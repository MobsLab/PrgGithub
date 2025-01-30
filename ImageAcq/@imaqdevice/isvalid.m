function isok = isvalid(obj)
%ISVALID True for image acquisition objects associated with hardware.
%
%    OUT = ISVALID(OBJ) returns a logical array, OUT, that contains a 1 
%    where the elements of OBJ are image acquisition objects associated 
%    with hardware and a 0 where the elements of OBJ are image acquisition 
%    objects not associated with hardware.
%
%    OBJ is an invalid image acquisition object when it is no longer 
%    associated with any hardware.  If this is the case, OBJ should be 
%    cleared from the workspace.
%
%    See also IMAQDEVICE/DELETE, IMAQHELP.

%    CP 9-01-01
%    Copyright 2001-2005 The MathWorks, Inc.
%    $Revision: 1.1.6.5 $  $Date: 2005/06/17 20:26:52 $

% Verify UDD object is valid.
isok = imaqgate('privateValidCheck', obj);
