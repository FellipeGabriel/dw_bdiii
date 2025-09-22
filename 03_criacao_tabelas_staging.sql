
-- STAGING

CREATE SCHEMA IF NOT EXISTS staging_varejo;

CREATE TABLE staging_varejo.stg_produtos (
    cod_produto INTEGER,
    descricao_produto VARCHAR(255),
    cod_categoria INTEGER,
    descricao_categoria VARCHAR(255),
    tipo_produto VARCHAR(100)
);

CREATE TABLE staging_varejo.stg_funcionarios (
    matricula INTEGER,
    nome_funcionario VARCHAR(255),
    nome_cargo VARCHAR(255)
);

CREATE TABLE staging_varejo.stg_clientes (
    cpf BIGINT,
    nome_cliente VARCHAR(255)
);

CREATE TABLE staging_varejo.stg_localidades (
    cod_loja INTEGER,
    estado VARCHAR(2),
    tipo_loja VARCHAR(50),
    regiao VARCHAR(50)
);

CREATE TABLE staging_varejo.stg_vendas (
    cod_venda INTEGER,
    cpf_cliente BIGINT,
    cod_produto INTEGER,
    matricula_funcionario INTEGER,
    data_venda DATE,
    quantidade INTEGER,
    valor_unitario NUMERIC(10,2),
    valor_total NUMERIC(10,2),
    numero_atendimento INTEGER
);