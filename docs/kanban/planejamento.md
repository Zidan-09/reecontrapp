# Planejamento do Reencontrapp

## 1. Visão geral

O desenvolvimento está organizado em **7 etapas** e **39 cartões**. O prazo final é **08/11/2026, às 23h59**, e a entrega ocorre exclusivamente pelo SIGAA.

O PDF valoriza uma solução simples, funcional, organizada e tecnicamente correta. O planejamento reflete isso: não há cartões para funcionalidades extras.

## 2. Etapas de desenvolvimento

| Etapa | Nome | Cartões | Resultado esperado |
|---|---|---|---|
| 1 | Fundação | 001 a 008 | Equipe registrada, repositório e projeto criados, nuvem configurada, convenções definidas |
| 2 | Dados | 009 a 014 | Modelo definido, leitura e gravação remotas funcionando, ordenação e mensagens de erro |
| 3 | Estado | 015 a 016 | Estado da listagem e do envio do formulário gerenciados |
| 4 | Interface | 017 a 029 | Fluxo completo: listar, cadastrar e ver o registro na lista |
| 5 | Qualidade | 030 a 032 | Código revisado, `flutter analyze` limpo, `dart format .` aplicado |
| 6 | Documentação | 033 a 035 | `README.md` completo, repositório conforme, commits identificáveis |
| 7 | Validação e entrega | 036 a 039 | Validações concluídas e entrega realizada no SIGAA |

## 3. Ordem sugerida de execução (ondas)

Cartões da mesma onda podem ser executados em paralelo por integrantes diferentes, desde que as dependências estejam concluídas.

| Onda | Cartões | Dependem de |
|---|---|---|
| 0 | CARD-001, CARD-002 | Nenhuma |
| 1 | CARD-003, CARD-005, CARD-035 | 001 (003, 035); 002 (005) |
| 2 | CARD-004, CARD-006 | 003 (004); 005 (006) |
| 3 | CARD-007, CARD-008, CARD-017 | 004, 005 (007); 004 (008, 017) |
| 4 | CARD-009, CARD-018, CARD-034 | 004, 008 (009); 017 (018); 003, 007 (034) |
| 5 | CARD-010, CARD-011, CARD-024 | 006, 007, 009 (010, 011); 017, 018 (024) |
| 6 | CARD-012, CARD-014, CARD-025 | 011 (012); 010, 011 (014); 024 (025) |
| 7 | CARD-013, CARD-015 | 010, 012 (013); 010, 014 (015) |
| 8 | CARD-016, CARD-019 | 011, 014, 015 (016); 009, 015, 018 (019) |
| 9 | CARD-020, CARD-021, CARD-022, CARD-023, CARD-026, CARD-029 | 019 e demais, conforme os cartões |
| 10 | CARD-027, CARD-028 | 014, 026 (027); 019, 026 (028) |
| 11 | CARD-030, CARD-033, CARD-036, CARD-037 | 028, 029 (030); 001, 002, 007, 028 (033); 021, 022, 027, 028, 029 (036); 028 (037) |
| 12 | CARD-031 | 030 |
| 13 | CARD-032 | 031 |
| 14 | CARD-038 | 032, 033, 034 |
| 15 | CARD-039 | 031 a 038 |

O CARD-035 (commits identificáveis) depende só do CARD-001, mas é uma atividade **contínua** durante todo o projeto e só se encerra na verificação final.

## 4. Dependências críticas

Caminho crítico (a sequência mais longa; qualquer atraso aqui atrasa a entrega):

```text
001 → 003 → 004 → 008 → 009 → 010 → 014 → 015 → 016 → 026 → 028 → 030 → 031 → 032 → 038 → 039
```

Pontos de atenção:

- **CARD-002 → 005 → 006 → 007** (escolha e configuração da nuvem) bloqueiam leitura e gravação. Quem executar essa cadeia deve começar logo, pois as dependências de rede são o maior risco do projeto.
- **CARD-009** (modelo de dados) bloqueia leitura, gravação e a tela de listagem.
- **CARD-016** (estado do envio) e **CARD-025** (validação) bloqueiam o salvamento (CARD-026).
- As dependências não possuem ciclos: toda dependência aponta para um ID menor.

## 5. Marcos importantes

Datas são **sugestão de ritmo**, considerando o prazo de 08/11/2026. A equipe deve ajustá-las.

| Marco | Descrição | Cartões concluídos | Data sugerida |
|---|---|---|---|
| M1 | Fundação pronta (repositório, projeto, nuvem configurada) | 001–008 | até 03/11 |
| M2 | Leitura e gravação remotas funcionando | 009–014 | até 04/11 |
| M3 | Estado gerenciado e telas básicas | 015–019, 024 | até 05/11 |
| M4 | Fluxo completo de listagem e cadastro | 020–029 | até 06/11 |
| M5 | Qualidade e documentação | 030–035 | até 07/11 |
| M6 | Validação final e entrega no SIGAA | 036–039 | 08/11, antes das 23h59 |

