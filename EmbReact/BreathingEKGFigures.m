clear all,
Files1=PathForExperimentsEmbReactMontreal('UMazeCond');
Files2=PathForExperimentsEmbReactMontreal('UMazeCondNight');
Files.path=[Files1.path,Files2.path];
Files.ExpeInfo=[Files1.ExpeInfo,Files2.ExpeInfo];
MouseToAvoid=[117,431]; % mice with noisy data to exclude
Files=RemoveElementsFromDir(Files,'nmouse',MouseToAvoid);

% Get average spectra
clear SaveSpec
Struc={'B','H','PFCx'};
StrucName={'Bulb','dHPC','PFCx'};
WndwSz=2*1e4; % size of little window to extract frequency data
LimFreq=20;
SpeedThresh=3; % cm/s
% for ss=1:length(Struc)
ss=1;
clear SaveSpecNoShck SaveSpecShck SaveSpec
TimeLim=2; % set to 2
for mm=1:size(Files.path,2)
    mm
    MouseName.UMazeCond{mm}=num2str(Files.ExpeInfo{mm}{1}.nmouse);
AvailStruc=Files.ExpeInfo{mm}{1}.RecordElecs.structure;AvailStruc=[AvailStruc{:}];
if  not(isempty(findstr(AvailStruc,StrucName{ss})))
    for c=1:size(Files.path{mm},2)
        count1=1;count2=1;
        % Go to folder and load everything
        cd( Files.path{mm}{c})
        clear StimEpoch TotalNoiseEpoch EKG Spectro
        load('behavResources.mat')
        load('StateEpochSB.mat','TotalNoiseEpoch','SleepyEpoch')
        RemovEpoch=or(or(TTLInfo.StimEpoch,TotalNoiseEpoch),SleepyEpoch);
        load([Struc{ss},'_Low_Spectrum.mat'])
        Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
        
        if exist('HeartBeatInfo.mat')>0
            load('HeartBeatInfo.mat')
        else
            EKG=[];
        end
        
        
        %% On the safe side
        LitEp=and(Behav.FreezeEpoch,or(Behav.ZoneEpoch{2},Behav.ZoneEpoch{5}))-RemovEpoch;
        [AvSpectra.Safe{mm}{c},SpectraBySlice.Safe{mm}{c},SliceDur.Safe{mm}{c}]=CharacterizeSpectraEpoch(Sptsd,Spectro{3},LitEp,TimeLim);
        [HRInfo.Safe{mm}{c},HRSliceBySlice.Safe{mm}{c},SliceDur.Safe{mm}{c}]=CharacterizeHeartRateEpoch(EKG,LitEp,TimeLim);
        
        
        %% On the shock side
        LitEp=and(Behav.FreezeEpoch,Behav.ZoneEpoch{1})-RemovEpoch;
        [AvSpectra.Shock{mm}{c},SpectraBySlice.Shock{mm}{c},SliceDur.Shock{mm}{c}]=CharacterizeSpectraEpoch(Sptsd,Spectro{3},LitEp,TimeLim);
        [HRInfo.Shock{mm}{c},HRSliceBySlice.Shock{mm}{c},SliceDur.Shock{mm}{c}]=CharacterizeHeartRateEpoch(EKG,LitEp,TimeLim);
        
        %% AllTogether
        LitEp=Behav.FreezeEpoch-RemovEpoch;
        [AvSpectra.AllFz{mm}{c},SpectraBySlice.AllFz{mm}{c},SliceDur.AllFz{mm}{c}]=CharacterizeSpectraEpoch(Sptsd,Spectro{3},LitEp,TimeLim);
        [HRInfo.AllFz{mm}{c},HRSliceBySlice.AllFz{mm}{c},SliceDur.AllFz{mm}{c}]=CharacterizeHeartRateEpoch(EKG,LitEp,TimeLim);
        
        
        %% running Epoch
        dt=median(diff(Range(Behav.Movtsd,'s')));
        tps=Range(Behav.Xtsd);
        RunSpeed=tsd(tps(1:end-1),runmean((abs(diff(Data(Behav.Xtsd)))+abs(diff(Data(Behav.Ytsd))))./diff(Range(Behav.Xtsd,'s')),3));
        RunningEpoch=thresholdIntervals(RunSpeed,SpeedThresh,'Direction','Above');
        RunningEpoch=mergeCloseIntervals(RunningEpoch,1*1e4);
        RunningEpoch=dropShortIntervals(RunningEpoch,2*1e4);
        
        LitEp=RunningEpoch-RemovEpoch;
        [AvSpectra.Running{mm}{c},SpectraBySlice.Running{mm}{c},SliceDur.Running{mm}{c}]=CharacterizeSpectraEpoch(Sptsd,Spectro{3},LitEp,TimeLim);
        [HRInfo.Running{mm}{c},HRSliceBySlice.Running{mm}{c},SliceDur.Running{mm}{c}]=CharacterizeHeartRateEpoch(EKG,LitEp,TimeLim);
        
    end
    
