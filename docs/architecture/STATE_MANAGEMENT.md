# Gerenciamento de Estado — Reencontrapp

## 1. Objetivo

Este documento define as diretrizes para o gerenciamento de estado do Reencontrapp, desenvolvido com Flutter e Dart.

O projeto utilizará **Riverpod** como solução de gerenciamento de estado.

Os principais objetivos são:

- Centralizar o gerenciamento de estados compartilhados.
- Separar a interface das operações da aplicação.
- Controlar corretamente operações assíncronas.
- Manter a interface sincronizada com os dados.
- Evitar duplicação de lógica.
- Garantir um fluxo previsível de atualização dos dados.

A implementação deverá ser proporcional à complexidade do projeto, evitando abstrações desnecessárias.

## 2. Tecnologia adotada

**Riverpod** será utilizado para:

- Disponibilizar dependências da aplicação.
- Gerenciar estados assíncronos.
- Controlar a recuperação dos registros.
- Controlar o envio de novos registros.
- Atualizar os dados após operações de cadastro.

A versão e a API utilizadas deverão ser compatíveis com as dependências declaradas no `pubspec.yaml`.

Não introduzir outra biblioteca de gerenciamento de estado.

## 3. Organização dos providers

Os providers relacionados à funcionalidade principal deverão permanecer em:

```text
lib/
└── features/
    └── lost_found/
        └── presentation/
            └── providers/
                ├── item_list_provider.dart
                └── create_item_provider.dart
```

Responsabilidades:

| Provider | Responsabilidade |
|---|---|
| `itemListProvider` | Recuperar e disponibilizar os registros |
| Provider de cadastro | Controlar o envio de novos registros |

Os nomes e tipos concretos poderão seguir a API da versão do Riverpod instalada, desde que as responsabilidades sejam preservadas.

## 4. Classificação dos estados

O gerenciamento de estado será dividido em duas categorias.

### 4.1 Estado local da interface

Representa informações temporárias utilizadas exclusivamente por um widget ou página.

Exemplos:

- Conteúdo digitado nos campos do formulário.
- Visibilidade de menus.
- Estado de expansão de componentes.
- Controle de foco.
- Seleções temporárias da interface.

Esses estados deverão permanecer nos próprios widgets sempre que não houver necessidade de compartilhamento.

Não utilizar Riverpod para estados simples que podem ser resolvidos localmente.

### 4.2 Estado compartilhado ou assíncrono

Representa informações utilizadas por diferentes componentes ou relacionadas às operações da aplicação.

Exemplos:

- Registros recuperados da nuvem.
- Carregamento da listagem.
- Falhas na recuperação dos registros.
- Envio de um novo registro.
- Resultado do cadastro.

Esses estados deverão ser gerenciados pelo Riverpod.

## 5. Gerenciamento da listagem

A recuperação dos registros será controlada por um provider assíncrono.

A abordagem prevista é utilizar `FutureProvider<List<LostFoundItem>>`.

Responsabilidades:

1. Executar o caso de uso de recuperação.
2. Disponibilizar os registros para a interface.
3. Controlar os estados de carregamento, sucesso e erro.
4. Permitir a atualização dos dados quando necessário.

### 5.1 Estados da listagem

A interface deverá tratar os estados disponibilizados pelo Riverpod.

| Estado | Comportamento esperado |
|---|---|
| `loading` | Apresentar indicador de carregamento |
| `error` | Apresentar mensagem de erro e opção de tentar novamente |
| `data` com lista vazia | Apresentar mensagem informando que não existem registros |
| `data` com registros | Apresentar a listagem |

A lista vazia deverá ser considerada um resultado válido, e não uma falha.

### 5.2 Exemplo conceitual

```dart
final itemListProvider = FutureProvider<List<LostFoundItem>>((ref) async {
  final getItems = ref.watch(getLostFoundItemsProvider);

  return getItems();
});
```

O provider de caso de uso apresentado é conceitual. Sua implementação deverá respeitar a composição de dependências definida na arquitetura do projeto.

Na interface, o estado deverá ser observado por meio de `ref.watch`.

Exemplo:

```dart
final itemsAsync = ref.watch(itemListProvider);

return itemsAsync.when(
  loading: () => const CircularProgressIndicator(),
  error: (error, stackTrace) => const Text(
    'Não foi possível carregar os registros.',
  ),
  data: (items) {
    if (items.isEmpty) {
      return const Text('Nenhum registro encontrado.');
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ItemCard(item: items[index]);
      },
    );
  },
);
```

O exemplo demonstra o fluxo esperado. A implementação visual deverá seguir o tema e os componentes definidos no projeto.

### 5.3 Atualização da listagem

A listagem deverá permitir atualização manual.

Também deverá ser atualizada automaticamente após o cadastro bem-sucedido de um registro.

Para isso, poderá ser utilizado:

```dart
ref.invalidate(itemListProvider);
```

A invalidação fará com que os dados sejam recuperados novamente quando o provider for observado.

Não manter cópias independentes da mesma listagem em diferentes widgets.

## 6. Gerenciamento do cadastro

O envio de novos registros será controlado por um `AsyncNotifier` ou abordagem equivalente compatível com a versão do Riverpod instalada.

Sua responsabilidade será:

1. Receber os dados validados do formulário.
2. Executar o caso de uso de cadastro.
3. Controlar o estado do envio.
4. Impedir operações simultâneas.
5. Propagar falhas para a interface.
6. Solicitar a atualização da listagem após o sucesso.

### 6.1 Estados do cadastro

| Estado | Comportamento esperado |
|---|---|
| `AsyncData` inicial | Formulário disponível |
| `AsyncLoading` | Envio em andamento |
| `AsyncData` após sucesso | Cadastro concluído |
| `AsyncError` | Apresentar mensagem de falha |

O estado de envio deverá ser independente do estado da listagem.

Uma falha no cadastro não deverá apagar ou substituir os registros já carregados.

### 6.2 Prevenção de envios duplicados

Durante o envio:

- Desabilitar o botão de cadastro.
- Apresentar indicador de carregamento.
- Impedir novas chamadas simultâneas ao caso de uso.
- Não permitir que múltiplos toques gerem registros duplicados.

A proteção deverá existir também na lógica do provider, e não apenas visualmente no botão.

### 6.3 Atualização após cadastro

Quando o cadastro for concluído com sucesso:

1. O provider de cadastro deverá concluir a operação.
2. A listagem deverá ser invalidada.
3. Os registros deverão ser recuperados novamente.
4. A interface deverá apresentar o novo registro após a atualização.

A navegação de retorno à listagem deverá ocorrer conforme o fluxo da interface, sem acoplar a lógica de navegação ao repositório ou ao caso de uso.

Em caso de falha, o usuário deverá permanecer em condições de corrigir os dados ou tentar novamente.

## 7. Injeção de dependências

O Riverpod também será utilizado para disponibilizar as dependências necessárias à aplicação.

O fluxo esperado será:

```text
Presentation
     |
     v
   Provider
     |
     v
  Use Case
     |
     v
 Repository Contract
     ^
     |
Repository Implementation
     |
     v
  Data Source
     |
     v
 Remote Service
```

Os providers deverão compor as dependências necessárias, respeitando a direção de dependência definida em `ARCHITECTURE.md`.

Responsabilidades:

- Disponibilizar implementações concretas dos repositórios.
- Disponibilizar os casos de uso.
- Disponibilizar os providers de estado.
- Evitar instanciação manual e repetida de dependências nos widgets.

A configuração concreta do Data Source dependerá do serviço de nuvem escolhido.

## 8. Uso de `ref.watch` e `ref.read`

Os métodos deverão ser utilizados conforme sua finalidade.

### 8.1 `ref.watch`

Utilizar quando um componente ou provider precisa acompanhar alterações de uma dependência.

Exemplos:

- Observar a listagem.
- Observar o estado do cadastro.
- Acompanhar uma dependência reativa.

### 8.2 `ref.read`

Utilizar quando for necessário acessar uma dependência sem estabelecer uma observação reativa.

Exemplos:

- Executar uma operação após o toque em um botão.
- Invocar uma ação de cadastro.
- Executar uma atualização manual.

Não utilizar `ref.read` indiscriminadamente para substituir observações reativas necessárias.

## 9. Tratamento de erros

Os erros deverão ser tratados de maneira compreensível para o usuário.

A interface não deverá apresentar:

- Stack traces.
- Mensagens técnicas internas.
- Detalhes de implementação do serviço de nuvem.
- Informações sensíveis de configuração.

