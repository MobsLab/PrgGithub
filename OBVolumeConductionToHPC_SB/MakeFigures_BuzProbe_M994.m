clear all
%% Go to file location
Dir = PathForExperimentsERC_Dima('UMazePAG');
Dir = RestrictPathForExperiment(Dir,'nMice', 994);
cd(Dir.path{1}{1})

HPCOrderChans={[123 109 110 111 119 120 106 107 108 116 121 103 104 105 117],...
    [59 45 46 47 55 56 42 43 44 52 57 39 40 ],...
    [61 50 60 34 35 48 51 62 63 33 30 32],...
    [26 27 24 12 3 2 28 29 14 13 0 1 31 15 49],...
    [5 19 16 17 9 6 20 21 18 10 7 25 22 23 11],...
    [101 102 114 125 124 98 99 112 115 126 127 97 94 96 ],...
    [90 91 88 76 67 66 92 93 78 77 64 65 95 79 113],...
    [69 83 80 81 73 70 84 85 82 74 71 89 86 87 75]};
cd /media/DataMOBsRAIDN/OBCoh_HPCProbes_4Hz/Mouse994_Probe1
load('Epochs.mat')

for shanknum = 1:length(HPCOrderChans)
    disp(num2str(shanknum))
    %% Get spectros
    disp('Spec')
    for el = 1:length(HPCOrderChans{shanknum})
        load(['Spectro_HPC',num2str(HPCOrderChans{shanknum}(el)),'.mat'])
        sptsd=tsd(t*1e4,Sp);
        AllSpec_Fz{shanknum}(el,:) = log(nanmean(Data(Restrict(sptsd,FreezeEpoch))));
        AllSpec_Mov{shanknum}(el,:) = log(nanmean(Data(Restrict(sptsd,RunEpoch))));
        AllSpec_REM{shanknum}(el,:) = log(nanmean(Data(Restrict(sptsd,REMEpoch))));
    end
    
    
    %% Get coherence LFP
    disp('LFP')
    for el = 1:length(HPCOrderChans{shanknum})
        load(['Cohgram_PFCx_HPC',num2str(HPCOrderChans{shanknum}(el)),'.mat'])
        sptsd=tsd(t*1e4,C);
        AllCoh_PFCx_Fz{shanknum}(el,:) = (nanmean(Data(Restrict(sptsd,FreezeEpoch))));
        AllCoh_PFCx_Mov{shanknum}(el,:) = (nanmean(Data(Restrict(sptsd,RunEpoch))));
        AllCoh_PFCx_REM{shanknum}(el,:) = (nanmean(Data(Restrict(sptsd,REMEpoch))));
        
        load(['Cohgram_OB_HPC',num2str(HPCOrderChans{shanknum}(el)),'.mat'])
        sptsd=tsd(t*1e4,C);
        AllCoh_OB_Fz{shanknum}(el,:) = (nanmean(Data(Restrict(sptsd,FreezeEpoch))));
        AllCoh_OB_Mov{shanknum}(el,:) = (nanmean(Data(Restrict(sptsd,RunEpoch))));
        AllCoh_OB_REM{shanknum}(el,:) = (nanmean(Data(Restrict(sptsd,REMEpoch))));
    end
    
    
    %% Get coherence Diff
    disp('Diff')
    for el = 1:length(HPCOrderChans{shanknum})-1
        load(['Cohgram_PFCx_HPCDiff_Sk',num2str(shanknum),'_El',num2str(el),'.mat'])
        sptsd=tsd(t*1e4,C);
        AllCohDiff_PFCx_Fz{shanknum}(el,:) = (nanmean(Data(Restrict(sptsd,FreezeEpoch))));
        AllCohDiff_PFCx_Mov{shanknum}(el,:) = (nanmean(Data(Restrict(sptsd,RunEpoch))));
        AllCohDiff_PFCx_REM{shanknum}(el,:) = (nanmean(Data(Restrict(sptsd,REMEpoch))));
        
        load(['Cohgram_OB_HPCDiff_Sk',num2str(shanknum),'_El',num2str(el),'.mat'])
        sptsd=tsd(t*1e4,C);
        AllCohDiff_OB_Fz{shanknum}(el,:) = (nanmean(Data(Restrict(sptsd,FreezeEpoch))));
        AllCohDiff_OB_Mov{shanknum}(el,:) = (nanmean(Data(Restrict(sptsd,RunEpoch))));
        AllCohDiff_OB_REM{shanknum}(el,:) = (nanmean(Data(Restrict(sptsd,REMEpoch))));
    end
    
    %% Get coherence CSD
    disp('CSD')
    for el = 1:length(HPCOrderChans{shanknum})-2
        load(['Cohgram_PFCx_HPCCSD_Sk',num2str(shanknum),'_El',num2str(el),'.mat'])
        sptsd=tsd(t*1e4,C);
        AllCohCSD_PFCx_Fz{shanknum}(el,:) = (nanmean(Data(Restrict(sptsd,FreezeEpoch))));
        AllCohCSD_PFCx_Mov{shanknum}(el,:) = (nanmean(Data(Restrict(sptsd,RunEpoch))));
        AllCohCSD_PFCx_REM{shanknum}(el,:) = (nanmean(Data(Restrict(sptsd,REMEpoch))));
        
        load(['Cohgram_OB_HPCCSD_Sk',num2str(shanknum),'_El',num2str(el),'.mat'])
        sptsd=tsd(t*1e4,C);
        AllCohCSD_OB_Fz{shanknum}(el,:) = (nanmean(Data(Restrict(sptsd,FreezeEpoch))));
        AllCohCSD_OB_Mov{shanknum}(el,:) = (nanmean(Data(Restrict(sptsd,RunEpoch))));
        AllCohCSD_OB_REM{shanknum}(el,:) = (nanmean(Data(Restrict(sptsd,REMEpoch))));
    end
    
