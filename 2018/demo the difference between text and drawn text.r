rebol[]

;on-unfocus draw-text and move text to data attribute

slice: func [s a b] [
	copy/part at s a b
]

slice-to: func [s a b][
	slice s a b - a + 1
]

;
    {view layout [
        body 80x50 "This is an example string."
            feel [
                engage: func [face act event] [
                    if act = 'down [
                        bx/text: copy offset-to-caret
                            face event/offset
                        show bx
                    ]
                ]
            ]
        bx: body 80x50 white black
    ]}
	
	{feel [
		engage: func [f a e][
			if e/type = 'down [. offset-to-caret f e/offset]
		]
	]}
	

;where to put the line feeds in a text

t1: {REBOL 2: View Draw Dialect
www.rebol.com/docs/draw.html
9 Nov 2010 – The REBOL/View graphics system was designed for displaying user ... Here the DRAW keywords are PEN, LINE, BOX, FILL-PEN, TEXT, and ...
You've visited this page many times. Last visit: 3/18/12
DRAW Dialect Reference - REBOL
www.rebol.com/docs/draw-ref.html
23 Oct 2010 – DRAW commands are a dialect of REBOL. ... This is a change from prior versions of REBOL. .... Sets the current font used for drawing text. Arg ...
You've visited this page many times. Last visit: 5/7/12
REBOL/View Graphics - Other Special Features
www.rebol.com/docs/view-face-other.html
1 Apr 2010 – In REBOL, these "virtual faces" can be generated dynamically ... When drawing the display, this allows you to set the offset, text, color or any ...
You've visited this page 4 times. Last visit: 11/13/11
Rebol Draw: how to center text inside a box? - Stack Overflow
stackoverflow.com/.../rebol-draw-how-to-center-text-inside-a-box
1 answer - 15 Aug 2009
Top answer: Here's a way of doing it by putting text straight into the box instead of using the DRAW dialect: view layout [ box white 728x90 font [align: 'center] "Your ...
rebol - How to stylize text-list and other elements? - Stack Overflow
stackoverflow.com/.../how-to-stylize-text-list-and-other-elements
2 answers - 11 Feb 2011
I want all fields to have a thin border, including text-list and others. But I have no ... Rebol Draw: how to center text inside a box? How to send ...
Rebol-View-GTK
www.pat665.free.fr/gtk/rebol-view.html
btn "Title 2" [set-face lay "Ok I stay here"] ] 300x100 lay/access: make lay/access [ set-face*: func [face value] [ face/text: value face/changes: 'text ] ] view/title ...
View Overview}



{f/feel/detect: func [f e][if e/type = 'down [. e/offset] e]}

{f/feel/detect: func [f e][if e/type = 'down [. offset-to-caret f e/offset] e]}




;offset-to-caret f 0x0

;There's two pixels between text lines
;offset-to-caret seems to start on the bottom of the first line
;use an offset of zero for the first line and three for the second line


;font size 12 actually takes up 14 pixels in height?

size-char: funct [fnt] [
	;size of an arial character A at font-size
	layout [f: box font fnt "A"]
	size-text f
]

text-to-draw-text: funct [f "face"][



l: does [length? f/line-list]
sz: size-text f
ht: second size-char f/font

;repeat n 35 [c: offset-to-caret f as-pair 0 n * 15 . copy/part c 20]

o: copy []
repeat n l [
	c: offset-to-caret f as-pair sz/y n * ht 
	append o index? c
]
insert o [1]

p: copy []
forall o [
	if o/2 [append p slice-to f/text o/1 o/2 - 1]
]

forall p [p/1: trim/head p/1]


{foreach p p [
	if #"^/" <> first p [
		insert p #"^/"
	]
]
remove p/1 ;first line shouldn't have a newline}

p

]

draw-text: funct [f][

	l: text-to-draw-text f

	;generate draw block

	db: copy compose [font (f/font)]
	forall l [
		append db [text]
		append db as-pair 2 (index? l) - 1 * (second size-char f/font) + 2
		append db l/1
	]

	f/text: none
	f/effect: [draw db] 
	show f
]

verdana24: make face/font [
	name: "verdana"
	size: 24
	align: 'left
]

w: layout [
	across
	e: area 600x600 font verdana24 wrap t1
	f: area 600x600 font verdana24 wrap t1
	btn "Draw Text" [draw-text f]
]
print 'yawp
view/options w [resize]
