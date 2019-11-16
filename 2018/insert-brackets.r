rebol [
	title: "Insert Brackets"
	date: 9-June-2013
	author: "Nicolas Schmidt"
	doc: {
		* Bracketless code can not be pasted into an interpreter.

		The difference in beginning line tabs determines the placement of brackets. If line1 has one less tab than line2, a bracket is appended to line1. If line2 has one less tab than line1, a bracket is inserted into the head of line2.

		Tabs can be checked by highlighting text.
	}
]

insert-brackets: funct [arg [string!] ][

	count-tabs: func [
		{return the number of tabs that a line begins with}
		a [string!]
	][
		if empty? a [return 0]
		while [equal? tab a/1][set 'a next a]
		subtract index? a 1
	]
	
	lines: parse/all trim/auto arg {^/}
	
	until [
	
		; difference in tabs between lines 1 and 2
		dt: subtract count-tabs lines/2 count-tabs lines/1
		either positive? dt [
			loop dt [append lines/1 {[}]
		][
			loop negate dt [append lines/2 {]}] ; using insert :(
		]
		lines: next lines
		tail? next lines
		
	]
	a: head lines
	b: copy {}
	forall a [
		append b first a 
		append b newline
	]
	b
]

do-bracketless: func [ a ] [
	do insert-brackets a 
]

remove-brackets: funct [ 
	{Note that if funct is used then arguments must be on another line to avoid bracket mismatch since it add lines to the code}
	arg [string!] 
][

	beg-line: charset {] ^-}
	end-line: charset {[ ^-}
	
	lines: parse/all arg {^/}
	out: copy []
	foreach l lines [
		; probe l
		while [ all [ l/1 find beg-line l/1 not tail? l ] ] [
			either l/1 = #"]" [ remove l ] [ l: next l ]
		]
		; probe head l
		l: back tail l
		while [ all [ l/1 find end-line l/1 ] ] [
			if l/1 = #"[" [ remove l ]
			l: back l
			if head? l [break]
		]
		; probe head l
	]
	out2: copy {}
	foreach l lines [
		append out2 l 
		append out2 newline
	]
	out2
]


demo: does [
	do probe insert-brackets probe {
	
		rebol 
			title: "Chart"
		
		data: 
			12 3 9 38 1 23 18
		
		gui: copy 
			backdrop white
		
		foreach val data 
			append gui compose 
				box blue (as-pair (val * 10) 40)
		
		win2: layout/offset gui 500x50
		
		view/options win2 [resize]
		
	}
	
	; isn't that pretty code

]