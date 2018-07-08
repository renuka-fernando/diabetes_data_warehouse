SELECT distinct `race`
FROM `diabetes_dwh_staging`.`dataset`;
-- 6 distinct races are found. (Caucasian, AfricanAmerican, ?, Other, Asian, Hispanic)

-- Views to identify dirty data
-- 1. Caucasian and AfricanAmerican
CREATE OR REPLACE VIEW `diabetes_dwh_staging`.`dirty_patient_race_1` AS
SELECT *
FROM `diabetes_dwh_staging`.`dataset`
WHERE `patient_nbr` in (
	SELECT `patient_nbr`
	FROM `diabetes_dwh_staging`.`dataset`
	WHERE `race` = 'Caucasian'
) AND `patient_nbr` in (
	SELECT `patient_nbr`
	FROM `diabetes_dwh_staging`.`dataset`
	WHERE `race` = 'AfricanAmerican'
)
ORDER BY `patient_nbr`, `encounter_id`;

-- 2. Caucasian and ?
CREATE OR REPLACE VIEW `diabetes_dwh_staging`.`dirty_patient_race_2` AS
SELECT *
FROM `diabetes_dwh_staging`.`dataset`
WHERE `patient_nbr` in (
	SELECT `patient_nbr`
	FROM `diabetes_dwh_staging`.`dataset`
	WHERE `race` = 'Caucasian'
) AND `patient_nbr` in (
	SELECT `patient_nbr`
	FROM `diabetes_dwh_staging`.`dataset`
	WHERE `race` = '?'
)
ORDER BY `patient_nbr`, `encounter_id`;

-- 3. Caucasian and Other
CREATE OR REPLACE VIEW `diabetes_dwh_staging`.`dirty_patient_race_3` AS
SELECT *
FROM `diabetes_dwh_staging`.`dataset`
WHERE `patient_nbr` in (
	SELECT `patient_nbr`
	FROM `diabetes_dwh_staging`.`dataset`
	WHERE `race` = 'Caucasian'
) AND `patient_nbr` in (
	SELECT `patient_nbr`
	FROM `diabetes_dwh_staging`.`dataset`
	WHERE `race` = 'Other'
)
ORDER BY `patient_nbr`, `encounter_id`;

-- 4. Caucasian and Asian
CREATE OR REPLACE VIEW `diabetes_dwh_staging`.`dirty_patient_race_4` AS
SELECT *
FROM `diabetes_dwh_staging`.`dataset`
WHERE `patient_nbr` in (
	SELECT `patient_nbr`
	FROM `diabetes_dwh_staging`.`dataset`
	WHERE `race` = 'Caucasian'
) AND `patient_nbr` in (
	SELECT `patient_nbr`
	FROM `diabetes_dwh_staging`.`dataset`
	WHERE `race` = 'Asian'
)
ORDER BY `patient_nbr`, `encounter_id`;

-- 5. Caucasian and Hispanic
CREATE OR REPLACE VIEW `diabetes_dwh_staging`.`dirty_patient_race_5` AS
SELECT *
FROM `diabetes_dwh_staging`.`dataset`
WHERE `patient_nbr` in (
	SELECT `patient_nbr`
	FROM `diabetes_dwh_staging`.`dataset`
	WHERE `race` = 'Caucasian'
) AND `patient_nbr` in (
	SELECT `patient_nbr`
	FROM `diabetes_dwh_staging`.`dataset`
	WHERE `race` = 'Hispanic'
)
ORDER BY `patient_nbr`, `encounter_id`;

-- 6. AfricanAmerican and ?
CREATE OR REPLACE VIEW `diabetes_dwh_staging`.`dirty_patient_race_6` AS
SELECT *
FROM `diabetes_dwh_staging`.`dataset`
WHERE `patient_nbr` in (
	SELECT `patient_nbr`
	FROM `diabetes_dwh_staging`.`dataset`
	WHERE `race` = 'AfricanAmerican'
) AND `patient_nbr` in (
	SELECT `patient_nbr`
	FROM `diabetes_dwh_staging`.`dataset`
	WHERE `race` = '?'
)
ORDER BY `patient_nbr`, `encounter_id`;

-- 7. AfricanAmerican and Other
CREATE OR REPLACE VIEW `diabetes_dwh_staging`.`dirty_patient_race_7` AS
SELECT *
FROM `diabetes_dwh_staging`.`dataset`
WHERE `patient_nbr` in (
	SELECT `patient_nbr`
	FROM `diabetes_dwh_staging`.`dataset`
	WHERE `race` = 'AfricanAmerican'
) AND `patient_nbr` in (
	SELECT `patient_nbr`
	FROM `diabetes_dwh_staging`.`dataset`
	WHERE `race` = 'Other'
)
ORDER BY `patient_nbr`, `encounter_id`;

