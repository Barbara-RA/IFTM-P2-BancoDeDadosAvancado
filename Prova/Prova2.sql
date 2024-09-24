drop database eveniftm;

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
titulo varchar(100) unique,
carga_horaria int,
tipo_atividade varchar(30),
dt_inicio_inscricao date,
dt_fim_inscricao  date,
dt_realizacao date,
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

insert into Usuario values (1, "Joao Carlos Pereira", "M", "1998-05-29", "joaocar@hotmail.com", "03745889100");
insert into Usuario values (2, "Pedro Paulo Paixão", "M", "1992-03-29", "pedropaulo@hotmail.com", "12345678910");
insert into Usuario values (3, "Maria Clara Fontes", "F", "2000-08-29", "marcla@gmaill.com", "23456789010");
insert into Usuario values (4, "Julia  Xavier", "F", "2001-08-18", "julia@hotmail.com", "34567890123");
insert into Usuario values (5, "Tome de Souza", "M", "1987-06-12", "tomer@gmaill.com", "53467835619");
insert into Usuario values (6, "Jessica Souza", "F", "1999-08-10", "jessica@hotmail.com", "76489173649");
insert into Usuario values (7, "Olivia Souza", "F", "1997-01-10", "olivia@hotmail.com", "98764536178");
insert into Usuario values (8, "Roberto Dias", "M", "1991-03-10", "roberto@hotmail.com", "98264758192");
insert into Usuario values (9, "Maria Paula Dias", "F", "2010-05-15", "mpaula@gmail.com", "18364758192");
insert into Usuario values (10, "João Paulo Ferreira", "M", "2011-03-05", "jpferrer@gmail.com", "82264758192");



insert into Categoria values (1, "Ensino");
insert into Categoria values (2, "Pesquisa");
insert into Categoria values (3, "Extensão");


insert into Atividade values (1, "I Mulheres na TI", 8, "Workshop", "2024-03-10", "2024-03-31",
 "2024-04-01", 150.00, 3);
insert into Atividade values (2, "Inteligencia artificial", 4, "Palestra", "2024-09-01", "2024-09-28",
 "2024-10-10", 80.00, 1);
insert into Atividade values (3, "Pesquisa e Inovação em TI", 6, "Minicurso", 
"2024-01-01", "2024-02-25", "2024-02-26", 95.50, 2);
insert into Atividade values (4, "Desafios da Carreira de Programador", 3, "Mesa Redonda", 
"2024-09-01", "2024-09-15", "2024-10-20", 230.10, 3);

-- ----------------------------------------------------------------------------------------------------------
-- drop procedure sp_inserir_inscricao;


/*Questão 01 - Barbara Ramos
Faça o procedimento sp_inserir_inscricao para inserir as informações de inscrição em uma atividade.
O procedimento terá como dados de entrada o CPF do usuário e título da atividade. A data da inscrição deve ser a do momento da inserção dos dados.
Validar se o cliente existe e se a atividade existe. Mostrar exemplos de chamada do procedimento.*/


/*Questão 01 - Barbara Ramos*/
delimiter $$
create procedure sp_inserir_inscricao(
    in p_cpf char(11),
    in p_titulo varchar(100)
)
begin
    declare v_cod_user int;
    declare v_cod_atividade int;
    declare v_user_exist int;
    declare v_atividade_exist int;

    -- confirindo se o usuário existe no banco
    select cod_user into v_cod_user
    from usuario
    where cpf = p_cpf;
    
    set v_user_exist = row_count();
    
    if v_user_exist = 0 then
        signal sqlstate '45000'
        set message_text = 'usuário não cadastrado!';
    end if;

    -- conferindo se a atividade já existe
    select cod_atividade into v_cod_atividade
    from atividade
    where titulo = p_titulo;
    
    set v_atividade_exist = row_count();
    
    if v_atividade_exist = 0 then
        signal sqlstate '45000'
        set message_text = 'atividade não cadastrada!';
    end if;

    -- cadastro da inscrição
    insert into inscricao (dt_inscricao, cod_user, cod_atividade)
    values (now(), v_cod_user, v_cod_atividade);
end $$
delimiter ;


call sp_inserir_inscricao('66666666666', 'inteligencia artificial');
call sp_inserir_inscricao('53467835619', 'Desafios da Carreira de Programador');
call sp_inserir_inscricao('53467835619', 'atividade testes');


/*Questão 02 - Barbara Ramos
Faça o procedimento sp_listar_atividades que vai receber como parâmetro uma data inicial e uma data final para listar o nome da atividade,
 carga horária, categoria da atividade, valor de ingresso e status das atividades que tiverem data de realização dentro do período informado.
 Caso não haja atividades no período informado imprimir uma mensagem "Sem atividades no período informado".
Exemplo de chamada e saída do procedimento:
call sp_listar_atividades( "2024-01-01","2024-10-30");*/


 -- drop procedure sp_listar_atividades;

