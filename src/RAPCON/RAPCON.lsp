; =====================================================================
; RAPCON - Random Points Created Out of Nothing
;
; Cria pontos COGO no Civil 3D a partir de um ponto existente,
; uma direcao, uma distancia horizontal e uma diferenca de cota.
;
; Uso:
;   1. Carregar com APPLOAD o arquivo RAPCON.lsp
;   2. Digitar RAPCON na linha de comando
;   3. Selecionar o ponto de partida (OSNAP Node ligado)
;   4. Indicar a direcao
;   5. Informar distancia, diferenca de cota e descricao de cada
;      novo ponto. Cada ponto e medido a partir do anterior.
;   6. Enter vazio na distancia (ou Esc) encerra o comando
;
; Calculos descritos em docs/memorial_calculo_rapcon.md
; =====================================================================

; ---------------------------------------------------------------------
; CALCULO DE COORDENADAS 3D
;
; Funcao responsavel pelos calculos geometricos. Nao interage com o
; usuario nem com o desenho, por isso pode ser testada isoladamente
; (ver tests/teste_calculo_coordenadas.lsp).
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

(defun c:RAPCON ( / *error* osmodeAntigo cmdechoAntigo pontoBase
                    direcao angulo distancia diferencaCota descricao
                    pontoDirecao novoPonto contador)

  ; Restaura as variaveis do sistema em caso de erro ou Esc
  (defun *error* (msg)
    (if osmodeAntigo (setvar "OSMODE" osmodeAntigo))
    (if cmdechoAntigo (setvar "CMDECHO" cmdechoAntigo))
    (if (not (member msg '("Function cancelled" "quit / exit abort"
                           "Função cancelada" "Funcao cancelada")))
      (princ (strcat "\nErro: " msg))
    )
    (princ)
  )

  (cond
    ; Ponto de partida (com Node ligado, o Z vem do ponto COGO)
    ((not (setq pontoBase (getpoint "\nSelecione ponto de partida: "))))

    ; Direcao dos novos pontos
    ((not (setq direcao (getpoint pontoBase "\nDetermine a direção: "))))

    (T
     ; O angulo e calculado uma unica vez: assim a direcao nao inverte
     ; quando a sequencia de pontos passa do ponto clicado
     (setq angulo (angle pontoBase direcao))
     (setq contador 0)

     (while (setq distancia
                  (getreal "\nDistância do ponto anterior <Enter para encerrar>: "))

       (setq diferencaCota
             (getreal "\nDiferença de cota do ponto anterior (+/-) <0>: "))
       (if (not diferencaCota) (setq diferencaCota 0.0))

       (setq descricao (getstring T "\nDescrição do novo ponto: "))

       ; Ponto auxiliar na direcao escolhida, a partir do ponto atual
       (setq pontoDirecao (polar pontoBase angulo 1.0))

       ; Calculo das coordenadas (funcao rapcon-calcular-coordenadas, acima)
       (setq novoPonto
             (rapcon-calcular-coordenadas
               pontoBase pontoDirecao distancia diferencaCota))

       (princ (strcat "\nCoordenadas do novo ponto:"
                      "\nX: " (rtos (car novoPonto) 2 4)
                      "\nY: " (rtos (cadr novoPonto) 2 4)
                      "\nZ: " (rtos (caddr novoPonto) 2 4)
                      "\nDescrição: " descricao))

       ; Desliga o OSNAP so durante a criacao, para as coordenadas
       ; digitadas nao serem "puxadas" para objetos proximos
       (setq osmodeAntigo (getvar "OSMODE")
             cmdechoAntigo (getvar "CMDECHO"))
       (setvar "OSMODE" 0)
       (setvar "CMDECHO" 0)

       (rapcon-criar-ponto novoPonto descricao)

       (setvar "OSMODE" osmodeAntigo)
       (setvar "CMDECHO" cmdechoAntigo)

       ; O proximo ponto e medido a partir deste
       (setq pontoBase novoPonto
             contador (1+ contador))
     )

     (princ (strcat "\nRAPCON: " (itoa contador) " ponto(s) criado(s)."))
    )
  )
  (princ)
)

; ---------------------------------------------------------------------
; Cria um ponto COGO com o comando -CREATEPOINTMANUAL do Civil 3D.
; Requer, em Point Creation, "Prompt For Descriptions" e
; "Prompt For Elevations" ativados (ordem: posicao, descricao, cota).
; ---------------------------------------------------------------------
(defun rapcon-criar-ponto (ponto descricao)
  (command "_.-CREATEPOINTMANUAL"
           (strcat (rtos (car ponto) 2 8) "," (rtos (cadr ponto) 2 8))
           descricao
           (rtos (caddr ponto) 2 8))
  ; Encerra o comando (que pediria um novo ponto) sem repetir nada
  (while (> (getvar "CMDACTIVE") 0)
    (command "")
  )
)

(princ "\nR.A.P.C.O.N - Random Points Created Out of Nothing")
(princ "\nCriado por Boreal - V.20240316.1801")
(princ "\nDigite RAPCON para iniciar.")
(princ)