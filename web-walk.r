rebol []

get-links: func [ url /local links ] [
	links: copy []
	parse read url [any [
		thru {A HREF="} copy link to {"} 
		(append links link)
	] to end]
	links
]

web-walk: func [
	{Deep read a directory given a dir d
	an output block o and a boolean function fn}
	d fn /local f
] [ attempt [
	f: get-links d
	foreach f f [do :fn d/:f]
	foreach f f [if #"/" = last f [web-walk d/:f :fn]]
] ]

video-suffix: [
	%.avi %.mpg %.mpeg %.divx %.mkv %.mov %.ogg %.rmvb %.rm
	%.rmv %.m4v %.ogm %.m2v %.wmv %.flv %.mp4
]

demo-web-walk: [
    url: http://www.google.com
	web-walk url func [f] [ print f ]
]
