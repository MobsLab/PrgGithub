%ParcoursObserveSpectrumRescaled

Dir1=PathForExperimentsDeltaSleepNew('BASAL');
Dir2=PathForExperimentsML('BASAL');
Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
Dir=MergePathForExperiment(Dir1,Dir2);
a=1;ValT=[];
for man=1:length(Dir.path)
    disp(' '); disp(Dir.path{man})
    cd(Dir.path{man})
    [val,SpectrumN1{a},SpectrumN2{a},SpectrumN3{a},SpectrumSWS{a},SpectrumREM{a},SpectrumWake{a}]=ObserveSpectrumRescaled('PFCx');
    nameMouseDay{a}=Dir.path{man}(max(strfind(Dir.path{man},'Mouse')):end);
    ValT=[ValT;val];
    a=a+1;
end

figure('color',[1 1 1]), hold on
plot(smooth(mean(zscore(ValT(1:6:end,:)'),2),3),'k')
plot(smooth(mean(zscore(ValT(2:6:end,:)'),2),3),'b')
plot(smooth(mean(zscore(ValT(3:6:end,:)'),2),3),'c')
plot(smooth(mean(zscore(ValT(4:6:end,:)'),2),3),'k','linewidth',2)
plot(smooth(mean(zscore(ValT(5:6:end,:)'),2),3),'r')
plot(smooth(mean(zscore(ValT(6:6:end,:)'),2),3),'m')
legend({'N1','N2','N3','SWS','REM','Wake'})

figure('color',[1 1 1]), hold on
plot(smooth(median(zscore(ValT(1:6:end,:)'),2),3),'k')
plot(smooth(median(zscore(ValT(2:6:end,:)'),2),3),'b')
plot(smooth(median(zscore(ValT(3:6:end,:)'),2),3),'c')
plot(smooth(median(zscore(ValT(4:6:end,:)'),2),3),'k','linewidth',2)
plot(smooth(median(zscore(ValT(5:6:end,:)'),2),3),'r')
plot(smooth(median(zscore(ValT(6:6:end,:)'),2),3),'m')
legend({'N1','N2','N3','SWS','REM','Wake'})