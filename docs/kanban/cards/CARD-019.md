# CARD-019 Construir a tela de listagem com os dados dos objetos

**Tipo:** Feature  
**Prioridade:** Alta  
**Complexidade:** Média  
**Status inicial:** Backlog

## Descrição

Construir a tela de listagem, que apresenta os objetos perdidos e encontrados carregados da nuvem. Cada item deve exibir nome, local, situação e descrição.

A tela consome o estado da listagem (CARD-015) e carrega os dados ao ser aberta. Os indicadores de carregamento e erro (CARD-021), a identificação visual da situação (CARD-020), a atualização (CARD-022) e o acesso ao cadastro (CARD-023) são tratados em cartões próprios.

## Requisitos relacionados

- RF01.1: carregar os registros armazenados na nuvem.
- RF01.2: exibir nome, local, situação e descrição de cada objeto.
- TL01: tela de listagem com exibição dos objetos perdidos e encontrados.
- RNF01.1: utilizar componentes do Material 3.
- RNF02.3: separação adequada entre interface, modelos e acesso aos dados.
- RT06: não utilizar dados fictícios definidos no código em substituição ao armazenamento remoto.

## Critérios de aceitação

- [ ] Ao abrir o aplicativo, os registros da nuvem são carregados e exibidos.
- [ ] Cada item exibe nome, local, situação e descrição.
- [ ] Objetos perdidos e encontrados aparecem na mesma lista.
- [ ] A lista pode ser rolada quando há mais itens que cabem na tela.
- [ ] A tela usa componentes do Material 3.
- [ ] Nenhum dado é definido no código em lugar dos dados remotos.
- [ ] A tela não acessa o serviço de nuvem diretamente, apenas o estado do CARD-015.
- [ ] Todos os textos fixos da tela estão em português.

## Dependências

- [CARD-009] Definir o modelo de dados do objeto.
- [CARD-015] Implementar gerenciamento de estado da listagem.
- [CARD-018] Estruturar a navegação entre listagem e cadastro.

## Observações técnicas

Textos longos, como a descrição de até 200 caracteres, devem caber no item sem causar overflow. Se a descrição for truncada na listagem, o usuário ainda deve conseguir lê-la por completo, pois o documento pede que a descrição seja exibida. A decisão deve ser registrada. A verificação em diferentes tamanhos de tela é feita no CARD-029. O comportamento da lista sem registros não é definido no PDF (ambiguidade A12).

## Definition of Done

- [ ] Implementação concluída.
- [ ] Critérios de aceitação atendidos.
- [ ] Tela verificada com registros reais da nuvem.
- [ ] Código revisado por outro integrante e integrado ao ramo principal.