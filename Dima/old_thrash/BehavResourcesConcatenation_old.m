% function BehavResourcesConcatenation (FilesList, FolderSessionName, tpsCatEvt, pathtosave)
function BehavResourcesConcatenation (FilesList, FolderSessionName, pathtosave)

%%%% TestBehavResourcesConcatenation
% Concatenate behavResources for any number of sessions
% Written for PreProcessingConcatenation pipeline (author - Sophie Bagur)
% By Dima Bryzgalov december 2018
%
% This code concatenates all possible behavResources.mat into one structure
% with the length that is equal to number of concatenated sessions (behavResources)
% !!! Time is unified and united in this structure !!!
% 
% Also, it creates concatenated variables were the whole day of experiment
% is concatenated. You can restrict your data to specifically created
% epochs with the name <'SessionEpoch.SessionName'>
% 
% Please find description of all variables inside the code
%
%  USAGE
%
%    BehavResourcesConcatenation (FilesList, FolderSessionName, pathtosave, tpsCatEvt, nameCatEvt)
%
%    FilesList              a cell with paths to behavResources file
%    FolderSessionName      a cell with names of sessions (same order as in FilesList)
%    tpsCatEvt              time of beginning and end of each session
%    pathtosave             Path to save behavioral resources
%
% TODO:
% - Write cat.evt file concatenation
% - Integrate in Sophie's code
% 
%%
%%%%%%%%%%%%%%%%%%%%%%%% -----------------------%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Load data
for i = 1:length(FilesList)
    a{i} = load(FilesList{i});
end

%% check forma
if pathtosave(end)~=filesep
    pathtosave(end+1) = filesep;
end


%% Start creating the structure - names of sessions
for i=1:length(FilesList)
    behavResources(i).SessionName = FolderSessionName{i};
end

%% Add constants in the structure - note that they could be different for different sessions

for i=1:length(FilesList)
    
    % Set of things you must have in each file
    behavResources(i).ref = a{i}.ref; % reference image
    behavResources(i).mask = a{i}.mask; % mask polygon
    behavResources(i).Ratio_IMAonREAL = a{i}.Ratio_IMAonREAL; % pixel/cm ratio
    behavResources(i).BW_threshold = a{i}.BW_threshold; % threshold of mouse detection in tracking
    behavResources(i).smaller_object_size = a{i}.smaller_object_size; % threshold of mouse size during tracking
    behavResources(i).sm_fact = a{i}.sm_fact; % smoothing factor for tracking
    behavResources(i).strsz = a{i}.strsz; % factor to smooth edges
    behavResources(i).SrdZone = a{i}.SrdZone; % Size of the zone where tracking looks for freezing
    behavResources(i).th_immob = a{i}.th_immob; % Tracking threshold of immobility
    behavResources(i).thtps_immob = a{i}.thtps_immob; % Tracking threshold of immobility on time
    
    % Set of non-obligatory variables
    if isfield(a{i}, 'frame_limits')
        behavResources(i).frame_limits = a{i}.frame_limits; % ColorAxis limits
    else
        behavResources(i).frame_limits = []; % ColorAxis limits
    end
    
    if isfield(a{i}, 'Zone')
        behavResources(i).Zone = a{i}.Zone; % Shapes of Zones
    else
        behavResources(i).Zone = [];
    end

    if isfield(a{i}, 'ZoneLabels')
        behavResources(i).ZoneLabels = a{i}.ZoneLabels; % Names of Zones
    else
        behavResources(i).ZoneLabels = [];
    end
    
    if isfield(a{i}, 'delStim')
        behavResources(i).delStim = a{i}.delStim; % InterStimulus interval
    else
        behavResources(i).delStim = [];
    end
    
    if isfield(a{i}, 'delStimreturn')
        behavResources(i).delStimreturn = a{i}.delStimreturn; % First entry stimulation latency
    else
        behavResources(i).delStimreturn = [];
    end
    
    if isfield(a{i}, 'DiodMask')
        behavResources(i).DiodMask = a{i}.DiodMask; % NosePoke Tracking: mask for the synchronizing diod
    else
        behavResources(i).DiodMask = [];
    end

    if isfield(a{i}, 'DiodThresh')
        behavResources(i).DiodThresh = a{i}.DiodThresh; % NosePoke Tracking: threshold for the synchronizing diod flashing
    else
        behavResources(i).DiodThresh = [];
    end
    
end

%% Calculate duration, find the first timestamp ('offset') and number of indices for each test
% find also last timestaps for each session ('lasttime')

