-- Arquivo convertido para PostgreSQL
-- Conversões aplicadas:
-- 1. IDENTITY(1,1) -> SERIAL
-- 2. NUMERIC(10) -> INTEGER (para códigos)
-- 3. NUMERIC(15) -> BIGINT (para CPF)
-- 4. datetime -> TIMESTAMP
-- 5. Remoção de ASC das chaves primárias
-- 6. Ajuste da sintaxe de INSERT
-- 7. Remoção de referências ao banco varejo_bdiii e esquema dbo

CREATE TABLE tb001_uf
( 
	tb001_sigla_uf       VARCHAR(2)  NOT NULL ,
	tb001_nome_estado    VARCHAR(255)  NOT NULL 
);

ALTER TABLE tb001_uf
	ADD CONSTRAINT XPKtb001_uf PRIMARY KEY (tb001_sigla_uf);

CREATE TABLE tb002_cidades
( 
	tb002_cod_cidade     SERIAL ,
	tb001_sigla_uf       VARCHAR(2)  NOT NULL ,
	tb002_nome_cidade    VARCHAR(255)  NOT NULL 
);

ALTER TABLE tb002_cidades
	ADD CONSTRAINT XPKtb002_cidades PRIMARY KEY (tb002_cod_cidade,tb001_sigla_uf);

CREATE TABLE tb003_enderecos
( 
	tb003_cod_endereco   SERIAL ,
	tb001_sigla_uf       VARCHAR(2)  NOT NULL ,
	tb002_cod_cidade     INTEGER  NOT NULL ,
	tb003_nome_rua       VARCHAR(255)  NOT NULL ,
	tb003_numero_rua     VARCHAR(10)  NOT NULL ,
	tb003_complemento    VARCHAR(255)  NULL ,
	tb003_ponto_referencia VARCHAR(255)  NULL ,
	tb003_bairro         VARCHAR(255)  NOT NULL ,
	tb003_CEP            VARCHAR(15)  NOT NULL 
);

ALTER TABLE tb003_enderecos
	ADD CONSTRAINT XPKtb003_enderecos PRIMARY KEY (tb003_cod_endereco);

CREATE TABLE tb004_lojas
( 
	tb004_cod_loja       SERIAL ,
	tb003_cod_endereco   INTEGER  NULL ,
	tb004_matriz         INTEGER  NULL ,
	tb004_cnpj_loja      VARCHAR(20)  NOT NULL ,
	tb004_inscricao_estadual VARCHAR(20)  NULL 
);

ALTER TABLE tb004_lojas
	ADD CONSTRAINT XPKtb004_lojas PRIMARY KEY (tb004_cod_loja);

CREATE TABLE tb005_006_funcionarios_cargos
( 
	tb005_matricula      INTEGER  NOT NULL ,
	tb006_cod_cargo      INTEGER  NOT NULL ,
	tb005_006_valor_cargo NUMERIC(10,2)  NOT NULL ,
	tb005_006_perc_comissao_cargo NUMERIC(5,2)  NOT NULL ,
	tb005_006_data_promocao TIMESTAMP  NOT NULL 
);

ALTER TABLE tb005_006_funcionarios_cargos
	ADD CONSTRAINT XPKtb005_006_funcionarios_cargos PRIMARY KEY (tb005_matricula,tb006_cod_cargo);

CREATE TABLE tb005_funcionarios
( 
	tb005_matricula      SERIAL ,
	tb004_cod_loja       INTEGER  NOT NULL ,
	tb003_cod_endereco   INTEGER  NOT NULL ,
	tb005_nome_completo  VARCHAR(255)  NOT NULL ,
	tb005_data_nascimento TIMESTAMP  NOT NULL ,
	tb005_CPF            VARCHAR(17)  NOT NULL ,
	tb005_RG             VARCHAR(15)  NOT NULL ,
	tb005_status         VARCHAR(20)  NOT NULL ,
	tb005_data_contratacao TIMESTAMP  NOT NULL ,
	tb005_data_demissao  TIMESTAMP  NULL 
);

ALTER TABLE tb005_funcionarios
	ADD CONSTRAINT XPKtb005_funcionarios PRIMARY KEY (tb005_matricula);

CREATE TABLE tb006_cargos
( 
	tb006_cod_cargo      SERIAL ,
	tb006_nome_cargo     VARCHAR(255)  NOT NULL 
);

ALTER TABLE tb006_cargos
	ADD CONSTRAINT XPKtb006_cargos PRIMARY KEY (tb006_cod_cargo);

CREATE TABLE tb010_012_vendas
( 
	tb010_012_cod_venda  SERIAL,
	tb010_cpf            BIGINT  NOT NULL ,
	tb012_cod_produto    INTEGER  NOT NULL ,
	tb005_matricula      INTEGER  NOT NULL ,
	tb010_012_data       TIMESTAMP  NOT NULL ,
	tb010_012_quantidade INTEGER  NOT NULL ,
	tb010_012_valor_unitario NUMERIC(12,4)  NOT NULL
);

ALTER TABLE tb010_012_vendas
	ADD CONSTRAINT XPKtb010_012_vendas PRIMARY KEY (tb010_012_cod_venda,tb005_matricula,tb010_cpf,tb012_cod_produto);

CREATE TABLE tb010_clientes
( 
	tb010_cpf            BIGINT  NOT NULL ,
	tb010_nome           VARCHAR(255)  NOT NULL ,
	tb010_fone_residencial VARCHAR(255)  NOT NULL ,
	tb010_fone_celular   VARCHAR(255)  NULL 
);

ALTER TABLE tb010_clientes
	ADD CONSTRAINT XPKtb010_clientes PRIMARY KEY (tb010_cpf);

CREATE TABLE tb010_clientes_antigos
( 
	tb010_cpf            BIGINT  NOT NULL ,
	tb010_nome           VARCHAR(255)  NULL 
);

ALTER TABLE tb010_clientes_antigos
	ADD CONSTRAINT XPKtb010_clientes_antigos PRIMARY KEY (tb010_cpf);

CREATE TABLE tb011_logins
( 
	tb011_logins         VARCHAR(255)  NOT NULL ,
	tb010_cpf            BIGINT  NOT NULL ,
	tb011_senha          VARCHAR(255)  NOT NULL ,
	tb011_data_cadastro  TIMESTAMP  NULL 
);

ALTER TABLE tb011_logins
	ADD CONSTRAINT XPKtb011_logins PRIMARY KEY (tb011_logins);

CREATE TABLE tb012_017_compras
( 
	tb012_017_cod_compra SERIAL ,
	tb012_cod_produto    INTEGER  NOT NULL ,
	tb017_cod_fornecedor INTEGER  NOT NULL ,
	tb012_017_data       TIMESTAMP  NULL ,
	tb012_017_quantidade INTEGER  NULL ,
	tb012_017_valor_unitario NUMERIC(12,2)  NULL
);

ALTER TABLE tb012_017_compras
	ADD CONSTRAINT XPKtb017_compras PRIMARY KEY (tb012_017_cod_compra,tb012_cod_produto,tb017_cod_fornecedor);

CREATE TABLE tb012_produtos
( 
	tb012_cod_produto    INTEGER  NOT NULL ,
	tb013_cod_categoria  INTEGER  NOT NULL ,
	tb012_descricao      VARCHAR(255)  NOT NULL 
);

ALTER TABLE tb012_produtos
	ADD CONSTRAINT XPKtb012_produtos PRIMARY KEY (tb012_cod_produto);

CREATE TABLE tb013_categorias
( 
	tb013_cod_categoria  SERIAL ,
	tb013_descricao      VARCHAR(255)  NOT NULL 
);

ALTER TABLE tb013_categorias
	ADD CONSTRAINT XPKtb013_categorias PRIMARY KEY (tb013_cod_categoria);

CREATE TABLE tb014_prd_alimentos
( 
	tb014_cod_prd_alimentos SERIAL ,
	tb012_cod_produto    INTEGER  NOT NULL ,
	tb014_detalhamento   VARCHAR(255)  NOT NULL ,
	tb014_unidade_medida VARCHAR(255)  NOT NULL ,
	tb014_num_lote       VARCHAR(255)  NULL ,
	tb014_data_vencimento TIMESTAMP  NULL ,
	tb014_valor_sugerido NUMERIC(10,2)  NULL 
);

ALTER TABLE tb014_prd_alimentos
	ADD CONSTRAINT XPKtb014_prd_alimentos PRIMARY KEY (tb014_cod_prd_alimentos,tb012_cod_produto);

CREATE TABLE tb015_prd_eletros
( 
	tb015_cod_prd_eletro SERIAL ,
	tb012_cod_produto    INTEGER  NOT NULL ,
	tb015_detalhamento   VARCHAR(255)  NOT NULL ,
	tb015_tensao         VARCHAR(255)  NULL ,
	tb015_nivel_consumo_procel CHAR(1)  NULL ,
	tb015_valor_sugerido NUMERIC(10,2)  NULL 
);

ALTER TABLE tb015_prd_eletros
	ADD CONSTRAINT XPKtb015_prd_tvs PRIMARY KEY (tb015_cod_prd_eletro,tb012_cod_produto);

CREATE TABLE tb016_prd_vestuarios
( 
	tb016_cod_prd_vestuario SERIAL ,
	tb012_cod_produto    INTEGER  NOT NULL ,
	tb016_detalhamento   VARCHAR(255)  NOT NULL ,
	tb016_sexo           CHAR(1)  NOT NULL ,
	tb016_tamanho        VARCHAR(255)  NULL ,
	tb016_numeracao      INTEGER  NULL ,
	tb016_valor_sugerido NUMERIC(10,2)  NULL 
);

ALTER TABLE tb016_prd_vestuarios
	ADD CONSTRAINT XPKtb016_refrigeradores PRIMARY KEY (tb016_cod_prd_vestuario,tb012_cod_produto);

CREATE TABLE tb017_fornecedores
( 
	tb017_cod_fornecedor SERIAL ,
	tb017_razao_social   VARCHAR(255)  NULL ,
	tb017_nome_fantasia  VARCHAR(255)  NULL ,
	tb017_fone           VARCHAR(15)  NULL ,
	tb003_cod_endereco   INTEGER  NULL 
);

ALTER TABLE tb017_fornecedores
	ADD CONSTRAINT XPKtb017_fornecedor PRIMARY KEY (tb017_cod_fornecedor);

CREATE TABLE tb999_log
( 
	tb999_cod_log        SERIAL ,
	tb099_objeto         VARCHAR(100)  NOT NULL ,
	tb999_dml            VARCHAR(25)  NOT NULL ,
	tb999_data           TIMESTAMP  NOT NULL 
);

ALTER TABLE tb999_log
	ADD CONSTRAINT XPKtb999_log PRIMARY KEY (tb999_cod_log);

-- FOREIGN KEYS
ALTER TABLE tb002_cidades
	ADD CONSTRAINT CONST_UF_CIDADE FOREIGN KEY (tb001_sigla_uf) REFERENCES tb001_uf(tb001_sigla_uf)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION;

ALTER TABLE tb003_enderecos
	ADD CONSTRAINT CONST_CIDADE_END FOREIGN KEY (tb002_cod_cidade,tb001_sigla_uf) REFERENCES tb002_cidades(tb002_cod_cidade,tb001_sigla_uf)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION;

ALTER TABLE tb004_lojas
	ADD CONSTRAINT CONST_END_LOJAS FOREIGN KEY (tb003_cod_endereco) REFERENCES tb003_enderecos(tb003_cod_endereco)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION;

ALTER TABLE tb005_006_funcionarios_cargos
	ADD CONSTRAINT CONST_FUNC_FUNCCARGO FOREIGN KEY (tb005_matricula) REFERENCES tb005_funcionarios(tb005_matricula)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION;

