# Padrões de Código — Reencontrapp

## 1. Objetivo

Este documento define os padrões de desenvolvimento que deverão ser seguidos durante a implementação e manutenção do Reencontrapp.

Os objetivos são:

- Manter consistência entre os arquivos.
- Facilitar a leitura e compreensão do código.
- Reduzir duplicação e acoplamento.
- Incentivar boas práticas de desenvolvimento.
- Preservar a arquitetura aprovada.
- Facilitar a colaboração entre os integrantes e agentes de IA.
- Garantir qualidade técnica sem introduzir complexidade desnecessária.

Todos os integrantes da equipe deverão seguir estas convenções.

## 2. Tecnologias e ferramentas

O projeto utilizará:

| Tecnologia | Finalidade |
|---|---|
| Flutter | Framework de desenvolvimento |
| Dart | Linguagem de programação |
| Riverpod | Gerenciamento de estado e injeção de dependências |
| Material 3 | Sistema de componentes visuais |
| Navigator 1.0 | Navegação |
| Git | Controle de versão |

As versões deverão ser compatíveis com as configurações existentes no projeto.

Não atualizar dependências ou introduzir ferramentas sem necessidade concreta.

## 3. Convenções de nomenclatura

Os identificadores técnicos deverão permanecer em inglês.

### 3.1 Arquivos e diretórios

Utilizar `snake_case`.

Exemplos:

```text
lost_found_item.dart
lost_found_repository.dart
item_list_page.dart
create_item_provider.dart
data_sources/
```

Os nomes deverão indicar claramente a responsabilidade do arquivo ou diretório.

### 3.2 Classes e enums

Utilizar `UpperCamelCase`.

Exemplos:

```dart
class LostFoundItem {}

class LostFoundRepositoryImpl {}

enum ItemStatus {
  lost,
  found,
}
```

### 3.3 Métodos e funções

Utilizar `lowerCamelCase`.

Exemplos:

```dart
Future<List<LostFoundItem>> getAll();

Future<void> createItem(LostFoundItem item);
```

Os nomes deverão representar claramente a ação executada.

### 3.4 Variáveis e parâmetros

Utilizar `lowerCamelCase`.

Exemplos:

```dart
final createdAt = DateTime.now();

final itemList = <LostFoundItem>[];
```

Evitar abreviações sem significado evidente.

### 3.5 Constantes

Seguir a convenção Dart para identificadores constantes, utilizando `lowerCamelCase`.

Exemplo:

```dart
const maxNameLength = 60;
const maxDescriptionLength = 200;
```

### 3.6 Textos apresentados ao usuário

Todos os textos visíveis na interface deverão estar em português.

Exemplos:

- Cadastrar objeto.
- Objeto perdido.
- Objeto encontrado.
- Nenhum registro encontrado.
- Não foi possível carregar os registros.

Não misturar idiomas na interface.

## 4. Organização e arquitetura

A organização deverá seguir Feature-First com Clean Architecture simplificada.

As camadas aprovadas são:

- `domain/`
- `application/`
- `data/`
- `presentation/`

Cada arquivo deverá permanecer na camada correspondente à sua responsabilidade.

### 4.1 Domain

Responsável pelas regras e conceitos fundamentais do negócio.

Regras:

- Não depender de Flutter.
- Não depender de Riverpod.
- Não depender de SDKs ou APIs de serviços externos.
- Não conter detalhes de persistência.
- Definir contratos necessários à aplicação.

### 4.2 Application

Responsável pelos casos de uso.

Regras:

- Implementar operações da aplicação.
- Coordenar as chamadas aos contratos do Domain.
- Não depender de widgets.
- Não realizar consultas diretamente ao serviço de nuvem.

### 4.3 Data

Responsável pelo acesso e transformação dos dados.

Regras:

- Implementar os contratos definidos no Domain.
- Isolar a comunicação com serviços externos.
- Realizar conversões entre Models e Entities.
- Tratar detalhes específicos da persistência.

### 4.4 Presentation

Responsável pela interface e interação com o usuário.

Regras:

- Utilizar Material 3.
- Observar os estados disponibilizados pelo Riverpod.
- Encaminhar ações aos providers e casos de uso conforme a arquitetura.
- Não acessar diretamente o banco de dados.
- Não concentrar regras de negócio nos widgets.

### 4.5 Princípio geral

Uma camada não deverá assumir responsabilidades pertencentes a outra.

Antes de adicionar lógica a um arquivo, verificar se ela realmente pertence àquela camada.

## 5. Boas práticas de Dart

### 5.1 Null safety

Utilizar corretamente o sistema de null safety do Dart.

Regras:

- Evitar tipos anuláveis sem necessidade.
- Tratar valores nulos explicitamente.
- Não utilizar o operador `!` sem justificativa.
- Preferir valores obrigatórios quando fizerem parte do contrato.

Evitar soluções que apenas ocultem possíveis erros de nulidade.

### 5.2 Imutabilidade

Preferir `final` para variáveis que não precisam ser reatribuídas.

Utilizar `const` quando possível.

Exemplo:

```dart
final item = LostFoundItem(
  name: 'Mochila',
  description: 'Mochila preta',
  location: 'Biblioteca',
  status: ItemStatus.lost,
);
```

Evitar mutabilidade desnecessária nas entidades de domínio.

### 5.3 Tipagem

Evitar o uso de `dynamic` sem necessidade.

Preferir tipos explícitos e contratos bem definidos.

Exemplo:

```dart
Future<List<LostFoundItem>> getAll();
```

Evitar assinaturas genéricas que dificultem compreender o resultado de uma operação.

### 5.4 Funções e métodos

Cada função deverá possuir uma responsabilidade clara.

Regras:

- Evitar métodos excessivamente longos.
- Evitar parâmetros desnecessários.
- Evitar efeitos colaterais inesperados.
- Utilizar nomes que expressem a finalidade da operação.
- Extrair métodos auxiliares quando isso melhorar a legibilidade.

Não fragmentar operações simples em dezenas de métodos sem benefício real.

### 5.5 Tratamento de exceções

Utilizar tratamento de exceções de acordo com a responsabilidade da camada.

Regras:

- Não ignorar exceções silenciosamente.
- Não utilizar blocos `catch` vazios.
- Não substituir falhas por resultados aparentemente válidos.
- Preservar informações úteis para diagnóstico.
- Não apresentar detalhes técnicos internos diretamente ao usuário.

Uma falha na recuperação dos registros, por exemplo, não deverá ser convertida em uma lista vazia.

## 6. Boas práticas de Flutter

### 6.1 Widgets

Cada widget deverá possuir uma responsabilidade visual ou de interação bem definida.

Regras:

- Preferir widgets pequenos e reutilizáveis quando necessário.
- Evitar páginas com toda a interface concentrada em um único método `build`.
- Utilizar `const` quando possível.
- Evitar reconstruções desnecessárias.
- Separar componentes reutilizáveis de acordo com sua responsabilidade.

Não criar um widget separado para cada elemento visual trivial.

### 6.2 Interface

A aplicação deverá seguir Material 3.

Regras:

- Manter consistência visual.
- Utilizar o tema global.
- Respeitar espaçamentos e hierarquia visual.
- Garantir legibilidade.
- Evitar elementos visualmente inconsistentes.
- Utilizar componentes adequados ao contexto.

### 6.3 Responsividade

A interface deverá funcionar em diferentes dimensões de tela.

Regras:

- Evitar dimensões fixas sem necessidade.
- Utilizar constraints e layouts adaptáveis.
- Evitar overflow horizontal e vertical.
- Garantir que campos e botões permaneçam acessíveis.
- Verificar o comportamento do teclado durante o preenchimento do formulário.

### 6.4 Acessibilidade e usabilidade

Os componentes deverão apresentar informações compreensíveis.

Regras:

- Utilizar textos claros.
- Manter contraste adequado.
- Não depender exclusivamente de cores para comunicar estados.
- Garantir áreas de interação adequadas.
- Apresentar feedback após operações importantes.

## 7. Programação assíncrona

As operações de leitura e gravação na nuvem deverão ser assíncronas.

Utilizar `async` e `await` para manter o fluxo compreensível.

Exemplo:

```dart
Future<List<LostFoundItem>> getItems() async {
  final items = await dataSource.getAll();

  return items;
}
```

Regras:

1. Não executar operações de rede de forma síncrona.
2. Não bloquear a interface durante operações remotas.
3. Tratar falhas de comunicação.
4. Apresentar indicadores de carregamento.
5. Impedir envios simultâneos.
6. Permitir novas tentativas após falhas.
7. Não ignorar Futures sem justificativa.

A interface deverá apresentar os estados de carregamento, sucesso e erro conforme definido em `STATE_MANAGEMENT.md`.

## 8. Gerenciamento de estado

Utilizar exclusivamente Riverpod como solução de gerenciamento de estado compartilhado.

Regras:

- Manter providers na estrutura definida para a feature.
- Utilizar estado local para informações exclusivamente visuais.
- Utilizar providers para operações assíncronas e estados compartilhados.
- Delegar operações aos casos de uso.
- Evitar duplicação de fontes de verdade.
- Atualizar a listagem após um cadastro bem-sucedido.
- Não introduzir outro gerenciador de estado.

