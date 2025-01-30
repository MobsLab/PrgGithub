% makeBehavRessourcesKJ
% 09.10.2017 KJ
%
% generate behavRessources variables
%
% Info
%   see makeDataBulbeSB
%

if exist('behavResources.mat','file')~=2
    save behavResources
end


%% Time of events data - create BehavResources


load('behavResources.mat', 'evt')
if exist('evt','var')
    disp('evt already done')
else
    % SetCurrentSession
    if ~exist('setCu','var')
        setCu=0;
    end
    if setCu==0
        SetCurrentSession
        SetCurrentSession('same')
        setCu=1;
    end
    
    % Get files concatenation events
    evt=GetEvents('output','Descriptions');
    tpsdeb={}; tpsfin={};nameSession={};tpsEvt={};
    
    %if first event is '0': not considered
    if strcmp(evt{1},'0')
        evt=evt(2:end);
    end

    % loop over event
    for i=1:length(evt)
        tpsEvt{i}=GetEvents(evt{i});
        if evt{i}(1)=='b'
            tpsdeb=[tpsdeb,tpsEvt{i}];
            nameSession=[nameSession,evt{i}(14:end)];
        elseif evt{i}(1)=='e'
            tpsfin=[tpsfin,tpsEvt{i}];
        end
    end
    
    save behavResources evt tpsEvt tpsdeb tpsfin nameSession 
end



%% GetTimeOfDataRecordingML - add to BehavResources
load('behavResources.mat', 'TimeEndRec')
if exist('TimeEndRec','var')
    disp('TimeEndRec already done')
else
    disp('GetTimeOfDataRecordingML.m')
    try
        TimeEndRec = GetTimeOfDataRecordingML;
        disp('Done');
    catch
        disp('Problem... SKIP');
    end
end