end


FigureFolder = '/media/DataMOBsRAIDN/OBCoh_HPCProbes_4Hz/Mouse994_Probe_Figures';

for shanknum = 1:length(HPCOrderChans)
    % Fz
    fig = figure;
    subplot(2,4,1)
    imagesc(f,1:size(AllSpec_Fz{shanknum},1),AllSpec_Fz{shanknum})
    title('Spec Fz')
    
    subplot(2,4,2)
    imagesc(f,1:size(AllSpec_Fz{shanknum},1),AllCoh_PFCx_Fz{shanknum})
    title('Coh PFC Fz')
    caxis([0.2 0.8])
    
    subplot(2,4,3)
    imagesc(f,1:size(AllCohDiff_PFCx_Fz{shanknum},1),AllCohDiff_PFCx_Fz{shanknum})
    title('Coh Diff PFCx Fz')
    caxis([0.2 0.8])
    
    subplot(2,4,4)
    imagesc(f,1:size(AllCohCSD_PFCx_Fz{shanknum},1),AllCohCSD_PFCx_Fz{shanknum})
    title('Coh CSD PFCx Fz')
    caxis([0.2 0.8])
    
    
    subplot(2,4,6)
    imagesc(f,1:size(AllSpec_Fz{shanknum},1),AllCoh_OB_Fz{shanknum})
    title('Coh OB Fz')
    caxis([0.2 0.8])
    
    subplot(2,4,7)
    imagesc(f,1:size(AllCohDiff_OB_Fz{shanknum},1),AllCohDiff_OB_Fz{shanknum})
    title('Coh Diff OB Fz')
    caxis([0.2 0.8])
    
    subplot(2,4,8)
    imagesc(f,1:size(AllCohCSD_OB_Fz{shanknum},1),AllCohCSD_OB_Fz{shanknum})
    title('Coh CSD OB Fz')
    caxis([0.2 0.8])
    
    saveas(fig.Number,[FigureFolder filesep 'FZ_Coh_Spec_Shank' num2str(shanknum) '.png'])
    
    % Mov
    fig= figure;
    subplot(2,4,1)
    imagesc(f,1:size(AllSpec_Mov{shanknum},1),AllSpec_Mov{shanknum})
    title('Spec Mov')
    
    subplot(2,4,2)
    imagesc(f,1:size(AllSpec_Mov{shanknum},1),AllCoh_PFCx_Mov{shanknum})
    title('Coh PFC Mov')
    caxis([0.2 0.8])
    
    subplot(2,4,3)
    imagesc(f,1:size(AllCohDiff_PFCx_Mov{shanknum},1),AllCohDiff_PFCx_Mov{shanknum})
    title('Coh Diff PFCx Mov')
    caxis([0.2 0.8])
    
    subplot(2,4,4)
    imagesc(f,1:size(AllCohCSD_PFCx_Mov{shanknum},1),AllCohCSD_PFCx_Mov{shanknum})
    title('Coh CSD PFCx Mov')
    caxis([0.2 0.8])
    
    
    subplot(2,4,6)
    imagesc(f,1:size(AllSpec_Mov{shanknum},1),AllCoh_OB_Mov{shanknum})
    title('Coh OB Mov')
    caxis([0.2 0.8])
    
    subplot(2,4,7)
    imagesc(f,1:size(AllCohDiff_OB_Mov{shanknum},1),AllCohDiff_OB_Mov{shanknum})
    title('Coh Diff OB Mov')
    caxis([0.2 0.8])
    
    subplot(2,4,8)
    imagesc(f,1:size(AllCohCSD_OB_Mov{shanknum},1),AllCohCSD_OB_Mov{shanknum})
    title('Coh CSD OB Mov')
    caxis([0.2 0.8])
    saveas(fig.Number,[FigureFolder filesep 'Mov_Coh_Spec_Shank' num2str(shanknum) '.png'])
    
    % REM
    fig = figure;
    subplot(2,4,1)
    imagesc(f,1:size(AllSpec_REM{shanknum},1),AllSpec_REM{shanknum})
    title('Spec REM')
    
    subplot(2,4,2)
    imagesc(f,1:size(AllSpec_REM{shanknum},1),AllCoh_PFCx_REM{shanknum})
    title('Coh PFC REM')
    caxis([0.2 0.8])
    
    subplot(2,4,3)
    imagesc(f,1:size(AllCohDiff_PFCx_REM{shanknum},1),AllCohDiff_PFCx_REM{shanknum})
    title('Coh Diff PFCx REM')
    caxis([0.2 0.8])
    
    subplot(2,4,4)
    imagesc(f,1:size(AllCohCSD_PFCx_REM{shanknum},1),AllCohCSD_PFCx_REM{shanknum})
    title('Coh CSD PFCx REM')
    caxis([0.2 0.8])
    
    subplot(2,4,6)
    imagesc(f,1:size(AllSpec_REM{shanknum},1),AllCoh_OB_REM{shanknum})
    title('Coh OB REM')
    caxis([0.2 0.8])
    
    subplot(2,4,7)
    imagesc(f,1:size(AllCohDiff_OB_REM{shanknum},1),AllCohDiff_OB_REM{shanknum})
    title('Coh Diff OB REM')
    caxis([0.2 0.8])
    
    subplot(2,4,8)
    imagesc(f,1:size(AllCohCSD_OB_REM{shanknum},1),AllCohCSD_OB_REM{shanknum})
    title('Coh CSD OB REM')
    caxis([0.2 0.8])
    
    saveas(fig.Number,[FigureFolder filesep 'REM_Coh_Spec_Shank' num2str(shanknum) '.png'])
    
