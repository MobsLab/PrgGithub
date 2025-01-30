%% Sleep
cd('/home/mobsmorty/Dropbox/Kteam/PrgMatlab/Baptiste/Temperature')
load('Sess.mat')

% all mice
Mouse_names={'M666','M667','M668','M669','M688','M739','M777','M779','M849','M893','M1001','M1002','M1005'};
Mouse=[666 667 668 669 688 739 777 779 849 893 1001 1002 1005];
for mouse = 1:length(Mouse_names)
    %Sess.(Mouse_names{mouse}) = GetAllMouseTaskSessions(Mouse(mouse));
    SleepSessTemp.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Sleep')))));
end

% mice with good respi/EKG 
Mouse_names={'M666','M667','M668','M669','M739','M777','M849','M1001','M1002','M1005'};
Mouse=[666 667 668 669 739 777 849 1001 1002 1005];
for mouse = 1:length(Mouse_names)
    SleepSessEKG.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Sleep')))));
end

%% Mean values
for mouse=1:length(Mouse_names)
    MTempData.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(SleepSessTemp.(Mouse_names{mouse}),'masktemperature');
    SleepEpoch.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(SleepSessTemp.(Mouse_names{mouse}),'epoch','epochname','sleepstates');
    RoomTempData.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(SleepSessTemp.(Mouse_names{mouse}),'roomtemperature');
end


% More EKG mean values
for mouse=1:length(Mouse_names)
    AccEKG.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(SleepSessEKG.(Mouse_names{mouse}),'accelero');
    SleepEpochEKG.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(SleepSessEKG.(Mouse_names{mouse}),'epoch','epochname','sleepstates');
    HRDataEKG.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(SleepSessEKG.(Mouse_names{mouse}),'heartrate');
    HRVarDataEKG.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(SleepSessEKG.(Mouse_names{mouse}),'heartratevar');
    RespiDataEKG.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(SleepSessEKG.(Mouse_names{mouse}),'instfreq','suffix_instfreq','B');
end

% Gathering mean values
for mouse=1:length(Mouse)
    SleepMeanAcc(mouse,1)=nanmean(Data(Restrict(AccEKG.(Mouse_names{mouse}),SleepEpochEKG.(Mouse_names{mouse}){1})));
    SleepMeanAcc(mouse,2)=nanmean(Data(Restrict(AccEKG.(Mouse_names{mouse}),SleepEpochEKG.(Mouse_names{mouse}){2})));
    SleepMeanAcc(mouse,3)=nanmean(Data(Restrict(AccEKG.(Mouse_names{mouse}),SleepEpochEKG.(Mouse_names{mouse}){3})));
    SleepMeanRespi(mouse,1)=nanmean(Data(Restrict(RespiDataEKG.(Mouse_names{mouse}),SleepEpochEKG.(Mouse_names{mouse}){1})));
    SleepMeanRespi(mouse,2)=nanmean(Data(Restrict(RespiDataEKG.(Mouse_names{mouse}),SleepEpochEKG.(Mouse_names{mouse}){2})));
    SleepMeanRespi(mouse,3)=nanmean(Data(Restrict(RespiDataEKG.(Mouse_names{mouse}),SleepEpochEKG.(Mouse_names{mouse}){3})));
    SleepMeanHR(mouse,1)=nanmean(Data(Restrict(HRDataEKG.(Mouse_names{mouse}),SleepEpochEKG.(Mouse_names{mouse}){1})));
    SleepMeanHR(mouse,2)=nanmean(Data(Restrict(HRDataEKG.(Mouse_names{mouse}),SleepEpochEKG.(Mouse_names{mouse}){2})));
    SleepMeanHR(mouse,3)=nanmean(Data(Restrict(HRDataEKG.(Mouse_names{mouse}),SleepEpochEKG.(Mouse_names{mouse}){3})));
    SleepMeanHRVar(mouse,1)=nanmean(Data(Restrict(HRVarDataEKG.(Mouse_names{mouse}),SleepEpochEKG.(Mouse_names{mouse}){1})));
    SleepMeanHRVar(mouse,2)=nanmean(Data(Restrict(HRVarDataEKG.(Mouse_names{mouse}),SleepEpochEKG.(Mouse_names{mouse}){2})));
    SleepMeanHRVar(mouse,3)=nanmean(Data(Restrict(HRVarDataEKG.(Mouse_names{mouse}),SleepEpochEKG.(Mouse_names{mouse}){3})));
end

% Making mean values array
for mouse=1:length(Mouse)
    SleepMeanTemp(mouse,1)=nanmean(Data(Restrict(MTempData.(Mouse_names{mouse}),SleepEpoch.(Mouse_names{mouse}){1})));
    SleepMeanTemp(mouse,2)=nanmean(Data(Restrict(MTempData.(Mouse_names{mouse}),SleepEpoch.(Mouse_names{mouse}){2})));
    SleepMeanTemp(mouse,3)=nanmean(Data(Restrict(MTempData.(Mouse_names{mouse}),SleepEpoch.(Mouse_names{mouse}){3})));
    SleepMeanTemp(mouse,4)=nanmean(Data(MTempData.(Mouse_names{mouse})));
