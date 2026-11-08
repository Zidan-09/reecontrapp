# Reencontrapp

Aplicativo de **achados e perdidos** para a comunidade acadêmica: membros da universidade cadastram objetos perdidos ou encontrados e consultam os registros compartilhados em nuvem.

Desenvolvido na disciplina **Programação para Dispositivos Móveis (2ª avaliação)** — UESPI, Curso de Tecnologia em Sistemas de Computação — com Flutter, Dart e Firebase Firestore.

---

## Integrantes

| Nome completo | Conta no GitHub |
|---|---|
| Gabriel Lima Silva Oliveira | [Gabriel-afk-9](https://github.com/Gabriel-afk-9) |
| Paulo Henrique Alves Vieira | [PaulEvezely](https://github.com/PaulEvezely) |
| Erick Vieira da Silva Costa | [Erick-VP](https://github.com/Erick-VP) |
| Samuel da Penha Nascimento | [Zidan-09](https://github.com/Zidan-09) |

Histórico de commits: [github.com/Zidan-09/reecontrapp](https://github.com/Zidan-09/reecontrapp)

---

## Funcionalidades

| Requisito | O que a tela faz |
|---|---|
| **Listagem** | Carrega os registros da nuvem e exibe nome, local, situação e descrição de cada objeto |
| **Distinção visual** | Perdido e encontrado aparecem identificados por badge de cor diferente |
| **Ordenação** | Registros mais recentes primeiro (data gerada pelo servidor) |
| **Atualização** | Botão ↻ no AppBar e arrastar a lista para recarregar da nuvem |
| **Cadastro** | Formulário com nome, descrição, local e situação, com validação em português |
| **Validação** | Nome obrigatório até 60 caracteres; descrição obrigatória até 200; local obrigatório; situação obrigatória |
| **Assincronismo** | Indicadores de carregamento na leitura, na atualização e na gravação; envios repetidos bloqueados |
| **Falhas** | Mensagens compreensíveis em português (ex.: "Sem conexão com a internet..."), sem detalhes técnicos, com ação **Tentar novamente** |

**Fora do escopo** (não exigido pelo trabalho): autenticação de usuários, edição e exclusão de registros, upload de imagens, notificações e pesquisa avançada.

---

## Armazenamento em nuvem

- **Serviço:** Google **Firebase Firestore**, plano **Spark** (gratuito, sem cartão de crédito).
- **Projeto:** `reencontrapp` — coleção `items`.
- **Acesso:** SDK oficial do FlutterFire (`cloud_firestore`) com operações assíncronas (`Future`/`Stream`).
- **Regras de segurança:** leitura e criação liberadas para todos; atualização e exclusão bloqueadas.

Os dados persistem no servidor e são compartilhados entre todas as instalações.

---

## Pré-requisitos

| Item | Versão usada neste projeto |
|---|---|
| Flutter (channel stable) | **3.47.7** |
| Dart | **3.13.5** |
| Google Chrome | recente (plataforma oficial de avaliação) |

> As versões exatas não são obrigatórias, mas foi com elas que o projeto foi verificado. Instale o Flutter em [docs.flutter.dev/get-started](https://docs.flutter.dev/get-started/install).

---

## Como executar

### Web (plataforma oficial de avaliação)

```powershell
git clone https://github.com/Zidan-09/reecontrapp.git
cd reecontrapp
flutter pub get
Copy-Item .env.example .env
flutter run -d chrome --dart-define-from-file=.env
```

Em macOS/Linux: `cp .env.example .env`.

O Chrome abre automaticamente em modo de desenvolvimento. Para encerrar, digite `q` no terminal do Flutter.

> **Atenção:** o `--dart-define-from-file=.env` faz parte do comando. Ele injeta as chaves públicas do Firebase em tempo de compilação, a partir do `.env` local. O passo `Copy-Item .env.example .env` só precisa ser feito uma vez por clone.

### Compilar para publicação

```powershell
flutter build web --dart-define-from-file=.env
```

O resultado fica em `build/web/`. Esse diretório é gerado pelo build e **não** deve ser versionado.

### Android

O projeto também está configurado para Android (`android/app/google-services.json`), mas o build Android não foi verificado nesta máquina. A avaliação oficial é a **Web**.

---

## Configuração do Firebase (chaves e parâmetros)

O trabalho exige que as chaves de API e parâmetros estejam **disponíveis no repositório** (seções 8.2 e 8.3 do documento de avaliação). Elas estão assim organizadas:

| Arquivo | Conteúdo | Versionado? |
|---|---|---|
| `.env.example` | `FIREBASE_WEB_API_KEY` e `FIREBASE_ANDROID_API_KEY` (chaves públicas de cliente) | **Sim** — modelo para todo clone |
| `.env` | Cópia local usada em `--dart-define-from-file=.env` | Não (`.gitignore`) |
| `lib/firebase_options.dart` | `appId`, `projectId`, `messagingSenderId` etc.; as chaves são lidas por `String.fromEnvironment` | Sim, sem chave embutida |
| `android/app/google-services.json` | Configuração exigida pelo plugin Google Services no build Android | Sim |

São **identificadores públicos de cliente**, não credenciais privadas: a segurança vem das Security Rules do Firestore. Credenciais privadas (`private_key` de conta de serviço) nunca são versionadas.

---

## Estrutura do projeto

Organização **Feature-First** com Clean Architecture simplificada:

```text
lib/
├── app/                    # MaterialApp, tema e rotas
├── core/                   # errors/ (CommunicationFailure) e utils/ compartilhados
├── firebase_options.dart   # parâmetros do Firebase
├── main.dart               # inicialização
└── features/lost_found/
    ├── domain/             # entidade, enum e contrato do repositório (sem Flutter/Firebase)
    ├── application/        # casos de uso (listar e cadastrar)
    ├── data/               # data source, model, implementação e providers de composição
    └── presentation/       # páginas, widgets e providers de estado (Riverpod)
```

**Padrões:** Repository Pattern, Use Case Pattern, DTO/Model, injeção de dependência e estado com Riverpod, navegação nativa (Navigator 1.0) e Material 3.

Documentação detalhada em [`docs/architecture/`](docs/architecture/README.md).

---

## Comandos de qualidade

Executar sempre na raiz do projeto:

```powershell
dart format .                        # formata o código
flutter analyze                      # análise estática — deve sair "No issues found!"
flutter test                         # 11 testes unitários de conversão e ordenação
```

---

## Limitações conhecidas

- **Sem autenticação:** qualquer pessoa pode ler e criar registros; edição e exclusão ficam bloqueadas pelas regras do Firestore.
- **Identidade da operação:** o ID usado na criação vive em memória e não sobrevive ao encerramento do aplicativo.
- **Plataformas:** iOS, Windows, Linux e macOS não estão configurados. Desktop e Android não foram verificados.
- **Registros de teste:** a coleção pode conter dados demonstrativos criados durante a validação.

---

## Licença

Projeto acadêmico sem licença de distribuição.
