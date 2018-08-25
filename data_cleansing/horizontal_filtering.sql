DELETE FROM `diabetes_dwh_staging`.`dataset`
WHERE `payer_code` = '?';

DELETE FROM `diabetes_dwh_staging`.`dataset`
WHERE `medical_specialty` = '?';

DELETE FROM `diabetes_dwh_staging`.`dataset`
WHERE `race` = '?';