end
end

Files=PathForExperimentsEmbReactMontreal('SoundTest');
MouseToAvoid=[117,431]; % mice with noisy data to exclude
Files=RemoveElementsFromDir(Files,'nmouse',MouseToAvoid);

% Get average spectra
clear SaveSpec
Struc={'B','H','PFCx'};
StrucName={'Bulb','dHPC','PFCx'};
% for ss=1:length(Struc)
ss=1;
clear SaveSpecNoShck SaveSpecShck SaveSpec
TimeLim=2; % set to 2
for mm=1:size(Files.path,2)
    mm
    MouseName.SoundTest{mm}=num2str(Files.ExpeInfo{mm}{1}.nmouse);
    
    AvailStruc=Files.ExpeInfo{mm}{1}.RecordElecs.structure;AvailStruc=[AvailStruc{:}];
    if  not(isempty(findstr(AvailStruc,StrucName{ss})))
        for c=1:size(Files.path{mm},2)
            count1=1;count2=1;
            % Go to folder and load everything
            cd( Files.path{mm}{c})
            clear StimEpoch TotalNoiseEpoch EKG Spectro SleepyEpoch
            load('behavResources.mat')
            load('StateEpochSB.mat','TotalNoiseEpoch','SleepyEpoch')
            RemovEpoch=or(or(TTLInfo.StimEpoch,TotalNoiseEpoch),SleepyEpoch);
            load([Struc{ss},'_Low_Spectrum.mat'])
            Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
            
            if exist('HeartBeatInfo.mat')>0
                load('HeartBeatInfo.mat')
            else
                EKG=[];
            end
            
            LitEp=and(Behav.FreezeEpoch,intervalSet(0,800*1e4))-RemovEpoch;
            [AvSpectra.SoundTest{mm}{c},SpectraBySlice.SoundTest{mm}{c},SliceDur.SoundTest{mm}{c}]=CharacterizeSpectraEpoch(Sptsd,Spectro{3},LitEp,TimeLim);
            [HRInfo.SoundTest{mm}{c},HRSliceBySlice.SoundTest{mm}{c},SliceDur.SoundTest{mm}{c}]=CharacterizeHeartRateEpoch(EKG,LitEp,TimeLim);
            
        end
        
    end
end

Files=PathForExperimentsEmbReactMontreal('SoundCond');
MouseToAvoid=[117,431]; % mice with noisy data to exclude
Files=RemoveElementsFromDir(Files,'nmouse',MouseToAvoid);

% Get average spectra
clear SaveSpec
Struc={'B','H','PFCx'};
StrucName={'Bulb','dHPC','PFCx'};
WndwSz=2*1e4; % size of little window to extract frequency data
LimFreq=20;

% for ss=1:length(Struc)
ss=1;
clear SaveSpecNoShck SaveSpecShck SaveSpec
TimeLim=2; % set to 2
for mm=1:size(Files.path,2)
    mm
    MouseName.SoundCond{mm}=num2str(Files.ExpeInfo{mm}{1}.nmouse);
    
    AvailStruc=Files.ExpeInfo{mm}{1}.RecordElecs.structure;AvailStruc=[AvailStruc{:}];
    if  not(isempty(findstr(AvailStruc,StrucName{ss})))
        for c=1:size(Files.path{mm},2)
            count1=1;count2=1;
            % Go to folder and load everything
            cd( Files.path{mm}{c})
            clear StimEpoch TotalNoiseEpoch EKG Spectro SleepyEpoch
            load('behavResources.mat')
            load('StateEpochSB.mat','TotalNoiseEpoch','SleepyEpoch')
            RemovEpoch=or(or(TTLInfo.StimEpoch,TotalNoiseEpoch),SleepyEpoch);
            load([Struc{ss},'_Low_Spectrum.mat'])
            Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
            
            if exist('HeartBeatInfo.mat')>0
                load('HeartBeatInfo.mat')
            else
                EKG=[];
            end
            
            
            LitEp=Behav.FreezeEpoch-RemovEpoch;
            [AvSpectra.SoundCond{mm}{c},SpectraBySlice.SoundCond{mm}{c},SliceDur.SoundCond{mm}{c}]=CharacterizeSpectraEpoch(Sptsd,Spectro{3},LitEp,TimeLim);
            [HRInfo.SoundCond{mm}{c},HRSliceBySlice.SoundCond{mm}{c},SliceDur.SoundCond{mm}{c}]=CharacterizeHeartRateEpoch(EKG,LitEp,TimeLim);
            
        end
        
    end
end
f=Spectro{3};
cd('/media/sophie/My Passport1/ProjectEmbReac/Figures/March2017')
save('EKGBreathing.mat','HRInfo','HRSliceBySlice','SliceDur','AvSpectra','SpectraBySlice','SliceDur','MouseName','f')

