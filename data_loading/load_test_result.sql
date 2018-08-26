INSERT INTO `diabetes_dwh`.`dim_test_results` (`glucose_serum_test_result`, `a1c_test_results`)
SELECT DISTINCT `max_glu_serum`, `A1Cresult`
FROM `diabetes_dwh_staging`.`dataset_modified`;

SELECT *
FROM `diabetes_dwh`.`dim_test_results`
WHERE `test_results_sk` = 3;