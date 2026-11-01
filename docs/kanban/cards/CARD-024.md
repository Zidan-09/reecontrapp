# CARD-024 Construir o formulário de cadastro com os campos definidos

**Tipo:** Feature  
**Prioridade:** Alta  
**Complexidade:** Média  
**Status inicial:** Backlog

## Descrição

Construir a tela de cadastro com o formulário contendo os quatro campos exigidos: nome do objeto, descrição, local e situação (perdido ou encontrado). Este cartão entrega a estrutura e a entrada de dados. A validação (CARD-025) e o salvamento (CARD-026) são tratados em cartões próprios.

## Requisitos relacionados

- RF02.1: disponibilizar formulário com os campos Nome do objeto, Descrição, Local e Situação.
- RF02.2: nome do objeto obrigatório, até 60 caracteres.
- RF02.3: descrição obrigatória, até 200 caracteres.
- RF02.4: local obrigatório.
- RF02.5: situação perdido ou encontrado.
- RB01: a situação do objeto assume apenas os valores "perdido" ou "encontrado".
- TL02: tela de cadastro com o formulário com os campos definidos.
- RNF01.1: utilizar componentes do Material 3.
- RNF01.2: apresentar interface em português.

## Critérios de aceitação

- [ ] A tela contém os campos Nome do objeto, Descrição, Local e Situação, com rótulos em português.
- [ ] A situação só pode assumir os valores perdido ou encontrado, e não aceita texto livre.
- [ ] Não existe campo de data nem de hora (ver CARD-012).
- [ ] Não existem campos além dos exigidos (por exemplo, imagem ou contato).
- [ ] Os campos usam componentes do Material 3.
- [ ] A tela é acessível pela navegação do CARD-018.
- [ ] Os textos digitados permanecem no formulário se o teclado for aberto ou fechado.
- [ ] Os campos de nome e descrição comportam a quantidade máxima de caracteres sem quebrar o layout.

## Dependências

- [CARD-017] Configurar tema Material 3 e idioma português.
- [CARD-018] Estruturar a navegação entre listagem e cadastro.

## Observações técnicas

O recurso de formulário do Flutter oferece mecanismos de validação por campo, que serão aproveitados no CARD-025. O campo Local não tem limite de tamanho no documento, e não é dito se é texto livre ou escolha entre opções (ambiguidade A3). A equipe deve decidir e registrar. O estado inicial da situação (nenhuma opção selecionada ou uma opção preselecionada) também não é definido, e a decisão afeta a validação do CARD-025. Atenção ao teclado, que pode cobrir campos e botões, o que se relaciona com o CARD-029.

## Definition of Done

- [ ] Implementação concluída.
- [ ] Critérios de aceitação atendidos.
- [ ] Tela executada e conferida visualmente.
- [ ] Código revisado por outro integrante e integrado ao ramo principal.