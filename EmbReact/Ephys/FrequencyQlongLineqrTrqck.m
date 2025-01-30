clear all
SessNames={ 'UMazeCond','UMazeCondNight','UMazeCond_EyeShock',...
    'UMazeCondBlockedShock_PreDrug','UMazeCondBlockedSafe_PreDrug','UMazeCondBlockedShock_PreDrug',...
    };
Lintemp=[];FreqTemp=[];SpecTemp=[];FreqTempPT=[];FreqTempWV=[];

for ss=1:length(SessNames)
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    MouseToAvoid=[117,431]; % mice with noisy data to exclude
    Dir=RemoveElementsFromDir(Dir,'nmouse',MouseToAvoid);
    disp(SessNames{ss})
    for d=1:length(Dir.path)
        for dd=1:length(Dir.path{d})
            cd(Dir.path{d}{dd})
            
            load('behavResources_SB.mat')
            load('InstFreqAndPhase_B.mat','LocalFreq')
            load('StateEpochSB.mat','SleepyEpoch')
            load('StateEpochSB.mat','TotalNoiseEpoch','SleepyEpoch')
            TTLInfo.StimEpoch=intervalSet(Start(TTLInfo.StimEpoch),Stop(TTLInfo.StimEpoch)+1*1e4);
            RemovEpoch=or(or(TTLInfo.StimEpoch,TotalNoiseEpoch),SleepyEpoch);
            LinDistTemp=Restrict(Behav.LinearDist,Behav.FreezeEpoch-RemovEpoch);
            LocalFreq.PT=Restrict(LocalFreq.PT,Behav.FreezeEpoch-RemovEpoch);
            LocalFreq.WV=Restrict(LocalFreq.WV,Behav.FreezeEpoch-RemovEpoch);
            FreqInst = (Restrict(LocalFreq.PT,LinDistTemp,'align','closest'));
            FreqInst2 = (Restrict(LocalFreq.WV,LinDistTemp,'align','closest'));
            LinDistAll{d}{dd}=Data(LinDistTemp);
            FreqAllPT{d}{dd}=Data(FreqInst);ed
            FreqAllWV{d}{dd}=Data(FreqInst2);
            load('B_Low_Spectrum.mat')
            Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
            Sptsd = (Restrict(Sptsd,LinDistTemp,'align','closest'));
            AllSpectro{d}{dd}=Data(Sptsd);
        end
    end
    
    for d=1:length(Dir.path)
        SpecTemptemp=[];
        for dd=1:length(Dir.path{d})
            Lintemp=[Lintemp;LinDistAll{d}{dd}];
            FreqTempPT=[FreqTempPT;FreqAllPT{d}{dd}];
            FreqTempWV=[FreqTempWV;FreqAllWV{d}{dd}];
            SpecTemptemp=[SpecTemptemp;AllSpectro{d}{dd}];
        end
        SpecTemptemp=SpecTemptemp./nanmean(nanmean(SpecTemptemp));
        SpecTemp=[SpecTemp;SpecTemptemp];
    end
end



NumLims=15;
Fr=[0:0.5:20];
clear MeanFreqPT MeanSpec Occup MaxValPT MaxValWV MaxValSpec MeanFreqWV XAx
for k=1:NumLims
    Bins=find(Lintemp>(k-1)*1/NumLims & Lintemp<(k)*1/NumLims);
    MeanFreqPT(k,:)=hist(FreqTempPT(Bins),Fr);
    MeanFreqPT(k,:)=runmean(MeanFreqPT(k,:)/max(MeanFreqPT(k,:)),2);
    MeanFreqWV(k,:)=hist(FreqTempWV(Bins),Fr);
    MeanFreqWV(k,:)=runmean(MeanFreqWV(k,:)/max(MeanFreqWV(k,:)),2);
    try
%     MeanSpec(k,:)=ZScoreWiWindowSB(nanmean(SpecTemp(Bins,:)),[15:size(SpecTemp,2)]);
    MeanSpec(k,:)=nanmean(SpecTemp(Bins,:));
    catch
        MeanSpec(k,:)=nan(1,size(SpecTemp,2));
    end
    [~,MaxValPT(k)]=max(MeanFreqPT(k,:));
    [~,MaxValWV(k)]=max(MeanFreqWV(k,:));
    [~,MaxValSpec(k)]=max(MeanSpec(k,20:end));MaxValSpec(k)=MaxValSpec(k)+20;
    if sum(isnan(MeanSpec(k,:)))==length(MeanSpec(k,:))
        MaxValSpec(k)=1;
    end
    Occup(k)=length(Bins);
    XAx(k)=((k-1)*1/NumLims+k*1/NumLims)/2;
end


figure
subplot(211)
imagesc(XAx,Spectro{3},((MeanSpec'))), axis xy, clim([-1.5 3.5])
hold on
f=Spectro{3};
f(1)=NaN;
plot(XAx,Spectro{3}(MaxValSpec),'*k','linewidth',2)
ylim([0 20])
 set(gca,'Xtick',[],'Color','w')
box off
subplot(212)
bar(XAx,Occup./sum(Occup))
 set(gca,'Xtick',[],'Color','w')
box off
cols=redblue(7);
cols=cols([7,1,3,5,2],:);
cols(3,:)=[0.9,0.7,1];


for z=1:5
    for dd=1:length(Dir.path{d})
        cd(Dir.path{d}{dd})
        load('behavResources.mat')
%         subplot(211)
%         hold on
%         plot(-Data(Restrict(Behav.Xtsd,Behav.ZoneEpoch{z})),-Data(Restrict(Behav.Ytsd,Behav.ZoneEpoch{z})),'color',cols(z,:))
        subplot(211)
        hold on
                line([min(Data(Restrict(Behav.LinearDist,Behav.ZoneEpoch{z}))) max(Data(Restrict(Behav.LinearDist,Behav.ZoneEpoch{z})))],[15 15],'color','w','linewidth',8)
        line([min(Data(Restrict(Behav.LinearDist,Behav.ZoneEpoch{z}))) max(Data(Restrict(Behav.LinearDist,Behav.ZoneEpoch{z})))],[15 15],'color',cols(z,:),'linewidth',5)
    end
end
% subplot(211)
 set(gca,'XTick',[],'Ytick',[],'Color','w')
 xlim([0.05 0.95])
 line([xlim],[5 5],'color','k','linestyle','-.')




figure
cols=redblue(7);
cols=cols([7,1,3,5,2],:);
cols(3,:)=[0.9,0.7,1];
AllX=[];AllY=[];
for z=1:5
    for dd=1:length(Dir.path{d})
        cd(Dir.path{d}{dd})
        subplot(211)

        load('behavResources.mat')
        hold on
        plot(-Data(Restrict(Behav.Xtsd,Behav.ZoneEpoch{z})),-Data(Restrict(Behav.Ytsd,Behav.ZoneEpoch{z})),'color',cols(z,:))
        AllX=[AllX;-Data(Restrict(Behav.Xtsd,Behav.ZoneEpoch{z}))];
        AllY=[AllY;-Data(Restrict(Behav.Ytsd,Behav.ZoneEpoch{z}))];
    end
end
set(gca,'XTick',[],'Ytick',[],'Color','w')
subplot(211)
xlim([-60 -10])
ylim([-45 0])
subplot(212)
pas=0.5;
imagesc([-60:pas:10],[-45:pas:0],log(hist2d(AllX,AllY,[-60:pas:10],[-45:pas:0]))')
axis xy
set(gca,'XTick',[],'Ytick',[],'Color','w')
xlim([-60 -10])
ylim([-45 0])





