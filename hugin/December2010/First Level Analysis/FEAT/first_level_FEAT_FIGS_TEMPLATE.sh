/*
Theme Name: Twenty Ten
Theme URI: http://wordpress.org/
Description: The 2010 default theme for WordPress.
Author: the WordPress team
Version: 1.0
Tags: black, blue, white, two-columns, fixed-width, custom-header, custom-background, theme-options, threaded-comments, sticky-post, translation-ready, microformats, rtl-language-support, editor-style
*/


/* Reset default browser CSS. Based on work by Eric Meyer: http://meyerweb.com/eric/tools/css/reset/index.html
-------------------------------------------------------------- */

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
	vertical-align: baseline;
	background: transparent;
}
body {
	line-height: 1;
}
h1, h2, h3, h4, h5, h6 {
	font-weight: normal;
	clear: both;
}
ol, ul {
	list-style: none;
}
blockquote {
	quotes: none;
}
blockquote:before, blockquote:after {
	content: '';
	content: none;
}
del {
	text-decoration: line-through;
}
/* tables still need 'cellspacing="0"' in the markup */
table {
	border-collapse: collapse;
	border-spacing: 0;
}
a img { border: none; }



/*
LAYOUT: Two columns
DESCRIPTION: Two-column fixed layout with one sidebar right of content
*/

#container {
	float: left;
	margin: 0 -240px 0 0;
	width: 100%;
}
#content {
	margin: 0 280px 0 20px;
}
#primary,
#secondary {
	float: right;
	overflow: hidden;
	width: 220px;
}
#secondary {
	clear: right;
}
#footer {
	clear: both;
	width: 100%;
}

/*
LAYOUT: One column, no sidebar
DESCRIPTION: One centered column with no sidebar
*/

.one-column #content {
	margin: 0 auto;
	width: 640px;
}

/*
LAYOUT: Full width, no sidebar
DESCRIPTION: Full width content with no sidebar; used for attachment pages
*/

.single-attachment #content {
	margin: 0 auto;
	width: 900px;
}


/* =Fonts
-------------------------------------------------------------- */
body,
input,
textarea,
.page-title span,
.pingback a.url {
	font-family: Georgia, "Bitstream Charter", serif;
}

h3#comments-title,
h3#reply-title,
#access .menu,
#access div.menu ul,
#cancel-comment-reply-link,
.form-allowed-tags,
#site-info,
#site-title,
#wp-calendar,
.comment-meta,
.comment-body tr th,
.comment-body thead th,
.entry-content label,
.entry-content tr th,
.entry-content thead th,
.entry-meta,
.entry-title,
.entry-utility,
#respond label,
.navigation,
.page-title,
.pingback p,
.reply,
.widget-title,
input[type=submit]
{
	font-family: "Helvetica Neue", Arial, Helvetica, "Nimbus Sans L", sans-serif;
}
pre {
	font-family: "Courier 10 Pitch", Courier, monospace;
}
code {
	font-family: Monaco, Consolas, "Andale Mono", "DejaVu Sans Mono", monospace;
}



/* =Structure
-------------------------------------------------------------- */

/* The main theme structure */
#access .menu-header,
div.menu,
#colophon,
#branding,
#main,
#wrapper {
	margin: 0 auto;
	width: 940px;
}
#wrapper {
	background: #fff;
	padding: 0 20px;
}

/* Structure the footer area */
#footer-widget-area {
	overflow: hidden;
}
#footer-widget-area .widget-area {
	float: left;
	margin-right: 20px;
	width: 220px;
}
#footer-widget-area #fourth {
	margin-right: 0;
}
#site-info {
	float: left;
	width: 700px;
	font-weight: bold;
	font-size: 14px;
}
#site-generator {
	float: right;
	width: 220px;
}



/* =Global Elements
-------------------------------------------------------------- */

/* Main global 'theme' and typographic styles  */
body {
	background: #f1f1f1;
}

body,
input,
textarea {
	color: #666;
	font-size: 12px;
	line-height: 18px;
}
hr {
	background-color: #E7E7E7;
	border:0;
	height: 1px;
	margin-bottom: 18px;
	clear:both;
}

