# CARD-030 Revisar nomenclatura, duplicação e separação de camadas

**Tipo:** Task  
**Prioridade:** Média  
**Complexidade:** Média  
**Status inicial:** Backlog

## Descrição

Revisar o código completo antes da fase final, conferindo se os identificadores técnicos estão em inglês, se os nomes são expressivos, se há duplicação evitável e se interface, modelos e acesso aos dados estão separados. A organização do projeto deve ser proporcional à complexidade, sem camadas desnecessárias.

## Requisitos relacionados

- RNF02.1: identificadores técnicos em inglês.
- RNF02.2: nomes expressivos e baixa duplicação.
- RNF02.3: separação adequada entre interface, modelos e acesso aos dados.
- RNF02.4: organização proporcional à complexidade da aplicação.

## Critérios de aceitação

- [ ] Todos os identificadores técnicos (classes, métodos, variáveis, arquivos, pastas) estão em inglês.
- [ ] Os textos exibidos ao usuário permanecem em português.
- [ ] Nomes genéricos ou pouco expressivos foram renomeados.
- [ ] Trechos duplicados relevantes foram consolidados.
- [ ] Nenhum componente de interface acessa o serviço de nuvem diretamente.
- [ ] Os modelos não dependem da interface nem do serviço de nuvem.
- [ ] Não há código morto, arquivos não utilizados nem trechos comentados sem justificativa.
- [ ] Não há dados fictícios definidos no código em substituição ao armazenamento remoto.
- [ ] A estrutura de pastas está de acordo com as convenções do CARD-008, ou as diferenças estão justificadas.
- [ ] Não há camadas ou abstrações sem uso real, ou seja, a organização é proporcional.

## Dependências

- [CARD-028] Exibir o novo registro na listagem após o cadastro.
- [CARD-029] Garantir adaptação a diferentes telas e ausência de overflow.

## Observações técnicas

A revisão não deve alterar o comportamento do aplicativo. Se uma refatoração for necessária, repetir a verificação funcional afetada (CARD-036). O documento não exige arquitetura específica e valoriza soluções simples, por isso a ausência de estruturas elaboradas não é falha, desde que a separação exigida exista. Uma revisão por pessoas que não escreveram o código tende a identificar mais problemas.

## Definition of Done

- [ ] Atividade concluída.
- [ ] Critérios de aceitação atendidos.
- [ ] Revisão feita por pelo menos um integrante que não escreveu o trecho revisado.
- [ ] Alterações integradas ao ramo principal.