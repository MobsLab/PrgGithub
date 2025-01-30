%% More sleep analysis



Mouse_names={'M688','M739','M777','M779','M849','M893'};
Mouse=[688 739 777 779 849 893];
for mouse = 1:length(Mouse_names)
    %Sess.(Mouse_names{mouse}) = GetAllMouseTaskSessions(Mouse(mouse));
    SleepSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Sleep')))));
    PreSleepSess.(Mouse_names{mouse})={SleepSess.(Mouse_names{mouse}){1}};
    PreDrugPostSleepSess.(Mouse_names{mouse})={SleepSess.(Mouse_names{mouse}){2}};
    PostDrugPostSleepSess.(Mouse_names{mouse})={SleepSess.(Mouse_names{mouse}){3}};
end


for mouse = 1:length(Mouse_names)
    
    PreSleepEpoch.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(PreSleepSess.(Mouse_names{mouse}){1},'epoch','epochname','sleepstates');
    PreDrugPostSleepEpoch.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(PreDrugPostSleepSess.(Mouse_names{mouse}){1},'epoch','epochname','sleepstates');
    PostDrugPostSleepEpoch.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(PostDrugPostSleepSess.(Mouse_names{mouse}){1},'epoch','epochname','sleepstates');
    
    SleepSessAcc(mouse,1)=nanmean(Data(ConcatenateDataFromFolders_SB(PreSleepSess.(Mouse_names{mouse}),'accelero')))-SleepSessMeanMTemp.(Mouse_names{mouse});
    SleepSessAcc(mouse,2)=nanmean(Data(ConcatenateDataFromFolders_SB(PreDrugPostSleepSess.(Mouse_names{mouse}),'accelero')))-SleepSessMeanMTemp.(Mouse_names{mouse});
    SleepSessAcc(mouse,3)=nanmean(Data(ConcatenateDataFromFolders_SB(PostDrugPostSleepSess.(Mouse_names{mouse}),'accelero')))-SleepSessMeanMTemp.(Mouse_names{mouse});
        
    SleepSessHR(mouse,1)=nanmean(Data(ConcatenateDataFromFolders_SB(PreSleepSess.(Mouse_names{mouse}),'heartrate')))-SleepSessMeanMTemp.(Mouse_names{mouse});
    SleepSessHR(mouse,2)=nanmean(Data(ConcatenateDataFromFolders_SB(PreDrugPostSleepSess.(Mouse_names{mouse}),'heartrate')))-SleepSessMeanMTemp.(Mouse_names{mouse});
    SleepSessHR(mouse,3)=nanmean(Data(ConcatenateDataFromFolders_SB(PostDrugPostSleepSess.(Mouse_names{mouse}),'heartrate')))-SleepSessMeanMTemp.(Mouse_names{mouse});
    
    SleepSessHRVar(mouse,1)=nanmean(Data(ConcatenateDataFromFolders_SB(PreSleepSess.(Mouse_names{mouse}),'heartratevar')))-SleepSessMeanMTemp.(Mouse_names{mouse});
    SleepSessHRVar(mouse,2)=nanmean(Data(ConcatenateDataFromFolders_SB(PreDrugPostSleepSess.(Mouse_names{mouse}),'heartratevar')))-SleepSessMeanMTemp.(Mouse_names{mouse});
    SleepSessHRVar(mouse,3)=nanmean(Data(ConcatenateDataFromFolders_SB(PostDrugPostSleepSess.(Mouse_names{mouse}),'heartratevar')))-SleepSessMeanMTemp.(Mouse_names{mouse});
    
    SleepSessRespi(mouse,1)=nanmean(Data(ConcatenateDataFromFolders_SB(PreSleepSess.(Mouse_names{mouse}),'instfreq','suffix_instfreq','B')))-SleepSessMeanMTemp.(Mouse_names{mouse});
    SleepSessRespi(mouse,2)=nanmean(Data(ConcatenateDataFromFolders_SB(PreDrugPostSleepSess.(Mouse_names{mouse}),'instfreq','suffix_instfreq','B')))-SleepSessMeanMTemp.(Mouse_names{mouse});
    SleepSessRespi(mouse,3)=nanmean(Data(ConcatenateDataFromFolders_SB(PostDrugPostSleepSess.(Mouse_names{mouse}),'instfreq','suffix_instfreq','B')))-SleepSessMeanMTemp.(Mouse_names{mouse});
    
    SleepSessMeanMTemp.(Mouse_names{mouse})=nanmean(Data(ConcatenateDataFromFolders_SB(SleepSess.(Mouse_names{mouse}),'masktemperature')));
    
    SleepSessMTemp(mouse,1)=nanmean(Data(ConcatenateDataFromFolders_SB(PreSleepSess.(Mouse_names{mouse}),'masktemperature')))-SleepSessMeanMTemp.(Mouse_names{mouse});
    SleepSessMTemp(mouse,2)=nanmean(Data(ConcatenateDataFromFolders_SB(PreDrugPostSleepSess.(Mouse_names{mouse}),'masktemperature')))-SleepSessMeanMTemp.(Mouse_names{mouse});
    SleepSessMTemp(mouse,3)=nanmean(Data(ConcatenateDataFromFolders_SB(PostDrugPostSleepSess.(Mouse_names{mouse}),'masktemperature')))-SleepSessMeanMTemp.(Mouse_names{mouse});
    
end


figure
subplot(1,5,1)
[pval,hb,eb]=PlotErrorBoxPlotN_BM(SleepSessAcc,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
makepretty
xticklabels({'PreSleep','PostSleep PreDrug','PostSleep PostDrug'})
ylabel('Movement quantity (AU)')
a=title('Accelerometer');
set(gca,'FontSize',20)
xtickangle(45)

subplot(1,5,2)
[pval,hb,eb]=PlotErrorBoxPlotN_BM(SleepSessHR,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
makepretty
xticklabels({'PreSleep','PostSleep PreDrug','PostSleep PostDrug'}) 
ylabel('Normalized Temperature (°C)')
a=title('HR');
set(gca,'FontSize',20)
xtickangle(45)

subplot(1,5,3)
[pval,hb,eb]=PlotErrorBoxPlotN_BM(SleepSessHRVar,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
makepretty
xticklabels({'PreSleep','PostSleep PreDrug','PostSleep PostDrug'}) 
ylabel('Normalized Temperature (°C)')
a=title('HRVar');
set(gca,'FontSize',20)
xtickangle(45)

subplot(1,5,4)
[pval,hb,eb]=PlotErrorBoxPlotN_BM(SleepSessRespi,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
makepretty
xticklabels({'PreSleep','PostSleep PreDrug','PostSleep PostDrug'}) 
ylabel('Normalized Temperature (°C)')
a=title('Temperature Evolution after aversive conditionning');
set(gca,'FontSize',20)
xtickangle(45)

subplot(1,5,5)
[pval,hb,eb]=PlotErrorBoxPlotN_BM(SleepSessMTemp,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
makepretty
xticklabels({'PreSleep','PostSleep PreDrug','PostSleep PostDrug'}) 
ylabel('Normalized Temperature (°C)')
a=title('Temperature Evolution after aversive conditionning');
set(gca,'FontSize',20)
xtickangle(45)

















