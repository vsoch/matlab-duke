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
#cboxOverlay{background:#000;}

#colorbox{}
    #cboxContent{background:#000; margin-top:20px;}
        #cboxLoadedContent{background:#000; padding:5px;}
        #cboxTitle{position:absolute; top:-20px; left:0; color:#ccc;}
        #cboxCurrent{position:absolute; top:-20px; right:0px; color:#ccc;}
        #cboxSlideshow{position:absolute; top:-20px; right:90px; color:#fff;}
        #cboxPrevious{position:absolute; top:50%; left:5px; margin-top:-32px; background:url(images/controls.png) top left no-repeat; width:28px; height:65px; text-indent:-9999px;}
        #cboxPrevious.hover{background-position:bottom left;}
        #cboxNext{position:absolute; top:50%; right:5px; margin-top:-32px; background:url(images/controls.png) top right no-repeat; width:28px; height:65px; text-indent:-9999px;}
        #cboxNext.hover{background-position:bottom right;}
        #cboxLoadingOverlay{background:#000;}
        #cboxLoadingGraphic{background:url(images/loading.gif) center center no-repeat;}
        #cboxClose{position:absolute; top:5px; right:5px; display:block; background:url(images/controls.png) top center no-repeat; width:38px; height:19px; text-indent:-9999px;}
        #cboxClose.hover{background-position:bottom center;}