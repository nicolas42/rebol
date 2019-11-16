REBOL []

locknote-ctx: make object! [
	doc: {
		15-6-2013	changed fonts to fixedsys; rebol has horrible fonts, may as well embrace it.
	}
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
        /local chk1 chk2 note
    ][
        chk1: copy/part locknote 20 
        note: crypt/decrypt skip locknote 20 checksum/secure pass 
        chk2: checksum/secure note 
        if equal? chk1 chk2 [note]
    ]
    save-locknote: func [file][
        save/header file compose [
            locknote-ctx: (locknote-ctx) 
            locknote-ctx/view-locknote
        ] []
    ]
    locknote: #{
1D7C86A6D03FAC0BF4F9A6FD894CA35CCC597821F7FB06E0EB22CB0ADE4489A5
797C89C2C77588B7045CC3531E0C90A546F9F7878F50547B5B938934ACCE05CC
95992EE03D4FA48631A43E9EA0FFA1E37588BBBF4802070312C16A463F5A6190
060B7DD57C3685E0F84AF270269C7B9B26C6BD023DDE82B1935AD9B3271BFB0E
13AA40DA1829B8114159DEE1979FDA172DB18125FE990D35261A7562CEC9E859
8E777F84AC937D8F721090EF18AB7BC928DFCBAF9AFD060280649EDB4D9B1A20
7CB2FF5D20358BDC87CD7A365E23832723EE8461FCFBAF9347EC948E78042439
F01DAE1B89379A4E045489F2C87A5F770E901F06571CA1948521A8DB3024A5DF
7D7F0ADD3DD75F25FFD57E63BF8668DC24F34AFB6E4587AA1DF4207290F8369C
9EE4F18D0870BDD05E6A8BAFD5C93CA7A9828EFE21285F58032CE9D00CBD4FEF
AA6A98FBCE77A1DAB4DB5587
}
    new-locknote: func [][
        old-secure?: secure? 
        attempt [
            locknote: copy #{} 
            secure?: no 
            save-locknote request-file/save/only
        ] 
        secure?: old-secure?
    ]
    secure?: false
    view-locknote: func [][
        secure [net ask file ask] 
        stylize/master [
            area: area wrap white white edge [size: 0x0] font [name: "fixedsys"]
            link: text font [size: 12 name: "fixedsys" color: blue style: [underline]] edge [size: 0x0] 
            field: field white white edge [size: 0x0]
        ] 
        win: center-face layout [
            backcolor silver across 
            link "Change Password" [
                if secure? [
                    if set/any 'it request-text/title "Enter new password" [pass: it]
                ]
            ] 
            link "New Locknote" [new-locknote] return 
            fac: area 300x300
        ] 
        insert-event-func [if event/type = 'close [
                if not secure? [
                    return event
                ] 
                if request "Do you want to save the file?" [
                    if all [
                        not empty? fac/text 
                        not empty? pass
                    ] [
                        locknote: encrypt fac/text pass 
                        secure?: no 
                        save-locknote any [rebol/options/script request-file/save/only]
                    ]
                ]
            ] event] 
        either empty? locknote [
            pass: request-text/title "Please enter a new password" 
            secure?: yes
        ] [
            secure?: no 
            attempt [
                pass: request-text/title "Please enter password" 
                fac/text: decrypt locknote pass 
                secure?: to-logic fac/text
            ] 
            either secure? [
            	focus fac
            ] [
                fac/font/size: 24 
                fac/font/color: red 
                fac/font/name: "fixedsys" 
                fac/text: copy "ACCESS DENIED"
            ]
        ] 
        show fac  
        view/title win "Lock Note"
    ]
] 
locknote-ctx/view-locknote