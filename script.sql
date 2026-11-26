-- ==========================================
-- 0. REMOÇÃO DE TABELAS EXISTENTES (CASO NECESSÁRIO)
-- ==========================================
DROP TABLE IF EXISTS pagamento CASCADE;
DROP TABLE IF EXISTS compra_produto CASCADE;
DROP TABLE IF EXISTS compra CASCADE;
DROP TABLE IF EXISTS carrinho CASCADE;
DROP TABLE IF EXISTS estoque CASCADE;
DROP TABLE IF EXISTS produto CASCADE;
DROP TABLE IF EXISTS endereco CASCADE;
DROP TABLE IF EXISTS fornecedor CASCADE;
DROP TABLE IF EXISTS categoria CASCADE;
DROP TABLE IF EXISTS cliente CASCADE;

-- ==========================================
-- 1. TABELA: cliente
-- ==========================================
CREATE TABLE cliente (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    cpf VARCHAR(14) NOT NULL,
    telefone VARCHAR(15),

    CONSTRAINT uq_cliente_email UNIQUE (email),
    CONSTRAINT uq_cliente_cpf UNIQUE (cpf)
);

-- ==========================================
-- 2. TABELA: categoria
-- ==========================================
CREATE TABLE categoria (
    id_categoria SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT
);

-- ==========================================
-- 3. TABELA: fornecedor
-- ==========================================
CREATE TABLE fornecedor (
    id_fornecedor SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    cnpj VARCHAR(18) NOT NULL,
    contato VARCHAR(255),

    CONSTRAINT uq_fornecedor_cnpj UNIQUE (cnpj)
);

-- ==========================================
-- 4. TABELA: endereco
-- ==========================================
CREATE TABLE endereco (
    id_endereco SERIAL PRIMARY KEY,
    logradouro VARCHAR(255) NOT NULL,
    numero VARCHAR(20) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    estado VARCHAR(2) NOT NULL,
    cep VARCHAR(9) NOT NULL,
    fk_cliente INT NOT NULL,

    CONSTRAINT fk_endereco_cliente FOREIGN KEY (fk_cliente) REFERENCES cliente(id_cliente) ON DELETE CASCADE
);

-- ==========================================
-- 5. TABELA: produto
-- ==========================================
CREATE TABLE produto (
    id_produto SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    marca VARCHAR(255) NOT NULL,
    especificacoes_tecnicas TEXT,
    preco DECIMAL(10,2) NOT NULL,
    nota_avaliacao DECIMAL(3,2),
    fk_categoria INT NOT NULL,
    fk_fornecedor INT NOT NULL,

    CONSTRAINT fk_produto_categoria FOREIGN KEY (fk_categoria) REFERENCES categoria(id_categoria) ON DELETE CASCADE,
    CONSTRAINT fk_produto_fornecedor FOREIGN KEY (fk_fornecedor) REFERENCES fornecedor(id_fornecedor) ON DELETE CASCADE
);

-- ==========================================
-- 6. TABELA: estoque
-- ==========================================
CREATE TABLE estoque (
    id_estoque SERIAL PRIMARY KEY,
    quantidade INT,
    localizacao_armazenar VARCHAR(100),
    fk_produto INT NOT NULL,

    CONSTRAINT fk_estoque_produto FOREIGN KEY (fk_produto) REFERENCES produto(id_produto) ON DELETE CASCADE
);

-- ==========================================
-- 7. TABELA: carrinho
-- ==========================================
CREATE TABLE carrinho (
    id_carrinho SERIAL PRIMARY KEY,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    fk_cliente INT NOT NULL,
    fk_produto INT NOT NULL,

    CONSTRAINT fk_carrinho_cliente FOREIGN KEY (fk_cliente) REFERENCES cliente(id_cliente) ON DELETE CASCADE,
    CONSTRAINT fk_carrinho_produto FOREIGN KEY (fk_produto) REFERENCES produto(id_produto) ON DELETE CASCADE
);

-- ==========================================
-- 8. TABELA: compra
-- ==========================================
CREATE TABLE compra (
    id_compra SERIAL PRIMARY KEY,
    data_compra TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    valor_total DECIMAL(10,2) NOT NULL,
    status VARCHAR(50),
    fk_cliente INT NOT NULL,
    fk_endereco INT NOT NULL,

    CONSTRAINT fk_compra_cliente FOREIGN KEY (fk_cliente) REFERENCES cliente(id_cliente) ON DELETE CASCADE,
    CONSTRAINT fk_compra_endereco FOREIGN KEY (fk_endereco) REFERENCES endereco(id_endereco) ON DELETE CASCADE
);

