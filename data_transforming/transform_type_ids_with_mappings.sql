DROP PROCEDURE IF EXISTS `diabetes_dwh_staging`.`TRANSFORM_ADMISSION_TYPE`;
DROP PROCEDURE IF EXISTS `diabetes_dwh_staging`.`TRANSFORM_ADMISSION_SOURCE`;
DROP PROCEDURE IF EXISTS `diabetes_dwh_staging`.`TRANSFORM_DISCHARGE_DISPOSITION`;
DELIMITER ;;

-- Admission Type
CREATE PROCEDURE `diabetes_dwh_staging`.`TRANSFORM_ADMISSION_TYPE`()
BEGIN

DECLARE n INT DEFAULT 0;
DECLARE i INT DEFAULT 1;

SET n = (SELECT COUNT(*) FROM `diabetes_dwh_staging`.`admission_type`);
-- Add the column
ALTER TABLE `diabetes_dwh_staging`.`dataset_modified`
ADD COLUMN `admission_type` VARCHAR(150);

WHILE i <= n DO
	UPDATE `diabetes_dwh_staging`.`dataset_modified`
    SET `admission_type` = (
		SELECT `description` FROM `diabetes_dwh_staging`.`admission_type` WHERE `id` = i
    )
    WHERE `admission_type_id` = i;
    SET i = i + 1;
END WHILE;

ALTER TABLE `diabetes_dwh_staging`.`dataset_modified`
DROP COLUMN `admission_type_id`;
END;;

-- Admission Source
CREATE PROCEDURE `diabetes_dwh_staging`.`TRANSFORM_ADMISSION_SOURCE`()
BEGIN

DECLARE n INT DEFAULT 0;
DECLARE i INT DEFAULT 1;

SET n = (SELECT COUNT(*) FROM `diabetes_dwh_staging`.`admission_source`);
-- Add the column
ALTER TABLE `diabetes_dwh_staging`.`dataset_modified`
ADD COLUMN `admission_source` VARCHAR(150);

WHILE i <= n DO
	UPDATE `diabetes_dwh_staging`.`dataset_modified`
    SET `admission_source` = (
		SELECT `description` FROM `diabetes_dwh_staging`.`admission_source` WHERE `id` = i
    )
    WHERE `admission_source_id` = i;
    SET i = i + 1;
END WHILE;

ALTER TABLE `diabetes_dwh_staging`.`dataset_modified`
DROP COLUMN `admission_source_id`;
END;;

-- Discharge Disposition
CREATE PROCEDURE `diabetes_dwh_staging`.`TRANSFORM_DISCHARGE_DISPOSITION`()
BEGIN

DECLARE n INT DEFAULT 0;
DECLARE i INT DEFAULT 1;

SET n = (SELECT COUNT(*) FROM `diabetes_dwh_staging`.`discharge_disposition`);
-- Add the column
ALTER TABLE `diabetes_dwh_staging`.`dataset_modified`
ADD COLUMN `discharge_disposition` VARCHAR(150);

WHILE i <= n DO
	UPDATE `diabetes_dwh_staging`.`dataset_modified`
    SET `discharge_disposition` = (
		SELECT `description` FROM `diabetes_dwh_staging`.`discharge_disposition` WHERE `id` = i
    )
    WHERE `discharge_disposition_id` = i;
    SET i = i + 1;
END WHILE;

ALTER TABLE `diabetes_dwh_staging`.`dataset_modified`
DROP COLUMN `discharge_disposition_id`;
END;;

DELIMITER ;
CALL `diabetes_dwh_staging`.`TRANSFORM_ADMISSION_TYPE`();
CALL `diabetes_dwh_staging`.`TRANSFORM_ADMISSION_SOURCE`();
CALL `diabetes_dwh_staging`.`TRANSFORM_DISCHARGE_DISPOSITION`();
