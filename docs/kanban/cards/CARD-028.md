# CARD-028 Exibir o novo registro na listagem após o cadastro

**Tipo:** Feature  
**Prioridade:** Alta  
**Complexidade:** Pequena  
**Status inicial:** Backlog

## Descrição

Garantir que, após um cadastro bem-sucedido, o novo registro apareça na listagem, na posição correta (o mais recente primeiro), sem que o usuário precise fazer a atualização manual.

Este cartão fecha o fluxo principal do aplicativo: listar, cadastrar e ver o registro novo na lista.

## Requisitos relacionados

- RF02.8: exibir o novo registro na listagem após o cadastro.
- RF04.4: atualizar a interface após um cadastro.
- RF01.4: apresentar os registros mais recentes primeiro.
- RB03: a listagem apresenta os registros em ordem decrescente de cadastro.

## Critérios de aceitação

- [ ] Após cadastrar um objeto com sucesso, o usuário vê a listagem contendo o novo registro sem acionar a atualização manual.
- [ ] O novo registro aparece no topo da lista.
- [ ] Os dados exibidos do novo registro (nome, local, situação e descrição) correspondem ao que foi digitado.
- [ ] O registro exibido corresponde ao que está gravado na nuvem.
- [ ] Os registros que já estavam na lista continuam presentes.
- [ ] Reabrir o aplicativo mantém o novo registro na lista.
- [ ] O fluxo funciona também quando a lista estava em erro ou ainda não tinha sido carregada.

## Dependências

- [CARD-019] Construir a tela de listagem com os dados dos objetos.
- [CARD-026] Implementar o salvamento com indicador de processamento e bloqueio de reenvio.

## Observações técnicas

A forma de atualizar a lista (recarregar da nuvem ou inserir o item localmente) é decisão da equipe, e a escolha deve ser registrada. Se o item for inserido localmente, garantir que o que o usuário vê seja o mesmo que está gravado, sobretudo a data e a hora (CARD-012), que dependem da origem escolhida. Se a lista for recarregada, tratar o caso em que a nova leitura falha logo após uma gravação bem-sucedida.

## Definition of Done

- [ ] Implementação concluída.
- [ ] Critérios de aceitação atendidos.
- [ ] Fluxo completo (listar, cadastrar, ver o novo registro) executado com a nuvem real.
- [ ] Código revisado por outro integrante e integrado ao ramo principal.