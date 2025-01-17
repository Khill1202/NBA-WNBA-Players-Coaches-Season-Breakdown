Use n_w;

Show Tables; 

Select *
From nba_stat limit 10;

Select *
From wnba_stat limit 10;


Select *
From nba_coaches limit 10;



Select *
From wnba_coaches limit 10;


select*
From nba_coaches_sal limit 10;



Select *
From wnba_coaches_sal limit 10;


select *
from nba_sal limit 10;

select *
from wnba_sal limit 10;


Select *
From nba_stat;

Select *
From wnba_stat;


Select *
From nba_coaches;



Select *
From wnba_coaches;


select*
From nba_coaches_sal;



Select *
From wnba_coaches_sal;


select *
from nba_sal; 

select *
from wnba_sal;





SELECT 
nba_stat.Rank,
    nba_stat.Player,
    nba_stat.Age,
    nba_stat.Position,
    nba_stat.Team,
    nba_stat.`FT%`,
    nba_stat.`FG%`,
    nba_stat.`2P%`,
    nba_stat.`3P%`,
    nba_stat.`EFG%`,
    nba_stat.PTS,
    nba_stat.TRB,
    nba_stat.AST,
    nba_stat.STL,
    nba_stat.TOV,
    nba_sal.Guaranteed
FROM 
    nba_stat
JOIN 
    nba_sal
ON 
    nba_stat.Player = nba_sal.Player
WHERE 
    nba_stat.Rank REGEXP '^[0-9]+$' -- Only numeric ranks
ORDER BY 
    CAST(nba_stat.Rank AS UNSIGNED) ASC;
  
  
  
  

SELECT * 
FROM wnba_stat LIMIT 10;


SELECT * 
FROM wnba_sal LIMIT 10;


SELECT * 
FROM wnba_stat;


SELECT * 
FROM wnba_sal;



    
    
    
    
    
    WITH RankedSalaries AS (
    SELECT 
        TRIM(wnba_stat.`WNBA Player`) AS `WNBA Player`,
        wnba_stat.`WNBA Position` AS `WNBA Position`,
        wnba_stat.`WNBA Team` AS `WNBA Team`,
        wnba_stat.`WNBA FT%` AS `WNBA FT%`,
        wnba_stat.`WNBA FG%` AS `WNBA FG%`,
        wnba_stat.`WNBA 2P%` AS `WNBA 2P%`,
        wnba_stat.`WNBA 3P%` AS `WNBA 3P%`,
        wnba_stat.`WNBA PTS` AS `WNBA PTS`,
        wnba_stat.`WNBA TRB` AS `WNBA TRB`,
        wnba_stat.`WNBA AST` AS `WNBA AST`,
        wnba_stat.`WNBA STL` AS `WNBA STL`,
        wnba_stat.`WNBA TOV` AS `WNBA TOV`,
        COALESCE(wnba_sal.`WNBA Salary 1`, '') AS `WNBA Salary`,
        ROW_NUMBER() OVER (
            PARTITION BY TRIM(LOWER(wnba_stat.`WNBA Player`)) 
            ORDER BY CAST(REPLACE(COALESCE(wnba_sal.`WNBA Salary 1`, '0'), ',', '') AS UNSIGNED) DESC
        ) AS RowNum
    FROM 
        wnba_stat
    LEFT JOIN 
        wnba_sal
    ON 
        TRIM(LOWER(wnba_stat.`WNBA Player`)) = TRIM(LOWER(wnba_sal.`WNBA Player`))
)
SELECT 
    `WNBA Player`, 
    `WNBA Position`, 
    `WNBA Team`, 
    `WNBA FT%`, 
    `WNBA FG%`, 
    `WNBA 2P%`, 
    `WNBA 3P%`, 
    `WNBA PTS`, 
    `WNBA TRB`, 
    `WNBA AST`, 
    `WNBA STL`, 
    `WNBA TOV`, 
    `WNBA Salary`
FROM 
    RankedSalaries
WHERE 
    RowNum = 1
ORDER BY 
 CAST(REPLACE(COALESCE(`WNBA Salary`, '0'), ',', '') AS UNSIGNED) DESC, 
    `WNBA Player` ASC; 
    
    
    
    
    
    
    
 WITH RankedSalaries AS (
    SELECT 
        nba_stat.Rank, 
        nba_stat.Player, 
        nba_stat.TEAM, 
        nba_stat.Position, 
        COALESCE(nba_sal.`Salary 1`, '') AS `Salary Y1`, 
        COALESCE(nba_sal.`Salary 2`, '') AS `Salary Y2`, 
        COALESCE(nba_sal.`Salary 3`, '') AS `Salary Y3`, 
        COALESCE(nba_sal.`Salary 4`, '') AS `Salary Y4`, 
        COALESCE(nba_sal.`Salary 52`, '') AS `Salary Y5`, 
        COALESCE(nba_sal.`Salary 6`, '') AS `Salary Y6`, 
        COALESCE(nba_sal.Guaranteed, '') AS Guaranteed, 
        ROW_NUMBER() OVER (
            PARTITION BY nba_stat.Player 
            ORDER BY CAST(REPLACE(COALESCE(nba_sal.`Salary 1`, '0'), ',', '') AS UNSIGNED) DESC
        ) AS RowNum
    FROM 
        nba_stat
    LEFT JOIN 
        nba_sal
        ON 
        TRIM(LOWER(nba_stat.Player)) = TRIM(LOWER(nba_sal.Player))
)
SELECT 
    `Rank`, 
    Player, 
    TEAM, 
    Position, 
    `Salary Y1`, 
    `Salary Y2`, 
    `Salary Y3`, 
    `Salary Y4`, 
    `Salary Y5`, 
    `Salary Y6`, 
    Guaranteed
