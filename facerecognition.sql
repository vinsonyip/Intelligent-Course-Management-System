-- phpMyAdmin SQL Dump
-- version 4.6.6deb5
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Feb 17, 2020 at 09:41 PM
-- Server version: 5.7.28-0ubuntu0.18.04.4
-- PHP Version: 7.2.24-0ubuntu0.18.04.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `facerecognition`
--

-- --------------------------------------------------------

--
-- Table structure for table `Student`
--
DROP TABLE IF EXISTS `Student`;


Create TABLE `Faculty` (
  `faculty_id` int UNSIGNED NOT NULL,
  `phone` int UNSIGNED NOT NULL,
  `main_office` text NOT NULL,
  `name` varchar(45) NOT NULL,
  `email` varchar(255) NOT NULL,
  PRIMARY KEY(`faculty_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


Create TABLE `Department` (
  `dpt_id` int UNSIGNED NOT NULL,
  `name` varchar(45) NOT NULL,
  `main_office` text NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` int UNSIGNED NOT NULL,
  `faculty_id` int UNSIGNED NOT NULL,
  PRIMARY KEY(`dpt_id`),
  FOREIGN KEY(`faculty_id`) REFERENCES `Faculty`(`faculty_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `Student` (
  `student_id` int UNSIGNED NOT NULL,
  `name` varchar(50) NOT NULL,
  `login_time` time NOT NULL,
  `login_date` date NOT NULL,
  `email` varchar(255) NOT NULL,
  `faculty_id` int UNSIGNED NOT NULL,
  PRIMARY KEY(`student_id`),
  FOREIGN KEY(`faculty_id`) REFERENCES `Faculty`(`faculty_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


Create TABLE `Classroom` (
  `room_id` int UNSIGNED NOT NULL,
  `name` varchar(45) NOT NULL,
  `size` varchar(45) NOT NULL,
  `seats` int UNSIGNED NOT NULL,
  PRIMARY KEY(`room_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


Create TABLE `Teacher` (
  `teacher_id` int UNSIGNED NOT NULL,
  `dpt_id` int UNSIGNED NOT NULL,
  `name` varchar(30) NOT NULL,
  `office` text NOT NULL,
  `email` varchar(255) NOT NULL,
  PRIMARY KEY(`teacher_id`),
  FOREIGN KEY(`dpt_id`) REFERENCES `Department`(`dpt_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


Create TABLE `Course` (
  `course_id` varchar(30) NOT NULL,
  `dpt_id` int UNSIGNED NOT NULL,
  `teacher_id` int UNSIGNED NOT NULL,
  `room_id` int UNSIGNED NOT NULL,
  `name` varchar(45) NOT NULL,
  `course_info` text NOT NULL,
  `subclass` varchar(30) NOT NULL,
  `schedule` varchar(30) NOT NULL, /* Display the schedule in a time table*/
  `zoom_link` text NOT NULL,
  `message_from_teacher` text NOT NULL,
  `project` datetime NOT NULL,
  `mid_term` varchar(45) NOT NULL,
  `final_exam` varchar(45) NOT NULL,
  `consultation_hours` varchar(30) NOT NULL,
  PRIMARY KEY(`course_id`),
  FOREIGN KEY(`room_id`) REFERENCES `Classroom`(`room_id`),
  FOREIGN KEY(`dpt_id`) REFERENCES `Department`(`dpt_id`),
  FOREIGN KEY(`teacher_id`) REFERENCES `Teacher`(`teacher_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


Create TABLE `Lecture_date` (
  `course_id` varchar(30) NOT NULL,
  `lecture_date` date NOT NULL,
  FOREIGN KEY(`course_id`) REFERENCES `Course`(`course_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


Create TABLE `Lecture_note` (
  `course_id` varchar(30) NOT NULL,
  `filename` varchar(255) NOT NULL,
  FOREIGN KEY(`course_id`) REFERENCES `Course`(`course_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


Create TABLE `Assignment` (
  `course_id` varchar(30) NOT NULL,
  `number` int UNSIGNED NOT NULL,
  `due_date` date NOT NULL,
  FOREIGN KEY(`course_id`) REFERENCES `Course`(`course_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


/* Student takes courses */
Create TABLE `Takes` ( 
  `student_id` int UNSIGNED NOT NULL,
  `course_id` varchar(30) NOT NULL,
  FOREIGN KEY(`student_id`) REFERENCES `Student`(`student_id`),
  FOREIGN KEY(`course_id`) REFERENCES `Course`(`course_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


Create TABLE `Tutor` (
  `tutor_id` int UNSIGNED NOT NULL,
  `teacher_id` int UNSIGNED NOT NULL,
  `dpt_id` int UNSIGNED NOT NULL,
  `name` varchar(45) NOT NULL,
  `office` text NOT NULL,
  `email` varchar(255) NOT NULL,
  `consultation_hours` varchar(30) NOT NULL,
  PRIMARY KEY(`tutor_id`),
  FOREIGN KEY(`teacher_id`) REFERENCES `Teacher`(`teacher_id`),
  FOREIGN KEY(`dpt_id`) REFERENCES `Department`(`dpt_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


Create TABLE `Tutorial` (
  `course_id` varchar(30) NOT NULL,
  `tutorial_no` int UNSIGNED NOT NULL,
  `tutor_id` int UNSIGNED NOT NULL,
  `room_id` int UNSIGNED NOT NULL,
  `schedule` varchar(30) NOT NULL,
  `zoom_link` text NOT NULL,
  PRIMARY KEY(`course_id`, `tutorial_no`),
  FOREIGN KEY(`course_id`) REFERENCES `Course`(`course_id`),
  FOREIGN KEY(`tutor_id`) REFERENCES `Tutor`(`tutor_id`),
  FOREIGN KEY(`room_id`) REFERENCES `Classroom`(`room_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


/* Student registers tutorials */
Create TABLE `Registers` (
  `student_id` int UNSIGNED NOT NULL,
  `course_id` varchar(30) NOT NULL,
  `tutorial_no` int UNSIGNED NOT NULL,
  FOREIGN KEY(`student_id`) REFERENCES `Student`(`student_id`),
  FOREIGN KEY(`course_id`, `tutorial_no`) REFERENCES `Tutorial`(`course_id`, `tutorial_no`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


Create TABLE `Tutorial_date`(
  `course_id` varchar(30) NOT NULL,
  `tutorial_no` int UNSIGNED NOT NULL,
  `tutorial_date` date NOT NULL,
FOREIGN KEY(`course_id`, `tutorial_no`) REFERENCES `Tutorial`(`course_id`, `tutorial_no`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


Create TABLE `Tutorial_note` (
  `course_id` varchar(30) NOT NULL,
  `tutorial_no` int UNSIGNED NOT NULL,
  `filename` varchar(255) NOT NULL,
FOREIGN KEY(`course_id`, `tutorial_no`) REFERENCES `Tutorial`(`course_id`, `tutorial_no`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


Create TABLE `Club` (
  `club_id` int UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(30) NOT NULL,
  PRIMARY KEY(`club_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


Create TABLE `Activity` (
  `club_id` int UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `location` varchar(255) NOT NULL,
  FOREIGN KEY(`club_id`) REFERENCES `Club`(`club_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


Create TABLE `Enrolls_in` (
  `student_id` int UNSIGNED NOT NULL,
  `club_id` int UNSIGNED NOT NULL,
  `role` varchar(30) NOT NULL,
  FOREIGN KEY(`club_id`) REFERENCES `Club`(`club_id`),
  FOREIGN KEY(`student_id`) REFERENCES `Student`(`student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


INSERT INTO `Faculty` (`faculty_id`, `name`, `phone`, `main_office`, `email`) VALUES (1, "Faculty of Science", 41000000, "1/F, JSL Science Building", "sci_faculty@hku.hk");
INSERT INTO `Faculty` (`faculty_id`, `name`, `phone`, `main_office`, `email`) VALUES (2, "Faculty of Business & Economics", 41000001, "4/F, Main Building", "be_faculty@hku.hk");
INSERT INTO `Faculty` (`faculty_id`, `name`, `phone`, `main_office`, `email`) VALUES (3, "Faculty of Computer Science", 41000002, "4/F, CYC Building", "cs_faculty@hku.hk");


INSERT INTO `Department` (`dpt_id`, `faculty_id`, `name`, `phone`, `main_office`, `email`) VALUES (1,1,"Science", 31000000, "2/F, CYM Building", "science@hku.hk");
INSERT INTO `Department` (`dpt_id`, `faculty_id`, `name`, `phone`, `main_office`, `email`) VALUES (2,2,"Business", 31000001, "3/F, HW Building", "business@hku.hk");
INSERT INTO `Department` (`dpt_id`, `faculty_id`, `name`, `phone`, `main_office`, `email`) VALUES (3, 3, "Computer Science", 31000002, "3/F, JC Tower", "computerscience@hku.hk");


LOCK TABLES `Student` WRITE;
/*!40000 ALTER TABLE `Student` DISABLE KEYS */;
INSERT INTO `Student` (`student_id`, `name`, `faculty_id`, `login_time`, `login_date`, `email`) VALUES (1, "JACK", 2, NOW(), '2021-01-20', 'h3568695@connect.hku.hk');
INSERT INTO `Student` (`student_id`, `name`, `faculty_id`, `login_time`, `login_date`, `email`) VALUES (2, "EVAN", 1, NOW(), '2021-01-20', 'evan@hku.hk');
INSERT INTO `Student` (`student_id`, `name`, `faculty_id`, `login_time`, `login_date`, `email`) VALUES (3, "VINCE", 2, NOW(), '2021-01-20', 'vince@hku.hk');
INSERT INTO `Student` (`student_id`, `name`, `faculty_id`, `login_time`, `login_date`, `email`) VALUES (4, "TOM", 3, NOW(), '2021-01-20', 'tom@hku.hk');
INSERT INTO `Student` (`student_id`, `name`, `faculty_id`, `login_time`, `login_date`, `email`) VALUES (5, "DAVE", 3, NOW(), '2021-01-20', 'dave@hku.hk');
/*!40000 ALTER TABLE `Student` ENABLE KEYS */;
UNLOCK TABLES;


INSERT INTO `Classroom` (`room_id`, `name`, `size`, `seats`) VALUES (1, "Lecture hall A", "big", 150);
INSERT INTO `Classroom` (`room_id`, `name`, `size`, `seats`) VALUES (2, "Classroom 1A", "small", 75);
INSERT INTO `Classroom` (`room_id`, `name`, `size`, `seats`) VALUES (3, "Lecture hall B", "big", 120);
INSERT INTO `Classroom` (`room_id`, `name`, `size`, `seats`) VALUES (4, "Classroom 1B", "small", 50);
INSERT INTO `Classroom` (`room_id`, `name`, `size`, `seats`) VALUES (5, "Lecture hall C", "big", 200);
INSERT INTO `Classroom` (`room_id`, `name`, `size`, `seats`) VALUES (6, "Lecture hall D", "big", 150);


INSERT INTO `Teacher` (`teacher_id`, `dpt_id`, `name`, `office`, `email`) VALUES (1, 1, "EMILIA", "402, HOC Building", "emilia@hku.hk");
INSERT INTO `Teacher` (`teacher_id`, `dpt_id`, `name`, `office`, `email`) VALUES (2, 1, "JEFF", "403, HOC Building", "jeff@hku.hk");
INSERT INTO `Teacher` (`teacher_id`, `dpt_id`, `name`, `office`, `email`) VALUES (3, 1, "DAVID", "404, HOC buildling", "david@hku.hk");
INSERT INTO `Teacher` (`teacher_id`, `dpt_id`, `name`, `office`, `email`) VALUES (4, 2, "SIMON", "203, RRS buildling", "simon@hku.hk");
INSERT INTO `Teacher` (`teacher_id`, `dpt_id`, `name`, `office`, `email`) VALUES (5, 2, "ANNE", "204, RRS buildling", "anne@hku.hk");
INSERT INTO `Teacher` (`teacher_id`, `dpt_id`, `name`, `office`, `email`) VALUES (6, 2, "CALEB", "205, RRS buildling", "caleb@hku.hk");
INSERT INTO `Teacher` (`teacher_id`, `dpt_id`, `name`, `office`, `email`) VALUES (7, 2, "STELLA", "206, RRS buildling", "stella@hku.hk");
INSERT INTO `Teacher` (`teacher_id`, `dpt_id`, `name`, `office`, `email`) VALUES (8, 2, "RONALDO", "RONALDO", "ronaldo@hku.hk");
INSERT INTO `Teacher` (`teacher_id`, `dpt_id`, `name`, `office`, `email`) VALUES (9, 3, "SARAH", "510, HW Building", "sarah@hku.hk");
INSERT INTO `Teacher` (`teacher_id`, `dpt_id`, `name`, `office`, `email`) VALUES (10, 3, "DANIEL", "511, HW Building", "daniel@hku.hk");
INSERT INTO `Teacher` (`teacher_id`, `dpt_id`, `name`, `office`, `email`) VALUES (11, 3, "EVELYN", "512, HW Building", "evelyn@hku.hk");
INSERT INTO `Teacher` (`teacher_id`, `dpt_id`, `name`, `office`, `email`) VALUES (12, 3, "LILAC", "513, HW Building", "lilac@hku.hk");


INSERT INTO `Course` (`course_id`, `dpt_id`, `teacher_id`, `room_id`, `name`, `course_info`, `subclass`, `schedule`, `zoom_link`, `message_from_teacher`, `project`, `mid_term`, `final_exam`, `consultation_hours`)
VALUES ("PHYS1250", 1, 1, 5, "Fundamental physics", 
"This is the first physics course for those who want to minor in physics or astronomy as well as for those who want to have an overview in physics.  It covers the fundamental blocks in physics in one semester. Conceptual ideas in physics are emphasized and the mathematical treatment is moderate.  Those who enter HKU before 2018 may also take this course as one of their astronomy, math/physics or physics major requirements.",
"N/A", "MON 09:30 - 11:20", "https://hku.zoom.us/j/3624090239", "The third lecture slides are released on moodle. Remember to downlaod and preview it before our lecture!",
"N/A", "2021-03-15", "TBA", "by appointment");
INSERT INTO `Course` (`course_id`, `dpt_id`, `teacher_id`, `room_id`, `name`, `course_info`, `subclass`, `schedule`, `zoom_link`, `message_from_teacher`, `project`, `mid_term`, `final_exam`, `consultation_hours`)
VALUES ("CHEM1041", 1, 2, 5, "Foundations of chemistry",
"The course aims to provide students who do not have HKDSE Chemistry or an equivalent background but are interested in exploring Chemistry further, with an understanding of the essential fundamental principles and concepts of chemistry.",
"N/A", "THU 10:30 - 12:20", "https://hku.zoom.us/j/97052302151?pwd=MVlSbTlHVFpBZlc2NndFd0Flalh0dz09", "Please hand in hw2 by 18th!",
"N/A", "2021-03-25", "TBA", "by appointment");
INSERT INTO `Course` (`course_id`, `dpt_id`, `teacher_id`, `room_id`, `name`, `course_info`, `subclass`, `schedule`, `zoom_link`, `message_from_teacher`, `project`, `mid_term`, `final_exam`, `consultation_hours`)
VALUES ("BIOL1110", 1, 3, 5, "From molecules to cells",
"This course aims to provide basic conceptual understanding of the biology of molecules and cells to underpin later studies in applied biology, genetics, biochemistry, nutrition, biotechnology, microbiology, plant and animal physiology and developmental biology.",
"N/A", "FRI 09:30 - 11:20", "https://hku.zoom.us/j/97760349233?pwd=RDBLdnc5WjRQWlk4NlhEbXBUOUlzUT09", "Slides 03 is released. Students can now download it on moodle.",
"N/A", "2021-03-26", "TBA", "by appointment");
INSERT INTO `Course` (`course_id`, `dpt_id`, `teacher_id`, `room_id`, `name`, `course_info`, `subclass`, `schedule`, `zoom_link`, `message_from_teacher`, `project`, `mid_term`, `final_exam`, `consultation_hours`)
VALUES ("ECON1210_A", 2, 4, 1, "Introductory microeconomics",
"An introduction to the basic concepts and principles of microeconomics - the study of demand and supply, consumer theory, cost and production, market structure, incentives, and resource allocation efficiency, political economy, and ethics and public policy.",
"A", "TUE 14:30 - 17:20", "N/A", "HW2 due Apr 28!!",
"N/A", "2021-03-21", "TBA", "by appointment");
INSERT INTO `Course` (`course_id`, `dpt_id`, `teacher_id`, `room_id`, `name`, `course_info`, `subclass`, `schedule`, `zoom_link`, `message_from_teacher`, `project`, `mid_term`, `final_exam`, `consultation_hours`)
VALUES ("ECON1210_B", 2, 5, 1, "Introductory microeconomics",
"An introduction to the basic concepts and principles of microeconomics - the study of demand and supply, consumer theory, cost and production, market structure, incentives, and resource allocation efficiency, political economy, and ethics and public policy.",
"B", "FRI 14:30 - 17:20", "N/A", "HW2 due Apr 28!!",
"N/A", "2021-03-21", "TBA", "by appointment");
INSERT INTO `Course` (`course_id`, `dpt_id`, `teacher_id`, `room_id`, `name`, `course_info`, `subclass`, `schedule`, `zoom_link`, `message_from_teacher`, `project`, `mid_term`, `final_exam`, `consultation_hours`)
VALUES ("ECON1220_A", 2, 6, 3, "Introductory macroeconomics", 
"This course is an introduction to macroeconomics—the study of business cycle fluctuations and long-run economic growth. The course will first introduce students to the measurement of major macroeconomic variables and the main issues in macroeconomics. It will then introduce students to models that study the trend of the economy in the long run and the cyclical ups and downs of the economy in the short run. Empirical evidence and the effects of fiscal and monetary policies will be discussed along the way.",
"A", "FRI 14:30 - 17:20", "N/A", "Midterm results are released. Students can check your grades on the 'Grades' page.",
"N/A", "2021-03-28", "TBA" , "by appointment");
INSERT INTO `Course` (`course_id`, `dpt_id`, `teacher_id`, `room_id`, `name`, `course_info`, `subclass`, `schedule`, `zoom_link`, `message_from_teacher`, `project`, `mid_term`, `final_exam`, `consultation_hours`)
VALUES ("ECON1220_B", 2, 7, 3, "Introductory macroeconomics", "This course is an introduction to macroeconomics—the study of business cycle fluctuations and long-run economic growth. The course will first introduce students to the measurement of major macroeconomic variables and the main issues in macroeconomics. It will then introduce students to models that study the trend of the economy in the long run and the cyclical ups and downs of the economy in the short run. Empirical evidence and the effects of fiscal and monetary policies will be discussed along the way.",
"B", "TUE 14:30 - 17:20", "N/A", "Midterm results are released. Students can check your grades on the 'Grades' page.",
"N/A", "2021-03-28", "TBA",  "by appointment");
INSERT INTO `Course` (`course_id`, `dpt_id`, `teacher_id`, `room_id`, `name`, `course_info`, `subclass`, `schedule`, `zoom_link`, `message_from_teacher`, `project`, `mid_term`, `final_exam`, `consultation_hours`)
VALUES ("COMP1117_A", 3, 9, 2, "Computer programming",
"This is an introductory course in computer programming. Students will acquire basic Python programming skills, including syntax, identifiers, control statements, functions, recursions, strings, lists, dictionaries, tuples and files.  Searching and sorting algorithms, such as sequential search, binary search, bubble sort, insertion sort and selection sort, will also be covered.",
"A", "TUE 10:30 - 12:20", "https://hku.zoom.us/j/99080937322?pwd=MkUwUFlLdUt5UWpxZlVwaWFEbUxQZz09", "New lecture notes about searching is released. Please download it on moodle before next lecture.",
"N/A", "2021-03-16", "TBA", "by appointment");
INSERT INTO `Course` (`course_id`, `dpt_id`, `teacher_id`, `room_id`, `name`, `course_info`, `subclass`, `schedule`, `zoom_link`, `message_from_teacher`, `project`, `mid_term`, `final_exam`, `consultation_hours`)
VALUES ("COMP1117_B", 3, 10, 2, "Computer programming",
"This is an introductory course in computer programming. Students will acquire basic Python programming skills, including syntax, identifiers, control statements, functions, recursions, strings, lists, dictionaries, tuples and files.  Searching and sorting algorithms, such as sequential search, binary search, bubble sort, insertion sort and selection sort, will also be covered.",
"B", "THU 10:30 - 12:20", "https://hku.zoom.us/j/99751935184?pwd=LzA2UTdDQ2QxV1c0bnIranlscVJMUT09", "New lecture notes about searching is released. Please download it on moodle before next lecture.",
"N/A", "2021-03-18", "TBA", "by appointment");
INSERT INTO `Course` (`course_id`, `dpt_id`, `teacher_id`, `room_id`, `name`, `course_info`, `subclass`, `schedule`, `zoom_link`, `message_from_teacher`, `project`, `mid_term`, `final_exam`, `consultation_hours`)
VALUES ("COMP2113", 3, 11, 4, "Programming technologies",
"This course covers intermediate to advanced computer programming topics on various technologies and tools that are useful for software development. Topics include advanced Python programming, Linux shell commands, shell scripts, C programming, and separate compilation techniques. This is a self-learning course; there will be no lecture and students will be provided with self-study materials. Students are required to complete milestone-based self-assessment tasks during the course. This course is designed for students who are interested in Computer Science /Computer Engineering.",
"N/A", "THU 14:30 - 16:20", "N/A", "N/A",
"2021-04-30", "2021-03-18", "TBA", "ny appointment");


INSERT INTO `Lecture_note` (`course_id`, `filename`) VALUES ("PHYS1250", "PHYS1250_L1");
INSERT INTO `Lecture_note` (`course_id`, `filename`) VALUES ("PHYS1250", "PHYS1250_L2");
INSERT INTO `Lecture_note` (`course_id`, `filename`) VALUES ("PHYS1250", "PHYS1250_L3");
INSERT INTO `Lecture_note` (`course_id`, `filename`) VALUES ("CHEM1041", "CHEM1041_L1");
INSERT INTO `Lecture_note` (`course_id`, `filename`) VALUES ("CHEM1041", "CHEM1041_L2");
INSERT INTO `Lecture_note` (`course_id`, `filename`) VALUES ("CHEM1041", "CHEM1041_L3");
INSERT INTO `Lecture_note` (`course_id`, `filename`) VALUES ("BIOL1110", "Slides 01");
INSERT INTO `Lecture_note` (`course_id`, `filename`) VALUES ("BIOL1110", "Slides 02");
INSERT INTO `Lecture_note` (`course_id`, `filename`) VALUES ("BIOL1110", "Slides 03");
INSERT INTO `Lecture_note` (`course_id`, `filename`) VALUES ("ECON1210_A", "Demand and Supply");
INSERT INTO `Lecture_note` (`course_id`, `filename`) VALUES ("ECON1210_A", "Ethics");
INSERT INTO `Lecture_note` (`course_id`, `filename`) VALUES ("ECON1210_B", "Demand and Supply");
INSERT INTO `Lecture_note` (`course_id`, `filename`) VALUES ("ECON1210_B", "Ethics");
INSERT INTO `Lecture_note` (`course_id`, `filename`) VALUES ("ECON1220_A", "About macroeconomics");
INSERT INTO `Lecture_note` (`course_id`, `filename`) VALUES ("ECON1220_A", "Macroeconomics models");
INSERT INTO `Lecture_note` (`course_id`, `filename`) VALUES ("ECON1220_B", "About macroeconomics");
INSERT INTO `Lecture_note` (`course_id`, `filename`) VALUES ("ECON1220_B", "Macroeconomics models");
INSERT INTO `Lecture_note` (`course_id`, `filename`) VALUES ("COMP1117_A", "Introduction");
INSERT INTO `Lecture_note` (`course_id`, `filename`) VALUES ("COMP1117_A", "Python");
INSERT INTO `Lecture_note` (`course_id`, `filename`) VALUES ("COMP1117_A", "Searching");
INSERT INTO `Lecture_note` (`course_id`, `filename`) VALUES ("COMP1117_B", "Introduction");
INSERT INTO `Lecture_note` (`course_id`, `filename`) VALUES ("COMP1117_B", "Python");
INSERT INTO `Lecture_note` (`course_id`, `filename`) VALUES ("COMP1117_B", "Searching");
INSERT INTO `Lecture_note` (`course_id`, `filename`) VALUES ("COMP2113", "Intro to Linux");
INSERT INTO `Lecture_note` (`course_id`, `filename`) VALUES ("COMP2113", "C/C++");


INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("PHYS1250", "2021-01-18");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("PHYS1250", "2021-01-25");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("PHYS1250", "2021-02-01");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("PHYS1250", "2021-02-08");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("PHYS1250", "2021-02-22");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("PHYS1250", "2021-03-01");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("PHYS1250", "2021-03-15");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("PHYS1250", "2021-03-22");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("PHYS1250", "2021-03-29");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("PHYS1250", "2021-04-12");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("PHYS1250", "2021-04-19");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("PHYS1250", "2021-04-26");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("CHEM1041", "2021-01-21");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("CHEM1041", "2021-01-28");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("CHEM1041", "2021-02-04");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("CHEM1041", "2021-02-11");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("CHEM1041", "2021-02-25");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("CHEM1041", "2021-03-04");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("CHEM1041", "2021-03-18");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("CHEM1041", "2021-03-25");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("CHEM1041", "2021-04-01");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("CHEM1041", "2021-04-08");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("CHEM1041", "2021-04-15");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("CHEM1041", "2021-04-22");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("CHEM1041", "2021-04-29");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("BIOL1110", "2021-01-22");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("BIOL1110", "2021-01-29");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("BIOL1110", "2021-02-05");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("BIOL1110", "2021-02-19");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("BIOL1110", "2021-02-26");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("BIOL1110", "2021-03-05");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("BIOL1110", "2021-03-19");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("BIOL1110", "2021-03-26");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("BIOL1110", "2021-04-09");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("BIOL1110", "2021-04-16");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("BIOL1110", "2021-04-23");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("BIOL1110", "2021-04-30");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1210_A", "2021-01-19");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1210_A", "2021-01-26");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1210_A", "2021-02-02");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1210_A", "2021-02-09");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1210_A", "2021-02-23");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1210_A", "2021-03-02");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1210_A", "2021-03-23");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1210_A", "2021-03-30");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1210_A", "2021-04-13");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1210_A", "2021-04-20");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1210_A", "2021-04-27");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1210_B", "2021-01-22");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1210_B", "2021-01-29");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1210_B", "2021-02-05");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1210_B", "2021-02-26");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1210_B", "2021-03-05");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1210_B", "2021-03-26");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1210_B", "2021-04-09");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1210_B", "2021-04-16");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1210_B", "2021-04-23");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1210_B", "2021-04-30");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1220_A", "2021-01-22");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1220_A", "2021-01-29");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1220_A", "2021-02-05");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1220_A", "2021-02-19");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1220_A", "2021-01-22");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1220_A", "2021-02-26");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1220_A", "2021-03-05");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1220_A", "2021-03-19");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1220_A", "2021-03-26");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1220_A", "2021-04-09");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1220_A", "2021-04-16");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1220_A", "2021-04-23");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1220_A", "2021-04-30");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1220_B", "2021-01-19");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1220_A", "2021-01-26");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1220_A", "2021-02-02");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1220_A", "2021-02-09");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1220_A", "2021-02-23");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1220_A", "2021-03-02");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1220_A", "2021-03-02");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1220_A", "2021-03-23");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1220_A", "2021-03-30");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1220_A", "2021-04-13");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1220_A", "2021-04-20");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("ECON1220_A", "2021-04-27");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("COMP1117_A", "2021-01-19");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("COMP1117_A", "2021-01-26");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("COMP1117_A", "2021-02-02");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("COMP1117_A", "2021-02-09");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("COMP1117_A", "2021-02-23");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("COMP1117_A", "2021-03-02");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("COMP1117_A", "2021-03-23");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("COMP1117_A", "2021-03-30");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("COMP1117_A", "2021-04-13");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("COMP1117_A", "2021-04-20");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("COMP1117_A", "2021-04-27");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("COMP1117_B", "2021-01-21");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("COMP1117_B", "2021-01-28");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("COMP1117_B", "2021-02-04");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("COMP1117_B", "2021-02-11");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("COMP1117_B", "2021-02-25");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("COMP1117_B", "2021-03-04");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("COMP1117_B", "2021-03-18");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("COMP1117_B", "2021-03-25");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("COMP1117_B", "2021-04-01");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("COMP1117_B", "2021-04-08");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("COMP1117_B", "2021-04-15");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("COMP1117_B", "2021-04-22");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("COMP1117_B", "2021-04-29");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("COMP2113", "2021-01-28");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("COMP2113", "2021-02-04");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("COMP2113", "2021-02-11");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("COMP2113", "2021-02-25");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("COMP2113", "2021-03-04");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("COMP2113", "2021-03-18");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("COMP2113", "2021-03-25");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("COMP2113", "2021-04-01");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("COMP2113", "2021-04-08");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("COMP2113", "2021-04-15");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("COMP2113", "2021-04-22");
INSERT INTO `Lecture_date` (`course_id`, `lecture_date`) VALUES ("COMP2113", "2021-04-29");


