 -- SCRIPT ETL PARA CARREGAR DIMENSÕES - DATA WAREHOUSE VAREJO (CORRIGIDO)

-- Remover constraint antiga
ALTER TABLE dim_tempo DROP CONSTRAINT IF EXISTS dim_tempo_dia_semana_check;

-- Adicionar constraint correta (PostgreSQL usa 0-6, onde 0=Domingo)
ALTER TABLE dim_tempo ADD CONSTRAINT dim_tempo_dia_semana_check 
    CHECK (dia_semana BETWEEN 0 AND 6);

 -- 1. ETL DIMENSÃO TEMPO
 
-- Função para popular dimensão tempo (5 anos de dados)
DO $$
DECLARE
    data_inicio DATE := '2019-01-01';
    data_fim DATE := '2025-12-31';
    data_atual DATE;
    v_ano INTEGER;
    v_mes INTEGER;
    v_dia INTEGER;
    v_trimestre INTEGER;
    v_semana INTEGER;
    v_dia_semana INTEGER;
    v_nome_mes VARCHAR(20);
    v_nome_dia VARCHAR(20);
    v_eh_fim_semana BOOLEAN;
    v_eh_feriado BOOLEAN;
BEGIN
    data_atual := data_inicio;
    
    WHILE data_atual <= data_fim LOOP
        v_ano := EXTRACT(YEAR FROM data_atual);
        v_mes := EXTRACT(MONTH FROM data_atual);
        v_dia := EXTRACT(DAY FROM data_atual);
        v_trimestre := CEIL(v_mes / 3.0);
        v_semana := EXTRACT(WEEK FROM data_atual);
        v_dia_semana := EXTRACT(DOW FROM data_atual); -- DOW retorna 0-6
        
        -- Nome do mês
        v_nome_mes := CASE v_mes
            WHEN 1 THEN 'Janeiro'
            WHEN 2 THEN 'Fevereiro'
            WHEN 3 THEN 'Março'
            WHEN 4 THEN 'Abril'
            WHEN 5 THEN 'Maio'
            WHEN 6 THEN 'Junho'
            WHEN 7 THEN 'Julho'
            WHEN 8 THEN 'Agosto'
            WHEN 9 THEN 'Setembro'
            WHEN 10 THEN 'Outubro'
            WHEN 11 THEN 'Novembro'
            WHEN 12 THEN 'Dezembro'
        END;
        
        -- Nome do dia da semana (0=Domingo no PostgreSQL)
        v_nome_dia := CASE v_dia_semana
            WHEN 0 THEN 'Domingo'
            WHEN 1 THEN 'Segunda-feira'
            WHEN 2 THEN 'Terça-feira'
            WHEN 3 THEN 'Quarta-feira'
            WHEN 4 THEN 'Quinta-feira'
            WHEN 5 THEN 'Sexta-feira'
            WHEN 6 THEN 'Sábado'
        END;
        
        -- Fim de semana (0=Domingo, 6=Sábado)
        v_eh_fim_semana := v_dia_semana IN (0, 6);
        
        -- Feriados básicos (simplificado)
        v_eh_feriado := (v_mes = 1 AND v_dia = 1) OR  -- Ano Novo
                        (v_mes = 4 AND v_dia = 21) OR -- Tiradentes
                        (v_mes = 9 AND v_dia = 7) OR  -- Independência
                        (v_mes = 10 AND v_dia = 12) OR -- Nossa Senhora
                        (v_mes = 11 AND v_dia = 15) OR -- Proclamação
                        (v_mes = 12 AND v_dia = 25);   -- Natal
        
        INSERT INTO dim_tempo (
            data_completa, ano, trimestre, mes, nome_mes, semana_ano,
            dia, dia_semana, nome_dia_semana, eh_fim_semana, eh_feriado
        ) VALUES (
            data_atual, v_ano, v_trimestre, v_mes, v_nome_mes, v_semana,
            v_dia, v_dia_semana, v_nome_dia, v_eh_fim_semana, v_eh_feriado
        ) ON CONFLICT (data_completa) DO NOTHING;
        
        data_atual := data_atual + INTERVAL '1 day';
    END LOOP;
END $$;

 -- 2. ETL STAGING PRODUTOS
 
-- Limpar staging
TRUNCATE TABLE staging_varejo.stg_produtos;

