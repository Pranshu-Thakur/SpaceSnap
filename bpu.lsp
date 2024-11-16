;; Dope will be
;; The user opens up A.CAD
;; bac.lsp loads up autoamtically and sets up the whole enviorment and make it code ready.
;; A.CAD will prompt the user to enter the warehouse name. 
;; The layout of that warehouse with the latest data will be printed.
;; That layout will be exported in the pdf. 


(defun c:bpu (/ layerName colorCode pageSetupFileName)
  
  (setvar 'gridmode 0)
  (setvar 'clayer "0")
  
  (setq p1 (list 0 0))
  (setq p2 (list (+ (car p1) 2) (+ (cadr p1) 2)))
  
  ;Create the layers and assign the colors to all the layers
  (setq layerName "filled")
  (setq colorCode 1) ;color red
  (command "_.-layer" "make" layerName "color" colorCode"")
  (command "") ;esc
  
  (setq layerName "partial")
  (setq colorCode 2) ; color yellow
  (command "_.-layer" "make" layerName "color" colorCode"")
  (command "") ;esc
  
  (setq layerName "empty")
  (setq colorCode 3) ;color green
  (command "_.-layer" "make" layerName "color" colorCode"")
  (command "") ;esc
  
  ;Create the locked layer and draw reference rectangle of 2 X 2
  (setq layerName "stay")
  (setq colorCode 141) ;color cyan
  (command "_.-layer" "make" layerName "color" colorCode"")
  (command "") ;esc
  (setvar 'clayer "stay")
  (command "_.-layer" "lock" layerName "") ;locking up the layer so nothing gets deleted from this
  
  (setvar 'clayer "0")
  (command "") ;esc
  (command "_.rectang" p1 p2)

  (command "_.insert" "huha" (list 40 60) "1" "1" "0");intended to print a block called "pallet"
  

  
  (command "_zoom" "e") ;zoom in to set the screen
  
  ;;importing the correct setup and applying for the plotter./ 
  (command "_.-plot" 
            "y"
           "model"
           "dwg to pdf"
           "ISO_A0_(841.00_x_1189.00_MM)"
           "m"
           "L"
           "n"
           "e"
           "F"
           "C"
           "y"
           ""
           "y"
           "a"
           "y"
           "y"
           "y"
           
  )

  (princ)
)







