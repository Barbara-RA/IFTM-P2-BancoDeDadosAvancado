drop database evenIFTM;

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


-- insert:
INSERT INTO Categoria (nome_categoria) VALUES ('Mesa redonda');

INSERT INTO Usuario (nome_user, sexo, dt_nasc, email, cpf)
VALUES
('Barbara Ramos', 'F', '1994-10-08', 'barbara@gmail.com', '12345678901'),
('Bruno Oliveira', 'M', '1999-07-20', 'bruno@gmail.com', '23456789012'),
('Lucas Snatos', 'M', '2001-01-10', 'Lucas@yahoo.com', '34567890123'),
('Iza Santos', 'F', '2002-05-25', 'Iza@outlook.com', '45678901234'),
('Diego Pereira', 'M', '2003-09-05', 'Diego@gmail.com', '56789012345');


INSERT INTO Atividade (titulo, carga_horaria, tipo_atividade, dt_inicio_inscricao, dt_fim_inscricao, dt_realizacao, valor_ingresso, cod_categoria)
VALUES
('Inteligência Artificial', 20, 'Workshop', '2023-03-01 09:00:00', '2023-03-15 18:00:00', '2023-04-10 09:00:00', 50.00, 1),
('Projeto Web', 98, 'Curso', '2023-04-01 09:00:00', '2023-04-15 18:00:00', '2023-05-20 09:00:00', 80.00, 2),
('Noções BD', 20, 'Palestra', '2023-05-01 09:00:00', '2023-05-15 18:00:00', '2023-06-10 09:00:00', 30.00, 3),
('POO 2', 41, 'Seminário', '2023-06-01 09:00:00', '2023-06-15 18:00:00', '2023-07-15 09:00:00', 60.00, 4),
('Requisitos', 68, 'Curso', '2024-03-01 09:00:00', '2024-03-15 18:00:00', '2024-04-20 09:00:00', 100.00, 1),
('IHC', 20, 'Workshop', '2024-04-01 09:00:00', '2024-04-15 18:00:00', '2024-05-10 09:00:00', 50.00, 2),
('Banco de daos avançado', 110, 'Curso', '2024-05-01 09:00:00', '2024-05-15 18:00:00', '2024-06-15 09:00:00', 90.00, 3),
('Projeto Back-end', 41, 'Seminário', '2024-06-01 09:00:00', '2024-06-15 18:00:00', '2024-07-10 09:00:00', 40.00, 4);

INSERT INTO Inscricao (dt_inscricao, cod_user, cod_atividade)
VALUES
('2023-02-28 10:00:00', 1, 1),
('2023-03-10 14:00:00', 2, 2),
('2023-04-05 11:30:00', 3, 3),
('2023-06-20 09:00:00', 4, 4),
('2024-03-05 16:00:00', 5, 5),
('2024-04-10 10:00:00', 1, 6),
('2024-05-02 15:30:00', 2, 7),
('2024-06-12 11:00:00', 3, 8);

-- Questão 01:
-- 1-a
select a.titulo atividade, c.nome_categoria categoria, count(I.cod_inscricao) qtd_inscritos
from Inscricao i
join Atividade a on i.cod_atividade = a.cod_atividade
join categoria c on a.cod_categoria = c.cod_categoria
where year(a.dt_realizacao) = 2023
group by a.cod_atividade
order by qtd_inscritos desc
limit 10;

-- 1 b
select u.nome_user nome, coalesce(sum(a.carga_horaria), 0) carga_horaria_extensao, floor(coalesce(sum(a.carga_horaria), 0) / 40) * 4  total_pontos
from usuario u
left join inscricao i on u.cod_user = i.cod_user
left join atividade a on i.cod_atividade = a.cod_atividade
left join categoria c on a.cod_categoria = c.cod_categoria and c.nome_categoria = 'extensão'
group by 1
order by 3 desc;

-- 1 c 
select year(a.dt_realizacao) ano, month(a.dt_realizacao) mes, sum(a.valor_ingresso) total_inscricoes
from inscricao i
join atividade a on i.cod_atividade = a.cod_atividade
join categoria c on a.cod_categoria = c.cod_categoria
where c.nome_categoria in ('Ensino', 'Pesquisa')
group by 1,2
order by 1,2;

-- 1 d 
select u.nome_user nome_usuario, year(curdate()) - year(u.dt_nasc) - (right(curdate(), 5) < right(u.dt_nasc, 5)) idade, u.sexo
from usuario u
join inscricao i on u.cod_user = i.cod_user
join atividade a on i.cod_atividade = a.cod_atividade
where a.tipo_atividade = 'Mesa redonda';


-- Questão 02
-- 2 a 
select a.titulo atividade, 
(select c.nome_categoria from categoria c where c.cod_categoria = a.cod_categoria) categoria
from  atividade a
where a.dt_realizacao between '2023-01-01' and '2023-12-31'
    and a.valor_ingresso = (
        select max(valor_ingresso) 
        from atividade
        where year(dt_realizacao) = 2023
    );

-- 2 b 
select nome_user nome, email
from usuario
where
    cod_user not in (
        select distinct cod_user
        from inscricao
        where dt_inscricao >= date_sub(curdate(), interval 3 month)
    );


-- 2c 
select a.titulo  Atividade, datediff(a.dt_fim_inscricao, a.dt_inicio_inscricao) 'Quantidade dias Inscricao', a.valor_ingresso 'Valor da Inscricao'
from atividade a
where
    a.cod_categoria in (
        select cod_categoria
        from categoria
        where nome_categoria in ('extensão', 'pesquisa'))
    and a.dt_realizacao > curdate();

-- 2 d
select u.nome_user Nome, u.sexo,  timestampdiff(year, u.dt_nasc, current_date()) Idade
from usuario u
where u.cod_user in (
        select distinct i.cod_user
        from inscricao i
        join atividade a on i.cod_atividade = a.cod_atividade
        where a.valor_ingresso > (
            select avg(valor_ingresso)
            from atividade));


-- Questão 3
select 
    nome_user 'Nome do Usuário', total_carga_horaria 'Carga Horária Total', status Situação
from (
    select 
        nome_user, sum(carga_horaria) total_carga_horaria, 'Carga horária suficiente' status
    from usuario
    join inscricao on usuario.cod_user = inscricao.cod_user
    join atividade on inscricao.cod_atividade = atividade.cod_atividade
    group by 1
    having total_carga_horaria >= 200

    union all

    select 
        nome_user, sum(carga_horaria) total_carga_horaria, 'Carga Horária Insuficiente' status
    from usuario
    join inscricao on usuario.cod_user = inscricao.cod_user
    join atividade on inscricao.cod_atividade = atividade.cod_atividade
    group by nome_user
    having total_carga_horaria < 200
) as carga_horaria_status
order by 1;


 
/* Questão 04

a) Falso, visões são tabelas que foram criadas a partir de outras tabelas do banco, podemos chamar de "relatórios" salvos, as informações geradas por eles serão sempre as atuais(dados atuais das tabelas).
b) Falso,  não é possível fazer a alteração em várias tabelas ao mesmo tempo, é possível fazer em apenas uma por vez.
c) Falso, visões com funções de agregação não aceitam operações de INSERT, UPDATE ou DELETE. Essas visões são apenas para consulta e não manipulam(salvam) os dados da tabela.
d) Falso, o comando correto drop view nome_visao. 
*/



