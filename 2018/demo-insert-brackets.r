rebol []

count-tabs: func [
	{return the number of tabs that a line begins with}
	a [string!]
][
	if empty? a [
		return 0
	]
	while [
		equal? tab a/1
	][
		set 'a next a
	]
	subtract index? a 1
]

insert-brackets: func[
	arg [string!]
	/local lines out dt
][
	lines: parse/all trim/auto arg {^/}
	
	until[
		dt: subtract 
		count-tabs lines/2 
		count-tabs lines/1
		 
		either positive? dt [
			loop dt [
				append lines/1 {[}
		]][
			loop negate dt [
				append lines/2 {]}
		]]
		lines: next lines
		tail? next lines 
	]
	
	out: copy {}
	lines: head lines
	forall lines [
		append out lines/1
		append out newline
	]
	out
]

a: {

count-tabs: func 
	{return the number of tabs that a line begins with}
	a [string!]

	if empty? a 
		return 0
	
	while 
		equal? tab a/1
	
		set 'a next a
	
	subtract index? a 1


insert-brackets: func
	arg [string!]
	/local lines out dt

	lines: parse/all trim/auto arg {^^/}
	until
		dt: subtract 
		count-tabs lines/2 
		count-tabs lines/1
		either positive? dt 
			loop dt 
				append lines/1 {[}
		
			loop negate dt 
				append lines/2 {]}
		
		lines: next lines
		tail? next lines 
	
	out: copy {}
	lines: head lines
	forall lines 
		append out lines/1
		append out newline
	
	out

}

b: insert-brackets a

win: layout [ 

	style area area 400x800 white white with [
		font/name: "courier new"
		; font/size: 13
		edge/size: 0x0
		para/wrap?: on
		para/tabs: 20
		flags: []
	]

	backcolor white across 
	
	menu: box 800x30 ; edge [size: 1x1] 
	
	return 
	
	; box silver 800x1 return 
	
	face1: area a #"^e" [ face2/text: insert-brackets face1/text show face2 ]
	face2: area ; b 

]

do1: does [ face2/text: insert-brackets face1/text show face2 ]
do2: does [ do face2/text ]
menu1: layout [
	style button button white white edge [size: 0x0]
	style link text blue font [ style: [bold underline] size: 16 name: "courier new"]
		origin 0 across 

	link "Insert Brackets" [do1] link "Do Column Two" [do2] 
]

menu/pane: menu1/pane

show menu

view win


{	rebol 
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



