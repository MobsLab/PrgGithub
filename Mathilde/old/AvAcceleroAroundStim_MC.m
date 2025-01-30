% DirCtrl=PathForExperiments_Opto_MC('PFC_Control_20Hz');
% Dir=PathForExperiments_Opto_MC('PFC_Control_20Hz');
% 
% DirOpto=PathForExperiments_Opto_MC('PFC_Stim_20Hz');
% 
% DirOpto = RestrictPathForExperiment(DirOpto, 'nMice', [1074 1076 1109 1136 1137]);
% % Dir{2}=PathForExperiments_Opto_MC('Septum_Stim_20Hz');
% 
% 
% %%
% DirDREADD = PathForExperiments_DREADD_MC('OneInject_Nacl');
% % DirDREADD = RestrictPathForExperiment(DirDREADD, 'nMice', [1106 1150]);
% 
% DirOpto_ChR = PathForExperiments_Opto_MC('PFC_Stim_20Hz');
% DirOpto_ChR = RestrictPathForExperiment(DirOpto_ChR, 'nMice', [1074 1076 1109 1136 1137]);
% 
% DirOpto_Ctrl = PathForExperiments_Opto_MC('PFC_Control_20Hz');
% % DirOpto_Ctrl = RestrictPathForExperiment(DirOpto_Ctrl, 'nMice', [1075 1112]);
% 
% DirOpto = MergePathForExperiment(DirOpto_ChR, DirOpto_Ctrl);
% 
% DirAccelero = MergePathForExperiment(DirDREADD, DirOpto);

%% Input dir
DirCtrl=PathForExperiments_Opto_MC('PFC_Control_20Hz');
% % DirCtrl = RestrictPathForExperiment(DirCtrl, 'nMice', [1075 1111 1112 1180 1181]);
% 
DirOpto=PathForExperiments_Opto_MC('PFC_Stim_20Hz');
% DirOpto = RestrictPathForExperiment(DirOpto, 'nMice', [675 733 1137 1136 648 1074]);%1109
DirOpto = RestrictPathForExperiment(DirOpto, 'nMice', [ 1137 1136 1109 1074]);%1109

%%
number=1;
for j=1:length(DirCtrl.path)
    cd(DirCtrl.path{j}{1});
    
    [MStartSWS,TStartSWS,MStartREM,TStartREM,MStartWake,TStartWake,MEndSWS,TEndSWS,MEndREM,TEndREM,MEndWake,TEndWake,Mstim,Tstim] = PlotAccAroundStim_MC;
    startSWS{j}=TStartSWS;
    startREM{j}=TStartREM;
    startWake{j}=TStartWake;
    
    endSWS{j}=TEndSWS;
    endREM{j}=TEndREM;
    endWake{j}=TEndWake;
    
    stdErrStartSWS{j}=MStartSWS(:,4);
    stdErrStartREM{j}=MStartREM(:,4);
    stdErrStartWake{j}=MStartWake(:,4);
    
    stdErrEndSWS{j}=MEndSWS(:,4);
    stdErrEndREM{j}=MEndREM(:,4);
    stdErrEndWake{j}=MEndWake(:,4);
    
    stimOnset{j}=Tstim;
    stdErrStim{j}=Mstim(:,4);
    
    
    for jj=1:length(stimOnset)
        AvStartSWS(jj,:)=nanmean(startSWS{jj}(:,:),1);
        AvStartREM(jj,:)=nanmean(startREM{jj}(:,:),1);
        AvStartWake(jj,:)=nanmean(startWake{jj}(:,:),1);
        
        AvEndSWS(jj,:)=nanmean(endSWS{jj}(:,:),1);
        AvEndREM(jj,:)=nanmean(endREM{jj}(:,:),1);
        AvEndWake(jj,:)=nanmean(endWake{jj}(:,:),1);
        
        AvStdErrStartSWS(jj,:)=nanmean(stdErrStartSWS{jj}(:,:),2);
        AvStdErrStartREM(jj,:)=nanmean(stdErrStartREM{jj}(:,:),2);
        AvStdErrStartWake(jj,:)=nanmean(stdErrStartWake{jj}(:,:),2);
        
        AvStdErrEndSWS(jj,:)=nanmean(stdErrEndSWS{jj}(:,:),2);
        AvStdErrEndREM(jj,:)=nanmean(stdErrEndREM{jj}(:,:),2);
        AvStdErrEndWake(jj,:)=nanmean(stdErrEndWake{jj}(:,:),2);
        
        AvstimOnset(jj,:)=nanmean(stimOnset{jj}(:,:),1);
        AvstdErrStim(jj,:)=nanmean(stdErrStim{jj}(:,:),2);
    end
    
%     MouseId(number) = Dir{1}.nMice{j} ;
%     number=number+1;
end

%%
numberOpto=1;
for i=1:length(DirOpto.path)
    cd(DirOpto.path{i}{1});
    [MStartSWS,TStartSWS,MStartREM,TStartREM,MStartWake,TStartWake,MEndSWS,TEndSWS,MEndREM,TEndREM,MEndWake,TEndWake,Mstim,Tstim] = PlotAccAroundStim_MC;
    
    stimOnsetOpto{i}=Tstim;
    stdErrStimOpto{i}=Mstim(:,4);

    for ii=1:length(stimOnsetOpto)
        AvstimOnsetOpto(ii,:)=nanmean(stimOnsetOpto{ii}(:,:),1);
        AvstdErrStimOpto(ii,:)=nanmean(stdErrStimOpto{ii}(:,:),2);
    end
    
