;; =================================================
;; Script: dual-col.r
;; downloaded from: www.REBOL.org
;; on: 6-Jun-2013
;; at: 11:51:42.981311 UTC
;; owner: carl [script library member who can update
;; this script]
;; =================================================
;; ===============================================
;; email address(es) have been munged to protect
;; them from spam harvesters.
;; If you were logged on the email addresses would
;; not be munged
;; ===============================================
REBOL [
    Title: "Dual Column Text"
    Date: 5-Oct-2001/7:22-8:00
    Version: 1.0.0
    File: %dual-col.r
    Author: "Carl Sassenrath"
    Purpose: "Shows an easy way to make dual column text."
    Email: %carl--pacific--net
    Web: http://www.rebol.com
    library: [
        level: 'intermediate 
        platform: none 
        type: none 
        domain: [GUI] 
        tested-under: none 
        support: none 
        license: none 
        see-also: none
    ]
]

page-width: 800

size-lay: layout [sizer: text]

split-text: func [text width /local size] [
    ; Used for column sizing. Returns second column break and column height.
    sizer/text: text
    sizer/size/x: width
    sizer/line-list: none
    size: size-text sizer
    offset-to-caret sizer size / 2 * 0x1
]

make-cols: func [content width /local where] [
    ; Returns a face that holds both columns
    where: split-text content width
    layout [
        across origin 0 backcolor snow
        text as-is width copy/part content where
        text as-is width copy where
    ]
]

make-body: func [titl byline date content /local out bx] [
    ; Returns a face that has title, byline, date, and columns.
    body: make-cols content page-width / 2
    body/offset: 0x0
    out: layout [
        origin 15 space 4x10
        backcolor snow
        h1 titl
        h4 reform ["By" byline "on" date]
        box page-width * 1x0 + 4x3 edge [size: 1x1 color: gray effect: 'bevel]
        bx: box body/size
    ]
    bx/pane: body
    out
]

view make-body "Dual Column Layout Example" "Carl Sassenrath"
    system/script/header/date read %dual-col.r                                                    