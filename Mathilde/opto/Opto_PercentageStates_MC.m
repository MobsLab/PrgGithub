% Dir{1}=PathForExperiments_Opto_MC('Septum_Sham_20Hz');
% Dir{2}=PathForExperiments_Opto_MC('Septum_Stim_20Hz');

Dir{1}=PathForExperiments_Opto_MC('PFC_Control_20Hz');
Dir{2}=PathForExperiments_Opto_MC('PFC_Stim_20Hz');
% Dir{2} = RestrictPathForExperiment(Dir{2}, 'nMice', [675 733 1137 1136 648 1074]);%%goood one

% Dir{2} = RestrictPathForExperiment(Dir{2}, 'nMice', [675 733 1137 1136 648 1074 1388]);                                                    


% Dir{1}=PathForExperiments_Opto_MC('SST_Sham_20Hz');
% Dir{2}=PathForExperiments_Opto_MC('SST_Stim_20Hz');
%%

% 
% Dir{1}=PathForExperiments_Opto_MC('sham_wake');
% Dir{2}=PathForExperiments_Opto_MC('stim_wake');
%%
ResWakeCtrl=[];
ResSWSCtrl=[];
ResREMCtrl=[];
for i=1:length(Dir{1}.path)
    cd(Dir{1}.path{i}{1});
    if exist('SleepScoring_OBGamma.mat')
        load('SleepScoring_OBGamma.mat','REMEpochWiNoise','SWSEpochWiNoise','WakeWiNoise')
    else
        load('SleepScoring_Accelero.mat','REMEpochWiNoise','SWSEpochWiNoise','WakeWiNoise')
    end
%     REMEpochWiNoise  =mergeCloseIntervals(REMEpochWiNoise,1E4);
%     SWSEpochWiNoise = mergeCloseIntervals(SWSEpochWiNoise,1E4);
%     WakeWiNoise =  mergeCloseIntervals(WakeWiNoise,1E4);
    Restemp=ComputeSleepStagesPercentagesMC(WakeWiNoise,SWSEpochWiNoise,REMEpochWiNoise);%close 
    
    ResWakeCtrl=[ResWakeCtrl;Restemp(1,1)];
    ResSWSCtrl=[ResSWSCtrl;Restemp(2,1)];
    ResREMCtrl=[ResREMCtrl;Restemp(3,1)];
    
    NbSWSctrl(i)=length(length(SWSEpochWiNoise));
    NbWakeCtrl(i)=length(length(WakeWiNoise));
    NbREMctrl(i)=length(length(REMEpochWiNoise));
    
    durWakeCtrl(i)=mean(End(WakeWiNoise)-Start(WakeWiNoise))/1E4;
    durSWSctrl(i)=mean(End(SWSEpochWiNoise)-Start(SWSEpochWiNoise))/1E4;
    durREMctrl(i)=mean(End(REMEpochWiNoise)-Start(REMEpochWiNoise))/1E4;
    
    clear Wake REMEpoch SWSEpoch
end

ResWakeOpto=[];
ResSWSOpto=[];
ResREMOpto=[];
for j=1:length(Dir{2}.path)
    cd(Dir{2}.path{j}{1});
    if exist('SleepScoring_OBGamma.mat')
        load('SleepScoring_OBGamma.mat','REMEpochWiNoise','SWSEpochWiNoise','WakeWiNoise')
    else
        load('SleepScoring_Accelero.mat','REMEpochWiNoise','SWSEpochWiNoise','WakeWiNoise')
    end
%     REMEpoch  =mergeCloseIntervals(REMEpochWiNoise,1E4);
%     SWSEpoch = mergeCloseIntervals(SWSEpochWiNoise,1E4);
%     Wake =  mergeCloseIntervals(WakeWiNoise,1E4);
%         load SleepScoring_Accelero Wake REMEpoch SWSEpoch

    Restemp=ComputeSleepStagesPercentagesMC(WakeWiNoise,SWSEpochWiNoise,REMEpochWiNoise);
    
    ResWakeOpto=[ResWakeOpto;Restemp(1,1)];
    ResSWSOpto=[ResSWSOpto;Restemp(2,1)];
    ResREMOpto=[ResREMOpto;Restemp(3,1)];
    
    NbSWSopto(j)=length(length(SWSEpochWiNoise));
    NbWakeOpto(j)=length(length(WakeWiNoise));
    NbREMopto(j)=length(length(REMEpochWiNoise));
    
    durWakeOpto(j)=mean(End(WakeWiNoise)-Start(WakeWiNoise))/1E4;
    durSWSopto(j)=mean(End(SWSEpochWiNoise)-Start(SWSEpochWiNoise))/1E4;
    durREMopto(j)=mean(End(REMEpochWiNoise)-Start(REMEpochWiNoise))/1E4;
    
    clear Wake REMEpoch SWSEpoch
