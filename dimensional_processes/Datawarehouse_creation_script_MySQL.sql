-- MySQL Script generated by MySQL Workbench
-- Sat 18 Mar 2023 10:02:06 PM -05
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `mydb` ;

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Date`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Date` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Date` (
  `date_id` INT NOT NULL,
  `date` VARCHAR(45) NOT NULL,
  `year` INT NOT NULL,
  `semester` VARCHAR(45) NOT NULL,
  `quarter` VARCHAR(45) NOT NULL,
  `bimester` VARCHAR(45) NOT NULL,
  `month` VARCHAR(45) NOT NULL,
  `month_name` VARCHAR(45) NOT NULL,
  `week` VARCHAR(45) NOT NULL,
  `weekday` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`date_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Student`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Student` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Student` (
  `student_id` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `birthdate` VARCHAR(45) NOT NULL,
  `nationality` VARCHAR(45) NOT NULL,
  `gender` VARCHAR(45) NOT NULL,
  `country` VARCHAR(45) NOT NULL,
  `city` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`student_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Program`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Program` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Program` (
  `program_id` INT NOT NULL,
  `sia_code` VARCHAR(45) NOT NULL,
  `education_level` VARCHAR(45) NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `mandatory_disciplinary_credits` INT NOT NULL,
  `mandatory_fundamental_credits` INT NOT NULL,
  `optional_disciplinary_credits` INT NOT NULL,
  `optional_fundamental_credits` INT NOT NULL,
  `free_choice_credits` INT NOT NULL,
  `department` VARCHAR(45) NOT NULL,
  `faculty` VARCHAR(45) NOT NULL,
  `campus` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`program_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Professor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Professor` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Professor` (
  `professor_id` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `birthdate` VARCHAR(45) NOT NULL,
  `nationality` VARCHAR(45) NOT NULL,
  `gender` VARCHAR(45) NOT NULL,
  `status` VARCHAR(45) NOT NULL,
  `entrance_date` VARCHAR(45) NOT NULL,
  `retirement_date` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`professor_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`CourseGroup`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`CourseGroup` ;

CREATE TABLE IF NOT EXISTS `mydb`.`CourseGroup` (
  `course_id` INT NOT NULL,
  `group_id` INT NOT NULL,
  `sia_code` VARCHAR(45) NOT NULL,
  `group_number` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `credits` INT NOT NULL,
  `seats` INT NOT NULL,
  `hourly_intensity` INT NOT NULL,
  `hourly_intensity_am` INT NOT NULL,
  `hourly_intensity_pm` INT NOT NULL,
  PRIMARY KEY (`course_id`, `group_id`),
  INDEX `idx_group_id` (`group_id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`AcademicHistory`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`AcademicHistory` ;

CREATE TABLE IF NOT EXISTS `mydb`.`AcademicHistory` (
  `academic_history_id` INT NOT NULL,
  `program_id` INT NOT NULL,
  `sia_code` VARCHAR(45) NOT NULL,
  `start_date` VARCHAR(45) NOT NULL,
  `end_date` VARCHAR(45) NOT NULL,
  `status` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`academic_history_id`, `program_id`),
  INDEX `fk_program_id_idx` (`program_id` ASC) VISIBLE,
  CONSTRAINT `fk_program_id_to_academic_history_id`
    FOREIGN KEY (`program_id`)
    REFERENCES `mydb`.`Program` (`program_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`CurriculumFact`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`CurriculumFact` ;

CREATE TABLE IF NOT EXISTS `mydb`.`CurriculumFact` (
  `program_id` INT NOT NULL,
  `course_id` INT NOT NULL,
  `group_id` INT NOT NULL,
  `count_prerequistes` INT NOT NULL,
  PRIMARY KEY (`program_id`, `course_id`, `group_id`),
  INDEX `fk_course_id_idx` (`course_id` ASC) VISIBLE,
  INDEX `fk_group_id_to_CurriculumFact_idx` (`group_id` ASC) VISIBLE,
  CONSTRAINT `fk_program_id_to_CurriculumFact`
    FOREIGN KEY (`program_id`)
    REFERENCES `mydb`.`Program` (`program_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_course_id_to_CurriculumFact`
    FOREIGN KEY (`course_id`)
    REFERENCES `mydb`.`CourseGroup` (`course_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_group_id_to_CurriculumFact`
    FOREIGN KEY (`group_id`)
    REFERENCES `mydb`.`CourseGroup` (`group_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`CourseFact`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`CourseFact` ;

CREATE TABLE IF NOT EXISTS `mydb`.`CourseFact` (
  `course_id` INT NOT NULL,
  `group_id` INT NOT NULL,
  `program_id` INT NOT NULL,
  `professor_id` INT NOT NULL,
  `grade_sum` DECIMAL NOT NULL,
  `student_count` INT NOT NULL,
  `approved_count` INT NOT NULL,
  `failed_count` INT NOT NULL,
  PRIMARY KEY (`course_id`, `group_id`, `program_id`, `professor_id`),
  INDEX `fk_group_id_idx` (`group_id` ASC) VISIBLE,
  INDEX `fk_program_id_idx` (`program_id` ASC) VISIBLE,
  INDEX `fk_professor_id_idx` (`professor_id` ASC) VISIBLE,
  CONSTRAINT `fk_course_id_to_CourseFact`
    FOREIGN KEY (`course_id`)
    REFERENCES `mydb`.`CourseGroup` (`course_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_group_id_to_CourseFact`
    FOREIGN KEY (`group_id`)
    REFERENCES `mydb`.`CourseGroup` (`group_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_program_id_to_CourseFact`
    FOREIGN KEY (`program_id`)
    REFERENCES `mydb`.`Program` (`program_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_professor_id_to_CourseFact`
    FOREIGN KEY (`professor_id`)
    REFERENCES `mydb`.`Professor` (`professor_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`GradesFact`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`GradesFact` ;

CREATE TABLE IF NOT EXISTS `mydb`.`GradesFact` (
  `grade_date_id` INT NOT NULL,
  `course_id` INT NOT NULL,
  `group_id` INT NOT NULL,
  `professor_id` INT NOT NULL,
  `student_id` INT NOT NULL,
  `program_id` INT NOT NULL,
  `academic_history_id` INT NOT NULL,
  `history_couse_id` VARCHAR(45) NOT NULL,
  `grade` DECIMAL NOT NULL,
  `approved` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`grade_date_id`, `course_id`, `group_id`, `professor_id`, `student_id`, `program_id`, `academic_history_id`, `history_couse_id`),
  INDEX `fk_course_id_idx` (`course_id` ASC) VISIBLE,
  INDEX `fk_group_id_idx` (`group_id` ASC) VISIBLE,
  INDEX `fk_professor_id_idx` (`professor_id` ASC) VISIBLE,
  INDEX `fk_student_id_idx` (`student_id` ASC) VISIBLE,
  INDEX `fk_program_id_idx` (`program_id` ASC) VISIBLE,
  INDEX `fk_academic_history_id_idx` (`academic_history_id` ASC) VISIBLE,
  CONSTRAINT `fk_grade_date_id_to_GradesFact`
    FOREIGN KEY (`grade_date_id`)
    REFERENCES `mydb`.`Date` (`date_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_course_id_to_GradesFact`
    FOREIGN KEY (`course_id`)
    REFERENCES `mydb`.`CourseGroup` (`course_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_group_id_to_GradesFact`
    FOREIGN KEY (`group_id`)
    REFERENCES `mydb`.`CourseGroup` (`group_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_professor_id_to_GradesFact`
    FOREIGN KEY (`professor_id`)
    REFERENCES `mydb`.`Professor` (`professor_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_student_id_to_GradesFact`
    FOREIGN KEY (`student_id`)
    REFERENCES `mydb`.`Student` (`student_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_program_id_to_GradesFact`
    FOREIGN KEY (`program_id`)
    REFERENCES `mydb`.`Program` (`program_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_academic_history_id_to_GradesFact`
    FOREIGN KEY (`academic_history_id`)
    REFERENCES `mydb`.`AcademicHistory` (`academic_history_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
