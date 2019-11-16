rebol []

print "attempting to do something on another process then return the result to this process"
server-port: open/lines tcp://:50'002

write tcp://localhost:50000 { 
	write tcp://localhost:50'002 {add 3 5} 
}
connection-port: first server-port 
wait connection-port 
result: attempt [do first connection-port] 
close connection-port 
probe result
halt


comment {
	forever [ 
	    connection-port: first server-port 
	    until [ 
	        wait connection-port 
	        error? try [do first connection-port] 
	    ] 
	    close connection-port 
	]
}






rebol [] ;run first

server-port: open/lines tcp://:50'000 

forever [ 
    connection-port: first server-port 
    until [ 
        wait connection-port 
        error? try [do first connection-port] 
    ] 
    close connection-port 
]

rebol [] ;run second in second process

server-port: open/lines tcp://:50'002

write tcp://localhost:50000 { 
	write tcp://localhost:50'002 {add 3 5} 
}
connection-port: first server-port 
wait connection-port 
result: attempt [do first connection-port] 
close connection-port 
probe result
halt

;the result has been calculated in another process and returned via a tcp interprocess connection.


