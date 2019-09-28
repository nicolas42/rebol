#!/usr/local/bin/rebol-view gif-viewer.r

rebol []

files: request-file
a: load files/1


view-gif-viewer: func [ a ] [

	draw-next: does [ a: next a i1/image: a/1 show i1 ]
	draw-prev: does [ a: back a i1/image: a/1 show i1 ]

	win: layout [

	across
		button "load" [ files: request-file a: load files/1 i1/size: a/1/size i1/image: a/1 show i1 ] 
		button "prev" [ draw-prev ] 
		button "next" [ draw-next ] return

	    i1: image a/1 [ draw-next ] feel [
	        engage: func [face action event] [
	            print [action event/key]
				if event/type = 'down [ draw-next return event ]
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
;		button "next" [ files: next files a: load files/1 i1/image: a/1 show i1 ]
;		button "prev" [ files: back files a: load files/1 i1/image: a/1 show i1 ]
	]
	
	view/new/options win [ resize ] 
	focus i1
	i1/text: none
	show i1
	do-events

]

view-gif-viewer a