INSERT INTO `Assignment` (`course_id`, `number`, `due_date`) VALUES ("PHYS1250", 1, "2021-03-03");
INSERT INTO `Assignment` (`course_id`, `number`, `due_date`) VALUES ("PHYS1250", 2, "2021-04-25");
INSERT INTO `Assignment` (`course_id`, `number`, `due_date`) VALUES ("CHEM1041", 1, "2021-03-27");
INSERT INTO `Assignment` (`course_id`, `number`, `due_date`) VALUES ("CHEM1041", 2, "2021-04-18");
INSERT INTO `Assignment` (`course_id`, `number`, `due_date`) VALUES ("BIOL1110", 1, "2021-03-14");
INSERT INTO `Assignment` (`course_id`, `number`, `due_date`) VALUES ("BIOL1110", 2, "2021-05-02");
INSERT INTO `Assignment` (`course_id`, `number`, `due_date`) VALUES ("ECON1210_A", 1, "2021-03-17");
INSERT INTO `Assignment` (`course_id`, `number`, `due_date`) VALUES ("ECON1210_A", 2, "2021-04-28");
INSERT INTO `Assignment` (`course_id`, `number`, `due_date`) VALUES ("ECON1210_B", 1, "2021-03-17");
INSERT INTO `Assignment` (`course_id`, `number`, `due_date`) VALUES ("ECON1210_B", 2, "2021-04-28");
INSERT INTO `Assignment` (`course_id`, `number`, `due_date`) VALUES ("ECON1220_A", 1, "2021-03-20");
INSERT INTO `Assignment` (`course_id`, `number`, `due_date`) VALUES ("ECON1220_A", 2, "2021-04-24");
INSERT INTO `Assignment` (`course_id`, `number`, `due_date`) VALUES ("ECON1220_B", 1, "2021-03-20");
INSERT INTO `Assignment` (`course_id`, `number`, `due_date`) VALUES ("ECON1220_B", 2, "2021-04-24");
INSERT INTO `Assignment` (`course_id`, `number`, `due_date`) VALUES ("COMP1117_A", 1, "2021-02-21");
INSERT INTO `Assignment` (`course_id`, `number`, `due_date`) VALUES ("COMP1117_A", 2, "2021-03-21");
INSERT INTO `Assignment` (`course_id`, `number`, `due_date`) VALUES ("COMP1117_A", 3, "2021-04-25");
INSERT INTO `Assignment` (`course_id`, `number`, `due_date`) VALUES ("COMP1117_B", 1, "2021-02-21");
INSERT INTO `Assignment` (`course_id`, `number`, `due_date`) VALUES ("COMP1117_B", 2, "2021-03-21");
INSERT INTO `Assignment` (`course_id`, `number`, `due_date`) VALUES ("COMP1117_B", 3, "2021-04-25");
INSERT INTO `Assignment` (`course_id`, `number`, `due_date`) VALUES ("COMP2113", 1, "2021-03-06");
INSERT INTO `Assignment` (`course_id`, `number`, `due_date`) VALUES ("COMP2113", 2, "2021-04-10");
INSERT INTO `Assignment` (`course_id`, `number`, `due_date`) VALUES ("COMP2113", 3, "2021-05-01");


