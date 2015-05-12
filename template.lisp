;;template.lisp
(in-package #:canvas)

(<:augment-with-doctype "html" "" :auto-emit-p t)
;;;;;;;;;;;;;;;


(defun freshline()
	"return NEWLINE in the html, no return value"
	(format nil "~A" #\newline))


(defun html-frame(context)
	"html frame for all pages"
	(<:html :lang "en"
		(<:head
			(<:meta :charset "UTF-8")
			(<:title (getf context :title))(freshline)
      ;(<:style (getf context :css))(freshline)
			(when (getf context :ajax-processor)
         (format nil "~A" (smackjack:generate-prologue (getf context :ajax-processor))))
			(freshline)
			(when (getf context :scripts)
					(loop for script in (getf context :scripts)
								collect	(<:script :src script))))
			(freshline)
		(<:body (getf context :body))))
