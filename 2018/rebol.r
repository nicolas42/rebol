rebol [
	title: "standard library"
]

do %math.r

handle: func [
	{ Shorthand insert-event-func [ switch event/type [] event ] 
	handle [ resize [ print "YAWP!" ] ] }
	arg
][
	insert-event-func compose/deep/only [
		switch event/type (arg)
		event
	]
]

unhandle: :remove-event-func

get-os: does [
    switch system/version/4 [
        3 [os: "Windows" countos: "n"]
        2 [os: "MacOSX" countos: "c"]
        4 [os: "Linux" countos: "c"]
        5 [os: "BeOS" countos: "c"]
        7 [os: "NetBSD" countos: "c"]
        9 [os: "OpenBSD" countos: "c"]
        10 [os: "SunSolaris" countos: "c"]
    ]
]

;making rebol pretty
;The colors of windows programs
windows-edge: to-tuple #{a7a6aa}
windows-color: to-tuple #{ebe9ed}
itunes-color: to-tuple #{f2f5f9}

stylize/master [

	progress: progress white edge [
		size: 1x1 
		effect: none
		color: windows-edge
	]

	link: text blue 
		font [name: "verdana" colors: reduce [blue red]]
		para [origin: 0x1 margin: 0x1]

	timer: sensor 0x0 rate 1 feel [
		engage: func [f a e] [if a = 'time [f/action f e]]
	]

	area: area wrap white white
		edge [color: windows-edge size: 1x1 effect: none]
		para [tabs: 10]  
		effect [aspect]
		
	field: field white white
		edge [color: windows-edge size: 1x1 effect: none]
		effect [aspect]

	button: button plain windows-color 
		edge none
		font [color: black shadow: none colors: reduce [black silver]]
		effect [] ;takes away 'over' effect i.e. font color change on mouse over
		
	gif: image with [
		frames: copy [] 
		rate: 15
		feel: make feel [
			engage: func [face action event] [
				if action = 'time [
					face/image: first face/frames 
					if tail? face/frames: next face/frames [
						face/frames: head face/frames
					] 
					show face
				]
			]
		] 
		words: [
			frames [append new/frames second args next args] 
			;rate func [new args][new/rate: second args next args]
			;data func [new args][new/data: second args next args]
		] 
		init: append copy init [
			;forall frames [change frames load-image first frames] 
			frames: head frames 
			image: first frames
			size: image/size
		]
	]
]


rotate: func [s] [
	if tail? s: next s [s: head s] s
]
rotate-back: func [s] [
	if head? s [s: tail s] s: back s
]

append-dir: func [dir [file!] data /local file] [
	
	if #"/" <> last dir [
		dir: dirize dir
	]
	if not exists? dir [
		make-dir dir
	]
	
	file: 1
	while [
		exists? join dir file
	] [
		file: file + 1
	]

	write join dir file data
]

mold-no-braces: func [
	{mold a block and remove first and last braces.}
	a [block!]
] [
	a: mold a
	take a
	take back tail a
	trim/auto a
]


video-suffix: [
	%.avi %.mpg %.mpeg %.divx %.mkv %.ogg %.rmvb %.rm
	%.rmv %.m4v %.ogm %.m2v %.wmv %.flv
]


image-suffix: [%.jpg %.jpeg %.png %.bmp %.gif]
music-suffix: [%.mp3 %.aac %.wma %.m4a]

index-files: funct [
	{Deep read a directory}
	dir out
] [ 
	attempt [
	
		files: sort load dir
		foreach f files [
			append out dir/:f
		]
		foreach f files [
			if #"/" = last f [
				index-files dir/:f out
			]
		]
		out
	] 
]

read-deep: func [
	{Index a block of directories}
	dirs 
	/local files
] [
	files: copy []
	foreach dir append copy [] dirs [
		index-files dir files
	]
	files
]

keep-suffix: func [
	{Remove all files that do not have one of the specified suffixes. Don't modify original files block.}
	files [block!] suffixes [block!]
] [
	remove-each f copy files [
		not find suffixes suffix? f 
	]
]

search: funct [
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

