REBOL [
	Title: "Spreadsheet"
]

;--- Added convenience function

do %statistical-functions.r

span: func [b /local p out] [
	p: copy []
	forall b [append p as-pair to-integer first form b/1 to-integer next form b/1]
	out: copy []
	for i p/1/1 p/2/1 1 [for j p/1/2 p/2/2 1 [
	        append out to-word join to-char i j
	]]
	reduce out
]

;--- Only needed for older REBOL/Views
as-pair: func [x [number!] y [number!]][
	to-pair reduce [to-integer x to-integer y]
]

;--- Configuration

cell-size:  125x20
sheet-size: 7x32

;--- Constants

scalar-types: [integer! | decimal! | money! | time! | date! | tuple! | pair!]
protect 'scalar-types

;--- Globals

sheet: 
lay: 
current-file: 
sheet-code:     ; sheet-specific code, used to extend functionality
	none
cells: copy []  ; e.g. [A1 <face> B1 <face> ...]
sheet-buttons: copy []

;--- Worksheet Data Format Dialect

use [
	; rules
	buttons== cell== sheet-code==
	; vars
	id val text action face style
] [
	id: val: text: action: face: none
	style: 'btn  ; 'button
	buttons==: [
		'buttons into [
			any [
				set val word! (id: val) 2 [
					set val string! (text: val)
					| set val block! (action: val)
				] (
					repend sheet-buttons [id text action]
					append lay/pane face: make-face/size/offset style
						cell-size
						cells/:id/offset
					if 'button = style [face/edge/size: 1x1]
					if not none? face [
						face/text: text
						face/action: action
						face/style: style
					]
				)
			]
		]
	]
	cell==: [
		set id word! into [
			opt 'formula set val [block! | path!] (cells/:id/formula: :val)
			| opt 'value set val [string! | scalar-types] (
				set cells/:id/var cells/:id/text: val
			)
		]
	]
	sheet-code==: ['do set sheet-code block! (do sheet-code)]
	; TBD Need a real ID rule, rather than just using word! values.
	sheet==: [
		(sheet-code: none  clear sheet-buttons)
		opt sheet-code==
		any [buttons== | cell==]
	]
]


;--- Patches

if link? [
	hilight-all: func [face] [
		either empty? face/text [unlight-text] [
			highlight-start: head face/text
			highlight-end: tail face/text
		]
	]
]

;--- Functions

clear-cell: func [cell] [set cell/var cell/text: cell/formula: none]

clear-sheet: does [
	foreach [id cell] cells [clear-cell cell]
	; remove any added faces (e.g. buttons)
	clear next find lay/pane last cells
	show lay
]

compute: does [
	unfocus
	foreach [id cell] cells [
		if cell/formula [
			if error? try [cell/text: do cell/formula] [cell/text: "ERROR!"]
			set cell/var cell/text
			show cell
		]
	]
]

cur-cell: does [either in-cell? [system/view/focal-face] [none]]

empty-cell?: func [cell] [
	all [
		none? cell/formula
		any [
			none? cell/text
			all [string? cell/text empty? cell/text]
		]
	]
]

enter: func [face /local data] [
	if empty? face/text [exit]
	set face/var face/text
	data: either #"=" = face/text/1 [next face/text][face/text]
	if error? try [data: load data] [exit]
	if scalar? :data [face/formula: none  set face/var data  exit]
	; blockify formula (could be a path!), or reset it to none.
	face/formula: either formula? face/text [compose [(:data)]] [none]
]

;** This is our insert-event-func callback function
event-func: func [face event /local f] [
	if all ['key = event/type in-cell?] [
		switch event/key [
			F2    [if in-cell? [show-formula system/view/focal-face]]
			up    [move up]
			down  [move down]
			; left/right conflict with edit navigation, need a more
			; complex system to track edit mode if we want to do
			; this. Use Tab/Shift+Tab to move L/R in the meantime.
			;left  [move left]
			;right [move right]
		]
	]
	event
]