%     MouseId(numberOpto) = Dir{2}.nMice{i} ;
%     numberOpto=numberOpto+1;
end

%%
% figure,
% subplot(331),shadedErrorBar(Mstim(:,1),median(AvStartREM)',median(AvStdErrStartREM)','-g',1);
% ylim([0 2e16])
% line([0 0], ylim,'color','k','linestyle',':')
% title('REM start')
% subplot(332),shadedErrorBar(Mstim(:,1),median(AvStartSWS)',median(AvStdErrStartSWS)','-r',1);
% ylim([0 2e16])
% line([0 0], ylim,'color','k','linestyle',':')
% title('NREM start')
% subplot(333),shadedErrorBar(Mstim(:,1),median(AvStartWake)',median(AvStdErrStartWake)','-b',1);
% ylim([0 2e16])
% line([0 0], ylim,'color','k','linestyle',':')
% title('Wake start')
% subplot(334),shadedErrorBar(Mstim(:,1),median(AvEndREM)',median(AvStdErrEndREM)','-g',1);
% ylim([0 2e16])
% line([0 0], ylim,'color','k','linestyle',':')
% title('REM end')
% subplot(335),shadedErrorBar(Mstim(:,1),median(AvEndSWS)',median(AvStdErrEndSWS)','-r',1);
% ylim([0 2e16])
% line([0 0], ylim,'color','k','linestyle',':')
% title('NREM end')
% subplot(336),shadedErrorBar(Mstim(:,1),median(AvEndWake)',median(AvStdErrEndWake)','-b',1);
% ylim([0 2e16])
% line([0 0], ylim,'color','k','linestyle',':')
% title('Wake end')
% subplot(337),shadedErrorBar(Mstim(:,1),median(AvstimOnset)',median(AvstdErrStim)','-k',1);
% ylim([0 2e16])
% line([0 0], ylim,'color','k','linestyle',':')
% title('stim ctrl mice')
% subplot(338),shadedErrorBar(Mstim(:,1),median(AvstimOnsetOpto)',median(AvstdErrStimOpto)','-k',1);
% ylim([0 2e16])
% line([0 0], ylim,'color','k','linestyle',':')
% title('stim opto mice')

%%


figure,
subplot(331),shadedErrorBar(Mstim(:,1),runmean(mean(AvStartREM)',10),median(AvStdErrStartREM)','-g',1);
xlabel('Time (s)')
xlim([-60 60])
ylim([0 1.5e16])
line([0 0], ylim,'color','k','linestyle',':')
title('REM start')

subplot(332),shadedErrorBar(Mstim(:,1),runmean(mean(AvStartSWS)',10),median(AvStdErrStartSWS)','-r',1);
xlabel('Time (s)')
xlim([-60 60])
ylim([0 1.5e16])
line([0 0], ylim,'color','k','linestyle',':')
title('NREM start')

subplot(333),shadedErrorBar(Mstim(:,1),runmean(mean(AvStartWake)',10),median(AvStdErrStartWake)','-b',1);
xlabel('Time (s)')
xlim([-60 60])
ylim([0 1.5e16])
line([0 0], ylim,'color','k','linestyle',':')
title('Wake start')

subplot(334),shadedErrorBar(Mstim(:,1),runmean(mean(AvEndREM)',10),median(AvStdErrEndREM)','-g',1);
xlabel('Time (s)')
xlim([-60 60])
ylim([0 1.5e16])
line([0 0], ylim,'color','k','linestyle',':')
title('REM end')

subplot(335),shadedErrorBar(Mstim(:,1),runmean(mean(AvEndSWS)',10),median(AvStdErrEndSWS)','-r',1);
xlabel('Time (s)')
xlim([-60 60])
ylim([0 1.5e16])
line([0 0], ylim,'color','k','linestyle',':')
title('NREM end')

subplot(336),shadedErrorBar(Mstim(:,1),runmean(mean(AvEndWake)',10),median(AvStdErrEndWake)','-b',1);
xlabel('Time (s)')
xlim([-60 60])
ylim([0 1.5e16])
line([0 0], ylim,'color','k','linestyle',':')
title('Wake end')

subplot(337),shadedErrorBar(Mstim(:,1),runmean(mean(AvstimOnset)',10),median(AvstdErrStim)','-k',1);
xlabel('Time (s)')
xlim([-60 60])
ylim([0 1.5e16])
line([0 0], ylim,'color','k','linestyle',':')
title('stim ctrl mice')

subplot(338),shadedErrorBar(Mstim(:,1),runmean(mean(AvstimOnsetOpto)',10),median(AvstdErrStimOpto)','-k',1);
xlabel('Time (s)')
xlim([-60 60])
ylim([0 1.5e16])
line([0 0], ylim,'color','k','linestyle',':')
title('stim opto mice')


