# CARD-004 Criar projeto Flutter base

**Tipo:** Task  
**Prioridade:** Alta  
**Complexidade:** Pequena  
**Status inicial:** Backlog

## Descrição

Criar o projeto Flutter base do Reencontrapp no repositório, garantindo que ele seja executado em pelo menos uma plataforma e que todos os integrantes consigam rodá-lo localmente.

Este cartão apenas cria a base do projeto. Não implementa funcionalidades e não acrescenta dependências sem respaldo no documento do professor.

## Requisitos relacionados

- RT01: utilização obrigatória de Flutter e Dart.
- RT03: não é necessário implementar autenticação.
- RT04: não é necessário utilizar recursos nativos do dispositivo.
- RT05: não são exigidos upload de imagens, edição, exclusão, notificações ou pesquisa avançada.
- RB04: não há autenticação, edição nem exclusão de registros.

## Critérios de aceitação

- [ ] O projeto Flutter está criado dentro do repositório do CARD-003.
- [ ] O nome do projeto é compatível com "Reencontrapp" e os identificadores técnicos estão em inglês.
- [ ] As dependências do projeto são instaladas sem erros.
- [ ] O aplicativo base executa em pelo menos uma plataforma, e a plataforma usada para a avaliação está registrada.
- [ ] Todos os integrantes clonaram o repositório e executaram o projeto base.
- [ ] Nenhuma dependência relacionada a autenticação, recursos nativos, notificações ou upload de imagens foi adicionada.
- [ ] O commit do projeto base não contém artefatos de compilação.

## Dependências

- [CARD-003] Criar repositório público no GitHub com `.gitignore`.

## Observações técnicas

Usar a ferramenta de criação de projetos do próprio Flutter e manter, no `pubspec.yaml`, somente as dependências estritamente necessárias. Cada dependência adicionada depois deve ser justificada por um requisito do PDF.

Ambiguidade relacionada: A10 (o PDF não define a plataforma-alvo). Esta decisão deve ser registrada, pois afeta o CARD-029 e o CARD-038. As pastas de plataforma geradas devem permanecer no repositório (ver A9 no CARD-003).

## Definition of Done

- [ ] Implementação ou atividade concluída.
- [ ] Critérios de aceitação atendidos.
- [ ] Projeto executado por todos os integrantes.
- [ ] Código integrado ao ramo principal do repositório.