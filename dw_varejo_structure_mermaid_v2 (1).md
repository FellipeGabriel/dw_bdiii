# Data Warehouse - DW_Varejo
## Estrutura Completa do DW 
---

## 📊 Modelo Dimensional — Star Schema

```mermaid
%%{init: {'theme':'neutral','themeVariables':{
  'primaryColor':'#e2e8f0','lineColor':'#64748b','fontSize':'14px'
}, 'flowchart':{'curve':'basis','padding':16}}}%%
flowchart LR
  classDef fact fill:#f97316,stroke:#ea580c,color:#fff,stroke-width:1px;
  classDef dim  fill:#0ea5e9,stroke:#0369a1,color:#fff,stroke-width:1px;

  DT["DIM_TEMPO\n(sk_tempo)\n• data_completa\n• ano/mês/dia\n• trimestre"]:::dim
  DP["DIM_PRODUTO\n(sk_produto)\n• descrição\n• categoria\n• tipo_produto"]:::dim
  DFN["DIM_FUNCIONARIO\n(sk_funcionario)\n• nome\n• cargo_atual\n• comissão_%"]:::dim
  DC["DIM_CLIENTE\n(sk_cliente)\n• nome\n• possui_login\n• cliente_antigo"]:::dim
  DL["DIM_LOCALIDADE\n(sk_localidade)\n• tipo_loja\n• cidade/estado\n• eh_matriz"]:::dim

  FV["FATO_VENDAS\n(sk_venda)\n\nMétricas:\n• quantidade\n• valor_unitário\n• valor_total\n• valor_desconto\n• valor_comissão"]:::fact

  DT --> FV
  DP --> FV
  DFN --> FV
  DC --> FV
  DL --> FV

  %% layout helpers
  DT ---| | DP
  DC ---| | DL
```

---

## 🧩 ERD com cardinalidades e atributos

```mermaid
erDiagram
  DIM_TEMPO ||--o{ FATO_VENDAS : "sk_tempo"
  DIM_PRODUTO ||--o{ FATO_VENDAS : "sk_produto"
  DIM_FUNCIONARIO ||--o{ FATO_VENDAS : "sk_funcionario"
  DIM_CLIENTE ||--o{ FATO_VENDAS : "sk_cliente"
  DIM_LOCALIDADE ||--o{ FATO_VENDAS : "sk_localidade"

  DIM_TEMPO {
    int      sk_tempo PK
    date     data_completa
    int      ano
    int      trimestre
    int      mes
    string   nome_mes
    int      semana_ano
    int      dia
    int      dia_semana
    string   nome_dia_semana
    boolean  eh_fim_semana
    boolean  eh_feriado
  }

  DIM_PRODUTO {
    int      sk_produto PK
    int      nk_produto
    string   descricao_produto
    string   categoria
    string   tipo_produto
    decimal  valor_sugerido
    date     data_inicio
    date     data_fim
    boolean  versao_atual
  }

  DIM_FUNCIONARIO {
    int      sk_funcionario PK
    int      nk_matricula
    string   nome_funcionario
    string   cargo_atual
    string   status
    date     data_contratacao
    date     data_demissao
    decimal  salario_base
    decimal  comissao_percentual
    date     data_inicio
    date     data_fim
    boolean  versao_atual
  }

  DIM_CLIENTE {
    int      sk_cliente PK
    long     nk_cpf
    string   nome_cliente
    string   telefone_residencial
    string   telefone_celular
    boolean  possui_login
    date     data_cadastro_login
    boolean  cliente_antigo
    date     data_inicio
    date     data_fim
    boolean  versao_atual
  }

  DIM_LOCALIDADE {
    int      sk_localidade PK
    int      nk_loja
    string   tipo_loja
    string   cnpj
    string   cidade
    string   estado
    string   nome_estado
    string   bairro
    string   regiao
    boolean  eh_matriz
    date     data_inicio
    date     data_fim
    boolean  versao_atual
  }

  FATO_VENDAS {
    int      sk_venda PK
    int      sk_tempo FK
    int      sk_produto FK
    int      sk_funcionario FK
    int      sk_cliente FK
    int      sk_localidade FK
    int      quantidade_vendida
    decimal  valor_unitario
    decimal  valor_total
    decimal  valor_desconto
    decimal  valor_comissao
    int      numero_atendimento
    timestamp data_carga
  }
```

---

## 🔄 Fluxo ETL (origem → staging → DW)

