clear all
SpeedThresh=3; % cm/s


% SessNames={'EPM','Habituation' 'SleepPreUMaze' 'TestPre' 'UMazeCond' 'SleepPostUMaze' 'TestPost' 'Extinction',...
%     'SoundHab' 'SleepPreSound' 'SoundCond' 'SleepPostSound' 'SoundTest','HabituationNight' 'SleepPreNight',...
%     'TestPreNight' 'UMazeCondNight' 'SleepPostNight' 'TestPostNight' 'ExtinctionNight'};
SessNames={ 'UMazeCond' 'UMazeCondNight' 'UMazeCond_EyeShock', 'UMazeCondBlockedShock_EyeShock', 'UMazeCondBlockedSafe_EyeShock'};

for ss=1:length(SessNames)
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    MouseToAvoid=[117,431]; % mice with noisy data to exclude
    Dir=RemoveElementsFromDir(Dir,'nmouse',MouseToAvoid);
    
    disp(SessNames{ss})
    for d=1:length(Dir.path)
        AllVals.(SessNames{ss}).Safe.WV{d}=[];         AllVals.(SessNames{ss}).Safe.PT{d}=[];
        AllVals.(SessNames{ss}).Shock.WV{d}=[];         AllVals.(SessNames{ss}).Shock.PT{d}=[];
        AllVals.(SessNames{ss}).All.WV{d}=[];         AllVals.(SessNames{ss}).All.PT{d}=[];
        AllVals.(SessNames{ss}).Run.WV{d}=[];         AllVals.(SessNames{ss}).Run.PT{d}=[];
        
        MouseName{ss,d}=num2str(Dir.ExpeInfo{d}{1}.nmouse);
        disp(d)
        for dd=1:length(Dir.path{d})
            cd(Dir.path{d}{dd})
            clear SleepyEpoch
            load('InstFreqAndPhase_B.mat','LocalFreq')
            load('behavResources_SB.mat')
            if not(isempty(Behav.FreezeAccEpoch))
                Behav.FreezeEpoch=Behav.FreezeAccEpoch;
            end
            load('StateEpochSB.mat','TotalNoiseEpoch')
            RemovEpoch=or(TTLInfo.StimEpoch,TotalNoiseEpoch);
            
            clear SleepyEpoch
            try,   load('StateEpochSB.mat','SleepyEpoch')
                RemovEpoch=or(RemovEpoch,SleepyEpoch);
            end
            
            %% UMaze
            %% On the safe side
            LitEp=and(Behav.FreezeEpoch,or(Behav.ZoneEpoch{2},Behav.ZoneEpoch{5}))-RemovEpoch;
            AllVals.(SessNames{ss}).Safe.WV{d}=[AllVals.(SessNames{ss}).Safe.WV{d};(Data(Restrict(LocalFreq.WV,LitEp)))];
            AllVals.(SessNames{ss}).Safe.PT{d}=[AllVals.(SessNames{ss}).Safe.PT{d};(Data(Restrict(LocalFreq.PT,LitEp)))];
            
            %% On the shock side
            LitEp=and(Behav.FreezeEpoch,Behav.ZoneEpoch{1})-RemovEpoch;
            AllVals.(SessNames{ss}).Shock.WV{d}=[AllVals.(SessNames{ss}).Shock.WV{d};(Data(Restrict(LocalFreq.WV,LitEp)))];
            AllVals.(SessNames{ss}).Shock.PT{d}=[AllVals.(SessNames{ss}).Shock.PT{d};(Data(Restrict(LocalFreq.PT,LitEp)))];
            
            %% AllTogether
            LitEp=Behav.FreezeEpoch-RemovEpoch;
            AllVals.(SessNames{ss}).All.WV{d}=[AllVals.(SessNames{ss}).All.WV{d};(Data(Restrict(LocalFreq.WV,LitEp)))];
            AllVals.(SessNames{ss}).All.PT{d}=[AllVals.(SessNames{ss}).All.PT{d};(Data(Restrict(LocalFreq.PT,LitEp)))];
            
            %% running Epoch
            dt=median(diff(Range(Behav.Vtsd,'s')));
            tps=Range(Behav.Xtsd);
            RunSpeed=tsd(tps(1:end-1),runmean((abs(diff(Data(Behav.Xtsd)))+abs(diff(Data(Behav.Ytsd))))./diff(Range(Behav.Xtsd,'s')),3));
            RunningEpoch=thresholdIntervals(RunSpeed,SpeedThresh,'Direction','Above');
            RunningEpoch=mergeCloseIntervals(RunningEpoch,1*1e4);
            RunningEpoch=dropShortIntervals(RunningEpoch,2*1e4);
            
            LitEp=RunningEpoch-RemovEpoch;
            AllVals.(SessNames{ss}).Run.WV{d}=[AllVals.(SessNames{ss}).Run.WV{d};(Data(Restrict(LocalFreq.WV,LitEp)))];
            AllVals.(SessNames{ss}).Run.PT{d}=[AllVals.(SessNames{ss}).Run.PT{d};(Data(Restrict(LocalFreq.PT,LitEp)))];
            
        end
    end
