DROP PROCEDURE IF EXISTS `diabetes_dwh`.`fill_admission_details_junk`;
DELIMITER ;;

CREATE PROCEDURE `diabetes_dwh`.`fill_admission_details_junk`()
BEGIN

DECLARE m INT DEFAULT 0;
DECLARE n INT DEFAULT 0;
DECLARE o INT DEFAULT 0;
DECLARE i INT DEFAULT 0;
DECLARE j INT DEFAULT 0;
DECLARE k INT DEFAULT 0;

DECLARE `type` VARCHAR(200);
DECLARE `source` VARCHAR(200);
DECLARE `med_spec` VARCHAR(200);

CREATE OR REPLACE VIEW `diabetes_DWH_staging`.`medical_specialty` AS
SELECT DISTINCT `medical_specialty` FROM `diabetes_dwh_staging`.`dataset`;

SET m = (SELECT COUNT(*) FROM `diabetes_DWH_staging`.`admission_type`);
SET n = (SELECT COUNT(*) FROM `diabetes_DWH_staging`.`admission_source`);
SET o = (SELECT COUNT(*) FROM `diabetes_DWH_staging`.`medical_specialty`);
DELETE FROM `diabetes_dwh`.`dim_junk_admissionDetails`;

WHILE i < m DO
	SET j = 0;
    SELECT `description` FROM `diabetes_DWH_staging`.`admission_type` LIMIT i, 1 INTO `type`;
    
	WHILE j < n DO
		SET k = 0;
		SELECT `description` FROM `diabetes_DWH_staging`.`admission_source` LIMIT j, 1 INTO `source`;
        
		WHILE k < o DO
			SELECT `medical_specialty` FROM `diabetes_DWH_staging`.`medical_specialty` LIMIT k, 1 INTO `med_spec`;
        
			INSERT INTO `diabetes_dwh`.`dim_junk_admissionDetails`
				(`admission_type`, `admission_source`, `medical_speciality`)
            VALUES (`type`, `source`, `med_spec`);
            
			SET k = k + 1;
		END WHILE;
        
        SET j = j + 1;
	END WHILE;
    
    SET i = i + 1;
END WHILE;

END;;

DELIMITER ;
CALL `diabetes_dwh`.`fill_admission_details_junk`();

SELECT COUNT(*) FROM `diabetes_dwh`.`dim_junk_admissionDetails`;