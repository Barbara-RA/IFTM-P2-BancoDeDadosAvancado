use brasil;

alter table aluno add index nome_idx (nome);

Select *
From cidade
Where nome like 'C%';

Alter table cidade add index nome_idx(nome);
Select *
From cidade
Where nome like 'C%';


select c.*
from cidade c straight_join estado e
where c.id_estado=e.id and e.nome='Minas Gerais';


select c.*
from cidade c ,estado e
where c.id_estado=e.id and e.nome='Minas Gerais';



select c.*
from cidade c straight_join estado e
where c.id_estado=e.id and e.nome='Minas Gerais';

Alter table cidade add index nome_idx(nome);
Select *
From cidade
Where nome like 'C%';

select * from cidade
ignore index(nome_idx)
where nome like 'C%';
