drop database if exists MePoupe;
create database MePoupe;
use MePoupe;

create table cliente(
cod_cliente int auto_increment,
nome varchar(50),
CPF char(11),
sexo char(1),
dt_nasc date,
telefone char(15),
email varchar(100),
primary key(cod_cliente));

insert into cliente values(1,'Bill Clinton','12999786543','M','1940-04-12', '11999786543',
 'william@gmail.com'),
 (2,'Trump', '13999786544', 'M','1942-05-10', '11999186543', 'trump@gmail.com');
 
 
create table conta_corrente(
cod_conta int auto_increment,
dt_hora_abertura datetime,
saldo numeric(9,2),
status_conta varchar(15),
cod_cliente int,
primary key(cod_conta),
foreign key(cod_cliente)references cliente(cod_cliente));

insert into conta_corrente values (1,'2020-03-15 13:50:00', 50,'Ativa',1);
insert into conta_corrente values (2,'2020-03-18 15:30:00',500,'Ativa',2);


create table Registro_Saque(
cod_saque int auto_increment,
cod_conta int,
dt_saque datetime,
valor_saque numeric(9,2),
primary key(cod_saque),
foreign key(cod_conta)references conta_corrente(cod_conta));

 create table Registro_Deposito(
cod_deposito int auto_increment,
cod_conta int,
dt_deposito datetime,
valor_deposito numeric(9,2),
primary key(cod_deposito),
foreign key(cod_conta)references conta_corrente(cod_conta));


insert into registro_saque values(1,2,'2020-03-20 14:00:00', 20);
insert into registro_saque values(2,2,'2020-04-20 17:30:00', 80);


insert into registro_deposito values(1,2,'2020-03-19 16:10:00', 40);
insert into registro_deposito values(2,2,'2020-04-22 19:15:00', 800);

select * from registro_deposito;



/*1) Crie uma função to_br_date que receba como entrada um tipo date e retorne uma data no padrão brasileiro(dd/mm/yyyy) utilizando as funções pré-definidas (substring e
concat_ws). Observe que o retorno da função será do tipo char. Mostre um exemplo de utilização dessa função em uma das tabelas da base de dados.*/

-- DROP FUNCTION IF EXISTS to_br_date;
delimiter $$
create function to_br_date(input_date date)
returns char(10)
deterministic
begin
    declare br_date char(10);

    -- Extrair dia, mês e ano da data de entrada
    set br_date = concat_ws('/',
        substring(input_date, 9, 2), -- dia
        substring(input_date, 6, 2), -- mês
        substring(input_date, 1, 4)  -- ano
    );

    return br_date;
end $$
delimiter ;

-- Teste
select cod_cliente, nome, to_br_date(dt_nasc) as data_nascimento_formatada
from cliente;

/*2) Crie uma função que dada uma data, retorne o nome do dia da semana (segunda-feira, terça-feira, etc) no qual aquela data ocorreu.*/
delimiter $$
create function nome_dia_semana(input_date date)
returns varchar(20)
deterministic
begin
    declare dia_semana varchar(20);
    
    set dia_semana = case dayofweek(input_date)
        when 1 then 'domingo'
        when 2 then 'segunda-feira'
        when 3 then 'terça-feira'
        when 4 then 'quarta-feira'
        when 5 then 'quinta-feira'
        when 6 then 'sexta-feira'
        when 7 then 'sábado'
    end;

    return dia_semana;
end $$

delimiter ;

select nome_dia_semana('1994-10-08') as dia_da_semana;

/*3)Crie uma função para formatar um CPF no padrão xxx.xxx.xxx-xx*/
-- DROP FUNCTION IF EXISTS formatar_cpf;
delimiter $$

create function formatar_cpf(cpf char(11))
returns char(14)
deterministic
begin
    return concat(
        substring(cpf, 1, 3), '.', 
        substring(cpf, 4, 3), '.', 
        substring(cpf, 7, 3), '-', 
        substring(cpf, 10, 2)
    );
end $$

delimiter ;

insert into cliente (nome, cpf, sexo, dt_nasc, telefone, email) values
('barbara ramos', '10134598712', 'f', '1994-08-10', '34966665555', 'barbara.alves@email.com');

-- Teste
select cod_cliente, nome, cpf, formatar_cpf(cpf) as cpf_formatado
from cliente
where nome = 'barbara ramos';


/*4) Crie um procedimento que liste o valor médio das depósitos realizadas por dia da semana, recebendo como parâmetro o ano e o mês.
Se o valor do mês estiver null, listar para todos os meses do ano. Mostrar o nome do dia da semana e a média de depósitos.
Aplicar a função criada na questão 2.*/

-- Função
delimiter $$
create function dia_da_semana(data date)
returns varchar(20)
deterministic
begin
    declare dia_semana varchar(20);
    case dayofweek(data)
        when 1 then set dia_semana = 'Domingo';
        when 2 then set dia_semana = 'Segunda-feira';
        when 3 then set dia_semana = 'Terça-feira';
        when 4 then set dia_semana = 'Quarta-feira';
        when 5 then set dia_semana = 'Quinta-feira';
        when 6 then set dia_semana = 'Sexta-feira';
        when 7 then set dia_semana = 'Sábado';
    end case;
    return dia_semana;
end $$

delimiter ;


-- Procedimento:
delimiter $$
create procedure media_depositos_por_dia_da_semana(
    in var_ano int,
    in var_mes int
)
begin
    if var_mes is null then
        select 
            dia_da_semana(dt_deposito) as dia_semana,
            avg(valor_deposito) as media_depositos
        from 
            registro_deposito
        where 
            year(dt_deposito) = var_ano
        group by 
            dia_da_semana(dt_deposito)
        order by 
            media_depositos desc;
    else
        select 
            dia_da_semana(dt_deposito) as dia_semana,
            avg(valor_deposito) as media_depositos
        from 
            registro_deposito
        where 
            year(dt_deposito) = var_ano
            and month(dt_deposito) = var_mes
        group by 
            dia_da_semana(dt_deposito)
        order by 
            media_depositos desc;
    end if;
end $$
delimiter ;

insert into registro_deposito (cod_conta, dt_deposito, valor_deposito) values
(1, '2024-07-01 10:00:00', 150.00);
insert into registro_deposito (cod_conta, dt_deposito, valor_deposito) values
(2, '2024-01-15 09:00:00', 200.00);

-- Teste
call media_depositos_por_dia_da_semana(2024, 7);
call media_depositos_por_dia_da_semana(2024, null);