INSERT INTO `Takes` (`student_id`, `course_id`) VALUES (1,"ECON1210_A");
INSERT INTO `Takes` (`student_id`, `course_id`) VALUES (1,"ECON1220_A");
INSERT INTO `Takes` (`student_id`, `course_id`) VALUES (2,"PHYS1250");
INSERT INTO `Takes` (`student_id`, `course_id`) VALUES (2,"CHEM1041");
INSERT INTO `Takes` (`student_id`, `course_id`) VALUES (2,"BIOL1110");
INSERT INTO `Takes` (`student_id`, `course_id`) VALUES (3,"ECON1210_B");
INSERT INTO `Takes` (`student_id`, `course_id`) VALUES (3,"ECON1220_B");
INSERT INTO `Takes` (`student_id`, `course_id`) VALUES (3,"COMP1117_A");
INSERT INTO `Takes` (`student_id`, `course_id`) VALUES (4,"PHYS1250");
INSERT INTO `Takes` (`student_id`, `course_id`) VALUES (4,"COMP2113");
INSERT INTO `Takes` (`student_id`, `course_id`) VALUES (5,"COMP1117_B");


INSERT INTO `Tutor` (`tutor_id`, `teacher_id`, `dpt_id`, `name`, `office`, `email`) VALUES (1, 1, 1, "OLIVER", "410, HOC Building", "oliver@hku.hk");
INSERT INTO `Tutor` (`tutor_id`, `teacher_id`, `dpt_id`, `name`, `office`, `email`) VALUES (2, 1, 1, "CHARLIE", "411, HOC Building", "charlie@hku.hk");
INSERT INTO `Tutor` (`tutor_id`, `teacher_id`, `dpt_id`, `name`, `office`, `email`) VALUES (3, 1, 1, "WENDY", "412, HOC Building", "wendy@hku.hk");
INSERT INTO `Tutor` (`tutor_id`, `teacher_id`, `dpt_id`, `name`, `office`, `email`) VALUES (4, 1, 1, "FRED", "413, HOC Building", "fred@hku.hk");
INSERT INTO `Tutor` (`tutor_id`, `teacher_id`, `dpt_id`, `name`, `office`, `email`) VALUES (5, 1, 1, "CHERRY", "414, HOC Building", "cherry@hku.hk");
INSERT INTO `Tutor` (`tutor_id`, `teacher_id`, `dpt_id`, `name`, `office`, `email`) VALUES (6, 1, 1, "LEO", "415, HOC Building", "leo@hku.hk");
INSERT INTO `Tutor` (`tutor_id`, `teacher_id`, `dpt_id`, `name`, `office`, `email`) VALUES (7, 4, 2, "ABELA", "209, RRS buildling", "abela@hku.hk");
INSERT INTO `Tutor` (`tutor_id`, `teacher_id`, `dpt_id`, `name`, `office`, `email`) VALUES (8, 4, 2, "JAMES", "210, RRS buildling", "james@hku.hk");
INSERT INTO `Tutor` (`tutor_id`, `teacher_id`, `dpt_id`, `name`, `office`, `email`) VALUES (9, 4, 2, "DAISY", "211, RRS buildling", "daisy@hku.hk");
INSERT INTO `Tutor` (`tutor_id`, `teacher_id`, `dpt_id`, `name`, `office`, `email`) VALUES (10, 4, 2, "GEORGE", "212, RRS buildling", "george@hku.hk");
INSERT INTO `Tutor` (`tutor_id`, `teacher_id`, `dpt_id`, `name`, `office`, `email`) VALUES (11, 4, 2, "MANSON", "213, RRS buildling", "manson@hku.hk");
INSERT INTO `Tutor` (`tutor_id`, `teacher_id`, `dpt_id`, `name`, `office`, `email`) VALUES (12, 4, 2, "ISABELLA", "214, RRS buildling", "isabella@hku.hk");
INSERT INTO `Tutor` (`tutor_id`, `teacher_id`, `dpt_id`, `name`, `office`, `email`) VALUES (13, 9, 3, "HELEN", "610, HW Building", "helen@hku.hk");
INSERT INTO `Tutor` (`tutor_id`, `teacher_id`, `dpt_id`, `name`, `office`, `email`) VALUES (14, 9, 3, "OSCAR", "611, HW Building", "oscar@hku.hk");
INSERT INTO `Tutor` (`tutor_id`, `teacher_id`, `dpt_id`, `name`, `office`, `email`) VALUES (15, 9, 3, "ADELA", "612, HW Building", "adela@hku.hk");
INSERT INTO `Tutor` (`tutor_id`, `teacher_id`, `dpt_id`, `name`, `office`, `email`) VALUES (16, 9, 3, "JACOB", "613, HW Building", "jacob@hku.hk");
INSERT INTO `Tutor` (`tutor_id`, `teacher_id`, `dpt_id`, `name`, `office`, `email`) VALUES (17, 9, 3, "RACHEAL", "614, HW Building", "racheal@hku.hk");


