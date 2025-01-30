% List
FilesList = {
%     '/media/nas5/ProjetERC2/Mouse-912/20190515/PAGexp/01-BaselineSleep/',...
%     '/media/nas5/ProjetERC2/Mouse-912/20190515/PAGexp/02-HabMaze2/',...
%     '/media/nas5/ProjetERC2/Mouse-912/20190515/PAGexp/03-HabMaze3/',...
%     '/media/nas5/ProjetERC2/Mouse-912/20190515/PAGexp/04-HabMaze1/',...
%     '/media/nas5/ProjetERC2/Mouse-912/20190515/PAGexp/05-HabMaze4/',...
    '/media/mobsrick/DataMOBS101/Mouse-994/20191013/PagExp/PreSleep/',...
    '/media/mobsrick/DataMOBS101/Mouse-994/20191013/PagExp/Hab/',...
    '/media/mobsrick/DataMOBS101/Mouse-994/20191013/PagExp/TestPre/TestPre1/',...
    '/media/mobsrick/DataMOBS101/Mouse-994/20191013/PagExp/TestPre/TestPre2/',...
    '/media/mobsrick/DataMOBS101/Mouse-994/20191013/PagExp/TestPre/TestPre3/',...
    '/media/mobsrick/DataMOBS101/Mouse-994/20191013/PagExp/TestPre/TestPre4/',...
    '/media/mobsrick/DataMOBS101/Mouse-994/20191013/PagExp/Cond/Cond1/',...
    '/media/mobsrick/DataMOBS101/Mouse-994/20191013/PagExp/Cond/Cond2/',...
    '/media/mobsrick/DataMOBS101/Mouse-994/20191013/PagExp/Cond/Cond3/',...
    '/media/mobsrick/DataMOBS101/Mouse-994/20191013/PagExp/Cond/Cond4/',...
    '/media/mobsrick/DataMOBS101/Mouse-994/20191013/PagExp/PostSleep/',...
    '/media/mobsrick/DataMOBS101/Mouse-994/20191013/PagExp/TestPost/TestPost1/',...
    '/media/mobsrick/DataMOBS101/Mouse-994/20191013/PagExp/TestPost/TestPost2/',...
    '/media/mobsrick/DataMOBS101/Mouse-994/20191013/PagExp/TestPost/TestPost3/',...
    '/media/mobsrick/DataMOBS101/Mouse-994/20191013/PagExp/TestPost/TestPost4/',...
   '/media/mobsrick/DataMOBS101/Mouse-994/20191013/PagExp/ExploAfter/'
};

% Concatenation
conc = '/media/mobsrick/DataMOBS101/Mouse-994/20191013/PagExp/_Concatenated/behavResources.mat';
T = load(conc, 'behavResources', 'tpsCatEvt', 'ZoneNames');


%% Load data
for i = 1:length(FilesList)
    a{i} = load([FilesList{i} 'behavResources.mat'], 'RAEpoch', 'RAUser', 'Xtsd', 'ZoneLabels');
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

% RAEpoch
for i=1:length(FilesList) % Epochs when the animals was situated in the Zone
    if isfield(a{i}, 'RAEpoch')
            RAEpochTempStart_ToShock{i} = Start(a{i}.RAEpoch.ToShock);
            RAEpochTempEnd_ToShock{i} = End(a{i}.RAEpoch.ToShock);
            RAEpochTempStart_ToSafe{i} = Start(a{i}.RAEpoch.ToSafe);
            RAEpochTempEnd_ToSafe{i} = End(a{i}.RAEpoch.ToSafe);
    else
        RAEpochTempStart_ToShock{i} = [];
        RAEpochTempStart_ToSafe{i} = [];
    end
end
for i=1:(length(FilesList)-1)
    if ~isempty(RAEpochTempStart_ToShock{i+1})
        RAEpochTempStart_ToShock{i+1} = RAEpochTempStart_ToShock{i+1} +sum(duration(1:i))*1e4;
        RAEpochTempEnd_ToShock{i+1} = RAEpochTempEnd_ToShock{i+1} +sum(duration(1:i))*1e4;
    end
    if ~isempty(RAEpochTempStart_ToSafe{i+1})
        RAEpochTempStart_ToSafe{i+1} = RAEpochTempStart_ToSafe{i+1} +sum(duration(1:i))*1e4;
        RAEpochTempEnd_ToSafe{i+1} = RAEpochTempEnd_ToSafe{i+1} +sum(duration(1:i))*1e4;
    end
