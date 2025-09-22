
-- DIMENSÕES 

-- dim_tempo mantém SK e apenas data_completa
CREATE TABLE dim_tempo (
    sk_tempo SERIAL PRIMARY KEY,
    data_completa DATE NOT NULL UNIQUE
);

-- Demais dimensões usam NK como chave primária
CREATE TABLE dim_produto (
    nk_produto INTEGER PRIMARY KEY,
    descricao_produto VARCHAR(255),
    categoria VARCHAR(255),
    tipo_produto VARCHAR(100)
);

CREATE TABLE dim_funcionario (
    nk_matricula INTEGER PRIMARY KEY,
    nome_funcionario VARCHAR(255)
);

CREATE TABLE dim_cliente (
    nk_cpf BIGINT PRIMARY KEY,
    nome_cliente VARCHAR(255)
);

CREATE TABLE dim_localidade (
    nk_loja INTEGER PRIMARY KEY,
    regiao VARCHAR(50)
);

