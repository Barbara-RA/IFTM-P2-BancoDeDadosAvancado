drop database if exists farm2town;

create database farm2town;

use farm2town;

create table cliente (
cod_cliente int primary key auto_increment,
nome varchar(60) not null,
endereco varchar(100) not null,
email varchar(60) not null unique,
telefone varchar(20) not null unique
);

create table pessoa_fisica (
cod_pf int primary key auto_increment,
cpf varchar(14) not null,
cod_cliente int,
FOREIGN KEY(cod_cliente) REFERENCES cliente (cod_cliente)
);

create table pessoa_juridica (
cod_pj int primary key auto_increment,
cnpj varchar(20) not null,
nome_responsavel varchar(60) not null,
ie varchar(16) not null,
cod_cliente int,
foreign key(cod_cliente) references cliente(cod_cliente)
);

create table pedido(
cod_pedido int primary key auto_increment,
valor_pedido numeric(10,2) not null,
data_pedido date default (current_date())
);

create table compra(
cod_compra int primary key auto_increment,
nro_cartao varchar(20) not null,
data_compra date default (current_date()),
cod_pedido int,
cod_pf int,
foreign key(cod_pedido) references pedido(cod_pedido),
foreign key(cod_pf) references pessoa_fisica(cod_pf)
);

create table compra_recorrente(
cod_transacao_rec int primary key auto_increment,
recorrencia int default 0,
data_compra date default (current_date()),
nro_cartao varchar(20) not null,
cod_pj int,
cod_pedido int,
foreign key(cod_pj) references pessoa_juridica(cod_pj),
foreign key(cod_pedido) references pedido(cod_pedido)
);

create table prod_organico(
cod_produto int primary key auto_increment,
nome_produto varchar(60) not null,
estoque int default 0,
un_medida varchar(16) not null,
valor_produto numeric(7,2) default 0.00,
disp_recorrencia boolean default true
);

create table item_pedido(
cod_item_pedido int primary key auto_increment,
qtdd_item int default 1,
valor_item numeric(7,2) default 0.01,
cod_pedido int,
cod_produto int,
foreign key(cod_pedido) references pedido(cod_pedido),
foreign key(cod_produto) references prod_organico(cod_produto)
);

create table produtor(
cod_produtor int primary key auto_increment,
nome varchar(60) not null,
cpf varchar(14) unique not null,
endereco varchar(100) not null,
telefone varchar(20) unique not null,
email varchar(60) unique not null,
conta varchar(25) not null,
banco varchar(40) not null
);

create table produz(
cod_producao int primary key auto_increment,
cod_produto int,
cod_produtor int,
foreign key(cod_produto) references prod_organico(cod_produto),
foreign key(cod_produtor) references produtor(cod_produtor)
);

create table selo_qualidade(
cod_selo int primary key auto_increment,
data_validade date not null,
nome_selo varchar(60) not null,
orgao_regulamentador varchar(60) not null,
cod_produtor int,
foreign key(cod_produtor) references produtor(cod_produtor)
);

create table entregador(
cod_entregador int primary key auto_increment,
nome varchar(60) not null,
cpf varchar(14) not null unique,
telefone varchar(20) not null unique,
email varchar(60) not null unique,
conta varchar(25) not null,
banco varchar(40) not null
);

CREATE TABLE entrega (
cod_entrega int primary key auto_increment,
data_entrega date default (current_date()),
avaliacao int,
cod_entregador int,
data_recolhimento date default (current_date()),
cod_pedido int,
cod_cliente int,
foreign key(cod_entregador) references entregador(cod_entregador),
foreign key(cod_pedido) references pedido(cod_pedido),
foreign key(cod_cliente) references cliente(cod_cliente),
check(avaliacao is null or avaliacao between 1 and 5)
);

-- Inserção de valores nas tabelas
INSERT INTO cliente (nome, endereco, email, telefone) VALUES
('João Silva', 'Rua A, 123', 'joao@email.com', '3123-4567'),
('Maria Oliveira', 'Av. B, 456', 'maria@email.com', '99987-6543'),
('Diego Renan da Mata', 'Rua Jerônimo Martins do Nascimento,512', 'diegorenandamata@simsvale.com.br', '98737-0746'),
('Maria Emanuelly Rocha', 'Alameda Adilson Baccili, 399', 'maria-rocha71@amaralmonteiro.com.br', '99261-0235'),
('Gourmeteria Ltda', 'Rua Arapuan, 572', 'qualidade@gourmeteriafernando.com.br', '98581-6007'),
('Seu fogão ME', 'Rua Águas de São Pedro, 187', 'qualidade@seufogao.com.br', '98334-6309'),
('Débora e Yuri Pães e Doces ME', 'Rua Francisco Xavier Rocha, 725', 'auditoria@deboraeyuripaesedocesme.com.br', '99116-5580'),
('Terrinha da Gente LTDA', 'Rua Vinte e Três, 687', 'administracao@terrinhadagenteltda.com.br', '98980-8725');

INSERT INTO pessoa_fisica (cpf, cod_cliente) VALUES
('123.456.789-01', 1),
('987.654.321-09', 2),
('148.688.326-54', 3),
('286.702.736-59', 4);

