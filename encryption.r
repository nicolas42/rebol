rebol []

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
    crypt txt checksum/secure pass
]
decrypt: func [
    arg pass 
][
    crypt/decrypt arg checksum/secure pass 

]