% for i = 1:ntest
%     TimeTemp{i} = Range(a{i}.Ytsd);
%     duration(i) = TimeTemp{i}(end) - TimeTemp{i}(1);
%     offset(i) = TimeTemp{i}(1);
%     lind(i) = length(TimeTemp{i});
%     lasttime(i) = TimeTemp{i}(end);
%     ThousandFrames{i} = ts(TimeTemp{i}(1:1000:end));
% end
% clear TimeTemp

for i = 1:length(FilesList)
    TimeTemp{i} = Range(a{i}.Xtsd);
    offset(i) = TimeTemp{i}(1);
    lind(i) = length(TimeTemp{i});
    ThousandFrames{i} = ts(TimeTemp{i}(1:1000:end));
end
clear TimeTemp

for i=1:length(tpsCatEvt)
    st(i) = tpsCatEvt(1:2:end);
    en(i) = tpsCatEvt(2:2:end);
end
for i=1:length(st)
    duration(i) = en(i)-st(i);
    lasttime(i) = en(i);
end    

%% Concatenate time-dependent variables

% Concatenate PosMat (type - array) 
for i=1:length(FilesList)
    PosMatTemp{i} = a{i}.PosMat; % First column - time in sec, second column - X, third column - Y, fourth column - events
end
for i=1:(length(FilesList)-1)

    PosMatTemp{i+1}(:,1) = PosMatTemp{i+1}(:,1) + (sum(duration(1:i)))/1E4 + sum(offset(1:i+1))/1e4;
%     PosMatTemp{i+1}(:,1) = PosMatTemp{i+1}(:,1) + (sum(duration(1:i))) + sum(offset(1:i))/1e4;
end
for i = 1:length(FilesList)
    behavResources(i).PosMat = PosMatTemp{i};
end
clear PosMatTemp

% Concatenate PosMatInit (type - array) 
for i=1:length(FilesList)
    PosMatInitTemp{i} = a{i}.PosMatInit; % Raw PosMat, it is interpolated to PosMat (where periods where mouse was lost are interpolated)
end
for i=1:(length(FilesList)-1)
    PosMatInitTemp{i+1}(:,1) = PosMatInitTemp{i+1}(:,1) + (sum(duration(1:i)))/1E4 + sum(offset(1:i))/1e4;
%     PosMatInitTemp{i+1}(:,1) = PosMatInitTemp{i+1}(:,1) + (sum(duration(1:i))) + sum(offset(1:i))/1e4;
end
for i = 1:length(FilesList)
    behavResources(i).PosMatInit = PosMatInitTemp{i};
end
clear PosMatInitTemp

% Concatenate im_diff (type - array) 
for i=1:length(FilesList) % First column - time in sec, second column - difference in pixels between mask and a frame,...
    % third column - number of pixels used for subtraction
    im_diffTemp{i} = a{i}.im_diff; 
end
for i=1:(length(FilesList)-1)
    im_diffTemp{i+1}(:,1) = im_diffTemp{i+1}(:,1) + (sum(duration(1:i)))/1E4 + sum(offset(1:i))/1e4;
%     im_diffTemp{i+1}(:,1) = im_diffTemp{i+1}(:,1) + (sum(duration(1:i))) + sum(offset(1:i))/1e4;
end
for i = 1:length(FilesList)
    behavResources(i).im_diff = im_diffTemp{i};
end
clear im_diffTemp

% Concatenate im_diffInit (type - array) 
for i=1:length(FilesList) % Raw im_Diff, it is interpolated to im_Diff (where periods where mouse was lost are interpolated)
    im_diffInitTemp{i} = a{i}.im_diffInit; 
end
for i=1:(length(FilesList)-1)
    im_diffInitTemp{i+1}(:,1) = im_diffInitTemp{i+1}(:,1) + (sum(duration(1:i)))/1E4 + sum(offset(1:i))/1e4;
%     im_diffInitTemp{i+1}(:,1) = im_diffInitTemp{i+1}(:,1) + (sum(duration(1:i))) + sum(offset(1:i))/1e4;
end
for i = 1:length(FilesList)
    behavResources(i).im_diffInit = im_diffInitTemp{i};
end
clear im_diffInitTemp

% Concatenate Imdifftsd (type single tsd)
for i=1:length(FilesList) % Tsd, with differences in pixels between mask and a frame in Data
    ImdifftsdTimeTemp{i} = Range(a{i}.Imdifftsd);
    ImdifftsdDataTemp{i} = Data(a{i}.Imdifftsd);
