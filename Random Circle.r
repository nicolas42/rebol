rebol[]

random/seed now/precise

win: center-face layout [
	backcolor black	origin 0 
	
	;canvas
	c: box black 380x380 edge none effect [draw []]
	;timer -10x-10 rate 1 [draw-turtle]
	key keycode [left right] [draw-turtle]
	key #"^M" [draw-turtle]
]

turn: func [n] [ang: ang + n]

move: func [n] [
	x: subtract x (n * cosine ang)
	y: subtract y (n * sine ang)
	append c/effect/draw as-pair x y
]

;Initialize all vars, generate draw-args and show the canvas.
draw-turtle: does [

	;canvas c for your painting

	ang: 90
	x: c/size/x / 2
	y: c/size/y / 2
	
	c/effect/draw: reduce [
		
		'pen random 255.255.255
		'fill-pen black
		
		'box -1x-1 c/size + 1
		'line-width 2 
		'line as-pair x y
	]
	
	t: random 360
	for m 1 360 1 [
		move m
		turn t
	]
	
	{chaos: make-chaos 3.9
	t: random 360
	for m 1 360 1 [
		move 100 * first+ chaos
		turn t
	]}
	
	show c
	
]

insert-event-func [
if event/type = 'resize [
	c/size: win/size
	show c
] event]

draw-turtle

view/options/title win [resize] "Turn"

