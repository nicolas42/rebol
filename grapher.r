REBOL[] http://www.rebol.com/docs/draw.html

;in-dir rebol/options/home [do %math.r]


;=== Wish List
{
	domain -10 10 1
	range -10 10 1
	
	sigma k 0 10 [
		x ** k / (fac k) * imag k
	]
	
	coeff: [0 1 2 3]	;coefficients
	
	sigma k 0 3 [
		x ** k * coeff/(k + 1)
	]
	
	dialect: [
	black red 
	range -10 10
	domain -10 10
	scale 1x1
	]
	
	
}

examples: [
	{x ** 2 + (4 * x) + 8}
	"2 * cos x + sin x"
	"exp x"
	"sum k 0 10 [(x ** k) / (fac k)]"
	"(1) - (x ** 2 / fac 2) + (x ** 4 / fac 4)"
	"sum k 0 10 [(x ** k) / (fac k) * (im k)]"	
	{coeff: [8 4 1] sum k 0 2 [x ** k * first+ coeff]}
]


sin: func [x] [sine/radians x]
cos: func [x] [cosine/radians x]

factorial: func [f /local a ] [
	a: 1.
	repeat i f [ 
		a: a * i 
	]
	a
]
fac: :factorial




total: sum: func [b] [t: 0 foreach i b [t: t + i]]
average: avg: func [b] [divide sum b length? b]

im: imaginary: func [p] [
	first skip [1 0 -1 0] remainder p 4
]

sum: func ['k low hi blk /local a] [
	a: 0
	for k low hi 1 compose/only [a: add a do (blk)]
]

;Defaults
xmin: -10  xmax: 10  xscale: 1
ymin: -10  ymax: 10  yscale: 1


graph: func [face formula] [

	;Calculate Data From Formula
	scaler: face/size/x / (xmax - xmin / xscale)
	data: copy []
	for x xmin xmax xscale / scaler [append data do bind/copy load/all formula 'x]


	sz: face/size
	box: as-pair ;size of a box
		sz/x / (xmax - xmin / xscale)
		sz/y / (ymax - ymin / yscale)

	xaxis: box/y * ymax / yscale			;x axis height 
	yaxis: negate box/x * xmin / xscale		;y axis width


	;Plot Data
	plot: copy [pen blue line]
	x: 0
	ht: sz/y / 2
	foreach y data [
	 append plot as-pair x xaxis - (box/y * y)
		x: x + 1
	]

	;Remove Multiple Y Values For One X Value
	p: skip plot 3
	out: copy [pen blue line]
	forall p [if all [p/1 p/2] [if p/1/1 <> p/2/1 [append out p/1]]]
	plot: out 


	;Make Grid
	grid: copy [pen silver]

	;verticle lines
	for x 0 sz/x box/x [
		append grid reduce ['line as-pair x 0 as-pair x sz/y]
	]

	;horizontal lines
	for y 0 sz/y box/y [
		append grid reduce ['line as-pair 0 y as-pair sz/x y]
	]

	;Black axis
	append grid reduce [
		'pen 100.100.100
		'line as-pair 0 xaxis as-pair sz/x xaxis	;across
		'line as-pair yaxis 0  as-pair yaxis sz/y	;down
	]
	
	face/effect: reduce ['draw append grid plot]
	show face
]

opts: layout [
	style pt text 50 230.9.102 
	backcolor 25.25.25
	across
	pt "Domain" field "-10 10 1" return
	pt "Range" field "-10 10 1" return
	pt "Graph" f2: field "x"[
		graph f1 value focus f2
		tl/data: unique append tl/data value
		show tl
	] return  
	tl: text-list 250 data examples [graph f1 value]
	key escape [halt]
] 


insert-event-func [
	if event/type = 'resize [
		f1/size: as-pair it: round/to subtract min win/size/x win/size/y 40 10 it
		graph f1 f2/text
	]
	if event/type = 'close [unview/all]
	event
]

f1-size: 400x400
xmin: -10  xmax: 10  xscale: 1
ymin: -10  ymax: 10  yscale: 1

win: center-face layout compose [
	f1: box snow f1-size
	key escape [halt]
]


view/new/options win [resize]
view/new opts 
graph f1 f2/text focus f2
wait[]
