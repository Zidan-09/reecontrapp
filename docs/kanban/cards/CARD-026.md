# CARD-026 Implementar o salvamento com indicador de processamento e bloqueio de reenvio

**Tipo:** Feature  
**Prioridade:** Alta  
**Complexidade:** Média  
**Status inicial:** Backlog

## Descrição

Conectar a ação de salvar do formulário à gravação na nuvem, usando o estado de envio do CARD-016. Durante a gravação, a tela mostra um indicador de processamento e impede novos envios.

O cartão cobre o caminho de sucesso e o comportamento durante o envio. O tratamento de falhas e a nova tentativa estão no CARD-027, e a exibição do novo registro na lista, no CARD-028.

## Requisitos relacionados

- RF02.6: validar todos os campos antes do envio.
- RF03.2: exibir indicador de carregamento durante as operações.
- RF03.3: impedir envios repetidos durante a gravação.
- RF04.3: gerenciar o estado de envio do formulário.
- TL02: tela de cadastro com ação para salvar e indicador de processamento durante o envio.
- RNF01.5: informar adequadamente operações em andamento e falhas.

## Critérios de aceitação

- [ ] Existe uma ação de salvar claramente identificada, em português.
- [ ] Ao acionar a ação com dados válidos, a gravação é iniciada na nuvem.
- [ ] Ao acionar a ação com dados inválidos, a validação do CARD-025 é executada e nenhuma gravação ocorre.
- [ ] Durante a gravação, um indicador de processamento é exibido.
- [ ] Durante a gravação, a ação de salvar não pode ser acionada de novo.
- [ ] Toques repetidos e rápidos na ação de salvar geram um único registro na nuvem.
- [ ] Durante a gravação, os campos do formulário não podem ser alterados ou a alteração é registrada de forma coerente (decisão da equipe registrada).
- [ ] Após a gravação com sucesso, o comportamento da tela está definido e registrado, e leva o usuário a ver o novo registro (CARD-028).
- [ ] O indicador e o bloqueio são removidos ao término da gravação, com sucesso ou falha.

## Dependências

- [CARD-016] Implementar gerenciamento de estado do envio do formulário.
- [CARD-025] Implementar a validação dos campos do formulário.

## Observações técnicas

O bloqueio da ação na interface complementa o bloqueio já existente no estado (CARD-016), e os dois devem coexistir. Se o usuário sair da tela durante a gravação, a equipe deve decidir como tratar isso, de modo que o estado não fique inconsistente. O documento não define esse caso. Evitar que a gravação seja disparada a partir do `build` ou de outros pontos de reconstrução da interface.

## Definition of Done

- [ ] Implementação concluída.
- [ ] Critérios de aceitação atendidos.
- [ ] Verificação feita com toques repetidos e com conexão lenta ou instável.
- [ ] Código revisado por outro integrante e integrado ao ramo principal.