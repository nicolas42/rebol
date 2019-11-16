rebol [ ]

{;test of local variables

unset 'a

sth: funct [][

	sthelse: func []
		a: 2
		b: 3
	]
	sthelse
]

a

}



div: :divide
len: :length? 
take: :subtract
pow: :power


.: func [a][
	probe a
	prin ""
]

set 'stats funct [a][

	len: :length?
	sqrt: :square-root
	take: :subtract	
	div: :divide
	pow: :power

	;a: [26 16 47 16 46 70]
	a: sort a
	
	n: length? a
	sum: avg: var: dev: 0 sdev 
	;variance, deviation, sample deviation
	
	sum: 0
	foreach a a [
		sum: add sum a
	]
	
	avg: sum / n
	
	b: 0
	foreach a a [
		b: add b power take a avg 2
	]
	
	var: b / n
	svar: b / (n - 1)
	dev: sqrt (b / n)
	sdev: sqrt (b / (n - 1))
	
	
	;median and quartiles
	{[26 16 47 16 46 70 23 2] len 8
	           ^ 
	           ^  ^
	[26 16 47 16 46 70 23] len 7
	       ^
	           ^
	}
	           
	median: func [a][
		m1: to-integer div len a 2
		m2: 0
		if odd? len a [m1: m2: m1 + 1]
		if even? len a [m2: m1 + 1]
		a/:m1 + a/:m2 / 2
	]
	
	q2: med: median a 
	a1: m1 - 1
	a2: m2 + 1
	q1: median probe copy/part a a1
	q3: median probe at a a2
	
	quartiles: reduce [q1 q2 q3]
	
	
	
	print remold [
		'values a
		'length n
		'sum sum 
		'avg avg
		'var var
		'svar svar
		'dev dev
		'sdev sdev
		'med med
		'quartiles quartiles
	]

]

do demo-stats: does [
	a: [26 16 47 16 46 70]
	stats a
]


halt