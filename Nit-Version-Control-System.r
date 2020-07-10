rebol [
	title: {Nit version control system}
]

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
	rejoin [ "" zero-extend now/year 4 zero-extend now/month 2 
		zero-extend now/day 2 "-" now-time ]
]

commit: funct [ ] [

	make-dir %.nit/
	make-dir %.nit/files/


	state: copy [ ] 
	file-walk %. func [ filename ] [ 

		if find/match filename "./.nit" [ return ]
		
		sha1-filename: join %./.nit/files/ mold checksum/method filename 'sha1
		foreach char "#{}" [ replace/all sha1-filename char "" ]

		if not exists? sha1-filename [ write sha1-filename read filename ]

		append state sha1-filename  
		append state filename

		print rejoin [ filename " => " sha1-filename ]
	]   
	write/lines rejoin [ %.nit/ now-descending ] state

]

revert: funct [ file ] [
	filenames: read/lines to-file file
	forskip filenames 2 [ 
		attempt [ write to-file filenames/2 read to-file filenames/1 ] 

		print rejoin [ filenames/1 " => " filenames/2 ] 
	]
]

print {
Nit version control system.  
Usage: 
	commit
	
	revert <state file>

	state files are stored in the .nit directory

	Usage example:

	# run rebol interpreter

	pwd

	commit

	ls %.nit

	revert %.nit/20200423-100123


}
halt
