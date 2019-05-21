body {
	font: 13px "Lucida Grande",Verdana,Arial,"Bitstream Vera Sans",sans-serif;
	color: #333;
	margin: 0;
	padding: 0;
	min-width: 675px;
	min-height: 400px;
}

img {
	border: none;
}

/* Header */
#wphead {
	border-top: none;
	padding-top: 4px;
	background: #444 !important;
}

.tagchecklist span a {
	background: transparent url(../images/xit.gif) no-repeat 0 0;
}

#poststuff #edButtonPreview,
#poststuff #edButtonHTML {
	-moz-border-radius: 3px 3px 0 0;
	-webkit-border-top-right-radius: 3px;
	-webkit-border-top-left-radius: 3px;
	-khtml-border-top-right-radius: 3px;
	-khtml-border-top-left-radius: 3px;
	border-top-right-radius: 3px;
	border-top-left-radius: 3px;
	border-style: solid;
	border-width: 1px;
	cursor: pointer;
	display: block;
	height: 18px;
	margin: 0 5px 0 0;
	padding: 0 5px 0;
	font-size: 10px;
	line-height: 18px;
	float: left;
}

.howto {
	margin-top: 2px;
	margin-bottom: 3px;
	font-size: 11px;
	font-style: italic;
	display: block;
}

input.text {
	outline-color: -moz-use-text-color;
	outline-style: none;
	outline-width: medium;
	width: 100%;
}

#message {
	-moz-border-radius: 6px;
	-khtml-border-radius: 6px;
	-webkit-border-radius: 6px;
	border-radius: 6px;
}

/* Editor/Main Column */
div#poststuff {
	margin: 10px;
}

div.zerosize {
	border: 0 none;
	height: 0;
	margin: 0;
	overflow: hidden;
	padding: 0;
	width: 0;
}

#poststuff #edButtonPreview.active,
#poststuff #edButtonHTML.active {
	display: none;
}

.posting {
	margin-right: 212px;
	position: relative;
}

#side-info-column {
	float: right;
	width: 200px;
	position: relative;
	right: 0;
}

#side-info-column .sleeve {
	padding-top: 5px;
}

#poststuff .inside {
	font-size: 11px;
	margin: 8px;
}

#poststuff h2,#poststuff h3 {
	font-size: 12px;
	font-weight: bold;
	line-height: 1;
	margin: 0;
	padding: 7px 9px;
}

#tagsdiv-post_tag h3,
#categorydiv h3 {
	cursor: pointer;
}

h3.tb {
	text-shadow: 0 1px 0 #fff;
	font-weight: bold;
	font-size: 12px;
	margin-left: 5px;
}

#TB_window {
	border: 1px solid #333;
	-moz-border-radius: 6px;
	-khtml-border-radius: 6px;
	-webkit-border-radius: 6px;
	border-radius: 6px;
}

.postbox,
.stuffbox {
	margin-bottom: 10px;
	border-width: 1px;
	border-style: solid;
	line-height: 1;
	-moz-border-radius: 6px;
	-khtml-border-radius: 6px;
	-webkit-border-radius: 6px;
	border-radius: 6px;
}

.postbox:hover .handlediv,
.stuffbox:hover .handlediv {
	background: transparent url(../images/menu-bits-vs.gif) no-repeat scroll left -111px;
}

.handlediv {
	float: right;
	height: 26px;
	width: 23px;
}

#title,
.tbtitle {
	-moz-border-radius: 6px;
	-khtml-border-radius: 6px;
	-webkit-border-radius: 6px;
	border-radius: 6px;
	border-style: solid;
	border-width: 1px;
	font-size: 1.7em;
	outline: none;
	padding: 3px 4px;
	border-color: #dfdfdf;
}

.tbtitle {
	font-size: 12px;
	padding: 3px;
}

#title {
	width: 97%;
}

.editor-container {
	-moz-border-radius: 6px;
	-khtml-border-radius: 6px;
	-webkit-border-radius: 6px;
	border-radius: 6px;
	border: 1px solid #dfdfdf;
	background-color: #fff;
}

