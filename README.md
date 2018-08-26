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
  `diag_1` VARCHAR(200) NULL COMMENT '',
  `diag_2` VARCHAR(200) NULL COMMENT '',
  `diag_3` VARCHAR(200) NULL COMMENT '',
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
  `primary_diagnosis` VARCHAR(200) NULL COMMENT '',
  `secondary_diagnosis` VARCHAR(200) NULL COMMENT '',
  `additional_diagnosis` VARCHAR(200) NULL COMMENT '',
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
### Store Modified Changes
```sql
CREATE TABLE IF NOT EXISTS `diabetes_DWH_staging`.`dataset_modified` (
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
  `diag_1` VARCHAR(200) NULL COMMENT '',
  `diag_2` VARCHAR(200) NULL COMMENT '',
  `diag_3` VARCHAR(200) NULL COMMENT '',
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
```

```sql
INSERT INTO `diabetes_DWH_staging`.`dataset_modified`
SELECT * FROM `diabetes_DWH_staging`.`dataset`;
```

### Horizontal Filtering
Some importants attributes that should be considered are missing in the dataset. Lets discard them.
```sql
DELETE FROM `diabetes_dwh_staging`.`dataset`
WHERE `payer_code` = '?';

DELETE FROM `diabetes_dwh_staging`.`dataset`
WHERE `medical_specialty` = '?';

DELETE FROM `diabetes_dwh_staging`.`dataset`
WHERE `race` = '?';

DELETE FROM `diabetes_dwh_staging`.`dataset`
WHERE `diag_1` = '?';

DELETE FROM `diabetes_dwh_staging`.`dataset`
WHERE `diag_2` = '?';

DELETE FROM `diabetes_dwh_staging`.`dataset`
WHERE `diag_3` = '?';

SELECT COUNT(*) FROM `diabetes_dwh_staging`.`dataset`;
```
We have 26755 data records.

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
There were 167 dirty records with 51 patients and cleaned with selecting most frequent and latest data.
```sql
-- Set race as Caucasian
UPDATE `diabetes_dwh_staging`.`dataset`
SET `race` = 'Caucasian'
WHERE `patient_nbr` IN (1553220, 23724792, 38893887, 42246738, 52316388, 112367349);

-- Set race as AfricanAmerican
UPDATE `diabetes_dwh_staging`.`dataset`
SET `race` = 'AfricanAmerican'
WHERE `patient_nbr` IN (6919587, 10980891, 40090752, 54643194, 101753730, 107849052);

-- Set race as Other
UPDATE `diabetes_dwh_staging`.`dataset`
SET `race` = 'Other'
WHERE `patient_nbr` IN (28532295, 30689766, 32314608, 33247647, 36967347, 37547937, 37638306, 38774187, 39160719, 42096384, 90817893, 93105117, 93662784, 94027644, 98584524, 100322946, 103228398, 103690161, 105125598, 106425234);

-- Set race as Asian
UPDATE `diabetes_dwh_staging`.`dataset`
SET `race` = 'Asian'
WHERE `patient_nbr` IN (24332220, 31812075, 34248078, 94539465, 97024806, 103305528, 104622570, 110657970, 111534210);

-- Set race as Hispanic
UPDATE `diabetes_dwh_staging`.`dataset`
SET `race` = 'Hispanic'
WHERE `patient_nbr` IN (37572957, 44744166, 45113778, 90035874, 91107549, 93809358, 94088088, 98934615, 106895331, 109448541);
```

## Step 05 - Transforming
Transform primary, secondary and additional diagnosis based on "**International Statistical Classification of Diseases and Related Health Problems**"
- Visit http://icd9.chrisendres.com/index.php?action=contents for Diseases and Injuries Tabular Index

Values are stored to the file **data_transforming/diseases_and_injuries_tabular_index.csv**.