-- Popular staging produtos
INSERT INTO staging_varejo.stg_produtos (
    cod_produto, descricao_produto, cod_categoria, descricao_categoria, tipo_produto
)
SELECT 
    p.tb012_cod_produto,
    p.tb012_descricao,
    c.tb013_cod_categoria,
    c.tb013_descricao,
    CASE 
        WHEN UPPER(c.tb013_descricao) LIKE '%ELETRÔNICO%' OR UPPER(c.tb013_descricao) LIKE '%ELETRONICO%' THEN 'Eletrônicos'
        WHEN UPPER(c.tb013_descricao) LIKE '%ROUPA%' OR UPPER(c.tb013_descricao) LIKE '%VESTUÁRIO%' THEN 'Roupas'
        WHEN UPPER(c.tb013_descricao) LIKE '%CASA%' OR UPPER(c.tb013_descricao) LIKE '%LAR%' THEN 'Casa e Decoração'
        WHEN UPPER(c.tb013_descricao) LIKE '%LIVRO%' OR UPPER(c.tb013_descricao) LIKE '%EDUCAÇÃO%' THEN 'Livros e Educação'
        WHEN UPPER(c.tb013_descricao) LIKE '%ESPORTE%' OR UPPER(c.tb013_descricao) LIKE '%FITNESS%' THEN 'Esportes'
        ELSE 'Outros'
    END as tipo_produto
FROM varejo_bdiii.tb012_produtos p
LEFT JOIN varejo_bdiii.tb013_categorias c ON p.tb013_cod_categoria = c.tb013_cod_categoria;

 -- 3. ETL DIMENSÃO PRODUTO
 
-- Popular dimensão produto
INSERT INTO dim_produto (
    nk_produto, descricao_produto, categoria, tipo_produto, valor_sugerido
)
SELECT 
    stg.cod_produto,
    stg.descricao_produto,
    stg.descricao_categoria,
    stg.tipo_produto,
    0.00 -- Valor sugerido será atualizado conforme necessário
FROM staging_varejo.stg_produtos stg
WHERE NOT EXISTS (
    SELECT 1 FROM dim_produto dp 
    WHERE dp.nk_produto = stg.cod_produto 
    AND dp.versao_atual = TRUE
);

 -- 4. ETL STAGING FUNCIONÁRIOS
 
-- Limpar staging
TRUNCATE TABLE staging_varejo.stg_funcionarios;

-- Popular staging funcionários
INSERT INTO staging_varejo.stg_funcionarios (
    matricula, nome_funcionario, cod_cargo, nome_cargo, 
    salario_base, comissao_percentual, data_contratacao, 
    data_demissao, status
)
SELECT 
    f.tb005_matricula,
    f.tb005_nome_completo,
    fc.tb006_cod_cargo,
    c.tb006_nome_cargo,
    fc.tb005_006_valor_cargo,
    fc.tb005_006_perc_comissao_cargo,
    f.tb005_data_contratacao,
    f.tb005_data_demissao,
    f.tb005_status
FROM varejo_bdiii.tb005_funcionarios f
INNER JOIN varejo_bdiii.tb005_006_funcionarios_cargos fc ON f.tb005_matricula = fc.tb005_matricula
INNER JOIN varejo_bdiii.tb006_cargos c ON fc.tb006_cod_cargo = c.tb006_cod_cargo;

 -- 5. ETL DIMENSÃO FUNCIONÁRIO
 
-- Popular dimensão funcionário
INSERT INTO dim_funcionario (
    nk_matricula, nome_funcionario, cargo_atual, status,
    data_contratacao, data_demissao, salario_base, comissao_percentual
)
SELECT 
    stg.matricula,
    stg.nome_funcionario,
    stg.nome_cargo,
    stg.status,
    stg.data_contratacao,
    stg.data_demissao,
    stg.salario_base,
    stg.comissao_percentual
FROM staging_varejo.stg_funcionarios stg
WHERE NOT EXISTS (
    SELECT 1 FROM dim_funcionario df 
    WHERE df.nk_matricula = stg.matricula 
    AND df.versao_atual = TRUE
);

 -- 6. ETL STAGING CLIENTES
 
-- Limpar staging
TRUNCATE TABLE staging_varejo.stg_clientes;

