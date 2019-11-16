rebol[]

;current problem
;implementation of select hit a road bump. left mouse and right mouse buttons cannot be pushed down together

sv: system/view
sf: sv/screen-face/feel
sf/event-funcs: append copy[] last sf/event-funcs
insert-event-func [
	if event/type = 'resize [f/size: win/size show win]
	event
]

win: layout [
origin 0 f: area edge none white white wrap with [flags: []]
para [tabs: 10]
font [name: "fixedsys"]
]

down?: no
alt-down?: no
leap-text: ""
origpos: ""

view/new/options win [resize]

f/feel: make object! bind/copy bind/copy [
    redraw: func [face act pos][
        if all [in face 'colors block? face/colors] [
            face/color: pick face/colors face <> focal-face
        ]
    ]
    detect: none
    over: none
    engage: func [face act event][
        switch act [
            down [
				down?: yes
				origpos: sv/caret

                ;either equal? face focal-face [unlight-text] [focus/no-show face] 
                ;caret: offset-to-caret face event/offset 
                show face
            ] 
		up [down?: no leap-text: copy ""]
		alt-down [alt-down?: yes origpos: sv/caret]
		alt-up [alt-down?: no leap-text: copy ""]

           none [; over [
                if not-equal? caret offset-to-caret face event/offset [
                    if not highlight-start [highlight-start: caret] 
                    highlight-end: caret: offset-to-caret face event/offset 
                    show face
                ]
            ] 
            key [
            event-key: event/key
            if event-key = #"^M" [event-key: #"^/"]
		if any [down? alt-down?] [append leap-text event-key probe leap-text]
		if down? [sv/caret: any [find/reverse origpos leap-text origpos]]
		if alt-down? [sv/caret: any [find origpos leap-text origpos]]
		if any [down? alt-down?] [show face]

    	either all [
    		find [#"^M" #"^/"] event/key 
    		event/shift
    	][
    		start: any [find/reverse sv/caret "^/^/" head sv/caret]
    		end: any [find sv/caret "^/^/" tail sv/caret]
    		set/any 'result attempt [do copy/part start end]
    		if value? 'result [
        		mr: mold result
        		insert sv/caret mr
        		sv/highlight-start: end 
        		sv/highlight-end: skip end length? mr 
        		show face
    		]
    		
    	] [
    		if not any [down? alt-down?][
				edit-text face event get in face 'action
			]
    	]

		
	]
        ]
    ]
] sv ctx-text

focus f
do-events
