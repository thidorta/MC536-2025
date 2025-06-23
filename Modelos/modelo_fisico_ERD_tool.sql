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
	agua_doce_coletada_em_1000_metros_cubicos_por_dia			real,
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

/*
Observaçoes sobre as consultas:

-Foram realizadas consultas sobre áreas urbanas, em maior parte, pois contém o maior número de pessoas

-Não foi realizado uma média entre área urbana e rural, pois seria necessário saber a quantidade de pessoas em cada área individual
*/


/*
Relação entre a força da economia do país e o accesso a saneamento básico.
Prova que países ricos tem maior acesso ao saneamento básico.
*/
SELECT
	CASE
		WHEN e.PIB_per_capita > 30000 THEN 'Países de Alta Renda'
		WHEN e.PIB_per_capita > 10000 THEN 'Países de Média Renda'
		WHEN e.PIB_per_capita > 0 THEN 'Países de Baixa Renda'
		ELSE 'Desconhecido'
	END AS desenvolvimento,
	AVG(s.porcentagem_urbana_com_acesso_a_instalacoes_basicas) AS media_urbana_com_acesso_a_instalacoes_basicas_de_saneamento
FROM economia e
INNER JOIN saneamento s ON e.economia_pais_nome = s.saneamento_pais_nome
GROUP BY desenvolvimento
ORDER BY media_urbana_com_acesso_a_instalacoes_basicas_de_saneamento DESC;


/*
A colera é obtida por água ou alimentos contaminados.
Assim a consulta serve para confirmar a relação entre falta de acesso a fonte de água segura e doenças como a colera.
*/
SELECT
	CASE
		WHEN a.porcentagem_urbana_com_acesso_a_instalacoes_basicas > 95 THEN 'Países com Alta Acesso em Áreas Urbanas a Água Potável Segura'
		WHEN a.porcentagem_urbana_com_acesso_a_instalacoes_basicas > 80 THEN 'Países com Médio Acesso em Áreas Urbanas a Água Potável Segura'
		WHEN a.porcentagem_urbana_com_acesso_a_instalacoes_basicas > 0 THEN 'Países com Baixo Acesso em Áreas Urbanas a Água Potável Segura'
		ELSE 'Desconhecido'
	END AS acesso_a_instalacoes_basicas_de_agua_potavel,
	AVG(d.numero_de_casos_de_colera/p.numero_de_habitantes_em_milhares) AS media_taxa_colera
FROM agua_potavel a
INNER JOIN desenvolvimento_da_area_da_saude d ON a.agua_potavel_pais_nome = d.desenvolvimento_da_area_da_saude_pais_nome
INNER JOIN pais p ON a.agua_potavel_pais_nome = p.nome
<<<<<<< HEAD:Modelos/modelo_fisico.sql
GROUP BY acesso_a_instalacoes_basicas_de_agua_potavel
ORDER BY media_taxa_colera DESC;


/*
Compara a taxa de morte por falta de hígiene com expectativa de vida.
Prmite ter noção do grau de impacto da higíene na expectativa de vida.
*/
SELECT
	CASE
		WHEN h.taxa_de_morte_a_cada_100000_mortes_devido_a_falta_instalacoes_de_lavagem_de_maos > 50 THEN 'Países com Alta Taxa de Morte por Falta de Instalações de Higiene Básica'
		WHEN h.taxa_de_morte_a_cada_100000_mortes_devido_a_falta_instalacoes_de_lavagem_de_maos > 20 THEN 'Países com Média Taxa de Morte por Falta de Instalações de Higiene Básica'
		WHEN h.taxa_de_morte_a_cada_100000_mortes_devido_a_falta_instalacoes_de_lavagem_de_maos > 0 THEN 'Países com Baixa Taxa de Morte por Falta de Instalações de Higiene Básica'
		ELSE 'Desconhecido'
	END AS taxa_de_morte_por_falta_de_instalacoes_de_higiene_basica,
	AVG(q.expectativa_de_vida) AS media_expectativa_de_vida
