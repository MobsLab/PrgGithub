%% Physiological parameters correlations

Mouse_names={'M666','M667','M668','M669','M739','M777','M849'};
Mouse=[666 667 668 669 739 777 849];
for mouse = 1:length(Mouse_names)
    Sess.(Mouse_names{mouse}) = GetAllMouseTaskSessions(Mouse(mouse));
    SleepSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Sleep')))));
    CondSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Cond')))));
end


%% Fear analysis
%% Freezing
Mouse_names={'M666','M667','M668','M669','M739','M777','M849'};

for mouse= 1:length(Mouse_names)
    
    MTempFear.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'masktemperature');
    TTempFear.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'tailtemperature');
    HRFear.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'heartrate');
    HRVarFear.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'heartratevar');
    RespiFear.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'instfreq','suffix_instfreq','B');
    FreezeEpoch.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'Epoch','epochname','freezeepoch');
    ZoneEpoch.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'Epoch','epochname','zoneepoch');
    TotalEpoch.(Mouse_names{mouse}) = intervalSet(0,max(Range(MTempFear.(Mouse_names{mouse}))));
    Non_FreezingEpoch.(Mouse_names{mouse})=TotalEpoch.(Mouse_names{mouse})-FreezeEpoch.(Mouse_names{mouse});
    SurpriseEpoch.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'Epoch','epochname','afterstimepoch');
    
    % Modifications Restrict to freezing Epoch, withdraw NaNs,
    MTempFz.(Mouse_names{mouse})=Restrict(MTempFear.(Mouse_names{mouse}),FreezeEpoch.(Mouse_names{mouse}));
    DataMTempNewFz.(Mouse_names{mouse})=Data(MTempFz.(Mouse_names{mouse}));
    DataMTempNewFz.(Mouse_names{mouse})=DataMTempNewFz.(Mouse_names{mouse})(~isnan(DataMTempNewFz.(Mouse_names{mouse})))-nanmean(Data(MTempFear.(Mouse_names{mouse})));
    
    TTempFz.(Mouse_names{mouse})=Restrict(TTempFear.(Mouse_names{mouse}),FreezeEpoch.(Mouse_names{mouse}));
    DataTTempNewFz.(Mouse_names{mouse})=Data(TTempFz.(Mouse_names{mouse}));
    DataTTempNewFz.(Mouse_names{mouse})=DataTTempNewFz.(Mouse_names{mouse})(~isnan(DataTTempNewFz.(Mouse_names{mouse})))-nanmean(Data(TTempFear.(Mouse_names{mouse})));
    
    HRFz.(Mouse_names{mouse})=Restrict(HRFear.(Mouse_names{mouse}),FreezeEpoch.(Mouse_names{mouse}));
    HRNewFz.(Mouse_names{mouse}) = Restrict(HRFz.(Mouse_names{mouse}),TTempFz.(Mouse_names{mouse}));
    DataHRNewFz.(Mouse_names{mouse})=Data(HRNewFz.(Mouse_names{mouse}));
    DataHRNewFz.(Mouse_names{mouse})=DataHRNewFz.(Mouse_names{mouse})(~isnan(DataTTempNewFz.(Mouse_names{mouse})));
    
    RespiFz.(Mouse_names{mouse})=Restrict(RespiFear.(Mouse_names{mouse}),FreezeEpoch.(Mouse_names{mouse}));
    RespiNewFz.(Mouse_names{mouse}) = Restrict(RespiFz.(Mouse_names{mouse}),TTempFz.(Mouse_names{mouse}));
    DataRespiNewFz.(Mouse_names{mouse})=Data(RespiNewFz.(Mouse_names{mouse}));
    DataRespiNewFz.(Mouse_names{mouse})=DataRespiNewFz.(Mouse_names{mouse})(~isnan(DataTTempNewFz.(Mouse_names{mouse})));

end
%% Active

% Modifications Restrict to freezing Epoch, withdraw NaNs, 
for mouse= 1:length(Mouse_names)
    
    MTempActive.(Mouse_names{mouse})=Restrict(MTempFear.(Mouse_names{mouse}),Non_FreezingEpoch.(Mouse_names{mouse}));
    DataMTempNewActive.(Mouse_names{mouse})=Data(MTempActive.(Mouse_names{mouse}));
    DataMTempNewActive.(Mouse_names{mouse})=DataMTempNewActive.(Mouse_names{mouse})(~isnan(DataMTempNewActive.(Mouse_names{mouse})))-nanmean(Data(MTempFear.(Mouse_names{mouse})));
    
    TTempActive.(Mouse_names{mouse})=Restrict(TTempFear.(Mouse_names{mouse}),Non_FreezingEpoch.(Mouse_names{mouse}));
    DataTTempNewActive.(Mouse_names{mouse})=Data(TTempActive.(Mouse_names{mouse}));
    DataTTempNewActive.(Mouse_names{mouse})=DataTTempNewActive.(Mouse_names{mouse})(~isnan(DataTTempNewActive.(Mouse_names{mouse})))-nanmean(Data(TTempFear.(Mouse_names{mouse})));
    
    HRActive.(Mouse_names{mouse})=Restrict(HRFear.(Mouse_names{mouse}),Non_FreezingEpoch.(Mouse_names{mouse}));
    HRNewActive.(Mouse_names{mouse}) = Restrict(HRActive.(Mouse_names{mouse}),TTempActive.(Mouse_names{mouse}));
    DataHRNewActive.(Mouse_names{mouse})=Data(HRNewActive.(Mouse_names{mouse}));
    DataHRNewActive.(Mouse_names{mouse})=DataHRNewActive.(Mouse_names{mouse})(~isnan(DataTTempNewActive.(Mouse_names{mouse})));
    
    RespiActive.(Mouse_names{mouse})=Restrict(RespiFear.(Mouse_names{mouse}),Non_FreezingEpoch.(Mouse_names{mouse}));
    RespiNewActive.(Mouse_names{mouse}) = Restrict(RespiActive.(Mouse_names{mouse}),TTempActive.(Mouse_names{mouse}));
    DataRespiNewActive.(Mouse_names{mouse})=Data(RespiNewActive.(Mouse_names{mouse}));
    DataRespiNewActive.(Mouse_names{mouse})=DataRespiNewActive.(Mouse_names{mouse})(~isnan(DataTTempNewActive.(Mouse_names{mouse})));

end

%% Surprise

% Modifications Restrict to freezing Epoch, withdraw NaNs, 
for mouse= 1:length(Mouse_names)
    
    MTempSurprise.(Mouse_names{mouse})=Restrict(MTempFear.(Mouse_names{mouse}),SurpriseEpoch.(Mouse_names{mouse}));
    DataMTempNewSurprise.(Mouse_names{mouse})=Data(MTempSurprise.(Mouse_names{mouse}));
    DataMTempNewSurprise.(Mouse_names{mouse})=DataMTempNewSurprise.(Mouse_names{mouse})(~isnan(DataMTempNewSurprise.(Mouse_names{mouse})))-nanmean(Data(MTempFear.(Mouse_names{mouse})));
    
    TTempSurprise.(Mouse_names{mouse})=Restrict(TTempFear.(Mouse_names{mouse}),SurpriseEpoch.(Mouse_names{mouse}));
    DataTTempNewSurprise.(Mouse_names{mouse})=Data(TTempSurprise.(Mouse_names{mouse}));
    DataTTempNewSurprise.(Mouse_names{mouse})=DataTTempNewSurprise.(Mouse_names{mouse})(~isnan(DataTTempNewSurprise.(Mouse_names{mouse})))-nanmean(Data(TTempFear.(Mouse_names{mouse})));
    
    HRSurprise.(Mouse_names{mouse})=Restrict(HRFear.(Mouse_names{mouse}),SurpriseEpoch.(Mouse_names{mouse}));
    HRNewSurprise.(Mouse_names{mouse}) = Restrict(HRSurprise.(Mouse_names{mouse}),MTempSurprise.(Mouse_names{mouse}));
    DataHRNewSurprise.(Mouse_names{mouse})=Data(HRNewSurprise.(Mouse_names{mouse}));
    DataHRNewSurprise.(Mouse_names{mouse})=DataHRNewSurprise.(Mouse_names{mouse})(~isnan(DataTTempNewSurprise.(Mouse_names{mouse})));
    
    RespiSurprise.(Mouse_names{mouse})=Restrict(RespiFear.(Mouse_names{mouse}),SurpriseEpoch.(Mouse_names{mouse}));
    RespiNewSurprise.(Mouse_names{mouse}) = Restrict(RespiSurprise.(Mouse_names{mouse}),MTempSurprise.(Mouse_names{mouse}));
    DataRespiNewSurprise.(Mouse_names{mouse})=Data(RespiNewSurprise.(Mouse_names{mouse}));
    DataRespiNewSurprise.(Mouse_names{mouse})=DataRespiNewSurprise.(Mouse_names{mouse})(~isnan(DataTTempNewSurprise.(Mouse_names{mouse})));

end


