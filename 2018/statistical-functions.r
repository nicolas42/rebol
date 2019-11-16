rebol [
	title: "Statistical Functions"
	date: 17-June-2013
	author: "Nicolas Schmidt"
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