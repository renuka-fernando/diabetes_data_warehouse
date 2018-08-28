DROP PROCEDURE IF EXISTS `diabetes_dwh_staging`.`transform_for_datamining`;
DELIMITER ;;

CREATE PROCEDURE `diabetes_dwh_staging`.`transform_for_datamining`()
BEGIN

DECLARE i INT DEFAULT 0;
DECLARE age_str VARCHAR(10);
DECLARE age_str_int INT;

ALTER TABLE `diabetes_dwh_staging`.`dataset_modified`
ADD COLUMN `age_int` INT;

WHILE i < 10 DO
	SET age_str = CONCAT('[', i * 10, '-', (i+1) * 10, ')');
    SET age_str_int = i * 10 + 5;
    
    UPDATE `diabetes_dwh_staging`.`dataset_modified`
    SET `age_int` = age_str_int
    WHERE `age` = age_str;
    
    SET i = i+1;
END WHILE;

END;;

DELIMITER ;
CALL `diabetes_dwh_staging`.`transform_for_datamining`();

SELECT DISTINCT `age`, `age_int`
FROM `diabetes_dwh_staging`.`dataset_modified`;