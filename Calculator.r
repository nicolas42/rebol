REBOL []

;inspired by tabbyCalc
;return is #"^M"

;====================================================

calc: func [
	{Takes a string like "4*3+8" and returns the answer}
	str
	/local digit non-digit out mark p1 p2 it
][
	digit:   charset "0123456789."
	non-digit: complement digit
	out: copy []
	parse str [any [to {^^} mark: {^^} (change/part mark "**" 1) ] ]
	parse str [
		some [
			copy it some digit (append out it) 
			opt ["." copy it some digit (append last out "." append last out it)]	
			opt [p1: "E" opt ["+" | "-"] some digit p2: (append last out copy/part p1 p2)]
			| copy it some non-digit (append out it)
		]
	]
	forall out [change out load first out]
	forall out [if number? first out [change out to-decimal first out]]
	do head out
]

factorial: func [f /local a ] [
	a: 1 ;accumulator
	repeat i f [ a: a * i ]
	a
]

total: sum: func [b] [t: 0 foreach i b [t: t + i]]
average: avg: func [b] [divide sum b length? b]


;====================================================

sv: :system/view

window: layout [
	backcolor black
	origin 5 space 5
	it: area black black 250x250 edge none font [name: "Tahoma" style: 'bold color: white]
	key escape [halt]
]

it/feel: make object! bind/copy bind/copy [
    redraw: func [face act pos][
        if all [in face 'colors block? face/colors] [
            face/color: pick face/colors face <> focal-face
        ]
    ]
    detect: none
    over: none
    engage: func [face act event /local start end][
        switch act [
            down [
                either equal? face focal-face [unlight-text] [focus/no-show face]
                caret: offset-to-caret face event/offset
                show face
            ]
            over [
                if not-equal? caret offset-to-caret face event/offset [
                    if not highlight-start [highlight-start: caret]
                    highlight-end: caret: offset-to-caret face event/offset
                    show face
                ]
            ]
            key [
            	edit-text face event get in face 'action
            	
            	;CHANGED BIT
            	if event/key = #"^M" [
            	
            		end: find/reverse sv/caret newline 
            		start: any [
            			find/reverse end newline
            			head sv/caret
            		]
            		string: copy/part start end
            		
            		;If input is single number then do nothing.
            		if all [
            			attempt [load/all string]
            			equal? 1 length? load/all string 
            			number? first load/all string
            		] [exit]

            		caret: insert caret form calc string
            		show face
            	]
            ]
        ]
    ]
] system/view ctx-text

focus it
view/new center-face window
wait []