FROM 
    RankedSalaries
WHERE 
    RowNum = 1 
ORDER BY 
    CAST(REPLACE(COALESCE(Guaranteed, '0'), ',', '') AS UNSIGNED) ASC;    
    
    
    
    
 WITH RankedWNBA AS (
    SELECT 
        TRIM(wnba_stat.`WNBA Player`) AS `WNBA Player`,
        wnba_stat.`WNBA Team` AS `WNBA Team`,
        wnba_stat.`WNBA Position` AS `WNBA Position`,
        wnba_stat.`WNBA MP` AS `WNBA MP`,
        wnba_stat.`WNBA Games` AS `WNBA Games`,
        wnba_stat.`WNBA Games Started` AS `WNBA Games Started`,
        COALESCE(wnba_sal.`WNBA Salary 1`, '') AS `WNBA Salary`,
          ROW_NUMBER() OVER (
            PARTITION BY TRIM(LOWER(wnba_stat.`WNBA Player`)) 
            ORDER BY CAST(REPLACE(COALESCE(wnba_sal.`WNBA Salary 1`, '0'), ',', '') AS UNSIGNED) ASC
        ) AS RowNum
    FROM 
        wnba_stat
    LEFT JOIN 
        wnba_sal 
    ON 
        TRIM(LOWER(wnba_stat.`WNBA Player`)) = TRIM(LOWER(wnba_sal.`WNBA Player`))
) 
SELECT 
    `WNBA Player`, 
    `WNBA Team`, 
    `WNBA Position`, 
    `WNBA MP`, 
    `WNBA Games`, 
    `WNBA Games Started`, 
    `WNBA Salary`
FROM 
    RankedWNBA
WHERE 
    RowNum = 1 
ORDER BY 
    CAST(REPLACE(`WNBA Salary`, ',', '') AS UNSIGNED) ASC; 
    
    
    
    
    
Select *
From nba_coaches;



Select *
From wnba_coaches;


select*
From nba_coaches_sal;



Select *
From wnba_coaches_sal;
    
  
  
  

SELECT 
nba_coaches.Coaches,
    nba_coaches.team,
    nba_coaches.`seasons w/fran`,
    nba_coaches.tenure,
    nba_coaches.`Career Games`,
    nba_coaches.`Career R.Wins`,
    nba_coaches.`Career R. Losses`,
    nba_coaches.`R.Wins%`
 From 
 nba_coaches;
    
    
    
 Select
	nba_coaches.Coaches,
    nba_coaches.team,
    nba_coaches.`seasons w/fran`,
    nba_coaches.tenure,
    nba_coaches.`Career Games`,
    nba_coaches.`Career R.Wins`,
    nba_coaches.`Career R. Losses`,
    nba_coaches.`R.Wins%`,
    nba_coaches_sal.`C.Salary`
 From 
 nba_coaches
 Join
nba_coaches_sal
ON 
nba_coaches.coaches = nba_coaches_sal.coach;


    
    
    


Select
	wnba_coaches.`wnba coaches`,
    wnba_coaches.`wnba team`,
    wnba_coaches.`WNBA Career Games W/Fran`,
    wnba_coaches.`WNBA Wins W/Fran`,
    wnba_coaches.`WNBA  Losses  W/Fran`,
    wnba_coaches.`WNBA W%`
 From 
 wnba_coaches;
 
 
 Select
	wnba_coaches.`wnba coaches`,
    wnba_coaches.`wnba team`,
    wnba_coaches.`WNBA Career Games W/Fran`,
    wnba_coaches.`WNBA Wins W/Fran`,
    wnba_coaches.`WNBA  Losses  W/Fran`,
    wnba_coaches.`WNBA W%`,
    wnba_coaches_sal.`wnba c. salaries`
 From 
 wnba_coaches
 JOIN 
    wnba_coaches_sal
ON 
    wnba_coaches.`wnba coaches` = wnba_coaches_sal.`wnba coach`
order by 
	wnba_coaches.`WNBA W%` DESC;
    
    
    
    
    
     Select
	nba_coaches.Coaches,
    nba_coaches.team,
    nba_coaches.tenure,
    nba_coaches.`Career P. Games`,
    nba_coaches.`Career P. Wins`,
    nba_coaches_sal.`C.Salary`
 From 
 nba_coaches
 Join
nba_coaches_sal
ON 
nba_coaches.coaches = nba_coaches_sal.coach;



 Select
	wnba_coaches.`wnba coaches`,
    wnba_coaches.`wnba team`,
    wnba_coaches.`WNBA P.Games`,
    wnba_coaches.`WNBA P.Wins`,
    wnba_coaches.`WNBA P.Losses`,
    wnba_coaches_sal.`wnba c. salaries`
 From 
 wnba_coaches
 JOIN 
    wnba_coaches_sal
ON 
    wnba_coaches.`wnba coaches` = wnba_coaches_sal.`wnba coach`
order by 
	wnba_coaches.`WNBA P.Games` DESC;
   