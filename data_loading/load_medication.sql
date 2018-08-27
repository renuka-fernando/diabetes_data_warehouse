INSERT INTO `diabetes_dwh`.`dim_medication` (
	`change_of_medication`, `diabetes_medicatin`, `metformin`, `repaglinide`,
    `nateglinide`, `chlorpropamide`, `glimepiride`, `acetohexamide`, `glipizide`,
    `tolbutamide`, `pioglitazone`, `rosiglitazone`, `acarbose`, `miglitol`,
    `troglitazone`, `tolazamide`, `examide`, `citoglipton`, `insulin`,
    `glyburide-metformin`, `glipizide-metformin`, `glimepiride-pioglitazone`,
    `metformin-rosiglitazone`, `metformin-pioglitazone`
)
SELECT DISTINCT `change`, `diabetesMed`, `metformin`,
	`repaglinide`, `nateglinide`, `chlorpropamide`, `glimepiride`, `acetohexamide`,
    `glipizide`, `tolbutamide`, `pioglitazone`, `rosiglitazone`, `acarbose`,
    `miglitol`, `troglitazone`, `tolazamide`, `examide`, `citoglipton`, `insulin`,
    `glyburide-metformin`, `glipizide-metformin`, `glimepiride-pioglitazone`,
    `metformin-rosiglitazone`, `metformin-pioglitazone`
FROM `diabetes_dwh_staging`.`dataset_modified`;

SELECT COUNT(*) FROM `diabetes_dwh`.`dim_medication`;