/* Text elements */
p {
	margin-bottom: 18px;
}
ul {
	list-style: square;
	margin: 0 0 18px 1.5em;
}
ol {
	list-style: decimal;
	margin: 0 0 18px 1.5em;
}
ol ol {
	list-style:upper-alpha;
}
ol ol ol {
	list-style:lower-roman;
}
ol ol ol ol {
	list-style:lower-alpha;
}
ul ul,
ol ol,
ul ol,
ol ul {
	margin-bottom:0;
}
dl {
	margin:0 0 24px 0;
}
dt {
	font-weight: bold;
}
dd {
	margin-bottom: 18px;
}
strong {
	font-weight: bold;
}
cite,
em,
i {
	font-style: italic;
}
big {
	font-size: 131.25%;
}
ins {
	background: #ffc;
	text-decoration: none;
}
blockquote {
	font-style: italic;
	padding: 0 3em;
}
blockquote cite,
blockquote em,
blockquote i {
	font-style: normal;
}
pre {
	background: #f7f7f7;
	color: #222;
	line-height: 18px;
	margin-bottom: 18px;
	padding: 1.5em;
}
abbr,
acronym {
	border-bottom: 1px dotted #666;
	cursor: help;
}

sup,
sub {
	height: 0;
	line-height: 1;
	vertical-align: baseline;
	position: relative;
}
sup {
	bottom: 1ex;
}
sub {
	top: .5ex;
}
input[type="text"],
textarea {
	padding: 2px;
	background: #f9f9f9;
	border: 1px solid #ccc;
	box-shadow: inset 1px 1px 1px rgba(0,0,0,0.1);
	-moz-box-shadow: inset 1px 1px 1px rgba(0,0,0,0.1);
	-webkit-box-shadow: inset 1px 1px 1px rgba(0,0,0,0.1);
}
a:link {
	color:#0066CC;
}
a:visited {
	color:#743399;
}
a:active,
a:hover {
	color: #FF4B33;
}

/* Text meant only for screen readers */
.screen-reader-text {
	position: absolute;
	left: -9000px;
}



/* =Header
-------------------------------------------------------------- */

#header {
	margin-top: 20px;
	padding: 30px 0 0 0;
}
#site-title {
	float: left;
	margin: 0 0 18px 0;
	width: 700px;
	font-size: 30px;
	line-height: 36px;
}
#site-title a {
	color: #000;
	font-weight: bold;
	text-decoration: none;
}
#site-description {
	clear: right;
	float: right;
	font-style: italic;
	margin: 14px 0 18px 0;
	width: 220px;
}

/* This is the custom header image */
#branding img {
	clear: both;
	border-top: 4px solid #000;
	display: block;
	border-bottom: 1px solid #000;
}



/* =Menu
-------------------------------------------------------------- */

#access {
	background: #000;
	margin: 0 auto;
	width: 940px;
	display:block;
	float:left;
}
#access .menu-header,
div.menu {
	font-size: 13px;
	margin-left: 12px;
}
#access .menu-header ul,
div.menu ul {
	list-style: none;
	margin: 0;
}
#access .menu-header li,
div.menu li {
	float:left;
	position: relative;
}
#access a {
	display:block;
	text-decoration:none;
	color:#aaa;
	padding:0 10px;
	line-height:38px;
}
#access ul ul {
	display:none;
	position:absolute;
	top:38px;
	left:0;
	float:left;
	box-shadow: 0px 3px 3px rgba(0,0,0,0.2);
	-moz-box-shadow: 0px 3px 3px rgba(0,0,0,0.2);
	-webkit-box-shadow: 0px 3px 3px rgba(0,0,0,0.2);
	z-index: 99999;
}
#access ul ul li {
	min-width: 180px;	
}
#access ul ul ul {
	left:100%;
	top:0;
}
#access ul ul a {
	background:#333;
	height:auto;
	line-height:1em;
	padding:10px;
	width: 160px;
}
#access li:hover > a,
#access ul ul :hover > a {
	color:#fff;
	background:#333;
}
#access ul li:hover > ul {
	display:block;
}
#access ul li.current_page_item > a,
#access ul li.current-menu-ancestor > a,
#access ul li.current-menu-item > a,
#access ul li.current-menu-parent > a {
	color: #fff;
}

* html #access ul li.current_page_item a,
* html #access ul li.current-menu-ancestor a,
* html #access ul li.current-menu-item a,
* html #access ul li.current-menu-parent a,
* html #access ul li a:hover {
	color:#fff;
}

/* =Content
-------------------------------------------------------------- */

