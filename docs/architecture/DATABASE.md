# Persistência e Banco de Dados — Reencontrapp

## 1. Objetivo

Este documento define os requisitos de persistência, o serviço de nuvem escolhido e o modelo físico de armazenamento do Reencontrapp.

Ele complementa `DATA_LAYER.md` e registra a decisão do `CARD-002`, atendendo aos requisitos `RF05`, `RT02`, `RT07`, `RB05`, `RB06` e `RB02`.

## 2. Decisão aprovada — CARD-002

| Aspecto | Decisão |
|---|---|
| Serviço de nuvem | Firebase Firestore |
| Plano | Spark (gratuito) |
| Data da verificação | 02/11/2026 |
| Responsável | Equipe Reencontrapp |
| Status | Aprovado — substitui o status "Pendente" de `README.md` e `ARCHITECTURE.md` |

A escolha foi validada por toda a equipe e está registrada no Kanban (`CARD-002` em Concluído).

### 2.1 Justificativa

Firebase Firestore Spark foi o único entre os avaliados (Firestore vs. Supabase vs. Appwrite) que atende **todos** os requisitos sem risco de pausa por inatividade.

- **Gratuidade real sem cartão (RF05.1 / RT02):** Spark não exige cartão de crédito e não gera cobrança. Ao atingir a cota diária o serviço pausa até o próximo ciclo, sem custo. Com dezenas de registros de texto, as cotas (50 K leituras/dia, 20 K escritas/dia, 1 GiB) nunca serão atingidas.
- **Persistência (RF05.2):** banco em nuvem gerenciado pelo Google, dados persistem indefinidamente.
- **Compartilhamento (RF05.3):** todos os clientes leem/escrevem na mesma coleção.
- **Acesso assíncrono (RF05.4):** SDK oficial `cloud_firestore` (FlutterFire) com API `Future`/`Stream`.
- **Sem autenticação (RB06):** Security Rules permitem `allow read, create: if true` de forma permanente, sem expiração.
- **Avaliação sem custo (RT07):** professor executa `flutter run` com `google-services.json` versionado, sem criar conta ou inserir cartão.
- **Timestamp confiável (RB02 / A2):** `FieldValue.serverTimestamp()` nativo, horário gerado pelo servidor Firestore.

**Fator decisivo:** Supabase e Appwrite pausam projetos Free após 7 dias de inatividade (Appwrite desde 20/02/2026). Entre o envio no SIGAA (08/11) e a avaliação pode haver mais de 7 dias sem chamadas, deixando o app offline e zerando `AV03` (2,0 pts). Firestore Spark não possui pausa por inatividade.

Fonte dos limites: https://firebase.google.com/pricing (consultado em 02/11/2026).

## 3. Plano gratuito — limites verificados

| Recurso | Cota Spark |
|---|---|
| Leituras | 50 K / dia |
| Escritas | 20 K / dia |
| Armazenamento | 1 GiB |
| Egress de rede | 10 GiB / mês |
| Cartão de crédito | Não exigido |
| Prazo / expiração | Permanente, sem prazo |
| Pausa por inatividade | Não existe |
| Comportamento ao atingir cota | Serviço para até o próximo ciclo, sem cobrança |

## 4. Estrutura física

### 4.1 Coleção

```
items
```

Nome em inglês, conforme `RNF02.1` e `FOLDER_STRUCTURE.md`. A entidade de domínio correspondente é `LostFoundItem`.

### 4.2 Schema do documento

| Campo | Tipo Firestore | Tipo Dart | Origem | Obrigatório | Regra |
|---|---|---|---|---|---|
| `name` | String | String | usuário | sim | ≤ 60 caracteres |
| `description` | String | String | usuário | sim | ≤ 200 caracteres |
| `location` | String | String | usuário | sim | não vazio |
| `status` | String | `ItemStatus` (`lost`/`found`) | usuário | sim | apenas `lost` ou `found` |
| `created_at` | Timestamp | DateTime | `FieldValue.serverTimestamp()` | sim | gerado pelo servidor, não editável |
| `id` | String (document ID) | String | Firestore (auto-ID) | sim | gerado automaticamente |

O campo `id` é o ID do documento Firestore. Não é informado pelo usuário. A conversão `created_at` (snake_case no Firestore) → `createdAt` (lowerCamelCase no Dart) ocorre em `LostFoundItemModel`, conforme `DATA_LAYER.md 6`.

Nenhum campo além dos acima será persistido nesta versão (sem imagem, contato ou dados pessoais — `RB05`).

## 5. Configuração e parâmetros

### 5.1 O que pode ser versionado (identificadores públicos)

`google-services.json` em `android/app/` e `firebase_options.dart` na raiz de `lib/` contêm `apiKey`, `projectId`, `appId`, `storageBucket` e `messagingSenderId`. São identificadores públicos destinados ao cliente e **podem** ser versionados. A segurança vem das Security Rules, não do sigilo da chave.

`GoogleService-Info.plist` em `ios/Runner/` segue a mesma regra quando a plataforma iOS for habilitada.

### 5.2 O que NUNCA vai ao repositório (segredos privados)

- Arquivos de conta de serviço (`*service-account*.json` com `private_key`)
- Chaves do Admin SDK
- Tokens com privilégio irrestrito

