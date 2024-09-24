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


-- dia 15-03-2024
use mepoupe;
-- 1 A
INSERT INTO cliente (nome, CPF, sexo, dt_nasc, telefone, email) VALUES
('Barack Obama', '01234567890', 'M', '1961-08-04', '11987654321', 'barack@example.com'),
('Angela Merkel', '11223344556', 'F', '1954-07-17', '491234567890', 'angela@example.com'),
('Xi Jinping', '22334455667', 'M', '1953-06-15', '8613800000000', 'xi@example.com'),
('Emmanuel Macron', '33445566778', 'M', '1977-12-21', '33123456789', 'emmanuel@example.com'),
('Justin Trudeau', '44556677889', 'M', '1971-12-25', '16135551212', 'justin@example.com');


-- 1 B
-- Criar novas contas com data de criação entre janeiro e março de 2024
INSERT INTO conta_corrente (dt_hora_abertura, saldo, status_conta, cod_cliente) VALUES
('2024-02-05', 1500, 'Ativa', 3), -- Nova conta de Barack Obama
('2024-02-10', 2500, 'Ativa', 4), -- Nova conta de Angela Merkel
('2024-03-01', 1800, 'Ativa', 5), -- Nova conta de Xi Jinping
('2024-03-10', 2200, 'Ativa', 6), -- Nova conta de Emmanuel Macron
('2024-03-20', 1900, 'Ativa', 7); -- Nova conta de Justin Trudeau

-- Inserir novos registros de saques para as contas antigas e novas contas
INSERT INTO registro_saque (cod_conta, dt_saque, valor_saque) VALUES
(1, '2024-01-05', 100), -- Saque na conta de Bill
(2, '2024-02-10', 150), -- Saque na conta de Trump
(3, '2024-01-20', 50),  -- Saque na conta de Barack Obama
(4, '2024-02-25', 70),  -- Saque na conta de Angela Merkel
(5, '2024-03-05', 80),  -- Saque na conta de Xi Jinping
(6, '2024-03-18', 60),  -- Saque na conta de Emmanuel Macron
(7, '2024-03-25', 90);  -- Saque na conta de Justin Trudeau

-- Inserir novos registros de depósitos para as contas antigas e novas contas
INSERT INTO registro_deposito (cod_conta, dt_deposito, valor_deposito) VALUES
(1, '2024-03-01', 200), -- Depósito na conta de Bill
(2, '2024-03-15', 300), -- Depósito na conta de Trump
(3, '2024-01-25', 300),  -- Depósito na conta de Barack Obama
(4, '2024-02-28', 500),  -- Depósito na conta de Angela Merkel
(5, '2024-03-10', 700),  -- Depósito na conta de Xi Jinping
(6, '2024-03-22', 400),  -- Depósito na conta de Emmanuel Macron
(7, '2024-03-28', 600);  -- Depósito na conta de Justin Trudeau



-- 2
/*Utilizando o operador UNION escreva o comando SQL que irá gerar o relatório
contendo o nome do cliente, o código da conta e total de depósitos e na sequência
mostre o nome do cliente, o código da conta e saques efetuados. Obs.: Utilizar a
função concat para concatenar “Depositos:” e o total de depositos, e “Saques:” com o
total de saques. Utilize a função cast para converter o valor decimal para char.*/
use mepoupe;
select c.nome, cc.cod_conta, CONCAT('Depositos: ', CAST(SUM(rd.valor_deposito) as char)) as relatorio
from cliente c
left join conta_corrente cc on c.cod_cliente = cc.cod_cliente
left join registro_deposito rd on cc.cod_conta = rd.cod_conta
GROUP BY c.nome, cc.cod_conta

union

select c.nome,cc.cod_conta,CONCAT('Saques: ', CAST(SUM(rs.valor_saque) as char)) as relatorio       
from cliente c
left join conta_corrente cc on c.cod_cliente = cc.cod_cliente
left join registro_saque rs on cc.cod_conta = rs.cod_conta
group by c.nome, cc.cod_conta;


/*2) Utilizando operadores de junção de tabelas responda as questões abaixo:
a) Listar o número da conta, nome, telefone e email dos clientes que são titulares de contas
que não foram movimentadas nos últimos 6 meses. Considere como operação de
movimentação saques e depósitos. (Utilize operadores de Junção e Subconsultas para fazer o
relatório).*/

select cc.cod_conta, c.nome, c.telefone, c.email
from conta_corrente cc join cliente c on cc.cod_cliente=c.cod_cliente
where not exists(
select 1
from registro_saque rs
where rs.cod_conta = cc.cod_conta and rs.dt_saque >= DATE_SUB(NOW(), interval 6 month)
)AND NOT EXISTS (
    select 1
    from registro_deposito rd
    where rd.cod_conta = cc.cod_conta and rd.dt_deposito >= DATE_SUB(NOW(), interval 6 month)
);