end


%% Triggered data
for shanknum = 1:length(HPCOrderChans)

    load(['HPCTriggered_Sk',num2str(shanknum),'.mat'])
    
    fig = figure;
    Types = fieldnames(HPCTrigBreath);
    for ty = 1:length(Types)
        
        clear M
        M(:,1) = [1:size(DataToUse,2)]/1250-0.5;
        
        DataToUse = HPCTrigBreath.(Types{ty});
        mu=mean(DataToUse(:,1:200),2);
        DataToUse = bsxfun(@minus,DataToUse, mu);
        
        subplot(3,3,1+(ty-1)*3)
        hold on
        for k=1:size(DataToUse,1)
            plot(M(:,1),DataToUse(k,:)-k*300,'color','k','linewidth',2)
        end
        line([0 0],ylim,'color','k','linewidth',3)
        title('LFP')
        ylabel((Types{ty}))
        xlim([-0.3 0.3])

        subplot(3,3,2+(ty-1)*3)
        imagesc(M(:,1),[1:size(DataToUse,1)],DataToUse),hold on
        line([0 0],ylim,'color','k','linewidth',3)
        title('LFP')
        caxis([-200 200])
        xlim([-0.3 0.3])

        subplot(3,3,3+(ty-1)*3)
        HPCTrigBreathCSD=interp2(diff(diff(DataToUse)),3);
        imagesc(M(:,1),[1:size(HPCTrigBreathCSD,1)],HPCTrigBreathCSD),hold on
        line([0 0],ylim,'color','k','linewidth',3)
        title('CSD')
        caxis([-20 20])
        xlim([-0.3 0.3])

    end
    saveas(fig.Number,[FigureFolder filesep 'TriggerOnBreath2_Shank' num2str(shanknum) '.png'])
    
    fig = figure;
    Types = fieldnames(HPCTrigTheta);
    for ty = 1:length(Types)
        
        clear M
        M(:,1) = [1:size(DataToUse,2)]/1250-0.5;
        
        DataToUse = HPCTrigTheta.(Types{ty});
        mu=mean(DataToUse(:,1:200),2);
        DataToUse = bsxfun(@minus,DataToUse, mu);
        
        subplot(3,3,1+(ty-1)*3)
        hold on
        for k=1:size(DataToUse,1)
            plot(M(:,1),DataToUse(k,:)-k*300,'color','k','linewidth',2)
        end
        xlim([-0.3 0.3])
        line([0 0],ylim,'color','k','linewidth',3)
        title('LFP')
        ylabel((Types{ty}))
        
        subplot(3,3,2+(ty-1)*3)
        imagesc(M(:,1),[1:size(DataToUse,1)],DataToUse),hold on
        line([0 0],ylim,'color','k','linewidth',3)
        title('LFP')
        caxis([-400 400])
        xlim([-0.3 0.3])
        
        subplot(3,3,3+(ty-1)*3)
        HPCTrigBreathCSD=interp2(diff(diff(DataToUse)),3);
        imagesc(M(:,1),[1:size(HPCTrigBreathCSD,1)],HPCTrigBreathCSD),hold on
        line([0 0],ylim,'color','k','linewidth',3)
        title('CSD')
        caxis([-50 50])
        xlim([-0.3 0.3])
        
    end
    saveas(fig.Number,[FigureFolder filesep 'TriggerOnTheta_Shank' num2str(shanknum) '.png'])
