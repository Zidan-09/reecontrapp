# Estrutura de Pastas — Reencontrapp

## 1. Objetivo

Este documento define a estrutura de diretórios e arquivos do projeto Reencontrapp, desenvolvido com Flutter e Dart.

A organização seguirá o modelo **Feature-First combinado com Clean Architecture simplificada**, agrupando os arquivos por funcionalidade e separando suas responsabilidades em camadas.

Os principais objetivos são:

- Facilitar a localização dos arquivos.
- Separar responsabilidades.
- Reduzir o acoplamento entre componentes.
- Facilitar a manutenção.
- Permitir que todos os integrantes compreendam a organização.
- Fornecer uma estrutura consistente para os agentes de IA.

A estrutura deverá permanecer simples e proporcional à complexidade real do projeto.

## 2. Estrutura geral do projeto

A organização inicial será:

```text
reencontrapp/
├── android/
├── ios/
├── web/
├── lib/
│   ├── main.dart
│   ├── app/
│   │   ├── app.dart
│   │   ├── app_theme.dart
│   │   └── app_router.dart
│   ├── core/
│   │   ├── constants/
│   │   ├── errors/
│   │   └── utils/
│   └── features/
│       └── lost_found/
│           ├── domain/
│           │   ├── entities/
│           │   ├── enums/
│           │   └── repositories/
│           ├── application/
│           │   └── use_cases/
│           ├── data/
│           │   ├── data_sources/
│           │   ├── models/
│           │   └── repositories/
│           └── presentation/
│               ├── pages/
│               ├── widgets/
│               └── providers/
├── docs/
│   └── architecture/
├── assets/
│   ├── images/
│   └── icons/
├── pubspec.yaml
├── analysis_options.yaml
├── .gitignore
└── README.md
```

A estrutura acima representa a organização de referência. Diretórios e arquivos só deverão ser criados quando forem necessários.

As pastas nativas (`android/`, `ios/`, `web/` etc.) dependerão das plataformas habilitadas no projeto Flutter.

## 3. Diretório `lib/`

O diretório `lib/` concentra o código-fonte Dart da aplicação.

Sua organização será dividida em três áreas principais:

- `main.dart`: entrada da aplicação.
- `app/`: configurações globais e inicialização da interface.
- `core/`: componentes compartilhados.
- `features/`: funcionalidades da aplicação.

## 4. Arquivo `main.dart`

```text
lib/
└── main.dart
```

É o ponto de entrada da aplicação.

Responsabilidades:

- Inicializar os serviços necessários.
- Configurar o ambiente de execução.
- Inicializar o Riverpod.
- Executar o widget raiz da aplicação.

Exemplo conceitual:

```dart
void main() {
  runApp(
    const ProviderScope(
      child: ReencontrappApp(),
    ),
  );
}
```

A implementação definitiva deverá incluir as inicializações necessárias ao serviço de nuvem escolhido.

O arquivo não deverá conter:

- Widgets de páginas.
- Regras de negócio.
- Consultas ao banco de dados.
- Implementações de repositórios.
- Lógica complexa de inicialização.

## 5. Diretório `app/`

```text
lib/
└── app/
    ├── app.dart
    ├── app_theme.dart
    └── app_router.dart
```

Contém configurações globais da aplicação.

### 5.1 `app.dart`

Responsável pelo widget raiz do Reencontrapp.

Deverá:

- Configurar o `MaterialApp`.
- Aplicar o tema global.
- Definir a tela inicial.
- Integrar a configuração de navegação.

Não deverá concentrar a implementação das páginas ou regras de negócio.

### 5.2 `app_theme.dart`

Responsável pela configuração visual global.

Deverá centralizar:

- `ThemeData`.
- Configuração do Material 3.
- Esquema de cores.
- Tipografia.
- Estilos globais de componentes, quando necessário.

O objetivo é manter consistência visual e evitar configurações repetidas em diferentes páginas.

### 5.3 `app_router.dart`

Responsável pela configuração centralizada da navegação.

O projeto utilizará o **Navigator 1.0 nativo do Flutter**.

Esse arquivo deverá organizar as rotas e os mecanismos de navegação necessários, evitando espalhar configurações de rotas por toda a aplicação.

Não adicionar bibliotecas externas de navegação sem necessidade concreta e aprovação da equipe.

## 6. Diretório `core/`

```text
lib/
└── core/
    ├── constants/
    ├── errors/
    └── utils/
```

Contém elementos compartilhados entre diferentes funcionalidades.