end


%% mi these
fig=figure;fig.Name=['AllCondWV'];
clear YNoSchk YSchk Ytest YCond
BinLims=[0.25:0.25:20];
% UMaze
for mm=1:size(AllVals.UMazeCond.Shock.WV,2)
    if not(isempty(AllVals.UMazeCond.Shock.WV{mm}))
        [YSchk(mm,:),X]=hist(AllVals.UMazeCond.Shock.WV{mm},BinLims);YSchk(mm,:)=YSchk(mm,:)./sum(YSchk(mm,:));
    else
        YSchk(mm,:)=nan(1,length(BinLims));
    end
    if not(isempty(AllVals.UMazeCond.Safe.WV{mm}))
        [YNoSchk(mm,:),X]=hist(AllVals.UMazeCond.Safe.WV{mm},BinLims);YNoSchk(mm,:)=YNoSchk(mm,:)./sum(YNoSchk(mm,:));
    else
        YNoSchk(mm,:)=nan(1,length(BinLims));
    end
end
subplot(311)
stairs(BinLims,smooth(nanmean(YNoSchk),5),'b','linewidth',3);
hold on
stairs(BinLims,smooth(nanmean(YSchk),5),'r','linewidth',3);

% UMazeNight
clear YNoSchk YSchk Ytest YCond
for mm=1:size(AllVals.UMazeCondNight.Shock.WV,2)
    if not(isempty(AllVals.UMazeCondNight.Shock.WV{mm}))
        [YSchk(mm,:),X]=hist(AllVals.UMazeCondNight.Shock.WV{mm},BinLims);YSchk(mm,:)=YSchk(mm,:)./sum(YSchk(mm,:));
    else
        YSchk(mm,:)=nan(1,length(BinLims));
    end
    if not(isempty(AllVals.UMazeCondNight.Safe.WV{mm}))
        [YNoSchk(mm,:),X]=hist(AllVals.UMazeCondNight.Safe.WV{mm},BinLims);YNoSchk(mm,:)=YNoSchk(mm,:)./sum(YNoSchk(mm,:));
    else
        YNoSchk(mm,:)=nan(1,length(BinLims));
    end
end

subplot(312)
stairs(BinLims,smooth(nanmean(YNoSchk),5),'b','linewidth',3);
hold on
stairs(BinLims,smooth(nanmean(YSchk),5),'r','linewidth',3);

% UMazeNight
clear YNoSchk YSchk Ytest YCond
for mm=1:size(AllVals.UMazeCond_EyeShock.Shock.WV,2)
    if not(isempty(AllVals.UMazeCond_EyeShock.Shock.WV{mm}))
        [YSchk(mm,:),X]=hist(AllVals.UMazeCond_EyeShock.Shock.WV{mm},BinLims);YSchk(mm,:)=YSchk(mm,:)./sum(YSchk(mm,:));
    else
        YSchk(mm,:)=nan(1,length(BinLims));
    end
    if not(isempty(AllVals.UMazeCond_EyeShock.Safe.WV{mm}))
        [YNoSchk(mm,:),X]=hist(AllVals.UMazeCond_EyeShock.Safe.WV{mm},BinLims);YNoSchk(mm,:)=YNoSchk(mm,:)./sum(YNoSchk(mm,:));
    else
        YNoSchk(mm,:)=nan(1,length(BinLims));
    end
end

subplot(313)
stairs(BinLims,smooth(nanmean(YNoSchk),5),'b','linewidth',3);
hold on
stairs(BinLims,smooth(nanmean(YSchk),5),'r','linewidth',3);


%%%%