ALTER TABLE tb005_006_funcionarios_cargos
	ADD CONSTRAINT CONST_CARGO_FUNCCARGO FOREIGN KEY (tb006_cod_cargo) REFERENCES tb006_cargos(tb006_cod_cargo)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION;

ALTER TABLE tb005_funcionarios
	ADD CONSTRAINT CONST_END_FUNC FOREIGN KEY (tb003_cod_endereco) REFERENCES tb003_enderecos(tb003_cod_endereco)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION;

ALTER TABLE tb005_funcionarios
	ADD CONSTRAINT CONST_LOJAS_FUNC FOREIGN KEY (tb004_cod_loja) REFERENCES tb004_lojas(tb004_cod_loja)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION;

ALTER TABLE tb010_012_vendas
	ADD CONSTRAINT CONST_FUNC_VENDAS FOREIGN KEY (tb005_matricula) REFERENCES tb005_funcionarios(tb005_matricula)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION;

ALTER TABLE tb010_012_vendas
	ADD CONSTRAINT CONST_CLI_VENDAS FOREIGN KEY (tb010_cpf) REFERENCES tb010_clientes(tb010_cpf)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION;

ALTER TABLE tb010_012_vendas
	ADD CONSTRAINT CONST_PRD_VENDAS FOREIGN KEY (tb012_cod_produto) REFERENCES tb012_produtos(tb012_cod_produto)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION;

ALTER TABLE tb011_logins
	ADD CONSTRAINT CONST_CLI_LOGIN FOREIGN KEY (tb010_cpf) REFERENCES tb010_clientes(tb010_cpf)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION;

ALTER TABLE tb012_017_compras
	ADD CONSTRAINT CONST_PRD_COMPRAS FOREIGN KEY (tb012_cod_produto) REFERENCES tb012_produtos(tb012_cod_produto)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION;

ALTER TABLE tb012_017_compras
	ADD CONSTRAINT CONST_FORN_COMPRAS FOREIGN KEY (tb017_cod_fornecedor) REFERENCES tb017_fornecedores(tb017_cod_fornecedor)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION;

ALTER TABLE tb012_produtos
	ADD CONSTRAINT CONST_CAT_PRD FOREIGN KEY (tb013_cod_categoria) REFERENCES tb013_categorias(tb013_cod_categoria)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION;

ALTER TABLE tb014_prd_alimentos
	ADD CONSTRAINT CONST_PRD_ALIM FOREIGN KEY (tb012_cod_produto) REFERENCES tb012_produtos(tb012_cod_produto)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION;

ALTER TABLE tb015_prd_eletros
	ADD CONSTRAINT CONST_PRD_ELET FOREIGN KEY (tb012_cod_produto) REFERENCES tb012_produtos(tb012_cod_produto)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION;

ALTER TABLE tb016_prd_vestuarios
	ADD CONSTRAINT CONST_PRD_VEST FOREIGN KEY (tb012_cod_produto) REFERENCES tb012_produtos(tb012_cod_produto)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION;

ALTER TABLE tb017_fornecedores
	ADD CONSTRAINT CONST_END_FORN FOREIGN KEY (tb003_cod_endereco) REFERENCES tb003_enderecos(tb003_cod_endereco)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION;

-- DADOS

-- tb001_uf
DELETE FROM tb001_uf;

INSERT INTO tb001_uf VALUES('AC', 'Acre');
INSERT INTO tb001_uf VALUES('AL', 'Alagoas');
INSERT INTO tb001_uf VALUES('AP', 'Amapá');
INSERT INTO tb001_uf VALUES('AM', 'Amazonas');
INSERT INTO tb001_uf VALUES('BA', 'Bahia');
INSERT INTO tb001_uf VALUES('CE', 'Ceará');
INSERT INTO tb001_uf VALUES('DF', 'Distrito Federal');
INSERT INTO tb001_uf VALUES('ES', 'Espírito Santo');
INSERT INTO tb001_uf VALUES('GO', 'Goiás'); -- Corrigi o valor em branco
INSERT INTO tb001_uf VALUES('MA', 'Maranhão');
INSERT INTO tb001_uf VALUES('MT', 'Mato Grosso');
INSERT INTO tb001_uf VALUES('MS', 'Mato Grosso do Sul');
INSERT INTO tb001_uf VALUES('MG', 'Minas Gerais');
INSERT INTO tb001_uf VALUES('PA', 'Pará');
INSERT INTO tb001_uf VALUES('PB', 'Paraíba');
INSERT INTO tb001_uf VALUES('PR', 'Paraná');
INSERT INTO tb001_uf VALUES('PE', 'Pernambuco');
INSERT INTO tb001_uf VALUES('PI', 'Piauí');
INSERT INTO tb001_uf VALUES('RR', 'Roraima');
INSERT INTO tb001_uf VALUES('RO', 'Rondônia');
INSERT INTO tb001_uf VALUES('RJ', 'Rio de Janeiro');
INSERT INTO tb001_uf VALUES('RN', 'Rio Grande do Norte');
INSERT INTO tb001_uf VALUES('RS', 'Rio Grande do Sul');
INSERT INTO tb001_uf VALUES('SC', 'Santa Catarina');
INSERT INTO tb001_uf VALUES('SP', 'São Paulo');
INSERT INTO tb001_uf VALUES('SE', 'Sergipe');
INSERT INTO tb001_uf VALUES('TO', 'Tocantins');

-- tb002_cidades
DELETE FROM tb002_cidades;

INSERT INTO tb002_cidades VALUES(DEFAULT, 'AC', 'Rio Branco');
INSERT INTO tb002_cidades VALUES(DEFAULT, 'AL', 'Maceió');
INSERT INTO tb002_cidades VALUES(DEFAULT, 'AP', 'Macapá');
INSERT INTO tb002_cidades VALUES(DEFAULT, 'AM', 'Manaus');
INSERT INTO tb002_cidades VALUES(DEFAULT, 'BA', 'Salvador');
INSERT INTO tb002_cidades VALUES(DEFAULT, 'CE', 'Fortaleza');
INSERT INTO tb002_cidades VALUES(DEFAULT, 'DF', 'Brasília');
INSERT INTO tb002_cidades VALUES(DEFAULT, 'ES', 'Vitória');
INSERT INTO tb002_cidades VALUES(DEFAULT, 'GO', 'Goiânia'); -- Corrigi o valor em branco
INSERT INTO tb002_cidades VALUES(DEFAULT, 'MA', 'São Luís');
INSERT INTO tb002_cidades VALUES(DEFAULT, 'MT', 'Cuiabá');
INSERT INTO tb002_cidades VALUES(DEFAULT, 'MS', 'Campo Grande');
INSERT INTO tb002_cidades VALUES(DEFAULT, 'MG', 'Belo Horizonte');
INSERT INTO tb002_cidades VALUES(DEFAULT, 'PA', 'Belém');
INSERT INTO tb002_cidades VALUES(DEFAULT, 'PB', 'João Pessoa');
INSERT INTO tb002_cidades VALUES(DEFAULT, 'PR', 'Curitiba');
INSERT INTO tb002_cidades VALUES(DEFAULT, 'PE', 'Recife');
INSERT INTO tb002_cidades VALUES(DEFAULT, 'PI', 'Teresina');
INSERT INTO tb002_cidades VALUES(DEFAULT, 'RR', 'Boa Vista');
INSERT INTO tb002_cidades VALUES(DEFAULT, 'RO', 'Porto Velho');
INSERT INTO tb002_cidades VALUES(DEFAULT, 'RJ', 'Rio de Janeiro');
INSERT INTO tb002_cidades VALUES(DEFAULT, 'RN', 'Natal');
INSERT INTO tb002_cidades VALUES(DEFAULT, 'RS', 'Porto Alegre');
INSERT INTO tb002_cidades VALUES(DEFAULT, 'SC', 'Florianópolis');
INSERT INTO tb002_cidades VALUES(DEFAULT, 'SP', 'São Paulo');
INSERT INTO tb002_cidades VALUES(DEFAULT, 'SE', 'Aracaju');
INSERT INTO tb002_cidades VALUES(DEFAULT, 'TO', 'Palmas');

-- tb003_enderecos
DELETE FROM tb003_enderecos;

INSERT INTO tb003_enderecos VALUES(DEFAULT, 'MG', 13, 'Av. Brasil', '1.234',null,null, 'Centro', '80.345-432');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'MG', 13, 'Av. Brasil', '234',null,null, 'Centro', '80.345-533');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'MG', 13, 'Av. Brasil', '43', 'Bl 08 AP 30',null, 'Rebouças', '82.345-434');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'MG', 13, 'Av. 1º de Maio', '34',null,null, 'Pampulha', '81.345-435');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'PR', 16, 'Av. Getúlio Vargas', '4.324',null,null, 'Água Verde', '80.345-634');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'PR', 16, 'Rua Brigadeiro Franco', '23',null,null, 'Centro', '80.345-735');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'PR', 16, 'Rua Brigadeiro Franco', '54', 'Casa 02',null, 'Centro', '82.345-435');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'PR', 16, 'Rua Brigadeiro Franco', '345', 'Casa 20', 'Próx. Shopping Curitiba', 'Centro', '81.345-436');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'PR', 16, 'Av. Iguaçú', '11',null,null, 'Rebouças', '80.345-836');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'PR', 16, 'Av. Manoel Ribas', '876',null,null, 'Santa Felicidade', '80.345-937');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'MG', 13, 'Av. Brasil', '467',null,null, 'Centro', '80.345-634');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'MG', 13, 'Av. Brasil', '422',null,null, 'Centro', '80.345-735');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'MG', 13, 'Av. Brasil', '376', 'Bl 08 AP 31',null, 'Rebouças', '82.345-435');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'MG', 13, 'Av. 1º de Maio', '331',null,null, 'Pampulha', '81.345-436');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'PR', 16, 'Av. Getúlio Vargas', '285',null,null, 'Água Verde', '80.345-836');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'PR', 16, 'Rua Brigadeiro Franco', '240',null,null, 'Centro', '80.345-937');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'PR', 16, 'Rua Brigadeiro Franco', '194', 'Casa 38',null, 'Centro', '82.345-436');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'PR', 16, 'Rua Brigadeiro Franco', '149', 'Casa 56', 'Próx. Vicente Machado', 'Centro', '81.345-437');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'PR', 16, 'Av. Iguaçú', '103',null,null, 'Rebouças', '80.345-937');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'PR', 16, 'Av. Manoel Ribas', '331',null,null, 'Santa Felicidade', '82.345-436');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'MG', 13, 'Av. Brasil', '285',null,null, 'Centro', '80.345-836');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'MG', 13, 'Av. Brasil', '240',null,null, 'Centro', '80.345-937');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'MG', 13, 'Av. Brasil', '331', 'Bl 08 AP 32',null, 'Rebouças', '82.345-436');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'MG', 13, 'Av. 1º de Maio', '285',null,null, 'Pampulha', '81.345-437');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'PR', 16, 'Av. Getúlio Vargas', '240',null,null, 'Água Verde', '80.345-038');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'RS', 23, 'Av. Joaquim Lima', '43',null,null, 'Centro', '80.345-634');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'RS', 23, 'Av. Joaquim Lima', '34',null,null, 'Centro', '80.345-735');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'RS', 23, 'Av. Joaquim Lima', '4.324',null,null, 'Rebouças', '82.345-435');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'RS', 23, 'Av. Joaquim Lima', '23', 'Casa 01',null, 'Rebouças', '81.345-436');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'RS', 23, 'Av. Joaquim Lima', '54', 'Casa 23',null, 'Centro', '80.345-836');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'RS', 23, 'Av. Joaquim Lima', '345', 'Casa 99',null, 'Centro', '80.345-937');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'RS', 23, 'Av. Das Nações', '11',null,null, 'Ladeira', '82.345-436');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'RS', 23, 'Av. Das Nações', '876',null,null, 'Ladeira', '81.345-437');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'RS', 23, 'Av. Das Nações', '467',null,null, 'Ladeira', '80.345-836');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'RS', 23, 'Av. Das Nações', '422',null,null, 'Ladeira', '80.345-937');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'RS', 23, 'Av. Das Nações', '376',null,null, 'Ladeira', '80.345-634');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'RS', 23, 'Av. Das Nações', '331',null,null, 'Ladeira', '80.345-735');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'SP', 25, 'Av. Das Nações', '285',null,null, 'Ladeira', '82.345-436');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'SP', 25, 'Av. Das Nações', '240',null,null, 'Ladeira', '81.345-437');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'SP', 25, 'Av. Das Nações', '34',null,null, 'Ladeira', '80.345-156');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'SP', 25, 'Av. Paulista', '4.324',null,null, 'Centro', '80.345-199');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'SP', 25, 'Av. Washington Luiz', '23',null,null, 'Moema', '82.345-437');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'SP', 25, 'Av. Washington Luiz', '54',null,null, 'Moema', '81.345-438');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'SP', 25, 'Av. Washington Luiz', '345',null,null, 'Moema', '80.345-103');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'SP', 25, 'Av. Washington Luiz', '11',null,null, 'Moema', '80.345-123');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'SP', 25, 'Av. Consolação', '34',null,null, 'Centro', '80.345-836');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'SP', 25, 'Av. Consolação', '4.324',null,null, 'Centro', '80.345-937');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'SP', 25, 'Av. Consolação', '23',null,null, 'Centro', '82.345-437');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'SP', 25, 'Av. Consolação', '54',null,null, 'Centro', '81.345-438');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'SP', 25, 'Av. Consolação', '345',null,null, 'Centro', '80.345-599');
INSERT INTO tb003_enderecos VALUES(DEFAULT, 'SP', 25, 'Av. Consolação', '11',null,null, 'Centro', '80.345-836');