### 6.1 `constants/`

Armazena constantes globais da aplicação.

Exemplos possíveis:

- Valores fixos de configuração.
- Identificadores compartilhados.
- Constantes visuais utilizadas em diferentes funcionalidades.

Não utilizar esse diretório para armazenar valores que pertencem exclusivamente a uma feature.

### 6.2 `errors/`

Armazena estruturas de erro compartilhadas, quando necessário.

Exemplos:

- Tipos de exceções da aplicação.
- Classes de erro reutilizáveis.
- Estruturas comuns para representação de falhas.

Erros específicos de uma funcionalidade deverão permanecer dentro do contexto dessa funcionalidade quando não houver necessidade de compartilhamento.

### 6.3 `utils/`

Armazena utilitários genéricos e reutilizáveis.

Um componente só deverá ser colocado aqui quando possuir utilidade real para mais de uma parte da aplicação.

Não transformar `core/` em um diretório genérico para arquivos cuja responsabilidade não esteja clara.

## 7. Diretório `features/`

```text
lib/
└── features/
    ├── lost_found/
    └── welcome/
```

Contém as funcionalidades do aplicativo.

A organização por feature permite manter próximos os arquivos que pertencem ao mesmo contexto funcional.

O Reencontrapp possui duas funcionalidades:

- `lost_found`: cadastro e listagem de objetos perdidos e encontrados.
- `welcome`: tela inicial exibida ao abrir o aplicativo, com acesso à listagem.

Caso novas funcionalidades sejam aprovadas, deverão ser organizadas dentro de `features/`, respeitando a mesma convenção arquitetural quando isso fizer sentido.

## 8. Estrutura da feature `lost_found/`

```text
lost_found/
├── domain/
├── application/
├── data/
└── presentation/
```

Cada camada possui uma responsabilidade específica.

### 8.1 `domain/`

```text
domain/
├── entities/
├── enums/
└── repositories/
```

Contém os conceitos fundamentais do negócio.

#### `entities/`

Armazena as entidades de domínio.

Arquivo previsto:

```text
entities/
└── lost_found_item.dart
```

`LostFoundItem` representa um objeto perdido ou encontrado.

Deverá conter os atributos e comportamentos próprios da entidade, sem depender de tecnologias externas.

#### `enums/`

Armazena enums utilizados pelo domínio.

Arquivo previsto:

```text
enums/
└── item_status.dart
```

`ItemStatus` representa as situações permitidas:

- `lost`
- `found`

#### `repositories/`

Armazena os contratos dos repositórios.

Arquivo previsto:

```text
repositories/
└── lost_found_repository.dart
```

O contrato `LostFoundRepository` define as operações que a aplicação necessita para recuperar e cadastrar registros.

**Regra:** o Domain não deve depender de Flutter, Riverpod, SDKs de nuvem ou bibliotecas específicas de banco de dados.

### 8.2 `application/`

```text
application/
└── use_cases/
```

Contém os casos de uso da aplicação.

Arquivos inicialmente previstos:

```text
use_cases/
├── get_lost_found_items.dart
└── create_lost_found_item.dart
```

Responsabilidades:

- Representar operações da aplicação.
- Coordenar a execução das ações.
- Utilizar os contratos definidos no Domain.

Os casos de uso não devem conhecer a implementação concreta do serviço de nuvem.

Não criar diretórios adicionais ou classes genéricas sem necessidade.

### 8.3 `data/`

```text
data/
├── data_sources/
├── models/
├── repositories/
└── data_providers.dart
```

Contém a implementação do acesso aos dados.

#### `data_sources/`

Responsável pela comunicação com fontes externas.

Arquivo previsto:

```text
data_sources/
└── lost_found_remote_data_source.dart
```

`LostFoundRemoteDataSource` deverá encapsular as operações remotas necessárias.

O SDK ou a API do serviço de nuvem escolhido deverá permanecer isolado nesta camada.

#### `models/`

Armazena modelos utilizados para representar os dados externos.

Arquivo previsto:

```text
models/
└── lost_found_item_model.dart
```

`LostFoundItemModel` será responsável pelas conversões entre o formato de persistência e as entidades de domínio.

Por pertencer à camada Data, este Model pode conhecer os tipos do SDK de nuvem (`Timestamp`, `FieldValue`), conforme `DATA_LAYER.md 6.1`. A entidade `LostFoundItem` do Domain permanece sem dependência de tecnologias externas.

#### `repositories/`

