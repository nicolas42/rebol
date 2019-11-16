REBOL []

locknote-ctx: make object! [
    doc: {
^-^-15-6-2013^-changed fonts to fixedsys; rebol has horrible fonts, may as well embrace it.
^-}
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
    locknote: #{
7614985EDCBDECE8F6A85FDAE017EE539EE099BCAECEA0D2567943324FB79182
A1961680B33DABE8817B4C62280425E7B88361DA5B41541AC1A96EB6DF0DEFFD
0FB907859F20B729A5C1E1AE3B431CCC30D9252F4AFEF4B468C06BE49FFAABAF
40AFEAA28BF07F99F356311E64D17B504787D2614D26D23470C7F989F87B06F0
D2FCA4757372018562ECBED09C56B537497DC8B0B57C8CC2A07BAE45CBC58B9A
98FAC5E4D1140F0E4ED44704BA34850BA2FF9C0BBB0EA03C6A24E0FD4216C5AC
FCCC4BCCD772A2D088548570C3F69DB917648DD62E76ADCFCBD92D64549C546A
CAC11581E1C69767ADDCAE37B4C3DF2BF18C3D9B562AEC14C0C47596B9766C74
ED6D66F97B76DE518E231E712261A9015A603E98133082216B211CF10B33299A
50DD43D25468DB7C24D4D875
}
    new-locknote: func [/local old-secure?][
        old-secure?: secure? 
        attempt [
            locknote: copy #{} 
            secure?: no 
            save-locknote request-file/save/only
        ] 
        secure?: old-secure?
    ]
    save-locknote: func [file][
        save/header file compose [
            locknote-ctx: (locknote-ctx) 
            locknote-ctx/view-locknote
        ] []
    ]
    secure?: false
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
                if secure? [
                    pass: request-text/title "Enter new password" 
                    if none? pass [pass: copy ""]
                ]
            ] 
            pad 10 
            link "New Locknote" [new-locknote] return 
            hr: box 300x1 silver return 
            fac: area 300x300
        ] 
        insert-event-func [
            if event/type = 'close [
                if not secure? [
                    return event
                ] 
                if request "Do you want to save the file?" [
                    locknote: encrypt fac/text pass 
                    secure?: no 
                    save-locknote any [rebol/options/script request-file/save/only]
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
        secure?: on 
        if not fac/text: decrypt locknote "" [
            pass: request-text/title "Please enter password" 
            if none? pass [pass: copy ""] 
            fac/text: decrypt locknote pass 
            secure?: to-logic fac/text 
            either secure? [
                focus fac
            ] [
                fac/font/name: "fixedsys" 
                fac/text: copy "ACCESS DENIED"
            ]
        ] 
        show fac 
        view/title/options win "Lock Note" [resize]
    ]
] 
locknote-ctx/view-locknote