end
for i=1:length(FilesList)
    if ~isempty (RAEpochTempStart_ToShock{i})
        T.behavResources(i).RAEpoch.ToShock = intervalSet(RAEpochTempStart_ToShock{i}, RAEpochTempEnd_ToShock{i});
        T.behavResources(i).RAEpoch.ToSafe = intervalSet(RAEpochTempStart_ToSafe{i}, RAEpochTempEnd_ToSafe{i});
    else
        T.behavResources(i).RAEpoch.ToShock = [];
        T.behavResources(i).RAEpoch.ToSafe = [];
    end
end
clear RAEpochTempStart_ToShock RAEpochTempEnd_ToShock RAEpochTempStart_ToSafe RAEpochTempEnd_ToSafe

% RAUser

% Get data
for i=1:length(FilesList) % tsd of X coordinates
    if isfield(a{i},'RAUser')
        if ~isempty(a{i}.RAUser.ToShock)
            RAUSerToShockTempTime{i} = a{i}.RAUser.ToShock.Time;
            RAUSerToShockTempIDX{i} = a{i}.RAUser.ToShock.idx;
            RAUSerToShockTempGrade{i} = a{i}.RAUser.ToShock.grade;
        else
            RAUSerToShockTempTime{i} = [];
            RAUSerToShockTempIDX{i} = [];
            RAUSerToShockTempGrade{i} = [];
        end
        if ~isempty(a{i}.RAUser.ToSafe)
            RAUSerToSafeTempTime{i} = a{i}.RAUser.ToSafe.Time;
            RAUSerToSafeTempIDX{i} = a{i}.RAUser.ToSafe.idx;
            RAUSerToSafeTempGrade{i} = a{i}.RAUser.ToSafe.grade;
        else
            RAUSerToSafeTempTime{i} = [];
            RAUSerToSafeTempIDX{i} = [];
            RAUSerToSafeTempGrade{i} = [];
        end

    else
        RAUSerToShockTempTime{i} = [];
        RAUSerToSafeTempTime{i} = [];
        
        RAUSerToShockTempIDX{i} = [];
        RAUSerToSafeTempIDX{i} = [];
        
        RAUSerToShockTempGrade{i} = [];
        RAUSerToSafeTempGrade{i} = [];
    end
end

% Add time
for i=1:(length(FilesList)-1)
    
    if ~isempty(RAUSerToShockTempTime{i+1})
        RAUSerToShockTempTime{i+1} = RAUSerToShockTempTime{i+1}+sum(duration(1:i));
    else
        RAUSerToShockTempTime{i+1} = [];
    end
    if ~isempty(RAUSerToSafeTempTime{i+1})
        RAUSerToSafeTempTime{i+1} = RAUSerToSafeTempTime{i+1}+sum(duration(1:i));
    else
        RAUSerToSafeTempTime{i+1} = [];
    end
    
    if ~isempty(RAUSerToShockTempIDX{i+1})
        RAUSerToShockTempIDX{i+1} = RAUSerToShockTempIDX{i+1}+sum(lind(1:i));
    else
        RAUSerToShockTempIDX{i+1} = [];
    end
    if ~isempty(RAUSerToSafeTempIDX{i+1})
        RAUSerToSafeTempIDX{i+1} = RAUSerToSafeTempIDX{i+1}+sum(lind(1:i));
    else
        RAUSerToSafeTempIDX{i+1} = [];
    end
    
end