.postdivrich {
	padding-top: 25px;
	position: relative;
}

.actions {
	float: right;
	margin: -19px 0 0;
}

#extra-fields .actions {
	margin: -15px -5px 0 0;
}

.actions li {
	float: left;
	list-style: none;
	margin-right: 10px;
}

#extra-fields .button {
	margin-right: 5px;
	padding: 3px 6px;
	border-radius: 10px;
	-webkit-border-radius: 10px;
	-khtml-border-radius: 10px;
	-moz-border-radius: 10px;
}

/* Photo Styles */
.photolist {
	margin-top: -10px;
}

#photo_saving {
	margin: 0 8px 8px;
	vertical-align: middle;
}

#img_container {
	background-color: #fff;
}

#img_container_container {
	overflow: auto;
}

#extra-fields {
	margin-top: 10px;
	position: relative;
}

#waiting {
	margin-top: 10px;
}

#extra-fields .postbox {
	margin-bottom: 5px;
}

#extra-fields .titlewrap {
	padding: 0;
	overflow: auto;
	height: 100px;
}

#img_container a {
	display: block;
	float: left;
	overflow: hidden;
	vertical-align: center;
}

#img_container img,
#img_container a {
	width: 68px;
	height: 68px;
}

#img_container img {
	border: none;
	background-color: #f4f4f4;
	cursor: pointer;
}

#img_container a,
#img_container a:link,
#img_container a:visited {
	border: 1px solid #ccc;
	display: block;
	position: relative;
}

#img_container a:hover,
#img_container a:active {
	border-color: #000;
	z-index: 1000;
	border-width: 2px;
	margin: -1px;
}

/* Video */
#embed-code {
	width: 100%;
	height: 98px;
}

/* Submit Column */
#viewsite {
	padding: 0;
	margin: 0 0 20px 5px;
	font-size: 10px;
	clear: both;
}

.wp-hidden-children
.wp-hidden-child {
	display: none;
}

/* Categories */

.category-add input {
	width: 94%;
	font-family: "Lucida Grande",Verdana,Arial,"Bitstream Vera Sans",sans-serif;
	font-size: 12px;
	margin: 1px;
}

.category-add select {
	width: 100%;
	-x-system-font: none;
	border-style: solid;
	border-width: 1px;
	font-family: "Lucida Grande","Bitstream Vera Sans",Verdana,Arial,sans-serif;
	font-size: 11px;
	height: 2em;
	line-height: 20px;
	padding: 2px;
	margin: 1px;
	vertical-align: top;
}

.category-add input.category-add-sumbit {
	width: auto;
}

.categorydiv div.tabs-panel,
#linkcategorydiv div.tabs-panel {
	height: 100px;
	overflow: auto;
	padding: 0.5em 0.9em;
	border-style: solid;
	border-width: 1px;
}

.category-tabs li {
	display: inline;
	padding-right: 8px;
}

.category-tabs a {
	text-decoration: none;
}

.categorydiv ul,
#linkcategorydiv ul {
	list-style: none;
	padding: 0;
	margin: 0;
}

.inline-editor ul.cat-checklist ul,
.categorydiv ul.categorychecklist ul,
#linkcategorydiv ul.categorychecklist ul {
	margin-left: 18px;
}

ul.categorychecklist li {
	margin: 0;
	padding: 0;
	line-height: 19px;
}

.categorydiv .tabs-panel {
	border-width: 3px;
	border-style: solid;
}

ul.category-tabs {
	margin-top: 12px;
	margin-bottom: 6px;
}

ul.category-tabs li.tabs {
	border-style: solid solid none;
	border-width: 1px 1px 0;
}

ul.category-tabs li {
	padding: 5px 8px;
	-moz-border-radius: 3px 3px 0 0;
	-webkit-border-top-left-radius: 3px;
	-webkit-border-top-right-radius: 3px;
	-khtml-border-top-left-radius: 3px;
	-khtml-border-top-right-radius: 3px;
	border-top-left-radius: 3px;
	border-top-right-radius: 3px;
}

