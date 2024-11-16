(defun c:rat ( / csv-file file-path line a2-cell b2-cell c2-cell d2-cell e2-cell x-coord y-coord increment start-point)
  ;; Specify the path to the CSV file
  (setq file-path "C:/Users/prans/OneDrive/Desktop/pallet put.csv")  ;; Updated file path

  ;; Ask user for the first insertion point
  (setq start-point (getpoint "\nSpecify the first insertion point: "))
  (setq x-coord (car start-point))  ;; Get x-coordinate from user input
  (setq y-coord (cadr start-point))  ;; Get y-coordinate from user input
  (setq increment 1010)  ;; Increment value for x-coordinate

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
            (princ (strcat "\nBlock 'pallet' placed at (" (rtos x-coord 2 2) ", " (rtos y-coord 2 2) ")."))

            ;; Set the text properties for the brand
            (setq start-point-brand (list (+ x-coord 185) (+ y-coord 600)))  ;; X=160, Y=600 relative to block origin
            (command "_.text" start-point-brand 80 0 b2-cell)

            ;; Set the text properties for the product
            (setq start-point-product (list (+ x-coord 185) (+ y-coord 500)))  ;; X=185, Y=560 relative to block origin
            (command "_.text" start-point-product 80 0 c2-cell)

            ;; Set the text properties for the D2 value with a "%" sign
            (setq start-point-d2 (list (+ x-coord 185) (+ y-coord 400)))  ;; X=185, Y=480 relative to block origin
            (command "_.text" start-point-d2 80 0 (strcat d2-cell " %"))

          )
          ;; If A2 doesn't contain "Pallet", print a different message
          (princ "\nA2 does not contain 'Pallet'.")
        )

        ;; Increment x-coord for the next block
        (setq x-coord (+ x-coord increment))
      )

      ;; Close the file after reading
      (close csv-file)
    )
    ;; If the file can't be opened, print an error message
    (princ "\nError: Could not open the file.")
  )
  
  ;; Finish with a null return to avoid extra output
  (princ)
)
