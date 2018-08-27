SELECT DISTINCT `gender`
FROM `diabetes_dwh_staging`.`dataset_modified`;

CREATE OR REPLACE VIEW `diabetes_dwh_staging`.`dirty_patient_gender` AS
SELECT *
FROM `diabetes_dwh_staging`.`dataset_modified`
WHERE `patient_nbr` in (
	SELECT `patient_nbr`
	FROM `diabetes_dwh_staging`.`dataset_modified`
	WHERE `gender` = 'Female'
) AND `patient_nbr` in (
	SELECT `patient_nbr`
	FROM `diabetes_dwh_staging`.`dataset_modified`
	WHERE `gender` = 'Male'
);

SELECT `encounter_id`, `patient_nbr`, `race`, `gender`
FROM `diabetes_dwh_staging`.`dirty_patient_gender`;

UPDATE `diabetes_dwh_staging`.`dataset_modified`
SET `gender` = 'Male'
WHERE `patient_nbr` = 109210482;