end


% ResWakeSham=[];
% ResSWSsham=[];
% ResREMsham=[];
% for k=1:length(Dir{3}.path)
%     cd(Dir{3}.path{k}{1});
%     load SleepScoring_OBGamma REMEpochWiNoise SWSEpochWiNoise WakeWiNoise
%     REMEpoch  =mergeCloseIntervals(REMEpochWiNoise,1E4);
%     SWSEpoch = mergeCloseIntervals(SWSEpochWiNoise,1E4);
%     Wake =  mergeCloseIntervals(WakeWiNoise,1E4);
% 
%     Restemp=ComputeSleepStagesPercAfterInjectionMC(Wake,SWSEpoch,REMEpoch);
%     
%     ResWakeSham=[ResWakeSham;Restemp(1,1)];
%     ResSWSsham=[ResSWSsham;Restemp(2,1)];
%     ResREMsham=[ResREMsham;Restemp(3,1)];
%     
%     NbSWSsham(k)=length(length(SWSEpoch));
%     NbWakeSham(k)=length(length(Wake));
%     NbREMsham(k)=length(length(REMEpoch));
%     
%     durWakeSham(k)=mean(End(Wake)-Start(Wake))/1E4; 
%     durSWSsham(k)=mean(End(SWSEpoch)-Start(SWSEpoch))/1E4;
%     durREMsham(k)=mean(End(REMEpoch)-Start(REMEpoch))/1E4;
%     
%     clear Wake REMEpoch SWSEpoch
% end




%%

FI_ctrl = NbREMctrl ./ durREMctrl;
FI_opto = NbREMopto ./ durREMopto;


%%



%% corr number bouts wake / NREM
% h=figure('Color',[1 1 1]);
% s1=plot(NbWakeOpto,NbSWSopto,'ro',NbWakeCtrl,NbSWSctrl,'ko');
% set(s1,'MarkerSize',8,'Linewidth',2);
% hold on
% l=lsline;
% set(l,'LineWidth',1)
% xlabel('wake bouts nb')
% ylabel('NREM bouts nb')
% makepretty
% suptitle('control vs opto')
% 
% % [rho,pval]=corr(NbWakeOpto',NbSWSopto')
% % [rho,pval]=corr(NbWakeCtrl',NbSWSctrl')
% 
% % corr duration bouts wake / NREM
% h=figure('Color',[1 1 1]);
% s1=plot(durWakeOpto,durSWSopto,'ro',durWakeCtrl,durSWSctrl,'ko');
% set(s1,'MarkerSize',8,'Linewidth',2);
% hold on
% l=lsline;
% set(l,'LineWidth',1)
% xlabel('wake bout duration')
% ylabel('NREM bouts duration')
% makepretty
% suptitle('control vs opto')
% 
% % [rho,pval]=corr(durWakeOpto',durSWSopto')
% % [rho,pval]=corr(durWakeCtrl',durSWSctrl')
% 
% 
% %% corr number bouts wake / REM
% h=figure('Color',[1 1 1]);
% s1=plot(NbWakeOpto,NbREMopto,'ro',NbWakeCtrl,NbREMctrl,'ko');
% set(s1,'MarkerSize',8,'Linewidth',2);
% hold on
% l=lsline;
% set(l,'LineWidth',1)
% xlabel('wake bouts nb')
% ylabel('REM bouts nb')
% makepretty
% suptitle('control vs opto')
% 
% % [rho,pval]=corr(NbWakeOpto',NbREMopto')
% % [rho,pval]=corr(NbWakeCtrl',NbREMctrl')
% 
% % corr duration bouts wake / REM
% h=figure('Color',[1 1 1]);
% s1=plot(durWakeOpto,durREMopto,'ro',durWakeCtrl,durREMctrl,'ko');
% set(s1,'MarkerSize',8,'Linewidth',2);
% hold on
% l=lsline;
% set(l,'LineWidth',1)
% xlabel('wake bout duration')
% ylabel('REM bouts duration')
% makepretty
% suptitle('control vs opto')
% 
% % [rho,pval]=corr(durWakeOpto',durREMopto')
% % [rho,pval]=corr(durWakeCtrl',durREMctrl')
% 
% 
% %% corr number bouts SWS / REM
% h=figure('Color',[1 1 1]);
% s1=plot(NbSWSopto,NbREMopto,'ro',NbSWSctrl,NbREMctrl,'ko');
% set(s1,'MarkerSize',8,'Linewidth',2);
% hold on
% l=lsline;
% set(l,'LineWidth',1)
% xlabel('NREM bouts nb')
% ylabel('REM bouts nb')
% makepretty
% suptitle('control vs opto')
% 
% % [rho,pval]=corr(NbREMopto',NbSWSopto')
% % [rho,pval]=corr(NbREMctrl',NbSWSctrl')
% 
% % corr duration bouts wake / REM
% h=figure('Color',[1 1 1]);
% s1=plot(durSWSopto,durREMopto,'ro',durSWSctrl,durREMctrl,'ko');
% set(s1,'MarkerSize',8,'Linewidth',2);
% hold on
% l=lsline;
% set(l,'LineWidth',1)
% xlabel('NREM bout duration')
% ylabel('REM bouts duration')
% makepretty
% suptitle('control vs opto')
% 
% % [rho,pval]=corr(durREMopto',durSWSopto')
% % [rho,pval]=corr(durREMctrl',durSWSctrl')


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
col_ctrl=[.8 .8 .8];
% col_chr2=[.4 .8 1];
col_chr2=[.4 .4 .4];

