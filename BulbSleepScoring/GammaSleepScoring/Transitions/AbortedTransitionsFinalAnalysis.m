%% What is happening during aborted transitions

%% Code used for 11th april draft
%% This code produces an example figure of transition zone and the duration of transition zones


clear all, close all
% Load Mice File Names
AllSlScoringMice



% All transitions --> before and after
for mm=1:m
    mm
    cd(filename2{mm})
    load('StateEpochSB.mat','SWSEpoch','Wake','REMEpoch')%     %Find transition zone
    TotDur=max([max(Stop(Wake)),max(Stop(SWSEpoch)),max(Stop(REMEpoch))])/1e4;
    load('TransLimsGam.mat')
    
    load('H_Low_Spectrum.mat');
    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
    for i=1:4
        StTime=Start(AbortTrans{i});
        StpTime=Stop(AbortTrans{i});
        for s=1:length(StTime)
            dur=StpTime(s)-StTime(s);
            tempEp=intervalSet(StTime(s)-dur,StTime(s));
            DatBefH{i,mm}(s,:)=mean(Data(Restrict(Sptsd,tempEp)),1);
            tempEp=intervalSet(StTime(s),StpTime(s));
            DatAftH{i,mm}(s,:)=mean(Data(Restrict(Sptsd,tempEp)),1);
        end
        
        if i==1 | i==4
            temp=dropShortIntervals(AbortTrans{i},3e4);
        else
            temp=dropShortIntervals(AbortTrans{i},0.5e4);
        end
        temp=intervalSet(Start(temp)-3e4,Start(temp)+3e4);
        a=Range(Restrict(Sptsd,subset(temp,2)))-Start(subset(temp,2));
        a=a(1:30);
        RefEp=ts(a);
        DatH{i,mm}=Data(Restrict(Sptsd,ts(Range(RefEp)+Start(subset(temp,2)))));
        for s=3:length(Start(temp))
            Ep=ts(Range(RefEp)+Start(subset(temp,s)));
            DatH{i,mm}=DatH{i,mm}+Data(Restrict(Sptsd,Ep));
        end
        DatH{i,mm}= DatH{i,mm}/length(Start(temp));
    end
    
    if exist('PF_Low_Spectrum.mat')>0
            load('PF_Low_Spectrum.mat');
        Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
        for i=1:4
            
            StTime=Start(AbortTrans{i});
            StpTime=Stop(AbortTrans{i});
            for s=1:length(StTime)
                dur=StpTime(s)-StTime(s);
                tempEp=intervalSet(StTime(s)-dur,StTime(s));
                DatBefP{i,mm}(s,:)=mean(Data(Restrict(Sptsd,tempEp)),1);
                tempEp=intervalSet(StTime(s),StpTime(s));
                DatAftP{i,mm}(s,:)=mean(Data(Restrict(Sptsd,tempEp)),1);
            end
            
            if i==1 | i==4
                temp=dropShortIntervals(AbortTrans{i},3e4);
            else
                temp=dropShortIntervals(AbortTrans{i},0.5e4);
            end
            temp=intervalSet(Start(temp)-3e4,Start(temp)+3e4);
            a=Range(Restrict(Sptsd,subset(temp,2)))-Start(subset(temp,2));
            a=a(1:30);
            RefEp=ts(a);
            DatP{i,mm}=Data(Restrict(Sptsd,ts(Range(RefEp)+Start(subset(temp,2)))));
            for s=3:length(Start(temp))
                Ep=ts(Range(RefEp)+Start(subset(temp,s)));
                DatP{i,mm}=DatP{i,mm}+Data(Restrict(Sptsd,Ep));
            end
            DatP{i,mm}= DatP{i,mm}/length(Start(temp));
        end
        
    end
end
    

close all
Titles={'WW','SW','WS','SS'};
% Spectrograms
clear Temp
    for i=1:4
        Temp{i}=zscore(DatH{i,1}');
    end

for mm=2:m
    for i=1:4
        Temp{i}=Temp{i}+zscore(DatH{i,mm}');
    end
end

figure
for i=1:4
subplot(2,2,i)
imagesc([1:30]/5-15/5,Spectro{3},(Temp{i})), axis xy
title(Titles{i})
caxis([-16 35])
end

clear Temp
  for i=1:4
        Temp{i}=zscore(DatP{i,1}');
    end
for mm=2:13
    for i=1:4
        Temp{i}=Temp{i}+zscore(DatP{i,mm}');
    end
end

figure
for i=1:4
subplot(2,2,i)
imagesc([1:30]/5-15/5,Spectro{3},(Temp{i})), axis xy
title(Titles{i})
caxis([-16 35])
end


clear Temp
% Spect After./Bef
for i=1:4
for mm=1:m
    Temp{i}(mm,:)=nanmean(DatAftH{i,mm})./nanmean(DatBefH{i,mm});
end
end

figure
for i=1:4
subplot(2,2,i)
shadedErrorBar(Spectro{3},nanmean(Temp{i}),[stdError(Temp{i});stdError(Temp{i})])
hold on
line([0 20],[1 1],'color','k')
title(Titles{i})
ylim([0.6 1.3])
end
clear Temp

for i=1:4
for mm=1:13
    Temp{i}(mm,:)=nanmean(DatAftP{i,mm})./nanmean(DatBefP{i,mm});
end
end

figure
for i=1:4
subplot(2,2,i)
shadedErrorBar(Spectro{3},nanmean(Temp{i}),[stdError(Temp{i});stdError(Temp{i})])
hold on
line([0 20],[1 1],'color','k')
title(Titles{i})
ylim([0.6 1.3])
end

