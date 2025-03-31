clear all, close all
%% Choose your session
% 
% cd /media/DataMOBsRAIDN/ProjectEmbReact/Mouse493/20161219/ProjectEmbReact_M493_20161219_BaselineSleep; Sleep = 1;
% cd /media/DataMOBsRAIDN/ProjectEmbReact/Mouse490/20161124/ProjectEmbReact_M490_20161124_BaselineSleep/; Sleep = 1;
% cd /media/DataMOBsRAIDN/ProjectEmbReact/Mouse514/20170316/ProjectEmbReact_M514_20170316_SleepPostSound; Sleep = 1;

cd /media/DataMOBsRAIDN/ProjectEmbReact/Mouse514/M514_170322; Sleep = 0;

%% Get relevant channels
load('ProbElectrodeOrder.mat')
load('ChannelsToAnalyse/dHPC_rip.mat')
channel_HPC = channel;
FirstChannel = min(Subgroups(:));
AllChan = sort(Subgroups(:));
Local = 0;

if Sleep ==1
    load('StateEpochSB.mat','SWSEpoch','REMEpoch','Wake','TotalNoiseEpoch')
    MeanSpec_SWS=[];MeanSpec_REM=[];MeanSpec_Wake=[];
    MeanCoh_SWS=[];MeanCoh_REM=[];MeanCoh_Wake=[];
else
    load('behavResources.mat')
    load('StateEpochSB.mat')
    MeanSpec_Fz=[];MeanSpec_Act=[];
    MeanCoh_Fz=[];MeanCoh_Act=[];
end

for kk = 1:length(AllChan)
    k = AllChan(kk);
    load(['AllSpecHPCProbe/HPCProbe',num2str(k),'_Low_Spectrum.mat'])
    sptsd=tsd(Spectro{2}*1e4,(Spectro{1}));
    if Sleep ==1
        MeanSpec_SWS(kk,:) = mean(log(Data(Restrict(sptsd,SWSEpoch-TotalNoiseEpoch))));
        MeanSpec_REM(kk,:) = mean(log(Data(Restrict(sptsd,REMEpoch-TotalNoiseEpoch))));
        MeanSpec_Wake(kk,:) = mean(log(Data(Restrict(sptsd,Wake-TotalNoiseEpoch))));
    else
        MeanSpec_Fz(kk,:) = mean(log(Data(Restrict(sptsd,FreezeEpoch-TotalNoiseEpoch))));
        MeanSpec_Act(kk,:) = mean(log(Data(Restrict(sptsd,intervalSet(0,max(Range(sptsd)))-TotalNoiseEpoch))));
    end
    
    if exist(['CohgramcDataL/Cohgram_OBLocal_HPC',num2str(k),'.mat'])>0
        load(['CohgramcDataL/Cohgram_OBLocal_HPC',num2str(k),'.mat'])
        Local = 1;
    else
        load(['CohgramcDataL/Cohgram_OB_HPC',num2str(k),'.mat'])
    end
    Ctsd = tsd(t*1e4,C);
    
    if Sleep ==1
        MeanCoh_SWS(kk,:) = mean(Data(Restrict(Ctsd,SWSEpoch-TotalNoiseEpoch)));
        MeanCoh_REM(kk,:) = mean(Data(Restrict(Ctsd,REMEpoch-TotalNoiseEpoch)));
        MeanCoh_Wake(kk,:) = mean(Data(Restrict(Ctsd,Wake-TotalNoiseEpoch)));
    else
        MeanCoh_Fz(kk,:) = mean(Data(Restrict(Ctsd,FreezeEpoch-TotalNoiseEpoch)));
        MeanCoh_Act(kk,:) = mean(Data(Restrict(Ctsd,intervalSet(0,max(Range(sptsd)))-TotalNoiseEpoch)));
    end
end

if Local ==1
    FileName = {'CoherenceOBLocal_HPCProbe.mat'};
