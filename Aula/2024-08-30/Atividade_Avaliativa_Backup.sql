use farm2town;
-- 1 
-- A
SHOW VARIABLES LIKE "secure_file_priv";

SELECT * FROM cliente
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/relatorio.csv'
FIELDS TERMINATED BY ':'
ENCLOSED BY ''
LINES TERMINATED BY '\n';

-- B
CREATE TABLE relatorio_geral(
    cod_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(60) NOT NULL,
    endereco VARCHAR(100) NOT NULL,
    email VARCHAR(60) NOT NULL UNIQUE,
    telefone VARCHAR(20) NOT NULL UNIQUE
); 

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/relatorio.csv'
INTO TABLE relatorio_geral
FIELDS TERMINATED BY ':'
ENCLOSED BY ''
LINES TERMINATED BY '\n';

SELECT * FROM relatorio_geral;

-- 2
-- a) Crie uma role para vincular usuários que vão trabalhar com algumas tabelas do seu banco de dados (ex.: gerente, estagiario, analista_teste, etc)
CREATE ROLE gerenteAdm;

-- b) Faça a concessão de privilégios para a role que você criou de acordo com a finalidade da role.
GRANT SELECT ON farm2town.* TO gerenteAdm;

-- c) Crie pelo menos dois usuários, um com seu nome e outro com um nome ficticio e defina senhas para esses usuário.
CREATE USER 'barbara'@'localhost' IDENTIFIED BY '2468';
CREATE USER 'lucio'@'localhost' IDENTIFIED BY '13579';

-- d) Associe os dois usuários com a role criada na letra "a".
GRANT gerenteAdm TO 'barbara'@'localhost';
GRANT gerenteAdm TO 'lucio'@'localhost';

-- e) Ative os privilégios para os usuários associados a role. Faça o print dos privilégios dos usuários através do resultado do comando show grants.
SET DEFAULT ROLE ALL TO 'barbara'@'localhost';
SET DEFAULT ROLE ALL TO 'lucio'@'localhost';

SHOW GRANTS FOR 'barbara'@'localhost';
SHOW GRANTS FOR 'lucio'@'localhost';


-- f) Crie uma conexão para o seu usuário e faça o print da tela do workbench que mostra a base de dados e tabela(s) que esse usuário tem acesso.
-- Print Word

-- g) Crie um usuário adm para a sua base de dados e conceda privilégio total e privilégio de repasse de privilégios. Faça o print do comando show grants para esse usuário
CREATE USER 'admin'@'localhost' IDENTIFIED BY '54321';
GRANT ALL ON farm2town.* to 'admin'@'localhost';
GRANT GRANT OPTION ON farm2town.* TO 'admin'@'localhost';
SHOW GRANTS FOR 'admin'@'localhost';


-- h) Utilize o usuário adm para fazer concessão de privilégios extras para o seu usuário. Para isso crie a conexão para o usuário adm e dentro dessa
-- conexão faça a concessão dos privilégios. Faça o print da tela do workbench que o usuário adm se conectou.
GRANT INSERT, UPDATE ON farm2town.entregador TO 'barbara'@'localhost';
SHOW GRANTS FOR 'barbara'@'localhost';

-- i) Revogue o privilégio de repasse de privilégios do adm.
REVOKE GRANT OPTION ON farm2town.* FROM 'admin'@'localhost';
SHOW GRANTS FOR 'admin'@'localhost';