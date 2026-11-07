# Instruções para Agentes de IA — Reencontrapp

## 1. Objetivo

Este documento estabelece as regras que todos os agentes de Inteligência Artificial deverão seguir ao participar do desenvolvimento do Reencontrapp.

O objetivo é garantir que as implementações realizadas por agentes:

- Respeitem os requisitos acadêmicos.
- Sigam a arquitetura aprovada.
- Mantenham a consistência do código.
- Evitem complexidade desnecessária.
- Não introduzam funcionalidades não solicitadas.
- Preservem o trabalho dos demais integrantes.
- Sejam verificáveis e documentadas.

**Estas instruções são obrigatórias para qualquer agente de IA que realize alterações no projeto.**

## 2. Leitura obrigatória antes de implementar

Antes de realizar qualquer alteração relevante, o agente deverá consultar:

1. `README.md`: visão geral e índice da documentação.
2. `ARCHITECTURE.md`: arquitetura geral.
3. `FOLDER_STRUCTURE.md`: organização dos diretórios.
4. `DESIGN_PATTERNS.md`: padrões de projeto.
5. `STATE_MANAGEMENT.md`: gerenciamento de estado.
6. `DATA_LAYER.md`: camada de dados.
7. `DATABASE.md`: requisitos e decisões de persistência.
8. `CODING_STANDARDS.md`: padrões de código.

Também deverá:

- Consultar o Kanban para identificar o cartão relacionado à tarefa.
- Inspecionar os arquivos envolvidos.
- Verificar implementações existentes antes de criar novas.
- Identificar dependências e comportamentos que possam ser afetados.
- Verificar se existem alterações não commitadas no repositório.

Não começar a implementar com base apenas na descrição da tarefa quando houver documentação ou código relevante disponível.

## 3. Hierarquia de decisões

O agente deverá respeitar a seguinte ordem de prioridade:

1. Requisitos acadêmicos e restrições definidas pelo professor.
2. Decisões explicitamente aprovadas pela equipe.
3. Documentação arquitetural atualizada.
4. Estrutura e convenções existentes no projeto.
5. Solicitação específica da tarefa atual.

Uma solicitação não deverá ser interpretada como autorização automática para alterar decisões arquiteturais ou requisitos acadêmicos.

Se houver conflito entre essas fontes, o agente deverá identificar o problema e solicitar esclarecimento antes de realizar alterações que possam comprometer o projeto.

## 4. Decisões técnicas aprovadas

As seguintes decisões já foram aprovadas e não deverão ser substituídas sem autorização.

| Aspecto | Decisão |
|---|---|
| Linguagem | Dart |
| Framework | Flutter |
| Organização | Feature-First |
| Arquitetura | Clean Architecture simplificada |
| Princípios | SOLID e Separation of Concerns |
| Gerenciamento de estado | Riverpod |
| Navegação | Navigator 1.0 nativo |
| Interface | Material 3 |
| Padrões | Repository Pattern, Use Case Pattern e DTO/Model |
| Injeção de dependências | Riverpod |
| Testes automatizados | Não implementar |
| Validação | Manual |
| Formatação | `dart format .` |
| Análise estática | `flutter analyze` |

Não substituir essas tecnologias ou padrões por alternativas sem aprovação.

## 5. Decisões de infraestrutura aprovadas

As decisões anteriormente pendentes foram aprovadas pela equipe e estão registradas em `DATABASE.md` (CARD-002). O agente deverá respeitá-las e não substituí-las sem nova aprovação:

| Aspecto | Decisão aprovada |
|---|---|
| Serviço de nuvem | Firebase Firestore — plano Spark (gratuito) |
| Banco de dados | Cloud Firestore (modo Native), coleção `items` |
| SDK ou API de integração | FlutterFire (`firebase_core`, `cloud_firestore`) |
| Esquema físico de persistência | Conforme `DATABASE.md` |
| Regras definitivas de acesso remoto | `allow read, create: if true; allow update, delete: if false` |
| Estratégia definitiva de timestamp | `FieldValue.serverTimestamp()` em `created_at` |
| Credenciais e parâmetros de configuração | Ponto único em `lib/firebase_options.dart`; chaves públicas em `.env.example`, injetadas via `--dart-define-from-file=.env` |

### 5.1 Não presumir decisões não tomadas

