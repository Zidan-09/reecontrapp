# AGENTS.md

# Instruções para Agentes de IA

Este arquivo define as instruções obrigatórias para qualquer agente de IA que trabalhe neste repositório.

O projeto deve ser desenvolvido seguindo rigorosamente os requisitos acadêmicos, as decisões arquiteturais aprovadas e os padrões documentados. Antes de realizar qualquer alteração, o agente deve compreender essas orientações.

## 1. Fonte de verdade

A documentação em `docs/architecture/` é a referência oficial para as decisões técnicas e arquiteturais do projeto.

**Antes de planejar, implementar, refatorar ou modificar qualquer parte do código, leia os documentos relevantes.**

Leia obrigatoriamente:

| Documento | Finalidade |
|---|---|
| [`docs/architecture/README.md`](docs/architecture/README.md) | Índice da documentação e visão geral das decisões. |
| [`docs/architecture/ARCHITECTURE.md`](docs/architecture/ARCHITECTURE.md) | Arquitetura geral, camadas, responsabilidades e fluxo da aplicação. |
| [`docs/architecture/FOLDER_STRUCTURE.md`](docs/architecture/FOLDER_STRUCTURE.md) | Organização dos diretórios e arquivos do projeto. |
| [`docs/architecture/DATA_LAYER.md`](docs/architecture/DATA_LAYER.md) | Contratos, fontes de dados, Models e implementação dos repositórios. |
| [`docs/architecture/DESIGN_PATTERNS.md`](docs/architecture/DESIGN_PATTERNS.md) | Padrões de projeto, SOLID e separação de responsabilidades. |
| [`docs/architecture/STATE_MANAGEMENT.md`](docs/architecture/STATE_MANAGEMENT.md) | Gerenciamento de estado com Riverpod. |
| [`docs/architecture/CODING_STANDARDS.md`](docs/architecture/CODING_STANDARDS.md) | Convenções de código, formatação e qualidade. |
| [`docs/architecture/AI_AGENTS.md`](docs/architecture/AI_AGENTS.md) | Procedimentos e restrições específicas para agentes de IA. |

Não presuma que conhece o conteúdo desses documentos. Consulte os arquivos reais do repositório, inclusive quando já tiver trabalhado anteriormente no projeto.

## 2. Hierarquia de requisitos e decisões

Ao trabalhar no projeto, respeite a seguinte ordem de prioridade:

1. Requisitos e restrições do trabalho acadêmico fornecidos pelo professor.
2. Decisões arquiteturais aprovadas e registradas em `docs/architecture/`.
3. Instruções deste arquivo.
4. Código e convenções já estabelecidos no projeto, desde que não contrariem os itens anteriores.

Caso encontre contradições entre essas fontes:

- Não escolha silenciosamente uma interpretação.
- Identifique os documentos ou requisitos conflitantes.
- Explique o impacto técnico.
- Solicite esclarecimento antes de tomar uma decisão que altere requisitos ou decisões aprovadas.

## 3. Contexto do projeto

O projeto é um aplicativo de achados e perdidos desenvolvido com Flutter e Dart.

Seu objetivo é permitir que membros da comunidade acadêmica cadastrem objetos perdidos ou encontrados e consultem os registros compartilhados na nuvem.

O escopo deve permanecer limitado aos requisitos estabelecidos para o trabalho acadêmico.

Não implemente funcionalidades adicionais por iniciativa própria.

## 4. Decisões técnicas obrigatórias

As seguintes decisões já foram aprovadas e devem ser respeitadas:

- **Framework:** Flutter.
- **Linguagem:** Dart.
- **Organização:** Feature-First.
- **Arquitetura:** Clean Architecture simplificada.
- **Princípios:** SOLID, Separation of Concerns e Dependency Inversion.
- **Gerenciamento de estado:** Riverpod.
- **Navegação:** Navigator 1.0 nativo.
- **Interface:** Material 3.
- **Padrões:** Repository Pattern, Use Case Pattern e DTO/Model.
- **Injeção de dependências:** Riverpod.
- **Testes automatizados:** não serão implementados.
- **Validação:** manual.
- **Qualidade:** `dart format .` e `flutter analyze`.

Consulte os documentos de arquitetura para conhecer a aplicação prática dessas decisões.

### 4.1. Decisões ainda pendentes

Não tome decisões definitivas sobre os seguintes pontos sem aprovação:

- Provedor de armazenamento em nuvem.
- Banco de dados e esquema físico.
- SDK ou API de integração remota.
- Regras de acesso e configuração de segurança.
- Estratégia definitiva para geração do timestamp.
- Credenciais, identificadores e parâmetros necessários à configuração do serviço.

Não presuma que o projeto utilizará Firebase, Supabase, Appwrite ou qualquer outro fornecedor.

Quando uma tarefa depender de uma dessas definições, identifique a dependência e solicite aprovação antes de implementar uma solução que a comprometa.

