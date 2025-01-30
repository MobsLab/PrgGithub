cd(GoTo)
SetCurrentSession(CurrSessName);

% Get limits of concatenated files
fid=fopen([FolderNameGen,'.cat.evt']);
LongString=fscanf(fid,'%s');
FileLim(1)=0;
for k=1:NumSessions
    tempname1=['beginningof',FolderNameGen,'-',sprintf('%2.2d',k)];
    tempname2=['endof',FolderNameGen,'-',sprintf('%2.2d',k)];
    FileLim(k+1)=eval(LongString(findstr(LongString,tempname1)+length(tempname1):findstr(LongString,tempname2)-1));
end
disp(' '); disp('SpikeData')
global DATA
s=GetSpikes('output','full');
tetrodeChannels=DATA.spikeGroups.groups;
sampleRate=20000;
NumberOfTetrodes=max(s(:,2));

% To get the quality indicator
tempInfo = xmltree([DATA.session.path,filesep,DATA.session.name,'.xml']);
UnitInfotemp = convert(tempInfo);
UnitInfo={};
for ee=1:size(UnitInfotemp.units.unit,2)
    UnitInfo{eval(UnitInfotemp.units.unit{ee}.group),eval(UnitInfotemp.units.unit{ee}.cluster)}=UnitInfotemp.units.unit{ee}.quality;
end

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
            Quality.MyMark{a}= UnitInfo{i,UnitNums{i}(j)};
            Quality.LRatio(a)=LRatio(j);
            Quality.IsoDistance(a)=distance(j);
            tempW = GetSpikeWaveforms([i UnitNums{i}(j)]);
            for elec=1:size(tempW,2)
                WF=tsd(Range(AllS{a}),squeeze(tempW(:,elec,:)));
                for k=1:NumSessions
                    AllW{k}{a}(elec,:)=mean(Data(Restrict(WF,intervalSet(FileLim(k)*10,FileLim(k+1)*10))),1); % Just made this modif - need to check
                end
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

%
% clear all
% load('behavResources.mat')
% fileIDT = fopen('pos.txt','w');
% XDat=Data(Behav.Xtsd);
% YDat=Data(Behav.Ytsd);
% fprintf(fileIDT,'%3.3f %3.3f\n',[XDat,YDat]'*10);
% fclose(fileIDT);
%
% figure
% for z=1:5
%     plot(Data(Restrict(Behav.Xtsd,Behav.ZoneEpoch{z})),Data(Restrict(Behav.Ytsd,Behav.ZoneEpoch{z}))), hold on
% end
%

% save waveforms, spike info and .clu and .res locally
for k=1:NumSessions
    cd([FolderToUseForUMaze,FolderName{k}])
    SubName=dir('*.lfp');
    SubName=SubName.name(1:end-4);
    for sp=1:length(AllW{1})
        W{sp}=AllW{k}{sp};
    end
    save('MeanWaveform.mat','W')
    clear W
    for sp=1:length(AllS)
        S{sp}=Restrict(AllS{sp},intervalSet(FileLim(k)*10,FileLim(k+1)*10));
        S{sp}=ts(Range(S{sp})-FileLim(k)*10);
    end
    save('SpikeData.mat','S','TT','Quality','cellnames','tetrodeChannels','-v7.3')
    clear S
    % make new .clu and .res to be able to look at clusters locally
    for i=1:NumberOfTetrodes
        %Just get one tetrode
        NewS=s(s(:,2)==i,:);
        NewSTps=NewS(NewS(:,1)>FileLim(k)/1e3&NewS(:,1)<FileLim(k+1)/1e3,:);
        NewSTps(:,1)=round(NewSTps(:,1)-FileLim(k)/1e3,5)*sampleRate;
        UnitNums{i}=[unique(s(s(:,2)==i,3))];
        fileIDT = fopen('tps.txt','w');
        fileIDC = fopen('clunum.txt','w');
        fprintf(fileIDC,'%.0f',length(UnitNums{i}));
        fprintf(fileIDC,'\n');
        for time=1:length(NewSTps)
            if time>1
                fprintf(fileIDT,'\n');
            end
            fprintf(fileIDT,'%.0f',NewSTps(time,1));
            if time>1
                fprintf(fileIDC,'\n');
            end
            fprintf(fileIDC,'%.0f',NewSTps(time,3));
        end
        fprintf(fileIDT,'\n');
        fprintf(fileIDC,'\n');
        fclose(fileIDT);fclose(fileIDC);
        movefile('tps.txt',[SubName,'.res.' num2str(i)])
        movefile('clunum.txt',[SubName,'.clu.' num2str(i)])
    end
    % make new .fet
    for i=1:NumberOfTetrodes
        %Just get one tetrode
        NewS=s(s(:,2)==i,:);
        NewSpikes=find(NewS(:,1)>FileLim(k)/1e3&NewS(:,1)<FileLim(k+1)/1e3);
        NewM=M{i}(NewSpikes+1,:);
        NewM(:,end)=NewM(:,end)-FileLim(k)*sampleRate/1000;
        fileIDT = fopen('fet.txt','w');
        fprintf(fileIDT,'%.0f',M{i}(1,1));
        fprintf(fileIDT,'\n');
        fprintf(fileIDT, [repmat('%d ',1,M{i}(1,1)-1) '%d' '\n'],NewM');
        fclose(fileIDT)
        movefile('fet.txt',[SubName,'.fet.' num2str(i)])
        NewName=[SubName,'.spk.' num2str(i)];
        SpikeTimesToUse=NewS(NewSpikes,1);
        CreateSpkFile(FilFile,SpikeTimesToUse,NumChannels,tetrodeChannels{i},NewName)
        movefile([GoTo,NewName],NewName)
    end
    copyfile([GoTo,'GoodStraightXML.xml'],[SubName,'.xml'])
    clear Behav XDat YDat TDat 
    try
        load('behavResources.mat')
        fileIDT = fopen('pos.txt','w');
        XDat=Data(Behav.Xtsd);
        YDat=Data(Behav.Ytsd);
        TDat=Range(Behav.Ytsd,'s');
        XDat=interp1(TDat,XDat,[min(TDat):0.05:max(TDat)])';
        YDat=interp1(TDat,YDat,[min(TDat):0.05:max(TDat)])';
        fprintf(fileIDT,'%3.3f %3.3f\n',[XDat,YDat]'*10);
        fclose(fileIDT);
        movefile('pos.txt',[SubName,'.pos'])
        clear XDat YDat TDat fileIDT
    end
end