-- tb004_lojas
DELETE FROM tb004_lojas;

INSERT INTO tb004_lojas VALUES(DEFAULT, 5,null, '99.555.000-0001/01', '234.655.765');
INSERT INTO tb004_lojas VALUES(DEFAULT, 1,1, '99.555.000-0001/02', '567.655.766');
INSERT INTO tb004_lojas VALUES(DEFAULT, 28,1, '99.555.000-0001/03', '888.655.767');
INSERT INTO tb004_lojas VALUES(DEFAULT, 41,null, '99.555.000-0001/04', '234.655.768');
INSERT INTO tb004_lojas VALUES(DEFAULT, 10,1, '99.555.000-0001/05', '234.567.769');

-- tb006_cargos
DELETE FROM tb006_cargos;

INSERT INTO tb006_cargos VALUES(DEFAULT, 'Diretor');
INSERT INTO tb006_cargos VALUES(DEFAULT, 'Gerente Regional');
INSERT INTO tb006_cargos VALUES(DEFAULT, 'Caixa');
INSERT INTO tb006_cargos VALUES(DEFAULT, 'Auxiliar Administrativo');
INSERT INTO tb006_cargos VALUES(DEFAULT, 'Vendedor Júnior');
INSERT INTO tb006_cargos VALUES(DEFAULT, 'Vendedor Pleno');
INSERT INTO tb006_cargos VALUES(DEFAULT, 'Vendedor Senior');
INSERT INTO tb006_cargos VALUES(DEFAULT, 'Motorista');
INSERT INTO tb006_cargos VALUES(DEFAULT, 'Recursos Humanos');
INSERT INTO tb006_cargos VALUES(DEFAULT, 'Contador');

-- tb005_funcionarios
DELETE FROM tb005_funcionarios;

INSERT INTO tb005_funcionarios VALUES(DEFAULT, 1, 8, 'Funcionário 01', '1975-01-01', '999.444.555-01', '543.765.234-8', 'Ativo', '2000-06-01',null);
INSERT INTO tb005_funcionarios VALUES(DEFAULT, 2, 2, 'Funcionário 02', '1978-02-03', '999.444.555-02', '543.765.234-9', 'Ativo', '2000-06-02',null);
INSERT INTO tb005_funcionarios VALUES(DEFAULT, 3,24, 'Funcionário 03', '1982-03-10', '999.444.555-03', '543.765.234-10', 'Ativo', '2000-06-03',null);
INSERT INTO tb005_funcionarios VALUES(DEFAULT, 4, 9, 'Funcionário 04', '1989-04-03', '999.444.555-04', '543.765.234-11', 'Ativo', '2000-06-04',null);
INSERT INTO tb005_funcionarios VALUES(DEFAULT, 5, 8, 'Funcionário 05', '1979-05-01', '999.444.555-05', '543.765.234-12', 'Inativo', '2000-06-05', '2009-01-01');
INSERT INTO tb005_funcionarios VALUES(DEFAULT, 1, 7, 'Funcionário 06', '1975-01-01', '999.444.555-06', '543.765.234-13', 'Ativo', '2000-06-06',null);
INSERT INTO tb005_funcionarios VALUES(DEFAULT, 2, 4, 'Funcionário 07', '1978-02-03', '999.444.555-07', '543.765.234-14', 'Ativo', '2000-06-07',null);
INSERT INTO tb005_funcionarios VALUES(DEFAULT, 3, 1, 'Funcionário 08', '1982-03-10', '999.444.555-08', '543.765.234-15', 'Ativo', '2000-06-08',null);
INSERT INTO tb005_funcionarios VALUES(DEFAULT, 4,28, 'Funcionário 09', '1989-04-03', '999.444.555-09', '543.765.234-16', 'Ativo', '2000-06-09',null);
INSERT INTO tb005_funcionarios VALUES(DEFAULT, 5, 9, 'Funcionário 10', '1979-05-01', '999.444.555-10', '543.765.234-17', 'Inativo', '2000-06-10', '2009-01-02');
INSERT INTO tb005_funcionarios VALUES(DEFAULT, 1, 8, 'Funcionário 11', '1975-01-01', '999.444.555-11', '543.765.234-18', 'Ativo', '2000-06-11',null);
INSERT INTO tb005_funcionarios VALUES(DEFAULT, 2, 5, 'Funcionário 12', '1978-02-03', '999.444.555-12', '543.765.234-19', 'Ativo', '2000-06-12',null);
INSERT INTO tb005_funcionarios VALUES(DEFAULT, 3, 2, 'Funcionário 13', '1982-03-10', '999.444.555-13', '543.765.234-20', 'Ativo', '2000-06-10',null);
INSERT INTO tb005_funcionarios VALUES(DEFAULT, 4, 9, 'Funcionário 14', '1989-04-03', '999.444.555-14', '543.765.234-21', 'Ativo', '2000-06-11',null);
INSERT INTO tb005_funcionarios VALUES(DEFAULT, 5,10, 'Funcionário 15', '1979-05-01', '999.444.555-15', '543.765.234-22', 'Inativo', '2000-06-12', '2009-01-03');
INSERT INTO tb005_funcionarios VALUES(DEFAULT, 1, 9, 'Funcionário 16', '1975-01-01', '999.444.555-16', '543.765.234-23', 'Ativo', '2000-06-12',null);
INSERT INTO tb005_funcionarios VALUES(DEFAULT, 1,15, 'Funcionário 17', '1978-02-03', '999.444.555-17', '543.765.234-24', 'Ativo', '2000-06-07',null);
INSERT INTO tb005_funcionarios VALUES(DEFAULT, 1, 9, 'Funcionário 18', '1982-03-10', '999.444.555-18', '543.765.234-25', 'Ativo', '2000-06-11',null);
INSERT INTO tb005_funcionarios VALUES(DEFAULT, 1,19, 'Funcionário 19', '1989-04-03', '999.444.555-19', '543.765.234-26', 'Ativo', '2000-06-10',null);
INSERT INTO tb005_funcionarios VALUES(DEFAULT, 1, 7, 'Funcionário 20', '1979-05-01', '999.444.555-20', '543.765.234-27', 'Inativo', '2000-06-02', '2008-01-04');
INSERT INTO tb005_funcionarios VALUES(DEFAULT, 1, 7, 'Funcionário 21', '1975-01-01', '999.444.555-21', '543.765.234-28', 'Ativo', '2000-06-02',null);
INSERT INTO tb005_funcionarios VALUES(DEFAULT, 2, 5, 'Funcionário 22', '1978-02-03', '999.444.555-22', '543.765.234-29', 'Ativo', '2000-06-02',null);
INSERT INTO tb005_funcionarios VALUES(DEFAULT, 3, 3, 'Funcionário 23', '1982-03-10', '999.444.555-23', '543.765.234-30', 'Ativo', '2000-06-03',null);
INSERT INTO tb005_funcionarios VALUES(DEFAULT, 3, 3, 'Funcionário 24', '1989-04-03', '999.444.555-24', '543.765.234-31', 'Ativo', '2000-06-04',null);
INSERT INTO tb005_funcionarios VALUES(DEFAULT, 3, 4, 'Funcionário 25', '1979-05-01', '999.444.555-25', '543.765.234-32', 'Inativo', '2000-06-05', '2005-01-05');
INSERT INTO tb005_funcionarios VALUES(DEFAULT, 3, 5, 'Funcionário 26', '1975-01-01', '999.444.555-26', '543.765.234-33', 'Ativo', '2000-06-02',null);
INSERT INTO tb005_funcionarios VALUES(DEFAULT, 3, 6, 'Funcionário 27', '1978-02-03', '999.444.555-27', '543.765.234-34', 'Ativo', '2000-06-02',null);
INSERT INTO tb005_funcionarios VALUES(DEFAULT, 3,25, 'Funcionário 28', '1982-03-10', '999.444.555-28', '543.765.234-35', 'Ativo', '2000-06-02',null);
INSERT INTO tb005_funcionarios VALUES(DEFAULT, 4, 1, 'Funcionário 29', '1989-04-03', '999.444.555-29', '543.765.234-36', 'Ativo', '2000-06-01',null);
INSERT INTO tb005_funcionarios VALUES(DEFAULT, 5, 1, 'Funcionário 30', '1979-05-01', '999.444.555-30', '543.765.234-37', 'Inativo', '2000-06-03', '2009-01-06');
INSERT INTO tb005_funcionarios VALUES(DEFAULT, 1, 1, 'Funcionário 31', '1975-01-01', '999.444.555-31', '543.765.234-38', 'Ativo', '2000-07-01',null);
INSERT INTO tb005_funcionarios VALUES(DEFAULT, 5, 2, 'Funcionário 32', '1978-02-03', '999.444.555-32', '543.765.234-39', 'Ativo', '2000-07-02',null);
INSERT INTO tb005_funcionarios VALUES(DEFAULT, 1, 6, 'Funcionário 33', '1982-03-10', '999.444.555-33', '543.765.234-40', 'Ativo', '2000-07-03',null);
INSERT INTO tb005_funcionarios VALUES(DEFAULT, 1, 7, 'Funcionário 34', '1989-04-03', '999.444.555-34', '543.765.234-41', 'Ativo', '2000-07-04',null);
INSERT INTO tb005_funcionarios VALUES(DEFAULT, 1, 8, 'Funcionário 35', '1979-05-01', '999.444.555-35', '543.765.234-42', 'Inativo', '2000-07-05', '2009-01-07');
INSERT INTO tb005_funcionarios VALUES(DEFAULT, 1, 9, 'Funcionário 36', '1975-01-01', '999.444.555-36', '543.765.234-43', 'Ativo', '2000-07-06',null);
INSERT INTO tb005_funcionarios VALUES(DEFAULT, 1,30, 'Funcionário 37', '1978-02-03', '999.444.555-37', '543.765.234-44', 'Ativo', '2000-07-07',null);
INSERT INTO tb005_funcionarios VALUES(DEFAULT, 1, 1, 'Funcionário 38', '1982-03-10', '999.444.555-38', '543.765.234-45', 'Ativo', '2000-07-08',null);
INSERT INTO tb005_funcionarios VALUES(DEFAULT, 1, 1, 'Funcionário 39', '1989-04-03', '999.444.555-39', '543.765.234-46', 'Ativo', '2000-07-09',null);
INSERT INTO tb005_funcionarios VALUES(DEFAULT, 1, 4, 'Funcionário 40', '1979-05-01', '999.444.555-40', '543.765.234-47', 'Inativo', '2000-07-10', '2005-01-08');