figure
subplot(331)
MakeBoxPlot_MC({ResWakeCtrl(:,1), ResWakeOpto(:,1)},...
    {col_ctrl,col_chr2},[1:2],{},1,0);
xticks([1 2]); xticklabels({'mCherry','ChR2'})
ylabel('Wake percentage (%)')
makepretty
% [h,p]=ttest2(ResWakeCtrl(:,1), ResWakeOpto(:,1));
p=ranksum(ResWakeCtrl(:,1), ResWakeOpto(:,1));
if p<0.05
    sigstar_DB({[1 2]},p,0,'LineWigth',16,'StarSize',24);
end
title(['p=', num2str(p)])

subplot(332)
MakeBoxPlot_MC({ResSWSCtrl(:,1), ResSWSOpto(:,1)},...
    {col_ctrl,col_chr2},[1:2],{},1,0);
xticks([1 2]); xticklabels({'mCherry','ChR2'})
ylabel('NREM percentage (%)')
makepretty
% [h,p]=ttest2(ResSWSCtrl(:,1), ResSWSOpto(:,1));
p=ranksum(ResSWSCtrl(:,1), ResSWSOpto(:,1));
if p<0.05
    sigstar_DB({[1 2]},p,0,'LineWigth',16,'StarSize',24);
end
title(['p=', num2str(p)])

subplot(333)
MakeBoxPlot_MC({ResREMCtrl(:,1), ResREMOpto(:,1)},...
    {col_ctrl,col_chr2},[1:2],{},1,0);
xticks([1 2]); xticklabels({'mCherry','ChR2'})
ylabel('REM percentage (%)')
makepretty
% [h,p]=ttest2(ResREMCtrl(:,1), ResREMOpto(:,1));
p=ranksum(ResREMCtrl(:,1), ResREMOpto(:,1));
if p<0.05
    sigstar_DB({[1 2]},p,0,'LineWigth',16,'StarSize',24);
end
title(['p=', num2str(p)])


% figure
subplot(334)
MakeBoxPlot_MC({NbWakeCtrl, NbWakeOpto},...
    {col_ctrl,col_chr2},[1:2],{},1,0);
xticks([1 2]); xticklabels({'mCherry','ChR2'})
ylabel('# Wake')
makepretty
% [h,p]=ttest2(NbWakeCtrl, NbWakeOpto);
p=ranksum(NbWakeCtrl, NbWakeOpto);
if p<0.05
    sigstar_DB({[1 2]},p,0,'LineWigth',16,'StarSize',24);
end
title(['p=', num2str(p)])

