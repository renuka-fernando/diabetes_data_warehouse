# Data Warehouse of Diabetic Data
Dataset URL - https://archive.ics.uci.edu/ml/datasets/Diabetes+130-US+hospitals+for+years+1999-2008
Attribute Info - https://www.hindawi.com/journals/bmri/2014/781670/tab1/

## Files
- data_warehouse.mwb - MySQL Workbench model file
- dimensional_modeling/dimentional_design.xml - Draw.io file

# Dimensional Model
![Dimensional Model of Data Warehouse](dimensional_modeling/dimentional_design.png)

# Build Data Warehouse
## Step 01 - Create Schema for Staging Area
Use following query to create the database named '*diabetes_dwh_staging*' and tables.
- Database: diabetes_dwh_staging
- Tables:
  1. dataset
  1. admission_source
  1. admission_type
  1. discharge_disposition

Query to execute
```sql

DROP SCHEMA IF EXISTS `diabetes_DWH_staging` ;
CREATE SCHEMA `diabetes_DWH_staging` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `diabetes_DWH_staging` ;

CREATE TABLE IF NOT EXISTS `diabetes_DWH_staging`.`dataset` (
  `encounter_id` INT NULL COMMENT '',
  `patient_nbr` INT NULL COMMENT '',
  `race` VARCHAR(45) NULL COMMENT '',
  `gender` VARCHAR(45) NULL COMMENT '',
  `age` VARCHAR(45) NULL COMMENT '',
  `weight` VARCHAR(45) NULL COMMENT '',
  `admission_type_id` INT NULL COMMENT '',
  `discharge_disposition_id` INT NULL COMMENT '',
  `admission_source_id` INT NULL COMMENT '',
  `time_in_hospital` INT NULL COMMENT '',
  `payer_code` VARCHAR(45) NULL COMMENT '',
  `medical_specialty` VARCHAR(45) NULL COMMENT '',
  `num_lab_procedures` INT NULL COMMENT '',
  `num_procedures` INT NULL COMMENT '',
  `num_medications` INT NULL COMMENT '',
  `number_outpatient` INT NULL COMMENT '',
  `number_emergency` INT NULL COMMENT '',
  `number_inpatient` INT NULL COMMENT '',
  `diag_1` VARCHAR(45) NULL COMMENT '',
  `diag_2` VARCHAR(45) NULL COMMENT '',
  `diag_3` VARCHAR(45) NULL COMMENT '',
  `number_diagnoses` INT NULL COMMENT '',
  `max_glu_serum` VARCHAR(45) NULL COMMENT '',
  `A1Cresult` VARCHAR(45) NULL COMMENT '',
  `metformin` VARCHAR(45) NULL COMMENT '',
  `repaglinide` VARCHAR(45) NULL COMMENT '',
  `nateglinide` VARCHAR(45) NULL COMMENT '',
  `chlorpropamide` VARCHAR(45) NULL COMMENT '',
  `glimepiride` VARCHAR(45) NULL COMMENT '',
  `acetohexamide` VARCHAR(45) NULL COMMENT '',
  `glipizide` VARCHAR(45) NULL COMMENT '',
  `glyburide` VARCHAR(45) NULL COMMENT '',
  `tolbutamide` VARCHAR(45) NULL COMMENT '',
  `pioglitazone` VARCHAR(45) NULL COMMENT '',
  `rosiglitazone` VARCHAR(45) NULL COMMENT '',
  `acarbose` VARCHAR(45) NULL COMMENT '',
  `miglitol` VARCHAR(45) NULL COMMENT '',
  `troglitazone` VARCHAR(45) NULL COMMENT '',
  `tolazamide` VARCHAR(45) NULL COMMENT '',
  `examide` VARCHAR(45) NULL COMMENT '',
  `citoglipton` VARCHAR(45) NULL COMMENT '',
  `insulin` VARCHAR(45) NULL COMMENT '',
  `glyburide-metformin` VARCHAR(45) NULL COMMENT '',
  `glipizide-metformin` VARCHAR(45) NULL COMMENT '',
  `glimepiride-pioglitazone` VARCHAR(45) NULL COMMENT '',
  `metformin-rosiglitazone` VARCHAR(45) NULL COMMENT '',
  `metformin-pioglitazone` VARCHAR(45) NULL COMMENT '',
  `change` VARCHAR(45) NULL COMMENT '',
  `diabetesMed` VARCHAR(45) NULL COMMENT '',
  `readmitted` VARCHAR(45) NULL COMMENT '')
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `diabetes_DWH_staging`.`admission_source` (
  `id` INT NULL COMMENT '',
  `description` VARCHAR(255) NULL COMMENT '')
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `diabetes_DWH_staging`.`admission_type` (
  `id` INT NULL COMMENT '',
  `description` VARCHAR(255) NULL COMMENT '')
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `diabetes_DWH_staging`.`discharge_disposition` (
  `id` INT NULL COMMENT '',
  `description` VARCHAR(255) NULL COMMENT '')
ENGINE = InnoDB;
```

