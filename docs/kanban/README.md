# Kanban do Reencontrapp

## Projeto

**Reencontrapp** é um aplicativo móvel de achados e perdidos para a comunidade acadêmica de um campus universitário. Ele permite divulgar objetos perdidos ou encontrados e consultar os registros publicados, facilitando a localização e a recuperação desses objetos.

O trabalho corresponde à **2ª Avaliação** da disciplina Programação para Dispositivos Móveis (UESPI, Curso de Tecnologia em Sistemas de Computação). O documento do professor é a principal fonte de verdade deste planejamento.

**Prazo de entrega:** 08/11/2026, até 23h59, exclusivamente pelo SIGAA.

## Tecnologias

| Item | Definição | Origem |
|---|---|---|
| Framework | Flutter | Obrigatório (RT01) |
| Linguagem | Dart | Obrigatório (RT01) |
| Armazenamento em nuvem | A definir pela equipe (serviço gratuito) | Livre escolha (RT02, RT07) |
| Gerenciamento de estado | A definir pela equipe | Livre (RF04) |
| Controle de versão | Git e GitHub (repositório público) | Obrigatório (DOC01) |

Não há tecnologias adicionais sem respaldo no documento do professor.

## Quantidade de cartões

**39 cartões**, cada um em seu próprio arquivo em `cards/`.

| Categoria | Cartões | Quantidade |
|---|---|---|
| Planejamento e estruturação | CARD-001 a CARD-002 | 2 |
| Configuração do projeto e da nuvem | CARD-003 a CARD-008 | 6 |
| Persistência de dados e integração | CARD-009 a CARD-014 | 6 |
| Gerenciamento de estado | CARD-015 a CARD-016 | 2 |
| Interface e funcionalidades | CARD-017 a CARD-029 | 13 |
| Qualidade de código | CARD-030 a CARD-032 | 3 |
| Documentação e repositório | CARD-033 a CARD-035 | 3 |
| Testes e validação | CARD-036 a CARD-038 | 3 |
| Entrega | CARD-039 | 1 |

| Tipo | Quantidade |
|---|---|
| Task | 18 |
| Feature | 17 |
| Documentation | 1 |
| Test | 3 |

| Prioridade | Quantidade |
|---|---|
| Alta | 37 |
| Média | 2 |
| Baixa | 0 |

Não há cartões de prioridade Baixa porque o documento não lista requisitos complementares. Todos os requisitos são obrigatórios ou necessários para a entrega.

## Estrutura da pasta

```text
kanban/
├── README.md          Este arquivo
├── requisitos.md      Requisitos extraídos do PDF e rastreabilidade
├── planejamento.md    Etapas, ordem de execução, marcos e pendências
└── cards/
    ├── README.md      Índice de todos os cartões
    └── CARD-001.md … CARD-039.md
```

## Organização do quadro

Todos os cartões começam em **Backlog**. Sugestão de colunas, que a equipe pode adaptar:

1. **Backlog:** cartões ainda não iniciados.
2. **Em andamento:** cartões em execução (limite sugerido de cartões por pessoa, a critério da equipe).
3. **Em revisão:** implementação concluída, aguardando verificação dos critérios de aceitação.
4. **Concluído:** critérios de aceitação e Definition of Done atendidos.

## Instruções de utilização

1. Consulte `cards/README.md` para ver todos os cartões, as prioridades e as dependências.
2. Antes de iniciar um cartão, confirme que **todas as suas dependências estão em Concluído**.
3. Siga a ordem sugerida em `planejamento.md` para aproveitar a paralelização entre integrantes.
4. Cada cartão lista os requisitos relacionados. Os IDs (RF, RNF, RB, RT, EQ, DOC, ENT, AV) estão definidos em `requisitos.md`.
5. Um cartão só vai para **Concluído** quando todos os itens de "Critérios de aceitação" e "Definition of Done" estiverem marcados.
6. Dúvidas e ambiguidades do documento do professor estão em `planejamento.md` (seção "Pendências e ambiguidades"). Não resolva uma ambiguidade sem registrar a decisão e quem a tomou.
7. Todos os integrantes devem ter commits identificáveis no repositório (EQ03). Associe cada cartão a quem o executou.