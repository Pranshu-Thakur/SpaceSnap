(defun c:epu (/ file-path layerName colorCode csv-file start-point x-coord y-coord pallet-count pallet-count2 pallet-count3 pallet-count4 pallet-count5 pallet-count6 a2-cell b2-cell c2-cell d2-cell e2-cell f2-cell)
  
  ;;just read the file and let it be for now,
  (setq file-path "C:/Users/prans/OneDrive/Desktop/mumdat2.csv")

 
  
  
  ;;setting up the drawing space. 
  (setvar 'gridmode 0)
  (setvar 'clayer "0")
  (command "_.ucsicon" "off")
  (command "_.-style" "Standard" "TechnicLite" "" "" "" "N" "N")

  ;;turning the decimals off
  (command "_.-units" "2" "0" "1" "0" "0" "N" "N" )
  
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
  (command "insert" "MUM2" (list 0 0) "1" "1" "0")
  
  ;;build a start point for the function. 
  (setq start-point  (list 102032 33468) )
  (setq x-coord (car start-point))
  (setq y-coord (cadr start-point))
  ;;putting a variable to count the pallets.
  (setq pallet-count 0)
  (setq pallet-count2 0)
  (setq pallet-count3 0)
  (setq pallet-count4 0)
  (setq pallet-count5 0)
  (setq pallet-count6 0)
 
  (setq PC-counter 0)
  (setq PC-counter2 0)
  (setq PC-counter3 0)
  ;;open the file again for funtion
  (setq csv-file (open file-path "r"))
  
  
  (if csv-file
    (progn
      (read-line csv-file) ;;ignoring first line
      (while (setq line (read-line csv-file))
        (setq parsed-line (parsecsv line))
        (setq a2-cell (nth 0 parsed-line)) ;; pallet identifier
        (setq b2-cell (nth 1 parsed-line)) ;; Pallet Number
        (setq c2-cell (nth 2 parsed-line)) ;; Brand
        (setq d2-cell (nth 3 parsed-line)) ;; Product
        (setq e2-cell (nth 4 parsed-line)) ;; Occupancy
        (setq f2-cell (nth 5 parsed-line)) ;; Status
        
        (if (equal a2-cell "pallet" )
          (progn
            ;(cond
              ;((equal f2-cell "filled") (setvar 'clayer "filled"))
              ;((equal f2-cell "almost filled") (setvar 'clayer "almost filled"))
              ;((equal f2-cell "partial") (setvar 'clayer "partial"))
              ;((equal f2-cell "empty") (setvar 'clayer "empty"))
              ;(t
              ;  (princ "\nF2 does not contain a valid status")
             ; )
            ;)
            
            (command "_.-insert" "huha" (strcat (rtos x-coord 2 0) "," (rtos y-coord 2 0))"1" "1" "0")
            
            
            (command "_.-text" (list (+ x-coord 94)  (+ y-coord 815)) 80 0 b2-cell) ;;Enter Pallet number
            ;(command "_.-text" (list (+ x-coord 94)  (+ y-coord 546)) 80 0 c2-cell) ;; Enter Brand Name
            ;(command "_.-text" (list (+ x-coord 94)  (+ y-coord 420)) 80 0 d2-cell) ;; Product Name 
            ;(command "_.-text" (list (+ x-coord 630)  (+ y-coord 44)) 80 0 (strcat e2-cell "%")) ;; Percentage
            (setq pallet-count (1+ pallet-count))
            (setq pallet-count2 (1+ pallet-count2))
            (setq pallet-count3 (1+ pallet-count3))
            (setq pallet-count4 (1+ pallet-count4))

            
            
            
            (if (= pallet-count 2) ;;close after 2376th time 
              (progn
                (setq pallet-count 0)
                (setq x-coord (+ x-coord 3226))
                (setq PC-counter (1+ PC-counter))
                  (if (>= PC-counter 2376)
                    (progn
                      (setq x-coord (- x-coord 3226))
                    )
                  )
              )
            )

            (if (= pallet-count2 44) ;;close after 108th time
              (progn
                (setq pallet-count2 0)
                (setq x-coord (- x-coord 115412))
                (setq y-coord (+ y-coord 1222))
                (setq PC-counter3 (1+ PC-counter3))
                  (if (>= PC-counter3 108)
                    (progn
                      (setq x-coord (+ x-coord 115412))
                      (setq y-coord (- y-coord 1222))
                    )
                  )
              )
            )

            (if (= pallet-count3 792) ;; close after 6th time
              (progn
                (setq pallet-count3 0)
                (setq y-coord (+ y-coord 36773))
                (setq PC-counter2 (1+ PC-counter2))
                  (if (>= PC-counter2 6)
                    (progn
                      (setq y-coord (- y-coord 36773))
                    )
                  )
              )
            )

            (if (= pallet-count4 4752) ;; changing the coord after 4753th time
              (progn
                (setq x-coord (+ x-coord 7919))
                (setq y-coord (+ y-coord 652))
              )
            )

            (if (and (>= pallet-count4 4753) (<= pallet-count4 4968))
              (progn
                (setq pallet-count5 (1+ pallet-count5))
                (setq pallet-count6 (1+ pallet-count6))
                (if (or (= pallet-count5 3) (= pallet-count5 6))
                  (progn
                  (setq x-coord ( + x-coord 1010))
                  )
                )
                
                (if (= pallet-count5 9)
                  (progn
                    (setq pallet-count5 0)
                    (setq x-coord ( - x-coord 11110))
                    (setq y-coord ( - y-coord 1222))
                  )
                )
                (if (= pallet-count6 72)
                  (progn
                    (setq pallet-count6 0)
                    (setq y-coord ( - y-coord 2402))
                  )
                )
              )
            )
            
            (if (= pallet-count4 4968)
              (progn
                (setq x-coord (- x-coord 39736))
                (setq y-coord (- y-coord -215))
              )
            )

            (if (and (>= pallet-count4 4969) (<= pallet-count4 5231))
              (progn
                (setq pallet-count5 (1+ pallet-count5))
                (setq pallet-count6 (1+ pallet-count6))
                (if (or (= pallet-count5 8) (= pallet-count5 17) (= pallet-count5 26) (= pallet-count5 35))
                 (setq x-coord (+ x-coord 1697))
                )
                (if ( = pallet-count5 44)
                  (progn
                    (setq pallet-count5 0)
                    (setq x-coord ( - x-coord 51228))
                    (setq y-coord ( - y-coord 1215))
                  )
                )
                (if (= pallet-count6 176)
                  (progn
                    (setq pallet-count6 0)
                    (setq y-coord ( - y-coord 1290))
                  )
                )
              )
            )

            (if (= pallet-count4 5232)
              (progn
                (setq x-coord (- x-coord 135793))
                (setq y-coord (+ y-coord 16514))
                (setq pallet-count6 0)
                (setq pallet-count5 0)    
              )
            )
            

            (if (and ( >= pallet-count4 5233 ) (<= pallet-count4 5507))
              (progn
                (setq pallet-count5 (1+ pallet-count5)) ;x =62418 y = 1210
                (setq pallet-count6 (1+ pallet-count6))
                (princ "\ni have counted the pallets");; just for logging
                
                (if (= pallet-count6 10)
                  (progn
                    (setq x-coord ( + x-coord 1707))
                  )
                )
                (if ( = pallet-count6 23)
                  (progn
                    (setq pallet-count6 0)
                    (setq x-coord (- x-coord 24937))
                    (setq y-coord (- y-coord 1215))
                  )
                )
                (if ( = pallet-count5 92)
                  (progn
                    (setq pallet-count5 0)
                    (setq y-coord ( - y-coord 1325))
                  )
                )
                ;; All set and working till here 
              )
            )
            
            (if (= pallet-count4 5508)
              (progn
                (setq x-coord (- x-coord 38634))
                (setq y-coord (+ y-coord 42675))
                (setq pallet-count5 0)
                (setq pallet-count6 0)
              ) 
            )
            
            (if (and ( >= pallet-count4 5509) (<= pallet-count4 5647))
              (progn
                (setq pallet-count5 (1+ pallet-count5))
                (setq pallet-count6 (1+ pallet-count6))
                (if (= pallet-count6 10)
                  (progn
                    (setq pallet-count6 0)
                    (setq x-coord ( - x-coord 10100))
                    (setq y-coord ( - y-coord 1215))
                  )
                )

                (if (= pallet-count5 40)
                  (progn
                    (setq pallet-count5 0)
                    (setq y-coord (- y-coord 1237))
                  )
                )
                ;; all working fine look down
              )
            )
            (if (= pallet-count4 5648)
              (progn
                (setq x-coord (+ x-coord 142673))
                (setq y-coord (+ y-coord 19939))
                (setq pallet-count5 0)
                (setq pallet-count6 0)
              )
            )
            
            (if (>= pallet-count4 5649)
              (progn
                (setq pallet-count5 (1+ pallet-count5))
                (if (= pallet-count5 2)
                  (progn
                    (setq pallet-count5 0)
                    (setq x-coord ( - x-coord 2018))
                    (setq y-coord ( - y-coord 1215))
                  )
                )
              )
            )
              
          )
          (princ "\nA2 Does not contain Pallet")
        )
        (setq x-coord (+ x-coord 1010))
      )
    )
  )
  

  ; hidding the layer of null pallets.
  (setvar 'clayer "0")
  (command "_.-layer" "off" "hidden" "")
  
  

  
  
  (command "_zoom" "e")
  (getstring)
  
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
