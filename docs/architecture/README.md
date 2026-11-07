# Documentação Arquitetural — Reencontrapp

## 1. Sobre esta documentação

Este diretório reúne a documentação técnica e arquitetural do Reencontrapp, uma aplicação Flutter desenvolvida para facilitar o registro e a recuperação de objetos perdidos e encontrados na comunidade acadêmica.

O objetivo desta documentação é estabelecer uma referência comum para todos os integrantes da equipe e agentes de Inteligência Artificial envolvidos no desenvolvimento.

Os documentos definem:

- Arquitetura da aplicação.
- Organização dos diretórios.
- Padrões de projeto.
- Gerenciamento de estado.
- Organização da camada de dados.
- Requisitos de persistência.
- Convenções de desenvolvimento.
- Regras para utilização de agentes de IA.

**Esta documentação deverá ser consultada antes de implementar alterações relevantes no projeto.**

## 2. Índice de documentos

| Documento | Descrição |
|---|---|
| [ARCHITECTURE.md](./ARCHITECTURE.md) | Apresenta a arquitetura geral, as camadas e o fluxo de comunicação da aplicação. |
| [FOLDER_STRUCTURE.md](./FOLDER_STRUCTURE.md) | Define a organização dos diretórios e arquivos do projeto. |
| [DESIGN_PATTERNS.md](./DESIGN_PATTERNS.md) | Documenta os padrões de projeto adotados e suas responsabilidades. |
| [STATE_MANAGEMENT.md](./STATE_MANAGEMENT.md) | Define a utilização do Riverpod e o gerenciamento dos estados da aplicação. |
| [DATA_LAYER.md](./DATA_LAYER.md) | Descreve a organização da camada de dados, repositórios, Models e Data Sources. |
| [DATABASE.md](./DATABASE.md) | Define os requisitos de persistência, modelo lógico e critérios para escolha do serviço de nuvem. |
| [CODING_STANDARDS.md](./CODING_STANDARDS.md) | Estabelece convenções de nomenclatura, formatação, qualidade e manutenção do código. |
| [AI_AGENTS.md](./AI_AGENTS.md) | Define as instruções obrigatórias para agentes de IA que participarem do desenvolvimento. |

## 3. Decisões arquiteturais aprovadas

As seguintes decisões foram discutidas e aprovadas pela equipe.

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
| Padrões de projeto | Repository Pattern, Use Case Pattern e DTO/Model |
| Injeção de dependências | Riverpod |
| Testes automatizados | Não serão implementados |
| Validação | Manual |
| Formatação | `dart format .` |
| Análise estática | `flutter analyze` |

Essas decisões deverão ser respeitadas durante o desenvolvimento.

Alterações somente poderão ocorrer mediante aprovação da equipe.

## 4. Decisões técnicas aprovadas de infraestrutura

As decisões antes pendentes foram aprovadas pela equipe e estão registradas em [`DATABASE.md`](./DATABASE.md) (CARD-002):

| Aspecto | Decisão |
|---|---|
| Serviço de nuvem | Firebase Firestore — plano Spark (gratuito) |
| Banco de dados | Cloud Firestore (modo Native), coleção `items` |
| SDK ou API de integração | FlutterFire (`firebase_core`, `cloud_firestore`) |
| Esquema físico de persistência | Documentos conforme `DATABASE.md` |
| Regras definitivas de acesso remoto | `allow read, create: if true; allow update, delete: if false` |
| Estratégia definitiva de timestamp | `FieldValue.serverTimestamp()` em `created_at` |
| Credenciais e parâmetros de configuração | Ponto único em `lib/firebase_options.dart`; identificadores públicos em `.env.example` versionado, sem chave hardcoded no Dart |

### 4.1 Restrições

- Não alterar essas decisões sem nova aprovação da equipe.
- Não escolher fornecedores, bancos ou SDKs adicionais sem aprovação.
- Não versionar credenciais privadas (service accounts, chaves administrativas).
- Não incluir credenciais fictícias como se fossem definitivas.

## 5. Princípios de desenvolvimento