/*Questão 02 - Barbara Ramos*/
delimiter $$
create procedure sp_listar_atividades(
    in p_data_inicial date,
    in p_data_final date
)
begin
    declare v_atividade_exist int;

    select count(*) into v_atividade_exist
    from atividade
    where dt_realizacao between p_data_inicial and p_data_final;
    
    if v_atividade_exist = 0 then
        signal sqlstate '45000'
        set message_text = 'Não há atividades para o periodo consultado';
    else
        select a.titulo as 'Título',
               a.carga_horaria as 'Carga horária',
               c.nome_categoria as 'Categoria',
               a.valor_ingresso as 'Valor do Ingresso',
               case
                   when a.dt_realizacao < curdate() then 'Realizada'
                   when a.dt_realizacao = curdate() then 'Em andamento'
                   else 'A Realizar'
               end as 'Status'
        from atividade a
        join categoria c on a.cod_categoria = c.cod_categoria
        where a.dt_realizacao between p_data_inicial and p_data_final;
    end if;
end $$
delimiter ;

-- chamada
call sp_listar_atividades( "2024-01-01","2024-10-30");
call sp_listar_atividades('2024-01-01', '2024-04-01');
call sp_listar_atividades('2024-05-01', '2024-06-01');

/*Questão 03 - Barbara Ramos
Crie a função formata_data que irá receber como dado de entrada uma data padrão (date) e retornar um texto contendo a data formatada  com dia,
nome do mês em português e ano .  Ex. entrada: 12/05/2021 Saída: 12 de maio de 2021.
Dê exemplo de uso da função em um relatório na tabela atividade para listar o nome da atividade e a data de realização no padrão retornado pela função formata_data.
*/

-- drop function formata_data;

/*Questão 03 - Barbara Ramos*/
-- bugou precisei usar o "deterministic" explicado no slide 10 de funções
delimiter $$
create function formata_data(p_data date) returns varchar(50)
deterministic
begin
    declare v_dia int;
    declare v_mes int;
    declare v_ano int;
    declare v_mes_nome varchar(20);
    declare v_resultado varchar(50);
    
    set v_dia = day(p_data);
    set v_mes = month(p_data);
    set v_ano = year(p_data);

    case v_mes
        when 1 then set v_mes_nome = 'janeiro';
        when 2 then set v_mes_nome = 'fevereiro';
        when 3 then set v_mes_nome = 'março';
        when 4 then set v_mes_nome = 'abril';
        when 5 then set v_mes_nome = 'maio';
        when 6 then set v_mes_nome = 'junho';
        when 7 then set v_mes_nome = 'julho';
        when 8 then set v_mes_nome = 'agosto';
        when 9 then set v_mes_nome = 'setembro';
        when 10 then set v_mes_nome = 'outubro';
        when 11 then set v_mes_nome = 'novembro';
        when 12 then set v_mes_nome = 'dezembro';
    end case;


    set v_resultado = concat(v_dia, ' de ', v_mes_nome, ' de ', v_ano);

    return v_resultado;
end $$
delimiter ;

select a.titulo as 'Título',
       formata_data(a.dt_realizacao) as 'Realização'
from atividade a;


/*Questão 04 - Barbara Ramos
Crie uma função que a partir da data de nascimento de uma pessoa informe a sua faixa etária: criança (0-12 anos), adolescente (13-17 anos), 
adulto (18-64 anos) e idoso (65 anos ou mais).
Mostre exemplo de aplicação da função em um select na tabela usuário para listar o nome, sexo e faixa etária do usuário.*/

/*Questão 04 - Barbara Ramos*/
delimiter $$
create function faixa_etaria(p_dt_nasc date)
returns varchar(20)
deterministic
begin
    declare v_idade int;
    declare v_faixa_etaria varchar(20);


    set v_idade = timestampdiff(year, p_dt_nasc, curdate());

    -- faixa etária
    case
        when v_idade between 0 and 12 then set v_faixa_etaria = 'Criança';
        when v_idade between 13 and 17 then set v_faixa_etaria = 'Adolescente';
        when v_idade between 18 and 64 then set v_faixa_etaria = 'Adulto';
        when v_idade >= 65 then set v_faixa_etaria = 'Idoso';
    end case;

    return v_faixa_etaria;
end $$
delimiter ;


select nome_user as 'Nome',
       sexo as 'Sexo',
       faixa_etaria(dt_nasc) as 'Faixa Etária'
from usuario;

