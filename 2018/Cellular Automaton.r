rebol[]

;The colors of windows programs
windows-edge: to-tuple #{a7a6aa}
windows-color: to-tuple #{ebe9ed}

stylize/master [

	progress: progress white edge [
		size: 1x1 
		effect: none
		color: windows-edge
	]

	link: text blue 
		font reduce [colors: reduce [blue red]]
		para [origin: 0x1 margin: 0x1]

	timer: sensor 0x0 rate 1 feel [
		engage: func [f a e] [if a = 'time [f/action f e]]
	]

	area: area wrap white white
		edge [color: windows-edge size: 1x1 effect: none]
		para [tabs: 10]  
		effect [aspect]
		
	field: field white white
		edge [color: windows-edge size: 1x1 effect: none]
		effect [aspect]

	button: button plain windows-color 
	edge [color: windows-edge size: 1x1 effect: none]
	font [color: black shadow: none colors: reduce [black silver]]
		
	key: key -20x-20

	debug: key keycode [f2] [halt]
	escape-key: key escape [halt]	;old

	gif: image with [
		frames: copy [] 
		rate: 15
		feel: make feel [
			engage: func [face action event] [
				if action = 'time [
					face/image: first face/frames 
					if tail? face/frames: next face/frames [
						face/frames: head face/frames
					] 
					show face
				]
			]
		] 
		words: [
			frames [append new/frames second args next args] 
			;rate func [new args][new/rate: second args next args]
			;data func [new args][new/data: second args next args]
		] 
		init: append copy init [
			;forall frames [change frames load-image first frames] 
			frames: head frames 
			image: first frames
			size: image/size
		]
	]


]

cell-size: 800x400

circle-ball: reduce load to-binary decompress 64#{
eJxz93SzsEwUYBBg+MTA8P8/AxAcOsTg5ARiJCUxNDUxTJrEoPif2881JNjZMcDV
SM+AmREop/hPyrkoNbEkNUWhPLMkQyExK7EiJz8xRS8zLy2fQfEnCycXUJUOyBiQ
4QzMxhy77vwzOOWZLZzMYcUhOYfdb0Yap+tGw0O7RGYe3KaXcORQ4QXdaAnLu8vY
LSV42L2yn3swYDPHBGSOX4+ignQLz+4Nz7pcCp0CQxIMJRUSfFyjpVbUyGwtvf82
UYK9QeG6xKM2Z8lNqipaQtgMMuPYZaSsfcrxxIQzU8L02VqTZfi+SPp99HRKnLG6
QOYD15nNe2WOrdBminwr/oex+TC/0coUqfn7WXD4LUlV+5RR28Q3c8LiW7uXcbYq
8rAYurQnygiucmvacFGeOSko9rOtvIGFjlT/iSVFlj5Y/WbEsatIXdvreYrIB4nP
Po08amWHE2KSQqa0tuyUy4h00jx/ykGAWe6ljfxhNbA5QZOwGgN0jsKhCZbij0ue
77k1z0DyuMwDRT2nbXNPha9ZZMjDxi1SnLh7g+n3qYyNBhs4O3fPz9X0wuWcO/8+
cArenBMaO4vx3a3CgqkJHXcT59w1mdbq6HbUQGRCwuxtjLwshxwEZhs2HLp2biJu
Y4AxvzrV6coczetyHByHFfqOF/KxGBqsPLVhXYDEIWB0hd1ayqRQmiTRNC9acAID
gzUDDAAAIS7OiqECAAA=
}


;make a cellular automaton image of size sz and with rule number n
cell: func [sz n] [

	bitpattern: func [int /width w /local it] [
		it: enbase/base to-binary to-block int 2
		if width [return skip it 8 - w] it
	]
	;e.g. bitpattern 2 => "00000010"
	
	rule: copy []  
	repeat i 8 [
		if #"1" = pick bitpattern n i  [
			bp: bitpattern/width (i - 1) 3
			replace/all bp "0" #{FF960A}
			replace/all bp "1" #{FFFF00}
			append rule make image! reduce [3x1 to-binary bp]
		]
	]
	
	i: to-image layout [origin 0 image sz yellow]
	i: skip change at i sz/x / 2 orange -3
	
	width: 5
	below: sz/x + 2
	loop sz/y - 1 [
		loop width [
			i3: copy/part i 3
			foreach r rule [
				if equal? r i3 [poke i below orange]
			]
			i: next i
		]
		i: skip i (sz/x - width - 1)
		width: width + 2
	]
	head i
]



;interesting cellular automatons
;[30 45 57 60 67 73 90 91 107 110 124 129 131 135 137 147 150]

write %worker mold compose [
	rebol []
	cell: (:cell)
	save/png %img cell (cell-size) 30
]

launch %worker

write %img ""
win: layout [
	style loader gif with [
		frames: load circle-ball
		size: frames/1/size
	]
	
	backcolor yellow 
	size cell-size
	
	ld: loader 
	
	fac: box cell-size
		effect [aspect draw []] 
		para [origin: 0x0]
	
	tm: timer [
		if zero? size? %img [exit]
		ca: load %img
		write %img ""
		fac/effect/draw: reduce [
			'image ca 0x0 as-pair win/size/x 0 win/size as-pair 0 win/size/y
		] 
		show fac 
		ld/rate: none hide ld
	]
]

ld/offset: win/size / 2
fac/offset: 0x0

event-func: insert-event-func [
	switch event/type [
		close [
			delete %worker 
			delete %img
		]
		resize [
			fac/size: win/size
			fac/effect/draw: reduce [
				'image ca 0x0 as-pair win/size/x 0 win/size as-pair 0 win/size/y
			] 
			show fac 
		]
	]
	event
]

view/options center-face win [resize]