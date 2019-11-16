rebol [
	title: "Reddit Tabindex Testing, HTML"
	date: 16-5-2013
	usage: {
		save the complete html webpage at http://www.reddit.com/r/funny/comments/1eejhm/here_in_alberta_the_girls_get_rifles_as_grad_gifts/
to a directory. then on the top line enter that directory after change-dir}

]

;change-dir %/c/users/user/desktop/
;files: request-file
;write clipboard:// mold files
;page: read files/1

files: [%/C/Users/User/Desktop/Here%20in%20Alberta,%20the%20girls%20get%20rifles%20as%20grad%20gifts.%20%20%20funny.htm]


page: read http://www.reddit.com/r/funny/comments/1eejhm/here_in_alberta_the_girls_get_rifles_as_grad_gifts/



comment {
	;Remove Existing Tabindexes
	pos: page
	while [
		 all [
			pos: find pos {tabindex="}
			pos2: find/tail pos {tabindex="}
			pos2: find/tail pos2 {"}
			all [
				found? pos
				found? pos2
			]
		]
	] [
		remove/part pos pos2
	]
}

pos: page
while [
	pos: find/tail pos {<a}
	found? pos

] [
	insert pos { tabindex="-1" }
]

;Insert New Tabindexes before [+]
n: 0
pos: page
while [
	pos: find pos ">[+]"
	found? pos
] [
	insert pos ajoin [
		{tabindex="} n {"}
	]
	;n: n + 1
	pos: find/tail pos ">[+]"
]

write files/1 page
wait 1
browse files/1

