(defun c:cpu (/ layerName colorCode csv-file file-path line a2-cell b2-cell c2-cell d2-cell e2-cell x-coord y-coord increment start-point pallet-count)
  
  (setq file-path "C:/Users/prans/OneDrive/Desktop/pallet yum.csv") ;; read the file 
  
  
  (setvar 'gridmode 0) ; turn the grid off
  (setvar 'clayer "0") ; keep the layer to 0
  (command "_.ucsicon" "off") ; turn the ucs icon off
  (command "_.style" "Standard" "TechnicLite" "" "" "" "N" "N") ;change the font to TechnicLite
  
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
  

  (command "_.rectang" p1 p2)
  (command "_.text" (list 1 1) 0.06 0 "Your Script Is Running...")
  (command "_zoom" "e") ;zoom in to set the screen
  
  (setvar 'clayer "0")
  (command "") ;esc

  (command "_.insert" "CHN" (list 0 0) "1" "1" "0") ;Inserting the wall layout of chennai
  
  (setq start-point (list 9171 492))
  (setq x-coord (car start-point))  ;; Get x-coordinate from user input
  (setq y-coord (cadr start-point))  ;; Get y-coordinate from user input
  (setq pallet-count 0)  ;; Initialize the counter for pallets placed

  ;; Attempt to open the CSV file
  (setq csv-file (open file-path "r"))

  ;; Check if the file was opened successfully
  (if csv-file
    (progn
      ;; Read and skip the first line (header row)
      (read-line csv-file)

      ;; Loop through each line until the end of the CSV file
      (while (setq line (read-line csv-file))
        ;; Split the line by comma and extract values
        (setq parsed-line (parsecsv line))
        (setq a2-cell (nth 0 parsed-line))  ;; A2 (pallet identifier)
        (setq b2-cell (nth 1 parsed-line))  ;; B2 (brand)
        (setq c2-cell (nth 2 parsed-line))  ;; C2 (product)
        (setq d2-cell (nth 3 parsed-line))  ;; D2 (percentage)
        (setq e2-cell (nth 4 parsed-line))  ;; E2 (status)

        ;; Check if A2 contains the word "Pallet"
        (if (equal a2-cell "Pallet")
          (progn
            ;; Change the current layer based on the E2 values ("e", "p", "f")
            (cond
              ((equal e2-cell "p") (setvar 'clayer "partial"))
              ((equal e2-cell "e") (setvar 'clayer "empty"))
              ((equal e2-cell "f") (setvar 'clayer "filled"))
              (t 
                (princ "\nE2 does not contain a recognized status.")
              )
            )
            
            ;; Confirm the current layer change
            (princ (strcat "\nCurrent layer set to: " (getvar 'clayer)))

            ;; Insert the block with numeric rotation at the dynamic x-coord, y-coord
            (command "_.-insert" "huha" (strcat (rtos x-coord 2 0) "," (rtos y-coord 2 0)) "1" "1" "0")
            ;(princ (strcat "\nBlock 'pallet' placed at (" (rtos x-coord 2 2) ", " (rtos y-coord 2 2) ")."))

            ;; Set the text properties for the brand
            (command "_.text" (list (+ x-coord 200) (+ y-coord 800)) 80 0 b2-cell)
            
            ;; Set the text properties for the product
            (command "_.text" (list (+ x-coord 200) (+ y-coord 600)) 80 0 c2-cell)
            
            ;; Set the text properties for the D2 value with a "%" sign
            (command "_.text" (list (+ x-coord 200) (+ y-coord 400)) 80 0 (strcat d2-cell "%"))

            ;; Increment the pallet count
            (setq pallet-count (1+ pallet-count))
            
            (princ "\n Block has been printed correctly")

            (cond
              ((= pallet-count 32)
                (setq x-coord (+ x-coord 1818))
                (setq y-coord (+ y-coord 0)))
              
              ((= pallet-count 60)
                (setq x-coord (+ x-coord -62418))
                (setq y-coord (+ y-coord 1210)))

              ((= pallet-count 92)
                (setq x-coord (+ x-coord 1818))
                (setq y-coord (+ y-coord 0)))
              
              ((= pallet-count 120)
                (setq x-coord (+ x-coord -62418))
                (setq y-coord (+ y-coord 1210)))
              
              ((= pallet-count 152)
                (setq x-coord (+ x-coord 1818))
                (setq y-coord (+ y-coord 0)))
              
              ((= pallet-count 180)
                (setq pallet-count 0)
                (setq x-coord (+ x-coord -62418))
                (setq y-coord (+ y-coord 2724)))
            )
          )


          ;; If A2 doesn't contain "Pallet", print a different message
          (princ "\nA2 does not contain 'Pallet'.")
        )

        ;; Increment x-coord for the next block
        (setq x-coord (+ x-coord 1010))
      )

      ;; Close the file after reading
      (close csv-file)
    )
    ;; If the file can't be opened, print an error message
    (princ "\nError: Could not open the file.")
  )
  
  
  
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
           "Chennai"
           "y"
           "y"
           
  )


  (princ)
)
(defun parsecsv (line / result pos)
  ;; This function splits a CSV line into separate values based on commas
  (setq result '())
  (while (setq pos (vl-string-search "," line))
    (setq result (cons (substr line 1 pos) result))
    (setq line (substr line (+ pos 2)))
  )
  ;; Add the last element
  (setq result (cons line result))
  ;; Return the result as a reversed list (to maintain order)
  (reverse result)
)