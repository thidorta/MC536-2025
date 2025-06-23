# Consultas Não Triviais ao Banco de Dados

Este documento apresenta cinco consultas SQL avançadas que envolvem múltiplas tabelas, agrupamentos e ordenações.

---

## 1. Acesso urbano médio por classe de renda

**Descrição:** Classifica os países em três classes de renda com base no PIB per capita e, para cada classe, calcula a média de acesso urbano considerando saneamento, higiene e água potável.

```sql
SELECT
  classe_renda,
  avg_acesso_urbano
FROM (
  SELECT
    CASE
      WHEN e.pib_per_capita > 30000 THEN 'Alta Renda'
      WHEN e.pib_per_capita > 10000 THEN 'Média Renda'
      ELSE                          'Baixa Renda'
    END AS classe_renda,
    ROUND(
      AVG(
        (s.porcentagem_urbana_com_acesso_a_instalacoes_basicas
       + h.porcentagem_urbana_com_acesso_a_instalacoes_basicas
       + a.porcentagem_urbana_com_acesso_a_instalacoes_basicas
        ) / 3.0
      )::numeric
    , 2) AS avg_acesso_urbano
  FROM economia      e
  JOIN saneamento    s ON s.saneamento_pais_nome   = e.economia_pais_nome
  JOIN higiene       h ON h.higiene_pais_nome      = e.economia_pais_nome
  JOIN agua_potavel  a ON a.agua_potavel_pais_nome = e.economia_pais_nome
  GROUP BY
    CASE
      WHEN e.pib_per_capita > 30000 THEN 'Alta Renda'
      WHEN e.pib_per_capita > 10000 THEN 'Média Renda'
      ELSE                          'Baixa Renda'
    END
) AS t
ORDER BY
  CASE
    WHEN t.classe_renda = 'Alta Renda'  THEN 1
    WHEN t.classe_renda = 'Média Renda' THEN 2
    WHEN t.classe_renda = 'Baixa Renda' THEN 3
  END;
```

---

## 2. Distribuição de países por nível de acesso

**Descrição:** Agrupa países em quatro faixas de acesso médio (Excelente, Bom, Moderado, Ruim), com base na média de cobertura urbana de saneamento, higiene e água potável, e mostra contagem e média por faixa.

```sql
WITH country_access AS (
  SELECT
    s.saneamento_pais_nome AS pais,
    (
      s.porcentagem_urbana_com_acesso_a_instalacoes_basicas
    + h.porcentagem_urbana_com_acesso_a_instalacoes_basicas
    + a.porcentagem_urbana_com_acesso_a_instalacoes_basicas
    ) / 3.0 AS acesso_medio
  FROM saneamento   s
  JOIN higiene      h ON h.higiene_pais_nome      = s.saneamento_pais_nome
  JOIN agua_potavel a ON a.agua_potavel_pais_nome = s.saneamento_pais_nome
)
SELECT
  CASE
    WHEN acesso_medio >= 90 THEN 'Excelente'
    WHEN acesso_medio >= 70 THEN 'Bom'
    WHEN acesso_medio >= 50 THEN 'Moderado'
    ELSE                      'Ruim'
  END AS nivel_acesso,
  COUNT(*)                             AS total_paises,
  ROUND(AVG(acesso_medio)::numeric, 2) AS media_acesso
FROM country_access
GROUP BY
  CASE
    WHEN acesso_medio >= 90 THEN 'Excelente'
    WHEN acesso_medio >= 70 THEN 'Bom'
    WHEN acesso_medio >= 50 THEN 'Moderado'
    ELSE                      'Ruim'
  END
ORDER BY media_acesso DESC;
```

---

## 3. Emissão média de CO₂ per capita por faixa de desemprego

**Descrição:** Calcula a emissão média de CO₂ por mil habitantes para cada faixa de taxa de desemprego (`< 5%`, `5–10%`, `> 10%`).

