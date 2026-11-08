# Análise pré-entrega — release/1.0 (auditoria 08/11/2026 + verificações 09/11/2026)

Auditoria executada na branch `release/1.0`, comparando o
documento `docs/pmob-aval2.pdf` e os cartões `CARD-029` a `CARD-039` com o
código atual em `lib/`, `README.md`, `.gitignore` e histórico Git local.
Comandos executados: `flutter analyze` (limpo),
`dart format --output=none --set-exit-if-changed .` (conforme após correção),
`flutter test` (11 testes passam).

## Verificações funcionais executadas (09/11/2026, Web/Chrome headless real)

Ambiente: `flutter build web --dart-define-from-file=.env` + Chrome headless
com relógio real via CDP (janela 390×844, 1280×800 e 844×390 paisagem).

### CARD-029 — telas/overflow (evidências)
- Boas-vindas 390×844: sem overflow. Listagem 390×844, 1280×800 e 844×390:
  sem faixa de erro de layout; busca, filtros, cards e FAB acessíveis.
- Formulário 390×844, 1280×800 e 844×390: seletor de situação, campos e
  botão alcançáveis, sem overflow.
- Registro com nome de 60 caracteres + descrição de 200 caracteres renderiza
  com ellipsis e "MAIS DETALHES", sem estouro nos dois tamanhos.
- Teclado aberto / rotação: não aplicável em Web desktop nesta bancada;
  formulário usa `SingleChildScrollView`, o que comporta o teclado virtual.
  Recomenda-se repetição manual no dispositivo do avaliador, se aplicável.

### CARD-036 — roteiro manual (resultado por item)
- Listagem carrega da nuvem e exibe nome/local/situação/descrição: **OK**
  (registro "Celular / Sala do Professor Eyder / Encontrado / De baixo da mesa").
- Distinção perdido × encontrado + ordem mais-recente-primeiro: **OK**
  (badge + stripe; novo registro criado via REST apareceu após atualização).
- Atualização vê registro criado fora da instalação: **OK** (reload trouxe a
  "Mochila teste 60 caracteres").
- Validação antes do envio: **OK** — 3 cliques em "Registrar objeto" com
  campos vazios geraram **0 documentos** (2 antes = 2 depois no Firestore).
- Indicadores de carregamento (skeletons/spinner/"Salvando..." no código):
  **OK** por inspeção nas telas de loading.
- Reenvio único: garantido por `state.isLoading` + `pendingItem` idempotente
  (`create_item_provider.dart`, transação no data source). Sem duplicata
  observada nos testes.
- Falha na leitura sem conexão: **CORRIGIDO NESTA SESSÃO** —
  instalação nova offline mostrava "Nenhum registro ainda" em vez de erro.
  Causa: `get()` cache-then-server resolve cache vazio como lista vazia.
  Correção (commit `e436322`, CARD-036): quando o snapshot vem do cache e
  está vazio, confirma-se contra o servidor (`Source.server`); se a rede
  falhar, o erro vira `CommunicationFailure` e a tela exibe "Sem conexão" +
  "Tentar novamente" (confirmado em screenshot 390×844).
- Nova tentativa após falha: **OK** (reload após desbloquear a rede trouxe
  os 2 registros).
- Dados demonstrativos, sem PII (RB05): **OK** — apenas "Celular" (sala do
  professor, dado de teste) + "Mochila teste" (criada nesta verificação).

### CARD-037 — persistência/compartilhamento (provas)
- Reload (nova inicialização) manteve os registros: **OK**.
- "2ª instalação" = perfil Chrome limpo nunca usado: carregou os mesmos
  2 registros da nuvem após voltar online: **OK**.
- Registro criado fora da instalação (via REST) visível no app: **OK**.
- REST confirma 2 documentos na coleção `items`; rules bloqueiam DELETE
  (403, esperado — update/delete proibidos): **OK**.
- **Decisão sobre dados de teste (ambiguidade A8):** os 2 registros de
  demonstração ("Celular", "Mochila teste") permanecem na coleção — são
  demonstrativos e o avaliador verá conteúdo na listagem. Se preferir
  entregar a base limpa, apague manualmente no console do Firebase antes
  do push final (o app não tem exclusão, por exigência do trabalho).

## Situação por cartão (039 → 029)

