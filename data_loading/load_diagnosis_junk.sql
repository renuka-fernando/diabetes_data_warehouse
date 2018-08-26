DROP PROCEDURE IF EXISTS `diabetes_dwh`.`fill_diagnosis_junk`;
DELIMITER ;;

CREATE PROCEDURE `diabetes_dwh`.`fill_diagnosis_junk`()
BEGIN

DECLARE n INT DEFAULT 0;
DECLARE i INT DEFAULT 0;
DECLARE j INT DEFAULT 0;
DECLARE k INT DEFAULT 0;

DECLARE pri VARCHAR(200);
DECLARE sec VARCHAR(200);
DECLARE alt VARCHAR(200);

SELECT COUNT(*) FROM `diabetes_DWH_staging`.`icd9_index` INTO n;
DELETE FROM `diabetes_dwh`.`dim_junk_diagnosis`;

WHILE i < n DO
	SET j = 0;
    SELECT `disease` FROM `diabetes_DWH_staging`.`icd9_index` LIMIT i, 1 INTO pri;
    
	WHILE j < n DO
		SET k = 0;
		SELECT `disease` FROM `diabetes_DWH_staging`.`icd9_index` LIMIT j, 1 INTO sec;
        
		WHILE k < n DO
			SELECT `disease` FROM `diabetes_DWH_staging`.`icd9_index` LIMIT k, 1 INTO alt;
        
			INSERT INTO `diabetes_dwh`.`dim_junk_diagnosis`
				(`primary_diagnosis`, `secondary_diagnosis`, `additional_diagnosis`)
            VALUES (pri, sec, alt);
            
			SET k = k + 1;
		END WHILE;
        
        SET j = j + 1;
	END WHILE;
    
    SET i = i + 1;
END WHILE;

END;;

DELIMITER ;
CALL `diabetes_dwh`.`fill_diagnosis_junk`();

SELECT COUNT(*) FROM `diabetes_dwh`.`dim_junk_diagnosis`;