O desenvolvimento deverá seguir os seguintes princípios:

### Simplicidade

Implementar somente o necessário para atender aos requisitos.

Evitar abstrações, bibliotecas e funcionalidades que não tragam benefícios concretos.

### Separação de responsabilidades

Cada camada deverá possuir responsabilidades bem definidas.

A interface não deverá conhecer detalhes de persistência, e o domínio não deverá depender de tecnologias externas.

### Baixo acoplamento

As funcionalidades deverão depender de contratos e abstrações apropriadas, evitando dependências desnecessárias entre componentes.

### Consistência

Novas implementações deverão seguir os padrões estabelecidos nesta documentação.

### Segurança

A ausência de autenticação não significa ausência de controle de acesso. As permissões do serviço remoto deverão ser limitadas às operações necessárias.

### Fidelidade aos requisitos

Os requisitos acadêmicos e as decisões aprovadas deverão prevalecer sobre funcionalidades adicionais sugeridas durante o desenvolvimento.

## 6. Requisitos funcionais contemplados

A arquitetura foi planejada para atender às seguintes funcionalidades:

- Listagem de objetos perdidos e encontrados.
- Recuperação de registros armazenados na nuvem.
- Identificação da situação de cada objeto.
- Ordenação dos registros do mais recente para o mais antigo.
- Atualização manual da listagem.
- Cadastro de novos registros.
- Validação dos campos obrigatórios.
- Registro automático da data de criação.
- Atualização da listagem após cadastro.
- Tratamento de operações assíncronas.
- Apresentação de estados de carregamento, sucesso e erro.
- Persistência e compartilhamento dos dados entre instalações.

Não fazem parte do escopo atual funcionalidades como autenticação, edição, exclusão, upload de imagens, notificações e pesquisa avançada.

## 7. Orientações para agentes de IA

Agentes de IA deverão consultar esta documentação antes de realizar alterações arquiteturais ou implementar funcionalidades relevantes.

A leitura de `AI_AGENTS.md` é obrigatória.

Além disso, deverão:

1. Inspecionar o código existente antes de editar.
2. Consultar o Kanban para identificar a tarefa correspondente.
3. Respeitar as decisões aprovadas.
4. Não presumir decisões pendentes.
5. Evitar refatorações fora do escopo.
6. Não introduzir funcionalidades não solicitadas.
7. Não implementar testes automatizados.
8. Executar `dart format .` e `flutter analyze` após alterações relevantes.
9. Informar claramente as validações realizadas e as pendências encontradas.

## 8. Atualização da documentação

Esta documentação deverá acompanhar a evolução real do projeto.

Sempre que uma decisão técnica relevante for aprovada:

1. Identificar os documentos afetados.
2. Atualizar as informações correspondentes.
3. Remover ou corrigir informações que tenham se tornado obsoletas.
4. Manter a consistência entre os documentos.
5. Registrar as decisões de maneira clara.

Não manter decisões antigas e novas simultaneamente quando forem incompatíveis.

Os documentos deverão representar o estado atual e aprovado da arquitetura, e não possibilidades de implementação ainda não decididas.

## 9. Relação com os requisitos acadêmicos

A documentação arquitetural complementa os requisitos definidos para o trabalho acadêmico, mas não os substitui.

Em caso de conflito, os requisitos obrigatórios do professor e as decisões formalmente aprovadas pela equipe deverão prevalecer.

A implementação deverá permanecer compatível com os critérios de avaliação, especialmente:

- Cadastro e validação.
- Listagem de registros.
- Integração com serviço de nuvem.
- Operações assíncronas e gerenciamento de estado.
- Qualidade da interface.
- Organização e qualidade do código.
- Documentação e possibilidade de avaliação.

## 10. Diretriz final

Esta documentação representa a referência arquitetural oficial do Reencontrapp.

Todos os integrantes e agentes de IA deverão utilizá-la como base para suas decisões e implementações.

**O objetivo não é construir a arquitetura mais complexa possível, mas desenvolver uma aplicação simples, organizada, funcional, segura e plenamente compatível com os requisitos do trabalho.**