end
for i=1:(length(FilesList)-1)
    ImdifftsdTimeTemp{i+1} = ImdifftsdTimeTemp{i+1}+sum(duration(1:i))+sum(offset(1:i));
%     ImdifftsdTimeTemp{i+1} = ImdifftsdTimeTemp{i+1}+sum(duration(1:i))*1e4+sum(offset(1:i));
end
for i = 1:length(FilesList)
    behavResources(i).Imdifftsd = tsd(ImdifftsdTimeTemp{i}, ImdifftsdDataTemp{i});
end
clear ImdifftsdTimeTemp ImdifftsdDataTemp

% Concatenate Xtsd (type single tsd)
for i=1:length(FilesList) % tsd of X coordinates
    XtsdTimeTemp{i} = Range(a{i}.Xtsd);
    XtsdDataTemp{i} = Data(a{i}.Xtsd);
end
for i=1:(length(FilesList)-1)
    XtsdTimeTemp{i+1} = XtsdTimeTemp{i+1}+sum(duration(1:i))+sum(offset(1:i));
%     XtsdTimeTemp{i+1} = XtsdTimeTemp{i+1}+sum(duration(1:i))*1e4+sum(offset(1:i));
end
for i = 1:length(FilesList)
    behavResources(i).Xtsd = tsd(XtsdTimeTemp{i}, XtsdDataTemp{i});
end
clear XtsdTimeTemp XtsdDataTemp

% Concatenate Ytsd (type single tsd)
for i=1:length(FilesList) % tsd of Y coordinates
    YtsdTimeTemp{i} = Range(a{i}.Ytsd);
    YtsdDataTemp{i} = Data(a{i}.Ytsd);
end
for i=1:(length(FilesList)-1)
    YtsdTimeTemp{i+1} = YtsdTimeTemp{i+1}+sum(duration(1:i))+sum(offset(1:i));
%     YtsdTimeTemp{i+1} = YtsdTimeTemp{i+1}+sum(duration(1:i))*1e4+sum(offset(1:i));
end
for i = 1:length(FilesList)
    behavResources(i).Ytsd = tsd(YtsdTimeTemp{i}, YtsdDataTemp{i});
end
clear YtsdTimeTemp YtsdDataTemp

% Concatenate Vtsd (type single tsd) - describe, plz, what's the trick!!!!
for i=1:length(FilesList) % tsd of instantaneous speed
    if i==length(FilesList)
        VtsdTimeTemp{i} = Range(a{i}.Vtsd);
        VtsdDataTemp{i} = Data(a{i}.Vtsd);
    else
        VtsdTimeTemp{i} = [Range(a{i}.Vtsd); lasttime(i)];
        VtsdDataTemp{i} = [Data(a{i}.Vtsd); -1];
    end
end
for i=1:(length(FilesList)-1)
    VtsdTimeTemp{i+1} = VtsdTimeTemp{i+1}+sum(duration(1:i))+sum(offset(1:i));
%     VtsdTimeTemp{i+1} = VtsdTimeTemp{i+1}+sum(duration(1:i))*1e4+sum(offset(1:i));
end
for i = 1:length(FilesList)
    behavResources(i).Vtsd = tsd(VtsdTimeTemp{i}, VtsdDataTemp{i});
end
clear VtsdTimeTemp VtsdDataTemp

%%%%% NON-OBLIGATORY

% Concatenate GotFrame (type - array) 
for i=1:length(FilesList) % Array of 0 and 1 - whether this frame is recorded to the video or not
    if isfield(a{i}, 'GotFrame')
        GotFrameTemp{i} = a{i}.GotFrame;
    else
        GotFrameTemp{i} = [];
    end
end
for i = 1:length(FilesList)
    behavResources(i).GotFrame = GotFrameTemp{i};
end
clear GotFrameTemp

% Concatenate ZoneIndices (type array of indices * N - number of Zones) 
for i=1:length(FilesList) % Time indices of the occasions when the animal was in the Zone
    if isfield(a{i}, 'ZoneIndices')
        for k = 1:length(a{i}.ZoneIndices)
            ZoneIndicesTemp{i}{k} = a{i}.ZoneIndices{k};
        end
    else
        ZoneIndicesTemp{i} = [];
    end
end
for i=1:length(FilesList)
    if ~isempty(ZoneIndicesTemp{i})
        for k = 1:length(ZoneIndicesTemp{i})
            behavResources(i).ZoneIndices{k} = ZoneIndicesTemp{i}{k};
        end
    else
        behavResources(i).ZoneIndices = ZoneIndicesTemp{i};
    end
end
clear ZoneIndicesTemp


