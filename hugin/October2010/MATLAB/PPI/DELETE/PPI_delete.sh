/**
 * SyntaxHighlighter
 * http://alexgorbatchev.com/
 *
 * SyntaxHighlighter is donationware. If you are using it, please donate.
 * http://alexgorbatchev.com/wiki/SyntaxHighlighter:Donate
 *
 * @version
 * 2.0.296 (March 01 2009)
 * 
 * @copyright
 * Copyright (C) 2004-2009 Alex Gorbatchev.
 *
 * @license
 * This file is part of SyntaxHighlighter.
 * 
 * SyntaxHighlighter is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * SyntaxHighlighter is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with SyntaxHighlighter.  If not, see <http://www.gnu.org/licenses/>.
 */
/************************************
 * Default Syntax Highlighter theme.
 * 
 * Interface elements.
 ************************************/

.syntaxhighlighter
{
	background-color: #E7E5DC !important;
}

/* Highlighed line number */
.syntaxhighlighter .line.highlighted .number
{
	background-color: #6CE26C !important;
	color: black !important;
}

/* Highlighed line */
.syntaxhighlighter .line.highlighted.alt1 .content,
.syntaxhighlighter .line.highlighted.alt2 .content
{
	background-color: #6CE26C !important;
}

/* Gutter line numbers */
.syntaxhighlighter .line .number
{
	color: #5C5C5C !important;
}

/* Add border to the lines */
.syntaxhighlighter .line .content
{
	border-left: 3px solid #6CE26C !important;
	color: #000 !important;
}

.syntaxhighlighter.printing .line .content 
{
	border: 0 !important;
}

/* First line */
.syntaxhighlighter .line.alt1 .content
{
	background-color: #fff !important;
}

/* Second line */
.syntaxhighlighter .line.alt2 .content
{
	background-color: #F8F8F8 !important;
}

.syntaxhighlighter .line .content .block
{
	background: url(wrapping.png) 0 1.1em no-repeat !important;
}

.syntaxhighlighter .ruler
{
	color: silver !important;
	background-color: #F8F8F8 !important;
	border-left: 3px solid #6CE26C !important;
}

.syntaxhighlighter.nogutter .ruler
{
	border: 0 !important;
}

.syntaxhighlighter .toolbar
{
	background-color: #F8F8F8 !important;
	border: #E7E5DC solid 1px !important;
}

.syntaxhighlighter .toolbar a
{
	color: #a0a0a0 !important;
}

.syntaxhighlighter .toolbar a:hover
{
	color: red !important;
}

/************************************
 * Actual syntax highlighter colors.
 ************************************/
.syntaxhighlighter .plain,
.syntaxhighlighter .plain a
{ 
	color: #000 !important;
}

.syntaxhighlighter .comments,
.syntaxhighlighter .comments a
{ 
	color: #008200 !important;
}

.syntaxhighlighter .string,
.syntaxhighlighter .string a
{
	color: blue !important; 
}

.syntaxhighlighter .keyword
{ 
	color: #069 !important; 
	font-weight: bold !important; 
}

.syntaxhighlighter .preprocessor 
{ 
	color: gray !important; 
}

.syntaxhighlighter .variable 
{ 
	color: #a70 !important; 
}

.syntaxhighlighter .value
{ 
	color: #090 !important; 
}

.syntaxhighlighter .functions
{ 
	color: #ff1493 !important; 
}

.syntaxhighlighter .constants
{ 
	color: #0066CC !important; 
}

.syntaxhighlighter .script
{ 
	background-color: yellow !important;
}

.syntaxhighlighter .color1,
.syntaxhighlighter .color1 a
{ 
	color: #808080 !important; 
}

.syntaxhighlighter .color2,
.syntaxhighlighter .color2 a
{ 
	color: #ff1493 !important; 
}

.syntaxhighlighter .color3,
.syntaxhighlighter .color3 a
{ 
	color: red !important; 
}