Para decisões que continuam abertas (por exemplo, plataforma de avaliação e destino do registro de demonstração), o agente deverá:

- Não escolher novos fornecedores, bancos ou SDKs sem aprovação.
- Não criar configurações definitivas para uma decisão ainda não tomada.
- Não introduzir credenciais ou configurações fictícias como se fossem definitivas.
- Não considerar uma decisão técnica aprovada apenas porque apareceu em uma sugestão anterior.

Se uma tarefa depender de uma decisão não tomada, o agente deverá informar a dependência e solicitar aprovação.

## 6. Requisitos funcionais obrigatórios

O agente deverá preservar os requisitos funcionais do Reencontrapp.

### 6.1 Listagem

A aplicação deverá:

- Recuperar os registros armazenados na nuvem.
- Exibir nome, local, situação e descrição.
- Diferenciar objetos perdidos e encontrados.
- Ordenar os registros do mais recente para o mais antigo.
- Permitir atualização da listagem.

### 6.2 Cadastro

A aplicação deverá:

- Permitir informar nome, descrição e local.
- Permitir selecionar perdido ou encontrado.
- Exigir nome com no máximo 60 caracteres.
- Exigir descrição com no máximo 200 caracteres.
- Exigir local.
- Validar os dados antes do envio.
- Registrar timestamp automaticamente.
- Atualizar a listagem após o cadastro bem-sucedido.

### 6.3 Operações assíncronas

A aplicação deverá:

- Executar leitura e gravação de forma assíncrona.
- Apresentar indicadores de carregamento.
- Impedir envios repetidos.
- Apresentar mensagens compreensíveis em caso de falha.
- Permitir novas tentativas.

### 6.4 Persistência

A aplicação deverá:

- Utilizar um serviço de nuvem gratuito.
- Persistir os registros entre sessões.
- Compartilhar os registros entre diferentes instalações.
- Funcionar sem autenticação de usuário.
- Respeitar permissões remotas compatíveis com as operações permitidas.

## 7. Restrições de escopo

O agente deverá implementar exclusivamente funcionalidades aprovadas ou solicitadas.

Não implementar antecipadamente:

- Autenticação.
- Cadastro de usuários.
- Perfil de usuário.
- Edição de registros.
- Exclusão de registros.
- Upload de imagens.
- Notificações.
- Chat.
- Pesquisa avançada.
- Funcionalidades administrativas.
- Sistemas de permissões por usuário.

Não adicionar funcionalidades apenas para tornar a aplicação aparentemente mais completa.

**Uma implementação simples que atende corretamente aos requisitos é preferível a uma solução complexa com funcionalidades desnecessárias.**

## 8. Regras arquiteturais

O agente deverá respeitar a separação entre as quatro camadas.

### 8.1 Domain

Responsável por:

- Entidades.
- Enums.
- Contratos de repositórios.
- Conceitos fundamentais do negócio.

Não deverá depender de Flutter, Riverpod, SDKs de nuvem ou detalhes de persistência.

### 8.2 Application

Responsável por:

- Casos de uso.
- Coordenação das operações da aplicação.

Deverá depender dos contratos do Domain, nunca de implementações concretas da infraestrutura.

### 8.3 Data

Responsável por:

- Data Sources.
- Models.
- Implementações dos repositórios.
- Conversões entre dados externos e entidades.

Detalhes do fornecedor de nuvem deverão permanecer isolados nesta camada.

### 8.4 Presentation

Responsável por:

- Páginas.
- Widgets.
- Providers.
- Interações com o usuário.
- Apresentação dos estados.

Não deverá acessar diretamente o serviço de nuvem nem implementar regras de negócio.

## 9. Regras para gerenciamento de estado

O agente deverá utilizar Riverpod.

Diretrizes:

- Utilizar estado local para informações exclusivamente visuais.
- Utilizar providers para estados compartilhados e operações assíncronas.
- Utilizar `FutureProvider` ou abordagem equivalente aprovada para a listagem.
- Utilizar `AsyncNotifier` ou abordagem equivalente aprovada para o cadastro.
- Separar o estado de carregamento da listagem do estado de envio.
- Atualizar a listagem após um cadastro bem-sucedido.
- Impedir envios simultâneos.
- Tratar loading, error e data explicitamente.

