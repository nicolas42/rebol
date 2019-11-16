rebol []

text1: read request-file/only

font1: make face/font [
	name: "sergoe ui" ; calibri, verdana (windows 7) lucida grande
	size: 20
	align: 'left
	valign: 'top
	color: black
]

fixedsys: make font1 [
	name: "fixedsys"
]

edge1: make face/edge [size: 1x1 effect: none color: silver]
	

; agg engine antigrain graphics
win1: layout [
	backcolor white
	box 700x700 white effect [draw [font font1 text text1]]
]

; view win1 halt 

draw-face1: does [
	do bind [
		data: text
		text: none
		image: draw size [ font font1 text text1 ]	
		show self
	] face1	
]

; view engine
win2: layout [
	style area area 700x700 white white edge edge1 font font1
	style link text blue bold font font1 
	backcolor white
	
	face1: area text1
	link #"^e" "draw face1" [ draw-face1 ]
]

view win2


; context face1 %/c/users/nicolas/desktop
