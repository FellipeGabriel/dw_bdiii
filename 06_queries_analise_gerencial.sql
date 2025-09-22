-- ========================================================================
-- QUERIES PARA ANÁLISE GERENCIAL - DATA WAREHOUSE VAREJO
-- ========================================================================
-- Database: dw_varejo
-- Autor: Sistema de Data Warehouse
-- Data: $(date)
-- Descrição: Queries para responder as 6 perguntas da análise gerencial
-- ========================================================================

-- Conectar ao banco dw_varejo
\c dw_varejo;

-- ========================================================================
-- PERGUNTA 1: Quantidade de vendas agrupada por tipo e categoria
-- ========================================================================

-- Query 1: Quantidade de vendas por tipo e categoria de produto
SELECT 
    dp.tipo_produto,
    dp.categoria,
    COUNT(*) as quantidade_vendas,
    SUM(fv.quantidade_vendida) as total_itens_vendidos,
    SUM(fv.valor_total) as valor_total_vendas
FROM fato_vendas fv
INNER JOIN dim_produto dp ON fv.sk_produto = dp.sk_produto
WHERE fv.sk_produto > 0  -- Exclui produtos desconhecidos
GROUP BY dp.tipo_produto, dp.categoria
ORDER BY dp.tipo_produto, quantidade_vendas DESC;

-- ========================================================================
-- PERGUNTA 2: Valor das vendas por funcionário, com visão hierárquica por tempo
-- ========================================================================

-- Query 2a: Valor das vendas por funcionário por ano
SELECT 
    dt.ano,
    df.nome_funcionario,
    df.cargo_atual,
    COUNT(*) as quantidade_vendas,
    SUM(fv.valor_total) as valor_total_vendas,
    SUM(fv.valor_comissao) as total_comissoes,
    AVG(fv.valor_total) as ticket_medio
FROM fato_vendas fv
INNER JOIN dim_funcionario df ON fv.sk_funcionario = df.sk_funcionario
INNER JOIN dim_tempo dt ON fv.sk_tempo = dt.sk_tempo
WHERE fv.sk_funcionario > 0 AND fv.sk_tempo > 0
GROUP BY dt.ano, df.nome_funcionario, df.cargo_atual
ORDER BY dt.ano, valor_total_vendas DESC;

-- Query 2b: Valor das vendas por funcionário por trimestre (visão hierárquica)
SELECT 
    dt.ano,
    dt.trimestre,
    df.nome_funcionario,
    df.cargo_atual,
    SUM(fv.valor_total) as valor_total_vendas,
    RANK() OVER (PARTITION BY dt.ano, dt.trimestre ORDER BY SUM(fv.valor_total) DESC) as ranking_trimestre
FROM fato_vendas fv
INNER JOIN dim_funcionario df ON fv.sk_funcionario = df.sk_funcionario
INNER JOIN dim_tempo dt ON fv.sk_tempo = dt.sk_tempo
WHERE fv.sk_funcionario > 0 AND fv.sk_tempo > 0
GROUP BY dt.ano, dt.trimestre, df.nome_funcionario, df.cargo_atual
ORDER BY dt.ano, dt.trimestre, valor_total_vendas DESC;

-- ========================================================================
-- PERGUNTA 3: Volume das vendas por funcionário
-- ========================================================================

-- Query 3: Volume (quantidade) de vendas por funcionário
SELECT 
    df.nome_funcionario,
    df.cargo_atual,
    dl.cidade,
    dl.estado,
    COUNT(*) as numero_atendimentos,
    SUM(fv.quantidade_vendida) as volume_total_itens,
    SUM(fv.valor_total) as valor_total_vendas,
    AVG(fv.quantidade_vendida) as media_itens_por_venda
FROM fato_vendas fv
INNER JOIN dim_funcionario df ON fv.sk_funcionario = df.sk_funcionario
INNER JOIN dim_localidade dl ON fv.sk_localidade = dl.sk_localidade
WHERE fv.sk_funcionario > 0 AND fv.sk_localidade > 0
GROUP BY df.nome_funcionario, df.cargo_atual, dl.cidade, dl.estado
ORDER BY volume_total_itens DESC;