-- ==========================================
-- 9. TABELA: compra_produto
-- ==========================================
CREATE TABLE compra_produto (
    id_compra_produto SERIAL PRIMARY KEY,
    quantidade INT NOT NULL,
    valor_unitario DECIMAL(10,2) NOT NULL,
    fk_compra INT NOT NULL,
    fk_produto INT NOT NULL,

    CONSTRAINT fk_compra_produto_compra FOREIGN KEY (fk_compra) REFERENCES compra(id_compra) ON DELETE CASCADE,
    CONSTRAINT fk_compra_produto_produto FOREIGN KEY (fk_produto) REFERENCES produto(id_produto) ON DELETE CASCADE
);

-- ==========================================
-- 10. TABELA: pagamento
-- ==========================================
CREATE TABLE pagamento (
    id_pagamento SERIAL PRIMARY KEY,
    forma_pagamento VARCHAR(50) NOT NULL,
    taxa_entrega DECIMAL(10,2),
    valor_pago DECIMAL(10,2) NOT NULL,
    status_pagamento VARCHAR(50),
    fk_compra INT NOT NULL,

    CONSTRAINT fk_pagamento_compra FOREIGN KEY (fk_compra) REFERENCES compra(id_compra) ON DELETE CASCADE
);


-- ==========================================
-- SCRIPT DE INSERÇÃO DIDÁTICA (DADOS REALISTAS)
-- ==========================================

-- 1. CLIENTE
INSERT INTO cliente (nome, email, cpf, telefone) VALUES
('Ana Paula Souza', 'ana.souza@email.com', '111.222.333-01', '(41) 99111-1001'),
('Carlos Eduardo Silva', 'carlos.silva@email.com', '222.333.444-02', '(41) 99222-2002'),
('Beatriz Lima Ferreira', 'beatriz.lima@email.com', '333.444.555-03', '(11) 99333-3003'),
('Daniel Oliveira Costa', 'daniel.costa@email.com', '444.555.666-04', '(21) 99444-4004'),
('Elena Rocha Martins', 'elena.rocha@email.com', '555.666.777-05', '(31) 99555-5005'),
('Felipe Santos Almeida', 'felipe.santos@email.com', '666.777.888-06', '(51) 99666-6006'),
('Gabriela Mendes Pereira', 'gabriela.mendes@email.com', '777.888.999-07', '(48) 99777-7007'),
('Hugo Alves Nogueira', 'hugo.alves@email.com', '888.999.000-08', '(71) 99888-8008'),
('Isabela Ribeiro Gomes', 'isabela.ribeiro@email.com', '999.000.111-09', '(61) 99999-9009'),
('João Pedro Castro', 'joao.castro@email.com', '000.111.222-10', '(81) 99000-0010');

-- 2. CATEGORIA
INSERT INTO categoria (nome, descricao) VALUES
('Processadores', 'Unidades centrais de processamento (CPU) para desktops e workstations.'),
('Placas de Vídeo', 'Unidades de processamento gráfico (GPU) dedicadas para jogos e renderização.'),
('Memória RAM', 'Módulos de memória volátil DDR4 e DDR5 de alta frequência.'),
('Armazenamento SSD', 'Unidades de estado sólido NVMe M.2 e SATA de alta velocidade.'),
('Placas-Mãe', 'Placas de circuito principal compatíveis com plataformas Intel e AMD.'),
('Fontes de Alimentação', 'Fontes ATX e SFX com certificação 80 Plus para sistemas de alto desempenho.'),
('Gabinetes', 'Estruturas mid-tower e full-tower com fluxo de ar otimizado.'),
('Refrigeração', 'Air coolers, water coolers AIO e ventoinhas PWM de alta pressão estática.'),
('Periféricos', 'Teclados mecânicos, mouses gamer, headsets e webcams.'),
('Monitores', 'Telas IPS, VA e OLED com altas taxas de atualização.');

