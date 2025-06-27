# Cenário A: Análise Estatística sobre Dados Estruturados e Imutáveis
No projeto, optou-se pelo uso do DuckDB, considerando as características do cenário A:
-Predominância de operações de leitura e agregação sobre grandes datasets.              (1)
-Alta compressão e performance em operações de leitura.                                 (2)
-Baixa frequência de escrita ou atualização.                                            (3)
-Integração com notebooks ou scripts de análise.                                        (4)
-Confiabilidade em leituras, mas sem exigência de controle transacional complexo.       (5)

Além de que o cenário envolve a reformulação de um sistema voltado para consultas a dados altamente estruturados, os quais são dados históricos e imutáveis. Ademais, as consultas acessam, normalmente, poucos atributos, os quais envolvem um grande número de dados. Por fim, o sistema é utilizado por indivíduos que optam por integração direta com linguagems como Python ou R.

A partir destas, informações, pode-se analisar separadamente cada aspecto do DuckDB.

# 1. Forma de Armazenamento de Arquivos
No DuckDB, os dados são armazenados em formato colunar, significando que são formados diversas colunas, as quais são utilizadas em consultas para se obter os dados de atributos desejados. No caso em que um BD seja normalizado ao extremo (apenas 1 tabela) para a conversão ao DuckDB, as 'foreign keys' (além de outros atributos constantemente repetidos em várias tabelas) formam, cada uma, 1 coluna, enquanto os atributos restantes, são divididos como componentes de uma colunas.

No caso do nosso BD, o seu modelo colunar seria uma coluna com o nome do país e outra coluna com os demais dos atributos. Para melhor entendimento, abaixo há uma pequena representação:

numero_de_habitantes_em_milhares                    |  41454.761719 |  2811.655029  |  46164.218750 |  ...  |  16340.822266 |
precipitacao_milhoes_de_metros_cubicos_por_ano      |      NULL     |  32224.000000 | 330957.406250 |  ...  | 372899.406250 |
agua_suja_gerada_em_1000_metros_cubicos_por_dia     |      NULL     |  1188.000000  |  7730.000000  |  ...  |  48978.601562 |
...                                                 |      ...      |      ...      |      ...      |  ...  |      ...      |
numero_de_camas_hospitalares_a_cada_10000_cidadaos  |    4.000000   |      NULL     |      NULL     |  ...  |   17.000000   |
                                                    |  Afeganistão  |    Albania    |    Algeria    |  ...  |    Zimbabwe   |

Os arquivos podem ser armazenados de 2 maneiras:
-Banco de Dados em Memória: Os arquivos são salvos na memória RAM e pode ser útil para tratar tarefas não recorrentes. Contém alto desempenho em troca de uma quantidade de dados limitada pelo tamanho da memória RAM.
-Banco de Dados Persistente: Os arquivos são salvos na memória do disco e é útil para tratar tarefas recorrentes. Em troca de um pior desempenho, permite tratar uma maior quantidade de dados.

Por fim, nota-se que por haver baixa frequência de escrita e atualização de dados, além dos dados serem históricos e imutáveis, faz com que o DuckDB seja mais vantajoso. O que é explicado pelos dados no formato colunar serem extremamente organizados e estruturados, assim sendo difícil alterar dados, visto que seria necessário alterar a coluna, pois todos os dados da coluna ficam juntos. Porém, graças ao quesito (3), não há problema com isso.

# 2. Linguagem e Processamento de Consultas
O DuckDB pode ser utilizado através da linguagem Python, a qual é optada pelos analistas de dados no cenário, também atendendo o quesito (4). Além disso, a sua lógica é extremamente similar ao SQL, o que permite criá-lo facilmente a partir do BD do projeto 1.

Considerando que, no cenário, são realizadas operações de leitura e agregação de datasets com poucos atributos, porém com um grande número de dados, o DuckDB prova-se ideal ao permitir uma consulta extremamente direcionada devido ao formato colunar formatar os dados com extrema organização, atendendo o quesito (1). Por este motivo, pode-se realizar consultas com maior eficiência, o que também satisfaz o quesito (2).

# 3. Processamento e Controle de Transações
O DuckDB contém suporte para transações ACID, a qual significa:
A -> Atomicidade -> Transações são, como átomos no modelo de Dalton, operações indivisíveis, significando que as operações dentro da transação são todas realizadas com sucesso ou nenhuma é realizada. Em outras palavras, é impossível apenas algumas operações sucederem enquanto outras falham.
C -> Consistência -> Garante que nenhuma transação deixará o BD com dados inválidos ou corrompidos.
I -> Isolamento -> Transações não podem interferir umas com as outras.
D -> Durabilidade -> Uma vez que a transação é realizada, as suas alterações devem permanecer, mesmo se a transação for removida do código.

Graças a estes aspectos o quesito (5) é atendido, visto que a Consistência garante confiabilidade da leitura ao não permitir que dados inválidos nem corrompidos sejam existentes no BD.

# 4. Mecanismos de Recuperação e Segurança
No projeto, foi utilizado um Banco de Dados Persistente, o qual permite salvar os dados obtidos pelas consultas no disco do computador. Também, no caso do projeto, o uso do github torna possível salvar diferentes versões do BD, permitindo fácil recuperação. Tais ações auxilia na recuperação de arquivos antigos, além da possibilidade de criar várias versões das consultas para o caso de corrupção ou alguma perda de dados do BD.

Para finalizar, devido a suportar transações ACID, o DuckDB também é capaz de evitar a corrupção de dados, adicionando um maior nível de detalhe a sua segurança.