#main {
	overflow: hidden;
	padding: 40px 0 0 0;
}
#content {
	margin-bottom: 36px;
}
#content,
#content input,
#content textarea {
	color: #444;
	font-size: 16px;
	line-height: 24px;
}
#content p,
#content ul,
#content ol,
#content dd,
#content pre,
#content hr {
	margin-bottom:24px;
}
#content ul ul,
#content ol ol,
#content ul ol,
#content ol ul {
	margin-bottom:0;
}
#content pre,
#content kbd,
#content tt,
#content var {
	font-size: 15px;
	line-height: 21px;
}
#content code {
	font-size: 13px;
}
#content strong,
#content b,
#content dt,
#content th {
	color: #000;
}
#content h1,
#content h2,
#content h3,
#content h4,
#content h5,
#content h6 {
	color: #000;
	margin: 0 0 20px 0;
	line-height: 1.5em;
}
#content table {
	border: 1px solid #e7e7e7;
	text-align: left;
	margin: 0 -1px 24px 0;
	width: 100%;
}
#content tr th,
#content thead th {
	color: #888;
	font-size: 12px;
	font-weight: bold;
	line-height: 18px;
	padding: 9px 24px;
}
#content tr td {
	border-top: 1px solid #e7e7e7;
	padding: 6px 24px;
}
#content tr.odd td {
	background: #F2F7FC;
}
.hentry {
	margin: 0 0 48px 0;
}
.home .sticky {
	background: #F2F7FC;
	border-top: 4px solid #000;
	padding: 18px 20px;
	margin-left: -20px;
	margin-right: -20px;
}
.single .hentry {
	margin: 0 0 36px 0;
}
.page-title {
	color: #000;
	font-size: 14px;
	font-weight: bold;
	margin: 0 0 36px 0;
}
.page-title span {
	color: #444;
	font-size: 16px;
	font-style: italic;
	font-weight: normal;
}
.page-title a:link,
.page-title a:visited {
	color:#888;
	text-decoration: none;
}
.page-title a:active,
.page-title a:hover {
	color: #FF4B33;
}
.entry-title,
.entry-meta {
	clear: left;
	float: left;
	margin-right: 68px;
}
#content .entry-title {
	color: #000;
	font-size: 21px;
	font-weight: bold;
	margin-bottom: 0;
}
.entry-title a:link,
.entry-title a:visited {
	color:#000;
	text-decoration: none;
}
.entry-title a:active,
.entry-title a:hover {
	color: #FF4B33;
}
.entry-meta {
	color: #888;
	font-size: 12px;
}
.entry-meta abbr,
.entry-utility abbr {
	border: none;
}
.entry-meta abbr:hover,
.entry-utility abbr:hover {
	border-bottom: 1px dotted #666;
}
.entry-content,
.entry-summary {
	clear: both;
	padding: 12px 0 0 0;
}
#content .entry-summary p:last-child {
	margin-bottom: 12px;
}
.entry-content fieldset {
	border: 1px solid #E7E7E7;
	margin: 0 0 24px 0;
	padding: 24px;
}
.entry-content fieldset legend {
	background: #fff;
	color: #000;
	font-weight: bold;
	padding: 0 24px;
}
.entry-content input {
	margin: 0 0 24px 0;
}
.entry-content input.file,
.entry-content input.button {
	margin-right: 24px;
}
.entry-content label {
	color: #888;
	font-size: 12px;
}
.entry-content select {
	margin: 0 0 24px 0;
}
.entry-content sup,
.entry-content sub {
	font-size: 10px;
}
.entry-content blockquote.left {
	float: left;
	margin-left: 0;
	margin-right: 24px;
	text-align: right;
	width: 33%;
}
.entry-content blockquote.right {
	float: right;
	margin-left: 24px;
	margin-right: 0;
	text-align: left;
	width: 33%;
}
.page-link {
	color: #000;
	font-weight:bold;
	margin:0 0 22px 0;
	word-spacing:0.5em;
}
.page-link a:link,
.page-link a:visited {
	background: #f1f1f1;
	color:#444;
	font-weight:normal;
	padding:0.5em 0.75em;
	text-decoration:none;
}
.home .sticky .page-link a {
	background: #D9E8F7;
}
.page-link a:active,
.page-link a:hover {
	color: #FF4B33;
}
#entry-author-info {
	background: #F2F7FC;
	border-top: 4px solid #000;
	padding: 18px 20px;
	margin: 24px 0;
	overflow: hidden;
	clear: both;
	font-size: 14px;
	line-height: 20px;
}
#entry-author-info #author-avatar {
	background: #fff;
	border: 1px solid #e7e7e7;
	float: left;
	margin: 0 -104px 0 0;
	padding: 11px;
	height: 60px;
}
#entry-author-info #author-description {
	float: left;
	margin: 0 0 0 104px;
}
#entry-author-info h2 {
	color: #000;
	font-weight: bold;
	font-size: 100%;
	margin-bottom: 0;
}
.entry-utility {
	color: #888;
	font-size: 12px;
	line-height: 18px;
	clear: both;
}
.entry-meta a,
.entry-utility a {
	color: #888;
}
.entry-meta a:hover,
.entry-utility a:hover {
	color: #FF4B33;
}
#content .video-player {
	padding: 0;
}



