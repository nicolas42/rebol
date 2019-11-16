rebol []

make-vlc-playlist: func [f /local a b o][

	a: {<?xml version="1.0" encoding="UTF-8"?>
	<playlist version="1" xmlns="http://xspf.org/ns/0/" xmlns:vlc="http://www.videolan.org/vlc/playlist/ns/0/">
		<title>Playlist</title>
		<trackList>
	}
		
	b: {
	</trackList>
	</playlist>}
	
	o: copy {}
	
	
	foreach f f [
		 append o rejoin [
		 	"<track><location>" "file:///" second f "://" skip f 3 "</location></track>" newline
		]
	]
	
	a: rejoin [a o b]
]

a: %"vlc playlist "
n: 0
until [
	file: join a [ n: n + 1 %.xspf ]
	not exists? file
]

write file make-vlc-playlist request-file
