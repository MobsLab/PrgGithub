
Dir{1}=PathForExperiments_Opto_MC('PFC_Control_20Hz');
    
REM_DurThresh = 1.7e5;
% REM_DurThresh = median(durREM);

number=1;
figure,hold on
for j=1:length(Dir{1}.path)
    cd(Dir{1}.path{j}{1})
    load SleepScoring_OBGamma REMEpochWiNoise SWSEpochWiNoise WakeWiNoise SmoothTheta SmoothGamma
    REMEp  = mergeCloseIntervals(REMEpochWiNoise,1E4);
    SWSEp = mergeCloseIntervals(SWSEpochWiNoise,1E4);
    WakeEp =  mergeCloseIntervals(WakeWiNoise,1E4);
    tps=Range(SmoothTheta);
    
    StartREMBouts = Start(REMEp);
    EndREMBouts = End(REMEp);
    
    [durREM,durTREM]=DurationEpoch(REMEp);

    for i = 1:length(StartREMBouts)
        if durREM(i) < REM_DurThresh
            line([0/3600e4 tps(end)/3600e4],[j j],'color',[0.7 0.7 0.7])
            line([StartREMBouts(i)/3600e4 EndREMBouts(i)/3600e4]',[StartREMBouts(i)/3600e4 EndREMBouts(i)/3600e4]'*0+j,'color','b','linewidth',10)
        else
            line([0/3600e4 tps(end)/3600e4],[j j],'color',[0.7 0.7 0.7])
            line([StartREMBouts(i)/3600e4 EndREMBouts(i)/3600e4]',[StartREMBouts(i)/3600e4 EndREMBouts(i)/3600e4]'*0+j,'color','r','linewidth',10)
            ylim([0 9])
        end
    end
    
    clear REMEpochWiNoise SWSEpochWiNoise WakeWiNoise

    MouseId(number) = Dir{1}.nMice{j} ;
    number=number+1;
end