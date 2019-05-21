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
/**
 * Django SyntaxHighlighter theme
 */

/************************************
 * Interface elements.
 ************************************/

.syntaxhighlighter
{
	background-color: #0B2F20 !important;
}

/* Gutter line numbers */
.syntaxhighlighter .line .number
{
	color: #497958 !important;
}

/* Add border to the lines */
.syntaxhighlighter .line .content
{
	border-left: 3px solid #41A83E !important;
	color: #B9BDB6 !important;
}

.syntaxhighlighter.printing .line .content 
{
	border: 0 !important;
}

/* First line */
.syntaxhighlighter .line.alt1 .content
{
}

/* Second line */
.syntaxhighlighter .line.alt2 .content
{
	background-color: #0a2b1d !important;
}

.syntaxhighlighter .line .content .block
{
	background: url(wrapping.png) 0 1.1em no-repeat !important;
}

/* Highlighed line number */
.syntaxhighlighter .line.highlighted .number
{
	background-color: #336442 !important;
	color: #fff !important;
}

/* Highlighed line */
.syntaxhighlighter .line.highlighted.alt1 .content,
.syntaxhighlighter .line.highlighted.alt2 .content
{
	background-color: #336442 !important;
}

.syntaxhighlighter .ruler
{
	color: #C4B14A !important;
	background-color: #245032 !important;
	border-left: 3px solid #41A83E !important;
}

.syntaxhighlighter.nogutter .ruler
{
	border: 0 !important;
}

.syntaxhighlighter .toolbar
{
	background-color: #245032 !important;
	border: #0B2F20 solid 1px !important;
}

.syntaxhighlighter .toolbar a
{
	color: #C4B14A !important;
}

.syntaxhighlighter .toolbar a:hover
{
	color: #FFE862 !important;
}

/************************************
 * Actual syntax highlighter colors.
 ************************************/
.syntaxhighlighter .plain,
.syntaxhighlighter .plain a
{
	color: #F8F8F8 !important;
}

.syntaxhighlighter .comments,
.syntaxhighlighter .comments a
{ 
	color: #336442 !important;
	font-style: italic !important;
}

.syntaxhighlighter .string,
.syntaxhighlighter .string a
{
	color: #9DF39F !important; 
}

.syntaxhighlighter .keyword
{ 
	color: #96DD3B !important; 
	font-weight: bold !important;
}

.syntaxhighlighter .preprocessor 
{ 
	color: #91BB9E !important; 
}

.syntaxhighlighter .variable 
{ 
	color: #FFAA3E !important; 
}

.syntaxhighlighter .value
{ 
	color: #F7E741 !important; 
}

.syntaxhighlighter .functions
{ 
	color: #FFAA3E !important; 
}

.syntaxhighlighter .constants
{ 
	color: #E0E8FF !important; 
}

.syntaxhighlighter .script
{ 
	background-color: #497958 !important;
}

.syntaxhighlighter .color1,
.syntaxhighlighter .color1 a
{ 
	color: #EB939A !important; 
}

.syntaxhighlighter .color2,
.syntaxhighlighter .color2 a
{ 
	color: #91BB9E !important; 
}

.syntaxhighlighter .color3,
.syntaxhighlighter .color3 a
{ 
	color: #EDEF7D !important; 
}