% Concatenate MouseTemp (type - array)
for i=1:length(FilesList) % First column - time in sec, Second column - mouse temp in a.u. (could be converted to degrees)
    if isfield(a{i}, 'MouseTemp')
        MouseTempTemp{i} = a{i}.MouseTemp;
    else
        MouseTempTemp{i} = [];
    end
end
for i=1:(length(FilesList)-1)
    if ~isempty(MouseTempTemp{i+1})
        MouseTempTemp{i+1}(:,1) = MouseTempTemp{i+1}(:,1) + (sum(duration(1:i)))/1E4 + sum(offset(1:i))/1e4;
%         MouseTempTemp{i+1}(:,1) = MouseTempTemp{i+1}(:,1) + (sum(duration(1:i))) + sum(offset(1:i))/1e4;
    else
        MouseTempTemp{i+1} = [];
    end
end
for i = 1:length(FilesList)
    behavResources(i).MouseTemp = MouseTempTemp{i};
end
clear MouseTempTemp

% Concatenate Freezeepoch (type single tsa)
for i=1:length(FilesList) % Epochs when the animal was Freezing
    if isfield(a{i}, 'FreezeEpoch')
        FreezeEpochTempStart{i} = Start(a{i}.FreezeEpoch);
        FreezeEpochTempEnd{i} = End(a{i}.FreezeEpoch);
    else
        FreezeEpochTempStart{i} = [];
    end
end
for i=1:(length(FilesList)-1)
    if ~isempty (FreezeEpochTempStart{i+1})
        FreezeEpochTempStart{i+1} = FreezeEpochTempStart{i+1}+sum(duration(1:i))+sum(offset(1:i));
%         FreezeEpochTempStart{i+1} = FreezeEpochTempStart{i+1}+sum(duration(1:i))*1e4+sum(offset(1:i));
        FreezeEpochTempEnd{i+1} = FreezeEpochTempEnd{i+1} +sum(duration(1:i))+sum(offset(1:i));
%         FreezeEpochTempEnd{i+1} = FreezeEpochTempEnd{i+1} +sum(duration(1:i))*1e4+sum(offset(1:i));
    end
end
for i=1:length(FilesList)
    if ~isempty (FreezeEpochTempStart{i})
        behavResources(i).FreezeEpoch = intervalSet(FreezeEpochTempStart{i}, FreezeEpochTempEnd{i});
    else
        behavResources(i).FreezeEpoch = [];
    end
end
clear FreezeEpochTempStart FreezeEpochTempEnd FreezeEpochStart FreezeEpochEnd

% Concatenate ZoneEpoch (type single tsa)
for i=1:length(FilesList) % Epochs when the animals was situated in the Zone
    if isfield(a{i}, 'ZoneEpoch')
        for k = 1:length(a{i}.ZoneEpoch)
            ZoneEpochTempStart{i}{k} = Start(a{i}.ZoneEpoch{k});
            ZoneEpochTempEnd{i}{k} = End(a{i}.ZoneEpoch{k});
        end
    else
        ZoneEpochTempStart{i} = [];
    end
end
for i=1:(length(FilesList)-1)
    if ~isempty (ZoneEpochTempStart{i+1})
        for k = 1:length(ZoneEpochTempStart{i+1})
            ZoneEpochTempStart{i+1}{k} = ZoneEpochTempStart{i+1}{k} +sum(duration(1:i))+sum(offset(1:i));
%             ZoneEpochTempStart{i+1}{k} = ZoneEpochTempStart{i+1}{k} +sum(duration(1:i))*1e4+sum(offset(1:i));
            ZoneEpochTempEnd{i+1}{k} = ZoneEpochTempEnd{i+1}{k} +sum(duration(1:i))+sum(offset(1:i));
%             ZoneEpochTempEnd{i+1}{k} = ZoneEpochTempEnd{i+1}{k} +sum(duration(1:i))*1e4+sum(offset(1:i));
        end
    end
end
for i=1:length(FilesList)
    if ~isempty (ZoneEpochTempStart{i})
        for k = 1:length(a{i}.ZoneEpoch)
            behavResources(i).ZoneEpoch{k} = intervalSet(ZoneEpochTempStart{i}{k}, ZoneEpochTempEnd{i}{k});
        end
    else
        behavResources(i).ZoneEpoch = [];
    end
end
clear ZoneEpochTempStart ZoneEpochTempEnd ZoneEpochStart ZoneEpochEnd


%% Concatenated tsd and intervalSet variables

