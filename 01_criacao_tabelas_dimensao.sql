 -- SCRIPT DE CRIAÇÃO DAS TABELAS DIMENSÃO - DATA WAREHOUSE VAREJO
 
 -- 1. DIMENSÃO TEMPO
 CREATE TABLE IF NOT EXISTS dim_tempo (
    sk_tempo            SERIAL PRIMARY KEY,
    data_completa       DATE NOT NULL UNIQUE,
    ano                 INTEGER NOT NULL,
    trimestre           INTEGER NOT NULL CHECK (trimestre BETWEEN 1 AND 4),
    mes                 INTEGER NOT NULL CHECK (mes BETWEEN 1 AND 12),
    nome_mes            VARCHAR(20) NOT NULL,
    semana_ano          INTEGER NOT NULL CHECK (semana_ano BETWEEN 1 AND 53),
    dia                 INTEGER NOT NULL CHECK (dia BETWEEN 1 AND 31),
    dia_semana          INTEGER NOT NULL CHECK (dia_semana BETWEEN 1 AND 7),
    nome_dia_semana     VARCHAR(20) NOT NULL,
    eh_fim_semana       BOOLEAN NOT NULL DEFAULT FALSE,
    eh_feriado          BOOLEAN NOT NULL DEFAULT FALSE,
    data_inicio         DATE NOT NULL DEFAULT CURRENT_DATE,
    data_fim            DATE DEFAULT '9999-12-31',
    versao_atual        BOOLEAN NOT NULL DEFAULT TRUE
);

-- Índices para DIM_TEMPO
CREATE INDEX IF NOT EXISTS idx_dim_tempo_data ON dim_tempo(data_completa);
CREATE INDEX IF NOT EXISTS idx_dim_tempo_ano_mes ON dim_tempo(ano, mes);
CREATE INDEX IF NOT EXISTS idx_dim_tempo_versao ON dim_tempo(versao_atual);

 -- 2. DIMENSÃO PRODUTO
 CREATE TABLE IF NOT EXISTS dim_produto (
    sk_produto          SERIAL PRIMARY KEY,
    nk_produto          INTEGER NOT NULL,
    descricao_produto   VARCHAR(255) NOT NULL,
    categoria           VARCHAR(255) NOT NULL,
    tipo_produto        VARCHAR(100) NOT NULL,
    valor_sugerido      NUMERIC(10,2) DEFAULT 0.00,
    data_inicio         DATE NOT NULL DEFAULT CURRENT_DATE,
    data_fim            DATE DEFAULT '9999-12-31',
    versao_atual        BOOLEAN NOT NULL DEFAULT TRUE,
    
    -- Constraint para SCD Type 2
    CONSTRAINT chk_produto_datas CHECK (data_inicio <= data_fim)
);

-- Índices para DIM_PRODUTO
CREATE INDEX IF NOT EXISTS idx_dim_produto_nk ON dim_produto(nk_produto);
CREATE INDEX IF NOT EXISTS idx_dim_produto_categoria ON dim_produto(categoria);
CREATE INDEX IF NOT EXISTS idx_dim_produto_versao ON dim_produto(versao_atual);
CREATE INDEX IF NOT EXISTS idx_dim_produto_vigencia ON dim_produto(data_inicio, data_fim);

 -- 3. DIMENSÃO FUNCIONÁRIO
 CREATE TABLE IF NOT EXISTS dim_funcionario (
    sk_funcionario      SERIAL PRIMARY KEY,
    nk_matricula        INTEGER NOT NULL,
    nome_funcionario    VARCHAR(255) NOT NULL,
    cargo_atual         VARCHAR(255) NOT NULL,
    status              VARCHAR(20) NOT NULL DEFAULT 'Ativo' CHECK (status IN ('Ativo', 'Inativo')),
    data_contratacao    DATE,
    data_demissao       DATE,
    salario_base        NUMERIC(10,2) DEFAULT 0.00,
    comissao_percentual NUMERIC(5,2) DEFAULT 0.00 CHECK (comissao_percentual >= 0 AND comissao_percentual <= 100),
    data_inicio         DATE NOT NULL DEFAULT CURRENT_DATE,
    data_fim            DATE DEFAULT '9999-12-31',
    versao_atual        BOOLEAN NOT NULL DEFAULT TRUE,
    
    -- Constraints para SCD Type 2
    CONSTRAINT chk_funcionario_datas CHECK (data_inicio <= data_fim),
    CONSTRAINT chk_funcionario_contrat_demiss CHECK (data_contratacao IS NULL OR data_demissao IS NULL OR data_contratacao <= data_demissao)
);

