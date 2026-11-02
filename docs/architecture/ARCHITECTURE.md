# Arquitetura do Reencontrapp

## 1. Visão geral

O **Reencontrapp** é um aplicativo móvel desenvolvido em Flutter e Dart para facilitar a divulgação e a recuperação de objetos perdidos e encontrados no ambiente universitário.

A aplicação permitirá que membros da comunidade acadêmica cadastrem objetos perdidos ou encontrados e consultem os registros compartilhados na nuvem.

A arquitetura deve priorizar:

- Organização e legibilidade do código.
- Separação clara de responsabilidades.
- Baixo acoplamento entre as camadas.
- Facilidade de manutenção e evolução.
- Independência em relação ao fornecedor de armazenamento em nuvem.
- Simplicidade proporcional ao escopo acadêmico do projeto.

O objetivo não é implementar uma arquitetura excessivamente complexa, mas estabelecer uma estrutura consistente que possa ser compreendida e mantida por todos os integrantes da equipe.

## 2. Decisões arquiteturais

As seguintes decisões estão aprovadas:

| Aspecto | Decisão |
|---|---|
| Linguagem | Dart |
| Framework | Flutter |
| Organização | Feature-First |
| Arquitetura | Clean Architecture simplificada |
| Princípios | SOLID, Separation of Concerns e Dependency Inversion |
| Gerenciamento de estado | Riverpod |
| Navegação | Navigator 1.0 nativo |
| Interface | Material 3 |
| Padrões de projeto | Repository Pattern e Use Case Pattern |
| Injeção de dependências | Riverpod |
| Testes automatizados | Não serão implementados |
| Validação | Testes manuais |
| Formatação | `dart format .` |
| Análise estática | `flutter analyze` |

### 2.1 Decisões de infraestrutura aprovadas

As decisões antes pendentes foram aprovadas pela equipe e estão registradas em [`DATABASE.md`](./DATABASE.md) (CARD-002):

| Aspecto | Decisão |
|---|---|
| Serviço de nuvem | Firebase Firestore — plano Spark (gratuito) |
| Banco de dados | Cloud Firestore (modo Native), coleção `items` |
| SDK de integração | FlutterFire (`firebase_core`, `cloud_firestore`) |
| Estrutura física | Documentos conforme o esquema de `DATABASE.md` |
| Regras de acesso remoto | `allow read, create: if true; allow update, delete: if false` |
| Timestamp | `FieldValue.serverTimestamp()` no campo `created_at` |
| Parâmetros de configuração | Ponto único em `lib/firebase_options.dart` |

A arquitetura deve continuar independente do fornecedor: o SDK permanece isolado na camada Data e nenhuma dessas decisões pode ser alterada sem nova aprovação da equipe.

## 3. Estilo arquitetural

O projeto utilizará **Feature-First combinado com Clean Architecture simplificada**.

### 3.1 Feature-First

A organização principal será por funcionalidade, agrupando os arquivos relacionados a um mesmo contexto.

Isso evita que o projeto cresça com grandes diretórios globais contendo arquivos de funcionalidades diferentes.

A estrutura principal será:

```text
lib/
├── app/
├── core/
└── features/
    └── lost_found/
```

Novas funcionalidades, caso sejam aprovadas futuramente, deverão ser organizadas dentro de `features/`.

### 3.2 Clean Architecture simplificada

A funcionalidade `lost_found` será dividida em quatro camadas:

- Presentation
- Application
- Domain
- Data

Cada camada possui responsabilidades específicas e deve respeitar as regras de dependência estabelecidas neste documento.

A implementação deve evitar abstrações desnecessárias. A separação de camadas existe para resolver problemas reais de acoplamento e organização, não para aumentar artificialmente a quantidade de arquivos.

## 4. Camadas da aplicação

### 4.1 Presentation

Responsável pela interface gráfica e pela interação com o usuário.

Contém:

- Páginas.
- Widgets.
- Formulários.
- Validações de interface.
- Providers e Notifiers do Riverpod.
- Apresentação dos estados de carregamento, sucesso e erro.

