use Clinica;

delimiter $
create procedure listar_futuras_consultas ()
begin
Declare var_data_atual date;
set var_data_atual =current_date();
select * from consulta where dt_consulta>var_data_atual;
end $
Delimiter ;

/*Utilizando o procedimento listar futuras consultas*/
insert into consulta (codm,codp,dt_consulta,hora_consulta,valor_consulta)
values (2,1,'2022-10-30','14:00',280);
call listar_futuras_consultas;