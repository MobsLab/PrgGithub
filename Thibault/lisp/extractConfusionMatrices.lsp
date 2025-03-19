#!


(defun add-commas (line)
	(let ((firstChar (subseq line 0 1))
		  (secondChar (subseq line 1 2))
		  (thirdChar (subseq line 2 3))
		  (fourthChar (subseq line 3 4))
		  (fifthChar (subseq line 4 5)))
		(cond
			((equal fifthChar "]") (concatenate 'string line ","))
			('t (concatenate 'string (subseq line 0 4) "," (add-commas (subseq line 5)))))))

(defun modify-for-python (line)
	(concatenate 'string (subseq line 0 2) (add-commas (subseq line 2))))

(defun get-confusion-matrix (in)
	(let ((currentLine (read-line in)))
		(cond
			((equal currentLine "stop") 'nil)
			('t (cons (modify-for-python currentLine) (get-confusion-matrix in))))))


(defun read-confusions (file)
	(with-open-file (in file)
		(get-all-confusion-matrices in)))


(defun get-all-confusion-matrices (in)		
	(let ((currentLine (read-line in)))
		(cond
			((equal currentLine "stop") 'nil)
			((equal currentLine "clu") (cons (get-confusion-matrix in) (get-all-confusion-matrices in)))
			('t (get-all-confusion-matrices in)))))

; (print (read-confusions #P"/Users/thibaultbalenbois/Dropbox/Kteam/PrgMatlab/OnlinePlaceDecoding/python/imbalancedDataAnalysis.py"))
; (print (read-confusions #P"/home/mobshamilton/Dropbox/Kteam/PrgMatlab/OnlinePlaceDecoding/python/imbalancedDataAnalysis.py"))

(defun write-matrix (str matrix)
	(cond
		((null (cdr matrix)) (format str (concatenate 'string (string-right-trim "," (car matrix)) "]~%~%")))
		('t
			(format str (concatenate 'string (car matrix) "~%"))
			(write-matrix str (cdr matrix)))))

(defun write-matrices (str matrices)
	(format str "allConfusions+=[")
	(cond
		((null (cdr matrices)) (write-matrix str (car matrices)))
		('t
			(write-matrix str (car matrices))
			(write-matrices str (cdr matrices))
			)))

(print (concatenate 'string "extracting matrices at " (car EXT:*ARGS*)))
(let ((matrices (read-confusions (car EXT:*ARGS*))))
; (let ((matrices (read-confusions #P"/Users/thibaultbalenbois/Dropbox/Kteam/PrgMatlab/OnlinePlaceDecoding/python/MSFE-confusions.txt")))
	(with-open-file (str (concatenate 'string (getenv "HOME") "/Dropbox/Kteam/PrgMatlab/OnlinePlaceDecoding/python/confusionsForPython.py")
	; (with-open-file (str "/Users/thibaultbalenbois/Dropbox/Kteam/PrgMatlab/OnlinePlaceDecoding/python/confusionsForPython.py"
	                     :direction :output
	                     :if-exists :supersede
	                     :if-does-not-exist :create)
	(format str "allConfusions=[]~%~%")
	(write-matrices str matrices)))
