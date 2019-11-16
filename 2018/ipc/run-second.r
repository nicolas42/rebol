rebol []

; open a channel on port 50'001
server-port: open/lines tcp://:50'001

; write port 50'000
write tcp://localhost:50000 { 
	print "Hahahahaha..."
	write tcp://localhost:50'001 mold 5 + 3
}

connection-port: first server-port 
wait connection-port 
result: first connection-port
close connection-port 

print result
halt
