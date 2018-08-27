INSERT INTO `diabetes_dwh`.`dim_junk_admissionDetails` (`admission_type`, `admission_source`, `medical_speciality`)
SELECT DISTINCT `admission_type`, `admission_source`, `medical_specialty`
FROM `diabetes_dwh_staging`.`dataset_modified`;

SELECT COUNT(*) FROM `diabetes_dwh`.`dim_junk_admissionDetails`;