INSERT INTO pessoa_juridica (cnpj, nome_responsavel, ie, cod_cliente) VALUES
('14.881.004/0001-30', 'Mário Silva', '742516215492', 5),
('50.810.034/0001-10', 'Debora Martins', '248808589265', 6),
('97.912.800/0001-10', 'Fernando Junior', '582725471045', 7),
('67.340.527/0001-36', 'Maria Silveira', '356268410230', 8);

INSERT INTO pedido (valor_pedido, data_pedido) VALUES
(80.00, '2023-10-17'),
(42.75, '2023-10-20'),
(983.00, '2023-10-21'),
(361.75, '2023-10-24'),
(185.75, '2023-10-24'),
(66.00, '2023-11-01'),
(37.00, '2023-11-01'),
(480.50, '2023-11-05'),
(43.50, '2023-11-05'),
(800.00, '2023-11-06'),
(120.50, '2023-11-07'),
(250.00, '2023-11-08'),
(70.25, '2023-11-09'),
(390.75, '2023-11-10'),
(520.50, '2023-11-11'),
(30.00, '2023-11-12'),
(410.75, '2023-11-13'),
(300.50, '2023-11-14'),
(610.00, '2023-11-15'),
(90.25, '2023-11-16'),
(110.75, '2023-11-17'),
(210.50, '2023-11-18'),
(55.00, '2023-11-19'),
(140.75, '2023-11-20'),
(470.25, '2023-11-21'),
(320.50, '2023-11-22'),
(60.00, '2023-11-23'),
(230.75, '2023-11-24'),
(150.50, '2023-11-25'),
(180.00, '2023-11-26'),
(85.25, '2023-11-27'),
(130.75, '2023-11-28');

INSERT INTO pedido (valor_pedido) VALUES
(150.00),
(200.00),
(300.00),
(250.00),
(175.00),
(320.00),
(450.00),
(220.00),
(190.00),
(330.00),
(410.00),
(290.00),
(210.00),
(270.00),
(310.00),
(360.00),
(430.00),
(380.00),
(340.00),
(150.00),
(200.00),
(300.00),
(250.00),
(175.00),
(320.00),
(450.00),
(220.00),
(190.00),
(330.00),
(410.00),
(290.00),
(210.00),
(270.00),
(310.00),
(360.00),
(430.00),
(380.00),
(340.00);

INSERT INTO compra (nro_cartao, data_compra, cod_pedido, cod_pf) VALUES
('1234-5678-9012-3456', '2023-10-17', 1, 1),
('2345-6789-0123-4567', '2023-10-18', 2, 2),
('3456-7890-1234-5678', '2023-10-19', 3, 3),
('4567-8901-2345-6789', '2023-10-20', 4, 4),
('5678-9012-3456-7890', '2023-10-21', 5, 1),
('6789-0123-4567-8901', '2023-10-22', 6, 2),
('7890-1234-5678-9012', '2023-10-23', 7, 3),
('8901-2345-6789-0123', '2023-10-24', 8, 4),
('9012-3456-7890-1234', '2023-10-25', 9, 1),
('0123-4567-8901-2345', '2023-10-26', 10, 2),
('1234-5678-9012-3456', '2023-10-27', 11, 3),
('2345-6789-0123-4567', '2023-10-28', 12, 4),
('3456-7890-1234-5678', '2023-10-29', 13, 1),
('4567-8901-2345-6789', '2023-10-30', 14, 2),
('5678-9012-3456-7890', '2023-10-31', 15, 3),
('6789-0123-4567-8901', '2023-11-01', 16, 4);

INSERT INTO compra (nro_cartao, cod_pedido, cod_pf) VALUES
('1234-5678-9012-3456', 33, 1),
('2345-6789-0123-4567', 34, 2),
('3456-7890-1234-5678', 35, 3),
('4567-8901-2345-6789', 36, 4),
('5678-9012-3456-7890', 37, 1),
('6789-0123-4567-8901', 38, 2),
('7890-1234-5678-9012', 39, 3),
('8901-2345-6789-0123', 40, 4),
('9012-3456-7890-1234', 41, 1),
('0123-4567-8901-2345', 42, 2),
('1234-5678-9012-3456', 43, 3),
('2345-6789-0123-4567', 44, 4),
('3456-7890-1234-5678', 45, 1),
('4567-8901-2345-6789', 46, 2),
('5678-9012-3456-7890', 47, 3),
('6789-0123-4567-8901', 48, 4);