%%%%
clear all
cd('/media/sophie/My Passport1/ProjectEmbReac/Figures/March2017')
load('EKGBreathing.mat')
ss=1;LimFreq=20;
Struc={'Bulb','dHPC','PFCx'};
fig=figure;fig.Name=[Struc{ss},'Av spec Sep Animals'];
for mm=1:size(AvSpectra.Shock,2)
    subplot(ceil(size(AvSpectra.Shock,2)/4),4,mm)
    % Shock
    tempSpec=[];
    for c=1:size(AvSpectra.Shock{mm},2)
        tempSpec=[tempSpec;AvSpectra.Shock{mm}{c}];
    end
    plot(f,nanmean(tempSpec),'r','linewidth',3),hold on
    % Safe
    tempSpec=[];
    for c=1:size(AvSpectra.Safe{mm},2)
        tempSpec=[tempSpec;AvSpectra.Safe{mm}{c}];
    end
    plot(f,nanmean(tempSpec),'b','linewidth',3),hold on
    title(MouseName.UMazeCond{mm})
    xlim([1 15]),line([3 3],ylim,'color','k','linewidth',2,'linestyle',':'),line([6 6],ylim,'color','k','linewidth',2,'linestyle',':')
end
saveas(fig.Number,[strrep(fig.Name,' ','_'),'.png'])
saveas(fig.Number,[strrep(fig.Name,' ','_'),'.fig'])
close(fig)

fig=figure;fig.Name=[Struc{ss},'Av spec'];
MeanSpecShk=[];    MeanSpecNoShk=[]; MeanSpecRun=[];
for mm=1:size(AvSpectra.Shock,2)
    % Shock
    tempSpec=[];
    for c=1:size(AvSpectra.Shock{mm},2)
        tempSpec=[tempSpec;AvSpectra.Shock{mm}{c}];
    end
    if not(isempty(tempSpec))
        % normalize by total power for between mice averaging
        MeanSpecShk=[MeanSpecShk;nanmean(tempSpec)./nanmean(nanmean(tempSpec(:,LimFreq:end)))];
    end
    
    % Safe
    tempSpec=[];
    for c=1:size(AvSpectra.Safe{mm},2)
        tempSpec=[tempSpec;AvSpectra.Safe{mm}{c}];
    end
    if not(isempty(tempSpec))
        MeanSpecNoShk=[MeanSpecNoShk;nanmean(tempSpec)./nanmean(nanmean(tempSpec(:,LimFreq:end)))];
    end
    
    % Run
    tempSpec=[];
    for c=1:size(AvSpectra.Running{mm},2)
        tempSpec=[tempSpec;AvSpectra.Running{mm}{c}];
    end
    if not(isempty(tempSpec))
        MeanSpecRun=[MeanSpecRun;nanmean(tempSpec)./nanmean(nanmean(tempSpec(:,LimFreq:end)))];
    end
end
hold on
g=shadedErrorBar(f,nanmean(MeanSpecShk),[stdError(MeanSpecShk);stdError(MeanSpecShk)],'r')
g=shadedErrorBar(f,nanmean(MeanSpecNoShk),[stdError(MeanSpecNoShk);stdError(MeanSpecNoShk)],'b')
g=shadedErrorBar(f,nanmean(MeanSpecRun),[stdError(MeanSpecRun);stdError(MeanSpecRun)],'k')
xlim([1 15]),line([3 3],ylim,'color','k'),line([6 6],ylim,'color','k')
saveas(fig.Number,[strrep(fig.Name,' ','_'),'.png'])
saveas(fig.Number,[strrep(fig.Name,' ','_'),'.fig'])
close(fig)

