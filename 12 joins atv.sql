select emp.nome "Empregado", emp.CPF "CPF",  date_format(emp.dataAdm, "%H:%i %d/%m/%Y") "Data de Admissão",  concat("R$ ", format (emp.salario, 2, "de_DE")) "Salário",
 dep.nome "Nome do Departamento", Departamento_idDepartamento "Id do Departamenento"
	from empregado emp
		inner join departamento dep on dep.idDepartamento = emp.Departamento_idDepartamento;
        
 -- Primeiro Relatório  
select emp.nome "Empregado", emp.CPF "CPF",  date_format(emp.dataAdm, "%H:%i %d/%m/%Y") "Data de Admissão",  concat("R$ ", format (emp.salario, 2, "de_DE")) "Salário",
dep.nome "Nome do Departamento", Departamento_idDepartamento "Id do Departamenento"
	from empregado emp
		inner join departamento dep on dep.idDepartamento = emp.Departamento_idDepartamento
        where emp.dataAdm between "2019-01-01" and "2022-03-31"
        order by emp.dataAdm desc;
        
 -- Segundo Relatório       
select emp.nome "Empregado", emp.CPF "CPF",  date_format(emp.dataAdm, "%H:%i %d/%m/%Y") "Data de Admissão",  concat("R$ ", format (emp.salario, 2, "de_DE")) "Salário",
 dep.nome "Nome do Departamento", Departamento_idDepartamento "Id do Departamenento"
	from empregado emp
		inner join departamento dep on dep.idDepartamento = emp.Departamento_idDepartamento
        where salario < (select avg(salario) from empregado)
        order by emp.nome;
        
-- Terceiro Relatório
select dep.nome "Nome do Departamento", dep.idDepartamento "ID do Departamento", 
count(emp.cpf) "Quantidade de Funcionários", 
concat("R$ ", format (avg(emp.salario), 2, "de_DE")) "Média Salarial",
concat("R$ ", format (avg(emp.comissao), 2, "de_DE")) "Média Comissional"
	from departamento dep
		left join empregado emp on dep.idDepartamento = emp.Departamento_idDepartamento
		group by dep.nome, dep.idDepartamento
			order by dep.nome;
    
-- Quarto Relatório
select emp.nome "Empregado", emp.CPF "CPF", concat("R$", format (emp.salario, 2, "de_DE")) "Salário",
 concat("R$ ", format (sum(vnd.comissao), 2, "de_DE")) "Total Valor Comissão",
 concat("R$ ", format (sum(vnd.valor), 2, "de_DE")) "Total Valor Vendido",
 count(vnd.idVenda) "Quantidade de Vendas"
	from empregado emp
		inner join venda vnd ON vnd.Empregado_cpf = emp.CPF
		group by emp.nome, emp.CPF, emp.sexo, emp.salario
			order by count(vnd.idVenda) desc;

-- Quinto Relatório
select emp.nome "Empregado", emp.CPF "CPF", 
concat("R$ ", format (emp.salario, 2, "de_DE")) "Salário",
count(vnd.idVenda)"Quantidade Vendas com Serviço",
concat("R$ ", format (sum(vnd.valor), 2, "de_DE")) "Total Valor Vendido com Serviço",
concat("R$ ", format (sum(vnd.comissao), 2, "de_DE")) "Total Comissão das Vendas com Serviço"
	from empregado emp
		inner join itensservico its on its.Empregado_cpf = emp.cpf
        inner join servico svc on its.Servico_idServico = svc.idServico
        inner join venda vnd on its.venda_idvenda = vnd.idvenda
			group by emp.nome, emp.cpf, emp.salario 
				order by count(vnd.idVenda) desc;

-- Sexto Relatório
select pet.nome "Nome do Pet", date_format(vnd.data, "%H:%i %d/%m/%Y") "Data do Serviço", svc.nome "Nome do Serviço", 
count(svc.idServico) "Quantidade",
emp.nome" Empregado que realizou o Serviço"
	from pet pet
		inner join itensservico its on its.PET_idPET = pet.idPET
        inner join servico svc on its.Servico_idServico = svc.idServico
        inner join empregado emp on its.Empregado_cpf = emp.cpf
        inner join venda vnd on its.venda_idvenda = vnd.idvenda	
			group by pet.nome, vnd.data, svc.nome, emp.nome
				order by vnd.data;
                
-- Sétimo Relatório
select cli.nome "Cliente", date_format(vnd.data, "%H:%i %d/%m/%Y") "Data da Venda",
concat("R$ ", format(vnd.valor, 2, "de_DE")) "Valor",
concat("R$ ", format(vnd.desconto, 2, "de_DE")) "Desconto",
concat("R$ ", format(vnd.valor - vnd.desconto, 2, "de_DE")) "Valor Total",
emp.nome "Empregado que realizou a venda"
	from cliente cli
		inner join venda vnd on vnd.Cliente_cpf = cli.cpf
        inner join empregado emp on vnd.Empregado_cpf = emp.cpf;
        
-- Oitavo Relatório
select svc.nome "Nome do Serviço", count(vnd.idVenda) "Quantidade de Venda", 
concat("R$ ", format (sum(svc.valorvenda), 2, "de_DE")) "Total Valor Vendido"
	from servico svc
    inner join itensservico its on its.Servico_idServico = svc.idServico
	inner join venda vnd on its.venda_idvenda = vnd.idvenda
		group by svc.nome
			order by count(vnd.idVenda)
				limit 10;

-- Nono Relatório
select fpv.tipo "Tipo da Forma Pagamento", count(fpv.idFormaPgVenda) "Quantidade das Vendas",
concat("R$ ", format(sum(vnd.valor), 2, "de_DE")) "Total do Valor Vendido"
	from venda vnd
		inner join formapgvenda fpv on fpv.Venda_idVenda = vnd.idVenda
			group by fpv.tipo
				order by count(fpv.idFormaPgVenda) desc;
                
-- Décimo Relatório
select date_format(vnd.data, "%H:%i %d/%m/%Y") "Data de Venda", count(vnd.data) "Quantidade de Vendas",
concat("R$ ", format(sum(vnd.valor - vnd.desconto), 2, "de_DE")) "Valor Total Venda"
	from venda vnd
		group by vnd.idVenda
			order by vnd.data;
        
-- Décimo Primeiro Relatório
select distinct prod.nome "Nome do Produto", coalesce(forn.nome, "Não informado") "Fornecedor", 
concat("R$ ", format(prod.precoCusto, 2, "de_DE")) "Valor do Produto", prod.idProduto "Id do Produto", 
coalesce(forn.email, "Não informado")"Email do Fornecedor",
coalesce(tel.numero, "Não informado") "Telefone do Fornecedor"
	from produtos prod
		left join itenscompra itc on itc.Produtos_idProduto = prod.idProduto
        left join compras comp on itc.Compras_idCompra = comp.idCompra
        left join fornecedor forn on comp.Fornecedor_cpf_cnpj = forn.cpf_cnpj
        left join telefone tel on tel.Fornecedor_cpf_cnpj = forn.cpf_cnpj
			order by prod.nome;
        
        
-- Décimo Segundo Relatório
select prod.nome "Nome do Produto",
count(vnd.idVenda) "Quantidade (Total) Vendas",
concat("R$ ", format(sum(vnd.valor - vnd.desconto), 2, "de_DE")) "Valor Total Venda"
	from produtos prod
		inner join itensvendaprod ivd on ivd.Produto_idProduto = prod.idProduto
        inner join venda vnd on ivd.Venda_idVenda = vnd.idVenda
			group by prod.nome
				order by count(vnd.idVenda) desc; 

        

