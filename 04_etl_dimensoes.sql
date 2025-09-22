
-- ETL DIMENSÕES

-- DIM_TEMPO
DO $$
DECLARE
    data_inicio DATE := '2019-01-01';
    data_fim DATE := '2025-12-31';
    data_atual DATE;
    v_ano INTEGER;
    v_mes INTEGER;
    v_trimestre INTEGER;
    v_dia_semana INTEGER;
    v_nome_mes VARCHAR(20);
    v_nome_dia VARCHAR(20);
BEGIN
    data_atual := data_inicio;
    
    WHILE data_atual <= data_fim LOOP
        v_ano := EXTRACT(YEAR FROM data_atual);
        v_mes := EXTRACT(MONTH FROM data_atual);
        v_trimestre := CEIL(v_mes / 3.0);
        v_dia_semana := EXTRACT(DOW FROM data_atual);
        
        v_nome_mes := CASE v_mes
            WHEN 1 THEN 'Janeiro' WHEN 2 THEN 'Fevereiro' WHEN 3 THEN 'Março'
            WHEN 4 THEN 'Abril' WHEN 5 THEN 'Maio' WHEN 6 THEN 'Junho'
            WHEN 7 THEN 'Julho' WHEN 8 THEN 'Agosto' WHEN 9 THEN 'Setembro'
            WHEN 10 THEN 'Outubro' WHEN 11 THEN 'Novembro' WHEN 12 THEN 'Dezembro'
        END;
        
        v_nome_dia := CASE v_dia_semana
            WHEN 0 THEN 'Domingo' WHEN 1 THEN 'Segunda-feira' WHEN 2 THEN 'Terça-feira'
            WHEN 3 THEN 'Quarta-feira' WHEN 4 THEN 'Quinta-feira' WHEN 5 THEN 'Sexta-feira'
            WHEN 6 THEN 'Sábado'
        END;
        
        INSERT INTO dim_tempo (data_completa, ano, trimestre, mes, nome_mes, dia_semana, nome_dia_semana)
        VALUES (data_atual, v_ano, v_trimestre, v_mes, v_nome_mes, v_dia_semana, v_nome_dia)
        ON CONFLICT (data_completa) DO NOTHING;
        
        data_atual := data_atual + INTERVAL '1 day';
    END LOOP;
END $$;

-- STAGING PRODUTOS
TRUNCATE TABLE staging_varejo.stg_produtos;
INSERT INTO staging_varejo.stg_produtos (cod_produto, descricao_produto, cod_categoria, descricao_categoria, tipo_produto)
SELECT 
    p.tb012_cod_produto,
    p.tb012_descricao,
    c.tb013_cod_categoria,
    c.tb013_descricao,
    CASE 
        WHEN UPPER(c.tb013_descricao) LIKE '%ELETRÔNICO%' THEN 'Eletrônicos'
        WHEN UPPER(c.tb013_descricao) LIKE '%ROUPA%' THEN 'Roupas'
        WHEN UPPER(c.tb013_descricao) LIKE '%CASA%' THEN 'Casa'
        WHEN UPPER(c.tb013_descricao) LIKE '%LIVRO%' THEN 'Livros'
        WHEN UPPER(c.tb013_descricao) LIKE '%ESPORTE%' THEN 'Esportes'
        ELSE 'Outros'
    END
FROM varejo_bdiii.tb012_produtos p
LEFT JOIN varejo_bdiii.tb013_categorias c ON p.tb013_cod_categoria = c.tb013_cod_categoria;

-- DIM_PRODUTO
INSERT INTO dim_produto (nk_produto, descricao_produto, categoria, tipo_produto)
SELECT cod_produto, descricao_produto, descricao_categoria, tipo_produto
FROM staging_varejo.stg_produtos;

-- STAGING FUNCIONÁRIOS
TRUNCATE TABLE staging_varejo.stg_funcionarios;
INSERT INTO staging_varejo.stg_funcionarios (matricula, nome_funcionario, nome_cargo)
SELECT 
    f.tb005_matricula,
    f.tb005_nome_completo,
    c.tb006_nome_cargo
FROM varejo_bdiii.tb005_funcionarios f
INNER JOIN varejo_bdiii.tb005_006_funcionarios_cargos fc ON f.tb005_matricula = fc.tb005_matricula
INNER JOIN varejo_bdiii.tb006_cargos c ON fc.tb006_cod_cargo = c.tb006_cod_cargo;

-- DIM_FUNCIONARIO
INSERT INTO dim_funcionario (nk_matricula, nome_funcionario, cargo_atual)
SELECT matricula, nome_funcionario, nome_cargo
FROM staging_varejo.stg_funcionarios;

-- STAGING CLIENTES
TRUNCATE TABLE staging_varejo.stg_clientes;
INSERT INTO staging_varejo.stg_clientes (cpf, nome_cliente)
SELECT tb010_cpf, tb010_nome
FROM varejo_bdiii.tb010_clientes;

-- DIM_CLIENTE
INSERT INTO dim_cliente (nk_cpf, nome_cliente)
SELECT cpf, nome_cliente
FROM staging_varejo.stg_clientes;

-- STAGING LOCALIDADES
TRUNCATE TABLE staging_varejo.stg_localidades;
INSERT INTO staging_varejo.stg_localidades (cod_loja, estado, tipo_loja, regiao)
SELECT 
    l.tb004_cod_loja,
    uf.tb001_sigla_uf,
    CASE WHEN l.tb004_matriz IS NULL THEN 'Matriz' ELSE 'Filial' END,
    CASE 
        WHEN uf.tb001_sigla_uf IN ('SP', 'RJ', 'MG', 'ES') THEN 'Sudeste'
        WHEN uf.tb001_sigla_uf IN ('RS', 'SC', 'PR') THEN 'Sul'
        WHEN uf.tb001_sigla_uf IN ('GO', 'MT', 'MS', 'DF') THEN 'Centro-Oeste'
        WHEN uf.tb001_sigla_uf IN ('BA', 'SE', 'PE', 'AL', 'PB', 'RN', 'CE', 'PI', 'MA') THEN 'Nordeste'
        WHEN uf.tb001_sigla_uf IN ('AM', 'PA', 'AC', 'RO', 'RR', 'AP', 'TO') THEN 'Norte'
        ELSE 'Outras'
    END
FROM varejo_bdiii.tb004_lojas l
LEFT JOIN varejo_bdiii.tb003_enderecos e ON l.tb003_cod_endereco = e.tb003_cod_endereco
LEFT JOIN varejo_bdiii.tb002_cidades c ON e.tb002_cod_cidade = c.tb002_cod_cidade
LEFT JOIN varejo_bdiii.tb001_uf uf ON c.tb001_sigla_uf = uf.tb001_sigla_uf;

-- DIM_LOCALIDADE
INSERT INTO dim_localidade (nk_loja, tipo_loja, regiao)
SELECT cod_loja, tipo_loja, regiao
FROM staging_varejo.stg_localidades;