# CARD-015 Implementar gerenciamento de estado da listagem

**Tipo:** Feature  
**Prioridade:** Alta  
**Complexidade:** Média  
**Status inicial:** Backlog

## Descrição

Implementar o gerenciamento de estado que mantém a lista de objetos cadastrados e os estados de carregamento, sucesso e erro da listagem, separando essa lógica da interface.

A tela de listagem (CARD-019) apenas reage a esse estado. Carregar e atualizar os dados são ações oferecidas por ele.

## Requisitos relacionados

- RF04.1: gerenciar a lista de objetos cadastrados.
- RF04.2: gerenciar os estados de carregamento, sucesso e erro.
- RF03.2: exibir indicador de carregamento durante as operações.
- RNF02.3: separação adequada entre interface, modelos e acesso aos dados.

## Critérios de aceitação

- [ ] O estado mantém a lista de objetos carregados.
- [ ] O estado distingue carregamento, sucesso e erro.
- [ ] O estado de erro guarda a mensagem compreensível definida no CARD-014.
- [ ] Existe uma ação de carregar e uma ação de atualizar, ambas assíncronas.
- [ ] Após uma falha, executar a ação de novo leva de volta ao carregamento e, depois, a sucesso ou erro.
- [ ] Mudanças no estado fazem a interface ser reconstruída, sem atualização manual.
- [ ] O estado não contém componentes de interface.
- [ ] A ferramenta escolhida para o gerenciamento de estado está registrada com justificativa.

## Dependências

- [CARD-010] Implementar leitura assíncrona dos registros na nuvem.
- [CARD-014] Converter falhas de comunicação em mensagens compreensíveis.

## Observações técnicas

O documento cita `ChangeNotifier`, Riverpod "ou outra abordagem apropriada" como possibilidades (sugestão técnica, não exigência). Preferir a solução mais simples que satisfaça os requisitos, e acrescentar dependência externa somente se houver necessidade comprovada. Cuidar para que ações disparadas em sequência (por exemplo, atualizar enquanto ainda carrega) não deixem o estado inconsistente.

## Definition of Done

- [ ] Implementação concluída.
- [ ] Critérios de aceitação atendidos.
- [ ] Transições de estado verificadas com sucesso e com falha.
- [ ] Código revisado por outro integrante e integrado ao ramo principal.