rebol [
	doc: {
		The markup function works pretty much as you'd expect.
		
		markup [tag [ tag2 "something" ] ]
		 => <tag><tag2>something</tag2></tag> 
			
		Single tags must be in a block and must have a #"/" character before the end brace.
		e.g. [meta /]
		
				Tags must have an odd number of items. That means that attributes pair with values.
		[parent attribute value attribute value]
		
		Reading the source		
		'a' is the open tag		
		'c' is the close tag i.e. </tag>
		'b' is the stuff in the middle that may require recursion.

	}
	
]

build-tags: func [
	{build-tags}
	arg o tabs /local a b c d
][
	forall arg [
	
		a: arg/1
		a: append copy [] a
		c: append copy [] to-refinement first a
		
		repend o [ tabs a: build-tag a newline ]

		if not-equal? #"/" last a [
		
			arg: next arg
			b: arg/1
			
			either block? b [
				append o build-tags b copy [] join tabs tab
			] [
				repend o [ join tabs tab b newline ] 
			]
			
			repend o [ tabs build-tag c newline ]
		]
	]
	o
]

markup: func [ a ] [ build-tags a copy [] copy {}]


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