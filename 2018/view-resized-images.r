rebol []

resize-image: func [ 
	{Reduces second size by an integer proportion until it is smaller than the first size
	Example: 
	>> resize-image 400x400 10000x8000
== 400x320} 
	max-size size 
	/local n new-size 
] [
	n: 2
	while [ outside? max-size new-size: size / n ] [
		n: n + 1
	]
	new-size
]



comment {
	; old version
	layout1: [ backcolor white across ] 
	foreach f files [ 
		image: load f 
		append layout1 compose [ 
			image (resize-image 400x400 image/size) load (f) effect [ blur aspect ] 
		] 
	]
	
	view layout layout1
}

files: request-file/keep

; load and resize images
images: copy []
foreach f files [ 
	image: load f 
	append images to-image layout/tight [ 
		image (resize-image 400x400 image/size) load (f) effect [ blur aspect ] 
	] 
]

layout1: copy [ 
	size (system/view/screen-face/size)
	origin 1 space 1 backcolor white across 
]
 
height: 0 width: 0
max-size: system/view/screen-face/size

foreach i images [ 
	width: width + i/size/x
	if width > max-size/x [
		width: i/size/x
		append layout1 [ 
			return
		]
	]
	if height > max-size/y [break]
	append layout1 compose [ 
		image (i)
	] 
]

win: layout layout1
win/changes: [maximize]
view/options win [resize]

