rebol []

uuid: funct [
	{Make a universally unique identifier (UUID)
	Make sure you random/seed now/precise beforehand
	
	Make a random 25 digit alphanumeric string with 8.08281277464764E+38 alternatives.	
	This is higher than a 128 bit binary which has 3.4 × 10 ** 38 alternatives.
	
	;unprintable version
	o: copy {} loop 16 [append o to-char random 255] ;(16 bytes)
	}
][
	a: "abcdefghijklmnopqrstuvwxyz0123456789"
	o: copy {} 
	loop 25 [append o pick a random length? a]
]

