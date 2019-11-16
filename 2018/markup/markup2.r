rebol [
	doc: {
		The markup function works like this.
		
		markup [tag [ tag2 "something" ] ]
		 => <tag><tag2>something</tag2></tag> 
		 
		 
			
		Single tags, i.e. those without an end tag, must be enclosed a block and must have a #"/" character before the end bdrace.
		e.g. [meta /]
	}
	
]

build-tags: func [
	arg [block!] out tabs 
	/local start content end 
][
	forall arg [
	
		start: arg/1
		start: append copy [] start
		end: append copy [] to-refinement first start
		
		repend out [ tabs start: build-tag start newline ]

		if not-equal? #"/" last start [
		
			arg: next arg
			content: arg/1
			
			either block? content [
				append out build-tags content copy {} join tabs tab
			] [
				repend out [ join tabs tab content newline ] 
			]
			
			repend out [ tabs build-tag end newline ]
		]
	]
	out
]

markup: func [ a ] [ 
	build-tags a copy {} copy {}
]

;test markup stuff

mold1: func [
	{mold a block and remove first and last braces.}
	a [block!]
] [
	a: mold a
	take a
	take back tail a
	trim/auto a
]


test-markup: does [

a: [
	weather [
		australia [
			brisbane {sunny and something else}
			melbourne {hot and sunny till 10pm at night}
			western-australia {who cares}
			[for testing purposes only "" /]
			[meta /]
		]
		belgium {who cares about belgium}
	]
]

editor rejoin [mold1 a newline newline markup a]

]


test-markup