%%% OBLIGATORY
% Concatenate PosMat (type - array) 
for i=1:length(FilesList)
    PosMatTemp{i} = a{i}.PosMat; 
end
for i=1:(length(FilesList)-1)
    PosMatTemp{i+1}(:,1) = PosMatTemp{i+1}(:,1) + (sum(duration(1:i)))/1E4  + sum(offset(1:i))/1e4;
%     PosMatTemp{i+1}(:,1) = PosMatTemp{i+1}(:,1) + (sum(duration(1:i))) + sum(offset(1:i))/1e4;
end
PosMat = PosMatTemp{1};
for i = 2:length(FilesList)
    PosMat = [PosMat; PosMatTemp{i}];
end
TimeInSec = PosMat(:,1);
clear PosMatTemp

% Concatenate PosMatInit (type - array) 
for i=1:length(FilesList)
    PosMatInitTemp{i} = a{i}.PosMatInit; 
end
for i=1:(length(FilesList)-1)
    PosMatInitTemp{i+1}(:,1) = PosMatInitTemp{i+1}(:,1) + (sum(duration(1:i)))/1E4  + sum(offset(1:i))/1e4;
%     PosMatInitTemp{i+1}(:,1) = PosMatInitTemp{i+1}(:,1) + (sum(duration(1:i))) + sum(offset(1:i))/1e4;
end
PosMatInit = PosMatInitTemp{1};
for i = 2:length(FilesList)
    PosMatInit = [PosMatInit; PosMatInitTemp{i}];
end
clear PosMatInitTemp

% Concatenate im_diff (type - array) 
for i=1:length(FilesList)
    im_diffTemp{i} = a{i}.im_diff; 
end
for i=1:(length(FilesList)-1)
    im_diffTemp{i+1}(:,1) = im_diffTemp{i+1}(:,1) + (sum(duration(1:i)))/1E4  + sum(offset(1:i))/1e4;
%     im_diffTemp{i+1}(:,1) = im_diffTemp{i+1}(:,1) + (sum(duration(1:i))) + sum(offset(1:i))/1e4;
end
im_diff = im_diffTemp{1};
for i = 2:length(FilesList)
    im_diff = [im_diff; im_diffTemp{i}];
end
clear im_diffTemp

% Concatenate im_diffInit (type - array) 
for i=1:length(FilesList)
    im_diffInitTemp{i} = a{i}.im_diffInit; 
end
for i=1:(length(FilesList)-1)
    im_diffInitTemp{i+1}(:,1) = im_diffInitTemp{i+1}(:,1) + (sum(duration(1:i)))/1E4  + sum(offset(1:i))/1e4;
%     im_diffInitTemp{i+1}(:,1) = im_diffInitTemp{i+1}(:,1) + (sum(duration(1:i))) + sum(offset(1:i))/1e4;
end
im_diffInit = im_diffInitTemp{1};
for i = 2:length(FilesList)
    im_diffInit = [im_diffInit; im_diffInitTemp{i}];
end
clear im_diffInitTemp

% Concatenate Imdifftsd (type single tsd)
for i=1:length(FilesList)
    ImdifftsdTimeTemp{i} = Range(a{i}.Imdifftsd);
    ImdifftsdDataTemp{i} = Data(a{i}.Imdifftsd);
end
for i=1:(length(FilesList)-1)
    ImdifftsdTimeTemp{i+1} = ImdifftsdTimeTemp{i+1}+sum(duration(1:i))+sum(offset(1:i));
%     ImdifftsdTimeTemp{i+1} = ImdifftsdTimeTemp{i+1}+sum(duration(1:i))*1e4+sum(offset(1:i));
end
ImdifftsdTime = ImdifftsdTimeTemp{1};
ImdifftsdData = ImdifftsdDataTemp{1};
for i = 2:length(FilesList)
    ImdifftsdTime = [ImdifftsdTime; ImdifftsdTimeTemp{i}];
    ImdifftsdData = [ImdifftsdData; ImdifftsdDataTemp{i}];
end
Imdifftsd = tsd(ImdifftsdTime, ImdifftsdData);
TimeInTsd = ImdifftsdTime;
clear ImdifftsdTimeTemp ImdifftsdDataTemp ImdifftsdTime ImdifftsdData

% Concatenate Xtsd (type single tsd)
for i=1:length(FilesList)
    XtsdTimeTemp{i} = Range(a{i}.Xtsd);
    XtsdDataTemp{i} = Data(a{i}.Xtsd);
end
for i=1:(length(FilesList)-1)
    XtsdTimeTemp{i+1} = XtsdTimeTemp{i+1}+sum(duration(1:i))+sum(offset(1:i));