formula?: func [text] [#"=" = text/1]

in-cell?: has [f] [all [f: system/view/focal-face 'cell = f/style]]

load-sheet: func [file [file! url!]] [
	clear-sheet
	parse load/all file sheet==
	current-file: file
	show lay
	compute
]

; The tab key triggers the face's action, but the arrow keys don't,
; so we need to manually call ENTER to set cell values if they move
; with the arrow keys.
move: func ['way /local pos] [
	pos: find cells cur-cell
	cell: pick switch way [
		up    [enter cur-cell  skip pos negate sheet-size/x * 2]
		down  [enter cur-cell  skip pos sheet-size/x * 2]
		;left  [back pos]
		;right [next pos]
	] 1
	; Keep from falling off the top of the list due to a negative skip.
	; stay where we are                 ; move to first cell
	if not object? cell [cell: none]    ; if 'A1 = cell [cell: cells/A1]
	if cell [focus cell]
]

new-sheet: does [
	clear-sheet
	current-file: none
	show lay
	focus second cells
]

use [not-vals] [
	not-vals: reduce [none ""]
	no-val?: func [cell-val] [find not-vals cell-val]
]

open-sheet: func [/with file [file! url!]] [
	if not file [
		if %none = file: to-file request-file [exit]
	]
	load-sheet file
	focus second cells
]

save-sheet: func [/as /local file buffer] [
	if any [not file: current-file  as] [
		if %none = file: to-file request-file/save [exit]
	]
	if all [file <> current-file  exists? file] [
		if not confirm join file " already exists. Do you want to write over it?" [exit]
	]
	buffer: copy []
	if sheet-code [repend buffer ['do sheet-code]]
	if not empty? sheet-buttons [repend buffer ['buttons sheet-buttons]]
	foreach [id cell] cells [
		if not empty-cell? cell [
			repend buffer [
				cell/var reduce [any [cell/formula  get cell/var]]
			]
		]
	]
	save file buffer
	current-file: file
]

scalar?: func [val] [find scalar-types type?/word :val]

set-cell: func [id val /local cell] [
	cell: select cells id
	cell/text: form val  enter cell  show cell
	compute
]

show-formula: func [face] [
	if face/formula [
		; set-face not available under link
		;set-face face join "=" mold/only face/formula
		face/text: join "=" mold/only face/formula
		; using FOCUS highlights the text, shows the face, and *most
		; importantly* takes care of resetting the caret correctly and
		; preventing the caret related crash because there is no edge.
		focus face
	]
]


;--- Data Export

ctx-html-export: context [
	out-buff: make string! 10'000

	html-template: {
<html>
<!--Page generated by REBOCalc-->
<head>
<title>$title</title>
<style type="text/css">
html, body, p, td, li {font-family: arial, sans-serif, helvetica; font-size: 10pt;}
table, tr {border-collapse: collapse;}
th, td {font-size: 12px; border: 1px solid #C0C0C0; padding: 0.5em 0.5em 0;}
th {background: #8E806E; font-weight: bold; text-align: center; color: #404040;}
</style>
</head>
<body bgcolor="white">
$table
</body></html>
}

	emit: func [data] [repend out-buff [reduce data newline]]

	set 'emit-html func [/to file /local val] [
		clear out-buff
		emit <table>
		repeat row 1 + sheet-size/y [
			emit [<tr><th> either 1 = row [""] [form row - 1]</th>]
			repeat col sheet-size/x [
				emit either 1 = row [[<th> col-lbl col </th>]] [
					[<td width="110"> any [get/any mk-var col row - 1 ""] </td>]
				]
			]
			emit </tr>
 		]
		emit </table>
		out-buff: replace copy html-template "$table" out-buff
		write %rebolcalc-out.html out-buff browse %rebolcalc-out.html
		;either file [write file html] [html]
	]
]

;--- Worksheet Functions

;--- Sheet Generation Support Functions

col-lbl: func [col] [form to char! 64 + col]
cell-name: func [col row] [join col-lbl col row]
mk-cell-size: func [col] [
	either any [none? col-widths  col > length? col-widths] [cell-size] [
		as-pair col-widths/:col cell-size/y
	]
]
mk-var: func [col row] [to lit-word! cell-name col row]

;--- Main Sheet Layout Generation

sheet: [
	origin 5x5 space 1x1 across
	style cell field cell-size edge none with [formula: none] [
		enter face  compute  face/para/scroll: 0x0
	]
	style label text cell-size white rebolor bold center
	style menu button 70x20 silver edge [size: 0x0] shadow off with [
		font/colors: [0.0.0 0.0.128]
		font/name: "verdana" ; added
	]
	menu "New"  #"^n" [new-sheet]  menu "Open" #"^o" [open-sheet]
	menu "Save" #"^s" [save-sheet] menu "Save As" #"^a" [save-sheet/as]
	menu "HTML" #"^t" [emit-html]
	menu "Quit" #"^q" [quit] ;f-current-file: text 400
	menu "Halt" [halt] ;f-current-file: text 400
	return
]

repeat row 1 + sheet-size/y [   ; +1 accounts for header row
	;repend sheet ['label (cell-size / 2x1) either 1 = row [""] [form row - 1]]
	repend sheet ['label (as-pair 30 cell-size/y) either 1 = row [""] [form row - 1]]
	repeat col sheet-size/x [
		append sheet compose/deep either 1 = row [[label (col-lbl col)]] [
			[cell with [var: (mk-var col row - 1)]]
		]
	]
	append sheet 'return
]


;--- Startup

lay: layout sheet
foreach face lay/pane [
	if 'cell = face/style [
		repend cells [face/var face]
		set face/var none
	]
]
focus second cells
insert-event-func :event-func
view lay


