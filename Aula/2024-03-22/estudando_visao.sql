use empresa;

Create view vw_emps_inf as
Select f.nome,f.sexo,f.data_adm
From funcionario f, departamento d
Where d.nome='Informatica' and f.cod_depto=d.cod_depto;


select * from vw_emps_inf;

insert into funcionario values
(11,"Carlos Henrique",current_date(),"M",1,1);

Select * From vw_emps_inf
Where data_adm<date_sub(current_date, Interval 10
year);


use clinica;

-- o novo nome dos campos ficarão entre parentese e o nome das colunas no banco dedados ficará depois do "as"
Create view vw_cardio_hipertenso(codigo, nome,
datanasc) as
Select codp, nomep,dt_nasc from paciente
Where problema='cardiaco' or problema='hipertensao';


select * from vw_cardio_hipertenso;


Create view vw_aposentados as
Select * From paciente
Where date_add(dt_nasc,Interval 60
year)<=current_date();
/* date_add soma um valor em dias,meses ou ano com uma determinada data */
/*current_date() : retorna a data atual */



create view vw_cardio_hipertenso_jovem as
select * from vw_cardio_hipertenso
where date_add(dataNasc, Interval 40 year) >=
current_date();

select * from vw_cardio_hipertenso_jovem;

insert into paciente(nomep,sexo,dt_nasc,problema)
values ('Joao Pedro', 'm', '2005-03-06','cardiaco');
Select * from vw_cardio_hipertenso_jovem;
/* os dados do Joao Pedro também serão listados por
esse select */


use empresa;
/*Usando BD Empresa
- Crie uma visão DadosFunc que contenha o nome do funcionario, a data de admissao, o nome do departamento, o nome do cargo e o salário.*/
Create view DadosFunc(nome, admissao, departamento, cargo,salario) as
Select f.nome, f.data_adm,d.nome, c.nome,c.salario from funcionario f
join departamento d on f.cod_depto=d.cod_depto
join cargo c on c.cod_cargo=f.cod_cargo;


select * from DadosFunc;

/* - Criar uma visao funcionariosPorDepto, que contenha o nome do departamento e a quantidade de funcionarios que trabalham nele*/

create view funcionariosporDepto as
select d.nome nmDepto, count(*) qtdeFunc
from funcionario f join departamento d
on f.cod_depto=d.cod_depto
group by d.cod_depto;

select * from funcionariosporDepto;
-- apagar visão: Drop view [nome da visão]

/*atualizar visão U(Update),I(Insert), D(Delete)
• Colunas obtidas através de um cálculo não podem ser atualizadas. Não permitem U, I e D.

• Visões compostas por funções agregadas e/ou agrupamento.
– Não permitem U,I e D.

A inserção de uma nova linha na visão não pode violar a restrição de chave primária
• Inserções devem incluir todas as colunas not null da tabela base.
• Se a visão foi obtida através de uma junção:
– Só é possível atualizar os dados de uma das tabelas por vez.

*/


update dadosFunc
set NomeFunc="Ana Silveira Mendes" where
NomeFunc="Ana Silveira";


update dadosFunc
set NomeFunc="Ruth Souza Silva",NomeDepto="Setor
de Servicos" where NomeFunc="Ruth Souza";

use clinica;

update vw_cardio_hipertenso_jovem
set dataNasc="1975-01-05"
where nome="Joao Pedro";

-- RESTRIÇÃO DE INTEGRIDADE IRÁ PARA O PROJETO

/*
* NOT NULL  - Não permite que o campo esteja vazio
* Default - caso o campo esteja vazio  coloque a isntrução-> default "Uberlândia" (resumo: caso nada seja preenchido, automaticamente preencherá "Uberlândia")
* UNIQUE - Permite que um valor seja exclusivo, não permite repetições. A chave primaria carrega de forma implicita a restrição unique e Not Null.

Create table filme(
cod_filme int auto_increment,
titulo varchar(30),
ano numeric(4),
diretor varchar(40),
Primary key(cod_filme),
Unique (titulo,ano));

* CHECK - Há situações onde o valor de um campo deve ficar restrito a um conjunto de valores. No caso abaixo os valores aceitos para Sexo são "F" e "M"

CREATE TABLE aluno (
Cod_aluno int auto_increment primary key,
nome VARCHAR(50) NOT NULL,
sexo CHAR(1) CHECK(sexo IN ("M", "F"))); 

* PRIMARY KEY - 
A chave estrangeira referencia a chave primária de uma outra tabela
■ Regra da integridade referencial
■ Deve garantir que inserções ou alterações gere a ocorrência de valores para o campo que é chave estrangeira que não possuem correspondência na chave referenciada
■ Definida durante a criação da tabela


Tratamento Default
■ Não permitir que alterações ou remoções na tabela referenciada gere tuplas orfãs
■ Corresponde as cláusulas ON DELETE RESTRICT ON UPDATE RESTRICT

ON DELETE SET NULL e ON UPDATE SET
NULL
■ ON DELETE SET NULL: Se o valor do atributo for deletado na tabela referenciada, ele é preenchido como null na tabela onde o campo é chave estrangeira
■ ON UPDATE SET NULL: Se o valor do atributo for atualizado na tabela referenciada, ele é preenchido como null na tabela onde o campo é chave estrangeira

Exemplo
Drop table curso;
create table curso(
Id_curso int auto_increment primary key,
Nome_curso varchar(20) not null,
Cod_depto int,
foreign key(cod_depto) references departamento(cod_depto)
on delete set null  <-----------------  nesses casos de delet será incluso null onde a chave primaria for chave estrangeira
on update set null);<-----------------

ON DELETE CASCADE e ON UPDATE CASCADE
■ ON DELETE CASCADE: A operação de delete na tabela referenciada gera a remoção dos registros que possuem como chave estrangeira o valor removido
■ ON UPDATE CASCADE: A operação de alteração na tabela referenciada gera a alteração dos registros que possuem como chave estrangeira o valor alterado

* FOREIGN KEY - 
* AUTO_INCREMENT - 
* SET
* ENUM - ele aceita null e caso o campo seja not null ele pegará o primeiro valor da lista
*/