INSERT INTO `Tutorial` (`course_id`, `tutorial_no`, `tutor_id`, `room_id`, `schedule`, `zoom_link`)
VALUES ("PHYS1250", 1, 1, 6, "WED 09:30 - 10:20", "https://hku.zoom.us/j/99980161331?pwd=MFBjcFdCWmd4UkxLcGk2WjBYVkNudz09");
INSERT INTO `Tutorial` (`course_id`, `tutorial_no`, `tutor_id`, `room_id`, `schedule`, `zoom_link`)
VALUES ("CHEM1041", 1, 3, 6, "MON 11:30 - 12:20", "https://hku.zoom.us/j/95419952073?pwd=U1pVeEZDb0FqQnhyNDlSNVRvS2FYZz09");
INSERT INTO `Tutorial` (`course_id`, `tutorial_no`, `tutor_id`, `room_id`, `schedule`, `zoom_link`)
VALUES ("BIOL1110", 1, 5, 6, "TUE 09:30 - 10:20", "https://hku.zoom.us/j/94542466421?pwd=dW5hcUR1K25SdlpkL3M2Z05BM2ZZUT09");
INSERT INTO `Tutorial` (`course_id`, `tutorial_no`, `tutor_id`, `room_id`, `schedule`, `zoom_link`)
VALUES ("ECON1210_A", 1 ,7, 1, "MON 17:30 - 18:20", "https://hku.zoom.us/j/97232002252?pwd=a3BDQWhoUzRLV20yQ01CalFUVEhKdz09");
INSERT INTO `Tutorial` (`course_id`, `tutorial_no`, `tutor_id`, `room_id`, `schedule`, `zoom_link`)
VALUES ("ECON1210_B", 1, 8, 1, "MON 17:30 - 18:20", "https://hku.zoom.us/j/99345519312?pwd=eWFVdTVxU1VtTXJJVTJhWWJQTGJaUT09");
INSERT INTO `Tutorial` (`course_id`, `tutorial_no`, `tutor_id`, `room_id`, `schedule`, `zoom_link`)
VALUES ("ECON1220_A", 1, 9, 3, "TUE 17:30 - 18:20", "https://hku.zoom.us/j/97672721790?pwd=ZWdRTklXQkFBVXM2QkZScFViS2dXUT09");
INSERT INTO `Tutorial` (`course_id`, `tutorial_no`, `tutor_id`, `room_id`, `schedule`, `zoom_link`)
VALUES ("ECON1220_B", 1, 10, 3, "TUE 17:30 - 18:20", "https://hku.zoom.us/j/93511800416?pwd=SWUvSWdDcWhVQXZnR2thVmlZOUdIQT09");
INSERT INTO `Tutorial` (`course_id`, `tutorial_no`, `tutor_id`, `room_id`, `schedule`, `zoom_link`)
VALUES ("COMP1117_A", 1, 13, 2, "FRI 11:30 - 12:20", "https://hku.zoom.us/j/97881286160?pwd=cCswWTB3cHdoS2NSMXZ4cmNkQWNidz09");
INSERT INTO `Tutorial` (`course_id`, `tutorial_no`, `tutor_id`, `room_id`, `schedule`, `zoom_link`)
VALUES ("COMP1117_B", 1, 14, 2, "FRI 11:30 - 12:20", "https://hku.zoom.us/j/93998743659?pwd=K2RVeXVDL0dhcUVtWnlSWVlhRG9Rdz09");
INSERT INTO `Tutorial` (`course_id`, `tutorial_no`, `tutor_id`, `room_id`, `schedule`, `zoom_link`)
VALUES ("COMP2113", 1, 15, 4, "MON 14:30 - 15:20", "N/A");


