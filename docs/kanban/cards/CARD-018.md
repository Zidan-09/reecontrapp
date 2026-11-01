# CARD-018 Estruturar a navegação entre listagem e cadastro

**Tipo:** Task  
**Prioridade:** Alta  
**Complexidade:** Pequena  
**Status inicial:** Backlog

## Descrição

Estruturar a navegação do aplicativo, com a tela de listagem como tela inicial e a tela de cadastro como destino, incluindo o retorno à listagem.

O documento deixa a organização da navegação e o uso de telas adicionais a critério da equipe. Este cartão cria apenas a estrutura mínima para as duas telas obrigatórias, que serão preenchidas nos CARD-019 e CARD-024.

## Requisitos relacionados

- TL01: tela de listagem com acesso ao cadastro de objetos.
- TL02: tela de cadastro.
- TL03: a organização da navegação e a utilização de telas adicionais ficam a critério da equipe.

## Critérios de aceitação

- [ ] O aplicativo abre na tela de listagem.
- [ ] É possível navegar da tela de listagem para a tela de cadastro.
- [ ] É possível voltar da tela de cadastro para a tela de listagem sem salvar.
- [ ] O retorno pelo mecanismo padrão de voltar do dispositivo funciona.
- [ ] Nenhuma tela adicional foi criada sem necessidade.
- [ ] Os títulos das telas estão em português.

## Dependências

- [CARD-017] Configurar tema Material 3 e idioma português.

## Observações técnicas

Usar os recursos de navegação do próprio Flutter, sem acrescentar bibliotecas de roteamento sem necessidade comprovada. Este cartão pode usar telas provisórias, que serão substituídas pelos CARD-019 e CARD-024. O comportamento de retorno após um cadastro bem-sucedido deve ser definido no CARD-026.

## Definition of Done

- [ ] Implementação concluída.
- [ ] Critérios de aceitação atendidos.
- [ ] Navegação testada em ida, volta e botão voltar do dispositivo.
- [ ] Código revisado por outro integrante e integrado ao ramo principal.