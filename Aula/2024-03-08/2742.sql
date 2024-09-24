--- URI Online Judge SQL
--- Copyright URI Online Judge
--- www.urionlinejudge.com.br
--- Problem 2742

create database beecrowd2742;


CREATE TABLE dimensions(
	id INTEGER PRIMARY KEY,
	name varchar(255)
);

CREATE TABLE life_registry(
	id INTEGER PRIMARY KEY,
	name VARCHAR(255),
	omega NUMERIC,
	dimensions_id INTEGER REFERENCES dimensions (id)
);


INSERT INTO dimensions(id, name)
VALUES 
      (1, 'C774'),
      (2, 'C784'),
      (3, 'C794'),
      (4, 'C824'),
      (5, 'C875');
      
INSERT INTO life_registry(id, name, omega, dimensions_id)
VALUES
	  (1, 'Richard Postman', 5.6, 2),	
	  (2, 'Simple Jelly', 1.4, 1),	
	  (3, 'Richard Gran Master', 2.5, 1),	
	  (4, 'Richard Turing', 6.4, 4),	
	  (5, 'Richard Strall',	1.0, 3);
use beecrowd2742;
  
  /*  Execute this query to drop the tables */
  -- DROP TABLE life_registry, dimensions; 
  
  /*Prazo: 1
Richard é um cientista famoso por sua teoria do multiverso, onde descreve cada conjunto hipotético de universos paralelos por meio de um banco de dados. 
Graças a isso agora você tem um emprego..
Como primeira tarefa, você deve selecionar cada Richard das dimensões C875 e C774, juntamente com sua probabilidade de existência (o famoso fator N) com três casas decimais de precisão.
Lembre-se que o fator N é calculado multiplicando o valor ômega por 1.618. Os dados devem ser classificados pelo menor valor ômega.*/


select l.name, round((l.omega * 1.618), 3) AS "Fator N" 
from life_registry l join dimensions d on 
	 l.dimensions_id = d.id 
where d.name in ('C875', 'C774') and l.name like 'Richard%'
order by l.omega asc;