-- tb005_006_funcionarios_cargos
DELETE FROM tb005_006_funcionarios_cargos;

INSERT INTO tb005_006_funcionarios_cargos VALUES(1, 1, 30000.00, 0.00, '2008-02-01');
INSERT INTO tb005_006_funcionarios_cargos VALUES(12, 2, 10000.00, 0.00, '2008-02-03');
INSERT INTO tb005_006_funcionarios_cargos VALUES(13, 3, 1000.00, 0.00, '2008-03-10');
INSERT INTO tb005_006_funcionarios_cargos VALUES(14, 4, 500.00, 0.00, '2008-03-10');
INSERT INTO tb005_006_funcionarios_cargos VALUES(14, 5, 800.00, 0.05, '2008-03-10');
INSERT INTO tb005_006_funcionarios_cargos VALUES(16, 6, 1000.00, 0.07, '2008-04-02');
INSERT INTO tb005_006_funcionarios_cargos VALUES(17, 7, 1300.00, 0.10, '2008-05-02');
INSERT INTO tb005_006_funcionarios_cargos VALUES(18, 8, 1050.00, 0.00, '2008-02-01');
INSERT INTO tb005_006_funcionarios_cargos VALUES(19, 9, 1150.00, 0.00, '2008-02-02');
INSERT INTO tb005_006_funcionarios_cargos VALUES(10, 3, 1050.99, 0.00, '2008-03-10');
INSERT INTO tb005_006_funcionarios_cargos VALUES(11, 5, 800.00, 0.06, '2008-03-10');
INSERT INTO tb005_006_funcionarios_cargos VALUES(12, 6, 1000.00, 0.06, '2008-03-10');
INSERT INTO tb005_006_funcionarios_cargos VALUES(13, 7, 1300.00, 0.11, '2008-04-02');
INSERT INTO tb005_006_funcionarios_cargos VALUES(15, 5, 800.00, 0.04, '2008-05-02');
INSERT INTO tb005_006_funcionarios_cargos VALUES(15, 6, 1000.00, 0.09, '2008-02-01');
INSERT INTO tb005_006_funcionarios_cargos VALUES(16, 7, 1300.00, 0.12, '2008-02-02');
INSERT INTO tb005_006_funcionarios_cargos VALUES(17, 5, 800.00, 0.05, '2008-03-10');
INSERT INTO tb005_006_funcionarios_cargos VALUES(18, 6, 1000.00, 0.09, '2008-03-12');
INSERT INTO tb005_006_funcionarios_cargos VALUES(4, 7, 1300.00, 0.12, '2008-03-10');
INSERT INTO tb005_006_funcionarios_cargos VALUES(20, 3, 1000.00, 0.00, '2008-04-02');
INSERT INTO tb005_006_funcionarios_cargos VALUES(11, 3, 1000.00, 0.00, '2008-05-02');
INSERT INTO tb005_006_funcionarios_cargos VALUES(12, 3, 1000.00, 0.00, '2008-02-01');
INSERT INTO tb005_006_funcionarios_cargos VALUES(13, 8, 1050.00, 0.00, '2008-02-05');
INSERT INTO tb005_006_funcionarios_cargos VALUES(14, 8, 1050.00, 0.00, '2008-03-06');
INSERT INTO tb005_006_funcionarios_cargos VALUES(15, 8, 1050.00, 0.00, '2008-03-07');
INSERT INTO tb005_006_funcionarios_cargos VALUES(16, 8, 1050.00, 0.00, '2008-03-08');
INSERT INTO tb005_006_funcionarios_cargos VALUES(17, 2, 10000.00, 0.00, '2008-04-02');
INSERT INTO tb005_006_funcionarios_cargos VALUES(18, 2, 10000.00, 0.00, '2008-05-02');
INSERT INTO tb005_006_funcionarios_cargos VALUES(14, 2, 10000.00, 0.00, '2008-02-01');
INSERT INTO tb005_006_funcionarios_cargos VALUES(10, 5, 800.00, 0.04, '2008-02-09');
INSERT INTO tb005_006_funcionarios_cargos VALUES(11, 6, 1000.00, 0.07, '2008-03-06');
INSERT INTO tb005_006_funcionarios_cargos VALUES(12, 7, 1300.00, 0.12, '2008-03-07');
INSERT INTO tb005_006_funcionarios_cargos VALUES(13, 5, 800.00, 0.04, '2008-03-12');
INSERT INTO tb005_006_funcionarios_cargos VALUES(14, 6, 1000.00, 0.07, '2008-04-02');
INSERT INTO tb005_006_funcionarios_cargos VALUES(15, 7, 1300.00, 0.11, '2008-05-03');
INSERT INTO tb005_006_funcionarios_cargos VALUES(16, 3, 1000.00, 0.00, '2008-02-01');
INSERT INTO tb005_006_funcionarios_cargos VALUES(17, 3, 1000.00, 0.00, '2008-02-05');
INSERT INTO tb005_006_funcionarios_cargos VALUES(18, 7, 1300.00, 0.11, '2008-03-05');
INSERT INTO tb005_006_funcionarios_cargos VALUES(3, 7, 1300.00, 0.11, '2008-03-05');
INSERT INTO tb005_006_funcionarios_cargos VALUES(10, 7, 1300.00, 0.11, '2008-03-08');
INSERT INTO tb005_006_funcionarios_cargos VALUES(13, 6, 1000.00, 0.07, '2009-03-09');
INSERT INTO tb005_006_funcionarios_cargos VALUES(8, 7, 1300.00, 0.10, '2009-04-02');
INSERT INTO tb005_006_funcionarios_cargos VALUES(9, 2, 10000.00, 0.10, '2009-05-02');

-- tb010_clientes
DELETE FROM tb010_clientes;

INSERT INTO tb010_clientes VALUES(10000000000, 'NOME Teste 01', '(41) 3333-0001', '(41) 9999-9001');
INSERT INTO tb010_clientes VALUES(10000000001, 'NOME Teste 02', '(41) 3333-0002', '(41) 9999-9002');
INSERT INTO tb010_clientes VALUES(10000000002, 'NOME Teste 03', '(41) 3333-0003', '(41) 9999-9003');
INSERT INTO tb010_clientes VALUES(10000000003, 'NOME Teste 04', '(41) 3333-0004', '(41) 9999-9004');
INSERT INTO tb010_clientes VALUES(10000000004, 'NOME Teste 05', '(41) 3333-0005', '(41) 9999-9005');
INSERT INTO tb010_clientes VALUES(10000000005, 'NOME Teste 06', '(41) 3333-0006', '(41) 9999-9006');
INSERT INTO tb010_clientes VALUES(10000000006, 'NOME Teste 07', '(41) 3333-0007', '(41) 9999-9007');
INSERT INTO tb010_clientes VALUES(10000000007, 'NOME Teste 08', '(41) 3333-0008', '(41) 9999-9008');
INSERT INTO tb010_clientes VALUES(10000000008, 'NOME Teste 09', '(41) 3333-0009', '(41) 9999-9009');
INSERT INTO tb010_clientes VALUES(10000000009, 'NOME Teste 10', '(41) 3333-0010', '(41) 9999-9010');
INSERT INTO tb010_clientes VALUES(10000000010, 'NOME Teste 11', '(11) 5333-0011', '(41) 9999-9011');
INSERT INTO tb010_clientes VALUES(10000000011, 'NOME Teste 12', '(41) 3333-0012', '(41) 9999-9012');
INSERT INTO tb010_clientes VALUES(10000000012, 'NOME Teste 13', '(41) 3333-0013', '(41) 9999-9013');
INSERT INTO tb010_clientes VALUES(10000000013, 'NOME Teste 14', '(41) 3333-0014', '(41) 9999-9014');
INSERT INTO tb010_clientes VALUES(10000000014, 'NOME Teste 15', '(41) 3333-0015', '(41) 9999-9015');
INSERT INTO tb010_clientes VALUES(10000000015, 'NOME Teste 16', '(48) 5333-8989', '(41) 9999-9016');
INSERT INTO tb010_clientes VALUES(10000000016, 'NOME Teste 17', '(41) 3333-0017', '(41) 9999-9017');
INSERT INTO tb010_clientes VALUES(10000000017, 'NOME Teste 18', '(41) 3333-0018', '(41) 9999-9018');
INSERT INTO tb010_clientes VALUES(10000000018, 'NOME Teste 19', '(41) 3333-0019', '(41) 9999-9019');
INSERT INTO tb010_clientes VALUES(10000000019, 'NOME Teste 20', '(41) 3333-0020', '(41) 9999-9020');
INSERT INTO tb010_clientes VALUES(10000000020, 'NOME Teste 21', '(41) 3333-0021', '(41) 9999-9021');
INSERT INTO tb010_clientes VALUES(10000000021, 'NOME Teste 22', '(41) 3333-0022', '(41) 9999-9022');
INSERT INTO tb010_clientes VALUES(10000000022, 'NOME Teste 23', '(11) 5333-0099', '(41) 9999-9023');
INSERT INTO tb010_clientes VALUES(10000000023, 'NOME Teste 24', '(41) 3333-0024', '(41) 9999-9024');
INSERT INTO tb010_clientes VALUES(10000000024, 'NOME Teste 25', '(41) 3333-0025', '(11) 8999-9025');
INSERT INTO tb010_clientes VALUES(10000000025, 'NOME Teste 26', '(41) 3333-0026', '(41) 9999-9026');
INSERT INTO tb010_clientes VALUES(10000000026, 'NOME Teste 27', '(41) 3333-0027', '(41) 9999-9027');
INSERT INTO tb010_clientes VALUES(10000000027, 'NOME Teste 28', '(41) 3333-0028', '(41) 9999-9028');
INSERT INTO tb010_clientes VALUES(10000000028, 'NOME Teste 29', '(41) 3333-0029', '(41) 9999-9029');
INSERT INTO tb010_clientes VALUES(10000000029, 'NOME Teste 30', '(41) 3333-0030', '(41) 9999-9030');
INSERT INTO tb010_clientes VALUES(10000000030, 'NOME Teste 31', '(41) 3333-0031', '(41) 9999-9031');
INSERT INTO tb010_clientes VALUES(10000000031, 'NOME Teste 32', '(41) 3333-0032', '(41) 9999-9032');
INSERT INTO tb010_clientes VALUES(10000000032, 'NOME Teste 33', '(41) 3333-0033', '(41) 9999-9033');
INSERT INTO tb010_clientes VALUES(10000000033, 'NOME Teste 34', '(41) 3333-0034', '(41) 9999-9034');
INSERT INTO tb010_clientes VALUES(10000000034, 'NOME Teste 35', '(41) 3333-0035', '(41) 9999-9035');
INSERT INTO tb010_clientes VALUES(10000000035, 'NOME Teste 36', '(41) 3333-0036', '(41) 9999-9036');
INSERT INTO tb010_clientes VALUES(10000000036, 'NOME Teste 37', '(41) 3333-0037', '(41) 9999-9037');
INSERT INTO tb010_clientes VALUES(10000000037, 'NOME Teste 38', '(41) 3333-0038', '(41) 9999-9038');
INSERT INTO tb010_clientes VALUES(10000000038, 'NOME Teste 39', '(41) 3333-0039', '(41) 9999-9039');
INSERT INTO tb010_clientes VALUES(10000000039, 'NOME Teste 40', '(41) 3333-0040', '(41) 9999-9040');
INSERT INTO tb010_clientes VALUES(10000000040, 'NOME Teste 41', '(41) 3333-0041', '(41) 9999-9041');
INSERT INTO tb010_clientes VALUES(10000000041, 'NOME Teste 42', '(41) 3333-0042', '(41) 9999-9042');
INSERT INTO tb010_clientes VALUES(10000000042, 'NOME Teste 43', '(41) 3333-0043', '(41) 9999-9043');
INSERT INTO tb010_clientes VALUES(10000000043, 'NOME Teste 44', '(41) 3333-0044', '(41) 9999-9044');
INSERT INTO tb010_clientes VALUES(10000000044, 'NOME Teste 45', '(41) 3333-0045', '(11) 8999-9325');
INSERT INTO tb010_clientes VALUES(10000000045, 'NOME Teste 46', '(41) 3333-0046', '(11) 8999-9089');
INSERT INTO tb010_clientes VALUES(10000000046, 'NOME Teste 47', '(41) 3333-0047', '(41) 9999-9047');
INSERT INTO tb010_clientes VALUES(10000000047, 'NOME Teste 48', '(41) 3333-0048', '(41) 9999-9048');
INSERT INTO tb010_clientes VALUES(10000000048, 'NOME Teste 49', '(41) 3333-0049', '(11) 8999-6464');
INSERT INTO tb010_clientes VALUES(10000000049, 'NOME Teste 50', '(41) 3333-0050', '(41) 9999-9050');
INSERT INTO tb010_clientes VALUES(10000000050, 'NOME Teste 51', '(41) 3333-0051', '(41) 9999-9051');