FROM higiene h
INNER JOIN qualidade_de_vida q ON h.higiene_pais_nome = q.qualidade_de_vida_pais_nome
GROUP BY taxa_de_morte_por_falta_de_instalacoes_de_higiene_basica
ORDER BY media_expectativa_de_vida DESC;


/*
Além de a taxa de morte poder ser evitada ao minimizar o risco de contaminação com base na erradicação, ao máximo do possível, dos métodos de transmissão.
O tratamento de um indivíduo já infectado é outra maneira.

Assim descobrir o grau de redução ao se utilizar esse método é importante.
Para o que serve essa tabela.
*/
SELECT
	CASE
		WHEN d.taxa_de_medicos_a_cada_1000_cidadaos > 2 THEN 'Países com Alta Taxa de Médicos'
		WHEN d.taxa_de_medicos_a_cada_1000_cidadaos > 1 THEN 'Países com Média Taxa de Médicos'
		WHEN d.taxa_de_medicos_a_cada_1000_cidadaos > 0 THEN 'Países com Baixa Taxa de Médicos'
		ELSE 'Desconhecido'
	END AS taxa_de_medicos,
	AVG(s.taxa_de_morte_a_cada_100000_mortes_devido_a_sanitacao_nao_segura + h.taxa_de_morte_a_cada_100000_mortes_devido_a_falta_instalacoes_de_lavagem_de_maos + a.taxa_de_morte_a_cada_100000_mortes_devido_a_agua_nao_segura) AS taxa_saneamento_higiene_e_agua_potavel
FROM desenvolvimento_da_area_da_saude d
INNER JOIN saneamento s ON d.desenvolvimento_da_area_da_saude_pais_nome = s.saneamento_pais_nome
INNER JOIN higiene h ON d.desenvolvimento_da_area_da_saude_pais_nome = h.higiene_pais_nome
INNER JOIN agua_potavel a ON d.desenvolvimento_da_area_da_saude_pais_nome = a.agua_potavel_pais_nome
GROUP BY taxa_de_medicos
ORDER BY taxa_saneamento_higiene_e_agua_potavel DESC;


/*
Os problemas de saneamento, higíene e acesso a água potável podem ser solucionados por instalações públicas, como banheiros e bebedoutos públicos.
Entretanto, raramente se vê um país com grande número deste tipo de instalações.
Portanto, se vê necessário a necessidade da posse de um banheiro com encanamento seguro.

Com isso em mente, o desemprego, que é uma ameaça para preservar posses privadas facilmente se um grande causador de mortes relacionadas.
Assim se faz uma consulta para ver o grau de importância
*/
SELECT
	CASE
		WHEN e.taxa_de_desemprego > 10 THEN 'Países com Alta Taxa de Desemprego'
		WHEN e.taxa_de_desemprego > 5 THEN 'Países com Média Taxa de Desemprego'
		WHEN e.taxa_de_desemprego > 0 THEN 'Países com Baixa Taxa de Desemprego'
		ELSE 'Desconhecido'
	END AS taxa_desemprego,
	AVG(s.taxa_de_morte_a_cada_100000_mortes_devido_a_sanitacao_nao_segura + h.taxa_de_morte_a_cada_100000_mortes_devido_a_falta_instalacoes_de_lavagem_de_maos + a.taxa_de_morte_a_cada_100000_mortes_devido_a_agua_nao_segura) AS taxa_saneamento_higiene_e_agua_potavel
FROM economia e
INNER JOIN saneamento s ON e.economia_pais_nome = s.saneamento_pais_nome
INNER JOIN higiene h ON e.economia_pais_nome = h.higiene_pais_nome
INNER JOIN agua_potavel a ON e.economia_pais_nome = a.agua_potavel_pais_nome
GROUP BY taxa_desemprego
ORDER BY taxa_saneamento_higiene_e_agua_potavel DESC;
=======
GROUP BY 
ORDER BY media_taxa_de_morte_a_cada_100000_morte_por_agua_nao_segura DESC;
