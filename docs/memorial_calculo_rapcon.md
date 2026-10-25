MEMORIAL DE CÁLCULO — RAPCON

Cálculo de coordenadas tridimensionais

O cálculo das coordenadas é uma das etapas utilizadas no desenvolvimento dos comandos do RAPCON. Essa parte tem como objetivo determinar a posição de novos pontos a partir de uma coordenada inicial, uma direção definida e os valores de distância e diferença de cota informados pelo usuário.

Para realizar esses cálculos, utilizamos relações trigonométricas, permitindo determinar as novas coordenadas X, Y e Z dos pontos.

Parâmetros utilizados

O cálculo considera um ponto inicial, representado pelas coordenadas X, Y e Z, e um segundo ponto utilizado para definir a direção do deslocamento.

Além disso, são informados a distância horizontal desejada e o valor da diferença de cota em relação ao ponto inicial.

Cálculo das coordenadas

Inicialmente, é determinado o ângulo de direção entre o ponto de referência e o segundo ponto selecionado. No AutoLISP, esse cálculo é realizado pela função angle, que retorna o ângulo em radianos.

Com o ângulo definido, são utilizadas as seguintes expressões:

Xnovo = Xinicial + distância × cos(ângulo)

Ynovo = Yinicial + distância × sen(ângulo)

Znovo = Zinicial + diferença de cota

As coordenadas X e Y são determinadas a partir da distância e da direção do deslocamento, enquanto a coordenada Z é calculada somando a diferença de cota à elevação inicial.

Exemplo de aplicação

Considerando um ponto inicial com coordenadas X = 1000 m, Y = 2000 m e Z = 50 m, uma direção de 0° em relação ao eixo X positivo, uma distância de 20 m e uma diferença de cota de 1,5 m, temos:

Xnovo = 1000 + 20 × cos(0°) = 1020 m

Ynovo = 2000 + 20 × sen(0°) = 2000 m

Znovo = 50 + 1,5 = 51,5 m

Dessa forma, o novo ponto calculado apresenta as coordenadas X = 1020 m, Y = 2000 m e Z = 51,5 m.

Esse exemplo demonstra o funcionamento matemático do cálculo e pode ser utilizado como referência para conferir os resultados da rotina.

Aplicação no RAPCON

Esses cálculos foram organizados na função rapcon-calcular-coordenadas, desenvolvida em AutoLISP, que recebe os parâmetros necessários e retorna uma lista contendo as novas coordenadas X, Y e Z.

Essa função representa somente a parte de cálculo geométrico, não realizando diretamente a criação dos pontos no Civil 3D.

Situação atual

A lógica de cálculo faz parte das rotinas desenvolvidas anteriormente para o RAPCON. Nesta etapa, estamos organizando e documentando seu funcionamento para facilitar o entendimento do código e o acompanhamento do projeto no GitHub.

A função de cálculo separada ainda poderá passar por verificações específicas, além de possíveis ajustes durante o desenvolvimento da disciplina.