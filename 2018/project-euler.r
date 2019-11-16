rebol[]

;burncdcc.exe cd burning software recommended by puppy linux

;Project Euler
;http://projecteuler.net/problems
nic42

;	Add all the natural numbers below one thousand that are multiples of 3 or 5.

a: copy []
repeat n 999 [
	if n // 3 = 0 [append a n]
	if n // 5 = 0 [append a n]
]
a: unique a
t: 0
foreach a a [
	t: t + a
]



{By considering the terms in the Fibonacci sequence whose values do not exceed 
four million, find the sum of the even-valued terms.}

f: [1.0 0.0]
while [f/1 < 4e6] [
	insert f f/1 + f/2
]
remove-each f f [not even? f]
sum f


;	Find the largest prime factor of a composite number.
;What is the largest prime factor of the number 600851475143 ?

maximum-of factorize 600851475143

;Find the largest palindrome made from the product of two 3-digit numbers.

12321

11 * 11
121

90 * 91 
9009

o: copy []
for x 999 100 -1 [for y 999 100 -1 [
	s: form n: x * y
	if s = reverse copy s [append o n]
]]

clip mold first maximum-of o


;What is the smallest positive number that is evenly divisible by all of the numbers 
;from 1 to 20?

a: [] b: [] c: [] d: []

repeat n 20 [append/only a factorize n]
foreach a a [append b a] ;flatten
b: unique b
foreach b b [
	n: 1 
	foreach a a [n: max n how-many a b] ;how many b are in a
	append c n
]
foreach [a b] zip b c [insert/dup d a b]
clip mold to-integer product d

{Find the difference between the sum of the squares of the first 
one hundred natural numbers and the square of the sum.}

a: 0
repeat n 100 [a: n * n + a]
b: 0 repeat n 100 [b: b + n]
b: b * b
print [a b]


;a is sum of squares
;b is square of sum

clip mold to-integer b - a





{By listing the first six prime numbers: 2, 3, 5, 7, 11, and 13, we can see that the 6th prime is 13.

What is the 10 001st prime number?
}


p: copy []
n: 2
until [
	if prime? n [append p n]
	n: n + 1
	10'001 = length? p
]

clip mold to-integer last p


{Find the greatest product of five consecutive digits in the 1000-digit number.}

s: trim/all {73167176531330624919225119674426574742355349194934
96983520312774506326239578318016984801869478851843
85861560789112949495459501737958331952853208805511
12540698747158523863050715693290963295227443043557
66896648950445244523161731856403098711121722383113
62229893423380308135336276614282806444486645238749
30358907296290491560440772390713810515859307960866
70172427121883998797908792274921901699720888093776
65727333001053367881220235421809751254540594752243
52584907711670556013604839586446706324415722155397
53697817977846174064955149290862569321978468622482
83972241375657056057490261407972968652414535100474
82166370484403199890008895243450658541227588666881
16427171479924442928230863465674813919123162824586
17866458359124566529476545682848912883142607690042
24219022671055626321111109370544217506941658960408
07198403850962455444362981230987879927244284909188
84580156166097919133875499200524063689912560717606
05886116467109405077541002256983155200055935729725
71636269561882670428252483600823257530420752963450}

o: copy []
forall s [
	t: func [a][load form a]
	append o product reduce [t s/1 t s/2 t s/3 t s/4 t s/5]
]

clip*: func [a][clip probe mold to-integer a]

clip* m


{

A Pythagorean triplet is a set of three natural numbers, a < b < c, for which,
a2 + b2 = c2

For example, 32 + 42 = 9 + 16 = 25 = 52.

There exists exactly one Pythagorean triplet for which a + b + c = 1000.
Find the product abc.
}

;a2 + b2 = c2
;a + b + c = 1000

;c = sqrt a ** 2 + (b ** 2)

;a + b + (sqrt a ** 2 + (b ** 2)) = 1000


for a 1 1000 1 [for b 1 1000 1 [
	c: (sqrt a ** 2 + (b ** 2))
	if equal? 1000 a + b + c [print [a b c]]
]]


;Find the sum of all the primes below two million.


t: 0.
for n 2 1'999'999 1 [
	i
	if prime? n [t: t + n]
	if n // 100'000 = 0 [prin "."]
]
clip* s








