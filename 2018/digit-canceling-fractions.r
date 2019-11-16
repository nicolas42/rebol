rebol [
	date: 29-6-2013
]

comment {
	49 / 98 = 4 / 8
	49 / 98 equals 4 / 8. It could be mistakenly thought that this is because the nines cancel. How many fractions are there were this is the case; that if the same numbers are removed from the top and bottom of the fraction then it equals the right result.
Note that multiples of ten are not counted. they are considered trivial.

There are four non-trivial examples, less than one in value, and containing two digits in the numerator and denominator.


}


numerators: copy []
denominators: copy []
for num 10 99 1 [ 
	for den 10 99 1 [	
		foreach char mold num [
			
			if all [
				find mold den char
				
				num2: to-decimal replace mold num char ""
				den2: to-decimal replace mold den char ""

				num // 10 <> 0
				den // 10 <> 0
								
				num2 <> 0
				den2 <> 0
				
				num <= den
				
				num <> den
				num2 <> den2
				
				equal? num2 / den2  divide to-decimal num to-decimal den

	
			] [
				print [ num den tab to-integer num2 to-integer den2 ]
				append numerators num2
				append denominators den2
			]
		]
	]
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


n: product numerators
d: product denominators

nf: factorize n
df: factorize d
nf1: copy nf
df1: copy df

foreach n nf [
	probe n
	replace df1 n []
	replace nf1 n []
]
foreach d df [
	probe d
	replace df1 n []
	replace nf1 n []
]

; make to-lowest-terms function
; (to-lowest-terms num den)









