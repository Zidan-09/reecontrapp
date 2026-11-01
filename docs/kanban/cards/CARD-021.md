# CARD-021 Exibir carregamento e falhas na listagem com nova tentativa

**Tipo:** Feature  
**Prioridade:** Alta  
**Complexidade:** Média  
**Status inicial:** Backlog

## Descrição

Fazer a tela de listagem refletir os estados do CARD-015: mostrar um indicador de carregamento enquanto os registros são lidos da nuvem, apresentar a mensagem compreensível quando a leitura falhar e oferecer uma ação para tentar novamente.

Sem este cartão, uma falha de leitura deixaria o usuário diante de uma tela sem explicação e sem saída.

## Requisitos relacionados

- RF03.2: exibir indicador de carregamento durante as operações.
- RF03.4: tratar falhas de comunicação, apresentando mensagens compreensíveis.
- RF03.5: permitir tentar novamente uma operação que tenha falhado.
- RF04.2: gerenciar os estados de carregamento, sucesso e erro.
- RNF01.2: apresentar interface em português.
- RNF01.5: informar adequadamente operações em andamento e falhas.

## Critérios de aceitação

- [ ] Durante a leitura inicial, a tela exibe um indicador de carregamento.
- [ ] Quando a leitura falha, a tela exibe a mensagem compreensível definida no CARD-014, em português.
- [ ] Na tela de erro existe uma ação visível para tentar novamente.
- [ ] Acionar a nova tentativa mostra o indicador de carregamento de novo e, em seguida, a lista ou um novo erro.
- [ ] A nova tentativa funciona mais de uma vez seguida.
- [ ] Com o dispositivo sem conexão, a falha foi provocada e as três situações (carregando, erro, nova tentativa com sucesso) foram observadas.
- [ ] A tela não exibe código de erro, trecho de exceção nem URL.
- [ ] A tela de erro não mostra uma lista desatualizada sem avisar o usuário.

## Dependências

- [CARD-014] Converter falhas de comunicação em mensagens compreensíveis.
- [CARD-015] Implementar gerenciamento de estado da listagem.
- [CARD-019] Construir a tela de listagem com os dados dos objetos.

## Observações técnicas

O indicador de carregamento da atualização manual (CARD-022) pode ser distinto do indicador de carregamento inicial, e a equipe decide se os dois compartilham o mesmo componente. Se houver uma lista já carregada e uma atualização falhar, a equipe deve decidir e registrar como informar a falha sem perder a lista exibida. O PDF não define esse caso. O comportamento da lista sem registros também não é definido (ambiguidade A12) e não faz parte deste cartão.

## Definition of Done

- [ ] Implementação concluída.
- [ ] Critérios de aceitação atendidos.
- [ ] Cenários de carregamento, erro e nova tentativa verificados em execução real.
- [ ] Código revisado por outro integrante e integrado ao ramo principal.