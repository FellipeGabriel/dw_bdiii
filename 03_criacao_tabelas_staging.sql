 -- SCRIPT DE CRIAÇÃO DAS TABELAS DE STAGING - DATA WAREHOUSE VAREJO

 -- SCHEMA PARA STAGING
 CREATE SCHEMA IF NOT EXISTS staging_varejo;

 -- 1. STAGING PRODUTOS
 CREATE TABLE IF NOT EXISTS staging_varejo.stg_produtos (
    cod_produto         INTEGER NOT NULL,
    descricao_produto   VARCHAR(255),
    cod_categoria       INTEGER,
    descricao_categoria VARCHAR(255),
    tipo_produto        VARCHAR(100),
    data_processamento  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

 -- 2. STAGING FUNCIONÁRIOS
 CREATE TABLE IF NOT EXISTS staging_varejo.stg_funcionarios (
    matricula           INTEGER NOT NULL,
    nome_funcionario    VARCHAR(255),
    cod_cargo           INTEGER,
    nome_cargo          VARCHAR(255),
    salario_base        NUMERIC(10,2),
    comissao_percentual NUMERIC(5,2),
    data_contratacao    DATE,
    data_demissao       DATE,
    status              VARCHAR(20),
    data_processamento  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

 -- 3. STAGING CLIENTES
 CREATE TABLE IF NOT EXISTS staging_varejo.stg_clientes (
    cpf                 BIGINT NOT NULL,
    nome_cliente        VARCHAR(255),
    telefone_residencial VARCHAR(255),
    telefone_celular    VARCHAR(255),
    possui_login        BOOLEAN DEFAULT FALSE,
    data_cadastro_login DATE,
    cliente_antigo      BOOLEAN DEFAULT FALSE,
    data_processamento  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

 -- 4. STAGING LOCALIDADES
 CREATE TABLE IF NOT EXISTS staging_varejo.stg_localidades (
    cod_loja            INTEGER NOT NULL,
    cod_endereco        INTEGER,
    matriz              INTEGER,
    cnpj_loja           VARCHAR(20),
    cidade              VARCHAR(255),
    estado              VARCHAR(2),
    nome_estado         VARCHAR(255),
    bairro              VARCHAR(255),
    tipo_loja           VARCHAR(50),
    eh_matriz           BOOLEAN DEFAULT FALSE,
    data_processamento  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

 -- 5. STAGING VENDAS
 CREATE TABLE IF NOT EXISTS staging_varejo.stg_vendas (
    cod_venda           INTEGER NOT NULL,
    cpf_cliente         BIGINT,
    cod_produto         INTEGER,
    matricula_funcionario INTEGER,
    cod_loja            INTEGER,
    data_venda          DATE,
    quantidade          INTEGER,
    valor_unitario      NUMERIC(10,2),
    valor_total         NUMERIC(10,2),
    valor_desconto      NUMERIC(10,2),
    numero_atendimento  INTEGER,
    data_processamento  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

 -- ÍNDICES PARA STAGING (PERFORMANCE ETL)
 
-- STG_PRODUTOS
CREATE INDEX IF NOT EXISTS idx_stg_produtos_cod ON staging_varejo.stg_produtos(cod_produto);
CREATE INDEX IF NOT EXISTS idx_stg_produtos_categoria ON staging_varejo.stg_produtos(cod_categoria);

-- STG_FUNCIONARIOS
CREATE INDEX IF NOT EXISTS idx_stg_funcionarios_matricula ON staging_varejo.stg_funcionarios(matricula);
CREATE INDEX IF NOT EXISTS idx_stg_funcionarios_cargo ON staging_varejo.stg_funcionarios(cod_cargo);

-- STG_CLIENTES
CREATE INDEX IF NOT EXISTS idx_stg_clientes_cpf ON staging_varejo.stg_clientes(cpf);

-- STG_LOCALIDADES
CREATE INDEX IF NOT EXISTS idx_stg_localidades_cod ON staging_varejo.stg_localidades(cod_loja);

-- STG_VENDAS
CREATE INDEX IF NOT EXISTS idx_stg_vendas_cod ON staging_varejo.stg_vendas(cod_venda);
CREATE INDEX IF NOT EXISTS idx_stg_vendas_data ON staging_varejo.stg_vendas(data_venda);
CREATE INDEX IF NOT EXISTS idx_stg_vendas_cliente ON staging_varejo.stg_vendas(cpf_cliente);
CREATE INDEX IF NOT EXISTS idx_stg_vendas_produto ON staging_varejo.stg_vendas(cod_produto);
CREATE INDEX IF NOT EXISTS idx_stg_vendas_funcionario ON staging_varejo.stg_vendas(matricula_funcionario);