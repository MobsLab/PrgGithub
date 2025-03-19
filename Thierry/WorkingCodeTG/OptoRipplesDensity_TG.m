%% input dir
DirCtrl=PathForExperiments_Opto_MC('PFC_Control_20Hz');
DirCtrl = RestrictPathForExperiment(DirCtrl, 'nMice', [1075 1111 1112]);
DirOpto=PathForExperiments_Opto_MC('PFC_Stim_20Hz');
DirOpto = RestrictPathForExperiment(DirOpto, 'nMice', [733 1076 1109 1136 1137]);

%% get data
number=1;
for i=1:length(DirCtrl.path)
    cd(DirCtrl.path{i}{1});
    [MatRemThet,MatRemGam,MatRemDel,MatRemRip,MatRemRipStart,MatRemRipEnd,MatRemBet,MatRemBetStart,MatRemBetEnd] = PlotMultipleParamDuringStim_MC_SB;
    dataRipp{i}=MatRemRip;
    dataDelt{i}=MatRemDel;
    dataThet{i}=MatRemThet;
    
    [MatRemThet,MatRemGam,MatRemDel,MatRemRip,MatRemRipStart,MatRemRipEnd,MatRemBet,MatRemBetStart,MatRemBetEnd] = PlotMultipleParamDuringStim_MC_SB;
    dataRippStartRem{i}=MatRemRipStart;
    dataRippEndRem{i}=MatRemRipEnd;
    
%     MouseId(number) = DirCtrl.nMice{i} ;
%     number=number+1;
end
clear MatRemRip MatRemDel MatRemThet

numberOpto=1;
for j=1:length(DirOpto.path)
    cd(DirOpto.path{j}{1});
    [MatRemThet,MatRemGam,MatRemDel,MatRemRip,MatRemRipStart,MatRemRipEnd,MatRemBet,MatRemBetStart,MatRemBetEnd] = PlotMultipleParamDuringStim_MC_SB;
    dataRippOpto{j}=MatRemRip;
    dataDeltOpto{j}=MatRemDel;
    dataThetOpto{j}=MatRemThet;
    
%     MouseId(numberOpto) = DirOpto.nMice{j} ;
%     numberOpto=numberOpto+1;
end

%% average accross mice
data_ripp=cat(3,dataRipp{:});
data_rippOpto=cat(3,dataRippOpto{:});

data_rippStartRem=cat(3,dataRippStartRem{:});
data_rippEndRem=cat(3,dataRippEndRem{:});

data_delt=cat(3,dataDelt{:});
data_deltOpto=cat(3,dataDeltOpto{:});

data_thet=cat(3,dataThet{:});
data_thetOpto=cat(3,dataThetOpto{:});

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
xlim([-60 +60])
line([0 0], ylim,'color','k','linestyle',':','linewidth',2)
xlabel('Time (s)')
ylabel('Density (ripples/s)')

%%  MEAN ripples
% mean
data_rippCtrl_mean = mean(data_ripp(:,2,:),2);
data_rippOpto_mean = mean(data_rippOpto(:,2,:),2);
% SEM
data_rippCtrl_SEM = std(squeeze(data_rippCtrl_mean)');
data_rippOpto_SEM = std(squeeze(data_rippOpto_mean)');
% to normalize
normOpto=mean(mean(data_rippOpto(20:40,2,:)));
norm=mean(mean(data_ripp(20:40,2,:)));

% figure
figure,shadedErrorBar(data_ripp(:,1),runmean(mean(data_rippOpto_mean,3),3)/norm,data_rippOpto_SEM','r',1), hold on
shadedErrorBar(data_ripp(:,1),runmean(mean(data_rippCtrl_mean,3),3)/norm,data_rippCtrl_SEM','k',1), hold on
makepretty
xlim([-20 +60])
line([0 0], ylim,'color','k','linestyle',':','linewidth',2)
xlabel('Time (s)')
ylabel('Density (ripples/s)')
ax1 = gca;
ax2 = axes('Position',[.48 .65 .25 .3]);
box on
PlotErrorBarN_KJ({mean(data_rippCtrl_mean(idxduring,:))/norm mean(data_rippOpto_mean(idxduring,:))/norm}, 'paired',0, 'newfig',0)
xticks([1 2])
xticklabels({'ctrl','opto'})
ylabel('Density (ripples/s)')
makepretty

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

%% delta : traces for each mouse + mean
figure,
plot(data_delt(:,1),runmean(squeeze(data_delt(:,2,:)),4),'color',[0.6 0.6 0.6]), hold on
plot(data_delt(:,1),nanmean(runmean(squeeze(data_delt(:,2,:)),4),2),'k','linewidth',2)
plot(data_delt(:,1),runmean(squeeze(data_deltOpto(:,2,:)),4),'color',[1 0.0 0.4])
plot(data_delt(:,1),nanmean(runmean(squeeze(data_deltOpto(:,2,:)),4),2),'r','linewidth',2)
line([0 0], ylim,'color','k','linestyle',':','linewidth',2)
% makepretty
xlim([-60 +60])
xlabel('Time (s)')
ylabel('Density (delta/s)')

%%  MEAN deltas
% mean
data_deltCtrl_mean = mean(data_delt(:,2,:),2);
data_deltOpto_mean = mean(data_deltOpto(:,2,:),2);
% SEM
data_deltCtrl_SEM = std(squeeze(data_deltCtrl_mean)');
data_deltOpto_SEM = std(squeeze(data_deltOpto_mean)');
% to normalize
norm_delt=mean(mean(data_delt(20:40,2,:)));

% figure
figure,shadedErrorBar(data_delt(:,1),runmean(mean(data_deltOpto_mean,3),3)/norm_delt, data_deltOpto_SEM','r',1), hold on
shadedErrorBar(data_delt(:,1),runmean(mean(data_deltCtrl_mean,3),3)/norm_delt, data_deltCtrl_SEM','k',1), hold on
makepretty
xlim([-20 +60])
line([0 0], ylim,'color','k','linestyle',':','linewidth',2)
xlabel('Time (s)')
ylabel('Density (deltas/s)')
% ax1 = gca;
% ax2 = axes('Position',[.4 .65 .25 .3]);
% box on
figure, PlotErrorBarN_KJ({mean(data_deltCtrl_mean(idxduring,:))/norm_delt mean(data_deltOpto_mean(idxduring,:))/norm_delt}, 'paired',0, 'newfig',0)
xticks([1 2])
xticklabels({'ctrl','opto'})
ylabel('Density (deltas/s)')
makepretty


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