subplot(335)
MakeBoxPlot_MC({NbSWSctrl, NbSWSopto},...
    {col_ctrl,col_chr2},[1:2],{},1,0);
xticks([1 2]); xticklabels({'mCherry','ChR2'})
ylabel('# NREM')
makepretty
% [h,p]=ttest2(NbSWSctrl, NbSWSopto);
p=ranksum(NbSWSctrl, NbSWSopto);
if p<0.05
    sigstar_DB({[1 2]},p,0,'LineWigth',16,'StarSize',24);
end
title(['p=', num2str(p)])

subplot(336)
MakeBoxPlot_MC({NbREMctrl, NbREMopto},...
    {col_ctrl,col_chr2},[1:2],{},1,0);
xticks([1 2]); xticklabels({'mCherry','ChR2'})
ylabel('# REM')
makepretty
% [h,p]=ttest2(NbREMctrl, NbREMopto);
p=ranksum(NbREMctrl, NbREMopto);
if p<0.05
    sigstar_DB({[1 2]},p,0,'LineWigth',16,'StarSize',24);
end
title(['p=', num2str(p)])


subplot(337)
MakeBoxPlot_MC({durWakeCtrl, durWakeOpto},...
    {col_ctrl,col_chr2},[1:2],{},1,0);
xticks([1 2]); xticklabels({'mCherry','ChR2'})
ylabel('Wake mean duration (s)')
makepretty
% [h,p]=ttest2(durWakeCtrl, durWakeOpto);
p=ranksum(durWakeCtrl, durWakeOpto);
if p<0.05
    sigstar_DB({[1 2]},p,0,'LineWigth',16,'StarSize',24);
end
title(['p=', num2str(p)])

subplot(338)
MakeBoxPlot_MC({durSWSctrl, durSWSopto},...
    {col_ctrl,col_chr2},[1:2],{},1,0);
xticks([1 2]); xticklabels({'mCherry','ChR2'})
ylabel('NREM mean duration (s)')
makepretty
% [h,p]=ttest2(durSWSctrl, durSWSopto);
p=ranksum(durSWSctrl, durSWSopto);
if p<0.05
    sigstar_DB({[1 2]},p,0,'LineWigth',16,'StarSize',24);
end
title(['p=', num2str(p)])

subplot(339)
MakeBoxPlot_MC({durREMctrl, durREMopto},...
    {col_ctrl,col_chr2},[1:2],{},1,0);
xticks([1 2]); xticklabels({'mCherry','ChR2'})
ylabel('REM mean duration (s)')
makepretty
% [h,p]=ttest2(durREMctrl, durREMopto);
p=ranksum(durREMctrl, durREMopto);
if p<0.05
    sigstar_DB({[1 2]},p,0,'LineWigth',16,'StarSize',24);
end
title(['p=', num2str(p)])



%%
col_on = [.4 .8 1];

col_basal=[.8 .8 .8];
col_opto = [.4 .8 1];


% PlotErrorBarN_KJ({prob_trans_REM_to_SWSEpoch_post_basal_10_end prob_trans_REM_to_SWSEpoch_post_SD},...
%     'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2],'barcolors',{col_basal, col_SD});
% xticks([1 2]); xticklabels({'mCherry','ChR2'})


figure
PlotErrorBarN_KJ({durREMctrl, durREMopto},...
     'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2],'barcolors',{col_basal, col_opto});
xticks([1 2]); xticklabels({'mCherry','ChR2'})
ylabel('REM mean duration (s)')
makepretty
[h,p]=ttest2(durREMctrl, durREMopto);
% p=ranksum(durREMctrl, durREMopto);
if p<0.05
    sigstar_DB({[1 2]},p,0,'LineWigth',16,'StarSize',24);
end
title(['p=', num2str(p)])



%%



figure
PlotErrorBarN_KJ({FI_ctrl, FI_opto},...
     'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2],'barcolors',{col_basal, col_opto});
xticks([1 2]); xticklabels({'mCherry','ChR2'})
ylabel('REM FI')
makepretty
[h,p]=ttest2(FI_ctrl, FI_opto);
% p=ranksum(FI_ctrl, FI_opto);
if p<0.05
    sigstar_DB({[1 2]},p,0,'LineWigth',16,'StarSize',24);
end
title(['p=', num2str(p)])
