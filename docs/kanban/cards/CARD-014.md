# CARD-014 Converter falhas de comunicação em mensagens compreensíveis

**Tipo:** Feature  
**Prioridade:** Alta  
**Complexidade:** Média  
**Status inicial:** Backlog

## Descrição

Definir um tratamento único para as falhas que podem ocorrer na leitura e na gravação, transformando-as em mensagens em português que o usuário consiga entender, sem expor termos técnicos nem detalhes internos do serviço.

Esse tratamento é reutilizado pelo estado da listagem (CARD-015), pelo estado do formulário (CARD-016) e pelas telas (CARD-021 e CARD-027).

## Requisitos relacionados

- RF03.4: tratar falhas de comunicação, apresentando mensagens compreensíveis.
- RNF01.2: apresentar interface em português.
- RNF01.5: informar adequadamente operações em andamento e falhas.

## Critérios de aceitação

- [ ] Falhas de leitura e de gravação passam pelo mesmo tratamento.
- [ ] A falta de conexão com a internet gera uma mensagem específica e compreensível.
- [ ] Falhas não identificadas geram uma mensagem genérica compreensível, e a aplicação não é encerrada.
- [ ] As mensagens estão em português e não exibem código de erro, trecho de exceção nem URL.
- [ ] As mensagens podem ser acompanhadas de uma indicação de que o usuário pode tentar novamente.
- [ ] Os cenários de falha foram simulados, pelo menos com o dispositivo sem conexão.
- [ ] Nenhuma falha de comunicação resulta em tela sem resposta ou fechamento inesperado.

## Dependências

- [CARD-010] Implementar leitura assíncrona dos registros na nuvem.
- [CARD-011] Implementar gravação assíncrona de registro na nuvem.

## Observações técnicas

As categorias de falha dependem do serviço escolhido. O cartão não exige um número mínimo de categorias, apenas que o caso mais comum (sem conexão) e o caso genérico sejam cobertos. Os detalhes técnicos da falha podem ser preservados para diagnóstico da equipe, desde que não sejam exibidos ao usuário. Este cartão define o tratamento e as mensagens. A exibição está nos CARD-021 e CARD-027.

## Definition of Done

- [ ] Implementação concluída.
- [ ] Critérios de aceitação atendidos.
- [ ] Falhas simuladas na leitura e na gravação.
- [ ] Código revisado por outro integrante e integrado ao ramo principal.