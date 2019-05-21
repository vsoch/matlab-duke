function ret=ispc
%ISPC True for the PC (Windows) version of MATLAB.
%   ISPC returns 1 for PC (Windows) versions of MATLAB and 0 otherwise.
%
%   Implements MATLAB R12 function for earlier versions of MATLAB.

% Based on "help ispc" from MATLAB R13 SP1:
%   Copyright 1984-2002 The MathWorks, Inc. 
%   Revision: 1.4   Date: 2002/04/08 20:51:21 

% BIAC Revision: $Id: ispc.m,v 1.5 2004/07/27 03:52:01 michelich Exp $

ret = strcmp(computer, 'PCWIN');
