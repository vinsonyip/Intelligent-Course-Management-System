import urllib
import numpy as np
import mysql.connector
import cv2
import pyttsx3
import pickle
from datetime import datetime
import datetime as dt
import sys
import PySimpleGUI as sg
import webbrowser



def find_days_of_week(dateTime): # For timetable window
    
    weekDate = []
    
    while True:
        if dateTime.weekday()>0:
            dateTime -= dt.timedelta(days=1)
        else:
            break

    for i in range(7):
        print(dateTime.strftime("%b %d"))
        weekDate.append(dateTime)
        dateTime+=dt.timedelta(days=1)
        

    print(weekDate)
    
    return weekDate # return an array that size = 7, consisting days of the week from Monday to Sunday



def do_facialReg():
        # 4 Open the camera and start face recognition
    ret, frame = cap.read()
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    faces = face_cascade.detectMultiScale(gray, scaleFactor=1.5, minNeighbors=5)

    for (x, y, w, h) in faces:
        print(x, w, y, h)
        roi_gray = gray[y:y + h, x:x + w]
        roi_color = frame[y:y + h, x:x + w]
        # predict the id and confidence for faces
        id_, conf = recognizer.predict(roi_gray) # id_ is the student ID 
        
        global student_uid
        student_uid = id_
        
        # If the face is recognized
        if conf >= gui_confidence:
            # print(id_)
            # print(labels[id_])
            font = cv2.QT_FONT_NORMAL
            id = 0
            id += 1
            name = labels[id_]
            current_name = name
            color = (255, 0, 0)
            stroke = 2
            cv2.putText(frame, name, (x, y), font, 1, color, stroke, cv2.LINE_AA)
            cv2.rectangle(frame, (x, y), (x + w, y + h), (255, 0, 0), (2))

            # Find the student information in the database.
            select = "SELECT student_id, name, DAY(login_date), MONTH(login_date), YEAR(login_date) FROM Student WHERE name='%s'" % (name)
            name = cursor.execute(select)
            
            result = cursor.fetchall() #[(student_id,name,DAY,MOUTH,YEAR)]
            print(result)
            data = "error"
            
            for x in result:
                data = x

            # If the student's information is not found in the database
            if data == "error":
                # the student's data is not in the database
                print("The student", current_name, "is NOT FOUND in the database.")

            # If the student's information is found in the database
            else:
                """
                Implement useful functions here.
                Check the course and classroom for the student.
                    If the student has class room within one hour, the corresponding course materials
                        will be presented in the GUI.
                    if the student does not have class at the moment, the GUI presents a personal class 
                        timetable for the student.

                """
                update =  "UPDATE Student SET login_date=%s WHERE name=%s"
                val = (date, current_name)
                cursor.execute(update, val)
                update = "UPDATE Student SET login_time=%s WHERE name=%s"
                val = (current_time, current_name)
                cursor.execute(update, val)
                myconn.commit()
               
                hello = ("Hello ", current_name, "You did attendance today")
                print(hello)
                global face_found
                face_found = True
                
                #engine.say(hello)
                    # If the face is unrecognized
        else: 
            color = (255, 0, 0)
            stroke = 2
            font = cv2.QT_FONT_NORMAL
            cv2.putText(frame, "UNKNOWN", (x, y), font, 1, color, stroke, cv2.LINE_AA)
            cv2.rectangle(frame, (x, y), (x + w, y + h), (255, 0, 0), (2))
            hello = ("Your face is not recognized")
            print(hello)
            #engine.say(hello)
            #engine.runAndWait()
    global imgbytes
    imgbytes = cv2.imencode('.png', frame)[1].tobytes()
    
def make_loginWin():
    layout = [
        [sg.Text('WELCOME TO ',font=('Any',22))],
        [sg.Text('HKU INTELLIGENT COURSE MANAGEMENT SYSTEM.',font=('Any',12),justification='right')],
        [sg.Button('Login'),sg.Button('Exit',button_color=('white','red'))]]
    
    return sg.Window('ICMS Login Page',layout,finalize=True)

def make_faceRegSettingWin():
 
    layout =  [
        [sg.Text('Setting', size=(18,1), font=('Any',18),text_color='#1c86ee' ,justification='left')],
        [sg.Text('Confidence'), sg.Slider(range=(0,100),orientation='h', resolution=1,
                                          default_value=60, size=(15,15), key='confidence')],
        [sg.Button('OK'), sg.Button('Cancel')]]
    
    return sg.Window('Setting Page for Facial Recognition',layout,
                     default_element_size=(21,1),
                     text_justification='right',auto_size_text=False,finalize=True)
              