-- ========================================================================
-- PERGUNTA 4: Quantidade de atendimentos por funcionário e localidade
-- ========================================================================

-- Query 4: Atendimentos realizados por funcionário e localidade
SELECT 
    dl.tipo_loja,
    dl.cidade,
    dl.estado,
    dl.eh_matriz,
    df.nome_funcionario,
    df.cargo_atual,
    COUNT(DISTINCT fv.numero_atendimento) as quantidade_atendimentos,
    COUNT(*) as total_vendas,
    SUM(fv.valor_total) as faturamento_total
FROM fato_vendas fv
INNER JOIN dim_funcionario df ON fv.sk_funcionario = df.sk_funcionario
INNER JOIN dim_localidade dl ON fv.sk_localidade = dl.sk_localidade
WHERE fv.sk_funcionario > 0 AND fv.sk_localidade > 0
GROUP BY dl.tipo_loja, dl.cidade, dl.estado, dl.eh_matriz, 
         df.nome_funcionario, df.cargo_atual
ORDER BY dl.eh_matriz DESC, quantidade_atendimentos DESC;

-- ========================================================================
-- PERGUNTA 5: Valor das últimas vendas realizadas por cliente
-- ========================================================================

-- Query 5: Últimas vendas de cada cliente com valores
WITH ultimas_vendas AS (
    SELECT 
        dc.nome_cliente,
        dc.nk_cpf,
        dc.possui_login,
        dc.cliente_antigo,
        dt.data_completa,
        fv.valor_total,
        fv.quantidade_vendida,
        dp.descricao_produto,
        dl.cidade as cidade_compra,
        ROW_NUMBER() OVER (PARTITION BY dc.sk_cliente ORDER BY dt.data_completa DESC) as rn
    FROM fato_vendas fv
    INNER JOIN dim_cliente dc ON fv.sk_cliente = dc.sk_cliente
    INNER JOIN dim_tempo dt ON fv.sk_tempo = dt.sk_tempo
    INNER JOIN dim_produto dp ON fv.sk_produto = dp.sk_produto
    INNER JOIN dim_localidade dl ON fv.sk_localidade = dl.sk_localidade
    WHERE fv.sk_cliente > 0 AND fv.sk_tempo > 0
)
SELECT 
    nome_cliente,
    nk_cpf,
    possui_login,
    cliente_antigo,
    data_completa as data_ultima_compra,
    valor_total as valor_ultima_compra,
    quantidade_vendida,
    descricao_produto,
    cidade_compra
FROM ultimas_vendas 
WHERE rn = 1
ORDER BY data_completa DESC, valor_total DESC;

-- ========================================================================
-- PERGUNTA 6: Clientes que mais compraram na "loja virtual" (NOTA: Não existe loja virtual)
-- ========================================================================

-- Query 6a: RESPOSTA PARA A PERGUNTA - Não há loja virtual no sistema
SELECT 
    'AVISO: Não existe loja virtual/online no sistema atual' as observacao,
    'Dados disponíveis são apenas de lojas físicas (Matriz e Filiais)' as explicacao;

-- Query 6b: ALTERNATIVA - Clientes que mais compraram por período (todas as lojas)
SELECT 
    dt.ano,
    dt.trimestre,
    dc.nome_cliente,
    dc.nk_cpf,
    dc.possui_login,
    dl.tipo_loja,
    COUNT(*) as total_compras,
    SUM(fv.quantidade_vendida) as total_itens,
    SUM(fv.valor_total) as valor_acumulado,
    AVG(fv.valor_total) as ticket_medio
FROM fato_vendas fv
INNER JOIN dim_cliente dc ON fv.sk_cliente = dc.sk_cliente
INNER JOIN dim_tempo dt ON fv.sk_tempo = dt.sk_tempo
INNER JOIN dim_localidade dl ON fv.sk_localidade = dl.sk_localidade
WHERE fv.sk_cliente > 0 AND fv.sk_tempo > 0
GROUP BY dt.ano, dt.trimestre, dc.nome_cliente, dc.nk_cpf, 
         dc.possui_login, dl.tipo_loja
