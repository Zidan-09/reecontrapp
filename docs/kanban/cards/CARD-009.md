# CARD-009 Definir o modelo de dados do objeto

**Tipo:** Task  
**Prioridade:** Alta  
**Complexidade:** Pequena  
**Status inicial:** Backlog

## Descrição

Definir o modelo de dados que representa um objeto perdido ou encontrado dentro do aplicativo, com os campos exigidos pelo documento: nome, descrição, local, situação (perdido ou encontrado) e data/hora do cadastro.

Esse modelo é a base compartilhada pela leitura (CARD-010), pela gravação (CARD-011) e pelas telas de listagem e cadastro, por isso deve ser definido antes delas e ser independente da interface.

## Requisitos relacionados

- RF01.2: exibir nome, local, situação e descrição de cada objeto.
- RF02.1: formulário com os campos Nome do objeto, Descrição, Local e Situação.
- RB01: a situação do objeto assume apenas os valores "perdido" ou "encontrado".
- RB02: data e hora do cadastro são registradas automaticamente.
- RNF02.3: separação adequada entre interface, modelos e acesso aos dados.
- RNF02.4: organização proporcional à complexidade da aplicação.

## Critérios de aceitação

- [ ] O modelo contém nome, descrição, local, situação e data/hora do cadastro.
- [ ] A situação só admite os dois valores previstos: perdido e encontrado.
- [ ] O modelo não depende de componentes de interface nem do serviço de nuvem.
- [ ] Os identificadores do modelo seguem as convenções do CARD-008 (inglês).
- [ ] O modelo ficou na pasta de modelos definida no CARD-008.
- [ ] O modelo não contém campos que o documento não exige (por exemplo, imagem ou contato).

## Dependências

- [CARD-004] Criar projeto Flutter base.
- [CARD-008] Estabelecer convenções de código e organização do projeto.

## Observações técnicas

A conversão entre o modelo e o formato de armazenamento do serviço escolhido será resolvida na leitura (CARD-010) e na gravação (CARD-011), pois depende do serviço. O PDF não pede um identificador único por registro. A necessidade de um identificador deve ser avaliada conforme o serviço escolhido e registrada, sem tratá-la como requisito do professor. Pensar em tipos que representem a situação de forma segura e a data/hora de forma adequada ao Dart.

## Definition of Done

- [ ] Implementação concluída.
- [ ] Critérios de aceitação atendidos.
- [ ] Código revisado por outro integrante e integrado ao ramo principal.