def make_faceRegWin():
    layout = [
        [sg.Text('Attendance System Interface', size=(30,1))],
        [sg.Image(data=imgbytes, key='_IMAGE_')],
        [sg.Text('Confidence'),
         sg.Slider(range=(0, 100), orientation='h', resolution=1, default_value=60, size=(15, 15),
                         key='confidence')],        
        [sg.Button('Exit',button_color=('white','red'))]
        ]
    return sg.Window('Attendance System',layout,default_element_size=(14, 1),text_justification='right',
                     auto_size_text=False,finalize=True)

def make_timeTableWin():
    
    def make_table(num_rows, num_cols):
        data = [[j for j in range(num_cols)] for i in range(num_rows)]
        data[0][0] = 'Time'
        data[0][1] = 'Monday'
        data[0][2] = 'Tuesday'
        data[0][3] = 'Wednesday'
        data[0][4] = 'Thursday'
        data[0][5] = 'Friday'
        data[0][6] = 'Saturday'
        data[0][7] = 'Sunday'
        
        for i in range(1, num_rows):
            data[i] = ['', *['' for i in range(num_cols - 1)]]

        init_time = 8
        for i in range(1,num_rows):
            if i%2 == 0:
                data[i][0] = str(init_time)+':00  '
            else:
                data[i][0] = str(init_time)+':30  '
                init_time+=1
        
        return data

    # ------ Make the Table Data ------
    num_rows=21
    num_cols=8

    data = make_table(num_rows=21, num_cols=8)

    # ------ Date of days within this week ------
    today = dt.date.today()

    weekDate = []
    weekDate = find_days_of_week(today)

    headings = [str(data[0][x]) for x in range(len(data[0]))]

    # ------ Initialize table content ------
    for i in range(1,len(data[0])):
        headings[i] = '  '+ str(data[0][i])+'  '
    global update_table
    update_table = [[j for j in range(num_cols)] for i in range(num_rows-1)]
    for i in  range(0,num_rows-1):
        for j in range(num_cols):
            update_table[i][j] = data[i+1][j]
            
    mon = str(weekDate[0].strftime("%b %d"))
    tue = str(weekDate[1].strftime("%b %d"))
    wed = str(weekDate[2].strftime("%b %d"))
    thu = str(weekDate[3].strftime("%b %d"))
    fri = str(weekDate[4].strftime("%b %d"))
    sat = str(weekDate[5].strftime("%b %d"))
    sun = str(weekDate[6].strftime("%b %d"))
    layout = [[sg.Button('Return to main page')],
          [sg.Text('Date:',size=(9,1),justification='center'),
           sg.Text(mon,size=(8,1),justification='right',key='-MON-'),
           sg.Text(tue,size=(10,1),justification='right',key='-TUE-'),
           sg.Text(wed,size=(9,1),justification='right',key='-WED-'),
           sg.Text(thu,size=(10,1),justification='right',key='-THU-'),
           sg.Text(fri,size=(10,1),justification='right',key='-FRI-'),
           sg.Text(sat,size=(9,1),justification='right',key='-SAT-'),
           sg.Text(sun,size=(9,1),justification='right',key='-SUN-'),],
          [sg.Table(values=data[1:][:],
                    headings=headings,
                    max_col_width=15,
                    # background_color='light blue',
                    auto_size_columns=False,
                    # display_row_numbers=True,
                    justification='center',
                    num_rows=20,
                    alternating_row_color='lightyellow',
                    key='-TABLE-',
                    row_height=25,
                    tooltip='This is class timetable')],
                [sg.Text('* You can select a week schedule by calendar')],
                [sg.CalendarButton('Calendar', close_when_date_chosen=True,  target='-IN-', location=(500,200), no_titlebar=False),sg.Input(key='-IN-', size=(20,1),disabled=True),sg.Button('SELECT',disabled=True)],
          
            ]
    return sg.Window('Timetable', layout,finalize=True)