else
    FileName = {'CoherenceOB_HPCProbe.mat'};
end
if Sleep
    save(FileName{1},'MeanCoh_SWS','MeanCoh_REM','MeanCoh_Wake')
else
    save(FileName{1},'MeanCoh_Fz','MeanCoh_Act')
end

load('B_Low_Spectrum.mat')
sptsd=tsd(Spectro{2}*1e4,(Spectro{1}));
if Sleep ==1
    MeanSpec_SWS_OB= mean(log(Data(Restrict(sptsd,SWSEpoch-TotalNoiseEpoch))));
    MeanSpec_REM_OB = mean(log(Data(Restrict(sptsd,REMEpoch-TotalNoiseEpoch))));
    MeanSpec_Wake_OB = mean(log(Data(Restrict(sptsd,Wake-TotalNoiseEpoch))));
    save('SpectraHPCProbe.mat','MeanSpec_SWS_OB','MeanSpec_REM_OB','MeanSpec_Wake_OB','MeanSpec_SWS','MeanSpec_REM','MeanSpec_Wake')
else
    MeanSpec_Fz_OB= mean(log(Data(Restrict(sptsd,FreezeEpoch-TotalNoiseEpoch))));
    MeanSpec_Act_OB = mean(log(Data(Restrict(sptsd,intervalSet(0,max(Range(sptsd)))-TotalNoiseEpoch))));
    save('SpectraHPCProbe.mat','MeanSpec_Fz','MeanSpec_Act','MeanSpec_Fz_OB','MeanSpec_Act_OB')
end


% Coherence
try, load('CoherenceOBLocal_HPCProbe.mat')
catch, load('CoherenceOB_HPCProbe.mat'), end

if Sleep ==1
figure
for group = 1:size(Subgroups,1)
    subplot(3,size(Subgroups,1),group)
    imagesc(f,[1:length(Subgroups(group,:))],MeanCoh_SWS(Subgroups(group,:)-FirstChannel+1,:))
    hold on,plot(f,8-MeanSpec_SWS_OB/2,'k','linewidth',2)
    caxis([0.4 0.56])
    set(gca,'YTick',[1:length(Subgroups(group,:))],'YTickLabel',  num2cell((Subgroups(group,:))))
    if group == 1
        ylabel('NREM')
    end
    title(['Shank ' num2str(group)])
    
    subplot(3,size(Subgroups,1),group+size(Subgroups,1))
    imagesc(f,[1:length(Subgroups(group,:))],MeanCoh_REM(Subgroups(group,:)-FirstChannel+1,:))
    hold on,plot(f,8-MeanSpec_REM_OB/2,'k','linewidth',2)
    caxis([0.4 0.65])
    set(gca,'YTick',[1:length(Subgroups(group,:))],'YTickLabel',  num2cell((Subgroups(group,:))))
    if group == 1
        ylabel('REM')
    end
    
    subplot(3,size(Subgroups,1),group+size(Subgroups,1)*2)
    imagesc(f,[1:length(Subgroups(group,:))],MeanCoh_Wake(Subgroups(group,:)-FirstChannel+1,:))
    hold on,plot(f,15-MeanSpec_Wake_OB*2,'k','linewidth',2)
    caxis([0.4 0.65])
    set(gca,'YTick',[1:length(Subgroups(group,:))],'YTickLabel',  num2cell((Subgroups(group,:))))
    if group == 1
        ylabel('Wake')
    end
    
end
colormap jet

