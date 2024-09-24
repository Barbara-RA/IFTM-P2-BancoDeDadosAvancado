create database aulo3008Backup;
use aulo3008Backup;


SHOW VARIABLES LIKE 'secure_file_priv';
-- Pegar o endereço que essa linha disponibiliza


SELECT * FROM aulo3008Backup.cidade 
-- Inverter a barra do endereço e informar o nome do arquivo.css
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Teste02.csv'
FIELDS TERMINATED BY '|'
ENCLOSED BY '' 
LINES TERMINATED BY '\n';

Select *
from information_schema.user_privileges;
create user 'pedro'@'localhost' identified by '12345';


create user 'carlos'@'localhost' ; -- sem definir senha

-- definindo a senha posteriormente ou alterando
ALTER USER 'carlos'@'localhost'
IDENTIFIED BY '12345';

/*CREATE USER maria IDENTIFIED BY 'senha123';
Equivalente à:
CREATE USER 'maria'@'%' IDENTIFIED BY 'senha123';*/

SHOW VARIABLES LIKE 'validate_password%'; 
set GLOBAL validate_password.policy="LOW";


-- para comparilhar uma tabela com o convidade
grant select
on empresa.cargo to 'carlos'@'localhost';

-- ver permissões para o usuário
show grants
for 'carlos'@'localhost';


-- para comparilhar todas as tabelas do banco com o convidado
-- caso vc permita que ele altere tem que colocar  grant select,update

grant select
on empresa.* to 'carlos'@'localhost';


-- para comparilhar todo o banco com o convidado
grant select
on *.* to 'carlos'@'localhost';

-- removendo privilegios
revoke all privileges on *.* from 'carlos'@'localhost';
