--- URI Online Judge SQL
--- Copyright URI Online Judge
--- www.urionlinejudge.com.br
--- Problem 2609
create database beecrowd2609;
use beecrowd2609;
CREATE TABLE categories (
  id numeric PRIMARY KEY,
  name varchar (255)
);

CREATE TABLE products (
  id numeric PRIMARY KEY,
  name varchar(50),
  amount numeric,
  price numeric(7,2),
  id_categories numeric REFERENCES categories (id)
);

INSERT INTO categories (id, name)
VALUES 
  (1,	'wood'),
  (2,	'luxury'),
  (3,	'vintage'),
  (4,	'modern'),
  (5,	'super luxury');
  
INSERT INTO products (id, name, amount, price, id_categories)
VALUES 
  (1,	'Two-doors wardrobe', 100,	800,	1),
  (2,	'Dining table',	1000,	560,	3),
  (3,	'Towel holder',	10000,	25.50,	4),
  (4,	'Computer desk',	350,	320.50,	2),
  (5,	'Chair',	3000,	210.64,	4),
  (6,	'Single bed',	750,	460,	1);
  
  /*  Execute this query to drop the tables */
  -- DROP TABLE categories,products; --
  
  /*
Como de costume o setor de vendas está fazendo uma análise de quantos produtos temos em estoque, e você pode ajudá-los.
Em seguida, seu trabalho exibirá o nome e a quantidade de produtos de cada categoria.*/

select c.name, sum(p.amount) sum
from categories c join products p on c.id=id_categories
group by 1 
order by 1;
