rebol [
	title: "Build Tags"
	date: 27-5-2013
	author: "Nicolas Schmidt"
]


build-tags: func [arg o /local a b c d][
	forall arg [
		a: arg/1
		a: append copy [] a
		c: append copy [] to-refinement first a
		
		append o probe a: build-tag a
		append o newline

		if not-equal? #"/" last a [
			arg: next arg
			b: arg/1
			either block? b [
				append o build-tags b copy []
				append o newline
			] [
				append o b
				append o newline
			]
			append o build-tag c
			append o newline
		]
	]
	o
]

test-build-tags-mark2: does [
	a: [
		[html xmlns http://www.w3.org/1999/xhtml] [
			head [
				[meta http-equiv Content-Type content "text/html; charset=UTF-8" /]
				style {}
				[script language javascript type text/javascript] {something}
			]
			body [
				[a href http://www.google.com] {something else to do these types of things huh? Now there are the types of things to do now}
			]
		]
	]
	
	
	build-tags a o: []
	write clipboard:// to-string o
	
	halt
]




comment {
	;mark 1, can't handle single tags, i.e. tags that don't wrap text


build-tags: func [a o /local c d][
	foreach [a b] a [
		a: append copy [] a
		c: append copy [] to-refinement first a
		
		append o probe build-tag a
		append o newline

		either block? b [
			append o build-tags b copy []
			append o newline
		] [
			append o b
			append o newline
		]
		append o build-tag c
		append o newline

	]
	o
]

test-build-tags: does [

	
	a: [
		html [
			head [
				style {}
				[script language javascript type text/javascript] {something}
			]
			body [
				[a href http://www.google.com] {something else to do these types of things huh? Now there are the types of things to do now}
			]
		]
	]
	
	
	build-tags a o: []
	write clipboard:// to-string o
	
	{<html>
<head>
<style>

</style>
<script language="javascript" type="text/javascript">
something
</script>

</head>
<body>
<a href="http://www.google.com">
something else to do these types of things huh? Now there are the types of things to do now
</a>

</body>

</html>
}
]

}