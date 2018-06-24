# Data Warehouse of Diabetic Data
Dataset URL - https://archive.ics.uci.edu/ml/datasets/Diabetes+130-US+hospitals+for+years+1999-2008

## Files
- data_warehouse.mwb - MySQL Workbench model file
- dimensional_modeling/dimentional_design.xml - Draw.io file

# Dimensional Model //TODO: update diagram
![Dimensional Model of Data Warehouse](dimensional_modeling/dimentional_design.png)

# Build Data Warehouse
## Step 01 - Create Database and Tables for staging area of Data Warehouse
Use following query to create the database named '*diabetes_dwh_staging*' and tables
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

## Step 02 - Extract (Import CSV Dataset to MySQL Database) to Staging Area
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