fig=figure;fig.Name='UMazeWVsepmice';
for d=1:length(AllVals.Safe.WV)
    subplot(5,4,d)
    nhist({AllVals.Shock.WV{d},AllVals.Safe.WV{d},AllVals.Run.WV{d}},'binfactor',0.4)
    xlim([0 15]),line([3 3],ylim,'color','k','linewidth',2,'linestyle',':'),line([6 6],ylim,'color','k','linewidth',2,'linestyle',':')
    title(MouseName{1,d})
end
for d=1:length(AllVals.SafeNight.WV)
    subplot(5,4,d+length(AllVals.Safe.WV))
    nhist({AllVals.ShockNight.WV{d},AllVals.SafeNight.WV{d},AllVals.RuNight.WV{d}},'binfactor',0.4)
    xlim([0 15]),line([3 3],ylim,'color','k','linewidth',2,'linestyle',':'),line([6 6],ylim,'color','k','linewidth',2,'linestyle',':')
    title(MouseName{4,d})
end

fig=figure;fig.Name='UMazePTsepmice';
for d=1:length(AllVals.Safe.WV)
    subplot(5,4,d)
    nhist({AllVals.Shock.PT{d},AllVals.Safe.PT{d},AllVals.Run.PT{d}},'binfactor',2)
    xlim([0 15]),line([3 3],ylim,'color','k','linewidth',2,'linestyle',':'),line([6 6],ylim,'color','k','linewidth',2,'linestyle',':')
    title(MouseName{1,d})
end


fig=figure;fig.Name='UMazeAllFzPTsepmice';
for d=1:length(AllVals.Safe.WV)
    subplot(5,4,d)
    hist(AllVals.All.PT{d},100)
    xlim([0 15]),line([3 3],ylim,'color','k','linewidth',2,'linestyle',':'),line([6 6],ylim,'color','k','linewidth',2,'linestyle',':')
    title(MouseName{1,d})
end

fig=figure;fig.Name='UMazeAllFzWVsepmice';
for d=1:length(AllVals.Safe.WV)
    subplot(5,4,d)
    hist(AllVals.All.WV{d},500)
    xlim([0 15]),line([3 3],ylim,'color','k','linewidth',2,'linestyle',':'),line([6 6],ylim,'color','k','linewidth',2,'linestyle',':')
    title(MouseName{1,d})
end

fig=figure;fig.Name='SoundPTsepmice';
for d=1:length(AllVals.Safe.WV)
    subplot(5,4,d)
    nhist({AllVals.SoundTest.PT{d},AllVals.SoundCond.PT{d}},'samebins')
    xlim([0 15]),line([3 3],ylim,'color','k','linewidth',2,'linestyle',':'),line([6 6],ylim,'color','k','linewidth',2,'linestyle',':')
    title(MouseName{1,d})
end

fig=figure;fig.Name='SoundWVsepmice';
for d=1:length(AllVals.Safe.WV)
    subplot(5,4,d)
    nhist({AllVals.SoundTest.WV{d},AllVals.SoundCond.WV{d}},'samebins')
    xlim([0 15]),line([3 3],ylim,'color','k','linewidth',2,'linestyle',':'),line([6 6],ylim,'color','k','linewidth',2,'linestyle',':')
    title(MouseName{1,d})
end

fig=figure;fig.Name=['AllCondWV'];
clear YNoSchk YSchk Ytest YCond
BinLims=[0.25:0.25:20];
% exclude ouse with v little freezign and lots of baseline noise
for mm=1:size(AllVals.Shock.WV,2)
    if not(isempty(AllVals.Shock.WV{mm}))
        [YSchk(mm,:),X]=hist(AllVals.Shock.WV{mm},BinLims);YSchk(mm,:)=YSchk(mm,:)./sum(YSchk(mm,:));
    else
        YSchk(mm,:)=nan(1,length(BinLims));
    end
    if not(isempty(AllVals.Safe.WV{mm}))
        [YNoSchk(mm,:),X]=hist(AllVals.Safe.WV{mm},BinLims);YNoSchk(mm,:)=YNoSchk(mm,:)./sum(YNoSchk(mm,:));
    else
        YNoSchk(mm,:)=nan(1,length(BinLims));
    end
end

