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

create table entrega(
cod_entrega int primary key auto_increment,
data_entrega date default (current_date()),
avaliacao varchar(100),
cod_entregador int,
data_recolhimento date default (current_date()),
cod_pedido int,
cod_cliente int,
foreign key(cod_entregador) references entregador(cod_entregador),
foreign key(cod_pedido) references pedido(cod_pedido),
foreign key(cod_cliente) references cliente(cod_cliente)
);


-- Inserção de valores nas tabelas
INSERT INTO cliente (nome, endereco, email, telefone) VALUES
('João Silva', 'Rua A, 123', 'joao@email.com', '3123-4567'),
('Maria Oliveira', 'Av. B, 456', 'maria@email.com', '99987-6543'),
('Diego Renan da Mata', 'Rua Jerônimo Martins do Nascimento,512', 'diegorenandamata@simsvale.com.br', '98737-0746'),
('Maria Emanuelly Rocha', 'Alameda Adilson Baccili, 399', 'maria-rocha71@amaralmonteiro.com.br', '99261-0235'),
('Luiz Igor Castro', 'Rua Frederico II, 251', 'luiz_igor_castro@afujita.com.br', '98957-9738'),
('Iago Vicente Araújo', 'Avenida Floriano Peixoto, 757', 'iago_araujo@unimedsjc.com.br', '99482-1692'),
('Luzia Alessandra Camila Gomes', 'Rua Olandir de Avelar, 834', 'luzia_gomes@findout.com.br', '987-6543'),
('Kauê Fábio Leonardo Moura', 'Rua Carlos Saraiva, 392', 'kaue_moura@ppconsulting.com.br', '99869-1157'),
('Ricardo Iago Henry Silva', 'Rua Edmar Honório Cordeiro, 368', 'ricardo_iago_silva@dedicasa.com.br', '99945-4554'),
('Isabella Eliane Teixeira', 'Rua Sete, 696', 'isabellaelianeteixeira@galpaoestofados.com.br', '98522-9198'),
('Mário e Letícia Pizzaria Ltda', 'Rua Luiza Motoko Watanabe, 942', 'producao@marioeleticiapizzarialtda.com.br', '98132-8429'),
('Julio e Débora Hortifruti ME', 'Rua Doutora Eloísa Esteves Bazanelli Guardia, 722', 'financeiro@julioedeborahortifruti.com.br', '98192-1025'),
('Gourmeteria Ltda', 'Rua Arapuan, 572', 'qualidade@gourmeteriafernando.com.br', '98581-6007'),
('Seu fogão ME', 'Rua Águas de São Pedro, 187', 'qualidade@seufogao.com.br', '98334-6309'),
('Débora e Yuri Pães e Doces ME', 'Rua Francisco Xavier Rocha, 725', 'auditoria@deboraeyuripaesedocesme.com.br', '99116-5580'),
('Terrinha da Gente LTDA', 'Rua Vinte e Três, 687', 'administracao@terrinhadagenteltda.com.br', '98980-8725'),
('Marli e Louise Comida Fitness ME', 'Praça Padre Daniel Chavarri, 607', 'administracao@marlielouisecomidafitness.com.br', '99684-2798'),
('Kaique Especialidades ME', 'Avenida Moaci, 1220', 'cobranca@kaiqueespecialidadesme.com.br', '98999-2591'),
('Sebastiana e Maria Vovós na Cozinha Ltda', 'Rua Soldado Genésio Valentim Corrêa, 704', 'administracao@vovosnacozinhaltda.com.br', '98388-9847'),
('Experiência 175 LTDA', 'Rua das Andorinhas, 919', 'administracao@experienciasgastronomicas.com.br', '98304-7274');


INSERT INTO pessoa_fisica (cpf, cod_cliente) VALUES
('123.456.789-01', 1),
('987.654.321-09', 2),
('148.688.326-54', 3),
('286.702.736-59', 4),
('150.837.136-91', 5),
('651.896.176-70', 6),
('498.136.596-96', 7),
('914.127.996-43', 8),
('787.020.016-67', 9),
('947.149.446-06', 10);

