# CARD-029 Garantir adaptação a diferentes telas e ausência de overflow

**Tipo:** Task  
**Prioridade:** Alta  
**Complexidade:** Média  
**Status inicial:** Backlog

## Descrição

Verificar e ajustar as duas telas (listagem e cadastro) para que se adaptem a diferentes tamanhos de tela, sem overflow de conteúdo e sem controles inacessíveis, inclusive com o teclado aberto e com textos no tamanho máximo permitido.

## Requisitos relacionados

- RNF01.3: adaptar-se a diferentes tamanhos de tela.
- RNF01.4: evitar overflow e controles inacessíveis.

## Critérios de aceitação

- [ ] As duas telas foram verificadas em pelo menos duas larguras e duas alturas diferentes de tela.
- [ ] Nenhuma tela exibe sinalização de overflow (faixa de erro de layout) em nenhum dos tamanhos verificados.
- [ ] A tela de listagem foi verificada com registros de nome com 60 caracteres e descrição com 200 caracteres.
- [ ] O formulário de cadastro continua utilizável com o teclado aberto: todos os campos e a ação de salvar podem ser alcançados.
- [ ] A rotação do dispositivo, se a plataforma a permitir, não causa overflow nem perda dos dados digitados.
- [ ] Os controles continuam acessíveis nos tamanhos verificados (nada fora da área visível ou sobreposto).
- [ ] Os tamanhos e plataformas verificados estão registrados.

## Dependências

- [CARD-019] Construir a tela de listagem com os dados dos objetos.
- [CARD-024] Construir o formulário de cadastro com os campos definidos.

## Observações técnicas

Usar os recursos de layout adaptativo do Flutter e as ferramentas de visualização em diferentes dimensões do ambiente de desenvolvimento. O documento não define as plataformas-alvo (ambiguidade A10), e a verificação deve cobrir ao menos a plataforma usada na avaliação, conforme registrado no CARD-004. As configurações de acessibilidade do sistema, como texto ampliado, afetam o layout e vale incluí-las na verificação como boa prática, embora o documento não as exija explicitamente.

## Definition of Done

- [ ] Atividade concluída.
- [ ] Critérios de aceitação atendidos.
- [ ] Verificação em múltiplos tamanhos registrada.
- [ ] Ajustes revisados por outro integrante e integrados ao ramo principal.