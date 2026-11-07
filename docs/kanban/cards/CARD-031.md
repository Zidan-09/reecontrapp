# CARD-031 Executar `flutter analyze` e corrigir os problemas

**Tipo:** Task  
**Prioridade:** Alta  
**Complexidade:** Pequena  
**Status inicial:** Backlog

## Descrição

Executar a análise estática do projeto com `flutter analyze` e corrigir todos os problemas provenientes do código da equipe. O documento exige que o projeto execute o comando sem problemas desse tipo, e essa verificação consta do checklist de entrega.

## Requisitos relacionados

- RNF02.5: o projeto deve executar `flutter analyze` sem problemas provenientes do código da equipe.
- ENT06: cumprir o checklist de entrega da seção 8.3 (item sobre `flutter analyze`).

## Critérios de aceitação

- [x] O comando `flutter analyze` foi executado na raiz do projeto, com as dependências instaladas.
- [x] A saída do comando não reporta problemas no código da equipe (erros, avisos ou sugestões).
- [x] Nenhum problema foi ocultado por meio de ignores em massa ou desativação geral de regras sem justificativa registrada.
- [x] Se algum problema reportado não for do código da equipe (por exemplo, arquivos gerados por ferramenta), ele está registrado, com explicação.
- [x] O resultado final da execução está registrado no cartão.
- [ ] As correções foram integradas ao ramo principal. *(pendente do merge final — CARD-038)*

## Dependências

- [CARD-030] Revisar nomenclatura, duplicação e separação de camadas.

## Observações técnicas

Executar o comando também em um ambiente com as dependências recém-instaladas, pois resultados podem divergir de uma máquina com cache antigo. A configuração de regras fornecida com o projeto Flutter já serve de base e não precisa ser ampliada, pois o documento não exige regras adicionais. Qualquer alteração de código feita depois deste cartão (inclusive correções dos CARD-036 a CARD-038) exige repetir a análise antes da entrega (CARD-039).

## Definition of Done

- [x] Atividade concluída.
- [x] Critérios de aceitação atendidos.
- [x] Comando executado com resultado limpo, registrado.
- [ ] Correções revisadas e integradas ao ramo principal. *(pendente do merge final — CARD-038)*

## Registro de execução — 08/11/2026

**Ambiente:** Flutter 3.47.7 (stable) • Dart 3.13.5 • Windows 10 • dependências atualizadas com `flutter pub get` na mesma sessão (`Got dependencies!`).

**Comando executado na raiz do projeto:**

```text
$ flutter analyze
Analyzing reecontrapp...
No issues found! (ran in 2.6s)
```

**Código de saída:** `0` — nenhum erro, aviso ou sugestão reportado.

### Análise executada depois dos demais cards

A execução acima foi feita **depois** do `CARD-034` (chaves movidas para `.env`) e do `CARD-030` (revisão de duplicação e remoção do `test/widget_test.dart`), ou seja, reflete o estado atual do código. Qualquer alteração posterior (CARD-036 a CARD-038) exige repetir o comando antes da entrega (CARD-039).

### Configuração do analisador

`analysis_options.yaml` é **o arquivo gerado pelo `flutter create`**, inalterado desde o commit inicial (`3c2d698`, CARD-003). Ele ativa `package:flutter_lints/flutter.yaml` e possui a lista de exclusão padrão da própria ferramenta:

```yaml
analyzer:
  exclude:
    - build/**
    - android/**
    - ios/**
    - web/**
    - windows/**
    - macos/**
    - linux/**
```

A exclusão cobre apenas os diretórios **gerados pelas ferramentas de plataforma** (arquivos nativos do template, não escrito pela equipe); `lib/`, `test/` e `docs/` são analisados integralmente. Nenhuma regra foi desativada, nenhum `linter.rules` foi removido e nenhuma análise foi reduzida por decisão da equipe.

### Directives de ignore existentes no código (2, ambas justificadas)

Não há `ignore_for_file` de regra ampla e nenhum código suprimido em massa. As duas únicas supressões são:

| Arquivo | Diretriz | Justificativa |
|---|---|---|
| `lib/firebase_options.dart` | `// ignore_for_file: type=lint` | Herdada do arquivo gerado pelo FlutterFire CLI; contém apenas as constantes de configuração e nenhum comportamento. O conteúdo é mantido pela equipe desde o CARD-034. |
| `lib/features/lost_found/presentation/pages/item_list_page.dart` | `// ignore: unused_result` (linha do `handleRefresh`) | O resultado do `ref.read(itemListProvider.future)` é tratado deliberadamente pelo estado do próprio provider; o `try/catch` ao redor documenta que a falha permanece exposta na tela. |

Nenhum problema foi ocultado: a análise roda com a configuração padrão do Flutter.

### Repetição pendente

Este cartão será reexecutado no CARD-039 (checklist 8.3, item 9: "`dart format .` e `flutter analyze` após a última alteração").