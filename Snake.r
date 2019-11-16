REBOL []

;Source: "Nick Antonaccio, http://www.re-bol.com/rebol.html#section-10.13.2"

redbox: to-image layout/tight [
	box red 10x10 edge none
]
greenbox: to-image layout/tight [
	box green 10x10 edge none
]

rand-pair: func [n] [
	as-pair round/to random n 10 round/to random n 10
]

random/seed now	

win: layout [
	key #"^M" [init]
	;key escape [quit]
	f: box white 300x300 
		effect [draw s] 
	debug
] 

init: does [

	newsection: false  
	f/rate: 30
	
	dir: first dirs: [0x10] 

	s: reduce [	
		'image greenbox (50x50 + rand-pair 190)
		'image redbox 150x150
		'image redbox 150x160
	]
]


f/feel/engage: func [f a e] [ 
	
	switch a [
	
		time [
		
			dir: either 1 = length? dirs [first dirs] [take dirs]
			
			;If snake hits herself or the wall
			if any [
				find (at s 7) s/6
				any [s/6/x < 0 s/6/y < 0 s/6/x > 290 s/6/y > 290]
				][
				f/rate: none 
				show f
				exit
			]
			
			;If an apple is eaten
			if within? s/6 s/3 10x10 [
				append s reduce ['image redbox last s]
				newsection: true
				s/3: rand-pair 290
			]
			
			;New Snake
			news: copy/part head s 5  append news (s/6 + dir)
			for item 7 (length? head s) 1 [
				append news either pair? pick s item [pick s item - 3] [pick s item]
			]
			
			if newsection [change back tail news last s  newsection: false]
				s: copy news
				show f
		]
	]	
]

insert-event-func [
	if event/key [
		dir: select [up 0x-10 down 0x10 left -10x0 right 10x0] event/key
		if equal? last dirs negate dir [exit]
		append dirs dir
	]
	event
]

init
view/new/title center-face win "Snake"
forever [attempt [do-events]]

