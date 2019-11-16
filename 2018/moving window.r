rebol []

demo-resizeable-moveable-area: func [
	{original code from NickA re-bol.com}
][
	
	engage-area*: func [f act e] bind/copy bind/copy [
	    switch act [
	        down [
	            either equal? f focal-face [unlight-text] [focus/no-show f]
	            caret: offset-to-caret f e/offset
	            show f
	
	            ;move resize code
	            initial-position: probe e/offset
	            initial-size: f/size
	            remove find f/parent-face/pane f
	            append f/parent-face/pane f
	            move?: either inside? 20x20 initial-position [on][off]
	            resize?: either outside? (f/size - 20x20) initial-position [on][off]
	        ]
	        over away [
	
	            ;move resize code
	            if resize? [f/size: initial-size + (e/offset - initial-position)]
	            if move? [f/offset: f/offset + (e/offset - initial-position)]
	            show f
	
	            if not-equal? caret offset-to-caret f e/offset [
	                if not highlight-start [highlight-start: caret]
	                highlight-end: caret: offset-to-caret f e/offset
	                show f
	            ]
	        ]
	        key [edit-text f e get in f 'action]
	    ]
	] system/view ctx-text 


	win: layout [fac: area "Click the top left corner to move. ^/Click the bottom right corner to resize."]
	view/new/options win [resize]
	win: make win [initial-position: initial-size: move?: resize?: none] ;put
	win/feel/engage: :engage-area*
	do-events
]

demo-resizeable-moveable-area

