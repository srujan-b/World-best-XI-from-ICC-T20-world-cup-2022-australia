-- Use the WORLDCUPT20_2022_AUSTRALIA database
USE WORLDCUPT20_2022_AUSTRALIA;

-- Create the MATCHSUMMARY table to store match details
CREATE TABLE MATCHSUMMARY (
    MatchDate DATE,                      -- Date of the match
    MatchNumber CHAR(20) PRIMARY KEY,   -- Unique match number
    City CHAR(20),                       -- City where the match was held
    Team1 CHAR(15),                      -- Name of the first team
    Team1SF CHAR(3),                     -- Short form of the first team's name
    Team1Score CHAR(6),                  -- Score of the first team
    Team2 CHAR(15),                      -- Name of the second team
    Team2SF CHAR(3),                     -- Short form of the second team's name
    Team2Score CHAR(6),                  -- Score of the second team
    Results CHAR(40),                    -- Result of the match
    URL CHAR(100)                        -- URL for more details about the match
);

-- Create the BATSMANSUMMARY table to store batsmen statistics
CREATE TABLE BATSMANSUMMARY (
    MATCHNUMBAT CHAR(20),                -- Match number for reference
    BATTINGTEAM CHAR(20),                -- Name of the batting team
    BATTINGPOSITION INT,                 -- Batting position of the player
    BATSMANNAME CHAR(20),                -- Name of the batsman
    BATSMANURL CHAR(100),                -- URL of the batsman's profile
    RUNSSCORED INT,                      -- Runs scored by the batsman
    BALLSFACED INT,                      -- Number of balls faced by the batsman
    NUMBEROFFORES INT,                   -- Number of fours hit by the batsman
    NUMBEROFSIX INT,                     -- Number of sixes hit by the batsman
    STRIKERATE DECIMAL(10, 2),           -- Strike rate of the batsman
    FOREIGN KEY (MATCHNUMBAT) REFERENCES MATCHSUMMARY(MATCHNUMBER)  -- Reference to MATCHSUMMARY table
);

-- Create the BOWLERSUMMARY table to store bowler statistics
CREATE OR REPLACE TABLE BOWLERSUMMARY (
    MATCHNUMBOWL CHAR(20),               -- Match number for reference
    BOWLERNAME CHAR(20),                 -- Name of the bowler
    BOWLERURL CHAR(100),                 -- URL of the bowler's profile
    BOWLINGTEAM CHAR(20),                -- Name of the bowling team
    NUMBEROVERS DECIMAL(32,0),           -- Number of overs bowled by the bowler
    MADEINOVERS INT,                     -- Number of maidens bowled by the bowler
    RUNSGIVEN INT,                       -- Runs given by the bowler
    WICKETSTAKEN INT,                    -- Number of wickets taken by the bowler
    ECONAMY DECIMAL(32,0),               -- Economy rate of the bowler
    DOTBALLS INT,                        -- Number of dot balls bowled by the bowler
    FOURGIVEN INT,                       -- Number of fours given by the bowler
    SIXESGIVEN INT,                      -- Number of sixes given by the bowler
    NOBALLSGIVEN INT,                    -- Number of no balls given by the bowler
    FOREIGN KEY(MATCHNUMBOWL) REFERENCES MATCHSUMMARY(MATCHNUMBER)  -- Reference to MATCHSUMMARY table
);

-- Create the PLAYERSSUMMARY table to store player details
CREATE OR REPLACE TABLE WORLDCUPT20_2022_AUSTRALIA.TEST_SCHEMA.PLAYERSSUMMARY(
PlayerName CHAR(40),
PLAYERCOUNTRY CHAR(20),
BATTINGSTYLE CHAR(40),
BOWLINGSTYLE CHAR(40),
PLAYINGROLE CHAR(40),
IMAGEURL CHAR(200),
PlayerURL CHAR(200)
);

-- Alter the PLAYINGROLE column to accommodate longer values
ALTER TABLE WORLDCUPT20_2022_AUSTRALIA.TEST_SCHEMA.PLAYERSSUMMARY MODIFY PLAYINGROLE CHAR(100);

-- Populate the PLAYERSSUMMARY table with unique player details
INSERT INTO WORLDCUPT20_2022_AUSTRALIA.TEST_SCHEMA.PLAYERSSUMMARY (PlayerName, PLAYERCOUNTRY, PlayerURL)
SELECT DISTINCT BATSMANNAME AS PlayerName, BATTINGTEAM AS PLAYERCOUNTRY, BATSMANURL AS PlayerURL
FROM WORLDCUPT20_2022_AUSTRALIA.TEST_SCHEMA.BATSMANSUMMARY 
UNION 
SELECT DISTINCT BOWLERNAME AS PlayerName, BOWLINGTEAM AS PLAYERCOUNTRY, BOWLERURL AS PlayerURL 
FROM WORLDCUPT20_2022_AUSTRALIA.TEST_SCHEMA.BOWLERSUMMARY;