INSERT INTO compra_recorrente (recorrencia, data_compra, nro_cartao, cod_pj, cod_pedido) VALUES
(1, '2023-10-01', '5678-9012-3456-7890', 1, 17),
(2, '2023-10-02', '2345-6789-0123-4567', 2, 18),
(3, '2023-10-03', '7890-1234-5678-9012', 3, 19),
(4, '2023-10-04', '8901-2345-6789-0123', 4, 20),
(5, '2023-10-05', '5678-9012-3456-7890', 1, 21),
(1, '2023-10-06', '2345-6789-0123-4567', 2, 22),
(2, '2023-10-07', '7890-1234-5678-9012', 3, 23),
(3, '2023-10-08', '8901-2345-6789-0123', 4, 24),
(4, '2023-10-09', '5678-9012-3456-7890', 1, 25),
(5, '2023-10-10', '2345-6789-0123-4567', 2, 26),
(1, '2023-10-11', '7890-1234-5678-9012', 3, 27),
(2, '2023-10-12', '8901-2345-6789-0123', 4, 28),
(3, '2023-10-13', '5678-9012-3456-7890', 1, 29),
(4, '2023-10-14', '2345-6789-0123-4567', 2, 30),
(5, '2023-10-15', '7890-1234-5678-9012', 3, 31),
(1, '2023-10-16', '8901-2345-6789-0123', 4, 32),
(2, '2023-10-17', '5678-9012-3456-7890', 1, 49),
(3, '2023-10-18', '2345-6789-0123-4567', 2, 50),
(4, '2023-10-19', '7890-1234-5678-9012', 3, 51),
(5, '2023-10-20', '8901-2345-6789-0123', 4, 52),
(1, '2023-10-21', '5678-9012-3456-7890', 1, 53),
(2, '2023-10-22', '2345-6789-0123-4567', 2, 54),
(3, '2023-10-23', '7890-1234-5678-9012', 3, 55),
(4, '2023-10-24', '8901-2345-6789-0123', 4, 56),
(5, '2023-10-25', '5678-9012-3456-7890', 1, 57),
(1, '2023-10-26', '2345-6789-0123-4567', 2, 58),
(2, '2023-10-27', '7890-1234-5678-9012', 3, 59),
(3, '2023-10-28', '8901-2345-6789-0123', 4, 60),
(4, '2023-10-29', '5678-9012-3456-7890', 1, 61),
(5, '2023-10-30', '2345-6789-0123-4567', 2, 62),
(1, '2023-10-31', '7890-1234-5678-9012', 3, 63),
(2, '2023-11-01', '8901-2345-6789-0123', 4, 64);

INSERT INTO prod_organico (nome_produto, estoque, un_medida, valor_produto, disp_recorrencia) VALUES
('Tomate', 100, 'kg', 20.00, TRUE),
('Almeirão', 50, 'un', 10.50, FALSE),
('Abobrinha', 75, 'kg', 11.25, TRUE),
('Ovos', 120, 'un', 9.75, TRUE),
('Batata', 200, 'kg', 25.00, TRUE),
('Alface', 30, 'un', 12.50, FALSE),
('Maçã', 90, 'kg', 16.75, TRUE),
('Pitaya', 60, 'un', 18.50, FALSE),
('Cenoura', 150, 'kg', 22.00, TRUE);

