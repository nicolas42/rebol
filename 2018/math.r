rebol [
	title: "Math"
	date: 1-July-2013
	author: "Nicolas Schmidt"
]

sqrt: :square-root

solve-quadratic: func [
	{Solve a quadratic equation of the form ax^2 + bx + c = 0}
	a b c 
	/local d
] [ 
	d: square-root b * b - (4 * a * c) 
	return compose [
		(- b - d / 2 / a)
		(- b + d / 2 / a)
	] 
]

gcd: funct [
	{Greatest Common Divisor
	Euclidian Algorithm}
	a b
][
	forever [
		c: remainder a b
		print [a b c]
		if c = 0 [return b]
		a: b
		b: c
	]
]

lcm: funct [
	{Lowest Common Multiple}
	a b
][
	a: factorize a 
	b: factorize b
	
	product collect [
		foreach f union a b [
			n: max how-many a f how-many b f
			loop n [ keep f ]
		]
	]
]

common-factors: func [a b /local n] [
	a: factorize a
	b: factorize b
	
	collect [
		foreach f union a b [
			n: min how-many a f how-many b f
			loop n [ keep f ]
		]
	]
]

lowest-terms: funct [arg][
	a: arg/1
	b: arg/2
	c: common-factors a b
	foreach c c [
		a: a / c
		b: b / c
	]
	reduce [a b]
]

how-many: func [
	{How many b's are in a}
	a b
	/local n
] [
	n: 0
	while [
		a: find/tail a b
	] [
		n: n + 1
	]
	n
]


product: func [
	{Find the product of a series of numers
	Note that the product of an empty block is 1}
	a [block!]
	/local t
][
	t: 1
	foreach a a [ 
		t: t * a
	]
	t
]

factorize: func [
	arg
	/local factor factors
][
	
	factor: 2
	; arg: 98
	factors: copy []
	
	while [ arg <> 1 ] [
		either arg // factor = 0 [
			arg: arg / factor
			append factors factor
		] [
			factor: factor + 1
		]
	]
	factors
]

sum: funct [a] [
	t: 0 foreach a a [t: t + a]
]
average: func [a] [
	divide sum a length? a
]
variance: funct [a][
	avg: average a
	
	t: 0
	foreach a a [
		t: t + power (a - avg) 2
	]
	t / length? a
]
sample-variance: funct [a][
	avg: average a
	
	t: 0
	foreach a a [
		t: t + power (a - avg) 2
	]
	t / subtract length? a 1
]
standard-deviation: func [a][
	square-root variance a
]
sample-standard-deviation: func [a][
	square-root sample-variance a
]
median: funct [a][
	a: sort copy a
	i: (1 + length? a) / 2 ; index of the middle value
	if decimal? i [
		i1: round/floor i
		i2: round/ceiling i
		return a/(i1) + a/(i2) / 2
	]
	a/(i)
]