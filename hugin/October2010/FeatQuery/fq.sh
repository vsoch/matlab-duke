/*
    ColorBox Core Style
    The following rules are the styles that are consistant between all ColorBox themes
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
    These rules are ordered and tabbed in a way that represents the order/nesting of the generated HTML, 
    in hope that this will make the relationship easier to understand. Thanks, jack@colorpowered.com
*/
#cboxOverlay{background:#303;}

#colorbox{}
    #cboxContent{background:#303; margin-top:20px;}
        #cboxBottomCenter{height:30px; background:#303;}
        #cboxLoadedContent{background:#303; padding:5px;}
                #cboxTitle{position:absolute; bottom:-25px; left:5px; color:#ccc;}
                #cboxCurrent{position:absolute; bottom:-25px; right:35px; color:#ccc;}
                #cboxSlideshow{position:absolute; top:-20px; right:90px; color:#fff;}
                #cboxPrevious{position:absolute; top:50%; left:5px; margin-top:-41px; background-image: url(data:image/gif;base64,AAAA); width:49%; height:100%; text-indent:-9999px;}
                #cboxPrevious.hover{background-position:bottom left; background:url(images/prevpurple.png) top left no-repeat;}
                #cboxNext{position:absolute; top:50%; right:5px; margin-top:-41px; background-image: url(data:image/gif;base64,AAAA); width:49%; height:100%; text-indent:-9999px;}
                #cboxNext.hover{background-position:bottom right; background:url(images/nextpurple.png) top right no-repeat;}
                #cboxLoadingOverlay{background:#303;}
        #cboxLoadingGraphic{background:url(images/loading.gif) center center no-repeat;}
        #cboxClose{position:absolute; bottom:-25px; right:5px; display:block; background:url(images/close.png) top center no-repeat; width:22px; height:22px; text-indent:-9999px;}
        #cboxClose.hover{background-position:bottom center;}