## 5. Fluxo obrigatório de trabalho

Antes de executar uma tarefa:

1. Leia este arquivo e os documentos de arquitetura relevantes.
2. Consulte os requisitos acadêmicos relacionados à tarefa.
3. Inspecione a estrutura atual do projeto e os arquivos envolvidos.
4. Verifique o estado do Git e as alterações já existentes.
5. Consulte o Kanban ou a descrição da tarefa, quando disponível.
6. Identifique as responsabilidades das camadas envolvidas.
7. Elabore um plano compatível com o escopo solicitado.
8. Implemente somente o necessário.

Durante a implementação:

- Preserve a arquitetura estabelecida.
- Respeite a direção das dependências.
- Mantenha a separação entre Presentation, Application, Domain e Data.
- Evite duplicação de código.
- Prefira soluções simples e proporcionais à complexidade do projeto.
- Não introduza dependências sem justificativa.
- Não altere funcionalidades não relacionadas à tarefa.
- Não crie abstrações ou camadas desnecessárias.

Ao finalizar:

1. Execute `dart format .`.
2. Execute `flutter analyze`.
3. Corrija os problemas introduzidos pela implementação.
4. Informe os comandos executados e seus resultados reais.
5. Relate eventuais pendências e limitações.
6. Atualize a documentação quando uma decisão aprovada ou comportamento documentado tiver sido alterado.

## 6. Restrições obrigatórias

### 6.1. Escopo funcional

Não implemente funcionalidades fora do escopo aprovado, incluindo:

- Autenticação de usuários.
- Edição de registros.
- Exclusão de registros.
- Upload de imagens.
- Notificações.
- Pesquisa avançada.
- Funcionalidades adicionais não solicitadas.

Não substitua a integração com a nuvem por dados fictícios fixos ou armazenamento exclusivamente local.

### 6.2. Testes

Não implemente testes automatizados.

Isso inclui:

- Testes unitários.
- Testes de widgets.
- Testes de integração.
- Mocks e infraestrutura criada exclusivamente para testes.
- Dependências de teste adicionadas sem autorização.

A validação deve ser realizada manualmente, conforme os documentos de arquitetura e os requisitos do trabalho.

Não afirme que testes foram executados se isso não aconteceu.

### 6.3. Segurança e configuração

- Nunca exponha credenciais privadas ou segredos no repositório.
- Não versione arquivos de configuração que contenham segredos.
- Respeite o princípio do menor privilégio nas permissões de acesso à nuvem.
- Considere que o aplicativo não possui autenticação de usuários.
- Preserve as instruções necessárias para que o professor consiga configurar e avaliar a aplicação.
- Não confunda identificadores e chaves públicas de configuração com credenciais privadas.

### 6.4. Git

- Não execute operações destrutivas sem autorização explícita.
- Não descarte alterações preexistentes.
- Não sobrescreva trabalho de outros colaboradores.
- Não faça `reset --hard`, `push --force` ou operações equivalentes sem autorização.
- Não realize commits ou merges fora do fluxo solicitado.

### 6.5. Artefatos

Não adicione ao repositório:

- Diretórios de build.
- Binários de compilação.
- APK, AAB ou IPA.
- Executáveis gerados.
- Credenciais privadas.
- Arquivos temporários desnecessários.

## 7. Documentação

A documentação de `docs/architecture/` deve permanecer consistente com a implementação e com as decisões aprovadas.

Quando uma tarefa alterar uma decisão arquitetural:

1. Identifique os documentos afetados.
2. Não altere uma decisão aprovada sem autorização.
3. Solicite aprovação quando a mudança exigir uma nova decisão.
4. Após aprovação, atualize os documentos correspondentes.
5. Preserve a consistência entre os documentos.

Não duplique neste arquivo explicações extensas que já estejam documentadas em `docs/architecture/`. Utilize os links da seção 1 como referência.

## 8. Relatório de conclusão

Ao concluir uma tarefa, apresente um relatório objetivo contendo:

- **Resumo:** o que foi implementado.
- **Arquivos:** quais arquivos foram criados, modificados ou removidos.
- **Decisões:** decisões técnicas tomadas ou pendentes.
- **Validação:** comandos executados e resultados reais.
- **Validação manual:** cenários verificados, quando aplicável.
- **Pendências:** problemas que ainda precisam de atenção.
- **Documentação:** documentos atualizados, quando aplicável.

Não declare uma tarefa como concluída se houver requisitos não atendidos ou problemas conhecidos que impeçam seu funcionamento.

---

## Regra final

**A simplicidade, a conformidade com os requisitos acadêmicos e a consistência arquitetural têm prioridade sobre a quantidade de funcionalidades ou a sofisticação da implementação.**

Não invente requisitos, não tome decisões arquiteturais pendentes por conta própria e não faça alterações além do escopo autorizado.

Em caso de dúvida relevante, consulte a documentação e peça esclarecimento antes de prosseguir.