function [ evt_beginning ] = SWBeginningOfWakefulness( lastActivities, SWc )
%SWBeginningOfWakefulness Find the beginning of an epoch of wakefulness.
%   This function return the beginning of a awake epoch given an array of
%   the last activities. If no beginning is found on the last activities,
%   1 is returned.
%

% Get an instance of SWConsts if not provided
if (nargin < 2)
    SWc = SWConsts.getInstance();
end

t_1 = find(lastActivities == SWc.IS_AWAKE, 1, 'last');
if isempty(t_1)
    evt_beginning = 1;
else
    t_2 = find(lastActivities(1:t_1) == SWc.IS_SLEEPING, 1, 'last');
    if isempty(t_2)
        evt_beginning = 1;
    else
        evt_beginning = t_2 + 1;
    end
end

end

