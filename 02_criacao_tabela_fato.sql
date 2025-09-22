
-- FATO VENDAS

CREATE TABLE fato_vendas (
    sk_venda SERIAL PRIMARY KEY,
    sk_tempo INTEGER NOT NULL,
    sk_produto INTEGER NOT NULL,
    sk_funcionario INTEGER NOT NULL,
    sk_cliente INTEGER NOT NULL,
    sk_localidade INTEGER NOT NULL,
    quantidade_vendida INTEGER NOT NULL,
    valor_total NUMERIC(10,2) NOT NULL,
    numero_atendimento INTEGER NOT NULL,
    
    CONSTRAINT fk_fato_tempo FOREIGN KEY (sk_tempo) REFERENCES dim_tempo(sk_tempo),
    CONSTRAINT fk_fato_produto FOREIGN KEY (sk_produto) REFERENCES dim_produto(sk_produto),
    CONSTRAINT fk_fato_funcionario FOREIGN KEY (sk_funcionario) REFERENCES dim_funcionario(sk_funcionario),
    CONSTRAINT fk_fato_cliente FOREIGN KEY (sk_cliente) REFERENCES dim_cliente(sk_cliente),
    CONSTRAINT fk_fato_localidade FOREIGN KEY (sk_localidade) REFERENCES dim_localidade(sk_localidade)
);