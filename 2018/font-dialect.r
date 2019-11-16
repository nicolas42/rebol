rebol [
	title: "Font Dialect"
	date: 15-6-2013
	author: "Nicolas Schmidt"
]

font: func [
    {Font dialect. Makes font object.

    Examples
    eg: font ["lucinda" 36 silver top left 5x5 10x10 1x1]
    arial12: font ["arial" 12]
    fixedsys: font ["fixedsys" bold]
    lucinda12: font ["lucinda" 12 silver top left]
    test: font [yellow "tahoma" 24 top left 0x0 2x2 3x3]

    make font default to top left alignment
    }
    a 
    /local oss font1
] [
    font1: make face/font [align: 'left valign: 'top]
    do bind/copy [
    
        oss: [offset space shadow]
        
        foreach a a  [
        
        	if all [word? a value? a] [a: get a]
        	
            switch type?/word a [
                string!         [name: a]
                integer!        [size: a]
                block!          [style: a]
                tuple!          [color: a]
                word!           [
                    switch a [
                        left right center       [align: a]
                        top bottom middle       [valign: a]
                        bold italic underline   [style: a]
                    ]
                ]
                pair!           [
                	set first oss a
                	oss: next oss
                 ]
            ]
        ] 
    ] font1

    return font1    
]

demo: does [
	arial12: font ["arial" 12]
	fixedsys: font ["fixedsys" bold]
	lucinda12: font ["lucinda" 12 silver top left]
	test: font [yellow "tahoma" 24 top left 0x0 2x2 3x3]
]
