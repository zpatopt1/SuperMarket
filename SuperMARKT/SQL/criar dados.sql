
-- =========================
-- DADOS
-- =========================

INSERT INTO categoria (nome, descricao) VALUES
('Laticínios', 'Produtos lácteos'),
('Bebidas', 'Bebidas'),
('Limpeza', 'Produtos limpeza');

INSERT INTO produto (id_categoria, unidade_medida, marca, nome, cod_barras, preco) VALUES
(1,'L','Agros','Leite','5601234567890',0.85),
(1,'kg','Danone','Iogurte','5601234567891',1.20),
(2,'L','Coca-Cola','Coca 1.5L','5601234567892',1.50),
(3,'un','Vileda','Detergente','5601234567893',2.99);

INSERT INTO local (nome, tipo_local) VALUES
('Loja Porto','supermercado'),
('Armazém','armazem');

INSERT INTO zona (id_local, nome) VALUES
(1,'Laticínios'),
(1,'Bebidas'),
(1,'Limpeza');

INSERT INTO stock_local VALUES
(1,1,50),
(2,1,30),
(3,1,100),
(4,1,20);

INSERT INTO funcao (descricao) VALUES
('Caixa'),
('Repositor'),
('Administrador');

INSERT INTO funcionario (nif, id_funcao, nome, contacto, email, password, ativo) VALUES
('123456789',1,'João','912345678','joao.caixa@supermarkt.pt', '1234', TRUE),
('987654321',2,'Maria','913333333','maria.repositor@supermarkt.pt', '1234', TRUE),
('111222333',3,'Admin','919999999','admin@supermarkt.pt', 'admin123', TRUE);

INSERT INTO cliente (nome, contacto, nif) VALUES
('Carlos','910000000','111'),
('Ana','911111111','222');

INSERT INTO movimentos (nif,status,data,hora) VALUES
('123456789','concluido','2026-04-21','10:00:00'),
('123456789','concluido','2026-04-21','11:00:00'),
('987654321','pendente','2026-04-21','12:00:00'),
('123456789','concluido','2026-04-21','14:00:00'),
('987654321','concluido','2026-04-21','15:00:00');

INSERT INTO venda VALUES
(1,1,5.10),
(2,2,3.00);

INSERT INTO fatura (id_venda) VALUES
(1),(2);

INSERT INTO linha_venda (id_venda,id_produto,quantidade,preco_venda,iva,subtotal,desconto) VALUES
(1,1,2,0.85,0.06,1.70,0),
(1,3,2,1.50,0.06,3.00,0),
(2,2,2,1.20,0.06,2.40,0);

INSERT INTO fornecedor (tipo_fornecedor,contacto,nif) VALUES
('Alimentar','219999999','333'),
('Limpeza','218888888','444');

INSERT INTO fornecedor_produto VALUES
(1,1,0.60),
(1,2,0.90),
(1,3,1.10),
(2,4,2.00);

INSERT INTO encomenda VALUES
(3,1,2,50.00,5.00,'2026-04-25',NULL);

INSERT INTO linha_enc (id_encomenda,id_produto,quantidade,data_validade,preco_encomenda) VALUES
(3,1,20,'2026-05-10',0.60),
(3,3,30,'2026-06-01',1.10);

INSERT INTO devolucao VALUES
(4,1,'Dano',1,0.85,TRUE);

INSERT INTO perda_stock VALUES
(5,1,1,2,'Expirado');