-- tb010_clientes_antigos
DELETE FROM tb010_clientes_antigos;

INSERT INTO tb010_clientes_antigos VALUES(10000000000, 'NOME Teste 01');
INSERT INTO tb010_clientes_antigos VALUES(10000000001, 'NOME Teste 02');
INSERT INTO tb010_clientes_antigos VALUES(10000000002, 'NOME Teste 03');
INSERT INTO tb010_clientes_antigos VALUES(10000000003, 'NOME Teste 04');
INSERT INTO tb010_clientes_antigos VALUES(10000000004, 'NOME Teste 05');
INSERT INTO tb010_clientes_antigos VALUES(10000000005, 'NOME Teste 06');
INSERT INTO tb010_clientes_antigos VALUES(10000000006, 'NOME Teste 07');
INSERT INTO tb010_clientes_antigos VALUES(10000000007, 'NOME Teste 08');
INSERT INTO tb010_clientes_antigos VALUES(10000000008, 'NOME Teste 09');
INSERT INTO tb010_clientes_antigos VALUES(10000000009, 'NOME Teste 10');
INSERT INTO tb010_clientes_antigos VALUES(10000000010, 'NOME Teste 11');
INSERT INTO tb010_clientes_antigos VALUES(10000000011, 'NOME Teste 12');

-- tb011_logins
DELETE FROM tb011_logins;

INSERT INTO tb011_logins VALUES('Teste_01',10000000000, 'Teste_01', '2009-01-01');
INSERT INTO tb011_logins VALUES('Teste_02',10000000001, 'Teste_02', '2009-01-01');
INSERT INTO tb011_logins VALUES('Teste_03',10000000002, 'Teste_03', '2009-01-01');
INSERT INTO tb011_logins VALUES('Teste_04',10000000003, 'Teste_04', '2009-01-11');
INSERT INTO tb011_logins VALUES('Teste_05',10000000004, 'Teste_05', '2009-01-01');
INSERT INTO tb011_logins VALUES('Teste_06',10000000005, 'Teste_06', '2009-01-12');
INSERT INTO tb011_logins VALUES('Teste_07',10000000006, 'Teste_07', '2009-01-01');
INSERT INTO tb011_logins VALUES('Teste_08',10000000007, 'Teste_08', '2009-01-01');
INSERT INTO tb011_logins VALUES('Teste_09',10000000008, 'Teste_09', '2009-08-01');
INSERT INTO tb011_logins VALUES('Teste_10',10000000009, 'Teste_10', '2009-01-01');
INSERT INTO tb011_logins VALUES('Teste_11',10000000010, 'Teste_11', '2009-01-01');
INSERT INTO tb011_logins VALUES('Teste_12',10000000011, 'Teste_12', '2008-01-01');
INSERT INTO tb011_logins VALUES('Teste_13',10000000012, 'Teste_13', '2009-01-03');
INSERT INTO tb011_logins VALUES('Teste_14',10000000013, 'Teste_14', '2009-01-01');
INSERT INTO tb011_logins VALUES('Teste_15',10000000014, 'Teste_15', '2009-01-01');
INSERT INTO tb011_logins VALUES('Teste_16',10000000015, 'Teste_16', '2009-02-01');
INSERT INTO tb011_logins VALUES('Teste_17',10000000016, 'Teste_17', '2009-01-01');
INSERT INTO tb011_logins VALUES('Teste_18',10000000017, 'Teste_18', '2009-01-05');
INSERT INTO tb011_logins VALUES('Teste_19',10000000018, 'Teste_19', '2009-01-01');
INSERT INTO tb011_logins VALUES('Teste_20',10000000019, 'Teste_20', '2009-01-01');
INSERT INTO tb011_logins VALUES('Teste_21',10000000020, 'Teste_21', '2009-01-01');
INSERT INTO tb011_logins VALUES('Teste_22',10000000021, 'Teste_22', '2009-01-11');
INSERT INTO tb011_logins VALUES('Teste_23',10000000022, 'Teste_23', '2009-01-01');
INSERT INTO tb011_logins VALUES('Teste_24',10000000023, 'Teste_24', '2009-01-05');
INSERT INTO tb011_logins VALUES('Teste_25',10000000024, 'Teste_25', '2009-01-01');
INSERT INTO tb011_logins VALUES('Teste_26',10000000025, 'Teste_26', '2009-01-01');
INSERT INTO tb011_logins VALUES('Teste_27',10000000026, 'Teste_27', '2009-08-01');
INSERT INTO tb011_logins VALUES('Teste_28',10000000027, 'Teste_28', '2009-01-01');
INSERT INTO tb011_logins VALUES('Teste_29',10000000028, 'Teste_29', '2009-01-01');
INSERT INTO tb011_logins VALUES('Teste_30',10000000029, 'Teste_30', '2008-01-01');
INSERT INTO tb011_logins VALUES('Teste_31',10000000030, 'Teste_31', '2009-01-08');
INSERT INTO tb011_logins VALUES('Teste_32',10000000031, 'Teste_32', '2009-01-01');
INSERT INTO tb011_logins VALUES('Teste_33',10000000032, 'Teste_33', '2009-01-01');
INSERT INTO tb011_logins VALUES('Teste_34',10000000033, 'Teste_34', '2009-02-01');
INSERT INTO tb011_logins VALUES('Teste_35',10000000034, 'Teste_35', '2009-01-01');
INSERT INTO tb011_logins VALUES('Teste_36',10000000035, 'Teste_36', '2009-01-09');
INSERT INTO tb011_logins VALUES('Teste_37',10000000036, 'Teste_37', '2009-01-01');
INSERT INTO tb011_logins VALUES('Teste_38',10000000037, 'Teste_38', '2009-01-01');
INSERT INTO tb011_logins VALUES('Teste_39',10000000038, 'Teste_39', '2009-01-01');
INSERT INTO tb011_logins VALUES('Teste_40',10000000039, 'Teste_40', '2009-01-11');
INSERT INTO tb011_logins VALUES('Teste_41',10000000040, 'Teste_41', '2009-01-01');
INSERT INTO tb011_logins VALUES('Teste_42',10000000041, 'Teste_42', '2009-01-07');
INSERT INTO tb011_logins VALUES('Teste_43',10000000042, 'Teste_43', '2009-01-01');
INSERT INTO tb011_logins VALUES('Teste_44',10000000043, 'Teste_44', '2009-01-01');
INSERT INTO tb011_logins VALUES('Teste_45',10000000044, 'Teste_45', '2009-08-01');
INSERT INTO tb011_logins VALUES('Teste_46',10000000045, 'Teste_46', '2009-01-01');
INSERT INTO tb011_logins VALUES('Teste_47',10000000046, 'Teste_47', '2009-01-01');
INSERT INTO tb011_logins VALUES('Teste_48',10000000047, 'Teste_48', '2008-01-01');
INSERT INTO tb011_logins VALUES('Teste_49',10000000048, 'Teste_49', '2009-01-04');
INSERT INTO tb011_logins VALUES('Teste_50',10000000049, 'Teste_50', '2009-01-01');
INSERT INTO tb011_logins VALUES('Teste_51',10000000050, 'Teste_51', '2009-01-01');

-- tb013_categorias
DELETE FROM tb013_categorias;

INSERT INTO tb013_categorias VALUES(DEFAULT, 'Alimentos Perecíveis');
INSERT INTO tb013_categorias VALUES(DEFAULT, 'Alimentos Não Perecíveis');
INSERT INTO tb013_categorias VALUES(DEFAULT, 'Eletrodomésticos');
INSERT INTO tb013_categorias VALUES(DEFAULT, 'Eletrônicos');
INSERT INTO tb013_categorias VALUES(DEFAULT, 'CD e DVD');
INSERT INTO tb013_categorias VALUES(DEFAULT, 'Roupas Masculinas');
INSERT INTO tb013_categorias VALUES(DEFAULT, 'Roupas Femininas');
INSERT INTO tb013_categorias VALUES(DEFAULT, 'Roupas Infantis');

-- tb012_produtos
DELETE FROM tb012_produtos;

