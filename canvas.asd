;;;; canvas.asd

(asdf:defsystem #:canvas
  :description "Describe canvas here"
  :author "Your Name <your.name@example.com>"
  :license "Specify license here"
  :depends-on (#:hunchentoot
               #:sexml
               #:parenscript
               #:cl-css
							 #:smackjack)
  :serial t
  :components ((:file "package")
							 (:file "util")
               (:file "template")
               (:file "canvas-ch1")
               (:file "canvas-ch2")

))