%     XtsdTimeTemp{i+1} = XtsdTimeTemp{i+1}+sum(duration(1:i))*1e4+sum(offset(1:i));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create epochs for each file
for i = 1:length(FilesList)
    v = genvarname([FolderSessionName{i}]);
    SessionEpoch.(v) = intervalSet(XtsdTimeTemp{i}(1),XtsdTimeTemp{i}(end));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
XtsdTime = XtsdTimeTemp{1};
XtsdData = XtsdDataTemp{1};
for i = 2:length(FilesList)
    XtsdTime = [XtsdTime; XtsdTimeTemp{i}];
    XtsdData = [XtsdData; XtsdDataTemp{i}];
end
Xtsd = tsd(XtsdTime, XtsdData);
clear XtsdTimeTemp XtsdDataTemp XtsdTime XtsdData

% Concatenate Ytsd (type single tsd)
for i=1:length(FilesList)
    YtsdTimeTemp{i} = Range(a{i}.Ytsd);
    YtsdDataTemp{i} = Data(a{i}.Ytsd);
end
for i=1:(length(FilesList)-1)
    YtsdTimeTemp{i+1} = YtsdTimeTemp{i+1}+sum(duration(1:i))+sum(offset(1:i));
%     YtsdTimeTemp{i+1} = YtsdTimeTemp{i+1}+sum(duration(1:i))*1e4+sum(offset(1:i));
end
YtsdTime = YtsdTimeTemp{1};
YtsdData = YtsdDataTemp{1};
for i = 2:length(FilesList)
    YtsdTime = [YtsdTime; YtsdTimeTemp{i}];
    YtsdData = [YtsdData; YtsdDataTemp{i}];
end
Ytsd = tsd(YtsdTime, YtsdData);
clear YtsdTimeTemp YtsdDataTemp YtsdTime YtsdData

% Concatenate Vtsd (type single tsd) - describe, plz, what's the trick!!!!
for i=1:length(FilesList)
    if i==length(FilesList)
        VtsdTimeTemp{i} = Range(a{i}.Vtsd);
        VtsdDataTemp{i} = Data(a{i}.Vtsd);
    else
        VtsdTimeTemp{i} = [Range(a{i}.Vtsd); lasttime(i)];
        VtsdDataTemp{i} = [Data(a{i}.Vtsd); -1];
    end
end
for i=1:(length(FilesList)-1)
    VtsdTimeTemp{i+1} = VtsdTimeTemp{i+1}+sum(duration(1:i))+sum(offset(1:i));
%     VtsdTimeTemp{i+1} = VtsdTimeTemp{i+1}+sum(duration(1:i))*1e4+sum(offset(1:i));
end
VtsdTime = VtsdTimeTemp{1};
VtsdData = VtsdDataTemp{1};
for i = 2:length(FilesList)
    VtsdTime = [VtsdTime; VtsdTimeTemp{i}];
    VtsdData = [VtsdData; VtsdDataTemp{i}];
end
Vtsd = tsd(VtsdTime, VtsdData);
clear VtsdTimeTemp VtsdDataTemp VtsdTime VtsdData

%%%%% NON-OBLIGATORY

% Concatenate GotFrame (type - array) 
for i=1:length(FilesList)
    if isfield(a{i}, 'GotFrame')
        GotFrameTemp{i} = a{i}.GotFrame;
    else
        GotFrameTemp{i} = zeros(1,lind(i));
    end
end
GotFrame = GotFrameTemp{1};
for i = 2:length(FilesList)
    GotFrame = [GotFrame GotFrameTemp{i}];
end
clear GotFrameTemp

% Concatenate Freezeepoch (type single tsa)
for i=1:length(FilesList)
    if isfield(a{i}, 'FreezeEpoch')
        FreezeEpochTempStart{i} = Start(a{i}.FreezeEpoch);
        FreezeEpochTempEnd{i} = End(a{i}.FreezeEpoch);
    else
        FreezeEpochTempStart{i} = [];
    end
end
for i=1:(length(FilesList)-1)
    if ~isempty (FreezeEpochTempStart{i+1})
        FreezeEpochTempStart{i+1} = FreezeEpochTempStart{i+1}+sum(duration(1:i))+sum(offset(1:i));
%         FreezeEpochTempStart{i+1} = FreezeEpochTempStart{i+1}+sum(duration(1:i))*1e4+sum(offset(1:i));
        FreezeEpochTempEnd{i+1} = FreezeEpochTempEnd{i+1} +sum(duration(1:i))+sum(offset(1:i));