/* Tags */
.screen-reader-text {
	display: none;
}

.tagsdiv .newtag {
	margin-right: 5px;
}

.jaxtag {
	clear: both;
	margin: 0;
}

.tagadd {
	margin-left: 3px;
}

.tagchecklist {
	margin-top: 3px;
	margin-bottom: 1em;
	font-size: 12px;
	overflow: auto;
}

.tagchecklist strong {
	position: absolute;
	font-size: .75em;
}

.tagchecklist span {
	margin-right: .5em;
	margin-left: 10px;
	display: block;
	float: left;
	font-size: 11px;
	line-height: 1.8em;
	white-space: nowrap;
	cursor: default;
}

.tagchecklist span a {
	margin: 6px 0 0 -9px;
	cursor: pointer;
	width: 10px;
	height: 10px;
	display: block;
	float: left;
	text-indent: -9999px;
	overflow: hidden;
	position: absolute;
}

#content {
	margin: 5px 0;
	padding: 0 5px;
	border: 0 none;
	height: 365px;
	width: 97% !important;
}

* html .postdivrich {
	zoom: 1;
}

/* Submit */
#saving {
	display: inline;
	vertical-align: middle;
}

.submit input,
.button,
.button-primary,
.button-secondary,
.button-highlighted,
#postcustomstuff .submit input {
	font-family: "Lucida Grande",Verdana,Arial,"Bitstream Vera Sans",sans-serif;
	text-decoration: none;
	font-size: 11px !important;
	line-height: 16px;
	padding: 2px 8px;
	cursor: pointer;
	border-width: 1px;
	border-style: solid;
	-moz-border-radius: 11px;
	-khtml-border-radius: 11px;
	-webkit-border-radius: 11px;
	border-radius: 11px;
}

.button-primary {
	background: #21759B url(../images/button-grad.png) repeat-x scroll left top;
	border-color: #21759B;
	color: #fff;
}

.ac_results {
	padding: 0;
	margin: 0;
	list-style: none;
	position: absolute;
	z-index: 10000;
	display: none;
	border-width: 1px;
	border-style: solid;
}

.ac_results li {
	padding: 2px 5px;
	white-space: nowrap;
	text-align: left;
}

.ac_over {
	cursor: pointer;
}

.ac_match {
	text-decoration: underline;
}

#TB_ajaxContent #options {
	position: absolute;
	top: 20px;
	right: 25px;
	padding: 5px;
}

#TB_ajaxContent h3 {
	margin-bottom: .25em;
}

.updated {
	margin: 10px 0;
	padding: 0;
	border-width: 1px;
	border-style: solid;
	width: 99%;
}

.updated p,
.error p {
	margin: 0.6em 0;
	padding: 0 0.6em;
}

.error a {
	text-decoration: underline;
}

.updated a {
	text-decoration: none;
	padding-bottom: 2px;
}

#post_status {
	margin-left: 10px;
	margin-bottom: 1em;
	display: block;
}

/* Footer */
#footer {
	height: 65px;
	display: block;
	width: 640px;
	padding: 10px 0 0 60px;
	margin: 0;
	position: absolute;
	bottom: 0;
	font-size: 12px;
}

#footer p {
	margin: 0;
	padding: 7px 0;
}

#footer p a {
	text-decoration: none;
}

#footer p a:hover {
	text-decoration: underline;
}

/* Utility Classes */
.centered {
	text-align: center;
}

.hidden {
	display: none;
}

.postbox input[type="text"],
.postbox textarea,
.stuffbox input[type="text"],
.stuffbox textarea {
	border-width: 1px;
	border-style: solid;
}

/* tag hints */
.taghint {
	color: #aaa;
	margin: -17px 0 0 7px;
	visibility: hidden;
}

input.newtag ~ div.taghint {
	visibility: visible;
}

input.newtag:focus ~ div.taghint {
	visibility: hidden;
}
