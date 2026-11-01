# CARD-025 Implementar a validação dos campos do formulário

**Tipo:** Feature  
**Prioridade:** Alta  
**Complexidade:** Média  
**Status inicial:** Backlog

## Descrição

Implementar a validação de todos os campos do formulário antes do envio, apresentando mensagens claras, em português, junto aos campos inválidos. Nenhum dado inválido deve chegar à gravação.

Este é o núcleo do critério de avaliação "Cadastro e validação do formulário" (2,0 pontos).

## Requisitos relacionados

- RF02.2: nome do objeto obrigatório, até 60 caracteres.
- RF02.3: descrição obrigatória, até 200 caracteres.
- RF02.4: local obrigatório.
- RF02.5: situação perdido ou encontrado.
- RF02.6: validar todos os campos antes do envio.
- RB01: a situação do objeto assume apenas os valores "perdido" ou "encontrado".
- RNF01.2: apresentar interface em português.

## Critérios de aceitação

- [ ] Nome vazio é rejeitado com mensagem em português.
- [ ] Nome com 61 caracteres ou mais é rejeitado, e nome com exatamente 60 caracteres é aceito.
- [ ] Descrição vazia é rejeitada com mensagem em português.
- [ ] Descrição com 201 caracteres ou mais é rejeitada, e descrição com exatamente 200 caracteres é aceita.
- [ ] Local vazio é rejeitado com mensagem em português.
- [ ] Um formulário sem situação válida (perdido ou encontrado) não pode ser enviado.
- [ ] Todos os campos inválidos são sinalizados na mesma tentativa de envio, e não apenas o primeiro.
- [ ] Com algum campo inválido, nenhuma gravação é disparada.
- [ ] Um formulário totalmente válido é aceito.
- [ ] O tratamento de campos preenchidos apenas com espaços está definido e registrado (ambiguidade A4).
- [ ] O tamanho máximo de 60 e 200 caracteres é verificado também quando o texto é colado.

## Dependências

- [CARD-024] Construir o formulário de cadastro com os campos definidos.

## Observações técnicas

O documento fixa apenas os limites máximos e a obrigatoriedade. Não há tamanho mínimo nem regra de formato, e nenhuma deve ser inventada. A contagem de caracteres para os limites deve ser coerente em todos os cenários de teste, inclusive com acentos e emojis, o que depende da forma de contagem escolhida pelo Dart. A equipe deve decidir e registrar. O campo Local não tem limite no documento (ambiguidade A3), e qualquer limite adotado deve ser registrado como decisão da equipe, e não como exigência do professor. Pode ser útil exibir um contador de caracteres, mas isso não é exigido.

## Definition of Done

- [ ] Implementação concluída.
- [ ] Critérios de aceitação atendidos.
- [ ] Todos os casos-limite (0, 1, 60, 61, 200 e 201 caracteres) testados manualmente.
- [ ] Código revisado por outro integrante e integrado ao ramo principal.