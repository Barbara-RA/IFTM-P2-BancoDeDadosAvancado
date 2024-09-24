drop database MePoupe;
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

insert into cliente values(1,'Bill Clinton','12999786543','M','1940-04-12', '11999786543', 'william@gmail.com'),
 (2,'Trump', '13999786544', 'M','1942-05-10', '11999186543', 'trump@gmail.com'),
 (3,'Lula','12345678901','M','1945-10-27', '11987654321', 'lula@gmail.com'), -- Adicionado: Lula
 (4,'Dilma','10987654321','F','1947-12-14', '11965432100', 'dilma@gmail.com'); -- Adicionado: Dilma
 
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
insert into conta_corrente values (3,'2024-01-10 10:00:00',1000,'Ativa',3), -- Adicionado: Conta de Lula
 (4,'2024-01-15 11:00:00',1500,'Ativa',4); -- Adicionado: Conta de Dilma

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
insert into registro_saque values(3,3,'2024-01-20 12:00:00', 100), -- Adicionado: Saque de Lula
 (4,4,'2024-02-01 15:00:00', 200); -- Adicionado: Saque de Dilma

insert into registro_deposito values(1,2,'2020-03-19 16:10:00', 40);
insert into registro_deposito values(2,2,'2020-04-22 19:15:00', 800);
insert into registro_deposito values(3,3,'2024-01-15 09:00:00', 500), -- Adicionado: Depósito de Lula
 (4,4,'2024-01-25 10:30:00', 1000); -- Adicionado: Depósito de Dilma

select * from registro_deposito;
    
    
-- Fim BD_MePoupe

/* 1 - Crie o trigger tr_red_clients que irá automaticamente incluir em uma tabela os dados dos clientes que entrarem no vermelho (saldo<0) ao realizar um saque. 
As informações dessa tabela deve conter o codigo do cliente, o nome do cliente, o CPF, número da conta, data que entrou no vermelho, data que saiu do vermelho
(inicialmente esse campo ficará null) e valor da taxa a pagar (também será null no início) .*/


-- Antes de criar o trigger, crie a tabela tb_red_clients;
create table tb_red_clients (
    cod_cliente int,
    nome varchar(50),
    cpf char(11),
    cod_conta int,
    dt_entrou_vermelho datetime,
    dt_saiu_vermelho datetime,
    taxa_pagar decimal(9,2),
    primary key(cod_cliente, cod_conta)
);

/*
Na criação do trigger considerar:
i. Atualizar o saldo do cliente, na tabela conta corrente, de acordo com o valor de saque;
ii. Os clientes têm o limite de R$ 200 para ficar no vermelho. O sistema não deve permitir saques que deixem a conta com um saldo negativo superior a R$ 200.
iii. A inserção na tabela tb_red_clients só deve ser feita se não houver um registro para a conta_corrente em aberto.*/


delimiter $$
create trigger tr_red_clients
before insert on registro_saque
for each row
begin
    declare saldo_atual decimal(9,2);

    select saldo into saldo_atual from conta_corrente where cod_conta = new.cod_conta;

    if saldo_atual - new.valor_saque >= -200 then
        update conta_corrente
        set saldo = saldo_atual - new.valor_saque
        where cod_conta = new.cod_conta;

        if saldo_atual - new.valor_saque < 0 then
            if not exists (
                select 1 from tb_red_clients 
                where cod_conta = new.cod_conta and dt_saiu_vermelho is null
            ) then
                insert into tb_red_clients (cod_cliente, nome, cpf, cod_conta, dt_entrou_vermelho, taxa_pagar)
                select c.cod_cliente, c.nome, c.cpf, cc.cod_conta, new.dt_saque, null
                from cliente c
                join conta_corrente cc on c.cod_cliente = cc.cod_cliente
                where cc.cod_conta = new.cod_conta;
            end if;
        end if;
    else
        signal sqlstate '45000' set message_text = 'saldo insuficiente para saque com limite de R$ 200 no negativo';
    end if;
end$$
delimiter ;

-- Dê exemplo de acionamento do trigger:
insert into registro_saque (cod_conta, dt_saque, valor_saque)
values (1, '2024-07-19 09:00:00', 120.00);
insert into registro_saque (cod_conta, dt_saque, valor_saque)
values (2, '2024-07-19 20:00:00', 250.00);
insert into registro_saque (cod_conta, dt_saque, valor_saque)
values (3, '2024-07-19 12:30:00', 400.00);

select * from tb_red_clients;


/*2 - Cria a função func_calcula_valor_taxa, para computar o valor da taxa a ser paga pelos clientes que ficaram no vermelho, considerando a cobrança de taxa no valor
de R$5,00 por dia. A função deverá ter como parâmetro de entrada a data de inicio e data de término, compreendendo o período que o cliente ficou no vermelho.*/

delimiter $$
create function func_calcula_valor_taxa(dt_inicio date, dt_termino date)
returns decimal(9,2)
begin
    declare dias_no_vermelho int;
    declare taxa_por_dia decimal(9,2) default 5.00;
    declare valor_taxa decimal(9,2);

    set dias_no_vermelho = datediff(dt_termino, dt_inicio);

    set valor_taxa = dias_no_vermelho * taxa_por_dia;

    return valor_taxa;
end$$

/*Crie o trigger tr_redout_clients que irá automaticamente preencher o campo com a data de saída do vermelho, e o valor de taxa a pagar na tabela tb_red_clients
se ao realizar um depósito o saldo do cliente tiver sido alterado de um valor negativo para um valor positivo(saldo>0). */

delimiter $$
create trigger tr_redout_clients
after insert on registro_deposito
for each row
begin
    declare saldo_atual decimal(9,2);
    declare dt_entrou datetime;
    declare valor_taxa decimal(9,2);
    
-- Atualizar o saldo do cliente, na tabela conta corrente, de acordo com o valor de depósito;
    select saldo into saldo_atual from conta_corrente where cod_conta = new.cod_conta;

    update conta_corrente
    set saldo = saldo_atual + new.valor_deposito
    where cod_conta = new.cod_conta;

    if saldo_atual < 0 and saldo_atual + new.valor_deposito >= 0 then
        select dt_entrou_vermelho into dt_entrou
        from tb_red_clients 
        where cod_conta = new.cod_conta and dt_saiu_vermelho is null;
        
-- Utilizar a função func_calcula_valor_taxa para computar o valor da taxa a ser paga pelo cliente.
        set valor_taxa = func_calcula_valor_taxa(dt_entrou, new.dt_deposito);

        update tb_red_clients
        set dt_saiu_vermelho = new.dt_deposito, taxa_pagar = valor_taxa
        where cod_conta = new.cod_conta and dt_saiu_vermelho is null;
    end if;
end$$
delimiter ;

-- Dê exemplo de acionamento do trigger.
insert into registro_deposito (cod_conta, dt_deposito, valor_deposito)
values (1, '2024-07-15 16:00:00', 200.00);
insert into registro_deposito (cod_conta, dt_deposito, valor_deposito)
values (1, '2024-07-19 03:00:00', 200.00);
insert into registro_deposito (cod_conta, dt_deposito, valor_deposito)
values (2, '2024-07-09 22:00:00', 300.00);
insert into registro_deposito (cod_conta, dt_deposito, valor_deposito)
values (3, '2024-07-11 19:30:00', 500.00);

-- verificar a tabela tb_red_clients
select * from tb_red_clients;
