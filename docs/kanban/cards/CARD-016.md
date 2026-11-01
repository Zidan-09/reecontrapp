# CARD-016 Implementar gerenciamento de estado do envio do formulário

**Tipo:** Feature  
**Prioridade:** Alta  
**Complexidade:** Média  
**Status inicial:** Backlog

## Descrição

Implementar o gerenciamento de estado do envio do formulário de cadastro, representando as fases do processo (por exemplo, ocioso, enviando, sucesso e erro) e impedindo novos envios enquanto uma gravação estiver em andamento.

Após uma gravação bem-sucedida, o estado da listagem (CARD-015) deve ser atualizado, para que a interface mostre o novo registro.

## Requisitos relacionados

- RF04.3: gerenciar o estado de envio do formulário.
- RF04.4: atualizar a interface após um cadastro.
- RF03.3: impedir envios repetidos durante a gravação.
- RF03.4: tratar falhas de comunicação, apresentando mensagens compreensíveis.
- RF03.5: permitir tentar novamente uma operação que tenha falhado.

## Critérios de aceitação

- [ ] O estado representa pelo menos: sem envio em andamento, envio em andamento, sucesso e erro.
- [ ] Uma nova solicitação de envio durante uma gravação em andamento é ignorada, e não gera registro duplicado.
- [ ] O estado de erro guarda a mensagem definida no CARD-014.
- [ ] Após um erro, uma nova tentativa de envio é possível sem sair do formulário.
- [ ] Após sucesso na gravação, o estado da listagem é atualizado.
- [ ] O estado não contém componentes de interface.
- [ ] O estado usa a mesma ferramenta de gerenciamento definida no CARD-015.

## Dependências

- [CARD-011] Implementar gravação assíncrona de registro na nuvem.
- [CARD-014] Converter falhas de comunicação em mensagens compreensíveis.
- [CARD-015] Implementar gerenciamento de estado da listagem.

## Observações técnicas

O bloqueio de reenvio deve existir na camada de estado e não depender apenas de desabilitar o botão na tela, pois toques rápidos podem chegar antes da reconstrução da interface. Este cartão trata do estado. O botão, o indicador de processamento e as mensagens ficam nos CARD-026 e CARD-027. A forma de atualizar a listagem após o cadastro (recarregar da nuvem ou inserir o novo item) é decisão da equipe, desde que o resultado seja o descrito no CARD-028.

## Definition of Done

- [ ] Implementação concluída.
- [ ] Critérios de aceitação atendidos.
- [ ] Verificação feita com tentativas repetidas de envio e com falha de conexão.
- [ ] Código revisado por outro integrante e integrado ao ramo principal.