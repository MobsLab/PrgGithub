function latencyToSWS = LatencyREMtoNREMafterOpto_MC(WakeWiNoise,SWSEpochWiNoise,REMEpochWiNoise)

REMEpoch  =mergeCloseIntervals(REMEpochWiNoise,1E4);
SWSEpoch = mergeCloseIntervals(SWSEpochWiNoise,1E4);
WakeEpoch =  mergeCloseIntervals(WakeWiNoise,1E4);

[Stim, StimREM, StimSWS, StimWake, Stimts] = FindOptoStim_MC(WakeWiNoise,SWSEpochWiNoise,REMEpochWiNoise);
[aft_cell,bef_cell]=transEpoch(REMEpoch,SWSEpoch);

% TransREMtoSWS=Start(aft_cell{1,2});
TransREMtoSWS=Stop(REMEpoch);

clear latencyToSWS
for i=1:length(StimREM)
    TransAfterStim=[];
    for j=1:length(TransREMtoSWS)
        TransAfterStim=[TransAfterStim;TransREMtoSWS(j)-StimREM(i)];
    end
    if isempty(find(TransAfterStim>0,1,'first')) & i==length(StimREM)
    else
        latencyToSWS(i)=TransAfterStim(find(TransAfterStim>0,1,'first'));
    end
end

end

% figure,subplot(121),line([Start(REMEpochWiNoise) Stop(REMEpochWiNoise)]',[Start(REMEpochWiNoise) Stop(REMEpochWiNoise)]'*0+1,'color','k','linewidth',3)
% hold on
% plot(StimREM,1,'r*')
% subplot(122), hist(latencyToSWS)