for mm=1:size(AllVals.SoundCond.WV,2)
    if not(isempty(AllVals.SoundCond.WV{mm}))
        [YCond(mm,:),X]=hist(AllVals.SoundCond.WV{mm},BinLims);YCond(mm,:)=YCond(mm,:)./sum(YCond(mm,:));
    else
        YCond(mm,:)=nan(1,length(BinLims));
    end
    if not(isempty(AllVals.SoundTest.WV{mm}))
        [Ytest(mm,:),X]=hist(AllVals.SoundTest.WV{mm},BinLims);Ytest(mm,:)=Ytest(mm,:)./sum(Ytest(mm,:));
    else
        Ytest(mm,:)=nan(1,length(BinLims));
    end
end


stairs(BinLims,smooth(nanmean(YNoSchk),5),'b','linewidth',3);
hold on
stairs(BinLims,smooth(nanmean(YSchk),5),'r','linewidth',3);
stairs(BinLims,smooth(nanmean(YCond),5),'m','linewidth',3);
stairs(BinLims,smooth(nanmean(Ytest),5),'c','linewidth',3);

xlim([1 15]),line([3 3],ylim,'color','k'),line([6 6],ylim,'color','k')


fig=figure;fig.Name=['AllCondPT '];
clear YNoSchk YSchk Ytest YCond
BinLims=[0.25:0.25:20];
% exclude ouse with v little freezign and lots of baseline noise
for mm=1:size(AllVals.Shock.PT,2)
    if not(isempty(AllVals.Shock.PT{mm}))
        [YSchk(mm,:),X]=hist(AllVals.Shock.PT{mm},BinLims);YSchk(mm,:)=YSchk(mm,:)./sum(YSchk(mm,:));
    else
        YSchk(mm,:)=nan(1,length(BinLims));
    end
    if not(isempty(AllVals.Safe.PT{mm}))
        [YNoSchk(mm,:),X]=hist(AllVals.Safe.PT{mm},BinLims);YNoSchk(mm,:)=YNoSchk(mm,:)./sum(YNoSchk(mm,:));
    else
        YNoSchk(mm,:)=nan(1,length(BinLims));
    end
end

for mm=1:size(AllVals.SoundCond.PT,2)
    if not(isempty(AllVals.SoundCond.PT{mm}))
        [YCond(mm,:),X]=hist(AllVals.SoundCond.PT{mm},BinLims);YCond(mm,:)=YCond(mm,:)./sum(YCond(mm,:));
    else
        YCond(mm,:)=nan(1,length(BinLims));
    end
    if not(isempty(AllVals.SoundTest.PT{mm}))
        [Ytest(mm,:),X]=hist(AllVals.SoundTest.PT{mm},BinLims);Ytest(mm,:)=Ytest(mm,:)./sum(Ytest(mm,:));
    else
        Ytest(mm,:)=nan(1,length(BinLims));
    end
end


stairs(BinLims,smooth(nanmean(YNoSchk),5),'b','linewidth',3);
hold on
stairs(BinLims,smooth(nanmean(YSchk),5),'r','linewidth',3);
stairs(BinLims,smooth(nanmean(YCond),5),'m','linewidth',3);
stairs(BinLims,smooth(nanmean(Ytest),5),'c','linewidth',3);
xlim([1 15]),line([3 3],ylim,'color','k'),line([6 6],ylim,'color','k')


fig=figure;fig.Name=['AllCondPT '];
YNoSchk=[]; YSchk=[]; Ytest=[]; YCond=[];
BinLims=[0.25:0.25:20];
% exclude ouse with v little freezign and lots of baseline noise
for mm=1:size(AllVals.Shock.PT,2)
    if not(isempty(AllVals.Shock.PT{mm}))
        YSchk=[YSchk;AllVals.Shock.PT{mm}];
    end
    
    if not(isempty(AllVals.Safe.PT{mm}))
        YNoSchk=[YNoSchk;AllVals.Safe.PT{mm}];
    end
end

for mm=1:size(AllVals.SoundCond.PT,2)
    if not(isempty(AllVals.SoundCond.PT{mm}))
        YCond=[YCond;AllVals.SoundCond.PT{mm}];
    end
    if not(isempty(AllVals.SoundTest.PT{mm}))
        Ytest=[Ytest;AllVals.SoundTest.PT{mm}];
    end
