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

- [ ] O comando `flutter analyze` foi executado na raiz do projeto, com as dependências instaladas.
- [ ] A saída do comando não reporta problemas no código da equipe (erros, avisos ou sugestões).
- [ ] Nenhum problema foi ocultado por meio de ignores em massa ou desativação geral de regras sem justificativa registrada.
- [ ] Se algum problema reportado não for do código da equipe (por exemplo, arquivos gerados por ferramenta), ele está registrado, com explicação.
- [ ] O resultado final da execução está registrado no cartão.
- [ ] As correções foram integradas ao ramo principal.

## Dependências

- [CARD-030] Revisar nomenclatura, duplicação e separação de camadas.

## Observações técnicas

Executar o comando também em um ambiente com as dependências recém-instaladas, pois resultados podem divergir de uma máquina com cache antigo. A configuração de regras fornecida com o projeto Flutter já serve de base e não precisa ser ampliada, pois o documento não exige regras adicionais. Qualquer alteração de código feita depois deste cartão (inclusive correções dos CARD-036 a CARD-038) exige repetir a análise antes da entrega (CARD-039).

## Definition of Done

- [ ] Atividade concluída.
- [ ] Critérios de aceitação atendidos.
- [ ] Comando executado com resultado limpo, registrado.
- [ ] Correções revisadas e integradas ao ramo principal.