INSERT INTO pessoa_juridica (cnpj, nome_responsavel, ie, cod_cliente) VALUES
('14.881.004/0001-30', 'Mário Silva', '742516215492', 11),
('50.810.034/0001-10', 'Debora Martins', '248808589265', 12),
('97.912.800/0001-10', 'Fernando Junior', '582725471045', 13),
('67.340.527/0001-36', 'Maria Silveira', '356268410230', 14),
('55.643.256/0001-09', 'Debora Mariana Souza', '958830750480', 15),
('13.989.267/0001-03', 'Isabel Teixeira', '443024396650', 16),
('35.668.564/0001-81', 'Marli Alvarez', '218420030438', 17),
('29.726.993/0001-65', 'Kaique Adriano Moraes', '197800903629', 18),
('72.479.680/0001-89', 'Sebastiana Medeiros ', '492567957506', 19),
('40.242.262/0001-87', 'Gabriel Marinho', '650551646646', 20);



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
(800.00, '2023-11-06');

INSERT INTO pedido (valor_pedido) VALUES
(50.00),
(50.00),
(50.00);
-- PARAMOS AQUIIIIIIIIIIIIIIIIIIIIIIIIII
INSERT INTO compra (cod_compra, nro_cartao, data_compra, cod_pedido, cod_pf) VALUES
(1, '1234-5678-9012-3456', '2023-10-17', 1, 1),
(2, '9876-5432-1098-7654', '2023-10-20', 2, 4),
(3, '5678-9012-3456-7890', '2023-11-01', 7, 10),
(4, '4321-0987-6543-2109', '2023-11-05', 9, 7),
(5, '7890-1234-5678-9012', '2023-11-05', 6, 8);

INSERT INTO compra_recorrente (cod_transacao_rec, recorrencia, data_compra, nro_cartao, cod_pj, cod_pedido) VALUES
(1, 1, '2023-10-21', '5278-6585-3030-6025', 5, 3),
(2, 3, '2023-10-24', '5215-5353-7701-2666', 1, 5),
(3, 1, '2023-10-24', '5283-6056-6343-8516', 6, 4),
(4, 2, '2023-11-05', '5522-9936-8286-4529', 10, 8),
(5, 4, '2023-11-06', '5257-3734-2335-6617', 8, 10);

INSERT INTO prod_organico (cod_produto, estoque, un_medida, valor_produto, disp_recorrencia) VALUES
(1, 100, 'kg', 20.00, TRUE),
(2, 50, 'un', 10.50, FALSE),
(3, 75, 'kg', 11.25, TRUE),
(4, 120, 'un', 9.75, TRUE),
(5, 200, 'kg', 25.00, TRUE),
(6, 30, 'un', 12.50, FALSE),
(7, 90, 'kg', 16.75, TRUE),
(8, 60, 'un', 18.50, FALSE),
(9, 150, 'kg', 22.00, TRUE),
(10, 40, 'un', 14.75, FALSE);

INSERT INTO item_pedido (cod_item_pedido, qtdd_item, valor_item, cod_pedido, cod_produto) VALUES
(1, 4, 80.00, 1, 1),
(2, 3, 31.50, 2, 2),
(3, 1, 11.25, 2, 3),
(4, 10, 200.00, 3, 1),
(5, 10, 250.00, 3, 5),
(6, 18, 333.00, 3, 8),
(7, 10, 200.00, 3, 9),
(8, 8, 118.00, 4, 10),
(9, 25, 243.75, 4, 4),
(10, 2, 25.00, 5, 6),
(11, 10, 160.75, 5, 7),
(12, 3, 66.00, 6, 9),
(13, 2, 37.00, 7, 8),
(14, 40, 380.00, 8, 4),
(15, 10, 100.50, 8, 2),
(16, 1, 25.00, 9, 5),
(17, 1, 18.50, 9, 8),
(18, 20, 500.00, 10, 5),
(19, 10, 200.00, 10, 1),
(20, 8, 100.00, 10, 6);


