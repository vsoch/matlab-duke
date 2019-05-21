/* http://meyerweb.com/eric/tools/css/reset/ */
/* v1.0 | 20080212 */

html, body, div, span, applet, object, iframe,
h1, h2, h3, h4, h5, h6, p, blockquote, pre,
a, abbr, acronym, address, big, cite, code,
del, dfn, em, font, img, ins, kbd, q, s, samp,
small, strike, strong, sub, sup, tt, var,
b, u, i, center,
dl, dt, dd, ol, ul, li,
fieldset, form, label, legend,
table, caption, tbody, tfoot, thead, tr, th, td {
	margin: 0;
	padding: 0;
	border: 0;
	outline: 0;
/*	font-size: 100%;
	vertical-align: baseline; */
	background: transparent;
}
body {
	line-height: 1;
}
ol, ul {
	list-style: none;
}
blockquote, q {
	quotes: none;
}
blockquote:before, blockquote:after,
q:before, q:after {
	content: '';
	content: none;
}

/* remember to define focus styles! */
/*
:focus {
	outline: 0;
}
*/
/* remember to highlight inserts somehow! */
ins {
	text-decoration: none;
}
del {
	text-decoration: line-through;
}

/* tables still need 'cellspacing="0"' in the markup */
/*
table {
	border-collapse: collapse;
	border-spacing: 0;
}
*/
/* end reset css */


/* 2 column liquid layout */
#wpwrap {
	height: auto;
	min-height: 100%;
	width: 100%;
}

#wpcontent {
	height: 100%;
	padding-bottom: 50px;
}

#wpbody {
	clear: both;
	margin-left: 175px;
}

.folded #wpbody {
	margin-left: 60px;
}

#wpbody-content {
	float: left;
	width: 100%;
}

#adminmenu {
	float: left;
	clear: left;
	width: 145px;
	margin-top: 15px;
	margin-right: 5px;
	margin-bottom: 15px;
	margin-left: -160px;
	position: relative;
	padding: 0;
	list-style: none;
}

.folded #adminmenu {
	margin-left: -45px;
}

.folded #adminmenu,
.folded #adminmenu li.menu-top {
	width: 28px;
}

#footer {
	clear: both;
	position: relative;
	width: 100%;
}

/* inner 2 column liquid layout */
.inner-sidebar {
	float: right;
	clear: right;
	display: none;
	width: 281px;
	position: relative;
}

.inner-sidebar #side-sortables {
	width: 280px;
	min-height: 300px;
}

.has-right-sidebar .inner-sidebar {
	display: block;
}

.has-right-sidebar #post-body {
	float: left;
	clear: left;
	width: 100%;
	margin-right: -340px;
}

.has-right-sidebar #post-body-content {
	margin-right: 300px;
}

/* 2 columns main area */

#col-container {
	overflow: hidden;
	padding: 0;
	margin: 0;
}

#col-left {
	padding: 0;
	margin: 0;
	overflow: hidden;
	width: 39%;
}

#col-right {
	float: right;
	clear: right;
	overflow: hidden;
	padding: 0;
	margin: 0;
	width: 59%;
}

/* utility classes */
.alignleft {
	float: left;
}

.alignright {
	float: right;
}

.textleft {
	text-align: left;
}

.textright {
	text-align: right;
}

.clear {
	clear: both;
}

/* Hide visually but not from screen readers */
.screen-reader-text,
.screen-reader-text span {
	position: absolute;
	left: -1000em;
	height: 1px;
	width: 1px;
	overflow: hidden;
}

.hidden,
.js .closed .inside,
.js .hide-if-js,
.no-js .hide-if-no-js {
	display: none;
}

/* include margin and padding in the width calculation of input and textarea */
input[type="text"],
input[type="password"],
textarea {
	-moz-box-sizing: border-box;
	-webkit-box-sizing: border-box;
	-ms-box-sizing: border-box; /* ie8 only */
	box-sizing: border-box;
}

input[type="checkbox"],
input[type="radio"] {
	vertical-align: middle;
}

/* styles for use by people extending the WordPress interface */
html,
body {
	height: 100%;
}

body,
td,
textarea,
input,
select {
	font-family: "Lucida Grande", Verdana, Arial, "Bitstream Vera Sans", sans-serif;
	font-size: 13px;
}

