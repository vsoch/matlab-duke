# designconvert.sed
# sed script to convert a design.fsf file into MATLAB code to specify
# the design as a structure named fmri

# Copyright 2004, Russ Poldrack, poldrack@ucla.edu
# with contributions from Dara Ghahremani
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# For a copy of the GNU Public License, see <http://www.gnu.org/licenses/>.

# Change Log:
# replace "." with ".c" when they occur within parens
# this is necessary because matlab can't handle struct fields
# whose name is just a number
# 11/30/05 - RP - removed global flag to prevent problems when 
# con_orig is fractional
# 12/18/06 - Dara - added line to acct. for symbols/numbers within
# evtitle field

/(*\.[0-9]*)/{
   /\.[0-9]/s/\./.c/
}

/set/s/set fmri(/fmri./g
/fmri/s/) /=/g
/"/s/"/'/g
/#/s/#/%/g

/fmri/s/$/;/

# put chars in single quotes
/fmri.unwarp_dir/s/\([a-zA-Z\-]*\);/'\1'/g

# added this to handle symbols and numbers in evtitle field (DG 12/18/06)
/fmri.evtitle/s/\([0-9a-zA-Z\-\+\_]*\);/'\1'/g

# deal with cases where the Rvalue is a string

/con_mode/s/=/='/
/con_mode/s/;/';/

# fix file specification separately
/_files/s/set /fmri./

# create as cell arrays
/_files/y/()/{}/
/_files/s/'/='/
/_files/s/$/;/