-- Retrieve and display player details with their respective URLs
SELECT * FROM PLAYERSSUMMARY;

-- Retrieve and display player names and URLs, ordered alphabetically by player name
SELECT PlayerName, PlayerURL FROM PLAYERSSUMMARY ORDER BY PlayerName ASC;

-- Retrieve distinct playing roles of players
SELECT PLAYINGROLE FROM WORLDCUPT20_2022_AUSTRALIA.TEST_SCHEMA.PLAYERSSUMMARY GROUP BY PLAYINGROLE;

-- Update playing role designation from 'Wicketkeeper Batter' to 'Wicketkeeper'
UPDATE WORLDCUPT20_2022_AUSTRALIA.TEST_SCHEMA.PLAYERSSUMMARY SET PLAYINGROLE = 'Wicketkeeper' WHERE PLAYINGROLE = 'Wicketkeeper Batter';

-- Retrieve players with duplicate URLs
SELECT * 
FROM WORLDCUPT20_2022_AUSTRALIA.TEST_SCHEMA.PLAYERSSUMMARY AS ps1
WHERE EXISTS (
    SELECT 1
    FROM WORLDCUPT20_2022_AUSTRALIA.TEST_SCHEMA.PLAYERSSUMMARY AS ps2
    WHERE ps1.PlayerURL = ps2.PlayerURL
    GROUP BY ps2.PlayerURL
    HAVING COUNT(ps2.PlayerURL) > 1
);

-- Retrieve player URLs with duplicate entries
SELECT PlayerURL FROM WORLDCUPT20_2022_AUSTRALIA.TEST_SCHEMA.PLAYERSSUMMARY  GROUP BY PlayerURL HAVING COUNT(PlayerURL) > 1;

-- Retrieve match details for a specific match number
SELECT * FROM worldcupt20_2022_australia.test_schema.matchsummary WHERE matchnumber ='33';

-- Retrieve details of all bowlers
SELECT * FROM WORLDCUPT20_2022_AUSTRALIA.TEST_SCHEMA.BOWLERSUMMARY;

-- Retrieve total runs scored by each batsman, along with the count of matches played
SELECT BATSMANNAME, SUM(RUNSSCORED), COUNT(MATCHNUMBAT) FROM WORLDCUPT20_2022_AUSTRALIA.TEST_SCHEMA.BATSMANSUMMARY GROUP BY BATSMANNAME ORDER BY COUNT(MATCHNUMBAT) DESC;

-- Calculate the median number of balls faced by batsmen with batting positions between 3 and 6
SELECT MEDIAN(BALLSFACED) FROM WORLDCUPT20_2022_AUSTRALIA.TEST_SCHEMA.BATSMANSUMMARY WHERE BATTINGPOSITION > 2 AND BATTINGPOSITION < 7;

-- Retrieve details of bowlers with the name 'Wanindu Hasaranga'
SELECT * FROM WORLDCUPT20_2022_AUSTRALIA.TEST_SCHEMA.BOWLERSUMMARY WHERE BOWLERNAME LIKE 'Wanindu Hasaranga';

-- Calculate the median count of batsmen names per match
SELECT MEDIAN(cnt) AS median_count_batsmen_names
FROM (
    SELECT COUNT(BATSMANNAME) AS cnt
    FROM WORLDCUPT20_2022_AUSTRALIA.TEST_SCHEMA.batsmansummary
    GROUP BY MATCHNUMBAT  -- Assuming MATCHNUMBAT uniquely identifies a match
);

-- Calculate the median number of balls faced by batsmen with batting positions between 3 and 6
SELECT MEDIAN(BALLSFACED) FROM WORLDCUPT20_2022_AUSTRALIA.TEST_SCHEMA.batsmansummary WHERE BATTINGPOSITION > 2 AND BATTINGPOSITION < 7;

-- Retrieve distinct teams and their short forms from match summary
SELECT DISTINCT team1, team1sf FROM TEST_SCHEMA.matchsummary;

-- Create or replace the countries table to store country names and their short forms
CREATE OR REPLACE TABLE countries (Country CHAR(20), shortForm CHAR(4));

-- Populate the countries table with distinct team names and their short forms from match summary
INSERT INTO countries (
SELECT DISTINCT team1, team1sf FROM TEST_SCHEMA.matchsummary
);

-- Retrieve player name, player country, and country short form from player summary and countries table
SELECT P.playername, P.playercountry, C.shortform FROM playerssummary P LEFT OUTER JOIN countries C ON P.playercountry = C.country;

-- Retrieve all records from the player summary table
SELECT * FROM PLAYERSSUMMARY;
