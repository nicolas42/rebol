REBOL[
    Title: "Merge Sort"
    File: %msort.r
    Author: "Ladislav Mecir"
    Date: 26-Sep-2011/13:19:37+2:00
    Purpose: {Merge sort a series}
]

msort: func [
	{Merge-sort a series in place.}
	a [series!]
	compare [any-function!]
	/local msort-do merge
][
    ; define a recursive Msort-do function
    msort-do: function [a l][mid b][
    	either l <= 2 [
    		unless any [
				l < 2
				compare first a second a
			][
				set/any 'b first a
				change/only a second a
				change/only next a get/any 'b
			]
		][
	    	mid: to integer! l / 2
	    	msort-do a mid
	    	msort-do skip a mid l - mid
	    	merge a mid skip a mid l - mid
	    ]
    ]
    ; the Merge function is the key part of the algorithm
    merge: func [
		{Uses auxiliary storage, at most half the size of the sorted series.}
		a la b lb /local c
	][
    	c: copy/part a la
        until [
            either (compare first b first c)[
                change/only a first b
                b: next b
                a: next a
                zero? lb: lb - 1
            ][
                change/only a first c
                c: next c
                a: next a
                empty? c
            ]
        ]
    	change a c
    ]
    msort-do a length? a
    a
]