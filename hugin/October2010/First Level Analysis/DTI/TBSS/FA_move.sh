/*
    ColorBox Core Style
    The following rules are the styles that are consistant between themes.
    Avoid changing this area to maintain compatability with future versions of ColorBox.
*/
#colorbox, #cboxOverlay, #cboxWrapper{position:absolute; top:0; left:0; z-index:9999; overflow:hidden;}
#cboxOverlay{position:fixed; width:100%; height:100%;}
#cboxMiddleLeft, #cboxBottomLeft{clear:left;}
#cboxContent{position:relative; overflow:hidden;}
#cboxLoadedContent{overflow:auto;}
#cboxLoadedContent iframe{display:block; width:100%; height:100%; border:0;}
#cboxTitle{margin:0;}
#cboxLoadingOverlay, #cboxLoadingGraphic{position:absolute; top:0; left:0; width:100%;}
#cboxPrevious, #cboxNext, #cboxClose, #cboxSlideshow{cursor:pointer;}
/* 
    ColorBox example user style
    The following rules are ordered and tabbed in a way that represents the
    order/nesting of the generated HTML, so that the structure easier to understand.
*/
#cboxOverlay{background:#fff;}

#colorBox{}
    #cboxTopLeft{width:25px; height:25px; background:url(images/border1.png) 0 0 no-repeat;}
    #cboxTopCenter{height:25px; background:url(images/border1.png) 0 -50px repeat-x;}
    #cboxTopRight{width:25px; height:25px; background:url(images/border1.png) -25px 0 no-repeat;}
    #cboxBottomLeft{width:25px; height:25px; background:url(images/border1.png) 0 -25px no-repeat;}
    #cboxBottomCenter{height:25px; background:url(images/border1.png) 0 -75px repeat-x;}
    #cboxBottomRight{width:25px; height:25px; background:url(images/border1.png) -25px -25px no-repeat;}
    #cboxMiddleLeft{width:25px; background:url(images/border2.png) 0 0 repeat-y;}
    #cboxMiddleRight{width:25px; background:url(images/border2.png) -25px 0 repeat-y;}
    #cboxContent{background:#fff;}
        #cboxLoadedContent{margin-bottom:20px; }
        #cboxTitle{position:absolute; bottom:0px; left:0; text-align:center; width:100%; color:#999; }
        #cboxCurrent{position:absolute; bottom:0px; left:100px; color:#999;}
        #cboxSlideshow{position:absolute; bottom:0px; right:42px; color:#444;}
        #cboxPrevious{position:absolute; bottom:0px; left:0; color:#444;}
        #cboxNext{position:absolute; bottom:0px; left:63px; color:#444;}
        #cboxLoadingOverlay{background:url(images/loading.gif) 5px 5px no-repeat #fff;}
        #cboxClose{position:absolute; bottom:0; right:0; display:block; color:#444;}


