rebol []

;Install Mac 	wget https://github.com/nicolas42/rebol/blob/master/mac/rebol
;Install Linux 	wget https://github.com/nicolas42/rebol/blob/master/linux/rebol

dir: %dolphin/  f: read dir  remove-each f f [ %.jpg <> suffix? f ]  forall f [ insert f/1 dir ]  
train: take/part f to-integer 0.2 * length? f
test: f

print train
print test