-- Índices para DIM_FUNCIONARIO
CREATE INDEX IF NOT EXISTS idx_dim_funcionario_nk ON dim_funcionario(nk_matricula);
CREATE INDEX IF NOT EXISTS idx_dim_funcionario_status ON dim_funcionario(status);
CREATE INDEX IF NOT EXISTS idx_dim_funcionario_versao ON dim_funcionario(versao_atual);
CREATE INDEX IF NOT EXISTS idx_dim_funcionario_vigencia ON dim_funcionario(data_inicio, data_fim);

 -- 4. DIMENSÃO CLIENTE
 CREATE TABLE IF NOT EXISTS dim_cliente (
    sk_cliente          SERIAL PRIMARY KEY,
    nk_cpf              BIGINT NOT NULL,
    nome_cliente        VARCHAR(255) NOT NULL,
    telefone_residencial VARCHAR(20),
    telefone_celular    VARCHAR(20),
    possui_login        BOOLEAN NOT NULL DEFAULT FALSE,
    data_cadastro_login DATE,
    cliente_antigo      BOOLEAN NOT NULL DEFAULT FALSE, -- Cliente cadastrado antes de 2019
    data_inicio         DATE NOT NULL DEFAULT CURRENT_DATE,
    data_fim            DATE DEFAULT '9999-12-31',
    versao_atual        BOOLEAN NOT NULL DEFAULT TRUE,
    
    -- Constraints para SCD Type 2
    CONSTRAINT chk_cliente_datas CHECK (data_inicio <= data_fim),
    CONSTRAINT chk_cliente_login CHECK (
        (possui_login = FALSE AND data_cadastro_login IS NULL) OR
        (possui_login = TRUE AND data_cadastro_login IS NOT NULL)
    )
);

-- Índices para DIM_CLIENTE
CREATE INDEX IF NOT EXISTS idx_dim_cliente_nk ON dim_cliente(nk_cpf);
CREATE INDEX IF NOT EXISTS idx_dim_cliente_login ON dim_cliente(possui_login);
CREATE INDEX IF NOT EXISTS idx_dim_cliente_antigo ON dim_cliente(cliente_antigo);
CREATE INDEX IF NOT EXISTS idx_dim_cliente_versao ON dim_cliente(versao_atual);
CREATE INDEX IF NOT EXISTS idx_dim_cliente_vigencia ON dim_cliente(data_inicio, data_fim);

 -- 5. DIMENSÃO LOCALIDADE
 CREATE TABLE IF NOT EXISTS dim_localidade (
    sk_localidade       SERIAL PRIMARY KEY,
    nk_loja             INTEGER NOT NULL,
    tipo_loja           VARCHAR(50) NOT NULL, -- 'Matriz' ou 'Filial'
    cnpj                VARCHAR(20),
    cidade              VARCHAR(255) NOT NULL,
    estado              VARCHAR(2) NOT NULL,
    nome_estado         VARCHAR(255) NOT NULL,
    bairro              VARCHAR(255),
    regiao              VARCHAR(100), -- Norte, Sul, Centro, etc.
    eh_matriz           BOOLEAN NOT NULL DEFAULT FALSE,
    data_inicio         DATE NOT NULL DEFAULT CURRENT_DATE,
    data_fim            DATE DEFAULT '9999-12-31',
    versao_atual        BOOLEAN NOT NULL DEFAULT TRUE,
    
    -- Constraints para SCD Type 2
    CONSTRAINT chk_localidade_datas CHECK (data_inicio <= data_fim),
    CONSTRAINT chk_localidade_tipo CHECK (tipo_loja IN ('Matriz', 'Filial')),
    CONSTRAINT chk_localidade_matriz CHECK (
        (tipo_loja = 'Matriz' AND eh_matriz = TRUE) OR
        (tipo_loja = 'Filial' AND eh_matriz = FALSE)
    )
);

