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
	origin 0 space 0x0 backcolor snow
	style field field snow snow 500 with [flags: [return] edge/effect: 'bezel edge/size: 1x1]
	style text-list text-list no-wrap 500x270 
	
	fd: field 		[run tl/data/1] 
	tl: text-list 	[run value focus fd] 	
	key keycode [F5]  [ index-files what-dir files: copy [] ]
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
		tl/resize tl/parent-face/size + 24x0
		fd/size/x: fd/parent-face/size/x show [tl fd]
	] 
	event
]

tl/sld/show?: false 
tl/sub-area/size/x: 524 
tl/sub-area/edge/size: 1x1 
tl/sub-area/edge/effect: 'bezel 
show tl

focus fd
view/options/title win [resize] "Finder"