end
SleepMeanTemp(:,1)=SleepMeanTemp(:,1)-SleepMeanTemp(:,4);
SleepMeanTemp(:,2)=SleepMeanTemp(:,2)-SleepMeanTemp(:,4);
SleepMeanTemp(:,3)=SleepMeanTemp(:,3)-SleepMeanTemp(:,4);

% Plot mean values
figure 
Cols = {[0 0 1],[1 0 0],[0 1 0]};% Plot parameters
X = [1,2,3];
Legends = {'Wake' 'NREM' 'REM'};

a=subplot(1,5,1);  a.Position(4)= 0.7;
MakeSpreadAndBoxPlot2_SB(SleepMeanAcc,Cols,X,Legends,'showpoints',0)
makepretty
ylabel('Movement quantity (AU)')
title('Accelerometer');

a=subplot(1,5,2); a.Position(4)= 0.7;
MakeSpreadAndBoxPlot2_SB(SleepMeanHR,Cols,X,Legends,'showpoints',0)
makepretty
ylabel('Frequency (Hz)')
title('Heart rate'); 

a=subplot(1,5,3); a.Position(4)= 0.7;
MakeSpreadAndBoxPlot2_SB(SleepMeanHRVar,Cols,X,Legends,'showpoints',0)
makepretty
ylabel('Variability')
title('Heart rate variability');  

a=subplot(1,5,4); a.Position(4)= 0.7;
MakeSpreadAndBoxPlot2_SB(SleepMeanRespi,Cols,X,Legends,'showpoints',0)
makepretty
ylabel('Frequency (Hz)')
title('Respirarory rate'); 

a=subplot(1,5,5); a.Position(4)= 0.7;
MakeSpreadAndBoxPlot2_SB(SleepMeanTemp(:,1:3),Cols,X,Legends,'showpoints',0)
makepretty
ylabel('Normalized Temperature(°C)')
title('Total Body Temperature'); 

a=suptitle('Sleep physiology, UMaze drugs experiments'); a.FontSize=30;

saveFigure(1,'Physiological_Analysis_Sleep_MeanValues','/home/mobsmorty/Desktop/Baptiste/Figures/')





%% Transitions study
Zones={'Wake_NREM','NREM_REM','NREM_Wake','REM_NREM'};
SleepTransition_time={'SleepTransition10','SleepTransition300'};
SleepTransition_times=[10 300];
for time=1:length(SleepTransition_time)
    for zones=1:length(Zones)
        for mouse=1:length(Mouse)
            Episodes= Temperature_ShockEpisodes(Mouse(mouse),SleepSessTemp,Zones{zones},SleepTransition_times(time),'Yes','No','No','No','No');
            SleepTransitions.(SleepTransition_time{time}).(Zones{zones}).(Mouse_names{mouse})=Episodes;
        end
    end
end

