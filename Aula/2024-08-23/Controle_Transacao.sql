drop database PoupeBem;
create database PoupeBem;

use PoupeBem;

create table cliente(
id_cliente int auto_increment,
nome varchar(50),
telefone char(15),
endereco varchar(50),
email varchar(100),
primary key(id_cliente));
create table conta_corrente(
id_conta int auto_increment,
saldo numeric(9,2),
id_cliente int,
primary key(id_conta),
foreign key(id_cliente)references cliente(id_cliente));
create table conta_poupanca(
id_poupanca int auto_increment,
saldo numeric(9,2),
id_cliente int,
primary key(id_poupanca),
foreign key(id_cliente)references cliente(id_cliente));

Select * from cliente;
Set autocommit=0;
Begin work;
insert into cliente
values (1,'Amoedo','11999786543','Av. Paulista, n. 100',
'amo.edo@gmail,com'),
(2, 'Luiz','12999786549','Av. do Triplex, n. 200', 'lu.la@gmail,com');
Select * from cliente;
Commit; /*Confirma as alteraçoes dos dados*/


begin work;
insert into conta_corrente
values (1,'1000',1);

select * from conta_corrente;

insert into conta_poupanca
values (1,'10000',1);

select * from conta_poupanca;

rollback; /*desfaz as alterações dos dados*/


begin work;
insert into conta_corrente
values (1,'1000',1);

select * from conta_corrente;

insert into conta_poupanca
values (1,'10000',1);

select * from conta_poupanca;
Commit;


