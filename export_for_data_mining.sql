SELECT 'race', 'gender', 'age', 'admission_type',
	'discharge_disposition', 'admission_source', 'time_in_hospital', 'payer_code',
    'medical_specialty', 'num_lab_procedures', 'num_procedures', 'num_medications',
    'number_outpatient', 'number_emergency', 'number_inpatient', 'diag_1', 'diag_2',
    'diag_3', 'number_diagnoses', 'max_glu_serum', 'A1Cresult', 'metformin', 'repaglinide',
    'nateglinide', 'chlorpropamide', 'glimepiride', 'acetohexamide', 'glipizide',
    'glyburide', 'tolbutamide', 'pioglitazone', 'rosiglitazone', 'acarbose', 'miglitol',
    'troglitazone', 'tolazamide', 'examide', 'citoglipton', 'insulin', 'glyburide-metformin',
    'glipizide-metformin', 'glimepiride-pioglitazone', 'metformin-rosiglitazone',
    'metformin-pioglitazone', 'change', 'diabetesMed', 'readmitted'
UNION
SELECT `race`, `gender`, `age_int`, `admission_type`,
	`discharge_disposition`, `admission_source`, `time_in_hospital`, `payer_code`,
    `medical_specialty`, `num_lab_procedures`, `num_procedures`, `num_medications`,
    `number_outpatient`, `number_emergency`, `number_inpatient`, `diag_1`, `diag_2`,
    `diag_3`, `number_diagnoses`, `max_glu_serum`, `A1Cresult`, `metformin`, `repaglinide`,
    `nateglinide`, `chlorpropamide`, `glimepiride`, `acetohexamide`, `glipizide`,
    `glyburide`, `tolbutamide`, `pioglitazone`, `rosiglitazone`, `acarbose`, `miglitol`,
    `troglitazone`, `tolazamide`, `examide`, `citoglipton`, `insulin`, `glyburide-metformin`,
    `glipizide-metformin`, `glimepiride-pioglitazone`, `metformin-rosiglitazone`,
    `metformin-pioglitazone`, `change`, `diabetesMed`, `readmitted`
FROM `diabetes_dwh_staging`.`dataset_modified`
INTO OUTFILE 'D:/data_set.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';