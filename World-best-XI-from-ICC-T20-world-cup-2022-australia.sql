-- Use the WORLDCUPT20_2022_AUSTRALIA database
USE WORLDCUPT20_2022_AUSTRALIA;

-- Create the MATCHSUMMARY table
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

-- Create the BATSMANSUMMARY table
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

-- Create the BOWLERSUMMARY table
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

CREATE OR REPLACE TABLE WORLDCUPT20_2022_AUSTRALIA.TEST_SCHEMA.PLAYERSSUMMARY(
PlayerName CHAR(40),
PLAYERCOUNTRY CHAR(20),
BATTINGSTYLE CHAR(40),
BOWLINGSTYLE CHAR(40),
PLAYINGROLE CHAR(40),
IMAGEURL CHAR(200),
PlayerURL CHAR(200)
);
DESCRIBE PLAYERSSUMMARY;
drop table PLAYERSSUMMARY;

select * from WORLDCUPT20_2022_AUSTRALIA.TEST_SCHEMA.PLAYERSSUMMARY  ;

alter table WORLDCUPT20_2022_AUSTRALIA.TEST_SCHEMA.PLAYERSSUMMARY modify PLAYINGROLE char(100);


SELECT DISTINCT BATSMANNAME AS PlayerName,BATTINGTEAM AS PLAYERCOUNTRY, BATSMANURL AS PlayerURL ,
FROM WORLDCUPT20_2022_AUSTRALIA.TEST_SCHEMA.BATSMANSUMMARY 
UNION 
SELECT DISTINCT BOWLERNAME AS PlayerName,BOWLINGTEAM AS PLAYERCOUNTRY, BOWLERURL AS PlayerURL 
FROM WORLDCUPT20_2022_AUSTRALIA.TEST_SCHEMA.BOWLERSUMMARY;

INSERT INTO  WORLDCUPT20_2022_AUSTRALIA.TEST_SCHEMA.PLAYERSSUMMARY (PlayerName, PLAYERCOUNTRY, PlayerURL)
SELECT DISTINCT BATSMANNAME AS PlayerName, BATTINGTEAM AS PLAYERCOUNTRY, BATSMANURL AS PlayerURL
FROM WORLDCUPT20_2022_AUSTRALIA.TEST_SCHEMA.BATSMANSUMMARY 
UNION 
SELECT DISTINCT BOWLERNAME AS PlayerName, BOWLINGTEAM AS PLAYERCOUNTRY, BOWLERURL AS PlayerURL 
FROM WORLDCUPT20_2022_AUSTRALIA.TEST_SCHEMA.BOWLERSUMMARY;


SELECT * FROM PLAYERSSUMMARY;

SELECT PlayerName,PlayerURL FROM PLAYERSSUMMARY ORDER BY PlayerName ASC;

select PLAYINGROLE from WORLDCUPT20_2022_AUSTRALIA.TEST_SCHEMA.PLAYERSSUMMARY group by PLAYINGROLE;

select * from worldcupt20_2022_australia.test_schema.playerssummary where bowlingstyle = 'Legbreak';

update WORLDCUPT20_2022_AUSTRALIA.TEST_SCHEMA.PLAYERSSUMMARY set PLAYINGROLE = 'Wicketkeeper' where PLAYINGROLE = 'Wicketkeeper Batter';

SELECT * 
FROM WORLDCUPT20_2022_AUSTRALIA.TEST_SCHEMA.PLAYERSSUMMARY AS ps1
WHERE EXISTS (
    SELECT 1
    FROM WORLDCUPT20_2022_AUSTRALIA.TEST_SCHEMA.PLAYERSSUMMARY AS ps2
    WHERE ps1.PlayerURL = ps2.PlayerURL
    GROUP BY ps2.PlayerURL
    HAVING COUNT(ps2.PlayerURL) > 1
);

select playerurl from WORLDCUPT20_2022_AUSTRALIA.TEST_SCHEMA.PLAYERSSUMMARY  group by playerurl having count(playerurl) > 1;

select * from worldcupt20_2022_australia.test_schema.matchsummary where matchnumber ='33';

select * FROM WORLDCUPT20_2022_AUSTRALIA.TEST_SCHEMA.BOWLERSUMMARY;

select BATSMANNAME,sum(RUNSSCORED),count(matchnumbat) from WORLDCUPT20_2022_AUSTRALIA.TEST_SCHEMA.BATSMANSUMMARY group by BATSMANNAME order by count(matchnumbat) desc;


select median(BALLSFACED) from WORLDCUPT20_2022_AUSTRALIA.TEST_SCHEMA.BATSMANSUMMARY  where strikerate > 130;


select *from WORLDCUPT20_2022_AUSTRALIA.TEST_SCHEMA.BOWLERSUMMARY  where BOWLERNAME  like 'Wanindu Hasaranga';





SELECT MEDIAN(cnt) AS median_count_batsmen_names
FROM (
    SELECT COUNT(BATSMANNAME) AS cnt
    FROM WORLDCUPT20_2022_AUSTRALIA.TEST_SCHEMA.batsmansummary
    GROUP BY MATCHNUMBAT  -- Assuming MATCHNUMBAT uniquely identifies a match
);


select median(BALLSFACED) from WORLDCUPT20_2022_AUSTRALIA.TEST_SCHEMA.batsmansummary where battingposition > 2 and battingposition < 7;



select distinct team1 ,team1sf from TEST_SCHEMA.matchsummary;

create or replace table countries (Country char(20), shortForm char(4));

insert into countries (
select distinct team1 ,team1sf from TEST_SCHEMA.matchsummary
);

select P.playername,p.playercountry ,c.shortform from playerssummary P left outer join  countries c on p.playercountry = c.country;



SELECT * FROM PLAYERSSUMMARY;