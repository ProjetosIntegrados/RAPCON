# RAPCON

> [!WARNING]
> Este projeto foi desenvolvido por estudantes no contexto de uma disciplina de graduação e possui finalidade exclusivamente educacional. Os resultados não foram necessariamente validados para uso profissional e devem ser utilizados com cautela e verificados independentemente.

**RAPCON** (*Random Points Created Out of Nothing*) é uma rotina em AutoLISP para o **AutoCAD Civil 3D**. Ela cria pontos COGO a partir de um ponto já levantado, de uma direção, de uma distância horizontal e de uma diferença de cota.

## Descrição

Em levantamentos topográficos, nem todos os pontos são medidos com a estação total. Pontos como o **terreno natural (TN)** ou uma **cerca** ao lado de uma faixa costumam ser medidos com trena e nível a partir de um ponto já levantado. Em campo, anota-se a distância e a diferença de cota.

Sem uma ferramenta, o usuário precisa calcular as coordenadas de cada ponto à mão e criá-las uma a uma no Civil 3D. O processo é lento e sujeito a erros.

O RAPCON automatiza esse processo:

- o usuário seleciona o ponto de partida e indica a direção (por exemplo, perpendicular à faixa);
- para cada novo ponto, informa a **distância**, a **diferença de cota** e a **descrição**;
- a rotina calcula X, Y e Z e cria o ponto COGO no desenho;
- os pontos são criados em sequência, cada um medido a partir do anterior;
- depois disso, basta reconstruir (*Rebuild*) a superfície para incluir os novos pontos.

Os cálculos estão descritos no [memorial de cálculo](docs/memorial_calculo_rapcon.md).

## Requisitos

- AutoCAD Civil 3D (testado na versão **[preencher]**)
- Em *Point Creation*, as opções **Prompt For Descriptions** e **Prompt For Elevations** ativadas

## Instalação

1. Baixe o repositório (*Code → Download ZIP*) ou a [versão mais recente](../../releases).
2. No Civil 3D, digite `APPLOAD`.
3. Selecione o arquivo `src/RAPCON/RAPCON.lsp` e clique em **Load**.

> Para carregar automaticamente sempre que o Civil 3D abrir, adicione o arquivo em **Startup Suite**, na janela do `APPLOAD`.

## Uso

1. Ligue o OSNAP **Node**, para que a rotina pegue a cota do ponto selecionado.
2. Digite `RAPCON`.
3. Clique no ponto COGO de partida.
4. Clique em um ponto que indique a direção dos novos pontos.
5. Para cada novo ponto, informe:
   - a distância a partir do ponto anterior;
   - a diferença de cota em relação ao ponto anterior (+/-);
   - a descrição (ex.: `TN`, `CERCA`).
6. Pressione **Enter** sem digitar nada na distância para encerrar.

Exemplo de sessão na linha de comando:

```text
Comando: RAPCON
Selecione ponto de partida:            (clique no ponto)
Determine a direção:                   (clique na direção)
Distância do ponto anterior <Enter para encerrar>: 10
Diferença de cota do ponto anterior (+/-) <0>: -4
Descrição do novo ponto: TN
Coordenadas do novo ponto:
X: ...
Y: ...
Z: ...
Distância do ponto anterior <Enter para encerrar>:
RAPCON: 1 ponto(s) criado(s).
```

## Exemplos

O diretório [`exemplos/`](exemplos/) traz um passo a passo completo com um desenho de levantamento (`exemplo_01.dwg`): criação de pontos de TN e cerca e atualização da superfície.

## Testes

Os testes estão em [`tests/`](tests/) e verificam a função de cálculo `rapcon-calcular-coordenadas` com casos calculados à mão: direções de 0°, 45°, 90° e 180°, cota negativa e distância zero.

Para rodar no Civil 3D (ou no AutoCAD):

1. `APPLOAD` → `src/RAPCON/RAPCON.lsp`
2. `APPLOAD` → `tests/teste_calculo_coordenadas.lsp`
3. Digite `RAPCON_TESTES`

Cada caso mostra `[PASSOU]` ou `[FALHOU]`. No final aparece o total.

## Estrutura do projeto

```text
.
├── src/
│   └── RAPCON/
│       └── RAPCON.lsp               # cálculo das coordenadas e comando RAPCON
├── tests/
│   └── teste_calculo_coordenadas.lsp
├── exemplos/
│   ├── README.md                    # passo a passo do exemplo
│   └── exemplo_01.dwg
├── docs/
│   └── memorial_calculo_rapcon.md
├── README.md
├── LICENSE
└── pyproject.toml
```

## Desenvolvimento

- Dentro do `RAPCON.lsp`, o cálculo fica numa função separada (`rapcon-calcular-coordenadas`), que não interage com o usuário nem com o desenho. O comando `RAPCON` pede os dados, chama essa função e cria os pontos. Assim o cálculo pode ser testado isoladamente.
- A direção é calculada uma única vez, no início. Por isso ela não inverte quando os pontos passam do ponto clicado.
- Para contribuir: abra uma *issue*, crie um *branch* para a alteração e envie um *Pull Request*.

## Autores

**Alunos**

* [Milena Dressler] (2026/2)
* [Vitor Salbego] (2026/2)
* [Nome completo] (2026/2)

**Professores orientadores**

* Felipe Pinto da Motta Quevedo
* Felipe Schaedler de Almeida

## Referências

- AUTODESK. *AutoLISP Developer's Guide*. Documentação do AutoCAD.
- AUTODESK. *Civil 3D Help: Creating Points* (comando `CREATEPOINTMANUAL`).
- [Referência de topografia usada pelo grupo, se houver]

## Licença

Este projeto está distribuído sob a licença MIT. Consulte o arquivo [`LICENSE`](LICENSE).