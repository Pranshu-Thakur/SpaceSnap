(defun c:epu (/ file-path layerName colorCode csv-file start-point x-coord y-coord pallet-count pallet-count2 a2-cell b2-cell c2-cell d2-cell e2-cell f2-cell)
  
  ;;just read the file and let it be for now,
  (setq file-path "C:/Users/prans/OneDrive/Desktop/mumdat.csv")
 
  
  
  ;;setting up the drawing space. 
  (setvar 'gridmode 0)
  (setvar 'clayer "0")
  (command "_.ucsicon" "off")
  (command "_.-style" "Standard" "TechnicLite" "" "" "" "N" "N")
  
  ;;Creating Layers
  (setq layerName "filled")
  (setq colorCode 1) ;1 = red
  (command "_.-layer" "make" layerName "color" colorCode)
  (command "" "")
  
  (setq layerName "almost filled")
  (setq colorCode 30) ;30 = orange
  (command "_.-layer" "make" layerName "color" colorCode)
  (command "" "")
  
  (setq layerName "partial")
  (setq colorCode 2) ;2 = yellow
  (command "_.-layer" "make" layerName "color" colorCode)
  (command "" "")
  
  (setq layerName "empty")
  (setq colorCode 3) ;3 = green
  (command "_.-layer" "make" layerName "color" colorCode)
  (command "" "")
  
  ;;Creating two new layers
  ;;Layer for reference rectangle (locked)
  ;;Layer for null pallets (hidden)
  
  (setq layerName "locked") ;locked material layer
  (setq colorCode 7)
  (command "_.-layer" "make" layerName "color" colorCode)
  (command "" "")
  (setvar 'clayer "locked")
  ;;Creating a rectangle on locked layer and locking it.
  (setq p1 (list 0 0))
  (setq p2 (list (+(car p1) 2) (+ (cadr p1) 2)) )
  (command "rectang" p1 p2)
  (command "_.text" (list 1 1) 0.06 0 "Your Script is Running..")
  (command "_zoom" "e")
  ;rectangle made, locking the layer
  (command "_.-layer" "lock" layerName "")
  
  (setq layerName "hidden") ; hidden material layer
  (setq colorCode 3)
  (command "_.-layer" "make" layerName "color" colorCode)
  (command "" "")
  
  (setvar 'clayer "0")
  ;;Inserting mum block
  (command "insert" "MUM" (list 0 0) "1" "1" "0")
  
  ;;build a start point for the function. 
  (setq start-point  (list 110172 17633) )
  (setq x-coord (car start-point))
  (setq y-coord (cadr start-point))
  ;;putting a variable to count the pallets.
  (setq pallet-count 0)
  (setq pallet-count2 0)
  
  ;;open the file again for funtion
  (setq csv-file (open file-path "r"))
  (if csv-file
    (progn
      (read-line csv-file) ;;ignoring first line
      (while (setq line (read-line csv-file))
        (setq parsed-line (parsecsv line))
        (setq a2-cell (nth 0 parsed-line)) ;; pallet identifier
        (setq b2-cell (nth 1 parsed-line)) ;;Pallet Number
        (setq c2-cell (nth 2 parsed-line)) ;; Brand
        (setq d2-cell (nth 3 parsed-line)) ;; Product
        (setq e2-cell (nth 4 parsed-line)) ;; Occupancy
        (setq f2-cell (nth 5 parsed-line)) ;; Status
        
        (if (equal a2-cell "pallet" )
          (progn
            (cond
              ((equal f2-cell "filled") (setvar 'clayer "filled"))
              ((equal f2-cell "almost filled") (setvar 'clayer "almost filled"))
              ((equal f2-cell "partial") (setvar 'clayer "partial"))
              ((equal f2-cell "empty") (setvar 'clayer "empty"))
              (t
                (princ "\nF2 does not contain a valid status")
              )
            )
            
            (command "_.-insert" "huha" (strcat (rtos x-coord 2 0) "," (rtos y-coord 2 0))"1" "1" "0")
            
            
            (command "_.-text" (list (+ x-coord 94)  (+ y-coord 815)) 80 0 b2-cell) ;;Enter Pallet number
            (command "_.-text" (list (+ x-coord 94)  (+ y-coord 546)) 80 0 c2-cell) ;; Enter Brand Name
            (command "_.-text" (list (+ x-coord 94)  (+ y-coord 420)) 80 0 d2-cell) ;; Product Name 
            (command "_.-text" (list (+ x-coord 630)  (+ y-coord 44)) 80 0 (strcat e2-cell "%")) ;; Percentage
            (setq pallet-count (1+ pallet-count))
            (setq pallet-count2 (1+ pallet-count2))
            (setq pallet-count3 (1+ pallet-count3))
            (setq pallet-count4 (1+ pallet-count4))
            
            (cond
              ((= pallet-count 10)
                (setq x-coord (+ x-coord 2727)) 
                (setq y-coord (+ y-coord 0))
              )
              
              ((= pallet-count 23)
                (setq pallet-count 0)
                (setq x-coord (+ x-coord -24061)) 
                (setq y-coord (+ y-coord 1215))
              )
              
              ((= pallet-count2 92)
                (setq pallet-count2 0)
                (setq pallet-count 0)
                (setq x-coord (+ x-coord -24061)) 
                (setq y-coord (+ y-coord 2505))
              )
              
              ((= pallet-count3 9)
                (setq pallet-count2 0)
                (setq pallet-count 0)
                (setq pallet-count3 0)
                (setq x-coord (+ x-coord -8109)) 
                (setq y-coord (+ y-coord 1215))
              )
              
            )
            
          )
          
          (princ "\nA2 Does not contain Pallet")
        )
        (setq x-coord (+ x-coord 1010))
      )
      
    )
  )

  ;hidding the layer of null pallets.
  (setvar 'clayer "0")
  (command "_.-layer" "off" "hidden" "")
  
  
  (command "_zoom" "e")
  
  (command "_.-plot" 
            "y"
           "model"
           "dwg to pdf"
           "ISO_A0_(841.00_x_1189.00_MM)"
           "m"
           "P"
           "n"
           "e"
           "F"
           "C"
           "y"
           ""
           "y"
           "a"
           "Mumbai"
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
