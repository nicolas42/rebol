REBOL []

locknote-ctx: make object! [
    request: func [text][
        layout1: layout [
            style h3 h3 font [name: "fixedsys" style: []] 
            style field field font [name: "fixedsys"] para [origin: 2x2] 
            style area area wrap white white edge [size: 0x0] font [name: "fixedsys"] 
            style link text font [size: 12 name: "fixedsys" color: blue style: []] edge [size: 0x0] 
            style field field white white edge [size: 0x0] 
            across origin 1 space 1 backcolor white 
            h3 (text) return 
            box silver 300x1 return 
            pad 120 
            link "Yes" 60 #"y" [result: yes hide-popup] 
            link "No" 60 #"n" [result: no hide-popup] 
            link "Cancel" 60 #"^[" [result: none hide-popup]
        ] 
        result: none 
        inform layout1 
        result
    ]
    request-text: func [
        "Requests a text string be entered." 
        /offset xy 
        /title title-text 
        /default str
    ][
        if none? str [str: copy ""] 
        text-lay: layout compose [
            across origin 1x1 space 1 backcolor white 
            style h3 h3 font [name: "fixedsys" style: []] 
            style field field font [name: "fixedsys"] para [origin: 2x2] 
            h3 (either title [title-text] ["Enter text below:"]) return 
            box silver 300x1 return 
            tf: field hide 300 str [ok: yes hide-popup] with [flags: [return]] return 
            box silver 300x1 return 
            pad 170 
            link "Enter" 60 [ok: yes hide-popup] 
            link "Cancel" 60 #"^[" [hide-popup]
        ] 
        ok: no 
        focus tf 
        either offset [inform/offset text-lay xy] [inform text-lay] 
        all [ok tf/data]
    ]
    crypt: func [
        "Encrypts or decrypts data and returns the result." 
        data [any-string!] "Data to encrypt or decrypt" 
        akey [binary!] "The encryption key" 
        /decrypt "Decrypt the data" 
        /binary "Produce binary decryption result." 
        /local port
    ][
        port: open [
            scheme: 'crypt 
            direction: pick [encrypt decrypt] not decrypt 
            key: akey 
            padding: true
        ] 
        insert port data 
        update port 
        data: copy port 
        close port 
        if all [decrypt not binary] [data: to-string data] 
        data
    ]
    encrypt: func [txt pass][
        join 
        checksum/secure txt 
        crypt txt checksum/secure pass
    ]
    decrypt: func [
        locknote pass 
        /local chk1 chk2 note
    ][
        chk1: copy/part locknote 20 
        note: crypt/decrypt skip locknote 20 checksum/secure pass 
        chk2: checksum/secure note 
        if equal? chk1 chk2 [note]
    ]
    locknote: #{
014EF9A982484017D7A1EB2664C9CBF4A478288C8DEBD22DF4F4AFCDC628FA36
A8572A3B4034AE469FAA263400ECFCB3B0270D6C22500F2233588F342B95BD47
912E9B8C9E9CE18CAA1DC3E7530E4D4F4941D5D77FE6D28335A77ABDE9A30953
A751982094EF7A1ACF9E48ACE9B2317D259B2DD772559F72DA70B631A96C0CC3
1AED7ADB503EF605538A3F609CDCD0A104EB90E309E267FC60383E076281F83B
E52AC7ABD335CF4BFBC1E0ACBB8EE96B3CDF0A6FBEE3B537D79F5C43D316E6F1
69A799EBA37E19ED0834F7794E1688199655BB5E1E34B1AB67D9F14521BB983A
4453150EEC25B583DAFBEE6E9E807F6E302B79E73208861BA2937006B963448B
5354E538CCFF3F4016459891913017F712F2BBB9BA5302E557A8A5C2C1BDDA01
332DCFE43729095C16681EF2FA43CB44ED35B966098C8756F9FAD7DFB149F627
7A821521F66D1907E000B257CB43494715FDF303D8A095B2FF24323C41AFCBAC
D8249EB8C9591C2BAB109E77C7E8AB08DB62D62A033892B692F11C461E91150B
46D762B3
}
    save-locknote: func [file content][
        save/header file compose [
            locknote-ctx: (locknote-ctx) 
            locknote-ctx/view-locknote
        ] []
    ]
    view-locknote: func [][
        comment "secure [net ask file ask] " 
        stylize/master [
            area: area wrap white white edge [size: 0x0] font [name: "fixedsys"] 
            link: text font [size: 12 name: "fixedsys" color: blue style: []] edge [size: 0x0] 
            field: field white white edge [size: 0x0]
        ] 
        win: center-face layout [
            origin 1 space 1 backcolor white across 
            link "Set Password" [
                if not none? it: request-text/title "Enter new password" [
                    pass: it
                ]
            ] 
            return 
            hr: box 350x1 silver return 
            fac: area 350x350
        ] 
        insert-event-func func [face event /local file] [
            if event/type = 'close [
                if any [
                    old-pass <> pass 
                    original-text <> fac/text
                ] [
                    if request "Do you want to save the file?" [
                        file: any [rebol/options/script request-file/save/only] 
                        locknote: encrypt fac/text pass 
                        save-locknote file locknote
                    ]
                ]
            ] 
            if event/type = 'resize [
                hr/size/x: win/size/x - 2 
                fac/size: win/size - 0x25 
                fac/line-list: none 
                show fac 
                show hr
            ] 
            event
        ] 
        case [
            empty? locknote [
                pass: old-pass: copy "" 
                fac/text: copy "" 
                focus fac 
                view/title/options win "Lock Note" [resize]
            ] 
            not decrypt locknote "" [
                pass: old-pass: request-text/title "Please enter password" 
                if none? pass [pass: copy ""] 
                if fac/text: decrypt locknote pass [
                    original-text: copy fac/text 
                    focus fac 
                    view/title/options win "Lock Note" [resize]
                ]
            ] 
            decrypt locknote "" [
                pass: old-pass: copy "" 
                fac/text: decrypt locknote "" 
                original-text: copy fac/text 
                focus fac 
                view/title/options win "Lock Note" [resize]
            ]
        ]
    ]
] 
locknote-ctx/view-locknote