%% Fear plot
% Active / Freezing
for mouse= 1:length(Mouse_names)
    
    MeanHRActive.(Mouse_names{mouse})=mean(DataHRNewActive.(Mouse_names{mouse}));
    MeanHRSurprise.(Mouse_names{mouse})=mean(DataHRNewSurprise.(Mouse_names{mouse}));
    MeanHRFz.(Mouse_names{mouse})=mean(DataHRNewFz.(Mouse_names{mouse}));
    MeanMTempActive.(Mouse_names{mouse})=mean(DataMTempNewActive.(Mouse_names{mouse}));
    MeanMTempSurprise.(Mouse_names{mouse})=mean(DataMTempNewSurprise.(Mouse_names{mouse}));
    MeanMTempFz.(Mouse_names{mouse})=mean(DataMTempNewFz.(Mouse_names{mouse}));
    MeanTTempActive.(Mouse_names{mouse})=mean(DataTTempNewActive.(Mouse_names{mouse}));
    MeanTTempSurprise.(Mouse_names{mouse})=mean(DataTTempNewSurprise.(Mouse_names{mouse}));
    MeanTTempFz.(Mouse_names{mouse})=mean(DataTTempNewFz.(Mouse_names{mouse}));
    MeanRespiActive.(Mouse_names{mouse})=mean(DataRespiNewActive.(Mouse_names{mouse}));
    MeanRespiSurprise.(Mouse_names{mouse})=mean(DataRespiNewSurprise.(Mouse_names{mouse}));
    MeanRespiFz.(Mouse_names{mouse})=mean(DataRespiNewFz.(Mouse_names{mouse}));
    
    StdMTempActive.(Mouse_names{mouse})=std(DataMTempNewActive.(Mouse_names{mouse}));
    StdMTempSurprise.(Mouse_names{mouse})=std(DataMTempNewSurprise.(Mouse_names{mouse}));
    StdMTempFz.(Mouse_names{mouse})=std(DataMTempNewFz.(Mouse_names{mouse}));
    StdTTempActive.(Mouse_names{mouse})=std(DataTTempNewActive.(Mouse_names{mouse}));
    StdTTempSurprise.(Mouse_names{mouse})=std(DataTTempNewSurprise.(Mouse_names{mouse}));
    StdTTempFz.(Mouse_names{mouse})=std(DataTTempNewFz.(Mouse_names{mouse}));
    StdHRActive.(Mouse_names{mouse})=std(DataHRNewActive.(Mouse_names{mouse}));
    StdHRSurprise.(Mouse_names{mouse})=std(DataHRNewSurprise.(Mouse_names{mouse}));
    StdHRFz.(Mouse_names{mouse})=std(DataHRNewFz.(Mouse_names{mouse}));
    StdRespiActive.(Mouse_names{mouse})=std(DataRespiNewActive.(Mouse_names{mouse}));
    StdRespiSurprise.(Mouse_names{mouse})=std(DataRespiNewSurprise.(Mouse_names{mouse}));
    StdRespiFz.(Mouse_names{mouse})=std(DataRespiNewFz.(Mouse_names{mouse}));
    
end

figure

subplot(4,3,1)
mouse=3;
HRAxes=dscatter(DataHRNewActive.(Mouse_names{mouse}),DataTTempNewActive.(Mouse_names{mouse}),'smoothing',7);
colormap hot
freezeColors
ylabel('Temperature (°C)')
makepretty
b=text(-0.4,-2.5,'Active','FontSize',30)
set(b,'Rotation',90);
title('T° = f(HR)')
xlim([5 16]); ylim([-10 15])
subplot(4,3,4)
HRAxes=dscatter(DataHRNewFz.(Mouse_names{mouse}),DataTTempNewFz.(Mouse_names{mouse}),'smoothing',7);
colormap cool
freezeColors
ylabel('Temperature (°C)')
xlim([5 16]); ylim([-10 15])
makepretty
b=text(-0.4,-3, 'Freezing','FontSize',30)
set(b,'Rotation',90);
subplot(4,3,7)
HRAxes=dscatter(DataHRNewSurprise.(Mouse_names{mouse}),DataTTempNewSurprise.(Mouse_names{mouse}),'smoothing',7);
colormap copper
freezeColors
ylabel('Temperature (°C)')
makepretty
b=text(-0.4,-2.5,'Surprise','FontSize',30)
set(b,'Rotation',90);
xlim([5 16]); ylim([-10 15])
subplot(4,3,10)
for mouse=1:length(Mouse_names)
plot(MeanHRActive.(Mouse_names{mouse}),MeanTTempActive.(Mouse_names{mouse}),'.r','MarkerSize',60)
line([MeanHRActive.(Mouse_names{mouse})-StdHRActive.(Mouse_names{mouse}) MeanHRActive.(Mouse_names{mouse})+StdHRActive.(Mouse_names{mouse})], [MeanTTempActive.(Mouse_names{mouse}) MeanTTempActive.(Mouse_names{mouse})],'color','r','LineWidth',2);
line([MeanHRActive.(Mouse_names{mouse}) MeanHRActive.(Mouse_names{mouse})], [MeanTTempActive.(Mouse_names{mouse})-StdTTempActive.(Mouse_names{mouse}) MeanTTempActive.(Mouse_names{mouse})+StdTTempActive.(Mouse_names{mouse})],'color','r','LineWidth',2);
hold on
plot(MeanHRFz.(Mouse_names{mouse}),MeanTTempFz.(Mouse_names{mouse}),'.c','MarkerSize',60)
line([MeanHRFz.(Mouse_names{mouse})-StdHRFz.(Mouse_names{mouse}) MeanHRFz.(Mouse_names{mouse})+StdHRFz.(Mouse_names{mouse})], [MeanTTempFz.(Mouse_names{mouse}) MeanTTempFz.(Mouse_names{mouse})],'color','c','LineWidth',2);
line([MeanHRFz.(Mouse_names{mouse}) MeanHRFz.(Mouse_names{mouse})], [MeanTTempFz.(Mouse_names{mouse})-StdTTempFz.(Mouse_names{mouse}) MeanTTempFz.(Mouse_names{mouse})+StdTTempFz.(Mouse_names{mouse})],'color','c','LineWidth',2);
plot(MeanHRSurprise.(Mouse_names{mouse}),MeanTTempSurprise.(Mouse_names{mouse}),'.','Color',[0.2 0 0],'MarkerSize',60)
line([MeanHRSurprise.(Mouse_names{mouse})-StdHRSurprise.(Mouse_names{mouse}) MeanHRSurprise.(Mouse_names{mouse})+StdHRSurprise.(Mouse_names{mouse})], [MeanTTempSurprise.(Mouse_names{mouse}) MeanTTempSurprise.(Mouse_names{mouse})],'color',[0.2 0 0],'LineWidth',2);
line([MeanHRSurprise.(Mouse_names{mouse}) MeanHRSurprise.(Mouse_names{mouse})], [MeanTTempSurprise.(Mouse_names{mouse})-StdTTempSurprise.(Mouse_names{mouse}) MeanTTempSurprise.(Mouse_names{mouse})+StdTTempSurprise.(Mouse_names{mouse})],'color',[0.2 0 0],'LineWidth',2);
end
xlabel('Heart rate (Hz)');
ylabel('Temperature (°C)')
makepretty
b=text(-1,-0.8, 'Mean values','FontSize',30)
set(b,'Rotation',90);
f=get(gca,'Children');
legend([f(8),f(5),f(2)],'Active','Freezing','Surprise')

subplot(4,3,2)
HRAxes=dscatter(DataRespiNewActive.(Mouse_names{mouse}),DataTTempNewActive.(Mouse_names{mouse}),'smoothing',7);
colormap hot
freezeColors
ylabel('Temperature (°C)')
title('Temperature=f(Respiratory Rate)')
makepretty
ylim([-10 15]); xlim([0 16])
title('Total Body Temperature = f(Respiratory Rate)')
subplot(4,3,5)
HRAxes=dscatter(DataRespiNewFz.(Mouse_names{mouse}),DataTTempNewFz.(Mouse_names{mouse}),'smoothing',7);
colormap cool
freezeColors
ylabel('Temperature (°C)')
ylim([-10 15]); xlim([0 16])
makepretty
subplot(4,3,8)
HRAxes=dscatter(DataRespiNewSurprise.(Mouse_names{mouse}),DataTTempNewSurprise.(Mouse_names{mouse}),'smoothing',7);
colormap copper
freezeColors
ylabel('Temperature (°C)')
ylim([-10 15]); xlim([0 16])
makepretty
subplot(4,3,11)
for mouse=1:length(Mouse_names)
    plot(MeanRespiActive.(Mouse_names{mouse}),MeanTTempActive.(Mouse_names{mouse}),'.r','MarkerSize',60)
    line([MeanRespiActive.(Mouse_names{mouse})-StdRespiActive.(Mouse_names{mouse}) MeanRespiActive.(Mouse_names{mouse})+StdRespiActive.(Mouse_names{mouse})], [MeanTTempActive.(Mouse_names{mouse}) MeanTTempActive.(Mouse_names{mouse})],'color','r','LineWidth',2);
    line([MeanRespiActive.(Mouse_names{mouse}) MeanRespiActive.(Mouse_names{mouse})], [MeanTTempActive.(Mouse_names{mouse})-StdTTempActive.(Mouse_names{mouse}) MeanTTempActive.(Mouse_names{mouse})+StdTTempActive.(Mouse_names{mouse})],'color','r','LineWidth',2);
    hold on
    plot(MeanRespiFz.(Mouse_names{mouse}),MeanTTempFz.(Mouse_names{mouse}),'.c','MarkerSize',60)
    line([MeanRespiFz.(Mouse_names{mouse})-StdRespiFz.(Mouse_names{mouse}) MeanRespiFz.(Mouse_names{mouse})+StdRespiFz.(Mouse_names{mouse})], [MeanTTempFz.(Mouse_names{mouse}) MeanTTempFz.(Mouse_names{mouse})],'color','c','LineWidth',2);
    line([MeanRespiFz.(Mouse_names{mouse}) MeanRespiFz.(Mouse_names{mouse})], [MeanTTempFz.(Mouse_names{mouse})-StdTTempFz.(Mouse_names{mouse}) MeanTTempFz.(Mouse_names{mouse})+StdTTempFz.(Mouse_names{mouse})],'color','c','LineWidth',2);
    plot(MeanRespiSurprise.(Mouse_names{mouse}),MeanTTempSurprise.(Mouse_names{mouse}),'.','Color',[0.2 0 0],'MarkerSize',60)
    line([MeanRespiSurprise.(Mouse_names{mouse})-StdRespiSurprise.(Mouse_names{mouse}) MeanRespiSurprise.(Mouse_names{mouse})+StdRespiSurprise.(Mouse_names{mouse})], [MeanTTempSurprise.(Mouse_names{mouse}) MeanTTempSurprise.(Mouse_names{mouse})],'color',[0.2 0 0],'LineWidth',2);
    line([MeanRespiSurprise.(Mouse_names{mouse}) MeanRespiSurprise.(Mouse_names{mouse})], [MeanTTempSurprise.(Mouse_names{mouse})-StdTTempSurprise.(Mouse_names{mouse}) MeanTTempSurprise.(Mouse_names{mouse})+StdTTempSurprise.(Mouse_names{mouse})],'color',[0.2 0 0],'LineWidth',2);
