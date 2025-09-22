  -- extensão FDW no banco DW
CREATE EXTENSION IF NOT EXISTS postgres_fdw;

CREATE SCHEMA IF NOT EXISTS varejo_bdiii;

DROP SERVER IF EXISTS varejo_bdiii_srv CASCADE;
CREATE SERVER varejo_bdiii_srv
  FOREIGN DATA WRAPPER postgres_fdw
  OPTIONS (host 'localhost', dbname 'varejo_bdiii', port '5432');

CREATE USER MAPPING FOR postgres
  SERVER varejo_bdiii_srv
  OPTIONS (user 'postgres', password 'specspidey'); --troquem aqui pelo usuário e senha de vocês

IMPORT FOREIGN SCHEMA public
  FROM SERVER varejo_bdiii_srv
  INTO varejo_bdiii;

