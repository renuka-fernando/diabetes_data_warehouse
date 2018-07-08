SELECT `encounter_id`, `patient_nbr`, `race`, `gender`
FROM `diabetes_dwh_staging`.`dirty_patient_race_1`;

UPDATE `diabetes_dwh_staging`.`dataset`
SET `race` = 'Caucasian'
WHERE `patient_nbr` in (1553220, 3228903, 3588723, 3616155, 5142546, 6198867, 13420188, 42246738, 52316388, 56088306,
89643555, 91830285, 92614788, 111126897);

UPDATE `diabetes_dwh_staging`.`dataset`
SET `race` = 'AfricanAmerican'
WHERE `patient_nbr` in (1243557, 1756539, 5333787, 6144201, 6480900, 6919587, 10980891, 24945534, 25764849, 30317814,
40090752, 54643194, 60899562, 60987717, 62845515, 74494548, 88696557, 101753730, 106137846, 112786587);

-- Continue SELECT and UPDATE as above

SELECT `encounter_id`, `patient_nbr`, `race`, `gender`
FROM `diabetes_dwh_staging`.`dirty_patient_race_2`;