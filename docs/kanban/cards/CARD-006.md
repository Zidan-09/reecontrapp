# CARD-006 Definir regras de acesso compatíveis com app sem autenticação

**Tipo:** Task  
**Prioridade:** Alta  
**Complexidade:** Pequena  
**Status inicial:** Backlog

## Descrição

Definir e aplicar, no serviço de nuvem, as regras de acesso que permitam ao aplicativo ler e gravar registros sem autenticação, mantendo uma configuração coerente com a finalidade demonstrativa do projeto.

O documento do professor exige que o serviço "possua regras de acesso compatíveis com essa finalidade", isto é, um aplicativo sem autenticação que armazena apenas dados demonstrativos, sem informações pessoais ou sensíveis.

## Requisitos relacionados

- RB05: somente dados demonstrativos, sem informações pessoais ou sensíveis.
- RB06: o serviço deve ter regras de acesso compatíveis com um aplicativo sem autenticação.

## Critérios de aceitação

- [x] Uma leitura de registros sem autenticação é permitida pelas regras.
- [x] Uma criação de registro sem autenticação é permitida pelas regras.
- [x] As regras foram verificadas por teste (simulador de regras do serviço ou requisição de teste), e não apenas lidas.
- [x] As regras adotadas estão documentadas, com justificativa de que são compatíveis com um aplicativo sem autenticação que usa apenas dados demonstrativos.
- [x] As regras não possuem prazo de expiração anterior ao fim do período de avaliação.
- [x] A equipe registrou que nenhum dado pessoal ou sensível será armazenado.

## Dependências

- [CARD-005] Configurar o serviço de nuvem e a estrutura de armazenamento.

## Observações técnicas

Alguns serviços aplicam por padrão regras de teste com data de expiração. Se o serviço escolhido fizer isso, verificar esse prazo, pois regras expiradas impediriam a avaliação (penalidade da seção 8.4).

O PDF não exige edição nem exclusão de registros (RB04). Se as regras também vão permitir ou negar essas operações, é uma decisão da equipe, que deve ser registrada junto com a justificativa. Ambiguidade relacionada: A1 (o que se pode expor no repositório), registrada em `planejamento.md`.

## Definition of Done

- [x] Atividade concluída.
- [x] Critérios de aceitação atendidos.
- [x] Regras e justificativa registradas em local acessível à equipe.
- [ ] Configuração conferida por pelo menos um segundo integrante.