else
    figure
    for group = 1:size(Subgroups,1)
        subplot(2,size(Subgroups,1),group)
        imagesc(f,[1:length(Subgroups(group,:))],MeanCoh_Act(Subgroups(group,:)-FirstChannel+1,:))
        hold on,plot(f,8-MeanSpec_Act_OB/2,'k','linewidth',2)
        caxis([0.4 0.56])
        set(gca,'YTick',[1:length(Subgroups(group,:))],'YTickLabel',  num2cell((Subgroups(group,:))))
        if group == 1
            ylabel('Active')
        end
        title(['Shank ' num2str(group)])
        
        subplot(2,size(Subgroups,1),group+size(Subgroups,1))
        imagesc(f,[1:length(Subgroups(group,:))],MeanCoh_Fz(Subgroups(group,:)-FirstChannel+1,:))
        hold on,plot(f,8-MeanSpec_Fz_OB/2,'k','linewidth',2)
        caxis([0.4 0.65])
        set(gca,'YTick',[1:length(Subgroups(group,:))],'YTickLabel',  num2cell((Subgroups(group,:))))
        if group == 1
            ylabel('Freezing')
        end
    end
    colormap jet
end

% Spectra
load('SpectraHPCProbe.mat')
if Sleep ==1
figure
for group = 1:size(Subgroups,1)
    subplot(3,size(Subgroups,1),group)
    imagesc(f,[1:length(Subgroups(group,:))],MeanSpec_SWS(Subgroups(group,:)-FirstChannel+1,:))
    hold on,plot(f,8-MeanSpec_SWS_OB/2,'k','linewidth',2)
    set(gca,'YTick',[1:length(Subgroups(group,:))],'YTickLabel',  num2cell((Subgroups(group,:))))
    caxis([5 13])
     if group == 1
        ylabel('NREM')
     end
        title(['Shank ' num2str(group)])

    title(['Shank ' num2str(group)])
    subplot(3,size(Subgroups,1),group+size(Subgroups,1))
    imagesc(f,[1:length(Subgroups(group,:))],MeanSpec_REM(Subgroups(group,:)-FirstChannel+1,:))
    hold on,plot(f,8-MeanSpec_REM_OB/2,'k','linewidth',2)
    set(gca,'YTick',[1:length(Subgroups(group,:))],'YTickLabel',  num2cell((Subgroups(group,:))))
        caxis([5 13])
    if group == 1
        ylabel('REM')
    end


    subplot(3,size(Subgroups,1),group+size(Subgroups,1)*2)
    imagesc(f,[1:length(Subgroups(group,:))],MeanSpec_Wake(Subgroups(group,:)-FirstChannel+1,:))
    hold on,plot(f,8-MeanSpec_Wake_OB/2,'k','linewidth',2)
    set(gca,'YTick',[1:length(Subgroups(group,:))],'YTickLabel',  num2cell((Subgroups(group,:))))
    caxis([5 13])
   if group == 1
        ylabel('Wake')
    end

end
colormap jet
else
    figure
    for group = 1:size(Subgroups,1)
        
        subplot(2,size(Subgroups,1),group)
        imagesc(f,[1:length(Subgroups(group,:))],MeanSpec_Act(Subgroups(group,:)-FirstChannel+1,:))
        hold on,plot(f,8-MeanSpec_Act_OB/2,'k','linewidth',2)
        set(gca,'YTick',[1:length(Subgroups(group,:))],'YTickLabel',  num2cell((Subgroups(group,:))))
        caxis([5 13])
        if group == 1
            ylabel('Active')
        end
        title(['Shank ' num2str(group)])
        
        subplot(2,size(Subgroups,1),group+size(Subgroups,1))
        imagesc(f,[1:length(Subgroups(group,:))],MeanSpec_Fz(Subgroups(group,:)-FirstChannel+1,:))
        hold on,plot(f,8-MeanSpec_Fz_OB/2,'k','linewidth',2)
        set(gca,'YTick',[1:length(Subgroups(group,:))],'YTickLabel',  num2cell((Subgroups(group,:))))
        caxis([5 13])
        if group == 1
            ylabel('Freezing')
        end
                
    end
    colormap jet
end

