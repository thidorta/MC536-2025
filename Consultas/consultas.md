# Consultas SQL Não Triviais – Análise Multissetorial de Indicadores

Este documento apresenta cinco consultas SQL avançadas que integram dados de múltiplas tabelas do banco de dados.

---

## Consulta 1: Média de Acesso Urbano em Saneamento, Água Potável e Higiene por Classe de Renda

**Objetivo:** Agrupar os países conforme sua faixa de renda (com base no PIB per capita) e calcular a média de acesso a instalações básicas urbanas para saneamento, água potável e higiene.

**Consulta SQL:**
```sql
SELECT
  CASE
    WHEN e.pib_per_capita > 30000 THEN 'Alta Renda'
    WHEN e.pib_per_capita > 10000 THEN 'Média Renda'
    ELSE 'Baixa Renda'
  END AS classe_renda,
  ROUND(AVG(s.porcentagem_urbana_com_acesso_a_instalacoes_basicas)::numeric,2) AS media_saneamento_urbano,
  ROUND(AVG(ag.porcentagem_urbana_com_acesso_a_instalacoes_basicas)::numeric,2) AS media_agua_urbano,
  ROUND(AVG(h.porcentagem_urbana_com_acesso_a_instalacoes_basicas)::numeric,2) AS media_higiene_urbana
FROM economia e
JOIN saneamento s ON e.economia_pais_nome = s.saneamento_pais_nome
JOIN agua_potavel ag ON e.economia_pais_nome = ag.agua_potavel_pais_nome
JOIN higiene h ON e.economia_pais_nome = h.higiene_pais_nome
GROUP BY classe_renda
ORDER BY media_saneamento_urbano DESC;
```
---

## Consulta 2: Top 10 Países com Melhor Acesso Global

**Objetivo:** Determinar os países com maior média geral de acesso básico (urbano e rural) a instalações de saneamento, água potável e higiene.

```sql
SELECT
  p.nome,
  ROUND(
    (
      COALESCE(s.porcentagem_urbana_com_acesso_a_instalacoes_basicas, 0)
      + COALESCE(s.porcentagem_rural_com_acesso_a_instalacoes_basicas, 0)
      + COALESCE(ag.porcentagem_urbana_com_acesso_a_instalacoes_basicas, 0)
      + COALESCE(ag.porcentagem_rural_com_acesso_a_instalacoes_basicas, 0)
      + COALESCE(h.porcentagem_urbana_com_acesso_a_instalacoes_basicas, 0)
      + COALESCE(h.porcentagem_rural_com_acesso_a_instalacoes_basicas, 0)
    )::numeric / 6
  , 2) AS media_acesso_global
FROM pais p
JOIN saneamento s ON p.nome = s.saneamento_pais_nome
JOIN agua_potavel ag ON p.nome = ag.agua_potavel_pais_nome
JOIN higiene h ON p.nome = h.higiene_pais_nome
ORDER BY media_acesso_global DESC
LIMIT 10;
```
---

## Consulta 3: Top 10 Países com Maior Taxa de Mortalidade Combinada

**Objetivo:** Identificar os países com maior taxa de mortalidade causada por falta de acesso a saneamento seguro, água potável e instalações de lavagem de mãos.

```sql
SELECT
  p.nome,
  ROUND((
    s.taxa_de_morte_a_cada_100000_mortes_devido_a_sanitacao_nao_segura
    + ag.taxa_de_morte_a_cada_100000_mortes_devido_a_agua_nao_segura
    + h.taxa_de_morte_a_cada_100000_mortes_devido_a_falta_instalacoes_de_lavagem_de_maos
  )::numeric, 2) AS mortalidade_total
FROM pais p
JOIN saneamento s ON p.nome = s.saneamento_pais_nome
JOIN agua_potavel ag ON p.nome = ag.agua_potavel_pais_nome
JOIN higiene h ON p.nome = h.higiene_pais_nome
ORDER BY mortalidade_total DESC
LIMIT 10;
```
---

## Consulta 4: Média de Emissões de CO₂ por Faixa de IDH

**Objetivo:** Avaliar a média de emissões de dióxido de carbono por país, agrupando-os conforme o nível de desenvolvimento humano (IDH).

```sql
SELECT
  CASE
    WHEN q.idh >= 0.8 THEN 'Alto'
    WHEN q.idh >= 0.6 THEN 'Médio'
    ELSE 'Baixo'
  END AS faixa_idh,
  ROUND(AVG(e.emissao_co2_em_quilotoneladas_por_ano)::numeric,2) AS media_co2
FROM qualidade_de_vida q
JOIN emissao_gases e ON q.qualidade_de_vida_pais_nome = e.emissao_gases_pais_nome
GROUP BY faixa_idh
ORDER BY media_co2 DESC;
```
---

## Consulta 5: Países com Alta Precipitação e Baixa Infraestrutura Hospitalar

**Objetivo:** Listar países com precipitação acima da média, mas que possuem uma infraestrutura hospitalar deficiente (menor número de camas por 10 mil habitantes).

```sql
SELECT
  p.nome,
  ad.precipitacao_milhoes_de_metros_cubicos_por_ano,
  das.numero_de_camas_hospitalares_a_cada_10000_cidadaos
FROM pais p
JOIN agua_disponibilidade_e_tratamento ad
  ON p.nome = ad.agua_disponibilidade_e_tratamento_pais_nome
JOIN desenvolvimento_da_area_da_saude das
  ON p.nome = das.desenvolvimento_da_area_da_saude_pais_nome
WHERE ad.precipitacao_milhoes_de_metros_cubicos_por_ano >
  (SELECT AVG(precipitacao_milhoes_de_metros_cubicos_por_ano)
     FROM agua_disponibilidade_e_tratamento)
ORDER BY das.numero_de_camas_hospitalares_a_cada_10000_cidadaos ASC
LIMIT 10;
```
---
