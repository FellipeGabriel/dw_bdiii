
-- ETL FATO VENDAS

-- STAGING VENDAS
TRUNCATE TABLE staging_varejo.stg_vendas;
INSERT INTO staging_varejo.stg_vendas (cod_venda, cpf_cliente, cod_produto, matricula_funcionario, data_venda, quantidade, valor_unitario, valor_total, numero_atendimento)
SELECT 
    v.tb010_012_cod_venda,
    v.tb010_cpf,
    v.tb012_cod_produto,
    v.tb005_matricula,
    v.tb010_012_data::DATE,
    v.tb010_012_quantidade,
    v.tb010_012_valor_unitario,
    (v.tb010_012_quantidade * v.tb010_012_valor_unitario),
    v.tb010_012_cod_venda
FROM varejo_bdiii.tb010_012_vendas v;

-- FATO VENDAS
INSERT INTO fato_vendas (sk_tempo, sk_produto, sk_funcionario, sk_cliente, sk_localidade, quantidade_vendida, valor_total, numero_atendimento)
SELECT 
    COALESCE(dt.sk_tempo, -1),
    COALESCE(dp.sk_produto, -1),
    COALESCE(df.sk_funcionario, -1),
    COALESCE(dc.sk_cliente, -1),
    COALESCE(dl.sk_localidade, -1),
    stg.quantidade,
    stg.valor_total,
    stg.numero_atendimento
FROM staging_varejo.stg_vendas stg
LEFT JOIN dim_tempo dt ON stg.data_venda = dt.data_completa
LEFT JOIN dim_produto dp ON stg.cod_produto = dp.nk_produto
LEFT JOIN dim_funcionario df ON stg.matricula_funcionario = df.nk_matricula
LEFT JOIN dim_cliente dc ON stg.cpf_cliente = dc.nk_cpf
LEFT JOIN (SELECT sk_localidade, ROW_NUMBER() OVER (ORDER BY sk_localidade) as rn FROM dim_localidade WHERE sk_localidade > 0) dl ON dl.rn = 1;