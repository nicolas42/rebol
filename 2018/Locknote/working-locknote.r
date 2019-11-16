REBOL []

locknote-ctx: make object! [
    doc: {
^-^-15-6-2013^-changed fonts to fixedsys; rebol has horrible fonts, may as well embrace it.

^-remake request function from original request function or possibly from inform function.
^-}
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
DFD9C0F3CDC6C1D38A11C666EA95204ED0B42E730C40F9AD495CCA880E29D7E0
5CFAA01249ACA4EC81895CA1B65B5F576D15EB63033F4C00B747D5A340C59E93
15F3AE258ACDC77FEA5E8A9C379676FB3F1AE97DD7EB696F9F881F8F7CA673C5
E3F89054A125F65491E3CA3DCA9E32C2B6A051EB4D3AE0335C1CA8944ADB9381
40710CC2C4317157682B5BB46F04CD8FB377F1662A5CA8D5E3733E7BD27A4239
8D80C40E6EDE64102C2FF497DC4C8E5D27FBF4E3EBEF6B8D54FE8F30C7577A05
26823438C532115A5E00FE751B7F02DEBBA0DE5E648A733082E6E0ABCEEDC14E
99087DD44A41586AB0E3FD566E3EBE4D74902E1271A0221CFFC2661A026AF245
FF76CFB03D306551DE2BC05D66D69C7F8E43D26DE3A819F54C8327D3170D7AA1
04FFA869
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
                pass: request-text/title "Enter new password" 
                if none? pass [pass: copy ""]
            ] 
            return 
            hr: box 300x1 silver return 
            fac: area 300x300
        ] 
        insert-event-func func [face event /local file] [
            if event/type = 'close [
                if request "Do you want to save the file?" [
                    file: any [rebol/options/script request-file/save/only] 
                    locknote: encrypt fac/text pass 
                    save-locknote file locknote
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
                pass: copy "" 
                fac/text: copy "" 
                focus fac 
                view/title/options win "Lock Note" [resize]
            ] 
            not decrypt locknote "" [
                pass: request-text/title "Please enter password" 
                if fac/text: decrypt locknote pass [
                    focus fac 
                    view/title/options win "Lock Note" [resize]
                ]
            ] 
            decrypt locknote "" [
                pass: copy "" 
                fac/text: decrypt locknote "" 
                focus fac 
                view/title/options win "Lock Note" [resize]
            ]
        ]
    ]
] 
locknote-ctx/view-locknote