REBOL [
    Title: "Copy File with Optional Checksum"
    Author: "Carl Sassenrath"
    License: 'MIT
]

copy-file: func [
    "Copy a file. Return WORD for failure or return optional checksum."
    from [file!]
    dest [file!]
    /sum "checksum the data"
    /local
    data
    path
    ff ; from file port
    tf ; to file port
][
    path: split-path dest

    foreach [block err-word] [
        [make-dir/deep path/1] dir-failed
        [ff: open/binary/read/seek from] read-failed
        [tf: open/binary/write dest] write-failed
        [if sum [sum: open [scheme: 'checksum]]] sum-failed
        [
            while [not tail? ff] [
                print index? ff
                data: copy/part ff 100000
                insert tail tf data
                if sum [insert sum data]
                ff: skip ff length? data
            ]
            ;print index? ff
        ] copy-failed
    ][
        if error? try block [
            if port? sum [close sum]
            if tf [close tf]
            if ff [close ff]
            return err-word
        ]
    ]

    data: none
    if sum [
        update sum
        data: copy sum
        close sum
    ]
    close tf
    close ff
    data ; checksum value or none
]

; print copy-file/sum %movie.mpg %movie2.mpg
; ask "done"

demo: does [ ;8-6-2013
if not exists? %starcraft.iso [ print " file doesn't exist" exit ]
recycle/on
change-dir %../desktop/
print copy-file/sum %starcraft.iso %starcraft-copy.iso
]


