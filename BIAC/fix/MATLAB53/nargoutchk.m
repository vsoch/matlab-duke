function msg=nargoutchk(low, high, n)
%NARGOUTCHK Validate number of output arguments. 
%   MSG = NARGOUTCHK(LOW,HIGH,N) returns an appropriate error message if
%   N is not between low and high. If it is, return empty matrix.
%
%   Implements MATLAB R12 function for earlier versions of MATLAB.
%
%   See also NARGCHK, NARGIN, NARGOUT, INPUTNAME.

% Based on "help nargoutchk" and functionality testing from:
%   nargoutchk.m (MATLAB R13 SP1)
%   Copyright 1984-2002 The MathWorks, Inc. 
%   Revision: 1.5   Date: 2002/04/08 23:29:23 

% BIAC Revision: $Id: nargoutchk.m,v 1.5 2004/07/27 03:52:02 michelich Exp $

msg = [];
if low > high
  error('First argument (low) to nargoutchk must not be greater than second argument (high).');
end
if n > high
  msg = 'Too many output arguments.';
elseif n < low
  msg = 'Not enough output arguments.';
end

