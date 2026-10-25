
; RAPCON - CALCULO DE COORDENADAS 3D
;
; Modulo responsavel pelos calculos
; geometricos utilizados na geracao
; de pontos tridimensionais.
;
; Entradas:
; pontoBase - Coordenadas iniciais X, Y e Z
; direcao - Ponto que define a direcao
; distancia - Distancia horizontal
; diferencaCota - Variacao da cota
;
; Saida:
; Lista com as coordenadas X, Y e Z

(defun rapcon-calcular-coordenadas
  (pontoBase direcao distancia diferencaCota
   / angulo novoX novoY novoZ)

  ; Determina o angulo de referencia
  (setq angulo
    (angle pontoBase direcao)
  )

  ; Calcula a coordenada X
  (setq novoX
    (+ (car pontoBase)
       (* distancia (cos angulo)))
  )

  ; Calcula a coordenada Y
  (setq novoY
    (+ (cadr pontoBase)
       (* distancia (sin angulo)))
  )

  ; Calcula a coordenada Z
  (setq novoZ
    (+ (caddr pontoBase) diferencaCota)
  )

  ; Retorna as coordenadas calculadas
  (list novoX novoY novoZ)
)
