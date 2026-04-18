        CREATE DATABASE IF NOT EXISTS supermercado;
        USE supermercado;

        DROP TABLE IF EXISTS perda_stock;
        DROP TABLE IF EXISTS fornecedor_produto;
        DROP TABLE IF EXISTS linha_enc;
        DROP TABLE IF EXISTS encomenda;
        DROP TABLE IF EXISTS devolucao;
        DROP TABLE IF EXISTS linha_venda;
        DROP TABLE IF EXISTS fatura;
        DROP TABLE IF EXISTS venda;
        DROP TABLE IF EXISTS movimentos;
        DROP TABLE IF EXISTS cliente;
        DROP TABLE IF EXISTS fornecedor;
        DROP TABLE IF EXISTS produto_localizacao_zona;
        DROP TABLE IF EXISTS zona;
        DROP TABLE IF EXISTS stock_local;
        DROP TABLE IF EXISTS local;
        DROP TABLE IF EXISTS funcionario;
        DROP TABLE IF EXISTS produto;
        DROP TABLE IF EXISTS funcao;
        DROP TABLE IF EXISTS categoria;

        CREATE TABLE categoria (
            id_categoria INT AUTO_INCREMENT,
            nome VARCHAR(50),
            descricao VARCHAR(50),
            PRIMARY KEY (id_categoria)
        );

        CREATE TABLE produto (
            id_produto INT AUTO_INCREMENT,
            id_categoria INT,
            unidade_medida VARCHAR(50),
            marca VARCHAR(50),
            nome VARCHAR(50),
            cod_barras VARCHAR(50),
            preco FLOAT,
            PRIMARY KEY (id_produto),
            FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
        );

        CREATE TABLE local (
            id_local INT AUTO_INCREMENT,
            nome VARCHAR(50),
            tipo_local VARCHAR(50),
            PRIMARY KEY (id_local)
        );

        CREATE TABLE zona (
            id_zona INT AUTO_INCREMENT,
            id_local INT,
            nome VARCHAR(50),
            PRIMARY KEY (id_zona),
            FOREIGN KEY (id_local) REFERENCES local(id_local)
        );

        CREATE TABLE stock_local (
            id_produto INT,
            id_local INT,
            quantidade INT,
            PRIMARY KEY (id_produto, id_local),
            FOREIGN KEY (id_produto) REFERENCES produto(id_produto),
            FOREIGN KEY (id_local) REFERENCES local(id_local)
        );
 
        CREATE TABLE produto_localizacao_zona (
            id_produto INT,
            id_local INT,
            id_zona INT,
            PRIMARY KEY (id_produto, id_local, id_zona),
            FOREIGN KEY (id_produto) REFERENCES produto(id_produto),
            FOREIGN KEY (id_local) REFERENCES local(id_local),
            FOREIGN KEY (id_zona) REFERENCES zona(id_zona)
        );

        CREATE TABLE funcao (
            id_funcao INT AUTO_INCREMENT,
            descricao VARCHAR(50),
            PRIMARY KEY (id_funcao)
        );

        CREATE TABLE funcionario (
            nif VARCHAR(50),
            id_funcao INT,
            nome VARCHAR(50),
            contacto VARCHAR(50),
            PRIMARY KEY (nif),
            FOREIGN KEY (id_funcao) REFERENCES funcao(id_funcao)
        );

        CREATE TABLE cliente (
            id_cliente INT AUTO_INCREMENT,
            nome VARCHAR(50),
            contacto VARCHAR(50),
            nif VARCHAR(50),
            PRIMARY KEY (id_cliente)
        );

        CREATE TABLE movimentos (
            id_movimentos INT AUTO_INCREMENT,
            nif VARCHAR(50),
            status VARCHAR(50),
            data DATE,
            hora TIME,
            PRIMARY KEY (id_movimentos),
            FOREIGN KEY (nif) REFERENCES funcionario(nif)
        );

        CREATE TABLE venda (
            id_venda INT,
            id_cliente INT,
            valor_total FLOAT,
            PRIMARY KEY (id_venda),
            FOREIGN KEY (id_venda) REFERENCES movimentos(id_movimentos),
            FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
        );

        CREATE TABLE fatura (
            nr_fatura INT AUTO_INCREMENT,
            id_venda INT,
            PRIMARY KEY (nr_fatura),
            FOREIGN KEY (id_venda) REFERENCES venda(id_venda)
        );

        CREATE TABLE linha_venda (
            id_linhavenda INT AUTO_INCREMENT,
            id_venda INT,
            id_produto INT,
            quantidade INT,
            preco_venda FLOAT,
            iva FLOAT,
            subtotal FLOAT,
            desconto FLOAT,
            PRIMARY KEY (id_linhavenda),
            FOREIGN KEY (id_venda) REFERENCES venda(id_venda),
            FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
        );
        -- ADicionado repor_stock mudar no model dps
        CREATE TABLE devolucao (
            id_devolucao INT,
            id_linhavenda INT,
            motivo VARCHAR(50),
            quantidade INT,
            valor FLOAT,
            repor_stock BOOLEAN DEFAULT FALSE, 
            PRIMARY KEY (id_devolucao),
            FOREIGN KEY (id_devolucao) REFERENCES movimentos(id_movimentos),
            FOREIGN KEY (id_linhavenda) REFERENCES linha_venda(id_linhavenda)
        );

        CREATE TABLE fornecedor (
            id_fornecedor INT AUTO_INCREMENT,
            tipo_fornecedor VARCHAR(50),
            contacto VARCHAR(50),
            nif VARCHAR(50),
            PRIMARY KEY (id_fornecedor)
        );
        -- adicionado custo_envio valor_total data_prevista e data_chegada fazer model dps
        -- rever custo_envio se é o valor total ou somente o custo de envio msm
        CREATE TABLE encomenda (
            id_encomenda INT,
            id_fornecedor INT,
            id_local INT,
            valor_total FLOAT, 
            custo_envio FLOAT,
            data_prevista DATE,
            data_chegada DATE,
            PRIMARY KEY (id_encomenda),
            FOREIGN KEY (id_encomenda) REFERENCES movimentos(id_movimentos),
            FOREIGN KEY (id_fornecedor) REFERENCES fornecedor(id_fornecedor),
            FOREIGN KEY (id_local) REFERENCES local(id_local)
        );
        -- adicionado data_validade + vai ter mudanças  por causa do fornecedor_produto rever model
        CREATE TABLE linha_enc (
            id_linhaenc INT AUTO_INCREMENT,
            id_encomenda INT,
            id_produto INT,
            quantidade INT,
            data_validade DATE,
            preco_encomenda FLOAT,
            PRIMARY KEY (id_linhaenc),
            FOREIGN KEY (id_encomenda) REFERENCES encomenda(id_encomenda),
            FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
        );

        -- adicionar no model
        -- ADICIONADO PARA SABER o preco do produto pelo fornecedor
        -- PAGINA DO fornecedor pode escolher o produto e setar o preço dele
        -- pode pesquisar pelo categoria dele tbm
        CREATE TABLE fornecedor_produto (
            id_fornecedor INT,
            id_produto INT,
            preco FLOAT,
            PRIMARY KEY (id_fornecedor, id_produto),
            FOREIGN KEY (id_fornecedor) REFERENCES fornecedor(id_fornecedor),
            FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
        );

        CREATE TABLE perda_stock (
            id_perda INT AUTO_INCREMENT,
            id_produto INT,
            id_local INT,
            quantidade INT,
            motivo VARCHAR(100),
            data_registo DATE,
            PRIMARY KEY (id_perda),
            FOREIGN KEY (id_produto) REFERENCES produto(id_produto),
            FOREIGN KEY (id_local) REFERENCES local(id_local)
        );

        -- CERTO E FEITO
        -- AGORA FALTA A LOGICA DE CUSTO  DE ENVIO
        -- SIMPLES colocar custo_envio onde quando o fornecedor receber o pedido coloca o 
        -- valor e dps eu aceito ou nao.
        -- ele tbm coloca a data_prevista
        -- CREATE TABLE encomenda (
        --     id_encomenda INT,
        --     id_fornecedor INT,
        --     id_local INT,
        --     valor_total INT,
        --     --custo_envio INT,
        --     --data_prevista DATE,
        --     --data_chegada DATE, 
        --     PRIMARY KEY (id_encomenda),
        --     FOREIGN KEY (id_encomenda) REFERENCES movimentos(id_movimentos),
        --     FOREIGN KEY (id_fornecedor) REFERENCES fornecedor(id_fornecedor),
        --     FOREIGN KEY (id_local) REFERENCES local(id_local)
        -- )



        -- Faz sentido rever SEGUIR ESTA LOGICA ?
        -- STOCK LOCAL PAGE:
        -- O sistema tem duas vistas principais. Na página inicial é mostrado o stock total de cada produto e a data de validade mais próxima, permitindo uma visão geral rápida do estado do inventário.
        -- Ao clicar num produto, abre-se uma página de detalhe onde são listadas as encomendas desse produto,
        -- cada uma com a sua quantidade e respetiva data de validade fornecedor . Isto permite ver a origem do stock e controlar melhor os prazos de expiração.
        -- Terá um alerta sempre que algum produto esta perto data de validade para serem removidos.
        -- Depois caso tenha algum produto fora da validade terei que manualmente registar as perdas 
        -- expira → alerta → funcionário confirma → registo de perda → baixa stock_local
        -- -- ADICIONAR AO MODEL
        -- CREATE TABLE perda_stock (
        --     id_perda INT AUTO_INCREMENT,
        --     id_produto INT,
        --     id_local INT,
        --     quantidade INT,
        --     motivo VARCHAR(100),
        --     data_registo DATE,
        --     PRIMARY KEY (id_perda),
        --     FOREIGN KEY (id_produto) REFERENCES produto(id_produto),
        --     FOREIGN KEY (id_local) REFERENCES local(id_local)
        -- );
        
        -- Faz sentido rever SEGUIR ESTA LOGICA
        -- STOCK LOCAL PAGE:
        -- O sistema tem duas vistas principais. Na página inicial é mostrado o stock total de cada produto e a data de validade mais próxima, permitindo uma visão geral rápida do estado do inventário.
        -- Ao clicar num produto, abre-se uma página de detalhe onde são listadas as encomendas desse produto,
        -- cada uma com a sua quantidade e respetiva data de validade fornecedor . Isto permite ver a origem do stock e controlar melhor os prazos de expiração.
        -- Terá um alerta sempre que algum produto esta perto data de validade para serem removidos.
        -- Depois caso tenha algum produto fora da validade terei que manualmente registar as perdas 
        -- expira → alerta → funcionário confirma → registo de perda → baixa stock_local
        -- ADICIONAR AO MODEL
        -- CREATE TABLE perda_stock (
        --     id_perda INT AUTO_INCREMENT,
        --     id_produto INT,
        --     id_local INT,
        --     quantidade INT,
        --     motivo VARCHAR(100),
        --     data_registo DATE,
        --     PRIMARY KEY (id_perda),
        --     FOREIGN KEY (id_produto) REFERENCES produto(id_produto),
        --     FOREIGN KEY (id_local) REFERENCES local(id_local)
        -- );
    