% Gathering data
clear all_mice_sleep;
all_mice_sleep_time={'all_mice_sleep10','all_mice_sleep300'};
Zones={'Wake_NREM','NREM_REM','NREM_Wake','REM_NREM'};
for time=1:length(all_mice_sleep_time)
    for zones=1:length(Zones)
        all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp=[];
        for mouse=1:length(Mouse_names)
            try
                all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp=[all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp ; nanmean(SleepTransitions.(SleepTransition_time{time}).(Zones{zones}).(Mouse_names{mouse}).MTemp_Interp')];
            end
        end
    end
end

% mean T° calculation
for mouse=1:length(Mouse_names)
    MeanMTempPerMice.(Mouse_names{mouse})=nanmean(Data(ConcatenateDataFromFolders_SB(SleepSessTemp.(Mouse_names{mouse}),'masktemperature')));
end

% Substract mean temperature
for time=1:length(all_mice_sleep_time)
    for zones=1:length(Zones)
        for mouse = 1:length(Mouse_names)
            
            try
            all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp(mouse,:)=all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp(mouse,:)-MeanMTempPerMice.(Mouse_names{mouse});
            end
            
        end
    end
end

% Transitions analysis for mice with EKG
Zones={'Wake_NREM','NREM_REM','NREM_Wake','REM_NREM'};
SleepTransition_time={'SleepTransition10','SleepTransition300'};
SleepTransition_times=[10 300];
for time=1:length(SleepTransition_time)
    for zones=1:length(Zones)
        for mouse=1:length(Mouse)
            Episodes= Temperature_ShockEpisodes(Mouse(mouse),SleepSessEKG,Zones{zones},SleepTransition_times(time),'No','Yes','No','Yes','Yes');
            SleepTransitionsEKG.(SleepTransition_time{time}).(Zones{zones}).(Mouse_names{mouse})=Episodes;
        end
    end
end

% Gathering data transitions
clear all_mice_sleepEKG;
all_mice_sleep_time={'all_mice_sleep10','all_mice_sleep300'};
Zones={'Wake_NREM','NREM_REM','NREM_Wake','REM_NREM'};
for time=1:length(all_mice_sleep_time)
    for zones=1:length(Zones)
        all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Acc=[];
        all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR=[];
        all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HRVar=[];
        all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Respi=[];
        all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).RespiOB=[];
        for mouse=1:length(Mouse_names)
            % Accelero
            try
                if size(SleepTransitionsEKG.(SleepTransition_time{time}).(Zones{zones}).(Mouse_names{mouse}).Acc_Interp,2)==1
                    all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Acc=[all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Acc ; SleepTransitionsEKG.(SleepTransition_time{time}).(Zones{zones}).(Mouse_names{mouse}).Acc_Interp'];
                else
                    all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Acc=[all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Acc ; nanmean(SleepTransitionsEKG.(SleepTransition_time{time}).(Zones{zones}).(Mouse_names{mouse}).Acc_Interp')];
                end
            end
            % Heart Rate
            try
                if size(SleepTransitionsEKG.(SleepTransition_time{time}).(Zones{zones}).(Mouse_names{mouse}).HR_Interp,2)==1
                    all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR=[all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR ; SleepTransitionsEKG.(SleepTransition_time{time}).(Zones{zones}).(Mouse_names{mouse}).HR_Interp'];
                else
                    all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR=[all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR ; nanmean(SleepTransitionsEKG.(SleepTransition_time{time}).(Zones{zones}).(Mouse_names{mouse}).HR_Interp')];
                end
            end
            % Heart rate variability
            try
                if size(SleepTransitionsEKG.(SleepTransition_time{time}).(Zones{zones}).(Mouse_names{mouse}).HRVar_Interp,2)==1
                    all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HRVar=[all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HRVar ; SleepTransitionsEKG.(SleepTransition_time{time}).(Zones{zones}).(Mouse_names{mouse}).HRVar_Interp'];
                else
                    all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HRVar=[all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HRVar ; nanmean(SleepTransitionsEKG.(SleepTransition_time{time}).(Zones{zones}).(Mouse_names{mouse}).HRVar_Interp')];
                end
            end
            % Respi InstFreq
            try
                if size(SleepTransitionsEKG.(SleepTransition_time{time}).(Zones{zones}).(Mouse_names{mouse}).Respi_Interp,2)==1
                    all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Respi=[all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Respi ; SleepTransitionsEKG.(SleepTransition_time{time}).(Zones{zones}).(Mouse_names{mouse}).Respi_Interp'];
                else
                    all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Respi=[all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Respi ; nanmean(SleepTransitionsEKG.(SleepTransition_time{time}).(Zones{zones}).(Mouse_names{mouse}).Respi_Interp')];
                end
            end
            % Respi from OB
            try
                if size(SleepTransitionsEKG.(SleepTransition_time{time}).(Zones{zones}).(Mouse_names{mouse}).RespiOB_Interp,2)==1
                    all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).RespiOB=[all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).RespiOB ; SleepTransitionsEKG.(SleepTransition_time{time}).(Zones{zones}).(Mouse_names{mouse}).RespiOB_Interp'];
                else
                    all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).RespiOB=[all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).RespiOB ; nanmean(SleepTransitionsEKG.(SleepTransition_time{time}).(Zones{zones}).(Mouse_names{mouse}).RespiOB_Interp')];
                end
            end
            
        end
    end
end

%% Details, one figure per physiological parameters
FigureResult=MakeFiguresPhysiologicalParameters_Sleep(all_mice_sleepEKG,'Acc',all_mice_sleep_time,Zones);
FigureResult=MakeFiguresPhysiologicalParameters_Sleep(all_mice_sleepEKG,'HR',all_mice_sleep_time,Zones);
FigureResult=MakeFiguresPhysiologicalParameters_Sleep(all_mice_sleepEKG,'HRVar',all_mice_sleep_time,Zones);
FigureResult=MakeFiguresPhysiologicalParameters_Sleep(all_mice_sleepEKG,'Respi',all_mice_sleep_time,Zones);
FigureResult=MakeFiguresPhysiologicalParameters_Sleep(all_mice_sleep,'MTemp',all_mice_sleep_time,Zones);

ylabel('Frequency (Hz)')
title('Heart rate around sleep transitions')
saveFigure(8,'HR_SleepSessions','/home/gruffalo/Desktop/Baptiste_Figures/')

a=ylabel('Frequency (Hz)');
title('Respiratory rate around sleep transitions')
saveFigure(1,'RR_SleepSessions','/home/gruffalo/Desktop/Baptiste_Figures/')


a=ylabel('Normalized Temperature (°C)');
title('Total Body Temperature around sleep transitions')
saveFigure(2,'Temperature_SleepSessions','/home/gruffalo/Desktop/Baptiste_Figures/')


% Normalization of REM episodes
Zones={'NREM_REM_NREM','REM_NREM_REM'};
margins_bef=10;
for zones=1:length(Zones)
    for mouse=1:length(Mouse)
        Episodes= Temperature_FreezingEpisodes3(Mouse(mouse),SleepSessEKG,Zones{zones},margins_bef,'No','No','No','Yes','Yes','Yes','No');
        REM_Episodes.(Zones{zones}).(Mouse_names{mouse})=Episodes; 
    end
end



for zones=1:length(Zones)
all_mice_norm.(Zones{zones}).Acc=[];
all_mice_norm.(Zones{zones}).HR=[];
all_mice_norm.(Zones{zones}).HRVar=[];
all_mice_norm.(Zones{zones}).Respi=[];
    for mouse=1:length(Mouse_names)
        % Accelero
        try
            if size(REM_Episodes.(Zones{zones}).(Mouse_names{mouse}).AccTogether,1)==1
                all_mice_norm.(Zones{zones}).Acc=[all_mice_norm.(Zones{zones}).Acc ; REM_Episodes.(Zones{zones}).(Mouse_names{mouse}).AccTogether];
            else
                all_mice_norm.(Zones{zones}).Acc=[all_mice_norm.(Zones{zones}).Acc ; nanmean(REM_Episodes.(Zones{zones}).(Mouse_names{mouse}).AccTogether)];
            end
        end
        % Heart Rate
        try
            if size(REM_Episodes.(Zones{zones}).(Mouse_names{mouse}).HRTogether,1)==1
                all_mice_norm.(Zones{zones}).HR=[all_mice_norm.(Zones{zones}).HR ; REM_Episodes.(Zones{zones}).(Mouse_names{mouse}).HRTogether];
            else
                all_mice_norm.(Zones{zones}).HR=[all_mice_norm.(Zones{zones}).HR ; nanmean(REM_Episodes.(Zones{zones}).(Mouse_names{mouse}).HRTogether)];
            end
        end
        % Heart rate variability
        try
            if size(REM_Episodes.(Zones{zones}).(Mouse_names{mouse}).HRVarTogether,1)==1
                all_mice_norm.(Zones{zones}).HRVar=[all_mice_norm.(Zones{zones}).HRVar ; REM_Episodes.(Zones{zones}).(Mouse_names{mouse}).HRVarTogether];
            else
                all_mice_norm.(Zones{zones}).HRVar=[all_mice_norm.(Zones{zones}).HRVar ; nanmean(REM_Episodes.(Zones{zones}).(Mouse_names{mouse}).HRVarTogether)];
            end
        end
        % Respi InstFreq
        try
            if size(REM_Episodes.(Zones{zones}).(Mouse_names{mouse}).RespiTogether,1)==1
                all_mice_norm.(Zones{zones}).Respi=[all_mice_norm.(Zones{zones}).Respi ; REM_Episodes.(Zones{zones}).(Mouse_names{mouse}).RespiTogether];
            else
                all_mice_norm.(Zones{zones}).Respi=[all_mice_norm.(Zones{zones}).Respi ; nanmean(REM_Episodes.(Zones{zones}).(Mouse_names{mouse}).RespiTogether)];
            end
        end
        
    end
end
all_mice_norm.NREM_REM_NREM.Acc(2,:)=NaN;
all_mice_norm.REM_NREM_REM.Acc(3,158)=NaN;
all_mice_norm.REM_NREM_REM.Acc(1,:)=NaN;
all_mice_norm.REM_NREM_REM.HR(6,:)=NaN;

figure
subplot(121)
zones=1;
Conf_Inter=nanstd(all_mice_norm.(Zones{zones}).Acc)/sqrt(size(all_mice_norm.(Zones{zones}).Acc,1));
shadedErrorBar([1:margins_bef*10],nanmean(all_mice_norm.(Zones{zones}).Acc(:,1:100)),Conf_Inter(1:100),'-r',1); hold on;
shadedErrorBar([margins_bef*10+1:margins_bef*20],nanmean(all_mice_norm.(Zones{zones}).Acc(:,101:200)),Conf_Inter(1:100),'-g',1); hold on;
shadedErrorBar([margins_bef*20+1:margins_bef*30],nanmean(all_mice_norm.(Zones{zones}).Acc(:,201:300)),Conf_Inter(1:100),'-r',1); hold on;
ylim([0 16e6])
makepretty
subplot(122)
zones=2;
Conf_Inter=nanstd(all_mice_norm.(Zones{zones}).Acc)/sqrt(size(all_mice_norm.(Zones{zones}).Acc,1));
shadedErrorBar([1:margins_bef*10],nanmean(all_mice_norm.(Zones{zones}).Acc(:,1:100)),Conf_Inter(1:100),'-g',1); hold on;
shadedErrorBar([margins_bef*10+1:margins_bef*20],nanmean(all_mice_norm.(Zones{zones}).Acc(:,101:200)),Conf_Inter(1:100),'-r',1); hold on;
shadedErrorBar([margins_bef*20+1:margins_bef*30],nanmean(all_mice_norm.(Zones{zones}).Acc(:,201:300)),Conf_Inter(1:100),'-g',1); hold on;
ylim([0 16e6])
makepretty
a=suptitle('Accelerometer'); a.FontSize=20;

figure
subplot(121)
zones=1;
Conf_Inter=nanstd(all_mice_norm.(Zones{zones}).HR)/sqrt(size(all_mice_norm.(Zones{zones}).HR,1));
shadedErrorBar([1:margins_bef*10],nanmean(all_mice_norm.(Zones{zones}).HR(:,1:100)),Conf_Inter(1:100),'-r',1); hold on;
shadedErrorBar([margins_bef*10+1:margins_bef*20],nanmean(all_mice_norm.(Zones{zones}).HR(:,101:200)),Conf_Inter(1:100),'-g',1); hold on;
shadedErrorBar([margins_bef*20+1:margins_bef*30],nanmean(all_mice_norm.(Zones{zones}).HR(:,201:300)),Conf_Inter(1:100),'-r',1); hold on;
ylim([7 9.5])
makepretty
subplot(122)
zones=2;
Conf_Inter=nanstd(all_mice_norm.(Zones{zones}).HR)/sqrt(size(all_mice_norm.(Zones{zones}).HR,1));
shadedErrorBar([1:margins_bef*10],nanmean(all_mice_norm.(Zones{zones}).HR(:,1:100)),Conf_Inter(1:100),'-g',1); hold on;
shadedErrorBar([margins_bef*10+1:margins_bef*20],nanmean(all_mice_norm.(Zones{zones}).HR(:,101:200)),Conf_Inter(1:100),'-r',1); hold on;
shadedErrorBar([margins_bef*20+1:margins_bef*30],nanmean(all_mice_norm.(Zones{zones}).HR(:,201:300)),Conf_Inter(1:100),'-g',1); hold on;
ylim([7 9.5])
makepretty
a=suptitle('Heart rate'); a.FontSize=20;

figure
subplot(121)
zones=1;
Conf_Inter=nanstd(all_mice_norm.(Zones{zones}).Respi)/sqrt(size(all_mice_norm.(Zones{zones}).Respi,1));
shadedErrorBar([1:margins_bef*10],nanmean(all_mice_norm.(Zones{zones}).Respi(:,1:100)),Conf_Inter(1:100),'-r',1); hold on;
shadedErrorBar([margins_bef*10+1:margins_bef*20],nanmean(all_mice_norm.(Zones{zones}).Respi(:,101:200)),Conf_Inter(1:100),'-g',1); hold on;
shadedErrorBar([margins_bef*20+1:margins_bef*30],nanmean(all_mice_norm.(Zones{zones}).Respi(:,201:300)),Conf_Inter(1:100),'-r',1); hold on;
%ylim([7 9.5])
makepretty
subplot(122)
zones=2;
Conf_Inter=nanstd(all_mice_norm.(Zones{zones}).Respi)/sqrt(size(all_mice_norm.(Zones{zones}).Respi,1));
shadedErrorBar([1:margins_bef*10],nanmean(all_mice_norm.(Zones{zones}).Respi(:,1:100)),Conf_Inter(1:100),'-g',1); hold on;
shadedErrorBar([margins_bef*10+1:margins_bef*20],nanmean(all_mice_norm.(Zones{zones}).Respi(:,101:200)),Conf_Inter(1:100),'-r',1); hold on;
shadedErrorBar([margins_bef*20+1:margins_bef*30],nanmean(all_mice_norm.(Zones{zones}).Respi(:,201:300)),Conf_Inter(1:100),'-g',1); hold on;
ylim([7 9.5])
makepretty
a=suptitle('Respi'); a.FontSize=20;





% Significant results: MakeFigurePhysiologicalParamsSleepDetailled


%% Transitions study, all in a figure
% Wake / NREM
figure
% time window = 20s
time=1; zones=1;
subplot(8,4,1)
Conf_Inter=nanstd(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Acc)/sqrt(size(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Acc,1));
shadedErrorBar([1:50],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Acc(:,1:50)),Conf_Inter(1:50),{'-b','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Acc(:,51:100)),Conf_Inter(51:100),{'-r','Linewidth',2},1); hold on
f=get(gca,'Children');
a=legend([f(8),f(4)],'Wake','NREM'); a.Position=[0.2424 0.8234 0.0389 0.0322];
a=ylabel('Movement quantity'); a.Position=[-6.607 -1e7 -1.0000]
vline(50,'--r');
xticklabels({'','','','','',''})
makepretty
a=title('Wake & NREM, Window = 20s'); a.Position=[50.0001 5.2e+07 1.4211e-14];
ylim([0 4e7])
subplot(8,4,5)
zones=3;
Conf_Inter=nanstd(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Acc)/sqrt(size(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Acc,1));
shadedErrorBar([1:50],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Acc(:,1:50)),Conf_Inter(1:50),{'-r','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Acc(:,51:100)),Conf_Inter(51:100),{'-b','Linewidth',2},1); hold on
makepretty
xticklabels({'-10','-6','-2','2','6','10'})
vline(50,'--r');
txt = 'Accelerometer';
b=text(-25,0e8,txt,'FontSize',24)
set(b,'Rotation',90);

subplot(8,4,9)
zones=1;
Conf_Inter=nanstd(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR)/sqrt(size(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR,1));
shadedErrorBar([1:50],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR(:,1:50)),Conf_Inter(1:50),{'-b','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR(:,51:100)),Conf_Inter(51:100),{'-r','Linewidth',2},1); hold on
xticklabels({'','','','','',''})
a=ylabel('Frequency (Hz)'); a.Position=[-6.607 6 -1.0000]
%ylim([7.5 10.5]);
vline(50,'--r');
makepretty
subplot(8,4,13)
zones=3;
Conf_Inter=nanstd(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR)/sqrt(size(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR,1));
shadedErrorBar([1:50],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR(:,1:50)),Conf_Inter(1:50),{'-r','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR(:,51:100)),Conf_Inter(51:100),{'-b','Linewidth',2},1); hold on
makepretty
xticklabels({'-10','-6','-2','2','6','10'})
%ylim([7.5 10.5]);
vline(50,'--r');
txt = 'Heart Rate';
b=text(-25,8.5,txt,'FontSize',24)
set(b,'Rotation',90);

subplot(8,4,17)
zones=1;
Conf_Inter=nanstd(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Respi)/sqrt(size(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Acc,1));
shadedErrorBar([1:50],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,1:50)),Conf_Inter(1:50),{'-b','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,51:100)),Conf_Inter(51:100),{'-r','Linewidth',2},1); hold on
xticklabels({'','','','','',''})
a=ylabel('Frequency (Hz)'); a.Position=[-14.607 2 -1.0000]
%ylim([3 7]);
vline(50,'--r');
makepretty
subplot(8,4,21)
zones=3;
Conf_Inter=nanstd(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Respi)/sqrt(size(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Acc,1));
shadedErrorBar([1:50],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,1:50)),Conf_Inter(1:50),{'-r','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,51:100)),Conf_Inter(51:100),{'-b','Linewidth',2},1); hold on
makepretty
xticklabels({'-10','-6','-2','2','6','10'})
%ylim([3 7]);
vline(50,'--r');
txt = 'Respiratory Rate';
b=text(-25,3,txt,'FontSize',20)
set(b,'Rotation',90);

subplot(8,4,25)
zones=1;
MTempMinusMean=all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp;
Conf_Inter=nanstd(MTempMinusMean)/sqrt(size(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp,1));
shadedErrorBar([1:50],nanmean(MTempMinusMean(:,1:50)),Conf_Inter(1:50),{'-b','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(MTempMinusMean(:,51:100)),Conf_Inter(51:100),{'-r','Linewidth',2},1); hold on
xticklabels({'','','','','',''})
%ylim([-0.2 0.2]);
vline(50,'--r');
a=ylabel('Normalized Temperature (°C)'); a.Position=[-15.807 -0.30 -1.0000]; a.FontSize=15;
makepretty
subplot(8,4,29)
zones=3;
MTempMinusMean=all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp;
Conf_Inter=nanstd(MTempMinusMean)/sqrt(size(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp,1));
shadedErrorBar([1:50],nanmean(MTempMinusMean(:,1:50)),Conf_Inter(1:50),{'-r','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(MTempMinusMean(:,51:100)),Conf_Inter(51:100),{'-b','Linewidth',2},1); hold on
makepretty
xticklabels({'-10','-6','-2','2','6','10'})
%ylim([-0.2 0.2]);
vline(50,'--r');
b=text(-25,-0.5,'Total Body Temperature','FontSize',18)
set(b,'Rotation',90);

% Sleep, NREM-REM
time=1; zones=2;
subplot(8,4,2)
Conf_Inter=nanstd(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Acc)/sqrt(size(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Acc,1));
shadedErrorBar([1:50],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Acc(:,1:50)),Conf_Inter(1:50),{'-r','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Acc(:,51:100)),Conf_Inter(51:100),{'-g','Linewidth',2},1); hold on
ylim([0 4e7]);
f=get(gca,'Children');
a=title('NREM & REM, Window = 20s'); a.Position=[50.0001 4.8882e+07 1.4211e-14];
a=legend([f(8),f(4)],'NREM','REM'); a.Position=[0.37 0.9 0.038 0.03]
xticklabels({'','','','','',''})
vline(50,'--r');
makepretty
subplot(8,4,6)
zones=4;
ylim([0 5e7]);
Conf_Inter=nanstd(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Acc)/sqrt(size(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Acc,1));
shadedErrorBar([1:50],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Acc(:,1:50)),Conf_Inter(1:50),{'-g','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Acc(:,51:100)),Conf_Inter(51:100),{'-r','Linewidth',2},1); hold on
makepretty
xticklabels({'-10','-6','-2','2','6','10'})
vline(50,'--r');

subplot(8,4,10)
zones=2;
Conf_Inter=nanstd(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR)/sqrt(size(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR,1));
shadedErrorBar([1:50],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR(:,1:50)),Conf_Inter(1:50),{'-r','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR(:,51:100)),Conf_Inter(51:100),{'-g','Linewidth',2},1); hold on
xticklabels({'','','','','',''})
%ylim([7.5 10.5]);
vline(50,'--r');
makepretty
subplot(8,4,14)
zones=4;
Conf_Inter=nanstd(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR)/sqrt(size(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR,1));
shadedErrorBar([1:50],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR(:,1:50)),Conf_Inter(1:50),{'-g','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR(:,51:100)),Conf_Inter(51:100),{'-r','Linewidth',2},1); hold on
makepretty
xticklabels({'-10','-6','-2','2','6','10'})
%ylim([7.5 10.5]);
vline(50,'--r');

subplot(8,4,18)
zones=2;
Conf_Inter=nanstd(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Respi)/sqrt(size(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Acc,1));
shadedErrorBar([1:50],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,1:50)),Conf_Inter(1:50),{'-r','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,51:100)),Conf_Inter(51:100),{'-g','Linewidth',2},1); hold on
xticklabels({'','','','','',''})
%ylim([3 8]);
vline(50,'--r');
makepretty
subplot(8,4,22)
zones=4;
Conf_Inter=nanstd(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Respi)/sqrt(size(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Acc,1));
shadedErrorBar([1:50],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,1:50)),Conf_Inter(1:50),{'-g','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,51:100)),Conf_Inter(51:100),{'-r','Linewidth',2},1); hold on
makepretty
xticklabels({'-10','-6','-2','2','6','10'})
%ylim([3 8]);
vline(50,'--r');

subplot(8,4,26)
zones=2;
MTempMinusMean=all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp;
Conf_Inter=nanstd(MTempMinusMean)/sqrt(size(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp,1));
shadedErrorBar([1:50],nanmean(MTempMinusMean(:,1:50)),Conf_Inter(1:50),{'-r','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(MTempMinusMean(:,51:100)),Conf_Inter(51:100),{'-g','Linewidth',2},1); hold on
xticklabels({'','','','','',''})
%ylim([-0.2 0.2]);
vline(50,'--r');
makepretty
subplot(8,4,30)
zones=4;
MTempMinusMean=all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp;
Conf_Inter=nanstd(MTempMinusMean)/sqrt(size(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp,1));
shadedErrorBar([1:50],nanmean(MTempMinusMean(:,1:50)),Conf_Inter(1:50),{'-g','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(MTempMinusMean(:,51:100)),Conf_Inter(51:100),{'-r','Linewidth',2},1); hold on
makepretty
xticklabels({'-10','-6','-2','2','6','10'})
%ylim([-0.2 0.2]);
vline(50,'--r');

% Time window = 300s
% Sleep, Wake NREM
time=2; zones=1;
subplot(8,4,3)
Conf_Inter=nanstd(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Acc)/sqrt(size(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).MTemp,1));
shadedErrorBar([1:50],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Acc(:,1:50)),Conf_Inter(1:50),{'-b','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Acc(:,51:100)),Conf_Inter(51:100),{'-r','Linewidth',2},1); hold on
ylim([0 1e8]);
a=title('Wake & NREM, Window = 10 min'); a.Position=[50.0001 12.382e+07 1.4211e-14];
xticklabels({'','','','','',''})
vline(50,'--r');
makepretty
subplot(8,4,7)
zones=3;
Conf_Inter=nanstd(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Acc)/sqrt(size(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).MTemp,1));
shadedErrorBar([1:50],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Acc(:,1:50)),Conf_Inter(1:50),{'-r','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Acc(:,51:100)),Conf_Inter(51:100),{'-b','Linewidth',2},1); hold on
makepretty
xticklabels({'-5','-3','-1','1','3','5'})
vline(50,'--r');

subplot(8,4,11)
zones=1;
Conf_Inter=nanstd(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR)/sqrt(size(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR,1));
shadedErrorBar([1:50],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR(:,1:50)),Conf_Inter(1:50),{'-b','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR(:,51:100)),Conf_Inter(51:100),{'-r','Linewidth',2},1); hold on
xticklabels({'','','','','',''})
ylim([7 12]);
vline(50,'--r');
makepretty
subplot(8,4,15)
zones=3;
Conf_Inter=nanstd(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR)/sqrt(size(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR,1));
shadedErrorBar([1:50],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR(:,1:50)),Conf_Inter(1:50),{'-r','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR(:,51:100)),Conf_Inter(51:100),{'-b','Linewidth',2},1); hold on
makepretty
xticklabels({'-5','-3','-1','1','3','5'})
ylim([7 12]);
vline(50,'--r');

subplot(8,4,19)
zones=1;
Conf_Inter=nanstd(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Respi)/sqrt(size(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).MTemp,1));
shadedErrorBar([1:50],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,1:50)),Conf_Inter(1:50),{'-b','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,51:100)),Conf_Inter(51:100),{'-r','Linewidth',2},1); hold on
xticklabels({'','','','','',''})
ylim([3 8]);
vline(50,'--r');
makepretty
subplot(8,4,23)
zones=3;
Conf_Inter=nanstd(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Respi)/sqrt(size(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).MTemp,1));
shadedErrorBar([1:50],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,1:50)),Conf_Inter(1:50),{'-r','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,51:100)),Conf_Inter(51:100),{'-b','Linewidth',2},1); hold on
makepretty
xticklabels({'-5','-3','-1','1','3','5'})
ylim([2 9]);
vline(50,'--r');

subplot(8,4,27)
zones=1;
MTempMinusMean=all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp
Conf_Inter=nanstd(MTempMinusMean)/sqrt(size(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp,1));
shadedErrorBar([1:50],nanmean(MTempMinusMean(:,1:50)),Conf_Inter(1:50),{'-b','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(MTempMinusMean(:,51:100)),Conf_Inter(51:100),{'-r','Linewidth',2},1); hold on
xticklabels({'','','','','',''})
ylim([-0.5 0.7]);
vline(50,'--r');
makepretty
;
subplot(8,4,31)
zones=3;
MTempMinusMean=all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp
Conf_Inter=nanstd(MTempMinusMean)/sqrt(size(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp,1));
shadedErrorBar([1:50],nanmean(MTempMinusMean(:,1:50)),Conf_Inter(1:50),{'-r','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(MTempMinusMean(:,51:100)),Conf_Inter(51:100),{'-b','Linewidth',2},1); hold on
makepretty
xticklabels({'-5','-3','-1','1','3','5'})
ylim([-0.5 0.7]);
vline(50,'--r');
;

% Sleep, NREM-REM
zones=2; time=2;
subplot(8,4,4)
Conf_Inter=nanstd(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Acc)/sqrt(size(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).MTemp,1));
shadedErrorBar([1:50],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Acc(:,1:50)),Conf_Inter(1:50),{'-r','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Acc(:,51:100)),Conf_Inter(51:100),{'-g','Linewidth',2},1); hold on
a=title('NREM & REM, Window = 10 min'); a.Position=[50.0001 2.3882e+07 1.4211e-14];
xticklabels({'','','','','',''})
vline(50,'--r');
makepretty
;
subplot(8,4,8)
zones=4;
Conf_Inter=nanstd(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Acc)/sqrt(size(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).MTemp,1));
shadedErrorBar([1:50],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Acc(:,1:50)),Conf_Inter(1:50),{'-g','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Acc(:,51:100)),Conf_Inter(51:100),{'-r','Linewidth',2},1); hold on
makepretty
xticklabels({'-5','-3','-1','1','3','5'})
vline(50,'--r');
;

subplot(8,4,12)
zones=2;
Conf_Inter=nanstd(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR)/sqrt(size(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR,1));
shadedErrorBar([1:50],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR(:,1:50)),Conf_Inter(1:50),{'-r','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR(:,51:100)),Conf_Inter(51:100),{'-g','Linewidth',2},1); hold on
xticklabels({'','','','','',''})
vline(50,'--r');
makepretty
;
subplot(8,4,16)
zones=4;
Conf_Inter=nanstd(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR)/sqrt(size(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR,1));
shadedErrorBar([1:50],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR(:,1:50)),Conf_Inter(1:50),{'-g','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR(:,51:100)),Conf_Inter(51:100),{'-r','Linewidth',2},1); hold on
makepretty
xticklabels({'-5','-3','-1','1','3','5'})
vline(50,'--r');
;

subplot(8,4,20)
zones=2;
Conf_Inter=nanstd(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Respi)/sqrt(size(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).MTemp,1));
shadedErrorBar([1:50],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,1:50)),Conf_Inter(1:50),{'-r','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,51:100)),Conf_Inter(51:100),{'-g','Linewidth',2},1); hold on
xticklabels({'','','','','',''})
ylim([29.5 31.5]);
ylim([3 7]);
vline(50,'--r');
makepretty
;
subplot(8,4,24)
zones=4;
Conf_Inter=nanstd(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Respi)/sqrt(size(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp,1));
shadedErrorBar([1:50],nanmean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,1:50)),Conf_Inter(1:50),{'-g','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,51:100)),Conf_Inter(51:100),{'-r','Linewidth',2},1); hold on
makepretty
xticklabels({'-5','-3','-1','1','3','5'})
ylim([3 7]);
vline(50,'--r');
;

subplot(8,4,28)
zones=2;
MTempMinusMean=all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp
Conf_Inter=nanstd(MTempMinusMean)/sqrt(size(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp,1));
shadedErrorBar([1:50],nanmean(MTempMinusMean(:,1:50)),Conf_Inter(1:50),{'-r','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(MTempMinusMean(:,51:100)),Conf_Inter(51:100),{'-g','Linewidth',2},1); hold on
xticklabels({'','','','','',''})
ylim([-0.5 0.5]);
vline(50,'--r');
makepretty
;
subplot(8,4,32)
zones=4;
MTempMinusMean=all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp
Conf_Inter=nanstd(MTempMinusMean)/sqrt(size(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp,1));
shadedErrorBar([1:50],nanmean(MTempMinusMean(:,1:50)),Conf_Inter(1:50),{'-g','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(MTempMinusMean(:,51:100)),Conf_Inter(51:100),{'-r','Linewidth',2},1); hold on
makepretty
xticklabels({'-5','-3','-1','1','3','5'})
ylim([-0.5 0.5]);
vline(50,'--r');
;

a=suptitle('Physiological parameters around states transitions, sleep sessions'); a.FontSize=30;


txt = '--------------------------------------------------------------------------------------------------------------';
b=text(-150,-2,txt,'FontSize',24);
set(b,'Rotation',90);

txt = '-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------';
b=text(-500,2.25,txt,'FontSize',24);

txt = '-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------';
b=text(-500,5.5,txt,'FontSize',24);

txt = '-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------';
b=text(-500,8.75,txt,'FontSize',24);


saveFigure(1,'Physiological_Params_SumUp_SleepSessions','/home/mobsmorty/Desktop/Baptiste/FiguresForSophie/')