/* Asides
-------------------------------------------------------------- */

.home #content .category-asides p {
	font-size: 14px;
	line-height: 20px;
	margin-bottom: 10px;
	margin-top:0;
}
.home .hentry.category-asides {
	padding: 0;
}
.home #content .category-asides .entry-content {
	padding-top: 0;
}




/* Gallery listing
-------------------------------------------------------------- */

.category-gallery {
	margin-bottom: 48px;
}
.category-gallery h2 {
	margin-top: 10px;
}
.category-gallery .entry-meta {
}
.category-gallery .size-thumbnail img {
	border: 10px solid #f1f1f1;
	margin-bottom: 0;
}
.category-gallery .gallery-thumb {
	float: left;
	margin-right:20px;
	margin-top: -4px;
}
.home #content .category-gallery .entry-content p {
	display: inline;
}
.home #content .category-gallery .entry-utility {
	padding-top:4px;
}


/* Attachment pages
-------------------------------------------------------------- */

.entry-content .attachment img {
	margin-bottom: 0;
}
.attachment .entry-content .entry-caption {
	font-size: 140%;
	margin-top: 24px;
}
.attachment .entry-content .nav-previous a:before {
	content: '\2190\00a0';
}
.attachment .entry-content .nav-next a:after {
	content: '\00a0\2192';
}



/* Images
-------------------------------------------------------------- */

#content img {
	margin: 0;
	max-width: 640px;
}
.single-attachment #content img {
	max-width: 900px;
}
#content .alignleft,
#content img.alignleft {
	display: inline;
	float: left;
	margin-right: 24px;
	margin-top: 4px;
}
#content .alignright,
#content img.alignright {
	display: inline;
	float: right;
	margin-left: 24px;
	margin-top: 4px;
}
#content .aligncenter,
#content img.aligncenter {
	clear: both;
	display: block;
	margin-left: auto;
	margin-right: auto;
}
#content img.alignleft, 
#content img.alignright, 
#content img.aligncenter {
	margin-bottom: 12px;
}
#content .wp-caption {
	background: #f1f1f1;
	color: #888;
	font-size: 12px;
	line-height: 18px;
	text-align: center;
	margin-bottom: 20px;
	padding: 4px;
}
#content .wp-caption img {
	margin: 5px;
}
#content .wp-caption p.wp-caption-text {
	margin: 0 0 4px;
}
#content .wp-smiley {
	margin:0;
}
#content .gallery {
	margin: auto;
}
#content .gallery .gallery-item {
	float: left;
	margin-top: 0;
	text-align: center;
	width: 33%;
}
#content .gallery img {
	border: 2px solid #cfcfcf;
}
#content .gallery .gallery-caption {
	color: #888;
	font-size: 12px;
	margin: 0 0 12px;
}
#content .gallery dl {
	margin: 0;
}
#content .gallery img {
	border: 10px solid #f1f1f1;
}
#content .gallery br+br {
	display: none;
}



/* =Navigation
-------------------------------------------------------------- */

.navigation {
	font-size:  12px;
	line-height: 18px;
	overflow: hidden;
	color: #888;
}
.navigation a:link,
.navigation a:visited {
	color: #888;
	text-decoration: none;
}
.navigation a:active,
.navigation a:hover {
	color: #FF4B33;
}
.nav-previous {
	float: left;
	width: 50%;
}
.nav-next {
	float: right;
	width: 50%;
	text-align:right;
}
#nav-above {
	margin: 0 0 18px 0;
}
#nav-above {
	display: none;
}
.paged #nav-above,
.single #nav-above {
	display: block;
}
#nav-below {
	margin: -18px 0 0 0;
}



