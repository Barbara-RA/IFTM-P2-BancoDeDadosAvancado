-- drop database evenIFTM;
create database evenIFTM;
use evenIFTM;
create table Usuario(
cod_user int auto_increment primary key,
nome_user varchar(50),
sexo char(1),
dt_nasc date,
email varchar(100),
cpf char(11)
);

create table Categoria(
cod_categoria int auto_increment primary key,
nome_categoria varchar(20)
);

create table Atividade(
cod_atividade int auto_increment primary key,
titulo varchar(100),
carga_horaria int,
tipo_atividade varchar(30),
dt_inicio_inscricao datetime,
dt_fim_inscricao  datetime,
dt_realizacao datetime,
valor_ingresso numeric(7,2),
cod_categoria int,
foreign key(cod_categoria) references Categoria(cod_categoria));

create table Inscricao(
cod_inscricao int auto_increment primary key,
dt_inscricao datetime,
cod_user int,
cod_atividade int,
foreign key(cod_user) references Usuario(cod_user),
foreign key(cod_atividade) references Atividade(cod_atividade));



insert into Categoria values (1, "Ensino");
insert into Categoria values (2, "Pesquisa");
insert into Categoria values (3, "Extensão");