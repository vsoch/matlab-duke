/*
    ColorBox Core Style
    The following rules are the styles that are consistant between themes.
    Avoid changing this area to maintain compatability with future versions of ColorBox.
*/
#colorbox, #cboxOverlay, #cboxWrapper{position:absolute; top:0; left:0; z-index:9999; overflow:hidden;}
#cboxOverlay{position:fixed; width:100%; height:100%;}
#cboxMiddleLeft, #cboxBottomLeft{clear:left;}
#cboxContent{position:relative; overflow:visible;}
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

#colorbox{}
    #cboxContent{margin-top:32px;}
        #cboxLoadedContent{background:#000; padding:1px;}
        #cboxLoadingGraphic{background:url(images/loading.gif) center center no-repeat;}
        #cboxLoadingOverlay{background:#000;}
        #cboxTitle{position:absolute; top:-22px; left:0; color:#000;}
        #cboxCurrent{position:absolute; top:-22px; right:205px; text-indent:-9999px;}
        #cboxSlideshow, #cboxPrevious, #cboxNext, #cboxClose{text-indent:-9999px; width:20px; height:20px; position:absolute; top:-20px; background:url(images/controls.png) 0 0 no-repeat;}
        #cboxPrevious{background-position:0px 0px; right:44px;}
        #cboxPrevious.hover{background-position:0px -25px;}
        #cboxNext{background-position:-25px 0px; right:22px;}
        #cboxNext.hover{background-position:-25px -25px;}
        #cboxClose{background-position:-50px 0px; right:0;}
        #cboxClose.hover{background-position:-50px -25px;}
        .cboxSlideshow_on #cboxPrevious, .cboxSlideshow_off #cboxPrevious{right:66px;}
        .cboxSlideshow_on #cboxSlideshow{background-position:-75px -25px; right:44px;}
        .cboxSlideshow_on #cboxSlideshow.hover{background-position:-100px -25px;}
        .cboxSlideshow_off #cboxSlideshow{background-position:-100px 0px; right:44px;}
        .cboxSlideshow_off #cboxSlideshow.hover{background-position:-75px -25px;}
