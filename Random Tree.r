rebol[]

comment {
	draw instructions d
	history h
	face f
	x, y, ang
	
	There's a face f
}


random/seed now/precise

turn: func [n] [ang: ang + n]



move: func [n] [
	x: subtract x (n * cosine ang)
	y: subtract y (n * sine ang)
	append d as-pair x y	;draw argument d
]

tree: func [size] [
	if size < 5 [exit] 
	move size
	turn -30  tree .7 * size
	turn 60  tree .7 * size
	turn -30  
	move negate size
]

random-tree: rtree: func [size] [
	if size < 5 [exit] 
	move size
	turn -30  
	rtree size * divide random 10 10
	turn 60  
	rtree size * divide random 10 10 
	turn -30  
	move negate size
]

stylize/master [
	debug: key escape [halt]
]

win: center-face layout [
	backcolor black
	origin 0
	
	;canvas
	c: box black 380x380 effect [draw d]
	key keycode [left] [h: back h d: first h show c]
	key keycode [right][draw-d h: back tail h]
	;timer rate 1 [draw-turtle]
	debug
]

h: []	;history

;Initialize all vars, generate d and show the canvas.
draw-d: does [

	ang: 90
	x: c/size/x / 2
	y: c/size/y
	d: reduce [
		'pen random 255.255.255
		'line-width 2 
		'line as-pair x y
	]
	
	random-tree 100
	show c
	append/only h d
	
	
]

insert-event-func [
if event/type = 'resize [
	c/size: win/size
	show c
] event ]

draw-d

view/options/title win [resize] "Random Tree"

