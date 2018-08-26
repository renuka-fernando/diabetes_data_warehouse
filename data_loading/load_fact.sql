SELECT `stg`.`encounter_id`,
	`patient`.`patient_sk`, `test`.`test_results_sk`,
    `stg`.`time_in_hospital`, `stg`.`num_lab_procedures`
FROM `diabetes_dwh_staging`.`dataset` as `stg`,
	`diabetes_dwh`.`dim_patient` as `patient`, 
    `diabetes_dwh`.`dim_test_results` as `test`
WHERE `stg`.`patient_nbr` = `patient`.`patient_number` AND `stg`.`age` = `patient`.`age`
	AND `test`.`glucose_serum_test_result` = `stg`.`max_glu_serum` AND `test`.`a1c_test_results` = `stg`.`A1Cresult`;