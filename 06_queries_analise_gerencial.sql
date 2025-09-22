
-- QUERIES ANÁLISE GERENCIAL (alinhadas às 6 questões e novo modelo)

-- 1. Quantidade vendida por tipo e categoria do produto
SELECT 
    dp.tipo_produto,
    dp.categoria,
    SUM(fv.quantidade_vendida) AS quantidade_itens,
    SUM(fv.valor) AS valor_total
FROM fato_vendas fv
LEFT JOIN dim_produto dp ON fv.nk_produto = dp.nk_produto
WHERE fv.nk_produto IS NOT NULL
  AND fv.sk_tempo IS NULL
  AND fv.nk_matricula IS NULL
  AND fv.nk_cpf IS NULL
  AND fv.nk_loja IS NULL
GROUP BY dp.tipo_produto, dp.categoria
ORDER BY quantidade_itens DESC;

-- 2. Valor das vendas por funcionário com visão temporal (ano/mês derivado de data)
SELECT 
    EXTRACT(YEAR  FROM dt.data_completa) AS ano,
    EXTRACT(MONTH FROM dt.data_completa) AS mes,
    df.nome_funcionario,
    SUM(fv.valor) AS valor_total,
    SUM(fv.quantidade_vendida) AS total_itens
FROM fato_vendas fv
LEFT JOIN dim_funcionario df ON fv.nk_matricula = df.nk_matricula
LEFT JOIN dim_tempo dt ON fv.sk_tempo = dt.sk_tempo
WHERE fv.sk_tempo IS NOT NULL
  AND fv.nk_matricula IS NOT NULL
  AND fv.nk_produto IS NULL
  AND fv.nk_cpf IS NULL
  AND fv.nk_loja IS NULL
GROUP BY ano, mes, df.nome_funcionario
ORDER BY ano, mes, valor_total DESC;

-- 3. Volume de vendas por funcionário 
SELECT 
    df.nome_funcionario,
    SUM(fv.quantidade_vendida) AS volume_total_itens,
    SUM(fv.valor) AS valor_total
FROM fato_vendas fv
LEFT JOIN dim_funcionario df ON fv.nk_matricula = df.nk_matricula
WHERE fv.nk_matricula IS NOT NULL
  AND fv.sk_tempo IS NULL
  AND fv.nk_produto IS NULL
  AND fv.nk_cpf IS NULL
  AND fv.nk_loja IS NULL
GROUP BY df.nome_funcionario
ORDER BY volume_total_itens DESC;

-- 4. Quantidade vendida por funcionário e localidade 
SELECT 
    dl.regiao,
    df.nome_funcionario,
    SUM(fv.quantidade_vendida) AS quantidade_vendida,
    SUM(fv.valor) AS faturamento_total
FROM fato_vendas fv
LEFT JOIN dim_funcionario df ON fv.nk_matricula = df.nk_matricula
LEFT JOIN dim_localidade dl ON fv.nk_loja = dl.nk_loja
WHERE fv.nk_matricula IS NOT NULL
  AND fv.nk_loja IS NOT NULL
  AND fv.sk_tempo IS NULL
  AND fv.nk_produto IS NULL
  AND fv.nk_cpf IS NULL
GROUP BY dl.regiao, df.nome_funcionario
ORDER BY quantidade_vendida DESC;

-- 5. Última compra por cliente (data mais recente e totais do dia)
WITH ult AS (
    SELECT fv.nk_cpf, MAX(dt.data_completa) AS data_ultima
    FROM fato_vendas fv
    LEFT JOIN dim_tempo dt ON fv.sk_tempo = dt.sk_tempo
    WHERE fv.nk_cpf IS NOT NULL
      AND fv.sk_tempo IS NOT NULL
      AND fv.nk_produto IS NULL
      AND fv.nk_matricula IS NULL
      AND fv.nk_loja IS NULL
    GROUP BY fv.nk_cpf
)
SELECT 
    dc.nome_cliente,
    dc.nk_cpf,
    u.data_ultima AS data_ultima_compra,
    SUM(fv.quantidade_vendida) AS quantidade_no_dia,
    SUM(fv.valor) AS valor_no_dia
FROM ult u
LEFT JOIN dim_cliente dc ON dc.nk_cpf = u.nk_cpf
LEFT JOIN fato_vendas fv ON fv.nk_cpf = u.nk_cpf
LEFT JOIN dim_tempo dt ON dt.sk_tempo = fv.sk_tempo AND dt.data_completa = u.data_ultima
WHERE fv.nk_produto IS NULL
  AND fv.nk_matricula IS NULL
  AND fv.nk_loja IS NULL
GROUP BY dc.nome_cliente, dc.nk_cpf, u.data_ultima
ORDER BY u.data_ultima DESC;

-- 6. Loja virtual não existe nos dados
SELECT 
    'RESPOSTA: Não existe loja virtual no sistema' AS observacao,
    'Alternativa: Listar clientes que mais compraram por período (ano/mês).' AS alternativa;

-- Alternativa: Top clientes por ano/mês 
SELECT 
    EXTRACT(YEAR  FROM dt.data_completa) AS ano,
    EXTRACT(MONTH FROM dt.data_completa) AS mes,
    dc.nome_cliente,
    dc.nk_cpf,
    SUM(fv.quantidade_vendida) AS quantidade,
    SUM(fv.valor) AS valor_acumulado
FROM fato_vendas fv
LEFT JOIN dim_cliente dc ON fv.nk_cpf = dc.nk_cpf
LEFT JOIN dim_tempo dt ON fv.sk_tempo = dt.sk_tempo
WHERE fv.nk_cpf IS NOT NULL
  AND fv.sk_tempo IS NOT NULL
  AND fv.nk_produto IS NULL
  AND fv.nk_matricula IS NULL
  AND fv.nk_loja IS NULL
GROUP BY ano, mes, dc.nome_cliente, dc.nk_cpf
ORDER BY ano, mes, valor_acumulado DESC;
