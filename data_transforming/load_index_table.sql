use diabetes_dwh_staging;

CREATE TABLE IF NOT EXISTS `diabetes_DWH_staging`.`icd9_index` (
  `id` INT NOT NULL COMMENT '',
  `disease` VARCHAR(200) NOT NULL COMMENT '',
  `code_letter` VARCHAR(10) NULL COMMENT '',
  `code_from` INT NOT NULL COMMENT '',
  `code_to` INT NOT NULL COMMENT '',
  PRIMARY KEY (`id`)  COMMENT '')
ENGINE = InnoDB;

LOAD DATA INFILE 'D:/University/Level 4/sem_1/Data Warehousing and Data Mining - SENG 41573/group mini project/diabetes_data_warehouse/data_transforming/diseases_and_injuries_tabular_index.csv'
INTO TABLE `icd9_index`
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;