INSERT INTO tb012_produtos VALUES(10, 1, 'Biscoito Recheado');
INSERT INTO tb012_produtos VALUES(11, 1, 'Pão-de-queijo Congelado');
INSERT INTO tb012_produtos VALUES(12, 1, 'Iogurte');
INSERT INTO tb012_produtos VALUES(13, 1, 'Barra de Chocolate');
INSERT INTO tb012_produtos VALUES(14, 1, 'Barra de Cereal');
INSERT INTO tb012_produtos VALUES(15, 1, 'Biscoito Água e Sal');
INSERT INTO tb012_produtos VALUES(16, 1, 'Biscoito Maizena');
INSERT INTO tb012_produtos VALUES(17, 1, 'Salgadinho');
INSERT INTO tb012_produtos VALUES(18, 1, 'Suco Ades');
INSERT INTO tb012_produtos VALUES(19, 1, 'Isotônico');
INSERT INTO tb012_produtos VALUES(20, 2, 'Acúcar');
INSERT INTO tb012_produtos VALUES(21, 2, 'Arroz');
INSERT INTO tb012_produtos VALUES(22, 2, 'Feijão');
INSERT INTO tb012_produtos VALUES(23, 2, 'Milho de Pipoca');
INSERT INTO tb012_produtos VALUES(30, 3, 'Geladeira');
INSERT INTO tb012_produtos VALUES(31, 3, 'Geladeira Duplex');
INSERT INTO tb012_produtos VALUES(32, 3, 'Fogão 4 Bocas');
INSERT INTO tb012_produtos VALUES(33, 3, 'Fogão 6 Bocas');
INSERT INTO tb012_produtos VALUES(34, 3, 'Batedeira');
INSERT INTO tb012_produtos VALUES(35, 3, 'Liquidificador');
INSERT INTO tb012_produtos VALUES(36, 3, 'Torradeira');
INSERT INTO tb012_produtos VALUES(37, 3, 'Sanduicheira');
INSERT INTO tb012_produtos VALUES(38, 3, 'Multiprocessador');
INSERT INTO tb012_produtos VALUES(39, 3, 'Forno Elétrico');
INSERT INTO tb012_produtos VALUES(40, 4, 'TV LCD');
INSERT INTO tb012_produtos VALUES(41, 4, 'TV Cubo de Imagens');
INSERT INTO tb012_produtos VALUES(42, 4, 'DVD');
INSERT INTO tb012_produtos VALUES(43, 4, 'DVD Karaoke');
INSERT INTO tb012_produtos VALUES(44, 4, 'Vídeo-Game');
INSERT INTO tb012_produtos VALUES(45, 4, 'Aparelho de Som');
INSERT INTO tb012_produtos VALUES(46, 4, 'Aparelho de Som Automotivo');
INSERT INTO tb012_produtos VALUES(47, 4, 'Auto-Falantes Automotivos');
INSERT INTO tb012_produtos VALUES(48, 4, 'Notebook');
INSERT INTO tb012_produtos VALUES(49, 4, 'Computador Desktop');
INSERT INTO tb012_produtos VALUES(50, 5, 'CD Rock');
INSERT INTO tb012_produtos VALUES(51, 5, 'CD POP');
INSERT INTO tb012_produtos VALUES(52, 5, 'CD Coletânea');
INSERT INTO tb012_produtos VALUES(53, 5, 'CD Caipira');
INSERT INTO tb012_produtos VALUES(54, 5, 'CD Virgem');
INSERT INTO tb012_produtos VALUES(55, 5, 'DVD Rock');
INSERT INTO tb012_produtos VALUES(56, 5, 'DVD POP');
INSERT INTO tb012_produtos VALUES(57, 5, 'DVD Coletânea');
INSERT INTO tb012_produtos VALUES(58, 5, 'DVD Caipira');
INSERT INTO tb012_produtos VALUES(59, 5, 'DVD Virgem');
INSERT INTO tb012_produtos VALUES(60, 6, 'Calça Jeans');
INSERT INTO tb012_produtos VALUES(61, 6, 'Calça Moleton');
INSERT INTO tb012_produtos VALUES(62, 6, 'Camisa Polo');
INSERT INTO tb012_produtos VALUES(63, 6, 'Camisa Manga Longa');
INSERT INTO tb012_produtos VALUES(64, 6, 'Camisa Manga Curta');
INSERT INTO tb012_produtos VALUES(65, 6, 'Camiseta');
INSERT INTO tb012_produtos VALUES(66, 6, 'Regata');
INSERT INTO tb012_produtos VALUES(67, 6, 'Meias');
INSERT INTO tb012_produtos VALUES(68, 6, 'Roupas de Baixo');
INSERT INTO tb012_produtos VALUES(69, 6, 'Gravatas');
INSERT INTO tb012_produtos VALUES(70, 7, 'Calça Jeans');
INSERT INTO tb012_produtos VALUES(71, 7, 'Calça Moleton');
INSERT INTO tb012_produtos VALUES(72, 7, 'Top');
INSERT INTO tb012_produtos VALUES(73, 7, 'Camisa Manga Longa');
INSERT INTO tb012_produtos VALUES(74, 7, 'Camisa Manga Curta');
INSERT INTO tb012_produtos VALUES(75, 7, 'Camiseta');
INSERT INTO tb012_produtos VALUES(76, 7, 'Regata');
INSERT INTO tb012_produtos VALUES(77, 7, 'Meias');
INSERT INTO tb012_produtos VALUES(78, 7, 'Roupas de Baixo');
INSERT INTO tb012_produtos VALUES(79, 7, 'Bolsas');
INSERT INTO tb012_produtos VALUES(80, 8, 'Camiseta');
INSERT INTO tb012_produtos VALUES(81, 8, 'Bermuda');
INSERT INTO tb012_produtos VALUES(82, 8, 'Tênis');
INSERT INTO tb012_produtos VALUES(83, 8, 'Bonés');

-- tb014_prd_alimentos
DELETE FROM tb014_prd_alimentos;

INSERT INTO tb014_prd_alimentos VALUES(DEFAULT, 10, 'Trakinas', 'Kilogramas', '8887775456', '2024-11-02', 1.10);
INSERT INTO tb014_prd_alimentos VALUES(DEFAULT, 10, 'Pica-Pau', 'Kilogramas', '3457684345', '2024-02-01', 0.89);
INSERT INTO tb014_prd_alimentos VALUES(DEFAULT, 10, 'Gulosos', 'Kilogramas', '8276348762', '2024-01-12', 1.09);
INSERT INTO tb014_prd_alimentos VALUES(DEFAULT, 11, 'Quijo de Minas', 'Kilogramas', '5473545453', '2024-06-01', 3.99);
INSERT INTO tb014_prd_alimentos VALUES(DEFAULT, 11, '+ Pão', 'Kilogramas', '5473545453', '2024-06-01', 2.89);
INSERT INTO tb014_prd_alimentos VALUES(DEFAULT, 12, 'Batavo - Frutas', 'Litros', '5473545453', '2024-05-01', 1.09);
INSERT INTO tb014_prd_alimentos VALUES(DEFAULT, 12, 'Danone', 'Litros', '9768935983', '2024-05-01', 0.99);
INSERT INTO tb014_prd_alimentos VALUES(DEFAULT, 13, 'Garoto', 'Kilogramas', '9583495345', '2024-05-01', 3.99);
INSERT INTO tb014_prd_alimentos VALUES(DEFAULT, 13, 'Nestlé', 'Kilogramas', '5345662345', '2024-03-01', 4.19);
INSERT INTO tb014_prd_alimentos VALUES(DEFAULT, 13, 'Hersheys', 'Kilogramas', 'FRU4345GDA', '2024-04-01', 2.99);
INSERT INTO tb014_prd_alimentos VALUES(DEFAULT, 14, 'Nutri', 'Kilogramas', '5433145453', '2024-06-01', 0.79);
INSERT INTO tb014_prd_alimentos VALUES(DEFAULT, 14, 'Trill', 'Kilogramas', '8757689456', '2024-06-01', 0.69);
INSERT INTO tb014_prd_alimentos VALUES(DEFAULT, 15, 'Nestlé', 'Kilogramas', '2324345423', '2024-04-01', 2.99);
INSERT INTO tb014_prd_alimentos VALUES(DEFAULT, 15, 'Todeschini', 'Kilogramas', '7896532736', '2024-01-05', 1.39);
INSERT INTO tb014_prd_alimentos VALUES(DEFAULT, 15, 'Mabel', 'Kilogramas', '98475934hhg', '2024-12-12', 1.20);
INSERT INTO tb014_prd_alimentos VALUES(DEFAULT, 16, 'Nestlé', 'Kilogramas', '13468720049', '2024-11-05', 2.10);
INSERT INTO tb014_prd_alimentos VALUES(DEFAULT, 16, 'Todeschini', 'Kilogramas', '19040907362', '2024-12-01', 1.14);
INSERT INTO tb014_prd_alimentos VALUES(DEFAULT, 16, 'Mabel', 'Kilogramas', '46575934hhg', '2024-12-01', 1.18);
INSERT INTO tb014_prd_alimentos VALUES(DEFAULT, 17, 'Elma Chips', 'Kilogramas', '34174845745', '2024-06-02', 1.99);
INSERT INTO tb014_prd_alimentos VALUES(DEFAULT, 17, 'Tip-Top', 'Kilogramas', '77583275585', '2024-08-01', 1.49);
INSERT INTO tb014_prd_alimentos VALUES(DEFAULT, 17, 'Pipoteca', 'Kilogramas', '9283478gdy9', '2024-10-08', 0.99);
INSERT INTO tb014_prd_alimentos VALUES(DEFAULT, 18, 'Del Vale', 'Litros', '12874534549', '2024-06-02', 1.39);
INSERT INTO tb014_prd_alimentos VALUES(DEFAULT, 18, 'Ades', 'Litros', '120991705w34', '2024-05-01', 1.09);
INSERT INTO tb014_prd_alimentos VALUES(DEFAULT, 18, 'Minute Maid +', 'Litros', '164400135343frt', '2024-10-08', 2.99);
INSERT INTO tb014_prd_alimentos VALUES(DEFAULT, 19, 'Isotônico', 'Litros', '9283478gdy10', '2024-06-10', 3.99);

-- tb015_prd_eletros
DELETE FROM tb015_prd_eletros;

INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 30, 'Consul', '110-220 volts', 'A', 999.00);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 30, 'Esmaltec', '110-220 volts', 'B', 999.00);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 31, 'Bosch', '110-220 volts', 'B', 1399.00);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 31, 'Consul', '110-220 volts', 'B', 1399.00);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 32, 'Continental', '110-220 volts', 'A', 559.00);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 32, 'Dako', '110-220 volts', 'A', 699.00);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 33, 'Bosch', '110-220 volts', 'A', 999.00);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 33, 'Esmaltec', '110 volts', 'B', 899.00);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 34, 'Arno', '110 volts', 'A', 49.90);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 34, 'Arno', '220 volts', 'A', 52.00);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 35, 'Britânia', '110 volts', 'A', 65.00);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 35, 'Arno', '110 volts', 'A', 59.99);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 36, 'Esmaltec', '110 volts', 'A', 38.00);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 36, 'Arno', '110 volts', 'A', 49.00);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 37, 'Britânia', '110 volts', 'B', 43.00);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 37, 'Arno', '110 volts', 'B', 59.99);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 38, 'Arno', '110-220 volts', 'C', 799.00);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 39, 'Brastemp', '110-220 volts', 'C', 599.00);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 40, 'LG 42 Polegadas', '110-220 volts', 'A', 2999.00);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 40, 'Philco 42 Polegadas', '110-220 volts', 'A', 2850.00);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 41, 'CCE 29 Polegadas', '110-220 volts', 'B', 899.00);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 41, 'Samsung 29 Polegadas', '110-220 volts', 'A', 1250.00);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 42, 'Philips', '110-220 volts', 'A', 299.00);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 42, 'Philco', '110-220 volts', 'A', 270.00);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 43, 'Philco', '110-220 volts', 'A', 299.00);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 43, 'LG', '110-220 volts', 'A', 312.00);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 44, 'Play Station 2', '110-220 volts', 'A', 499.00);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 44, 'X Box 360', '110-220 volts', 'A', 650.00);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 45, 'Sony', '12 volts', null, 519.00);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 45, 'Aiwa', '12 volts', null, 430.50);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 46, 'Sony', '12 volts', null, 249.00);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 46, 'Pioneer', '12 volts', null, 310.80);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 47, 'Booster', '12 volts', null, 130.00);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 47, 'Bravox', '12 volts', null, 129.99);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 48, 'Positivo', '110-220 volts', 'A', 2599.00);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 48, 'Intelbras', '110-220 volts', 'A', 1400.00);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 49, 'STI', '110-220 volts', 'A', 999.90);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 49, 'Positivo', '110-220 volts', 'A', 1235.89);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 50, 'AC-DC Collection', null, null, 35.00);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 50, 'Ultraje a Rigor', null, null, 21.89);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 51, 'Shakira', null, null, 19.99);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 51, 'Beyonce', null, null, 1.99);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 52, 'Melhores 80 Rocks', null, null, 23.89);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 52, 'Melhores 90 Rocks', null, null, 25.99);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 53, 'Pena Branca e Xavantinho', null, null, 15.99);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 53, 'Milhionário e José Rico', null, null, 26.34);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 54, 'EMTEC', null, null, 0.89);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 54, 'BULK', null, null, 0.73);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 55, 'Deep Purple', null, null, 49.90);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 55, 'Joe Satriani', null, null, 72.78);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 56, 'Shakira', null, null, 89.34);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 56, 'Beyonce', null, null, 1.99);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 57, 'Melhores 80 Rocks', null, null, 35.75);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 57, 'Melhores 90 Rocks', null, null, 32.58);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 58, 'Berenice Azambuja', null, null, 35.76);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 58, 'Tadeu e Tadando', null, null, 32.59);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 59, 'EMTEC', null, null, 1.23);
INSERT INTO tb015_prd_eletros VALUES(DEFAULT, 59, 'BULK', null, null, 0.99);

