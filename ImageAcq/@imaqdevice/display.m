function display(obj)
%DISPLAY Compact display method for image acquisition objects.
%
%    DISPLAY(OBJ) calls OBJ's DISP method.
%
%    See also VIDEOINPUT, IMAQDEVICE/GET.

%    CP 9-01-01
%    Copyright 2001-2005 The MathWorks, Inc.
%    $Revision: 1.1.6.6 $  $Date: 2006/06/02 20:03:35 $

% Initialize formatting variables.
isloose = strcmp(get(0,'FormatSpacing'),'loose');
if isloose,
    newline=sprintf('\n');
else
    newline=sprintf('');
end

% Determine if we need to display a single object or an array.
nObjs = length(obj);
if nObjs==1,
    % >> obj
    disp(obj);
else
    % >> [obj obj]
    %
    % Write out the header.
    fprintf(newline);
    fprintf([blanks(3) 'Video Input Object Array:\n']);
    fprintf(newline)
    fprintf([blanks(3) 'Index:   Type:          Name:  \n']);
    
    % Get all the values for the display.
    uddObj = imaqgate('privateGetField', obj, 'uddobject');
    for i = 1:nObjs
        if ishandle(uddObj(i))
            typeValue = get(uddObj(i), 'Type');
            nameValue = get(uddObj(i), 'Name');
        else
            typeValue = 'Invalid';
            nameValue = 'Invalid';
        end
        index = num2str(i);
        fprintf([blanks(3), index, ...
                blanks(9 - length(index)), typeValue, ...
                blanks(15 - length(typeValue)), '%s\n'], num2str(nameValue));
    end	
    fprintf(newline);
end
