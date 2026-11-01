# CARD-010 Implementar leitura assíncrona dos registros na nuvem

**Tipo:** Feature  
**Prioridade:** Alta  
**Complexidade:** Média  
**Status inicial:** Backlog

## Descrição

Implementar a camada de acesso a dados responsável por ler da nuvem todos os registros de objetos e entregá-los ao restante do aplicativo no formato do modelo definido no CARD-009.

A operação deve ser assíncrona, sem bloquear a interface, e deve usar exclusivamente o armazenamento remoto. O documento proíbe substituir esse armazenamento por dados fictícios fixados no código.

## Requisitos relacionados

- RF01.1: carregar os registros armazenados na nuvem.
- RF03.1: operações de leitura e gravação assíncronas.
- RF05.4: recuperar os dados por meio de operações assíncronas.
- RT06: não utilizar dados fictícios definidos no código em substituição ao armazenamento remoto.

## Critérios de aceitação

- [ ] A leitura busca os registros diretamente do serviço de nuvem configurado nos cartões CARD-005, CARD-006 e CARD-007.
- [ ] A operação é assíncrona e não bloqueia a interface durante a espera.
- [ ] Os registros retornados são convertidos para o modelo do CARD-009 sem perda de campos.
- [ ] Não existe lista de objetos fictícios definida no código em lugar da leitura remota.
- [ ] Uma falha na leitura é sinalizada ao chamador, e não é silenciada.
- [ ] Uma leitura sem registros no serviço não gera erro.
- [ ] A leitura usa os parâmetros do ponto único de configuração (CARD-007), sem duplicá-los.
- [ ] A interface não acessa o serviço de nuvem diretamente.

## Dependências

- [CARD-006] Definir regras de acesso compatíveis com app sem autenticação.
- [CARD-007] Definir e disponibilizar parâmetros de configuração da nuvem.
- [CARD-009] Definir o modelo de dados do objeto.

## Observações técnicas

Usar os recursos assíncronos do Dart (`Future`, `async` e `await`). A ordenação por mais recentes é tratada no CARD-013 e a conversão de falhas em mensagens compreensíveis, no CARD-014. A forma como o resultado e as falhas chegam ao gerenciamento de estado (CARD-015) é decisão da implementação, desde que a interface possa distinguir sucesso e falha. O comportamento visual de uma lista vazia não é definido no PDF (ambiguidade A12).

## Definition of Done

- [ ] Implementação concluída.
- [ ] Critérios de aceitação atendidos.
- [ ] Leitura testada com registros reais da nuvem, incluindo cenário de falha de conexão.
- [ ] Código revisado por outro integrante e integrado ao ramo principal.