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