| id | disease                                                                                            | code_letter | code_from | code_to |
|----|----------------------------------------------------------------------------------------------------|-------------|-----------|---------|
|  1 | INFECTIOUS AND PARASITIC DISEASES                                                                  |             |         1 |     139 |
|  2 | NEOPLASMS                                                                                          |             |       140 |     239 |
|  3 | ENDOCRINE, NUTRITIONAL AND METABOLIC DISEASES, AND IMMUNITY DISORDERS                              |             |       240 |     279 |
|  4 | DISEASES OF THE BLOOD AND BLOOD-FORMING ORGANS                                                     |             |       280 |     289 |
|  5 | MENTAL DISORDERS                                                                                   |             |       290 |     319 |
|  6 | DISEASES OF THE NERVOUS SYSTEM AND SENSE ORGANS                                                    |             |       320 |     389 |
|  7 | DISEASES OF THE CIRCULATORY SYSTEM                                                                 |             |       390 |     459 |
|  8 | DISEASES OF THE RESPIRATORY SYSTEM                                                                 |             |       460 |     519 |
|  9 | DISEASES OF THE DIGESTIVE SYSTEM                                                                   |             |       520 |     579 |
| 10 | DISEASES OF THE GENITOURINARY SYSTEM                                                               |             |       580 |     629 |
| 11 | COMPLICATIONS OF PREGNANCY, CHILDBIRTH, AND THE PUERPERIUM                                         |             |       630 |     679 |
| 12 | DISEASES OF THE SKIN AND SUBCUTANEOUS TISSUE                                                       |             |       680 |     709 |
| 13 | DISEASES OF THE MUSCULOSKELETAL SYSTEM AND CONNECTIVE TISSUE                                       |             |       710 |     739 |
| 14 | CONGENITAL ANOMALIES                                                                               |             |       740 |     759 |
| 15 | CERTAIN CONDITIONS ORIGINATING IN THE PERINATAL PERIOD                                             |             |       760 |     779 |
| 16 | SYMPTOMS, SIGNS, AND ILL-DEFINED CONDITIONS                                                        |             |       780 |     799 |
| 17 | INJURY AND POISONING                                                                               |             |       800 |     999 |
| 18 | SUPPLEMENTARY CLASSIFICATION OF FACTORS INFLUENCING HEALTH STATUS AND CONTACT WITH HEALTH SERVICES | V           |         1 |      89 |
| 19 | SUPPLEMENTARY CLASSIFICATION OF EXTERNAL CAUSES OF INJURY AND POISONING                            | E           |       800 |     999 |

Transforming
```sql
DROP PROCEDURE IF EXISTS `diabetes_dwh_staging`.`TRANSFORM_ICD9`;
DELIMITER ;;

CREATE PROCEDURE `diabetes_dwh_staging`.`TRANSFORM_ICD9`()
BEGIN

DECLARE n INT DEFAULT 0;
DECLARE i INT DEFAULT 0;

-- Transform other values (starts with V and E)
-- Transform "diag_1" values
UPDATE `diabetes_dwh_staging`.`dataset_modified`
SET `diag_1` = (
	SELECT `disease`
    FROM `diabetes_dwh_staging`.`icd9_index`
    WHERE `code_letter` = 'V'
)
WHERE LEFT(`diag_1`, 1) = 'V';

UPDATE `diabetes_dwh_staging`.`dataset_modified`
SET `diag_1` = (
	SELECT `disease`
    FROM `diabetes_dwh_staging`.`icd9_index`
    WHERE `code_letter` = 'E'
)
WHERE LEFT(`diag_1`, 1) = 'E';

-- Transform "diag_2" values
UPDATE `diabetes_dwh_staging`.`dataset_modified`
SET `diag_2` = (
	SELECT `disease`
    FROM `diabetes_dwh_staging`.`icd9_index`
    WHERE `code_letter` = 'V'
)
WHERE LEFT(`diag_2`, 1) = 'V';

UPDATE `diabetes_dwh_staging`.`dataset_modified`
SET `diag_2` = (
	SELECT `disease`
    FROM `diabetes_dwh_staging`.`icd9_index`
    WHERE `code_letter` = 'E'
)
WHERE LEFT(`diag_2`, 1) = 'E';

-- Transform "diag_3" values
UPDATE `diabetes_dwh_staging`.`dataset_modified`
SET `diag_3` = (
	SELECT `disease`
    FROM `diabetes_dwh_staging`.`icd9_index`
    WHERE `code_letter` = 'V'
)
WHERE LEFT(`diag_3`, 1) = 'V';

UPDATE `diabetes_dwh_staging`.`dataset_modified`
SET `diag_3` = (
	SELECT `disease`
    FROM `diabetes_dwh_staging`.`icd9_index`
    WHERE `code_letter` = 'E'
)
WHERE LEFT(`diag_3`, 1) = 'E';


-- Transform values with digits only
SELECT COUNT(*) FROM `diabetes_dwh_staging`.`icd9_index`
WHERE `code_letter` = ''
INTO n;

SET i = 0;
WHILE i < n DO 
	-- Transform "diag_1" values
	UPDATE `diabetes_dwh_staging`.`dataset_modified`
    SET `diag_1` = (
		SELECT `disease`
        FROM `diabetes_dwh_staging`.`icd9_index`
        LIMIT i, 1
	)
    WHERE `diag_1` REGEXP '^[0-9]+\\.?[0-9]*$' AND (
		`diag_1` >= (
			SELECT `code_from`
            FROM `diabetes_dwh_staging`.`icd9_index`
            LIMIT i, 1
		) AND
		`diag_1` <= (
			SELECT `code_to`
            FROM `diabetes_dwh_staging`.`icd9_index`
            LIMIT i, 1
		)
	);
    
	-- Transform "diag_2" values
	UPDATE `diabetes_dwh_staging`.`dataset_modified` SET `diag_2` = (
		SELECT `disease`
        FROM `diabetes_dwh_staging`.`icd9_index`
        LIMIT i, 1
	)
    WHERE `diag_2` REGEXP '^[0-9]+\\.?[0-9]*$' AND (
		`diag_2` >= (
			SELECT `code_from`
            FROM `diabetes_dwh_staging`.`icd9_index`
            LIMIT i, 1
		) AND
		`diag_2` <= (
			SELECT `code_to`
            FROM `diabetes_dwh_staging`.`icd9_index`
            LIMIT i, 1
		)
	);
    
    -- Transform "diag_3" values
	UPDATE `diabetes_dwh_staging`.`dataset_modified` SET `diag_3` = (
		SELECT `disease`
        FROM `diabetes_dwh_staging`.`icd9_index`
        LIMIT i, 1
	)
    WHERE `diag_3` REGEXP '^[0-9]+\\.?[0-9]*$' AND (
		`diag_3` >= (
			SELECT `code_from`
			FROM `diabetes_dwh_staging`.`icd9_index`
			LIMIT i, 1
        ) AND
		`diag_3` <= (
			SELECT `code_to`
			FROM `diabetes_dwh_staging`.`icd9_index`
			LIMIT i, 1
        )
	);
  SET i = i + 1;
END WHILE;

END;;

DELIMITER ;
CALL `diabetes_dwh_staging`.`TRANSFORM_ICD9`();
```

