use aula_proc;

CREATE TABLE curso_backup(
Cod_curso int auto_increment primary key,
Sigla_curso Varchar(7) not null,
Nome_curso Varchar(50) not null,
dt_exclusao datetime,
usuario_exclusao varchar(30));


delimiter $
create trigger fazbackup after delete on curso for each row
begin
insert into curso_backup values
(OLD.cod_curso,OLD.sigla_curso,OLD.nome_curso,now()
,user());
end $
delimiter ;

Select * from curso_backup;

-- para acionar o trigger é necessário deletar algum dado da tabela curso
delete from curso where cod_curso>=1;

Use aula_proc;

create table professor(
cod_prof int auto_increment primary key,
nome varchar(50),
sexo char(1),
area varchar(30),
titulacao varchar(20),
Salario numeric(7,2));

drop trigger verificaRestricao;
delimiter $
CREATE TRIGGER verificaRestricao BEFORE INSERT ON professor
FOR EACH ROW
BEGIN
DECLARE msg varchar(255);
IF (new.sexo != 'F' and new.sexo!='M') THEN
SET msg = 'O sexo do professor deve ser definido como M ou F!';
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg;
else if (new.salario<1212.00) then
SET msg = 'Salario não pode ser inferior a R$ 1212.00';
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg;
end if;
end if;
END $
delimiter ;

-- outra maneira:
delimiter $
CREATE TRIGGER verificaRestricao BEFORE INSERT ON professor
FOR EACH ROW
BEGIN
DECLARE msg varchar(255);
DECLARE erro CONDITION FOR SQLSTATE '45000';
IF (new.sexo != 'F' and new.sexo!='M') THEN
SIGNAL erro
SET MESSAGE_TEXT = 'Valor Invalido para o sexo!';

else if (new.salario<1212.00) then
SIGNAL erro
SET MESSAGE_TEXT = 'Salario inferior a 1212.00!';
end if;
end if;
END $
delimiter ;


insert into professor values(10,'Maria','X','Educacao','Doutorado',1,900);

delimiter $
create trigger testaSalUpdate before update on professor for each row
begin
if(new.salario<old.salario) then
set new.salario=old.salario;
end if;
end $
delimiter ;

update professor set salario=880 where cod_prof=1;

select * from professor;
