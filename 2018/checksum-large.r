rebol [
	date: 23-6-2013
]

checksum-large: funct [ file /verbose ] [

	; checksum large files in megabyte blocks
	sport: open [scheme: 'checksum]
	
	; change-dir %/c/users/nicolas/desktop/
	; file: %alphacentauri.iso
	port: open/binary/seek file 
	
	index: 1.0
	while [
		part: copy/part at port index 1000'000
		not empty? part
	] [
		insert sport part
		index: index + 1000'000
		if verbose [
			msg: ajoin [ to-integer index / 1000'000 " megabytes" ]
			prin msg
			loop length? msg [ prin backspace ]
		]
	]
	
	update sport
	sum: copy sport
	close sport
	sum
]
