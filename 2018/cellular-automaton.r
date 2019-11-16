rebol []

c-code: {

	#include <windows.h> 
	#define DLL_EXPORT __declspec(dllexport)  
	
	DLL_EXPORT int cellular_automaton (int *a, int la, int *r, int lr, int col, int width) {
		int i, j;
		for (i=0; i<(la-(width+3)); i=i+1) {
			for (j=0; j<lr; j=j+3) {
				if (a[i] == r[j] && a[i+1] == r[j+1] && a[i+2] == r[j+2]) {
					a[i+width+1] = col ; //0x00ffffff;
				}
			}
		}
		return a;
	}
}

compile: does [
	attempt [ delete %cellular-automaton.dll ]
	write %cellular-automaton.c c-code
	call/console/wait "tcc -shared cellular-automaton.c"
]
; compile

library: load/library %cellular-automaton.dll

cellular-automaton1: make routine! [
	a [integer!] 
	la [int] 
	r [integer!]
	lr [int]
	col [int]
	width [int]
	return: [integer!]
] library "cellular_automaton"

make-rule: funct [n color1 color2][

	bitpattern: func [
		{bitpattern 2 => "00000010"}
		int 
		/width w 
		/local it
	] [
		it: enbase/base to-binary to-block int 2
		if width [return skip it 8 - w] 
		it
	]	
	rule: copy #{}
	repeat i 8 [
		if #"1" = pick bitpattern n i  [
			bp: bitpattern/width (i - 1) 3
			replace/all bp "0" color1
			replace/all bp "1" color2
			append rule to-binary bp
		]
	]
	rule
]


do %library-utils.r

; colors must be 32 bits wide
color1: #{0A96FF00}
color2: #{00FFFF00}
sz: system/view/screen-face/size

n0: 30
win: layout [ 
	backcolor black origin 0
	fac: image sz 
	key -20x-20 keycode [left] [n: n - 1]
	key -20x-20 keycode [right] [n: n + 1]
	; timer is a responsiveness hack. it prevents queueing of events
	timer: sensor -20x-20 rate 0 feel [ engage: func [f a e][ if a = 'time [
		if n <> n0 [
			cellular-automaton n
			n0: n
		]
	] ] ]
		
	key -20x-20 escape [ 
		; toggle command face
		either 6 <= length? win/pane [ 
			remove back tail win/pane
			show win/pane/1
		] [
			append win/pane make-face/spec 'field [
				action: func [face value] [
					test value
					focus self
				]
				edge none
			]
			focus last win/pane
			show win
		]
		; color1: #{00000000}
		; color2: #{ffffff00}
		; for black and white
	]
	at 0x0 com-face: field "" edge none [ 
		test value focus face 
	]
	do [focus com-face]
	
]

opt-face: make face 

view/new/options win [resize]

insert-event-func [ 
	switch event/type [ 
		resize [
			win/size: as-pair round/to win/size/x 2 win/size/y
			; doesn't work when height of image is an odd number. dunno why.
			sz: win/size
			fac/size: win/size
			cellular-automaton n
		]
	]
	event
]

int32: func [color [tuple!] ][
	append to-binary reverse color #{00}
]

update-window: does [	
	win/text: join "Cellular Automaton " mold n
	win/changes: [text]
	show win
]

cellular-automaton: funct [n][
	la: sz/x * sz/y
	
	; initialize image
	a: head insert/dup copy #{} color2 la
	change/part (skip a sz/x / 2 * 4) color1 4
	
	r: make-rule n color1 color2
	lr: divide length? r 4
	
	a: cellular-automaton1 string-address? a la string-address? r lr first convert color1 [int] sz/x
	a: get-memory a la * 4  	
	a: to-image a
	a/size: sz
	update-window
	fac/image: a
	show fac
]

n: 30
update-window
win/changes: [maximize]
show win
cellular-automaton n


colorize: func [
	{Convert tuple color to 32bit little endian color}
	col [tuple!]
][
	append to-binary reverse col #{00}
]

test: func [ arg [string!] ][
	set/any 'result attempt [ load/all arg]
	if any [
		not value? 'result
		none? result
	] [exit]
	colors: copy []
	foreach r result [
		if integer? r [
			n: r
		]
		if tuple? r [
			append colors colorize r
		]
		if tuple? attempt [get r][
			append colors colorize get r
		]
	]
	if 2 = length? colors [
		set [color1 color2] colors
	]
	if 1 = length? colors [
		set 'color1 colors/1
	]
	cellular-automaton n
]

do-events