/* =Comments
-------------------------------------------------------------- */

#comments .navigation {
	padding: 0 0 18px 0;
}
h3#comments-title,
h3#reply-title {
	color: #000;
	font-weight: bold;
	font-size: 20px;
	margin-bottom: 0;
}
h3#comments-title {
	padding: 24px 0;
}
.commentlist {
	list-style: none;
	margin: 0;
}
.commentlist li.comment {
	border-bottom: 1px solid #e7e7e7;
	line-height: 24px;
	margin: 0 0 24px 0;
	padding: 0 0 0 56px;
	position: relative;
}
.commentlist li:last-child {
	border-bottom:none;
	margin-bottom:0;
}
#comments .comment-body ul,
#comments .comment-body ol {
	margin-bottom: 18px;
}
#comments .comment-body p:last-child {
	margin-bottom: 6px;
}
#comments .comment-body blockquote p:last-child {
	margin-bottom: 24px;
}
.commentlist ol {
	list-style: decimal;
}
.commentlist .avatar {
	position: absolute;
	top: 4px;
	left: 0;
}
.comment-author {
}
.comment-author cite {
	color: #000;
	font-style: normal;
	font-weight: bold;
}
.comment-author .says {
	font-style: italic;
}
.comment-meta {
	font-size: 12px;
	margin: 0 0 18px 0;
}
.comment-meta a:link,
.comment-meta a:visited {
	color: #888;
	text-decoration: none;
}
.comment-meta a:active,
.comment-meta a:hover {
	color: #FF4B33;
}
.commentlist .even {
}
.commentlist .bypostauthor {
}
.reply {
	font-size: 12px;
	padding: 0 0 24px 0;
}
.reply a,
a.comment-edit-link {
	color: #888;
}
.reply a:hover,
a.comment-edit-link:hover {
	color: #FF4B33;
}
.commentlist .children {
	list-style: none;
	margin: 0;
}
.commentlist .children li {
	border: none;
	margin: 0;
}
.nocomments {
	display: none;
}
#comments .pingback {
	margin-bottom: 18px;
	padding-bottom: 18px;
	border-bottom: 1px solid #e7e7e7;
}
.commentlist li.comment+li.pingback {
	margin-top: -6px;
}
#comments .pingback p {
	color: #888;
	font-size: 12px;
	line-height: 18px;
	display:block;
	margin: 0;
}
#comments .pingback .url {
	font-style: italic;
	font-size: 13px;
}



/* Comments form */
input[type=submit] {
	color: #333;
}
#respond {
	margin-top: 24px;
	border-top: 1px solid #e7e7e7;
	overflow: hidden;
	position: relative;
}
#respond p {
	margin: 0;
}
#respond .comment-notes {
	margin-bottom: 1em;
}
.form-allowed-tags {
	line-height: 1em;
}
.children #respond {
	margin: 0 48px 0 0;
}
h3#reply-title {
	margin: 18px 0;
}
#comments-list #respond {
	margin: 0 0 18px 0;
}
#comments-list ul #respond {
	margin: 0;
}
#cancel-comment-reply-link {
	font-size: 12px;
	line-height: 18px;
	font-weight: normal;
}
#respond .required {
	color:#FF4B33;
	font-weight:bold;
}
#respond label {
	color: #888;
	font-size: 12px;
}
#respond input {
	margin:0 0 9px;
	width:98%;
}
#respond textarea {
	width:98%;
}
#respond .form-allowed-tags {
	color: #888;
	font-size: 12px;
	line-height: 18px;
}
#respond .form-allowed-tags code {
	font-size: 11px;
}
#respond .form-submit {
	margin: 0 0 24px;
}
#respond .form-submit input {
	width: auto;
	font-size: 14px;
}
#respond dl {
	margin: 0 0 10px;
}
#respond dt {
	 display: inline;
	font-weight: normal;
}
#respond dd {
	display: inline;
}


/* =Widget Areas
-------------------------------------------------------------- */

