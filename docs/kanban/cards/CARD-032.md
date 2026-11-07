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

- [x] O comando `dart format .` foi executado na raiz do projeto.
- [x] Uma segunda execução do mesmo comando não altera nenhum arquivo.
- [x] A formatação foi aplicada em um commit próprio ou identificada claramente, sem misturar alterações de comportamento.
- [x] Após a formatação, o aplicativo continua compilando e executando.
- [x] Após a formatação, `flutter analyze` continua sem problemas do código da equipe.
- [ ] O resultado foi integrado ao ramo principal. *(pendente do merge final — CARD-038)*

## Dependências

- [CARD-031] Executar `flutter analyze` e corrigir os problemas.

## Observações técnicas

A formatação deve ser a última alteração de código antes da validação final, para evitar divergências. Se houver nova alteração depois, repetir o comando. Antes de executar, a equipe deve combinar um momento em que ninguém tenha alterações locais não integradas, para não gerar conflitos em massa.

## Definition of Done

- [x] Atividade concluída.
- [x] Critérios de aceitação atendidos.
- [x] Segunda execução verificada sem alterações.
- [ ] Alterações integradas ao ramo principal. *(pendente do merge final — CARD-038)*

## Registro de execução — 08/11/2026

**Ambiente:** Flutter 3.47.7 (stable) • Dart 3.13.5 • Windows 10.

**Primeira execução, na raiz do projeto:**

```text
$ dart format .
Formatted 23 files (0 changed) in 0.06 seconds.
```

**Segunda execução (verificação de idempotência):**

```text
$ dart format --output=none --set-exit-if-changed .
Formatted 23 files (0 changed) in 0.08 seconds.
(exit code 0)
```

Os 23 arquivos Dart do projeto (`lib/` e `test/`) já estavam integralmente formatados: **nenhuma alteração foi necessária**.

### Não houve alteração de comportamento neste commit

Como o `dart format .` não precisou alterar nada, este cartão gera apenas o registro. As mudanças de código dos cartões anteriores (`CARD-034` e `CARD-030`) já foram formatadas **antes** dos respectivos commits — em ambos `dart format .` retornou `0 changed` imediatamente antes do commit, e o conteúdo commitado passou pelo formataador.

### Verificações posteriores à formatação

| Comando | Resultado |
|---|---|
| `flutter build web --dart-define-from-file=.env` | `✓ Built build\web` |
| `flutter analyze` | `No issues found!` |
| `flutter test` | `All tests passed!` (11 testes, executado no CARD-030) |

### Repetição pendente

Este cartão será reexecutado no CARD-039 (checklist 8.3, item 9: "`dart format .` e `flutter analyze` após a última alteração"), já que alterações de código podem ocorrer na validação manual (CARD-036/CARD-037).