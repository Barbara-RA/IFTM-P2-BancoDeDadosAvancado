--- URI Online Judge SQL
--- Copyright URI Online Judge
--- www.urionlinejudge.com.br
--- Problem 2617
create database beecrowd2617;
use beecrowd2617;
CREATE TABLE providers (
  id numeric PRIMARY KEY,
  name varchar(255),
  street varchar(255),
  city varchar(255),
  state char(2)
);

CREATE TABLE products (
  id numeric PRIMARY KEY,
  name varchar (255),
  amount numeric,
  price numeric,
  id_providers numeric REFERENCES providers (id)
);


INSERT INTO providers (id, name, street, city, state)
VALUES
  (1,	'Ajax SA',	'Presidente Castelo Branco',	'Porto Alegre',	'RS'),
  (2,	'Sansul SA',	'Av Brasil',	'Rio de Janeiro',	'RJ'),
  (3,	'South Chairs',	'Av Moinho',	'Santa Maria', 	'RS'),
  (4,	'Elon Electro',	'Apolo',	'São Paulo',	'SP'),
  (5,	'Mike Electro',	'Pedro da Cunha',	'Curitiba',	'PR');
  
INSERT INTO products (id, name, amount, price, id_providers)
VALUES
  (1,	'Blue Chair',	30,	300.00,	5),
  (2,	'Red Chair',	50,	2150.00,	1),
  (3,	'Disney Wardrobe',	400,	829.50,	4),
  (4,	'Blue Toaster',	20,	9.90,	3),
  (5,	'Solar Panel',	30,	3000.25,	4);
  
  
  /*  Execute this query to drop the tables */
  -- DROP TABLE products, providers; --
  
  /*
O setor financeiro encontrou alguns problemas na entrega de um de nossos fornecedores, a entrega dos produtos não corresponde à fatura.
Seu trabalho é exibir o nome dos produtos e o nome do fornecedor, para os produtos fornecidos pelo fornecedor 'Ajax SA'.*/

select pr.name,pv.name 
from products pr join providers pv on pv.id=pr.id_providers
where pv.name='Ajax SA';