Exemplos de responsabilidades:

- Exibir a lista de objetos.
- Apresentar os detalhes dos registros.
- Permitir o preenchimento do formulário.
- Validar campos obrigatórios.
- Impedir visualmente o envio repetido.
- Apresentar mensagens compreensíveis ao usuário.

**Restrições:**

- Não acessar diretamente o banco de dados.
- Não utilizar SDKs de serviços de nuvem diretamente nos widgets.
- Não conter regras de persistência.
- Não concentrar regras de negócio complexas na interface.

A Presentation deve comunicar-se com a camada Application por meio dos casos de uso, utilizando o Riverpod para coordenar as operações.

### 4.2 Application

Responsável por coordenar as operações da aplicação.

Contém os casos de uso (*Use Cases*), que representam ações específicas disponíveis no sistema.

Inicialmente, estão previstos:

| Caso de uso | Responsabilidade |
|---|---|
| `GetLostFoundItems` | Recuperar os registros de objetos |
| `CreateLostFoundItem` | Cadastrar um novo registro |

Os casos de uso devem utilizar os contratos definidos no Domain, sem conhecer as implementações concretas da camada Data.

Não criar uma classe base genérica para todos os casos de uso apenas por padronização.

### 4.3 Domain

Representa o núcleo da aplicação e contém os conceitos e regras fundamentais do negócio.

Contém:

- Entidades.
- Enums.
- Contratos de repositórios.
- Regras de domínio independentes de infraestrutura.

A entidade principal será `LostFoundItem`.

Campos previstos:

| Campo | Tipo | Regra |
|---|---|---|
| `id` | Identificador | Único para cada registro |
| `name` | String | Obrigatório, máximo de 60 caracteres |
| `description` | String | Obrigatório, máximo de 200 caracteres |
| `location` | String | Obrigatório |
| `status` | ItemStatus | Perdido ou encontrado |
| `createdAt` | DateTime | Gerado automaticamente |

O enum `ItemStatus` deverá representar as duas situações permitidas:

```dart
enum ItemStatus {
  lost,
  found,
}
```

Os identificadores técnicos devem permanecer em inglês. A apresentação dos valores na interface deverá ocorrer em português.

Exemplos:

- `lost` → Perdido.
- `found` → Encontrado.

**Restrições:**

O Domain não deve depender de:

- Flutter.
- Riverpod.
- SDKs de serviços de nuvem.
- Bibliotecas específicas de banco de dados.
- Implementações concretas de infraestrutura.

O domínio deve continuar funcionando independentemente do fornecedor escolhido para armazenamento.

### 4.4 Data

Responsável pela comunicação com fontes externas de dados e pela implementação dos contratos definidos no Domain.

Contém:

- Data Sources.
- Models/DTOs.
- Implementações de repositórios.
- Conversões entre dados externos e entidades.

Exemplos:

| Componente | Responsabilidade |
|---|---|
| `LostFoundRemoteDataSource` | Comunicar-se com o serviço remoto |
| `LostFoundItemModel` | Representar e converter os dados externos |
| `LostFoundRepositoryImpl` | Implementar o contrato do repositório |

O SDK do serviço de nuvem, quando escolhido, deverá permanecer isolado nesta camada.

A troca do fornecedor não deverá exigir alterações na interface ou nas regras centrais do negócio.

## 5. Direção das dependências

As dependências devem respeitar a inversão de dependência.

Representação conceitual:

```text
        PRESENTATION
              |
              v
         APPLICATION
              |
              v
           DOMAIN
              ^
              |
            DATA
```

A camada Data implementa os contratos definidos no Domain.

O Domain não conhece a Data.

A Presentation não deve depender diretamente de implementações concretas de infraestrutura.

A composição das dependências será realizada pelo Riverpod.

Essa organização permite substituir a implementação de persistência sem modificar os casos de uso ou os componentes visuais.

## 6. Fluxo de funcionamento

### 6.1 Recuperação dos registros

