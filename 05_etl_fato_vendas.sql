-- ========================================================================
-- SCRIPT ETL PARA FATO VENDAS - DATA WAREHOUSE VAREJO (CORRIGIDO)
-- ========================================================================
-- Database: dw_varejo
-- Autor: Sistema de Data Warehouse
-- Data: $(date)
-- Descrição: Script ETL para popular a tabela fato de vendas
-- ========================================================================

-- Conectar ao banco dw_varejo
\c dw_varejo;

-- ========================================================================
-- 1. ETL STAGING VENDAS
-- ========================================================================

-- Limpar staging vendas
TRUNCATE TABLE staging_varejo.stg_vendas;

-- Popular staging vendas (CORRIGIDO - usando apenas colunas que existem)
INSERT INTO staging_varejo.stg_vendas (
    cod_venda, cpf_cliente, cod_produto, matricula_funcionario,
    data_venda, quantidade, valor_unitario, valor_total, 
    valor_desconto, numero_atendimento
)
SELECT 
    v.tb010_012_cod_venda,
    v.tb010_cpf,
    v.tb012_cod_produto,
    v.tb005_matricula,
    v.tb010_012_data::DATE,
    v.tb010_012_quantidade,
    v.tb010_012_valor_unitario,
    (v.tb010_012_quantidade * v.tb010_012_valor_unitario) as valor_total,
    0.00 as valor_desconto, -- Não existe desconto na tabela origem
    v.tb010_012_cod_venda as numero_atendimento -- Usar código da venda como número do atendimento
FROM varejo_bdiii.tb010_012_vendas v;

-- ========================================================================
-- 2. ETL FATO VENDAS
-- ========================================================================

-- Popular fato vendas com lookup das dimensões
INSERT INTO fato_vendas (
    sk_tempo, sk_produto, sk_funcionario, sk_cliente, sk_localidade,
    quantidade_vendida, valor_unitario, valor_total, valor_desconto,
    valor_comissao, numero_atendimento
)
SELECT 
    -- Lookup Dimensão Tempo
    COALESCE(dt.sk_tempo, -1) as sk_tempo,
    
    -- Lookup Dimensão Produto  
    COALESCE(dp.sk_produto, -1) as sk_produto,
    
    -- Lookup Dimensão Funcionário
    COALESCE(df.sk_funcionario, -1) as sk_funcionario,
    
    -- Lookup Dimensão Cliente
    COALESCE(dc.sk_cliente, -1) as sk_cliente,
    
    -- Lookup Dimensão Localidade (usar primeira loja disponível ou -1)
    COALESCE(dl.sk_localidade, -1) as sk_localidade,
    
    -- Métricas
    stg.quantidade,
    stg.valor_unitario,
    stg.valor_total,
    stg.valor_desconto,
    
    -- Cálculo da comissão (valor_total * percentual_comissao / 100)
    ROUND(stg.valor_total * COALESCE(df.comissao_percentual, 0) / 100, 2) as valor_comissao,
    
    stg.numero_atendimento

FROM staging_varejo.stg_vendas stg

-- JOIN com Dimensão Tempo
LEFT JOIN dim_tempo dt ON stg.data_venda = dt.data_completa

-- JOIN com Dimensão Produto
LEFT JOIN dim_produto dp ON stg.cod_produto = dp.nk_produto 
    AND dp.versao_atual = TRUE

-- JOIN com Dimensão Funcionário  
LEFT JOIN dim_funcionario df ON stg.matricula_funcionario = df.nk_matricula 
    AND df.versao_atual = TRUE

-- JOIN com Dimensão Cliente
LEFT JOIN dim_cliente dc ON stg.cpf_cliente = dc.nk_cpf 
    AND dc.versao_atual = TRUE

-- JOIN com Dimensão Localidade (pegar a primeira loja disponível - já que não temos essa info nas vendas)
LEFT JOIN (
    SELECT dl.sk_localidade, ROW_NUMBER() OVER (ORDER BY dl.eh_matriz DESC, dl.sk_localidade) as rn
    FROM dim_localidade dl 
    WHERE dl.versao_atual = TRUE
) dl ON dl.rn = 1

WHERE NOT EXISTS (
    SELECT 1 FROM fato_vendas fv 
    WHERE fv.numero_atendimento = stg.numero_atendimento
    AND fv.sk_produto = COALESCE(dp.sk_produto, -1)
    AND fv.sk_cliente = COALESCE(dc.sk_cliente, -1)
);

-- ========================================================================
-- 3. VERIFICAÇÕES E ESTATÍSTICAS
-- ========================================================================