.widget-area ul {
	list-style: none;
	margin-left: 0;
}
.widget-area ul ul {
	list-style: square;
	margin-left: 1.3em;
}
.widget_search #s { /* This keeps the search inputs in line */
	width: 60%;
}
.widget_search label {
	display:none;
}
.widget-container {
	margin: 0 0 18px 0;
}
.widget-title {
	color: #222;
	font-weight: bold;
}
.widget-area a:link,
.widget-area a:visited {
	text-decoration: none;
}
.widget-area a:active,
.widget-area a:hover {
	text-decoration: underline;
}
.widget-area .entry-meta {
	font-size: 11px;
}
#wp_tag_cloud div {
	line-height: 1.6em;
}
#wp-calendar {
	width:100%;
}
#wp-calendar caption {
	font-weight: bold;
	color: #222;
	text-align: left;
	font-size:14px;
	padding-bottom: 4px;
}
#wp-calendar thead {
	font-size:11px;
}
#wp-calendar thead th {
}
#wp-calendar tbody {
	color: #aaa;
}
#wp-calendar tbody td {
	padding: 3px 0 2px;
	background: #f5f5f5;
	border:1px solid #fff;
	text-align: center;
}
#wp-calendar tbody .pad {
	background: none;
}
#wp-calendar tfoot #next {
	text-align: right;
}
.widget_rss a.rsswidget {
	color: #000;
}
.widget_rss a.rsswidget:hover {
	color: #FF4B33;
}
.widget_rss .widget-title img {
	height: 11px;
	width: 11px;
}

/* Main sidebars */
#main .widget-area ul {
	margin-left: 0;
	padding: 0 20px 0 0;
}
#main .widget-area ul ul {
	border: none;
	margin-left: 1.3em;
	padding: 0;
}
#primary {
}
#secondary {
}

/* Footer widget areas */
#footer-widget-area {
}



/* =Footer
-------------------------------------------------------------- */

#footer {
	margin-bottom: 20px;
}
#colophon {
	border-top: 4px solid #000;
	margin-top: -4px;
	padding: 18px 0;
	overflow: hidden;
}
#site-info {
	font-weight: bold;
}
#site-info a {
	color: #000;
	text-decoration: none;
}
#site-generator {
	position: relative;
	font-style: italic;
}
#site-generator a {
	color: #666;
	display:inline-block;
	text-decoration: none;
	background: url(images/wordpress.png) center left no-repeat;
	padding-left: 20px;
	line-height: 16px;
}
#site-generator a:hover {
	text-decoration: underline;
}
img#wpstats {
	display:block;
	margin: 0 auto 10px;
}



/* Mobile Safari ( iPad, iPhone and iPod Touch )
-------------------------------------------------------------- */

pre {
	-webkit-text-size-adjust: 140%;
}
code {
	-webkit-text-size-adjust: 160%;
}
#access,
.entry-meta,
.entry-utility,
.navigation,
.widget-area {
	-webkit-text-size-adjust: 120%;
}
#site-description {
	-webkit-text-size-adjust: none;
}



/* =Print Style
-------------------------------------------------------------- */

@media print {
	body {
		background:none !important;
	}
	#wrapper {
		float: none !important;
		clear: both !important;
		display: block !important;
		position: relative !important;
	}
	#header {
		border-bottom: 2pt solid #000;
		padding-bottom: 18pt;
	}
	#colophon {
		border-top: 2pt solid #000;
	}
	#site-title,
	#site-description {
		float: none;
		margin: 0;
		padding:0;
		line-height: 1.4em;
	}
	#site-title {
		font-size: 13pt;
	}
	.entry-content {
		font-size: 14pt;
		line-height: 1.6em;
	}
	.entry-title {
		font-size: 21pt;
	}
	#access,
	#branding img,
	#respond,
	.comment-edit-link,
	.edit-link,
	.navigation,
	.page-link,
	.widget-area {
		display: none !important;
	}
	#container,
	#header,
	#footer {
		width: 100%;
		margin: 0;
	}
	#content,
	.one-column #content {
		width: 100%;
		margin: 24pt 0 0;
	}
	.wp-caption p {
		font-size: 11pt;
	}
	#site-info,
	#site-generator {
		float: none;
		width: auto;
	}
	#colophon {
		width: auto;
	}
	img#wpstats {
		display:none
	}
	#site-generator a {
		padding: 0;
	margin: 0;
	}
	#entry-author-info {
		border: 1px solid #e7e7e7;
	}
	#main {
		display:inline;
	}
	.home .sticky {
		border: none;
	}
}