-- consulta Adolescente
select nome_user as 'Nome',
       sexo as 'Sexo',
       faixa_etaria(dt_nasc) as 'Faixa Etária'
from usuario
where timestampdiff(year, dt_nasc, curdate()) between 13 and 17;

/*Questão 05 - Barbara Ramos
Crie o trigger tr_solicitar_autorizacao que após inserção de uma inscrição verifique se há a necessidade de pedir autorização de um responsável
para que usuários menores de idade (<18 anos) participem de uma atividade. Se houver, inserir na tabela Pedido_autorizacao o CPF, nome do usuário,
 o email do usuário, o titulo da atividade e a data de realização da atividade que o usuário menor de idade fez inscrição. Obs.: Fazer a criação 
 da tabela Pedido_autorizacao antes de testar o trigger. Dê exemplo de comandos de ativação do trigger.*/

/*Questão 05 - Barbara Ramos*/
-- Criação da tabela
create table Pedido_autorizacao (
    id int auto_increment primary key,
    cpf char(11),
    nome_usuario varchar(50),
    email varchar(100),
    titulo_atividade varchar(100),
    data_realizacao date,
    data_pedido datetime default current_timestamp
);

insert into Usuario (nome_user, sexo, dt_nasc, email, cpf) values ('Catarina Oliveira Ramos', 'F', '2010-08-07', 'catarina@gmail.com', '10122235678');
insert into Atividade (titulo, carga_horaria, tipo_atividade, dt_inicio_inscricao, dt_fim_inscricao, dt_realizacao, valor_ingresso, cod_categoria) values ('Festa Junina IFTM', 3, 'Oficina', '2024-08-01', '2024-08-15', '2024-08-20', 2.00, 1);

-- Trigger
delimiter $$
create trigger tr_solicitar_autorizacao
after insert on Inscricao
for each row
begin
    declare v_idade int;

    -- idade
    set v_idade = timestampdiff(year, (select dt_nasc from Usuario where cod_user = new.cod_user), curdate());

    -- menor de 18 anos?
    if v_idade < 18 then
        insert into Pedido_autorizacao (cpf, nome_usuario, email, titulo_atividade, data_realizacao)
        select u.cpf, u.nome_user, u.email, a.titulo, a.dt_realizacao
        from Usuario u
        join Atividade a on a.cod_atividade = new.cod_atividade
        where u.cod_user = new.cod_user;
    end if;
end $$
delimiter ;


insert into Inscricao (dt_inscricao, cod_user, cod_atividade) 
values (now(), (select cod_user from Usuario where cpf = '10122235678'), 
(select cod_atividade from Atividade where titulo = 'Festa Junina IFTM'));

select * from Pedido_autorizacao;



/*Questão 06 - Barbara Ramos
Crie o trigger tr_valida_data que antes da inserção de uma atividade verifique se a data de inicio das inscrições não é maior que a data de término das inscrições.
Se for, gerar um erro. Garantir também que  a data de realização da atividade acontece após o período de inscrição. Dê exemplo de comandos de ativação do trigger.*/

/*Questão 06 - Barbara Ramos*/
delimiter $$
create trigger tr_valida_data
before insert on Atividade
for each row
begin
    if new.dt_inicio_inscricao > new.dt_fim_inscricao then
        signal sqlstate '45000'
        set message_text = 'inválido: A data de início não pode ser maior que a data de término, por favor prencher um período válido.';
    end if;

    if new.dt_realizacao <= new.dt_fim_inscricao then
        signal sqlstate '45000'
        set message_text = 'Inválido: A data da realização da atividade deve ser posterior à data de término das inscrições.';
    end if;
end $$
delimiter ;

-- data de início maior que a data de término
insert into Atividade (titulo, carga_horaria, tipo_atividade, dt_inicio_inscricao, dt_fim_inscricao, dt_realizacao, valor_ingresso, cod_categoria)
values ('Atividade Incorreta', 5, 'Curso', '2024-09-01', '2024-08-30', '2024-09-15', 100.00, 1);


-- data de realização antes do fim das inscrições
insert into Atividade (titulo, carga_horaria, tipo_atividade, dt_inicio_inscricao, dt_fim_inscricao, dt_realizacao, valor_ingresso, cod_categoria)
values ('Atividade Incorreta', 5, 'Curso', '2024-08-01', '2024-08-15', '2024-08-10', 100.00, 1);


-- Insert datas válidas
insert into Atividade (titulo, carga_horaria, tipo_atividade, dt_inicio_inscricao, dt_fim_inscricao, dt_realizacao, valor_ingresso, cod_categoria)
values ('Atividade Correta', 5, 'Curso', '2024-08-01', '2024-08-15', '2024-08-20', 100.00, 1);