end
xlabel('Respiratory rate (Hz)');
ylabel('Temperature (°C)')
makepretty

subplot(4,3,3)
HRAxes=dscatter(DataRespiNewActive.(Mouse_names{mouse}),DataHRNewActive.(Mouse_names{mouse}),'smoothing',7);
colormap hot
freezeColors
ylabel('Heart Rate (Hz)')
title('Heart Rate=f(Respiratory Rate)')
makepretty
xlim([0 14]);  ylim([5 16])
subplot(4,3,6)
HRAxes=dscatter(DataRespiNewFz.(Mouse_names{mouse}),DataHRNewFz.(Mouse_names{mouse}),'smoothing',7);
colormap cool
freezeColors
ylabel('Heart Rate (Hz)')
xlim([0 14]);  ylim([5 16])
makepretty
subplot(4,3,9)
HRAxes=dscatter(DataRespiNewSurprise.(Mouse_names{mouse}),DataHRNewSurprise.(Mouse_names{mouse}),'smoothing',7);
colormap copper
freezeColors
ylabel('Heart Rate (Hz)')
xlim([0 14]);  ylim([5 16])
makepretty
subplot(4,3,12)
for mouse=1:length(Mouse_names)
    plot(MeanRespiActive.(Mouse_names{mouse}),MeanHRActive.(Mouse_names{mouse}),'.r','MarkerSize',60)
    line([MeanRespiActive.(Mouse_names{mouse})-StdRespiActive.(Mouse_names{mouse}) MeanRespiActive.(Mouse_names{mouse})+StdRespiActive.(Mouse_names{mouse})], [MeanHRActive.(Mouse_names{mouse}) MeanHRActive.(Mouse_names{mouse})],'color','r','LineWidth',2);
    line([MeanRespiActive.(Mouse_names{mouse}) MeanRespiActive.(Mouse_names{mouse})], [MeanHRActive.(Mouse_names{mouse})-StdHRActive.(Mouse_names{mouse}) MeanHRActive.(Mouse_names{mouse})+StdHRActive.(Mouse_names{mouse})],'color','r','LineWidth',2);
    hold on
    plot(MeanRespiFz.(Mouse_names{mouse}),MeanHRFz.(Mouse_names{mouse}),'.c','MarkerSize',60)
    line([MeanRespiFz.(Mouse_names{mouse})-StdRespiFz.(Mouse_names{mouse}) MeanRespiFz.(Mouse_names{mouse})+StdRespiFz.(Mouse_names{mouse})], [MeanHRFz.(Mouse_names{mouse}) MeanHRFz.(Mouse_names{mouse})],'color','c','LineWidth',2);
    line([MeanRespiFz.(Mouse_names{mouse}) MeanRespiFz.(Mouse_names{mouse})], [MeanHRFz.(Mouse_names{mouse})-StdHRFz.(Mouse_names{mouse}) MeanHRFz.(Mouse_names{mouse})+StdHRFz.(Mouse_names{mouse})],'color','c','LineWidth',2);
    plot(MeanRespiSurprise.(Mouse_names{mouse}),MeanHRSurprise.(Mouse_names{mouse}),'.','Color',[0.2 0 0],'MarkerSize',60)
    line([MeanRespiSurprise.(Mouse_names{mouse})-StdRespiSurprise.(Mouse_names{mouse}) MeanRespiSurprise.(Mouse_names{mouse})+StdRespiSurprise.(Mouse_names{mouse})], [MeanHRSurprise.(Mouse_names{mouse}) MeanHRSurprise.(Mouse_names{mouse})],'color',[0.2 0 0],'LineWidth',2);
    line([MeanRespiSurprise.(Mouse_names{mouse}) MeanRespiSurprise.(Mouse_names{mouse})], [MeanHRSurprise.(Mouse_names{mouse})-StdHRSurprise.(Mouse_names{mouse}) MeanHRSurprise.(Mouse_names{mouse})+StdHRSurprise.(Mouse_names{mouse})],'color',[0.2 0 0],'LineWidth',2);
end
xlabel('Respiratory rate (Hz)');
ylabel('Heart Rate (Hz)')
makepretty

a=suptitle('Physiological parameters for fear sessions, Mouse 739'); a.FontSize=30;

saveFigure(2,'Physiological_Params_Fear_Version2','/home/mobsmorty/Desktop/Baptiste/FiguresForSophie/')


%% Sleep analysis
for mouse= 1:length(Mouse_names)
    
    MTempSleep.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(SleepSess.(Mouse_names{mouse}),'masktemperature');
    HRSleep.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(SleepSess.(Mouse_names{mouse}),'heartrate');
    HRVarSleep.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(SleepSess.(Mouse_names{mouse}),'heartratevar');
    RespiSleep.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(SleepSess.(Mouse_names{mouse}),'instfreq','suffix_instfreq','B');
    SleepEpoch.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(SleepSess.(Mouse_names{mouse}),'epoch','epochname','sleepstates');
    SleepEpoch.(Mouse_names{mouse}){1} = dropShortIntervals(SleepEpoch.(Mouse_names{mouse}){1}, 20e4);
    SleepEpoch.(Mouse_names{mouse}){3} = dropShortIntervals(SleepEpoch.(Mouse_names{mouse}){3}, 7e4);
    
    %% Wake
    % Modifications Restrict to freezing Epoch, withdraw NaNs,
    MTempWake.(Mouse_names{mouse})=Restrict(MTempSleep.(Mouse_names{mouse}),SleepEpoch.(Mouse_names{mouse}){1});
    DataMTempNewWake.(Mouse_names{mouse})=Data(MTempWake.(Mouse_names{mouse}));
    DataMTempNewWake.(Mouse_names{mouse})=DataMTempNewWake.(Mouse_names{mouse})(~isnan(DataMTempNewWake.(Mouse_names{mouse})))-nanmean(Data(MTempSleep.(Mouse_names{mouse})));
    
    HRWake.(Mouse_names{mouse})=Restrict(HRSleep.(Mouse_names{mouse}),SleepEpoch.(Mouse_names{mouse}){1});
    HRNewWake.(Mouse_names{mouse}) = Restrict(HRWake.(Mouse_names{mouse}),MTempWake.(Mouse_names{mouse}));
    DataHRNewWake.(Mouse_names{mouse})=Data(HRNewWake.(Mouse_names{mouse}));
    DataHRNewWake.(Mouse_names{mouse})=DataHRNewWake.(Mouse_names{mouse})(~isnan(DataMTempNewWake.(Mouse_names{mouse})));
    
    RespiWake.(Mouse_names{mouse})=Restrict(RespiSleep.(Mouse_names{mouse}),SleepEpoch.(Mouse_names{mouse}){1});
    RespiNewWake.(Mouse_names{mouse}) = Restrict(RespiWake.(Mouse_names{mouse}),MTempWake.(Mouse_names{mouse}));
    DataRespiNewWake.(Mouse_names{mouse})=Data(RespiNewWake.(Mouse_names{mouse}));
    DataRespiNewWake.(Mouse_names{mouse})=DataRespiNewWake.(Mouse_names{mouse})(~isnan(DataMTempNewWake.(Mouse_names{mouse})));
    
    
    %% NREM
    % Modifications Restrict to freezing Epoch, withdraw NaNs,
    MTempNREM.(Mouse_names{mouse})=Restrict(MTempSleep.(Mouse_names{mouse}),SleepEpoch.(Mouse_names{mouse}){2});
    DataMTempNewNREM.(Mouse_names{mouse})=Data(MTempNREM.(Mouse_names{mouse}));
    DataMTempNewNREM.(Mouse_names{mouse})=DataMTempNewNREM.(Mouse_names{mouse})(~isnan(DataMTempNewNREM.(Mouse_names{mouse})))-nanmean(Data(MTempSleep.(Mouse_names{mouse})));
    
    HRNREM.(Mouse_names{mouse})=Restrict(HRSleep.(Mouse_names{mouse}),SleepEpoch.(Mouse_names{mouse}){2});
    HRNewNREM.(Mouse_names{mouse}) = Restrict(HRNREM.(Mouse_names{mouse}),MTempNREM.(Mouse_names{mouse}));
    DataHRNewNREM.(Mouse_names{mouse})=Data(HRNewNREM.(Mouse_names{mouse}));
    DataHRNewNREM.(Mouse_names{mouse})=DataHRNewNREM.(Mouse_names{mouse})(~isnan(DataMTempNewNREM.(Mouse_names{mouse})));
    
    RespiNREM.(Mouse_names{mouse})=Restrict(RespiSleep.(Mouse_names{mouse}),SleepEpoch.(Mouse_names{mouse}){2});
    RespiNewNREM.(Mouse_names{mouse}) = Restrict(RespiNREM.(Mouse_names{mouse}),MTempNREM.(Mouse_names{mouse}));
    DataRespiNewNREM.(Mouse_names{mouse})=Data(RespiNewNREM.(Mouse_names{mouse}));
    DataRespiNewNREM.(Mouse_names{mouse})=DataRespiNewNREM.(Mouse_names{mouse})(~isnan(DataMTempNewNREM.(Mouse_names{mouse})));
    
    
    %% REM
    % Modifications Restrict to freezing Epoch, withdraw NaNs,
    MTempREM.(Mouse_names{mouse})=Restrict(MTempSleep.(Mouse_names{mouse}),SleepEpoch.(Mouse_names{mouse}){3});
    DataMTempNewREM.(Mouse_names{mouse})=Data(MTempREM.(Mouse_names{mouse}));
    DataMTempNewREM.(Mouse_names{mouse})=DataMTempNewREM.(Mouse_names{mouse})(~isnan(DataMTempNewREM.(Mouse_names{mouse})))-nanmean(Data(MTempSleep.(Mouse_names{mouse})));
    
    HRREM.(Mouse_names{mouse})=Restrict(HRSleep.(Mouse_names{mouse}),SleepEpoch.(Mouse_names{mouse}){3});
    HRNewREM.(Mouse_names{mouse}) = Restrict(HRREM.(Mouse_names{mouse}),MTempREM.(Mouse_names{mouse}));
    DataHRNewREM.(Mouse_names{mouse})=Data(HRNewREM.(Mouse_names{mouse}));
    DataHRNewREM.(Mouse_names{mouse})=DataHRNewREM.(Mouse_names{mouse})(~isnan(DataMTempNewREM.(Mouse_names{mouse})));
    
    RespiREM.(Mouse_names{mouse})=Restrict(RespiSleep.(Mouse_names{mouse}),SleepEpoch.(Mouse_names{mouse}){3});
    RespiNewREM.(Mouse_names{mouse}) = Restrict(RespiREM.(Mouse_names{mouse}),MTempREM.(Mouse_names{mouse}));
    DataRespiNewREM.(Mouse_names{mouse})=Data(RespiNewREM.(Mouse_names{mouse}));
    DataRespiNewREM.(Mouse_names{mouse})=DataRespiNewREM.(Mouse_names{mouse})(~isnan(DataMTempNewREM.(Mouse_names{mouse})));
    