fig=figure;fig.Name=[Struc{ss},'Av spec heat Map Indiv'];
subplot(211)
MeanSpecShk(find(sum(isnan(MeanSpecShk)')==263),:)=[];
MeanSpecShk=MeanSpecShk(:,15:end);
caxis([-1 3])
imagesc(f(15:end),[1:19],zscore(MeanSpecShk')')
title('Shock side')
subplot(212)
MeanSpecNoShk(find(sum(isnan(MeanSpecNoShk)')==263),:)=[];
MeanSpecNoShk=MeanSpecNoShk(:,15:end);
imagesc(f(15:end),[1:19],zscore(MeanSpecNoShk')')
caxis([-1 3])
title('No shock side')
xlabel('Frequency (Hz)')
saveas(fig.Number,[strrep(fig.Name,' ','_'),'.png'])
saveas(fig.Number,[strrep(fig.Name,' ','_'),'.fig'])
close(fig)


fig=figure;fig.Name=[Struc{ss},'Av spec AllFz'];
MeanSpecAllFz=[];
for mm=1:size(AvSpectra.Shock,2)
    % Shock
    tempSpec=[];
    for c=1:size(AvSpectra.AllFz{mm},2)
        tempSpec=[tempSpec;AvSpectra.AllFz{mm}{c}];
    end
    if not(isempty(tempSpec))
        % normalize by total power for between mice averaging
        MeanSpecAllFz=[MeanSpecAllFz;nanmean(tempSpec)./nanmean(nanmean(tempSpec(:,LimFreq:end)))];
    end
    
    
end
hold on
g=shadedErrorBar(f,nanmean(MeanSpecAllFz),[stdError(MeanSpecAllFz);stdError(MeanSpecAllFz)],'g')
xlim([1 15]),line([3 3],ylim,'color','k'),line([6 6],ylim,'color','k')
saveas(fig.Number,[strrep(fig.Name,' ','_'),'.png'])
saveas(fig.Number,[strrep(fig.Name,' ','_'),'.fig'])
close(fig)


% Look at distributions of peak frequencies
fig=figure;fig.Name=[Struc{ss},'Freq Dist'];
f=Spectro{3};
fShck=[];fNoShck=[];fRun=[];
for mm=1:size(SpectraBySlice.Safe,2)
    mm
    for c=1:size(SpectraBySlice.Safe{mm},2)
        if not(isempty(SpectraBySlice.Safe{mm}{c}))
            for k=1:size(SpectraBySlice.Safe{mm}{c},1)
                [val,ind]=max(SpectraBySlice.Safe{mm}{c}(k,LimFreq:end)); ind=ind+LimFreq;
                fNoShck=[fNoShck,f(ind)];
            end
        end
    end
    for c=1:size(SpectraBySlice.Shock{mm},2)
        try
            if not(isempty(SpectraBySlice.Shock{mm}{c}))
                for k=1:size(SpectraBySlice.Shock{mm}{c},1)
                    [val,ind]=max(SpectraBySlice.Shock{mm}{c}(k,LimFreq:end)); ind=ind+LimFreq;
                    fShck=[fShck,f(ind)];
                end
            end
        end
    end
    for c=1:size(SpectraBySlice.Running{mm},2)
        try
            if not(isempty(SpectraBySlice.Running{mm}{c}))
                for k=1:size(SpectraBySlice.Running{mm}{c},1)
                    [val,ind]=max(SpectraBySlice.Running{mm}{c}(k,40:end)); ind=ind+LimFreq;
                    fRun=[fRun,f(ind)];
                end
            end
        end
    end
end
nhist({fNoShck,fShck},'samebins')
xlim([1 15]),line([3 3],ylim,'color','k'),line([6 6],ylim,'color','k')
saveas(fig.Number,[strrep(fig.Name,' ','_'),'.png'])
saveas(fig.Number,[strrep(fig.Name,' ','_'),'.fig'])
close(fig)

fig=figure;fig.Name=[Struc{ss},'Freq Dist wirun'];
nhist({fNoShck,fShck,fRun},'samebins')
xlim([1 15]),line([3 3],ylim,'color','k'),line([6 6],ylim,'color','k')
saveas(fig.Number,[strrep(fig.Name,' ','_'),'.png'])
saveas(fig.Number,[strrep(fig.Name,' ','_'),'.fig'])
close(fig)


fig=figure;fig.Name=[Struc{ss},'Indiv Freq Distrib'];
clear fShck fNoShck
f=Spectro{3};
for mm=1:size(SpectraBySlice.Safe,2)
    fShck{mm}=[];fNoShck{mm}=[];
    subplot(ceil(size(SpectraBySlice.Safe,2)/4),4,mm)
    
    for c=1:size(SpectraBySlice.Safe{mm},2)
        if not(isempty(SpectraBySlice.Safe{mm}{c}))
            for k=1:size(SpectraBySlice.Safe{mm}{c},1)
                [val,ind]=max(SpectraBySlice.Safe{mm}{c}(k,LimFreq:end)); ind=ind+LimFreq;
                fNoShck{mm}=[fNoShck{mm},f(ind)];
            end
        end
    end
    for c=1:size(SpectraBySlice.Safe{mm},2)
        try
            if not(isempty(SpectraBySlice.Shock{mm}{c}))
                for k=1:size(SpectraBySlice.Shock{mm}{c},1)
                    [val,ind]=max(SpectraBySlice.Shock{mm}{c}(k,LimFreq:end)); ind=ind+LimFreq;
                    fShck{mm}=[fShck{mm},f(ind)];
                end
            end
        end
    end
    nhist({fNoShck{mm},fShck{mm}},'samebins','binfactor',0.5)
    title(MouseName.UMazeCond{mm})
    xlim([1 10]),line([3 3],ylim,'color','k','linewidth',2,'linestyle',':'),line([6 6],ylim,'color','k','linewidth',2,'linestyle',':')
end
saveas(fig.Number,[strrep(fig.Name,' ','_'),'.png'])
saveas(fig.Number,[strrep(fig.Name,' ','_'),'.fig'])
close(fig)

fig=figure;fig.Name=[Struc{ss},'Freq Dist Av Of Mice '];
clear YNoSchk YSchk
BinLims=[0.25:0.25:20];
% exclude ouse with v little freezign and lots of baseline noise
for mm=1:size(SpectraBySlice.Safe,2)
    if not(isempty(fShck{mm}))
        [YSchk(mm,:),X]=hist(fShck{mm},BinLims);YSchk(mm,:)=YSchk(mm,:)./sum(YSchk(mm,:));
    else
        YSchk(mm,:)=nan(1,length(BinLims));
    end
    if not(isempty(fNoShck{mm}))
        [YNoSchk(mm,:),X]=hist(fNoShck{mm},BinLims);YNoSchk(mm,:)=YNoSchk(mm,:)./sum(YNoSchk(mm,:));
    else
        YNoSchk(mm,:)=nan(1,length(BinLims));
    end
end
stairs(BinLims,smooth(nanmean(YNoSchk),5),'b','linewidth',3);
hold on
stairs(BinLims,smooth(nanmean(YSchk),5),'r','linewidth',3);
xlim([1 15]),line([3 3],ylim,'color','k'),line([6 6],ylim,'color','k')
saveas(fig.Number,[strrep(fig.Name,' ','_'),'.png'])
saveas(fig.Number,[strrep(fig.Name,' ','_'),'.fig'])
close(fig)

%% sound
fig=figure;fig.Name=[Struc{ss},'Av spec Sound'];
MeanSpecSoundCond=[];    MeanSpecSoundTest=[];
c=1;
for mm=1:size(AvSpectra.SoundCond,2)
    % Sound Cond
    MeanSpecSoundCond=[MeanSpecSoundCond;(AvSpectra.SoundCond{mm}{c})./(nanmean(AvSpectra.SoundCond{mm}{c}(:,LimFreq:end)))];
    % Soundtest
    MeanSpecSoundTest=[MeanSpecSoundTest;(AvSpectra.SoundTest{mm}{c})./(nanmean(AvSpectra.SoundTest{mm}{c}(:,LimFreq:end)))];
end
hold on
g=shadedErrorBar(f,nanmean(MeanSpecSoundCond),[stdError(MeanSpecSoundCond);stdError(MeanSpecSoundCond)],'r')
g=shadedErrorBar(f,nanmean(MeanSpecSoundTest),[stdError(MeanSpecSoundTest);stdError(MeanSpecSoundTest)],'b')
xlim([1 15]),line([3 3],ylim,'color','k'),line([6 6],ylim,'color','k')
saveas(fig.Number,[strrep(fig.Name,' ','_'),'.png'])
saveas(fig.Number,[strrep(fig.Name,' ','_'),'.fig'])
close(fig)

fig=figure;fig.Name=[Struc{ss},'Av spec Sep Animals Sound'];
c=1;
for mm=1:size(AvSpectra.SoundCond,2)
    subplot(ceil(size(AvSpectra.SoundCond,2)/4),4,mm)
    plot(Spectro{3},AvSpectra.SoundCond{mm}{c},'r','linewidth',3),hold on
    plot(Spectro{3},AvSpectra.SoundTest{mm}{c},'b','linewidth',3),hold on
    title(MouseName.SoundCond{mm})
    xlim([1 15]),line([3 3],ylim,'color','k','linewidth',2,'linestyle',':'),line([6 6],ylim,'color','k','linewidth',2,'linestyle',':')
end
saveas(fig.Number,[strrep(fig.Name,' ','_'),'.png'])
saveas(fig.Number,[strrep(fig.Name,' ','_'),'.fig'])
close(fig)

% Look at distributions of peak frequencies
fig=figure;fig.Name=[Struc{ss},'Freq Dist sound'];
f=Spectro{3};
fCond=[];fTest=[];
for mm=1:size(SpectraBySlice.SoundCond,2)
    mm
    for c=1
        if not(isempty(SpectraBySlice.SoundCond{mm}{c}))
            for k=1:size(SpectraBySlice.SoundCond{mm}{c},1)
                [val,ind]=max(SpectraBySlice.SoundCond{mm}{c}(k,LimFreq:end)); ind=ind+LimFreq;
                fCond=[fCond,f(ind)];
            end
        end
    end
    for c=1
        if not(isempty(SpectraBySlice.SoundTest{mm}{c}))
            for k=1:size(SpectraBySlice.SoundTest{mm}{c},1)
                [val,ind]=max(SpectraBySlice.SoundTest{mm}{c}(k,LimFreq:end)); ind=ind+LimFreq;
                fTest=[fTest,f(ind)];
            end
        end
    end
    
end
nhist({fCond,fTest},'samebins')
xlim([1 15]),line([3 3],ylim,'color','k'),line([6 6],ylim,'color','k')
saveas(fig.Number,[strrep(fig.Name,' ','_'),'.png'])
saveas(fig.Number,[strrep(fig.Name,' ','_'),'.fig'])
close(fig)



fig=figure;fig.Name=[Struc{ss},'Indiv Freq Distrib Sound'];
clear fShck fNoShck
f=Spectro{3};
for mm=1:size(SpectraBySlice.SoundCond,2)
    fCond{mm}=[];fTest{mm}=[];
    subplot(ceil(size(SpectraBySlice.SoundCond,2)/4),4,mm)
    
    for c=1:size(SpectraBySlice.SoundCond{mm},2)
        if not(isempty(SpectraBySlice.SoundCond{mm}{c}))
            for k=1:size(SpectraBySlice.SoundCond{mm}{c},1)
                [val,ind]=max(SpectraBySlice.SoundCond{mm}{c}(k,LimFreq:end)); ind=ind+LimFreq;
                fCond{mm}=[fCond{mm},f(ind)];
            end
        end
    end
    for c=1:size(SpectraBySlice.SoundTest{mm},2)
        try
            if not(isempty(SpectraBySlice.SoundTest{mm}{c}))
                for k=1:size(SpectraBySlice.SoundTest{mm}{c},1)
                    [val,ind]=max(SpectraBySlice.SoundTest{mm}{c}(k,LimFreq:end)); ind=ind+LimFreq;
                    fTest{mm}=[fTest{mm},f(ind)];
                end
            end
        end
    end
    nhist({fCond{mm},fTest{mm}},'samebins','binfactor',0.5)
    title(MouseName.SoundCond{mm})
    xlim([1 10]),line([3 3],ylim,'color','k','linewidth',2,'linestyle',':'),line([6 6],ylim,'color','k','linewidth',2,'linestyle',':')
end
saveas(fig.Number,[strrep(fig.Name,' ','_'),'.png'])
saveas(fig.Number,[strrep(fig.Name,' ','_'),'.fig'])
close(fig)

fig=figure;fig.Name=[Struc{ss},'Freq Dist Av Of Mice Sound '];
clear YCond YTest
BinLims=[0.25:0.25:20];
% exclude ouse with v little freezign and lots of baseline noise
for mm=1:size(SpectraBySlice.SoundCond,2)
    if not(isempty(fCond{mm}))
        [YCond(mm,:),X]=hist(fCond{mm},BinLims);YCond(mm,:)=YCond(mm,:)./sum(YCond(mm,:));
    else
        YCond(mm,:)=nan(1,length(BinLims));
    end
    if not(isempty(fTest{mm}))
        [YTest(mm,:),X]=hist(fTest{mm},BinLims);YTest(mm,:)=YTest(mm,:)./sum(YTest(mm,:));
    else
        YTest(mm,:)=nan(1,length(BinLims));
    end
end
stairs(BinLims,smooth(nanmean(YTest),5),'b','linewidth',3);
hold on
stairs(BinLims,smooth(nanmean(YCond),5),'r','linewidth',3);
xlim([1 15]),line([3 3],ylim,'color','k'),line([6 6],ylim,'color','k')
saveas(fig.Number,[strrep(fig.Name,' ','_'),'.png'])
saveas(fig.Number,[strrep(fig.Name,' ','_'),'.fig'])
close(fig)



%% EKG
GoodEKGMice={'484','485','490','507','508','509'}; % More restrictive
%GoodEKGMice={'483','484','485','490','507','508','509','510','512'};
GoodEKG=[];
for mm=1:length(GoodEKGMice)
    GoodEKG=[GoodEKG,find(~cellfun(@isempty,(strfind(MouseName.UMazeCond,GoodEKGMice{mm}))))];
end
%GoodEKG=sort(GoodEKG);


for mm=1:length(GoodEKG)
    for c=1:size(HRInfo.Safe{GoodEKG(mm)},2)
        SafeMoytemp(c)=HRInfo.Safe{GoodEKG(mm)}{c}.MeanHR;
        SafeStdtemp(c)=HRInfo.Safe{GoodEKG(mm)}{c}.StdHR;
        SafeStdBistemp(c)=HRInfo.Safe{GoodEKG(mm)}{c}.StdInterHB;
        
        ShockMoytemp(c)=HRInfo.Shock{GoodEKG(mm)}{c}.MeanHR;
        ShockStdtemp(c)=HRInfo.Shock{GoodEKG(mm)}{c}.StdHR;
        ShockStdBistemp(c)=HRInfo.Shock{GoodEKG(mm)}{c}.StdInterHB;
        
        RunningMoytemp(c)=HRInfo.Running{GoodEKG(mm)}{c}.MeanHR;
        RunningStdtemp(c)=HRInfo.Running{GoodEKG(mm)}{c}.StdHR;
        RunningStdBistemp(c)=HRInfo.Running{GoodEKG(mm)}{c}.StdInterHB;
    end
    SafeMoy(mm)=nanmean(SafeMoytemp);clear SafeMoytemp
    SafeStd(mm)=nanmean(SafeStdtemp);clear SafeStdtemp
    SafeStdBis(mm)=nanmean(SafeStdBistemp);clear SafeStdBistemp
    
    ShockMoy(mm)=nanmean(ShockMoytemp);clear ShockMoytemp
    ShockStd(mm)=nanmean(ShockStdtemp);clear ShockStdtemp
    ShockStdBis(mm)=nanmean(ShockStdBistemp);clear ShockStdBistemp
    
    RunningMoy(mm)=nanmean(RunningMoytemp);clear ShockMoytemp
    RunningStd(mm)=nanmean(RunningStdtemp);clear ShockStdtemp
    RunningStdBis(mm)=nanmean(RunningStdBistemp);clear ShockStdBistemp
    
end

fig=figure;fig.Name=[' HR Basic parameters'];
subplot(1,3,1)
pval=PlotErrorBarN([RunningMoy;SafeMoy;ShockMoy]',0,1), ylabel('MeanHR')
set(gca,'XTick',[1,2,3],'XTickLabel',{'Mov','FzSafe','FzShk'})
subplot(1,3,2)
pval=PlotErrorBarN([RunningStd;SafeStd;ShockStd]',0,1), ylabel('StdHR')
set(gca,'XTick',[1,2,3],'XTickLabel',{'Mov','FzSafe','FzShk'})
subplot(1,3,3)
pval=PlotErrorBarN([RunningStdBis;SafeStdBis;ShockStdBis]',0,1), ylabel('StdInterBeatInt')
set(gca,'XTick',[1,2,3],'XTickLabel',{'Mov','FzSafe','FzShk'})
saveas(fig.Number,[strrep(fig.Name,' ','_'),'.png'])
saveas(fig.Number,[strrep(fig.Name,' ','_'),'.fig'])
close(fig)

fig=figure;fig.Name=[' HR Distrib Indiv Mice'];
for mm=1:length(GoodEKG)
    AllSafe=[]; AllShock=[];
    for c=1:size(HRInfo.Safe{GoodEKG(mm)},2)
        AllSafe=[AllSafe,HRSliceBySlice.Safe{GoodEKG(mm)}{c}.MeanHR];
        AllShock=[AllShock,HRSliceBySlice.Shock{GoodEKG(mm)}{c}.MeanHR];
    end
    subplot(3,2,mm)
    nhist({AllSafe,AllShock},'samebins')
    title(MouseName.UMazeCond{mm})
end
saveas(fig.Number,[strrep(fig.Name,' ','_'),'.png'])
saveas(fig.Number,[strrep(fig.Name,' ','_'),'.fig'])
close(fig)


%%%%
fig=figure;
subplot(1,3,1)
AllBr=[];AllHR=[];
for  mm=1:length(GoodEKG)
    fShck=[];fNoShck=[];
    for c=1:size(SpectraBySlice.Safe{GoodEKG(mm)},2)
        if not(isempty(SpectraBySlice.Safe{GoodEKG(mm)}{c}))
            for k=1:size(SpectraBySlice.Safe{GoodEKG(mm)}{c},1)
                [val,ind]=max(SpectraBySlice.Safe{GoodEKG(mm)}{c}(k,LimFreq:end)); ind=ind+LimFreq;
                fNoShck=[fNoShck,f(ind)];
            end
        end
    end
    
    for c=1:size(SpectraBySlice.Shock{GoodEKG(mm)},2)
        for k=1:size(SpectraBySlice.Shock{GoodEKG(mm)}{c},1)
            [val,ind]=max(SpectraBySlice.Shock{GoodEKG(mm)}{c}(k,LimFreq:end)); ind=ind+LimFreq;
            fShck=[fShck,f(ind)];
        end
    end
    
    HRSafe=[]; HRShock=[];
    for c=1:size(HRInfo.Safe{GoodEKG(mm)},2)
        if not(sum(isnan(HRSliceBySlice.Safe{GoodEKG(mm)}{c}.MeanHR))==size(HRSliceBySlice.Safe{GoodEKG(mm)}{c}.MeanHR,2))
            HRSafe=[HRSafe,HRSliceBySlice.Safe{GoodEKG(mm)}{c}.MeanHR];
        end
        if not(sum(isnan(HRSliceBySlice.Shock{GoodEKG(mm)}{c}.MeanHR))==size(HRSliceBySlice.Shock{GoodEKG(mm)}{c}.MeanHR,2))
            HRShock=[HRShock,HRSliceBySlice.Shock{GoodEKG(mm)}{c}.MeanHR];
        end
    end
    
    plot(HRShock,fShck,'r.'), hold on
    plot(HRSafe,fNoShck,'b.')
    AllBr=[AllBr,[fShck,fNoShck]];
    AllHR=[AllHR,[HRShock,HRSafe]];
    %     xlim([8 14])
    ylim([1 10])
    
end
AllBr(isnan(AllHR))=[];
AllHR(isnan(AllHR))=[];
[R,P]=corrcoef(AllHR,AllBr)
title(['P=',num2str(P(1,2)),' R=',num2str(R(1,2))])
xlabel('HR mean'),ylabel('Resp Freq'),


subplot(1,3,2)
AllBr=[];AllHR=[];
for  mm=1:length(GoodEKG)
    fShck=[];fNoShck=[];
    for c=1:size(SpectraBySlice.Safe{GoodEKG(mm)},2)
        if not(isempty(SpectraBySlice.Safe{GoodEKG(mm)}{c}))
            for k=1:size(SpectraBySlice.Safe{GoodEKG(mm)}{c},1)
                [val,ind]=max(SpectraBySlice.Safe{GoodEKG(mm)}{c}(k,LimFreq:end)); ind=ind+LimFreq;
                fNoShck=[fNoShck,f(ind)];
            end
        end
    end
    
    for c=1:size(SpectraBySlice.Shock{GoodEKG(mm)},2)
        for k=1:size(SpectraBySlice.Shock{GoodEKG(mm)}{c},1)
            [val,ind]=max(SpectraBySlice.Shock{GoodEKG(mm)}{c}(k,LimFreq:end)); ind=ind+LimFreq;
            fShck=[fShck,f(ind)];
        end
    end
    
    HRSafe=[]; HRShock=[];
    for c=1:size(HRInfo.Safe{GoodEKG(mm)},2)
        if not(sum(isnan(HRSliceBySlice.Safe{GoodEKG(mm)}{c}.MeanHR))==size(HRSliceBySlice.Safe{GoodEKG(mm)}{c}.StdHR,2))
            HRSafe=[HRSafe,HRSliceBySlice.Safe{GoodEKG(mm)}{c}.StdHR];
        end
        if not(sum(isnan(HRSliceBySlice.Shock{GoodEKG(mm)}{c}.MeanHR))==size(HRSliceBySlice.Shock{GoodEKG(mm)}{c}.StdHR,2))
            HRShock=[HRShock,HRSliceBySlice.Shock{GoodEKG(mm)}{c}.StdHR];
        end
    end
    
    plot(HRShock,fShck,'r.'), hold on
    plot(HRSafe,fNoShck,'b.')
    AllBr=[AllBr,[fShck,fNoShck]];
    AllHR=[AllHR,[HRShock,HRSafe]];
    %     xlim([8 14])
    ylim([1 10])
    
end
AllBr(isnan(AllHR))=[];
AllHR(isnan(AllHR))=[];
[R,P]=corrcoef(AllHR,AllBr)
title(['P=',num2str(P(1,2)),' R=',num2str(R(1,2))])
xlabel('HR std'),ylabel('Resp Freq'),


subplot(1,3,3)
AllBr=[];AllHR=[];
for  mm=1:length(GoodEKG)
    fShck=[];fNoShck=[];
    for c=1:size(SpectraBySlice.Safe{GoodEKG(mm)},2)
        if not(isempty(SpectraBySlice.Safe{GoodEKG(mm)}{c}))
            for k=1:size(SpectraBySlice.Safe{GoodEKG(mm)}{c},1)
                [val,ind]=max(SpectraBySlice.Safe{GoodEKG(mm)}{c}(k,LimFreq:end)); ind=ind+LimFreq;
                fNoShck=[fNoShck,f(ind)];
            end
        end
    end
    
    for c=1:size(SpectraBySlice.Shock{GoodEKG(mm)},2)
        for k=1:size(SpectraBySlice.Shock{GoodEKG(mm)}{c},1)
            [val,ind]=max(SpectraBySlice.Shock{GoodEKG(mm)}{c}(k,LimFreq:end)); ind=ind+LimFreq;
            fShck=[fShck,f(ind)];
        end
    end
    
    HRSafe=[]; HRShock=[];
    for c=1:size(HRInfo.Safe{GoodEKG(mm)},2)
        if not(sum(isnan(HRSliceBySlice.Safe{GoodEKG(mm)}{c}.MeanHR))==size(HRSliceBySlice.Safe{GoodEKG(mm)}{c}.StdInterHB,2))
            HRSafe=[HRSafe,HRSliceBySlice.Safe{GoodEKG(mm)}{c}.StdInterHB];
        end
        if not(sum(isnan(HRSliceBySlice.Shock{GoodEKG(mm)}{c}.MeanHR))==size(HRSliceBySlice.Shock{GoodEKG(mm)}{c}.StdInterHB,2))
            HRShock=[HRShock,HRSliceBySlice.Shock{GoodEKG(mm)}{c}.StdInterHB];
        end
    end
    
    plot(HRShock,fShck,'r.'), hold on
    plot(HRSafe,fNoShck,'b.')
    AllBr=[AllBr,[fShck,fNoShck]];
    AllHR=[AllHR,[HRShock,HRSafe]];
    %     xlim([8 14])
    ylim([1 10])
    
end
AllBr(isnan(AllHR))=[];
AllHR(isnan(AllHR))=[];
[R,P]=corrcoef(AllHR,AllBr)
title(['P=',num2str(P(1,2)),' R=',num2str(R(1,2))])
xlabel('HR StdInterBeatInt'),ylabel('Resp Freq'),




%%%%%%%%%%%




