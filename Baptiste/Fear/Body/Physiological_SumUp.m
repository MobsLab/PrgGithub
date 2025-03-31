%% Physiological sum up

%% PAG

%Sess names
Mouse=[490 507 508 509 510 512 514];
for mouse = 1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    Sess.(Mouse_names{mouse}) = GetAllMouseTaskSessions(Mouse(mouse));
    CondSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Cond')))));
end

% Generate Data
Zones={'Stim','FreezingOnset','ShockOnset'};
for zones=1:length(Zones)
    for mouse=1:length(Mouse)
        Episodes= Temperature_ShockEpisodes(Mouse(mouse),CondSess,Zones{zones},10,'No','Yes','Yes','Yes','Yes');
        PAGMice.(Zones{zones}).(Mouse_names{mouse})=Episodes;
    end
end

% Gathering all data
clear all_PAG;
for zones=1:length(Zones)
    all_PAG.(Zones{zones}).Speed=[];
    all_PAG.(Zones{zones}).Acc=[];
    all_PAG.(Zones{zones}).Respi=[];
    all_PAG.(Zones{zones}).HR=[];
    all_PAG.(Zones{zones}).HRVar=[];
    for mouse=1:length(Mouse_names)
        all_PAG.(Zones{zones}).Speed=[all_PAG.(Zones{zones}).Speed ; nanmean(PAGMice.(Zones{zones}).(Mouse_names{mouse}).Speed_Interp')];
        all_PAG.(Zones{zones}).Acc=[all_PAG.(Zones{zones}).Acc ; nanmean(PAGMice.(Zones{zones}).(Mouse_names{mouse}).Acc_Interp')];
        all_PAG.(Zones{zones}).Respi=[all_PAG.(Zones{zones}).Respi; nanmean(PAGMice.(Zones{zones}).(Mouse_names{mouse}).Respi_Interp')];
        all_PAG.(Zones{zones}).HR=[all_PAG.(Zones{zones}).HR ; nanmean(PAGMice.(Zones{zones}).(Mouse_names{mouse}).HR_Interp')];
        all_PAG.(Zones{zones}).HRVar=[all_PAG.(Zones{zones}).HRVar ; nanmean(PAGMice.(Zones{zones}).(Mouse_names{mouse}).HRVar_Interp')];
    end
end


%% EYELIDSHOCKS
clear Sess; clear CondSess;
Mouse_names={'M666','M667','M668','M669','M688','M739','M777','M779','M849','M893'};
Mouse=[666 667 668 669 688 739 777 779 849 893];
for mouse = 1:length(Mouse)
    Sess.(Mouse_names{mouse}) = GetAllMouseTaskSessions(Mouse(mouse));
    CondSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Cond')))));
end
CondSess.M666=[{CondSess.M666{1}} {CondSess.M666{4}} {CondSess.M666{7}} {CondSess.M666{8}}];

Zones={'Stim','FreezingOnset','FreezingOffset','ShockOnset','SafeOnset','ShockOffset','SafeOffset'};
for zones=1:length(Zones)
    for mouse=1:length(Mouse)
        Episodes= Temperature_ShockEpisodes(Mouse(mouse),CondSess,Zones{zones},10,'Yes','Yes','Yes','Yes','Yes');
        On_Offset_Freezing.(Zones{zones}).(Mouse_names{mouse})=Episodes;
    end
end

clear all_mice_onset; 
for zones=1:length(Zones)
%Gathering all episodes in an array
    all_mice_onset.(Zones{zones}).TTemp=[];
    all_mice_onset.(Zones{zones}).MTemp=[];
    all_mice_onset.(Zones{zones}).Respi=[];
    all_mice_onset.(Zones{zones}).HR=[];
    all_mice_onset.(Zones{zones}).HRVar=[];
    all_mice_onset.(Zones{zones}).Speed=[];
    all_mice_onset.(Zones{zones}).Acc=[];
        for mouse=1:length(Mouse_names)
            all_mice_onset.(Zones{zones}).TTemp=[all_mice_onset.(Zones{zones}).TTemp ; nanmean(On_Offset_Freezing.(Zones{zones}).(Mouse_names{mouse}).TTemp_Interp')];
            all_mice_onset.(Zones{zones}).MTemp=[all_mice_onset.(Zones{zones}).MTemp ; nanmean(On_Offset_Freezing.(Zones{zones}).(Mouse_names{mouse}).MTemp_Interp')];
            all_mice_onset.(Zones{zones}).Respi=[all_mice_onset.(Zones{zones}).Respi; nanmean(On_Offset_Freezing.(Zones{zones}).(Mouse_names{mouse}).Respi_Interp')];
            all_mice_onset.(Zones{zones}).HR=[all_mice_onset.(Zones{zones}).HR ; nanmean(On_Offset_Freezing.(Zones{zones}).(Mouse_names{mouse}).HR_Interp')];
            all_mice_onset.(Zones{zones}).HRVar=[all_mice_onset.(Zones{zones}).HRVar ; nanmean(On_Offset_Freezing.(Zones{zones}).(Mouse_names{mouse}).HRVar_Interp')];
            all_mice_onset.(Zones{zones}).Speed=[all_mice_onset.(Zones{zones}).Speed ; nanmean(On_Offset_Freezing.(Zones{zones}).(Mouse_names{mouse}).Speed_Interp')];
            all_mice_onset.(Zones{zones}).Acc=[all_mice_onset.(Zones{zones}).Acc ; nanmean(On_Offset_Freezing.(Zones{zones}).(Mouse_names{mouse}).Acc_Interp')];
        end
    all_mice_onset.(Zones{zones}).HR([5 8 10],:)=NaN;
end



%% Wake NREM REM
Mouse_names={'M688','M739','M777','M779','M849','M893'};
Mouse=[688 739 777 779 849 893];
for mouse = 1:length(Mouse_names)
    Sess.(Mouse_names{mouse}) = GetAllMouseTaskSessions(Mouse(mouse));
    SleepSess.(Mouse_names{mouse}) =Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Sleep')))));
end

Zones={'Wake_NREM','NREM_REM','NREM_Wake','REM_NREM'};
SleepTransition_time={'SleepTransition10','SleepTransition300'};
SleepTransition_times=[10 300];
for time=1:length(SleepTransition_time)
    for zones=1:length(Zones)
        for mouse=1:length(Mouse)
            Episodes= Temperature_ShockEpisodes(Mouse(mouse),SleepSess,Zones{zones},SleepTransition_times(time),'Yes','Yes','No','Yes','Yes');
            SleepTransitions.(SleepTransition_time{time}).(Zones{zones}).(Mouse_names{mouse})=Episodes;
        end
    end
end

clear all_mice_sleep;
all_mice_sleep_time={'all_mice_sleep10','all_mice_sleep300'};
Zones={'Wake_NREM','NREM_REM','NREM_Wake','REM_NREM'};
for time=1:length(all_mice_sleep_time)
    for zones=1:length(Zones)
        %Gathering all episodes in an array
        all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp=[];
        all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Respi=[];
        all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Acc=[];
        for mouse=1:length(Mouse_names)
            try
                all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp=[all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp ; nanmean(SleepTransitions.(SleepTransition_time{time}).(Zones{zones}).(Mouse_names{mouse}).MTemp_Interp')];
            end
            try
                all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Respi=[all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Respi; nanmean(SleepTransitions.(SleepTransition_time{time}).(Zones{zones}).(Mouse_names{mouse}).Respi_Interp')];
            end
            try
                all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Acc=[all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Acc ; nanmean(SleepTransitions.(SleepTransition_time{time}).(Zones{zones}).(Mouse_names{mouse}).Acc_Interp')];
            end
        end
    end
end

for mouse=1:length(Mouse_names)
    MeanMTempPerMice.(Mouse_names{mouse})=nanmean(Data(ConcatenateDataFromFolders_SB(SleepSess.(Mouse_names{mouse}),'masktemperature')));
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

% More EKG
Mouse_names={,'M739','M777','M849','M1001','M1002','M1005','M1006'};
Mouse=[739 777 849 1001 1002 1005 1006];
for mouse = 1:length(Mouse_names)
    Sess.(Mouse_names{mouse}) = GetAllMouseTaskSessions(Mouse(mouse));
    SleepSessEKG.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Sleep')))));
end

Zones={'Wake_NREM','NREM_REM','NREM_Wake','REM_NREM'};
SleepTransition_time={'SleepTransition10','SleepTransition300'};
SleepTransition_times=[10 300];
for time=1:length(SleepTransition_time)
    for zones=1:length(Zones)
        for mouse=1:length(Mouse)
            Episodes= Temperature_ShockEpisodes(Mouse(mouse),SleepSessEKG,Zones{zones},SleepTransition_times(time),'No','Yes','No','No','Yes');
            SleepTransitionsEKG.(SleepTransition_time{time}).(Zones{zones}).(Mouse_names{mouse})=Episodes;
        end
    end
end

clear all_mice_sleepEKG;
all_mice_sleep_time={'all_mice_sleep10','all_mice_sleep300'};
Zones={'Wake_NREM','NREM_REM','NREM_Wake','REM_NREM'};
for time=1:length(all_mice_sleep_time)
    for zones=1:length(Zones)
        %Gathering all episodes in an array
        all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR=[];
        all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HRVar=[];
        for mouse=1:length(Mouse_names)
             try
                all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR=[all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR ; nanmean(SleepTransitionsEKG.(SleepTransition_time{time}).(Zones{zones}).(Mouse_names{mouse}).HR_Interp')];
            end
            try
                all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HRVar=[all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HRVar ; nanmean(SleepTransitionsEKG.(SleepTransition_time{time}).(Zones{zones}).(Mouse_names{mouse}).HRVar_Interp')];
            end
        end
    end
end


%% PLOT
% Shocks
figure
a=suptitle('Physiological parameters around states transitions, Window = 20 s'); a.FontSize=30;

subplot(5,5,1)
Conf_Inter=nanstd(all_PAG.Stim.Acc)/sqrt(size(all_PAG.Stim.Acc,1));
shadedErrorBar([1:100],nanmean(all_PAG.Stim.Acc),Conf_Inter,{'Color',[0.4940, 0.1840, 0.5560],'Linewidth',2},1); hold on
Conf_Inter=nanstd(all_mice_onset.Stim.Acc)/sqrt(size(all_mice_onset.Stim.Acc,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.Stim.Acc),Conf_Inter,{'Color',[0.8500, 0.3250, 0.0980],'Linewidth',2},1); hold on
ylim([0 5e8]);
ylabel('Movement quantity')
f=get(gca,'Children');
a=legend([f(4),f(8)],'Eyelidshocks','PAG stimulation'); a.Position=[0.1978 0.8840 0.0705 0.0312]
makepretty
txt = 'Accelerometer';
b=text(-25,-1e8,txt,'FontSize',24)
set(b,'Rotation',90);
xticklabels({'-10s','0','10s'})
vline(50,'--r');
a=title('Aversive stimulation'); a.Position=[50.0001 5.6183e+08 0];

subplot(5,5,6)
Conf_Inter=nanstd(all_PAG.Stim.HR)/sqrt(size(all_PAG.Stim.HR,1));
shadedErrorBar([1:100],nanmean(all_PAG.Stim.HR),Conf_Inter,{'Color',[0.4940, 0.1840, 0.5560],'Linewidth',2},1); hold on
Conf_Inter=nanstd(all_mice_onset.Stim.HR)/sqrt(size(all_mice_onset.Stim.Acc,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.Stim.HR),Conf_Inter,{'Color',[0.8500, 0.3250, 0.0980],'Linewidth',2},1); hold on
ylabel('Frequency (Hz)')
ylim([10 14]);
makepretty
txt = 'Heart Rate';
b=text(-25,9.5,txt,'FontSize',24)
set(b,'Rotation',90);
xticklabels({'-10s','0','10s'})
vline(50,'--r');

subplot(5,5,11)
Conf_Inter=nanstd(all_PAG.Stim.Respi)/sqrt(size(all_PAG.Stim.Respi,1));
shadedErrorBar([1:100],nanmean(all_PAG.Stim.Respi),Conf_Inter,{'Color',[0.4940, 0.1840, 0.5560],'Linewidth',2},1); hold on
Conf_Inter=nanstd(all_mice_onset.Stim.Respi)/sqrt(size(all_mice_onset.Stim.Acc,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.Stim.Respi),Conf_Inter,{'Color',[0.8500, 0.3250, 0.0980],'Linewidth',2},1); hold on
ylabel('Frequency (Hz)')
ylim([5 10]);
makepretty
txt = 'Respiratory Rate';
b=text(-25,5.5,txt,'FontSize',18)
set(b,'Rotation',90);
vline(50,'--r');
xticklabels({'-10s','0','10s'})

subplot(5,5,16)
MTempMinusMean=all_mice_onset.Stim.MTemp-nanmean(all_mice_onset.Stim.MTemp(:,1:50)')';
Conf_Inter=nanstd(MTempMinusMean)/sqrt(size(all_mice_onset.Stim.Acc,1));
shadedErrorBar([1:100],nanmean(MTempMinusMean),Conf_Inter,{'Color',[0.8500, 0.3250, 0.0980],'Linewidth',2},1); hold on
vline(50,'--r');
ylabel('Temperature (°C)')
ylim([-0.5 0.5]);
makepretty
txt = 'Total Body temperature';
b=text(-35,-0.8,txt,'FontSize',18)
set(b,'Rotation',90);
xticklabels({'-10s','0','10s'})

subplot(5,5,21)
TTempMinusMean=all_mice_onset.Stim.TTemp-nanmean(all_mice_onset.Stim.TTemp(:,1:50)')';
Conf_Inter=nanstd(TTempMinusMean)/sqrt(size(all_mice_onset.Stim.Acc,1));
shadedErrorBar([1:100],nanmean(TTempMinusMean),Conf_Inter,{'Color',[0.8500, 0.3250, 0.0980],'Linewidth',2},1); hold on
vline(50,'--r');
ylabel('Temperature (°C)')
ylim([-1 1]);
makepretty
txt = 'Tail temperature';
b=text(-25,-0.8,txt,'FontSize',18)
set(b,'Rotation',90);
xticklabels({'-10s','0','10s'})

% Freezing Onset
subplot(5,5,2)
Conf_Inter=nanstd(all_PAG.FreezingOnset.Acc)/sqrt(size(all_PAG.FreezingOnset.Acc,1));
shadedErrorBar([1:100],nanmean(all_PAG.FreezingOnset.Acc),Conf_Inter,{'Color',[0.4940, 0.1840, 0.5560],'Linewidth',2},1); hold on
Conf_Inter=nanstd(all_mice_onset.FreezingOnset.Acc)/sqrt(size(all_mice_onset.FreezingOnset.Acc,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.FreezingOnset.Acc),Conf_Inter,{'Color',[0.8500, 0.3250, 0.0980],'Linewidth',2},1); hold on
ylim([0 4e7]);
ylabel('Movement quantity')
f=get(gca,'Children');
legend([f(8),f(4)],'Freezing Onset Eyelidshock','Freezing Onset PAG')
makepretty
xticklabels({'-10s','0','10s'})
ylim([0 5e7]);
vline(50,'--r');
a=title('Freezing Onset (stim)'); a.Position=[50.0001 5.5183e+07 0];

subplot(5,5,7)
Conf_Inter=nanstd(all_PAG.FreezingOnset.HR)/sqrt(size(all_PAG.FreezingOnset.HR,1));
shadedErrorBar([1:100],nanmean(all_PAG.FreezingOnset.HR),Conf_Inter,{'Color',[0.4940, 0.1840, 0.5560],'Linewidth',2},1); hold on
Conf_Inter=nanstd(all_mice_onset.FreezingOnset.HR)/sqrt(size(all_mice_onset.FreezingOnset.HR,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.FreezingOnset.HR),Conf_Inter,{'Color',[0.8500, 0.3250, 0.0980],'Linewidth',2},1); hold on
ylabel('Frequency (Hz)')
ylim([10.5 13]);
makepretty
xticklabels({'-10s','0','10s'})
vline(50,'--r');

subplot(5,5,12)
Conf_Inter=nanstd(all_PAG.FreezingOnset.Respi)/sqrt(size(all_PAG.FreezingOnset.Respi,1));
shadedErrorBar([1:100],nanmean(all_PAG.FreezingOnset.Respi),Conf_Inter,{'Color',[0.4940, 0.1840, 0.5560],'Linewidth',2},1); hold on
Conf_Inter=nanstd(all_mice_onset.FreezingOnset.Respi)/sqrt(size(all_mice_onset.FreezingOnset.Respi,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.FreezingOnset.Respi),Conf_Inter,{'Color',[0.8500, 0.3250, 0.0980],'Linewidth',2},1); hold on
ylabel('Frequency (Hz)')
makepretty
vline(50,'--r');
xticklabels({'-10s','0','10s'})

subplot(5,5,17)
MTempMinusMean=all_mice_onset.FreezingOnset.MTemp-nanmean(all_mice_onset.FreezingOnset.MTemp(:,1:50)')';
Conf_Inter=nanstd(MTempMinusMean)/sqrt(size(all_mice_onset.FreezingOnset.Acc,1));
shadedErrorBar([1:100],nanmean(MTempMinusMean),Conf_Inter,{'Color',[0.8500, 0.3250, 0.0980],'Linewidth',2},1); hold on
ylim([-0.1 0.1]);
vline(50,'--r');
ylabel('Temperature (°C)')
makepretty
xticklabels({'-10s','0','10s'})

subplot(5,5,22)
MTempMinusMean=all_mice_onset.FreezingOnset.TTemp-nanmean(all_mice_onset.FreezingOnset.TTemp(:,1:50)')';
Conf_Inter=nanstd(MTempMinusMean)/sqrt(size(all_mice_onset.FreezingOnset.Acc,1));
shadedErrorBar([1:100],nanmean(MTempMinusMean),Conf_Inter,{'Color',[0.8500, 0.3250, 0.0980],'Linewidth',2},1); hold on
ylim([-1 1]);
vline(50,'--r');
ylabel('Temperature (°C)')
makepretty
xticklabels({'-10s','0','10s'})

% Freezing Offset
subplot(5,5,3)
Conf_Inter=nanstd(all_PAG.FreezingOffset.Acc)/sqrt(size(all_PAG.FreezingOffset.Acc,1));
shadedErrorBar([1:100],nanmean(all_PAG.FreezingOffset.Acc),Conf_Inter,{'Color',[0.4940, 0.1840, 0.5560],'Linewidth',2},1); hold on
Conf_Inter=nanstd(all_mice_onset.FreezingOffset.Acc)/sqrt(size(all_mice_onset.FreezingOffset.Acc,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.FreezingOffset.Acc),Conf_Inter,{'Color',[0.8500, 0.3250, 0.0980],'Linewidth',2},1); hold on
ylim([0 4e7]);
ylabel('Movement quantity')
f=get(gca,'Children');
a=legend([f(8),f(4)],'Freezing Offset Eyelidshock','Freezing Offset PAG'); a.Position=[0.4668 0.8940 0.1074 0.0312]
makepretty
xticklabels({'-10s','0','10s'})
ylim([0 5e7]);
vline(50,'--r');
a=title('Freezing Offset (stim)'); a.Position=[50.0001 5.5183e+07 0];

subplot(5,5,8)
Conf_Inter=nanstd(all_PAG.FreezingOffset.HR)/sqrt(size(all_PAG.FreezingOffset.HR,1));
shadedErrorBar([1:100],nanmean(all_PAG.FreezingOffset.HR),Conf_Inter,{'Color',[0.4940, 0.1840, 0.5560],'Linewidth',2},1); hold on
Conf_Inter=nanstd(all_mice_onset.FreezingOffset.HR)/sqrt(size(all_mice_onset.FreezingOffset.HR,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.FreezingOffset.HR),Conf_Inter,{'Color',[0.8500, 0.3250, 0.0980],'Linewidth',2},1); hold on
ylabel('Frequency (Hz)')
makepretty
ylim([10.5 13]);
xticklabels({'-10s','0','10s'})
vline(50,'--r');

subplot(5,5,13)
Conf_Inter=nanstd(all_PAG.FreezingOffset.Respi)/sqrt(size(all_PAG.FreezingOffset.Respi,1));
shadedErrorBar([1:100],nanmean(all_PAG.FreezingOffset.Respi),Conf_Inter,{'Color',[0.4940, 0.1840, 0.5560],'Linewidth',2},1); hold on
Conf_Inter=nanstd(all_mice_onset.FreezingOffset.Respi)/sqrt(size(all_mice_onset.FreezingOffset.Respi,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.FreezingOffset.Respi),Conf_Inter,{'Color',[0.8500, 0.3250, 0.0980],'Linewidth',2},1); hold on
ylabel('Frequency (Hz)')
makepretty
vline(50,'--r');
xticklabels({'-10s','0','10s'})

subplot(5,5,18)
MTempMinusMean=all_mice_onset.FreezingOffset.MTemp-nanmean(all_mice_onset.FreezingOffset.MTemp(:,1:50)')';
Conf_Inter=nanstd(MTempMinusMean)/sqrt(size(all_mice_onset.FreezingOffset.Acc,1));
shadedErrorBar([1:100],nanmean(MTempMinusMean),Conf_Inter,{'Color',[0.8500, 0.3250, 0.0980],'Linewidth',2},1); hold on
ylim([-0.1 0.2]);
vline(50,'--r');
ylabel('Temperature (°C)')
makepretty
xticklabels({'-10s','0','10s'})

subplot(5,5,23)
MTempMinusMean=all_mice_onset.FreezingOffset.TTemp-nanmean(all_mice_onset.FreezingOffset.TTemp(:,1:50)')';
Conf_Inter=nanstd(MTempMinusMean)/sqrt(size(all_mice_onset.FreezingOffset.Acc,1));
shadedErrorBar([1:100],nanmean(MTempMinusMean),Conf_Inter,{'Color',[0.8500, 0.3250, 0.0980],'Linewidth',2},1); hold on
ylim([-1 1]);
vline(50,'--r');
ylabel('Temperature (°C)')
makepretty
xticklabels({'-10s','0','10s'})

% Freezing Onset zones
subplot(5,5,4)
Conf_Inter=nanstd(all_mice_onset.ShockOnset.Acc)/sqrt(size(all_mice_onset.ShockOnset.Acc,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.ShockOnset.Acc),Conf_Inter,{'Color',[0.6350, 0.0780, 0.1840],'Linewidth',2},1); hold on
Conf_Inter=nanstd(all_mice_onset.SafeOnset.Acc)/sqrt(size(all_mice_onset.SafeOnset.Acc,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.SafeOnset.Acc),Conf_Inter,{'Color',[0, 0.4470, 0.7410],'Linewidth',2},1); hold on
ylim([0 8e7]);
ylabel('Movement quantity')
f=get(gca,'Children');
a=legend([f(8),f(4)],'Onset Freezing Shock','Onset Freezing Safe'); a.Position=[0.6484 0.8940 0.0886 0.0312];
makepretty
xticklabels({'-10s','0','10s'})
ylim([0 1e8]);
vline(50,'--r');
a=title('Freezing Onset (zones)'); a.Position=[50.0001 11.183e+07 0];

subplot(5,5,9)
Conf_Inter=nanstd(all_mice_onset.ShockOnset.HR)/sqrt(size(all_mice_onset.ShockOnset.HR,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.ShockOnset.HR),Conf_Inter,{'Color',[0.6350, 0.0780, 0.1840],'Linewidth',2},1); hold on
Conf_Inter=nanstd(all_mice_onset.SafeOnset.HR)/sqrt(size(all_mice_onset.SafeOnset.HR,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.SafeOnset.HR),Conf_Inter,{'Color',[0, 0.4470, 0.7410],'Linewidth',2},1); hold on
ylabel('Frequency (Hz)')
makepretty
ylim([10.5 13]);
xticklabels({'-10s','0','10s'})
vline(50,'--r');

subplot(5,5,14)
Conf_Inter=nanstd(all_mice_onset.ShockOnset.Respi)/sqrt(size(all_mice_onset.ShockOnset.Respi,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.ShockOnset.Respi),Conf_Inter,{'Color',[0.6350, 0.0780, 0.1840],'Linewidth',2},1); hold on
Conf_Inter=nanstd(all_mice_onset.SafeOnset.Respi)/sqrt(size(all_mice_onset.SafeOnset.Respi,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.SafeOnset.Respi),Conf_Inter,{'Color',[0, 0.4470, 0.7410],'Linewidth',2},1); hold on
ylabel('Frequency (Hz)')
makepretty
vline(50,'--r');
xticklabels({'-10s','0','10s'})

subplot(5,5,19)
MTempMinusMean=all_mice_onset.ShockOnset.MTemp-nanmean(all_mice_onset.ShockOnset.MTemp(:,1:50)')';
Conf_Inter=nanstd(MTempMinusMean)/sqrt(size(all_mice_onset.ShockOnset.Acc,1));
shadedErrorBar([1:100],nanmean(MTempMinusMean),Conf_Inter,{'Color',[0.6350, 0.0780, 0.1840],'Linewidth',2},1); hold on
MTempMinusMean=all_mice_onset.SafeOnset.MTemp-nanmean(all_mice_onset.SafeOnset.MTemp(:,1:50)')';
Conf_Inter=nanstd(MTempMinusMean)/sqrt(size(all_mice_onset.SafeOnset.Acc,1));
shadedErrorBar([1:100],nanmean(MTempMinusMean),Conf_Inter,{'Color',[0, 0.4470, 0.7410],'Linewidth',2},1); hold on
ylim([-0.1 0.2]);
vline(50,'--r');
ylabel('Temperature (°C)')
makepretty
xticklabels({'-10s','0','10s'})

subplot(5,5,24)
MTempMinusMean=all_mice_onset.ShockOnset.TTemp-nanmean(all_mice_onset.ShockOnset.TTemp(:,1:50)')';
Conf_Inter=nanstd(MTempMinusMean)/sqrt(size(all_mice_onset.ShockOnset.Acc,1));
shadedErrorBar([1:100],nanmean(MTempMinusMean),Conf_Inter,{'Color',[0.6350, 0.0780, 0.1840],'Linewidth',2},1); hold on
MTempMinusMean=all_mice_onset.SafeOnset.TTemp-nanmean(all_mice_onset.SafeOnset.TTemp(:,1:50)')';
Conf_Inter=nanstd(MTempMinusMean)/sqrt(size(all_mice_onset.SafeOnset.Acc,1));
shadedErrorBar([1:100],nanmean(MTempMinusMean),Conf_Inter,{'Color',[0, 0.4470, 0.7410],'Linewidth',2},1); hold on
ylim([-1 1.5]);
vline(50,'--r');
ylabel('Temperature (°C)')
makepretty
xticklabels({'-10s','0','10s'})

% Freezing Offset zones
subplot(5,5,5)
Conf_Inter=nanstd(all_mice_onset.ShockOffset.Acc)/sqrt(size(all_mice_onset.ShockOffset.Acc,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.ShockOffset.Acc),Conf_Inter,{'Color',[0.6350, 0.0780, 0.1840],'Linewidth',2},1); hold on
Conf_Inter=nanstd(all_mice_onset.SafeOffset.Acc)/sqrt(size(all_mice_onset.SafeOffset.Acc,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.SafeOffset.Acc),Conf_Inter,{'Color',[0, 0.4470, 0.7410],'Linewidth',2},1); hold on
ylim([0 8e7]);
ylabel('Movement quantity')
f=get(gca,'Children');
b=legend([f(8),f(4)],'Offset Freezing Shock','Offset Freezing Safe'); b.Position=[0.7907 0.8940 0.0890 0.0312]
makepretty
xticklabels({'-10s','0','10s'})
vline(50,'--r');
ylim([0 1e8]);
a=title('Freezing Offset (zones)'); a.Position=[50.0001 11.183e+07 0];

subplot(5,5,10)
Conf_Inter=nanstd(all_mice_onset.ShockOffset.HR)/sqrt(size(all_mice_onset.ShockOffset.HR,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.ShockOffset.HR),Conf_Inter,{'Color',[0.6350, 0.0780, 0.1840],'Linewidth',2},1); hold on
Conf_Inter=nanstd(all_mice_onset.SafeOffset.HR)/sqrt(size(all_mice_onset.SafeOffset.HR,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.SafeOffset.HR),Conf_Inter,{'Color',[0, 0.4470, 0.7410],'Linewidth',2},1); hold on
ylim([10.5 13]);
ylabel('Frequency (Hz)')
makepretty
xticklabels({'-10s','0','10s'})
vline(50,'--r');

subplot(5,5,15)
Conf_Inter=nanstd(all_mice_onset.ShockOffset.Respi)/sqrt(size(all_mice_onset.ShockOffset.Respi,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.ShockOffset.Respi),Conf_Inter,{'Color',[0.6350, 0.0780, 0.1840],'Linewidth',2},1); hold on
Conf_Inter=nanstd(all_mice_onset.SafeOffset.Respi)/sqrt(size(all_mice_onset.SafeOffset.Respi,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.SafeOffset.Respi),Conf_Inter,{'Color',[0, 0.4470, 0.7410],'Linewidth',2},1); hold on
ylabel('Frequency (Hz)')
makepretty
vline(50,'--r');
xticklabels({'-10s','0','10s'})

subplot(5,5,20)
MTempMinusMean=all_mice_onset.ShockOffset.MTemp-nanmean(all_mice_onset.ShockOffset.MTemp(:,1:50)')';
Conf_Inter=nanstd(MTempMinusMean)/sqrt(size(all_mice_onset.ShockOffset.Acc,1));
shadedErrorBar([1:100],nanmean(MTempMinusMean),Conf_Inter,{'Color',[0.6350, 0.0780, 0.1840],'Linewidth',2},1); hold on
MTempMinusMean=all_mice_onset.SafeOffset.MTemp-nanmean(all_mice_onset.SafeOffset.MTemp(:,1:50)')';
Conf_Inter=nanstd(MTempMinusMean)/sqrt(size(all_mice_onset.SafeOffset.Acc,1));
shadedErrorBar([1:100],nanmean(MTempMinusMean),Conf_Inter,{'Color',[0, 0.4470, 0.7410],'Linewidth',2},1); hold on
ylim([-0.2 0.2]);
vline(50,'--r');
ylabel('Temperature (°C)')
makepretty
xticklabels({'-10s','0','10s'})

subplot(5,5,25)
MTempMinusMean=all_mice_onset.ShockOffset.TTemp-nanmean(all_mice_onset.ShockOffset.TTemp(:,1:50)')';
Conf_Inter=nanstd(MTempMinusMean)/sqrt(size(all_mice_onset.ShockOffset.Acc,1));
shadedErrorBar([1:100],nanmean(MTempMinusMean),Conf_Inter,{'Color',[0.6350, 0.0780, 0.1840],'Linewidth',2},1); hold on
MTempMinusMean=all_mice_onset.SafeOffset.TTemp-nanmean(all_mice_onset.SafeOffset.TTemp(:,1:50)')';
Conf_Inter=nanstd(MTempMinusMean)/sqrt(size(all_mice_onset.SafeOffset.Acc,1));
shadedErrorBar([1:100],nanmean(MTempMinusMean),Conf_Inter,{'Color',[0, 0.4470, 0.7410],'Linewidth',2},1); hold on
ylim([-1 1.5]);
vline(50,'--r');
ylabel('Temperature (°C)')
makepretty
xticklabels({'-10s','0','10s'})

saveFigure(2,'Physiological_Params_SumUp_Fear_20s','/home/mobsmorty/Desktop/Baptiste/FiguresForSophie/')

%% PLOT SLEEP
% Sleep, Wake NREM
figure
% time window = 20s
time=1; zones=1;
subplot(8,4,1)
Conf_Inter=nanstd(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Acc)/sqrt(size(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp,1));
shadedErrorBar([1:50],nanmean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Acc(:,1:50)),Conf_Inter(1:50),{'-b','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Acc(:,51:100)),Conf_Inter(51:100),{'-r','Linewidth',2},1); hold on
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
Conf_Inter=nanstd(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Acc)/sqrt(size(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp,1));
shadedErrorBar([1:50],nanmean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Acc(:,1:50)),Conf_Inter(1:50),{'-r','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Acc(:,51:100)),Conf_Inter(51:100),{'-b','Linewidth',2},1); hold on
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
ylim([7.5 10.5]);
vline(50,'--r');
makepretty
subplot(8,4,13)
zones=3;
Conf_Inter=nanstd(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR)/sqrt(size(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR,1));
shadedErrorBar([1:50],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR(:,1:50)),Conf_Inter(1:50),{'-r','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR(:,51:100)),Conf_Inter(51:100),{'-b','Linewidth',2},1); hold on
makepretty
xticklabels({'-10','-6','-2','2','6','10'})
ylim([7.5 10.5]);
vline(50,'--r');
txt = 'Heart Rate';
b=text(-25,8.5,txt,'FontSize',24)
set(b,'Rotation',90);

subplot(8,4,17)
zones=1;
Conf_Inter=nanstd(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Respi)/sqrt(size(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp,1));
shadedErrorBar([1:50],nanmean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,1:50)),Conf_Inter(1:50),{'-b','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,51:100)),Conf_Inter(51:100),{'-r','Linewidth',2},1); hold on
xticklabels({'','','','','',''})
a=ylabel('Frequency (Hz)'); a.Position=[-14.607 2 -1.0000]
ylim([3 7]);
vline(50,'--r');
makepretty
subplot(8,4,21)
zones=3;
Conf_Inter=nanstd(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Respi)/sqrt(size(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp,1));
shadedErrorBar([1:50],nanmean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,1:50)),Conf_Inter(1:50),{'-r','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,51:100)),Conf_Inter(51:100),{'-b','Linewidth',2},1); hold on
makepretty
xticklabels({'-10','-6','-2','2','6','10'})
ylim([3 7]);
vline(50,'--r');
txt = 'Respiratory Rate';
b=text(-25,3,txt,'FontSize',20)
set(b,'Rotation',90);

subplot(8,4,25)
zones=1;
MTempMinusMean=all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp
Conf_Inter=nanstd(MTempMinusMean)/sqrt(size(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp,1));
shadedErrorBar([1:50],nanmean(MTempMinusMean(:,1:50)),Conf_Inter(1:50),{'-b','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(MTempMinusMean(:,51:100)),Conf_Inter(51:100),{'-r','Linewidth',2},1); hold on
xticklabels({'','','','','',''})
ylim([-0.2 0.2]);
vline(50,'--r');
a=ylabel('Normalized Temperature (°C)'); a.Position=[-15.807 -0.30 -1.0000]; a.FontSize=15;
makepretty
subplot(8,4,29)
zones=3;
MTempMinusMean=all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp
Conf_Inter=nanstd(MTempMinusMean)/sqrt(size(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp,1));
shadedErrorBar([1:50],nanmean(MTempMinusMean(:,1:50)),Conf_Inter(1:50),{'-r','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(MTempMinusMean(:,51:100)),Conf_Inter(51:100),{'-b','Linewidth',2},1); hold on
makepretty
xticklabels({'-10','-6','-2','2','6','10'})
ylim([-0.2 0.2]);
vline(50,'--r');
b=text(-25,-0.5,'Total Body Temperature','FontSize',18)
set(b,'Rotation',90);

% Sleep, NREM-REM
time=1; zones=2;
subplot(8,4,2)
Conf_Inter=nanstd(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Acc)/sqrt(size(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp,1));
shadedErrorBar([1:50],nanmean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Acc(:,1:50)),Conf_Inter(1:50),{'-r','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Acc(:,51:100)),Conf_Inter(51:100),{'-g','Linewidth',2},1); hold on
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
Conf_Inter=nanstd(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Acc)/sqrt(size(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp,1));
shadedErrorBar([1:50],nanmean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Acc(:,1:50)),Conf_Inter(1:50),{'-g','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Acc(:,51:100)),Conf_Inter(51:100),{'-r','Linewidth',2},1); hold on
makepretty
xticklabels({'-10','-6','-2','2','6','10'})
vline(50,'--r');

subplot(8,4,10)
zones=2;
Conf_Inter=nanstd(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR)/sqrt(size(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR,1));
shadedErrorBar([1:50],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR(:,1:50)),Conf_Inter(1:50),{'-r','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR(:,51:100)),Conf_Inter(51:100),{'-g','Linewidth',2},1); hold on
xticklabels({'','','','','',''})
ylim([7.5 10.5]);
vline(50,'--r');
;
makepretty
subplot(8,4,14)
zones=4;
Conf_Inter=nanstd(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR)/sqrt(size(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR,1));
shadedErrorBar([1:50],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR(:,1:50)),Conf_Inter(1:50),{'-g','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR(:,51:100)),Conf_Inter(51:100),{'-r','Linewidth',2},1); hold on
makepretty
xticklabels({'-10','-6','-2','2','6','10'})
ylim([7.5 10.5]);
vline(50,'--r');

subplot(8,4,18)
zones=2;
Conf_Inter=nanstd(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Respi)/sqrt(size(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp,1));
shadedErrorBar([1:50],nanmean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,1:50)),Conf_Inter(1:50),{'-r','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,51:100)),Conf_Inter(51:100),{'-g','Linewidth',2},1); hold on
xticklabels({'','','','','',''})
ylim([29.5 31.5]);
ylim([3 8]);
vline(50,'--r');
makepretty
subplot(8,4,22)
zones=4;
Conf_Inter=nanstd(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Respi)/sqrt(size(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp,1));
shadedErrorBar([1:50],nanmean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,1:50)),Conf_Inter(1:50),{'-g','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,51:100)),Conf_Inter(51:100),{'-r','Linewidth',2},1); hold on
makepretty
xticklabels({'-10','-6','-2','2','6','10'})
ylim([3 8]);
vline(50,'--r');

subplot(8,4,26)
zones=2;
MTempMinusMean=all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp
Conf_Inter=nanstd(MTempMinusMean)/sqrt(size(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp,1));
shadedErrorBar([1:50],nanmean(MTempMinusMean(:,1:50)),Conf_Inter(1:50),{'-r','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(MTempMinusMean(:,51:100)),Conf_Inter(51:100),{'-g','Linewidth',2},1); hold on
xticklabels({'','','','','',''})
ylim([-0.2 0.2]);
vline(50,'--r');
makepretty
subplot(8,4,30)
zones=4;
MTempMinusMean=all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp
Conf_Inter=nanstd(MTempMinusMean)/sqrt(size(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp,1));
shadedErrorBar([1:50],nanmean(MTempMinusMean(:,1:50)),Conf_Inter(1:50),{'-g','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(MTempMinusMean(:,51:100)),Conf_Inter(51:100),{'-r','Linewidth',2},1); hold on
makepretty
xticklabels({'-10','-6','-2','2','6','10'})
ylim([-0.2 0.2]);
vline(50,'--r');

% Time window = 300s
% Sleep, Wake NREM
time=2; zones=1;
subplot(8,4,3)
Conf_Inter=nanstd(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Acc)/sqrt(size(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp,1));
shadedErrorBar([1:50],nanmean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Acc(:,1:50)),Conf_Inter(1:50),{'-b','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Acc(:,51:100)),Conf_Inter(51:100),{'-r','Linewidth',2},1); hold on
ylim([0 1e8]);
a=title('Wake & NREM, Window = 10 min'); a.Position=[50.0001 12.382e+07 1.4211e-14];
xticklabels({'','','','','',''})
vline(50,'--r');
makepretty
subplot(8,4,7)
zones=3;
Conf_Inter=nanstd(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Acc)/sqrt(size(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp,1));
shadedErrorBar([1:50],nanmean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Acc(:,1:50)),Conf_Inter(1:50),{'-r','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Acc(:,51:100)),Conf_Inter(51:100),{'-b','Linewidth',2},1); hold on
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
Conf_Inter=nanstd(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Respi)/sqrt(size(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp,1));
shadedErrorBar([1:50],nanmean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,1:50)),Conf_Inter(1:50),{'-b','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,51:100)),Conf_Inter(51:100),{'-r','Linewidth',2},1); hold on
xticklabels({'','','','','',''})
ylim([3 8]);
vline(50,'--r');
makepretty
subplot(8,4,23)
zones=3;
Conf_Inter=nanstd(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Respi)/sqrt(size(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp,1));
shadedErrorBar([1:50],nanmean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,1:50)),Conf_Inter(1:50),{'-r','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,51:100)),Conf_Inter(51:100),{'-b','Linewidth',2},1); hold on
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
Conf_Inter=nanstd(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Acc)/sqrt(size(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp,1));
shadedErrorBar([1:50],nanmean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Acc(:,1:50)),Conf_Inter(1:50),{'-r','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Acc(:,51:100)),Conf_Inter(51:100),{'-g','Linewidth',2},1); hold on
a=title('NREM & REM, Window = 10 min'); a.Position=[50.0001 2.3882e+07 1.4211e-14];
xticklabels({'','','','','',''})
vline(50,'--r');
makepretty
;
subplot(8,4,8)
zones=4;
Conf_Inter=nanstd(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Acc)/sqrt(size(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp,1));
shadedErrorBar([1:50],nanmean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Acc(:,1:50)),Conf_Inter(1:50),{'-g','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Acc(:,51:100)),Conf_Inter(51:100),{'-r','Linewidth',2},1); hold on
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
Conf_Inter=nanstd(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Respi)/sqrt(size(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp,1));
shadedErrorBar([1:50],nanmean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,1:50)),Conf_Inter(1:50),{'-r','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,51:100)),Conf_Inter(51:100),{'-g','Linewidth',2},1); hold on
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



