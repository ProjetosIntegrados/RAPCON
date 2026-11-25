; =====================================================================
; RAPCON - Testes da funcao rapcon-calcular-coordenadas
;
; Como rodar (no AutoCAD / Civil 3D):
;   1. APPLOAD: carregar src/rapcon/calculo_coordenadas.lsp
;   2. APPLOAD: carregar tests/teste_calculo_coordenadas.lsp
;   3. Digitar RAPCON_TESTES na linha de comando
;
; Cada caso compara o resultado com o valor calculado a mao
; (ver docs/memorial_calculo_rapcon.md) e mostra PASSOU ou FALHOU.
; =====================================================================

(setq rapcon-tolerancia 1e-6)

; Compara duas listas de coordenadas com tolerancia
(defun rapcon-pontos-iguais (p1 p2)
  (and (equal (car p1) (car p2) rapcon-tolerancia)
       (equal (cadr p1) (cadr p2) rapcon-tolerancia)
       (equal (caddr p1) (caddr p2) rapcon-tolerancia))
)

(defun rapcon-ponto-texto (p)
  (strcat "(" (rtos (car p) 2 4) "; "
              (rtos (cadr p) 2 4) "; "
              (rtos (caddr p) 2 4) ")")
)

; Roda um caso de teste e devolve T se passou
(defun rapcon-caso (nome base direcao distancia dz esperado / obtido ok)
  (setq obtido (rapcon-calcular-coordenadas base direcao distancia dz))
  (setq ok (rapcon-pontos-iguais obtido esperado))
  (princ (strcat "\n" (if ok "[PASSOU] " "[FALHOU] ") nome))
  (if (not ok)
    (princ (strcat "\n    esperado " (rapcon-ponto-texto esperado)
                   "\n    obtido   " (rapcon-ponto-texto obtido)))
  )
  ok
)

(defun c:RAPCON_TESTES ( / resultados)
  (if (not rapcon-calcular-coordenadas)
    (progn
      (alert "Carregue src/rapcon/calculo_coordenadas.lsp antes de rodar os testes.")
      (exit)
    )
  )

  (princ "\n=== Testes do RAPCON ===")

  (setq resultados
    (list
      ; Exemplo do memorial de calculo: direcao 0 grau
      (rapcon-caso "Exemplo do memorial (0 grau)"
        '(1000.0 2000.0 50.0) '(1100.0 2000.0 50.0) 20.0 1.5
        '(1020.0 2000.0 51.5))

      ; Direcao 90 graus (para o norte)
      (rapcon-caso "Direcao 90 graus"
        '(1000.0 2000.0 50.0) '(1000.0 2100.0 50.0) 20.0 1.5
        '(1000.0 2020.0 51.5))

      ; Direcao 180 graus com cota negativa
      (rapcon-caso "Direcao 180 graus, cota negativa"
        '(500.0 500.0 10.0) '(400.0 500.0 10.0) 8.0 -0.5
        '(492.0 500.0 9.5))

      ; Direcao 45 graus: distancia 10*raiz(2) anda 10 em X e 10 em Y
      (rapcon-caso "Direcao 45 graus"
        '(0.0 0.0 0.0) '(1.0 1.0 0.0) (* 10.0 (sqrt 2.0)) -4.0
        '(10.0 10.0 -4.0))

      ; Distancia zero: so muda a cota
      (rapcon-caso "Distancia zero"
        '(100.0 200.0 30.0) '(150.0 200.0 30.0) 0.0 2.0
        '(100.0 200.0 32.0))

      ; O ponto de direcao pode estar mais perto que a distancia
      (rapcon-caso "Ponto de direcao mais perto que a distancia"
        '(0.0 0.0 0.0) '(1.0 0.0 0.0) 18.0 0.0
        '(18.0 0.0 0.0))
    )
  )

  (princ (strcat "\n=== "
                 (itoa (length (vl-remove nil resultados))) " de "
                 (itoa (length resultados)) " testes passaram ==="))
  (princ)
)

(princ "\nTestes do RAPCON carregados. Digite RAPCON_TESTES para rodar.")
(princ)
