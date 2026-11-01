# CARD-027 Tratar falha de gravação com mensagem e nova tentativa

**Tipo:** Feature  
**Prioridade:** Alta  
**Complexidade:** Pequena  
**Status inicial:** Backlog

## Descrição

Fazer a tela de cadastro tratar falhas de gravação: apresentar a mensagem compreensível definida no CARD-014, preservar os dados digitados e permitir que o usuário tente salvar de novo sem refazer o preenchimento.

## Requisitos relacionados

- RF03.4: tratar falhas de comunicação, apresentando mensagens compreensíveis.
- RF03.5: permitir tentar novamente uma operação que tenha falhado.
- RNF01.2: apresentar interface em português.
- RNF01.5: informar adequadamente operações em andamento e falhas.

## Critérios de aceitação

- [ ] Quando a gravação falha, a tela exibe a mensagem do CARD-014, em português.
- [ ] Os dados digitados no formulário são preservados após a falha.
- [ ] O usuário pode acionar a ação de salvar novamente, ou uma ação específica de nova tentativa.
- [ ] A nova tentativa, quando bem-sucedida, grava exatamente um registro.
- [ ] Após a falha, o indicador de processamento e o bloqueio de envio são removidos.
- [ ] Com o dispositivo sem conexão, a falha foi provocada e a nova tentativa, depois de restabelecida a conexão, foi concluída com sucesso.
- [ ] Uma falha não gera registros duplicados nem parciais na nuvem.
- [ ] A tela não exibe código de erro, trecho de exceção nem URL.

## Dependências

- [CARD-014] Converter falhas de comunicação em mensagens compreensíveis.
- [CARD-026] Implementar o salvamento com indicador de processamento e bloqueio de reenvio.

## Observações técnicas

A mensagem pode ser exibida no próprio formulário ou em outro componente do Material 3, e a escolha é da equipe. Verificar com atenção o caso em que a gravação chegou à nuvem, mas a resposta foi perdida. Nesse caso, a nova tentativa poderia criar um registro duplicado. O documento não define como tratar esse caso, e a equipe deve avaliar, sem exigir mecanismos complexos, e registrar a decisão.

## Definition of Done

- [ ] Implementação concluída.
- [ ] Critérios de aceitação atendidos.
- [ ] Falha e nova tentativa verificadas com dispositivo sem conexão.
- [ ] Código revisado por outro integrante e integrado ao ramo principal.