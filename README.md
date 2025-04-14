# Super Mario Bros em Assembly

## 1. Super Mario Bros a Recriação da Primeira Fase

Este projeto recria a primeira fase do clássico jogo *Super Mario Bros* utilizando a linguagem Assembly para o microprocessador RISC-V com a ISA RV32IMF implementada em FPGA. Foi desenvolvido como parte da disciplina Organização e Arquitetura de Computadores (OAC) na Universidade de Brasília (UnB) e tem como objetivo aplicar conhecimentos teóricos em um desafio prático.

### Propósito
- Demonstrar conceitos de arquitetura de computadores por meio de um projeto divertido e educativo.
- Resolver problemas relacionados à programação em baixo nível, como controle de gráficos, áudio e interação.

### Tecnologias Utilizadas
- **RARS**: Simulador para execução de programas em Assembly RISC-V.
- **FPGA**: Implementação do microprocessador RISC-V com ISA RV32IMF.
- **Ferramentas de IO**: Simulação de teclado, display VGA e sintetizador MIDI.

### Desafios Enfrentados
- Implementação de física e movimentação do personagem.
- Desenvolvimento de um background móvel sincronizado com o deslocamento do Mario.
- Limitações na implementação de inimigos e interações completas devido ao tempo disponível.

## 2. Tabela de Conteúdo
- [Super Mario Bros](#1-Super-Mario-Bros)
- [Tabela de Conteúdo](#2-tabela-de-conteúdo)
- [Requisitos](#3-requisitos)
- [Instruções de Instalação](#4-instruções-de-instalação)
- [Exemplos de Uso](#5-exemplos-de-uso)
- [Documentação](#6-documentação)
- [Contribuições](#7-contribuições)
- [Licença](#8-licença)
- [Créditos](#9-créditos)
- [Preview](#10-Preview)

## 3. Requisitos
- Simulador RARS versão 1.6 Custom 1.
- Microprocessador RISC-V com ISA RV32IMF implementado em FPGA.
- Resolução gráfica mínima: 320x240 pixels no display VGA.

## 4. Instruções de Instalação
1. Baixe o simulador RARS na versão especificada.
2. Configure o ambiente para suportar a ISA RV32IMF.
3. Carregue os arquivos `src/main.asm` no simulador.
4. Execute o programa utilizando as ferramentas de IO disponíveis no RARS.

## 5. Exemplos de Uso
Após iniciar o jogo:
1. Utilize as teclas **A**, **S**, **W**, **D** para movimentar o Mario.
2. Observe o background móvel ao avançar na fase.
3. Colete cogumelos para ativar o power-up e aumentar o tamanho do personagem.

## 6. Documentação
Para mais detalhes sobre a implementação, consulte o Relatório detalhado do projeto ou entre em contato com os autores.
Foi testado em principalmente no SO Windown 10 através de um simulador RARS, e também em um Microprocessador RISC-V.


## 7. Contribuições
Contribuições são bem-vindas! Para colaborar:
1. Faça um fork deste repositório.
2. Envie um pull request com suas alterações ou melhorias.

## 8. Licença
Este projeto está licenciado sob a licença MIT.

## 9. Créditos
Desenvolvido por:
- Daniel Monteiro Oliveira  
- Felipe Costa de Sousa  
- Lucas Rocha dos Santos  
- Luís Augusto Araújo da Silva  
- Victória Silva da Rocha  

Departamento de Ciência da Computação - Universidade de Brasília (UnB).

## 10. Preview

![SuperMario](/images/SuperMario.png)
![Historia1](/images/historia1.jpg)
![Historia2](/images/historia2.jpg)
![Historia3](/images/historia3.jpg)
![Vitoria](/images/teladevitoria.jpg)
