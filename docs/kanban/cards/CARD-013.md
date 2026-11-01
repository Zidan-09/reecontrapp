# CARD-013 Ordenar registros do mais recente para o mais antigo

**Tipo:** Feature  
**Prioridade:** Alta  
**Complexidade:** Pequena  
**Status inicial:** Backlog

## Descrição

Garantir que os registros carregados sejam apresentados em ordem decrescente de data e hora de cadastro, com os mais recentes primeiro, conforme exige o documento.

Este cartão define onde e como a ordenação acontece (na consulta remota ou no aplicativo). O PDF não especifica (ambiguidade A7).

## Requisitos relacionados

- RF01.4: apresentar os registros mais recentes primeiro.
- RB03: a listagem apresenta os registros em ordem decrescente de cadastro.

## Critérios de aceitação

- [ ] Com pelo menos três registros de datas diferentes, a lista apresenta primeiro o mais recente e por último o mais antigo.
- [ ] Um registro recém-cadastrado aparece no topo da lista.
- [ ] A ordem se mantém após atualizar a listagem (CARD-022).
- [ ] A ordenação usa a data e a hora gravadas no CARD-012, e não a ordem de chegada dos dados.
- [ ] A decisão sobre onde a ordenação ocorre está registrada.

## Dependências

- [CARD-010] Implementar leitura assíncrona dos registros na nuvem.
- [CARD-012] Registrar data e hora do cadastro automaticamente.

## Observações técnicas

Se a ordenação for feita na consulta, verificar se o serviço escolhido a suporta em um campo de data. Se for feita no aplicativo, a lista completa precisa estar carregada. Registros com data ausente não são previstos pelo documento. Se existirem registros criados diretamente no console da nuvem (por exemplo, durante os testes do CARD-005), a equipe deve decidir como tratá-los e registrar a decisão. Isso se relaciona com a ambiguidade A8.

## Definition of Done

- [ ] Implementação concluída.
- [ ] Critérios de aceitação atendidos.
- [ ] Verificação feita com a nuvem real e registros de datas distintas.
- [ ] Código revisado por outro integrante e integrado ao ramo principal.