def make_personalPageWin():
    layout = [
        [sg.Text(size=(1,1))],
        [sg.Text('Hello, Vinson',key='-WelcomeMsg-',size=(30,1),font=('Any',20))],
        [sg.Text('Last Login: 2021/4/17 0:08',size=(50,1),text_color='orange',key='-LateLogin-')],
        [sg.Text('')],
        [sg.Text('Your course(s) within an hour: ',text_color='yellow'),sg.Text('No courses available!',size=(55,1),key='-CourseInHour-'),sg.Button('Refresh')],
        [sg.Text('')],
        [sg.Button('Fold/Unfold Course Frame'), sg.Button('Fold/Unfold Tutorial Frame')],
        [sg.Frame(layout=[
            [sg.Text(size=(1,1))],
            [sg.Text('Course(s): ',size=(15,1),text_color='yellow'),sg.Combo([], size=(20, 20), key='-COURSE-',enable_events=True)],
            [sg.Text('Classroom:',size=(15,1),text_color='yellow'),sg.Text('',size=(20,1),key='-ClassroomAddr-'),
             sg.Text('Start:',text_color='yellow',size=(15,1),justification='right'),
             sg.Text('',key='-ClassTime-',size=(15,1),justification='right')],
            [sg.Text('Zoom links:',size=(15,1),text_color='yellow'),sg.Listbox([],size=(75,3),key='-ZoomLinks-',enable_events=True)],
            [sg.Text('Messages:',size=(15,1),text_color='yellow'),sg.Multiline('',size=(75,3),key='-LectureMsg-',disabled=True)],
            [sg.Text('Course materials:',size=(15,1),text_color='yellow'),sg.Listbox([],size=(60,3),key='-LectureNotes-')],
            [sg.Text(size=(1,1))],
            [sg.Button('View my Timetable')],
            [sg.Text(size=(1,1))]
            ], title='Course(s) Info', relief=sg.RELIEF_SUNKEN, tooltip='Course(s) information shown here!',visible=True,key='-CourseFrame-'),
         sg.Frame(layout=[
            [sg.Text(size=(2,1))],
            [sg.Text('Tutorial(s): ',size=(15,1),text_color='yellow'),sg.Combo(sg.theme_list(), size=(25, 20), key='-TUTORIAL-',enable_events=True)],
            [sg.Text('Classroom:',size=(15,1),text_color='yellow'),sg.Text('',size=(20,1),key='-TutorialClassroomAddr-'),
             sg.Text('Start:',text_color='yellow',size=(15,1),justification='right'),sg.Text('',key='-TutorialClassTime-',size=(15,1),justification='right')],
            [sg.Text('Zoom links:',size=(15,1),text_color='yellow'),sg.Listbox([],size=(75,3),key='-TutorialList-',enable_events=True)],
            [sg.Text('Messages:',size=(15,1),text_color='yellow'),sg.Multiline('',size=(75,3),key='-TutorialMsg-',disabled=True)],
            [sg.Text('Tutorial materials:',size=(15,1),text_color='yellow'),sg.Listbox([],size=(60,3),key='-TutorialNotes-')],
            [sg.Text(size=(1,1))],
            #[sg.Button('View my Tutorial Timetable')],
            [sg.Text(size=(1,1))],
            ], title='Tutorial(s) Info', relief=sg.RELIEF_SUNKEN, tooltip='Tutorial(s) information shown here!',visible=False,key='-TutorialFrame-')
         ],


        [sg.Button('Clear'),sg.Button('Logout',button_color=('white','red')),sg.Text(size=(44,1)),sg.Button('Send Details to my University Email')],
        ]
    return sg.Window('ICMS Personal Page',layout,finalize=True)

# DB query
def do_DBquery(command):
    
    select = command
    cursor.execute(select)

    result = cursor.fetchall() #[(_,_,_)]
    
    data = "error"

    for x in result:
        data = x

    ## If the student's information is not found in the database
    if data == "error":
        return 'error'
    

    return result

def parseDate(date): # format of Date in DB :MON 14:30 - 16:20
    
    parsed = []

    weekday = date.split()[0] #Format:MON 14:30 - 17:20
                    
    timeslot_h_s = int((date.split()[1]).split(':')[0]) # starting time hour unit
    timeslot_m_s = int((date.split()[1]).split(':')[1]) # starting time minute unit

    timeslot_h_e = int((date.split()[3]).split(':')[0]) # ending time hour unit
    timeslot_m_e = int((date.split()[3]).split(':')[1]) # starting time minute unit

    
    if weekday == 'MON': 
        weekdayNum = 0
        
          
    if weekday == 'TUE':
        weekdayNum = 1
        
    if weekday == 'WED':
        weekdayNum = 2
               
        
    if weekday == 'THU':
        weekdayNum = 3
        
    if weekday == 'FRI':
        weekdayNum = 4
                               
        
    if weekday == 'SAT':
        weekdayNum = 5
                           
        
    if weekday == 'SUN':
        weekdayNum = 6

    parsed.append(weekdayNum)
    parsed.append(timeslot_h_s)
    parsed.append(timeslot_m_s)
    parsed.append(timeslot_h_e)
    parsed.append(timeslot_m_e)
    
    return parsed#[3,10,30,12,20] for THU 10:30 - 12:20


