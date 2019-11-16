REBOL [
    Title: "Gradient Colorize Examples"   
    Author:   ["Tesserator" "Massimiliano Vessi"]
    Purpose: {Trying to Auto DL weather maps on 30min. intervals from: http://wwwghcc.msfc.nasa.gov/ }
    Email: jimbo@sc.starcat.ne.jp   
]     
nasa_url:   http://wwwghcc.msfc.nasa.gov
update_img: does [
    flash "Fetching image..."
    img: read   http://weather.msfc.nasa.gov/GOES/goeseastfullir.html
    parse img [thru {TYPE="image" src="}   copy img   to {"}   to end ]
    img: load (join   nasa_url img)
    ; this way img2 is loaded just one time
    if not value? 'img2   [img2: load http://weather.msfc.nasa.gov/GOES/colorbarvert.gif ]
    unview
    ]
update_img
view layout [
    h1   "GOES East Interactive Infrared Weather Satellite Image Viewer"
    text "Image automatically updated every 30 minutes"
    across
    image img rate 00:30 feel [ engage: func [face action event] [
        update_img
        face/image: img
        show face
        ] ]
    image img2   
    ]
