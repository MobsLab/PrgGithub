#!

(defun pair (x y) 
	(cond 
		((null x) '())
		('t (cons 
			(list (car x) (car y)) 
			(pair (cdr x) (cdr y))))))

(defun accumulate (binaryFun lst)
	(cond
		((null (cdr lst)) (car lst)) 
		('t (funcall binaryFun (car lst) (accumulate binaryFun (cdr lst))))))

(defun add (x y) (+ x y))
; (print (accumulate #'add '(1 6 4 8 5 9 6 7 8 9 6 5 4 5 7 5 3 5 3 2 1 4 5 6 7)))

; (print (accumulate (lambda (x y) (+ x y)) '(1 6 4 8 5 9 6 7 8 9 6 5 4 5 7 5 3 5 3 2 1 4 5 6 7)))


(defun tailAccumulate (binaryFun elList)
	(labels ((acc (fun lst res)
		(cond
			((null (cdr lst)) (funcall fun res (car lst)))
			('t (acc fun (cdr lst) (funcall fun res (car lst)))))))
	(acc binaryFun (cdr elList) (car elList))))

; (print (tailAccumulate #'add '(1 6 4 8 5 9 6 7 8 9 6 5 4 5 7 5 3 5 3 2 1 4 5 6 7)))
; (print (tailAccumulate #'(lambda (a b) (concatenate 'string a b)) '("test" "hjk" "o" "lk")))
; (print '("test" "hjk" "o" "lk"))


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
		((null (cdr matrix)) (format str (concatenate 'string (car matrix) "~%~%")))
		('t
			(format str (concatenate 'string (car matrix) "~%"))
			(write-matrix str (cdr matrix)))))

(defun write-matrices (str matrices)
	(cond
		((null (cdr matrices)) (write-matrix str (car matrices)))
		('t
			(write-matrix str (car matrices))
			(write-matrices str (cdr matrices))
			)))

(let ((matrices (read-confusions #P"/Users/thibaultbalenbois/Dropbox/Kteam/PrgMatlab/OnlinePlaceDecoding/python/imbalancedDataAnalysis.py")))
	(with-open-file (str "/Users/thibaultbalenbois/Dropbox/Kteam/PrgMatlab/OnlinePlaceDecoding/python/imbalancedDataAnalysis2.py"
	                     :direction :output
	                     :if-exists :supersede
	                     :if-does-not-exist :create)
	  (write-matrices str matrices)))



