DROP TABLE IF EXISTS saneamento;

CREATE TABLE saneamento (
	saneamento_id												smallserial,
	saneamento_pais_id											smallserial,
	porcentagem_urbana_com_instalacoes_basicas					real,
	porcentagem_rural_com_instalacoes_basicas					real,
	morte_por_sanitacao_nao_segura_a_cada_100000_mortes		real,
	CONSTRAINT PK_saneamento
		PRIMARY KEY (saneamento_id)
);

DROP TABLE IF EXISTS higiene;

CREATE TABLE higiene (
	higiene_id													smallserial,
	higiene_pais_id												smallserial,
	porcentagem_urbana_com_instalacoes_basicas					real,
	porcentagem_rural_com_instalacoes_basicas					real,
	morte_por_sanitacao_nao_segura_a_cada_100000_mortes		real,
	CONSTRAINT PK_higiene
		PRIMARY KEY (higiene_id)
);

DROP TABLE IF EXISTS agua_potavel;

CREATE TABLE agua_potavel (
	agua_potavel_id												smallserial,
	agua_potavel_pais_id										smallserial,
	porcentagem_urbana_com_instalacoes_basicas					real,
	porcentagem_rural_com_instalacoes_basicas					real,
	morte_por_sanitacao_nao_segura_a_cada_100000_mortes		real,
	CONSTRAINT PK_agua_potavel
		PRIMARY KEY (agua_potavel_id)
);

DROP TABLE IF EXISTS quimicos;

CREATE TABLE quimicos (
	quimicos_id							smallserial,
	quimicos_pais_id					smallserial,
	concentracao_de_amonio_mg_por_L	real,
	concentracao_de_nitrato_mg_por_L	real,
	concentracao_de_fosforo_mg_por_L	real,
	CONSTRAINT PK_quimicos
		PRIMARY KEY (quimicos_id)
);

DROP TABLE IF EXISTS paises;

CREATE TABLE paises (
	pais_id					smallserial,
	nome					varchar(20) NOT NULL,
	continente				varchar(20) NOT NULL,
	GDP						real,
	CONSTRAINT PK_paises
		PRIMARY KEY (pais_id)
);

ALTER TABLE saneamento
       ADD CONSTRAINT FK01_paises_saneamento
              FOREIGN KEY (saneamento_pais_id)
                             REFERENCES paises (pais_id);

ALTER TABLE higiene
       ADD CONSTRAINT FK02_paises_higiene
              FOREIGN KEY (higiene_pais_id)
                             REFERENCES paises (pais_id);

ALTER TABLE agua_potavel
       ADD CONSTRAINT FK03_paises_agua_potavel
              FOREIGN KEY (agua_potavel_pais_id)
                             REFERENCES paises (pais_id);

ALTER TABLE quimicos
       ADD CONSTRAINT FK04_paises_quimicos
              FOREIGN KEY (quimicos_pais_id)
                             REFERENCES paises (pais_id);