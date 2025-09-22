
-- QUERIES ANÁLISE GERENCIAL

-- 1. Quantidade de vendas agrupada por tipo e categoria
SELECT 
    dp.tipo_produto,
    dp.categoria,
    COUNT(*) as quantidade_vendas,
    SUM(fv.quantidade_vendida) as total_itens_vendidos
FROM fato_vendas fv
INNER JOIN dim_produto dp ON fv.sk_produto = dp.sk_produto
WHERE fv.sk_produto > 0
GROUP BY dp.tipo_produto, dp.categoria
ORDER BY quantidade_vendas DESC;

-- 2. Valor das vendas por funcionário, com visão hierárquica por tempo
SELECT 
    dt.ano,
    dt.trimestre,
    dt.mes,
    df.nome_funcionario,
    df.cargo_atual,
    SUM(fv.valor_total) as valor_total_vendas,
    COUNT(*) as quantidade_vendas
FROM fato_vendas fv
INNER JOIN dim_funcionario df ON fv.sk_funcionario = df.sk_funcionario
INNER JOIN dim_tempo dt ON fv.sk_tempo = dt.sk_tempo
WHERE fv.sk_funcionario > 0 AND fv.sk_tempo > 0
GROUP BY dt.ano, dt.trimestre, dt.mes, df.nome_funcionario, df.cargo_atual
ORDER BY dt.ano, dt.trimestre, dt.mes, valor_total_vendas DESC;

-- 3. Volume das vendas por funcionário
SELECT 
    df.nome_funcionario,
    df.cargo_atual,
    SUM(fv.quantidade_vendida) as volume_total_itens,
    COUNT(*) as numero_atendimentos,
    SUM(fv.valor_total) as valor_total_vendas
FROM fato_vendas fv
INNER JOIN dim_funcionario df ON fv.sk_funcionario = df.sk_funcionario
WHERE fv.sk_funcionario > 0
GROUP BY df.nome_funcionario, df.cargo_atual
ORDER BY volume_total_itens DESC;

-- 4. Quantidade de atendimentos realizados por funcionário e localidade
SELECT 
    dl.regiao,
    dl.tipo_loja,
    df.nome_funcionario,
    df.cargo_atual,
    COUNT(DISTINCT fv.numero_atendimento) as quantidade_atendimentos,
    SUM(fv.valor_total) as faturamento_total
FROM fato_vendas fv
INNER JOIN dim_funcionario df ON fv.sk_funcionario = df.sk_funcionario
INNER JOIN dim_localidade dl ON fv.sk_localidade = dl.sk_localidade
WHERE fv.sk_funcionario > 0 AND fv.sk_localidade > 0
GROUP BY dl.regiao, dl.tipo_loja, df.nome_funcionario, df.cargo_atual
ORDER BY quantidade_atendimentos DESC;

-- 5. Valor das últimas vendas realizadas por cliente
WITH ultimas_vendas AS (
    SELECT 
        dc.nome_cliente,
        dc.nk_cpf,
        dt.data_completa,
        fv.valor_total,
        fv.quantidade_vendida,
        dp.descricao_produto,
        ROW_NUMBER() OVER (PARTITION BY dc.sk_cliente ORDER BY dt.data_completa DESC) as rn
    FROM fato_vendas fv
    INNER JOIN dim_cliente dc ON fv.sk_cliente = dc.sk_cliente
    INNER JOIN dim_tempo dt ON fv.sk_tempo = dt.sk_tempo
    INNER JOIN dim_produto dp ON fv.sk_produto = dp.sk_produto
    WHERE fv.sk_cliente > 0 AND fv.sk_tempo > 0
)
SELECT 
    nome_cliente,
    nk_cpf,
    data_completa as data_ultima_compra,
    valor_total as valor_ultima_compra,
    quantidade_vendida,
    descricao_produto
FROM ultimas_vendas 
WHERE rn = 1
ORDER BY data_completa DESC;

-- 6. Clientes que mais compraram na "loja virtual" (NÃO EXISTE)
SELECT 
    'RESPOSTA: Não existe loja virtual no sistema' as observacao,
    'Alternativa: Dados disponíveis são apenas de lojas físicas' as alternativa;

-- ALTERNATIVA 6: Clientes que mais compraram por período
SELECT 
    dt.ano,
    dt.mes,
    dc.nome_cliente,
    dc.nk_cpf,
    dl.regiao,
    dl.tipo_loja,
    COUNT(*) as total_compras,
    SUM(fv.valor_total) as valor_acumulado
FROM fato_vendas fv
INNER JOIN dim_cliente dc ON fv.sk_cliente = dc.sk_cliente
INNER JOIN dim_tempo dt ON fv.sk_tempo = dt.sk_tempo
INNER JOIN dim_localidade dl ON fv.sk_localidade = dl.sk_localidade
WHERE fv.sk_cliente > 0 AND fv.sk_tempo > 0
GROUP BY dt.ano, dt.mes, dc.nome_cliente, dc.nk_cpf, dl.regiao, dl.tipo_loja
ORDER BY dt.ano, dt.mes, valor_acumulado DESC;