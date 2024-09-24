-- drop database e_commerce.
create database e_commerce;

use e_commerce;

-- 1
-- a. Crie dentro dessa base de dados a tabela eventos (Slide 23)
CREATE TABLE eventos(
id int auto_increment primary key,
nome_evento varchar(255),
visitante varchar(255),
propriedades json,
navegador json
);


-- b. Execute o script de inserção de dados na tabela eventos (Slide 24)
INSERT INTO eventos(nome_evento, visitante,propriedades,navegador)
VALUES ('pageview', '1','{ "page": "/" }','{ "name": "Safari", "os": "Mac", "resolution": { "x": 1920, "y":
1080 } }'),
('pageview', '2','{ "page": "/contact" }','{ "name": "Firefox", "os": "Windows", "resolution": { "x": 2560,
"y": 1600 } }'
),
('pageview', '1','{ "page": "/products" }','{ "name": "Safari", "os": "Mac", "resolution": { "x": 1920, "y":
1080 } }'
),
('purchase', '3','{ "amount": 200 }','{ "name": "Firefox", "os": "Windows", "resolution": { "x": 1600, "y":
900 } }'),
(
'purchase',
'4',
'{ "amount": 150 }',
'{ "name": "Firefox", "os": "Windows", "resolution": { "x": 1280, "y": 800 } }'
),
(
'purchase',
'4',
'{ "amount": 500 }',
'{ "name": "Chrome", "os": "Windows", "resolution": { "x": 1680, "y": 1050 } }'
);

-- c. Insira mais dois registros na tabela eventos para o visitante 1, referente a compras nos valores de 200 e 300. (...)
insert into eventos(nome_evento, visitante, propriedades, navegador)
values 
('purchase', '1', '{ "amount": 200 }', '{ "name": "Safari", "os": "Mac", "resolution": { "x": 1920, "y": 1080 } }'),
('purchase', '1', '{ "amount": 300 }', '{ "name": "Safari", "os": "Mac", "resolution": { "x": 1920, "y": 1080 } }');

-- 2 
/*Selecionar o nome dos navegadores (name) e sistemas operacionais (os) utilizados
pelos visitantes, ordenado pelo nome do sistema operacional. Elimine as repetições.*/

select distinct 
    json_unquote(json_extract(navegador, '$.name')) as nome_navegador,
    json_unquote(json_extract(navegador, '$.os')) as sistema_operacional
from 
    eventos
order by 
    sistema_operacional;
    
    
-- b. Selecionar a quantidade de acessos por nome de navegador.
   select 
    json_unquote(json_extract(navegador, '$.name')) as nome_navegador,
    count(*) as quantidade_acessos
from 
    eventos
group by 
    nome_navegador;
 
 
 -- c. Selecionar o total pago para cada um dos visitantes que efetuaram compras.
select 
    visitante,
    sum(json_unquote(json_extract(propriedades, '$.amount'))) as total_pago
from 
    eventos
where 
    nome_evento = 'purchase'
group by 
    visitante;

-- d. Selecionar o nome do navegador e a resolução no formato x X y. Elimine as repetições.
select distinct 
    json_unquote(json_extract(navegador, '$.name')) as nome_navegador,
    concat(
        json_unquote(json_extract(navegador, '$.resolution.x')), 
        ' X ', 
        json_unquote(json_extract(navegador, '$.resolution.y'))
    ) as resolucao
from 
    eventos;
    
/**i. Crie uma função para formatar a resolução no formato x X y (ex. 1920 X 1080)
1. Entrada: valor de x e valor de y
2. Saída: string com a formatação x X y*/

-- Cria a função para formatar a resolução

delimiter $$
create function formatar_resolucao(x int, y int) 
returns varchar(20) 
begin
    
    return concat(x, ' X ', y);
end $$

delimiter ;

-- e. Selecionar a maior e a menor resolução dos visitantes que acessaram o site.
select 
    concat(
        max(json_unquote(json_extract(navegador, '$.resolution.x'))), 
        ' X ', 
        max(json_unquote(json_extract(navegador, '$.resolution.y')))
    ) as maior_resolucao,
    concat(
        min(json_unquote(json_extract(navegador, '$.resolution.x'))), 
        ' X ', 
        min(json_unquote(json_extract(navegador, '$.resolution.y')))
    ) as menor_resolucao
from 
    eventos;
    
/*Selecionar os dados de navegação dos visitantes que fizeram alguma compra com o valor igual ou superior a 400.*/
select 
    e1.visitante,
    e1.navegador
from 
    eventos e1
join 
    eventos e2
on 
    e1.visitante = e2.visitante
where 
    e2.nome_evento = 'purchase' 
    and json_unquote(json_extract(e2.propriedades, '$.amount')) >= 400
    and e1.nome_evento != 'purchase';




