;;;; canvas.lisp

(in-package #:canvas)

;;; "canvas" goes here. Hacks and glory await!

;;;;;;;;;;;;ch1ex1
(define-easy-handler (ch1ex1 :uri "/ch1ex1")()
	(html-frame
	(list :title "CH1EX1: Basic Hello World HTML Page"
				:body "Hello World!")))

;;;;;;;;;;;ch1ex2
(define-easy-handler (ch1ex2 :uri "/ch1ex2") ()
	(html-frame
	(list :title "CH1EX2: Hello World HTML Page With A DIV"
        :body (<:div :style (cl-css:inline-css '(:position absolute :top 50px :left 50px))
                     "Hello World!"))))


;;;;;;;;;;;;;ch1ex3
;;use modernizr-canvas.js
(push (hunchentoot:create-static-file-dispatcher-and-handler "/modernizr-canvas.js" 
                "~/quicklisp/local-projects/canvas/static/javascript/modernizr-canvas.js"
               "text/javascript")
      hunchentoot:*dispatch-table*)

(push (create-static-file-dispatcher-and-handler "/images/helloworld.gif"
        "~/quicklisp/local-projects/canvas/static/images/helloworld.gif"
        "image/gif")
		*dispatch-table*)



(define-easy-handler (util-js :uri "/util.js")()
	(setf (content-type*) "text/javascript")
		(parenscript:ps

	(chain window (add-event-listener "load" event-window-loaded false))

	(var *debugger (new (*function)))


	(setf (@ *debugger log) #'(lambda(message)
										(try (chain console (log message))
		                	(:catch (exception)
												(return undefined)))))


	(defun event-window-loaded()
		(canvas-app))

	(defun canvas-support()
		(@ *modernizr canvas))))

(define-easy-handler (ch1ex3-js :uri "/ch1ex3.js")()
	(setf (content-type*) "text/javascript")
		(parenscript:ps
	(defun canvas-app()
		(if (not (canvas-support))
			(return undefined))
		(var the-canvas (chain document (get-element-by-id "canvasOne")))
		(var context (chain the-canvas (get-context "2d")))
	
		(chain *debugger (log "Drawing Canvas"))

		(draw-screen)

		(defun draw-screen()
			;background
			(setf (@ context fill-style) "#ffffaa")
			(chain context (fill-rect 0 0 500 300))
		
			;text
			(setf (@ context fill-style) "#000000"
		        (@ context font)       "20px Sans-Serif"
		        (@ context text-baseline) "top")
			(chain context (fill-text "Hello World!" 195 80))

			;;image
			(var hello-world-image (new (*image)))
			(setf (@ hello-world-image onload) #'(lambda() (chain context (draw-image hello-world-image 155 110)))
		        (@ hello-world-image src) "/images/helloworld.gif")

			;;box
			(setf (@ context stroke-style) "#000000")
			(chain context (stroke-rect 5 5 490 290))))
	))


(define-easy-handler (ch1ex3 :uri "/ch1ex3")()
	(html-frame
	(list :title "CH1EX3: Your First Canvas Applications"
        :scripts '("/modernizr-canvas.js" "/util.js" "/ch1ex3.js")
        :body (<:div :style (cl-css:inline-css '(:position absolute :top 50px :left 50px))
                (<:canvas :id "canvasOne" :width "500" :height "300"
                          "Your Browser does not support HTML5 Canvas.")))))


;;;;;;;;;;;;;;;;ch1ex4

(define-easy-handler (ch1ex4-js :uri "/ch1ex4.js")()
	(setf (content-type*) "text/javascript")
	(ps

	(defun canvas-app()
		(if (not (canvas-support))
			(return undefined))
		(var the-canvas (chain document (get-element-by-id "canvasOne")))
		(var context (chain the-canvas (get-context "2d")))
	
		(chain *debugger (log "Drawing Canvas"))

		(var guesses 0)
		(var message "Guess The Letter From a (lower) to z (higher)")

		(var letters (loop for code from 97 to 122
				                   collect (chain *string (from-char-code code))))

		(var today (new (*date)))
		(var letter-to-guess "")
		(var higher-or-lower "")
		(var letters-guessed)
		(var game-over false)
		
		(init-game)


		(defun init-game()
			(var letter-index (chain *math (floor (* (chain *math (random)) (@ letters length)))))
			(setf letter-to-guess (elt letters letter-index) ;letterToGuess = letters[letterIndex];
						guesses 0
				    letters-guessed (new (*array))
				    game-over false)
			(chain *debugger (log (+ "Result :" letter-to-guess)))
			(chain window (add-event-listener "keydown" event-key-pressed t))
      
			(var form-element (chain document (get-element-by-id "createImageData")))
			(chain form-element (add-event-listener "click" create-image-data-pressed false))

			(draw-screen))

		(defun event-key-pressed(e)
			(chain *debugger (log (+ "keycode: " (@ e key-code))))
			(when (not game-over)
				     (var letter-pressed (chain *string (from-char-code (@ e key-code))))
				     (setf letter-pressed (chain letter-pressed (to-lower-case))
				           guesses (1+ guesses))
						 (chain letters-guessed (push letter-pressed))
            
				     (cond ((equal letter-pressed letter-to-guess) (setf game-over t))
				           (t (setf letter-index (chain letters (index-of letter-to-guess))
				                    guess-index  (chain letters (index-of letter-pressed)))
				              (chain *debugger (log guess-index))
				              (cond ((< guess-index 0) (setf higher-or-lower "That is not a letter"))
				              ((> guess-index letter-index) (setf higher-or-lower "Lower"))
				              (t (setf higher-or-lower "Higher"))))))
			;(alert (chain *string (from-char-code (@ e key-code))))
			(draw-screen))

		(defun draw-screen()
			;;background
			(setf (@ context fill-style) "#ffffaa")
			(chain context (fill-rect 0 0 500 300))
			
			;;Box
			(setf (chain context stroke-style) "#000000")
      (chain context (stroke-rect 5 5 490 290))
			(setf (@ context text-baseline) "top")

			;;Date
			(setf (@ context fill-style) "#000000"
            (@ context font)       "10px Sans-Serif")
      (chain context (fill-text today 150 10))

			;;message
			(setf (@ context fill-style) "#FF0000"
            (@ context font)       "14px Sans-Serif")
      (chain context (fill-text message 125 30)) ;;message
			(setf (@ context fill-style) "#109910"
            (@ context font)       "16px Sans-Serif")
			(chain context (fill-text (+ "Guesses: " guesses) 215 50))

			;;higher or lower
			(setf (@ context fill-style) "#000000"	
            (@ context font)       "16px Sans-Serif")
			(chain context (fill-text (+ "Higher Or Lower: " higher-or-lower) 150 125))

			;;Letter guessed
			(setf (@ context fill-style) "#FF0000"	
            (@ context font)       "16px Sans-Serif")
      (chain context (fill-text (+ "Letters Guessed: " (chain letters-guessed (to-string)))
                                10 260))

			(when game-over
				(setf (@ context fill-style) "#FF0000"	
            (@ context font)       "40px Sans-Serif")
				(chain context (fill-text "You Got It!" 150 180))))

		(defun create-image-data-pressed(e)
			(chain window (open (chain the-canvas (to-data-u-r-l)) "canvasImage" 
                          (+ "left=0,top=0,width="
                             (@ the-canvas width)
                             ",height=" (@ the-canvas height)
                             ",toolbar=0, resizable=0"))))

)))

(define-easy-handler (ch1ex4 :uri "/ch1ex4")()
	(html-frame
	(list :title "CH1EX3: Your First Canvas Applications"
        :scripts '("/modernizr-canvas.js" "/util.js" "/ch1ex4.js")
        :body (<:div :style (cl-css:inline-css '(:position absolute :top 50px :left 50px))
               	(<:canvas :id "canvasOne" :width "500" :height "300"
                      			  "Your Browser does not support HTML5 Canvas.")
                (<:form 
                  (<:input :type "button" :id "createImageData" :value "Export Canvas Image"))))))





