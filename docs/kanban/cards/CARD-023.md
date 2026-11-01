# CARD-023 Disponibilizar acesso ao cadastro na tela de listagem

**Tipo:** Feature  
**Prioridade:** Alta  
**Complexidade:** Pequena  
**Status inicial:** Backlog

## Descrição

Incluir na tela de listagem um controle visível que leve o usuário à tela de cadastro de objetos, conforme exige a descrição das funcionalidades mínimas da interface.

## Requisitos relacionados

- TL01: tela de listagem com acesso ao cadastro de objetos.
- RNF01.1: utilizar componentes do Material 3.
- RNF01.4: evitar overflow e controles inacessíveis.

## Critérios de aceitação

- [ ] A tela de listagem exibe um controle de acesso ao cadastro, visível sem rolar a lista.
- [ ] O controle tem rótulo ou descrição em português que indique sua função.
- [ ] Acionar o controle abre a tela de cadastro.
- [ ] O controle continua acessível quando a lista está longa.
- [ ] O controle não cobre o conteúdo essencial dos itens.
- [ ] O controle está disponível também quando a leitura está em carregamento ou em erro.

## Dependências

- [CARD-018] Estruturar a navegação entre listagem e cadastro.
- [CARD-019] Construir a tela de listagem com os dados dos objetos.

## Observações técnicas

O tipo de componente (botão flutuante, botão na barra superior ou outro) é decisão da equipe, desde que seja do Material 3 e fique acessível. Garantir que o controle permaneça utilizável quando o teclado ou a barra de navegação do dispositivo reduzirem a área disponível. A verificação em diferentes tamanhos de tela está no CARD-029.

## Definition of Done

- [ ] Implementação concluída.
- [ ] Critérios de aceitação atendidos.
- [ ] Controle verificado com lista vazia, lista longa e tela de erro.
- [ ] Código revisado por outro integrante e integrado ao ramo principal.