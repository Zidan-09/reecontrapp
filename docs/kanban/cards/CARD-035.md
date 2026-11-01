# CARD-035 Garantir commits identificáveis de todos os integrantes

**Tipo:** Task  
**Prioridade:** Alta  
**Complexidade:** Pequena  
**Status inicial:** Backlog

## Descrição

Assegurar que todos os integrantes da equipe tenham commits identificáveis no repositório, associados a cada pessoa por nome ou conta, e que o histórico de commits seja preservado. Este cartão é contínuo e acompanha o desenvolvimento, sendo encerrado na verificação final.

## Requisitos relacionados

- EQ02: todos os integrantes participam efetivamente do desenvolvimento e conhecem o funcionamento da solução.
- EQ03: todos os integrantes possuem commits identificáveis no repositório.
- DOC06: histórico de commits dos integrantes preservado no repositório.

## Critérios de aceitação

- [ ] Cada integrante configurou a própria identidade no Git (nome e e-mail) antes de commitar.
- [ ] O e-mail dos commits de cada integrante está associado à respectiva conta do GitHub, de modo que a autoria apareça no repositório.
- [ ] Cada integrante possui commits com conteúdo do projeto, e não apenas alterações triviais.
- [ ] O histórico não foi comprimido, nem reescrito de forma a apagar a autoria de integrantes.
- [ ] A lista de contribuidores do repositório mostra todos os integrantes.
- [ ] A verificação foi repetida na véspera da entrega.

## Dependências

- [CARD-001] Registrar integrantes e responsabilidades da equipe.

## Observações técnicas

Este cartão não cria os commits, apenas garante que a autoria seja identificável. Um integrante que não consiga commitar corretamente deve resolver o problema logo, pois o documento não admite compensação posterior. Em trabalho em dupla, registrar os dois autores na mensagem do commit é uma boa prática, mas cada integrante precisa ter também seus próprios commits. Se for necessário corrigir autoria de commits antigos, avaliar o impacto no histórico antes (ver CARD-034).

## Definition of Done

- [ ] Atividade concluída.
- [ ] Critérios de aceitação atendidos.
- [ ] Verificação final feita por pelo menos dois integrantes.