end


%% Triggered data
for shanknum = 1:length(HPCOrderChans)

    load(['HPCTriggered_Sk',num2str(shanknum),'.mat'])
    
    fig = figure;
        clear M
        
        DataToUse = HPCTrigRipples;
        mu=mean(DataToUse(:,1:200),2);
        DataToUse = bsxfun(@minus,DataToUse, mu);
        M(:,1) = [1:size(DataToUse,2)]/1250-0.5;
        
        subplot(3,1,1)
        hold on
        for k=1:size(DataToUse,1)
            plot(M(:,1),DataToUse(k,:)-k*500,'color','k','linewidth',2)
        end
        title('LFP')
        xlim([-0.3 0.3])
        
        subplot(3,1,2)
        imagesc(M(:,1),[1:size(DataToUse,1)],DataToUse),hold on
        line([0 0],ylim,'color','k','linewidth',3)
        title('LFP')
        caxis([-400 400])
        xlim([-0.3 0.3])
        
        subplot(3,1,3)
        HPCTrigBreathCSD=interp2(diff(diff(DataToUse)),3);
        imagesc(M(:,1),[1:size(HPCTrigBreathCSD,1)],HPCTrigBreathCSD),hold on
        line([0 0],ylim,'color','k','linewidth',3)
        title('CSD')
        caxis([-50 50])
        xlim([-0.3 0.3])

    
    saveas(fig.Number,[FigureFolder filesep 'TriggerOnRip_Shank' num2str(shanknum) '.png'])
end