%         FreezeEpochTempEnd{i+1} = FreezeEpochTempEnd{i+1} +sum(duration(1:i))*1e4+sum(offset(1:i));
    end
end
FreezeEpochStart = FreezeEpochTempStart{1};
FreezeEpochEnd = FreezeEpochTempEnd{1};
for i=2:length(FilesList)
    FreezeEpochStart = [FreezeEpochStart; FreezeEpochTempStart{i}];
    FreezeEpochEnd = [FreezeEpochEnd; FreezeEpochTempEnd{i}];
end
FreezeEpoch = intervalSet(FreezeEpochStart, FreezeEpochEnd);
clear FreezeEpochTempStart FreezeEpochTempEnd FreezeEpochStart FreezeEpochEnd

% Find all the zones names you have
if isfield(a{i}, 'ZoneLabels')
    ZoneNames = cell(1,1000);
    v=1;
    for i=1:length(FilesList)
        if ~isempty(behavResources(i).ZoneLabels)
            for k = 1:length(behavResources(i).ZoneLabels)
                ZoneNames{v} = behavResources(i).ZoneLabels{k};
                v=v+1;
            end
        end
    end
    ZoneNames = ZoneNames(~cellfun('isempty', ZoneNames));
    ZoneNames = unique(ZoneNames);
    clear v
end
        
% Concatenate ZoneEpoch (type single tsa) 
for i=1:length(FilesList)
    if isfield(a{i}, 'ZoneEpoch')
        for k = 1:length(a{i}.ZoneEpoch)
            idx_Zone = find(strcmp(a{i}.ZoneLabels{k}, ZoneNames));
            ZoneEpochTempStart{i}{idx_Zone} = Start(a{i}.ZoneEpoch{k});
            ZoneEpochTempEnd{i}{idx_Zone} = End(a{i}.ZoneEpoch{k});
        end
    else
        ZoneEpochTempStart{i} = [];
        ZoneEpochTempEnd{i} = [];
    end
end
for i=1:(length(FilesList)-1)
    if ~isempty (ZoneEpochTempStart{i+1})
        for k = 1:length(ZoneNames)
            ZoneEpochTempStart{i+1}{k} = ZoneEpochTempStart{i+1}{k} +sum(duration(1:i))+sum(offset(1:i));
%             ZoneEpochTempStart{i+1}{k} = ZoneEpochTempStart{i+1}{k} +sum(duration(1:i))*1e4+sum(offset(1:i));
            ZoneEpochTempEnd{i+1}{k} = ZoneEpochTempEnd{i+1}{k} +sum(duration(1:i))+sum(offset(1:i));
%             ZoneEpochTempEnd{i+1}{k} = ZoneEpochTempEnd{i+1}{k} +sum(duration(1:i))*1e4+sum(offset(1:i));
        end
    end
end
for k=1:length(ZoneNames)
    if ~isempty(ZoneEpochTempStart{1})
        if ~isempty(ZoneEpochTempStart{1}{k})
            ZoneEpochStart{k} = ZoneEpochTempStart{1}{k};
            ZoneEpochEnd{k} = ZoneEpochTempEnd{1}{k};
        else
            ZoneEpochStart{k} = [];
            ZoneEpochEnd{k} = [];
        end
    else
        ZoneEpochStart{k} = [];
        ZoneEpochEnd{k} = [];
    end
end
for i=2:length(FilesList)
    for k = 1:length(ZoneNames)
        if ~isempty(ZoneEpochTempStart{i})
            ZoneEpochStart{k} = [ZoneEpochStart{k}; ZoneEpochTempStart{i}{k}];
            ZoneEpochEnd{k} = [ZoneEpochEnd{k}; ZoneEpochTempEnd{i}{k}];
        end
    end
end
for i=1:length(ZoneNames)
    ZoneEpoch.(ZoneNames{i}) = intervalSet(ZoneEpochStart{i}, ZoneEpochEnd{i});
end
clear idx_Zone ZoneEpochTempStart ZoneEpochTempEnd ZoneEpochStart ZoneEpochEnd

% Concatenate ZoneIndices (type array of indices * 7 - number of Zones)
for i=1:length(FilesList)
    if isfield(a{i}, 'ZoneIndices')
        for k = 1:length(a{i}.ZoneIndices)
            idx_Zone = find(strcmp(a{i}.ZoneLabels{k}, ZoneNames));
            ZoneIndicesTemp{i}{idx_Zone} = a{i}.ZoneIndices{k};
        end
    else
        ZoneIndicesTemp{i} = [];
    end
