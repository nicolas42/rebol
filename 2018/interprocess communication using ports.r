REBOL []

attempt [close listen]

listen: open/lines tcp://:12345 
waitports: [listen]
forever [
    probe type? data: wait waitports
    either same? data listen [
        active-port: first listen
        append waitports active-port
    ][
      attempt [do first data]
    ] 
]
close listen


{
;Do this from another task. The code must end in a newline
denis: open tcp://localhost:12345
insert denis {alert "Plug my internet back in!" ^/}
insert denis {print "hello"^/}
}

;read*: :first


;Okay, so now I've got to modify this so that it waits on the rebol/ports/wait-list so that it works alongside all the other ports :)

