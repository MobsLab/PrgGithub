

clear all
file=dir('*.lfp');
FolderNameGen = [file.name(1:end-4) '_SpikeRef'];

SetCurrentSession(FolderNameGen);
% Get limits of concatenated files
disp(' '); disp('SpikeData')
global DATA
s=GetSpikes('output','full');
% the s matrix gives you all the basic info in columns, spike timing, which
% tetrode its on, which cluster of this tetrode it belongs to

tetrodeChannels=DATA.spikeGroups.groups;
sampleRate=20000;
NumberOfTetrodes=max(s(:,2));


% Get spike info
a=1;
for i=1:NumberOfTetrodes
    UnitNums{i}=[unique(s(s(:,2)==i,3))];
    % don't load MUA
    UnitNums{i}(UnitNums{i}<2)=[];
    
    features = LoadSpikeFeatures([FolderNameGen,'.clu.',num2str(i)],20000);
    if length(UnitNums{i})>0
        LRatio=[];distance=[];
        [distance,LRatio] = IsolationDistance(features);
    end
    
    for j=1:length(UnitNums{i})
        if length(find(s(:,2)==i&s(:,3)==UnitNums{i}(j)))>1
            AllS{a}=tsd(s(find(s(:,2)==i&s(:,3)==UnitNums{i}(j)),1)*1E4,s(find(s(:,2)==i&s(:,3)==UnitNums{i}(j)),1)*1E4);
            TT{a}=[i,UnitNums{i}(j)];
            cellnames{a}=['TT',num2str(i),'c',num2str(UnitNums{i}(j))];
            disp(['Cluster : ',cellnames{a},' > done'])
            Quality.LRatio(a)=LRatio(j);
            Quality.IsoDistance(a)=distance(j);
            tempW = GetSpikeWaveforms([i UnitNums{i}(j)]);
            for elec=1:size(tempW,2)
                WF=tsd(Range(AllS{a}),squeeze(tempW(:,elec,:)));
                    All{a}(elec,:)=mean(Data(WF),1); % Just made this modif - need to check
            end
            a=a+1;
        end
    end
    disp(['Tetrodes #',num2str(i),' > done'])
end

for i=1:NumberOfTetrodes
    M{i}=dlmread([FolderNameGen,'.fet.',num2str(i)]);
end


try
    AllS=tsdArray(AllS);
end
S=AllS;
save('SpikeData.mat','S','TT','Quality','cellnames','tetrodeChannels','-v7.3')
clear S
