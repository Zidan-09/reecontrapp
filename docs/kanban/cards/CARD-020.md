# CARD-020 Identificar visualmente objetos perdidos e encontrados

**Tipo:** Feature  
**Prioridade:** Alta  
**Complexidade:** Pequena  
**Status inicial:** Backlog

## Descrição

Fazer com que cada item da listagem indique visualmente se o objeto está perdido ou encontrado, de modo que o usuário reconheça a situação rapidamente ao percorrer a lista.

O documento exige a identificação visual, mas não define o recurso a usar (cor, ícone, rótulo etc.). A escolha é da equipe (ambiguidade A6).

## Requisitos relacionados

- RF01.3: identificar visualmente objetos perdidos e encontrados.
- TL01: identificação da situação de cada objeto.
- RB01: a situação do objeto assume apenas os valores "perdido" ou "encontrado".
- RNF01.1: utilizar componentes do Material 3.

## Critérios de aceitação

- [ ] Itens perdidos e itens encontrados têm aparência claramente distinta.
- [ ] Os dois valores de situação (perdido e encontrado) estão cobertos.
- [ ] O recurso visual é aplicado do mesmo modo a todos os itens.
- [ ] A situação continua informada em texto em português, e não apenas por recurso visual.
- [ ] A distinção foi verificada em uma lista com os dois tipos de item.
- [ ] A identificação usa componentes e recursos do Material 3.

## Dependências

- [CARD-019] Construir a tela de listagem com os dados dos objetos.

## Observações técnicas

Como sugestão (não é exigência do documento), evitar depender apenas da cor para diferenciar os itens, pois a combinação com texto ou ícone torna a distinção mais confiável em telas e condições diferentes. A cor deve estar vinculada ao tema do CARD-017, sem valores soltos repetidos pelo código.

## Definition of Done

- [ ] Implementação concluída.
- [ ] Critérios de aceitação atendidos.
- [ ] Verificação visual feita com os dois tipos de registro.
- [ ] Código revisado por outro integrante e integrado ao ramo principal.