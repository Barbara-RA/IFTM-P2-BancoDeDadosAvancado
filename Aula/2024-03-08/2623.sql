--- URI Online Judge SQL
--- Copyright URI Online Judge
--- www.urionlinejudge.com.br
--- Problem 2623
create database beecrowd2623;

use beecrowd2623;
CREATE TABLE categories (
  id numeric PRIMARY KEY,
  name varchar(255)
);

CREATE TABLE products (
  id numeric PRIMARY KEY,
  name varchar (255),
  amount numeric,
  price numeric,
  id_categories numeric REFERENCES categories (id)
);


INSERT INTO categories (id, name)
VALUES
  (1,	'Superior'),
  (2,	'Super Luxury'),
  (3,	'Modern'),
  (4,	'Nerd'),
  (5,	'Infantile'),
  (6,	'Robust'),
  (9,	'Wood');

INSERT INTO products (id, name, amount, price, id_categories)
VALUES
  (1,	'Blue Chair',	30, 300.00,	9),
  (2,	'Red Chair',	200,	2150.00, 2),
  (3,	'Disney Wardrobe',	400,	829.50,	4),
  (4,	'Blue Toaster',	20,	9.90,	3),
  (5,	'Solar Panel',	30,	3000.25,	4);


/*  Execute this query to drop the tables */
-- DROP TABLE products, categories; --

/*O setor de vendas precisa de um relatório para saber quais produtos restam em estoque.

Para ajudar o setor de vendas, exiba o nome do produto e o nome da categoria para produtos cujo valor seja superior a 100 e o ID da categoria seja 1,2,3,6 ou 9.
Mostre os resultados em ordem crescente por ID da categoria.*/

select  p.name, c.name
from products p join categories c on
     p.id_categories = c.id
where p.amount > 100 and p.id_categories IN(1, 2, 3, 6, 9);
