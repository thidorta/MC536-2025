# Sistema de Análise de Indicadores Sanitários - MC536

## Descrição

Este projeto foi desenvolvido para fins educacionais na disciplina de Banco de Dados (MC536) na UNICAMP. Ele consiste na modelagem de um sistema de banco de dados relacional (PostgreSQL) voltado à análise integrada de informações sobre saneamento, saúde, economia, qualidade de vida e emissões por país.

## Corpo do Projeto

### 1. Modelos Conceitual e Relacional

Os modelos abaixo ilustram a estrutura lógica do banco de dados relacional, incluindo entidades como `saneamento`, `economia`, `qualidade_de_vida`, `higiene`, `água potável`, `emissão de gases`, entre outras, todas ligadas à entidade `país`.

<div align="center">
  <img src="Modelos/modelo_conceitual.png" alt="Modelo Conceitual" width="600px">
  <p><em>Figura 1: Modelo conceitual do banco de dados</em></p>
</div>

<br>

<div align="center">
  <img src="Modelos/modelo_relacional.png" alt="Modelo Relacional" width="600px">
  <p><em>Figura 2: Modelo relacional do banco de dados</em></p>
</div>

### 2. Implementação: Criação, População e Consultas SQL

O banco de dados foi criado no PostgreSQL, utilizando scripts para:
- Criação do modelo físico (DDL)
- População da base com dados reais
- Execução de consultas SQL não triviais (com agregações, junções e ordenações)

Acesse os scripts e códigos utilizados aqui:  
📄 [Criação e População do Banco + Consultas SQL](criacao_e_populacao_bd.md)

---

### 3. Estrutura do Repositório
```pgsql
MC536/
│
├── Consultas/
│   └── consultas.md
│
├── Datasets/
│   ├── DataUN/
│   │   ├── Desenvolvimento_da_Área_da_Saúde/
│   │   │   └── Fontes.txt
│   │   ├── Emissao_Gases/
│   │   │   └── Fontes.txt
│   │   ├── País/
│   │   │   └── Fontes.txt
│   │   ├── Água_Disponibilidade_e_Tratamento/
│   │   │   └── Fontes.txt
│   ├── OurWorldInData/
│   │   ├── Economia/
│   │   │   └── Fontes.txt
│   │   ├── Higiene/
│   │   │   └── Fontes.txt
│   │   ├── Qualidade_de_Vida/
│   │   │   └── Fontes.txt
│   │   ├── Sanitação/
│   │   │   └── Fontes.txt
│   │   ├── Água_potável/
│   │       └── Fontes.txt
├── Modelos/
│   ├── modelo_conceitual.png
│   ├── modelo_relacional.png
│   ├── modelo_relacional.pgerd
│   ├── modelo_fisico.sql
│   └── modelo_fisico_EDR_tool.sql
│
├── Resultados/
│   ├── consulta1.csv
│   ├── consulta2.csv
│   ├── consulta3.csv
│   ├── consulta4.csv
│   ├── consulta5.csv
│
└── criacao_e_populacao_bd.md
└── README.md
```