O fluxo esperado para carregar a listagem é:

1. O usuário acessa a tela de listagem.
2. A Presentation observa o provider responsável pelos registros.
3. O provider executa o caso de uso `GetLostFoundItems`.
4. O caso de uso chama o contrato `LostFoundRepository`.
5. A implementação concreta do repositório solicita os dados ao data source.
6. O data source realiza a consulta ao serviço de nuvem.
7. Os dados recebidos são convertidos em entidades `LostFoundItem`.
8. O resultado retorna ao provider.
9. A interface apresenta os registros.

A interface deverá representar adequadamente os estados:

- Carregamento.
- Erro.
- Dados disponíveis.
- Lista vazia.

### 6.2 Cadastro de um registro

O fluxo esperado para cadastrar um objeto é:

1. O usuário acessa a tela de cadastro.
2. Preenche nome, descrição, local e situação.
3. A Presentation valida os campos.
4. O provider responsável pelo cadastro inicia a operação.
5. O caso de uso `CreateLostFoundItem` é executado.
6. O caso de uso utiliza o contrato do repositório.
7. O repositório solicita a gravação ao data source.
8. O serviço remoto persiste o registro.
9. O resultado retorna à aplicação.
10. Em caso de sucesso, a listagem é atualizada.
11. A interface informa o resultado ao usuário.

O envio deverá ser bloqueado enquanto uma gravação estiver em andamento, evitando registros duplicados causados por múltiplos toques.

A aplicação não deve informar sucesso antes da confirmação da operação remota.

## 7. Gerenciamento de estado

O gerenciamento de estado será realizado com **Riverpod**.

Sua utilização será destinada principalmente a:

- Compartilhamento de dados entre widgets.
- Operações assíncronas.
- Estado da listagem.
- Estado de envio do formulário.
- Injeção de dependências.

Estados puramente visuais e locais deverão permanecer nos próprios widgets quando não houver necessidade de compartilhamento.

Exemplos:

| Situação | Gerenciamento |
|---|---|
| Dados da listagem | Riverpod |
| Carregamento da listagem | Riverpod |
| Erro na consulta | Riverpod |
| Envio do formulário | Riverpod |
| Controle de um menu expandido | Estado local |
| `TextEditingController` | Estado local |

A listagem deverá utilizar um provider assíncrono, como `FutureProvider`.

O cadastro deverá utilizar um notifier assíncrono, como `AsyncNotifier`.

Após um cadastro bem-sucedido, a listagem deverá ser invalidada ou atualizada para refletir o novo registro.

As regras detalhadas estão documentadas em `STATE_MANAGEMENT.md`.

## 8. Navegação

A navegação utilizará o **Navigator 1.0 nativo do Flutter**.

Essa escolha prioriza simplicidade e adequação ao tamanho atual do projeto.

As rotas deverão ser organizadas centralmente em `app_router.dart`, evitando espalhar configurações de navegação por diferentes componentes.

Não adicionar bibliotecas externas de navegação sem uma necessidade concreta e aprovação da equipe.

## 9. Interface e apresentação visual

A interface utilizará **Material 3**, conforme exigido pelos requisitos do projeto.

Diretrizes:

- Textos apresentados ao usuário em português.
- Layout responsivo.
- Componentes visualmente consistentes.
- Identificação clara de objetos perdidos e encontrados.
- Indicadores de carregamento durante operações assíncronas.
- Mensagens compreensíveis em caso de falha.
- Controles acessíveis e sem overflow.

A apresentação visual deverá priorizar clareza e facilidade de utilização, sem adicionar funcionalidades que não façam parte do escopo.

## 10. Tratamento de erros

Falhas de comunicação e persistência devem ser tratadas adequadamente.

A aplicação deverá:

- Informar quando uma operação estiver em andamento.
- Apresentar mensagens claras em português.
- Permitir nova tentativa quando apropriado.
- Evitar exibir detalhes técnicos ou stack traces ao usuário.
- Não interpretar uma falha de comunicação como uma lista vazia.
- Não apresentar sucesso quando a gravação não tiver sido confirmada.

