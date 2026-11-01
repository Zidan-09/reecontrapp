# CARD-032 Formatar o código com `dart format .`

**Tipo:** Task  
**Prioridade:** Alta  
**Complexidade:** Pequena  
**Status inicial:** Backlog

## Descrição

Formatar todo o código do projeto com `dart format .`, conforme exige o documento do professor, e integrar o resultado ao repositório. Esta formatação consta também do checklist de entrega.

## Requisitos relacionados

- RNF02.6: o código deve estar formatado com `dart format .`.
- ENT06: cumprir o checklist de entrega da seção 8.3 (item sobre `dart format .`).

## Critérios de aceitação

- [ ] O comando `dart format .` foi executado na raiz do projeto.
- [ ] Uma segunda execução do mesmo comando não altera nenhum arquivo.
- [ ] A formatação foi aplicada em um commit próprio ou identificada claramente, sem misturar alterações de comportamento.
- [ ] Após a formatação, o aplicativo continua compilando e executando.
- [ ] Após a formatação, `flutter analyze` continua sem problemas do código da equipe.
- [ ] O resultado foi integrado ao ramo principal.

## Dependências

- [CARD-031] Executar `flutter analyze` e corrigir os problemas.

## Observações técnicas

A formatação deve ser a última alteração de código antes da validação final, para evitar divergências. Se houver nova alteração depois, repetir o comando. Antes de executar, a equipe deve combinar um momento em que ninguém tenha alterações locais não integradas, para não gerar conflitos em massa.

## Definition of Done

- [ ] Atividade concluída.
- [ ] Critérios de aceitação atendidos.
- [ ] Segunda execução verificada sem alterações.
- [ ] Alterações integradas ao ramo principal.