INSERT INTO `Registers` (`student_id`, `course_id`, `tutorial_no`) VALUES (1, "ECON1210_A", 1);
INSERT INTO `Registers` (`student_id`, `course_id`, `tutorial_no`) VALUES (1, "ECON1220_A", 1);
INSERT INTO `Registers` (`student_id`, `course_id`, `tutorial_no`) VALUES (2, "PHYS1250", 1);
INSERT INTO `Registers` (`student_id`, `course_id`, `tutorial_no`) VALUES (2, "CHEM1041", 1);
INSERT INTO `Registers` (`student_id`, `course_id`, `tutorial_no`) VALUES (2, "BIOL1110", 1);
INSERT INTO `Registers` (`student_id`, `course_id`, `tutorial_no`) VALUES (3, "ECON1210_B", 1);
INSERT INTO `Registers` (`student_id`, `course_id`, `tutorial_no`) VALUES (3, "ECON1220_B", 1);
INSERT INTO `Registers` (`student_id`, `course_id`, `tutorial_no`) VALUES (3, "COMP1117_A", 1);
INSERT INTO `Registers` (`student_id`, `course_id`, `tutorial_no`) VALUES (4, "PHYS1250", 1);
INSERT INTO `Registers` (`student_id`, `course_id`, `tutorial_no`) VALUES (4, "COMP2113", 1);
INSERT INTO `Registers` (`student_id`, `course_id`, `tutorial_no`) VALUES (5, "COMP1117_B", 1);


INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("PHYS1250", 1, "2021-01-20");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("PHYS1250", 1, "2021-01-27");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("PHYS1250", 1, "2021-02-03");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("PHYS1250", 1, "2021-02-10");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("PHYS1250", 1, "2021-02-24");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("PHYS1250", 1, "2021-03-03");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("PHYS1250", 1, "2021-03-17");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("PHYS1250", 1, "2021-03-24");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("PHYS1250", 1, "2021-03-31");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("PHYS1250", 1, "2021-04-07");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("PHYS1250", 1, "2021-04-14");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("PHYS1250", 1, "2021-04-21");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("PHYS1250", 1, "2021-04-28");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("CHEM1041", 1, "2021-01-18");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("CHEM1041", 1, "2021-01-25");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("CHEM1041", 1, "2021-02-01");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("CHEM1041", 1, "2021-02-08");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("CHEM1041", 1, "2021-02-22");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("CHEM1041", 1, "2021-03-01");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("CHEM1041", 1, "2021-03-15");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("CHEM1041", 1, "2021-03-22");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("CHEM1041", 1, "2021-03-29");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("CHEM1041", 1, "2021-04-12");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("CHEM1041", 1, "2021-04-19");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("CHEM1041", 1, "2021-04-26");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("BIOL1110", 1, "2021-01-19");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("BIOL1110", 1, "2021-01-26");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("BIOL1110", 1, "2021-02-02");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("BIOL1110", 1, "2021-02-09");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("BIOL1110", 1, "2021-02-23");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("BIOL1110", 1, "2021-03-02");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("BIOL1110", 1, "2021-03-23");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("BIOL1110", 1, "2021-03-30");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("BIOL1110", 1, "2021-04-13");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("BIOL1110", 1, "2021-04-20");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("BIOL1110", 1, "2021-04-27");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1210_A", 1, "2021-01-18");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1210_A", 1, "2021-01-25");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1210_A", 1, "2021-02-01");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1210_A", 1, "2021-02-08");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1210_A", 1, "2021-02-22");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1210_A", 1, "2021-03-01");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1210_A", 1, "2021-03-15");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1210_A", 1, "2021-03-22");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1210_A", 1, "2021-03-29");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1210_A", 1, "2021-04-12");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1210_A", 1, "2021-04-19");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1210_A", 1, "2021-04-26");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1210_B", 1, "2021-01-18");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1210_B", 1, "2021-01-25");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1210_B", 1, "2021-02-01");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1210_B", 1, "2021-02-08");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1210_B", 1, "2021-02-22");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1210_B", 1, "2021-03-01");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1210_B", 1, "2021-03-15");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1210_B", 1, "2021-03-22");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1210_B", 1, "2021-03-29");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1210_B", 1, "2021-04-12");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1210_B", 1, "2021-04-19");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1210_B", 1, "2021-04-26");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1220_A", 1, "2021-01-19");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1220_A", 1, "2021-01-26");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1220_A", 1, "2021-02-02");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1220_A", 1, "2021-02-09");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1220_A", 1, "2021-02-23");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1220_A", 1, "2021-03-02");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1220_A", 1, "2021-03-23");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1220_A", 1, "2021-03-30");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1220_A", 1, "2021-04-13");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1220_A", 1, "2021-04-20");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1220_A", 1, "2021-04-27");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1220_B", 1, "2021-01-19");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1220_B", 1, "2021-01-26");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1220_B", 1, "2021-02-02");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1220_B", 1, "2021-02-09");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1220_B", 1, "2021-02-23");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1220_B", 1, "2021-03-02");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1220_B", 1, "2021-03-23");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1220_B", 1, "2021-03-30");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1220_B", 1, "2021-04-13");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1220_B", 1, "2021-04-20");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("ECON1220_B", 1, "2021-04-27");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("COMP1117_A", 1, "2021-01-22");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("COMP1117_A", 1, "2021-01-29");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("COMP1117_A", 1, "2021-02-05");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("COMP1117_A", 1, "2021-02-19");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("COMP1117_A", 1, "2021-02-26");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("COMP1117_A", 1, "2021-03-05");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("COMP1117_A", 1, "2021-03-19");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("COMP1117_A", 1, "2021-03-26");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("COMP1117_A", 1, "2021-04-09");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("COMP1117_A", 1, "2021-04-16");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("COMP1117_A", 1, "2021-04-23");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("COMP1117_A", 1, "2021-04-30");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("COMP1117_B", 1, "2021-01-22");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("COMP1117_B", 1, "2021-01-29");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("COMP1117_B", 1, "2021-02-05");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("COMP1117_B", 1, "2021-02-19");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("COMP1117_B", 1, "2021-02-26");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("COMP1117_B", 1, "2021-03-05");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("COMP1117_B", 1, "2021-03-19");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("COMP1117_B", 1, "2021-03-26");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("COMP1117_B", 1, "2021-04-09");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("COMP1117_B", 1, "2021-04-16");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("COMP1117_B", 1, "2021-04-23");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("COMP1117_B", 1, "2021-04-30");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("COMP2113", 1, "2021-01-18");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("COMP2113", 1, "2021-01-25");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("COMP2113", 1, "2021-02-01");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("COMP2113", 1, "2021-02-08");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("COMP2113", 1, "2021-02-22");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("COMP2113", 1, "2021-03-01");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("COMP2113", 1, "2021-03-15");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("COMP2113", 1, "2021-03-22");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("COMP2113", 1, "2021-03-29");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("COMP2113", 1, "2021-04-12");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("COMP2113", 1, "2021-04-19");
INSERT INTO `Tutorial_date` (`course_id`, `tutorial_no`, `tutorial_date`) VALUES ("COMP2113", 1, "2021-04-26");


