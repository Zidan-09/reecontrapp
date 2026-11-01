# CARD-038 Validar compilação e execução a partir de clone limpo

**Tipo:** Test  
**Prioridade:** Alta  
**Complexidade:** Média  
**Status inicial:** Backlog

## Descrição

Simular o que o avaliador fará: clonar o repositório público em um local novo, seguir apenas as instruções do README, instalar as dependências, configurar a nuvem, compilar e executar o aplicativo.

O objetivo é detectar arquivos faltantes, passos omitidos, parâmetros ausentes e dependências de configurações locais, que são causas explícitas de penalidade na seção 8.4.

## Requisitos relacionados

- DOC01: repositório público no GitHub com o código-fonte completo.
- ENT03: o projeto deve estar funcional e disponível para avaliação.
- ENT04: proibido incluir artefatos de compilação e arquivos gerados.
- ENT05: fornecer as informações de configuração da nuvem no repositório ou no README.
- ENT07: ciência das penalidades da seção 8.4.
- RT06: não utilizar dados fictícios definidos no código em substituição ao armazenamento remoto.

## Critérios de aceitação

- [ ] O repositório foi clonado em um diretório novo, sem arquivos de build anteriores, a partir do link público.
- [ ] A verificação foi feita, de preferência, por um integrante que não configurou o ambiente original, ou em máquina diferente.
- [ ] Apenas as instruções do README foram usadas, sem conhecimento adicional.
- [ ] As dependências foram instaladas sem erros.
- [ ] A compilação foi concluída sem arquivos faltantes.
- [ ] O aplicativo executou e conectou-se à nuvem usando exclusivamente os parâmetros fornecidos no repositório ou no README.
- [ ] As funções principais (listar e cadastrar) funcionaram no clone limpo, com dados vindos da nuvem.
- [ ] `flutter analyze` e `dart format .` foram executados no clone, sem problemas e sem alterar arquivos.
- [ ] Após a execução, nenhum arquivo gerado apareceu como pendente de commit (o `.gitignore` os cobre).
- [ ] Toda lacuna encontrada nas instruções ou no repositório foi corrigida e a verificação foi refeita.

## Dependências

- [CARD-032] Formatar o código com `dart format .`.
- [CARD-033] Redigir o `README.md` do repositório.
- [CARD-034] Verificar ausência de artefatos de build e credenciais privadas.

## Observações técnicas

Usar o repositório público, e não uma cópia local, para confirmar também que o repositório está acessível sem login. Tratar como defeito qualquer dependência de caminho, variável de ambiente ou arquivo local não documentado. A plataforma de teste deve ser a registrada no README (ambiguidade A10). Se alguma correção de código ou documentação for feita, repetir este cartão.

## Definition of Done

- [ ] Verificação concluída e resultados registrados.
- [ ] Critérios de aceitação atendidos.
- [ ] Lacunas corrigidas no repositório e verificação repetida.
- [ ] Registro revisado por outro integrante.