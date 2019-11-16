REBOL []

locknote-ctx: make object! [
    request-text: func [
        "Requests a text string be entered." 
        /offset xy 
        /title title-text 
        /default str
    ][
        if none? str [str: copy ""] 
        text-lay: layout compose [
            across origin 10x10 space 2x4 
            h3 bold (either title [title-text] ["Enter text below:"]) 
            return 
            tf: field hide 300 str [ok: yes hide-popup] with [flags: [return]] return 
            pad 194 
            btn-enter 50 [ok: yes hide-popup] 
            btn-cancel 50 #"^[" [hide-popup]
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
        /local chk chk2 note
    ][
        chk1: take/part locknote 20 
        note: crypt/decrypt locknote checksum/secure pass 
        chk2: checksum/secure note 
        if equal? chk1 chk2 [note]
    ]
    locknote: #{
E9B3E17E9989246E0ABD2151E7105B711A5A5997B036CE10AC1473471270F546
423839DDE27440AEBFC3E09CC08BDC9E8ED89A3D5DFDA497C25641E29D1B5231
6231048967581CB758504A459EF04B85B7049B0A89E072363BC5CB9D1D38C4B9
FD2618E54C5D9BBCF27CDCA5D61884D2E356F975FEA3EF0747A944B99A7DE7DE
7674F8E758C38DB9AA9D61E46187C3789D48041454AA52D8154147B9A0214DEE
1DB2314AC5F234D04464C098BBDD29BCF9747B5E995D760D818251A3623DC813
AA5EB9E3AAE9D58A61D42F05453B41F78AEB7463DD78B4C3E4E4C18F60946948
BF7F0E95671570DBAD93283D9BC98742A708CB1920B082D22B22001039D36574
DC7903C3EE0F96CF9091979432404DA054E66F3F
}
    view-locknote: func [][
        pass: request-text 
        if empty? pass [quit] 
        either not empty? locknote [
            note: decrypt locknote pass 
            unless note [
                alert "DENIED" 
                quit
            ]
        ] [note: copy ""] 
        
        stylize/master [
            area: area white white edge [size: 0x0]
            link: text font [color: blue style: [bold underline]] edge [size: 0x0]
            field: field white white edge [size: 0x0]
        ]
        win: center-face layout [
            backcolor silver
            
            link "Change Password" [
                if set/any 'it request-text/title "Enter new password" [pass: it]
            ] 
            fac: area  300x300 note
        ] 
        insert-event-func [ if event/type = 'close [
            if request "Do you want to save the file?" [
                if all [
                    not empty? fac/text 
                    not empty? pass
                ] [
                    locknote: encrypt fac/text pass
                ] 
                save/header rebol/options/script compose [
                    locknote-ctx: (locknote-ctx) 
                    locknote-ctx/view-locknote
                ] []
            ]
        ] event ]
        focus fac 
        view/title win "Lock Note"
    ]
] 
locknote-ctx/view-locknote