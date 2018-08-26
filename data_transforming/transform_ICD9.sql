DROP PROCEDURE IF EXISTS `diabetes_dwh_staging`.`TRANSFORM_ICD9`;
DELIMITER ;;

CREATE PROCEDURE `diabetes_dwh_staging`.`TRANSFORM_ICD9`()
BEGIN

DECLARE n INT DEFAULT 0;
DECLARE i INT DEFAULT 0;

-- Transform other values (starts with V and E)
-- Transform "diag_1" values
UPDATE `diabetes_dwh_staging`.`dataset_modified` SET `diag_1` = (
	SELECT `disease` FROM `diabetes_dwh_staging`.`icd9_index` WHERE `code_letter` = 'V'
)
WHERE LEFT(`diag_1`, 1) = 'V';
UPDATE `diabetes_dwh_staging`.`dataset_modified` SET `diag_1` = (
	SELECT `disease` FROM `diabetes_dwh_staging`.`icd9_index` WHERE `code_letter` = 'E'
)
WHERE LEFT(`diag_1`, 1) = 'E';

-- Transform "diag_2" values
UPDATE `diabetes_dwh_staging`.`dataset_modified` SET `diag_2` = (
	SELECT `disease` FROM `diabetes_dwh_staging`.`icd9_index` WHERE `code_letter` = 'V'
)
WHERE LEFT(`diag_2`, 1) = 'V';
UPDATE `diabetes_dwh_staging`.`dataset_modified` SET `diag_2` = (
	SELECT `disease` FROM `diabetes_dwh_staging`.`icd9_index` WHERE `code_letter` = 'E'
)
WHERE LEFT(`diag_2`, 1) = 'E';

-- Transform "diag_3" values
UPDATE `diabetes_dwh_staging`.`dataset_modified` SET `diag_3` = (
	SELECT `disease` FROM `diabetes_dwh_staging`.`icd9_index` WHERE `code_letter` = 'V'
)
WHERE LEFT(`diag_3`, 1) = 'V';
UPDATE `diabetes_dwh_staging`.`dataset_modified` SET `diag_3` = (
	SELECT `disease` FROM `diabetes_dwh_staging`.`icd9_index` WHERE `code_letter` = 'E'
)
WHERE LEFT(`diag_3`, 1) = 'E';


-- Transform values with digits only
SELECT COUNT(*) FROM `diabetes_dwh_staging`.`icd9_index` WHERE `code_letter` = '' INTO n;
SET i = 0;
WHILE i < n DO 
	-- Transform "diag_1" values
	UPDATE `diabetes_dwh_staging`.`dataset_modified` SET `diag_1` = (
		SELECT `disease` FROM `diabetes_dwh_staging`.`icd9_index` LIMIT i,1
	)
    WHERE `diag_1` REGEXP '^[0-9]+\\.?[0-9]*$' AND (
		`diag_1` >= (SELECT `code_from` FROM `diabetes_dwh_staging`.`icd9_index` LIMIT i,1) AND
		`diag_1` <= (SELECT `code_to` FROM `diabetes_dwh_staging`.`icd9_index` LIMIT i,1)
	);
    
	-- Transform "diag_2" values
	UPDATE `diabetes_dwh_staging`.`dataset_modified` SET `diag_2` = (
		SELECT `disease` FROM `diabetes_dwh_staging`.`icd9_index` LIMIT i,1
	)
    WHERE `diag_2` REGEXP '^[0-9]+\\.?[0-9]*$' AND (
		`diag_2` >= (SELECT `code_from` FROM `diabetes_dwh_staging`.`icd9_index` LIMIT i,1) AND
		`diag_2` <= (SELECT `code_to` FROM `diabetes_dwh_staging`.`icd9_index` LIMIT i,1)
	);
    
    -- Transform "diag_3" values
	UPDATE `diabetes_dwh_staging`.`dataset_modified` SET `diag_3` = (
		SELECT `disease` FROM `diabetes_dwh_staging`.`icd9_index` LIMIT i,1
	)
    WHERE `diag_3` REGEXP '^[0-9]+\\.?[0-9]*$' AND (
		`diag_3` >= (SELECT `code_from` FROM `diabetes_dwh_staging`.`icd9_index` LIMIT i,1) AND
		`diag_3` <= (SELECT `code_to` FROM `diabetes_dwh_staging`.`icd9_index` LIMIT i,1)
	);
  SET i = i + 1;
END WHILE;
END;
;;

DELIMITER ;
CALL `diabetes_dwh_staging`.`TRANSFORM_ICD9`();