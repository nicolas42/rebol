rebol []

index-files: func [
	{Deep read a directory}
	d "dir" o "output" /local f
] [attempt [

	f: sort load d ;files
	foreach f f [append o d/:f]
	foreach f f [if #"/" = last f [index-files d/:f o]]
	o
]]

filter: func [s query] [
	q: form query ;for literals
	if empty? q [return s]	
	s: copy s 
	foreach word parse q none [
		remove-each text s [not find to-string text word]
	]
	s
]

run: func [file] [
	if url? file [browse to-url file exit]
	that: rejoin [{""} to-local-file to-file file {""}]
	call either dir? to-file file [reform ["%systemroot%\explorer.exe" that]] [that]
]

attempt [ change-dir %/c/users/nick/downloads ]
attempt [ change-dir request-dir ]

index-files what-dir files: copy []

win: layout [	
	backcolor white
	
	fd: field white white	[call tl/data/1] edge none
	tl: text-list 			[call value focus fd] 	edge none
]

; Feel
fd/feel: make svv/vid-styles/field/feel []
fd/feel/engage: func [f a e][
    svv/vid-styles/field/feel/engage f a e
    tl/data: filter files fd/data
    show tl
] 

insert-event-func [
	if event/type = 'resize [
		tl/resize win/size - 20x20
		fd/size/x: win/size/x - 20
		show [tl fd]
	] 
	event
]

tl/sld/show?: false 
show tl

focus fd
view/options/title win [resize] "Finder"

