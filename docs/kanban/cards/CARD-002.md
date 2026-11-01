# CARD-002 Escolher serviço de armazenamento em nuvem gratuito

**Tipo:** Task  
**Prioridade:** Alta  
**Complexidade:** Média  
**Status inicial:** Backlog

## Descrição

Escolher o serviço de armazenamento em nuvem que guardará os registros de objetos perdidos e encontrados. O documento do professor deixa a escolha livre, mas exige que o serviço seja gratuito e que a aplicação possa ser executada e avaliada sem custos.

A escolha precisa ser feita no início do projeto, pois bloqueia toda a cadeia de integração (CARD-005, CARD-006, CARD-007, CARD-010 e CARD-011).

## Requisitos relacionados

- RF05.1: utilizar exclusivamente serviços com plano gratuito.
- RF05.2: persistir os dados após o encerramento da aplicação.
- RF05.3: compartilhar os registros entre diferentes instalações do aplicativo.
- RF05.4: recuperar os dados por meio de operações assíncronas.
- RT02: armazenamento em nuvem exclusivamente com serviços gratuitos.
- RT07: a equipe escolhe livremente o serviço, desde que seja possível executar e avaliar a aplicação sem custos.
- RB06: o serviço deve ter regras de acesso compatíveis com um aplicativo sem autenticação.

## Critérios de aceitação

- [ ] O serviço escolhido possui plano gratuito que cobre o uso previsto (leitura e gravação de registros de texto) sem cobrança.
- [ ] Os limites e condições do plano gratuito (cotas, exigência de cartão, prazo de validade) foram conferidos na documentação oficial e registrados.
- [ ] O serviço permite armazenar dados de forma persistente e compartilhada entre instalações diferentes.
- [ ] O serviço pode ser acessado a partir de Flutter/Dart por operações assíncronas.
- [ ] O serviço permite definir regras de acesso adequadas a um aplicativo sem autenticação.
- [ ] A escolha está registrada com a justificativa e foi comunicada a toda a equipe.

## Dependências

Nenhuma.

## Observações técnicas

O PDF não indica nenhum serviço específico. Os planos gratuitos mudam com frequência, por isso a verificação deve usar a documentação oficial atual, e não a memória da equipe. Verificar também se o serviço oferece biblioteca para Dart ou API acessível por requisições HTTP, sem presumir qual abordagem será usada na implementação. Este cartão não define arquitetura nem estrutura de código.

Ambiguidade relacionada: A8 (dados de demonstração no serviço remoto), registrada em `planejamento.md`.

## Definition of Done

- [ ] Atividade concluída e decisão registrada.
- [ ] Critérios de aceitação atendidos.
- [ ] Decisão validada por toda a equipe.