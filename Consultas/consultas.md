# Consultas SQL Não Triviais – Análise Multissetorial de Indicadores

Este documento apresenta cinco consultas SQL avançadas que integram dados de múltiplas tabelas do banco de dados.

**Observações sobre as consultas:**

-Foram realizadas consultas sobre áreas urbanas, em maior parte, pois contém o maior número de pessoas

-Não foi realizado uma média entre área urbana e rural, pois seria necessário saber a quantidade de pessoas em cada área individual


---

## Consulta 1: Relação entre a força da economia do país e o accesso a saneamento básico.

**Descrição:** Prova que países ricos tem maior acesso ao saneamento básico.

```sql
SELECT
	CASE
		WHEN e.PIB_per_capita > 30000 THEN 'Países de Alta Renda'
		WHEN e.PIB_per_capita > 10000 THEN 'Países de Média Renda'
		WHEN e.PIB_per_capita > 0 THEN 'Países de Baixa Renda'
		ELSE 'Desconhecido'
	END AS intervalo_de_renda,
	AVG(s.porcentagem_urbana_com_acesso_a_instalacoes_basicas) AS media_da_taxa_urbana_com_acesso_a_instalacoes_basicas_de_saneamento
FROM economia e
INNER JOIN saneamento s ON e.economia_pais_nome = s.saneamento_pais_nome
GROUP BY intervalo_de_renda
ORDER BY media_da_taxa_urbana_com_acesso_a_instalacoes_basicas_de_saneamento DESC;
```
---

## Consulta 2: A colera é obtida por água ou alimentos contaminados.

**Descrição:** A chuva, em geral, é uma fonte de água limpa (com exceção a contaminações por radiação ou gases).
Com isso em mente, pretende-se verificar se países com maior chuva tem menor problema em relação a taxa de morte por falta de água potável segura.

```sql
SELECT
	CASE
		WHEN (t.precipitacao_milhoes_de_metros_cubicos_por_ano/p.numero_de_habitantes_em_milhares) > 10 THEN 'Países com Muita Chuva em Relação ao Número de Habitantes'
		WHEN (t.precipitacao_milhoes_de_metros_cubicos_por_ano/p.numero_de_habitantes_em_milhares) > 5 THEN 'Países com Média Chuva em Relação ao Número de Habitantes'
		WHEN (t.precipitacao_milhoes_de_metros_cubicos_por_ano/p.numero_de_habitantes_em_milhares) > 0 THEN 'Países com Pouca Chuva em Relação ao Número de Habitantes'
		ELSE 'Desconhecido'
	END AS relação_chuva_população_milhoes_metros_cubicos_de_chuva_por_1000_pessoas,
	AVG(a.taxa_de_morte_a_cada_100000_mortes_devido_a_agua_nao_segura) AS taxa_morte_a_cada_100000_mortes_por_agua_nao_segura
FROM agua_disponibilidade_e_tratamento t
INNER JOIN agua_potavel a ON t.agua_disponibilidade_e_tratamento_pais_nome = a.agua_potavel_pais_nome
INNER JOIN pais p ON t.agua_disponibilidade_e_tratamento_pais_nome = p.nome
GROUP BY relação_chuva_população_milhoes_metros_cubicos_de_chuva_por_1000_pessoas
ORDER BY taxa_morte_a_cada_100000_mortes_por_agua_nao_segura DESC;
```
---

## Consulta 3: Compara a taxa de morte por falta de higiene com expectativa de vida.

**Descrição:** Permite ter noção do grau de impacto da higiene na expectativa de vida.

```sql
SELECT
	CASE
		WHEN h.taxa_de_morte_a_cada_100000_mortes_devido_a_falta_instalacoes_de_lavagem_de_maos > 50 THEN 'Países com Alta Taxa de Morte por Falta de Instalações de Higiene Básica'
		WHEN h.taxa_de_morte_a_cada_100000_mortes_devido_a_falta_instalacoes_de_lavagem_de_maos > 20 THEN 'Países com Média Taxa de Morte por Falta de Instalações de Higiene Básica'
		WHEN h.taxa_de_morte_a_cada_100000_mortes_devido_a_falta_instalacoes_de_lavagem_de_maos > 0 THEN 'Países com Baixa Taxa de Morte por Falta de Instalações de Higiene Básica'
		ELSE 'Desconhecido'
	END AS taxa_de_morte_a_cada_100000_mortes_por_falta_de_instalacoes_de_higiene_basica,
	AVG(q.expectativa_de_vida) AS media_expectativa_de_vida
FROM higiene h
INNER JOIN qualidade_de_vida q ON h.higiene_pais_nome = q.qualidade_de_vida_pais_nome
GROUP BY taxa_de_morte_a_cada_100000_mortes_por_falta_de_instalacoes_de_higiene_basica
ORDER BY media_expectativa_de_vida DESC;
```
---

## Consulta 4: Comparativo da Taxa de Mortalidade por Saneamento e Higiene segundo a Disponibilidade de Médicos

**Descrição:** Agrupa países por faixas de taxa de médicos por 1000 habitantes e calcula a média da mortalidade causada por saneamento precário, falta de higiene e água não potável em cada grupo.

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

**Descrição:** Agrupa países por faixas de taxa de desemprego e calcula a média da mortalidade relacionada à falta de saneamento, higiene e água potável, avaliando o possível impacto do desemprego na preservação de condições sanitárias básicas.

```sql
SELECT
	CASE
		WHEN e.taxa_de_desemprego > 10 THEN 'Países com Alta Taxa de Desemprego'
		WHEN e.taxa_de_desemprego > 5 THEN 'Países com Média Taxa de Desemprego'
		WHEN e.taxa_de_desemprego > 0 THEN 'Países com Baixa Taxa de Desemprego'
		ELSE 'Desconhecido'
	END AS taxa_desemprego,
	AVG(s.taxa_de_morte_a_cada_100000_mortes_devido_a_sanitacao_nao_segura + h.taxa_de_morte_a_cada_100000_mortes_devido_a_falta_instalacoes_de_lavagem_de_maos + a.taxa_de_morte_a_cada_100000_mortes_devido_a_agua_nao_segura) AS taxa_de_morte_a_cada_100000_mortes_por_falta_de_saneamento_higiene_ou_agua_potavel_seguro
FROM economia e
INNER JOIN saneamento s ON e.economia_pais_nome = s.saneamento_pais_nome
INNER JOIN higiene h ON e.economia_pais_nome = h.higiene_pais_nome
INNER JOIN agua_potavel a ON e.economia_pais_nome = a.agua_potavel_pais_nome
GROUP BY taxa_desemprego
ORDER BY taxa_de_morte_a_cada_100000_mortes_por_falta_de_saneamento_higiene_ou_agua_potavel_seguro DESC;
```
---
## Conclusão:

Tendo em vista as consultas aqui tratadas, é visível que as condições financeiras e socieconômicas do país, bem como o número de profissionais da saúde, são mais importantes ao se tratar de acesso à água limpa, saneamento básico e higiene, do que as condições climáticas do país em questão. 
