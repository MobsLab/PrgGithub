% List
FilesList = {
%     '/media/nas5/ProjetERC2/Mouse-912/20190515/PAGexp/01-BaselineSleep/',...
%     '/media/nas5/ProjetERC2/Mouse-912/20190515/PAGexp/02-HabMaze2/',...
%     '/media/nas5/ProjetERC2/Mouse-912/20190515/PAGexp/03-HabMaze3/',...
%     '/media/nas5/ProjetERC2/Mouse-912/20190515/PAGexp/04-HabMaze1/',...
%     '/media/nas5/ProjetERC2/Mouse-912/20190515/PAGexp/05-HabMaze4/',...
    '/media/nas5/ProjetERC2/Mouse-977/20190812/PAGexp/PreSleep/',...
    '/media/nas5/ProjetERC2/Mouse-977/20190812/PAGexp/Hab/',...
    '/media/nas5/ProjetERC2/Mouse-977/20190812/PAGexp/TestPre/TestPre1/',...
    '/media/nas5/ProjetERC2/Mouse-977/20190812/PAGexp/TestPre/TestPre2/',...
    '/media/nas5/ProjetERC2/Mouse-977/20190812/PAGexp/TestPre/TestPre3/',...
    '/media/nas5/ProjetERC2/Mouse-977/20190812/PAGexp/TestPre/TestPre4/',...
    '/media/nas5/ProjetERC2/Mouse-977/20190812/PAGexp/Cond/Cond1/',...
    '/media/nas5/ProjetERC2/Mouse-977/20190812/PAGexp/Cond/Cond2/',...
    '/media/nas5/ProjetERC2/Mouse-977/20190812/PAGexp/Cond/Cond3/',...
    '/media/nas5/ProjetERC2/Mouse-977/20190812/PAGexp/Cond/Cond4/',...
    '/media/nas5/ProjetERC2/Mouse-977/20190812/PAGexp/PostSleep/',...
    '/media/nas5/ProjetERC2/Mouse-977/20190812/PAGexp/TestPost/TestPost1/',...
    '/media/nas5/ProjetERC2/Mouse-977/20190812/PAGexp/TestPost/TestPost2/',...
    '/media/nas5/ProjetERC2/Mouse-977/20190812/PAGexp/TestPost/TestPost3/',...
    '/media/nas5/ProjetERC2/Mouse-977/20190812/PAGexp/TestPost/TestPost4/',...
   '/media/nas5/ProjetERC2/Mouse-977/20190812/PAGexp/ExploAfter/'
};

% Concatenation
conc = '/media/nas5/ProjetERC2/Mouse-977/20190812/PAGexp/Concatenated/behavResources.mat';
T = load(conc, 'behavResources', 'tpsCatEvt', 'ZoneNames');

%% Load data
for i = 1:length(FilesList)
    a{i} = load([FilesList{i} 'behavResources.mat'], 'AlignedXtsd', 'AlignedYtsd', 'ZoneEpochAligned',...
        'LinearDist', 'Xtsd', 'ZoneLabels');
end

%% Calculate duration, find the first timestamp ('offset') and number of indices for each test
% find also last timestaps for each session ('lasttime')

for i = 1:length(FilesList)
    TimeTemp{i} = Range(a{i}.Xtsd);
    offset(i) = TimeTemp{i}(1);
    lind(i) = length(TimeTemp{i});
    lasttimeBeh(i) = TimeTemp{i}(end);
    ThousandFrames{i} = ts(TimeTemp{i}(1:1000:end));
end
clear TimeTemp

st = cell2mat(T.tpsCatEvt);
st = st(1:2:end);
en = cell2mat(T.tpsCatEvt);
en = en(2:2:end);

for i=1:length(st)
    duration(i) = en(i)-st(i);
    lasttime(i) = en(i);
end    


%% BehavResources
% AlignedXtsd
for i=1:length(FilesList) % tsd of X coordinates
    if isfield(a{i},'AlignedXtsd')
        XtsdTimeTemp{i} = Range(a{i}.AlignedXtsd);
        XtsdDataTemp{i} = Data(a{i}.AlignedXtsd);
    else
        XtsdTimeTemp{i} = [];
    end
end
for i=1:(length(FilesList)-1)
    if ~isempty(XtsdTimeTemp{i+1})
        XtsdTimeTemp{i+1} = XtsdTimeTemp{i+1}+sum(duration(1:i))*1e4;
    else
        XtsdTimeTemp{i+1} = [];
    end
end
for i = 1:length(FilesList)
    if ~isempty(XtsdTimeTemp{i})
        T.behavResources(i).AlignedXtsd = tsd(XtsdTimeTemp{i}, XtsdDataTemp{i});
    else
        T.behavResources(i).AlignedXtsd = [];
    end
