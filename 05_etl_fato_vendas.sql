
-- ETL FATO VENDAS (agregada na carga)

-- STAGING VENDAS (deriva loja a partir do funcionário)
TRUNCATE TABLE staging_varejo.stg_vendas;
INSERT INTO staging_varejo.stg_vendas (
    cod_venda,
    cpf_cliente,
    cod_produto,
    matricula_funcionario,
    cod_loja,
    data_venda,
    quantidade,
    valor_unitario,
    valor_total
)
SELECT 
    v.tb010_012_cod_venda,
    v.tb010_cpf,
    v.tb012_cod_produto,
    v.tb005_matricula,
    f.tb004_cod_loja AS cod_loja,
    v.tb010_012_data::DATE,
    v.tb010_012_quantidade,
    v.tb010_012_valor_unitario,
    (v.tb010_012_quantidade * v.tb010_012_valor_unitario) AS valor_total
FROM varejo_bdiii.tb010_012_vendas v
LEFT JOIN varejo_bdiii.tb005_funcionarios f ON f.tb005_matricula = v.tb005_matricula;

-- Zera a fato para nova carga consolidada
TRUNCATE TABLE fato_vendas;


-- Q1: Produto (demais dimensões NULL)
INSERT INTO fato_vendas (
    sk_tempo, nk_produto, nk_matricula, nk_cpf, nk_loja,
    quantidade_vendida, valor
)
SELECT 
    NULL::INTEGER AS sk_tempo,
    stg.cod_produto,
    NULL::INTEGER AS nk_matricula,
    NULL::BIGINT  AS nk_cpf,
    NULL::INTEGER AS nk_loja,
    SUM(stg.quantidade),
    SUM(stg.valor_total)
FROM staging_varejo.stg_vendas stg
GROUP BY stg.cod_produto;

-- Q2: Funcionário x Tempo (dia) – demais dimensões NULL
INSERT INTO fato_vendas (
    sk_tempo, nk_produto, nk_matricula, nk_cpf, nk_loja,
    quantidade_vendida, valor
)
SELECT 
    dt.sk_tempo,
    NULL::INTEGER AS nk_produto,
    stg.matricula_funcionario,
    NULL::BIGINT  AS nk_cpf,
    NULL::INTEGER AS nk_loja,
    SUM(stg.quantidade),
    SUM(stg.valor_total)
FROM staging_varejo.stg_vendas stg
LEFT JOIN dim_tempo dt ON stg.data_venda = dt.data_completa
GROUP BY dt.sk_tempo, stg.matricula_funcionario;

-- Q3: Funcionário (demais dimensões NULL)
INSERT INTO fato_vendas (
    sk_tempo, nk_produto, nk_matricula, nk_cpf, nk_loja,
    quantidade_vendida, valor
)
SELECT 
    NULL::INTEGER AS sk_tempo,
    NULL::INTEGER AS nk_produto,
    stg.matricula_funcionario,
    NULL::BIGINT  AS nk_cpf,
    NULL::INTEGER AS nk_loja,
    SUM(stg.quantidade),
    SUM(stg.valor_total)
FROM staging_varejo.stg_vendas stg
GROUP BY stg.matricula_funcionario;

-- Q4: Funcionário x Loja (demais dimensões NULL)
INSERT INTO fato_vendas (
    sk_tempo, nk_produto, nk_matricula, nk_cpf, nk_loja,
    quantidade_vendida, valor
)
SELECT 
    NULL::INTEGER AS sk_tempo,
    NULL::INTEGER AS nk_produto,
    stg.matricula_funcionario,
    NULL::BIGINT  AS nk_cpf,
    stg.cod_loja,
    SUM(stg.quantidade),
    SUM(stg.valor_total)
FROM staging_varejo.stg_vendas stg
GROUP BY stg.matricula_funcionario, stg.cod_loja;

-- Q5/Q6: Cliente x Tempo (dia) – demais dimensões NULL
INSERT INTO fato_vendas (
    sk_tempo, nk_produto, nk_matricula, nk_cpf, nk_loja,
    quantidade_vendida, valor
)
SELECT 
    dt.sk_tempo,
    NULL::INTEGER AS nk_produto,
    NULL::INTEGER AS nk_matricula,
    stg.cpf_cliente,
    NULL::INTEGER AS nk_loja,
    SUM(stg.quantidade),
    SUM(stg.valor_total)
FROM staging_varejo.stg_vendas stg
LEFT JOIN dim_tempo dt ON stg.data_venda = dt.data_completa
GROUP BY dt.sk_tempo, stg.cpf_cliente;
