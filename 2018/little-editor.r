rebol []

doc: {
	Just a little editor.
	Press control+l to evaluate the text
	Always use view/new as view will unview the editor
	Errors are viewed in a separate error window.
}

err-win: layout compose [
	backcolor white origin 0 
	err-face: text 400x400 as-is "No errors yet"
]

text1: {}

win: layout [
	origin 0 space 0 
	fac: area text1 #"^l" [ 
		if error? set/any 'err try [ do face/text ] [
			if not viewed? err-win [ 
				view/new/title/options err-win "Error Window" [resize]
			]
			err-face/text: mold disarm err
			err-face/size: size-text err-face
			err-win/size: err-face/size
			show err-win
			show err-face
			
		]
	]
	key #"^s" []
]

win/feel: make object! [
    redraw: none
    detect: func [face event][
    	if event/type = 'resize [
			face/pane/1/size: face/size
			show face/pane/1
		]
        either all [
            event/type = 'key
            face: find-key-face face event/key
        ] [
            if get in face 'action [do-face face event/key]
            none
        ] [
            event
        ]
    ]
    over: none
    engage: none
]

focus fac
view/options win [resize]