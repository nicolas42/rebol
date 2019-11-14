rebol []

video-suffix: [
	%.avi %.mpg %.mpeg %.divx %.mkv %.mov %.ogg %.rmvb %.rm
	%.rmv %.m4v %.ogm %.m2v %.wmv %.flv %.mp4
]
image-suffix: [%.jpg %.jpeg %.png %.bmp %.gif]
audio-suffix: [%.mp3 %.aac %.wma %.m4a]

file-walk: func [
	{Deep read a directory given a dir d
	an output block o and a boolean function fn}
	d fn /local f
] [
	f: read d
	foreach f f [do :fn d/:f]
	foreach f f [if #"/" = last f [file-walk d/:f :fn]]
]


search: func [
	 files query 
] [
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

list: func [ f ] [ foreach f f [ print f ] ]

index-files: func [
	{Deep read a directory}
	dir "dir" out "output"
	/local files
] [
	files: read dir
	foreach f files [append out f]
	foreach f files [
		if #"/" = last f [index-files dir/:f out]
	]
]

file-walk-demo: [
	files: []
	file-walk pwd func[f][ if dir? f [ print f append files f ] ]
]