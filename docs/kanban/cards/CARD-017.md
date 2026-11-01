# CARD-017 Configurar tema Material 3 e idioma português

**Tipo:** Task  
**Prioridade:** Alta  
**Complexidade:** Pequena  
**Status inicial:** Backlog

## Descrição

Configurar o aplicativo para usar os componentes do Material 3 e para apresentar toda a interface em português do Brasil, incluindo os textos padrão fornecidos pelo próprio framework.

Esta é a base visual e de idioma para todas as telas.

## Requisitos relacionados

- RNF01.1: utilizar componentes do Material 3.
- RNF01.2: apresentar interface em português.

## Critérios de aceitação

- [ ] O tema do aplicativo habilita o Material 3.
- [ ] O idioma do aplicativo está definido como português do Brasil.
- [ ] Textos padrão do framework (por exemplo, dicas de botões e mensagens de campos) aparecem em português.
- [ ] O título do aplicativo está em português.
- [ ] Não há texto em inglês visível ao usuário no aplicativo base.
- [ ] O aplicativo continua executando sem erros após a configuração.

## Dependências

- [CARD-004] Criar projeto Flutter base.

## Observações técnicas

O suporte a localização faz parte do SDK do Flutter e deve ser configurado sem depender de bibliotecas de terceiros, salvo se houver necessidade comprovada. Os identificadores técnicos continuam em inglês, e apenas os textos exibidos ao usuário ficam em português (CARD-008). A escolha da paleta de cores e da tipografia não é regulamentada pelo documento e pode ser simples.

## Definition of Done

- [ ] Implementação concluída.
- [ ] Critérios de aceitação atendidos.
- [ ] Aplicativo executado e conferido visualmente.
- [ ] Código revisado por outro integrante e integrado ao ramo principal.