Esses arquivos estão cobertos por `.gitignore` (`**/service-account*.json`). Violar esta regra gera penalidade `DOC07`/`ENT04`.

### 5.3 Ponto único de configuração

Os parâmetros são centralizados em `firebase_options.dart` (gerado por `flutterfire configure`). `LostFoundRemoteDataSource` lê desse ponto, sem duplicação, conforme `DATA_LAYER.md 11`.

As instruções prontas para serem incorporadas ao `README.md` no `CARD-033` estão na seção 5.4.

### 5.4 Instruções de execução (base para o CARD-033)

Como os arquivos de configuração são versionados, um clone já contém tudo o que é necessário:

1. `flutter pub get`
2. `flutter run` em um emulador/dispositivo Android ou em um navegador (`flutter run -d chrome`).

Nenhum parâmetro adicional precisa ser informado: `lib/firebase_options.dart` e `android/app/google-services.json` fornecem automaticamente os identificadores do projeto `reencontrapp`.

## 6. Regras de acesso — Firestore Security Rules

Compatíveis com app sem autenticação (`RB06`) e com `RB04` (sem edição/exclusão):

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /items/{document} {
      allow read, create: if true;
      allow update, delete: if false;
    }
  }
}
```

- `read` e `create` sem autenticação: permitido.
- `update` e `delete`: bloqueado (funcionalidades fora de escopo).
- Regra permanente, **sem expiração**. O template de "test mode" de 30 dias não será usado; a regra acima é customizada e só muda com edição manual (`CARD-006` valida no Rules Playground).

Princípio do menor privilégio: apenas leitura e criação são liberadas (`CODING_STANDARDS.md 16`).

## 7. Estratégia de timestamp

Definitiva após `CARD-002`: `FieldValue.serverTimestamp()` no campo `created_at` durante `create`. Resolve a ambiguidade `A2` (horário do servidor, não do dispositivo). A ordenação `orderBy('created_at', descending: true)` na consulta garante `RB03` e `RF01.4` no servidor (`CARD-013`).

## 8. Resolução de ambiguidades

| Ambiguidade | Decisão |
|---|---|
| A1 — credencial privada vs. pública | `apiKey`/`projectId`/`appId` são públicas e entram no repo; `private_key` de service account é segredo e não entra. |
| A2 — origem do timestamp | Servidor Firestore via `FieldValue.serverTimestamp()`. |
| A8 — registro de teste na nuvem | Permitido, apenas dados demonstrativos (`RB05`). Decisão sobre manter/remover será registrada no `CARD-005`. |
| A9 — arquivos gerados desnecessários | `build/`, `.dart_tool/`, `.apk`/`.aab`/`.ipa` continuam ignorados; pastas de plataforma `android/`/`ios/`/`web/` permanecem versionadas. |

## 9. Impacto nas camadas

- **Domain:** nenhuma alteração (entidade `LostFoundItem` e `ItemStatus` permanecem independentes).
- **Data:** `LostFoundRemoteDataSource` usará `cloud_firestore` + `firebase_core`; `LostFoundItemModel` fará `fromMap`/`toMap` com `created_at` ↔ `createdAt`.
- **Application/Presentation:** sem impacto além da injeção via Riverpod já prevista em `DATA_LAYER.md 11` e `STATE_MANAGEMENT.md 7`.

## 10. Configuração executada (Kanban)

- `CARD-005`: projeto `reencontrapp` configurado, banco Firestore `(default)` ativo, coleção `items` com registros de demonstração, `flutterfire configure` executado para Android e Web (`google-services.json` e `firebase_options.dart` gerados).
- `CARD-006`: regras da seção 6 aplicadas via `firebase deploy --only firestore:rules` e verificadas com requisições sem autenticação: leitura e criação retornaram sucesso (200) e atualização/exclusão foram negadas (403).
- `CARD-007`: parâmetros centralizados em `lib/firebase_options.dart`, arquivos de configuração versionados, `**/service-account*.json` adicionado ao `.gitignore` e instruções de execução registradas na seção 5.4.

## 11. Referências

- `ARCHITECTURE.md` — visão geral e decisões pendentes agora resolvidas para nuvem/timestamp.
- `DATA_LAYER.md` — contratos de repositório e Data Source.
- `FOLDER_STRUCTURE.md` — organização de diretórios.
- `STATE_MANAGEMENT.md` — gerenciamento de estado da listagem e cadastro.
- `docs/kanban/cards/CARD-002.md` — critérios de aceitação originais.
- `docs/kanban/planejamento.md` — onda 0 e ambiguidades A1/A2/A8/A9.

## 12. Definition of Done — CARD-002

- [x] Serviço escolhido e justificado com comparação documentada (Firestore vs. Supabase vs. Appwrite)
- [x] Plano gratuito verificado na documentação oficial (sem cartão, sem pausa, sem expiração)
- [x] Schema de campos definido em inglês (`RNF02.1`)
- [x] Distinção chave pública vs. segredo documentada (`A1`)
- [x] Security Rules sem autenticação definidas e sem expiração
- [x] Estratégia de timestamp definida (`FieldValue.serverTimestamp()`)
- [x] Decisão validada pela equipe e registrada neste documento