INSERT INTO item_pedido (qtdd_item, valor_item, cod_pedido, cod_produto) VALUES
(2, 50.00, 1, 1),
(1, 30.00, 1, 2),
(3, 20.00, 1, 3),
(2, 25.00, 1, 4),
(1, 15.00, 1, 5),
(4, 10.00, 2, 6),
(2, 40.00, 2, 7),
(3, 35.00, 2, 8),
(1, 45.00, 2, 9),
(2, 50.00, 3, 1),
(1, 15.00, 3, 5),
(4, 10.00, 4, 6),
(2, 40.00, 4, 7),
(3, 35.00, 4, 8),
(1, 45.00, 4, 9),
(2, 50.00, 5, 1),
(1, 30.00, 5, 2),
(3, 20.00, 5, 3),
(2, 25.00, 5, 4),
(1, 15.00, 5, 5),
(4, 10.00, 6, 6),
(2, 40.00, 6, 7),
(3, 35.00, 6, 8),
(1, 45.00, 6, 9),
(2, 50.00, 7, 1),
(1, 30.00, 7, 2),
(3, 20.00, 7, 3),
(2, 25.00, 7, 4),
(1, 15.00, 7, 5),
(4, 10.00, 8, 6),
(2, 40.00, 8, 7),
(3, 35.00, 8, 8),
(1, 45.00, 8, 9),
(2, 50.00, 9, 1),
(1, 30.00, 9, 2),
(3, 20.00, 9, 3),
(2, 25.00, 9, 4),
(1, 15.00, 9, 5),
(4, 10.00, 10, 6),
(2, 40.00, 10, 7),
(3, 35.00, 10, 8),
(1, 45.00, 10, 9),
(2, 50.00, 11, 1),
(1, 30.00, 11, 2),
(3, 20.00, 11, 3),
(2, 25.00, 11, 4),
(1, 15.00, 11, 5),
(4, 10.00, 12, 6),
(2, 40.00, 12, 7),
(3, 35.00, 12, 8),
(1, 45.00, 12, 9),
(2, 50.00, 13, 1),
(1, 15.00, 13, 5),
(4, 10.00, 14, 6),
(2, 40.00, 14, 7),
(3, 35.00, 14, 8),
(1, 45.00, 14, 9),
(2, 50.00, 15, 1),
(1, 30.00, 15, 2),
(3, 20.00, 15, 3),
(2, 25.00, 15, 4),
(1, 15.00, 15, 5),
(4, 10.00, 16, 6),
(2, 40.00, 16, 7),
(1, 30.00, 17, 2),
(3, 20.00, 17, 3),
(2, 25.00, 17, 4),
(1, 15.00, 17, 5),
(4, 10.00, 18, 6),
(2, 40.00, 18, 7),
(3, 35.00, 18, 8),
(1, 45.00, 18, 9),
(2, 50.00, 19, 1),
(1, 30.00, 19, 2),
(3, 20.00, 19, 3),
(2, 25.00, 19, 4),
(1, 15.00, 19, 5),
(4, 10.00, 20, 6),
(2, 40.00, 20, 7),
(3, 35.00, 20, 8),
(1, 45.00, 20, 9),
(2, 50.00, 21, 1),
(1, 30.00, 21, 2),
(3, 20.00, 21, 3),
(2, 25.00, 21, 4),
(1, 15.00, 21, 5),
(4, 10.00, 22, 6),
(2, 40.00, 22, 7),
(3, 35.00, 22, 8),
(1, 45.00, 22, 9),
(2, 50.00, 23, 1),
(1, 30.00, 23, 2),
(3, 20.00, 23, 3),
(2, 25.00, 23, 4),
(3, 35.00, 24, 8),
(1, 45.00, 24, 9),
(2, 50.00, 25, 1),
(1, 30.00, 25, 2),
(3, 20.00, 25, 3),
(2, 25.00, 25, 4),
(1, 15.00, 25, 5),
(4, 10.00, 26, 6),
(2, 40.00, 26, 7),
(3, 35.00, 26, 8),
(1, 45.00, 26, 9),
(2, 50.00, 27, 1),
(1, 30.00, 27, 2),
(3, 20.00, 27, 3),
(2, 25.00, 27, 4),
(1, 15.00, 27, 5),
(4, 10.00, 28, 6),
(2, 40.00, 28, 7),
(3, 35.00, 28, 8),
(3, 20.00, 29, 3),
(2, 25.00, 29, 4),
(1, 15.00, 29, 5),
(4, 10.00, 30, 6),
(2, 40.00, 30, 7),
(3, 35.00, 30, 8),
(1, 45.00, 30, 9),
(2, 50.00, 31, 1),
(1, 15.00, 31, 5),
(4, 10.00, 32, 6),
(2, 40.00, 32, 7),
(3, 35.00, 32, 8),
(1, 45.00, 32, 9),
(2, 50.00, 33, 1),
(1, 30.00, 33, 2),
(3, 20.00, 33, 3),
(2, 25.00, 33, 4),
(1, 15.00, 33, 5),
(4, 10.00, 34, 6),
(2, 40.00, 34, 7),
(3, 35.00, 34, 8),
(1, 45.00, 34, 9),
(2, 25.00, 35, 4),
(1, 15.00, 35, 5),
(4, 10.00, 36, 6),
(2, 40.00, 36, 7),
(3, 35.00, 36, 8),
(1, 45.00, 36, 9),
(2, 50.00, 37, 1),
(1, 30.00, 37, 2),
(3, 20.00, 37, 3),
(2, 25.00, 37, 4),
(1, 15.00, 37, 5),
(4, 10.00, 38, 6),
(2, 40.00, 38, 7),
(3, 35.00, 38, 8),
(1, 45.00, 38, 9),
(2, 50.00, 39, 1),
(1, 30.00, 39, 2),
(3, 20.00, 39, 3),
(2, 25.00, 39, 4),
(1, 15.00, 39, 5),
(4, 10.00, 40, 6),
(2, 40.00, 40, 7),
(3, 35.00, 40, 8),
(1, 45.00, 40, 9),
(2, 50.00, 41, 1),
(1, 15.00, 41, 5),
(4, 10.00, 42, 6),
(2, 40.00, 42, 7),
(3, 35.00, 42, 8),
(1, 45.00, 42, 9),
(2, 50.00, 43, 1),
(1, 30.00, 43, 2),
(3, 20.00, 43, 3),
(2, 25.00, 43, 4),
(1, 15.00, 43, 5),
(4, 10.00, 44, 6),
(2, 40.00, 44, 7),
(1, 30.00, 45, 2),
(3, 20.00, 45, 3),
(2, 25.00, 45, 4),
(1, 15.00, 45, 5),
(4, 10.00, 46, 6),
(2, 40.00, 46, 7),
(3, 35.00, 46, 8),
(1, 45.00, 46, 9),
(2, 50.00, 47, 1),
(1, 30.00, 47, 2),
(3, 20.00, 47, 3),
(2, 25.00, 47, 4),
(1, 15.00, 47, 5),
(4, 10.00, 48, 6),
(2, 40.00, 48, 7),
(3, 35.00, 48, 8),
(1, 45.00, 48, 9),
(2, 50.00, 49, 1),
(1, 30.00, 49, 2),
(3, 20.00, 49, 3),
(2, 25.00, 49, 4),
(1, 15.00, 49, 5),
(4, 10.00, 50, 6),
(2, 40.00, 50, 7),
(3, 35.00, 50, 8),
(1, 45.00, 50, 9),
(2, 50.00, 51, 1),
(1, 30.00, 51, 2),
(1, 15.00, 51, 5),
(4, 10.00, 52, 6),
(2, 40.00, 52, 7),
(3, 35.00, 52, 8),
(1, 45.00, 52, 9),
(2, 50.00, 53, 1),
(1, 30.00, 53, 2),
(3, 20.00, 53, 3),
(2, 25.00, 53, 4),
(1, 15.00, 53, 5),
(4, 10.00, 54, 6),
(2, 40.00, 54, 7),
(3, 35.00, 54, 8),
(1, 45.00, 54, 9),
(2, 50.00, 55, 1),
(1, 30.00, 55, 2),
(3, 20.00, 55, 3),
(2, 25.00, 55, 4),
(1, 15.00, 55, 5),
(4, 10.00, 56, 6),
(2, 40.00, 56, 7),
(3, 35.00, 56, 8),
(1, 45.00, 56, 9),
(2, 50.00, 57, 1),
(1, 30.00, 57, 2),
(3, 20.00, 57, 3),
(2, 25.00, 57, 4),
(1, 15.00, 57, 5),
(4, 10.00, 58, 6),
(2, 40.00, 58, 7),
(3, 35.00, 58, 8),
(1, 45.00, 58, 9),
(2, 50.00, 59, 1),
(1, 30.00, 59, 2),
(3, 20.00, 59, 3),
(4, 10.00, 60, 6),
(2, 40.00, 60, 7),
(3, 35.00, 60, 8),
(1, 45.00, 60, 9),
(2, 50.00, 61, 1),
(1, 30.00, 61, 2),
(3, 20.00, 61, 3),
(2, 25.00, 61, 4),
(1, 15.00, 61, 5),
(4, 10.00, 62, 6),
(2, 40.00, 62, 7),
(3, 35.00, 62, 8),
(1, 45.00, 62, 9),
(2, 50.00, 63, 1),
(1, 30.00, 63, 2),
(3, 20.00, 63, 3),
(2, 25.00, 63, 4),
(1, 15.00, 63, 5),
(3, 35.00, 64, 8),
(1, 45.00, 64, 9);

