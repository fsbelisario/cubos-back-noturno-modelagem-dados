--Criação do banco de dados
CREATE DATABASE ecommerce;

--Criação das tabelas e relações
CREATE TABLE categorias (
  id serial NOT NULL PRIMARY KEY,
  nome varchar(50)
);

CREATE TABLE clientes (
  cpf char(11) NOT NULL PRIMARY KEY,
  nome varchar(150) NOT NULL
);

CREATE TABLE vendedores (
  cpf char(11) NOT NULL PRIMARY KEY,
  nome varchar(150) NOT NULL
);

CREATE TABLE produtos (
  id serial NOT NULL PRIMARY KEY,
  nome varchar(100),
  descricao text,
  preco int NOT NULL,
  quantidade_em_estoque int NOT NULL,
  categoria_id int NOT NULL REFERENCES categorias(id)
);

CREATE TABLE pedidos (
  id serial NOT NULL PRIMARY KEY,
  valor int,
  cliente_cpf char(11) NOT NULL REFERENCES clientes(cpf),
  vendedor_cpf char(11) NOT NULL REFERENCES vendedores(cpf)
);

CREATE TABLE itens_do_pedido (
  id serial NOT NULL PRIMARY KEY,
  pedido_id int NOT NULL REFERENCES pedidos(id),
  quantidade int NOT NULL,
  produto_id int NOT NULL REFERENCES produtos(id)
);

--1 - Alimentar a tabela categorias
INSERT INTO categorias
(nome)
VALUES
('frutas'),
('verduras'),
('massas'),
('bebidas'),
('utilidades');

--2 - Alimentar a tabela produtos
INSERT INTO produtos
(nome, descricao, preco, quantidade_em_estoque, categoria_id)
VALUES
('Mamão','Rico em vitamina A, potássio e vitamina C',300,123,1),
('Maça','Fonte de potássio e fibras.',90,34,1),
('Cebola','Rico em quercetina, antocianinas, vitaminas do complexo B, C.',50,76,2),
('Abacate','NÃO CONTÉM GLÚTEN.',150,64,1),
('Tomate','Rico em vitaminas A, B e C.',125,88,2),
('Acelga','NÃO CONTÉM GLÚTEN.',235,13,2),
('Macarrão parafuso','Sêmola de trigo enriquecida com ferro e ácido fólico, ovos e corantes naturais',690,5,3),
('Massa para lasanha','Uma reunião de família precisa ter comida boa e muita alegria.',875,19,3),
('Refrigerante coca cola lata','Sabor original',350,189,4),
('Refrigerante Pepsi 2l','NÃO CONTÉM GLÚTEN. NÃO ALCOÓLICO.',700,12,4),
('Cerveja Heineken 600ml','Heineken é uma cerveja lager Puro Malte, refrescante e de cor amarelo-dourado',1200,500,4),
('Agua mineral sem gás','Smartwater é água adicionado de sais mineirais (cálcio, potássio e magnésio) livre de sódio e com pH neutro.',130,478,4),
('Vassoura','Pigmento, matéria sintética e metal.',2350,30,5),
('Saco para lixo','Reforçado para garantir mais segurança',1340,90,5),
('Escova dental','Faça uma limpeza profunda com a tecnologia inovadora',1000,44,5),
('Balde para lixo 50l','Possui tampa e fabricado com material reciclado',2290,55,5),
('Manga','Rico em Vitamina A, potássio e vitamina C',198,176,1),
('Uva','NÃO CONTÉM GLÚTEN.',420,90,1);

--3 - Alimentar a tabela clientes
INSERT INTO clientes
(cpf, nome)
VALUES
('80371350042','José Augusto Silva'),
('67642869061','Antonio Oliveira'),
('63193310034','Ana Rodrigues'),
('75670505018','Maria da Conceição');

--4 - Alimentar a tabela vendedores
INSERT INTO vendedores
(cpf, nome)
VALUES
('82539841031','Rodrigo Sampaio'),
('23262546003','Beatriz Souza Santos'),
('28007155023','Carlos Eduardo');

--5 - Realizar vendas
--a) José Algusto comprou os seguintes itens com o vendedor Carlos Eduardo:
--1 Mamão, 1 Pepsi de 2l, 6 Heinekens de 600ml, 1 Escova dental e 5 Maçãs.
INSERT INTO pedidos
(cliente_cpf, vendedor_cpf)
VALUES
('80371350042','28007155023');

INSERT INTO itens_do_pedido
(pedido_id,quantidade,produto_id)
VALUES
(1,1,1),--Mamão
(1,1,10),--Pepsi
(1,6,11),--Heineken
(1,1,15),--Escova de dente
(1,5,2);--Maçã

UPDATE pedidos
SET valor = (
SELECT SUM(preco * quantidade) as total FROM itens_do_pedido
LEFT JOIN produtos ON itens_do_pedido.produto_id = produtos.id
WHERE pedido_id = 1
GROUP BY pedido_id)
WHERE id = 1;

UPDATE produtos
SET quantidade_em_estoque = produtos.quantidade_em_estoque - itens_do_pedido.quantidade
FROM itens_do_pedido
WHERE itens_do_pedido.pedido_id = 1 AND produtos.id = itens_do_pedido.produto_id;

--b) Ana Rodrigues comprou os seguintes itens com a vendedora Beatriz Souza Santos
--10 Mangas, 3 Uvas, 5 Mamões, 10 tomates e 2 Acelgas.
INSERT INTO pedidos
(cliente_cpf, vendedor_cpf)
VALUES
('63193310034','23262546003');

