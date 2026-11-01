# Requisitos do Reencontrapp

Requisitos extraídos do documento do professor (2ª Avaliação: Achados e Perdidos). Os identificadores `RF`, `RNF` e `TL` seguem o PDF. Os sufixos numéricos (ex.: RF01.2) e as demais famílias (RB, RT, EQ, DOC, ENT, AV) são **identificadores internos** deste projeto.

Legenda de origem: seção do PDF entre parênteses.

---

## 1. Requisitos funcionais

### RF01 — Listagem de objetos (seção 2)

| ID | Requisito |
|---|---|
| RF01.1 | Carregar os registros armazenados na nuvem |
| RF01.2 | Exibir nome, local, situação e descrição de cada objeto |
| RF01.3 | Identificar visualmente objetos perdidos e encontrados |
| RF01.4 | Apresentar os registros mais recentes primeiro |
| RF01.5 | Permitir atualizar a listagem |

### RF02 — Cadastro de objetos (seção 2)

| ID | Requisito |
|---|---|
| RF02.1 | Disponibilizar formulário com os campos Nome do objeto, Descrição, Local e Situação |
| RF02.2 | Nome do objeto: obrigatório, até 60 caracteres |
| RF02.3 | Descrição: obrigatória, até 200 caracteres |
| RF02.4 | Local: obrigatório |
| RF02.5 | Situação: perdido ou encontrado |
| RF02.6 | Validar todos os campos antes do envio |
| RF02.7 | Registrar data e hora do cadastro automaticamente |
| RF02.8 | Exibir o novo registro na listagem após o cadastro |

### RF03 — Assincronismo (seção 2)

| ID | Requisito |
|---|---|
| RF03.1 | Executar de forma assíncrona as operações de leitura e gravação |
| RF03.2 | Exibir indicador de carregamento durante as operações |
| RF03.3 | Impedir envios repetidos durante a gravação |
| RF03.4 | Tratar falhas de comunicação com mensagens compreensíveis |
| RF03.5 | Permitir tentar novamente uma operação que tenha falhado |

### RF04 — Gerenciamento de estado (seção 2)

| ID | Requisito |
|---|---|
| RF04.1 | Gerenciar a lista de objetos cadastrados |
| RF04.2 | Gerenciar os estados de carregamento, sucesso e erro |
| RF04.3 | Gerenciar o estado de envio do formulário |
| RF04.4 | Atualizar a interface após um cadastro |

*Observação:* o PDF cita `ChangeNotifier`, Riverpod "ou outra abordagem apropriada". Trata-se de **sugestão técnica**, não de exigência de ferramenta.

### RF05 — Armazenamento em nuvem (seção 2)

| ID | Requisito |
|---|---|
| RF05.1 | Utilizar exclusivamente serviços com plano gratuito |
| RF05.2 | Persistir os dados após o encerramento da aplicação |
| RF05.3 | Compartilhar os registros entre diferentes instalações do aplicativo |
| RF05.4 | Recuperar os dados por meio de operações assíncronas |

---

## 2. Funcionalidades mínimas da interface (seção 3)

| ID | Requisito |
|---|---|
| TL01 | **Tela de listagem:** exibir objetos perdidos e encontrados; identificar a situação de cada objeto; permitir atualizar os registros; dar acesso ao cadastro |
| TL02 | **Tela de cadastro:** formulário com os campos definidos; validação dos dados; ação para salvar; indicador de processamento durante o envio |
| TL03 | A organização da navegação e a utilização de telas adicionais ficam a critério da equipe |

---

## 3. Requisitos não funcionais

### RNF01 — Interface e usabilidade (seção 4)

| ID | Requisito |
|---|---|
| RNF01.1 | Utilizar componentes do Material 3 |
| RNF01.2 | Apresentar interface em português |
| RNF01.3 | Adaptar-se a diferentes tamanhos de tela |
| RNF01.4 | Evitar overflow e controles inacessíveis |
| RNF01.5 | Informar adequadamente operações em andamento e falhas |

### RNF02 — Qualidade do código (seção 4)

| ID | Requisito |
|---|---|
| RNF02.1 | Identificadores técnicos em inglês |
| RNF02.2 | Nomes expressivos e baixa duplicação |
| RNF02.3 | Separação adequada entre interface, modelos e acesso aos dados |
| RNF02.4 | Organização proporcional à complexidade da aplicação |
| RNF02.5 | O projeto deve executar `flutter analyze` sem problemas provenientes do código da equipe |
| RNF02.6 | O código deve estar formatado com `dart format .` |

*Observação:* "não será exigida uma arquitetura específica" (sugestão de liberdade, não exigência de padrão).

---

## 4. Regras de negócio

O PDF não numera regras de negócio. Os IDs abaixo são internos e derivados de trechos explícitos.