Não introduzir Provider, Bloc, GetX, MobX ou outra solução de gerenciamento de estado.

Consultar `STATE_MANAGEMENT.md` antes de modificar o gerenciamento de estado.

## 10. Regras para implementação da camada de dados

O agente deverá respeitar os contratos definidos no Domain.

Diretrizes:

- Utilizar Repository Pattern.
- Isolar o acesso remoto em Data Sources.
- Utilizar Models para conversão de dados externos.
- Não expor SDKs externos para as camadas superiores.
- Não retornar dados fictícios para simular sucesso.
- Não converter falhas de comunicação em listas vazias.
- Não informar sucesso antes da confirmação da operação remota.

O formato físico dos dados deverá respeitar `DATABASE.md` e as decisões aprovadas para o fornecedor escolhido.

## 11. Segurança e configuração

O agente deverá tratar configurações e credenciais com cuidado.

Regras:

1. Nunca incluir senhas ou chaves privadas no código-fonte.
2. Nunca versionar credenciais administrativas.
3. Não presumir que toda chave identificada como pública seja segura em qualquer contexto.
4. Utilizar somente os parâmetros necessários à aplicação.
5. Restringir operações remotas ao mínimo necessário.
6. Não habilitar permissões irrestritas para facilitar a implementação.
7. Não adicionar autenticação de usuário, pois ela não faz parte dos requisitos.
8. Documentar as configurações necessárias para execução e avaliação.

A aplicação deverá permitir leitura e cadastro sem autenticação, mas isso não autoriza acesso irrestrito a operações de edição, exclusão ou administração.

## 12. Processo obrigatório de execução das tarefas

O agente deverá seguir as etapas abaixo.

### Etapa 1 — Análise

Antes de editar:

- Entender o objetivo da tarefa.
- Identificar os requisitos relacionados.
- Consultar o cartão correspondente no Kanban.
- Ler a documentação relevante.
- Inspecionar os arquivos existentes.
- Identificar dependências e possíveis impactos.
- Verificar alterações locais não commitadas.

Não presumir que um arquivo está vazio ou que uma funcionalidade não existe sem verificar.

### Etapa 2 — Planejamento

Definir:

- Quais arquivos precisam ser criados.
- Quais arquivos precisam ser modificados.
- Quais responsabilidades serão afetadas.
- Como a implementação respeitará a arquitetura.
- Como será realizada a validação manual.

O planejamento deverá permanecer restrito ao objetivo solicitado.

Não propor refatorações amplas quando uma alteração localizada for suficiente.

### Etapa 3 — Implementação

Durante a implementação:

- Seguir a estrutura de pastas aprovada.
- Respeitar as responsabilidades das camadas.
- Utilizar nomes expressivos em inglês.
- Manter textos da interface em português.
- Reutilizar componentes existentes quando apropriado.
- Evitar duplicação.
- Evitar abstrações desnecessárias.
- Não adicionar dependências sem justificativa.
- Não modificar arquivos fora do escopo sem necessidade.

### Etapa 4 — Validação

Após implementar:

Executar:

```bash
dart format .
flutter analyze
```

Verificar também:

- Se a funcionalidade atende aos requisitos.
- Se os fluxos de sucesso e falha estão contemplados.
- Se a interface apresenta os estados corretamente.
- Se não foram introduzidas regressões evidentes.
- Se a implementação funciona com a configuração real do serviço de nuvem.

A validação funcional deverá ser manual.

**Não criar testes automatizados**, conforme decisão aprovada pela equipe.

Se não for possível executar alguma verificação, informar claramente a limitação.

### Etapa 5 — Documentação

Se a implementação alterar decisões ou estruturas documentadas:

- Atualizar os documentos correspondentes.
- Registrar novas decisões aprovadas.
- Atualizar instruções de configuração.
- Atualizar o README quando necessário.

Não alterar documentação arquitetural apenas para justificar uma implementação que contraria as decisões aprovadas.

### Etapa 6 — Relatório final

Ao concluir, apresentar:

1. Resumo do que foi implementado.
2. Arquivos criados.
3. Arquivos modificados.
4. Decisões técnicas relevantes.
5. Comandos executados.
6. Resultados de `dart format .` e `flutter analyze`.
7. Validações manuais realizadas.
8. Pendências ou limitações.
9. Cartão ou cartões do Kanban relacionados e seus respectivos estados.

