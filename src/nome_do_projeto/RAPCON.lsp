(defun c:RAPCON ()
  (setq pontoExistente (getpoint "\nSelecione ponto de partida: "))
  (setq direcao (getpoint "\nDetermine a direção: "))
  (setq distancia (getreal "\nDistância do ponto base: "))
  (setq diferencaCota (getreal "\nDiferença de cota do ponto base (+/-): "))
  (setq descricao (getstring "\nDescrição do novo ponto: "))

  ; Calcula as coordenadas do novo ponto
  (setq novoX (+ (car pontoExistente) (* distancia (cos (angle pontoExistente direcao))))) 
  (setq novoY (+ (cadr pontoExistente) (* distancia (sin (angle pontoExistente direcao)))))
  (setq novoZ (+ (caddr pontoExistente) diferencaCota))

  ; Exibe as coordenadas calculadas para confirmação
  (princ (strcat "\nCoordenadas do novo ponto:"
                 "\nX: " (rtos novoX)
                 "\nY: " (rtos novoY)
                 "\nZ: " (rtos novoZ)
                 "\nDescrição: " descricao))

  ; Cria o ponto COGO automaticamente
  (criarPontoManual novoX novoY novoZ descricao)

  ; Reinicializa as variáveis para solicitar novos valores ao executar o comando novamente
  (setq distancia nil)
  (setq diferencaCota nil)

  ; Continua a criação de pontos
  (continuarCriacaoPonto novoX novoY novoZ direcao)
)

(defun criarPontoManual (x y z descricao)
  (command "-CREATEPOINTMANUAL")
  (command (strcat (rtos x) "," (rtos y))) ; Coordenadas X,Y
  (command descricao) ; Descrição 
  (command (rtos z)c:)
)

(defun continuarCriacaoPonto (x y z direcao)
  (setq distancia (getreal "\nDigite a nova distância do ponto base: "))
  (setq diferencaCota (getreal "\nDigite a nova diferença de cota do ponto base (+/-): "))
  (setq descricao (getstring "\nDigite a nova descrição do ponto: "))

  ; Calcula as coordenadas do novo ponto
  (setq novoX (+ x (* distancia (cos (angle (list x y) direcao))))) 
  (setq novoY (+ y (* distancia (sin (angle (list x y) direcao)))))
  (setq novoZ (+ z diferencaCota))

  ; Exibe as coordenadas calculadas para confirmação
  (princ (strcat "\nCoordenadas do novo ponto:"
                 "\nX: " (rtos novoX)
                 "\nY: " (rtos novoY)
                 "\nZ: " (rtos novoZ)
                 "\nDescrição: " descricao))

  ; Cria o ponto COGO automaticamente
  (criarPontoManual novoX novoY novoZ descricao)

  ; Continua a criação de pontos
  (continuarCriacaoPonto novoX novoY novoZ direcao)
)

(alert "R.A.P.C.O.N\nRandom Points Created Out of Nothing\nCriado por Boreal\nV.20240316.1801")