| ID | Regra | Origem |
|---|---|---|
| RB01 | A situação do objeto assume apenas os valores "perdido" ou "encontrado" | Seção 2 (RF02) |
| RB02 | Data e hora do cadastro são registradas automaticamente, sem informação do usuário | Seção 2 (RF02) |
| RB03 | A listagem apresenta os registros em ordem decrescente de cadastro | Seção 2 (RF01) |
| RB04 | Não há autenticação, edição nem exclusão de registros | Seções 2 (RF05) e 5 |
| RB05 | Somente dados demonstrativos, sem informações pessoais ou sensíveis | Seção 5 |
| RB06 | O serviço de nuvem deve ter regras de acesso compatíveis com um aplicativo sem autenticação | Seção 5 |

---

## 5. Restrições técnicas (seção 5)

| ID | Restrição |
|---|---|
| RT01 | Utilização obrigatória de Flutter e Dart |
| RT02 | Armazenamento em nuvem exclusivamente com serviços gratuitos |
| RT03 | Não é necessário implementar autenticação |
| RT04 | Não é necessário utilizar recursos nativos do dispositivo |
| RT05 | Não são exigidos upload de imagens, edição, exclusão, notificações ou pesquisa avançada |
| RT06 | Não utilizar dados fictícios definidos no código em substituição ao armazenamento remoto |
| RT07 | A equipe escolhe livremente o serviço, desde que seja possível executar e avaliar a aplicação sem custos |

---

## 6. Equipe (seção 6)

| ID | Requisito |
|---|---|
| EQ01 | Equipes de até 4 estudantes |
| EQ02 | Todos os integrantes participam efetivamente do desenvolvimento e conhecem o funcionamento da solução |
| EQ03 | Todos os integrantes possuem commits identificáveis no repositório |

---

## 7. Documentação e repositório (seções 7 e 8.1)

| ID | Requisito |
|---|---|
| DOC01 | Repositório público no GitHub com o código-fonte completo |
| DOC02 | `README.md` com os nomes completos de todos os integrantes |
| DOC03 | `README.md` com a descrição das funcionalidades |
| DOC04 | `README.md` com o serviço de armazenamento utilizado |
| DOC05 | `README.md` com instruções para configuração e execução |
| DOC06 | Histórico de commits dos integrantes preservado no repositório |
| DOC07 | Não versionar arquivos de build, binários ou credenciais privadas |

---

## 8. Entrega (seção 8)

| ID | Requisito |
|---|---|
| ENT01 | Prazo: 08/11/2026, até 23h59 |
| ENT02 | Entrega exclusivamente pelo SIGAA, com o link do repositório e os nomes completos dos integrantes |
| ENT03 | O projeto deve estar funcional e disponível para avaliação |
| ENT04 | Proibido incluir no repositório artefatos de compilação (`.apk`, `.aab`, `.ipa`, executáveis, diretórios `build/` e demais arquivos gerados), em qualquer plataforma |
| ENT05 | Fornecer as informações de configuração da nuvem (chaves de API, identificadores, URLs e demais parâmetros) no repositório ou em instruções claras no `README.md` |
| ENT06 | Cumprir o checklist de entrega da seção 8.3 |
| ENT07 | Ciência das penalidades da seção 8.4 (artefatos de build ou arquivos gerados desnecessários; ausência de arquivos, configurações, chaves ou instruções indispensáveis; impossibilidade de executar ou avaliar o app) |

---

## 9. Critérios de avaliação (seção 9)

Total de 10,0 pontos. A nota é comum a todos os integrantes da equipe.

| ID | Critério | Pontos |
|---|---|---|
| AV01 | Cadastro e validação do formulário | 2,0 |
| AV02 | Listagem e apresentação dos registros | 2,0 |
| AV03 | Integração com armazenamento em nuvem | 2,0 |
| AV04 | Assincronismo e gerenciamento de estado | 2,0 |
| AV05 | Interface, qualidade do código e organização do repositório | 2,0 |

Diretriz da seção 10: serão valorizadas soluções simples, funcionais, organizadas e tecnicamente corretas. Funcionalidades adicionais não são necessárias para a pontuação máxima.

---

## 10. Rastreabilidade: requisito → cartões

