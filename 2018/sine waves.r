REBOL[title: "Sine Waves"] 

;helper functions
sin: func [x] [sine/radians x]
cos: func [x] [cosine/radians x]


;Box f, draw plot
win: layout [origin 0 f: box snow 240x160 effect [draw axis draw plot]]
insert-event-func [
	if event/type = 'resize [
		f/size: win/size graph fn
	]
	event
]

;helpers
domain: func [a][xmin: a/1 xmax: a/2]
range: 	func [a][ymin: a/1 ymax: a/2]

;draws axis, initializes variables based on f and xmin, xmax, etc.
reset: does [

	;math height, width
	mh: ymax - ymin	
	mw: xmax - xmin

	;interface height, width, half width, half height
	h: f/size/y		w: f/size/x
	hh: h / 2  		hw: w / 2
	
	plot: copy []
	axis: reduce [
		;grid 10x10 0x0 200.200.200

		;black axis
		'pen 100.100.100
		'line as-pair 0 hh as-pair w hh
		'line as-pair hw 0 as-pair hw h
	]
	;show f
]

graph2: func [fn color] [

	if empty? fn [return reset]
	
	append plot compose [pen (color) spline]
	p: 0
	for x xmin xmax mw / w [
	
		;make math y value
		y: attempt [do bind/copy load/all fn 'x]
		
		;convert to pixels and append plot
		if y [append plot as-pair p hh - (y * h / mh)]
		p: p + 1
	]
	plot
	;. plot
	;show f
]

graph: func [formula][reset foreach [f col] formula [graph2 f col] show f]

;yawp
domain [-50 50]  
range [-5 5]

set [n m][1 1]
fn: [
	[(sin n * x) + (sin m * x)] blue
	[sin n * x] red
	[sin m * x] green
	;[(cos n * x) ** 2]
	;[(sin m * x) ** 2]
	;[(cos n * x) + (sin m * x)]
	;[((cos n * x) ** 2) + ((sin m * x) ** 2)]
]
graph fn
view/new/options win [resize]

insert-event-func [
	switch event/type [
		scroll-line [n: n - event/offset/y graph fn print [n m]] 
		scroll-page [m: m - event/offset/y graph fn print [n m]]
	]
	event
]
do-events





{

http://www.rebol.com/docs/draw.html

sin: func [x] [sine/radians x]
cos: func [x] [cosine/radians x]

;Defaults
xmin: -10  xmax: 10  xscale: 1
ymin: -10  ymax: 10  yscale: 1


graph: func [face formula] [

	;Calculate Data From Formula
	data: copy []
	xstep: (xmax - xmin) / face/size/x
	for x xmin xmax xstep [append data do bind/copy load/all formula 'x]


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
	out: copy [pen blue spline]
	forall p [if all [p/1 p/2] [if p/1/1 <> p/2/1 [append out p/1]]]
	plot: out


	;Make Grid, 
	grid: copy [pen silver]
	
	{;verticle lines
	for x 0 sz/x box/x [
		append grid reduce ['line as-pair x 0 as-pair x sz/y]
	]
	;horizontal lines
	for y 0 sz/y box/y [
		append grid reduce ['line as-pair 0 y as-pair sz/x y]
	]}

	;Black axis
	append grid reduce [
		'pen 100.100.100
		'line as-pair 0 xaxis as-pair sz/x xaxis	;across
		'line as-pair yaxis 0  as-pair yaxis sz/y	;down
	]
	
	face/effect: reduce ['draw append grid plot]
	show face
]

{handle [resize [f/size: w/size	graph f g]]}

w: layout [origin 0 f: box snow screen/size]
xmin: -100  xmax: 100  xscale: 1
ymin: -10 ymax: 10  yscale: 1
g: "sin x"
graph f g
yawp
view/offset f 0x0


}

{yawp
layout [f: box snow sv/screen-face/size]

;half width, half height
hw: f/size/x / 2  hh: f/size/y / 2
f/effect: reduce [
	;grid 10x10 0x0 200.200.200

	;black axis
	'pen 100.100.100
	'line as-pair 0 hh as-pair hw hh
	'line as-pair hw 0 as-pair hw hh
	
	'pen 'blue 'spline 
]

for x negate hw hw 1 [
	append f/effect as-pair hw + x 100 * sine/radians x
]
. append f/effect [flip]
view/offset f 0x0}



{
;formula functions, convenient
sin: func [x] [sine/radians x]
cos: func [x] [cosine/radians x]

layout [f: box snow sv/screen-face/size effect [draw plot]]




;preferences
xmin: -10  xmax: 10
ymin: -10  ymax: 10
formula: "sin x"

;math height, width
mh: ymax - ymin
mw: xmax - xmin

;interface height, width, half width, half height
h: f/size/y		w: f/size/x
hh: h / 2  		hw: w / 2



plot: reduce [
	;grid 10x10 0x0 200.200.200

	;black axis
	'pen 100.100.100
	'line as-pair 0 hh as-pair w hh
	'line as-pair hw 0 as-pair hw h
	
	'pen 'blue 'spline 
]

p: 0
for x xmin xmax mw / w [
	y: do bind/copy load/all formula 'x
	
	append plot as-pair p hh - (y * h / mh)
	p: p + 1
]

. plot


;yawp
view/offset f 0x0}