# Análise pré-entrega — release/1.0 (auditoria 08/11/2026)

Auditoria executada na branch `release/1.0` (commit `c42a563`), comparando o
documento `docs/pmob-aval2.pdf` e os cartões `CARD-029` a `CARD-039` com o
código atual em `lib/`, `README.md`, `.gitignore` e histórico Git local.
Nenhum código foi alterado nesta etapa, exceto a criação deste relatório.
Comandos somente-leitura executados: `flutter analyze` (limpo),
`dart format --output=none --set-exit-if-changed .` (1 arquivo diverge),
`flutter test` (11 testes passam).

## Situação por cartão (039 → 029)

| Cartão | Assunto | Estado encontrado |
|---|---|---|
| 039 | Checklist 8.3 + entrega SIGAA | **Pendente** — nenhum item do checklist está marcado como conferido; entrega SIGAA (prazo hoje 08/11 23h59) ainda não registrada. |
| 038 | Clone limpo | **Pendente** — sem evidência de clone em diretório novo seguindo só o README. |
| 037 | Persistência entre instalações | **Pendente** — sem registro de verificação em 2 instalações / console do Firebase. |
| 036 | Roteiro manual listagem/cadastro/erro | **Pendente** — sem roteiro escrito nem resultados (limites 0/60/61/200/201, offline leitura+gravação, reenvio). |
| 035 | Commits identificáveis | **Parcial** — os 4 integrantes têm commits de conteúdo no histórico local, mas falta a verificação na véspera no GitHub (lista de contribuidores + e-mail associado). |
| 034 | Artefatos + credenciais | **OK com ressalva** — `git ls-files` (237 arquivos) sem `build/`, `.apk/.aab/.ipa`, binários ou `.env`; `.gitignore` cobre os casos; `google-services.json` e `.env.example` mantidos como configuração pública (decisão registrada). Reauditar após o merge final. |
| 033 | README | **OK com ressalvas** — contém nomes, funcionalidades, Firestore Spark, pré-requisitos, passo a passo Web, tabela de chaves e plataforma oficial (Web/Chrome). Faltam: validação por terceiro (CARD-038) e revisão por outro integrante. |
| 032 | `dart format` | **Não-conforme hoje** — `dart format --set-exit-if-changed` acusa 1 arquivo: `lib/features/lost_found/presentation/pages/item_list_page.dart` (`SizedBox(height: 12,)`). É preciso rodar `dart format .` antes da entrega. |
| 031 | `flutter analyze` | **OK hoje** — `No issues found!`, mas terá de ser repetido após o `dart format` e após qualquer alteração (CARD-039 item 9). |
| 030 | Nomenclatura/camadas | **OK** — registros do cartão conferem com o código (identificadores em inglês, UI em português, sem acesso direto da UI ao Firestore, sem dados fictícios). Falta confirmação de revisão por outro integrante + integração ao ramo principal. |
| 029 | Telas/overflow | **Parcial** — há 3 fixes commitados (status wrap, AppBar ellipsis, scroll em loading/erro), mas **nenhum critério de aceitação está marcado** e não há registro de larguras/alturas, teclado aberto, rotação ou teste com 60/200 caracteres. |

## Requisitos do professor (pmob-aval2.pdf) — cobertura observada

- RF01 listagem: implementado (nuvem → nome/local/situação/descrição, badge Perdido/Encontrado, ordenação mais-recente-primeiro no `LostFoundRepositoryImpl.getAll`, atualização por botão ↻ e `RefreshIndicator`).
- RF02 cadastro: implementado (nome ≤60, descrição ≤200, local obrigatório, situação obrigatória, validação antes do envio, `created_at` por `FieldValue.serverTimestamp()`, retorno à lista com `invalidate(itemListProvider)`).
- RF03 assincronismo: implementado (leitura/gravação `async`, skeletons + spinners + "Salvando...", trava de `isLoading` + `pendingItem` idempotente por transação, `CommunicationFailure` em PT + "Tentar novamente").
- RF04 estado (Riverpod): implementado (`itemListProvider`, `createItemProvider`, estados loading/data/error).
- RF05 nuvem: implementação aponta para Firestore Spark (`items`), `persistenceEnabled: true`, sem dados fictícios — **mas sem prova registrada de persistência pós-reinício e entre instalações (CARD-037)**.
- RNF01: Material 3 + PT + mensagens de operação/falha OK; **adaptação/overflow sem evidência de verificação (CARD-029)**.
- RNF02: identificadores inglês, `analyze` limpo, **formato com 1 divergência (ver acima)**.
- Equipe: 4 integrantes com commits de conteúdo no histórico local (Gabriel, Paulo, Erick, Samuel/Zidan-09) — falta conferência no GitHub.
- Repositório/entrega (seções 7–8): sem artefatos versionados; chaves públicas em `.env.example` + `google-services.json`; **merge para o ramo principal + push + SIGAA ainda pendentes** (`release/1.0` tem 69 commits à frente de `origin/main`, sem upstream configurado).