body,
textarea {
	line-height: 1.4em;
}

input,
select {
	line-height: 15px;
}

p {
	margin: 1em 0;
}

blockquote {
	margin: 1em;
}

label {
	cursor: pointer;
}

li,
dd {
	margin-bottom: 6px;
}

p,
li,
dl,
dd,
dt {
	line-height: 140%;
}

textarea,
input,
select {
	margin: 1px;
	padding: 3px;
}

h1 {
  display: block;
  font-size: 2em;
  font-weight: bold;
  margin: .67em 0;
}

h2 {
  display: block;
  font-size: 1.5em;
  font-weight: bold;
  margin: .83em 0;
}

h3 {
  display: block;
  font-size: 1.17em;
  font-weight: bold;
  margin: 1em 0;
}

h4 {
  display: block;
  font-size: 1em;
  font-weight: bold;
  margin: 1.33em 0;
}

h5 {
  display: block;
  font-size: 0.83em;
  font-weight: bold;
  margin: 1.67em 0;
}

h6 {
  display: block;
  font-size: 0.67em;
  font-weight: bold;
  margin: 2.33em 0;
}

ul.ul-disc {
	list-style: disc outside;
}

ul.ul-square {
	list-style: square outside;
}

ol.ol-decimal {
	list-style: decimal outside;
}

ul.ul-disc,
ul.ul-square,
ol.ol-decimal {
	margin-left: 1.8em;
}

ul.ul-disc > li,
ul.ul-square > li,
ol.ol-decimal > li {
	margin: 0 0 0.5em;
}

.subsubsub {
	list-style: none;
	margin: 8px 0 5px;
	padding: 0;
	white-space: nowrap;
	font-size: 11px;
	float: left;
}

.subsubsub a {
	line-height: 2;
	padding: .2em;
	text-decoration: none;
}

.subsubsub a .count, .subsubsub a.current .count {
	color: #999;
	font-weight: normal;
}

.subsubsub a.current {
	font-weight: bold;
	background: none;
	border: none;
}

.subsubsub li {
	display: inline;
	margin: 0;
	padding: 0;
}

.widefat {
	border-width: 1px;
	border-style: solid;
	border-spacing: 0;
	width: 100%;
	clear: both;
	margin: 0;
	-moz-border-radius: 4px;
	-khtml-border-radius: 4px;
	-webkit-border-radius: 4px;
	border-radius: 4px;
}

.widefat * {
	word-wrap: break-word;
}

.widefat a {
	text-decoration: none;
}

.widefat td,
.widefat th {
	border-bottom-width: 1px;
	border-bottom-style: solid;
	font-size: 11px;
}

.widefat td {
	padding: 3px 7px;
	vertical-align: top;
}

.widefat td p,
.widefat td ol,
.widefat td ul {
	font-size: 11px;
}

.widefat th {
	padding: 7px 7px 8px;
	text-align: left;
	line-height: 1.3em;
}

.widefat th input {
	margin: 0 0 0 8px;
	padding: 0;
	vertical-align: text-top;
}

.widefat .check-column {
	width: 2.2em;
	padding: 0;

}

.widefat tbody th.check-column {
	padding: 7px 0 22px;
	vertical-align: top;
}

.widefat .num,
.column-comments,
.column-links,
.column-posts {
	text-align: center;
}

.widefat th#comments {
	vertical-align: middle;
}

.wrap {
	margin: 0 15px 0 5px;
}

.updated,
.error {
	border-width: 1px;
	border-style: solid;
	padding: 0 0.6em;
	margin: 5px 15px 2px;
	-moz-border-radius: 3px;
	-khtml-border-radius: 3px;
	-webkit-border-radius: 3px;
	border-radius: 3px;
}

.updated p,
.error p {
	margin: 0.5em 0;
	line-height: 1;
	padding: 2px;
}

.wrap .updated,
.wrap .error {
	margin: 5px 0 15px;
}

.wrap h2 {
	font: italic normal normal 24px/29px Georgia, "Times New Roman", "Bitstream Charter", Times, serif;
	margin: 0;
	padding: 14px 15px 3px 0;
	line-height: 35px;
	text-shadow: rgba(255,255,255,1) 0 1px 0;
}

.wrap h2.long-header {
	padding-right: 0;
}
