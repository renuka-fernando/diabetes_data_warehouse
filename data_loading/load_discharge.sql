INSERT INTO `diabetes_dwh`.`dim_discharge` (`discharge_disposition`, `readmitted`, `payer_code`)
SELECT DISTINCT `discharge_disposition`, `readmitted`, `payer_code`
FROM `diabetes_dwh_staging`.`dataset_modified`;

SELECT COUNT(*) FROM `diabetes_dwh`.`dim_discharge`;