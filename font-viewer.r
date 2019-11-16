REBOL []

get-fonts: make function! [
	"Obtain list of fonts on supported platforms."
	/local s fonts
] [
	fonts: copy []
	either 3 = fourth system/version [
		call/output {reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"} s: copy ""
		s: skip parse/all s "^-^/" 4
		foreach [fn reg style] s [
			fn: trim first parse/all fn "("
			all [
				not find fonts fn
				not find ["Estrangelo Edessa" "Gautami" "Latha" "Mangal" "Mv Boli" "Raavi" "Shruti" "Tunga"] fn
				not find fn " Bold"
				not find fn " Italic"
				not find fn " Black"
				not find fn "WST_"
				insert tail fonts fn
			]
		]
	] [
		call/output "fc-list" s: copy ""
		s: parse/all s ":^/"
		foreach [fn style] s [
			all [
				not find fonts fn
				(size-text make face [text: "A" font: make font [name: fn size: 12]]) <>
				size-text make face [text: "A" font: make font [name: fn size: 20 style: 'bold]]
				insert tail fonts fn
			]
		]
	]
	sort fonts
]

;This fonts block was obtained with "fonts: get-fonts"
fonts: ["Arial" "Comic Sans MS" "Courier 10,12,15" "Franklin Gothic Medium" "Georgia" "Impact" "Lucida Console" "Lucida Grande" "Lucida Sans Demibold Roman" "Lucida Sans Regular" "Lucida Sans Unicode" "MCKoss Tiny  4" "Microsoft Sans Serif" "MS Sans Serif 8,10,12,14,18,24" "MS Serif 8,10,12,14,18,24" "Sylfaen" "Tahoma" "Times New Roman" "Trebuchet MS" "Verdana"]
drw: [pen black]
pos: 0x0

forall fonts [
	fnt: make face/font [
		name: fonts/1
		size: 20
	]
	repend drw [
		'font fnt 
		'text pos fnt/name
	]
	pos: pos + 0x25
]

view center-face layout [
	backcolor white
	box 300x500 effect [draw drw]
]

;past versions
comment [{
fonts: get-fonts
sheet: copy [backcolor white]
forall fonts [
	append sheet compose/deep [
		text (to-string fonts/1) font [size: 20 name: (fonts/1)]
		;added 9/2/11
		with [
			feel: make feel [
				engage: func [f a e] [
					probe face/font/name
				]
			]
		]
	]
	if 0 = remainder index? fonts 20 [
		append sheet [return]
	]
]

append sheet [key escape [halt]]

view win: center-face layout sheet

}]


comment [{
fonts: ["Arial" "Comic Sans MS" "Courier 10,12,15" "Courier New" "Franklin Gothic Medium" "Georgia" "Impact" "Kartika" "Lucida Console" "Lucida Grande" "Lucida Sans Demibold Roman" "Lucida Sans Regular" "Lucida Sans Unicode" "MCKoss Tiny  4" "Microsoft Sans Serif" "Modern" "MS Sans Serif 8,10,12,14,18,24" "MS Serif 8,10,12,14,18,24" "Palatino Linotype" "Roman" "Script" "Small Fonts" "Sylfaen" "Symbol" "Symbol 8,10,12,14,18,24" "Tahoma" "Times New Roman" "Trebuchet MS" "Verdana" "Vrinda"]

sheet: copy [
	style b box 200x40
	backcolor white
]
	
forall fonts [
	f: make face/font [
		name: fonts/1
		size: 20
	]
	append sheet reduce ['b 'effect reduce ['draw reduce ['pen black 'font f 'text fonts/1]]]
]

view center-face layout sheet
}]


comment [{fonts: ["Arial" "Comic Sans MS" "Courier 10,12,15" "Courier New" "Franklin Gothic Medium" "Georgia" "Impact" "Kartika" "Lucida Console" "Lucida Grande" "Lucida Sans Demibold Roman" "Lucida Sans Regular" "Lucida Sans Unicode" "MCKoss Tiny  4" "Microsoft Sans Serif" "Modern" "MS Sans Serif 8,10,12,14,18,24" "MS Serif 8,10,12,14,18,24" "Roman" "Script" "Small Fonts" "Sylfaen" "Tahoma" "Times New Roman" "Trebuchet MS" "Verdana" "Vrinda"]

sheet: copy [
	style b box 300x25
	backcolor white
]

l: length? fonts	
forall fonts [
	f: make face/font [
		name: fonts/1
		size: 20
	]
	append sheet reduce [
		'b 'effect reduce ['draw reduce [
				'pen black 
				'font f 
				'text fonts/1
		]]
	]
	if divisible? index? fonts 10 [append sheet [return]]
]

view center-face layout sheet
}]