HAVING SUM(fv.valor_total) > 1000  -- Filtro para clientes com volume significativo
ORDER BY dt.ano, dt.trimestre, valor_acumulado DESC;

-- Query 6c: ALTERNATIVA - Clientes com login (mais próximo de "virtual") por período
SELECT 
    dt.ano,
    dt.mes,
    dt.nome_mes,
    COUNT(DISTINCT CASE WHEN dc.possui_login = TRUE THEN dc.sk_cliente END) as clientes_com_login,
    COUNT(DISTINCT dc.sk_cliente) as total_clientes,
    SUM(CASE WHEN dc.possui_login = TRUE THEN fv.valor_total ELSE 0 END) as vendas_clientes_com_login,
    SUM(fv.valor_total) as total_vendas,
    ROUND(
        (SUM(CASE WHEN dc.possui_login = TRUE THEN fv.valor_total ELSE 0 END) * 100.0 / 
         NULLIF(SUM(fv.valor_total), 0)), 2
    ) as percentual_vendas_login
FROM fato_vendas fv
INNER JOIN dim_cliente dc ON fv.sk_cliente = dc.sk_cliente
INNER JOIN dim_tempo dt ON fv.sk_tempo = dt.sk_tempo
WHERE fv.sk_cliente > 0 AND fv.sk_tempo > 0
GROUP BY dt.ano, dt.mes, dt.nome_mes
ORDER BY dt.ano, dt.mes;

-- ========================================================================
-- QUERIES EXTRAS PARA ANÁLISE COMPLEMENTAR
-- ========================================================================

-- Query Extra 1: Resumo geral do DW
SELECT 
    'Resumo Geral do Data Warehouse' as analise,
    (SELECT COUNT(*) FROM fato_vendas WHERE sk_venda > 0) as total_vendas,
    (SELECT COUNT(DISTINCT sk_cliente) FROM fato_vendas WHERE sk_cliente > 0) as clientes_unicos,
    (SELECT COUNT(DISTINCT sk_produto) FROM fato_vendas WHERE sk_produto > 0) as produtos_vendidos,
    (SELECT COUNT(DISTINCT sk_funcionario) FROM fato_vendas WHERE sk_funcionario > 0) as funcionarios_ativos,
    (SELECT COUNT(DISTINCT sk_localidade) FROM fato_vendas WHERE sk_localidade > 0) as localidades_ativas,
    (SELECT SUM(valor_total) FROM fato_vendas WHERE sk_venda > 0) as faturamento_total;

-- Query Extra 2: Performance por localidade
SELECT 
    dl.tipo_loja,
    dl.cidade,
    dl.estado,
    dl.eh_matriz,
    COUNT(*) as vendas,
    SUM(fv.valor_total) as faturamento,
    COUNT(DISTINCT fv.sk_cliente) as clientes_atendidos,
    COUNT(DISTINCT fv.sk_funcionario) as funcionarios_vendedores
FROM fato_vendas fv
INNER JOIN dim_localidade dl ON fv.sk_localidade = dl.sk_localidade
WHERE fv.sk_localidade > 0
GROUP BY dl.tipo_loja, dl.cidade, dl.estado, dl.eh_matriz
ORDER BY faturamento DESC;

-- Query Extra 3: Sazonalidade das vendas
SELECT 
    dt.mes,
    dt.nome_mes,
    COUNT(*) as vendas,
    SUM(fv.valor_total) as faturamento,
    AVG(fv.valor_total) as ticket_medio
FROM fato_vendas fv
INNER JOIN dim_tempo dt ON fv.sk_tempo = dt.sk_tempo
WHERE fv.sk_tempo > 0
GROUP BY dt.mes, dt.nome_mes
ORDER BY dt.mes;

-- ========================================================================
-- FIM DAS QUERIES DE ANÁLISE GERENCIAL
-- ========================================================================

SELECT 'Queries de análise gerencial criadas com sucesso!' as status;