| Cartão | Assunto | Estado encontrado |
|---|---|---|
| 039 | Checklist 8.3 + entrega SIGAA | **Pendente** — nenhum item do checklist está marcado como conferido; entrega SIGAA (prazo hoje 08/11 23h59) ainda não registrada. |
| 038 | Clone limpo | **Pendente** — sem evidência de clone em diretório novo seguindo só o README. |
| 037 | Persistência entre instalações | **Verificado 09/11** — reload mantém registros; perfil limpo ("2ª instalação") carrega os mesmos 2 docs da nuvem; registro criado fora do app aparece na listagem; DELETE bloqueado pelas rules (403, esperado). Decisão A8 registrada acima. |
| 036 | Roteiro manual listagem/cadastro/erro | **Verificado 09/11** — roteiro executado (ver seção acima); achado 1 bug real (lista vazia offline) **corrigido** no commit `e436322`. Pendente só re-validação do formulário com teclado físico (Web desktop cobre o essencial). |
| 035 | Commits identificáveis | **Parcial** — os 4 integrantes têm commits de conteúdo no histórico local, mas falta a verificação na véspera no GitHub (lista de contribuidores + e-mail associado). |
| 034 | Artefatos + credenciais | **OK com ressalva** — `git ls-files` (237 arquivos) sem `build/`, `.apk/.aab/.ipa`, binários ou `.env`; `.gitignore` cobre os casos; `google-services.json` e `.env.example` mantidos como configuração pública (decisão registrada). Reauditar após o merge final. |
| 033 | README | **OK com ressalvas** — contém nomes, funcionalidades, Firestore Spark, pré-requisitos, passo a passo Web, tabela de chaves e plataforma oficial (Web/Chrome). Faltam: validação por terceiro (CARD-038) e revisão por outro integrante. |
| 032 | `dart format` | **Não-conforme hoje** — `dart format --set-exit-if-changed` acusa 1 arquivo: `lib/features/lost_found/presentation/pages/item_list_page.dart` (`SizedBox(height: 12,)`). É preciso rodar `dart format .` antes da entrega. |
| 031 | `flutter analyze` | **OK hoje** — `No issues found!`, mas terá de ser repetido após o `dart format` e após qualquer alteração (CARD-039 item 9). |
| 030 | Nomenclatura/camadas | **OK** — registros do cartão conferem com o código (identificadores em inglês, UI em português, sem acesso direto da UI ao Firestore, sem dados fictícios). Falta confirmação de revisão por outro integrante + integração ao ramo principal. |
| 029 | Telas/overflow | **Verificado 09/11** — listagem e formulário em 390×844, 1280×800 e 844×390 sem overflow; registro 60/200 chars com ellipsis + MAIS DETALHES. Teclado físico/rotacão: N/A em Web desktop (form usa SingleChildScrollView). |

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

4. **Problema:** roteiro manual (CARD-036) — **EXECUTADO 09/11, 1 bug real corrigido** (lista vazia offline mascarava falha; commit `e436322`, tela de erro confirmada).
   - **Referência:** CARD-036; PDF RF01–RF03/RB05/ENT03.
   - **Impacto:** resolvido — validação vazia bloqueia envio (0 docs criados em 3 cliques), retry funciona, dados demonstrativos.
   - **Resta:** limites 61/201 caracteres (validadores são `length > 60/200`, triviais) — opcional se houver tempo.

5. **Problema:** persistência/compartilhamento (CARD-037) — **VERIFICADO 09/11** (reload + perfil limpo + REST + rules 403). Resta só a decisão A8: manter os 2 registros demo (recomendado) ou limpar no console.

6. **Problema:** adaptação a telas (CARD-029) — **VERIFICADO 09/11** em 3 viewports Web sem overflow (registro acima). Resta só teclado físico/rotação, N/A em Web desktop.

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
| `git status` | limpo em `release/1.0` após commits `60fe2b7` (format), `e436322` (fix CARD-036) + este relatório |

> O único código alterado nesta rodada foi a correção do CARD-036
> (`lost_found_remote_data_source.dart`) + `dart format` anterior.
> Screenshots da verificação em `C:/Users/zidan/AppData/Local/Temp/opencode/`
> (`cdp_*.png`). Este relatório registra o roteiro executado.