A implementação deverá respeitar `STATE_MANAGEMENT.md`.

## 9. Padrões de projeto

Os padrões aprovados são:

- Repository Pattern.
- Use Case Pattern.
- Dependency Injection via Riverpod.
- DTO/Model para conversão de dados externos.

Aplicar SOLID e Separation of Concerns de maneira proporcional ao projeto.

Não introduzir padrões adicionais sem uma necessidade concreta.

Evitar especialmente:

- Factories genéricas sem necessidade.
- Service Locator.
- Singleton manual para dependências gerenciadas pelo Riverpod.
- CQRS.
- Event Bus.
- Mediator.
- Unit of Work.
- Classes base genéricas para casos de uso simples.

Consultar `DESIGN_PATTERNS.md` antes de introduzir novas abstrações.

## 10. Validação de dados

As regras de validação deverão respeitar os requisitos funcionais.

Para o cadastro:

| Campo | Regra |
|---|---|
| Nome | Obrigatório, máximo de 60 caracteres |
| Descrição | Obrigatória, máximo de 200 caracteres |
| Local | Obrigatório |
| Situação | Somente perdido ou encontrado |

Regras adicionais:

- Validar antes de enviar os dados.
- Não aceitar campos obrigatórios vazios ou compostos apenas por espaços.
- Apresentar mensagens claras em português.
- Não depender exclusivamente da validação visual.
- Preservar as regras de integridade também na camada apropriada da aplicação.

Não adicionar restrições de negócio que não estejam nos requisitos aprovados sem autorização.

## 11. Dependências e bibliotecas

Toda dependência externa deverá possuir justificativa.

Antes de adicionar uma biblioteca:

1. Verificar se o Flutter ou Dart já oferecem a funcionalidade.
2. Verificar se uma dependência existente atende à necessidade.
3. Avaliar o impacto na complexidade do projeto.
4. Verificar compatibilidade com a versão atual do Flutter e Dart.
5. Atualizar a documentação quando a dependência afetar a arquitetura.

Não adicionar pacotes apenas por conveniência quando uma solução nativa simples for suficiente.

Não atualizar indiscriminadamente todas as dependências.

## 12. Comentários e documentação do código

O código deverá ser compreensível principalmente por meio de nomes expressivos e organização adequada.

Comentários deverão ser utilizados para explicar:

- Decisões não óbvias.
- Regras específicas.
- Limitações técnicas.
- Comportamentos que não podem ser compreendidos apenas pela implementação.

Evitar comentários que apenas repetem o código.

Exemplo inadequado:

```dart
// Incrementa o contador.
counter++;
```

Comentários não deverão ser utilizados como substitutos de código organizado.

## 13. Padrões de formatação e análise

Antes de considerar uma implementação concluída, executar:

```bash
dart format .
flutter analyze
```

### 13.1 `dart format .`

Responsável por aplicar a formatação oficial do Dart ao projeto.

Não manter arquivos deliberadamente fora do padrão de formatação.

### 13.2 `flutter analyze`

Responsável por verificar problemas estáticos no código Flutter/Dart.

O objetivo é concluir a implementação sem erros ou avisos introduzidos pelas alterações.

Caso existam problemas anteriores às alterações, identificá-los separadamente e não afirmar que foram corrigidos sem validação.

Não desabilitar regras do analisador apenas para ocultar problemas.

## 14. Testes e validação manual

Conforme decisão aprovada pela equipe, o projeto não implementará testes automatizados.

Portanto, não criar:

- Testes unitários.
- Testes de widgets.
- Testes de integração.
- Mocks destinados a testes automatizados.
- Estruturas de testes automatizados.
- Dependências utilizadas exclusivamente para testes.

A validação será realizada manualmente.

### 14.1 Checklist de validação

**Listagem**

- [ ] Os registros são recuperados da nuvem.
- [ ] Os registros aparecem em ordem decrescente de data.
- [ ] Os campos são apresentados corretamente.
- [ ] Perdidos e encontrados são diferenciados.
- [ ] A lista vazia é apresentada corretamente.
- [ ] A atualização manual funciona.
- [ ] Falhas apresentam mensagens compreensíveis.
- [ ] É possível tentar novamente após uma falha.

**Cadastro**

- [ ] Nome obrigatório.
- [ ] Nome limitado a 60 caracteres.
- [ ] Descrição obrigatória.
- [ ] Descrição limitada a 200 caracteres.
- [ ] Local obrigatório.
- [ ] Situação limitada a perdido ou encontrado.
- [ ] Dados inválidos não são enviados.
- [ ] O botão apresenta carregamento durante o envio.
- [ ] Envios simultâneos são impedidos.
- [ ] O cadastro bem-sucedido aparece na listagem.

