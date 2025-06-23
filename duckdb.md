# Justificativa Técnica: Escolha do DuckDB para o Cenário A

## Cenário A: Análise Estatística sobre Dados Estruturados e Imutáveis

Neste projeto, optamos pela utilização do banco de dados DuckDB para atender às exigências do Cenário A, que envolve consultas frequentes sobre grandes volumes de dados estruturados e históricos. As operações predominantes são de leitura e agregação, realizadas por analistas de dados que utilizam ferramentas como Python e R. O DuckDB foi escolhido por apresentar uma arquitetura colunar altamente otimizada para esse tipo de carga de trabalho, além de uma integração simples com ambientes analíticos.

## 1. Forma de Armazenamento de Arquivos

O DuckDB adota um modelo de armazenamento colunar, em que os dados são armazenados por coluna em vez de por linha. Essa estrutura favorece diretamente operações analíticas, permitindo a leitura eficiente de apenas um subconjunto de colunas, o que é ideal quando o objetivo é processar grandes volumes de registros acessando poucos atributos.

Além disso, o formato colunar proporciona alta compressão de dados, otimizando o uso de memória e armazenamento em disco. Essa abordagem é extremamente vantajosa para conjuntos de dados com muitos valores repetidos ou similares em uma mesma coluna, como indicadores estatísticos por país, presentes neste projeto.

O fato de ser um banco embutido permite o armazenamento local dos dados, em arquivos binários portáteis, eliminando a necessidade de servidores dedicados ou infraestrutura adicional.

## 2. Linguagem e Processamento de Consultas

O DuckDB é compatível com SQL padrão, oferecendo suporte a consultas relacionais completas com uso de cláusulas como `JOIN`, `GROUP BY`, `ORDER BY`, `WHERE`, `WINDOW FUNCTIONS` e agregações. Isso facilita a transição de sistemas relacionais como PostgreSQL para análises colunadas, sem a necessidade de reescrita significativa das consultas.

Além disso, o DuckDB possui integração nativa com linguagens como Python e R, permitindo que analistas consultem e manipulem dados diretamente a partir de notebooks Jupyter, scripts estatísticos ou ambientes como VSCode, PyCharm e RStudio. Isso promove uma experiência fluida para exploração e visualização de dados, ideal para times que trabalham com análise exploratória e geração de relatórios.

Essa integração direta permite que os dados sejam carregados de arquivos CSV, Parquet ou até mesmo DataFrames do Pandas, mantendo um fluxo de trabalho produtivo para análises estatísticas e científicas.

## 3. Processamento e Controle de Transações

Apesar de ser voltado principalmente para leitura analítica, o DuckDB implementa suporte a transações com propriedades ACID (Atomicidade, Consistência, Isolamento e Durabilidade). Isso garante que as operações de leitura e escrita ocorram com integridade, mesmo em cenários que envolvem múltiplas etapas de processamento.

O controle transacional do DuckDB é adequado para o tipo de operação envolvida neste projeto, em que a maioria dos dados é histórica e imutável. Ainda assim, é possível realizar inserções ou atualizações controladas de forma segura, mantendo a consistência dos dados sem a necessidade de mecanismos complexos de bloqueio ou concorrência.

Esse suporte transacional permite que as análises sejam realizadas com confiança, mesmo em ambientes locais ou embarcados, garantindo que os dados refletidos nas consultas estejam sempre em estado válido.

## 4. Mecanismos de Recuperação e Segurança

O DuckDB armazena os dados em arquivos locais binários, que podem ser versionados, copiados e transportados facilmente, o que facilita estratégias de backup e restauração. A simplicidade do modelo de armazenamento permite que cópias dos bancos sejam mantidas em sistemas de controle de versão como Git ou em serviços de armazenamento em nuvem, como Google Drive ou Dropbox.

Embora o DuckDB não seja um sistema gerenciador de banco de dados com múltiplos usuários simultâneos, sua arquitetura embarcada proporciona um ambiente seguro e isolado, onde apenas o usuário com acesso ao ambiente de execução pode consultar ou alterar os dados. Em contextos acadêmicos, analíticos e de desenvolvimento, isso representa uma abordagem segura e eficaz.

Além disso, o formato utilizado é robusto e tolerante a falhas de leitura, permitindo a recuperação dos dados mesmo em casos de encerramento inesperado da aplicação, sem necessidade de procedimentos manuais de restauração.

## Conclusão

Diante das necessidades específicas do cenário A, o DuckDB se destaca como a tecnologia ideal para o projeto. Sua arquitetura colunar embutida, aliada à compatibilidade com SQL, integração com Python e R, suporte a transações e armazenamento leve e confiável, o tornam a escolha mais adequada para o processamento analítico de dados estruturados e imutáveis em larga escala.