INSERT INTO produtor (cod_produtor, nome, cpf, endereco, telefone, email, conta, banco) VALUES
(1, 'Cauê Nicolas Baptista', '613.156.224-59', 'Fazenda Bento Rita, Rodovia 111, km 123', '99397-9682', 'caue-baptista73@email.com', '1061748-5', 'Banco Itau'),
(2, 'Giovanni Julio Dias', '176.860.614-50', 'Fazenda Vila Rica, Rodovia 055, km 30', '99819-6701', 'giovannijuliodias@email.com', '53622780-8', 'Banco Brasil'),
(3, 'Theo Marcos Antonio Aragão', '789.512.489-76', 'Fazenda Pixinguinha, Rodovia 020 km 100', '98142-5817', 'theo_aragao@email.com', '148535-0', 'Banco Bradesco'),
(4, 'Mirella Cristiane Analu', '434.062.991-05', 'Fazenda Fortaleza Rodovia 11, km 125', '98457-1151', 'mirelacristiane75@email.com', '87584-8', 'Banco Itau'),
(5, 'Sandra Luana Novaes', '769.176.642-43', 'Fazenda da Lua, Rodovia 055, km 40', '99846-1209', 'sandraluananovaes@email.com', '4567890-1', 'Banco Brasil'),
(6, 'Otávio Anderson Carlos Novaes', '177.742.569-70', 'Fazenda Tonhão da Lua, Rodovia 111, km 90', '98537-0733', 'otavioandersoncarlosnovaes@email.com', '5678901-2', 'Banco Itau'),
(7, 'Aurora Galvão', '078.295.628-90', 'Fazenda Galvao, Rodovia 020 km 85', '98787-9785', 'auroragalvao5@email.com', '6789012-3', 'Banco Bradesco'),
(8, 'José Benjamin Ferreira', '648.908.246-26', 'Fazenda Paraguaiana, Rodovia 111, km 120', '9849-49101', 'josebenjaminferreira-93@email.com', '7890123-4', 'Banco Itau'),
(9, 'Levi Victor Melo', '726.659.136-41', 'Fazenda Travessa, Rodovia 055, km 25 ', '99868-8013', 'levivictormelo@email.com', '8901234-5', 'Banco Itau'),
(10, 'Vanessa Benedito', '394.641.057-04', 'Fazenda Poeira Marrom', '995431310', 'beneditovanessa65@email.com', '9012345-6', 'Banco Bradesco');

INSERT INTO produz (cod_producao, cod_produto, cod_produtor) VALUES
(1, 3, 10),
(2, 8, 2),
(3, 10, 5),
(4, 6, 9),
(5, 2, 6),
(6, 9, 1),
(7, 5, 8),
(8, 1, 4),
(9, 7, 3),
(10, 4, 7);


INSERT INTO selo_qualidade (cod_selo, data_validade, nome_selo, orgao_regulamentador, cod_produtor) VALUES
(1, '2024-12-31', 'Produto Orgânico Brasil', 'Ministério da Agricultura, Pecuária e Abastecimento', 1),
(2, '2024-11-30', 'Produto Orgânico Brasil', 'Ministério da Agricultura, Pecuária e Abastecimento', 2),
(3, '2024-10-31', 'Produto Orgânico Brasil', 'Ministério da Agricultura, Pecuária e Abastecimento', 3),
(4, '2024-09-30', 'Produto Orgânico Brasil', 'Ministério da Agricultura, Pecuária e Abastecimento', 4),
(5, '2024-08-31', 'Produto Orgânico Brasil', 'Ministério da Agricultura, Pecuária e Abastecimento', 5),
(6, '2024-07-31', 'Produto Orgânico Brasil', 'Ministério da Agricultura, Pecuária e Abastecimento', 6),
(7, '2024-06-30', 'Produto Orgânico Brasil', 'Ministério da Agricultura, Pecuária e Abastecimento', 7),
(8, '2024-05-31', 'Produto Orgânico Brasil', 'Ministério da Agricultura, Pecuária e Abastecimento', 8),
(9, '2024-04-30', 'Produto Orgânico Brasil', 'Ministério da Agricultura, Pecuária e Abastecimento', 9),
(10, '2024-03-31', 'Produto Orgânico Brasil', 'Ministério da Agricultura, Pecuária e Abastecimento', 10);