% Write to final variable
for i = 1:length(FilesList)
    
    if ~isempty(RAUSerToShockTempTime{i})
        T.behavResources(i).RAUser.ToShock.Time = RAUSerToShockTempTime{i};
    else
        T.behavResources(i).RAUser.ToShock.Time = [];
    end
    if ~isempty(RAUSerToSafeTempTime{i})
        T.behavResources(i).RAUser.ToSafe.Time = RAUSerToSafeTempTime{i};
    else
        T.behavResources(i).RAUser.ToSafe.Time = [];
    end
    
    if ~isempty(RAUSerToShockTempIDX{i})
        T.behavResources(i).RAUser.ToShock.idx = RAUSerToShockTempIDX{i};
    else
        T.behavResources(i).RAUser.ToShock.idx = [];
    end
    if ~isempty(RAUSerToSafeTempIDX{i})
        T.behavResources(i).RAUser.ToSafe.idx = RAUSerToSafeTempIDX{i};
    else
        T.behavResources(i).RAUser.ToSafe.idx = [];
    end
    
    if ~isempty(RAUSerToShockTempGrade{i})
        T.behavResources(i).RAUser.ToShock.grade = RAUSerToShockTempGrade{i};
    else
        T.behavResources(i).RAUser.ToShock.grade = [];
    end
    if ~isempty(RAUSerToSafeTempGrade{i})
        T.behavResources(i).RAUser.ToSafe.grade = RAUSerToSafeTempGrade{i};
    else
        T.behavResources(i).RAUser.ToSafe.grade = [];
    end
end
clear RAUSerToShockTempTime RAUSerToSafeTempTime RAUSerToShockTempIDX RAUSerToSafeTempIDX RAUSerToShockTempGrade...
    RAUSerToSafeTempGrade

behavResources = T.behavResources;


%% Separate variables
% Concatenate RAEpoch (type intervalset)
for i=1:length(FilesList)
    if isfield(a{i}, 'RAEpoch')
        RAEpochTempStart_ToShock{i} = Start(a{i}.RAEpoch.ToShock);
        RAEpochTempEnd_ToShock{i} = End(a{i}.RAEpoch.ToShock);
        RAEpochTempStart_ToSafe{i} = Start(a{i}.RAEpoch.ToSafe);
        RAEpochTempEnd_ToSafe{i} = End(a{i}.RAEpoch.ToSafe);
    else
        RAEpochTempStart_ToShock{i} = [];
        RAEpochTempEnd_ToShock{i} = [];
        RAEpochTempStart_ToSafe{i} = [];
        RAEpochTempEnd_ToSafe{i} = [];
    end
end

for i=1:(length(FilesList)-1)
    if ~isempty (RAEpochTempStart_ToShock{i+1})
        RAEpochTempStart_ToShock{i+1} = RAEpochTempStart_ToShock{i+1} +sum(duration(1:i))*1e4;
        RAEpochTempEnd_ToShock{i+1} = RAEpochTempEnd_ToShock{i+1} +sum(duration(1:i))*1e4;
    end
    if ~isempty (RAEpochTempStart_ToSafe{i+1})
        RAEpochTempStart_ToSafe{i+1} = RAEpochTempStart_ToSafe{i+1} +sum(duration(1:i))*1e4;
        RAEpochTempEnd_ToSafe{i+1} = RAEpochTempEnd_ToSafe{i+1} +sum(duration(1:i))*1e4;
    end
end

if ~isempty(RAEpochTempStart_ToShock{1})
    RAEpochStart_ToShock = RAEpochTempStart_ToShock{1};
    RAEpochEnd_ToShock = RAEpochTempEnd_ToShock{1};
else
    RAEpochStart_ToShock = [];
    RAEpochEnd_ToShock = [];
end
if ~isempty(RAEpochTempStart_ToSafe{1})
    RAEpochStart_ToSafe = RAEpochTempStart_ToSafe{1};
    RAEpochEnd_ToSafe = RAEpochTempEnd_ToSafe{1};
else
    RAEpochStart_ToSafe = [];
    RAEpochEnd_ToSafe = [];
end

for i=2:length(FilesList)
    if ~isempty(RAEpochTempStart_ToShock{i})
        RAEpochStart_ToShock = [RAEpochStart_ToShock; RAEpochTempStart_ToShock{i}];
        RAEpochEnd_ToShock = [RAEpochEnd_ToShock; RAEpochTempEnd_ToShock{i}];
    end
    
    if ~isempty(RAEpochTempStart_ToSafe{i})
        RAEpochStart_ToSafe = [RAEpochStart_ToSafe; RAEpochTempStart_ToSafe{i}];
        RAEpochEnd_ToSafe = [RAEpochEnd_ToSafe; RAEpochTempEnd_ToSafe{i}];
    end
