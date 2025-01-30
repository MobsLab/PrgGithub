function delete(obj)
%DELETE Remove video input object from memory.
%
%    DELETE(OBJ) removes video input object, OBJ, from memory. When
%    OBJ is  deleted, it becomes an invalid object. An invalid object
%    should be removed from the workspace with the CLEAR command.
%
%    If multiple references to a video input object exist in the
%    workspace, then deleting one video input object invalidates the
%    remaining references. These remaining references should be cleared
%    from the workspace with the CLEAR command.
%
%    If the video input object is accessing hardware, i.e. has a 
%    Running property value of on, the video input object will be
%    stopped with the STOP function and then deleted.
%
%    If OBJ is an array of video input objects and one of the objects
%    cannot be deleted, the remaining objects in the array will be deleted
%    and a warning will be returned.
%
%    DELETE should be used at the end of an image acquisition session.
%
%    Example:
%      obj = videoinput('winvideo', 1);
%      start(obj);
%      data = getdata(obj);
%      stop(obj);
%      delete(obj);
%
%    See also IMAQDEVICE/STOP, IMAQDEVICE/ISVALID, IMAQHELP.

%    CP 2-1-02
%    Copyright 2001-2010 The MathWorks, Inc.
%    $Revision: 1.1.6.10 $  $Date: 2010/12/27 01:13:46 $

% Initialize variables.
errorOccurred = false;
uddObj = imaqgate('privateGetField', obj, 'uddobject');

% Delete each UDD object.  Keep looping even 
% if one of the objects could not be deleted.  
for i=1:length(uddObj),
    try
        % Only handle valid objects.
        if ~strcmp(class(uddObj(i)), 'handle'),
            % Note: Cannot use obj(i) since this calls the built-in
            %       SUBSREF, not our IMAQDEVICE/SUBSREF.
            %
            % Close any preview windows associated with this object.
            % Make sure to call the MATLAB method first, not the UDD method.
            closepreview( subsref(obj, substruct('()', i)) );

            % Stop any running objects, then delete.
            stop(uddObj(i));
            
            % Need to check again in case:
            % - a callback calls DELETE, and 
            % - STOP from above executes a StopFcn 
            %   configured to DELETE, which
            % - results in an invalid handle after
            %   the STOP above returns.
            if ~strcmp(class(uddObj(i)), 'handle'),
                delete(uddObj(i));
            end
        end
    catch deleteException
        errorOccurred = true;	    
    end   
end   

% Report error if one occurred.
if errorOccurred,
    if length(uddObj) == 1
        throw(deleteException);
    else
        warnState = warning('backtrace', 'off');
        oc = onCleanup(@()warning(warnState));
        warning(message('imaq:delete:notAll'));
        clear('oc');
    end
end
