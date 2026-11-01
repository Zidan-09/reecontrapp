# CARD-007 Definir e disponibilizar parâmetros de configuração da nuvem

**Tipo:** Task  
**Prioridade:** Alta  
**Complexidade:** Pequena  
**Status inicial:** Backlog

## Descrição

Identificar todas as informações necessárias para que qualquer pessoa execute o aplicativo conectado à nuvem (chaves de API, identificadores, URLs e demais parâmetros) e definir onde elas serão disponibilizadas: no repositório ou em instruções claras no `README.md`.

A ausência dessas informações é uma das penalidades explícitas do documento (seção 8.4) e pode impedir a avaliação do aplicativo.

## Requisitos relacionados

- ENT05: fornecer as informações de configuração da nuvem (chaves de API, identificadores, URLs e demais parâmetros) no repositório ou em instruções claras no `README.md`.

## Critérios de aceitação

- [ ] Existe uma lista completa dos parâmetros necessários para o aplicativo acessar o serviço de nuvem.
- [ ] A forma de disponibilização (no repositório ou por instruções no README) está definida e registrada.
- [ ] A decisão sobre o que pode ser publicado no repositório, considerando a diferença entre credenciais públicas e privadas, está registrada com justificativa (ambiguidade A1).
- [ ] Os parâmetros estão concentrados em um único ponto do projeto.
- [ ] Alguém sem acesso ao console da nuvem consegue obter todos os parâmetros pelo repositório e pelas instruções.
- [ ] As instruções estão prontas para serem incorporadas ao `README.md` no CARD-033.

## Dependências

- [CARD-004] Criar projeto Flutter base.
- [CARD-005] Configurar o serviço de nuvem e a estrutura de armazenamento.

## Observações técnicas

Concentrar os parâmetros em um único ponto facilita a leitura e a conferência pelo avaliador. O CARD-010 e o CARD-011 devem ler os parâmetros desse ponto, sem duplicá-los. O PDF proíbe versionar "credenciais privadas" (seção 7), mas exige fornecer chaves e identificadores (seção 8.2). A equipe deve decidir o que se enquadra em cada caso e documentar a decisão, preferencialmente após consultar o professor.

## Definition of Done

- [ ] Atividade concluída.
- [ ] Critérios de aceitação atendidos.
- [ ] Parâmetros validados por um integrante que não participou da configuração.
- [ ] Conteúdo integrado ao repositório, quando aplicável.