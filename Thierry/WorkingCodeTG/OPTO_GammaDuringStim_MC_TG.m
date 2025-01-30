Dir{1}=PathForExperiments_Opto_MC('PFC_Control_20Hz');
Dir{2}=PathForExperiments_Opto_MC('PFC_Stim_20Hz');

numberCtrl=1;
for i=1:length(Dir{1}.path)
    cd(Dir{1}.path{i}{1});
    [MREMGam,MStartREMGam,MEndREMGam,MWakeGam,MStartWakeGam,MEndWakeGam] = GetGammaAroundStim_MC;
    dataGamREM{i}=MREMGam;
    dataGamStartREM{i}=MStartREMGam;
    dataGamEndREM{i}=MEndREMGam;
    dataGamWake{i}=MWakeGam;
    dataGamStartWake{i}=MStartWakeGam;
    dataGamEndWake{i}=MEndWakeGam;
    
    MouseId(numberCtrl) = Dir{1}.nMice{i} ;
    numberCtrl=numberCtrl+1;
end
clear MREMGam MStartREMGam MEndREMGam MWakeGam MStartWakeGam MEndWakeGam
 

numberOpto=1;
for j=1:length(Dir{2}.path)
    cd(Dir{2}.path{j}{1});
    
    [MREMGam,MStartREMGam,MEndREMGam,MWakeGam,MStartWakeGam,MEndWakeGam] = GetGammaAroundStim_MC;
    dataGamREMopto{j}=MREMGam;
    dataGamWakeOpto{j}=MWakeGam;
    
    MouseId(numberOpto) = Dir{2}.nMice{j} ;
    numberOpto=numberOpto+1;
end

%%
GamREM=cat(3,dataGamREM{:});
GamStartREM=cat(3,dataGamStartREM{:});
GamEndREM=cat(3,dataGamEndREM{:});
GamWake=cat(3,dataGamWake{:});
GamStartWake=cat(3,dataGamStartWake{:});
GamEndWake=cat(3,dataGamEndWake{:});
GamREMopto=cat(3,dataGamREMopto{:});
GamWakeOpto=cat(3,dataGamWakeOpto{:});

%%
Std_GamREM=std(runmean(squeeze(GamREM(:,2,:)),4)');
Std_GamStartREM=std(runmean(squeeze(GamStartREM(:,2,:)),4)');
Std_GamEndREM=std(runmean(squeeze(GamEndREM(:,2,:)),4)');
Std_GamWake=std(runmean(squeeze(GamWake(:,2,:)),4)');
Std_GamStartWake=std(runmean(squeeze(GamStartWake(:,2,:)),4)');
Std_GamEndWake=std(runmean(squeeze(GamEndWake(:,2,:)),4)');
Std_GamREMopto=std(runmean(squeeze(GamREMopto(:,2,:)),4)');
Std_GamWakeOpto=std(runmean(squeeze(GamWakeOpto(:,2,:)),4)');

%%
figure,subplot(421),shadedErrorBar(GamStartREM(:,1),mean(squeeze(GamStartREM(:,2,:)),2),Std_GamStartREM,'k',1)
ylim([0 600])
line([0 0],[0 600],'color','k','linestyle',':')
xlim([-60 60])
title('REM start')
subplot(422),shadedErrorBar(GamStartWake(:,1),mean(squeeze(GamStartWake(:,2,:)),2),Std_GamStartWake,'k',1)
ylim([0 600])
line([0 0],[0 600],'color','k','linestyle',':')
xlim([-60 60])
title('Wake start')
subplot(423),shadedErrorBar(GamEndREM(:,1),mean(squeeze(GamEndREM(:,2,:)),2),Std_GamEndREM,'k',1)
ylim([0 600])
line([0 0],[0 600],'color','k','linestyle',':')
xlim([-60 60])
title('REM end')
subplot(424),shadedErrorBar(GamEndWake(:,1),mean(squeeze(GamEndWake(:,2,:)),2),Std_GamEndWake,'k',1)
ylim([0 600])
line([0 0],[0 600],'color','k','linestyle',':')
xlim([-60 60])
title('Wake end')
subplot(425),shadedErrorBar(GamREM(:,1),mean(squeeze(GamREM(:,2,:)),2),Std_GamREM,'k',1)
ylim([0 600])
line([0 0],[0 600],'color','k','linestyle',':')
xlim([-60 60])
title('ctrl')
% subplot(426),shadedErrorBar(GamWake(:,1),mean(squeeze(GamWake(:,2,:)),2),Std_GamWake,'k',1)
% ylim([0 700])
% xlim([-60 60])
% line([0 0],[0 100],'color','k','linestyle',':')
subplot(427),shadedErrorBar(GamREMopto(:,1),mean(squeeze(GamREMopto(:,2,:)),2),Std_GamREMopto,'k',1)
ylim([0 600])
line([0 0],[0 600],'color','k','linestyle',':')
xlim([-60 60])
title('opto')
% subplot(428),shadedErrorBar(GamWakeOpto(:,1),mean(squeeze(GamWakeOpto(:,2,:)),2),Std_GamWakeOpto,'k',1)
% ylim([0 700])
% xlim([-60 60])
% line([0 0],[0 100],'color','k','linestyle',':')
suptitle('gamma power ctrl n=5 opto n=6')