;In the 20×20 grid below, four numbers along a diagonal line have been marked in red.

{The product of these numbers is 26 × 63 × 78 × 14 = 1788696.

What is the greatest product of four adjacent numbers in any direction (up, down, left, right, or diagonally) in the 20×20 grid?
}

g: [
08 02 22 97 38 15 00 40 00 75 04 05 07 78 52 12 50 77 91 08
49 49 99 40 17 81 18 57 60 87 17 40 98 43 69 48 04 56 62 00
81 49 31 73 55 79 14 29 93 71 40 67 53 88 30 03 49 13 36 65
52 70 95 23 04 60 11 42 69 24 68 56 01 32 56 71 37 02 36 91
22 31 16 71 51 67 63 89 41 92 36 54 22 40 40 28 66 33 13 80
24 47 32 60 99 03 45 02 44 75 33 53 78 36 84 20 35 17 12 50
32 98 81 28 64 23 67 10 26 38 40 67 59 54 70 66 18 38 64 70
67 26 20 68 02 62 12 20 95 63 94 39 63 08 40 91 66 49 94 21
24 55 58 05 66 73 99 26 97 17 78 78 96 83 14 88 34 89 63 72
21 36 23 09 75 00 76 44 20 45 35 14 00 61 33 97 34 31 33 95
78 17 53 28 22 75 31 67 15 94 03 80 04 62 16 14 09 53 56 92
16 39 05 42 96 35 31 47 55 58 88 24 00 17 54 24 36 29 85 57
86 56 00 48 35 71 89 07 05 44 44 37 44 60 21 58 51 54 17 58
19 80 81 68 05 94 47 69 28 73 92 13 86 52 17 77 04 89 55 40
04 52 08 83 97 35 99 16 07 97 57 32 16 26 26 79 33 27 98 66
88 36 68 87 57 62 20 72 03 46 33 67 46 55 12 32 63 93 53 69
04 42 16 73 38 25 39 11 24 94 72 18 08 46 29 32 40 62 76 36
20 69 36 41 72 30 23 88 34 62 99 69 82 67 59 85 74 04 36 16
20 73 35 29 78 31 90 01 74 31 49 71 48 86 81 16 23 57 05 54
01 70 54 71 83 51 54 69 16 92 33 48 61 43 52 01 89 19 67 48]

;20x20 grid g

;left right
m: 0 ;max
forall g [attempt [m: max m g/1 * g/2 * g/3 * g/4]]
g: head g
. m 

;up down
forall g [attempt [
	a: g
	b: skip g 20
	c: skip b 20
	d: skip c 20
	
	a: a/1 b: b/1 c: c/1 d: d/1

	m: max m a * b * c * d
]]
g: head g


;diagonals :(

forskip g 20 [for n 1 17 1 [attempt [
	
	a: at g n
	b: skip a 21
	c: skip b 21
	d: skip c 21
	print [a: a/1 b: b/1 c: c/1 d: d/1]
	
	m: max m a * b * c * d
]]]
g: head g


forskip g 20 [for n 4 20 1 [attempt [
	
	a: at g n
	b: skip a 19
	c: skip b 19
	d: skip c 19
	print [a: a/1 b: b/1 c: c/1 d: d/1]
	
	m: max m a * b * c * d
]]]
g: head g


m


;Euler Question: Find the sum of the digits in the number 100!

;Project Euler definitions of insert-till and append-till

insert-till: funct [a b ml "max length"] [
	head insert/dup a b ml - length? a
]

append-till: funct [a b ml "max length"] [
	head insert/dup tail a b ml - length? a
]

number-to-block: funct [n][
	o: copy []
	foreach digit form n [
		append o do to-string digit
	]
]

;fix bignumber, now known as carry
fix: funct [b] [

	;split
	o: copy [] foreach n b [append/only o number-to-block n]
	forall o [insert/dup tail o/1 [0] subtract length? o 1]
	
	m: 0 foreach o o [m: max m length? o]
	forall o [insert-till o/1 [0] m]

	;printall o
	
	;add
	p: head insert/dup copy [] [0] m
	foreach o o [
		repeat n m [
			poke p n add pick p n pick o n
		]
	]
	p
]

;fix [987 789 78 9]
;fix [999999999 999999999 999999999 999999999 999999999 999999999 999999999 ]


t: [1 0 0]
for n 99 1 -1 [
	forall t [
		change t t/1 * n
	]
	t: fix t
]

sum t
;ans 648

{The following iterative sequence is defined for the set of positive integers:

n ? n/2 (n is even)
n ? 3n + 1 (n is odd)}

lc: 0 ;longest chain

for a 1 999'999 1 [

	cl: 0 ;chain length
	n: to-decimal a
	
	until [
		n: either n // 2 = 0 [n / 2] [3 * n + 1] 
		cl: cl + 1
		n = 1
	]
	
	if cl > lc [lc: cl print [a cl]]
]