-- 8. AfricanAmerican and Asian
CREATE OR REPLACE VIEW `diabetes_dwh_staging`.`dirty_patient_race_8` AS
SELECT *
FROM `diabetes_dwh_staging`.`dataset`
WHERE `patient_nbr` in (
	SELECT `patient_nbr`
	FROM `diabetes_dwh_staging`.`dataset`
	WHERE `race` = 'AfricanAmerican'
) AND `patient_nbr` in (
	SELECT `patient_nbr`
	FROM `diabetes_dwh_staging`.`dataset`
	WHERE `race` = 'Asian'
)
ORDER BY `patient_nbr`, `encounter_id`;

-- 9. AfricanAmerican and Hispanic
CREATE OR REPLACE VIEW `diabetes_dwh_staging`.`dirty_patient_race_9` AS
SELECT *
FROM `diabetes_dwh_staging`.`dataset`
WHERE `patient_nbr` in (
	SELECT `patient_nbr`
	FROM `diabetes_dwh_staging`.`dataset`
	WHERE `race` = 'AfricanAmerican'
) AND `patient_nbr` in (
	SELECT `patient_nbr`
	FROM `diabetes_dwh_staging`.`dataset`
	WHERE `race` = 'Hispanic'
)
ORDER BY `patient_nbr`, `encounter_id`;

-- 10. ? and Other
CREATE OR REPLACE VIEW `diabetes_dwh_staging`.`dirty_patient_race_10` AS
SELECT *
FROM `diabetes_dwh_staging`.`dataset`
WHERE `patient_nbr` in (
	SELECT `patient_nbr`
	FROM `diabetes_dwh_staging`.`dataset`
	WHERE `race` = '?'
) AND `patient_nbr` in (
	SELECT `patient_nbr`
	FROM `diabetes_dwh_staging`.`dataset`
	WHERE `race` = 'Other'
)
ORDER BY `patient_nbr`, `encounter_id`;

-- 11. ? and Asian
CREATE OR REPLACE VIEW `diabetes_dwh_staging`.`dirty_patient_race_11` AS
SELECT *
FROM `diabetes_dwh_staging`.`dataset`
WHERE `patient_nbr` in (
	SELECT `patient_nbr`
	FROM `diabetes_dwh_staging`.`dataset`
	WHERE `race` = '?'
) AND `patient_nbr` in (
	SELECT `patient_nbr`
	FROM `diabetes_dwh_staging`.`dataset`
	WHERE `race` = 'Asian'
)
ORDER BY `patient_nbr`, `encounter_id`;

-- 12. ? and Hispanic
CREATE OR REPLACE VIEW `diabetes_dwh_staging`.`dirty_patient_race_12` AS
SELECT *
FROM `diabetes_dwh_staging`.`dataset`
WHERE `patient_nbr` in (
	SELECT `patient_nbr`
	FROM `diabetes_dwh_staging`.`dataset`
	WHERE `race` = '?'
) AND `patient_nbr` in (
	SELECT `patient_nbr`
	FROM `diabetes_dwh_staging`.`dataset`
	WHERE `race` = 'Hispanic'
)
ORDER BY `patient_nbr`, `encounter_id`;

-- 13. Other and Asian
CREATE OR REPLACE VIEW `diabetes_dwh_staging`.`dirty_patient_race_13` AS
SELECT *
FROM `diabetes_dwh_staging`.`dataset`
WHERE `patient_nbr` in (
	SELECT `patient_nbr`
	FROM `diabetes_dwh_staging`.`dataset`
	WHERE `race` = 'Other'
) AND `patient_nbr` in (
	SELECT `patient_nbr`
	FROM `diabetes_dwh_staging`.`dataset`
	WHERE `race` = 'Asian'
)
ORDER BY `patient_nbr`, `encounter_id`;

-- 14. Other and Hispanic
CREATE OR REPLACE VIEW `diabetes_dwh_staging`.`dirty_patient_race_14` AS
SELECT *
FROM `diabetes_dwh_staging`.`dataset`
WHERE `patient_nbr` in (
	SELECT `patient_nbr`
	FROM `diabetes_dwh_staging`.`dataset`
	WHERE `race` = 'Other'
) AND `patient_nbr` in (
	SELECT `patient_nbr`
	FROM `diabetes_dwh_staging`.`dataset`
	WHERE `race` = 'Hispanic'
)
ORDER BY `patient_nbr`, `encounter_id`;

-- 15. Asian and Hispanic
CREATE OR REPLACE VIEW `diabetes_dwh_staging`.`dirty_patient_race_15` AS
SELECT *
FROM `diabetes_dwh_staging`.`dataset`
WHERE `patient_nbr` in (
	SELECT `patient_nbr`
	FROM `diabetes_dwh_staging`.`dataset`
	WHERE `race` = 'Asian'
) AND `patient_nbr` in (
	SELECT `patient_nbr`
	FROM `diabetes_dwh_staging`.`dataset`
	WHERE `race` = 'Hispanic'
)
ORDER BY `patient_nbr`, `encounter_id`;