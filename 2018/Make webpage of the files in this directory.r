rebol[]


files-to-links: func [files][
	out: copy []
	foreach f files [
		append out rejoin [
			{<a href="} f {">} 
			f 
			"</a><br />"
			newline
		]
	]
]

change-dir rebol/options/home

files: read what-dir
remove-each f files [not find [%.r] suffix? f]

html: ajoin compose [
<html>
<head></head>
<body>
	<h4>"Title"</h4>
	<p>"This is a little note"</p>
	(files-to-links files)
</body>

</html>
]

write %files-webpage.html html

