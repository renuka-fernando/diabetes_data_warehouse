SELECT distinct `race`
FROM `diabetes_dwh_staging`.`dataset_modified`;
-- 6 distinct races are found. (Caucasian, AfricanAmerican, ?, Other, Asian, Hispanic)

-- Views to identify dirty data
CREATE OR REPLACE VIEW `diabetes_dwh_staging`.`dirty_patient_race` AS
SELECT `patient_nbr`, count(distinct `race`) as `race_count`
FROM `diabetes_dwh_staging`.`dataset_modified`
group by `patient_nbr` having `race_count` > 1;

SELECT count(`patient_nbr`)
FROM `diabetes_dwh_staging`.`dirty_patient_race`;

SELECT `encounter_id`, `patient_nbr`, `race`
FROM `diabetes_dwh_staging`.`dataset_modified`
WHERE `patient_nbr` in (
	SELECT `patient_nbr`
    FROM `diabetes_dwh_staging`.`dirty_patient_race`
)
ORDER BY `patient_nbr`, `encounter_id`;

-- Set race as Caucasian
UPDATE `diabetes_dwh_staging`.`dataset_modified`
SET `race` = 'Caucasian'
WHERE `patient_nbr` IN (1553220, 23724792, 38893887, 42246738, 52316388, 112367349);

-- Set race as AfricanAmerican
UPDATE `diabetes_dwh_staging`.`dataset_modified`
SET `race` = 'AfricanAmerican'
WHERE `patient_nbr` IN (6919587, 10980891, 40090752, 54643194, 101753730, 107849052);

-- Set race as Other
UPDATE `diabetes_dwh_staging`.`dataset_modified`
SET `race` = 'Other'
WHERE `patient_nbr` IN (28532295, 30689766, 32314608, 33247647, 36967347, 37547937, 37638306, 38774187, 39160719, 42096384, 90817893, 93105117, 93662784, 94027644, 98584524, 100322946, 103228398, 103690161, 105125598, 106425234);

-- Set race as Asian
UPDATE `diabetes_dwh_staging`.`dataset_modified`
SET `race` = 'Asian'
WHERE `patient_nbr` IN (24332220, 31812075, 34248078, 94539465, 97024806, 103305528, 104622570, 110657970, 111534210);

-- Set race as Hispanic
UPDATE `diabetes_dwh_staging`.`dataset_modified`
SET `race` = 'Hispanic'
WHERE `patient_nbr` IN (37572957, 44744166, 45113778, 90035874, 91107549, 93809358, 94088088, 98934615, 106895331, 109448541);