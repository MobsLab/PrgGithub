Dir{1}=PathForExperiments_Opto_MC('PFC_Control_20Hz');
% Dir{2}=PathForExperiments_DREADD_MC('1Inj2mg_CNO');


number=1;
for i=1:length(Dir{1}.path)
    cd(Dir{1}.path{i}{1});
    
    cd(Dir{1}.path{i}{1});
    load SleepScoring_OBGamma REMEpochWiNoise SWSEpochWiNoise WakeWiNoise
    REMep{i}=mergeCloseIntervals(REMEpochWiNoise,1E4);
    SWSEp{i} = mergeCloseIntervals(SWSEpochWiNoise,1E4);
    WakeEp{i} =  mergeCloseIntervals(WakeWiNoise,1E4);
    
    [Stim, StimREM, StimSWS, StimWake, Stimts] = FindOptoStim_MC;
    StimW{i}=StimWake;
    StimS{i}=StimSWS;
    StimR{i}=StimREM;
    
    load('Bulb_deep_Low_Spectrum.mat')
    SpectroB{i}=Spectro;
    SpB=tsd(Spectro{2}*1E4,Spectro{1});
    fb=Spectro{3};
    SpOB{i}=SpB;
    frqB{i}=fb;
end
%%
for i=1:length(Dir{1}.path)
%     data_StimWake(i,:)=mean(10*(Data(Restrict(SpOB{i},StimW{i}))));
%     data_StimSWS(i,:)=mean(10*(Data(Restrict(SpOB{i},StimS{i}))));
%     data_StimREM(i,:)=mean(10*(Data(Restrict(SpOB{i},StimR{i}))));
    
      data_StimWake(i,:)=mean(10*(Data(Restrict(SpOB{i},WakeEp{i}))));
    data_StimSWS(i,:)=mean(10*(Data(Restrict(SpOB{i},SWSEp{i}))));
    data_StimREM(i,:)=mean(10*(Data(Restrict(SpOB{i},REMep{i}))));
end

avSpHt_StimWake=nanmean(data_StimWake);
avSpHt_StimSWS=nanmean(data_StimSWS);
avSpHt_StimREM=nanmean(data_StimREM);

SEM_SpHt_StimWake=std(data_StimWake)/sqrt(length(data_StimWake));
SEM_SpHt_StimSWS=std(data_StimSWS)/sqrt(length(data_StimSWS));
SEM_SpHt_StimREM=std(data_StimREM)/sqrt(length(data_StimREM));

%%
figure,
subplot(131),shadedErrorBar(frqB{1},avSpHt_StimWake,SEM_SpHt_StimWake,'b',1)
ylim([0 2.5e6])
ylabel('Power')
xlabel('frequency (Hz)')
title('Wakefulness')
subplot(132),shadedErrorBar(frqB{1},avSpHt_StimSWS,SEM_SpHt_StimSWS,'r',1)
ylim([0 2.5e6])
xlabel('frequency (Hz)')
title('NREM')
subplot(133);shadedErrorBar(frqB{1},avSpHt_StimREM,SEM_SpHt_StimREM,'g',1)
ylim([0 2.5e6])
% ylim([0 12e5])
ylabel('Power')
xlabel('frequency (Hz)')
title('REM')
suptitle('OB spectrum')