drop database farm2town;

create database farm2town;

use farm2town;

-- Tabela cliente
CREATE TABLE cliente (
    cod_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(60) NOT NULL,
    endereco VARCHAR(100) NOT NULL,
    email VARCHAR(60) NOT NULL UNIQUE,
    telefone VARCHAR(20) NOT NULL UNIQUE
);

-- Tabela pessoa_fisica
CREATE TABLE pessoa_fisica (
    cod_pf INT PRIMARY KEY AUTO_INCREMENT,
    cpf VARCHAR(14) NOT NULL,
    cod_cliente INT,
    FOREIGN KEY (cod_cliente) REFERENCES cliente(cod_cliente),
    CHECK (cpf REGEXP '^[0-9]{3}\\.[0-9]{3}\\.[0-9]{3}\\-[0-9]{2}$') -- Validação de formato para CPF
);

-- Tabela pessoa_juridica
CREATE TABLE pessoa_juridica (
    cod_pj INT PRIMARY KEY AUTO_INCREMENT,
    cnpj VARCHAR(20) NOT NULL,
    nome_responsavel VARCHAR(60) NOT NULL,
    ie VARCHAR(16) NOT NULL,
    cod_cliente INT,
    FOREIGN KEY (cod_cliente) REFERENCES cliente(cod_cliente),
    CHECK (cnpj REGEXP '^[0-9]{2}\\.[0-9]{3}\\.[0-9]{3}/[0-9]{4}\\-[0-9]{2}$') -- Validação de formato para CNPJ
);

-- Tabela pedido
CREATE TABLE pedido(
    cod_pedido INT PRIMARY KEY AUTO_INCREMENT,
    valor_pedido NUMERIC(10,2) NOT NULL,
    data_pedido DATE DEFAULT (CURRENT_DATE())
);

-- Tabela compra
CREATE TABLE compra(
    cod_compra INT PRIMARY KEY AUTO_INCREMENT,
    nro_cartao VARCHAR(20) NOT NULL,
    data_compra DATE DEFAULT (CURRENT_DATE()),
    cod_pedido INT,
    cod_pf INT,
    FOREIGN KEY (cod_pedido) REFERENCES pedido(cod_pedido),
    FOREIGN KEY (cod_pf) REFERENCES pessoa_fisica(cod_pf)
);

-- Tabela compra_recorrente
CREATE TABLE compra_recorrente(
    cod_transacao_rec INT PRIMARY KEY AUTO_INCREMENT,
    recorrencia INT DEFAULT 0,
    data_compra DATE DEFAULT (CURRENT_DATE()),
    nro_cartao VARCHAR(20) NOT NULL,
    cod_pj INT,
    cod_pedido INT,
    FOREIGN KEY (cod_pj) REFERENCES pessoa_juridica(cod_pj),
    FOREIGN KEY (cod_pedido) REFERENCES pedido(cod_pedido)
);

-- Tabela prod_organico
CREATE TABLE prod_organico(
    cod_produto INT PRIMARY KEY AUTO_INCREMENT,
    nome_produto VARCHAR(60) NOT NULL,
    estoque INT DEFAULT 0,
    un_medida VARCHAR(16) NOT NULL,
    valor_produto NUMERIC(7,2) DEFAULT 0.00,
    disp_recorrencia BOOLEAN DEFAULT TRUE
);

-- Tabela item_pedido
CREATE TABLE item_pedido(
    cod_item_pedido INT PRIMARY KEY AUTO_INCREMENT,
    qtdd_item INT DEFAULT 1,
    valor_item NUMERIC(7,2) DEFAULT 0.01,
    cod_pedido INT,
    cod_produto INT,
    FOREIGN KEY (cod_pedido) REFERENCES pedido(cod_pedido),
    FOREIGN KEY (cod_produto) REFERENCES prod_organico(cod_produto)
);

-- Tabela produtor
CREATE TABLE produtor(
    cod_produtor INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(60) NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    endereco VARCHAR(100) NOT NULL,
    telefone VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(60) UNIQUE NOT NULL,
    conta VARCHAR(25) NOT NULL,
    banco VARCHAR(40) NOT NULL
);

-- Tabela produz
CREATE TABLE produz(
    cod_producao INT PRIMARY KEY AUTO_INCREMENT,
    cod_produto INT,
    cod_produtor INT,
    FOREIGN KEY (cod_produto) REFERENCES prod_organico(cod_produto),
    FOREIGN KEY (cod_produtor) REFERENCES produtor(cod_produtor)
);

-- Tabela selo_qualidade
CREATE TABLE selo_qualidade(
    cod_selo INT PRIMARY KEY AUTO_INCREMENT,
    data_validade DATE NOT NULL,
    nome_selo VARCHAR(60) NOT NULL,
    orgao_regulamentador VARCHAR(60) NOT NULL,
    cod_produtor INT,
    FOREIGN KEY (cod_produtor) REFERENCES produtor(cod_produtor)
);

-- Tabela entregador
CREATE TABLE entregador(
    cod_entregador INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(60) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    telefone VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(60) NOT NULL UNIQUE,
    conta VARCHAR(25) NOT NULL,
    banco VARCHAR(40) NOT NULL
);

