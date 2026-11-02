# CARD-005 Configurar o serviço de nuvem e a estrutura de armazenamento

**Tipo:** Task  
**Prioridade:** Alta  
**Complexidade:** Média  
**Status inicial:** Backlog

## Descrição

Criar a conta e o projeto no serviço escolhido no CARD-002, usando exclusivamente o plano gratuito, e preparar a estrutura de armazenamento que receberá os registros de objetos (nome, descrição, local, situação e data/hora do cadastro).

Este cartão deixa o serviço pronto para ser acessado pelo aplicativo. As regras de acesso são tratadas no CARD-006 e os parâmetros de configuração no CARD-007.

## Requisitos relacionados

- RF05.1: utilizar exclusivamente serviços com plano gratuito.
- RT02: armazenamento em nuvem exclusivamente com serviços gratuitos.

## Critérios de aceitação

- [x] O projeto no serviço de nuvem está criado no plano gratuito, sem cobrança ativa.
- [x] Existe uma estrutura de armazenamento com campos correspondentes a nome, descrição, local, situação e data/hora do cadastro.
- [x] Os nomes de campos e coleções (ou equivalentes) seguem o padrão de identificadores técnicos em inglês.
- [ ] Um registro de teste foi criado e lido pelo console do serviço, e contém apenas dados demonstrativos.
- [ ] Pelo menos dois integrantes têm acesso administrativo ao projeto na nuvem.
- [x] Os dados de acesso administrativo ao console não estão no repositório.

## Dependências

- [CARD-002] Escolher serviço de armazenamento em nuvem gratuito.

## Observações técnicas

Alinhar os nomes dos campos com o modelo definido no CARD-009, sem esperar a conclusão dele. Se o registro de teste for mantido ou removido, registrar a decisão (ambiguidade A8). Evitar que a configuração dependa da conta pessoal de um único integrante, pois o avaliador precisa acessar o serviço mesmo que essa pessoa esteja indisponível.

## Definition of Done

- [x] Atividade concluída.
- [ ] Critérios de aceitação atendidos.
- [ ] Configuração conferida por pelo menos um segundo integrante.