/*
b) Listar o código da conta, ano, mês, o valor total de saques e o valor total de depositos. Para
as contas onde não houveram saques imprimir a mensagem “Sem registro de saque”. Para as
contas onde não houveram depositos imprimir a mensagem “Sem registro de depositos”.
(Utilizar a função if, operadores de junção e operador UNION ALL).*/

select cod_conta, year(dt_saque) as ano, month(dt_saque) as mes, 
concat('saques: ', if(sum(valor_saque) is null, 'sem registro', sum(valor_saque))) as movimento
from registro_saque
group by cod_conta, year(dt_saque), month(dt_saque)

union all

select cod_conta, year(dt_deposito) as ano, month(dt_deposito) as mes,
    concat('depositos: ', if(sum(valor_deposito) is null, 'sem registro', sum(valor_deposito))) as movimento
from registro_deposito
group by cod_conta, year(dt_deposito), month(dt_deposito);



/*c) Para o mês atual, listar o número da conta, nome do cliente e a quantidade de saques
efetuados na conta. Para as contas onde não houveram saques a quantidade retornada deve ser
zero. Utilizar os operadores de junção.*/

select cc.cod_conta, c.nome as nome_cliente, count(rs.cod_saque) as quantidade_saques
from conta_corrente cc
join cliente c on cc.cod_cliente = c.cod_cliente
left join registro_saque rs on cc.cod_conta = rs.cod_conta and year(rs.dt_saque) = year(now()) and month(rs.dt_saque) = month(now())
group by cc.cod_conta, c.nome;




/*d) Listar o nome do cliente, cpf e número da conta de todos os clientes que são titulares de
contas com saldo superior a R$ 100.000,00 .*/
select c.nome as nome_cliente, c.cpf,
    cc.cod_conta
from cliente c
join conta_corrente cc on c.cod_cliente = cc.cod_cliente
where cc.saldo > 100000.00;

-- Saldo Final
select c.nome, c.cpf, cc.cod_conta
from cliente c
join conta_corrente cc on c.cod_cliente = cc.cod_cliente
left join (
    select cod_conta, sum(valor_deposito) as total_depositos
    from registro_deposito
    group by cod_conta
) as depositos on cc.cod_conta = depositos.cod_conta
left join (
    select cod_conta, sum(valor_saque) as total_saques
    from registro_saque
    group by cod_conta
) as saques on cc.cod_conta = saques.cod_conta
where cc.saldo + coalesce(total_depositos, 0) - coalesce(total_saques, 0) > 100000.00;



/*3) Dê o código SQL correspondente às consultas solicitadas. Utilize subconsultas.
a) Liste os dados dos clientes que realizaram o maior valor de depósito no mês corrente. Obs.:
Eliminar possíveis repetições.*/

select c.cod_cliente, c.nome, c.cpf, c.sexo, c.dt_nasc, c.telefone, c.email
from cliente c
join (
    select cc.cod_cliente
    from conta_corrente cc
    join registro_deposito rd on cc.cod_conta = rd.cod_conta
    where year(rd.dt_deposito) = year(now()) and month(rd.dt_deposito) = month(now())
    order by rd.valor_deposito desc
    limit 1
) as max_dep_cliente on c.cod_cliente = max_dep_cliente.cod_cliente;

/*b) Listar o cpf, nome, telefone, email e número da conta dos clientes que realizaram saques
com valores acima da média durante o ano de 2024.*/
select c.cpf, c.nome, c.telefone, c.email, cc.cod_conta
from cliente c
join conta_corrente cc on c.cod_cliente = cc.cod_cliente
join registro_saque rs on cc.cod_conta = rs.cod_conta
where year(rs.dt_saque) = 2024
and rs.valor_saque > (
    select avg(valor_saque)
    from registro_saque
    where year(dt_saque) = 2024
);


/*c) Listar as informações dos clientes que efetuaram abertura de contas no mês de janeiro ou
fevereiro.*/
select c.*
from cliente c
join conta_corrente cc on c.cod_cliente = cc.cod_cliente
where month(cc.dt_hora_abertura) in (1, 2);

/*d) Listar o número da conta, saldo e data de abertura de todas as contas criadas no ano de
2024 por clientes do sexo feminino.*/

select cc.cod_conta, cc.saldo, cc.dt_hora_abertura
from conta_corrente cc
join cliente c on cc.cod_cliente = c.cod_cliente
where year(cc.dt_hora_abertura) = 2024
and c.sexo = 'f';

