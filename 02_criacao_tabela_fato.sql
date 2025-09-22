
-- FATO VENDAS 

CREATE TABLE fato_vendas (
    sk_tempo INTEGER NULL,
    nk_produto INTEGER NULL,
    nk_matricula INTEGER NULL,
    nk_cpf BIGINT NULL,
    nk_loja INTEGER NULL,
    quantidade_vendida INTEGER NOT NULL,
    valor NUMERIC(10,2) NOT NULL,

    CONSTRAINT fk_fato_tempo       FOREIGN KEY (sk_tempo)     REFERENCES dim_tempo(sk_tempo),
    CONSTRAINT fk_fato_produto     FOREIGN KEY (nk_produto)   REFERENCES dim_produto(nk_produto),
    CONSTRAINT fk_fato_funcionario FOREIGN KEY (nk_matricula) REFERENCES dim_funcionario(nk_matricula),
    CONSTRAINT fk_fato_cliente     FOREIGN KEY (nk_cpf)       REFERENCES dim_cliente(nk_cpf),
    CONSTRAINT fk_fato_localidade  FOREIGN KEY (nk_loja)      REFERENCES dim_localidade(nk_loja)
);
