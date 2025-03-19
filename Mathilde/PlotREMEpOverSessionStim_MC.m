
Dir{1}=PathForExperiments_Opto_MC('PFC_Stim_20Hz');

number=1;
figure,hold on
for i=1:length(Dir{1}.path)
    cd(Dir{1}.path{i}{1});
    load SleepScoring_OBGamma REMEpochWiNoise SWSEpochWiNoise WakeWiNoise SmoothTheta SmoothGamma
    REMEp  =mergeCloseIntervals(REMEpochWiNoise,1E4);
    SWSEp = mergeCloseIntervals(SWSEpochWiNoise,1E4);
    WakeEp =  mergeCloseIntervals(WakeWiNoise,1E4);
    tps=Range(SmoothTheta);

    [Stim, StimREM, StimSWS, StimWake, Stimts] = FindOptoStim_MC;
    StimR=Range(Restrict(Stimts,REMEp))/1E4;
    line([0/3600e4 tps(end)/3600e4],[i i],'color',[0.7 0.7 0.7])

    plot([Start(REMEpochWiNoise)/3600e4 Stop(REMEpochWiNoise)/3600e4]',[Start(REMEpochWiNoise)/3600e4 Stop(REMEpochWiNoise)/3600e4]'*0+i,'r.')
%     line([Start(REMEpochWiNoise)/3600e4 Stop(REMEpochWiNoise)/3600e4]',[Start(REMEpochWiNoise)/3600e4 Stop(REMEpochWiNoise)/3600e4]'*0+i,'color','k','linewidth',10)
    
plot(StimREM/3600e4,i,'r*')
%     ylim([0 6])
    
    MouseId(number) = Dir{1}.nMice{i} ;
    number=number+1;
end