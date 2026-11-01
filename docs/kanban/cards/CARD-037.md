# CARD-037 Validar persistência e compartilhamento entre instalações

**Tipo:** Test  
**Prioridade:** Alta  
**Complexidade:** Média  
**Status inicial:** Backlog

## Descrição

Verificar que os registros são realmente armazenados na nuvem: persistem após o encerramento do aplicativo e são compartilhados entre instalações diferentes. Esta é a prova prática do critério de integração com o armazenamento em nuvem.

## Requisitos relacionados

- RF05.2: persistir os dados após o encerramento da aplicação.
- RF05.3: compartilhar os registros entre diferentes instalações do aplicativo.
- RF05.4: recuperar os dados por meio de operações assíncronas.
- RT06: não utilizar dados fictícios definidos no código em substituição ao armazenamento remoto.

## Critérios de aceitação

- [ ] Um registro cadastrado em uma instalação permanece visível após encerrar completamente e reabrir o aplicativo.
- [ ] O mesmo registro aparece em uma segunda instalação distinta (outro dispositivo, outro emulador ou instalação limpa) após carregar ou atualizar a listagem.
- [ ] O registro cadastrado também é visível no console do serviço de nuvem.
- [ ] Uma instalação nova, sem nenhum uso anterior, exibe os registros existentes na nuvem.
- [ ] Registros criados diretamente no serviço (se houver) aparecem no aplicativo, e o aplicativo não depende de dados fixos no código.
- [ ] A verificação foi feita com mais de uma pessoa ou conta de acesso ao ambiente, quando possível.
- [ ] Os resultados estão registrados.

## Dependências

- [CARD-028] Exibir o novo registro na listagem após o cadastro.

## Observações técnicas

Usar instalações realmente separadas e não apenas duas execuções na mesma máquina com o mesmo armazenamento local. Se o serviço oferecer cache local, garantir que o resultado observado venha da nuvem. A decisão sobre manter ou apagar os registros de teste antes da entrega deve ser registrada (ambiguidade A8), lembrando que o avaliador verá o conteúdo do serviço.

## Definition of Done

- [ ] Verificação concluída e resultados registrados.
- [ ] Critérios de aceitação atendidos.
- [ ] Defeitos encontrados registrados e tratados.