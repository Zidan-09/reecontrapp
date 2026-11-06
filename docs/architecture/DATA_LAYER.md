# Camada de Dados — Reencontrapp

## 1. Objetivo

A camada Data é responsável por implementar o acesso aos dados do Reencontrapp, isolando a aplicação dos detalhes técnicos de comunicação com serviços externos.

Sua principal responsabilidade é permitir que a aplicação consulte e cadastre objetos perdidos e encontrados sem que as demais camadas precisem conhecer o fornecedor de armazenamento em nuvem.

A implementação deverá respeitar a arquitetura **Feature-First + Clean Architecture simplificada**, mantendo a separação entre:

- Entidades e contratos do domínio.
- Casos de uso da aplicação.
- Implementações de persistência.
- Comunicação com serviços externos.

**Importante:** o serviço de nuvem foi aprovado no CARD-002 (Firebase Firestore), conforme `DATABASE.md`. Este documento estabelece os contratos e responsabilidades da camada Data; o esquema físico, as regras de acesso, a geração do timestamp e os parâmetros de configuração estão definidos em `DATABASE.md`.

## 2. Responsabilidades da camada Data

A camada Data deverá:

- Consultar os registros armazenados na nuvem.
- Cadastrar novos registros.
- Converter os dados externos em modelos da aplicação.
- Converter modelos em entidades de domínio.
- Implementar os contratos de repositórios definidos no Domain.
- Isolar dependências de serviços externos.
- Tratar e propagar erros de infraestrutura.
- Garantir que as operações sejam assíncronas.

A camada Data não deverá:

- Conter widgets ou componentes visuais.
- Controlar diretamente a navegação.
- Apresentar mensagens ao usuário.
- Implementar regras de interface.
- Depender da Presentation.
- Definir regras de negócio que pertencem ao Domain.

## 3. Organização dos diretórios

A estrutura prevista para a camada Data é:

```text
features/
└── lost_found/
    └── data/
        ├── data_sources/
        │   └── lost_found_remote_data_source.dart
        ├── models/
        │   └── lost_found_item_model.dart
        └── repositories/
            └── lost_found_repository_impl.dart
```

### 3.1 `data_sources/`

Responsável pela comunicação direta com fontes externas de dados.

Inicialmente, haverá uma fonte remota:

`LostFoundRemoteDataSource`

Ela deverá encapsular as operações necessárias para consultar e cadastrar registros no serviço de nuvem.

A implementação concreta utilizará o SDK aprovado (`cloud_firestore`, conforme `DATABASE.md`).

### 3.2 `models/`

Contém os modelos utilizados para representar e converter os dados recebidos ou enviados à fonte remota.

Inicialmente, haverá:

`LostFoundItemModel`

Esse modelo será responsável pela conversão entre a representação externa dos dados e os objetos utilizados pela aplicação.

### 3.3 `repositories/`

Contém as implementações concretas dos contratos definidos no Domain.

Inicialmente, haverá:

`LostFoundRepositoryImpl`

Sua responsabilidade será coordenar o data source e realizar as conversões necessárias para disponibilizar entidades de domínio aos casos de uso.

## 4. Repository Pattern

O projeto utilizará o **Repository Pattern** para abstrair o acesso aos dados.

O contrato do repositório deverá ser declarado na camada Domain:

```dart
abstract interface class LostFoundRepository {
  Future<List<LostFoundItem>> getAll();

  Future<String> generateId();

  Future<void> create(LostFoundItem item);
}
```

Esse contrato define as operações que a aplicação necessita, sem expor detalhes sobre a tecnologia de persistência.

A camada Data deverá fornecer sua implementação:

```dart
class LostFoundRepositoryImpl implements LostFoundRepository {
  // Implementação das operações do repositório.
}
```

A implementação deverá receber suas dependências por injeção, em vez de instanciar diretamente clientes ou SDKs de serviços externos.

### 4.1 Regras do contrato

- Os métodos devem ser assíncronos.
- O repositório deve retornar entidades de domínio, não modelos específicos do banco.
- Não deve expor tipos pertencentes ao SDK do fornecedor.
- Deve propagar falhas de leitura e gravação.
- Não deve retornar resultados fictícios em caso de falha.
- Deve manter a interface independente da implementação concreta.

Caso surja uma necessidade real de novas operações, o contrato poderá ser ampliado mediante atualização da documentação.

Não antecipar métodos de edição, exclusão ou outras funcionalidades que não fazem parte do escopo atual.

## 5. Data Sources

Os Data Sources representam a fronteira entre a aplicação e as fontes externas de dados.

### 5.1 LostFoundRemoteDataSource

Será responsável pela comunicação com o serviço remoto de armazenamento.

Operações inicialmente necessárias:

| Operação | Responsabilidade |
|---|---|
| `getAll` | Recuperar todos os registros necessários à listagem |
| `create` | Persistir um novo registro |

Os nomes e parâmetros definitivos poderão ser ajustados conforme a API ou o SDK escolhido.

### 5.2 Contrato de implementação

A implementação deverá:

1. Executar operações de rede de forma assíncrona.
2. Converter os dados recebidos para estruturas utilizáveis pela camada Data.
3. Encaminhar dados de cadastro no formato esperado pelo serviço.
4. Tratar falhas de comunicação.
5. Não ocultar exceções.
6. Não retornar sucesso quando a operação não tiver sido confirmada.

O Data Source não deverá conhecer widgets, providers da interface ou casos de uso.

### 5.3 Independência do fornecedor

A implementação concreta deverá permanecer isolada.

Por exemplo, caso a equipe escolha futuramente um serviço baseado em API REST ou um SDK específico, os detalhes dessa tecnologia deverão ficar restritos à implementação do Data Source e às configurações necessárias.

Não criar múltiplos Data Sources ou interfaces genéricas antecipadamente. A abstração deve atender às necessidades reais do projeto.

## 6. Models e conversões

O modelo `LostFoundItemModel` representará a estrutura dos dados recebidos e enviados ao serviço remoto.

Ele deverá permitir:

- Converter dados externos para um modelo Dart.
- Converter o modelo para uma entidade `LostFoundItem`.
- Converter os dados necessários para a operação de cadastro.

Exemplo conceitual:

```dart
class LostFoundItemModel {
  final String id;
  final String name;
  final String description;
  final String location;
  final String status;
  final DateTime createdAt;

  const LostFoundItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.status,
    required this.createdAt,
  });

  factory LostFoundItemModel.fromMap(Map<String, dynamic> map) {
    // Conversão dos dados externos para o modelo.
    throw UnimplementedError();
  }

  LostFoundItem toEntity() {
    // Conversão para a entidade de domínio.
    throw UnimplementedError();
  }
}
```

O exemplo é ilustrativo. A implementação definitiva deverá considerar o formato de dados do serviço escolhido.

### 6.1 Separação entre Model e Entity

O Model pertence à camada Data.

A Entity pertence à camada Domain.

A separação existe para impedir que a estrutura física de armazenamento determine a estrutura interna do domínio.

Portanto:

- A Entity não deverá possuir dependências do fornecedor.
- O Model poderá conhecer o formato externo dos dados.
- A implementação do repositório será responsável por realizar as conversões necessárias.

Não adicionar anotações, heranças ou dependências específicas de SDK às entidades de domínio.

## 7. Estrutura dos dados

O registro de um objeto deverá representar os seguintes campos:

| Campo | Tipo conceitual | Obrigatoriedade | Regra |
|---|---|---|---|
| `id` | Identificador | Sim | Único e gerado automaticamente |
| `name` | String | Sim | Máximo de 60 caracteres |
| `description` | String | Sim | Máximo de 200 caracteres |
| `location` | String | Sim | Não pode estar vazio |
| `status` | String/Enum | Sim | `lost` ou `found` |
| `created_at` | Timestamp | Sim | Gerado automaticamente |

Os nomes apresentados representam o modelo lógico. O formato físico poderá ser diferente dependendo do serviço escolhido.

### 7.1 Identificador

Cada registro deverá possuir um identificador único.

A estratégia de geração deverá ser definida considerando os recursos do serviço de persistência selecionado.

A interface não deverá solicitar esse identificador ao usuário.

### 7.2 Situação

Os únicos valores permitidos são:

- `lost`
- `found`

O mapeamento para a entidade deverá utilizar o enum `ItemStatus` definido no Domain.

Valores desconhecidos ou inválidos não deverão ser convertidos silenciosamente para uma situação válida.

### 7.3 Data e hora

O campo `created_at` representa o momento de criação do registro.

Regras:

- Deve ser gerado automaticamente.
- Não deve ser informado pelo usuário.
- Não deve ser editável nesta versão.
- Deve permitir ordenação cronológica.
- Deve ser convertido corretamente para `DateTime`.

**Decisão aprovada:** o timestamp é gerado pelo servidor Firestore com `FieldValue.serverTimestamp()` no campo `created_at`, conforme `DATABASE.md`.

## 8. Operação de leitura

A operação de leitura será responsável por recuperar os registros necessários para preencher a listagem.

Fluxo esperado:

```text
Presentation
     |
     v
Application (GetLostFoundItems)
     |
     v
Domain (LostFoundRepository)
     |
     v
Data (LostFoundRepositoryImpl)
     |
     v
Data (LostFoundRemoteDataSource)
     |
     v
Cloud Service
```

Após a recuperação:

1. O Data Source obtém os dados remotos.
2. Os dados são convertidos em `LostFoundItemModel`.
3. O repositório converte os Models em entidades.
4. A lista de `LostFoundItem` é retornada ao caso de uso.

### 8.1 Ordenação

Os registros deverão ser apresentados do mais recente para o mais antigo.

No CARD-013, `LostFoundRepositoryImpl.getAll()` ordena a nova lista de entidades
após converter os Models. Compara `createdAt` como `DateTime` em ordem decrescente
e desempata por `id` crescente. Registros com `LostFoundItem.unknownCreatedAt`
ficam ao final, também ordenados por ID, sem modificar suas datas.

A consulta continua recuperando todos os documentos: `orderBy('created_at')`
no Firestore excluiria documentos sem esse campo. Essa escolha preserva a
compatibilidade do CARD-012 e dispensa alterações de índices ou configuração.
Consulte `DATABASE.md`, seção 7.2, para a justificativa.

A lista recebida do Data Source não é reordenada nem alterada. Cada leitura
produz uma nova lista ordenada, sem depender da ordem da resposta remota.
O caso de uso `GetLostFoundItems` já repassa esse resultado; a futura listagem
deverá consumir o caso de uso e preservar a ordem recebida.

### 8.2 Lista vazia

Uma consulta concluída com sucesso, mas sem registros, deverá retornar uma lista vazia.

Isso não deve ser confundido com uma falha de comunicação.

A Presentation será responsável por apresentar uma mensagem apropriada quando não houver registros.

## 9. Operação de cadastro

A operação de cadastro será responsável por persistir um novo registro.

Fluxo esperado:

```text
Presentation
     |
     v
Application (CreateLostFoundItem)
     |
     v
Domain (LostFoundRepository)
     |
     v
Data (LostFoundRepositoryImpl)
     |
     v
Data (LostFoundRemoteDataSource)
     |
     v
Cloud Service
```

### 9.1 Dados enviados

O cadastro deverá utilizar:

- Nome.
- Descrição.
- Local.
- Situação.

O identificador e a data/hora deverão ser gerados automaticamente conforme a estratégia aprovada para o serviço escolhido.

### 9.2 Confirmação da gravação

A operação somente deverá ser considerada concluída após a confirmação da persistência pelo serviço remoto.

Em caso de falha:

- A exceção deverá ser propagada.
- A interface não deverá apresentar sucesso.
- O usuário deverá receber uma mensagem compreensível.
- Deverá ser possível tentar novamente quando apropriado.

### 9.3 Atualização da listagem

Após um cadastro bem-sucedido, o gerenciamento de estado deverá invalidar ou atualizar o provider responsável pela listagem.

A atualização deverá recuperar os dados persistidos, evitando manter uma lista desatualizada na interface.

Essa coordenação pertence à camada Application/Presentation por meio dos providers, não ao Data Source.

### 9.4 Identidade e nova tentativa — CARD-027

`generateId()` aloca um auto-ID do Firestore sem criar documento. O caso de
uso disponibiliza essa operação ao notifier, que associa o ID aos dados
originais em uma entidade imutável antes de chamar `create`. O contrato de
`create` exige ID preenchido e reconhece uma criação anterior correspondente.
O repositório conserva a tradução de erros do CARD-014 nas duas operações.

O Data Source executa uma transação: lê `items/{id}` e, se ausente, cria todos
os campos com `model.toMap()`. Se presente, compara nome, descrição, local e
situação e exige um timestamp persistido válido, sem comparar seu valor com a
data da entidade. Correspondência confirma sucesso sem escrita; divergência
gera erro, sem sobrescrever ou escolher outro ID. O callback não contém efeitos
de interface. As regras existentes de leitura/criação são suficientes.

Transações exigem conexão e não enfileiram o cadastro para sincronização
offline. Uma falha libera o processamento e permite repetir a mesma operação.
Não há timeout adicional: erro ou ausência de confirmação não provam ausência
de gravação. O sucesso exige confirmação remota, inclusive na reconciliação.

A garantia limita-se às tentativas com o mesmo ID e dados conservados. Não
deduplica operações com IDs diferentes nem conserva identidade após encerramento
do processo. Não há armazenamento persistente local. Veja também
`DATABASE.md`, seção 7.3, e `STATE_MANAGEMENT.md`, seção 6.4.

## 10. Tratamento de erros

A camada Data deverá tratar adequadamente as falhas provenientes da infraestrutura.

Exemplos:

- Falha de conexão.
- Tempo limite de comunicação.
- Falha de leitura.
- Falha de gravação.
- Resposta inválida.
- Dados incompatíveis com o modelo esperado.

### 10.1 Responsabilidades

**Data Source:**
- Identificar falhas provenientes do serviço externo.
- Não ocultar exceções.
- Converter erros específicos quando necessário.