INSERT INTO entregador (cod_entregador, nome, cpf, telefone, email, conta, banco) VALUES
(1, 'Bryan Henrique Silva', '284.901.391-99', '98222-4491', 'bryanhenriquesilva@email.com', '8765432-1', 'Banco Itau'),
(2, 'Osvaldo Paulo Pinto', '161.412.553-88', '98501-7729', 'osvaldo-pinto71@yahooo.com.br', '1234567-8', 'Banco Brasil'),
(3, '"Francisco Raimundo Baptista', '909.460.251-26', '99460-8410', 'franciscoraimundobaptista@email.com', '2345678-9', 'Banco Brasil'),
(4, 'Bento Leandro Lucas da Silva', '210.987.654-32', '99171-0245', 'bento_dasilva98d@email.com', '3456789-0', 'Banco Bradesco'),
(5, 'Carla Renata Pereira', '640.284.267-23', '99328-0026', 'carlarenata95@email.com', '4567890-1', 'Banco Itau'),
(6, 'Alice Nina Moreira', '403.378.193-51', '98890-0371', 'aliceninamoreira10@email.com', '5678901-2', 'Banco Itau'),
(7, 'Joaquim Gael Viana', '985.705.164-28', '98282-6145', 'joaquim_gael_viana@email.com', '6789012-3', 'Banco Brasil'),
(8, 'Márcio Oliver Felipe Fernandes', '810.788.853-70', '99695-6045', 'marcio_oliver_fernandes@email.com', '7890123-4', 'Banco Brasil'),
(9, 'Laís Sandra Pereira', '295.400.617-09', '99828-0262', 'laissandrapereira20@email.com', '8901234-5', 'Banco Bradesco'),
(10, 'Nelson Lucas Alves', '581.912.872-93', '99633-7760', 'nelson_alves@email.com', '9012345-6', 'Banco Brasil');


INSERT INTO entrega (cod_entrega, data_entrega, avaliacao, cod_entregador, data_recolhimento, cod_pedido, cod_cliente) VALUES
(1, '2023-10-17', 'Ótimo serviço!', 1, '2023-10-17', 1, 1),
(2, '2023-10-20', 'Entrega rápida e eficiente.', 2, '2023-10-20', 2, 4),
(3, '2023-10-21', 'Entregador muito educado.', 3, '2023-10-21', 3, 10),
(4, '2023-10-24', 'Tudo perfeito!', 4, '2023-10-24', 4, 7),
(5, '2023-10-24', 'Entregador profissional.', 5, '2023-10-24', 5, 8),
(6, '2023-11-01', 'Sem problemas na entrega.', 6, '2023-11-01', 6, 15),
(7, '2023-11-05', 'Entrega antes do prazo.', 7, '2023-11-05', 7, 11),
(8, '2023-11-05', 'Bom atendimento.', 8, '2023-11-05', 8, 16),
(9, '2023-11-05', 'Recomendo o entregador.', 9, '2023-11-05', 9, 20),
(10, '2023-11-06', 'Entrega bem embalada.', 10, '2023-11-06', 10, 18);

-- 1º relatório
SELECT *
FROM cliente
WHERE nome LIKE 'D%';

-- 2º relatório
SELECT *
FROM pedido
WHERE data_pedido BETWEEN '2023-10-01' AND '2023-10-31';