end

%% Sleep plot
for mouse=1:length(Mouse_names)
    MeanHRWake.(Mouse_names{mouse})=mean(DataHRNewWake.(Mouse_names{mouse}));
    MeanHRNREM.(Mouse_names{mouse})=mean(DataHRNewNREM.(Mouse_names{mouse}));
    MeanHRREM.(Mouse_names{mouse})=mean(DataHRNewREM.(Mouse_names{mouse}));
    MeanMTempWake.(Mouse_names{mouse})=mean(DataMTempNewWake.(Mouse_names{mouse}));
    MeanMTempNREM.(Mouse_names{mouse})=mean(DataMTempNewNREM.(Mouse_names{mouse}));
    MeanMTempREM.(Mouse_names{mouse})=mean(DataMTempNewREM.(Mouse_names{mouse}));
    MeanRespiWake.(Mouse_names{mouse})=mean(DataRespiNewWake.(Mouse_names{mouse}));
    MeanRespiNREM.(Mouse_names{mouse})=mean(DataRespiNewNREM.(Mouse_names{mouse}));
    MeanRespiREM.(Mouse_names{mouse})=mean(DataRespiNewREM.(Mouse_names{mouse}));
    StdMTempWake.(Mouse_names{mouse})=std(DataMTempNewWake.(Mouse_names{mouse}));
    StdMTempNREM.(Mouse_names{mouse})=std(DataMTempNewNREM.(Mouse_names{mouse}));
    StdMTempREM.(Mouse_names{mouse})=std(DataMTempNewREM.(Mouse_names{mouse}));
    StdHRWake.(Mouse_names{mouse})=std(DataHRNewWake.(Mouse_names{mouse}));
    StdHRNREM.(Mouse_names{mouse})=std(DataHRNewNREM.(Mouse_names{mouse}));
    StdHRREM.(Mouse_names{mouse})=std(DataHRNewREM.(Mouse_names{mouse}));
    StdRespiWake.(Mouse_names{mouse})=std(DataRespiNewWake.(Mouse_names{mouse}));
    StdRespiNREM.(Mouse_names{mouse})=std(DataRespiNewNREM.(Mouse_names{mouse}));
    StdRespiREM.(Mouse_names{mouse})=std(DataRespiNewREM.(Mouse_names{mouse}));
end

figure
a=suptitle('Physiological parameters for sleep sessions, Mouse 739'); a.FontSize=30
mouse=3;
subplot(4,3,1)
HRAxes=dscatter(DataHRNewWake.(Mouse_names{mouse}),DataMTempNewWake.(Mouse_names{mouse}),'smoothing',7);
colormap parula
freezeColors
ylabel('Temperature (°C)')
title('Total Body Temperature=f(Heart Rate)')
makepretty
b=text(2,31,'Wake','FontSize',30)
set(b,'Rotation',90);
ylim([-2 2]); xlim([4 14]); 

subplot(4,3,4)
HRAxes=dscatter(DataHRNewNREM.(Mouse_names{mouse}),DataMTempNewNREM.(Mouse_names{mouse}),'smoothing',7);
colormap autumn
freezeColors
ylabel('Temperature (°C)')
title('Total Body Temperature=f(Respiratory Rate)')
ylim([-2 2]); xlim([4 14]); 
makepretty
b=text(2,31,'NREM','FontSize',30)
set(b,'Rotation',90);

subplot(4,3,7)
HRAxes=dscatter(DataHRNewREM.(Mouse_names{mouse}),DataMTempNewREM.(Mouse_names{mouse}),'smoothing',7);
colormap summer
freezeColors
ylabel('Temperature (°C)')
ylim([-2 2]); xlim([4 14]); 
makepretty
b=text(2,31, 'REM','FontSize',30)
set(b,'Rotation',90);

subplot(4,3,10)
for mouse=1:length(Mouse_names)
    plot(MeanHRWake.(Mouse_names{mouse}),MeanMTempWake.(Mouse_names{mouse}),'.b','MarkerSize',60)
    line([MeanHRWake.(Mouse_names{mouse})-StdHRWake.(Mouse_names{mouse}) MeanHRWake.(Mouse_names{mouse})+StdHRWake.(Mouse_names{mouse})], [MeanMTempWake.(Mouse_names{mouse}) MeanMTempWake.(Mouse_names{mouse})],'color','b','LineWidth',2);
    line([MeanHRWake.(Mouse_names{mouse}) MeanHRWake.(Mouse_names{mouse})], [MeanMTempWake.(Mouse_names{mouse})-StdMTempWake.(Mouse_names{mouse}) MeanMTempWake.(Mouse_names{mouse})+StdMTempWake.(Mouse_names{mouse})],'color','b','LineWidth',2);
    hold on
    plot(MeanHRNREM.(Mouse_names{mouse}),MeanMTempNREM.(Mouse_names{mouse}),'.r','MarkerSize',60)
    line([MeanHRNREM.(Mouse_names{mouse})-StdHRNREM.(Mouse_names{mouse}) MeanHRNREM.(Mouse_names{mouse})+StdHRNREM.(Mouse_names{mouse})], [MeanMTempNREM.(Mouse_names{mouse}) MeanMTempNREM.(Mouse_names{mouse})],'color','r','LineWidth',2);
    line([MeanHRNREM.(Mouse_names{mouse}) MeanHRNREM.(Mouse_names{mouse})], [MeanMTempNREM.(Mouse_names{mouse})-StdMTempNREM.(Mouse_names{mouse}) MeanMTempNREM.(Mouse_names{mouse})+StdMTempNREM.(Mouse_names{mouse})],'color','r','LineWidth',2);
    plot(MeanHRREM.(Mouse_names{mouse}),MeanMTempREM.(Mouse_names{mouse}),'.g','MarkerSize',60)
    line([MeanHRREM.(Mouse_names{mouse})-StdHRREM.(Mouse_names{mouse}) MeanHRREM.(Mouse_names{mouse})+StdHRREM.(Mouse_names{mouse})], [MeanMTempREM.(Mouse_names{mouse}) MeanMTempREM.(Mouse_names{mouse})],'color','g','LineWidth',2);
    line([MeanHRREM.(Mouse_names{mouse}) MeanHRREM.(Mouse_names{mouse})], [MeanMTempREM.(Mouse_names{mouse})-StdMTempREM.(Mouse_names{mouse}) MeanMTempREM.(Mouse_names{mouse})+StdMTempREM.(Mouse_names{mouse})],'color','g','LineWidth',2);