Recomenda-se **não deixar a entrega para a última hora**, para absorver falhas de acesso ao SIGAA ou da nuvem.

## 6. Relação com os critérios de avaliação

| Critério | Pontos | Cartões principais | Risco se negligenciado |
|---|---|---|---|
| AV01 — Cadastro e validação do formulário | 2,0 | 012, 024, 025, 026, 027, 028 | Campos sem validação ou sem limites (60 e 200 caracteres) |
| AV02 — Listagem e apresentação dos registros | 2,0 | 013, 019, 020, 021, 022, 023 | Situação não identificada visualmente ou ordem incorreta |
| AV03 — Integração com armazenamento em nuvem | 2,0 | 002, 005, 006, 007, 010, 011, 037 | Dados não persistem ou o avaliador não consegue acessar a nuvem |
| AV04 — Assincronismo e gerenciamento de estado | 2,0 | 014, 015, 016, 021, 026, 027 | Sem indicador de carregamento, sem bloqueio de reenvio, sem nova tentativa |
| AV05 — Interface, qualidade do código e organização do repositório | 2,0 | 008, 009, 017, 018, 029, 030–035, 038 | Overflow, `analyze` com problemas, build versionado, README incompleto |

As penalidades da seção 8.4 (artefatos de build, arquivos de configuração ausentes, chaves ou instruções ausentes, impossibilidade de executar o app) são aplicadas **nos critérios correspondentes**. Elas são prevenidas principalmente pelos cartões 007, 033, 034 e 038.

## 7. Pendências e ambiguidades identificadas

Estas ambiguidades foram **apenas registradas**. Nenhuma solução foi presumida. A equipe deve decidir (e documentar a decisão) ou, preferencialmente, esclarecer com o professor.

| # | Ambiguidade | Cartões afetados |
|---|---|---|
| A1 | A seção 7 proíbe versionar "credenciais privadas", mas a seção 8.2 exige fornecer chaves, identificadores e URLs no repositório ou no README. O PDF não define o que é "credencial privada" nem o que pode ser exposto. | 006, 007, 033, 034 |
| A2 | Não é dito se data e hora do cadastro vêm do dispositivo ou do servidor. | 012 |
| A3 | O campo Local não tem limite de tamanho, e não é dito se é texto livre ou escolha entre opções. | 024, 025 |
| A4 | Nome e Descrição não têm tamanho mínimo, e não é dito como tratar espaços em branco. | 025 |
| A5 | O mecanismo de atualização da listagem (gesto, botão etc.) não é especificado. | 022 |
| A6 | O meio da identificação visual de perdido/encontrado (cor, ícone, rótulo) não é especificado. | 020 |
| A7 | Não é dito se a ordenação por mais recentes ocorre na consulta remota ou no aplicativo. | 013 |
| A8 | Não está claro se registros de demonstração podem ser inseridos no serviço remoto. O PDF só proíbe dados fixos no código em substituição ao armazenamento remoto. | 002, 005, 013, 036, 037 |
| A9 | "Arquivos gerados desnecessários" não é definido. Não está dito quais arquivos gerados, como pastas de plataforma, são aceitáveis. | 003, 004, 034, 038 |
| A10 | A plataforma-alvo (Android, iOS, Web, etc.) não é definida. | 004, 029, 033, 038 |
| A11 | Testes automatizados não são exigidos. Os cartões 036 a 038 são **verificações manuais** ligadas a requisitos explícitos. | 036, 037, 038 |
| A12 | O comportamento da listagem sem registros não é mencionado. Nenhum cartão foi criado para isso. | 010, 019, 021 |

### Observações sobre o escopo

- O PDF afirma que **não são exigidos** autenticação, recursos nativos, upload de imagens, edição, exclusão, notificações nem pesquisa avançada. Nenhum cartão trata desses itens.
- O gerenciador de estado e o serviço de nuvem são de livre escolha. Os cartões descrevem o comportamento esperado, não a ferramenta.
- Não há exigência de arquitetura específica, apenas de separação entre interface, modelos e acesso a dados (RNF02.3).

## 8. Critério de conclusão do projeto

O projeto é considerado pronto para entrega quando:

1. Todos os cartões estiverem em **Concluído**.
2. O checklist da seção 8.3 do PDF estiver integralmente marcado (CARD-039).
3. O link do repositório e os nomes completos dos integrantes forem informados no SIGAA dentro do prazo.