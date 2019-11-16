REBOL [Title: "Nano-Sheets"]

csize: 100x20
size: 8x16

col-lbl: func [col] [form to char! 64 + col]
cell-name: func [x y] [join col-lbl x y]
mk-var: func [x y] [to lit-word! cell-name x y]

sheet: copy [
   space 1x1 across
   style cell field csize edge none 
      with [formula: none]
      [enter face  compute  face/para/scroll: 0x0]
   style label text csize white black bold center
]

repeat y 1 + size/y [
   repend sheet ['label (csize / 2x1)
      either 1 = y [""] [form y - 1]]
   repeat x size/x [
      append sheet compose/deep
      either 1 = y [
         [label (col-lbl x)]
      ][
         [cell with [var: (mk-var x y - 1)]]
      ]
   ]
   append sheet 'return
]

enter: func [face /local data] [
   if empty? face/text [exit]
   set face/var face/text
   data: either #"=" = face/text/1 [ next face/text ][
      face/text
   ]
   if error? try [data: load data] [exit]
   if find [integer! decimal! money! time!
      date! tuple! pair!]   type?/word :data [
         set face/var data exit
   ]
   if face/text/1 = #"=" [face/formula: :data]
]

compute: does [
   unfocus
   foreach cell cells [
      if cell/formula [
         if error? cell/text: try [do cell/formula] 
            [cell/text: "ERROR!"]
         set cell/var cell/text
         show cell
      ]
   ]
]

append sheet [key escape [halt]]
lay: layout sheet
cells: copy []
foreach face lay/pane [
   if 'cell = face/style [   append cells face]
]
focus first cells
view lay 
