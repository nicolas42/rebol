
rebol [] ;run first

print "doing text received on port 50'000"

server-port: open/lines tcp://:50'000 

forever [ 
    connection-port: first server-port 
    until [ 
        wait connection-port 
        error? try [do first connection-port] 
    ] 
    close connection-port 
]


