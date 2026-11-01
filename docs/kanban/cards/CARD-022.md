# CARD-022 Implementar a atualização manual da listagem

**Tipo:** Feature  
**Prioridade:** Alta  
**Complexidade:** Pequena  
**Status inicial:** Backlog

## Descrição

Permitir que o usuário atualize manualmente a listagem, buscando novamente os registros na nuvem, por exemplo para ver objetos cadastrados por outras instalações do aplicativo.

O documento exige a possibilidade de atualizar a listagem, mas não define o mecanismo (gesto, botão ou outro). A escolha é da equipe (ambiguidade A5).

## Requisitos relacionados

- RF01.5: permitir atualizar a listagem.
- TL01: tela de listagem com atualização dos registros.
- RF03.2: exibir indicador de carregamento durante as operações.
- RNF01.5: informar adequadamente operações em andamento e falhas.

## Critérios de aceitação

- [ ] A tela de listagem oferece uma ação de atualização identificável pelo usuário.
- [ ] Ao acionar a atualização, os registros são lidos novamente da nuvem.
- [ ] Um registro criado por outra instalação, ou diretamente no serviço, aparece após a atualização.
- [ ] Um indicador de operação em andamento é exibido durante a atualização.
- [ ] Acionar a atualização repetidamente enquanto ela está em andamento não dispara várias leituras simultâneas.
- [ ] A ordenação por mais recentes é mantida após a atualização.
- [ ] Uma falha na atualização é informada com a mensagem do CARD-014.

## Dependências

- [CARD-015] Implementar gerenciamento de estado da listagem.
- [CARD-019] Construir a tela de listagem com os dados dos objetos.

## Observações técnicas

A ação de atualização do CARD-015 já deve existir, e este cartão apenas a expõe na interface. O Material oferece componentes e gestos comuns para esse fim, e a equipe pode escolher o mais simples. Se o mecanismo escolhido não for óbvio (por exemplo, um gesto sem botão equivalente), considerar se o usuário o descobrirá, pois o documento valoriza a ausência de controles inacessíveis (RNF01.4). A decisão deve ser registrada.

## Definition of Done

- [ ] Implementação concluída.
- [ ] Critérios de aceitação atendidos.
- [ ] Atualização verificada com um registro criado fora da instalação testada.
- [ ] Código revisado por outro integrante e integrado ao ramo principal.