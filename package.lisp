  ;;;; package.lisp

(defpackage #:canvas
  (:use #:cl #:hunchentoot #:parenscript))

(in-package #:canvas)

;;;;;;;;;;;;;;;;;
(sexml:with-compiletime-active-layers
	(sexml:standard-sexml sexml:xml-doctype)
	(sexml:support-dtd
		(merge-pathnames "html5.dtd" (asdf:system-source-directory "sexml"))
		:<))
;;;;(<:augment-with-doctype "html" "" :auto-emit-p t)


(setf *js-string-delimiter* #\")
