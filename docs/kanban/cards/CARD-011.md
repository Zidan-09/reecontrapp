# CARD-011 Implementar gravação assíncrona de registro na nuvem

**Tipo:** Feature  
**Prioridade:** Alta  
**Complexidade:** Média  
**Status inicial:** Backlog

## Descrição

Implementar, na camada de acesso a dados, a operação que grava na nuvem um novo registro de objeto perdido ou encontrado, a partir do modelo definido no CARD-009.

A operação deve ser assíncrona e informar ao chamador se a gravação foi concluída ou falhou. O registro gravado deve persistir após o encerramento do aplicativo e ficar disponível para outras instalações.

## Requisitos relacionados

- RF03.1: operações de leitura e gravação assíncronas.
- RF05.2: persistir os dados após o encerramento da aplicação.
- RF05.3: compartilhar os registros entre diferentes instalações do aplicativo.
- RT06: não utilizar dados fictícios definidos no código em substituição ao armazenamento remoto.
- RB04: não há autenticação, edição nem exclusão de registros.

## Critérios de aceitação

- [ ] A gravação envia o registro diretamente ao serviço de nuvem configurado nos cartões CARD-005, CARD-006 e CARD-007.
- [ ] A operação é assíncrona e não bloqueia a interface durante a espera.
- [ ] A conclusão com sucesso e a falha são sinalizadas ao chamador de forma distinguível.
- [ ] Nome, descrição, local e situação são gravados e recuperados pela leitura (CARD-010) sem perda de campos.
- [ ] Um registro gravado continua disponível após encerrar e reabrir o aplicativo.
- [ ] Uma falha na gravação não deixa registros incompletos visíveis na leitura.
- [ ] Não há operação de edição nem de exclusão implementada.
- [ ] A gravação usa os parâmetros do ponto único de configuração (CARD-007), sem duplicá-los.
- [ ] A interface não acessa o serviço de nuvem diretamente.

## Dependências

- [CARD-006] Definir regras de acesso compatíveis com app sem autenticação.
- [CARD-007] Definir e disponibilizar parâmetros de configuração da nuvem.
- [CARD-009] Definir o modelo de dados do objeto.

## Observações técnicas

Usar `Future`, `async` e `await`. O registro de data e hora é tratado no CARD-012, a conversão de falhas em mensagens compreensíveis no CARD-014 e o bloqueio de envios repetidos no CARD-016 e no CARD-026. Este cartão fornece a operação de gravação, e esses cartões tratam do comportamento ao redor dela. A validação dos campos ocorre antes do envio (CARD-025), mas a camada de dados não deve presumir que a validação aconteceu.

## Definition of Done

- [ ] Implementação concluída.
- [ ] Critérios de aceitação atendidos.
- [ ] Gravação testada com a nuvem real, incluindo cenário de falha de conexão.
- [ ] Código revisado por outro integrante e integrado ao ramo principal.