end
subplot(211)
histogram(YSchk,BinLims,'Normalization','pdf','FaceAlpha',0.6,'Facecolor','r');hold on
histogram(YNoSchk,BinLims,'Normalization','pdf','FaceAlpha',0.6,'Facecolor','b');hold on
xlim([1 15]),line([3 3],ylim,'color','k'),line([6 6],ylim,'color','k')
subplot(212)
histogram(YCond,BinLims,'Normalization','pdf','FaceAlpha',0.6,'Facecolor','r');hold on
histogram(Ytest,BinLims,'Normalization','pdf','FaceAlpha',0.6,'Facecolor','b');hold on
xlim([1 15]),line([3 3],ylim,'color','k'),line([6 6],ylim,'color','k')



fig=figure;fig.Name=['AllCondWV '];
YNoSchk=[]; YSchk=[]; Ytest=[]; YCond=[];
BinLims=[0.25:0.25:20];
for mm=1:size(AllVals.Shock.WV,2)
    if not(isempty(AllVals.Shock.WV{mm}))
        YSchk=[YSchk;AllVals.Shock.WV{mm}];
    end
    
    if not(isempty(AllVals.Safe.WV{mm}))
        YNoSchk=[YNoSchk;AllVals.Safe.WV{mm}];
    end
end
for mm=1:size(AllVals.ShockNight.WV,2)
    if not(isempty(AllVals.ShockNight.WV{mm}))
        YSchk=[YSchk;AllVals.ShockNight.WV{mm}];
    end
    
    if not(isempty(AllVals.SafeNight.WV{mm}))
        YNoSchk=[YNoSchk;AllVals.SafeNight.WV{mm}];
    end
end


for mm=1:size(AllVals.SoundCond.WV,2)
    if not(isempty(AllVals.SoundCond.WV{mm}))
        YCond=[YCond;AllVals.SoundCond.WV{mm}];
    end
    if not(isempty(AllVals.SoundTest.WV{mm}))
        Ytest=[Ytest;AllVals.SoundTest.WV{mm}];
    end
end
subplot(211)
histogram(YSchk,BinLims,'Normalization','pdf','FaceAlpha',0.6,'Facecolor','r');hold on
histogram(YNoSchk,BinLims,'Normalization','pdf','FaceAlpha',0.6,'Facecolor','b');hold on
xlim([1 15]),line([3 3],ylim,'color','k'),line([6 6],ylim,'color','k')
subplot(212)
histogram(YCond,BinLims,'Normalization','pdf','FaceAlpha',0.6,'Facecolor','r');hold on
histogram(Ytest,BinLims,'Normalization','pdf','FaceAlpha',0.6,'Facecolor','b');hold on
xlim([1 15]),line([3 3],ylim,'color','k'),line([6 6],ylim,'color','k')



%% Night and day
fig=figure;fig.Name=['AllCondPT '];
YNoSchk=[]; YSchk=[]; YNoSchkNight=[]; YSchkNight=[];
BinLims=[0.25:0.25:20];
% exclude ouse with v little freezign and lots of baseline noise
for mm=1:size(AllVals.Shock.PT,2)
    if not(isempty(AllVals.Shock.PT{mm}))
        YSchk=[YSchk;AllVals.Shock.PT{mm}];
    end
    
    if not(isempty(AllVals.Safe.PT{mm}))
        YNoSchk=[YNoSchk;AllVals.Safe.PT{mm}];
    end
end
% exclude ouse with v little freezign and lots of baseline noise
for mm=1:size(AllVals.ShockNight.PT,2)
    if not(isempty(AllVals.ShockNight.PT{mm}))
        YSchkNight=[YSchkNight;AllVals.ShockNight.PT{mm}];
    end
    
    if not(isempty(AllVals.SafeNight.PT{mm}))
        YNoSchkNight=[YNoSchkNight;AllVals.SafeNight.PT{mm}];
    end
end

subplot(211)
histogram(YSchk,BinLims,'Normalization','pdf','FaceAlpha',0.6,'Facecolor','r');hold on
histogram(YNoSchk,BinLims,'Normalization','pdf','FaceAlpha',0.6,'Facecolor','b');hold on
ylim([0 0.4])
xlim([1 15]),line([3 3],ylim,'color','k'),line([6 6],ylim,'color','k')
title('DayTime')
box off
subplot(212)
histogram(YSchkNight,BinLims,'Normalization','pdf','FaceAlpha',0.6,'Facecolor','r');hold on
histogram(YNoSchkNight,BinLims,'Normalization','pdf','FaceAlpha',0.6,'Facecolor','b');hold on
ylim([0 0.4])
xlim([1 15]),line([3 3],ylim,'color','k'),line([6 6],ylim,'color','k')
title('NightTime')
box off