rebol []

do %msort.r

sort-files: func [a][
	msort a func [a b][all [#"/" = last a #"/" <> last b]]
	; yet again, msort is the most awesome thing evar. well, it's reasonably fast.
]

index-files: funct [
	{Deep read a directory}
	dir "dir" out "output"
] [attempt [

	append out dir
	files: sort-files read dir
	foreach f files [append out f]
	foreach f files [
		if #"/" = last f [index-files dir/:f out]
	]
	out
]]

demo: does [
	; OMG OMG awesome
	index-files %/d/ files: []
	write/lines %files.txt files
	call %files.txt
]