Exemplos de mensagens:

| Situação | Mensagem |
|---|---|
| Falha ao carregar registros | Não foi possível carregar os registros. Tente novamente. |
| Falha ao cadastrar | Não foi possível cadastrar o registro. Tente novamente. |
| Falha de conexão | Não foi possível conectar ao serviço. Verifique sua conexão. |
| Cadastro concluído | Registro cadastrado com sucesso. |

As mensagens deverão refletir a falha real sempre que possível.

O tratamento de exceções deverá ocorrer nas camadas apropriadas. A interface deverá apresentar mensagens amigáveis sem assumir responsabilidades de infraestrutura.

## 10. Atualização manual e recuperação

O usuário deverá conseguir solicitar uma nova recuperação dos registros após uma falha ou quando desejar atualizar a listagem.

A implementação poderá utilizar a invalidação do provider ou o mecanismo de atualização assíncrona disponibilizado pela versão instalada do Riverpod.

Regras:

- Não apresentar uma lista vazia como se a recuperação tivesse sido bem-sucedida quando ocorreu uma falha.
- Não descartar dados válidos sem necessidade.
- Exibir o estado de carregamento durante a atualização.
- Permitir novas tentativas após falhas.
- Manter o comportamento consistente com a atualização após cadastro.

## 11. Regras de implementação

Todos os integrantes e agentes de IA deverão seguir estas regras:

1. Utilizar Riverpod como solução de gerenciamento de estado.
2. Manter providers dentro da estrutura definida para cada feature.
3. Utilizar estado local para informações exclusivamente visuais.
4. Utilizar providers para estados compartilhados e operações assíncronas.
5. Não executar consultas ao serviço de nuvem diretamente nos widgets.
6. Não colocar regras de negócio dentro dos providers.
7. Delegar operações aos casos de uso.
8. Evitar duplicação de estados e fontes de verdade.
9. Tratar explicitamente carregamento, sucesso e erro.
10. Impedir envios simultâneos de registros.
11. Atualizar a listagem após um cadastro bem-sucedido.
12. Não introduzir outro gerenciador de estado.
13. Não adicionar code generation sem necessidade concreta.
14. Utilizar a API compatível com a versão do Riverpod instalada.
15. Não criar abstrações genéricas apenas para padronizar operações simples.

## 12. Restrições de escopo

O gerenciamento de estado atual deverá atender somente às funcionalidades aprovadas:

- Recuperação da listagem de objetos.
- Atualização da listagem.
- Cadastro de objetos.
- Controle dos estados assíncronos.
- Tratamento de falhas.

Não implementar antecipadamente gerenciamento de estado para:

- Autenticação.
- Perfil de usuário.
- Edição de registros.
- Exclusão de registros.
- Notificações.
- Chat.
- Pesquisa avançada.
- Upload de imagens.

Essas funcionalidades não fazem parte do escopo aprovado.

## 13. Validação

O projeto não implementará testes automatizados, conforme decisão aprovada pela equipe.

A validação do gerenciamento de estado será realizada manualmente, verificando:

- Carregamento inicial da listagem.
- Apresentação de uma lista vazia.
- Apresentação dos registros recuperados.
- Atualização manual da listagem.
- Comportamento durante falhas de conexão.
- Recuperação após uma falha.
- Validação dos campos antes do cadastro.
- Indicador de carregamento durante o envio.
- Bloqueio de envios simultâneos.
- Atualização da listagem após cadastro.
- Persistência dos registros após reiniciar a aplicação.

Também deverão ser executados:

```bash
dart format .
flutter analyze
```

## 14. Referências

- `ARCHITECTURE.md`: arquitetura geral da aplicação.
- `FOLDER_STRUCTURE.md`: organização dos diretórios.
- `DESIGN_PATTERNS.md`: padrões de projeto.
- `DATA_LAYER.md`: implementação da camada de dados.
- `DATABASE.md`: requisitos e decisões de persistência.
- `CODING_STANDARDS.md`: padrões de código.
- `AI_AGENTS.md`: instruções para agentes de IA.

Este documento estabelece as diretrizes oficiais de gerenciamento de estado do Reencontrapp. Alterações relevantes deverão ser documentadas e aprovadas pela equipe.