-- 3. FORNECEDOR
INSERT INTO fornecedor (nome, cnpj, contato) VALUES
('TechDistribuidora Brasil Ltda', '12.345.678/0001-01', 'comercial@techdistribuidora.com.br'),
('MegaHardware Importadora S.A.', '23.456.789/0001-02', 'vendas@megahardware.com.br'),
('Silicon Components Atacado', '34.567.890/0001-03', 'contato@siliconcomponents.com.br'),
('NextGen Suprimentos TI', '45.678.901/0001-04', 'pedidos@nextgenti.com.br'),
('Alpha Informática Distribuição', '56.789.012/0001-05', 'atendimento@alphainfo.com.br'),
('GlobalParts Eletrônicos', '67.890.123/0001-06', 'suporte@globalparts.com.br'),
('PrimeTech Logística e Comércio', '78.901.234/0001-07', 'comercial@primetech.com.br'),
('InfoSul Atacadista de Hardware', '89.012.345/0001-08', 'vendas@infosul.com.br'),
('CyberStore Suprimentos Digitais', '90.123.456/0001-09', 'contato@cyberstore.com.br'),
('Vector Hardware Nacional', '01.234.567/0001-10', 'parcerias@vectorhardware.com.br');

-- 4. ENDERECO
INSERT INTO endereco (logradouro, numero, cidade, estado, cep, fk_cliente) VALUES
('Rua XV de Novembro', '1200', 'Curitiba', 'PR', '80010-000', 1),
('Avenida República Argentina', '2450', 'Curitiba', 'PR', '80620-010', 2),
('Avenida Paulista', '1578', 'São Paulo', 'SP', '01310-100', 3),
('Avenida Atlântica', '3100', 'Rio de Janeiro', 'RJ', '22070-001', 4),
('Avenida Afonso Pena', '950', 'Belo Horizonte', 'MG', '30130-001', 5),
('Rua dos Andradas', '1420', 'Porto Alegre', 'RS', '90020-008', 6),
('Avenida Beira Mar Norte', '2800', 'Florianópolis', 'SC', '88015-200', 7),
('Avenida Sete de Setembro', '510', 'Salvador', 'BA', '40060-001', 8),
('Setor Comercial Sul Quadra 4', '120', 'Brasília', 'DF', '70304-000', 9),
('Avenida Boa Viagem', '4500', 'Recife', 'PE', '51021-000', 10);

-- 5. PRODUTO
INSERT INTO produto (nome, marca, especificacoes_tecnicas, preco, nota_avaliacao, fk_categoria, fk_fornecedor) VALUES
('Processador Ryzen 7 7800X3D', 'AMD', '8 Núcleos, 16 Threads, Clock Boost 5.0GHz, Cache 104MB, Socket AM5', 2699.90, 4.95, 1, 1),
('Placa de Vídeo RTX 4070 Super 12GB', 'NVIDIA / Asus', '12GB GDDR6X, 192-bit, Ray Tracing, DLSS 3.5, Dual Fan', 4199.90, 4.90, 2, 2),
('Memória RAM Fury Beast 32GB (2x16GB)', 'Kingston', 'DDR5 6000MHz, CL36, Dissipador em Alumínio Preto', 899.90, 4.85, 3, 3),
('SSD NVMe 990 Pro 1TB', 'Samsung', 'M.2 2280 PCIe 4.0 x4, Leitura 7450MB/s, Gravação 6900MB/s', 749.90, 4.92, 4, 4),
('Placa-Mãe B650M Gaming Plus WiFi', 'MSI', 'Micro-ATX, Socket AM5, DDR5 até 7200MHz, Wi-Fi 6E e Bluetooth 5.3', 1199.90, 4.80, 5, 1),
('Fonte RM850e 850W Full Modular', 'Corsair', 'Certificação 80 Plus Gold, ATX 3.0, PCIe 5.0, Cabos Modulares', 849.90, 4.88, 6, 5),
('Gabinete Mid Tower 4000D Airflow', 'Corsair', 'Painel Frontal Mesh, Vidro Temperado, Suporte Radiador 360mm', 579.90, 4.87, 7, 5),
('Water Cooler MasterLiquid 360L Core', 'Cooler Master', 'Radiador 360mm, 3 Ventoinhas ARGB 120mm, Bomba Câmara Dupla', 649.90, 4.75, 8, 6),
('Teclado Mecânico G Pro X TKL', 'Logitech', 'Switch Tactile GX Brown, Sem Fio Lightspeed, Layout ABNT2', 999.90, 4.82, 9, 7),
('Monitor Gamer UltraGear 27 QHD', 'LG', '27 Polegadas, Painel IPS 2560x1440, 180Hz, 1ms GtG, FreeSync/G-Sync', 1899.90, 4.91, 10, 8);

