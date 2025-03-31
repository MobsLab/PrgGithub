function latencyREMAfterStimNREM = LatencyREMAfterStimulationInSWS_MC(WakeWiNoise,SWSEpochWiNoise,REMEpochWiNoise)

REMEpoch  =mergeCloseIntervals(REMEpochWiNoise,1E4);
SWSEpoch = mergeCloseIntervals(SWSEpochWiNoise,1E4);
WakeEpoch =  mergeCloseIntervals(WakeWiNoise,1E4);

[Stim, StimREM, StimSWS, StimWake, Stimts] = FindOptoStim_MC(WakeWiNoise,SWSEpochWiNoise,REMEpochWiNoise);
StimREM = FindOptoStimWithLongBout_MC(WakeEpoch, SWSEpoch, REMEpoch ,'rem', 5);


% [aft_cell,bef_cell]=transEpoch(WakeWiNoise,SWSEpochWiNoise);
% [aft_cell,bef_cell]=transEpoch(SWSEpochWiNoise,WakeWiNoise);
% 
% TransREMtoSWS=Start(aft_cell{1,2});


% TransREMtoSWS=Start(REMEpochWiNoise);
% TransREMtoSWS=Start(WakeWiNoise);
TransREMtoSWS=Start(SWSEpochWiNoise);

% stimulation = StimSWS;
stimulation = StimWake;
% stimulation = StimREM;

%%
clear latencyToSWS
if isempty(stimulation)==0
    for i=1:length(stimulation)
        TransAfterStim=[];
        for j=1:length(TransREMtoSWS)
            TransAfterStim=[TransAfterStim;TransREMtoSWS(j)-stimulation(i)];
        end
        if isempty(find(TransAfterStim>0,1,'first')) & i==length(stimulation)
        else
            latencyREMAfterStimNREM(i)=TransAfterStim(find(TransAfterStim>0,1,'first'));
        end
    end
else
    latencyREMAfterStimNREM=NaN;
end
end

% figure,subplot(121),line([Start(REMEpochWiNoise) Stop(REMEpochWiNoise)]',[Start(REMEpochWiNoise) Stop(REMEpochWiNoise)]'*0+1,'color','k','linewidth',3)
% hold on
% plot(StimREM,1,'r*')
% subplot(122), hist(latencyToSWS)
