# CARD-033 Redigir o `README.md` do repositório

**Tipo:** Documentation  
**Prioridade:** Alta  
**Complexidade:** Média  
**Status inicial:** Backlog

## Descrição

Redigir o `README.md` do repositório com todas as informações exigidas pelo documento do professor: nomes completos dos integrantes, descrição das funcionalidades, serviço de armazenamento utilizado e instruções claras de configuração e execução, incluindo os parâmetros de acesso à nuvem.

O README é a principal fonte de informação do avaliador. Instruções incompletas podem impedir a execução do aplicativo e gerar penalidade.

## Requisitos relacionados

- DOC02: `README.md` com os nomes completos de todos os integrantes.
- DOC03: `README.md` com a descrição das funcionalidades.
- DOC04: `README.md` com o serviço de armazenamento utilizado.
- DOC05: `README.md` com instruções para configuração e execução.
- ENT05: fornecer as informações de configuração da nuvem no repositório ou em instruções claras no `README.md`.

## Critérios de aceitação

- [x] O README contém os nomes completos de todos os integrantes: Gabriel Lima Silva Oliveira, Paulo Henrique Alves Vieira, Erick Vieira da Silva Costa, Samuel da Penha Nascimento.
- [x] O README descreve as funcionalidades efetivamente implementadas (listagem, cadastro, validação, atualização e tratamento de falhas), sem mencionar recursos que não existem.
- [x] O README informa o serviço de armazenamento em nuvem utilizado (Firebase Firestore, plano Spark).
- [x] O README informa os pré-requisitos para executar (Flutter 3.47.7, Dart 3.13.5, Google Chrome).
- [x] O README descreve, passo a passo, como clonar, instalar as dependências, configurar a nuvem e executar o aplicativo.
- [x] Todos os parâmetros de configuração da nuvem (chaves, identificadores, URLs e demais) estão no repositório ou descritos no README (`.env.example` versionado, `google-services.json`, tabela na seção Configuração do Firebase).
- [x] O README informa a plataforma usada para a avaliação: **Web (Chrome)**.
- [ ] Alguém que não participou da escrita seguiu as instruções, sem ajuda externa, até executar o aplicativo. *(pendente — validação do CARD-038)*
- [x] O texto está em português.

## Dependências

- [CARD-001] Registrar integrantes e responsabilidades da equipe.
- [CARD-002] Escolher serviço de armazenamento em nuvem gratuito.
- [CARD-007] Definir e disponibilizar parâmetros de configuração da nuvem.
- [CARD-028] Exibir o novo registro na listagem após o cadastro.

## Observações técnicas

Não incluir no README credenciais que a equipe tenha classificado como privadas (ambiguidade A1). Os comandos de compilação e execução devem ser exatamente os necessários, evitando passos que dependam de configurações locais não documentadas. O README deve ser revisado de novo após o CARD-038, pois a execução em um clone limpo pode revelar passos omitidos.

## Definition of Done

- [x] Documento redigido e integrado ao repositório.
- [x] Critérios de aceitação atendidos.
- [ ] Revisado por pelo menos um integrante que não o escreveu. *(pendente)*
- [x] Conteúdo conferido com os nomes e dados do CARD-001.