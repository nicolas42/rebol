rebol []

; C:\Program Files (x86)\rebol\view\rebol.exe -s
; C:\Users\Nicolas\Downloads\Rebol\rebol.exe

; attempt [ delete %cellular-automaton.dll ]
; call/show/wait "tcc -shared cellular-automaton.c"

do %library-utils.r

; the cellular-automaton function makes an 800x400 cellular automaton image in a binary 

library: load/library %cellular-automaton.dll
cellular-automaton: make routine! [
	a [integer!] 
	la [int] 
	r [integer!]
	lr [int]
	return: [integer!]
] library "cellular_automaton"

sz: 800x400

; make a binary 'a' 800*400 in length. 'la' is short for length of a
la: sz/x * sz/y
a: head insert/dup #{} #{0000 0000} la

; put a dot in the middle of the first row
change/part (skip a sz/x / 2 * 4) #{ffff ff00} 4

; make rule


r: #{
	ffffff00 00000000 00000000 
	00000000 ffffff00 ffffff00 
	00000000 ffffff00 00000000 
	00000000 00000000 ffffff00
}
lr: 12

; pass the pointer to this binary to the c-function 
a: cellular-automaton string-address? a la string-address? r lr

a: get-memory a la * 4  

; the length of a is la for the c-function since it counts in I ASSUME 32 bit integers
; the length of the data for the get-memory function is la*4 because get memory counts in bytes

a: to-image a
a/size: sz
view layout [ backcolor black image a ]

; matching braces in peripheral vision is easier to do when they're surrounded by white space I find.