Transform **Admission Type, Discharge Disposition, Admission Source** with given mapping data set. One procedure will takes around 30 seconds to execute.

```sql
DROP PROCEDURE IF EXISTS `diabetes_dwh_staging`.`TRANSFORM_ADMISSION_TYPE`;
DROP PROCEDURE IF EXISTS `diabetes_dwh_staging`.`TRANSFORM_ADMISSION_SOURCE`;
DROP PROCEDURE IF EXISTS `diabetes_dwh_staging`.`TRANSFORM_DISCHARGE_DISPOSITION`;
DELIMITER ;;

-- Admission Type
CREATE PROCEDURE `diabetes_dwh_staging`.`TRANSFORM_ADMISSION_TYPE`()
BEGIN

DECLARE n INT DEFAULT 0;
DECLARE i INT DEFAULT 1;

SET n = (SELECT COUNT(*) FROM `diabetes_dwh_staging`.`admission_type`);
-- Add the column
ALTER TABLE `diabetes_dwh_staging`.`dataset_modified`
ADD COLUMN `admission_type` VARCHAR(150);

WHILE i <= n DO
	UPDATE `diabetes_dwh_staging`.`dataset_modified`
    SET `admission_type` = (
		SELECT `description` FROM `diabetes_dwh_staging`.`admission_type` WHERE `id` = i
    )
    WHERE `admission_type_id` = i;
    SET i = i + 1;
END WHILE;

ALTER TABLE `diabetes_dwh_staging`.`dataset_modified`
DROP COLUMN `admission_type_id`;
END;;

-- Admission Source
CREATE PROCEDURE `diabetes_dwh_staging`.`TRANSFORM_ADMISSION_SOURCE`()
BEGIN

DECLARE n INT DEFAULT 0;
DECLARE i INT DEFAULT 1;

SET n = (SELECT COUNT(*) FROM `diabetes_dwh_staging`.`admission_source`);
-- Add the column
ALTER TABLE `diabetes_dwh_staging`.`dataset_modified`
ADD COLUMN `admission_source` VARCHAR(150);

WHILE i <= n DO
	UPDATE `diabetes_dwh_staging`.`dataset_modified`
    SET `admission_source` = (
		SELECT `description` FROM `diabetes_dwh_staging`.`admission_source` WHERE `id` = i
    )
    WHERE `admission_source_id` = i;
    SET i = i + 1;
END WHILE;

ALTER TABLE `diabetes_dwh_staging`.`dataset_modified`
DROP COLUMN `admission_source_id`;
END;;

-- Discharge Disposition
CREATE PROCEDURE `diabetes_dwh_staging`.`TRANSFORM_DISCHARGE_DISPOSITION`()
BEGIN

DECLARE n INT DEFAULT 0;
DECLARE i INT DEFAULT 1;

SET n = (SELECT COUNT(*) FROM `diabetes_dwh_staging`.`discharge_disposition`);
-- Add the column
ALTER TABLE `diabetes_dwh_staging`.`dataset_modified`
ADD COLUMN `discharge_disposition` VARCHAR(150);

WHILE i <= n DO
	UPDATE `diabetes_dwh_staging`.`dataset_modified`
    SET `discharge_disposition` = (
		SELECT `description` FROM `diabetes_dwh_staging`.`discharge_disposition` WHERE `id` = i
    )
    WHERE `discharge_disposition_id` = i;
    SET i = i + 1;
END WHILE;

ALTER TABLE `diabetes_dwh_staging`.`dataset_modified`
DROP COLUMN `discharge_disposition_id`;
END;;

DELIMITER ;
CALL `diabetes_dwh_staging`.`TRANSFORM_ADMISSION_TYPE`();
CALL `diabetes_dwh_staging`.`TRANSFORM_ADMISSION_SOURCE`();
CALL `diabetes_dwh_staging`.`TRANSFORM_DISCHARGE_DISPOSITION`();

```