Contém implementações concretas dos contratos definidos no Domain.

Arquivo previsto:

```text
repositories/
└── lost_found_repository_impl.dart
```

`LostFoundRepositoryImpl` implementará `LostFoundRepository`, utilizando o Data Source e realizando as conversões necessárias.

#### `data_providers.dart`

Arquivo de composição de dependências da camada Data, aprovado em `DATA_LAYER.md 11` e `DESIGN_PATTERNS.md 5.2`.

```text
data/
└── data_providers.dart
```

Responsabilidades:

| Provider | Responsabilidade |
|---|---|
| `firestoreProvider` | Isolar a configuração do cliente do serviço de nuvem em um ponto único |
| `lostFoundRemoteDataSourceProvider` | Instanciar o Data Source com o cliente acima |
| `lostFoundRepositoryProvider` | Expor `LostFoundRepository` como contrato do Domain |
| `getLostFoundItemsProvider` / `createLostFoundItemProvider` | Compor os casos de uso com o repositório |

O fluxo segue exatamente a composição prevista: `RemoteDataSource → Repository → UseCase → Presentation Provider`. Nenhum widget instancia implementações concretas, e nenhum outro contêiner de injeção de dependências é utilizado.

### 8.4 `presentation/`

```text
presentation/
├── pages/
├── widgets/
└── providers/
```

Contém a interface e o gerenciamento de estado da funcionalidade.

#### `pages/`

Armazena as páginas completas da aplicação.

Arquivos inicialmente previstos:

```text
pages/
├── item_list_page.dart
└── create_item_page.dart
```

Responsabilidades:

- Compor as telas.
- Observar os estados fornecidos pelo Riverpod.
- Encaminhar interações do usuário.
- Apresentar os resultados das operações.

As páginas não devem executar consultas diretamente ao serviço de nuvem.

#### `widgets/`

Armazena componentes visuais reutilizáveis dentro da feature.

Arquivos inicialmente previstos:

```text
widgets/
├── item_card.dart
├── item_status_badge.dart
└── item_form.dart
```

Responsabilidades:

| Widget | Responsabilidade |
|---|---|
| `ItemCard` | Apresentar um registro de objeto |
| `ItemStatusBadge` | Identificar visualmente a situação |
| `ItemForm` | Compor o formulário de cadastro |

Widgets exclusivos de uma página podem permanecer próximos dela se isso resultar em uma organização mais simples.

Não criar widgets separados para cada elemento visual trivial sem necessidade.

#### `providers/`

Armazena os providers e notifiers do Riverpod relacionados à funcionalidade.

Arquivos inicialmente previstos:

```text
providers/
├── item_list_provider.dart
└── create_item_provider.dart
```

Responsabilidades:

| Provider | Responsabilidade |
|---|---|
| `itemListProvider` | Gerenciar a recuperação dos registros |
| Provider de cadastro | Gerenciar o envio do formulário |

Os providers também poderão participar da composição das dependências, conforme a organização adotada para a integração.

O gerenciamento de estado deverá seguir as regras de `STATE_MANAGEMENT.md`.

## 9. Diretório `docs/`

```text
docs/
└── architecture/
```

Armazena a documentação técnica e arquitetural do projeto.

A estrutura prevista é:

```text
docs/
└── architecture/
    ├── README.md
    ├── ARCHITECTURE.md
    ├── FOLDER_STRUCTURE.md
    ├── DESIGN_PATTERNS.md
    ├── STATE_MANAGEMENT.md
    ├── DATA_LAYER.md
    ├── DATABASE.md
    ├── CODING_STANDARDS.md
    └── AI_AGENTS.md
```

Esses documentos representam a referência técnica para os integrantes da equipe e para os agentes de IA.

Alterações em decisões arquiteturais deverão ser refletidas na documentação correspondente.

## 10. Diretório `assets/`

```text
assets/
├── images/
└── icons/
```

Armazena recursos visuais utilizados pela aplicação.

### 10.1 `images/`

Imagens estáticas utilizadas na interface.

Exemplos:

- Ilustrações.
- Imagens de apresentação.
- Recursos visuais de telas vazias.

### 10.2 `icons/`

Ícones personalizados utilizados na aplicação, caso não sejam atendidos pelos ícones disponíveis no Flutter ou em dependências já aprovadas.

Os recursos deverão ser declarados no `pubspec.yaml` quando necessário.

Não criar diretórios para recursos que não serão utilizados.

## 11. Arquivos de configuração na raiz

### 11.1 `pubspec.yaml`