end
clear XtsdTimeTemp XtsdDataTemp

% AlignedYtsd
for i=1:length(FilesList) % tsd of Y coordinates
    if isfield(a{i},'AlignedYtsd')
        YtsdTimeTemp{i} = Range(a{i}.AlignedYtsd);
        YtsdDataTemp{i} = Data(a{i}.AlignedYtsd);
    else
        YtsdTimeTemp{i} = [];
    end
end
for i=1:(length(FilesList)-1)
    if ~isempty(YtsdTimeTemp{i+1})
        YtsdTimeTemp{i+1} = YtsdTimeTemp{i+1}+sum(duration(1:i))*1e4;
    else
        YtsdTimeTemp{i+1} = [];
    end
end
for i = 1:length(FilesList)
    if ~isempty(YtsdTimeTemp{i})
       T.behavResources(i).AlignedYtsd = tsd(YtsdTimeTemp{i}, YtsdDataTemp{i});
    else
        T.behavResources(i).AlignedYtsd = [];
    end
end
clear YtsdTimeTemp YtsdDataTemp

% ZoneEpochAligned
for i=1:length(FilesList) % Epochs when the animals was situated in the Zone
    if isfield(a{i}, 'ZoneEpochAligned')
        for k = 1:length(a{i}.ZoneEpochAligned)
            ZoneEpochTempStart{i}{k} = Start(a{i}.ZoneEpochAligned{k});
            ZoneEpochTempEnd{i}{k} = End(a{i}.ZoneEpochAligned{k});
        end
    else
        ZoneEpochTempStart{i} = [];
    end
end
for i=1:(length(FilesList)-1)
    if ~isempty (ZoneEpochTempStart{i+1})
        for k = 1:length(ZoneEpochTempStart{i+1})
            ZoneEpochTempStart{i+1}{k} = ZoneEpochTempStart{i+1}{k} +sum(duration(1:i))*1e4;
            ZoneEpochTempEnd{i+1}{k} = ZoneEpochTempEnd{i+1}{k} +sum(duration(1:i))*1e4;
        end
    end
end
for i=1:length(FilesList)
    if ~isempty (ZoneEpochTempStart{i})
        for k = 1:length(a{i}.ZoneEpochAligned)
           T.behavResources(i).ZoneEpochAligned{k} = intervalSet(ZoneEpochTempStart{i}{k}, ZoneEpochTempEnd{i}{k});
        end
    else
        T.behavResources(i).ZoneEpochAligned = [];
    end
end
clear ZoneEpochTempStart ZoneEpochTempEnd ZoneEpochStart ZoneEpochEnd

% LinearDist
for i=1:length(FilesList) % tsd of X coordinates
    if isfield(a{i},'LinearDist')
        LinearDistTimeTemp{i} = Range(a{i}.LinearDist);
        LinearDistDataTemp{i} = Data(a{i}.LinearDist);
    else
        LinearDistTimeTemp{i} = [];
    end
end
for i=1:(length(FilesList)-1)
    if ~isempty(LinearDistTimeTemp{i+1})
        LinearDistTimeTemp{i+1} = LinearDistTimeTemp{i+1}+sum(duration(1:i))*1e4;
    else
        LinearDistTimeTemp{i+1} = [];
    end
end
for i = 1:length(FilesList)
    if ~isempty(LinearDistTimeTemp{i})
        T.behavResources(i).LinearDist = tsd(LinearDistTimeTemp{i}, LinearDistDataTemp{i});
    else
        T.behavResources(i).LinearDist = [];
    end
end
clear LinearDistTimeTemp LinearDistDataTemp

behavResources = T.behavResources;

%% Separate variables
% Concatenate Xtsd (type single tsd)
for i=1:length(FilesList)
    if isfield(a{i},'AlignedXtsd')
        XtsdTimeTemp{i} = Range(a{i}.AlignedXtsd);
        XtsdDataTemp{i} = Data(a{i}.AlignedXtsd);
    else
        XtsdTimeTemp{i} = Range(a{i}.Xtsd);
        XtsdDataTemp{i} = nan(length(XtsdTimeTemp{i}),1);
    end
end
for i=1:(length(FilesList)-1)
    XtsdTimeTemp{i+1} = XtsdTimeTemp{i+1}+sum(duration(1:i))*1e4;
end
XtsdTime = XtsdTimeTemp{1};
XtsdData = XtsdDataTemp{1};
for i = 2:length(FilesList)
    XtsdTime = [XtsdTime; XtsdTimeTemp{i}];
    XtsdData = [XtsdData; XtsdDataTemp{i}];
