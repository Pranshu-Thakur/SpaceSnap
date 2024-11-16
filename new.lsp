(defun c:cat ( / csv-file file-path line a2-cell e2-cell)
  ;; Specify the path to the CSV file
  (setq file-path "C:/Users/prans/OneDrive/Desktop/pallet put.csv")  ;; Updated file path

  ;; Attempt to open the CSV file
  (setq csv-file (open file-path "r"))

  ;; Check if the file was opened successfully
  (if csv-file
    (progn
      ;; Read the first line (header row), but we don't need to process it
      (read-line csv-file)

      ;; Read the second line (A2, B2, C2, etc.)
      (setq line (read-line csv-file))

      ;; Split the line by comma and extract values
      (setq parsed-line (parsecsv line))
      (setq a2-cell (nth 0 parsed-line))  ;; A2 is the first column
      (setq b2-cell (nth 1 parsed-line))  ;; B2 is the second column
      (setq c2-cell (nth 2 parsed-line))  ;; C2 is the third column (product)
      (setq d2-cell (nth 3 parsed-line))  ;; D2 is the fourth column
      (setq e2-cell (nth 4 parsed-line))  ;; E2 is the fifth column

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
          

          
          (command "_.-insert" "pallet" "0,0" "1" "0")  ;; Pass rotation as numeric 0


          ;; Set the text properties for the brand
          (setq start-point-brand (list 185 640))  ;; X=160, Y=600
          ;; Create the brand text
          (command "_.text" start-point-brand 80 0 b2-cell)

          ;; Set the text properties for the product
          (setq start-point-product (list 185 500))  ;; X=185, Y=560
          ;; Create the product text
          (command "_.text" start-point-product 80 0 c2-cell)

          ;; Set the text properties for the D2 value with a "%"
          (setq start-point-d2 (list 185 350))  ;; X=185, Y=480
          ;; Create the D2 text with "%" sign
          (command "_.text" start-point-d2 80 0 (strcat d2-cell"%"))


          (princ "\nBlock 'pallet' placed at (0,0).")

        )
        ;; If A2 doesn't contain "Pallet", print a different message
        (princ "\nA2 does not contain 'Pallet'.")
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
