-- Remove newline spaces before 'Club' name, remove 'star' characters from 'IR' column

UPDATE fifa_21_players
SET 
   Club = REPLACE(Club,'\n',''),
   IR = REPLACE(IR,'★','');

--------------------------------------------------------------------------------------------------------------

-- Removing characters from strings, converting to lbs to kgs, updating 'Weight' column  

UPDATE fifa_21_players
SET 
   Weight = CASE WHEN Weight  LIKE '%kg%' THEN SUBSTRING_INDEX(Weight,'k',1)
              WHEN Weight  LIKE '%lbs%' THEN  ROUND(SUBSTRING_INDEX(Weight,'l',1)*0.45359237,0)
              ELSE Weight END;

-- Changing Weight 'column' from string to numeric data type
         
ALTER TABLE fifa_21_players
CHANGE Weight Weight_kg INT;
-------------------------------------------------------------------------------------------------------------

-- Removing characters from strings, converting to centimeters, updating 'Height' column   

UPDATE fifa_21_players
SET 
   Height=CASE WHEN Height  LIKE '%cm%' THEN SUBSTRING_INDEX(Height,'c',1)
              WHEN Height  LIKE '%"%' THEN  ROUND(SUBSTRING_INDEX(Height,"'",1) * 30.48 + SUBSTRING_INDEX(SUBSTRING_INDEX(Height,"'",-1),'"',1) * 2.54,0)
              ELSE Height END;
              
-- Changing 'Height' column from string to numeric data type

ALTER TABLE fifa_21_players
CHANGE Height Height_cm INT;
------------------------------------------------------------------------------------------------

-- Manage empty strings in 'LoanDateEnd' column

UPDATE fifa_21_players
SET
   LoanDateEnd = IF(LoanDateEnd='',NULL,LoanDateEnd);

-- Converting 'Joined', 'LoanDateEnd' column to date data type

UPDATE fifa_21_players
SET 
   Joined = STR_TO_DATE(Joined,'%b %e,%Y'),
   LoanDateEnd = STR_TO_DATE(LoanDateEnd,'%b %e,%Y');

ALTER TABLE fifa_21_players
MODIFY Joined DATE,
MODIFY LoanDateEnd DATE;

-------------------------------------------------------------------------------------------------

-- Update 'PlayerValue','Wage' columns, conversion from string to numeric data type

UPDATE fifa_21_players
SET 
   PlayerValue = CASE WHEN PlayerValue LIKE '%K' THEN TRIM(TRAILING 'K' FROM SUBSTRING(PlayerValue,2))*1000
				     WHEN PlayerValue LIKE '%M' THEN TRIM(TRAILING 'M' FROM SUBSTRING(PlayerValue,2))*1000000
                     ELSE SUBSTRING(PlayerValue,2) END,
    Wage = CASE WHEN Wage LIKE '%K' THEN TRIM(TRAILING 'K' FROM SUBSTRING(Wage,2))*1000
              ELSE SUBSTRING(Wage,2) END;                 


ALTER TABLE fifa_21_players
CHANGE PlayerValue PlayerValue_Euro INT,
CHANGE Wage Wage_Euro INT;

------------------------------------------------------------------------------------------------------

-- Create column 'ContractStatus' 

ALTER TABLE fifa_21_players
ADD COLUMN ContractStatus VARCHAR(20) AFTER Contract;

-- Update column 'ContractStatus' based on information from column 'Contract'

UPDATE fifa_21_players
SET 
   ContractStatus = CASE WHEN Contract LIKE '%~%' THEN 'Active'
                         WHEN Contract LIKE '%On Loan%' THEN 'On Loan'
                         ELSE 'Free' END; 

