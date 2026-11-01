# CARD-008 Estabelecer convenções de código e organização do projeto

**Tipo:** Task  
**Prioridade:** Média  
**Complexidade:** Pequena  
**Status inicial:** Backlog

## Descrição

Combinar, de forma breve, as convenções que a equipe seguirá no código: idioma dos identificadores, critérios de nomenclatura, organização de pastas e o modo como interface, modelos e acesso aos dados ficarão separados.

O documento não exige uma arquitetura específica, mas exige separação adequada entre interface, modelos e acesso aos dados, e organização proporcional à complexidade. O cartão evita decisões arquiteturais desnecessárias e define apenas o mínimo para que todos escrevam código de forma consistente.

## Requisitos relacionados

- RNF02.1: identificadores técnicos em inglês.
- RNF02.2: nomes expressivos e baixa duplicação.
- RNF02.3: separação adequada entre interface, modelos e acesso aos dados.
- RNF02.4: organização proporcional à complexidade da aplicação.

## Critérios de aceitação

- [ ] As convenções estão registradas em documento curto, acessível a toda a equipe.
- [ ] O documento determina que identificadores técnicos (classes, métodos, variáveis, arquivos) são escritos em inglês.
- [ ] O documento determina que textos exibidos ao usuário são escritos em português.
- [ ] O documento define pastas distintas para interface, modelos e acesso aos dados.
- [ ] A organização proposta é proporcional ao tamanho do projeto (sem camadas ou padrões que não se justifiquem pela complexidade).
- [ ] Todos os integrantes leram e concordaram com as convenções.

## Dependências

- [CARD-004] Criar projeto Flutter base.

## Observações técnicas

O projeto Flutter já inclui um conjunto padrão de regras de análise estática, que serve de apoio ao `flutter analyze` (CARD-031). A pasta de documentação do projeto pode abrigar o documento, mas a localização é decisão da equipe. Não definir padrões arquiteturais completos, pois o PDF explicitamente não exige nenhuma arquitetura e valoriza soluções simples.

## Definition of Done

- [ ] Atividade concluída.
- [ ] Critérios de aceitação atendidos.
- [ ] Convenções disponíveis para consulta durante todo o desenvolvimento.