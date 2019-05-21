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
 * Emacs SyntaxHighlighter theme based on theme by Joshua Emmons
 * http://www.skia.net/
 */

/************************************
 * Interface elements.
 ************************************/

.syntaxhighlighter
{
	background-color: #000000 !important;
}

/* Gutter line numbers */
.syntaxhighlighter .line .number
{
	color: #D3D3D3 !important;
}

/* Add border to the lines */
.syntaxhighlighter .line .content
{
	border-left: 3px solid #990000 !important;
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
	background-color: #0f0f0f !important;
}

.syntaxhighlighter .line .content .block
{
	background: url(wrapping.png) 0 1.1em no-repeat !important;
}

/* Highlighed line number */
.syntaxhighlighter .line.highlighted .number
{
	background-color: #435A5F !important;
	color: #fff !important;
}

/* Highlighed line */
.syntaxhighlighter .line.highlighted.alt1 .content,
.syntaxhighlighter .line.highlighted.alt2 .content
{
	background-color: #435A5F !important;
}

.syntaxhighlighter .ruler
{
	color: silver !important;
	background-color: #000000 !important;
	border-left: 3px solid #990000 !important;
}

.syntaxhighlighter.nogutter .ruler
{
	border: 0 !important;
}

.syntaxhighlighter .toolbar
{
	background-color: #000000 !important;
	border: #000000 solid 1px !important;
}

.syntaxhighlighter .toolbar a
{
	color: #646763 !important;
}

.syntaxhighlighter .toolbar a:hover
{
	color: #9CCFF4 !important;
}

/************************************
 * Actual syntax highlighter colors.
 ************************************/
.syntaxhighlighter .plain,
.syntaxhighlighter .plain a
{ 
	color: #D3D3D3 !important;
}

.syntaxhighlighter .comments,
.syntaxhighlighter .comments a
{ 
	color: #FF7D27 !important;
}

.syntaxhighlighter .string,
.syntaxhighlighter .string a
{
	color: #FF9E7B !important; 
}

.syntaxhighlighter .keyword
{ 
	color: #00FFFF !important; 
}

.syntaxhighlighter .preprocessor 
{ 
	color: #AEC4DE !important; 
}

.syntaxhighlighter .variable 
{ 
	color: #FFAA3E !important; 
}

.syntaxhighlighter .value
{ 
	color: #090 !important; 
}

.syntaxhighlighter .functions
{ 
	color: #81CEF9 !important; 
}

.syntaxhighlighter .constants
{ 
	color: #FF9E7B !important; 
}

.syntaxhighlighter .script
{ 
	background-color: #990000 !important;
}

.syntaxhighlighter .color1,
.syntaxhighlighter .color1 a
{ 
	color: #EBDB8D !important; 
}

.syntaxhighlighter .color2,
.syntaxhighlighter .color2 a
{ 
	color: #FF7D27 !important; 
}

.syntaxhighlighter .color3,
.syntaxhighlighter .color3 a
{ 
	color: #AEC4DE !important; 
}
