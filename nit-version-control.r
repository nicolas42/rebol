rebol []

comment { 
	In the future perhaps now-descending should use the gmt time for a team who 
	might move around.
		now-time: replace/all mold now/time - now/zone ":" ""


}

make-dir %.nit/files/
make-dir %.nit/versions/


file-walk: func [
	{Deep read a directory given a dir d
	an output block o and a boolean function fn}
	d fn /local f
] [
	f: read d
	foreach f f [ do :fn d/:f ]
	foreach f f [ if #"/" = last f [ file-walk d/:f :fn ] ]
]

zero-extend: funct [ a n ] [ a: mold a  head insert/dup a "0" n - length? a ]

now-descending: funct [ ] [
	now-time: replace/all mold now/time ":" ""
	rejoin [ "" zero-extend now/year 4 zero-extend now/month 2 zero-extend now/day 2 "-" now-time ]
]

commit: funct [ ] [

	v: copy [ ] 
	file-walk %. func [ f ] [ 
	
		if find/match f "./.nit" [ return ]
		
		filename: join %./.nit/files/ mold checksum/method f 'sha1
		foreach c "#{}" [ replace/all filename c "" ]
		write filename read f
		append v filename  append v f   
	]   
	write/lines rejoin [ %.nit/versions/ now-descending ] v
	write/lines %.nit/versions/current v

	forskip v 2 [ print rejoin [ v/2 " => " v/1 ] ]
]


revert: funct [ /file version-file /to dir ] [

	a: read/lines %.nit/versions/current
	if file [ a: read/lines version-file ]

	foreach f read %. [ if not find/match f ".nit" [ either dir? f [ delete-dir f ] [ delete f ] ] ]
	
	forskip a 2 [ print rejoin [ a/1 " => " a/2 ] attempt [ write to-file a/2 read to-file a/1 ] ]
]
