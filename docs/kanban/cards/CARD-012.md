# CARD-012 Registrar data e hora do cadastro automaticamente

**Tipo:** Feature  
**Prioridade:** Alta  
**Complexidade:** Pequena  
**Status inicial:** Backlog

## Descrição

Garantir que cada registro gravado receba automaticamente a data e a hora do cadastro, sem que o usuário precise informá-las. Esse valor é a base da ordenação por mais recentes (CARD-013).

O documento não diz se a data e a hora devem vir do dispositivo ou do servidor (ambiguidade A2). A equipe deve escolher uma das duas formas e registrar a decisão.

## Requisitos relacionados

- RF02.7: registrar data e hora do cadastro automaticamente.
- RB02: data e hora do cadastro são registradas automaticamente, sem informação do usuário.

## Critérios de aceitação

- [ ] O formulário de cadastro não possui campo de data nem de hora.
- [ ] Todo registro gravado contém data e hora, e o valor é definido no momento do cadastro.
- [ ] A data e a hora são recuperadas na leitura (CARD-010) e preenchem o campo do modelo.
- [ ] A origem do valor (dispositivo ou servidor) está registrada, com justificativa.
- [ ] Dois registros cadastrados em momentos diferentes têm valores diferentes e na ordem correta.
- [ ] O formato armazenado permite ordenar os registros de forma confiável.

## Dependências

- [CARD-011] Implementar gravação assíncrona de registro na nuvem.

## Observações técnicas

Se o relógio do dispositivo for usado, registros de aparelhos com horários diferentes podem ficar fora de ordem. Se o relógio do servidor for usado, o serviço escolhido deve oferecer essa funcionalidade. A escolha afeta o CARD-013 e deve considerar o serviço definido no CARD-002. Padronizar o fuso horário no armazenamento é uma decisão que a equipe deve tomar e documentar. A apresentação da data na interface não é exigida pelo documento, que pede apenas o registro automático.

## Definition of Done

- [ ] Implementação concluída.
- [ ] Critérios de aceitação atendidos.
- [ ] Verificação feita com pelo menos dois registros cadastrados em momentos distintos.
- [ ] Código revisado por outro integrante e integrado ao ramo principal.