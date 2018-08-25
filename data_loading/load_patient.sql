INSERT INTO `diabetes_dwh`.`dim_patient` (`patient_number`, `race`, `gender`, `age`)
SELECT DISTINCT `patient_nbr`, `race`, `gender`, `age`
FROM `diabetes_dwh_staging`.`dataset`
ORDER BY `patient_nbr`, `age`;

SELECT *
FROM `diabetes_dwh`.`dim_patient`
WHERE `patient_sk` = 62;