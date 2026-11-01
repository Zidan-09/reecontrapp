# Padrões de Projeto — Reencontrapp

## 1. Objetivo

Este documento define os padrões de projeto e princípios de desenvolvimento adotados no Reencontrapp.

O objetivo é estabelecer uma implementação consistente, organizada e de fácil manutenção, respeitando a arquitetura **Feature-First + Clean Architecture simplificada**.

Os padrões devem ser utilizados para resolver problemas reais de organização, acoplamento e manutenção. Não devem ser aplicados indiscriminadamente apenas para aumentar a quantidade de abstrações ou classes do projeto.

A simplicidade é uma prioridade: implementar somente as estruturas necessárias para atender aos requisitos da aplicação.

## 2. Padrões adotados

Os seguintes padrões estão aprovados:

| Padrão | Aplicação |
|---|---|
| Repository Pattern | Abstração do acesso aos dados |
| Use Case Pattern | Representação das operações da aplicação |
| Dependency Injection | Composição e fornecimento de dependências por meio do Riverpod |
| DTO / Model | Conversão entre dados externos e entidades de domínio |

Além desses padrões, o projeto deverá respeitar os princípios SOLID e Separation of Concerns.

## 3. Repository Pattern

<badge color="success">Adotado</badge>

### 3.1 Objetivo

O Repository Pattern será utilizado para abstrair a comunicação entre as regras da aplicação e a infraestrutura de persistência.

A aplicação deverá conhecer apenas o contrato do repositório, sem precisar conhecer como os dados são armazenados ou recuperados.

Isso permite substituir o serviço de nuvem sem modificar os casos de uso ou a interface.

### 3.2 Organização

O padrão será dividido entre duas camadas:

**Domain**

Define o contrato que representa as operações necessárias para o negócio.

Exemplo:

```dart
abstract interface class LostFoundRepository {
  Future<List<LostFoundItem>> getAll();

  Future<void> create(LostFoundItem item);
}
```

**Data**

Implementa o contrato utilizando a fonte de dados escolhida.

Exemplo:

```dart
class LostFoundRepositoryImpl implements LostFoundRepository {
  LostFoundRepositoryImpl(this._dataSource);

  final LostFoundRemoteDataSource _dataSource;

  @override
  Future<List<LostFoundItem>> getAll() async {
    // Recupera e converte os registros.
    throw UnimplementedError();
  }

  @override
  Future<void> create(LostFoundItem item) async {
    // Solicita a persistência do registro.
    throw UnimplementedError();
  }
}
```

Os exemplos são ilustrativos e não representam a implementação definitiva da integração remota.

### 3.3 Responsabilidades

O contrato do repositório deverá:

- Definir as operações necessárias à aplicação.
- Trabalhar com entidades de domínio.
- Permanecer independente do fornecedor de nuvem.
- Não expor detalhes de infraestrutura.

A implementação deverá:

- Utilizar os Data Sources necessários.
- Converter Models em Entities.
- Converter Entities em dados de persistência.
- Propagar erros de infraestrutura de maneira apropriada.

### 3.4 Regras

1. O contrato deve permanecer no Domain.
2. A implementação deve permanecer na Data.
3. A Presentation não deve acessar diretamente os Data Sources.
4. Os casos de uso devem depender do contrato, não da implementação.
5. Não retornar tipos específicos de SDK ou banco de dados pelo contrato.
6. Não criar métodos para funcionalidades que não fazem parte do escopo aprovado.

## 4. Use Case Pattern

<badge color="success">Adotado</badge>

### 4.1 Objetivo

O Use Case Pattern será utilizado para representar operações específicas da aplicação.

Cada caso de uso deverá ter uma responsabilidade clara e coordenar a execução de uma ação por meio das abstrações disponíveis no Domain.

Os casos de uso pertencem à camada Application.

### 4.2 Casos de uso previstos

Inicialmente, a aplicação possui duas operações principais:

| Caso de uso | Responsabilidade |
|---|---|
| `GetLostFoundItems` | Recuperar os registros de objetos perdidos e encontrados |
| `CreateLostFoundItem` | Cadastrar um novo registro |

### 4.3 Exemplo de implementação

```dart
class GetLostFoundItems {
  GetLostFoundItems(this._repository);

  final LostFoundRepository _repository;

  Future<List<LostFoundItem>> call() {
    return _repository.getAll();
  }
}
```

Exemplo de cadastro:

```dart
class CreateLostFoundItem {
  CreateLostFoundItem(this._repository);

  final LostFoundRepository _repository;

  Future<void> call(LostFoundItem item) {
    return _repository.create(item);
  }
}
```

### 4.4 Responsabilidades

Um caso de uso poderá:

- Coordenar uma operação da aplicação.
- Utilizar um ou mais contratos de repositório.
- Aplicar regras pertinentes à operação.
- Retornar resultados ou propagar falhas.

Não deverá:

- Executar consultas diretamente ao banco.
- Conhecer SDKs de serviços externos.
- Manipular widgets.
- Controlar navegação.
- Apresentar mensagens visuais.
- Gerenciar diretamente o estado da interface.

### 4.5 Quando criar um Use Case

Criar um caso de uso quando existir uma operação identificável da aplicação que mereça uma representação própria.

Não criar casos de uso para operações triviais sem benefício arquitetural.

Também não criar uma classe base genérica como:

```dart
abstract class UseCase<Input, Output> {
  Future<Output> call(Input input);
}
```

Essa abstração não será adotada inicialmente.

Cada caso de uso deverá possuir uma implementação explícita e simples.

## 5. Dependency Injection

<badge color="success">Adotado — Riverpod</badge>

### 5.1 Objetivo

A injeção de dependências será realizada por meio do Riverpod.

Seu propósito é fornecer as dependências necessárias a cada componente sem exigir que ele instancie diretamente suas implementações concretas.

O Riverpod também será utilizado para gerenciamento de estado, conforme definido em `STATE_MANAGEMENT.md`.

### 5.2 Composição das dependências

A composição deverá respeitar o fluxo:

```text
RemoteDataSource
       |
       v
RepositoryImpl
       |
       v
UseCase
       |
       v
Presentation Provider
```

Os providers deverão construir e fornecer os componentes necessários.

Exemplo conceitual:

```dart
final lostFoundRepositoryProvider =
    Provider<LostFoundRepository>((ref) {
  final dataSource = ref.watch(
    lostFoundRemoteDataSourceProvider,
  );

  return LostFoundRepositoryImpl(dataSource);
});

final getLostFoundItemsProvider =
    Provider<GetLostFoundItems>((ref) {
  final repository = ref.watch(
    lostFoundRepositoryProvider,
  );

  return GetLostFoundItems(repository);
});
```

O exemplo não define a configuração definitiva do serviço remoto.

### 5.3 Regras

- Utilizar Riverpod para fornecer dependências.
- Não instanciar repositórios concretos diretamente nos widgets.
- Não criar um Service Locator paralelo.
- Não introduzir outro contêiner de injeção de dependências.
- Evitar dependências globais mutáveis.
- Manter a configuração de infraestrutura isolada.

## 6. DTO / Model Pattern

<badge color="success">Adotado na camada Data</badge>

### 6.1 Objetivo

Os Models serão utilizados para representar os dados no formato esperado pelas fontes externas.

Eles serão responsáveis por converter os dados recebidos ou enviados entre a infraestrutura e os objetos internos da aplicação.

### 6.2 Separação entre Model e Entity

O projeto deverá distinguir:

**Entity**

Pertence ao Domain e representa um conceito do negócio.

Exemplo:

```dart
class LostFoundItem {
  final String id;
  final String name;
  final String description;
  final String location;
  final ItemStatus status;
  final DateTime createdAt;

  const LostFoundItem({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.status,
    required this.createdAt,
  });
}
```

**Model**

Pertence à Data e representa os dados recebidos ou enviados ao serviço de persistência.

Exemplo:

```dart
class LostFoundItemModel {
  // Campos e conversões específicos do formato externo.

  factory LostFoundItemModel.fromMap(
    Map<String, dynamic> map,
  ) {
    throw UnimplementedError();
  }

  LostFoundItem toEntity() {
    throw UnimplementedError();
  }
}
```

Os exemplos são ilustrativos.

### 6.3 Regras

- Entities não devem depender de Models.
- Entities não devem importar SDKs externos.
- Models podem conhecer o formato de persistência.
- A conversão entre Model e Entity deve ocorrer na camada Data.
- Valores externos inválidos devem ser tratados explicitamente.
- Não utilizar `dynamic` indiscriminadamente para evitar definir os tipos dos dados.

Não criar modelos redundantes sem necessidade. A separação deverá existir principalmente para proteger o domínio das particularidades da infraestrutura.

## 7. Princípios SOLID

O projeto deverá respeitar os cinco princípios SOLID de maneira pragmática.

### 7.1 Single Responsibility Principle (SRP)

Uma classe deve possuir uma responsabilidade principal e um motivo claro para mudar.

Exemplos:

- `LostFoundItem`: representa um objeto.
- `GetLostFoundItems`: coordena a recuperação dos registros.
- `LostFoundRepositoryImpl`: implementa o acesso aos dados.
- `LostFoundRemoteDataSource`: comunica-se com o serviço remoto.

