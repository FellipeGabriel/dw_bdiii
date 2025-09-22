 -- FATO VENDAS
 CREATE TABLE IF NOT EXISTS fato_vendas (
    sk_venda            SERIAL PRIMARY KEY,
    
    -- Chaves estrangeiras para as dimensões
    sk_tempo            INTEGER NOT NULL,
    sk_produto          INTEGER NOT NULL,
    sk_funcionario      INTEGER NOT NULL,
    sk_cliente          INTEGER NOT NULL,
    sk_localidade       INTEGER NOT NULL,
    
    -- Métricas aditivas
    quantidade_vendida  INTEGER NOT NULL DEFAULT 0 CHECK (quantidade_vendida >= 0),
    valor_unitario      NUMERIC(10,2) NOT NULL DEFAULT 0.00 CHECK (valor_unitario >= 0),
    valor_total         NUMERIC(10,2) NOT NULL DEFAULT 0.00 CHECK (valor_total >= 0),
    valor_desconto      NUMERIC(10,2) NOT NULL DEFAULT 0.00 CHECK (valor_desconto >= 0),
    valor_comissao      NUMERIC(10,2) NOT NULL DEFAULT 0.00 CHECK (valor_comissao >= 0),
    
    -- Atributos descritivos
    numero_atendimento  INTEGER NOT NULL,
    
    -- Controle ETL
    data_carga          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT chk_fato_vendas_valores CHECK (
        valor_total = (quantidade_vendida * valor_unitario) - valor_desconto
    ),
    CONSTRAINT chk_fato_vendas_desconto CHECK (valor_desconto <= valor_total + valor_desconto),
    
    -- Foreign Keys para as dimensões
    CONSTRAINT fk_fato_vendas_tempo FOREIGN KEY (sk_tempo) 
        REFERENCES dim_tempo(sk_tempo),
    CONSTRAINT fk_fato_vendas_produto FOREIGN KEY (sk_produto) 
        REFERENCES dim_produto(sk_produto),
    CONSTRAINT fk_fato_vendas_funcionario FOREIGN KEY (sk_funcionario) 
        REFERENCES dim_funcionario(sk_funcionario),
    CONSTRAINT fk_fato_vendas_cliente FOREIGN KEY (sk_cliente) 
        REFERENCES dim_cliente(sk_cliente),
    CONSTRAINT fk_fato_vendas_localidade FOREIGN KEY (sk_localidade) 
        REFERENCES dim_localidade(sk_localidade)
);

 -- ÍNDICES PARA PERFORMANCE
 
-- Índices nas chaves estrangeiras (para joins)
CREATE INDEX IF NOT EXISTS idx_fato_vendas_sk_tempo ON fato_vendas(sk_tempo);
CREATE INDEX IF NOT EXISTS idx_fato_vendas_sk_produto ON fato_vendas(sk_produto);
CREATE INDEX IF NOT EXISTS idx_fato_vendas_sk_funcionario ON fato_vendas(sk_funcionario);
CREATE INDEX IF NOT EXISTS idx_fato_vendas_sk_cliente ON fato_vendas(sk_cliente);
CREATE INDEX IF NOT EXISTS idx_fato_vendas_sk_localidade ON fato_vendas(sk_localidade);

-- Índices compostos para consultas comuns
CREATE INDEX IF NOT EXISTS idx_fato_vendas_tempo_produto ON fato_vendas(sk_tempo, sk_produto);
CREATE INDEX IF NOT EXISTS idx_fato_vendas_tempo_funcionario ON fato_vendas(sk_tempo, sk_funcionario);
CREATE INDEX IF NOT EXISTS idx_fato_vendas_tempo_cliente ON fato_vendas(sk_tempo, sk_cliente);
CREATE INDEX IF NOT EXISTS idx_fato_vendas_funcionario_localidade ON fato_vendas(sk_funcionario, sk_localidade);

-- Índice para controle ETL
CREATE INDEX IF NOT EXISTS idx_fato_vendas_data_carga ON fato_vendas(data_carga);
CREATE INDEX IF NOT EXISTS idx_fato_vendas_numero_atendimento ON fato_vendas(numero_atendimento);

-- Índices para métricas (para agregações)
CREATE INDEX IF NOT EXISTS idx_fato_vendas_valor_total ON fato_vendas(valor_total);
CREATE INDEX IF NOT EXISTS idx_fato_vendas_quantidade ON fato_vendas(quantidade_vendida);
