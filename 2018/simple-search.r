REBOL [title: "Simple Search"]

phrase: request-text/title/default "Text to Find:" "the"
start-folder: request-dir/title "Folder to Start In:"
change-dir start-folder
found-list: ""

recurse: func [current-folder] [ 
    foreach item (read current-folder) [ 
        if not dir? item [  if error? try [
            if find (read to-file item) phrase [
                print rejoin [{"} phrase {" found in:  } what-dir item]
                found-list: rejoin [found-list newline what-dir item]
            ]] [print rejoin ["error reading " item]]
        ]
    ]
    foreach item (read current-folder) [ 
        if dir? item [
            change-dir item 
            recurse %.\
            change-dir %..\
        ] 
    ]
]

print rejoin [{SEARCHING for "} phrase {" in } start-folder "...^/"]
recurse %.\
print "^/DONE^/"
editor found-list
halt
