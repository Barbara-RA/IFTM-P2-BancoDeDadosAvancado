use aula_proc;
Select current_date() into @data_atual;
-- Set @data_atual=current_date();

-- Exemplo: PREPARE comando FROM 'SELECT SQRT(POW(?,2) + POW(?,2)) AS hipotenusa';
-- set: atribui um valor para uma variável
-- PREPARE comando FROM 'SELECT SQRT(POW(?,2) + POW(?,2)) AS hipotenusa';
-- set @a=6, set @b=8;
-- Select @a,@b;
-- ● Execução do comando
-- ○ Informar as variáveis que possuem os valores a serem usados na execução
-- ● Usar o comando Execute
-- ● Exemplo
-- EXECUTE comando USING @a, @b;
/*
SET @tabela = 'professor';
SET @s = CONCAT('SELECT * FROM ', @tabela); -- select @s
PREPARE listaTabela FROM @s;
EXECUTE listaTabela;


delimiter $$
create procedure listaDadostabela(var_nome_tabela varchar(30))
begin
set @tabela=var_nome_tabela;
set @comando=CONCAT('SELECT * FROM ', @tabela);
PREPARE listar_dados FROM @comando; EXECUTE listar_dados;
end
$$
delimiter ;

call listaDadosTabela('professor');
call listaDadosTabela('curso');*/

CREATE TABLE calendario(
id INT AUTO_INCREMENT,
data_calendario DATE UNIQUE,
dia TINYINT NOT NULL,
mes TINYINT NOT NULL,
ano INT NOT NULL,
PRIMARY KEY(id)
);

DELIMITER $$
CREATE PROCEDURE InsereCalendario(dt DATE)
BEGIN
INSERT INTO calendario(
data_calendario,
dia,
mes,
ano
)
VALUES(
dt,
EXTRACT(DAY FROM dt),
EXTRACT(MONTH FROM dt),
EXTRACT(YEAR FROM dt)
);
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE PreencheCalendario(
dt_inicio DATE,
dia INT
)
BEGIN
DECLARE cont INT DEFAULT 1;
DECLARE dt DATE DEFAULT dt_inicio;
WHILE cont<= dia DO
CALL InsereCalendario(dt);
SET cont = cont + 1;
SET dt = DATE_ADD(dt,INTERVAL 1 day);
END WHILE;
END$$
DELIMITER ;
call PreencheCalendario('2020-01-01',31);

use empresa;

DELIMITER |
CREATE FUNCTION calculanovovalor(valAntigo numeric(7,2),valPerc
numeric(5,2))
RETURNS numeric(7,2)
-- DETERMINISTIC
BEGIN
DECLARE novovalor,valaumento numeric(7,2);
SET valaumento= valAntigo*(valPerc/100);
set novovalor=valaumento+valAntigo;
RETURN novovalor;
END |
Delimiter ;

select calculanovovalor(salario,5) from cargo;
update cargo set salario=calculanovovalor(salario,5);
Select calculanovovalor(1200,5);

DELIMITER |
CREATE FUNCTION qtdeAnosEmpresa(var_dt_adm date)
RETURNS int
BEGIN
DECLARE qtdeAnos int;
SET qtdeAnos=(select timestampdiff(YEAR,var_dt_adm,current_date));
RETURN qtdeAnos;
END |
Delimiter ;