```mermaid

flowchart LR
  classDef src fill:#dbeafe,stroke:#60a5fa,color:#0b1320;
  classDef stg fill:#e5e7eb,stroke:#6b7280,color:#111827;
  classDef dw  fill:#dcfce7,stroke:#22c55e,color:#052e16;

  subgraph ORIGEM["CAMADA DE ORIGEM\n(PostgreSQL: varejo_bdiii)"]
    O1["VENDA\n tb010_012_vendas"]:::src
    O2["PRODUTOS\n tb012_produtos / tb013_categorias"]:::src
    O3["FUNCIONÁRIOS\n tb005 / tb006"]:::src
    O4["CLIENTES & LOGINS\n tb010 / tb011"]:::src
    O5["LOJAS & ENDEREÇOS\n tb004 / tb003"]:::src
  end

  subgraph STAGING["STAGING (staging_varejo)"]
    S1["stg_vendas\n• validação • limpeza • flags"]:::stg
    S2["stg_produtos\n• join categorias • tipo"]:::stg
    S3["stg_funcionarios\n• cargo atual • comissão"]:::stg
    S4["stg_clientes\n• flag login • antigo"]:::stg
    S5["stg_localidades\n• endereço • matriz/filial"]:::stg
  end

  subgraph DW["DATA WAREHOUSE (dw_varejo)"]
    D1["dim_tempo"]:::dw
    D2["dim_produto"]:::dw
    D3["dim_funcionario"]:::dw
    D4["dim_cliente"]:::dw
    D5["dim_localidade"]:::dw
    DF["fato_vendas\ncarga diária"]:::dw
  end

  O1 --> S1 --> DF
  O2 --> S2 --> D2 --> DF
  O3 --> S3 --> D3 --> DF
  O4 --> S4 --> D4 --> DF
  O5 --> S5 --> D5 --> DF
  D1 -. lookup .-> DF
```

---

## 📚 Estrutura das tabelas

<details>
<summary><b>DIM_TEMPO</b></summary>

| Campo | Tipo | Observação |
|---|---|---|
| sk_tempo | INTEGER | PK (surrogate) |
| data_completa | DATE | not null |
| ano, trimestre, mes, semana_ano, dia, dia_semana | INTEGER | hierarquia de tempo |
| nome_mes, nome_dia_semana | VARCHAR(20) | textos |
| eh_fim_semana, eh_feriado | BOOLEAN | flags |
</details>

<details>
<summary><b>DIM_PRODUTO</b></summary>

| Campo | Tipo | Observação |
|---|---|---|
| sk_produto | INTEGER | PK |
| nk_produto | INTEGER | NK |
| descricao_produto, categoria, tipo_produto | VARCHAR | not null |
| valor_sugerido | NUMERIC(10,2) |  |
| data_inicio, data_fim | DATE | SCD2 |
| versao_atual | BOOLEAN | default true |
</details>

<details>
<summary><b>DIM_FUNCIONARIO</b></summary>

| Campo | Tipo | Observação |
|---|---|---|
| sk_funcionario | INTEGER | PK |
| nk_matricula | INTEGER | NK |
| nome_funcionario, cargo_atual | VARCHAR |  |
| status | VARCHAR(20) | Ativo/Inativo |
| data_contratacao, data_demissao | DATE |  |
| salario_base, comissao_percentual | NUMERIC |  |
| data_inicio, data_fim, versao_atual | DATE/BOOLEAN | SCD2 |
</details>

<details>
<summary><b>DIM_CLIENTE</b></summary>

| Campo | Tipo | Observação |
|---|---|---|
| sk_cliente | INTEGER | PK |
| nk_cpf | BIGINT | NK |
| nome + telefones | VARCHAR |  |
| possui_login, cliente_antigo | BOOLEAN |  |
| data_cadastro_login | DATE | se houver login |
| data_inicio, data_fim, versao_atual | DATE/BOOLEAN | SCD2 |
</details>

<details>
<summary><b>DIM_LOCALIDADE</b></summary>

| Campo | Tipo | Observação |
|---|---|---|
| sk_localidade | INTEGER | PK |
| nk_loja | INTEGER | NK |
| tipo_loja, cnpj, cidade, estado, nome_estado, bairro, regiao | VARCHAR |  |
| eh_matriz | BOOLEAN |  |
| data_inicio, data_fim, versao_atual | DATE/BOOLEAN | SCD2 |
</details>

<details>
<summary><b>FATO_VENDAS</b></summary>

| Campo | Tipo | Observação |
|---|---|---|
| sk_venda | SERIAL | PK |
| sk_tempo / sk_produto / sk_funcionario / sk_cliente / sk_localidade | INTEGER | FKs |
| quantidade_vendida, valor_unitario, valor_total, valor_desconto, valor_comissao | NUMERIC | métricas |
| numero_atendimento | INTEGER |  |
| data_carga | TIMESTAMP | default now() |
</details>

---