end
ylim([-2 2]); xlim([4 14]); 
xlabel('Heart rate (Hz)');
ylabel('Temperature (°C)')
makepretty
b=text(2,30,'Mean values','FontSize',30)
set(b,'Rotation',90);
f=get(gca,'Children');
legend([f(8),f(5),f(2)],'Wake','NREM','REM')

subplot(4,3,2)
HRAxes=dscatter(DataRespiNewWake.(Mouse_names{mouse}),DataMTempNewWake.(Mouse_names{mouse}),'smoothing',7);
colormap parula
freezeColors
ylabel('Temperature (°C)')
ylim([-2 2]); xlim([0 16]); 
makepretty

subplot(4,3,5)
HRAxes=dscatter(DataRespiNewNREM.(Mouse_names{mouse}),DataMTempNewNREM.(Mouse_names{mouse}),'smoothing',7);
colormap autumn
freezeColors
ylabel('Temperature (°C)')
ylim([-2 2]); xlim([0 16]); 
makepretty

subplot(4,3,8)
HRAxes=dscatter(DataRespiNewREM.(Mouse_names{mouse}),DataMTempNewREM.(Mouse_names{mouse}),'smoothing',7);
colormap summer
freezeColors
ylabel('Temperature (°C)')
ylim([-2 2]); xlim([0 16]); 
makepretty

subplot(4,3,11)
for mouse=1:length(Mouse_names)
    plot(MeanRespiWake.(Mouse_names{mouse}),MeanMTempWake.(Mouse_names{mouse}),'.b','MarkerSize',60)
    line([MeanRespiWake.(Mouse_names{mouse})-StdRespiWake.(Mouse_names{mouse}) MeanRespiWake.(Mouse_names{mouse})+StdRespiWake.(Mouse_names{mouse})], [MeanMTempWake.(Mouse_names{mouse}) MeanMTempWake.(Mouse_names{mouse})],'color','b','LineWidth',2);
    line([MeanRespiWake.(Mouse_names{mouse}) MeanRespiWake.(Mouse_names{mouse})], [MeanMTempWake.(Mouse_names{mouse})-StdMTempWake.(Mouse_names{mouse}) MeanMTempWake.(Mouse_names{mouse})+StdMTempWake.(Mouse_names{mouse})],'color','b','LineWidth',2);
    hold on
    plot(MeanRespiNREM.(Mouse_names{mouse}),MeanMTempNREM.(Mouse_names{mouse}),'.r','MarkerSize',60)
    line([MeanRespiNREM.(Mouse_names{mouse})-StdRespiNREM.(Mouse_names{mouse}) MeanRespiNREM.(Mouse_names{mouse})+StdRespiNREM.(Mouse_names{mouse})], [MeanMTempNREM.(Mouse_names{mouse}) MeanMTempNREM.(Mouse_names{mouse})],'color','r','LineWidth',2);
    line([MeanRespiNREM.(Mouse_names{mouse}) MeanRespiNREM.(Mouse_names{mouse})], [MeanMTempNREM.(Mouse_names{mouse})-StdMTempNREM.(Mouse_names{mouse}) MeanMTempNREM.(Mouse_names{mouse})+StdMTempNREM.(Mouse_names{mouse})],'color','r','LineWidth',2);
    plot(MeanRespiREM.(Mouse_names{mouse}),MeanMTempREM.(Mouse_names{mouse}),'.g','MarkerSize',60)
    line([MeanRespiREM.(Mouse_names{mouse})-StdRespiREM.(Mouse_names{mouse}) MeanRespiREM.(Mouse_names{mouse})+StdRespiREM.(Mouse_names{mouse})], [MeanMTempREM.(Mouse_names{mouse}) MeanMTempREM.(Mouse_names{mouse})],'color','g','LineWidth',2);
    line([MeanRespiREM.(Mouse_names{mouse}) MeanRespiREM.(Mouse_names{mouse})], [MeanMTempREM.(Mouse_names{mouse})-StdMTempREM.(Mouse_names{mouse}) MeanMTempREM.(Mouse_names{mouse})+StdMTempREM.(Mouse_names{mouse})],'color','g','LineWidth',2);
end
ylim([-2 2]); xlim([0 16]); 
xlabel('Respiratory rate (Hz)');
ylabel('Temperature (°C)')
makepretty

subplot(4,3,3)
HRAxes=dscatter(DataRespiNewWake.(Mouse_names{mouse}),DataHRNewWake.(Mouse_names{mouse}),'smoothing',7);
colormap parula
freezeColors
ylabel('Heart Rate (Hz)')
makepretty
ylim([4 14]); xlim([0 16]); 
subplot(4,3,6)
HRAxes=dscatter(DataRespiNewNREM.(Mouse_names{mouse}),DataHRNewNREM.(Mouse_names{mouse}),'smoothing',7);
colormap autumn
freezeColors
ylabel('Heart Rate (Hz)')
ylim([4 14]); xlim([0 16]); 
makepretty
subplot(4,3,9)
HRAxes=dscatter(DataRespiNewREM.(Mouse_names{mouse}),DataHRNewREM.(Mouse_names{mouse}),'smoothing',7);
colormap summer
freezeColors
ylabel('Heart Rate (Hz)')
ylim([4 14]); xlim([0 16]); 
makepretty
subplot(4,3,12)
for mouse=1:length(Mouse_names)
    plot(MeanRespiWake.(Mouse_names{mouse}),MeanHRWake.(Mouse_names{mouse}),'.b','MarkerSize',60)
    line([MeanRespiWake.(Mouse_names{mouse})-StdRespiWake.(Mouse_names{mouse}) MeanRespiWake.(Mouse_names{mouse})+StdRespiWake.(Mouse_names{mouse})], [MeanHRWake.(Mouse_names{mouse}) MeanHRWake.(Mouse_names{mouse})],'color','b','LineWidth',2);
    line([MeanRespiWake.(Mouse_names{mouse}) MeanRespiWake.(Mouse_names{mouse})], [MeanHRWake.(Mouse_names{mouse})-StdHRWake.(Mouse_names{mouse}) MeanHRWake.(Mouse_names{mouse})+StdHRWake.(Mouse_names{mouse})],'color','b','LineWidth',2);
    hold on
    plot(MeanRespiNREM.(Mouse_names{mouse}),MeanHRNREM.(Mouse_names{mouse}),'.r','MarkerSize',60)
    line([MeanRespiNREM.(Mouse_names{mouse})-StdRespiNREM.(Mouse_names{mouse}) MeanRespiNREM.(Mouse_names{mouse})+StdRespiNREM.(Mouse_names{mouse})], [MeanHRNREM.(Mouse_names{mouse}) MeanHRNREM.(Mouse_names{mouse})],'color','r','LineWidth',2);
    line([MeanRespiNREM.(Mouse_names{mouse}) MeanRespiNREM.(Mouse_names{mouse})], [MeanHRNREM.(Mouse_names{mouse})-StdHRNREM.(Mouse_names{mouse}) MeanHRNREM.(Mouse_names{mouse})+StdHRNREM.(Mouse_names{mouse})],'color','r','LineWidth',2);
    plot(MeanRespiREM.(Mouse_names{mouse}),MeanHRREM.(Mouse_names{mouse}),'.g','MarkerSize',60)
    line([MeanRespiREM.(Mouse_names{mouse})-StdRespiREM.(Mouse_names{mouse}) MeanRespiREM.(Mouse_names{mouse})+StdRespiREM.(Mouse_names{mouse})], [MeanHRREM.(Mouse_names{mouse}) MeanHRREM.(Mouse_names{mouse})],'color','g','LineWidth',2);
    line([MeanRespiREM.(Mouse_names{mouse}) MeanRespiREM.(Mouse_names{mouse})], [MeanHRREM.(Mouse_names{mouse})-StdHRREM.(Mouse_names{mouse}) MeanHRREM.(Mouse_names{mouse})+StdHRREM.(Mouse_names{mouse})],'color','g','LineWidth',2);
end
ylim([4 14]); xlim([0 16]);
xlabel('Respiratory rate (Hz)');
ylabel('Heart Rate (Hz)')
makepretty


saveFigure(1,'Physiological_Params_correlations_Sleep','/home/mobsmorty/Desktop/Baptiste/FiguresForSophie/')
saveFigure(2,'Physiological_Params_correlations_Fear','/home/mobsmorty/Desktop/Baptiste/FiguresForSophie/')



% Plot for more mice, increase algorithm for respi, check for blob REM,
% check for lines Respi : moving vs resting (Vtsd)
% Old way : plot hold on the differents brain states

%% Active vs Wake
figure