INSERT INTO `Tutorial_note` (`course_id`, `tutorial_no`, `filename`) VALUES ("PHYS1250", 1, "Tutorial_slides");
#INSERT INTO `Tutorial_note` (`course_id`, `tutorial_no`, `filename`) VALUES ("PHYS1250", 2, "Tutorial_slides");
INSERT INTO `Tutorial_note` (`course_id`, `tutorial_no`, `filename`) VALUES ("CHEM1041", 1, "T1");
INSERT INTO `Tutorial_note` (`course_id`, `tutorial_no`, `filename`) VALUES ("CHEM1041", 1, "T2");
INSERT INTO `Tutorial_note` (`course_id`, `tutorial_no`, `filename`) VALUES ("CHEM1041", 1, "T3");
INSERT INTO `Tutorial_note` (`course_id`, `tutorial_no`, `filename`) VALUES ("CHEM1041", 1, "T4");
#INSERT INTO `Tutorial_note` (`course_id`, `tutorial_no`, `filename`) VALUES ("CHEM1041", 2, "T1");
#INSERT INTO `Tutorial_note` (`course_id`, `tutorial_no`, `filename`) VALUES ("CHEM1041", 2, "T2");
#INSERT INTO `Tutorial_note` (`course_id`, `tutorial_no`, `filename`) VALUES ("CHEM1041", 2, "T3");
#INSERT INTO `Tutorial_note` (`course_id`, `tutorial_no`, `filename`) VALUES ("CHEM1041", 2, "T4");
INSERT INTO `Tutorial_note` (`course_id`, `tutorial_no`, `filename`) VALUES ("BIOL1110", 1, "Tutorial_01");
INSERT INTO `Tutorial_note` (`course_id`, `tutorial_no`, `filename`) VALUES ("BIOL1110", 1, "Tutorial_02");
INSERT INTO `Tutorial_note` (`course_id`, `tutorial_no`, `filename`) VALUES ("BIOL1110", 1, "Tutorial_03");
INSERT INTO `Tutorial_note` (`course_id`, `tutorial_no`, `filename`) VALUES ("BIOL1110", 1, "Tutorial_04");
#INSERT INTO `Tutorial_note` (`course_id`, `tutorial_no`, `filename`) VALUES ("BIOL1110", 2, "Tutorial_01");
#INSERT INTO `Tutorial_note` (`course_id`, `tutorial_no`, `filename`) VALUES ("BIOL1110", 2, "Tutorial_02");
#INSERT INTO `Tutorial_note` (`course_id`, `tutorial_no`, `filename`) VALUES ("BIOL1110", 2, "Tutorial_03");
#INSERT INTO `Tutorial_note` (`course_id`, `tutorial_no`, `filename`) VALUES ("BIOL1110", 2, "Tutorial_04");
INSERT INTO `Tutorial_note` (`course_id`, `tutorial_no`, `filename`) VALUES ("ECON1210_A", 1, "Demand and Supply");
INSERT INTO `Tutorial_note` (`course_id`, `tutorial_no`, `filename`) VALUES ("ECON1210_A", 1, "Elasticity");
INSERT INTO `Tutorial_note` (`course_id`, `tutorial_no`, `filename`) VALUES ("ECON1210_A", 1, "Profit aximization");
INSERT INTO `Tutorial_note` (`course_id`, `tutorial_no`, `filename`) VALUES ("ECON1210_A", 1, "Price discrimination");
INSERT INTO `Tutorial_note` (`course_id`, `tutorial_no`, `filename`) VALUES ("ECON1210_B", 1, "Demand and Supply");
INSERT INTO `Tutorial_note` (`course_id`, `tutorial_no`, `filename`) VALUES ("ECON1210_B", 1, "Elasticity");
INSERT INTO `Tutorial_note` (`course_id`, `tutorial_no`, `filename`) VALUES ("ECON1210_B", 1, "Profit aximization");
INSERT INTO `Tutorial_note` (`course_id`, `tutorial_no`, `filename`) VALUES ("ECON1210_B", 1, "Price discrimination");
INSERT INTO `Tutorial_note` (`course_id`, `tutorial_no`, `filename`) VALUES ("ECON1220_A", 1, "About macroeconomics");
INSERT INTO `Tutorial_note` (`course_id`, `tutorial_no`, `filename`) VALUES ("ECON1220_A", 1, "Macroeconomics models");
INSERT INTO `Tutorial_note` (`course_id`, `tutorial_no`, `filename`) VALUES ("ECON1220_A", 1, "About macroeconomics");
INSERT INTO `Tutorial_note` (`course_id`, `tutorial_no`, `filename`) VALUES ("ECON1220_A", 1, "Macroeconomics models");


