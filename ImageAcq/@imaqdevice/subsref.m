function result = subsref(obj, Struct)
%SUBSREF Subscripted reference into image acquisition objects.
%
%    SUBSREF Subscripted reference into image acquisition objects.
%
%    OBJ(I) is an array formed from the elements of OBJ specified by the
%    subscript vector I.  
%
%    OBJ.PROPERTY returns the property value of PROPERTY for image 
%    acquisition object OBJ.
%
%    Supported syntax for image acquisition objects:
%
%    Dot Notation:                  Equivalent Get Notation:
%    =============                  ========================
%    obj.Tag                        get(obj,'Tag')
%    obj(1).Tag                     get(obj(1),'Tag')
%    obj(1:4).Tag                   get(obj(1:4), 'Tag')
%    obj(1)                         
%
%    See also IMAQDEVICE/GET, IMAQDEVICE/PROPINFO, IMAQHELP.
%

%    CP 9-01-01
%    Copyright 2001-2007 The MathWorks, Inc.
%    $Revision: 1.1.6.7 $  $Date: 2007/12/17 06:17:49 $

try
    result = imaqgate('privateSubsref', obj, Struct);
catch exception
    throw(exception);
end