-- Popular staging clientes
INSERT INTO staging_varejo.stg_clientes (
    cpf, nome_cliente, telefone_residencial, telefone_celular, 
    possui_login, data_cadastro_login, cliente_antigo
)
SELECT 
    c.tb010_cpf,
    c.tb010_nome,
    c.tb010_fone_residencial,
    c.tb010_fone_celular,
    CASE WHEN l.tb011_logins IS NOT NULL THEN TRUE ELSE FALSE END as possui_login,
    l.tb011_data_cadastro,
    CASE WHEN EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM l.tb011_data_cadastro) >= 5 
         THEN TRUE ELSE FALSE END as cliente_antigo
FROM varejo_bdiii.tb010_clientes c
LEFT JOIN varejo_bdiii.tb011_logins l ON c.tb010_cpf = l.tb010_cpf;

 -- 7. ETL DIMENSÃO CLIENTE
 
-- Popular dimensão cliente
INSERT INTO dim_cliente (
    nk_cpf, nome_cliente, telefone_residencial, telefone_celular,
    possui_login, data_cadastro_login, cliente_antigo
)
SELECT 
    stg.cpf,
    stg.nome_cliente,
    stg.telefone_residencial,
    stg.telefone_celular,
    stg.possui_login,
    stg.data_cadastro_login,
    stg.cliente_antigo
FROM staging_varejo.stg_clientes stg
WHERE NOT EXISTS (
    SELECT 1 FROM dim_cliente dc 
    WHERE dc.nk_cpf = stg.cpf 
    AND dc.versao_atual = TRUE
);

 -- 8. ETL STAGING LOCALIDADES
 
-- Limpar staging
TRUNCATE TABLE staging_varejo.stg_localidades;

-- Popular staging localidades
INSERT INTO staging_varejo.stg_localidades (
    cod_loja, cod_endereco, matriz, cnpj_loja, cidade, estado, 
    nome_estado, bairro, tipo_loja, eh_matriz
)
SELECT 
    l.tb004_cod_loja,
    l.tb003_cod_endereco,
    l.tb004_matriz,
    l.tb004_cnpj_loja,
    c.tb002_nome_cidade,
    uf.tb001_sigla_uf,
    uf.tb001_nome_estado,
    e.tb003_bairro,
    CASE WHEN l.tb004_matriz IS NULL THEN 'Matriz' ELSE 'Filial' END as tipo_loja,
    CASE WHEN l.tb004_matriz IS NULL THEN TRUE ELSE FALSE END as eh_matriz
FROM varejo_bdiii.tb004_lojas l
LEFT JOIN varejo_bdiii.tb003_enderecos e ON l.tb003_cod_endereco = e.tb003_cod_endereco
LEFT JOIN varejo_bdiii.tb002_cidades c ON e.tb002_cod_cidade = c.tb002_cod_cidade
LEFT JOIN varejo_bdiii.tb001_uf uf ON c.tb001_sigla_uf = uf.tb001_sigla_uf;

 -- 9. ETL DIMENSÃO LOCALIDADE
 
-- Popular dimensão localidade
INSERT INTO dim_localidade (
    nk_loja, tipo_loja, cnpj, cidade, estado, nome_estado, 
    bairro, regiao, eh_matriz
)
SELECT 
    stg.cod_loja,
    stg.tipo_loja,
    stg.cnpj_loja,
    stg.cidade,
    stg.estado,
    stg.nome_estado,
    stg.bairro,
    CASE 
        WHEN stg.estado IN ('SP', 'RJ', 'MG', 'ES') THEN 'Sudeste'
        WHEN stg.estado IN ('RS', 'SC', 'PR') THEN 'Sul'
        WHEN stg.estado IN ('GO', 'MT', 'MS', 'DF') THEN 'Centro-Oeste'
        WHEN stg.estado IN ('BA', 'SE', 'PE', 'AL', 'PB', 'RN', 'CE', 'PI', 'MA') THEN 'Nordeste'
        WHEN stg.estado IN ('AM', 'PA', 'AC', 'RO', 'RR', 'AP', 'TO') THEN 'Norte'
        ELSE 'Não Identificado'
    END as regiao,
    stg.eh_matriz
FROM staging_varejo.stg_localidades stg
WHERE NOT EXISTS (
    SELECT 1 FROM dim_localidade dl 
    WHERE dl.nk_loja = stg.cod_loja 
    AND dl.versao_atual = TRUE
);

