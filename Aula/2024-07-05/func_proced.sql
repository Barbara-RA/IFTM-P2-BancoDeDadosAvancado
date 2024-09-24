drop database if exists aula_proc;

Create database aula_proc;

Use aula_proc;

CREATE TABLE curso(
Cod_curso int auto_increment primary key,
Sigla_curso Varchar(7) not null,
Nome_curso Varchar(50) not null);

-- criando procedimento 
DELIMITER $
CREATE PROCEDURE sp_curso_inserir (var_sigla
varchar(7), var_nome varchar(50))
BEGIN
Insert INTO curso(sigla_curso,nome_curso)
VALUES (var_sigla,var_nome);
END $
DELIMITER ;


-- Inserindo informações

call sp_curso_inserir('ADM','Administração');
call sp_curso_inserir('LCOMP','Licenciatura em Computação');

select * from curso;

/*Comando REPLACE
○ Insere um novo registro ou atualiza se o valor informado como chave primária já existir na tabela*/
Replace INTO curso VALUES (1,'ADM','Administração');

DELIMITER $
CREATE PROCEDURE sp_curso_inserir_atualizar (
var_cod int,
var_Sigla varchar(7),
var_nome varchar(50))
BEGIN
Replace INTO curso VALUES (var_cod,var_sigla,var_nome);
END $
Delimiter ;

call sp_curso_inserir_atualizar(1,'ADM','Administração');
Select * from curso;
call sp_curso_inserir_atualizar(2,'IF','Informatica');
Select * from curso;
call sp_curso_inserir_atualizar(2,'INF','Informatica');
Select * from curso;

DELIMITER $$
CREATE PROCEDURE sp_cursos_listar( var_cod Int) 
BEGIN
IF(var_cod IS NULL) THEN
SELECT * FROM curso;
ELSE
SELECT * FROM curso
where cod_curso=var_cod;
END IF;
END $$


Call sp_cursos_listar(1);

Call sp_cursos_listar(null);

Call sp_cursos_listar(5);
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE sp_curso_excluir(var_cod int)
BEGIN
DELETE FROM curso WHERE cod_curso =

var_cod;
END $$
Delimiter ;

Select * from curso;
Call sp_curso_excluir(2);
Select * from curso;
Call sp_curso_excluir(3);
Select * from curso;

-- declaração de variável
-- set var_data_atual =current_date();

