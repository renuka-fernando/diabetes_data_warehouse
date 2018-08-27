DELETE FROM `diabetes_dwh_staging`.`dataset_modified`
WHERE `payer_code` = '?';

DELETE FROM `diabetes_dwh_staging`.`dataset_modified`
WHERE `medical_specialty` = '?';

DELETE FROM `diabetes_dwh_staging`.`dataset_modified`
WHERE `race` = '?';

DELETE FROM `diabetes_dwh_staging`.`dataset_modified`
WHERE `diag_1` = '?';

DELETE FROM `diabetes_dwh_staging`.`dataset_modified`
WHERE `diag_2` = '?';

DELETE FROM `diabetes_dwh_staging`.`dataset_modified`
WHERE `diag_3` = '?';

SELECT COUNT(*) FROM `diabetes_dwh_staging`.`dataset_modified`;