-- Índices para DIM_LOCALIDADE
CREATE INDEX IF NOT EXISTS idx_dim_localidade_nk ON dim_localidade(nk_loja);
CREATE INDEX IF NOT EXISTS idx_dim_localidade_tipo ON dim_localidade(tipo_loja);
CREATE INDEX IF NOT EXISTS idx_dim_localidade_estado ON dim_localidade(estado);
CREATE INDEX IF NOT EXISTS idx_dim_localidade_matriz ON dim_localidade(eh_matriz);
CREATE INDEX IF NOT EXISTS idx_dim_localidade_versao ON dim_localidade(versao_atual);
CREATE INDEX IF NOT EXISTS idx_dim_localidade_vigencia ON dim_localidade(data_inicio, data_fim);

 
 -- REGISTROS ESPECIAIS (Unknown/Default)
 
-- Registro "Unknown" para DIM_TEMPO (para vendas sem data válida)
INSERT INTO dim_tempo (
    sk_tempo, data_completa, ano, trimestre, mes, nome_mes, 
    semana_ano, dia, dia_semana, nome_dia_semana, eh_fim_semana, eh_feriado
) VALUES (
    -1, '1900-01-01', 1900, 1, 1, 'Desconhecido', 
    1, 1, 1, 'Desconhecido', FALSE, FALSE
) ON CONFLICT (sk_tempo) DO NOTHING;

-- Registro "Unknown" para DIM_PRODUTO
INSERT INTO dim_produto (
    sk_produto, nk_produto, descricao_produto, categoria, tipo_produto
) VALUES (
    -1, -1, 'Produto Desconhecido', 'Categoria Desconhecida', 'Tipo Desconhecido'
) ON CONFLICT (sk_produto) DO NOTHING;

-- Registro "Unknown" para DIM_FUNCIONARIO
INSERT INTO dim_funcionario (
    sk_funcionario, nk_matricula, nome_funcionario, cargo_atual, status
) VALUES (
    -1, -1, 'Funcionário Desconhecido', 'Cargo Desconhecido', 'Inativo'
) ON CONFLICT (sk_funcionario) DO NOTHING;

-- Registro "Unknown" para DIM_CLIENTE
INSERT INTO dim_cliente (
    sk_cliente, nk_cpf, nome_cliente, possui_login, cliente_antigo
) VALUES (
    -1, -1, 'Cliente Desconhecido', FALSE, FALSE
) ON CONFLICT (sk_cliente) DO NOTHING;

-- Registro "Unknown" para DIM_LOCALIDADE
INSERT INTO dim_localidade (
    sk_localidade, nk_loja, tipo_loja, cidade, estado, nome_estado, eh_matriz
) VALUES (
    -1, -1, 'Filial', 'Cidade Desconhecida', 'XX', 'Estado Desconhecido', FALSE
) ON CONFLICT (sk_localidade) DO NOTHING;

 -- RESET SEQUENCES PARA OS VALORES CORRETOS
 SELECT setval('dim_tempo_sk_tempo_seq', 1, false);
SELECT setval('dim_produto_sk_produto_seq', 1, false);
SELECT setval('dim_funcionario_sk_funcionario_seq', 1, false);
SELECT setval('dim_cliente_sk_cliente_seq', 1, false);
SELECT setval('dim_localidade_sk_localidade_seq', 1, false);