## Pendências (maior → menor prioridade)

### CRÍTICA

1. **Problema:** ***(POR ÚLTIMO)*** entrega SIGAA + publicação do ramo principal não concluídas; `release/1.0` está 69 commits à frente de `origin/main` e sem upstream.
   - **Referência:** CARD-039; PDF ENT01/ENT02/ENT03/8.3 itens 1, 4, 10.
   - **Impacto:** sem merge+push público e sem envio ao SIGAA até 23h59 de hoje, o trabalho não é avaliado.
   - **Localização:** branches `release/1.0` → `main`/`origin/main`; SIGAA.
   - **Correção sugerida:** mergear `release/1.0` em `main`, `git push`, confirmar repositório público acessível sem login, enviar link + nomes no SIGAA e guardar comprovante.

### ALTA

2. **Problema:** `dart format` diverge em 1 arquivo; checklist 8.3 item 9 ("format + analyze após a última alteração") falha hoje.
   - **Referência:** CARD-032/CARD-039; PDF RNF02.6/8.3 item 9.
   - **Impacto:** item explícito do checklist; perda direta no critério qualidade/repositório.
   - **Localização:** `lib/features/lost_found/presentation/pages/item_list_page.dart:107` (`SizedBox(height: 12,)`).
   - **Correção sugerida:** rodar `dart format .`, confirmar 2ª execução com 0 alterações, rodar `flutter analyze` em seguida e commitar.

3. **Problema:** (Validado) validação em clone limpo (CARD-038) não executada; risco de o avaliador não conseguir compilar/executar só com o README.
   - **Referência:** CARD-038; PDF ENT03/ENT04/ENT05/8.4 (ausência de arquivos, chaves ou instruções).
   - **Impacto:** qualquer passo omitido (ex.: `Copy-Item .env.example .env` + flag `--dart-define-from-file=.env`) impede a avaliação → penalidade 8.4.
   - **Localização:** `README.md` seção "Como executar"; `lib/firebase_options.dart` (`String.fromEnvironment`); `.env.example`.
   - **Correção sugerida:** clonar o **link público** em pasta nova, seguir só o README (`pub get` → `.env` → `run -d chrome --dart-define-from-file=.env`), testar listar+cadastrar; corrigir o README e repetir. Atenção ao Teste C do CARD-034: sem a flag a chave fica `""` e o SDK Web ficou "inconclusivo em automação headless" — validar manualmente no Chrome real e deixar claro se a flag é obrigatória.

4. **Problema:** sem roteiro manual preenchido (CARD-036) — limites 60/200, offline leitura/gravação, reenvio único, indicadores.
   - **Referência:** CARD-036; PDF RF01–RF03/RB05/ENT03.
   - **Impacto:** defeitos de validação, ordenação, loading ou retry passam despercebidos e cada critério vale 2,0 pontos.
   - **Localização:** `lib/features/lost_found/presentation/widgets/item_form.dart` (validadores), `item_list_page.dart`, `create_item_provider.dart`, `communication_failure.dart`.
   - **Correção sugerida:** executar o roteiro do cartão com a nuvem real (0/60/61 e 0/200/201 caracteres, teclado aberto, sem conexão nas duas operações, toques repetidos) e registrar resultado por item.