Não afirmar que algo foi validado quando não foi.

## 13. Gerenciamento de Git

O agente deverá preservar o histórico e o trabalho da equipe.

Regras:

- Não executar `git reset --hard` sem autorização explícita.
- Não executar `git clean -fd` sem autorização explícita.
- Não utilizar `git push --force` sem autorização explícita.
- Não descartar alterações locais de outros integrantes.
- Não sobrescrever arquivos sem inspecionar seu conteúdo atual.
- Não realizar merges ou rebase sem que façam parte da tarefa autorizada.
- Não criar commits automaticamente, a menos que isso tenha sido solicitado.
- Verificar a branch atual antes de alterações relevantes.

Caso existam alterações não commitadas, identificar seu conteúdo e preservar o trabalho existente.

## 14. Dependências e ferramentas

Antes de adicionar uma dependência:

1. Verificar se a funcionalidade já existe no Flutter ou Dart.
2. Verificar se alguma dependência aprovada já resolve o problema.
3. Avaliar o impacto arquitetural.
4. Verificar compatibilidade com as versões instaladas.
5. Justificar a necessidade.

Não adicionar bibliotecas por preferência pessoal.

Não executar atualizações gerais de dependências sem necessidade.

Não introduzir code generation ou ferramentas adicionais sem aprovação quando isso alterar significativamente a estrutura do projeto.

## 15. Testes automatizados

A equipe decidiu explicitamente não implementar testes automatizados neste projeto.

Portanto, é proibido criar:

- Testes unitários.
- Testes de widgets.
- Testes de integração.
- Mocks para testes automatizados.
- Dependências exclusivamente destinadas a testes.
- Estruturas adicionais para execução de testes automatizados.

A validação deverá ser realizada manualmente, seguindo os requisitos funcionais e o checklist de `CODING_STANDARDS.md`.

Não interpretar a ausência de testes automatizados como autorização para deixar de validar o comportamento da aplicação.

## 16. Tratamento de dúvidas e conflitos

Quando encontrar uma situação não definida pela documentação, o agente deverá avaliar se consegue prosseguir sem assumir uma decisão importante.

Se a dúvida afetar:

- Arquitetura.
- Fornecedor de nuvem.
- Banco de dados.
- Segurança.
- Persistência.
- Dependências estruturais.
- Requisitos acadêmicos.

O agente deverá interromper a parte afetada da implementação e solicitar esclarecimento.

Não tomar decisões silenciosas que possam comprometer o trabalho da equipe.

Para detalhes de implementação de baixo impacto, poderá adotar a solução mais simples e consistente com os padrões existentes, informando a decisão no relatório final.

## 17. Princípio fundamental

O agente deverá priorizar, nesta ordem:

1. Correção funcional.
2. Atendimento aos requisitos acadêmicos.
3. Respeito à arquitetura aprovada.
4. Segurança e integridade dos dados.
5. Clareza e manutenção do código.
6. Simplicidade da implementação.

Não confundir qualidade com quantidade de código, abstrações ou funcionalidades.

O Reencontrapp deverá permanecer uma aplicação simples, funcional, organizada e tecnicamente correta.

**Implemente somente o necessário, respeite as decisões aprovadas e não transforme tarefas pequenas em refatorações abrangentes.**

## 18. Documentação de referência

Antes de executar qualquer tarefa, consulte os documentos relevantes em `docs/architecture/`:

| Documento | Finalidade |
|---|---|
| `README.md` | Índice da documentação |
| `ARCHITECTURE.md` | Arquitetura geral |
| `FOLDER_STRUCTURE.md` | Organização dos diretórios |
| `DESIGN_PATTERNS.md` | Padrões de projeto |
| `STATE_MANAGEMENT.md` | Gerenciamento de estado |
| `DATA_LAYER.md` | Camada de dados |
| `DATABASE.md` | Persistência e banco de dados |
| `CODING_STANDARDS.md` | Padrões de desenvolvimento |
| `AI_AGENTS.md` | Regras para agentes de IA |

Este documento é a referência obrigatória para a atuação de agentes de IA no desenvolvimento do Reencontrapp. Qualquer alteração relevante em suas diretrizes deverá ser aprovada pela equipe e documentada.