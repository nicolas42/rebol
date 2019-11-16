rebol []

comment {

	#include <windows.h> 
	#define DLL_EXPORT __declspec(dllexport)  
	
	DLL_EXPORT int cellular_automaton(int *a, int la, int *r, int lr) {
		int i, j;
		for (i=0; i<(la-803); i=i+1) {
		for (j=0; j<lr; j=j+3) {
			if (a[i] == r[j] && a[i+1] == r[j+1] && a[i+2] == r[j+2]) {
				a[i+801] = 0x00ffffff;
			}
		}}
		return a;
	}

}

; attempt [ delete %cellular-automaton.dll ]
; call/console/wait "tcc -shared cellular-automaton.c"

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
