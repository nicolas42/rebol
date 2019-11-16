REBOL [
	Title: "Chaos"
	author: "Nicolas Schmidt"
]

{A population has a growth rate which determines the instability of the population. 
Overpopulation causes starvation which may result in extinction. 
In this model, if the value 'r' is larger than 4 then the species is doomed.
TO DO - make a chaos function which outputs an image.}

make-chaos: funct [r] [
	b: copy [0.02]
	loop 2000 [insert b max 0 1 - b/1 * b/1 * r]
	reverse b
]

draw-chaos: func [
	sz "size of image"
	r "growth rate"
] [
	list: make-chaos r
	rule: copy [pen white line]
	x: 10

	foreach y list [
	    append rule as-pair x sz/y - 10 - (sz/y * y)
	    x: x + 3
	]

	draw sz rule
]

r: 4.000000
scale: 0.0000001

b: [text ""]
win: layout [
	backcolor black
	bf: box black 200x20 effect [draw b]
	f1: image 800x400
	debug
]

f1/image: draw-chaos f1/size r

handle [
	scroll-line[
		r: add r multiply scale negate divide second event/offset 3
		f1/image: draw-chaos f1/size r
		b/2: join "Growth Rate: " r 
		show bf
		show f1
	]
	resize [
		f1/size: win/size
		f1/image: draw-chaos 0.8 * f1/size r
		b/2: join "Growth Rate: " r 
		show bf
		show f1
	]
	up [scale: scale * 10]
	down [scale: scale / 10]
]

b/2: join "Growth Rate: " r 
show bf
view/options center-face win [resize]

