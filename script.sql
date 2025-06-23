DROP TABLE IF EXISTS saneamento;

CREATE TABLE saneamento (
	saneamento_pais_nome													varchar(50),
	porcentagem_urbana_com_acesso_a_instalacoes_basicas					real,
	porcentagem_rural_com_acesso_a_instalacoes_basicas						real,
	taxa_de_morte_a_cada_100000_mortes_devido_a_sanitacao_nao_segura		real,

	CONSTRAINT PK_saneamento
		PRIMARY KEY (saneamento_pais_nome)
);

DROP TABLE IF EXISTS higiene;

CREATE TABLE higiene (
	higiene_pais_nome																		varchar(50),
	porcentagem_urbana_com_acesso_a_instalacoes_basicas									real,
	porcentagem_rural_com_acesso_a_instalacoes_basicas										real,
	taxa_de_morte_a_cada_100000_mortes_devido_a_falta_instalacoes_de_lavagem_de_maos		real,

	CONSTRAINT PK_higiene
		PRIMARY KEY (higiene_pais_nome)
);

DROP TABLE IF EXISTS agua_potavel;

CREATE TABLE agua_potavel (
	agua_potavel_pais_nome													varchar(50),
	porcentagem_urbana_com_acesso_a_instalacoes_basicas					real,
	porcentagem_rural_com_acesso_a_instalacoes_basicas						real,
	taxa_de_morte_a_cada_100000_mortes_devido_a_agua_nao_segura			real,

	CONSTRAINT PK_agua_potavel
		PRIMARY KEY (agua_potavel_pais_nome)
);

DROP TABLE IF EXISTS economia;

CREATE TABLE economia (
	economia_pais_nome		varchar(50),
	taxa_de_desemprego		real,
	GINI					real,
	PIB_per_capita			real,

	CONSTRAINT PK_economia
		PRIMARY KEY (economia_pais_nome)
);

DROP TABLE IF EXISTS qualidade_de_vida;

CREATE TABLE qualidade_de_vida (
	qualidade_de_vida_pais_nome												varchar(50),
	IDH																		real,
	expectativa_de_vida														real,

	CONSTRAINT PK_qualidade_de_vida
		PRIMARY KEY (qualidade_de_vida_pais_nome)
);

DROP TABLE IF EXISTS emissao_gases;

CREATE TABLE emissao_gases (
	emissao_gases_pais_nome						varchar(50),
	emissao_N2O_em_quilotoneladas_por_ano		real,
	emissao_CO2_em_quilotoneladas_por_ano		real,
	emissao_CH4_em_quilotoneladas_por_ano		real,

	CONSTRAINT PK_emissao_gases
		PRIMARY KEY (emissao_gases_pais_nome)
);

DROP TABLE IF EXISTS agua_disponibilidade_e_tratamento;

CREATE TABLE agua_disponibilidade_e_tratamento (
	agua_disponibilidade_e_tratamento_pais_nome				varchar(50),
	precipitacao_milhoes_de_metros_cubicos_por_ano				real,
	agua_suja_gerada_em_1000_metros_cubicos_por_dia			real,
	agua_suja_nao_tratada_em_1000_metros_cubicos_por_dia		real,

	CONSTRAINT PK_agua_disponibilidade_e_tratamento
		PRIMARY KEY (agua_disponibilidade_e_tratamento_pais_nome)
);

DROP TABLE IF EXISTS desenvolvimento_da_area_da_saude;

CREATE TABLE desenvolvimento_da_area_da_saude (
	desenvolvimento_da_area_da_saude_pais_nome							varchar(50),
	numero_de_casos_de_colera											integer,
	taxa_de_medicos_a_cada_1000_cidadaos								real,
	numero_de_camas_hospitalares_a_cada_10000_cidadaos					real,

	CONSTRAINT PK_desenvolvimento_da_area_da_saude
		PRIMARY KEY (desenvolvimento_da_area_da_saude_pais_nome)
);

DROP TABLE IF EXISTS pais;

CREATE TABLE pais (
	nome											varchar(50) NOT NULL,
	numero_de_habitantes_em_milhares				int		NOT NULL,

	CONSTRAINT PK_nome
		PRIMARY KEY (nome)
);

ALTER TABLE saneamento
       ADD CONSTRAINT FK01_pais_saneamento
              FOREIGN KEY (saneamento_pais_nome)
                             REFERENCES pais (nome);

ALTER TABLE higiene
       ADD CONSTRAINT FK02_pais_higiene
              FOREIGN KEY (higiene_pais_nome)
                             REFERENCES pais (nome);

ALTER TABLE agua_potavel
       ADD CONSTRAINT FK03_pais_agua_potavel
              FOREIGN KEY (agua_potavel_pais_nome)
                             REFERENCES pais (nome);


ALTER TABLE economia
       ADD CONSTRAINT FK04_pais_economia
              FOREIGN KEY (economia_pais_nome)
                             REFERENCES pais (nome);

ALTER TABLE qualidade_de_vida
       ADD CONSTRAINT FK05_pais_qualidade_de_vida
              FOREIGN KEY (qualidade_de_vida_pais_nome)
                             REFERENCES pais (nome);

ALTER TABLE emissao_gases
       ADD CONSTRAINT FK06_emissao_gases
              FOREIGN KEY (emissao_gases_pais_nome)
                             REFERENCES pais (nome);

ALTER TABLE agua_disponibilidade_e_tratamento
       ADD CONSTRAINT FK07_agua_disponibilidade_e_tratamento
              FOREIGN KEY (agua_disponibilidade_e_tratamento_pais_nome)
                             REFERENCES pais (nome);

ALTER TABLE desenvolvimento_da_area_da_saude
       ADD CONSTRAINT FK08_desenvolvimento_da_area_da_saude
              FOREIGN KEY (desenvolvimento_da_area_da_saude_pais_nome)
                             REFERENCES pais (nome);

SELECT
	CASE
		WHEN e.PIB_per_capita > 30000 THEN 'País de Alta Renda'
		WHEN e.PIB_per_capita > 10000 THEN 'País de Média Renda'
		WHEN e.PIB_per_capita > 0 THEN 'País de Baixa Renda'
		ELSE 'Desconhecido'
	END AS desenvolvimento,
	AVG(s.porcentagem_urbana_com_acesso_a_instalacoes_basicas) AS media_urbana_acesso
FROM saneamento s
INNER JOIN economia e ON s.saneamento_pais_nome = e.economia_pais_nome
GROUP BY desenvolvimento
ORDER BY media_urbana_acesso DESC;

SELECT
	CASE
		WHEN a.taxa_de_morte_a_cada_100000_mortes_devido_a_agua_nao_segura > 30000 THEN 'País com Muita Chuva'
		WHEN a.taxa_de_morte_a_cada_100000_mortes_devido_a_agua_nao_segura > 10000 THEN 'País com Moderada Chuva'
		WHEN a.taxa_de_morte_a_cada_100000_mortes_devido_a_agua_nao_segura > 0 THEN 'País com Pouca Chuva'
		ELSE 'Desconhecido'
	END AS ,
	AVG(d.numero_de_casos_de_colera/p.numero_de_habitantes_em_milhares) AS media_taxa_colera
FROM agua_potavel a
INNER JOIN desenvolvimento_da_area_da_saude d ON a.agua_potavel_pais_nome = d.desenvolvimento_da_area_da_saude_pais_nome
INNER JOIN pais p ON a.agua_potavel_pais_nome = p.nome
GROUP BY 
ORDER BY media_taxa_de_morte_a_cada_100000_morte_por_agua_nao_segura DESC;