Evitar classes que concentrem interface, persistência, validação e regras de negócio.

### 7.2 Open/Closed Principle (OCP)

Os componentes devem permitir extensões sem exigir modificações desnecessárias em estruturas estáveis.

No projeto, o contrato do repositório permite substituir sua implementação sem modificar os casos de uso.

Não criar mecanismos de extensão genéricos antecipadamente.

### 7.3 Liskov Substitution Principle (LSP)

Implementações de um contrato devem respeitar seu comportamento esperado.

Por exemplo, qualquer implementação de `LostFoundRepository` deverá cumprir as expectativas de leitura e gravação definidas pelo contrato.

Não alterar silenciosamente o significado das operações em implementações diferentes.

### 7.4 Interface Segregation Principle (ISP)

Contratos devem ser pequenos e específicos.

O `LostFoundRepository` deve expor apenas as operações necessárias à funcionalidade.

Não criar interfaces enormes com métodos que não serão utilizados.

### 7.5 Dependency Inversion Principle (DIP)

Componentes de alto nível devem depender de abstrações, não de implementações concretas.

No Reencontrapp:

- Os casos de uso dependem de contratos do Domain.
- A implementação do repositório depende das abstrações necessárias.
- A Presentation não conhece os detalhes do serviço de nuvem.
- O Domain não depende da infraestrutura.

A injeção dessas dependências será feita pelo Riverpod.

## 8. Separation of Concerns

Além de SOLID, o projeto deverá respeitar a separação de responsabilidades entre componentes e camadas.

| Componente | Responsabilidade |
|---|---|
| Page | Compor a tela |
| Widget | Apresentar componentes visuais |
| Provider / Notifier | Gerenciar estado e coordenar operações |
| Use Case | Representar uma ação da aplicação |
| Repository | Abstrair o acesso aos dados |
| Data Source | Comunicar-se com a fonte externa |
| Model | Converter dados externos |
| Entity | Representar conceitos do domínio |

Nenhum componente deverá assumir responsabilidades pertencentes a outra camada sem justificativa.

## 9. Padrões que não serão adotados antecipadamente

Para evitar complexidade desnecessária, os seguintes padrões não fazem parte da arquitetura inicial:

| Padrão | Motivo |
|---|---|
| Singleton manual | O Riverpod já fornece mecanismos de compartilhamento e ciclo de vida |
| Service Locator | A injeção será realizada pelo Riverpod |
| Factory genérica | Não existe necessidade atual que justifique sua introdução |
| Unit of Work | O escopo atual não exige coordenação de múltiplas operações transacionais |
| CQRS | As operações são simples e não justificam separar modelos de leitura e escrita |
| Event Bus | Não existe necessidade atual de comunicação por eventos desacoplados |
| Mediator | Os casos de uso existentes não justificam essa complexidade |
| Base genérica para Use Cases | Não oferece benefício suficiente para o tamanho atual do projeto |

Esses padrões não são proibidos em qualquer circunstância futura, mas somente poderão ser introduzidos se houver uma necessidade concreta e aprovação da equipe.

## 10. Regras para agentes de IA

Todos os agentes de IA que trabalharem no projeto deverão respeitar as seguintes regras:

1. Consultar este documento antes de criar novas abstrações.
2. Utilizar Repository Pattern para abstrair o acesso aos dados.
3. Utilizar Use Cases para operações relevantes da aplicação.
4. Utilizar Riverpod para injeção de dependências.
5. Manter Entities independentes da infraestrutura.
6. Isolar SDKs e detalhes do serviço de nuvem na camada Data.
7. Respeitar SOLID e Separation of Concerns.
8. Evitar duplicação de código.
9. Não criar classes ou interfaces sem necessidade concreta.
10. Não introduzir padrões adicionais por preferência pessoal.
11. Não alterar decisões arquiteturais sem aprovação.
12. Priorizar implementações simples, explícitas e fáceis de compreender.

Se uma tarefa parecer exigir um padrão não documentado, o agente deverá explicar o problema que pretende resolver e justificar a necessidade antes de introduzi-lo.

## 11. Referências

- `ARCHITECTURE.md`: visão geral e organização arquitetural.
- `FOLDER_STRUCTURE.md`: estrutura de diretórios.
- `STATE_MANAGEMENT.md`: gerenciamento de estado com Riverpod.
- `DATA_LAYER.md`: responsabilidades e implementação da camada Data.
- `DATABASE.md`: requisitos de persistência.
- `CODING_STANDARDS.md`: convenções de desenvolvimento.
- `AI_AGENTS.md`: instruções para agentes de IA.

Este documento deverá ser atualizado sempre que um padrão adotado for alterado ou uma nova decisão arquitetural for aprovada.