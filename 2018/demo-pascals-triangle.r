rebol [
	date: 16-6-2013
]

factorial: func [ n /local a ] [
	a: 1.0 
	repeat n n [ a: a * n ] 
	a
]

binomial-coefficient: func [
	{How many ways can n items be chosen from a group of k when the order is not significant.
	Example:
		5 people want to sit on 3 seats. How many different groups can sit on the seats
		If the order is significant then it is 5*4*3 or 5!-2! or 5!/(5-3)!
		if the order is not significant then we must divide by the number of permutations the sitters can have i.e. 3*2*1.
		So the expression becomes 5!/(5-3)!/3!	
		or if the number of people is n and the number of seats is k
		n!/(n-k)!/k!
	}
	n k
][
	(factorial n) / (factorial n - k) / (factorial k)
]

pascals-triangle: func [ n ] [
	o: copy [ ]
	for x 0 n 1 [
		append/only o copy [ ]
		for y 0 x 1 [
			append last o to-integer binomial-coefficient x y
		]
	]
	o
]


code: trim/auto {
	foreach line pascals-triangle 15 [ print line ] halt 
}

print code
do code

comment {

Zero Factorial - Numberphile
https://www.youtube.com/watch?v=Mfk_L4Nx2ZI

	factorial: funct [ n ] [ set 'a 1.0 repeat n n [ set 'a multiply a n ] a ]
	binomial-coefficient: func [ a b ] [ divide divide factorial a factorial b factorial a - b ]
	pascals-triangle: does [ for x 0 10 1 [ for y 0 x 1 [ print round binomial-coefficient x y prin { } ] print {} ] ]

}

