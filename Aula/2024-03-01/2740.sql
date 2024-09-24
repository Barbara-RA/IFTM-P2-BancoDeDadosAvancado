--- URI Online Judge SQL
--- Copyright URI Online Judge
--- www.urionlinejudge.com.br
--- Problem 2740

create database beecrowdEx2740;
use beecrowdEx2740;

CREATE TABLE league(
  position INTEGER,
  team CHARACTER VARYING (255)
);


INSERT INTO league(position, team)
VALUES (1, 'The Quack Bats'),
       (2, 'The Responsible Hornets'),
       (3, 'The Bawdy Dolphins'),
       (4, 'The Abstracted Sharks'),
       (5, 'The Nervous Zebras'),
       (6, 'The Oafish Owls'),
       (7, 'The Unequaled Bison'),
       (8, 'The Keen Kangaroos'),
       (9, 'The Left Nightingales'),
       (10, 'The Terrific Elks'),
       (11, 'The Lumpy Frogs'),
       (12, 'The Swift Buffalo'),
       (13, 'The Big Chargers'),
       (14, 'The Rough Robins'),
       (15, 'The Silver Crocs');

  
  /*  Execute this query to drop the tables */
  -- DROP TABLE league; --


(select 'Podium:',team
from league
limit 0,3)
union
(select 'Demoted:',team
from league
limit 13,2);

-- ajuste para ler no beecrowd
(SELECT 'Podium: ' || team AS name
FROM league
ORDER BY position ASC
LIMIT 3)

UNION ALL

(SELECT 'Demoted: ' || team AS name
FROM league
ORDER BY position ASC
LIMIT 2 OFFSET 13);
