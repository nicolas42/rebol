REBOL [Title: "REBOL Binary Embedder"]


;to embed the thing do this
;load to-binary decompress thing

system/options/binary-base: 64
file: to-file request-file/only
if not file [quit]
uncompressed: read/binary file

compressed: compress to-string uncompressed
; Note that the line above converts the binary data
; to a text string, and then compresses it.

editor compressed
alert rejoin ["Uncompressed size:  " length? uncompressed
    " bytes.  Compressed size: " length? compressed " bytes."]