5. **Problema:** (Validado) persistência/compartilhamento entre instalações sem prova (CARD-037).
   - **Referência:** CARD-037; PDF RF05.2/RF05.3/RT06.
   - **Impacto:** critério "Integração com armazenamento em nuvem" (2,0 pts) depende exatamente desta prova.
   - **Localização:** `lost_found_remote_data_source.dart` (`collection('items').get()`), `main.dart` (`persistenceEnabled: true`), console Firestore.
   - **Correção sugerida:** cadastrar em uma instalação, fechar/reabrir, conferir em 2ª instalação limpa + console do Firebase; registrar prints/observações e decidir sobre dados de teste (ambiguidade A8).

6. **Problema:** adaptação a telas sem registro (CARD-029, todos os checkboxes abertos).
   - **Referência:** CARD-029; PDF RNF01.3/RNF01.4.
   - **Impacto:** overflow ou controle inacessível desconta no critério interface (2,0 pts).
   - **Localização:** `item_list_page.dart`, `item_form.dart`, `lost_found_item_card.dart`, `create_item_page.dart`.
   - **Correção sugerida:** verificar 2 larguras × 2 alturas (Web/Chrome), teclado aberto no formulário, rotação, registros 60/200 caracteres; anotar tamanhos e corrigir o que estourar.

7. **Problema:** verificação de autoria no GitHub pendente (CARD-035, verificação da véspera).
   - **Referência:** CARD-035; PDF EQ02/EQ03/DOC06.
   - **Impacto:** integrante sem commit identificável/associado perde pontuação de equipe.
   - **Localização:** histórico Git local (4 autores com conteúdo) × contribuidores do GitHub.
   - **Correção sugerida:** após o push final, conferir `github.com/Zidan-09/reecontrapp` (contribuidores, e-mails associados) e repetir na véspera/entrega.

### MÉDIA

8. **Problema:** (Professor irá testar apenas em chrome WEB) plataformas não-Web lançam `UnsupportedError` (`DefaultFirebaseOptions` só trata Web/Android); avaliador que tentar iOS/macOS/Windows/Linux vê crash.
   - **Referência:** PDF 8.1/8.2/8.4; CARD-038 observação (ambiguidade A10).
   - **Impacto:** "impossibilidade de executar" se o avaliador sair da plataforma declarada.
   - **Localização:** `lib/firebase_options.dart:32-56`; `README.md` (plataforma oficial: Web/Chrome).
   - **Correção sugerida:** não mudar código agora; garantir que README + entrega SIGAA deixem explícito "avaliar na Web (Chrome)"; se sobrar tempo, validar o comando exato da seção Web.

9. **Problema:** (Ignorar) revisões cruzadas pendentes (CARD-030, CARD-033, CARD-036–038 pedem revisão por outro integrante).
   - **Referência:** DoD dos cartões; PDF EQ02.
   - **Impacto:** menor que os itens acima, mas demonstra participação efetiva de todos.
   - **Localização:** diffs de CARD-030/029/034, `README.md`.
   - **Correção sugerida:** um integrante que não escreveu revisar e registrar o aceite antes do merge.

### BAIXA

10. **Observação (não é pendência):** (Ignorar) tela de boas-vindas (`AppRouter.welcome = '/'`) é extra ao mínimo exigido, mas o PDF permite telas adicionais a critério da equipe. Sem impacto, desde que o caminho Boas-vindas → listagem → cadastro esteja óbvio.
    - **Localização:** `lib/app/app_router.dart`, `lib/features/welcome/`.

## Verificações executadas nesta auditoria

| Comando | Resultado |
|---|---|
| `flutter analyze` | `No issues found!` |
| `dart format --output=none --set-exit-if-changed .` | 1 arquivo diverge (`item_list_page.dart`) — exit 1 |
| `flutter test` | `All tests passed!` (11 testes) |
| `git ls-files` (237 arquivos) | sem `build/`, `.apk/.aab/.ipa`, binários, `.env` ou `service-account`; `.env.example` versionado com as chaves públicas |
| `git log` autores | Gabriel, Paulo, Erick e Samuel/Zidan possuem commits de conteúdo no histórico local |
| `git status` | limpo em `release/1.0`; 69 commits à frente de `origin/main`, sem upstream |

> Nada foi corrigido no código nesta etapa, conforme a restrição da tarefa. O único arquivo criado foi este relatório.
