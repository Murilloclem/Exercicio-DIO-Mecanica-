CREATE database mecanica;
use mecanica;

Create table cliente(
	idcliente int auto_increment primary key,
	nome varchar(45),
	CPF char(11) unique,
	telefone char(11)
);

create table veiculo(
	idveiculo int auto_increment primary key,
	marca varchar(45),
	Modelo varchar(45),
	placa char(7) unique,
	id_cliente int not null,
	constraint FK_veiculo_cliente foreign key (id_cliente) references cliente (idcliente)
	);
    
    
create table verificacao(
		idverificacao int auto_increment primary key,
		tarefa enum ('revisão','concerto'),
		ID_veiculo int not null,
		constraint FK_veiculo_verificacao  foreign key (id_veiculo) references veiculo (idveiculo)
);
	

create table mecanicos(
	idmecanico int auto_increment primary key,
	nome varchar (45),
	CPF char (11),
	telefone char (11),
	endereco varchar (255),
	especialidade varchar (45)
    
    
);

create table servico(
	idservico int auto_increment primary key,
	id_mecanico int not null,
	id_verificacao int not null,
	constraint FK_verificacao_servico foreign key (id_verificacao) references verificacao (idverificacao),
	constraint FK_equipe_servico foreign key (id_mecanico) references mecanicos (idmecanico)
);    
    

create table ordem_servico(
	idordem_servico int auto_increment primary key,
	valor_mao_de_obra float,
	valor_pecas float,
	data_da_entrega date,
	data_da_emissao date,
	status varchar(45),
	valor_total float as (valor_mao_de_obra + valor_pecas) stored 
);

create table autorizacao(
	idautorização int auto_increment primary key,
	autorização enum('sim', 'não'),
	id_ordem_servico int not null,
	id_servico int,
	constraint FK_autorizacao_ordem_servico foreign key (id_ordem_servico) references ordem_servico (idordem_servico),
	constraint FK_autorizacao_servico foreign key (id_servico) references servico (idservico)
);


Create table execucao(
	idexecucao int auto_increment primary key,
	servico enum('na fila de espera','em andamento', 'finalizado'),
	idautorização int not null,
	idordem_servico int,
	constraint FK_autorizacao_execucao foreign key (idautorização) references autorizacao (idautorização),
	constraint FK_ordem_servico_execucao foreign key (idordem_servico) references  ordem_servico (idordem_servico)
);


insert into cliente (nome,CPF,telefone) values ('Carlos', 19234929319, 41997892810);

insert into cliente (nome,CPF,telefone) values ('Vania', 12394939192, 41998129391);
	
insert into cliente (nome,CPF,telefone) values ('Joao', 93429493912, 41992893919);	

select * from cliente;

insert into veiculo (id_cliente,marca,modelo,placa) values (1,'Chevrolet','Celta','BRA1A12');

insert into veiculo (id_cliente,marca,modelo,placa) values (2,'Fiat','Uno','ARA8w58');

insert into veiculo (id_cliente,marca,modelo,placa) values (3,'Honda','HB20','FAJ6Z35');

select * from cliente;

select * from veiculo;

select c.nome, c.CPF, c.telefone, v.marca, v.modelo, v.placa 
from cliente c inner join veiculo v 
on c.idcliente = v.idveiculo
order by v.marca;


insert into verificacao (ID_veiculo, tarefa) values (1,'concerto');
insert into verificacao (ID_veiculo, tarefa) values (2,'revisão');
insert into verificacao (ID_veiculo, tarefa) values (3,'concerto');

select * from verificacao;


select v.marca,.v.modelo,v.placa,ve.tarefa
from veiculo v inner join verificacao ve
on v.idveiculo = ve.id_veiculo;

select c.nome, c.CPF, c.telefone, v.marca, v.modelo, v.placa, ve.tarefa
from cliente c inner join veiculo v 
on c.idcliente = v.idveiculo
inner join verificacao ve
on v.idveiculo = ve.idverificacao
order by v.marca;

insert into mecanicos (nome,cpf,telefone,endereco,especialidade) values ('Marcos',12342345123,41898283892,'Parana', 'pintor');
insert into mecanicos (nome,cpf,telefone,endereco,especialidade) values ('Claudemar',12342345123,41898283892,'Parana', 'mecanico');
insert into mecanicos (nome,cpf,telefone,endereco,especialidade) values ('Valdir',12342345123,41898283892,'Parana', 'mecanico chefe');
insert into mecanicos (nome,cpf,telefone,endereco,especialidade) values ('Waldiney',12342345123,41898283892,'Parana', 'mecanico');

select * from mecanicos;


insert into ordem_servico (valor_mao_de_obra,valor_pecas,data_da_entrega,data_da_emissao,status) values (590.99,1260,'2024-12-20','2024-11-27','aprovada');

insert into ordem_servico (valor_mao_de_obra,valor_pecas,data_da_entrega,data_da_emissao,status) values (120.99,250,'24-12-12','2024-12-01','aprovada');

insert into ordem_servico (valor_mao_de_obra,valor_pecas,data_da_entrega,data_da_emissao,status) values (1000,10000,'2024-11-20','2024-11-20','rejeitada');

select * from ordem_servico;

insert into autorizacao(id_ordem_servico,autorização) values (1,'sim');

insert into autorizacao(id_ordem_servico,autorização) values (2,'sim');

insert into autorizacao(id_ordem_servico,autorização) values (3,'não');
select * from autorizacao;

insert into execucao (servico,idautorização) values ('na fila de espera',1);
insert into execucao (servico,idautorização) values ('em andamento',2);
insert into execucao (servico,idautorização) values ('finalizado',3);

select * from execucao;

select 
c.nome,c.CPF,c.telefone,
v.marca,v.modelo,v.placa,
ve.tarefa,
o.valor_mao_de_obra,o.valor_pecas,o.data_da_emissao,o.data_da_entrega,o.status,o.valor_total,
a.autorização,
e.servico
from cliente c inner join veiculo v on c.idcliente = v.idveiculo
inner join verificacao ve on v.idveiculo = ve.idverificacao
inner join ordem_servico o on ve.idverificacao = o.idordem_servico
inner join autorizacao a on o.idordem_servico = a.idautorização
inner join execucao e on a.idautorização = idexecucao
order by c.nome;