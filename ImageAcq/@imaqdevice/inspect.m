function inspect(obj)
%INSPECT Open inspector and inspect image acquisition object properties.
%
%    INSPECT(OBJ) opens the property inspector and allows you to 
%    inspect and set properties for image acquisition object, OBJ. OBJ
%    must be a 1-by-1 image acquisition object.
%
%    Example:
%      % Inspect video input properties.
%      obj = videoinput('matrox', 1, 'RS170');
%      inspect(obj)
%
%      % Inspect video source properties.
%      src = obj.Source;
%      inspect(src(1));
%
%    See also IMAQDEVICE/SET, IMAQDEVICE/GET, IMAQDEVICE/PROPINFO,
%             IMAQHELP.
%

%    CP 9-01-01
%    Copyright 2001-2010 The MathWorks, Inc.
%    $Revision: 1.1.6.5 $  $Date: 2010/12/27 01:13:56 $

% Error checking.
if ~isa(obj, 'imaqdevice')
   error(message('imaq:inspect:invalidType'));
elseif length(obj)>1
   error(message('imaq:inspect:OBJ1x1'));
elseif ~isvalid(obj)
   error(message('imaq:inspect:invalidOBJ'));
end

% Open the inspector.
inspect(imaqgate('privateGetField', obj, 'uddobject'));