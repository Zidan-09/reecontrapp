# CARD-003 Criar repositório público no GitHub com `.gitignore`

**Tipo:** Task  
**Prioridade:** Alta  
**Complexidade:** Pequena  
**Status inicial:** Backlog

## Descrição

Criar o repositório público no GitHub que abrigará o código-fonte e a documentação do projeto, garantir que todos os integrantes consigam contribuir e configurar o `.gitignore` desde o primeiro commit.

O documento proíbe expressamente versionar artefatos de compilação, binários e arquivos gerados pelo build, em qualquer plataforma. A violação gera penalidade na nota. Por isso o `.gitignore` deve existir antes de qualquer código ser enviado.

## Requisitos relacionados

- DOC01: repositório público no GitHub com o código-fonte completo.
- DOC07: não versionar arquivos de build, binários ou credenciais privadas.
- ENT04: proibido incluir artefatos de compilação, binários e arquivos gerados no repositório.

## Critérios de aceitação

- [ ] O repositório existe no GitHub com visibilidade pública.
- [ ] O repositório abre em uma janela anônima, sem login.
- [ ] Todos os integrantes conseguem enviar commits ao repositório com a própria identidade.
- [ ] O `.gitignore` cobre diretórios `build/` e arquivos `.apk`, `.aab` e `.ipa`.
- [ ] O primeiro commit não contém artefatos de compilação, binários nem arquivos gerados desnecessários.

## Dependências

- [CARD-001] Registrar integrantes e responsabilidades da equipe.

## Observações técnicas

O comando de criação do projeto Flutter (CARD-004) gera seu próprio `.gitignore`. Ao executá-lo, conciliar os dois arquivos, mantendo todos os padrões deste cartão. A pasta `.dart_tool/` e outros arquivos gerados pelo Flutter também não devem ser versionados.

Ambiguidade relacionada: A9 (o PDF não define "arquivos gerados desnecessários"). As pastas de plataforma criadas pelo Flutter (por exemplo, `android/` e `ios/`) contêm configuração necessária à compilação, e sua ausência pode gerar penalidade (seção 8.4). A equipe deve registrar a decisão sobre elas antes de alterar qualquer uma.

## Definition of Done

- [ ] Atividade concluída.
- [ ] Critérios de aceitação atendidos.
- [ ] Todos os integrantes testaram o acesso ao repositório.
- [ ] Configuração integrada ao ramo principal do repositório.