INSERT INTO produtor (nome, cpf, endereco, telefone, email, conta, banco) VALUES
('Cauê Nicolas Baptista', '613.156.224-59', 'Fazenda Bento Rita, Rodovia 111, km 123', '99397-9682', 'caue-baptista73@email.com', '1061748-5', 'Banco Itau'),
('Giovanni Julio Dias', '176.860.614-50', 'Fazenda Vila Rica, Rodovia 055, km 30', '99819-6701', 'giovannijuliodias@email.com', '53622780-8', 'Banco Brasil'),
('Theo Marcos Antonio Aragão', '789.512.489-76', 'Fazenda Pixinguinha, Rodovia 020 km 100', '98142-5817', 'theo_aragao@email.com', '148535-0', 'Banco Bradesco');

INSERT INTO produz (cod_produto, cod_produtor) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 1),
(5, 2),
(6, 3),
(7, 1),
(8, 2),
(9, 3);

INSERT INTO selo_qualidade (data_validade, nome_selo, orgao_regulamentador, cod_produtor) VALUES
('2023-12-31', 'Produto Orgânico Brasil', 'Ministério da Agricultura, Pecuária e Abastecimento', 1),
('2024-11-30', 'Produto Orgânico Brasil', 'Ministério da Agricultura, Pecuária e Abastecimento', 2),
('2024-10-31', 'Produto Orgânico Brasil', 'Ministério da Agricultura, Pecuária e Abastecimento', 3);

INSERT INTO entregador (nome, cpf, telefone, email, conta, banco) VALUES
('Bryan Henrique Silva', '284.901.391-99', '98222-4491', 'bryanhenriquesilva@email.com', '8765432-1', 'Banco Itau'),
('Osvaldo Paulo Pinto', '161.412.553-88', '98501-7729', 'osvaldo-pinto71@yahooo.com.br', '1234567-8', 'Banco Brasil'),
('Francisco Raimundo Baptista', '909.460.251-26', '99460-8410', 'franciscoraimundobaptista@email.com', '2345678-9', 'Banco Brasil'),
('Bento Leandro Lucas da Silva', '210.987.654-32', '99171-0245', 'bento_dasilva98d@email.com', '3456789-0', 'Banco Bradesco'),
('Carla Renata Pereira', '640.284.267-23', '99328-0026', 'carlarenata95@email.com', '4567890-1', 'Banco Itau'),
('Alice Nina Moreira', '403.378.193-51', '98890-0371', 'aliceninamoreira10@email.com', '5678901-2', 'Banco Itau'),
('Joaquim Gael Viana', '985.705.164-28', '98282-6145', 'joaquim_gael_viana@email.com', '6789012-3', 'Banco Brasil'),
('Márcio Oliver Felipe Fernandes', '810.788.853-70', '99695-6045', 'marcio_oliver_fernandes@email.com', '7890123-4', 'Banco Brasil'),
('Laís Sandra Pereira', '295.400.617-09', '99828-0262', 'laissandrapereira20@email.com', '8901234-5', 'Banco Bradesco'),
('Nelson Lucas Alves', '581.912.872-93', '99633-7760', 'nelson_alves@email.com', '9012345-6', 'Banco Brasil');