def main():
    sg.theme('TealMono')
    global student_uid
    global face_found
    global gui_confidence
    global image_elem

    global courseList_Hour
    courseList_Hour = []
    global courseList
    courseList = []

    global tutorialList_Hour
    tutorialList_Hour = []
    global tutorialList
    tutorialList = []

    global coursesWithScheduleList
    coursesWithScheduleList = []
    global tutorialsWithScheduleList
    tutorialsWithScheduleList = []


    face_found = False
    # 1 Create database connection
    global myconn
    myconn = mysql.connector.connect(host="localhost", user="root", passwd="CFdIBIgT6*9.", database="facerecognition")
    global date
    date = datetime.utcnow()
    global now
    now = datetime.now()
    global current_time
    current_time = now.strftime("%H:%M:%S")
    global cursor
    cursor = myconn.cursor()

    #2 Load recognize and read label from model
    global recognizer
    recognizer = cv2.face.LBPHFaceRecognizer_create()
    recognizer.read("train.yml")
    global labels
    labels = {"person_name": 1}
    with open("labels.pickle", "rb") as f:
        labels = pickle.load(f)
        labels = {v: k for k, v in labels.items()}

    # create text to speech
    '''
    global engine
    engine = pyttsx3.init()
    global rate
    rate = engine.getProperty("rate")
    engine.setProperty("rate", 175)
    '''


    # Define camera and detect face
    global face_cascade
    face_cascade = cv2.CascadeClassifier('haarcascade/haarcascade_frontalface_default.xml')
    global cap
    cap = cv2.VideoCapture(0)

    # Define all windows
    loginWin = make_loginWin()
    faceRegSettingWin = None
    faceRegWin = None
    personalPageWin = None
    timeTableWin = None

    eventListenerEnabled = True;
    # Variable for personal page
    LectureFrameVisible = True;
    TutorialFrameVisible = False;
    
    # Event loop
    while True:
        #print('looping')
        if eventListenerEnabled:
            window,event,values = sg.read_all_windows()
                
        print(event)
        # Dealing with First Welcome Page
        if window == loginWin:
            if event in (sg.WINDOW_CLOSED,'Exit'):
                loginWin.close()
                break
                
            if event == 'Login' and not faceRegSettingWin:
                loginWin.hide()
                faceRegSettingWin = make_faceRegSettingWin()

        # Dealing with facial regconition setting page 
        if window == faceRegSettingWin:
            args = values
            gui_confidence = args["confidence"]
            do_facialReg()
            if event in (sg.WIN_CLOSED, 'Cancel'):
                faceRegSettingWin.close()
                faceRegSettingWin = None
                loginWin.un_hide()

            if event == 'OK':
                faceRegSettingWin.close()
                loginWin.close()
                faceRegSettingWin = None
                loginWin = None
                faceRegWin = make_faceRegWin()
                faceRegWin['_IMAGE_'].update(data=imgbytes)
                #print('Come here')
                eventListenerEnabled = False; # Disable the listener, or the listen will wait for a key to activate
                window = faceRegWin
                

        if window == faceRegWin:
            #print('Come here2')
            while True:
                #print('Come here3')
                #print(face_found)
                do_facialReg()
                window['_IMAGE_'].update(data=imgbytes)
                event, value = faceRegWin.Read(timeout=20)
                gui_confidence = value['confidence']
                if event in (sg.WIN_CLOSED,'Exit'):
                    faceRegWin.close()
                    faceRegWin = None
                    break
                if face_found == True:
                    eventListenerEnabled = True
                    window['Exit'].update(disabled=True)
                    faceRegWin.close()
                    faceRegWin=None
                    personalPageWin = make_personalPageWin()
                    window = personalPageWin

                    # Search user name in DB
                    result = do_DBquery("SELECT name, login_date, login_time FROM Student WHERE student_id='%s'" % (student_uid))
                    if result != 'error':
                        #print(str(result[0][2]))
                        personalPageWin['-WelcomeMsg-'].update('Hello, '+result[0][0])
                        personalPageWin['-LateLogin-'].update('Last Login: '+ str(result[0][1])+ ' ' + str(result[0][2]))

                    # Search course codes in DB
                    courses = do_DBquery("SELECT c.course_id FROM Takes t,Course c WHERE t.student_id='%s' AND t.course_id = c.course_id;" % (student_uid))

                    for i in range(len(courses)):
                        courseList.append(courses[i][0])
                        
                    personalPageWin['-COURSE-'].update(values = list(courseList))
                    #print(courseList)
                    
                    # Search tutorials in DB
                    tutorials = do_DBquery("SELECT c.course_id,t.tutorial_no FROM  Takes ta,Course c,Tutorial t WHERE ta.student_id = '%s' AND ta.course_id = c.course_id AND c.course_id = t.course_id"
                                         % (student_uid))
                    for i in range(len(tutorials)):
                        tutorialList.append(str(tutorials[i][0])+' - Tutorial '+str(tutorials[i][1]))
                    
                    personalPageWin['-TUTORIAL-'].update(values = list(tutorialList))

                    # Refresh button needed to do the update current time operation
                    
                    # Search course codes and schedule in DB
                    coursesWithSchedule = do_DBquery("SELECT c.course_id,c.schedule FROM Takes t,Course c WHERE t.student_id='%s' AND t.course_id = c.course_id;" % (student_uid))
                    
                    for i in range(len(courses)):
                        coursesWithScheduleList.append(coursesWithSchedule[i])


                    # Search tutorial codes and schedule in DB
                    tutorialsWithSchedule = do_DBquery("SELECT c.course_id,t.tutorial_no,t.schedule FROM  Takes ta,Course c,Tutorial t WHERE ta.student_id = '%s' AND ta.course_id = c.course_id AND c.course_id = t.course_id"
                                         % (student_uid))
                    
                    for i in range(len(courses)):
                        tutorialsWithScheduleList.append(tutorialsWithSchedule[i])

                    # Find if any course or tutorial will be started within an hour
                    
                    today = datetime.today()

                    #print(today.weekday())
                    #print(int(today.strftime("%H %M %S").split()[1]))

                    #print("coursesWithScheduleList:",coursesWithScheduleList[0][1])
                    #print(parseDate(coursesWithScheduleList[i][1]))
                    
                    for i in range(len(coursesWithScheduleList)):

                        tmpList = []
                        tmpList = parseDate(coursesWithScheduleList[i][1])

                        current_hour = int(today.strftime("%H"))
                        current_minute = int(today.strftime("%M"))
                        
                        if tmpList[0] == today.weekday():
                            
                            if current_hour == tmpList[1]:
                                courseList_Hour.append(coursesWithScheduleList[i][0])
                                
                            elif current_hour+1 == tmpList[1] and current_minute == tmpList[2]:
                                courseList_Hour.append(coursesWithScheduleList[i][0])

                            elif current_hour+1 == tmpList[1] and current_minute > tmpList[2]:
                                courseList_Hour.append(coursesWithScheduleList[i][0])

                            elif current_hour > tmpList[1] and current_hour < tmpList[3]:
                                courseList_Hour.append(coursesWithScheduleList[i][0])

                            elif current_hour == tmpList[3] and current_minute < tmpList[4]:
                                courseList_Hour.append(coursesWithScheduleList[i][0])
                        
                    
                    # print("xx:",courseList_Hour)

                    #print("tutorialsWithScheduleList:",tutorialsWithScheduleList)
                    
                    for i in range(len(tutorialsWithScheduleList)):

                        tmpList = []
                        tmpList = parseDate(tutorialsWithScheduleList[i][2])

                        current_hour = int(today.strftime("%H"))
                        current_minute = int(today.strftime("%M"))
                        print(tmpList[0])
                        if tmpList[0] == today.weekday():
                            
                            if current_hour == tmpList[1]:
                                tutorialList_Hour.append(str(tutorialsWithScheduleList[i][0])+' - Tutorial '+str(tutorialsWithScheduleList[i][1]))
                                
                            elif current_hour+1 == tmpList[1] and current_minute == tmpList[2]:
                                tutorialList_Hour.append(str(tutorialsWithScheduleList[i][0])+' - Tutorial '+str(tutorialsWithScheduleList[i][1]))

                            elif current_hour+1 == tmpList[1] and current_minute > tmpList[2]:
                                tutorialList_Hour.append(str(tutorialsWithScheduleList[i][0])+' - Tutorial '+str(tutorialsWithScheduleList[i][1]))

                            elif current_hour > tmpList[1] and current_hour < tmpList[3]:
                                tutorialList_Hour.append(str(tutorialsWithScheduleList[i][0])+' - Tutorial '+str(tutorialsWithScheduleList[i][1]))

                            elif current_hour == tmpList[3] and current_minute < tmpList[4]:
                                tutorialList_Hour.append(str(tutorialsWithScheduleList[i][0])+' - Tutorial '+str(tutorialsWithScheduleList[i][1]))
                            
                    #print('courseList_Hour: ',courseList_Hour)
                    #print('tutorialList_Hour: ',tutorialList_Hour)
                    
                    # Update the UI element for courses available within an hour
                    if len(courseList_Hour) == 0 and len(tutorialList_Hour) == 0:
                        personalPageWin['-CourseInHour-'].update('No course or tutorial available !')
                    else:
                        if len(courseList_Hour) !=0 and len(tutorialList_Hour) == 0:
                            tmpStr = '| '
                            for i in courseList_Hour:
                                tmpStr += (i+ " | ")
                            personalPageWin['-CourseInHour-'].update(tmpStr)
                            
                        if len(courseList_Hour) ==0 and len(tutorialList_Hour) != 0:
                            tmpStr = '| '
                            for i in tutorialList_Hour:
                                tmpStr += (i+ " | ")
                            personalPageWin['-CourseInHour-'].update(tmpStr)

                        if len(courseList_Hour) !=0 and len(tutorialList_Hour) != 0:
                            tmpStr = '| '
                            for i in courseList_Hour:
                                tmpStr += (i+ " | ")
                                
                            for i in tutorialList_Hour:
                                tmpStr += (i+ " | ")
                                
                            personalPageWin['-CourseInHour-'].update(tmpStr)

                    
                    break
            if face_found == True:
                cap.release()
                continue
            cap.release()
            break

        if window == personalPageWin:
            # print('PersonalPageWin')
            if event == '-COURSE-':
                # print('The current value: '+ values['-COURSE-'])
                
                # Find lecture msg, zoom links and start time
                result = do_DBquery("SELECT c.zoom_link,c.message_from_teacher,c.schedule FROM Course c WHERE c.course_id = '%s'" % (str(values['-COURSE-'])))
                window['-LectureMsg-'].update(result[0][1])
                window['-ZoomLinks-'].update([result[0][0]])
                window['-ClassTime-'].update(result[0][2])

                # Find lecture materials
                result = do_DBquery("SELECT l.filename FROM Lecture_note l WHERE l.course_id = '%s'" % (str(values['-COURSE-'])))
                lectureNotes = []
                for i in range(len(result)):
                    lectureNotes.append(result[i][0])
                window['-LectureNotes-'].update(lectureNotes)

                # Find lecture room  
                result = do_DBquery("SELECT cl.name FROM Course c, Classroom cl WHERE c.course_id = '%s' AND c.room_id = cl.room_id" % (str(values['-COURSE-'])))
                room_name = result[0][0]
                window['-ClassroomAddr-'].update(room_name)

            if event == '-ZoomLinks-':
                webbrowser.open("%s"%(values['-ZoomLinks-'][0]))

            if event == '-TutorialList-':
                webbrowser.open("%s"%(values['-TutorialList-'][0]))
                
            if event == '-TUTORIAL-':
                #print('The current value: '+ values['-TUTORIAL-'])
                
                course_id = values['-TUTORIAL-'].split()[0]
                #print('course_id : '+ course_id)
                tutorial_number = values['-TUTORIAL-'].split()[3]
                
                
                # Find tutorial msg, zoom links and start time
                result = do_DBquery("SELECT c.zoom_link,c.message_from_teacher,c.schedule FROM Course c WHERE c.course_id = '%s'" % (course_id))
                # print(result)
                window['-TutorialMsg-'].update(result[0][1])
                
                #Find zoom links and start time
                tutorials = do_DBquery("SELECT t.zoom_link,t.schedule FROM Tutorial t WHERE t.course_id = '%s' AND t.tutorial_no = '%s'" % (course_id,tutorial_number))
                
                window['-TutorialList-'].update([tutorials[0][0]])
                window['-TutorialClassTime-'].update(tutorials[0][1])

                # Find tutorial materials
                result = do_DBquery("SELECT t.filename FROM Tutorial_note t WHERE t.course_id = '%s' AND t.tutorial_no = '%s'" % (course_id,tutorial_number))
                if result == 'error':
                    window['-TutorialNotes-'].update(['No file available now !'])
                else:
                    tutorialNotes = []
                    for i in range(len(result)):
                        tutorialNotes.append(result[i][0])

                    # print(tutorialNotes)
                    
                    window['-TutorialNotes-'].update(tutorialNotes)
                    
                
                
                
                # Find tutorial room  
                result = do_DBquery("SELECT cr.name FROM Classroom cr,Tutorial t WHERE t.course_id = '%s' AND t.tutorial_no = '%s' AND t.room_id = cr.room_id;" % (course_id,tutorial_number))
                room_name = result[0][0]
                window['-TutorialClassroomAddr-'].update(room_name)

                # Find tutorial start time  
                
                

                
            if event == 'Clear':
                window['-COURSE-'].update("",values = list(courseList))
                window['-ClassroomAddr-'].update('')
                window['-ClassTime-'].update('')
                window['-ZoomLinks-'].update('')
                window['-LectureMsg-'].update('')
                window['-LectureNotes-'].update('')

                window['-TUTORIAL-'].update('')
                window['-TutorialClassroomAddr-'].update('')
                window['-TutorialClassTime-'].update('')
                window['-TutorialList-'].update('')
                window['-TutorialMsg-'].update('')
                window['-TutorialNotes-'].update('')

                
            if event == 'Refresh':

                    # Find if any course or tutorial will be started within this hour
                    
                    today = datetime.today()

                    #print(today.weekday())
                    #print(int(today.strftime("%H %M %S").split()[1]))

                    #print("coursesWithScheduleList:",coursesWithScheduleList[0][1])
                    #print(parseDate(coursesWithScheduleList[i][1]))
                    tutorialList_Hour = []
                    courseList_Hour = []
                    for i in range(len(coursesWithScheduleList)):

                        tmpList = []
                        tmpList = parseDate(coursesWithScheduleList[i][1])

                        current_hour = int(today.strftime("%H"))
                        current_minute = int(today.strftime("%M"))
                        
                        if tmpList[0] == today.weekday():
                            
                            if current_hour == tmpList[1]:
                                courseList_Hour.append(coursesWithScheduleList[i][0])
                                
                            elif current_hour+1 == tmpList[1] and current_minute == tmpList[2]:
                                courseList_Hour.append(coursesWithScheduleList[i][0])

                            elif current_hour+1 == tmpList[1] and current_minute > tmpList[2]:
                                courseList_Hour.append(coursesWithScheduleList[i][0])

                            elif current_hour > tmpList[1] and current_hour < tmpList[3]:
                                courseList_Hour.append(coursesWithScheduleList[i][0])

                            elif current_hour == tmpList[3] and current_minute < tmpList[4]:
                                courseList_Hour.append(coursesWithScheduleList[i][0])
                        
                    
                    # print("xx:",courseList_Hour)

                    #print("tutorialsWithScheduleList:",tutorialsWithScheduleList)
                    
                    for i in range(len(tutorialsWithScheduleList)):

                        tmpList = []
                        tmpList = parseDate(tutorialsWithScheduleList[i][2])

                        current_hour = int(today.strftime("%H"))
                        current_minute = int(today.strftime("%M"))

                        
                        
                        if tmpList[0] == today.weekday():
                            
                            if current_hour == tmpList[1]:
                                tutorialList_Hour.append(str(tutorialsWithScheduleList[i][0])+' - Tutorial '+str(tutorialsWithScheduleList[i][1]))
                                
                            elif current_hour+1 == tmpList[1] and current_minute == tmpList[2]:
                                tutorialList_Hour.append(str(tutorialsWithScheduleList[i][0])+' - Tutorial '+str(tutorialsWithScheduleList[i][1]))

                            elif current_hour+1 == tmpList[1] and current_minute > tmpList[2]:
                                tutorialList_Hour.append(str(tutorialsWithScheduleList[i][0])+' - Tutorial '+str(tutorialsWithScheduleList[i][1]))

                            elif current_hour > tmpList[1] and current_hour < tmpList[3]:
                                tutorialList_Hour.append(str(tutorialsWithScheduleList[i][0])+' - Tutorial '+str(tutorialsWithScheduleList[i][1]))

                            elif current_hour == tmpList[3] and current_minute < tmpList[4]:
                                tutorialList_Hour.append(str(tutorialsWithScheduleList[i][0])+' - Tutorial '+str(tutorialsWithScheduleList[i][1]))
                            
                    #print('courseList_Hour: ',courseList_Hour)
                    #print('tutorialList_Hour: ',tutorialList_Hour)
                    tmpStr = ''
                    # Update the UI element for courses available within an hour
                    if len(courseList_Hour) == 0 and len(tutorialList_Hour) == 0:
                        personalPageWin['-CourseInHour-'].update('No courses or tutorial available !')
                    else:
                        if len(courseList_Hour) !=0 and len(tutorialList_Hour) == 0:
                            tmpStr = '| '
                            for i in courseList_Hour:
                                tmpStr += (i+ " | ")
                            personalPageWin['-CourseInHour-'].update(tmpStr)
                            
                        if len(courseList_Hour) ==0 and len(tutorialList_Hour) != 0:
                            tmpStr = '| '
                            for i in tutorialList_Hour:
                                tmpStr += (i+ " | ")
                            personalPageWin['-CourseInHour-'].update(tmpStr)

                        if len(courseList_Hour) !=0 and len(tutorialList_Hour) != 0:
                            tmpStr = '| '
                            for i in courseList_Hour:
                                tmpStr += (i+ " | ")
                                
                            for i in tutorialList_Hour:
                                tmpStr += (i+ " | ")
                            personalPageWin['-CourseInHour-'].update('')    
                            personalPageWin['-CourseInHour-'].update(tmpStr)
                
            if event == 'Fold/Unfold Course Frame':
                LectureFrameVisible = not LectureFrameVisible
                window['-CourseFrame-'].update(visible=LectureFrameVisible)
                
            if event == 'Fold/Unfold Tutorial Frame':
                TutorialFrameVisible = not TutorialFrameVisible
                window['-TutorialFrame-'].update(visible=TutorialFrameVisible)
                
            if event in (sg.WIN_CLOSED,'Logout'):
                window.close()
                break
            
            if event == 'View my Timetable':
                personalPageWin.hide()
                timeTableWin = make_timeTableWin()
                # Find courses list
                courses = do_DBquery("SELECT c.course_id,c.schedule FROM Takes t,Course c WHERE t.student_id='%s' AND t.course_id = c.course_id;" % (student_uid))

                coursesSchedule = [] # [[course name, x axis, y axis(start time),# of timeslot occupied],...]
               
                
                for i in range(len(courses)):
                    weekday = courses[i][1].split()[0] #Format:MON 14:30 - 17:20
                    
                    timeslot_h_s = (courses[i][1].split()[1]).split(':')[0] # starting time hour unit
                    timeslot_h_e = (courses[i][1].split()[3]).split(':')[0] # ending time hour unit

                    timeslot_m_s = (courses[i][1].split()[1]).split(':')[1] # starting time minute unit

                    numOfTimeslot = (int(timeslot_h_e)-int(timeslot_h_s))*2 # # of timeslot occupied, x2 because 30 minutes is the scale

                    
                    yAxis = (int(timeslot_h_s) - 8)*2  # start with which y coordinate
                    if timeslot_m_s == '00':
                        yAxis -= 1
                    
                    '''
                    print('hour: '+ timeslot_h_s + ' hour_e: '+timeslot_h_e)
                    print('minute: '+ timeslot_m_s)
                    print('# of timeslot: '+ str(numOfTimeslot))
                    print('yAxis :'+str(yAxis))
                    '''
                    
                    weekdayNum = -1
                    
                    item = []
                    
                    if weekday == 'MON': 
                        weekdayNum = 0
                        
                          
                    if weekday == 'TUE':
                        weekdayNum = 1
                        
                    if weekday == 'WED':
                        weekdayNum = 2
                               
                        
                    if weekday == 'THU':
                        weekdayNum = 3
                        
                    if weekday == 'FRI':
                        weekdayNum = 4
                                               
                        
                    if weekday == 'SAT':
                        weekdayNum = 5
                                           
                        
                    if weekday == 'SUN':
                        weekdayNum = 6
                        
                    item.append(courses[i][0])
                    item.append(weekdayNum+1) #+1 because the first column is not used
                    item.append(yAxis)
                    item.append(numOfTimeslot)
                        
                    print(item)
                    coursesSchedule.append(item)

                for i in range(len(coursesSchedule)):
                    xAxis = coursesSchedule[i][1]
                    yAxis_start = coursesSchedule[i][2]
                    yAxis_end = coursesSchedule[i][2]+coursesSchedule[i][3]+1

                    #print('yAxis_start:'+ str(yAxis_start))
                    #print('yAxis_end:'+ str(yAxis_end))
                    #print('update_table:'+ update_table[xAxis][18])
    
                    
                    for j in range(yAxis_start,yAxis_end):
                        update_table[j][xAxis] = coursesSchedule[i][0]
                    
                timeTableWin['-TABLE-'].update(values=update_table) # display class timeslot

                '''
                print(update_table)
                print('update_table length:'+str(len(update_table)))
                '''

                
                
                
                
            if event == 'Send Details to my University Email':
                sg.popup('Class info sended successfully!')



                

        if window == timeTableWin:
            #print(event)
            
            if event in ('Return to main page',sg.WIN_CLOSED):
                timeTableWin.close()
                timeTableWin = None
                personalPageWin.un_hide()
                
            if event == 'SELECT':
                
                date_str = values['-IN-'][0:10]
                date_object = dt.datetime.strptime(date_str, '%Y-%m-%d').date()
                weekDate = find_days_of_week(date_object)
                #print(type(weekDate[0].strftime("%b %d")))
                window['-MON-'].update(weekDate[0].strftime("%b %d"))
                window['-TUE-'].update(weekDate[1].strftime("%b %d"))
                window['-WED-'].update(weekDate[2].strftime("%b %d"))
                window['-THU-'].update(weekDate[3].strftime("%b %d"))
                window['-FRI-'].update(weekDate[4].strftime("%b %d"))
                window['-SAT-'].update(weekDate[5].strftime("%b %d"))
                window['-SUN-'].update(weekDate[6].strftime("%b %d"))

                # May update something to timetable
                '''
                update_table[5][5] = 'COMP3278'
                window['-TABLE-'].update(values=update_table) # display class timeslot
                '''
                
            if event == 'Calendar':
               tmpdate = sg.popup_get_date(close_when_chosen=True)
               tmpdate = str(tmpdate[2])+'-'+str(tmpdate[0])+'-'+str(tmpdate[1])
               window['-IN-'].update(tmpdate)
               window['SELECT'].update(disabled=False)

        
if __name__ == '__main__':
    main()