subplot(3,3,1)
mouse=3;
HRAxes=dscatter(DataHRNewActive.(Mouse_names{mouse}),DataMTempNewActive.(Mouse_names{mouse}),'smoothing',7);
colormap hot
freezeColors
ylabel('Temperature (°C)')
makepretty
b=text(-0.4,-2.5,'Active','FontSize',30)
set(b,'Rotation',90);
title('Total Body Temperature = f(Heart Rate)')
xlim([5 16]); ylim([-3 2])
subplot(3,3,4)
HRAxes=dscatter(DataHRNewWake.(Mouse_names{mouse}),DataMTempNewWake.(Mouse_names{mouse}),'smoothing',7);
colormap parula
freezeColors
ylabel('Temperature (°C)')
title('Total Body Temperature=f(Heart Rate)')
makepretty
xlim([5 16]); ylim([-3 2])
subplot(3,3,7)
for mouse=1:length(Mouse_names)
    plot(MeanHRActive.(Mouse_names{mouse}),MeanMTempActive.(Mouse_names{mouse}),'.r','MarkerSize',60)
    line([MeanHRActive.(Mouse_names{mouse})-StdHRActive.(Mouse_names{mouse}) MeanHRActive.(Mouse_names{mouse})+StdHRActive.(Mouse_names{mouse})], [MeanMTempActive.(Mouse_names{mouse}) MeanMTempActive.(Mouse_names{mouse})],'color','r','LineWidth',2);
    line([MeanHRActive.(Mouse_names{mouse}) MeanHRActive.(Mouse_names{mouse})], [MeanMTempActive.(Mouse_names{mouse})-StdMTempActive.(Mouse_names{mouse}) MeanMTempActive.(Mouse_names{mouse})+StdMTempActive.(Mouse_names{mouse})],'color','r','LineWidth',2);
    hold on
    plot(MeanHRWake.(Mouse_names{mouse}),MeanMTempWake.(Mouse_names{mouse}),'.b','MarkerSize',60)
    line([MeanHRWake.(Mouse_names{mouse})-StdHRWake.(Mouse_names{mouse}) MeanHRWake.(Mouse_names{mouse})+StdHRWake.(Mouse_names{mouse})], [MeanMTempWake.(Mouse_names{mouse}) MeanMTempWake.(Mouse_names{mouse})],'color','b','LineWidth',2);
    line([MeanHRWake.(Mouse_names{mouse}) MeanHRWake.(Mouse_names{mouse})], [MeanMTempWake.(Mouse_names{mouse})-StdMTempWake.(Mouse_names{mouse}) MeanMTempWake.(Mouse_names{mouse})+StdMTempWake.(Mouse_names{mouse})],'color','b','LineWidth',2);
end
xlabel('Heart rate (Hz)');
ylabel('Temperature (°C)')
makepretty
b=text(-1,-0.8, 'Mean values','FontSize',30)
set(b,'Rotation',90);
f=get(gca,'Children');
legend([f(2),f(5)],'Freezing','Active')

subplot(3,3,2)
HRAxes=dscatter(DataRespiNewActive.(Mouse_names{mouse}),DataMTempNewActive.(Mouse_names{mouse}),'smoothing',7);
colormap hot
freezeColors
ylabel('Temperature (°C)')
title('Temperature=f(Respiratory Rate)')
makepretty
ylim([-3 2]); xlim([0 16])
title('Total Body Temperature = f(Respiratory Rate)')
subplot(3,3,5)
HRAxes=dscatter(DataRespiNewWake.(Mouse_names{mouse}),DataMTempNewWake.(Mouse_names{mouse}),'smoothing',7);
colormap parula
freezeColors
ylabel('Temperature (°C)')
ylim([-3 2]); xlim([0 16])
makepretty
subplot(3,3,8)
for mouse=1:length(Mouse_names)
    plot(MeanRespiActive.(Mouse_names{mouse}),MeanMTempActive.(Mouse_names{mouse}),'.r','MarkerSize',60)
    line([MeanRespiActive.(Mouse_names{mouse})-StdRespiActive.(Mouse_names{mouse}) MeanRespiActive.(Mouse_names{mouse})+StdRespiActive.(Mouse_names{mouse})], [MeanMTempActive.(Mouse_names{mouse}) MeanMTempActive.(Mouse_names{mouse})],'color','r','LineWidth',2);
    line([MeanRespiActive.(Mouse_names{mouse}) MeanRespiActive.(Mouse_names{mouse})], [MeanMTempActive.(Mouse_names{mouse})-StdMTempActive.(Mouse_names{mouse}) MeanMTempActive.(Mouse_names{mouse})+StdMTempActive.(Mouse_names{mouse})],'color','r','LineWidth',2);
    hold on
     plot(MeanRespiWake.(Mouse_names{mouse}),MeanMTempWake.(Mouse_names{mouse}),'.b','MarkerSize',60)
    line([MeanRespiWake.(Mouse_names{mouse})-StdRespiWake.(Mouse_names{mouse}) MeanRespiWake.(Mouse_names{mouse})+StdRespiWake.(Mouse_names{mouse})], [MeanMTempWake.(Mouse_names{mouse}) MeanMTempWake.(Mouse_names{mouse})],'color','b','LineWidth',2);
    line([MeanRespiWake.(Mouse_names{mouse}) MeanRespiWake.(Mouse_names{mouse})], [MeanMTempWake.(Mouse_names{mouse})-StdMTempWake.(Mouse_names{mouse}) MeanMTempWake.(Mouse_names{mouse})+StdMTempWake.(Mouse_names{mouse})],'color','b','LineWidth',2);
end
xlabel('Respiratory rate (Hz)');
ylabel('Temperature (°C)')
makepretty

subplot(3,3,3)
HRAxes=dscatter(DataRespiNewActive.(Mouse_names{mouse}),DataHRNewActive.(Mouse_names{mouse}),'smoothing',7);
colormap hot
freezeColors
ylabel('Heart Rate (Hz)')
title('Heart Rate=f(Respiratory Rate)')
makepretty
xlim([0 14]);  ylim([5 16])
subplot(3,3,6)
HRAxes=dscatter(DataRespiNewWake.(Mouse_names{mouse}),DataHRNewWake.(Mouse_names{mouse}),'smoothing',7);
colormap parula
freezeColors
ylabel('Heart Rate (Hz)')
makepretty
xlim([0 14]);  ylim([5 16])
subplot(3,3,9)
for mouse=1:length(Mouse_names)
    plot(MeanRespiActive.(Mouse_names{mouse}),MeanHRActive.(Mouse_names{mouse}),'.r','MarkerSize',60)
    line([MeanRespiActive.(Mouse_names{mouse})-StdRespiActive.(Mouse_names{mouse}) MeanRespiActive.(Mouse_names{mouse})+StdRespiActive.(Mouse_names{mouse})], [MeanHRActive.(Mouse_names{mouse}) MeanHRActive.(Mouse_names{mouse})],'color','r','LineWidth',2);
    line([MeanRespiActive.(Mouse_names{mouse}) MeanRespiActive.(Mouse_names{mouse})], [MeanHRActive.(Mouse_names{mouse})-StdHRActive.(Mouse_names{mouse}) MeanHRActive.(Mouse_names{mouse})+StdHRActive.(Mouse_names{mouse})],'color','r','LineWidth',2);
    hold on
     plot(MeanRespiWake.(Mouse_names{mouse}),MeanHRWake.(Mouse_names{mouse}),'.b','MarkerSize',60)
    line([MeanRespiWake.(Mouse_names{mouse})-StdRespiWake.(Mouse_names{mouse}) MeanRespiWake.(Mouse_names{mouse})+StdRespiWake.(Mouse_names{mouse})], [MeanHRWake.(Mouse_names{mouse}) MeanHRWake.(Mouse_names{mouse})],'color','b','LineWidth',2);
    line([MeanRespiWake.(Mouse_names{mouse}) MeanRespiWake.(Mouse_names{mouse})], [MeanHRWake.(Mouse_names{mouse})-StdHRWake.(Mouse_names{mouse}) MeanHRWake.(Mouse_names{mouse})+StdHRWake.(Mouse_names{mouse})],'color','b','LineWidth',2);
   end
xlabel('Respiratory rate (Hz)');
ylabel('Heart Rate (Hz)')
makepretty


%% 2 freezing types

% Shock Freezing 
for mouse= 1:length(Mouse_names)
       
    % Modifications Restrict to freezing Epoch, withdraw NaNs,
    TTempFzShock.(Mouse_names{mouse})=Restrict(TTempFz.(Mouse_names{mouse}),or(ZoneEpoch.(Mouse_names{mouse}){1},ZoneEpoch.(Mouse_names{mouse}){4}));
    DataTTempNewFzShock.(Mouse_names{mouse})=Data(TTempFzShock.(Mouse_names{mouse}));
    DataTTempNewFzShock.(Mouse_names{mouse})=DataTTempNewFzShock.(Mouse_names{mouse})(~isnan(DataTTempNewFzShock.(Mouse_names{mouse})))-nanmean(Data(TTempFear.(Mouse_names{mouse})));
    
    HRFzShock.(Mouse_names{mouse})=Restrict(HRFz.(Mouse_names{mouse}),or(ZoneEpoch.(Mouse_names{mouse}){1},ZoneEpoch.(Mouse_names{mouse}){4}));
    HRNewFzShock.(Mouse_names{mouse}) = Restrict(HRFzShock.(Mouse_names{mouse}),TTempFzShock.(Mouse_names{mouse}));
    DataHRNewFzShock.(Mouse_names{mouse})=Data(HRNewFzShock.(Mouse_names{mouse}));
    DataHRNewFzShock.(Mouse_names{mouse})=DataHRNewFzShock.(Mouse_names{mouse})(~isnan(DataTTempNewFzShock.(Mouse_names{mouse})));
    
    RespiFzShock.(Mouse_names{mouse})=Restrict(RespiFz.(Mouse_names{mouse}),or(ZoneEpoch.(Mouse_names{mouse}){1},ZoneEpoch.(Mouse_names{mouse}){4}));
    RespiNewFzShock.(Mouse_names{mouse}) = Restrict(RespiFzShock.(Mouse_names{mouse}),TTempFzShock.(Mouse_names{mouse}));
    DataRespiNewFzShock.(Mouse_names{mouse})=Data(RespiNewFzShock.(Mouse_names{mouse}));
    DataRespiNewFzShock.(Mouse_names{mouse})=DataRespiNewFzShock.(Mouse_names{mouse})(~isnan(DataTTempNewFzShock.(Mouse_names{mouse})));

