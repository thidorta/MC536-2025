# Consultas SQL Não Triviais – Análise Multissetorial de Indicadores

Este documento apresenta cinco consultas SQL avançadas que integram dados de múltiplas tabelas do banco de dados.

**Observações sobre as consultas:**

-Foram realizadas consultas sobre áreas urbanas, em maior parte, pois contém o maior número de pessoas

-Não foi realizado uma média entre área urbana e rural, pois seria necessário saber a quantidade de pessoas em cada área individual


---

## Consulta 1: Relação entre a força da economia do país e o accesso a saneamento básico.

**Objetivo:** Prova que países ricos tem maior acesso ao saneamento básico.

```sql
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
```
---

## Consulta 2: A colera é obtida por água ou alimentos contaminados.

**Objetivo:** Assim a consulta serve para confirmar a relação entre falta de acesso a fonte de água segura e doenças como a colera.

```sql
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
GROUP BY acesso_a_instalacoes_basicas_de_agua_potavel
ORDER BY media_taxa_colera DESC;
```
---

## Consulta 3: Compara a taxa de morte por falta de higiene com expectativa de vida.

**Objetivo:** Permite ter noção do grau de impacto da higiene na expectativa de vida.

```sql
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
```
---

## Consulta 4: Comparativo da Taxa de Mortalidade por Saneamento e Higiene segundo a Disponibilidade de Médicos

**Objetivo:** Agrupa países por faixas de taxa de médicos por 1000 habitantes e calcula a média da mortalidade causada por saneamento precário, falta de higiene e água não potável em cada grupo.

```sql
SELECT
	CASE
		WHEN d.taxa_de_medicos_a_cada_1000_cidadaos > 2 THEN 'Países com Alta Taxa de Médicos'
		WHEN d.taxa_de_medicos_a_cada_1000_cidadaos > 1 THEN 'Países com Média Taxa de Médicos'
		WHEN d.taxa_de_medicos_a_cada_1000_cidadaos > 0 THEN 'Países com Baixa Taxa de Médicos'
		ELSE 'Desconhecido'
	END AS taxa_medicos_a_cada_1000_cidadaos,
	AVG(s.taxa_de_morte_a_cada_100000_mortes_devido_a_sanitacao_nao_segura + h.taxa_de_morte_a_cada_100000_mortes_devido_a_falta_instalacoes_de_lavagem_de_maos + a.taxa_de_morte_a_cada_100000_mortes_devido_a_agua_nao_segura) AS taxa_de_morte_a_cada_100000_mortes_por_falta_de_saneamento_higiene_ou_agua_potavel_seguro
FROM desenvolvimento_da_area_da_saude d
INNER JOIN saneamento s ON d.desenvolvimento_da_area_da_saude_pais_nome = s.saneamento_pais_nome
INNER JOIN higiene h ON d.desenvolvimento_da_area_da_saude_pais_nome = h.higiene_pais_nome
INNER JOIN agua_potavel a ON d.desenvolvimento_da_area_da_saude_pais_nome = a.agua_potavel_pais_nome
GROUP BY taxa_medicos_a_cada_1000_cidadaos
ORDER BY taxa_de_morte_a_cada_100000_mortes_por_falta_de_saneamento_higiene_ou_agua_potavel_seguro DESC;
```
---

## Consulta 5: Mortalidade por Saneamento vs. Taxa de Desemprego

**Objetivo:** Agrupa países por faixas de taxa de desemprego e calcula a média da mortalidade relacionada à falta de saneamento, higiene e água potável, avaliando o possível impacto do desemprego na preservação de condições sanitárias básicas.

```sql
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
```
---