-- tb016_prd_vestuarios
DELETE FROM tb016_prd_vestuarios;

INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 60, 'Lee', 'M', null, 52, 69.99);
INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 60, 'Malwe', 'M', null, 56, 89.99);
INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 61, 'Malwe', 'U', 'Grande', null, 22.00);
INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 61, 'Hering', 'U', 'Pequena', null, 22.00);
INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 62, 'Polo', 'M', 'Grande', null, 22.00);
INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 62, 'Lacoste', 'M', 'Grande', null, 35.00);
INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 63, 'Polo', 'M', 'Grande', null, 27.00);
INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 63, 'Lacoste', 'M', 'Grande', null, 38.00);
INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 64, 'Polo', 'M', 'Grande', null, 22.00);
INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 64, 'Lacoste', 'M', 'Grande', null, 35.00);
INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 65, 'Rip Curl', 'U', 'Grande', null, 28.09);
INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 65, 'Mormai', 'U', 'Grande', null, 32.00);
INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 66, 'Mormai', 'M', 'Grande', null, 10.99);
INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 66, 'Mormai', 'M', 'Pequena', null, 10.99);
INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 67, 'Social', 'M', null, 44, 9.90);
INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 67, 'Esporte', 'M', null, 44, 12.00);
INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 68, 'Cueca', 'M', 'Grande', null, 15.89);
INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 68, 'Samba Canção', 'M', 'Grande', null, 15.89);
INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 69, 'Armani', 'M', null, null, 19.99);
INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 70, 'Lee', 'F', null, 46, 99.99);
INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 70, 'Malwe', 'F', null, 48, 119.99);
INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 71, 'Malwe', 'F', 'Grande', null, 35.00);
INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 71, 'Hering', 'F', 'Pequena', null, 35.00);
INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 72, 'Polo', 'F', 'Média', null, 37.00);
INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 72, 'Meimalha', 'F', 'Média', null, 37.00);
INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 73, 'Polo', 'F', 'Média', null, 27.00);
INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 73, 'Meimalha', 'F', 'Média', null, 38.00);
INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 74, 'Polo', 'F', 'Média', null, 22.00);
INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 74, 'Meimalha', 'F', 'Média', null, 35.00);
INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 75, 'Rip Curl', 'F', 'Média', null, 28.09);
INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 75, 'Mormai', 'F', 'Média', null, 32.00);
INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 76, 'Mormai', 'F', 'Média', null, 10.99);
INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 76, 'Mormai', 'F', 'Pequena', null, 10.99);
INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 77, 'Social', 'F', null, 44, 9.90);
INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 77, 'Esporte', 'F', null, 44, 12.00);
INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 78, 'Calcinhas', 'F', 'Pequena', null, 19.99);
INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 78, 'Soutien', 'F', 'Pequena', null, 29.99);
INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 79, 'Renner', 'F', null, null, 139.00);
INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 79, 'C & A', 'F', null, null, 119.00);
INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 80, 'Malwe', 'I', 'Pequena', null, 19.99);
INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 80, 'Tigor T Tigre', 'I', 'Pequena', null, 25.99);
INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 81, 'Malwe', 'I', 'Pequena', null, 19.99);
INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 81, 'Tigor T Tigre', 'I', 'Pequena', null, 25.99);
INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 82, 'Klin', 'I', null, 25, 39.99);
INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 82, 'Pimpolho', 'I', null, 28, 59.99);
INSERT INTO tb016_prd_vestuarios VALUES(DEFAULT, 83, 'Tigor T Tigre', 'I', null, null, 9.50);

-- tb017_fornecedores
DELETE FROM tb017_fornecedores;

INSERT INTO tb017_fornecedores VALUES(DEFAULT, 'Empresa 01', 'Nome Fantasia - Empresa 01', '(41) 3343-4545',7);
INSERT INTO tb017_fornecedores VALUES(DEFAULT, 'Empresa 02', 'Nome Fantasia - Empresa 02', '(41) 3343-4546',7);
INSERT INTO tb017_fornecedores VALUES(DEFAULT, 'Empresa 03', 'Nome Fantasia - Empresa 03', '(41) 3343-4547',7);
INSERT INTO tb017_fornecedores VALUES(DEFAULT, 'Empresa 04', 'Nome Fantasia - Empresa 04', '(41) 3343-4548',7);
INSERT INTO tb017_fornecedores VALUES(DEFAULT, 'Empresa 05', 'Nome Fantasia - Empresa 05', '(41) 3343-4549',7);
INSERT INTO tb017_fornecedores VALUES(DEFAULT, 'Empresa 06', 'Nome Fantasia - Empresa 06', '(41) 3343-4550',7);
INSERT INTO tb017_fornecedores VALUES(DEFAULT, 'Empresa 07', 'Nome Fantasia - Empresa 07', '(41) 3343-4551',7);
INSERT INTO tb017_fornecedores VALUES(DEFAULT, 'Empresa 08', 'Nome Fantasia - Empresa 08', '(41) 3343-4552',7);
INSERT INTO tb017_fornecedores VALUES(DEFAULT, 'Empresa 09', 'Nome Fantasia - Empresa 09', '(41) 3343-4553',7);
INSERT INTO tb017_fornecedores VALUES(DEFAULT, 'Empresa 10', 'Nome Fantasia - Empresa 10', '(41) 3343-4554',7);
INSERT INTO tb017_fornecedores VALUES(DEFAULT, 'Empresa 11', 'Nome Fantasia - Empresa 11', '(41) 3343-4555',8);
INSERT INTO tb017_fornecedores VALUES(DEFAULT, 'Empresa 12', 'Nome Fantasia - Empresa 12', '(41) 3343-4556',8);
INSERT INTO tb017_fornecedores VALUES(DEFAULT, 'Empresa 13', 'Nome Fantasia - Empresa 13', '(41) 3343-4557',8);
INSERT INTO tb017_fornecedores VALUES(DEFAULT, 'Empresa 14', 'Nome Fantasia - Empresa 14', '(41) 3343-4558',8);
INSERT INTO tb017_fornecedores VALUES(DEFAULT, 'Empresa 15', 'Nome Fantasia - Empresa 15', '(41) 3343-4559',8);
INSERT INTO tb017_fornecedores VALUES(DEFAULT, 'Empresa 16', 'Nome Fantasia - Empresa 16', '(41) 3343-4560',8);
INSERT INTO tb017_fornecedores VALUES(DEFAULT, 'Empresa 17', 'Nome Fantasia - Empresa 17', '(41) 3343-4561',8);
INSERT INTO tb017_fornecedores VALUES(DEFAULT, 'Empresa 18', 'Nome Fantasia - Empresa 18', '(41) 3343-4562',8);
INSERT INTO tb017_fornecedores VALUES(DEFAULT, 'Empresa 19', 'Nome Fantasia - Empresa 19', '(41) 3343-4563',8);
INSERT INTO tb017_fornecedores VALUES(DEFAULT, 'Empresa 20', 'Nome Fantasia - Empresa 20', '(41) 3343-4564',8);
INSERT INTO tb017_fornecedores VALUES(DEFAULT, 'Empresa 21', 'Nome Fantasia - Empresa 21', '(41) 3343-4565',9);
INSERT INTO tb017_fornecedores VALUES(DEFAULT, 'Empresa 22', 'Nome Fantasia - Empresa 22', '(41) 3343-4566',9);
INSERT INTO tb017_fornecedores VALUES(DEFAULT, 'Empresa 23', 'Nome Fantasia - Empresa 23', '(41) 3343-4567',9);
INSERT INTO tb017_fornecedores VALUES(DEFAULT, 'Empresa 24', 'Nome Fantasia - Empresa 24', '(41) 3343-4568',9);
INSERT INTO tb017_fornecedores VALUES(DEFAULT, 'Empresa 25', 'Nome Fantasia - Empresa 25', '(41) 3343-4569',9);
INSERT INTO tb017_fornecedores VALUES(DEFAULT, 'Empresa 26', 'Nome Fantasia - Empresa 26', '(41) 3343-4570',9);
INSERT INTO tb017_fornecedores VALUES(DEFAULT, 'Empresa 27', 'Nome Fantasia - Empresa 27', '(41) 3343-4571',9);
INSERT INTO tb017_fornecedores VALUES(DEFAULT, 'Empresa 28', 'Nome Fantasia - Empresa 28', '(41) 3343-4572',9);
INSERT INTO tb017_fornecedores VALUES(DEFAULT, 'Empresa 29', 'Nome Fantasia - Empresa 29', '(41) 3343-4573',9);
INSERT INTO tb017_fornecedores VALUES(DEFAULT, 'Empresa 30', 'Nome Fantasia - Empresa 30', '(41) 3343-4574',9);
INSERT INTO tb017_fornecedores VALUES(DEFAULT, 'Empresa 31', 'Nome Fantasia - Empresa 31', '(41) 3343-4575',10);
INSERT INTO tb017_fornecedores VALUES(DEFAULT, 'Empresa 32', 'Nome Fantasia - Empresa 32', '(41) 3343-4576',11);
INSERT INTO tb017_fornecedores VALUES(DEFAULT, 'Empresa 33', 'Nome Fantasia - Empresa 33', '(41) 3343-4577',12);

-- tb010_012_vendas  
DELETE FROM tb010_012_vendas;

INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000000, 10,  4, '2024-03-11', 2, 1.42);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000001, 10,  2, '2024-03-12', 3, 0.94);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000002, 10,  3, '2024-03-13', 1, 1.10);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000003, 11,  5, '2024-03-14', 2, 2.46);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000004, 11,  5, '2024-03-15', 2, 2.62);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000005, 11,  6, '2024-03-16', 1, 3.22);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000006, 12,  8, '2024-03-17', 1, 1.10);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000007, 12,  7, '2024-03-18', 1, 1.10);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000008, 12,  7, '2024-03-19', 2, 0.83);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000009, 13,  9, '2024-03-20', 2, 3.76);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000010, 13, 10, '2024-03-21', 1, 3.54);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000011, 13, 11, '2024-03-22', 2, 3.34);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000012, 14, 13, '2024-03-23', 3, 0.51);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000013, 14, 12, '2024-03-24', 2, 0.51);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000014, 14, 13, '2024-03-25', 1, 0.45);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000015, 15, 14, '2024-03-26', 1, 1.42);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000016, 15, 15, '2024-03-27', 1, 1.55);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000017, 15, 16, '2024-03-28', 1, 1.42);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000018, 16, 17, '2024-03-29', 2, 2.22);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000019, 16, 18, '2024-03-30', 2, 1.58);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000020, 16, 19, '2024-03-31', 2, 1.63);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000021, 17, 20, '2024-04-01', 1, 1.10);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000022, 17, 21, '2024-04-02', 3, 1.10);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000023, 17, 22, '2024-04-03', 2, 0.83);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000024, 18, 23, '2024-04-04', 3, 1.58);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000025, 18, 24, '2024-04-05', 1, 1.63);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000026, 18, 25, '2024-04-06', 2, 1.10);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000027, 19, 26, '2024-04-07', 4, 2.22);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000028, 30,  1, '2024-04-08', 3, 1152.62);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000029, 30,  2, '2024-04-09', 2, 1137.58);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000030, 31,  3, '2024-04-10', 2, 1760.00);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000031, 31,  4, '2024-04-11', 1, 1600.00);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000032, 32,  5, '2024-04-12', 1, 574.40);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000033, 32,  6, '2024-04-13', 1, 577.79);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000034, 33,  7, '2024-04-14', 1, 894.40);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000035, 33,  8, '2024-04-15', 1, 737.79);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000036, 34,  9, '2024-04-16', 1, 24.00);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000037, 34, 10, '2024-04-17', 1, 27.20);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000038, 35, 11, '2024-04-18', 1, 35.20);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000039, 35, 12, '2024-04-19', 2, 49.60);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000040, 36, 14, '2024-04-20', 2, 43.20);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000041, 37, 15, '2024-04-21', 1, 52.80);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000042, 38, 17, '2024-04-22', 1, 43.20);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000043, 39, 18, '2024-04-23', 1, 52.80);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000044, 40, 20, '2024-03-16', 1, 1643.31);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000045, 41, 21, '2024-03-17', 1, 2949.74);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000046, 42, 24, '2024-03-18', 2, 203.31);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000047, 43, 25, '2024-03-19', 1, 229.74);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000048, 44, 28, '2024-03-20', 1, 660.91);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000049, 45, 29, '2024-03-21', 1, 732.14);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000050, 46, 32, '2024-03-22', 1, 340.91);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000015, 47, 33, '2024-03-23', 3, 143.34);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000016, 48, 36, '2024-03-24', 1, 1968.94);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000017, 49, 37, '2024-03-25', 2, 980.91);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000018, 50, 40, '2024-03-26', 1, 18.54);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000019, 51,  4, '2024-03-27', 1, 17.26);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000020, 52,  2, '2024-03-28', 4, 18.56);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000021, 53,  3, '2024-03-29', 1, 17.28);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000022, 54,  5, '2024-03-30', 3, 18.58);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000023, 55,  5, '2024-03-31', 1, 17.30);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000024, 56,  6, '2024-04-01', 2, 18.59);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000025, 57,  8, '2024-04-02', 1, 17.31);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000026, 58,  7, '2024-04-03', 1, 18.61);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000027, 59,  7, '2024-04-04', 2, 0.69);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000028, 60,  9, '2024-04-05', 2, 95.18);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000029, 60, 10, '2024-04-06', 1, 122.38);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000030, 61, 11, '2024-03-16', 2, 29.94);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000031, 61, 13, '2024-03-17', 1, 29.97);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000032, 62, 12, '2024-03-18', 2, 29.98);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000033, 62, 13, '2024-03-19', 1, 47.60);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000034, 63, 14, '2024-03-20', 2, 36.72);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000037, 63, 15, '2024-03-21', 1, 51.68);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000038, 64, 16, '2024-03-22', 2, 29.92);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000039, 64, 17, '2024-03-23', 1, 47.60);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000040, 65, 18, '2024-03-24', 2, 38.19);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000041, 65, 19, '2024-03-25', 1, 43.54);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000000, 66, 20, '2024-03-26', 1, 14.94);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000001, 66, 21, '2024-03-27', 2, 14.94);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000002, 67, 22, '2024-03-28', 1, 13.46);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000003, 67, 23, '2024-03-29', 2, 16.42);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000004, 68, 24, '2024-03-30', 1, 21.71);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000005, 68, 25, '2024-03-31', 3, 21.65);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000006, 69, 26, '2024-04-01', 1, 27.18);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000007, 70,  1, '2024-04-02', 3, 135.98);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000008, 70,  2, '2024-04-03', 1, 163.18);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000009, 71,  3, '2024-04-04', 1, 47.60);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000010, 71,  4, '2024-04-05', 2, 47.60);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000011, 72,  5, '2024-04-06', 1, 50.32);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000000, 72,  6, '2024-03-16', 1, 50.32);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000001, 73,  7, '2024-03-17', 2, 36.72);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000002, 73,  8, '2024-03-18', 1, 51.78);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000003, 74,  9, '2024-03-19', 1, 30.06);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000004, 74, 10, '2024-03-20', 1, 47.60);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000005, 75, 11, '2024-03-21', 1, 38.19);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000006, 75, 12, '2024-03-22', 2, 43.60);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000007, 76, 14, '2024-03-23', 1, 14.94);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000008, 76, 15, '2024-03-24', 2, 14.94);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000009, 77, 17, '2024-03-25', 1, 13.46);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000010, 77, 18, '2024-03-26', 1, 16.40);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000011, 78, 20, '2024-03-27', 1, 27.18);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000012, 78, 21, '2024-03-28', 3, 38.38);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000013, 79, 24, '2024-03-29', 1, 189.49);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000014, 79, 25, '2024-03-30', 1, 161.84);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000015, 80, 28, '2024-03-31', 2, 27.18);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000012, 80, 29, '2024-04-01', 1, 35.34);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000013, 81, 32, '2024-04-02', 1, 27.18);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000014, 81, 33, '2024-04-03', 1, 35.34);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000015, 82, 36, '2024-04-04', 2, 54.38);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000013, 82, 37, '2024-04-05', 1, 81.58);
INSERT INTO tb010_012_vendas VALUES(DEFAULT, 10000000014, 83, 40, '2024-04-06', 1, 14.38);

-- tb012_017_compras
DELETE FROM tb012_017_compras;

INSERT INTO tb012_017_compras VALUES(DEFAULT, 10,  4, '2024-01-01', 3, 0.89);
INSERT INTO tb012_017_compras VALUES(DEFAULT, 10,  2, '2024-01-02', 1, 0.59);
INSERT INTO tb012_017_compras VALUES(DEFAULT, 10,  3, '2024-01-03', 2, 0.69);
INSERT INTO tb012_017_compras VALUES(DEFAULT, 11,  5, '2024-01-04', 3, 1.54);
INSERT INTO tb012_017_compras VALUES(DEFAULT, 11,  5, '2024-01-05', 1, 1.64);
INSERT INTO tb012_017_compras VALUES(DEFAULT, 11,  6, '2024-01-06', 2, 2.01);
INSERT INTO tb012_017_compras VALUES(DEFAULT, 12,  8, '2024-01-07', 3, 0.69);
INSERT INTO tb012_017_compras VALUES(DEFAULT, 12,  7, '2024-01-08', 3, 0.69);
INSERT INTO tb012_017_compras VALUES(DEFAULT, 12,  7, '2024-01-09', 3, 0.52);
INSERT INTO tb012_017_compras VALUES(DEFAULT, 13,  9, '2024-01-10', 3, 2.35);
INSERT INTO tb012_017_compras VALUES(DEFAULT, 13, 10, '2024-01-11', 3, 2.21);
INSERT INTO tb012_017_compras VALUES(DEFAULT, 13, 11, '2024-01-12', 4, 2.09);
INSERT INTO tb012_017_compras VALUES(DEFAULT, 14, 13, '2024-01-13', 4, 0.32);
INSERT INTO tb012_017_compras VALUES(DEFAULT, 14, 12, '2024-01-14', 4, 0.32);
INSERT INTO tb012_017_compras VALUES(DEFAULT, 14, 13, '2024-01-15', 4, 0.28);
INSERT INTO tb012_017_compras VALUES(DEFAULT, 15, 14, '2024-01-16', 5, 0.89);
INSERT INTO tb012_017_compras VALUES(DEFAULT, 15, 15, '2024-01-17', 5, 0.97);
INSERT INTO tb012_017_compras VALUES(DEFAULT, 15, 16, '2024-01-18', 5, 0.89);
INSERT INTO tb012_017_compras VALUES(DEFAULT, 16, 17, '2024-02-19', 5, 1.39);
INSERT INTO tb012_017_compras VALUES(DEFAULT, 16, 18, '2024-02-20', 6, 0.99);
INSERT INTO tb012_017_compras VALUES(DEFAULT, 16, 19, '2024-02-21', 6, 1.02);
INSERT INTO tb012_017_compras VALUES(DEFAULT, 17, 20, '2024-02-22', 3, 0.69);
INSERT INTO tb012_017_compras VALUES(DEFAULT, 17, 21, '2024-02-23', 4, 0.69);
INSERT INTO tb012_017_compras VALUES(DEFAULT, 17, 22, '2024-02-24', 2, 0.52);
INSERT INTO tb012_017_compras VALUES(DEFAULT, 18, 23, '2024-02-25', 5, 0.99);
INSERT INTO tb012_017_compras VALUES(DEFAULT, 18, 24, '2024-02-26', 3, 1.02);
INSERT INTO tb012_017_compras VALUES(DEFAULT, 18, 25, '2024-02-27', 4, 0.69);
INSERT INTO tb012_017_compras VALUES(DEFAULT, 19, 26, '2024-02-28', 3, 1.39);
INSERT INTO tb012_017_compras VALUES(DEFAULT, 30,  1, '2024-02-10', 5, 720.39);
INSERT INTO tb012_017_compras VALUES(DEFAULT, 30,  2, '2024-02-11', 5, 710.99);
INSERT INTO tb012_017_compras VALUES(DEFAULT, 31,  3, '2024-02-13', 3, 1100.00);
INSERT INTO tb012_017_compras VALUES(DEFAULT, 31,  4, '2024-02-14', 2, 1000.00);
INSERT INTO tb012_017_compras VALUES(DEFAULT, 32,  5, '2024-02-15', 1, 359.00);
INSERT INTO tb012_017_compras VALUES(DEFAULT, 32,  6, '2024-02-16', 3, 361.12);
INSERT INTO tb012_017_compras VALUES(DEFAULT, 33,  7, '2024-02-17', 3, 559.00);
INSERT INTO tb012_017_compras VALUES(DEFAULT, 33,  8, '2024-02-18', 3, 461.12);
INSERT INTO tb012_017_compras VALUES(DEFAULT, 34,  9, '2024-02-19', 5, 15.00);
INSERT INTO tb012_017_compras VALUES(DEFAULT, 34, 10, '2024-02-20', 2, 17.00);
INSERT INTO tb012_017_compras VALUES(DEFAULT, 35, 11, '2024-02-21', 5, 22.00);
INSERT INTO tb012_017_compras VALUES(DEFAULT, 35, 12, '2024-02-22', 3, 31.00);
INSERT INTO tb012_017_compras VALUES(DEFAULT, 36, 14, '2024-02-23', 4, 27.00);
INSERT INTO tb012_017_compras VALUES(DEFAULT, 37, 15, '2024-02-24', 5, 33.00);
INSERT INTO tb012_017_compras VALUES(DEFAULT, 38, 17, '2024-02-25', 3, 27.00);
INSERT INTO tb012_017_compras VALUES(DEFAULT, 39, 18, '2024-01-26', 5, 33.00);