end

RAEpoch.ToShock = intervalSet(RAEpochStart_ToShock, RAEpochEnd_ToShock);
RAEpoch.ToSafe = intervalSet(RAEpochStart_ToSafe, RAEpochEnd_ToSafe);

clear RAEpochTempStart_ToShock RAEpochTempEnd_ToShock RAEpochTempStart_ToSafe RAEpochTempEnd_ToSafe...
    RAEpochStart_ToShock RAEpochEnd_ToShock RAEpochStart_ToSafe RAEpochEnd_ToSafe


% Concatenate RAUser (type single tsd)
for i=1:length(FilesList) % tsd of X coordinates
    if isfield(a{i},'RAUser')
        if ~isempty(a{i}.RAUser.ToShock)
            RAUSerToShockTempTime{i} = a{i}.RAUser.ToShock.Time;
            RAUSerToShockTempIDX{i} = a{i}.RAUser.ToShock.idx;
            RAUSerToShockTempGrade{i} = a{i}.RAUser.ToShock.grade;
        else
            RAUSerToShockTempTime{i} = [];
            RAUSerToShockTempIDX{i} = [];
            RAUSerToShockTempGrade{i} = [];
        end
        if ~isempty(a{i}.RAUser.ToSafe)
            RAUSerToSafeTempTime{i} = a{i}.RAUser.ToSafe.Time;
            RAUSerToSafeTempIDX{i} = a{i}.RAUser.ToSafe.idx;
            RAUSerToSafeTempGrade{i} = a{i}.RAUser.ToSafe.grade;
        else
            RAUSerToSafeTempTime{i} = [];
            RAUSerToSafeTempIDX{i} = [];
            RAUSerToSafeTempGrade{i} = [];
        end

    else
        RAUSerToShockTempTime{i} = [];
        RAUSerToSafeTempTime{i} = [];
        
        RAUSerToShockTempIDX{i} = [];
        RAUSerToSafeTempIDX{i} = [];
        
        RAUSerToShockTempGrade{i} = [];
        RAUSerToSafeTempGrade{i} = [];
    end
end



for i=1:(length(FilesList)-1)
    RAUSerToShockTempTime{i+1} = RAUSerToShockTempTime{i+1}+sum(duration(1:i));
    RAUSerToSafeTempTime{i+1} = RAUSerToSafeTempTime{i+1}+sum(duration(1:i));
    
    RAUSerToShockTempIDX{i+1} = RAUSerToShockTempIDX{i+1}+sum(lind(1:i));
    RAUSerToSafeTempIDX{i+1} = RAUSerToSafeTempIDX{i+1}+sum(lind(1:i));
end

RAUser.ToShock.Time = RAUSerToShockTempTime{1};
RAUser.ToSafe.Time = RAUSerToSafeTempTime{1};

RAUser.ToShock.idx = RAUSerToShockTempIDX{1};
RAUser.ToSafe.idx = RAUSerToSafeTempIDX{1};

RAUser.ToShock.grade = RAUSerToShockTempGrade{1};
RAUser.ToSafe.grade = RAUSerToSafeTempGrade{1};

for i = 2:length(FilesList)
    RAUser.ToShock.Time = [RAUser.ToShock.Time RAUSerToShockTempTime{i}];
    RAUser.ToSafe.Time = [RAUser.ToSafe.Time RAUSerToSafeTempTime{i}];
    
    RAUser.ToShock.idx = [RAUser.ToShock.idx RAUSerToShockTempIDX{i}];
    RAUser.ToSafe.idx = [RAUser.ToSafe.idx RAUSerToSafeTempIDX{i}];
    
    RAUser.ToShock.grade = [RAUser.ToShock.grade RAUSerToShockTempGrade{i}];
    RAUser.ToSafe.grade = [RAUser.ToSafe.grade RAUSerToSafeTempGrade{i}];
end

clear RAUSerToShockTempTime RAUSerToSafeTempTime RAUSerToShockTempIDX RAUSerToSafeTempIDX RAUSerToShockTempGrade...
    RAUSerToSafeTempGrade

%% Save

save(conc, 'behavResources','RAUser','RAEpoch', '-append');
