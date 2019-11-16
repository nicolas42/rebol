rebol []

url-to-text: funct [ url ] [

	markup: load/markup url
	page: to-string markup
	
	a: remove-each tag copy markup [ tag? tag ]
	
	text: {}
	foreach a a [
		append text a append text " "
	]
	; editor text
	
	
	; &#32;  ; http://www.ascii.cl/htmlcodes.htm
	
	
	out: copy {}
	parse text [ 
		any [ 
			copy text1 to "&" thru "&" a: to ";" b: thru ";" ( 
				append out text1 
				a: copy/part a b
				; print a
				
				either #"#" = a/1 [ ; probe
					take a
					if lesser? length? a 4 [
						append out to-char do a
					]
				] [
					result: select [
						"nbsp" " " "quot" {"}
					] a
					if result [
						append out to-char result
					]
				]		
			)
		] 
		end
	]
	
	
	editor out

]

editor url-to-text http://arstechnica.com

comment {
	
	; test2
	; tested urls
	url: http://www.reddit.com/r/worldnews/comments/1fwhkx/what_we_have_is_concrete_proof_of_usbased/
	
	url: http://arstechnica.com
	
	
	
	; test1 
	
	text: {ints	1206 points	1207 points	&#32;	4 hours	&#32;ago	&nbsp;	(358 children)	[&ndash;]	sod6	&#32;}
		
	
	out: copy {}
	parse text [ 
		any [ 
			copy text1 to "&" thru "&" a: to ";" b: thru ";" ( 
				append out text1 
				a: copy/part a b
				; print a
				
				either #"#" = a/1 [ ; probe
					take a
					append out to-char do a
				] [
					result: select [
						"nbsp" " " "quot" {"}
					] a
					if result [
						append out to-char result
					]
				]		
			)
		] 
		end
	]
	
	
	print out

}