-- Verificar registros carregados
SELECT 
    'STAGING' as origem,
    COUNT(*) as total_registros,
    SUM(quantidade) as total_quantidade,
    SUM(valor_total) as total_valor,
    MIN(data_venda) as data_mais_antiga,
    MAX(data_venda) as data_mais_recente
FROM staging_varejo.stg_vendas

UNION ALL

SELECT 
    'FATO_VENDAS' as origem,
    COUNT(*) as total_registros,
    SUM(quantidade_vendida) as total_quantidade,
    SUM(valor_total) as total_valor,
    (SELECT MIN(data_completa) FROM dim_tempo dt 
     INNER JOIN fato_vendas fv ON dt.sk_tempo = fv.sk_tempo) as data_mais_antiga,
    (SELECT MAX(data_completa) FROM dim_tempo dt 
     INNER JOIN fato_vendas fv ON dt.sk_tempo = fv.sk_tempo) as data_mais_recente
FROM fato_vendas
WHERE sk_venda > 0;

-- ========================================================================
-- 4. VERIFICAR DADOS "UNKNOWN" (Quality Check)
-- ========================================================================

-- Verificar vendas com dimensões desconhecidas
SELECT 
    'Vendas com Tempo Desconhecido' as verificacao,
    COUNT(*) as quantidade
FROM fato_vendas WHERE sk_tempo = -1

UNION ALL

SELECT 
    'Vendas com Produto Desconhecido' as verificacao,
    COUNT(*) as quantidade  
FROM fato_vendas WHERE sk_produto = -1

UNION ALL

SELECT 
    'Vendas com Funcionário Desconhecido' as verificacao,
    COUNT(*) as quantidade
FROM fato_vendas WHERE sk_funcionario = -1

UNION ALL

SELECT 
    'Vendas com Cliente Desconhecido' as verificacao,
    COUNT(*) as quantidade
FROM fato_vendas WHERE sk_cliente = -1

UNION ALL

SELECT 
    'Vendas com Localidade Desconhecida' as verificacao,
    COUNT(*) as quantidade
FROM fato_vendas WHERE sk_localidade = -1;

-- ========================================================================
-- 5. VERIFICAÇÃO DE INTEGRIDADE DOS CÁLCULOS
-- ========================================================================

-- Verificar se valor_total = (quantidade * valor_unitario) - valor_desconto
SELECT 
    COUNT(*) as vendas_com_erro_calculo
FROM fato_vendas 
WHERE ABS(valor_total - ((quantidade_vendida * valor_unitario) - valor_desconto)) > 0.01;

-- Verificar comissões calculadas
SELECT 
    'Comissões Calculadas' as verificacao,
    COUNT(*) as vendas_com_comissao,
    SUM(valor_comissao) as total_comissoes,
    AVG(valor_comissao) as media_comissao
FROM fato_vendas 
WHERE valor_comissao > 0;

-- ========================================================================
-- 6. RESUMO POR PERÍODO (Para validação)
-- ========================================================================

-- Resumo de vendas por ano/mês
SELECT 
    dt.ano,
    dt.mes,
    dt.nome_mes,
    COUNT(*) as qtd_vendas,
    SUM(fv.quantidade_vendida) as qtd_itens,
    SUM(fv.valor_total) as faturamento,
    SUM(fv.valor_comissao) as total_comissoes,
    COUNT(DISTINCT fv.sk_cliente) as clientes_unicos
FROM fato_vendas fv
INNER JOIN dim_tempo dt ON fv.sk_tempo = dt.sk_tempo
WHERE fv.sk_venda > 0
GROUP BY dt.ano, dt.mes, dt.nome_mes
ORDER BY dt.ano, dt.mes;

-- ========================================================================
-- 7. NOTA IMPORTANTE SOBRE LOCALIDADE
-- ========================================================================

SELECT 
    'OBSERVAÇÃO' as tipo,
    'A tabela tb010_012_vendas não possui campo tb004_cod_loja' as observacao,
    'Todas as vendas foram associadas à primeira loja disponível' as solucao,
    'Para análises por localidade, os dados podem não ser precisos' as limitacao;

-- ========================================================================
-- 8. ATUALIZAR ESTATÍSTICAS PARA PERFORMANCE
-- ========================================================================

-- Atualizar estatísticas das tabelas para otimização de consultas
ANALYZE fato_vendas;
ANALYZE dim_tempo;
ANALYZE dim_produto;
ANALYZE dim_funcionario;
ANALYZE dim_cliente;
ANALYZE dim_localidade;

-- ========================================================================
-- FIM DO SCRIPT ETL FATO VENDAS
-- ========================================================================

SELECT 'ETL da tabela fato_vendas executado com sucesso!' as status;