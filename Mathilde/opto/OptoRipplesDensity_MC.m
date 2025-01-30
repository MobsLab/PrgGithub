%% input dir
DirCtrl=PathForExperiments_Opto_MC('PFC_Control_20Hz');
DirCtrl = RestrictPathForExperiment(DirCtrl, 'nMice', [1075 1111 1112 1180 1181]);
DirOpto=PathForExperiments_Opto_MC('PFC_Stim_20Hz');
% DirOpto = RestrictPathForExperiment(DirOpto, 'nMice', [733 1137 1136 1109 1076]);
DirOpto = RestrictPathForExperiment(DirOpto, 'nMice', [733 1137 1136 1109 1076]);%648

timebin = 1;

%% get data
number=1;
for k=1:length(DirCtrl.path)
    cd(DirCtrl.path{k}{1});
        %%load sleep scoring
    if exist('SleepScoring_OBGamma.mat')
        c{k} = load('SleepScoring_OBGamma', 'REMEpochWiNoise', 'SWSEpochWiNoise', 'WakeWiNoise');
        
    elseif exist('SleepScoring_Accelero.mat')
        c{k} = load('SleepScoring_Accelero', 'REMEpochWiNoise', 'SWSEpochWiNoise', 'WakeWiNoise');
    else
    end
    [MatRemRip,MatRemRipStart,MatRemRipEnd] = GetRipplesDensityOpto_MC(c{k}.WakeWiNoise,c{k}.SWSEpochWiNoise,c{k}.REMEpochWiNoise,'rem',timebin);
    dataRipp{k}=MatRemRip;
    
%     MouseId(number) = DirCtrl.nMice{i} ;
%     number=number+1;
end
clear MatRemRip MatRemDel MatRemThet

numberOpto=1;
for j=1:length(DirOpto.path)
    cd(DirOpto.path{j}{1});
        if exist('SleepScoring_OBGamma.mat')
        b{j} = load('SleepScoring_OBGamma', 'REMEpochWiNoise', 'SWSEpochWiNoise', 'WakeWiNoise');
        
    elseif exist('SleepScoring_Accelero.mat')
        b{j} = load('SleepScoring_Accelero', 'REMEpochWiNoise', 'SWSEpochWiNoise', 'WakeWiNoise');
    else
    end
    [MatRemRip,MatRemRipStart,MatRemRipEnd] = GetRipplesDensityOpto_MC(b{j}.WakeWiNoise,b{j}.SWSEpochWiNoise,b{j}.REMEpochWiNoise,'rem',timebin);

    dataRippOpto{j}=MatRemRip;

    
%     MouseId(numberOpto) = DirOpto.nMice{j} ;
%     numberOpto=numberOpto+1;
end

%% average accross mice
data_ripp=cat(3,dataRipp{:});
data_rippOpto=cat(3,dataRippOpto{:});

% data_rippStartRem=cat(3,dataRippStartRem{:});
% data_rippEndRem=cat(3,dataRippEndRem{:});

% data_delt=cat(3,dataDelt{:});
% data_deltOpto=cat(3,dataDeltOpto{:});
% 
% data_thet=cat(3,dataThet{:});
% data_thetOpto=cat(3,dataThetOpto{:});

%% index to restrain time durinf the stim
idxduring=find(data_ripp(:,1)>0&data_ripp(:,1)<30);
idxbefore=find(data_ripp(:,1)>-30&data_ripp(:,1)<0);

%% ripples : traces for each mouse + mean
figure,
plot(data_ripp(:,1),runmean(squeeze(data_ripp(:,2,:)),4),'color',[0.6 0.6 0.6]), hold on
plot(data_ripp(:,1),nanmean(runmean(squeeze(data_ripp(:,2,:)),4),2),'k','linewidth',2)
plot(data_ripp(:,1),runmean(squeeze(data_rippOpto(:,2,:)),4),'color',[1 0.0 0.4])
plot(data_ripp(:,1),nanmean(runmean(squeeze(data_rippOpto(:,2,:)),4),2),'r','linewidth',2)
% makepretty
% xlim([-60 +60])
line([0 0], ylim,'color','k','linestyle',':','linewidth',2)
xlabel('Time (s)')
ylabel('Density (ripples/s)')