-- 3º relatório
SELECT *
FROM prod_organico
WHERE estoque < 50;

-- 4º relatório
SELECT *
FROM prod_organico
WHERE disp_recorrencia = TRUE;

-- 5º relatório
SELECT *
FROM entrega
WHERE avaliacao = 'Ótimo serviço!';

-- 6º relatório
SELECT *
FROM cliente
WHERE endereco LIKE '%Rua%';

-- 7º relatório
SELECT c.nome, p.valor_pedido, p.data_pedido
FROM cliente c
JOIN entrega e ON c.cod_cliente = e.cod_cliente
JOIN pedido p ON e.cod_pedido = p.cod_pedido;

-- 8º relatório
SELECT pr.cod_produto, pr.estoque, pr.valor_produto, cr.recorrencia
FROM prod_organico pr
JOIN item_pedido ip ON pr.cod_produto = ip.cod_produto
JOIN pedido p ON ip.cod_pedido = p.cod_pedido
JOIN compra_recorrente cr ON p.cod_pedido = cr.cod_pedido;

-- 9º relatório
SELECT pd.nome AS produtor, po.cod_produto, po.valor_produto
FROM produtor pd
JOIN produz pz ON pd.cod_produtor = pz.cod_produtor
JOIN prod_organico po ON pz.cod_produto = po.cod_produto;

-- 10º relatório
SELECT e.cod_entrega, e.data_entrega, e.avaliacao, c.nome AS cliente
FROM entrega e
JOIN cliente c ON e.cod_cliente = c.cod_cliente;

-- 11º relatório
SELECT cr.cod_transacao_rec, cr.recorrencia, cr.data_compra, pj.nome_responsavel
FROM compra_recorrente cr
JOIN pessoa_juridica pj ON cr.cod_pj = pj.cod_pj;

-- 12º relatório
SELECT p.cod_pedido, ip.cod_item_pedido, po.cod_produto, po.valor_produto
FROM pedido p
JOIN item_pedido ip ON p.cod_pedido = ip.cod_pedido
JOIN prod_organico po ON ip.cod_produto = po.cod_produto;

-- 13º relatório
SELECT c.nome, SUM(p.valor_pedido) as total_compras
FROM cliente c
JOIN entrega e ON c.cod_cliente = e.cod_cliente
JOIN pedido p ON e.cod_pedido = p.cod_pedido
GROUP BY c.cod_cliente, c.nome;

-- 14º relatório
SELECT pj.nome_responsavel, AVG(p.valor_pedido) as media_valor_rec
FROM pessoa_juridica pj
JOIN compra_recorrente cr ON pj.cod_pj = cr.cod_pj
JOIN pedido p ON cr.cod_pedido = p.cod_pedido
GROUP BY pj.cod_pj, pj.nome_responsavel;

-- 15º relatório
SELECT pd.nome AS produtor, COUNT(pz.cod_produto) as qtd_produtos
FROM produtor pd
JOIN produz pz ON pd.cod_produtor = pz.cod_produtor
GROUP BY pd.cod_produtor, pd.nome;

-- 16º relatório
SELECT c.nome, MIN(p.valor_pedido) as menor_compra, MAX(p.valor_pedido) as maior_compra
FROM cliente c
JOIN entrega e ON c.cod_cliente = e.cod_cliente
JOIN pedido p ON e.cod_pedido = p.cod_pedido
GROUP BY c.cod_cliente, c.nome;

-- 17º relatório
SELECT en.nome AS entregador, COUNT(e.cod_entrega) as num_entregas
FROM entregador en
JOIN entrega e ON en.cod_entregador = e.cod_entregador
GROUP BY en.cod_entregador, en.nome;

-- 18º relatório
SELECT MONTH(p.data_pedido) as mes, SUM(p.valor_pedido) as total_compras
FROM pedido p
GROUP BY mes;