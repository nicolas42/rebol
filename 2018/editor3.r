#!/usr/bin/rebol
rebol []

sv: system/view

insert-caret: func [a] bind [ 
	insert caret a
	highlight-start: caret
	caret: skip caret length? a
	highlight-end: caret
	show focal-face
] sv

select-line: func [/local a b] bind/copy [
	;select paragraph
	a: any [find/reverse back caret "^/" head caret]
	b: any [find caret "^/" tail caret]
	trim probe copy/part a b
] sv


try*: func [a][
	switch type? set/any 'a try a reduce [
		error! [return disarm a] 
		unset! [return none]
	]
	return :a
]

bind*: func ["one ring to bind them all" a][
	bind/copy bind/copy load/all a sv sv/focal-face
]

mold*: func [a][
	case [
		none? :a [a: ""]
		not string? :a [a: mold :a] 

	]
	:a
]

win: layout [
	origin 0
	f1: area 400x400 keycode [#"^M" #"^-"] [
		ctx-text/insert-char face newline
		show face
		insert-caret mold* try* [do bind* select-line]
		show face
	] [
	
		ctx-text/insert-char face #
		show face
		if not all [sv/highlight-start sv/highlight-end][exit]
		insert-caret mold* try* bind* copy/part sv/highlight-start sv/highlight-end
	]		
]
focus f1
view/new/options win [resize]
do-events
