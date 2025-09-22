
-- DIMENSÕES

CREATE TABLE dim_tempo (
    sk_tempo SERIAL PRIMARY KEY,
    data_completa DATE NOT NULL UNIQUE,
    ano INTEGER NOT NULL,
    trimestre INTEGER NOT NULL,
    mes INTEGER NOT NULL,
    nome_mes VARCHAR(20) NOT NULL,
    dia_semana INTEGER NOT NULL CHECK (dia_semana BETWEEN 0 AND 6),
    nome_dia_semana VARCHAR(20) NOT NULL
);

CREATE TABLE dim_produto (
    sk_produto SERIAL PRIMARY KEY,
    nk_produto INTEGER NOT NULL,
    descricao_produto VARCHAR(255) NOT NULL,
    categoria VARCHAR(255) NOT NULL,
    tipo_produto VARCHAR(100) NOT NULL
);

CREATE TABLE dim_funcionario (
    sk_funcionario SERIAL PRIMARY KEY,
    nk_matricula INTEGER NOT NULL,
    nome_funcionario VARCHAR(255) NOT NULL,
    cargo_atual VARCHAR(255) NOT NULL
);

CREATE TABLE dim_cliente (
    sk_cliente SERIAL PRIMARY KEY,
    nk_cpf BIGINT NOT NULL,
    nome_cliente VARCHAR(255) NOT NULL
);

CREATE TABLE dim_localidade (
    sk_localidade SERIAL PRIMARY KEY,
    nk_loja INTEGER NOT NULL,
    tipo_loja VARCHAR(50) NOT NULL,
    regiao VARCHAR(50) NOT NULL
);

-- REGISTROS UNKNOWN

INSERT INTO dim_tempo VALUES (-1, '1900-01-01', 1900, 1, 1, 'Desconhecido', 1, 'Desconhecido');
INSERT INTO dim_produto VALUES (-1, -1, 'Produto Desconhecido', 'Categoria Desconhecida', 'Tipo Desconhecido');
INSERT INTO dim_funcionario VALUES (-1, -1, 'Funcionário Desconhecido', 'Cargo Desconhecido');
INSERT INTO dim_cliente VALUES (-1, -1, 'Cliente Desconhecido');
INSERT INTO dim_localidade VALUES (-1, -1, 'Filial', 'Região Desconhecida');

SELECT setval('dim_tempo_sk_tempo_seq', 1, false);
SELECT setval('dim_produto_sk_produto_seq', 1, false);
SELECT setval('dim_funcionario_sk_funcionario_seq', 1, false);
SELECT setval('dim_cliente_sk_cliente_seq', 1, false);
SELECT setval('dim_localidade_sk_localidade_seq', 1, false);