end

% Safe Freezing 
for mouse= 1:length(Mouse_names)
       
    % Modifications Restrict to freezing Epoch, withdraw NaNs,
    TTempFzSafe.(Mouse_names{mouse})=Restrict(TTempFz.(Mouse_names{mouse}),or(ZoneEpoch.(Mouse_names{mouse}){2},ZoneEpoch.(Mouse_names{mouse}){5}));
    DataTTempNewFzSafe.(Mouse_names{mouse})=Data(TTempFzSafe.(Mouse_names{mouse}));
    DataTTempNewFzSafe.(Mouse_names{mouse})=DataTTempNewFzSafe.(Mouse_names{mouse})(~isnan(DataTTempNewFzSafe.(Mouse_names{mouse})))-nanmean(Data(TTempFear.(Mouse_names{mouse})));
    
    HRFzSafe.(Mouse_names{mouse})=Restrict(HRFz.(Mouse_names{mouse}),or(ZoneEpoch.(Mouse_names{mouse}){2},ZoneEpoch.(Mouse_names{mouse}){5}));
    HRNewFzSafe.(Mouse_names{mouse}) = Restrict(HRFzSafe.(Mouse_names{mouse}),TTempFzSafe.(Mouse_names{mouse}));
    DataHRNewFzSafe.(Mouse_names{mouse})=Data(HRNewFzSafe.(Mouse_names{mouse}));
    DataHRNewFzSafe.(Mouse_names{mouse})=DataHRNewFzSafe.(Mouse_names{mouse})(~isnan(DataTTempNewFzSafe.(Mouse_names{mouse})));
    
    RespiFzSafe.(Mouse_names{mouse})=Restrict(RespiFz.(Mouse_names{mouse}),or(ZoneEpoch.(Mouse_names{mouse}){2},ZoneEpoch.(Mouse_names{mouse}){5}));
    RespiNewFzSafe.(Mouse_names{mouse}) = Restrict(RespiFzSafe.(Mouse_names{mouse}),TTempFzSafe.(Mouse_names{mouse}));
    DataRespiNewFzSafe.(Mouse_names{mouse})=Data(RespiNewFzSafe.(Mouse_names{mouse}));
    DataRespiNewFzSafe.(Mouse_names{mouse})=DataRespiNewFzSafe.(Mouse_names{mouse})(~isnan(DataTTempNewFzSafe.(Mouse_names{mouse})));

end

%% Plot 2 fz types

for mouse= 1:length(Mouse_names)
    
    MeanHRFzShock.(Mouse_names{mouse})=mean(DataHRNewFzShock.(Mouse_names{mouse}));
    MeanTTempFzShock.(Mouse_names{mouse})=mean(DataTTempNewFzShock.(Mouse_names{mouse}));
    MeanRespiFzShock.(Mouse_names{mouse})=mean(DataRespiNewFzShock.(Mouse_names{mouse}));
    MeanHRFzSafe.(Mouse_names{mouse})=mean(DataHRNewFzSafe.(Mouse_names{mouse}));
    MeanTTempFzSafe.(Mouse_names{mouse})=mean(DataTTempNewFzSafe.(Mouse_names{mouse}));
    MeanRespiFzSafe.(Mouse_names{mouse})=mean(DataRespiNewFzSafe.(Mouse_names{mouse}));
    
    StdTTempFzShock.(Mouse_names{mouse})=std(DataTTempNewFzShock.(Mouse_names{mouse}));
    StdHRFzShock.(Mouse_names{mouse})=std(DataHRNewFzShock.(Mouse_names{mouse}));
    StdRespiFzShock.(Mouse_names{mouse})=std(DataRespiNewFzShock.(Mouse_names{mouse}));
    StdTTempFzSafe.(Mouse_names{mouse})=std(DataTTempNewFzSafe.(Mouse_names{mouse}));
    StdHRFzSafe.(Mouse_names{mouse})=std(DataHRNewFzSafe.(Mouse_names{mouse}));
    StdRespiFzSafe.(Mouse_names{mouse})=std(DataRespiNewFzSafe.(Mouse_names{mouse}));
    
end


%% test
figure
subplot(2,3,1)
mouse=4;
HRAxes=dscatter(all_mice.Safe.HR(mouse,301:600)',all_mice.Safe.TTemp(mouse,301:600)','smoothing',7);
colormap spring
freezeColors
hold on
HRAxes=dscatter(all_mice.Shock.HR(mouse,301:600)',all_mice.Shock.TTemp(mouse,301:600)','smoothing',7);
colormap bone
freezeColors
ylabel('Temperature (°C)')
makepretty
b=text(-0.4,-3, 'Freezing','FontSize',30)
set(b,'Rotation',90);
subplot(2,3,4)
for mouse=1:length(Mouse_names)
plot(MeanHRFzShock.(Mouse_names{mouse}),MeanTTempFzShock.(Mouse_names{mouse}),'.k','MarkerSize',60)
line([MeanHRFzShock.(Mouse_names{mouse})-StdHRFzShock.(Mouse_names{mouse}) MeanHRFzShock.(Mouse_names{mouse})+StdHRFzShock.(Mouse_names{mouse})], [MeanTTempFzShock.(Mouse_names{mouse}) MeanTTempFzShock.(Mouse_names{mouse})],'color','k','LineWidth',2);
line([MeanHRFzShock.(Mouse_names{mouse}) MeanHRFzShock.(Mouse_names{mouse})], [MeanTTempFzShock.(Mouse_names{mouse})-StdTTempFzShock.(Mouse_names{mouse}) MeanTTempFzShock.(Mouse_names{mouse})+StdTTempFzShock.(Mouse_names{mouse})],'color','k','LineWidth',2);
hold on
plot(MeanHRFzSafe.(Mouse_names{mouse}),MeanTTempFzSafe.(Mouse_names{mouse}),'.m','MarkerSize',60)
line([MeanHRFzSafe.(Mouse_names{mouse})-StdHRFzSafe.(Mouse_names{mouse}) MeanHRFzSafe.(Mouse_names{mouse})+StdHRFzSafe.(Mouse_names{mouse})], [MeanTTempFzSafe.(Mouse_names{mouse}) MeanTTempFzSafe.(Mouse_names{mouse})],'color','m','LineWidth',2);
line([MeanHRFzSafe.(Mouse_names{mouse}) MeanHRFzSafe.(Mouse_names{mouse})], [MeanTTempFzSafe.(Mouse_names{mouse})-StdTTempFzSafe.(Mouse_names{mouse}) MeanTTempFzSafe.(Mouse_names{mouse})+StdTTempFzSafe.(Mouse_names{mouse})],'color','m','LineWidth',2);
end
xlabel('Heart rate (Hz)');
ylabel('Temperature (°C)')
makepretty
b=text(-1,-0.8, 'Mean values','FontSize',30)
set(b,'Rotation',90);
f=get(gca,'Children');
legend([f(5),f(2)],'Freezing shock','Freezing Safe')

subplot(2,3,2)
HRAxes=dscatter(AllMiceRespiratoryFrequency.Safe(mouse,301:600)',all_mice.Safe.TTemp(mouse,301:600)','smoothing',7);
colormap spring
freezeColors
xticks([1:12:121])
xticklabels({'','1Hz','2Hz','3Hz','4Hz','5Hz','6Hz','7Hz','8Hz','9Hz','10Hz'})
hold on
HRAxes=dscatter(AllMiceRespiratoryFrequency.Shock(mouse,301:600)',all_mice.Shock.TTemp(mouse,301:600)','smoothing',7);
colormap bone
freezeColors
ylabel('Temperature (°C)')
makepretty
subplot(2,3,5)
for mouse=1:length(Mouse_names)
    plot(MeanRespiFzShock.(Mouse_names{mouse}),MeanTTempFzShock.(Mouse_names{mouse}),'.k','MarkerSize',60)
    line([MeanRespiFzShock.(Mouse_names{mouse})-StdRespiFzShock.(Mouse_names{mouse}) MeanRespiFzShock.(Mouse_names{mouse})+StdRespiFzShock.(Mouse_names{mouse})], [MeanTTempFzShock.(Mouse_names{mouse}) MeanTTempFzShock.(Mouse_names{mouse})],'color','k','LineWidth',2);
    line([MeanRespiFzShock.(Mouse_names{mouse}) MeanRespiFzShock.(Mouse_names{mouse})], [MeanTTempFzShock.(Mouse_names{mouse})-StdTTempFzShock.(Mouse_names{mouse}) MeanTTempFzShock.(Mouse_names{mouse})+StdTTempFzShock.(Mouse_names{mouse})],'color','k','LineWidth',2);
    hold on
    plot(MeanRespiFzSafe.(Mouse_names{mouse}),MeanTTempFzSafe.(Mouse_names{mouse}),'.m','MarkerSize',60)
    line([MeanRespiFzSafe.(Mouse_names{mouse})-StdRespiFzSafe.(Mouse_names{mouse}) MeanRespiFzSafe.(Mouse_names{mouse})+StdRespiFzSafe.(Mouse_names{mouse})], [MeanTTempFzSafe.(Mouse_names{mouse}) MeanTTempFzSafe.(Mouse_names{mouse})],'color','m','LineWidth',2);
    line([MeanRespiFzSafe.(Mouse_names{mouse}) MeanRespiFzSafe.(Mouse_names{mouse})], [MeanTTempFzSafe.(Mouse_names{mouse})-StdTTempFzSafe.(Mouse_names{mouse}) MeanTTempFzSafe.(Mouse_names{mouse})+StdTTempFzSafe.(Mouse_names{mouse})],'color','m','LineWidth',2);