Gerencia as informações do projeto e suas dependências.

Deverá conter:

- Nome do pacote.
- Versão.
- SDK Dart compatível.
- Dependências de produção.
- Dependências de desenvolvimento necessárias.
- Declaração de assets.

Não adicionar dependências sem justificativa.

### 11.2 `analysis_options.yaml`

Configura as regras de análise estática do Dart.

Deverá manter as verificações necessárias para garantir consistência e qualidade do código.

### 11.3 `.gitignore`

Define arquivos e diretórios que não deverão ser versionados.

Deverá ignorar, entre outros:

- Arquivos temporários.
- Diretórios de build.
- Arquivos gerados.
- Configurações locais privadas.
- Credenciais e segredos.

Não versionar APK, AAB, IPA ou outros binários de entrega.

### 11.4 `README.md`

Documento principal do repositório.

Deverá apresentar:

- Nome do projeto.
- Integrantes da equipe.
- Objetivo da aplicação.
- Funcionalidades.
- Tecnologias utilizadas.
- Serviço de armazenamento escolhido.
- Instruções de configuração.
- Instruções para execução.
- Informações necessárias para avaliação.

## 12. Regras de nomenclatura

Os nomes dos arquivos e diretórios deverão seguir as convenções do Dart.

| Elemento | Convenção | Exemplo |
|---|---|---|
| Arquivos | `snake_case` | `lost_found_item.dart` |
| Diretórios | `snake_case` | `data_sources/` |
| Classes | `UpperCamelCase` | `LostFoundItem` |
| Enums | `UpperCamelCase` | `ItemStatus` |
| Métodos | `lowerCamelCase` | `getAll()` |
| Variáveis | `lowerCamelCase` | `createdAt` |
| Enum values | `lowerCamelCase` | `lost` |

Os identificadores técnicos devem permanecer em inglês.

Textos apresentados ao usuário devem permanecer em português.

## 13. Regras gerais de organização

Todos os integrantes e agentes de IA deverão respeitar as seguintes regras:

1. Organizar os arquivos por funcionalidade.
2. Respeitar a separação entre Domain, Application, Data e Presentation.
3. Manter componentes específicos dentro da feature correspondente.
4. Utilizar `core/` somente para elementos realmente compartilhados.
5. Não criar diretórios vazios antecipadamente.
6. Não criar arquivos apenas para preencher a estrutura prevista.
7. Não duplicar componentes ou responsabilidades.
8. Não criar abstrações sem necessidade concreta.
9. Não colocar regras de negócio em widgets.
10. Não colocar detalhes de infraestrutura no Domain.
11. Não mover arquivos para `core/` apenas para reduzir a quantidade de arquivos em uma feature.
12. Atualizar este documento caso a estrutura seja modificada de maneira relevante.

## 14. Estruturas que não fazem parte do escopo atual

Não criar antecipadamente diretórios ou módulos para:

- Autenticação.
- Perfil de usuário.
- Edição de registros.
- Exclusão de registros.
- Upload de imagens.
- Notificações.
- Pesquisa avançada.
- Chat ou comunicação entre usuários.

Essas funcionalidades não fazem parte dos requisitos aprovados para a versão atual.

Também não criar uma estrutura de testes automatizados.

O projeto utilizará validação manual, além de `dart format .` e `flutter analyze`.

## 15. Evolução da estrutura

A estrutura poderá evoluir conforme necessidades reais surgirem durante o desenvolvimento.

Qualquer alteração deverá respeitar:

- A arquitetura aprovada.
- A separação de responsabilidades.
- Os padrões de projeto.
- A simplicidade da implementação.
- Os requisitos acadêmicos.

Antes de criar novas camadas, diretórios globais ou abstrações, deve-se verificar se a necessidade não pode ser resolvida pela estrutura existente.

Mudanças relevantes deverão ser documentadas e aprovadas pela equipe.

## 16. Referências

- `ARCHITECTURE.md`: visão geral da arquitetura.
- `DESIGN_PATTERNS.md`: padrões de projeto.
- `STATE_MANAGEMENT.md`: gerenciamento de estado.
- `DATA_LAYER.md`: organização da camada de dados.
- `DATABASE.md`: requisitos e decisões de persistência.
- `CODING_STANDARDS.md`: padrões de código.
- `AI_AGENTS.md`: instruções para agentes de IA.

Este documento representa a estrutura de referência do Reencontrapp e deverá ser consultado antes de criar novos diretórios ou reorganizar arquivos.