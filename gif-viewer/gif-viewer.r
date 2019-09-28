#!/usr/local/bin/rebol-view gif-viewer.r

rebol []

f1: request-file/only
a: load f1


view-gif-viewer: func [ a ] [

	draw-next: does [ a: next a i1/image: a/1 show i1 ]
	draw-prev: does [ a: back a i1/image: a/1 show i1 ]

	view/new layout [
	    i1: image a/1 feel [
	        engage: func [face action event] [
			probe event/key
	            print [action event/key]
				switch event/key [
					left [draw-prev]
					right [draw-next]
					#"j" [draw-prev]
					#"l" [draw-next]
					#"^[" [ unview ]
				]
				event
	        ]
	    ]
	]
	focus i1
	i1/text: none
	show i1
	do-events

]