## Step 02 - Extract (Import CSV Dataset) to Staging Area
Use the following query to import data to '*datase*' table. Use absolute path to the '*diabetic_data.csv*' file as `<dataset_directory>/diabetic_data.csv` in the query.
**In windows use '/' characters instead of '\\' as path name separator character** (eg: instead of '*D:\dwh\diabetic_data.csv*' use '*D:/dwh/diabetic_data.csv*')

```sql
USE `diabetes_DWH_staging` ;

LOAD DATA INFILE '<dataset_directory>/diabetic_data.csv'
INTO TABLE `dataset`
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;
```

 > If **secure_file_priv** is enabled copy '*diabetic_data.csv*' file to the directory given by following query and use that path.
> ```sql
> SHOW VARIABLES LIKE "secure_file_priv";
> ```
Check whether all 101766 recoreds are imported with executing the query below.
```sql
SELECT COUNT(*) FROM `dataset`;
```

Import *IDs_mapping_admission_source.csv*, *IDs_mapping_admission_type.csv* and *IDs_mapping_discharge_disposition.csv* files as the same way as below.

```sql
LOAD DATA INFILE '<dataset_directory>/IDs_mapping_admission_source.csv'
INTO TABLE `admission_source`
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

LOAD DATA INFILE '<dataset_directory>/IDs_mapping_admission_type.csv'
INTO TABLE `admission_type`
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

LOAD DATA INFILE '<dataset_directory>/IDs_mapping_discharge_disposition.csv'
INTO TABLE `discharge_disposition`
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;
```

## Step 03 - Create Schema for Data Warehouse
Exucute following query to create database and tables for Data Warehouse as in the Dimensional Model