| Requisito | Cartões |
|---|---|
| RF01.1 | CARD-010, CARD-019, CARD-036 |
| RF01.2 | CARD-009, CARD-019, CARD-036 |
| RF01.3 | CARD-020, CARD-036 |
| RF01.4 | CARD-013, CARD-028, CARD-036 |
| RF01.5 | CARD-022, CARD-036 |
| RF02.1 | CARD-009, CARD-024 |
| RF02.2 | CARD-024, CARD-025, CARD-036 |
| RF02.3 | CARD-024, CARD-025, CARD-036 |
| RF02.4 | CARD-024, CARD-025, CARD-036 |
| RF02.5 | CARD-024, CARD-025 |
| RF02.6 | CARD-025, CARD-026, CARD-036 |
| RF02.7 | CARD-012 |
| RF02.8 | CARD-028, CARD-036 |
| RF03.1 | CARD-010, CARD-011 |
| RF03.2 | CARD-015, CARD-021, CARD-022, CARD-026, CARD-036 |
| RF03.3 | CARD-016, CARD-026, CARD-036 |
| RF03.4 | CARD-014, CARD-016, CARD-021, CARD-027, CARD-036 |
| RF03.5 | CARD-016, CARD-021, CARD-027, CARD-036 |
| RF04.1 | CARD-015 |
| RF04.2 | CARD-015, CARD-021 |
| RF04.3 | CARD-016, CARD-026 |
| RF04.4 | CARD-016, CARD-028 |
| RF05.1 | CARD-002, CARD-005 |
| RF05.2 | CARD-002, CARD-011, CARD-037 |
| RF05.3 | CARD-002, CARD-011, CARD-037 |
| RF05.4 | CARD-002, CARD-010, CARD-037 |
| TL01 | CARD-018, CARD-019, CARD-020, CARD-022, CARD-023 |
| TL02 | CARD-018, CARD-024, CARD-026 |
| TL03 | CARD-018 |
| RNF01.1 | CARD-017, CARD-019, CARD-020, CARD-023, CARD-024 |
| RNF01.2 | CARD-014, CARD-017, CARD-021, CARD-024, CARD-025, CARD-027 |
| RNF01.3 | CARD-029 |
| RNF01.4 | CARD-023, CARD-029 |
| RNF01.5 | CARD-014, CARD-021, CARD-022, CARD-026, CARD-027, CARD-036 |
| RNF02.1 | CARD-008, CARD-030 |
| RNF02.2 | CARD-008, CARD-030 |
| RNF02.3 | CARD-008, CARD-009, CARD-015, CARD-019, CARD-030 |
| RNF02.4 | CARD-008, CARD-009, CARD-030 |
| RNF02.5 | CARD-031 |
| RNF02.6 | CARD-032 |
| RB01 | CARD-009, CARD-020, CARD-024, CARD-025 |
| RB02 | CARD-009, CARD-012 |
| RB03 | CARD-013, CARD-028 |
| RB04 | CARD-004, CARD-011 |
| RB05 | CARD-006, CARD-036 |
| RB06 | CARD-002, CARD-006 |
| RT01 | CARD-004 |
| RT02 | CARD-002, CARD-005 |
| RT03 | CARD-004 |
| RT04 | CARD-004 |
| RT05 | CARD-004 |
| RT06 | CARD-010, CARD-011, CARD-019, CARD-037, CARD-038 |
| RT07 | CARD-002 |
| EQ01 | CARD-001, CARD-039 |
| EQ02 | CARD-001, CARD-035 |
| EQ03 | CARD-035 |
| DOC01 | CARD-003, CARD-038 |
| DOC02 | CARD-033 |
| DOC03 | CARD-033 |
| DOC04 | CARD-033 |
| DOC05 | CARD-033 |
| DOC06 | CARD-035 |
| DOC07 | CARD-003, CARD-034 |
| ENT01 | CARD-039 |
| ENT02 | CARD-039 |
| ENT03 | CARD-036, CARD-038, CARD-039 |
| ENT04 | CARD-003, CARD-034, CARD-038 |
| ENT05 | CARD-007, CARD-033, CARD-038 |
| ENT06 | CARD-031, CARD-032, CARD-039 |
| ENT07 | CARD-034, CARD-038, CARD-039 |

### Rastreabilidade por critério de avaliação

| Critério | Cartões principais |
|---|---|
| AV01 — Cadastro e validação | CARD-012, CARD-024, CARD-025, CARD-026, CARD-027, CARD-028 |
| AV02 — Listagem e apresentação | CARD-013, CARD-019, CARD-020, CARD-021, CARD-022, CARD-023 |
| AV03 — Integração com nuvem | CARD-002, CARD-005, CARD-006, CARD-007, CARD-010, CARD-011, CARD-037 |
| AV04 — Assincronismo e estado | CARD-014, CARD-015, CARD-016, CARD-021, CARD-026, CARD-027 |
| AV05 — Interface, código e repositório | CARD-008, CARD-009, CARD-017, CARD-018, CARD-029, CARD-030, CARD-031, CARD-032, CARD-033, CARD-034, CARD-035, CARD-038 |

Os cartões de apoio (CARD-001, 003, 004, 036 e 039) sustentam todos os critérios.