-- Tabela entrega
CREATE TABLE entrega (
    cod_entrega INT PRIMARY KEY AUTO_INCREMENT,
    data_entrega DATE DEFAULT (CURRENT_DATE()),
    avaliacao INT,
    cod_entregador INT,
    data_recolhimento DATE DEFAULT (CURRENT_DATE()),
    cod_pedido INT,
    cod_cliente INT,
    FOREIGN KEY (cod_entregador) REFERENCES entregador(cod_entregador),
    FOREIGN KEY (cod_pedido) REFERENCES pedido(cod_pedido),
    FOREIGN KEY (cod_cliente) REFERENCES cliente(cod_cliente),
    CHECK (avaliacao IS NULL OR avaliacao BETWEEN 1 AND 5)
);

-- Tabela inspecao (relaciona produtor e selo_qualidade)
CREATE TABLE inspecao (
    cod_inspecao INT PRIMARY KEY AUTO_INCREMENT,
    cod_produtor INT,
    cod_selo INT,
    data_inspecao DATE DEFAULT (CURRENT_DATE()),
    FOREIGN KEY (cod_produtor) REFERENCES produtor(cod_produtor),
    FOREIGN KEY (cod_selo) REFERENCES selo_qualidade(cod_selo)
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
('2023-11-02', 4, 6, '2023-11-01', 6, 2),
('2023-11-02', 4, 7, '2023-11-01', 7, 3),
('2023-11-06', 4, 8, '2023-11-05', 8, 4),
('2023-11-06', 4, 9, '2023-11-05', 9, 1),
('2023-11-07', 3, 10, '2023-11-06', 10, 2),
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
('2023-12-19', 4, 10, '2023-12-18', 40, 4),
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
('2024-01-22', 5, 4, '2024-01-21', 64, 8),
('2024-01-25', 5, 1, '2024-01-24', 65, 1),
('2024-01-26', 4, 2, '2024-01-25', 66, 2),
('2024-01-27', 4, 3, '2024-01-26', 67, 3),
('2024-01-28', 5, 4, '2024-01-27', 68, 4),
('2024-01-29', 5, 5, '2024-01-28', 69, 1),
('2024-01-30', 4, 6, '2024-01-29', 70, 2);

-- Consultas com subconsultas

-- 1º 
-- Consulta lista de pedidos realizados em novembro
EXPLAIN
SELECT c.nome, p.data_pedido, p.valor_pedido
FROM pedido p
LEFT JOIN entrega e ON p.cod_pedido = e.cod_pedido
LEFT JOIN cliente c ON e.cod_cliente = c.cod_cliente
WHERE month(p.data_pedido) = 11;

-- índice
CREATE INDEX idx_pedido_data_pedido ON pedido (data_pedido);

-- Alterando a ordem das tabelas
EXPLAIN
SELECT c.nome, p.data_pedido, p.valor_pedido
FROM pedido p
STRAIGHT_JOIN entrega e ON p.cod_pedido = e.cod_pedido
STRAIGHT_JOIN cliente c ON e.cod_cliente = c.cod_cliente
WHERE month(p.data_pedido) = 11;



-- Consultas com subconsultas

-- 2º
-- Consulta de clientes com pedidos acima da média de valor
EXPLAIN
SELECT nome, email
FROM cliente
WHERE cod_cliente IN (
    SELECT cod_cliente
    FROM pedido
    WHERE valor_pedido > (
        SELECT AVG(valor_pedido)
        FROM pedido)
);
-- índices
CREATE INDEX idx_valor_pedido ON pedido (valor_pedido);



-- Alterando a ordem das tabelas
EXPLAIN
SELECT STRAIGHT_JOIN nome, email
FROM cliente
WHERE cod_cliente IN (
    SELECT cod_cliente
    FROM pedido
    WHERE valor_pedido > (
        SELECT AVG(valor_pedido)
        FROM pedido)
);



-- Consultas com subconsultas

-- 2º
-- Consulta de clientes com pedidos acima da média de valor
EXPLAIN
SELECT nome, email
FROM cliente
WHERE cod_cliente IN (
    SELECT cod_cliente
    FROM pedido
    WHERE valor_pedido > (
        SELECT AVG(valor_pedido)
        FROM pedido)
);
-- índices
CREATE INDEX idx_valor_pedido ON pedido (valor_pedido);



-- Alterando a ordem das tabelas
EXPLAIN
SELECT STRAIGHT_JOIN nome, email
FROM cliente
WHERE cod_cliente IN (
    SELECT cod_cliente
    FROM pedido
    WHERE valor_pedido > (
        SELECT AVG(valor_pedido)
        FROM pedido)
);


-- 3° relatório
-- Consulta de entregadores com avaliação média maior ou igual a 4
EXPLAIN
SELECT nome, email
FROM entregador
WHERE cod_entregador IN (
    SELECT cod_entregador
    FROM entrega
    GROUP BY cod_entregador
    HAVING AVG(avaliacao) >= 4
);


-- Alterando a ordem das tabelas
EXPLAIN
SELECT e.nome, e.email
FROM entregador e
STRAIGHT_JOIN entrega en ON e.cod_entregador = en.cod_entregador
GROUP BY e.cod_entregador
HAVING AVG(en.avaliacao) >= 4;



