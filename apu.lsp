(defun c:apu ( / csv-file file-path line a2-cell b2-cell c2-cell d2-cell e2-cell x-coord y-coord increment start-point pallet-count)
  ;; Specify the path to the CSV file
  (setq file-path "C:/Users/prans/OneDrive/Desktop/pallet yum.csv")  ;; Updated file path
  (setvar 'clayer "stay")
  
  (setq p1 (list 0 0))
  (setq p2 (list (+ (car p1) 2) (+ (cadr p1) 2)))
  
  (command "_.rectang" p1 p2)
  (command "_.zoom" "e")
  
  (setvar 'clayer "0")

  
  (command "_.-insert" "CHN_Outline" (list 0 0) "1" "0")
  
  ;; Ask user for the first insertion point
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
            (command "_.-insert" "pallet" (strcat (rtos x-coord 2 0) "," (rtos y-coord 2 0)) "1" "0")
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
  
    ;; Zoom Extents after all blocks are placed
  (command "_.zoom" "e")
  
  
  ;; Prompt user to press Enter to proceed
  (princ "\nPress Enter to proceed...")
  (getstring)  ;; Waits for the user to press Enter
  
  ;; Plotting settings for PDF output
  (command    "-plot" 
               "n" 
               "Model"
               "Setup1"
               "DWG To PDF.pc3"
               "ISO_full_bleed_A0_(841.00_x_1189.00_MM)" 
               "Yes" 
               "Yes"
               
  )

  (command "_qsave")
  
  ;; Finish with a null return to avoid extra output
  (princ)
)
