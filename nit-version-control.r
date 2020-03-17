rebol []

comment { 
	In the future perhaps now-descending should use the gmt time for a team who 
	might move around.
}

make-dir %.nit/files/
make-dir %.nit/versions/


file-walk: func [
	{Deep read a directory given a dir d
	an output block o and a boolean function fn}
	d fn /local f
] [
	f: read d
	foreach f f [do :fn d/:f]
	foreach f f [if #"/" = last f [file-walk d/:f :fn]]
]

now-descending: does [
	now-time: replace/all mold now/time ":" ""
	rejoin [ "" now/year now/month now/day "-" now-time ]
	
]

save: funct[] [

	v: copy [] 
	file-walk %. func[f][ 
	
		if find/match f "./.nit" [ return ]
		
		filename: join %./.nit/files/ mold checksum/method f 'sha1
		foreach c "#{}" [replace/all filename c "" ]
		
		write filename read f
		append v filename  append v f   
	]   
	write/lines rejoin [ %.nit/versions/ now-descending ".txt" ] v
	write/lines %.nit/versions/current.txt v


	forskip v 2 [ print rejoin [ v/2 " => " v/1 ] ]
]


restore: funct [/file version-file] [


comment {
	d: %.nit/versions/
	v: read d
	if n < 0 [ n: add n length? v ]
	f: read/lines join d v/:n
}	
	
	f: read/lines %.nit/versions/current.txt
	if file [
		f: read/lines version-file
	]

	foreach f read %. [ if not find/match f ".nit" [ either dir? f [ delete-dir f ] [ delete f ] ] ]
	
	forskip f 2 [ print rejoin [ f/1 " => " f/2 ] attempt [ write to-file f/2 read to-file f/1 ] ]
	
	
	
]



