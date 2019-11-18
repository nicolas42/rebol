rebol []

index-files: func [
	{Deep read a directory}
	dir "dir" out "output"
	/local files
] [
	files: read dir
	foreach f files [append out dir/:f]
	foreach f files [
		if #"/" = last f [index-files dir/:f out]
	]
]

index-files %dolphin/ files: copy []
remove-each file files [ %.jpg <> suffix? file ]

train: take/part files to-integer 0.2 * length? files
test: files

print train
print test
