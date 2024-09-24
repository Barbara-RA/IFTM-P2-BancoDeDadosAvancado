use MePoupe;

/*2) Crie o procedimento sp_insere_cli que irá receber como dados de entrada o nome,
CPF, sexo, data de nascimento, telefone e email de um cliente e fará a inserção na
tabela cliente. Validar o preenchimento de campos obrigatórios.
Cliente(cod_cliente, nome, CPF,sexo, dt_nasc, Telefone, email)*/

-- drop procedure sp_insere_cli;
DELIMITER $
CREATE PROCEDURE sp_insere_cli (
var_nome varchar(50),
var_cpf varchar(11),
var_sexo varchar(1),
var_dt_nasc date,
var_telefone char(15),
var_email varchar(100))
begin
IF(var_nome is null or var_cpf is null ) then 
select "Os campos Nome e CPF são de preenchimento obrigatório" as msg;
else
Insert INTO cliente(nome,CPF,sexo,dt_nasc,telefone,email)
VALUES (var_nome, var_cpf, var_sexo, var_dt_nasc, var_telefone, var_email);
end if;
END $
DELIMITER ;


-- 3) Faça um procedimento para registrar uma transferência de uma conta para outra:
-- • Criar a tabela registro de transferência antes de fazer a criação do procedimento.
-- • Campos: codigo da transferência, codigo da conta de origem, codigo da conta de destino, valor da transferência, data e hora.


-- drop table reg_transferencia;
CREATE TABLE reg_transferencia(
cod_tranf int auto_increment primary key,
cod_conta_origem int,
cod_conta_destino int,
valor_tranf numeric(9,2),
dt_hora_transf datetime default current_timestamp,
foreign key (cod_conta_origem) references conta_corrente (cod_conta),
foreign key (cod_conta_destino) references conta_corrente (cod_conta)
);


/*
• Parâmetros de entrada: codigo da conta de origem, codigo da conta de
destino,valor da transferência.
• Validar se a conta de origem tem saldo suficiente antes de efetuar a transferência.
• Atualizar o saldo da conta de origem e da conta de destino.*/

-- drop procedure registro_transferencia;
delimiter $
create procedure registro_transferencia (
    in var_conta_origem int, 
    in var_conta_destino int, 
    in var_valor numeric(9,2)
)
begin
    declare saldo_origem numeric(9,2);

    -- Verifica o preenchimento dos parâmetros e se o valor é maior que zero
    if var_conta_origem is null or var_conta_destino is null or var_valor is null then
        select 'conta de origem, conta de destino e valor são obrigatórios' as msg;
    elseif var_valor <= 0 then
        select 'o valor da transferência deve ser maior que zero'as msg;
    else
        -- Valida se a conta de origem tem saldo suficiente
        select saldo into saldo_origem
        from conta_corrente
        where cod_conta = var_conta_origem;

        if saldo_origem >= var_valor then
            -- Atualiza saldo da conta de origem
            update conta_corrente
            set saldo = saldo - var_valor
            where cod_conta = var_conta_origem;

            -- Atualiza saldo da conta de destino
            update conta_corrente
            set saldo = saldo + var_valor
            where cod_conta = var_conta_destino;

            -- Insere registro na tabela de transferência
            insert into reg_transferencia (cod_conta_origem, cod_conta_destino, valor_tranf)
            values (var_conta_origem, var_conta_destino, var_valor);
        else
             select 'saldo insuficiente na conta de origem' as msg;
        end if;
    end if;
end $

delimiter ;

call registro_transferencia (1,2,-5);
select * from reg_transferencia;
call registro_transferencia (2,1,5);
select * from reg_transferencia;


/* 4 -Crie um procedimento que terá como entrada uma data de inicial e uma data final e irá gerar um relatório contendo o nome do cliente, 
número da conta e o valor total de depósitos realizados para a conta no período informado. Ordenar pelo valor total dos depósitos.*/

-- drop procedure relatorio_depositos
delimiter $

create procedure gerar_relatorio_depositos(
    in data_inicio date,
    in data_fim date
)
begin
    select 
        c.nome as nome_cliente,
        cc.cod_conta as numero_conta,
        sum(rd.valor_deposito) as valor_total_depositos
    from 
        cliente c
        join conta_corrente cc on c.cod_cliente = cc.cod_cliente
        join registro_deposito rd on cc.cod_conta = rd.cod_conta
    where 
        rd.dt_deposito between data_inicio and data_fim
    group by 
        c.nome, cc.cod_conta
    order by 
        valor_total_depositos desc;
end $

delimiter ;

/*5)Crie um procedimento para fazer o relatório anual das contas, informando como entrada o ano e código do relatório desejado (1: total de Saques ou 2: total de depósitos). O relatório
deverá conter o número da conta, mês , total de saques (se código do relatório for 1) ou total de depósitos (se código do relatório for 2).*/

-- drop procedure gerar_relatorio_anual_contas
delimiter $
create procedure gerar_relatorio_anual_contas(
    in ano int,
    in cod_relatorio int
)
begin
    if cod_relatorio = 1 then
        select 
            cc.cod_conta as numero_conta,
            month(rs.dt_saque) as mes,
            sum(rs.valor_saque) as total_saques
        from 
            conta_corrente cc
            join registro_saque rs on cc.cod_conta = rs.cod_conta
        where 
            year(rs.dt_saque) = ano
        group by 
            cc.cod_conta, month(rs.dt_saque)
        order by 
            cc.cod_conta, mes;
    elseif cod_relatorio = 2 then
        select 
            cc.cod_conta as numero_conta,
            month(rd.dt_deposito) as mes,
            sum(rd.valor_deposito) as total_depositos
        from 
            conta_corrente cc
            join registro_deposito rd on cc.cod_conta = rd.cod_conta
        where 
            year(rd.dt_deposito) = ano
        group by 
            cc.cod_conta, month(rd.dt_deposito)
        order by 
            cc.cod_conta, mes;
    else
        select 'Código de relatório inválido' as msg;
    end if;
end $
delimiter ;

call gerar_relatorio_anual_contas(2020, 1);
call gerar_relatorio_anual_contas(2020, 2);



SELECT BENCHMARK(1000000,1+1); -- expressão 1+1
SELECT BENCHMARK(1000000,(select sum(valor_curso) from
curso)) ;
select benchmark(1000000,(select avg(valor_curso) from
curso));