INSERT INTO entrega (data_entrega, avaliacao, cod_entregador, data_recolhimento, cod_pedido, cod_cliente) VALUES
('2023-10-18', 4, 1, '2023-10-17', 1, 1),
('2023-10-21', 4, 2, '2023-10-20', 2, 2),
('2023-10-22', 3, 3, '2023-10-21', 3, 3),
('2023-10-25', 4, 4, '2023-10-24', 4, 4),
('2023-10-25', 5, 5, '2023-10-24', 5, 1),
('2023-11-02', null, 6, '2023-11-01', 6, 2),
('2023-11-02', 4, 7, '2023-11-01', 7, 3),
('2023-11-06', 4, 8, '2023-11-05', 8, 4),
('2023-11-06', 4, 9, '2023-11-05', 9, 1),
('2023-11-07', null, 10, '2023-11-06', 10, 2),
('2023-11-10', 5, 1, '2023-11-09', 11, 3),
('2023-11-10', 5, 2, '2023-11-09', 12, 4),
('2023-11-13', 4, 3, '2023-11-12', 13, 1),
('2023-11-13', 5, 4, '2023-11-12', 14, 2),
('2023-11-14', 5, 5, '2023-11-13', 15, 3),
('2023-11-17', 4, 6, '2023-11-16', 16, 4),
('2023-11-17', 4, 7, '2023-11-16', 17, 5),
('2023-11-20', 5, 8, '2023-11-19', 18, 6),
('2023-11-20', 5, 9, '2023-11-19', 19, 7),
('2023-11-21', 5, 10, '2023-11-20', 20, 8),
('2023-11-24', 4, 1, '2023-11-23', 21, 5),
('2023-11-24', 5, 2, '2023-11-23', 22, 6),
('2023-11-27', 4, 3, '2023-11-26', 23, 7),
('2023-11-27', 4, 4, '2023-11-26', 24, 8),
('2023-11-28', 5, 5, '2023-11-27', 25, 5),
('2023-12-01', 5, 6, '2023-11-30', 26, 6),
('2023-12-01', 4, 7, '2023-11-30', 27, 7),
('2023-12-04', 5, 8, '2023-12-03', 28, 8),
('2023-12-04', 4, 9, '2023-12-03', 29, 5),
('2023-12-05', 5, 10, '2023-12-04', 30, 6),
('2023-12-08', 4, 1, '2023-12-07', 31, 7),
('2023-12-08', 5, 2, '2023-12-07', 32, 8),
('2023-12-11', 5, 3, '2023-12-10', 33, 1),
('2023-12-11', 4, 4, '2023-12-10', 34, 2),
('2023-12-12', 4, 5, '2023-12-11', 35, 3),
('2023-12-15', 5, 6, '2023-12-14', 36, 4),
('2023-12-15', 5, 7, '2023-12-14', 37, 1),
('2023-12-18', 4, 8, '2023-12-17', 38, 2),
('2023-12-18', 4, 9, '2023-12-17', 39, 3),
('2023-12-19', null, 10, '2023-12-18', 40, 4),
('2023-12-22', 4, 1, '2023-12-21', 41, 1),
('2023-12-22', 4, 2, '2023-12-21', 42, 2),
('2023-12-25', 5, 3, '2023-12-24', 43, 3),
('2023-12-25', 5, 4, '2023-12-24', 44, 4),
('2023-12-26', 5, 5, '2023-12-25', 45, 1),
('2023-12-29', 5, 6, '2023-12-28', 46, 2),
('2023-12-29', 4, 7, '2023-12-28', 47, 3),
('2024-01-01', 4, 8, '2023-12-31', 48, 4),
('2024-01-01', 5, 9, '2023-12-31', 49, 5),
('2024-01-02', 4, 10, '2024-01-01', 50, 6),
('2024-01-05', 5, 1, '2024-01-04', 51, 7),
('2024-01-05', 5, 2, '2024-01-04', 52, 8),
('2024-01-08', 5, 3, '2024-01-07', 53, 5),
('2024-01-08', 4, 4, '2024-01-07', 54, 6),
('2024-01-09', 5, 5, '2024-01-08', 55, 7),
('2024-01-12', 5, 6, '2024-01-11', 56, 8),
('2024-01-12', 4, 7, '2024-01-11', 57, 5),
('2024-01-15', 4, 8, '2024-01-14', 58, 6),
('2024-01-15', 5, 9, '2024-01-14', 59, 7),
('2024-01-16', 4, 10, '2024-01-15', 60, 8),
('2024-01-19', 5, 1, '2024-01-18', 61, 5),
('2024-01-19', 5, 2, '2024-01-18', 62, 6),
('2024-01-22', 4, 3, '2024-01-21', 63, 7),
('2024-01-22', 5, 4, '2024-01-21', 64, 8);

-- Consultas com subconsultas

-- 1º relatório
-- Milena Bertolini
-- Selecionar o produtor que produz o produto 'Pitaya'
SELECT p.nome
FROM produtor p
JOIN produz prd ON p.cod_produtor = prd.cod_produtor
WHERE prd.cod_produto = (
    SELECT po.cod_produto
    FROM prod_organico po
    WHERE po.nome_produto = 'Pitaya'
);

-- 2º relatório
-- Milena Bertolini
-- Selecionar o nome do produtor e a quantidade de produtos, dos produtores que produzem mais de 1 produto
SELECT p.nome, COUNT(prd.cod_produto) AS qtd_produtos
FROM produtor p
JOIN produz prd ON p.cod_produtor = prd.cod_produtor
WHERE p.cod_produtor IN (
    SELECT prd2.cod_produtor
    FROM produz prd2
    GROUP BY prd2.cod_produtor
    HAVING COUNT(prd2.cod_produto) > 1
)
GROUP BY p.nome;

-- 3º relatório
-- Diego Martins
-- Selecionar o nome dos clientes que fizeram mais de uma compra
SELECT nome
FROM cliente
WHERE cod_cliente IN (
    SELECT cod_cliente
    FROM pessoa_fisica
    WHERE cod_pf IN (
        SELECT cod_pf
        FROM compra
        GROUP BY cod_pf
        HAVING COUNT(cod_compra) > 1
    )
);

-- 4º relatório
-- Diego Martins
-- Selecionar o nome dos entregadores que realizaram entregas entre os dia 22 de outubro de 2023
-- e 03 de novembro de 2023:
SELECT nome
FROM entregador
WHERE cod_entregador IN (
    SELECT cod_entregador
    FROM entrega
    WHERE data_entrega BETWEEN '2023-10-22' AND '2023-11-03'
);

