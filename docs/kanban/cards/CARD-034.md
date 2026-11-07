# CARD-034 Verificar ausência de artefatos de build e credenciais privadas

**Tipo:** Task  
**Prioridade:** Alta  
**Complexidade:** Pequena  
**Status inicial:** Backlog

## Descrição

Auditar o repositório para garantir que ele contém exclusivamente código-fonte, arquivos de configuração, recursos necessários para compilar e executar, e documentação. O documento proíbe expressamente artefatos de compilação, binários e arquivos gerados pelo build, e prevê penalidade para esse descumprimento.

A auditoria também confirma que não há credenciais privadas versionadas, conforme a decisão tomada no CARD-007.

## Requisitos relacionados

- DOC07: não versionar arquivos de build, binários ou credenciais privadas.
- ENT04: proibido incluir artefatos de compilação, binários e arquivos gerados, em qualquer plataforma.
- ENT07: ciência das penalidades da seção 8.4.

## Critérios de aceitação

- [x] A lista de arquivos versionados foi revisada integralmente.
- [x] Não há diretórios `build/` versionados, em nenhuma plataforma.
- [x] Não há arquivos `.apk`, `.aab`, `.ipa`, executáveis ou outros binários versionados.
- [x] Não há arquivos gerados desnecessários versionados (por exemplo, caches locais de ferramentas).
- [x] Os arquivos necessários para compilar e executar (configuração do projeto, dependências e pastas de plataforma) continuam presentes.
- [x] Nenhuma credencial classificada como privada pela equipe (ambiguidade A1) está versionada.
- [x] O repositório não contém dados pessoais ou sensíveis.
- [x] O histórico de commits foi verificado, e eventuais artefatos ou credenciais já commitados foram tratados com decisão da equipe registrada.
- [x] O `.gitignore` impede que os arquivos gerados voltem a ser versionados.

> Resultado detalhado na seção **Registro de verificação — 08/11/2026**, ao final deste cartão.

## Dependências

- [CARD-003] Criar repositório público no GitHub com `.gitignore`.
- [CARD-007] Definir e disponibilizar parâmetros de configuração da nuvem.

## Observações técnicas

A verificação do histórico é uma precaução da equipe, e o documento não a exige de forma explícita. Um artefato removido depois do commit continua acessível no histórico. Se isso ocorrer, reescrever histórico afeta a autoria dos commits (CARD-035) e deve ser decidido por toda a equipe, com cuidado para preservar os commits identificáveis de cada integrante. Também é possível que a seção 8.4 considere "arquivos gerados desnecessários", e o PDF não define o termo (ambiguidade A9). Repetir esta auditoria na véspera da entrega.

## Definition of Done

- [x] Atividade concluída.
- [x] Critérios de aceitação atendidos.
- [x] Resultado da auditoria registrado.
- [ ] Correções integradas ao ramo principal. *(pendente do merge final — CARD-038)*

## Registro de verificação — 08/11/2026

**Escopo:** 211 arquivos versionados em `develop` (após `flutter pub get` e `dart format .`).

### Critérios de aceitação

- [x] **Lista de arquivos revisada:** `git ls-files` (211 arquivos) inspecionado integralmente.
- [x] **Sem diretórios `build/`:** nenhuma ocorrência de `build/`, `.dart_tool/`, `coverage/` ou `android/app/{debug,profile,release}/` no índice.
- [x] **Sem binários:** nenhuma ocorrência de `.apk`, `.aab`, `.ipa`, `.jar`, `.exe`, `.dll`, `.so`, `.a`, `.o`, `.jks`, `.keystore`, `.class` no índice.
- [x] **Sem arquivos gerados desnecessários:** nenhum arquivo rastreado acima de 200 KB; nenhum `.env` versionado.
- [x] **Arquivos necessários presentes:** `pubspec.yaml`, `pubspec.lock`, pastas de plataforma, `android/app/google-services.json` e `lib/firebase_options.dart` permanecem no índice.
- [x] **Sem credencial privada:** `git grep` por `private_key`, `BEGIN RSA`, `BEGIN PRIVATE` e `service-account` não retorna resultados. `.gitignore` cobre `**/service-account*.json`.
- [x] **Sem dados sensíveis:** os dados no repositório são os identificadores públicos do projeto `reencontrapp` e os e-mails de commit dos integrantes (exigidos pelo CARD-035).
- [x] **Histórico verificado:** `git log --all --name-only` em todos os commits não contém artefatos de build, binários, credenciais privadas ou arquivos `.env`. Nada precisou ser removido, portanto **não houve reescrita de histórico** (que afetaria a autoria — CARD-035).
- [x] **`.gitignore` reforçado:** adicionados `*.apk`, `*.aab`, `*.ipa`, `*.jks`, `*.keystore`, `key.properties`, `.env`, `.env.*` (com exceção `!.env.example`). Verificado com `git check-ignore -v .env`.

### Mudança de configuração executada neste card

A chave de API do cliente estava hardcoded em `lib/firebase_options.dart` (Web e Android) — o que motivou o pedido de `.env`. Decisão baseada no PDF:

- Seção 7 proíbe apenas **credenciais privadas**; seções 8.2 e 8.3 **exigem** que as chaves de API estejam disponíveis no repositório ou no `README.md`; a seção 8.4 penaliza a ausência delas.
- Portanto a chave continua **disponível**, porém **fora do código Dart**:

| Arquivo | Papel | Versionado |
|---|---|---|
| `.env.example` | Modelo com as chaves públicas (Web e Android) | Sim |
| `.env` | Cópia local, usada por `--dart-define-from-file=.env` | Não (`.gitignore`) |
| `lib/firebase_options.dart` | Demais parâmetros; chaves via `String.fromEnvironment` | Sim, sem chave embutida |
| `android/app/google-services.json` | Exigido pelo plugin Google Services (build Android) | Sim (configuração pública) |

`git grep "AIza"` após a alteração retorna apenas `android/app/google-services.json` — nenhuma chave no código Dart.

### Validação executada

| Comando | Resultado |
|---|---|
| `flutter pub get` | `Got dependencies!` |
| `dart format .` | `Formatted 24 files (0 changed)` |
| `flutter analyze` | `No issues found!` |
| `flutter build web --dart-define-from-file=.env` | `✓ Built build\web` (38,8 s); a chave está presente no bundle gerado; `build/` ignorado pelo `.gitignore` |

Nenhum teste automatizado foi criado ou alterado neste card.