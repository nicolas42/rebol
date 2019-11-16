rebol []

files: read what-dir
insert files %../

print "Click on the iterated faces."

selected: 0

aface: make face [
    size: 300x20
    text: "Test"
    font: make font [
    	align: 'left
    ]
    edge: none
    feel: make feel [
        engage: func [face action event] [
            print ["Engage" face/data action]
    		if action = 'scroll-line [
    			files: skip files e/offset/y
    			show main-face
    		]
            if action = 'down [
            	either all [
            		not empty? face/text 
            		#"/" = last face/text
            	] [
	            	if attempt [read files/:data] [
	            		selected: none
	            		change-dir files/:data
	            		files: read what-dir
	            		insert files %../
						show main-face
	            	]
            	] [
	                selected: face/data
	                show main-face
                ]
            ]
        ]
    ]
    data: 0
]

pane-func: func [face index] [
    ; RETURNS: face, index number, or none
    ; ?? index
    either integer? index [
        ; Draw needs to know offset and text:
        if index <= 1000 [
        	do bind [
            	data: index
            	offset/y: index - 1 * 20
            	text: ""
            	if files/:index [
            		text: form files/:index
            	]
            	color: if selected = index [yello]
            	return self
            ] aface
        ]
    ][
        ; Events need to know iteration number:
        return to-integer index/y / 20 + 1
    ]
]

main-face: make face [
	offset: 100x100
	color: white
    size: as-pair aface/size/x 800
    edge: none
    pane: :pane-func
    feel: make feel [
    	engage: func [f a e][
    		if a = 'scroll-line [
    			files: skip files e/offset/y
    			show main-face
    		]
    	]
    ]
]

system/view/focal-face: main-face

view/options main-face [resize]