INSERT INTO itens_do_pedido
(pedido_id,quantidade,produto_id)
VALUES
(2,10,17),--Manga
(2,3,18),--Uva
(2,5,1),--Mamão
(2,10,5),--Tomate
(2,2,6);--Acelga

UPDATE pedidos
SET valor = (
SELECT SUM(preco * quantidade) as total FROM itens_do_pedido
LEFT JOIN produtos ON itens_do_pedido.produto_id = produtos.id
WHERE pedido_id = 2
GROUP BY pedido_id)
WHERE id = 2;

UPDATE produtos
SET quantidade_em_estoque = produtos.quantidade_em_estoque - itens_do_pedido.quantidade
FROM itens_do_pedido
WHERE itens_do_pedido.pedido_id = 2 AND produtos.id = itens_do_pedido.produto_id;

--c) Maria da Conceição comprou os seguintes itens com a vendedora Beatriz Souza Santos
--1 Vassoura, 6 Águas sem gás e 5 Mangas.
INSERT INTO pedidos
(cliente_cpf, vendedor_cpf)
VALUES
('75670505018','23262546003');

INSERT INTO itens_do_pedido
(pedido_id,quantidade,produto_id)
VALUES
(3,1,13),--Vassoura
(3,6,12),--Água sem gás
(3,5,17);--Manga

UPDATE pedidos
SET valor = (
SELECT SUM(preco * quantidade) as total FROM itens_do_pedido
LEFT JOIN produtos ON itens_do_pedido.produto_id = produtos.id
WHERE pedido_id = 3
GROUP BY pedido_id)
WHERE id = 3;

UPDATE produtos
SET quantidade_em_estoque = produtos.quantidade_em_estoque - itens_do_pedido.quantidade
FROM itens_do_pedido
WHERE itens_do_pedido.pedido_id = 3 AND produtos.id = itens_do_pedido.produto_id;

--d) Maria da Conceição comprou os seguintes itens com o vendedor Rodrigo Sampaio
--1 Balde para lixo, 6 Uvas, 1 Macarrão parafuso, 3 Mamões, 20 tomates e 2 Acelgas.
INSERT INTO pedidos
(cliente_cpf, vendedor_cpf)
VALUES
('75670505018','82539841031');

INSERT INTO itens_do_pedido
(pedido_id,quantidade,produto_id)
VALUES
(4,1,16),--Balde para lixo
(4,6,18),--Uva
(4,1,7),--Macarrão parafuso
(4,3,1),--Mamão
(4,20,5),--Tomate
(4,2,6);--Acelga

UPDATE pedidos
SET valor = (
SELECT SUM(preco * quantidade) as total FROM itens_do_pedido
LEFT JOIN produtos ON itens_do_pedido.produto_id = produtos.id
WHERE pedido_id = 4
GROUP BY pedido_id)
WHERE id = 4;

UPDATE produtos
SET quantidade_em_estoque = produtos.quantidade_em_estoque - itens_do_pedido.quantidade
FROM itens_do_pedido
WHERE itens_do_pedido.pedido_id = 4 AND produtos.id = itens_do_pedido.produto_id;

--e) Antonio Oliveira comprou os seguintes itens com o vendedor Rodrigo Sampaio
--8 Uvas, 1 Massa para lasanha, 3 Mangas, 8 tomates e 2 Heinekens 600ml.
INSERT INTO pedidos
(cliente_cpf, vendedor_cpf)
VALUES
('67642869061','82539841031');

INSERT INTO itens_do_pedido
(pedido_id,quantidade,produto_id)
VALUES
(5,8,18),--Uva
(5,1,8),--Massa para lasanha
(5,3,17),--Manga
(5,8,5),--Tomate
(5,2,11);--Heineken

UPDATE pedidos
SET valor = (
SELECT SUM(preco * quantidade) as total FROM itens_do_pedido
LEFT JOIN produtos ON itens_do_pedido.produto_id = produtos.id
WHERE pedido_id = 5
GROUP BY pedido_id)
WHERE id = 5;

UPDATE produtos
SET quantidade_em_estoque = produtos.quantidade_em_estoque - itens_do_pedido.quantidade
FROM itens_do_pedido
WHERE itens_do_pedido.pedido_id = 4 AND produtos.id = itens_do_pedido.produto_id;

--6 - Consultas
--a) Faça uma listagem de todos os produtos cadastrados com o nome da sua respectiva categoria.
SELECT produtos.nome as produto, categorias.nome as categoria
FROM produtos
LEFT JOIN categorias ON categorias.id = produtos.categoria_id;

--b) Faça uma listagem de todos os pedidos com o nome do vendedor e o nome do cliente relacionado a venda.
SELECT id as pedido, vendedores.nome as vendedor, clientes.nome as cliente
FROM pedidos
LEFT JOIN vendedores ON vendedores.cpf = pedidos.vendedor_cpf
LEFT JOIN clientes ON clientes.cpf = pedidos.cliente_cpf;

--c) Faça uma listagem de todas as categorias e a soma do estoque disponível de todos os produtos de cada categoria.
SELECT categorias.nome as categoria, SUM(produtos.quantidade_em_estoque) as estoque_total
FROM categorias
LEFT JOIN produtos ON produtos.categoria_id = categorias.id
GROUP BY categorias.nome;

--d) Faça uma listagem de todos os produtos e a quantidade vendida de cada produto.
SELECT produtos.nome as produto, SUM(itens_do_pedido.quantidade) as qtd_vendida
FROM produtos
LEFT JOIN itens_do_pedido ON itens_do_pedido.produto_id = produtos.id
GROUP BY produtos.id
ORDER BY SUM(itens_do_pedido.quantidade) DESC;