**Repository:**
- Traduzir falhas de infraestrutura para erros que façam sentido para a aplicação.
- Preservar a informação necessária para diagnóstico.

**Presentation:**
- Apresentar mensagens compreensíveis em português.
- Exibir estados de erro.
- Permitir nova tentativa quando aplicável.

Não retornar uma lista vazia para esconder uma falha de consulta.

Não apresentar detalhes internos, stack traces ou credenciais ao usuário.

## 11. Injeção de dependências

A injeção de dependências será realizada pelo **Riverpod**.

Os providers deverão compor as dependências necessárias:

```text
RemoteDataSource Provider
          |
          v
Repository Provider
          |
          v
Use Case Provider
          |
          v
Presentation Provider
```

A composição deverá permitir que cada componente receba suas dependências sem instanciar diretamente implementações concretas.

A configuração do cliente do serviço de nuvem deverá ficar isolada, preferencialmente em um provider específico da camada Data ou da configuração de infraestrutura.

Não introduzir outro contêiner de injeção de dependências.

## 12. Segurança e acesso remoto

O aplicativo não terá autenticação de usuários nesta versão.

Entretanto, a ausência de login não significa que o serviço remoto deva permitir operações irrestritas.

A configuração de acesso deverá respeitar o princípio do menor privilégio.

Operações necessárias:

- Leitura dos registros.
- Criação de novos registros.

Operações que não fazem parte do escopo:

- Edição.
- Exclusão.
- Administração do banco pelo aplicativo.

Nunca incluir no código ou no repositório:

- Senhas administrativas.
- Chaves privadas.
- Tokens com privilégios elevados.
- Credenciais de acesso administrativo.

A equipe deverá consultar a documentação oficial do fornecedor escolhido para distinguir corretamente configurações públicas de segredos privados.

## 13. Independência do fornecedor

A arquitetura deverá permitir substituir o serviço de nuvem com o menor impacto possível.

Uma eventual substituição deverá afetar principalmente:

- Configuração do cliente remoto.
- Implementação do Data Source.
- Mapeamento do Model.
- Configurações específicas do fornecedor.

Deverão permanecer independentes:

- Entidades do Domain.
- Contratos dos repositórios.
- Casos de uso.
- Widgets.
- Páginas.
- Regras de apresentação.
- Gerenciamento de estado, salvo ajustes necessários de integração.

Não utilizar tipos específicos do fornecedor nos contratos de domínio ou nos componentes visuais.

## 14. Restrições de implementação

As seguintes regras são obrigatórias:

1. Não implementar integração com um fornecedor antes de sua aprovação.
2. Não acoplar entidades de domínio ao SDK de nuvem.
3. Não acessar o serviço remoto diretamente pelos widgets.
4. Não inserir dados fictícios hardcoded como substitutos da persistência real.
5. Não ocultar erros de comunicação.
6. Não permitir que o usuário informe ou altere o timestamp.
7. Não implementar edição ou exclusão nesta versão.
8. Não criar abstrações genéricas sem necessidade.
9. Não adicionar dependências sem justificativa.
10. Não incluir credenciais privadas no repositório.

## 15. Decisões aprovadas

As decisões de infraestrutura foram aprovadas no CARD-002 e estão detalhadas em `DATABASE.md`:

| Decisão | Situação |
|---|---|
| Serviço de nuvem | Firebase Firestore — plano Spark (gratuito) |
| Banco de dados | Cloud Firestore (modo Native), coleção `items` |
| SDK ou API de integração | FlutterFire (`firebase_core`, `cloud_firestore`) |
| Estrutura física da coleção | Conforme o esquema de `DATABASE.md` |
| Regras de acesso remoto | `allow read, create: if true; allow update, delete: if false` |
| Geração definitiva do timestamp | `FieldValue.serverTimestamp()` em `created_at` |
| Estratégia de configuração para avaliação | Parâmetros em `lib/firebase_options.dart` e arquivos de plataforma versionados; instruções no `README.md` (CARD-033) |

A escolha atende aos requisitos acadêmicos de gratuidade, persistência, compartilhamento entre instalações e acesso sem autenticação.

Alterações nessa configuração exigem nova aprovação da equipe.

## 16. Referências

- `ARCHITECTURE.md`: visão geral da arquitetura.
- `FOLDER_STRUCTURE.md`: organização dos diretórios.
- `DESIGN_PATTERNS.md`: padrões de projeto.
- `STATE_MANAGEMENT.md`: gerenciamento de estado.
- `DATABASE.md`: requisitos de persistência.
- `CODING_STANDARDS.md`: padrões de código.
- `AI_AGENTS.md`: orientações para agentes de IA.

Este documento deverá ser atualizado sempre que a implementação da camada Data ou as decisões de infraestrutura forem alteradas.
