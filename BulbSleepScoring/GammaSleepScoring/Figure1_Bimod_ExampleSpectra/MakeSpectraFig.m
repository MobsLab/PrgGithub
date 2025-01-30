%% This code was used for Fig1 in draft for 11th april 2016
%% Look at spectra using movement based scoring
clear all
struc={'B','H','PF','Pa'};

AllSlScoringMice
OldScoring=[1:3,5:8,13:15];

CalcSpectra=1;

if CalcSpectra
for file=1:m
    file
    cd(filename2{file})
    for st=1:4
        if not(isnan(chan(file,st)))
            LowSpectrumSB(filename2{file},chan(file,st),struc{st});
            HighSpectrum(filename2{file},chan(file,st),struc{st});
        end
    end
end
end

%% Low spectra
mousenum=1;
GetSpectra=cell(4,3);
for file=OldScoring
    file
    cd(filename2{file})
    clear SWSEpoch NoiseEpoch GndNoiseEpoch MovEpoch REMEpoch Wake
    try, load('StateEpoch.mat','SWSEpoch','REMEpoch','MovEpoch','NoiseEpoch','GndNoiseEpoch'), catch, load('StateEpochEMGSB.mat','SWSEpoch','REMEpoch','Wake','NoiseEpoch','GndNoiseEpoch'),MovEpoch=Wake; end
    for st=1:4
        if exist(strcat(struc{st},'_Low_Spectrum.mat'))==0
            GetSpectra{st,1}(mousenum,:)=NaN;
            GetSpectra{st,2}(mousenum,:)=NaN;
            GetSpectra{st,3}(mousenum,:)=NaN;
        else
        load(strcat(struc{st},'_Low_Spectrum.mat'))
        Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
        GetSpectra{st,1}(mousenum,:)=(nanmean(Data(Restrict(Sptsd,SWSEpoch-NoiseEpoch-GndNoiseEpoch))));
        GetSpectra{st,2}(mousenum,:)= (nanmean(Data(Restrict(Sptsd,MovEpoch-NoiseEpoch-GndNoiseEpoch))));
        GetSpectra{st,3}(mousenum,:)=(nanmean(Data(Restrict(Sptsd,REMEpoch-NoiseEpoch-GndNoiseEpoch))));
        end
    end
    mousenum=mousenum+1;
end

meanval=[];mousenum=1;
for file=OldScoring
    for st=1:4
        meanval(st,mousenum)=nanmean(nanmean(GetSpectra{st,1}(mousenum,:)))+nanmean(nanmean(GetSpectra{st,2}(mousenum,:)))+nanmean(nanmean(GetSpectra{st,3}(mousenum,:)));
    end
    mousenum=mousenum+1;
end
f1=Spectro{3};



%% High Spectra
mousenum=1;
GetSpectraH=cell(4,3);
for file=OldScoring
    file
    cd(filename2{file})
    clear SWSEpoch NoiseEpoch GndNoiseEpoch MovEpoch REMEpoch Wake
    try, load('StateEpoch.mat','SWSEpoch','REMEpoch','MovEpoch','NoiseEpoch','GndNoiseEpoch'), catch, load('StateEpochEMGSB.mat','SWSEpoch','REMEpoch','Wake','NoiseEpoch','GndNoiseEpoch'),MovEpoch=Wake; end
    for st=1:4
        if exist(strcat(struc{st},'_High_Spectrum.mat'))==0
            GetSpectraH{st,1}(mousenum,:)=NaN;
            GetSpectraH{st,2}(mousenum,:)=NaN;
            GetSpectraH{st,3}(mousenum,:)=NaN;
        else
        load(strcat(struc{st},'_High_Spectrum.mat'))
        Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
        GetSpectraH{st,1}(mousenum,:)=(nanmean(Data(Restrict(Sptsd,SWSEpoch-NoiseEpoch-GndNoiseEpoch))));
        GetSpectraH{st,2}(mousenum,:)= (nanmean(Data(Restrict(Sptsd,MovEpoch-NoiseEpoch-GndNoiseEpoch))));
        GetSpectraH{st,3}(mousenum,:)=(nanmean(Data(Restrict(Sptsd,REMEpoch-NoiseEpoch-GndNoiseEpoch))));
        end
    end
    mousenum=mousenum+1;
end
meanvalH=[];mousenum=1;
for file=OldScoring
    for st=1:4
        meanvalH(st,mousenum)=nanmean([nanmean(nanmean(GetSpectraH{st,1}(mousenum,:))),nanmean(nanmean(GetSpectraH{st,2}(mousenum,:))),nanmean(nanmean(GetSpectraH{st,3}(mousenum,:)))]);
    end
    mousenum=mousenum+1;
end
f2=Spectro{3};

save('/media/DataMOBSSlSc/SleepScoringMice/AnalysisResults/ResultsPapier/AllSpectra.mat','GetSpectraH'...
    'GetSpectra','meanval','meanvalH','f1','f2')

%%%%
load('/media/DataMOBSSlSc/SleepScoringMice/AnalysisResults/ResultsPapier/AllSpectra.mat')

% Plot spectra
struc={'B','H','PF','Pa'};
close all
for st=1:4
    fig=figure;
    temp=log(GetSpectra{st,1}([1:5,7:10],:)./(meanval(st,[1:5,7:10])'*ones(1,263)));
    g=shadedErrorBar(f1,nanmean(temp),[stdError(temp);stdError(temp)],'b');
    hold on
    temp=log(GetSpectra{st,2}([1:5,7:10],:)./(meanval(st,[1:5,7:10])'*ones(1,263)));
    g=shadedErrorBar(f1,nanmean(temp),[stdError(temp);stdError(temp)],'k');
    temp=log(GetSpectra{st,3}([1:5,7:10],:)./(meanval(st,[1:5,7:10])'*ones(1,263)));
    g=shadedErrorBar(f1,nanmean(temp),[stdError(temp);stdError(temp)],'r');
    title(struc{st})
    box off
    set(gca,'XTick',[0:50:20],'YTick',[-8:1:5])
    saveas(fig,['LowSpec',struc{st},'.fig'])
    close all
end


for st=1:4
    fig=figure;
    temp=log(GetSpectraH{st,1}([1:5,7:10],:)./(meanvalH(st,[1:5,7:10])'*ones(1,32)));
    g=shadedErrorBar(f2,runmean(nanmean(temp),3),[stdError(temp);stdError(temp)],'b');
    hold on
    temp=log(GetSpectraH{st,2}([1:5,7:10],:)./(meanvalH(st,[1:5,7:10])'*ones(1,32)));
    g=shadedErrorBar(f2,runmean(nanmean(temp),3),[stdError(temp);stdError(temp)],'k');
    temp=log(GetSpectraH{st,3}([1:5,7:10],:)./(meanvalH(st,[1:5,7:10])'*ones(1,32)));
    g=shadedErrorBar(f2,runmean(nanmean(temp),3),[stdError(temp);stdError(temp)],'r');
    title(struc{st})
    set(gca,'XTick',[20:40:100],'YTick',[-8:1:5])
    box off
    saveas(fig,['HighSpec',struc{st},'.fig'])
    close all
end

