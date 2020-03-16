file-walk: func [
	{Deep read a directory given a dir d
	an output block o and a boolean function fn}
	d fn /local f
] [
	f: read d
	foreach f f [do :fn d/:f]
	foreach f f [if #"/" = last f [file-walk d/:f :fn]]
]


; Save
v: copy []  
file-walk %. func[f][ 
filename: join %.nit/files/ mold checksum/method f 'sha1
replace/all filename "#" ""
replace/all filename "{" ""
replace/all filename "}" ""
print filename

write filename read f
append v filename  append v f   
]   
write/lines %.nit/versions/20200317.txt v



; Restore
f: read/lines %.nit/versions/20200317.txt
forskip f 2 [ attempt [ write to-file f/2 read to-file f/1 ] ]