%%  MEAN ripples
% mean
data_rippCtrl_mean = mean(data_ripp(:,2,:),2);
data_rippOpto_mean = mean(data_rippOpto(:,2,:),2);
% SEM
data_rippCtrl_SEM = std(squeeze(data_rippCtrl_mean)',1);
data_rippOpto_SEM = std(squeeze(data_rippOpto_mean)',1);
% to normalize
normOpto=mean(mean(data_rippOpto(20:40,2,:)));
norm=mean(mean(data_ripp(20:40,2,:)));

figure,subplot(1,3,[1,2]),shadedErrorBar(data_ripp(:,1),runmean(mean(data_rippOpto_mean,3),3)/normOpto,data_rippOpto_SEM','r',1), hold on
shadedErrorBar(data_ripp(:,1),runmean(mean(data_rippCtrl_mean,3),3)/norm,data_rippCtrl_SEM','k',1), hold on
makepretty
xlim([-20 +60])
line([0 0], ylim,'color','k','linestyle',':','linewidth',2)
xlabel('Time (s)')
ylabel('Density (ripples/s)')
% ax1 = gca;
% ax2 = axes('Position',[.48 .65 .25 .3]);
% box on
subplot(133),PlotErrorBarN_KJ({mean(data_rippCtrl_mean(idxduring,:))/norm mean(data_rippOpto_mean(idxduring,:))/normOpto}, 'paired',0, 'newfig',0)
xticks([1 2])
xticklabels({'ctrl','opto'})
ylabel('Density (ripples/s)')
makepretty


%%

timebin=2;
figure, hold on, 
plot(data_ripp(1:timebin:121,1), nanmean(data_rippOpto_mean(1:timebin:121,:,:),3),'linestyle','-','marker','o','markerfacecolor',[1 0 0],'color',[1 0 0])
errorbar(data_ripp(1:timebin:121,1), nanmean(squeeze(data_rippOpto_mean(1:timebin:121,:,:))'), stdError(squeeze(data_rippOpto_mean(1:timebin:121,:,:))'))

plot(data_ripp(1:timebin:121,1), nanmean(data_rippCtrl_mean(1:timebin:121,:,:),3),'linestyle','-','marker','o','markerfacecolor',[.8 .8 .8],'color',[.8 .8 .8])
errorbar(data_ripp(1:timebin:121,1), nanmean(squeeze(data_rippCtrl_mean(1:timebin:121,:,:))'), stdError(squeeze(data_rippCtrl_mean(1:timebin:121,:,:))'))

xlim([-10 60])
makepretty 
%% clean figure (csi)

% col_ctrl=[.8 .8 .8];
% col_chr2=[.4 .4 .4];

col_ctrl=[.8 .8 .8];
% col_chr2=[.4 .8 1];
col_chr2=[.3 .3 .3];



% figure
figure,subplot(1,3,[1,2]),shadedErrorBar(data_ripp(:,1),runmean(mean(data_rippOpto_mean,3),3)/normOpto,data_rippOpto_SEM','r',1), hold on
shadedErrorBar(data_ripp(:,1),runmean(mean(data_rippCtrl_mean,3),3)/norm,data_rippCtrl_SEM','k',1), hold on
makepretty
xlim([-20 +60])
line([0 0], ylim,'color','k','linestyle',':','linewidth',2)
xlabel('Time (s)')
ylabel('Density (ripples/s)')
% ax1 = gca;
% ax2 = axes('Position',[.48 .65 .25 .3]);
% box on


subplot(133),
MakeSpreadAndBoxPlot2_SB({mean(data_rippCtrl_mean(idxduring,:))/norm mean(data_rippOpto_mean(idxduring,:))/normOpto},{col_ctrl,col_chr2},[1:2],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');

xticks([1 2])
xticklabels({'mCherry','ChR2'})
ylabel('Density (ripples/s)')
makepretty

p=ranksum(mean(data_rippCtrl_mean(idxduring,:))/norm, mean(data_rippOpto_mean(idxduring,:))/normOpto);
title(['p=', num2str(p)])



% % plot
% figure,shadedErrorBar(data_ripp(:,1),mean(runmean(squeeze(data_ripp(:,2,:)),4)')/norm,Std_Ripp,'k',1), hold on
% shadedErrorBar(data_rippOpto(:,1),mean(runmean(squeeze(data_rippOpto(:,2,:)),4)')/normOpto,Std_RippOpto,'r',1)
% % makepretty
% xlim([-60 +60])
% line([0 0], ylim,'color','k','linestyle',':','linewidth',2)
% xlabel('Time (s)')
% ylabel('Density (ripples/s)')
% 
% 
% figure,PlotErrorBarN_KJ({squeeze(nanmean(data_ripp(idxduring,2,:),1))/norm, squeeze(nanmean(data_rippOpto(idxduring,2,:),1))/normOpto},'newfig',0,'paired',0,'ShowSigstar','sig');
% xticks([1 2])
% xticklabels({'ctrl','opto'})
% ylabel('Density (ripples/s)')



%% plot theta-ripples correlation
varThetOpto=squeeze(nanmean(data_thetOpto(idxduring,2,:),1));
varThetCtrl=squeeze(nanmean(data_thet(idxduring,2,:),1));
varRipOpto=squeeze(nanmean(data_rippOpto(idxduring,2,:),1));
varRipCtrl=squeeze(nanmean(data_ripp(idxduring,2,:),1));

h=figure('Color',[1 1 1]);
s1=plot(varThetOpto,varRipOpto,'ro',varThetCtrl,varRipCtrl,'k+');
set(s1,'MarkerSize',8,'Linewidth',2);
hold on
l=lsline;
set(l,'LineWidth',1.5)
xlabel('theta power')
ylabel('ripples density (ripples/s)')

% to get corr value and the associated p value
% [rho,pval]=corr(varThetOpto,varRipOpto)
% [rho2,pval2]=corr(varThetCtrl,varRipCtrl)

%% figure avec densité ripples par souris start REM, end REM, ctrl et opto
figure,
subplot(3,4,[1,2]),plot(data_rippStartRem(:,1),runmean(squeeze(data_rippStartRem(:,2,:)),4),'k')
makepretty
xlim([-60 +60])
ylim([0 0.4])
line([0 0], ylim,'color','k','linestyle',':','linewidth',2)
xlabel('Time (s)')
ylabel('Density (ripples/s)')
title('start REM')
subplot(3,4,[5,6]),plot(data_rippEndRem(:,1),runmean(squeeze(data_rippEndRem(:,2,:)),4),'k')
makepretty
xlim([-60 +60])
ylim([0 0.4])
line([0 0], ylim,'color','k','linestyle',':','linewidth',2)
xlabel('Time (s)')
ylabel('Density (ripples/s)')
title('end REM')
subplot(3,4,[9,10]),plot(data_ripp(:,1),runmean(squeeze(data_ripp(:,2,:)),4),'k')
hold on
plot(data_ripp(:,1),runmean(squeeze(data_rippOpto(:,2,:)),4),'r')
makepretty
xlim([-60 +60])
ylim([0 0.4])
line([0 0], ylim,'color','k','linestyle',':','linewidth',2)
xlabel('Time (s)')
ylabel('Density (ripples/s)')
title('stim opto REM')
subplot(3,4,3),PlotErrorBarN_KJ({squeeze(nanmean(data_rippStartRem(idxbefore,2,:),1)), squeeze(nanmean(data_rippStartRem(idxduring,2,:),1))},'newfig',0,'paired',0,'ShowSigstar','sig');
xticks([1 2])
xticklabels({'before','during'})
ylabel('Density (ripples/s)')
subplot(3,4,7),PlotErrorBarN_KJ({squeeze(nanmean(data_rippEndRem(idxbefore,2,:),1)), squeeze(nanmean(data_rippEndRem(idxduring,2,:),1))},'newfig',0,'paired',0,'ShowSigstar','sig');
xticks([1 2])
xticklabels({'before','during'})
ylabel('Density (ripples/s)')
subplot(3,4,11),PlotErrorBarN_KJ({squeeze(nanmean(data_ripp(idxbefore,2,:),1)), squeeze(nanmean(data_rippOpto(idxbefore,2,:),1))},'newfig',0,'paired',0,'ShowSigstar','sig');
xticks([1 2])
xticklabels({'ctrl','opto'})
ylabel('Density (ripples/s)')
title('before')
subplot(3,4,12),PlotErrorBarN_KJ({squeeze(nanmean(data_ripp(idxduring,2,:),1)), squeeze(nanmean(data_rippOpto(idxduring,2,:),1))},'newfig',0,'paired',0,'ShowSigstar','sig');
xticks([1 2])
xticklabels({'ctrl','opto'})
ylabel('Density (ripples/s)')
title('during')

