SELECT distinct `gender`
FROM `diabetes_dwh_staging`.`dataset`;

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

UPDATE `diabetes_dwh_staging`.`dataset`
SET `gender` = 'Male'
WHERE `patient_nbr` in (55500588, 109210482, 40867677);