```sql
WITH co2pc AS (
  SELECT
    g.emissao_gases_pais_nome                                          AS pais,
    g.emissao_co2_em_quilotoneladas_por_ano
      / NULLIF(p.numero_de_habitantes_em_milhares, 0)                   AS co2_per_milhab,
    e.taxa_de_desemprego
  FROM emissao_gases g
  JOIN pais     p ON p.nome               = g.emissao_gases_pais_nome
  JOIN economia e ON e.economia_pais_nome = g.emissao_gases_pais_nome
)
SELECT
  CASE
    WHEN taxa_de_desemprego <  5 THEN 'Desemprego Baixo'
    WHEN taxa_de_desemprego < 10 THEN 'Desemprego Médio'
    ELSE                             'Desemprego Alto'
  END AS faixa_desemprego,
  COUNT(*)                                        AS total_paises,
  ROUND(AVG(co2_per_milhab)::numeric, 3)          AS avg_co2_per_milhab
FROM co2pc
GROUP BY
  CASE
    WHEN taxa_de_desemprego <  5 THEN 'Desemprego Baixo'
    WHEN taxa_de_desemprego < 10 THEN 'Desemprego Médio'
    ELSE                             'Desemprego Alto'
  END
ORDER BY avg_co2_per_milhab DESC;
```

---

## 4. Efetividade do tratamento de água por nível de IDH

**Descrição:** Para cada faixa de IDH (`< 0.60`, `0.60–0.80`, `>= 0.80`), calcula a porcentagem média de água tratada (água gerada menos não tratada) dividida pela água gerada.

```sql
SELECT
  CASE
    WHEN q.IDH >= 0.80 THEN 'IDH ≥ 0.80'
    WHEN q.IDH >= 0.60 THEN '0.60 ≤ IDH < 0.80'
    ELSE                    'IDH < 0.60'
  END AS faixa_IDH,
  COUNT(*)                                                                 AS total_paises,
  ROUND(
    AVG(
      (
        adt.agua_suja_gerada_em_1000_metros_cubicos_por_dia
      - adt.agua_suja_nao_tratada_em_1000_metros_cubicos_por_dia
      )
      / NULLIF(adt.agua_suja_gerada_em_1000_metros_cubicos_por_dia, 0)
    )::numeric * 100
  , 2)                                                                     AS pct_media_tratamento
FROM agua_disponibilidade_e_tratamento adt
JOIN qualidade_de_vida q
  ON q.qualidade_de_vida_pais_nome = adt.agua_disponibilidade_e_tratamento_pais_nome
GROUP BY
  CASE
    WHEN q.IDH >= 0.80 THEN 'IDH ≥ 0.80'
    WHEN q.IDH >= 0.60 THEN '0.60 ≤ IDH < 0.80'
    ELSE                    'IDH < 0.60'
  END
ORDER BY pct_media_tratamento DESC;
```

---

## 5. Médicos por classe de mortalidade sanitária

**Descrição:** Agrupa países em três classes de mortalidade por falta de saneamento (`< 10`, `10–30`, `>= 30` mortes por 100k) e calcula a média de médicos por 1 000 habitantes em cada classe.

```sql
SELECT
  classe_mortalidade,
  total_paises,
  avg_medicos_por_1000
FROM (
  SELECT
    CASE
      WHEN mort_rate < 10 THEN 'Baixa mortalidade (<10/100k)'
      WHEN mort_rate < 30 THEN 'Mortalidade média (10–30/100k)'
      ELSE                            'Alta mortalidade (≥30/100k)'
    END AS classe_mortalidade,
    COUNT(*)                                       AS total_paises,
    ROUND(AVG(medicos_1000)::numeric, 2)           AS avg_medicos_por_1000
  FROM (
    SELECT
      s.saneamento_pais_nome                                          AS pais,
      s.taxa_de_morte_a_cada_100000_mortes_devido_a_sanitacao_nao_segura AS mort_rate,
      d.taxa_de_medicos_a_cada_1000_cidadaos                          AS medicos_1000
    FROM saneamento s
    JOIN desenvolvimento_da_area_da_saude d
      ON d.desenvolvimento_da_area_da_saude_pais_nome = s.saneamento_pais_nome
  ) AS mort
  GROUP BY
    CASE
      WHEN mort_rate < 10 THEN 'Baixa mortalidade (<10/100k)'
      WHEN mort_rate < 30 THEN 'Mortalidade média (10–30/100k)'
      ELSE                            'Alta mortalidade (≥30/100k)'
    END
) AS t
ORDER BY avg_medicos_por_1000 DESC;
```