## Step 06 - Loading Data
### 6.1 Loading to Patient Dimension
```sql
INSERT INTO `diabetes_dwh`.`dim_patient` (`patient_number`, `race`, `gender`, `age`)
SELECT DISTINCT `patient_nbr`, `race`, `gender`, `age`
FROM `diabetes_dwh_staging`.`dataset_modified`
ORDER BY `patient_nbr`, `age`;
```

### 6.2 Loading to Test Results Dimension
```sql
INSERT INTO `diabetes_dwh`.`dim_test_results` (`glucose_serum_test_result`, `a1c_test_results`)
SELECT DISTINCT `max_glu_serum`, `A1Cresult`
FROM `diabetes_dwh_staging`.`dataset_modified`;
```

### 6.3 Loading to Diagnosis Junk Dimension
This query may take several miniutes (~5min) to execute and may produce 6859 rows.
```sql
DROP PROCEDURE IF EXISTS `diabetes_dwh`.`fill_diagnosis_junk`;
DELIMITER ;;

CREATE PROCEDURE `diabetes_dwh`.`fill_diagnosis_junk`()
BEGIN

DECLARE n INT DEFAULT 0;
DECLARE i INT DEFAULT 0;
DECLARE j INT DEFAULT 0;
DECLARE k INT DEFAULT 0;

DECLARE pri VARCHAR(200);
DECLARE sec VARCHAR(200);
DECLARE alt VARCHAR(200);

SELECT COUNT(*) FROM `diabetes_DWH_staging`.`icd9_index` INTO n;
DELETE FROM `diabetes_dwh`.`dim_junk_diagnosis`;

WHILE i < n DO
  SET j = 0;
  SELECT `disease` FROM `diabetes_DWH_staging`.`icd9_index` LIMIT i, 1 INTO pri;
    
  WHILE j < n DO
    SET k = 0;
    SELECT `disease` FROM `diabetes_DWH_staging`.`icd9_index` LIMIT j, 1 INTO sec;
        
    WHILE k < n DO
      SELECT `disease` FROM `diabetes_DWH_staging`.`icd9_index` LIMIT k, 1 INTO alt;
        
      INSERT INTO `diabetes_dwh`.`dim_junk_diagnosis`
        (`primary_diagnosis`, `secondary_diagnosis`, `additional_diagnosis`)
      VALUES (pri, sec, alt);
            
      SET k = k + 1;
    END WHILE;
        
    SET j = j + 1;
  END WHILE;
    
  SET i = i + 1;
END WHILE;

END;;

DELIMITER ;
CALL `diabetes_dwh`.`fill_diagnosis_junk`();

SELECT COUNT(*) FROM `diabetes_dwh`.`dim_junk_diagnosis`;
```

### Loading to Fact
