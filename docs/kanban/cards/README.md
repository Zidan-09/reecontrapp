# Índice de cartões

Total: **39 cartões**. Status inicial de todos: **Backlog**.

Legenda de complexidade: **P** = Pequena, **M** = Média, **G** = Grande (não há cartões Grandes).

## Planejamento e estruturação

| ID | Título | Tipo | Prioridade | Compl. | Dependências |
|---|---|---|---|---|---|
| [CARD-001](CARD-001.md) | Registrar integrantes e responsabilidades da equipe | Task | Alta | P | Nenhuma |
| [CARD-002](CARD-002.md) | Escolher serviço de armazenamento em nuvem gratuito | Task | Alta | M | Nenhuma |

## Configuração do projeto e da nuvem

| ID | Título | Tipo | Prioridade | Compl. | Dependências |
|---|---|---|---|---|---|
| [CARD-003](CARD-003.md) | Criar repositório público no GitHub com `.gitignore` | Task | Alta | P | CARD-001 |
| [CARD-004](CARD-004.md) | Criar projeto Flutter base | Task | Alta | P | CARD-003 |
| [CARD-005](CARD-005.md) | Configurar o serviço de nuvem e a estrutura de armazenamento | Task | Alta | M | CARD-002 |
| [CARD-006](CARD-006.md) | Definir regras de acesso compatíveis com app sem autenticação | Task | Alta | P | CARD-005 |
| [CARD-007](CARD-007.md) | Definir e disponibilizar parâmetros de configuração da nuvem | Task | Alta | P | CARD-004, CARD-005 |
| [CARD-008](CARD-008.md) | Estabelecer convenções de código e organização do projeto | Task | Média | P | CARD-004 |

## Persistência de dados e integração

| ID | Título | Tipo | Prioridade | Compl. | Dependências |
|---|---|---|---|---|---|
| [CARD-009](CARD-009.md) | Definir o modelo de dados do objeto | Task | Alta | P | CARD-004, CARD-008 |
| [CARD-010](CARD-010.md) | Implementar leitura assíncrona dos registros na nuvem | Feature | Alta | M | CARD-006, CARD-007, CARD-009 |
| [CARD-011](CARD-011.md) | Implementar gravação assíncrona de registro na nuvem | Feature | Alta | M | CARD-006, CARD-007, CARD-009 |
| [CARD-012](CARD-012.md) | Registrar data e hora do cadastro automaticamente | Feature | Alta | P | CARD-011 |
| [CARD-013](CARD-013.md) | Ordenar registros do mais recente para o mais antigo | Feature | Alta | P | CARD-010, CARD-012 |
| [CARD-014](CARD-014.md) | Converter falhas de comunicação em mensagens compreensíveis | Feature | Alta | M | CARD-010, CARD-011 |

## Gerenciamento de estado

| ID | Título | Tipo | Prioridade | Compl. | Dependências |
|---|---|---|---|---|---|
| [CARD-015](CARD-015.md) | Implementar gerenciamento de estado da listagem | Feature | Alta | M | CARD-010, CARD-014 |
| [CARD-016](CARD-016.md) | Implementar gerenciamento de estado do envio do formulário | Feature | Alta | M | CARD-011, CARD-014, CARD-015 |

## Interface e funcionalidades

| ID | Título | Tipo | Prioridade | Compl. | Dependências |
|---|---|---|---|---|---|
| [CARD-017](CARD-017.md) | Configurar tema Material 3 e idioma português | Task | Alta | P | CARD-004 |
| [CARD-018](CARD-018.md) | Estruturar a navegação entre listagem e cadastro | Task | Alta | P | CARD-017 |
| [CARD-019](CARD-019.md) | Construir a tela de listagem com os dados dos objetos | Feature | Alta | M | CARD-009, CARD-015, CARD-018 |
| [CARD-020](CARD-020.md) | Identificar visualmente objetos perdidos e encontrados | Feature | Alta | P | CARD-019 |
| [CARD-021](CARD-021.md) | Exibir carregamento e falhas na listagem com nova tentativa | Feature | Alta | M | CARD-014, CARD-015, CARD-019 |
| [CARD-022](CARD-022.md) | Implementar a atualização manual da listagem | Feature | Alta | P | CARD-015, CARD-019 |
| [CARD-023](CARD-023.md) | Disponibilizar acesso ao cadastro na tela de listagem | Feature | Alta | P | CARD-018, CARD-019 |
| [CARD-024](CARD-024.md) | Construir o formulário de cadastro com os campos definidos | Feature | Alta | M | CARD-017, CARD-018 |
| [CARD-025](CARD-025.md) | Implementar a validação dos campos do formulário | Feature | Alta | M | CARD-024 |
| [CARD-026](CARD-026.md) | Implementar o salvamento com indicador de processamento e bloqueio de reenvio | Feature | Alta | M | CARD-016, CARD-025 |
| [CARD-027](CARD-027.md) | Tratar falha de gravação com mensagem e nova tentativa | Feature | Alta | P | CARD-014, CARD-026 |
| [CARD-028](CARD-028.md) | Exibir o novo registro na listagem após o cadastro | Feature | Alta | P | CARD-019, CARD-026 |
| [CARD-029](CARD-029.md) | Garantir adaptação a diferentes telas e ausência de overflow | Task | Alta | M | CARD-019, CARD-024 |

## Qualidade de código

| ID | Título | Tipo | Prioridade | Compl. | Dependências |
|---|---|---|---|---|---|
| [CARD-030](CARD-030.md) | Revisar nomenclatura, duplicação e separação de camadas | Task | Média | M | CARD-028, CARD-029 |
| [CARD-031](CARD-031.md) | Executar `flutter analyze` e corrigir os problemas | Task | Alta | P | CARD-030 |
| [CARD-032](CARD-032.md) | Formatar o código com `dart format .` | Task | Alta | P | CARD-031 |

## Documentação e repositório

| ID | Título | Tipo | Prioridade | Compl. | Dependências |
|---|---|---|---|---|---|
| [CARD-033](CARD-033.md) | Redigir o `README.md` do repositório | Documentation | Alta | M | CARD-001, CARD-002, CARD-007, CARD-028 |
| [CARD-034](CARD-034.md) | Verificar ausência de artefatos de build e credenciais privadas | Task | Alta | P | CARD-003, CARD-007 |
| [CARD-035](CARD-035.md) | Garantir commits identificáveis de todos os integrantes | Task | Alta | P | CARD-001 |

## Testes e validação

| ID | Título | Tipo | Prioridade | Compl. | Dependências |
|---|---|---|---|---|---|
| [CARD-036](CARD-036.md) | Validar manualmente os fluxos de listagem, cadastro e erro | Test | Alta | M | CARD-021, CARD-022, CARD-027, CARD-028, CARD-029 |
| [CARD-037](CARD-037.md) | Validar persistência e compartilhamento entre instalações | Test | Alta | M | CARD-028 |
| [CARD-038](CARD-038.md) | Validar compilação e execução a partir de clone limpo | Test | Alta | M | CARD-032, CARD-033, CARD-034 |

## Entrega

| ID | Título | Tipo | Prioridade | Compl. | Dependências |
|---|---|---|---|---|---|
| [CARD-039](CARD-039.md) | Executar o checklist da seção 8.3 e entregar no SIGAA | Task | Alta | P | CARD-031 a CARD-038 |

## Resumo

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