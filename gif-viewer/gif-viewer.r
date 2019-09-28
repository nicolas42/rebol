#!/usr/local/bin/rebol-view gif-viewer.r

rebol []

view-gif: func [ a ] [

	draw-next: does [ a: next a i1/image: a/1 show i1 ]
	draw-prev: does [ a: back a i1/image: a/1 show i1 ]

	win: layout [

	backcolor white
	across
		button "load" keycode [#"^M"] [ files: request-file a: load files/1 i1/size: a/1/size i1/image: a/1 show i1 ] 
		button "prev" keycode [left #"j"] [ draw-prev ] 
		button "next" keycode [right #"l"] [ draw-next ]
		button "+" keycode [#"="] [ i1/size: i1/size * 1.2 show i1 ] 
		button "-" keycode [#"-"] [ i1/size: i1/size / 1.2 show i1 ] 
		
		button "quit" keycode [#"^[" #"q"] [ unview ] return
	    i1: image a/1 [ draw-next ]
	]
	
	view/new/options win [ resize ] 
	focus i1
	i1/text: none
	show i1
	do-events

]

main: [
	files: request-file
	a: load files/1
	view-gif a
]

do main