```sql
DROP SCHEMA IF EXISTS `diabetes_dwh` ;

CREATE SCHEMA IF NOT EXISTS `diabetes_dwh` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `diabetes_dwh` ;

CREATE TABLE IF NOT EXISTS `diabetes_dwh`.`dim_patient` (
  `patient_sk` INT NOT NULL AUTO_INCREMENT COMMENT '',
  `patient_number` VARCHAR(45) NOT NULL COMMENT '',
  `race` VARCHAR(45) NULL COMMENT '',
  `gender` VARCHAR(45) NULL COMMENT '',
  `age` VARCHAR(45) NULL COMMENT '',
  PRIMARY KEY (`patient_sk`)  COMMENT '')
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `diabetes_dwh`.`dim_junk_admissionDetails` (
  `admissionDetail_sk` INT NOT NULL AUTO_INCREMENT COMMENT '',
  `admission_type` VARCHAR(45) NULL COMMENT '',
  `admission_source` VARCHAR(45) NULL COMMENT '',
  `medical_speciality` VARCHAR(45) NULL COMMENT '',
  PRIMARY KEY (`admissionDetail_sk`)  COMMENT '')
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `diabetes_dwh`.`dim_discharge` (
  `discharge_sk` INT NOT NULL AUTO_INCREMENT COMMENT '',
  `discharge_disposition` VARCHAR(45) NULL COMMENT '',
  `readmitted` VARCHAR(45) NULL COMMENT '',
  `payer_code` VARCHAR(45) NULL COMMENT '',
  PRIMARY KEY (`discharge_sk`)  COMMENT '')
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `diabetes_dwh`.`dim_test_results` (
  `test_results_sk` INT NOT NULL AUTO_INCREMENT COMMENT '',
  `glucose_serum_test_result` VARCHAR(45) NULL COMMENT '',
  `a1c_test_results` VARCHAR(45) NULL COMMENT '',
  PRIMARY KEY (`test_result_sk`)  COMMENT '')
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `diabetes_dwh`.`dim_medication` (
  `medication_sk` INT NOT NULL AUTO_INCREMENT COMMENT '',
  `change_of_medication` VARCHAR(45) NULL COMMENT '',
  `diabetes_medicatin` VARCHAR(45) NULL COMMENT '',
  `metformin` VARCHAR(45) NULL COMMENT '',
  `repaglinide` VARCHAR(45) NULL COMMENT '',
  `nateglinide` VARCHAR(45) NULL COMMENT '',
  `chlorpropamide` VARCHAR(45) NULL COMMENT '',
  `glimepiride` VARCHAR(45) NULL COMMENT '',
  `acetohexamide` VARCHAR(45) NULL COMMENT '',
  `glipizide` VARCHAR(45) NULL COMMENT '',
  `tolbutamide` VARCHAR(45) NULL COMMENT '',
  `pioglitazone` VARCHAR(45) NULL COMMENT '',
  `rosiglitazone` VARCHAR(45) NULL COMMENT '',
  `acarbose` VARCHAR(45) NULL COMMENT '',
  `miglitol` VARCHAR(45) NULL COMMENT '',
  `troglitazone` VARCHAR(45) NULL COMMENT '',
  `tolazamide` VARCHAR(45) NULL COMMENT '',
  `examide` VARCHAR(45) NULL COMMENT '',
  `citoglipton` VARCHAR(45) NULL COMMENT '',
  `insulin` VARCHAR(45) NULL COMMENT '',
  `glyburide-metformin` VARCHAR(45) NULL COMMENT '',
  `glipizide-metformin` VARCHAR(45) NULL COMMENT '',
  `glimepiride-pioglitazone` VARCHAR(45) NULL COMMENT '',
  `metformin-rosiglitazone` VARCHAR(45) NULL COMMENT '',
  `metformin-pioglitazone` VARCHAR(45) NULL COMMENT '',
  PRIMARY KEY (`medication_sk`)  COMMENT '')
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `diabetes_dwh`.`dim_junk_diagnosis` (
  `diagnosis_sk` INT NOT NULL AUTO_INCREMENT COMMENT '',
  `diagnosis_1` VARCHAR(45) NULL COMMENT '',
  `diagnosis_2` VARCHAR(45) NULL COMMENT '',
  `diagnosis_3` VARCHAR(45) NULL COMMENT '',
  PRIMARY KEY (`diagnosis_sk`)  COMMENT '')
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `diabetes_dwh`.`fact_admission` (
  `encounter_id` INT NOT NULL AUTO_INCREMENT COMMENT '',
  `patient_sk` INT NOT NULL COMMENT '',
  `test_sk` INT NOT NULL COMMENT '',
  `medication_sk` INT NOT NULL COMMENT '',
  `diagnosis_sk` INT NOT NULL COMMENT '',
  `date_sk` DATETIME NOT NULL COMMENT '',
  `time_in_hospital` VARCHAR(45) NULL COMMENT '',
  `num_lab_procedure` INT NULL COMMENT '',
  `num_procedures` INT NULL COMMENT '',
  `num_medication` INT NULL COMMENT '',
  `number_outpatient` INT NULL COMMENT '',
  `number_emergency` INT NULL COMMENT '',
  `number_inpatient` INT NULL COMMENT '',
  `number_diagnoses` INT NULL COMMENT '',
  PRIMARY KEY (`encounter_id`)  COMMENT '',
  UNIQUE INDEX `patient_sk_UNIQUE` (`patient_sk` ASC)  COMMENT '',
  UNIQUE INDEX `test_sk_UNIQUE` (`test_sk` ASC)  COMMENT '',
  UNIQUE INDEX `medication_sk_UNIQUE` (`medication_sk` ASC)  COMMENT '',
  UNIQUE INDEX `diagnosis_sk_UNIQUE` (`diagnosis_sk` ASC)  COMMENT '',
  UNIQUE INDEX `date_sk_UNIQUE` (`date_sk` ASC)  COMMENT '')
ENGINE = InnoDB;
```

