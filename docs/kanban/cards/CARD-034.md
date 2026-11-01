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

- [ ] A lista de arquivos versionados foi revisada integralmente.
- [ ] Não há diretórios `build/` versionados, em nenhuma plataforma.
- [ ] Não há arquivos `.apk`, `.aab`, `.ipa`, executáveis ou outros binários versionados.
- [ ] Não há arquivos gerados desnecessários versionados (por exemplo, caches locais de ferramentas).
- [ ] Os arquivos necessários para compilar e executar (configuração do projeto, dependências e pastas de plataforma) continuam presentes.
- [ ] Nenhuma credencial classificada como privada pela equipe (ambiguidade A1) está versionada.
- [ ] O repositório não contém dados pessoais ou sensíveis.
- [ ] O histórico de commits foi verificado, e eventuais artefatos ou credenciais já commitados foram tratados com decisão da equipe registrada.
- [ ] O `.gitignore` impede que os arquivos gerados voltem a ser versionados.

## Dependências

- [CARD-003] Criar repositório público no GitHub com `.gitignore`.
- [CARD-007] Definir e disponibilizar parâmetros de configuração da nuvem.

## Observações técnicas

A verificação do histórico é uma precaução da equipe, e o documento não a exige de forma explícita. Um artefato removido depois do commit continua acessível no histórico. Se isso ocorrer, reescrever histórico afeta a autoria dos commits (CARD-035) e deve ser decidido por toda a equipe, com cuidado para preservar os commits identificáveis de cada integrante. Também é possível que a seção 8.4 considere "arquivos gerados desnecessários", e o PDF não define o termo (ambiguidade A9). Repetir esta auditoria na véspera da entrega.

## Definition of Done

- [ ] Atividade concluída.
- [ ] Critérios de aceitação atendidos.
- [ ] Resultado da auditoria registrado.
- [ ] Correções integradas ao ramo principal.