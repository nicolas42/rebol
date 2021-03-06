rebol []

use [ walk-block test-walk-block ] [

video-suffix: [
	%.avi %.mpg %.mpeg %.divx %.mkv %.mov %.ogg %.rmvb %.rm
	%.rmv %.m4v %.ogm %.m2v %.wmv %.flv
]


image-suffix: [%.jpg %.jpeg %.png %.bmp %.gif]
music-suffix: [%.mp3 %.aac %.wma %.m4a]

keep-suffix: func [files suffixes] [
	remove-each f copy files [
		not find suffixes suffix? f 
	]
]

index-files: funct [
	{Deep read a directory}
	d "dir" o "output"
] [attempt [

	f: sort load d ;files
	foreach f f [append o d/:f]
	foreach f f [if #"/" = last f [index-files d/:f o]]
	o
]]

read-deep: funct [d "dir or block of dirs"] [
	d: append copy [] d ;blockize input
	o: copy [] ;output
	foreach d d [index-files d o]
	o
]


walk-block: func [
	{organises a miss-mash of words, directories, files, and search terms into a coherent set of three blocks of dirs, suffixes (from the non directory files) and search terms from the strings. It's recursive. }
	 block dirs suffixes search-terms
] [
	foreach item block [ 
		if word? item [
			item: get item
		]
		case [
			#"/" = last item [
				append dirs item
			]
			attempt [ suffix? item ] [
				append suffixes suffix? item
			]
			string? item [
				append search-terms item
			]
			block? item [
				walk-block item dirs suffixes search-terms
			]
		]
	]
	reduce [dirs suffixes search-terms]
]

test-walk-block: does [
 	dirs: copy [] suffixes: copy [] search-terms: copy []
	probe walk-block [
		%/c/users/user/ video-suffix [%.r [%/d/ %.something] %.jpg] %.exe [%/c/]] dirs suffixes search-terms
]

search: funct [ files query ] [
	files: copy files
	if empty? query [
		return files
	]
	query: parse query none
	foreach word query [
		remove-each f files [
			not find f word
		]
	]
]

get-files: funct [
	{Read deep type marries together directories and suffixes. It does a deep
	read of the directories and then removes all files that do not have one of the 
	suffixes provided.}
	arg [block! file! string!]
][
	if file? arg [
		if suffix? arg [
			return remove-each f read-deep what-dir [
				not-equal? suffix? f suffix? arg
			]
		]
		if #"/" = last arg [
			return read-deep arg
		]
	]
	if string? arg [
		return search read-deep what-dir arg
	]

	dirs: copy [] suffixes: copy [] search-terms: copy []
	walk-block arg dirs suffixes search-terms
	if empty? dirs [
		append dirs what-dir
	]
	files: read-deep dirs
	if not empty? suffixes [
		remove-each f files [not find suffixes suffix? f]
	]
	foreach s search-terms [
		files: search files s
	]
	files
]

test-get-files: does [

	get-files [%/c/users/user/ %.r "so"]
	get-files [video-suffix "some"]
	get-files "something"
	
	dirs: [
		%/c/users/user/desktop/
		%/c/users/user/downloads/
		%/c/users/user/documents/
		%/c/users/user/pictures/
	]
	
	change-dir %/c/users/user/
	get-files [%desktop/ %downloads/ %pictures/ %documents/ %.r]
	get-files dirs

]



]