;answer 837799
;took longer than 1 minute
;try with caching in a hash table


{#include <stdio.h>
#include <math.h>

/* 
cd c:\tcc
tcc -run test.c
*/
main()
{
	
	float la = 0.0;
 	float lc = 0.0;
	
	float a;
	for (a = 1.0; a < 1000000.0; a = a + 1.0) {
		float cl = 0.0;
		float n = a;
		while (n != 1.0) {
			if (fmod (n, 2.0) == 0.0) {
				n = n / 2.0; 
			}
			else {
				n = 3.0 * n + 1.0;
			}
			cl = cl + 1.0;
		}
		//printf("%f\t%f\n", a, cl);
		if (cl > lc) {
			la = a;
			lc = cl; 
			printf("%f\t%f\n", a, cl);
		}
	}
	printf("\n\n%f\t%f\n", la, lc);
	//getchar();
}
}

;result of above code
;992283 501
;992283th term creates a chain 501 long

;rebol answer was 837799

;rebol was right, c was wrong

{rebol and c answers deviate after term 100'000}


{project euler problem 13 
Work out the first ten digits of the sum of the following one-hundred 50-digit numbers.
}

;arg
a: trim/all {37107287533902102798797998220837590246510135740250
46376937677490009712648124896970078050417018260538
74324986199524741059474233309513058123726617309629
91942213363574161572522430563301811072406154908250
23067588207539346171171980310421047513778063246676
89261670696623633820136378418383684178734361726757
28112879812849979408065481931592621691275889832738
44274228917432520321923589422876796487670272189318
47451445736001306439091167216856844588711603153276
70386486105843025439939619828917593665686757934951
62176457141856560629502157223196586755079324193331
64906352462741904929101432445813822663347944758178
92575867718337217661963751590579239728245598838407
58203565325359399008402633568948830189458628227828
80181199384826282014278194139940567587151170094390
35398664372827112653829987240784473053190104293586
86515506006295864861532075273371959191420517255829
71693888707715466499115593487603532921714970056938
54370070576826684624621495650076471787294438377604
53282654108756828443191190634694037855217779295145
36123272525000296071075082563815656710885258350721
45876576172410976447339110607218265236877223636045
17423706905851860660448207621209813287860733969412
81142660418086830619328460811191061556940512689692
51934325451728388641918047049293215058642563049483
62467221648435076201727918039944693004732956340691
15732444386908125794514089057706229429197107928209
55037687525678773091862540744969844508330393682126
18336384825330154686196124348767681297534375946515
80386287592878490201521685554828717201219257766954
78182833757993103614740356856449095527097864797581
16726320100436897842553539920931837441497806860984
48403098129077791799088218795327364475675590848030
87086987551392711854517078544161852424320693150332
59959406895756536782107074926966537676326235447210
69793950679652694742597709739166693763042633987085
41052684708299085211399427365734116182760315001271
65378607361501080857009149939512557028198746004375
35829035317434717326932123578154982629742552737307
94953759765105305946966067683156574377167401875275
88902802571733229619176668713819931811048770190271
25267680276078003013678680992525463401061632866526
36270218540497705585629946580636237993140746255962
24074486908231174977792365466257246923322810917141
91430288197103288597806669760892938638285025333403
34413065578016127815921815005561868836468420090470
23053081172816430487623791969842487255036638784583
11487696932154902810424020138335124462181441773470
63783299490636259666498587618221225225512486764533
67720186971698544312419572409913959008952310058822
95548255300263520781532296796249481641953868218774
76085327132285723110424803456124867697064507995236
37774242535411291684276865538926205024910326572967
23701913275725675285653248258265463092207058596522
29798860272258331913126375147341994889534765745501
18495701454879288984856827726077713721403798879715
38298203783031473527721580348144513491373226651381
34829543829199918180278916522431027392251122869539
40957953066405232632538044100059654939159879593635
29746152185502371307642255121183693803580388584903
41698116222072977186158236678424689157993532961922
62467957194401269043877107275048102390895523597457
23189706772547915061505504953922979530901129967519
86188088225875314529584099251203829009407770775672
11306739708304724483816533873502340845647058077308
82959174767140363198008187129011875491310547126581
97623331044818386269515456334926366572897563400500
42846280183517070527831839425882145521227251250327
55121603546981200581762165212827652751691296897789
32238195734329339946437501907836945765883352399886
75506164965184775180738168837861091527357929701337
62177842752192623401942399639168044983993173312731
32924185707147349566916674687634660915035914677504
99518671430235219628894890102423325116913619626622
73267460800591547471830798392868535206946944540724
76841822524674417161514036427982273348055556214818
97142617910342598647204516893989422179826088076852
87783646182799346313767754307809363333018982642090
10848802521674670883215120185883543223812876952786
71329612474782464538636993009049310363619763878039
62184073572399794223406235393808339651327408011116
66627891981488087797941876876144230030984490851411
60661826293682836764744779239180335110989069790714
85786944089552990653640447425576083659976645795096
66024396409905389607120198219976047599490197230297
64913982680032973156037120041377903785566085089252
16730939319872750275468906903707539413042652315011
94809377245048795150954100921645863754710598436791
78639167021187492431995700641917969777599028300699
15368713711936614952811305876380278410754449733078
40789923115535562561142322423255033685442488917353
44889911501440648020369068063960672322193204149535
41503128880339536053299340368006977710650566631954
81234880673210146739058568557934581403627822703280
82616570773948327592232845941706525094512325230608
22918802058777319719839450180888072429661980811197
77158542502016545090413245809786882778948721859617
72107838435069186155435662884062257473692284509516
20849603980134001723930671666823555245252804609722
53503534226472524250874054075591789781264330331690}

o: copy []
forskip a 50 [
	append o trim copy/part a 50
]

;make bignums
bn: copy []
foreach o o [
	append/only bn string-to-bignum o
]

;Work out the first ten digits of the sum of the following one-hundred 50-digit numbers.

b: bn

t: copy [] ;total
loop 50 [insert t 0]

foreach b b [
	repeat n 50 [
		poke t n add pick t n pick b n
	]
]

5537376230


a: {onetwothreefourfivesixseveneightnine}
b: {teneleventwelvethirteenfourteenfifteensixteenseventeeneighteennineteen}
c: {twentythirtyfourtyfiftysixtyseventyeightyninety}


;the length of the numbers one to twenty
90 * a ;90 by 9
10 * b ;teens 10 * 10

90 * c ;

900 * length? {hundred}
792 * length? {and}
100 * length? a

length? {onethousand}




;faster way, generate prime factors then generate factors by multiplying them together 
;in all possible permutations
;complex code

f 630
2 3 5 7

for i 1 tn: 630 1 [if tn // i = 0 [print i]]

[1 2 3 5 6 7 9 10 14 15 18 21 30 35 42 45 63 70 90 105 126 210 315 630]




f: func [n][at f n] ;e.g. f 3 is factor number 3 

n: length? fl

2 3 5 7
2 3 5

;permutations combinations

f: [2 3 5 7] ;factors

i: [1 2 3 4]

{project euler 
What is the first term in the Fibonacci sequence to contain 1000 digits?
}

a: [1] b: [1] c: []
n: 2
dt [forever [
	c: add-bignum a b
	a: b  b: c
	n: n + 1
	if 1000 <= length? c [alert mold n halt]
]]

4782


;18 project euler

a: {
75
95 64
17 47 82
18 35 87 10
20 04 82 47 65
19 01 23 75 03 34
88 02 77 73 07 63 67
99 65 04 28 06 16 70 92
41 41 26 56 83 40 80 70 33
41 48 72 33 47 32 37 16 94 29
53 71 44 65 25 43 91 52 97 51 14
70 11 33 28 77 73 17 78 39 68 17 57
91 71 52 38 17 14 91 43 58 50 27 29 48
63 66 04 68 89 53 67 30 73 16 69 87 40 31
04 62 98 27 23 09 70 98 73 93 38 53 60 04 23
}

;4 + max 0 63
;62 + max 63

a: parse/all a "^/" b: []
foreach a a [
	unless empty? a [
		append/only b load/all a
	]
]

l: length? last b
foreach b b [
	insert/dup b 0 l - len b
]

reverse b

a: b/1
forall a [
	change a add a/1 either b/2 [max b/1 b/2] [b/1]
]




;18 project euler

a: {
75
95 64
17 47 82
18 35 87 10
20 04 82 47 65
19 01 23 75 03 34
88 02 77 73 07 63 67
99 65 04 28 06 16 70 92
41 41 26 56 83 40 80 70 33
41 48 72 33 47 32 37 16 94 29
53 71 44 65 25 43 91 52 97 51 14
70 11 33 28 77 73 17 78 39 68 17 57
91 71 52 38 17 14 91 43 58 50 27 29 48
63 66 04 68 89 53 67 30 73 16 69 87 40 31
04 62 98 27 23 09 70 98 73 93 38 53 60 04 23
}

a: parse/all a "^/" 
b: copy []

foreach a a [
	unless empty? a [
		append/os fnly b load/all a
	]
]

reverse b


forall b [
	fl: b/1
	sl: b/2
	if none? sl [break]
	forall sl [
		i: index? sl
		change sl sl/1 + max fl/(i) fl/(i + 1)
	]
	foreach b head b [print b]
	input
]

1074 yay!


Find the last ten digits of the series, 1^1 + 2^2 + 3^3 + ... + 1000^1000

a: [5 0]
b: [5 0]
;a: a * b


t: [0]
repeat n 1000 [
	
]




;problem 12
;find the first triangular number with more than 500 divisors

factorize: funct [n][
	m: 2 i: 1
	o: copy[]
	until [
		either n // m = 0 [n: n / m append o m][m: m + i i: 2]
		if 1. * m * m > n [append o n n: 1] 
		n = 1
	]
	o
]

;Euler 
;What is the value of the first triangle number to have over five hundred divisors?


;>> factorize 78984626
;== [2 7 83 101 673]

a: [673 101 83 7 2] 
la: length? a

n: 78984626
nd: 2 ;for one and itself
a: factorize n ;[2 7 83 101 673]
foreach a a [
	nd: n / a - 1 + nd ;subtract 1 to prevent adding itself multiple times
]

ni: 0 ;number of intersects
la: length? a
repeat n la [
	ni: ni + binomial-coefficient la n 
]

nd - ni



pickall: funct [s i] [
	o: copy []
	foreach i i [append o pick s i]
]

increment: func [b lim] [
	change b b/1 + 1
	forall b [
		if b/1 > lim [
			b/1: 1
			either b/2 [b/2: b/2 + 1][append b 1]
		]
	] 
	b
]


c: :binomial-coefficient
t: 0 repeat n lim: 9 [t: t + (c lim n)]
;== 511

;the first number with 9 unique prime factors has over 500 divisors

n: 0
tn: 0
dt [until [
	n: n + 1
	print reduce [tn: tn + n tab
	 uf: unique factorize tn ]
	if 9 <= length? uf [halt]
]]

;but what is the relationship between unique and non-unique prime factors?

1722580860 :(

>> factorize 28
== [2 2 7]
1 28
2 7 4 14

f: [2 2 7]
o: copy f
la: length? a
repeat a la [repeat b la [repeat c la [
	if a <> b [print [a b] append o f/:a * f/:b]
]]



;factorize 1189622253   3 29 71 229


{a: [3 29 71 229]
o: copy f
la: length? a
repeat b la [repeat c la [repeat d la [
	if none-equal? [b c d] [print [b c d] append o f/:b * f/:c]
]]]}

;[w1 w2 w3]

none-equal?: func [b] [
	b: reduce b
	forall b [
		if find find/tail head b b/1 b/1 [return false]
	]
	true
]


make-word: func [n] [to-word join 'w n]
w: copy []
repeat n 100 [append w make-word n]



l: 9
w: copy/part w l
code: compose/deep/only copy [if none-equal? (w) [print (w)]]
forall w [code: append/only reduce ['for w/1 length? w l 1] code]
do code


;factorize 118931352
;== [2 2 2 3 4955473]

;different numbers of orders
5 * 4 * 3 * 2 * 1
120




;problem 12
;find the first triangular number with more than 500 divisors
;The smart way is to get the number of divisors for n and then for n + 1 / 2
;and then multiply them together. 

get-divisors: funct [n][
	o: copy[]
	for x 2 round sqrt n 1 [
		if n // x = 0 [
			repend o [n / x  x]
		]
	]
	2 + length? o
]

;stupid way
tn: 0
n: 0
forever [
	n: n + 1
	tn: tn + n 
	tl: get-divisors tn
	if 500 < tl [alert form tn]
]

;smart way
t1: ntp
n: 0
forever [
	n: n + 1
	
	a: n
	b: n + 1
	either even? a [a: a / 2] [b: b / 2]
	if 500 < multiply get-divisors a get-divisors b [
		break/return a * b
	]
]
ntp - t1


{

If the numbers 1 to 5 are written out in words: one, two, three, four, five, then there are 3 + 3 + 5 + 4 + 4 = 19 letters used in total.

If all the numbers from 1 to 1000 (one thousand) inclusive were written out in words, how many letters would be used?

NOTE: Do not count spaces or hyphens. For example, 342 (three hundred and forty-two) contains 23 letters and 115 (one hundred and fifteen) contains 20 letters. The use of "and" when writing out numbers is in compliance with British usage.
}

;N.B. FORTY FORTY FORTY FORTY FORTY. The correct spelling of 40 is forty. 

t: func [s] [length? rejoin parse s none]
a: t{one two three four five six seven eight nine}
b: t{ten eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen}
c: t{twenty thirty forty fifty sixty seventy eighty ninety}
d: t{onehundredand twohundredand threehundredand fourhundredand fivehundredand sixhundredand sevenhundredand eighthundredand ninehundredand}

e: t{onehundred twohundred threehundred fourhundred fivehundred sixhundred sevenhundred eighthundred ninehundred onethousand}


{;length from 1 to 99
The length from one to ninety nine is reached by added the length of the ones, the length of the teens starting from ten to nineteen and then adding ten...}
l99: a + b + (10 * c) + (8 * a) 

{one two three four five six seven eight nine}
{ten eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen}

{the total length is found by adding up all of the solitary hundred words, e.g. "onehundred" and ninety nine times the first part of composite hundred words, e.g. "onehundredand"}
e + (99 * d) + (10 * l99)

ans: 21124



{Problem 21
05 July 2002

Let d(n) be defined as the sum of proper divisors of n (numbers less than n which divide evenly into n).
If d(a) = b and d(b) = a, where a ? b, then a and b are an amicable pair and each of a and b are called amicable numbers.

For example, the proper divisors of 220 are 1, 2, 4, 5, 10, 11, 20, 22, 44, 55 and 110; therefore d(220) = 284. The proper divisors of 284 are 1, 2, 4, 71 and 142; so d(284) = 220.

Evaluate the sum of all the amicable numbers under 10000.
}

get-divisors: funct [n][
	o: copy[]
	for x 2 round sqrt n 1 [
		if n // x = 0 [
			repend o [n / x  x]
		]
	]
	repend o [1]
]

d: func [a] [sum get-divisors a]

o: copy []
repeat a 10'000 [
	b: d a 
	if all [a <> b a = d b] [repend o [a b]]
]
unique o

>> sum  unique all-to integer! o
== 31626.0



{add-bignum: func [a b] [
	;make them both the same length
	ml: max length? a length? b
	insert/dup a 0 ml - length? a
	insert/dup b 0 ml - length? b

	;add members and carry
	c: copy []
	repeat n ml [append c add pick a n pick b n]
	c: carry c
]


b+: funct [a b] [
	o: copy [] ta: tail a tb: tail b
	lim: negate first maximum-of reduce [length? a length? b]
	for i -1 lim -1 [
		a: pick ta i 
		b: pick tb i
		case [
			all [a b]	[insert o add a b]
			a			[insert o a]
			b			[insert o b]
		] 
	]
	o
]

;b+ [123 21 2321 32 1] [12 1 231 ]


}


{Problem 48
18 July 2003

The series, 11 + 22 + 33 + ... + 1010 = 10405071317.

Find the last ten digits of the series, 11 + 22 + 33 + ... + 10001000.
}


o: copy []
repeat n 1000 [
	t: 1.
	loop n [
		t: t * n
		mt: mold t
		l: length? copy/part mt find mt "."
		if 10 < l [
			t: do take/part/last mt 12
		]
	]
	append o t
]
sum o
ans: 9110846700

;OMG!!!!




{Problem 19
14 June 2002How many Sundays fell on the first of the month during the twentieth century 
(1 Jan 1901 to 31 Dec 2000)?}

n: 0
d: 7-Jan-1900 ;sunday
while [d < 31-Dec-2000] [
	d: d + 7
	if all [
		d > 1-Jan-1901
		d/day = 1
	] [
		n: n + 1
	]
]




f: read http://projecteuler.net/project/names.txt
f: load parse/all f ","
sort f

alphabet: {abcdefghijklmnopqrstuvwxyz}
score-of-name: funct [str] [
	t: 0
	foreach c str [
		t: t + index? find alphabet c
	]
	t
]

s: copy []
foreach f f [append s score-of-name f]

t: 0
forall s [t: add t s/1 * index? s]
t



lim: 999999
o: copy []
for n 10 1 -1 [
	append o r: to-integer lim / n: factorial n
	lim: lim - (r * n)
]

n: [0 1 2 3 4 5 6 7 8 9]
o: next o
p: copy []
forall o [append p take skip n o/1]
write clipboard:// rejoin p

ans: 278391546







prime-factors-of: funct [n][
	m: 2 i: 1
	o: copy[]
	until [
		either n // m = 0 [n: n / m append o m][m: m + i i: 2]
		if 1. * m * m > n [append o n n: 1] 
		n = 1
	]
	o
]

factors-of: funct [n][
	o: copy [1]
	for x 2 round sqrt n 1 [
		if n // x = 0 [
			repend o [n / x  x]
		]
	]
	append o n
]

proper-factors-of: funct [n][
	o: copy [1]
	for x 2 round sqrt n 1 [
		if n // x = 0 [
			repend o [n / x  x]
		]
	]
	o
]


;Find the sum of all the positive integers which cannot be written as the sum of two abundant numbers.


pn = f1 + f2 + f3 + ... + fi

n = pn + pn2







{Problem 23
02 August 2002

A perfect number is a number for which the sum of its proper divisors is exactly equal to the number. For example, the sum of the proper divisors of 28 would be 1 + 2 + 4 + 7 + 14 = 28, which means that 28 is a perfect number.

A number n is called deficient if the sum of its proper divisors is less than n and it is called abundant if this sum exceeds n.

As 12 is the smallest abundant number, 1 + 2 + 3 + 4 + 6 = 16, the smallest number that can be written as the sum of two abundant numbers is 24. By mathematical analysis, it can be shown that all integers greater than 28123 can be written as the sum of two abundant numbers. However, this upper limit cannot be reduced any further by analysis even though it is known that the greatest number that cannot be expressed as the sum of two abundant numbers is less than this limit.

Find the sum of all the positive integers which cannot be written as the sum of two abundant numbers.
}


s: spf: funct [{sum of proper factors} n][
	t: 1
	for x 2 round sqrt n 1 [
		if n // x = 0 [
			t: n / x + x + t
		]
	]
	t
]


an: []
for n 1 28123 1 [
	if greater? spf n n [
		append an n
	]
]

o: []
for n 1 28123 1 [

	lo: an
	hi: tail an
	

	
]

s2a: func [n] [
	forever [
		s: lo/1 + hi/-1 ;s sum of two abundant numbers
		if n = s [break]
		either s > n [hi: back hi] [lo: next lo]
		if greater-or-equal? index? lo index? hi [append o n print n break]
	]
	return n
]



3906285





;problem 26
;Find the value of d  1000 for which 1/d contains the longest recurring cycle in its decimal fraction part.

;d: 456
p: []
repeat d 1000 [
o: copy []
n: 1 
forever [
	n: n * 10
	while [n < d] [n: n * 10]
	
	either find o n [append p length? o break] [append o n]
	n: n // d
	if n = 0 [append p length? o  break]
]
]
index? maximum-of p
;983

