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

  DT["DIM_TEMPO\n(sk_tempo)\n• data_completa\n• ano/mês/trimestre\n• dia_semana"]:::dim
  DP["DIM_PRODUTO\n(sk_produto)\n• descrição\n• categoria\n• tipo_produto"]:::dim
  DFN["DIM_FUNCIONARIO\n(sk_funcionario)\n• nome\n• cargo_atual"]:::dim
  DC["DIM_CLIENTE\n(sk_cliente)\n• nome\n• cpf"]:::dim
  DL["DIM_LOCALIDADE\n(sk_localidade)\n• tipo_loja\n• regiao"]:::dim

  FV["FATO_VENDAS\n(sk_venda)\n\nMétricas:\n• quantidade_vendida\n• valor_total\n• numero_atendimento"]:::fact

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
    int      dia_semana
    string   nome_dia_semana
  }

  DIM_PRODUTO {
    int      sk_produto PK
    int      nk_produto
    string   descricao_produto
    string   categoria
    string   tipo_produto
  }

  DIM_FUNCIONARIO {
    int      sk_funcionario PK
    int      nk_matricula
    string   nome_funcionario
    string   cargo_atual
  }

  DIM_CLIENTE {
    int      sk_cliente PK
    long     nk_cpf
    string   nome_cliente
  }

  DIM_LOCALIDADE {
    int      sk_localidade PK
    int      nk_loja
    string   tipo_loja
    string   regiao
  }

  FATO_VENDAS {
    int      sk_venda PK
    int      sk_tempo FK
    int      sk_produto FK
    int      sk_funcionario FK
    int      sk_cliente FK
    int      sk_localidade FK
    int      quantidade_vendida
    decimal  valor_total
    int      numero_atendimento
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
    O1["VENDAS\n tb010_012_vendas"]:::src
    O2["PRODUTOS\n tb012_produtos / tb013_categorias"]:::src
    O3["FUNCIONÁRIOS\n tb005 / tb006"]:::src
    O4["CLIENTES\n tb010_clientes"]:::src
    O5["LOJAS & ENDEREÇOS\n tb004 / tb003 / tb002 / tb001"]:::src
  end

  subgraph STAGING["STAGING (staging_varejo)"]
    S1["stg_vendas\n• valor_total calculado"]:::stg
    S2["stg_produtos\n• tipo_produto derivado"]:::stg
    S3["stg_funcionarios\n• cargo atual"]:::stg
    S4["stg_clientes\n• dados básicos"]:::stg
    S5["stg_localidades\n• região calculada"]:::stg
  end

  subgraph DW["DATA WAREHOUSE (dw_varejo)"]
    D1["dim_tempo"]:::dw
    D2["dim_produto"]:::dw
    D3["dim_funcionario"]:::dw
    D4["dim_cliente"]:::dw
    D5["dim_localidade"]:::dw
    DF["fato_vendas\ncarga única"]:::dw
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
| sk_tempo | SERIAL | PK (surrogate) |
| data_completa | DATE | not null, unique |
| ano | INTEGER | not null |
| trimestre | INTEGER | not null (1-4) |
| mes | INTEGER | not null (1-12) |
| nome_mes | VARCHAR(20) | not null |
| dia_semana | INTEGER | not null (0-6, 0=Domingo) |
| nome_dia_semana | VARCHAR(20) | not null |
</details>

<details>
<summary><b>DIM_PRODUTO</b></summary>

| Campo | Tipo | Observação |
|---|---|---|
| sk_produto | SERIAL | PK |
| nk_produto | INTEGER | NK - código original |
| descricao_produto | VARCHAR(255) | not null |
| categoria | VARCHAR(255) | not null |
| tipo_produto | VARCHAR(100) | not null - derivado da categoria |
</details>

<details>
<summary><b>DIM_FUNCIONARIO</b></summary>

| Campo | Tipo | Observação |
|---|---|---|
| sk_funcionario | SERIAL | PK |
| nk_matricula | INTEGER | NK - matrícula |
| nome_funcionario | VARCHAR(255) | not null |
| cargo_atual | VARCHAR(255) | not null |
</details>

<details>
<summary><b>DIM_CLIENTE</b></summary>

| Campo | Tipo | Observação |
|---|---|---|
| sk_cliente | SERIAL | PK |
| nk_cpf | BIGINT | NK - CPF |
| nome_cliente | VARCHAR(255) | not null |
</details>

<details>
<summary><b>DIM_LOCALIDADE</b></summary>

| Campo | Tipo | Observação |
|---|---|---|
| sk_localidade | SERIAL | PK |
| nk_loja | INTEGER | NK - código da loja |
| tipo_loja | VARCHAR(50) | not null - Matriz/Filial |
| regiao | VARCHAR(50) | not null - Norte/Sul/Sudeste/etc |
</details>

<details>
<summary><b>FATO_VENDAS</b></summary>

| Campo | Tipo | Observação |
|---|---|---|
| sk_venda | SERIAL | PK |
| sk_tempo | INTEGER | FK para dim_tempo |
| sk_produto | INTEGER | FK para dim_produto |
| sk_funcionario | INTEGER | FK para dim_funcionario |
| sk_cliente | INTEGER | FK para dim_cliente |
| sk_localidade | INTEGER | FK para dim_localidade |
| quantidade_vendida | INTEGER | not null |
| valor_total | NUMERIC(10,2) | not null - calculado |
| numero_atendimento | INTEGER | not null |
</details>

---