end
xlabel('Respiratory rate (Hz)');
ylabel('Temperature (°C)')
makepretty

subplot(2,3,3)
HRAxes=dscatter(AllMiceRespiratoryFrequency.Safe(mouse,301:600)',all_mice.Safe.HR(mouse,301:600)','smoothing',7);
colormap spring
freezeColors
xticks([1:12:121])
xticklabels({'','1Hz','2Hz','3Hz','4Hz','5Hz','6Hz','7Hz','8Hz','9Hz','10Hz'})
hold on
HRAxes=dscatter(AllMiceRespiratoryFrequency.Shock(mouse,301:600)',all_mice.Shock.HR(mouse,301:600)','smoothing',7);
colormap bone
freezeColors
ylabel('Heart Rate (Hz)')
makepretty
subplot(2,3,6)
for mouse=1:length(Mouse_names)
    plot(MeanRespiFzShock.(Mouse_names{mouse}),MeanHRFzShock.(Mouse_names{mouse}),'.k','MarkerSize',60)
    line([MeanRespiFzShock.(Mouse_names{mouse})-StdRespiFzShock.(Mouse_names{mouse}) MeanRespiFzShock.(Mouse_names{mouse})+StdRespiFzShock.(Mouse_names{mouse})], [MeanHRFzShock.(Mouse_names{mouse}) MeanHRFzShock.(Mouse_names{mouse})],'color','k','LineWidth',2);
    line([MeanRespiFzShock.(Mouse_names{mouse}) MeanRespiFzShock.(Mouse_names{mouse})], [MeanHRFzShock.(Mouse_names{mouse})-StdHRFzShock.(Mouse_names{mouse}) MeanHRFzShock.(Mouse_names{mouse})+StdHRFzShock.(Mouse_names{mouse})],'color','k','LineWidth',2);
    hold on
    plot(MeanRespiFzSafe.(Mouse_names{mouse}),MeanHRFzSafe.(Mouse_names{mouse}),'.m','MarkerSize',60)
    line([MeanRespiFzSafe.(Mouse_names{mouse})-StdRespiFzSafe.(Mouse_names{mouse}) MeanRespiFzSafe.(Mouse_names{mouse})+StdRespiFzSafe.(Mouse_names{mouse})], [MeanHRFzSafe.(Mouse_names{mouse}) MeanHRFzSafe.(Mouse_names{mouse})],'color','m','LineWidth',2);
    line([MeanRespiFzSafe.(Mouse_names{mouse}) MeanRespiFzSafe.(Mouse_names{mouse})], [MeanHRFzSafe.(Mouse_names{mouse})-StdHRFzSafe.(Mouse_names{mouse}) MeanHRFzSafe.(Mouse_names{mouse})+StdHRFzSafe.(Mouse_names{mouse})],'color','m','LineWidth',2);
    end
xlabel('Respiratory rate (Hz)');
ylabel('Heart Rate (Hz)')
makepretty


%% with good respi

all_mice.Safe.TTemp(8,:)=NaN;

figure
subplot(2,3,1)
mouse=7;
HRAxes=dscatter(all_mice.Safe.HR(mouse,301:600)',all_mice.Safe.TTemp(mouse,301:600)','smoothing',7);
colormap spring
freezeColors
hold on
HRAxes=dscatter(all_mice.Shock.HR(mouse,301:600)',all_mice.Shock.TTemp(mouse,301:600)','smoothing',7);
colormap bone
freezeColors
ylabel('Temperature (°C)')
makepretty
b=text(-0.4,-3, 'Freezing','FontSize',30)
set(b,'Rotation',90);
subplot(2,3,4)
for mouse=1:length(Mouse_names)
plot(mean(all_mice.Shock.HR(mouse,301:600)),mean(all_mice.Shock.TTemp(mouse,301:600)),'.k','MarkerSize',60)
[Line]=MeanPlusOrMinusStd(all_mice.Shock.HR(mouse,301:600) , all_mice.Shock.TTemp(mouse,301:600));
line(Line(1,:),Line(2,:),'color','k','LineWidth',2); line(Line(3,:),Line(4,:),'color','k','LineWidth',2); 
hold on
plot(mean(all_mice.Safe.HR(mouse,301:600)),mean(all_mice.Safe.TTemp(mouse,301:600)),'.m','MarkerSize',60)
[Line]=MeanPlusOrMinusStd(all_mice.Safe.HR(mouse,301:600) , all_mice.Safe.TTemp(mouse,301:600));
line(Line(1,:),Line(2,:),'color','m','LineWidth',2); line(Line(3,:),Line(4,:),'color','m','LineWidth',2); 
end
xlabel('Heart rate (Hz)');
ylabel('Temperature (°C)')
makepretty
b=text(-1,-0.8, 'Mean values','FontSize',30)
set(b,'Rotation',90);
f=get(gca,'Children');
legend([f(5),f(2)],'Freezing shock','Freezing Safe')

subplot(2,3,2)
mouse=7;
HRAxes=dscatter(AllMiceRespiratoryFrequency.Safe(mouse,301:600)',all_mice.Safe.TTemp(mouse,301:600)','smoothing',7);
colormap spring
freezeColors
 xticks([1:12:121])
xticklabels({'','1','2','3','4','5','6','7','8','9Hz','10Hz'})
hold on
HRAxes=dscatter(AllMiceRespiratoryFrequency.Shock(mouse,301:600)',all_mice.Shock.TTemp(mouse,301:600)','smoothing',7);
colormap bone
freezeColors
ylabel('Temperature (°C)')
makepretty
subplot(2,3,5)
for mouse=1:length(Mouse_names)
plot(mean(AllMiceRespiratoryFrequency.Shock(mouse,301:600)),mean(all_mice.Shock.TTemp(mouse,301:600)),'.k','MarkerSize',60)
[Line]=MeanPlusOrMinusStd(AllMiceRespiratoryFrequency.Shock(mouse,301:600) , all_mice.Shock.TTemp(mouse,301:600));
line(Line(1,:),Line(2,:),'color','k','LineWidth',2); line(Line(3,:),Line(4,:),'color','k','LineWidth',2); 
hold on
plot(mean(AllMiceRespiratoryFrequency.Safe(mouse,301:600)),mean(all_mice.Safe.TTemp(mouse,301:600)),'.m','MarkerSize',60)
[Line]=MeanPlusOrMinusStd(AllMiceRespiratoryFrequency.Safe(mouse,301:600) , all_mice.Safe.TTemp(mouse,301:600));
line(Line(1,:),Line(2,:),'color','m','LineWidth',2); line(Line(3,:),Line(4,:),'color','m','LineWidth',2); 
end
xlabel('Respiratory rate (Hz)'); xticks([1:12:121])
xticklabels({'','1','2','3','4','5','6','7','8','9Hz','10Hz'})
ylabel('Temperature (°C)')
makepretty

subplot(2,3,3)
mouse=7;
HRAxes=dscatter(AllMiceRespiratoryFrequency.Safe(mouse,301:600)',all_mice.Safe.HR(mouse,301:600)','smoothing',7);
colormap spring
freezeColors
xticks([1:12:121])
xticklabels({'','1','2','3','4','5','6','7','8','9Hz','10Hz'})
hold on
HRAxes=dscatter(AllMiceRespiratoryFrequency.Shock(mouse,301:600)',all_mice.Shock.HR(mouse,301:600)','smoothing',7);
colormap bone
freezeColors
ylabel('Heart Rate (Hz)')
makepretty
subplot(2,3,6)
for mouse=1:length(Mouse_names)
plot(mean(AllMiceRespiratoryFrequency.Shock(mouse,301:600)),mean(all_mice.Shock.HR(mouse,301:600)),'.k','MarkerSize',60)
[Line]=MeanPlusOrMinusStd(AllMiceRespiratoryFrequency.Shock(mouse,301:600) , all_mice.Shock.HR(mouse,301:600));
line(Line(1,:),Line(2,:),'color','k','LineWidth',2); line(Line(3,:),Line(4,:),'color','k','LineWidth',2); 
hold on
plot(mean(AllMiceRespiratoryFrequency.Safe(mouse,301:600)),mean(all_mice.Safe.HR(mouse,301:600)),'.m','MarkerSize',60)
[Line]=MeanPlusOrMinusStd(AllMiceRespiratoryFrequency.Safe(mouse,301:600) , all_mice.Safe.HR(mouse,301:600));
line(Line(1,:),Line(2,:),'color','m','LineWidth',2); line(Line(3,:),Line(4,:),'color','m','LineWidth',2); 
end
xlabel('Respiratory rate (Hz)'); xticks([1:12:121])
xticklabels({'','1','2','3','4','5','6','7','8','9Hz','10Hz'})
ylabel('Heart Rate (Hz)')
makepretty