## Step 04 - Data Cleansing
### Cleansing Patient Data

- Select diry data wrt gender of the patient
```sql
CREATE OR REPLACE VIEW `diabetes_dwh_staging`.`dirty_patient_gender` AS
SELECT *
FROM `diabetes_dwh_staging`.`dataset`
WHERE `patient_nbr` in (
	SELECT `patient_nbr`
	FROM `diabetes_dwh_staging`.`dataset`
	WHERE `gender` = 'Female'
) AND `patient_nbr` in (
	SELECT `patient_nbr`
	FROM `diabetes_dwh_staging`.`dataset`
	WHERE `gender` = 'Male'
);

SELECT `encounter_id`, `patient_nbr`, `race`, `gender`
FROM `diabetes_dwh_staging`.`dirty_patient_gender`;
```

There were 7 dirty records with 3 patients and cleaned with selecting most frequent and latest data.
```sql
UPDATE `diabetes_dwh_staging`.`dataset`
SET `gender` = 'Male'
WHERE `patient_nbr` in (55500588, 109210482, 40867677);
```

- Select diry data wrt race of the patient
```sql
SELECT distinct `race`
FROM `diabetes_dwh_staging`.`dataset`;
-- 6 distinct races are found. (Caucasian, AfricanAmerican, ?, Other, Asian, Hispanic)

-- Views to identify dirty data
CREATE OR REPLACE VIEW `diabetes_dwh_staging`.`dirty_patient_race` AS
SELECT `patient_nbr`, count(distinct `race`) as `race_count`
FROM `diabetes_dwh_staging`.`dataset`
group by `patient_nbr` having `race_count` > 1;

SELECT count(`patient_nbr`)
FROM `diabetes_dwh_staging`.`dirty_patient_race`;

SELECT `encounter_id`, `patient_nbr`, `race`
FROM `diabetes_dwh_staging`.`dataset`
WHERE `patient_nbr` in (
	SELECT `patient_nbr`
    FROM `diabetes_dwh_staging`.`dirty_patient_race`
)
ORDER BY `patient_nbr`, `encounter_id`;
```
There were 716 dirty records with 249 patients and cleaned with selecting most frequent and latest data.
```sql
-- Set race as Caucasian
UPDATE `diabetes_dwh_staging`.`dataset`
SET `race` = 'Caucasian'
WHERE `patient_nbr` IN (453267, 1041291);

-- Set race as AfricanAmerican
UPDATE `diabetes_dwh_staging`.`dataset`
SET `race` = 'AfricanAmerican'
WHERE `patient_nbr` IN ('FILL THIS...');

-- Set race as Other
UPDATE `diabetes_dwh_staging`.`dataset`
SET `race` = 'Other'
WHERE `patient_nbr` IN ('FILL THIS...');

-- Set race as Asian
UPDATE `diabetes_dwh_staging`.`dataset`
SET `race` = 'Asian'
WHERE `patient_nbr` IN ('FILL THIS...');

-- Set race as Hispanic
UPDATE `diabetes_dwh_staging`.`dataset`
SET `race` = 'Hispanic'
WHERE `patient_nbr` IN ('FILL THIS...');
```

## Step 05 - Loading Data
### Loading to Patient Dimension
```sql
INSERT INTO `diabetes_dwh`.`dim_patient` (`patient_number`, `race`, `gender`, `age`)
SELECT DISTINCT `patient_nbr`, `race`, `gender`, `age`
FROM `diabetes_dwh_staging`.`dataset`
ORDER BY `patient_nbr`, `age`;
```

### Loading to Test Results Dimension
```sql
INSERT INTO `diabetes_dwh`.`dim_test_results` (`glucose_serum_test_result`, `a1c_test_results`)
SELECT DISTINCT `max_glu_serum`, `A1Cresult`
FROM `diabetes_dwh_staging`.`dataset`;
```

### Loading to Fact