INSERT INTO `Club` (`club_id`, `name`, `email`) VALUES (1, "Art Club", "art@hku.hk");
INSERT INTO `Club` (`club_id`, `name`, `email`) VALUES (2, "Bridge Club", "bridge@hku,hk");
INSERT INTO `Club` (`club_id`, `name`, `email`) VALUES (3, "Dance Club", "dance@hku.hk");
INSERT INTO `Club` (`club_id`, `name`, `email`) VALUES (4, "Film Club", "film@hku.hk");


INSERT INTO `Activity` (`club_id`, `title`, `start_date`, `end_date`, `location`) VALUES (1, "Art exhibition", "2021-05-01", "2021-05-02", "CYC Building");
INSERT INTO `Activity` (`club_id`, `title`, `start_date`, `end_date`, `location`) VALUES (3, "Dancing competition", "2021-04-18", "2021-04-18", "KITEC");


INSERT INTO `Enrolls_in` (`student_id`, `club_id`, `role`) VALUES (2,1, "member");
INSERT INTO `Enrolls_in` (`student_id`, `club_id`, `role`) VALUES (2,2, "member");
INSERT INTO `Enrolls_in` (`student_id`, `club_id`, `role`) VALUES (3,2, "vice-president");
INSERT INTO `Enrolls_in` (`student_id`, `club_id`, `role`) VALUES (4,3, "member");


/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;


