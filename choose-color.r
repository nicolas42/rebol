REBOL []

comment {
	;same as "? tuple!" except returns string, doesn't print. First attempt
	types: dump-obj/match system/words 'tuple!


	;[1] Get word and value of all tuples in rebol 
	words: first system/words
	vals: second system/words
	tuples: []
	forall vals [
		if tuple? first vals [
			append tuples pick words index? vals
			append tuples first vals
		]
	] 
	tuples


	;generated from code at [1]
	colors: [gray 128.128.128 white 255.255.255 silver 192.192.192 water 80.108.142 black 0.0.0 maroon 128.0.0 snow 240.240.240 blue 0.0.255 coal 64.64.64 pewter 170.170.170 green 0.255.0 cyan 0.255.255 red 255.0.0 yellow 255.255.0 magenta 255.0.255 navy 0.0.128 leaf 0.128.0 teal 0.128.128 olive 128.128.0 purple 128.0.128 orange 255.150.10 oldrab 72.72.16 brown 139.69.19 coffee 76.26.0 sienna 160.82.45 crimson 220.20.60 violet 72.0.90 brick 178.34.34 pink 255.164.200 gold 255.205.40 tan 222.184.135 beige 255.228.196 ivory 255.255.240 linen 250.240.230 khaki 179.179.126 rebolor 142.128.110 wheat 245.222.129 aqua 40.100.130 forest 0.48.0 papaya 255.80.37 sky 164.200.255 mint 100.136.116 reblue 38.58.108 base-color 160.180.160 yello 255.240.120 main-color 175.155.120 button-color 44.80.132 over-color 44.80.132 bar-color 100.120.100 windows-edge 167.166.170 windows-color 235.233.237]

}

b: []

fnt: make face/font [
	align: 'center
	valign: 'middle 
	name: "Lucida Grande" ;"Times New Roman" ;
	size: 30
]


choose-color: does [
	result: none

	colors: [gray white silver water black maroon snow blue coal pewter green cyan red yellow magenta navy leaf teal olive purple orange oldrab brown coffee sienna crimson violet brick pink gold tan beige ivory linen khaki rebolor wheat aqua forest papaya sky mint reblue base-color yello main-color button-color over-color bar-color windows-edge windows-color]

	sheet: [
		
		backcolor windows-color
		space 2  origin 5 across 
		
		box 10x10 return		
		key escape [halt]
		pad 10 c: box 40x40 black
		pad 10 
		t: box 150x40 effect [draw b]  return
		box 10x10 return
		
	]

	b: reduce ['font fnt 'pen black 'text 5x0 "Black"]

	;round/ceiling length? colors

	forall colors [
		repend sheet [
			'box 20x20 colors/1 [result: face/color unview]
				'with compose [
					var: 'color-choice
					data: (to-lit-word colors/1)
					feel/over: func [face into pos] [
						unless into [exit]
						;t/text: form face/data
						if face/var = 'color-choice [
							c/color: face/color
							b: reduce ['font fnt 'pen black 'text 5x0 form face/data]
						]
						show [c t]
					]
				] 
		]
		if 0 = remainder index? colors 10 [append sheet [return]]
	]

	view win: center-face layout sheet
	result

]

choose-color


;loop that's like foreach but can use index? in it.
;each: func [forall


