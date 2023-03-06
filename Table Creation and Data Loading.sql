CREATE DATABASE portfolio_project_2;

USE portfolio_project_2;

CREATE TABLE IF NOT EXISTS fifa_21_players
( ID INT PRIMARY KEY,
PlayerName VARCHAR(255),
LongName VARCHAR(255),
Nationality VARCHAR(255),
Age INT,
OVA INT,
Club VARCHAR(255),
Contract VARCHAR(255),
Positions VARCHAR(255),
Height VARCHAR(10),
Weight VARCHAR(10),
BOV INT,
BestPosition VARCHAR(10),
Joined VARCHAR(255),
LoanDateEnd VARCHAR(255),
PlayerValue VARCHAR(255),
Wage VARCHAR(255),
IR VARCHAR(10)
);

--  The local file to be loaded is a subset of the FIFA 21 players dataset retrieved from user Rachit Toshniwal on kaggle.com

LOAD DATA LOCAL INFILE 'C:/MySQL/Portfolio Database/fifa21 raw data v2_sub.csv'
INTO TABLE fifa_21_players
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;