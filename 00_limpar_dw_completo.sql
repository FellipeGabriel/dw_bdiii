-- ========================================================================
-- SCRIPT PARA LIMPAR COMPLETAMENTE O DATA WAREHOUSE
-- ========================================================================

-- ========================================================================
-- 1. REMOVER TABELA FATO (primeiro por causa das FKs)
-- ========================================================================
DROP TABLE IF EXISTS fato_vendas CASCADE;

-- ========================================================================
-- 2. REMOVER TODAS AS DIMENSÕES
-- ========================================================================
DROP TABLE IF EXISTS dim_tempo CASCADE;
DROP TABLE IF EXISTS dim_produto CASCADE;
DROP TABLE IF EXISTS dim_funcionario CASCADE;
DROP TABLE IF EXISTS dim_cliente CASCADE;
DROP TABLE IF EXISTS dim_localidade CASCADE;

-- ========================================================================
-- 3. REMOVER SCHEMA STAGING E TODAS AS TABELAS DENTRO
-- ========================================================================
DROP SCHEMA IF EXISTS staging_varejo CASCADE;

-- ========================================================================
-- 4. LIMPAR SEQUENCES (caso existam)
-- ========================================================================
DROP SEQUENCE IF EXISTS dim_tempo_sk_tempo_seq CASCADE;
DROP SEQUENCE IF EXISTS dim_produto_sk_produto_seq CASCADE;
DROP SEQUENCE IF EXISTS dim_funcionario_sk_funcionario_seq CASCADE;
DROP SEQUENCE IF EXISTS dim_cliente_sk_cliente_seq CASCADE;
DROP SEQUENCE IF EXISTS dim_localidade_sk_localidade_seq CASCADE;
DROP SEQUENCE IF EXISTS fato_vendas_sk_venda_seq CASCADE;

-- ========================================================================
-- 5. VERIFICAÇÃO FINAL
-- ========================================================================
SELECT 
    'Tabelas restantes no banco dw_varejo:' as status;

SELECT 
    table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_type = 'BASE TABLE'
ORDER BY table_name;

SELECT 
    'Schemas restantes:' as status;

SELECT 
    schema_name 
FROM information_schema.schemata 
WHERE schema_name NOT IN ('information_schema', 'pg_catalog', 'pg_toast')
ORDER BY schema_name;

-- ========================================================================
-- BANCO LIMPO - PRONTO PARA RECOMEÇAR
-- ========================================================================
SELECT 'Data Warehouse limpo com sucesso! Pronto para recomeçar.' as resultado;
