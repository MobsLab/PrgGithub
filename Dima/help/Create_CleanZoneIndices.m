% List
FilesList = {
%     '/media/nas5/ProjetERC2/Mouse-912/20190515/PAGexp/01-BaselineSleep/',...
%     '/media/nas5/ProjetERC2/Mouse-906/20190418/PAGExp/1-HabMaze1/',...
%     '/media/nas5/ProjetERC2/Mouse-882/20190409/PAGexp/HabBefore1/',...
%     '/media/nas5/ProjetERC2/Mouse-882/20190409/PAGexp/HabBefore2/',...
%     '/media/nas5/ProjetERC2/Mouse-882/20190409/PAGexp/HabBefore3/',...
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/PreSleep/',...
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/Hab/',...
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/TestPre/TestPre1/',...
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/TestPre/TestPre2/',...
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/TestPre/TestPre3/',...
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/TestPre/TestPre4/',...
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/Cond/Cond1/',...
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/Cond/Cond2/',...
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/Cond/Cond3/',...
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/Cond/Cond4/',...
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/PostSleep/',...
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/TestPost/TestPost1/',...
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/TestPost/TestPost2/',...
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/TestPost/TestPost3/',...
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/TestPost/TestPost4/'
%    '/media/nas5/ProjetERC2/Mouse-861/20190313/ExploAfter/'
};

% Concatenation
conc = '/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/_Concatenated/behavResources.mat';
T = load(conc, 'behavResources', 'tpsCatEvt', 'ZoneNames');

%% Load data
for i = 1:length(FilesList)
    a{i} = load([FilesList{i} 'behavResources.mat'], 'CleanXtsd','CleanYtsd','Zone',...
    'Ratio_IMAonREAL','ZoneIndices','ZoneEpoch','ZoneLabels', 'ZoneLabels','Xtsd');
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

% Concatenate ZoneIndices (type array of indices * N - number of Zones)
for i=1:length(FilesList) % Time indices of the occasions when the animal was in the Zone
    if isfield(a{i}, 'CleanXtsd')
        XXX = floor(Data(a{i}.CleanXtsd)*a{i}.Ratio_IMAonREAL);
        XXX(find(isnan(XXX))) = 320;
        YYY = floor(Data(a{i}.CleanYtsd)*a{i}.Ratio_IMAonREAL);
        YYY(find(isnan(YYY))) = 240;
        for k = 1:length(a{i}.ZoneIndices)
            ZoneIndicesTemp{i}{k}=find(diag(a{i}.Zone{k}(YYY,XXX)));
        end
    else
        ZoneIndicesTemp{i} = [];
    end
end
for i=1:length(FilesList)
    if ~isempty(ZoneIndicesTemp{i})
        for k = 1:length(ZoneIndicesTemp{i})
            T.behavResources(i).CleanZoneIndices{k} = ZoneIndicesTemp{i}{k};
        end
    else
        T.behavResources(i).CleanZoneIndices = ZoneIndicesTemp{i};
    end
end
clear ZoneIndicesTemp ZoneIndices XXX YYY

% Concatenate ZoneEpoch (type single tsa)
for i=1:length(FilesList) % Epochs when the animals was situated in the Zone
    if isfield(a{i}, 'CleanXtsd')
        Xtemp=Data(a{i}.CleanXtsd);
        T1=Range(a{i}.CleanXtsd);
        XXX = floor(Data(a{i}.CleanXtsd)*a{i}.Ratio_IMAonREAL);
        XXX(find(isnan(XXX))) = 320;
        YYY = floor(Data(a{i}.CleanYtsd)*a{i}.Ratio_IMAonREAL);
        YYY(find(isnan(YYY))) = 240;
        for k = 1:length(a{i}.ZoneEpoch)
            ZoneIndicesTemp{i}{k}=find(diag(a{i}.Zone{k}(YYY,XXX)));
            Xtemp2=Xtemp*0;
            Xtemp2(ZoneIndicesTemp{i}{k})=1;
            ZoneEpoch{i}{k}=thresholdIntervals(tsd(T1,Xtemp2),0.5,'Direction','Above');
        end
    else
        ZoneEpochTempStart{i} = [];
    end
end
for i=1:length(FilesList) % Epochs when the animals was situated in the Zone
    if isfield(a{i}, 'CleanXtsd')
        for k = 1:length(a{i}.ZoneEpoch)
            ZoneEpochTempStart{i}{k} = Start(ZoneEpoch{i}{k});
            ZoneEpochTempEnd{i}{k} = End(ZoneEpoch{i}{k});
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
        for k = 1:length(a{i}.ZoneEpoch)
            T.behavResources(i).CleanZoneEpoch{k} = intervalSet(ZoneEpochTempStart{i}{k}, ZoneEpochTempEnd{i}{k});
        end
    else
        T.behavResources(i).CleanZoneEpoch = [];
    end
