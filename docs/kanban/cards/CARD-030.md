# CARD-030 Revisar nomenclatura, duplicação e separação de camadas

**Tipo:** Task  
**Prioridade:** Média  
**Complexidade:** Média  
**Status inicial:** Backlog

## Descrição

Revisar o código completo antes da fase final, conferindo se os identificadores técnicos estão em inglês, se os nomes são expressivos, se há duplicação evitável e se interface, modelos e acesso aos dados estão separados. A organização do projeto deve ser proporcional à complexidade, sem camadas desnecessárias.

## Requisitos relacionados

- RNF02.1: identificadores técnicos em inglês.
- RNF02.2: nomes expressivos e baixa duplicação.
- RNF02.3: separação adequada entre interface, modelos e acesso aos dados.
- RNF02.4: organização proporcional à complexidade da aplicação.

## Critérios de aceitação

- [x] Todos os identificadores técnicos (classes, métodos, variáveis, arquivos, pastas) estão em inglês.
- [x] Os textos exibidos ao usuário permanecem em português.
- [x] Nomes genéricos ou pouco expressivos foram renomeados.
- [x] Trechos duplicados relevantes foram consolidados.
- [x] Nenhum componente de interface acessa o serviço de nuvem diretamente.
- [x] Os modelos não dependem da interface nem do serviço de nuvem. *(ver ressalva abaixo — `LostFoundItemModel` conhece o formato externo conforme `DATA_LAYER.md 6.1`; a Entity do Domain não depende do SDK)*
- [x] Não há código morto, arquivos não utilizados nem trechos comentados sem justificativa.
- [x] Não há dados fictícios definidos no código em substituição ao armazenamento remoto.
- [x] A estrutura de pastas está de acordo com as convenções do CARD-008, ou as diferenças estão justificadas.
- [x] Não há camadas ou abstrações sem uso real, ou seja, a organização é proporcional.

## Dependências

- [CARD-028] Exibir o novo registro na listagem após o cadastro.
- [CARD-029] Garantir adaptação a diferentes telas e ausência de overflow.

## Observações técnicas

A revisão não deve alterar o comportamento do aplicativo. Se uma refatoração for necessária, repetir a verificação funcional afetada (CARD-036). O documento não exige arquitetura específica e valoriza soluções simples, por isso a ausência de estruturas elaboradas não é falha, desde que a separação exigida exista. Uma revisão por pessoas que não escreveram o código tende a identificar mais problemas.

## Definition of Done

- [x] Atividade concluída.
- [x] Critérios de aceitação atendidos.
- [ ] Revisão feita por pelo menos um integrante que não escreveu o trecho revisado. *(pendente: confirmação de um integrante sobre o diff deste commit)*
- [ ] Alterações integradas ao ramo principal. *(pendente do merge final — CARD-038)*

## Registro da revisão — 08/11/2026

### Nomenclatura (RNF02.1 / RNF02.2)

- Busca por identificadores em português em `lib/` (classes, métodos, variáveis, arquivos e pastas): **nenhuma ocorrência**. Os termos em português encontrados estão apenas em textos de interface (`'Cadastrar objeto'`, `'Nenhum registro encontrado.'`) e em comentários, o que é correto (RNF02.2).
- Nomes de arquivo e diretório em `snake_case` e em inglês, conforme `CODING_STANDARDS.md`.

### Duplicação (RNF02.2)

Duas telas reconstruíam a mesma mensagem de falha com lógica própria:

| Arquivo | Antes | Depois |
|---|---|---|
| `presentation/pages/item_list_page.dart` | `error is CommunicationFailure ? error.userMessage : 'Não foi possível concluir a operação. Tente novamente.'` (literal duplicado de `CommunicationFailure.userMessage`) | `toCommunicationFailure(error).userMessage` |
| `presentation/widgets/item_form.dart` | `error is CommunicationFailure ? error.userMessage : const CommunicationFailure.unknown().userMessage` | `error == null ? const CommunicationFailure.unknown().userMessage : toCommunicationFailure(error).userMessage` |

O texto passa a existir em um único lugar (`core/errors/communication_failure.dart`). A classificação de falha também fica igual nas duas telas: timeout e mensagens de rede viram "Sem conexão com a internet...", sem expor detalhes técnicos (CARD-014). Nenhuma mensagem nova foi criada; o comportamento exibido ao usuário permanece o mesmo nos casos já tratados.

### Separação de camadas (RNF02.3)

- Nenhum widget acessa Firestore: a interface consome apenas providers (`itemListProvider`, `createItemProvider`).
- `docs/architecture/FOLDER_STRUCTURE.md` passou a documentar `data/data_providers.dart`, que já existia no código mas não estava previsto na estrutura. Ele é o ponto de composição das dependências exigido por `DATA_LAYER.md 11` e `DESIGN_PATTERNS.md 5.2` (`RemoteDataSource → Repository → UseCase → Presentation Provider`).
- **Ressalva sobre o critério "os modelos não dependem do serviço de nuvem":** `LostFoundItemModel` usa `Timestamp`/`FieldValue` do SDK. Isso é permitido por `DATA_LAYER.md 6.1` ("O Model poderá conhecer o formato externo dos dados"); a regra vale para a **Entity** (`LostFoundItem`), que permanece sem qualquer dependência de SDK, Flutter ou Riverpod. A separação Entity/Model está documentada em `FOLDER_STRUCTURE.md` seção 8.3.

### Código morto e dados fictícios (RNF02.4)

- `flutter analyze` sem problemas: não há elementos não utilizados, imports órfãos nem código morto apontado.
- `test/widget_test.dart` foi **removido**: era o teste de scaffold gerado pelo template, não fazia parte do escopo e verificava um texto inexistente (`'Reencontrapp'`), falhando em `flutter test`. Os 11 testes do CARD-012/CARD-013 permanecem.
- Nenhum registro fictício no código: a listagem lê exclusivamente a coleção `items` da nuvem (RT06).

### Organização proporcional (RNF02.4)

Uma feature, quatro camadas, cinco providers, dois casos de uso e três widgets. Nenhuma abstração foi adicionada; `core/` contém apenas `errors/` e `utils/` reais.

### Validação executada

| Comando | Resultado |
|---|---|
| `dart format .` | `Formatted 23 files (0 changed)` |
| `flutter analyze` | `No issues found!` |
| `flutter test` | `00:00 +11: All tests passed!` |