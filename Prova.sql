Create table investidores(
id serial primary key,
nome varchar(120) not null,
cpf varchar(11) not null unique,
nivel_experiencia int default 0 check (nivel_experiencia >= 0)

);


create table carteiras(
id serial primary key,
investidor_id int references investidores(id),
endereco_wallet varchar(30) not null unique,
rede_blockchain varchar(30) not null,
saldo_usd numeric(10,2) check (saldo_usd > 0) not null,
status varchar(20) default 'Ativa' check (status in ('Ativa','Em analise', 'bloqueada', 'Pausada'))

);

Create table  corretoras(
id serial primary key,
nome_exchange varchar(100) not null,
cnpj varchar(14) not null unique,
email_suporte varchar(150) not null unique
);

Create table  criptomoedas(
id serial primary key,
corretora_id int references corretoras (id),
nome_moeda varchar(120) not null,
preco_unitario_usd numeric(10,2) check (preco_unitario_usd > 0) not null,
categorias varchar(20) default 'Layer1' check (categorias in ('Layer1','DeFi', 'Memecoin', 'Stablecoin'))

);

Create table transacoes_cripto(
id serial primary key,
carteiras_id int references carteiras (id),
criptomoedas_id int references criptomoedas (id),
quantidade numeric(10,2) check (quantidade > 0) not null,
valor_pago numeric(10,2) check (valor_pago > 0) not null,
data_transacao timestamp default current_timestamp

);

insert into investidores (nome, cpf, nivel_experiencia) values
('Pedro','11132223434',0),
('Lucas','82748974948',3),
('Maria','95830407474',2),
('Dante','09858590010',6),
('Margo','56498376584',5);

insert into  carteiras (investidor_id, endereco_wallet, rede_blockchain, saldo_usd, status ) values
(1, 'ACT -321' , 'bitcoin', 4570.00, 'Ativa'),
(2, 'MGH -701' , 'Ethereum', 1809.00, 'Em analise'),
(3, 'PLQ -671' , 'bitcoin', 8756.00, 'Pausada'),
(4, 'DCF -396' , 'Solana', 2094.00, 'Ativa'),
(5, 'LOR -057' , 'Ethereum', 9036.00, 'bloqueada');

insert into  corretoras (nome_exchange, cnpj, email_suporte) values
('Trobas','98247937823741','Trobas_suport@gmail.com'),
('Medias','09832098430943','Medias_suport@gmail.com'),
('Sentra','47982347437284','Sentra_suport@gmail.com'),
('Luvins','38709328493829','Luvins_suport@gmail.com'),
('Caixas','98230948290384','Caixas_suport@gmail.com');


insert into  criptomoedas ( corretora_id,  nome_moeda, preco_unitario_usd,  categorias) values
(1, 'bitcoin', 1835.00, 'Memecoin'),
(2, 'Ethereum', 9845.00, 'Stablecoin'),
(3, 'bitcoin', 3845.00, 'Layer1'),
(4, 'Solana', 9873.00, 'Memecoin'),
(5, 'Ethereum', 1201.00, 'DeFi');

insert into transacoes_cripto ( carteiras_id, criptomoedas_id, quantidade, valor_pago) values
(1, 1, 18, 934.00),
(2, 2, 68, 4854.00),
(3, 3, 30, 8876.00),
(4, 4, 01, 380.00),
(5, 5, 12, 1234.00);

SELECT
    carteiras.endereco_wallet,
    carteiras.rede_blockchain,
    carteiras.saldo_usd,
    investidores.nome,
    investidores.cpf
FROM carteiras
JOIN investidores
ON carteiras.investidor_id = investidores.id
WHERE carteiras.status IN ('Ativa', 'Em analise');

SELECT
    carteiras.endereco_wallet,
    criptomoedas.nome_moeda,
    transacoes_cripto.quantidade,
    transacoes_cripto.valor_pago,
    transacoes_cripto.data_transacao
FROM transacoes_cripto
JOIN carteiras
ON transacoes_cripto.carteiras_id = carteiras.id
JOIN criptomoedas
ON transacoes_cripto.criptomoedas_id = criptomoedas.id
WHERE transacoes_cripto.valor_pago > 500
ORDER BY transacoes_cripto.valor_pago DESC;

SELECT
    corretoras.nome_exchange,
    SUM(transacoes_cripto.valor_pago) AS total_movimentado
FROM transacoes_cripto
JOIN criptomoedas
ON transacoes_cripto.criptomoedas_id = criptomoedas.id
JOIN corretoras
ON criptomoedas.corretora_id = corretoras.id
GROUP BY corretoras.nome_exchange;


CREATE VIEW vw_painel_carteiras AS
SELECT
    carteiras.endereco_wallet,
    carteiras.rede_blockchain,
    carteiras.status,
    carteiras.saldo_usd,
    investidores.nome,
    investidores.cpf
FROM carteiras
JOIN investidores
ON carteiras.investidor_id = investidores.id;

