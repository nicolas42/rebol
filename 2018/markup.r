rebol [
	date: 27-5-2013
	title: "Markup"
	author: "Nicolas Schmidt"
]

build-tags-no-format: func [
	{main recursive function}
	arg [block!] out [block!]
	/local start content end 
][
	forall arg [
	
		start: arg/1
		start: append copy [] start
		end: append copy [] to-refinement first start
		repend out [ start: build-tag start ]
		
		if not-equal? #"/" last start [
			arg: next arg
			content: arg/1			
			either block? content [
				append out build-tags content copy []
			] [
				repend out [content] 
			]			
			repend out [ build-tag end]
		]
	]
	out
]

{;example
build-tags-no-format [html [head [ [a href arstechnica.com ] {a link} ] ] ] []
== [<html> <head> <a href="arstechnica.com"> "a link" </a> </head> </html>]
}

build-tags: func [
	{main recursive function for markup}
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

markup: func [
	{
	produce formatted markup from rebol blocks
	e.g. 
	markup [tag [ tag2 "something" [hr /] ] ]
	 => <tag><tag2>something</tag2><hr /></tag> 

	Single tags, i.e. those without an end tag, must be enclosed a block and must have a #"/" character before the end brace.
	e.g. [meta /]
	
	If attributes are required then enclose the tag in braces. e.g. [a href google.com]
	}
	a
] [
	build-tags a copy {} copy {}
]