-- 5º relatório
-- Barbara Ramos
-- Motrar a média de valor dos pedidos feitos por clientes que realizaram compras recorrentes
SELECT FORMAT(AVG(valor_pedido), 2) AS 'Média Valor'
FROM pedido
WHERE cod_pedido IN (
    SELECT cod_pedido
    FROM compra_recorrente
);

-- 6º relatório
-- Barbara Ramos
-- Selecionar os produtos orgânicos mais vendidos
SELECT nome_produto
FROM prod_organico
WHERE cod_produto IN (
    select cod_produto
    from (select cod_produto
    FROM item_pedido
    GROUP BY cod_produto
    ORDER BY SUM(qtdd_item) DESC
    limit 5) as res
);

 SELECT cod_produto,  SUM(qtdd_item)
    FROM item_pedido
    GROUP BY cod_produto
    ORDER BY SUM(qtdd_item) DESC;

select *
from prod_organico;
-- Consultas com operadores de junção interna e junção externa

-- 7º relatório
-- Milena Bertolini
-- Selecionar todos os clientes (pessoas físicas) que realizaram compras e a suas respectivas datas
SELECT c.nome, cp.data_compra, cod_pedido
FROM cliente c
LEFT JOIN pessoa_fisica pf ON c.cod_cliente = pf.cod_cliente
LEFT JOIN compra cp ON pf.cod_pf = cp.cod_pf
WHERE cod_compra IS NOT NULL AND data_compra IS NOT NULL;

-- 8º relatório
-- Milena Bertolini
-- Selecionar todos os produtos orgânicos, seus produtores, o selo de produto orgânico e sua validade
SELECT po.nome_produto, pr.nome, sq.nome_selo, sq.data_validade
FROM prod_organico po
LEFT JOIN produz pdz ON po.cod_produto = pdz.cod_produto
LEFT JOIN produtor pr ON pdz.cod_produtor = pr.cod_produtor
LEFT JOIN selo_qualidade sq ON sq.cod_produtor = pr.cod_produtor;

-- 9º relatório
-- Diego Martins
-- Listar todos os clientes (pessoas jurídica) que realizaram compras e tiveram um valor maior que 500 reais 
SELECT c.nome, cr.data_compra, pd.valor_pedido
FROM cliente c
LEFT JOIN pessoa_juridica pj ON c.cod_cliente = pj.cod_cliente
LEFT JOIN compra_recorrente cr ON pj.cod_pj = cr.cod_pj
LEFT JOIN pedido pd on cr.cod_pedido = pd.cod_pedido
WHERE pd.valor_pedido > 500;

-- 10º relatório
-- Diego Martins
-- Listar todos os pedidos e os clientes que os fizeram somente no mês de novembro
SELECT c.nome, p.data_pedido, p.valor_pedido
FROM pedido p
LEFT JOIN entrega e ON p.cod_pedido = e.cod_pedido
LEFT JOIN cliente c ON e.cod_cliente = c.cod_cliente
WHERE month(p.data_pedido) = 11;

-- 11º relatório
-- Barbara Ramos
-- Selecionar todos os produtores que o selo de produto orgânico já tenha passado da validade
SELECT pr.nome, sq.data_validade
FROM produtor pr
RIGHT JOIN selo_qualidade sq ON sq.cod_produtor = pr.cod_produtor
WHERE sq.data_validade < now();

-- 12º relatório
-- Barbara Ramos
-- Listar os entregadores que realizaram entregas, e têm três avaliações
SELECT e.nome, en.data_entrega, en.avaliacao
FROM entregador e
LEFT JOIN entrega en ON e.cod_entregador = en.cod_entregador 
WHERE en.avaliacao = 3;

-- Relatórios usando operador UNION/UNION ALL

-- 13º relatório
-- Milena Bertolini
-- Selecionar os clientes e produtores com seus detalhes de contato
(SELECT c.nome, c.email, c.telefone, "Cliente"
FROM cliente c
LEFT JOIN pessoa_fisica pf ON c.cod_cliente = pf.cod_cliente)
UNION
(SELECT p.nome, p.email, p.telefone, "Produtor"
FROM produtor p);

-- 14º relatório
-- Milena Bertolini
-- Combinar listas de todas as compras e compras recorrentes feitas por clientes pessoa física e jurídica, 
-- incluindo informações detalhadas de cada compra e remover duplicatas:
(SELECT cp.cod_compra AS transacao_id, cp.data_compra, c.nome AS cliente_nome, cp.nro_cartao, 'Compra' AS tipo_transacao
FROM compra cp
INNER JOIN pessoa_fisica pf ON cp.cod_pf = pf.cod_pf
INNER JOIN cliente c ON pf.cod_cliente = c.cod_cliente)
UNION
(SELECT cr.cod_transacao_rec AS transacao_id, cr.data_compra, c.nome AS cliente_nome, cr.nro_cartao, 'Compra Recorrente' AS tipo_transacao
FROM compra_recorrente cr
INNER JOIN pessoa_juridica pj ON cr.cod_pj = pj.cod_pj
INNER JOIN cliente c ON pj.cod_cliente = c.cod_cliente);

