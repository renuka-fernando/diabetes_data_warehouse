INSERT INTO `diabetes_dwh`.`dim_junk_diagnosis` (`primary_diagnosis`, `secondary_diagnosis`, `additional_diagnosis`)
SELECT DISTINCT `diag_1`, `diag_2`, `diag_3`
FROM `diabetes_dwh_staging`.`dataset_modified`;

SELECT COUNT(*) FROM `diabetes_dwh`.`dim_junk_diagnosis`;