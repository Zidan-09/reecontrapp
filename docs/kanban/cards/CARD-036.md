# CARD-036 Validar manualmente os fluxos de listagem, cadastro e erro

**Tipo:** Test  
**Prioridade:** Alta  
**Complexidade:** Média  
**Status inicial:** Backlog

## Descrição

Executar um roteiro de verificação manual sobre o aplicativo completo, cobrindo as funcionalidades exigidas de listagem, cadastro, validação, assincronismo e tratamento de falhas, e registrar o resultado de cada item.

O documento não exige testes automatizados (ambiguidade A11). Este cartão é uma verificação manual ligada aos requisitos explícitos, e não cria exigência nova.

## Requisitos relacionados

- RF01.1: carregar os registros armazenados na nuvem.
- RF01.2: exibir nome, local, situação e descrição de cada objeto.
- RF01.3: identificar visualmente objetos perdidos e encontrados.
- RF01.4: apresentar os registros mais recentes primeiro.
- RF01.5: permitir atualizar a listagem.
- RF02.2: nome do objeto obrigatório, até 60 caracteres.
- RF02.3: descrição obrigatória, até 200 caracteres.
- RF02.4: local obrigatório.
- RF02.6: validar todos os campos antes do envio.
- RF02.8: exibir o novo registro na listagem após o cadastro.
- RF03.2: exibir indicador de carregamento durante as operações.
- RF03.3: impedir envios repetidos durante a gravação.
- RF03.4: tratar falhas de comunicação, apresentando mensagens compreensíveis.
- RF03.5: permitir tentar novamente uma operação que tenha falhado.
- RNF01.5: informar adequadamente operações em andamento e falhas.
- RB05: somente dados demonstrativos, sem informações pessoais ou sensíveis.
- ENT03: o projeto deve estar funcional e disponível para avaliação.

## Critérios de aceitação

- [ ] Existe um roteiro escrito com cada cenário, o resultado esperado e o resultado obtido.
- [ ] Listagem: os registros carregam da nuvem e exibem nome, local, situação e descrição.
- [ ] Listagem: perdidos e encontrados são distinguíveis, e a ordem é do mais recente para o mais antigo.
- [ ] Atualização: um registro criado fora da instalação testada aparece após a atualização.
- [ ] Validação: campos vazios e limites de 60 e 200 caracteres (0, 60, 61, 200 e 201) foram testados.
- [ ] Cadastro: um registro válido é salvo e aparece no topo da listagem.
- [ ] Assincronismo: indicadores aparecem na leitura, na atualização e na gravação.
- [ ] Reenvio: toques repetidos geram um único registro.
- [ ] Falhas: a leitura e a gravação foram testadas sem conexão, com mensagem em português e nova tentativa funcionando.
- [ ] Os dados usados no teste são demonstrativos, sem informações pessoais ou sensíveis.
- [ ] Todo defeito encontrado foi registrado como cartão do tipo Bug, e os corrigidos foram verificados de novo.

## Dependências

- [CARD-021] Exibir carregamento e falhas na listagem com nova tentativa.
- [CARD-022] Implementar a atualização manual da listagem.
- [CARD-027] Tratar falha de gravação com mensagem e nova tentativa.
- [CARD-028] Exibir o novo registro na listagem após o cadastro.
- [CARD-029] Garantir adaptação a diferentes telas e ausência de overflow.

## Observações técnicas

Executar o roteiro com a nuvem real, e não com dados simulados. Se a equipe optar por criar registros de demonstração no serviço, registrar a decisão (ambiguidade A8). Para provocar falhas de comunicação, desativar a conexão do dispositivo ou emulador. Qualquer correção de código resultante exige repetir `flutter analyze` e `dart format .` (CARD-031 e CARD-032).

## Definition of Done

- [ ] Verificação concluída e roteiro preenchido.
- [ ] Critérios de aceitação atendidos.
- [ ] Defeitos encontrados registrados e tratados.
- [ ] Resultado revisado por pelo menos um integrante que não executou o roteiro.