-- 6. ESTOQUE
INSERT INTO estoque (quantidade, localizacao_armazenar, fk_produto) VALUES
(25, 'Corredor A - Prateleira 01', 1),
(14, 'Corredor A - Prateleira 02', 2),
(40, 'Corredor B - Prateleira 01', 3),
(55, 'Corredor B - Prateleira 03', 4),
(18, 'Corredor A - Prateleira 04', 5),
(22, 'Corredor C - Prateleira 01', 6),
(12, 'Setor Volumosos - Box 05', 7),
(19, 'Corredor C - Prateleira 02', 8),
(30, 'Corredor D - Prateleira 01', 9),
(10, 'Setor Volumosos - Box 02', 10);

-- 7. CARRINHO
INSERT INTO carrinho (quantidade, preco_unitario, fk_cliente, fk_produto) VALUES
(1, 2699.90, 1, 1),
(1, 1199.90, 1, 5),
(1, 4199.90, 2, 2),
(2, 899.90, 3, 3),
(1, 749.90, 4, 4),
(1, 849.90, 5, 6),
(1, 579.90, 6, 7),
(1, 649.90, 7, 8),
(1, 999.90, 8, 9),
(1, 1899.90, 9, 10);

-- 8. COMPRA
INSERT INTO compra (valor_total, status, fk_cliente, fk_endereco) VALUES
(3899.80, 'ENTREGUE', 1, 1),
(4229.90, 'ENVIADO', 2, 2),
(1824.80, 'PAGO', 3, 3),
(769.90, 'ENTREGUE', 4, 4),
(874.90, 'PENDENTE', 5, 5),
(614.90, 'ENTREGUE', 6, 6),
(674.90, 'PAGO', 7, 7),
(1019.90, 'CANCELADO', 8, 8),
(1939.90, 'ENTREGUE', 9, 9),
(3449.80, 'ENVIADO', 10, 10);

-- 9. COMPRA_PRODUTO
INSERT INTO compra_produto (quantidade, valor_unitario, fk_compra, fk_produto) VALUES
(1, 2699.90, 1, 1),
(1, 1199.90, 1, 5),
(1, 4199.90, 2, 2),
(2, 899.90, 3, 3),
(1, 749.90, 4, 4),
(1, 849.90, 5, 6),
(1, 579.90, 6, 7),
(1, 649.90, 7, 8),
(1, 999.90, 8, 9),
(1, 1899.90, 9, 10);

-- 10. PAGAMENTO
INSERT INTO pagamento (forma_pagamento, taxa_entrega, valor_pago, status_pagamento, fk_compra) VALUES
('PIX', 0.00, 3899.80, 'APROVADO', 1),
('Cartão de Crédito', 30.00, 4229.90, 'APROVADO', 2),
('Cartão de Crédito', 25.00, 1824.80, 'APROVADO', 3),
('PIX', 20.00, 769.90, 'APROVADO', 4),
('Boleto Bancário', 25.00, 874.90, 'AGUARDANDO', 5),
('Cartão de Débito', 35.00, 614.90, 'APROVADO', 6),
('PIX', 25.00, 674.90, 'APROVADO', 7),
('Cartão de Crédito', 20.00, 1019.90, 'ESTORNADO', 8),
('Cartão de Crédito', 40.00, 1939.90, 'APROVADO', 9),
('PIX', 0.00, 3449.80, 'APROVADO', 10);


-- ==========================================
-- 11. CONSULTAS DE VALIDAÇÃO (TESTE RÁPIDO)
-- ==========================================

-- 1. Testar tabela cliente
SELECT * FROM cliente;

-- 2. Testar tabela categoria
SELECT * FROM categoria;

-- 3. Testar tabela fornecedor
SELECT * FROM fornecedor;

-- 4. Testar tabela endereco
SELECT * FROM endereco;

-- 5. Testar tabela produto
SELECT * FROM produto;

-- 6. Testar tabela estoque
SELECT * FROM estoque;

-- 7. Testar tabela carrinho
SELECT * FROM carrinho;

-- 8. Testar tabela compra
SELECT * FROM compra;

-- 9. Testar tabela compra_produto
SELECT * FROM compra_produto;

-- 10. Testar tabela pagamento
SELECT * FROM pagamento;


SELECT 
       VU.unitario AS  valor_unitario;

FROM

     compra_produto cp