**Persistência e nuvem**

- [ ] Os registros permanecem após reiniciar a aplicação.
- [ ] Os registros cadastrados em uma instalação aparecem em outra.
- [ ] O acesso funciona sem autenticação de usuário.
- [ ] As permissões remotas respeitam o escopo da aplicação.

**Interface**

- [ ] A aplicação apresenta Material 3.
- [ ] Os textos estão em português.
- [ ] A interface funciona em diferentes dimensões de tela.
- [ ] Não existem problemas de overflow.
- [ ] Os estados de carregamento, erro e vazio são apresentados corretamente.

**Qualidade**

- [ ] `dart format .` executado.
- [ ] `flutter analyze` executado.
- [ ] README atualizado quando necessário.
- [ ] Nenhum segredo ou artefato proibido foi versionado.

A equipe deverá registrar honestamente quais verificações foram executadas e quais ainda estão pendentes.

## 15. Controle de versão

O Git será utilizado para manter o histórico de desenvolvimento.

### 15.1 Commits

Os commits deverão:

- Possuir mensagens claras.
- Representar alterações coerentes.
- Evitar agrupar mudanças sem relação.
- Permitir identificar o propósito da implementação.

Exemplos:

```text
feat: add lost and found item listing
feat: implement item registration
fix: handle remote loading errors
style: improve item card layout
docs: update architecture documentation
```

As mensagens de commit poderão seguir o padrão Conventional Commits.

### 15.2 Arquivos que não devem ser versionados

Não versionar:

- Diretórios de build.
- APK, AAB, IPA e outros binários.
- Arquivos temporários.
- Configurações privadas locais.
- Chaves privadas.
- Senhas.
- Tokens secretos.
- Credenciais administrativas.
- Arquivos gerados que não sejam necessários ao projeto.

Arquivos de configuração pública exigidos para execução poderão ser versionados quando não expuserem segredos e forem necessários à avaliação.

## 16. Segurança

Mesmo sem autenticação de usuário, o projeto deverá respeitar princípios básicos de segurança.

Regras:

1. Não incluir segredos privados no código-fonte.
2. Não expor credenciais administrativas.
3. Configurar permissões remotas com o menor privilégio possível.
4. Permitir somente as operações necessárias ao escopo.
5. Não confiar exclusivamente na validação da interface.
6. Evitar exposição de informações técnicas em mensagens ao usuário.
7. Documentar os parâmetros necessários para configurar o serviço de nuvem.

O acesso sem autenticação não significa permitir operações irrestritas sobre os dados.

## 17. Restrições de escopo

O desenvolvimento deverá permanecer limitado aos requisitos aprovados.

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

Não adicionar funcionalidades apenas porque são tecnicamente possíveis.

Qualquer ampliação do escopo deverá ser discutida e aprovada pela equipe.

## 18. Regras para agentes de IA

Os agentes de IA que participarem do desenvolvimento deverão:

1. Ler a documentação arquitetural antes de realizar alterações relevantes.
2. Inspecionar a estrutura e o código existente antes de editar.
3. Respeitar as decisões aprovadas.
4. Não presumir decisões ainda pendentes.
5. Implementar somente o escopo solicitado.
6. Evitar refatorações não relacionadas à tarefa.
7. Não introduzir dependências sem justificativa.
8. Não criar testes automatizados.
9. Executar `dart format .` e `flutter analyze` após alterações relevantes.
10. Informar os arquivos modificados.
11. Informar os comandos executados e seus resultados.
12. Apontar pendências e limitações encontradas.
13. Não afirmar que uma validação foi realizada quando não foi executada.
14. Não executar operações Git destrutivas sem autorização.
15. Não descartar alterações de outros integrantes da equipe.

Em caso de conflito entre a solicitação atual e uma decisão arquitetural documentada, o agente deverá apontar o conflito antes de realizar alterações que possam comprometer a arquitetura.

As instruções completas para agentes estão em `AI_AGENTS.md`.

## 19. Referências

- `README.md`: visão geral da documentação.
- `ARCHITECTURE.md`: arquitetura geral.
- `FOLDER_STRUCTURE.md`: organização dos diretórios.
- `DESIGN_PATTERNS.md`: padrões de projeto.
- `STATE_MANAGEMENT.md`: gerenciamento de estado.
- `DATA_LAYER.md`: camada de dados.
- `DATABASE.md`: requisitos e decisões de persistência.
- `AI_AGENTS.md`: instruções para agentes de IA.

Este documento estabelece os padrões oficiais de desenvolvimento do Reencontrapp. Alterações relevantes deverão ser aprovadas pela equipe e refletidas na documentação.