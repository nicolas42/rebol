rebol[]

chessboard: has [sheet] [
	sheet:[
		style b box black 50x50 
		style w b white space 0x0
	]
	loop 8[
		append sheet head reverse/part [b w b w b w b w return] 8
	]
	view layout sheet
]

do chessboard