-- =========================================================
-- fornecedor_produto
-- Guarda quais produtos cada fornecedor vende
-- e o preço negociado com esse fornecedor.
-- =========================================================

CREATE TABLE fornecedor_produto (
    id_fornecedor INT,
    id_produto INT,

    preco FLOAT,

    PRIMARY KEY (id_fornecedor, id_produto),

    FOREIGN KEY (id_fornecedor)
        REFERENCES fornecedor(id_fornecedor),

    FOREIGN KEY (id_produto)
        REFERENCES produto(id_produto)
);

-- =========================================================
-- encomenda
-- Cabeçalho da encomenda feita ao fornecedor.
-- Guarda informações gerais da compra.
-- =========================================================

CREATE TABLE encomenda (
    id_encomenda INT,

    id_fornecedor INT NOT NULL,
    id_local INT NOT NULL,

    valor_total FLOAT
    custo_envio FLOAT,

    data_prevista DATE,
    data_chegada DATE,

    PRIMARY KEY (id_encomenda),

    FOREIGN KEY (id_encomenda)
        REFERENCES movimentos(id_movimentos),

    FOREIGN KEY (id_fornecedor)
        REFERENCES fornecedor(id_fornecedor),

    FOREIGN KEY (id_local)
        REFERENCES local(id_local)
);

-- =========================================================
-- linha_enc
-- Produtos pertencentes à encomenda.
-- Representa o que foi comprado/recebido.
-- Aqui pode-se guardar:
-- - quantidade recebida
-- - preço da compra
-- - lote do fornecedor
-- - validade original
-- =========================================================

CREATE TABLE linha_enc (
    id_linhaenc INT AUTO_INCREMENT,

    id_encomenda INT NOT NULL,
    id_produto INT NOT NULL,

    quantidade INT NOT NULL CHECK (quantidade > 0),

    preco_encomenda FLOAT,

    numero_lote VARCHAR(50),

    data_validade DATE,

    PRIMARY KEY (id_linhaenc),

    FOREIGN KEY (id_encomenda)
        REFERENCES encomenda(id_encomenda),

    FOREIGN KEY (id_produto)
        REFERENCES produto(id_produto),

);

-- =========================================================
-- stock_lote
-- Guarda o stock REAL atual por lote.
-- Esta tabela muda constantemente:
-- - vendas diminuem quantidade
-- - perdas diminuem quantidade
-- - transferências alteram quantidade
--
-- Utilizada para:
-- - controlo de validade
-- - FEFO (vender primeiro o que expira antes)
-- - rastreamento de lotes
-- - alertas de produtos expirados
-- =========================================================

CREATE TABLE stock_lote (
    id_lote INT AUTO_INCREMENT,

    id_produto INT NOT NULL,
    id_local INT NOT NULL,

    -- ligação ao registo original da encomenda
    id_linhaenc INT,

    numero_lote VARCHAR(50),

    quantidade INT NOT NULL CHECK (quantidade >= 0),

    data_validade DATE,

    data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP,

    ativo BOOLEAN DEFAULT TRUE,

    PRIMARY KEY (id_lote),

    FOREIGN KEY (id_produto)
        REFERENCES produto(id_produto),

    FOREIGN KEY (id_local)
        REFERENCES local(id_local),

    FOREIGN KEY (id_linhaenc)
        REFERENCES linha_enc(id_linhaenc),
);

-- =========================================================
-- IMPORTANTE
--
-- stock_local:
-- Guarda apenas o stock total do produto no local sem QUANTIDADE.
--
-- stock_lote:
-- Guarda o detalhe do stock por lote/validade.
--
-- Quando entra stock:
-- atualizar stock_local + criar stock_lote
--
-- Quando vende:
-- diminuir stock_local + diminuir stock_lote
--
-- O lote vendido deve ser o de validade mais próxima
-- (FEFO = First Expire First Out)
-- =========================================================

-- =========================================================
-- IMPORTAÇÃO CSV
--
-- O sistema deve possuir importações separadas:
--
-- 1. Importação de Produtos
--    -> adiciona produtos na tabela produto sem DATA E QUANTIDADE
--nome,codigo_barras,categoria,preco_venda
--leite,5601234567890,Laticinios,1.99
-- Arroz,5609999999999,Mercearia,2.50

-- 2. Importação fornecedor_produto
--    -> define quais fornecedores vendem quais produtos
--    -> define o preço negociado por fornecedor
--fornecedor,codigo_produto,preco
--Fornecedor A,5601234567890,1.20
--Fornecedor A,5609999999999,1.80

-- 3. Importação de lotes / entrada de stock
--    -> cria registos em stock_lote
--    -> atualiza stock_local
--    -> define validade e número de lote
--produto,local,quantidade,lote,data_validade
--5601234567890,Loja 1,100,LT2026A,2026-01-10
--5601234567890,Loja 1,50,LT2026B,2026-02-20
--
-- IMPORTANTE:
-- Produtos devem existir antes da importação de lotes.
--
-- Os lotes representam stock físico real.
--
-- Cada lote pode possuir:
-- - validade diferente
-- - quantidade diferente
-- - fornecedor diferente
--
-- O stock total é obtido em stock_local.
-- O detalhe por validade é obtido em stock_lote.
-- =========================================================