end
clear ZoneEpochTempStart ZoneEpochTempEnd ZoneEpochStart ZoneEpochEnd Xtemp Xtemp2 T1 ZoneEpoch XXX YYY

behavResources = T.behavResources;

%% Separate variables

ZoneNames = T.ZoneNames;
        
% Concatenate ZoneEpoch (type single tsa)
for i=1:length(FilesList) % Epochs when the animals was situated in the Zone
    if isfield(a{i}, 'CleanXtsd')
        Xtemp=Data(a{i}.CleanXtsd);
        T1=Range(a{i}.CleanXtsd);
        XXX = floor(Data(a{i}.CleanXtsd)*a{i}.Ratio_IMAonREAL);
        XXX(find(isnan(XXX))) = 320;
        YYY = floor(Data(a{i}.CleanYtsd)*a{i}.Ratio_IMAonREAL);
        YYY(find(isnan(YYY))) = 240;
        for k = 1:length(a{i}.ZoneEpoch)
            ZoneIndicesTemp{i}{k}=find(diag(a{i}.Zone{k}(YYY,XXX)));
            Xtemp2=Xtemp*0;
            Xtemp2(ZoneIndicesTemp{i}{k})=1;
            ZoneEpoch{i}{k}=thresholdIntervals(tsd(T1,Xtemp2),0.5,'Direction','Above');
        end
    else
        ZoneEpochTempStart{i} = [];
    end
end

for i=1:length(FilesList)
    if isfield(a{i}, 'CleanXtsd')
        if isfield(a{i}, 'ZoneLabels')
            ZoneEpochTempStart{i} = cell(1,length(ZoneNames));
            ZoneEpochTempEnd{i} = cell(1,length(ZoneNames));
            for k = 1:length(a{i}.ZoneEpoch)
                idx_Zone = find(strcmp(a{i}.ZoneLabels{k}, ZoneNames));
                ZoneEpochTempStart{i}{idx_Zone} = Start(ZoneEpoch{i}{k});
                ZoneEpochTempEnd{i}{idx_Zone} = End(ZoneEpoch{i}{k});
            end
        end
    else
        ZoneEpochTempStart{i} = [];
        ZoneEpochTempEnd{i} = [];
    end
end
for i=1:(length(FilesList)-1)
    if ~isempty (ZoneEpochTempStart{i+1})
        for k = 1:length(ZoneNames)
            ZoneEpochTempStart{i+1}{k} = ZoneEpochTempStart{i+1}{k} +sum(duration(1:i))*1e4;
            ZoneEpochTempEnd{i+1}{k} = ZoneEpochTempEnd{i+1}{k} +sum(duration(1:i))*1e4;
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
    CleanZoneEpoch.(ZoneNames{i}) = intervalSet(ZoneEpochStart{i}, ZoneEpochEnd{i});
end
clear idx_Zone ZoneEpochTempStart ZoneEpochTempEnd ZoneEpochStart ZoneEpochEnd ZoneEpoch Xtemp Xtemp2 T1 XXX YYY

% Concatenate ZoneIndices (type array of indices * 7 - number of Zones)
for i=1:length(FilesList) % Time indices of the occasions when the animal was in the Zone
    if isfield(a{i}, 'CleanXtsd')
        XXX = floor(Data(a{i}.CleanXtsd)*a{i}.Ratio_IMAonREAL);
        XXX(find(isnan(XXX))) = 320;
        YYY = floor(Data(a{i}.CleanYtsd)*a{i}.Ratio_IMAonREAL);
        YYY(find(isnan(YYY))) = 240;
        for k = 1:length(a{i}.ZoneIndices)
            ZoneIndices{i}{k}=find(diag(a{i}.Zone{k}(YYY,XXX)));
        end
    else
        ZoneIndices{i} = [];
    end
end

for i=1:length(FilesList)
    if isfield(a{i}, 'ZoneIndices')
        ZoneIndicesTemp{i} = cell(1,length(ZoneNames));
        if ~isempty(ZoneIndices{i})
            for k = 1:length(a{i}.ZoneIndices)
                idx_Zone = find(strcmp(a{i}.ZoneLabels{k}, ZoneNames));
                ZoneIndicesTemp{i}{idx_Zone} = ZoneIndices{i}{k};
            end
        else
            ZoneIndicesTemp{i} = [];
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
    CleanZoneIndices.(ZoneNames{i}) = ZoneIndicesNew{i};
end
clear idx_Zone ZoneIndicesTemp ZoneIndicesNew XXX YYY


%% Save

save(conc, 'behavResources', 'CleanZoneEpoch','CleanZoneIndices','-append');