-- 15º relatório
-- Diego Martins
-- Listar pedidos de clientes pessoa física e pessoa jurídica com detalhes do cliente e do pedido
-- ajustar coluna indicar quem é pj e pf
(SELECT c.nome, cp.cod_pedido, p.valor_pedido, p.data_pedido
FROM cliente c
LEFT JOIN pessoa_fisica pf ON c.cod_cliente = pf.cod_cliente
LEFT JOIN compra cp ON pf.cod_pf = cp.cod_pf
LEFT JOIN pedido p ON cp.cod_pedido = p.cod_pedido
WHERE p.cod_pedido IS NOT NULL)
UNION ALL
(SELECT c.nome, cr.cod_pedido, p.valor_pedido, p.data_pedido
FROM cliente c
LEFT JOIN pessoa_juridica pj ON c.cod_cliente = pj.cod_cliente
LEFT JOIN compra_recorrente cr ON pj.cod_pj = cr.cod_pj
LEFT JOIN pedido p ON cr.cod_pedido = p.cod_pedido
WHERE p.cod_pedido IS NOT NULL);

-- 16º relatório
-- Diego Martins
-- Selecionar os entregadores e as entregas que realizaram
(SELECT e.nome, en.cod_entrega, en.data_entrega, en.avaliacao
FROM entregador e
LEFT JOIN entrega en ON e.cod_entregador = en.cod_entregador)
UNION
(SELECT e.nome, NULL AS cod_entrega, NULL AS data_entrega, NULL AS avaliacao
FROM entregador e
WHERE e.cod_entregador NOT IN (SELECT cod_entregador FROM entrega));

-- 17º relatório
-- Barbara Ramos
-- Selecionar os produtos orgânicos disponíveis para recorrência e os não disponíveis para recorrência
(SELECT nome_produto, 'Disponível para recorrência' AS disponibilidade
FROM prod_organico
WHERE disp_recorrencia = true)
UNION ALL
(SELECT nome_produto, 'Não disponível para recorrência' AS disponibilidade
FROM prod_organico
WHERE disp_recorrencia = false);

-- 18º relatório
-- Barbara Ramos
-- Selecionar todos os pedidos, incluindo detalhes do cliente e do entregador
-- AJUSTAR  verificar se pedidos nulos são de PJ
(SELECT p.cod_pedido, c.nome AS cliente_nome, e.nome AS entregador_nome, p.valor_pedido, p.data_pedido
FROM pedido p
LEFT JOIN entrega en ON p.cod_pedido = en.cod_pedido
LEFT JOIN cliente c ON en.cod_cliente = c.cod_cliente
LEFT JOIN entregador e ON en.cod_entregador = e.cod_entregador)
UNION
(SELECT p.cod_pedido, c.nome AS cliente_nome, et.nome, p.valor_pedido, p.data_pedido
FROM 
 compra cp 
LEFT JOIN pedido p ON p.cod_pedido = cp.cod_pedido
LEFT JOIN
pessoa_fisica pf ON cp.cod_pf = pf.cod_pf left join cliente c
on c.cod_cliente = pf.cod_cliente
left join entrega en on en.cod_pedido=p.cod_pedido
left join entregador et on et.cod_entregador=en.cod_entregador
and en.cod_entregador IS NULL);

-- Visões sobre os dados

-- 19º relatório
-- Diego Martins
-- Visão para obter detalhes de itens de pedido e os produtos associados
CREATE VIEW vw_itens_pedidos_produtos AS
SELECT 
    ip.cod_item_pedido,
    ip.qtdd_item,
    ip.valor_item,
    p.cod_pedido,
    p.valor_pedido,
    p.data_pedido,
    po.nome_produto,
    po.estoque,
    po.un_medida,
    po.valor_produto
FROM item_pedido ip
LEFT JOIN pedido p ON ip.cod_pedido = p.cod_pedido
LEFT JOIN prod_organico po ON ip.cod_produto = po.cod_produto;

SELECT * 
FROM vw_itens_pedidos_produtos;

-- 20º relatório
-- Barbara Ramos
-- Visão para obter detalhes de produtos e seus produtores
CREATE VIEW vw_produtos_produtores AS
SELECT 
    po.cod_produto,
    po.nome_produto,
    po.estoque,
    po.un_medida,
    po.valor_produto,
    po.disp_recorrencia,
    pr.cod_produtor,
    pr.nome AS produtor_nome,
    pr.cpf AS produtor_cpf,
    pr.telefone AS produtor_telefone,
    pr.email AS produtor_email
FROM prod_organico po
LEFT JOIN produz pdz ON po.cod_produto = pdz.cod_produto
LEFT JOIN produtor pr ON pdz.cod_produtor = pr.cod_produtor;

SELECT * 
FROM vw_produtos_produtores;

-- 21º relatório
-- Milena Bertolini
-- Visão para obter detalhes de compras recorrentes e os clientes (pessoa jurídica) associados
CREATE VIEW vw_compras_recorrentes_clientes AS
SELECT 
    cr.cod_transacao_rec,
    cr.recorrencia,
    cr.data_compra,
    cr.nro_cartao,
    pj.cod_pj,
    pj.cnpj,
    pj.nome_responsavel,
    pj.ie,
    c.cod_cliente,
    c.nome AS cliente_nome,
    c.email,
    c.telefone
FROM compra_recorrente cr
LEFT JOIN pessoa_juridica pj ON cr.cod_pj = pj.cod_pj
LEFT JOIN cliente c ON pj.cod_cliente = c.cod_cliente;

SELECT * 
FROM vw_compras_recorrentes_clientes;