Os detalhes técnicos deverão permanecer disponíveis para diagnóstico durante o desenvolvimento, sem exposição de credenciais ou informações sensíveis.

## 11. Persistência e serviço de nuvem

A escolha do serviço de nuvem está aprovada em [`DATABASE.md`](./DATABASE.md) (CARD-002): **Firebase Firestore**, plano Spark (gratuito).

A solução selecionada atende aos seguintes requisitos:

- Plano exclusivamente gratuito compatível com a avaliação.
- Persistência dos registros após o encerramento da aplicação.
- Compartilhamento dos registros entre diferentes instalações.
- Leitura e gravação assíncronas.
- Acesso sem autenticação de usuário.
- Configuração reproduzível pelo avaliador.

A arquitetura deverá manter o acesso remoto isolado na camada Data.

### 11.1 Data e hora

A data/hora de criação será gerada automaticamente e não poderá ser informada pelo usuário.

A estratégia aprovada é `FieldValue.serverTimestamp()`, que gera o horário no servidor Firestore (`DATABASE.md`).

### 11.2 Segurança

A ausência de autenticação não significa ausência de controle de acesso.

A configuração deverá permitir somente as operações necessárias ao aplicativo, evitando permissões administrativas ou irrestritas.

Credenciais privadas e segredos administrativos nunca deverão ser incluídos no repositório ou no código distribuído.

## 12. Testes e validação

O projeto não terá testes automatizados.

Não serão implementados:

- Testes unitários.
- Testes de widgets.
- Testes de integração automatizados.
- Infraestrutura de execução de testes automatizados.

A validação será realizada manualmente, seguindo os critérios definidos nos cartões Kanban.

Entre os cenários que deverão ser verificados estão:

- Cadastro válido.
- Validação de campos obrigatórios.
- Limites de caracteres.
- Situação permitida.
- Bloqueio de envios repetidos.
- Recuperação dos registros.
- Ordenação por data decrescente.
- Atualização da listagem.
- Estados de carregamento, erro e sucesso.
- Falhas de comunicação e nova tentativa.
- Persistência após fechar e reabrir o aplicativo.
- Compartilhamento dos registros entre instalações.

Além da validação manual, deverão ser executados:

```bash
dart format .
flutter analyze
```

O código deverá estar formatado e sem problemas de análise introduzidos pela equipe.

## 13. Princípios de implementação

Todos os integrantes e agentes de IA deverão respeitar as seguintes diretrizes:

1. Seguir a arquitetura Feature-First com Clean Architecture simplificada.
2. Aplicar SOLID e Separation of Concerns de maneira pragmática.
3. Manter o Domain independente de infraestrutura.
4. Utilizar contratos para abstrair o acesso aos dados.
5. Utilizar Riverpod para estado compartilhado e injeção de dependências.
6. Evitar duplicação de código.
7. Não criar abstrações sem necessidade concreta.
8. Não adicionar dependências sem justificativa.
9. Não implementar funcionalidades fora do escopo aprovado.
10. Não presumir decisões ainda pendentes.
11. Preservar a simplicidade e a legibilidade do projeto.
12. Consultar os cartões Kanban antes de implementar funcionalidades.

## 14. Referências complementares

Os documentos abaixo detalham aspectos específicos desta arquitetura:

- `FOLDER_STRUCTURE.md`: estrutura de diretórios.
- `DESIGN_PATTERNS.md`: padrões de projeto e princípios adotados.
- `STATE_MANAGEMENT.md`: gerenciamento de estado com Riverpod.
- `DATA_LAYER.md`: organização e responsabilidades da camada Data.
- `DATABASE.md`: requisitos de persistência e decisões de infraestrutura aprovadas.
- `CODING_STANDARDS.md`: convenções de código e qualidade.
- `AI_AGENTS.md`: instruções para agentes de inteligência artificial.

Este documento deve ser atualizado sempre que uma decisão arquitetural for alterada ou uma decisão pendente for aprovada.
