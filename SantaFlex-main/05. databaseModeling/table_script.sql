-- 비트캠프 A반 2조 문하윤, 김혜지, 고결, 유철우


-- -----------------------------------------------------
-- Table `database_modeling`.`member`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `database_modeling`.`member` (
  `ID` VARCHAR(45) NOT NULL,
  `Name` VARCHAR(45) NOT NULL,
  `pwd` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `birthday` INT NOT NULL,
  `Tel` INT NOT NULL,
  `address` VARCHAR(45) NOT NULL,
  `Role` VARCHAR(1) NOT NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `database_modeling`.`Event`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `database_modeling`.`Event` (
  `EventID` VARCHAR(45) NOT NULL,
  `EventName` VARCHAR(45) NOT NULL,
  `EventDate` VARCHAR(45) NOT NULL,
  `Receiver` VARCHAR(45) NOT NULL,
  `Location` VARCHAR(45) NOT NULL,
  `Content` TEXT NOT NULL,
  `regDate` DATETIME NOT NULL,
  `member_ID` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`EventID`, `member_ID`),
  INDEX `fk_Event_member1_idx` (`member_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Event_member1`
    FOREIGN KEY (`member_ID`)
    REFERENCES `database_modeling`.`member` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `database_modeling`.`SelectPresent`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `database_modeling`.`SelectPresent` (
  `PresentNum` VARCHAR(45) NOT NULL,
  `PresentName` VARCHAR(45) NOT NULL,
  `price` VARCHAR(45) NOT NULL,
  `Event_EventID` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`PresentNum`, `Event_EventID`),
  INDEX `fk_SelectPresent_Event1_idx` (`Event_EventID` ASC) VISIBLE,
  CONSTRAINT `fk_SelectPresent_Event1`
    FOREIGN KEY (`Event_EventID`)
    REFERENCES `database_modeling`.`Event` (`EventID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `database_modeling`.`QnA`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `database_modeling`.`QnA` (
  `qnaNum` INT NOT NULL,
  `Title` VARCHAR(45) NOT NULL,
  `regDate` DATETIME NOT NULL,
  `Hit` INT NOT NULL,
  `content` TEXT NOT NULL,
  `Status` VARCHAR(1) NOT NULL,
  `member_ID` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`qnaNum`, `member_ID`),
  INDEX `fk_QnA_member1_idx` (`member_ID` ASC) VISIBLE,
  CONSTRAINT `fk_QnA_member1`
    FOREIGN KEY (`member_ID`)
    REFERENCES `database_modeling`.`member` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `database_modeling`.`GivePresent`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `database_modeling`.`GivePresent` (
  `SelectPresent_PresentNum` VARCHAR(45) NOT NULL,
  `member_ID` VARCHAR(45) NOT NULL,
  `Price` VARCHAR(45) NOT NULL,
  `Dutch` VARCHAR(1) NOT NULL,
  `PayOpt` VARCHAR(1) NOT NULL,
  `Receiver` VARCHAR(45) NOT NULL,
  `accountNum` VARCHAR(45) NULL,
  `CVC` VARCHAR(3) NULL,
  `expiration` DATE NULL,
  `ReturnID` VARCHAR(45) NULL,
  `ReturnName` VARCHAR(1) NULL,
  `ReturnMethod` VARCHAR(1) NULL,
  `paymentStatus` VARCHAR(1) NOT NULL,
  PRIMARY KEY (`SelectPresent_PresentNum`, `member_ID`),
  INDEX `fk_Give_present_member1_idx` (`member_ID` ASC) VISIBLE,
  INDEX `fk_GivePresent_SelectPresent1_idx` (`SelectPresent_PresentNum` ASC) VISIBLE,
  CONSTRAINT `fk_Give_present_member1`
    FOREIGN KEY (`member_ID`)
    REFERENCES `database_modeling`.`member` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_GivePresent_SelectPresent1`
    FOREIGN KEY (`SelectPresent_PresentNum`)
    REFERENCES `database_modeling`.`SelectPresent` (`PresentNum`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `database_modeling`.`Message`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `database_modeling`.`Message` (
  `MsgNum` INT NOT NULL,
  `To` VARCHAR(45) NOT NULL,
  `From` VARCHAR(45) NOT NULL,
  `Title` VARCHAR(45) NOT NULL,
  `content` TEXT NOT NULL,
  `Date` DATETIME NOT NULL,
  `member_ID` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`MsgNum`, `member_ID`),
  INDEX `fk_Message_member1_idx` (`member_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Message_member1`
    FOREIGN KEY (`member_ID`)
    REFERENCES `database_modeling`.`member` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