% ripples
if exist('RippleTriggeredAverageProbe.mat')==0
    load('Ripples.mat')
    clear M RemRip
    for kk = 1:length(AllChan)
        k = AllChan(kk)
        load(['LFPData/LFP',num2str(k),'.mat'])
        [M,T]=PlotRipRaw(LFP,RipplesR(:,2)/1e3,1000,0,0);
        RippleTriggeredAverage(kk,:) = M(:,2);
    end
    tps = M(:,1);
    save('RippleTriggeredAverageProbe.mat','RippleTriggeredAverage','tps')
else
    load('RippleTriggeredAverageProbe.mat','RippleTriggeredAverage','tps')
end

figure
colors = jet(length(Subgroups(group,:)));
for group = 1:size(Subgroups,1)
    subplot(1,size(Subgroups,1),group)
    title(['Shank ' num2str(group)])
    for ch = 1 :length(Subgroups(group,:))
        if GoodElecs(group,ch) ==1
            plot(tps,RippleTriggeredAverage(Subgroups(group,ch)-FirstChannel+1,:)-ch*2000,'color',colors(ch,:),'linewidth',2),hold on
        else
            plot(tps,RippleTriggeredAverage(Subgroups(group,ch)-FirstChannel+1,:)-ch*2000,'color',[0.6 0.6 0.6],'linewidth',2),hold on
        end
    end
    xlim([-0.1 0.3])
    axis xy
    set(gca,'YTick',-[length(Subgroups(group,:)):-1:1]*2000,'YTickLabel',  num2cell(fliplr(Subgroups(group,:))))
    line([0 0],ylim,'color','k')
end

% theta triggered
if exist('ThetaTriggeredAverageProbe.mat')==0
    
    load(['LFPData/LFP',num2str(channel_HPC),'.mat'])
    LFPHPC=LFP;
    LFPHPC=FilterLFP(LFPHPC,[7 12],1024);
    LFPHPCHil=hilbert(Data(LFPHPC));
    LFPHPCPhase=angle(LFPHPCHil);
    Phasetsd=tsd(Range(LFPHPC),LFPHPCPhase);
    if Sleep==1
        Phasetsd=Restrict(Phasetsd,REMEpoch);
    else
        Phasetsd=Restrict(Phasetsd,intervalSet(0,max(Range(sptsd)))-TotalNoiseEpoch);
    end
    PeakTheta=thresholdIntervals(Phasetsd,3.1,'Direction','Above');
    clear ThetaTriggeredAverage
    for kk = 1:length(AllChan)
        k = AllChan(kk)
        load(['LFPData/LFP',num2str(k),'.mat'])
        [M,T]=PlotRipRaw(LFP,Start(PeakTheta,'s'),300,0,0);
        ThetaTriggeredAverage(kk,:)=M(:,2);
    end
    tps = M(:,1);
    save('ThetaTriggeredAverageProbe.mat','ThetaTriggeredAverage','tps')
else
    load('ThetaTriggeredAverageProbe.mat')
end


figure
colors = jet(length(Subgroups(group,:)));
for group = 1:size(Subgroups,1)
    subplot(1,size(Subgroups,1),group)
    for ch = 1 :length(Subgroups(group,:))
        if GoodElecs(group,ch) ==1
            plot(tps,ThetaTriggeredAverage(Subgroups(group,ch)-FirstChannel+1,:)-ch*2000,'color',colors(ch,:),'linewidth',2),hold on
        else
            plot(tps,ThetaTriggeredAverage(Subgroups(group,ch)-FirstChannel+1,:)-ch*2000,'color',[0.6 0.6 0.6],'linewidth',2),hold on
        end
    end
    xlim([-0.3 0.3])
    axis xy
    set(gca,'YTick',-[length(Subgroups(group,:)):-1:1]*2000,'YTickLabel',  num2cell(fliplr(Subgroups(group,:))))
    line([0 0],ylim,'color','k')
    title(['Shank ' num2str(group)])
end