end
AlignedXtsd = tsd(XtsdTime, XtsdData);
clear XtsdTimeTemp XtsdDataTemp XtsdTime XtsdData


% Concatenate Ytsd (type single tsd)
for i=1:length(FilesList)
    if isfield(a{i},'AlignedYtsd')
        YtsdTimeTemp{i} = Range(a{i}.AlignedYtsd);
        YtsdDataTemp{i} = Data(a{i}.AlignedYtsd);
    else
        YtsdTimeTemp{i} = Range(a{i}.Xtsd);
        YtsdDataTemp{i} = nan(length(YtsdTimeTemp{i}),1);
    end
end
for i=1:(length(FilesList)-1)
    YtsdTimeTemp{i+1} = YtsdTimeTemp{i+1}+sum(duration(1:i))*1e4;
end
YtsdTime = YtsdTimeTemp{1};
YtsdData = YtsdDataTemp{1};
for i = 2:length(FilesList)
    YtsdTime = [YtsdTime; YtsdTimeTemp{i}];
    YtsdData = [YtsdData; YtsdDataTemp{i}];
end
AlignedYtsd = tsd(YtsdTime, YtsdData);
clear YtsdTimeTemp YtsdDataTemp YtsdTime YtsdData

% Concatenate ZoneEpochAligned (type single tsa) 
for i=1:length(FilesList)
    if isfield(a{i}, 'ZoneEpochAligned')
        if isfield(a{i}, 'ZoneLabels')
            ZoneEpochTempStart{i} = cell(1,length(T.ZoneNames));
            ZoneEpochTempEnd{i} = cell(1,length(T.ZoneNames));
            for k = 1:length(a{i}.ZoneEpochAligned)
                idx_Zone = find(strcmp(a{i}.ZoneLabels{k}, T.ZoneNames));
                ZoneEpochTempStart{i}{idx_Zone} = Start(a{i}.ZoneEpochAligned{k});
                ZoneEpochTempEnd{i}{idx_Zone} = End(a{i}.ZoneEpochAligned{k});
            end
        end
    else
        ZoneEpochTempStart{i} = [];
        ZoneEpochTempEnd{i} = [];
    end
end
for i=1:(length(FilesList)-1)
    if ~isempty (ZoneEpochTempStart{i+1})
        for k = 1:length(ZoneEpochTempStart{i+1})
            ZoneEpochTempStart{i+1}{k} = ZoneEpochTempStart{i+1}{k} +sum(duration(1:i))*1e4;
            ZoneEpochTempEnd{i+1}{k} = ZoneEpochTempEnd{i+1}{k} +sum(duration(1:i))*1e4;
        end
    end
end
for k=1:length(T.ZoneNames)
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
    for k = 1:length(T.ZoneNames)
        if ~isempty(ZoneEpochTempStart{i})
            ZoneEpochStart{k} = [ZoneEpochStart{k}; ZoneEpochTempStart{i}{k}];
            ZoneEpochEnd{k} = [ZoneEpochEnd{k}; ZoneEpochTempEnd{i}{k}];
        end
    end
end
for i=1:length(T.ZoneNames)
    ZoneEpochAligned.(T.ZoneNames{i}) = intervalSet(ZoneEpochStart{i}, ZoneEpochEnd{i});
end
clear idx_Zone ZoneEpochTempStart ZoneEpochTempEnd ZoneEpochStart ZoneEpochEnd


% Concatenate LinearDist (type single tsd)
for i=1:length(FilesList)
    if isfield(a{i},'LinearDist')
        LinearDistTimeTemp{i} = Range(a{i}.LinearDist);
        LinearDistDataTemp{i} = Data(a{i}.LinearDist);
    else
        LinearDistTimeTemp{i} = Range(a{i}.Xtsd);
        LinearDistDataTemp{i} = nan(length(LinearDistTimeTemp{i}),1);
    end
end
for i=1:(length(FilesList)-1)
    LinearDistTimeTemp{i+1} = LinearDistTimeTemp{i+1}+sum(duration(1:i))*1e4;
end
LinearDistTime = LinearDistTimeTemp{1};
LinearDistData = LinearDistDataTemp{1};
for i = 2:length(FilesList)
    LinearDistTime = [LinearDistTime; LinearDistTimeTemp{i}];
    LinearDistData = [LinearDistData; LinearDistDataTemp{i}];
end
LinearDist = tsd(LinearDistTime, LinearDistData);
clear LinearDistTimeTemp LinearDistDataTemp LinearDistTime LinearDistData

%% Save

save(conc, 'behavResources','AlignedXtsd','AlignedYtsd','ZoneEpochAligned','LinearDist','-append');
