SELECT distinct `race`
FROM `diabetes_dwh_staging`.`dataset`;
-- 6 distinct races are found. (Caucasian, AfricanAmerican, ?, Other, Asian, Hispanic)

-- Views to identify dirty data
CREATE OR REPLACE VIEW `diabetes_dwh_staging`.`dirty_patient_race` AS
SELECT `patient_nbr`, count(distinct `race`) as `race_count`
FROM `diabetes_dwh_staging`.`dataset`
group by `patient_nbr` having `race_count` > 1;

SELECT count(`patient_nbr`)
FROM `diabetes_dwh_staging`.`dirty_patient_race`;

SELECT `encounter_id`, `patient_nbr`, `race`
FROM `diabetes_dwh_staging`.`dataset`
WHERE `patient_nbr` in (
	SELECT `patient_nbr`
    FROM `diabetes_dwh_staging`.`dirty_patient_race`
)
ORDER BY `patient_nbr`, `encounter_id`;

-- Set race as Caucasian
UPDATE `diabetes_dwh_staging`.`dataset`
SET `race` = 'Caucasian'
WHERE `patient_nbr` IN (1553220, 'FILL THIS...');

-- Set race as AfricanAmerican
UPDATE `diabetes_dwh_staging`.`dataset`
SET `race` = 'AfricanAmerican'
WHERE `patient_nbr` IN (6919587, 'FILL THIS...');

-- Set race as Other
UPDATE `diabetes_dwh_staging`.`dataset`
SET `race` = 'Other'
WHERE `patient_nbr` IN ('FILL THIS...');

-- Set race as Asian
UPDATE `diabetes_dwh_staging`.`dataset`
SET `race` = 'Asian'
WHERE `patient_nbr` IN ('FILL THIS...');

-- Set race as Hispanic
UPDATE `diabetes_dwh_staging`.`dataset`
SET `race` = 'Hispanic'
WHERE `patient_nbr` IN ('FILL THIS...');