end
for i=1:(length(FilesList)-1)
    if ~isempty (ZoneIndicesTemp{i+1})
        for k = 1:length(ZoneNames)
            ZoneIndicesTemp{i+1}{k} = ZoneIndicesTemp{i+1}{k} + sum(lind(1:i));
        end
    end
end
for k=1:length(ZoneNames)
    if ~isempty(ZoneIndicesTemp{1})
        if ~isempty(ZoneIndicesTemp{1}{k})
            ZoneIndicesNew{k} = ZoneIndicesTemp{1}{k};
        else
            ZoneIndicesNew{k} = [];
        end
    else
        ZoneIndicesNew{k} = [];
    end
end
for i=2:length(FilesList)
    for k = 1:length(ZoneNames)
        if ~isempty(ZoneIndicesTemp{i})
            ZoneIndicesNew{k} = [ZoneIndicesNew{k}; ZoneIndicesTemp{i}{k}];
        end
    end
end
for i=1:length(ZoneNames)
    ZoneIndices.(ZoneNames{i}) = ZoneIndicesNew{i};
end
clear idx_Zone ZoneIndicesTemp ZoneIndicesNew

% Time in mouse temperature (it could be a bit different than in other arrays - no idea why)
for i = 1:length(FilesList)
    if isfield(a{i}, 'MouseTemp')
        MouseTempTime{i} = a{i}.MouseTemp(:,1);
    else
        MouseTempTime{i} = (Range(a{i}.Xtsd))/1e4;
    end
end
for i = 1:length(FilesList)
    durationTemp(i) = MouseTempTime{i}(end) - MouseTempTime{i}(1);
    offsetTemp(i) = MouseTempTime{i}(1);
    lindTemp(i) = length(MouseTempTime{i});
    lasttimeTemp(i) = MouseTempTime{i}(end);
end
clear MouseTempTime

%Concatenate MouseTemp (type - array)
for i=1:length(FilesList)
    if isfield(a{i}, 'MouseTemp')
        MouseTempTimeTemp{i} = a{i}.MouseTemp(:,1);
        MouseTempDataTemp{i} = a{i}.MouseTemp(:,2);
    else
        MouseTempTimeTemp{i} = a{i}.PosMat(:,1);
        MouseTempDataTemp{i} = nan(length(MouseTempTimeTemp{i}),1);
    end
end
for i=1:(length(FilesList)-1)
    MouseTempTimeTemp{i+1}(:,1) = MouseTempTimeTemp{i+1}(:,1) + (sum(durationTemp(1:i))) + sum(offsetTemp(1:i));
end
MouseTempTime = MouseTempTimeTemp{1};
MouseTempData = MouseTempDataTemp{1};
for i = 2:length(FilesList)
    MouseTempTime = [MouseTempTime; MouseTempTimeTemp{i}];
    MouseTempData = [MouseTempData; MouseTempDataTemp{i}];
end
MouseTemp = [MouseTempTime MouseTempData];
clear MouseTempTime MouseTempData MouseTempTimeTemp MouseTempDataTemp


%% Clear temporary variables
clear a duration durationTemp FilesList i indir k lasttime lasttimeTemp lind lindTemp offset offsetTemp TimeinSec TimeinTsd

%% Save common variables
if ~exist([pathtosave 'behavResources.mat'], 'file')
    disp('Creating behavResources.mat');
    save([pathtosave 'behavResources.mat']);
else
    save([pathtosave 'behavResources.mat'], 'behavResources', 'SessionEpoch', 'im_diff','im_diffInit', 'Imdifftsd', 'PosMat',...
        'PosMatInit', 'Vtsd', 'Xtsd', 'Ytsd', 'ThousandFrames','-append');
    if exist('GotFrame', 'var')
        save([pathtosave 'behavResources.mat'], 'GotFrame', '-append');
    end
    if exist('MouseTemp', 'var')
        save([pathtosave 'behavResources.mat'], 'MouseTemp', '-append');
    end
    if exist('ZoneNames', 'var')
        save([pathtosave 'behavResources.mat'], 'ZoneNames', '-append');
    end
    if exist('ZoneIndices', 'var')
        save([pathtosave 'behavResources.mat'], 'ZoneIndices', '-append');
    end 
    if exist('ZoneEpoch', 'var')
        save([pathtosave 'behavResources.mat'], 'ZoneEpoch', '-append');
    end 
    if exist('FreezeEpoch', 'var')
        save([pathtosave 'behavResources.mat'], 'FreezeEpoch', '-append');
    end 
end

end