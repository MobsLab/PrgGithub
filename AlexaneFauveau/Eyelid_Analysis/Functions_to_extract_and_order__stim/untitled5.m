
i=0;
i=i+1;FolderName{i} = '/media/gruffalo/DataMOBS198/2_PiezoEyelidStim/1597_Eyelid_240516_160804/';
i=i+1;FolderName{i} = '/media/gruffalo/DataMOBS198/2_PiezoEyelidStim/1597_Eyelid_240517_111240/';
i=i+1;FolderName{i} = '/media/gruffalo/DataMOBS198/2_PiezoEyelidStim/1597_Eyelid_240517_145901/';
i=i+1;FolderName{i} = '/media/gruffalo/DataMOBS198/2_PiezoEyelidStim/1597_Eyelid_240517_171645/';
i=i+1;FolderName{i} = '/media/gruffalo/DataMOBS198/2_PiezoEyelidStim/1597_Eyelid_240527_131121/';



ligne = 0;
duration_stim = 0.2*1e4;

c1Aw = 1;
c1As = 1;
c15Aw = 1;
c15As = 1;
c2Aw = 1;
c2As = 1;

c1Pw = 1;
c1Ps = 1;
c15Pw = 1;
c15Ps = 1;
c2Pw = 1;
c2Ps = 1;

% Create the Stim Epoch
for i = 1:length(FolderName)

    % Load
    cd(FolderName{i});

    % For Accelero :
    load 'SleepScoring_Accelero.mat' WakeWiNoise SleepWiNoise;
    load 'behavResources.mat' MovAcctsd
    
        % For 1V Wake:
    state = 'wake';
    BoutDurationBeforeStim = 5;  % give in sec
    ValueStim = 1;
    StimWithLongBout = FindEyelidStimWithLongBout_AF(WakeWiNoise,SleepWiNoise,state,BoutDurationBeforeStim,ValueStim);
    PlotOrNot = 0;
    PlotNewfig = 0;
    try
    [M,T] = PlotRipRaw(MovAcctsd,StimWithLongBout,[-20 20]*1e3,0,PlotOrNot,PlotNewfig);
    clear Start_StimWithLongBout
    for l = 1:length(M)
    megaM_1V_accelero_wake_temps(l,c1Aw) = M(l); 
    megaM_1V_accelero_wake_mean(l,c1Aw) = M(l,2);
    megaM_1V_accelero_wake_std(l,c1Aw) = M(l,4);
    end
    c1Aw = c1Aw + 1;
    end

        % For 1V Sleep : 
    state = 'sleep';
    BoutDurationBeforeStim = 5;  % give in sec
    ValueStim = 1;
    StimWithLongBout = FindEyelidStimWithLongBout_AF(WakeWiNoise,SleepWiNoise,state,BoutDurationBeforeStim,ValueStim);
    PlotOrNot = 0;
    PlotNewfig = 0;
    try
    [M,T] = PlotRipRaw(MovAcctsd,StimWithLongBout,[-20 20]*1e3,0,PlotOrNot,PlotNewfig);
    clear Start_StimWithLongBout
    for l = 1:length(M)
    megaM_1V_accelero_sleep_temps(l,c1As) = M(l); 
    megaM_1V_accelero_sleep_mean(l,c1As) = M(l,2);
    megaM_1V_accelero_sleep_std(l,c1As) = M(l,4);
    end
    c1As = c1As + 1;
end
    
        % For 1.5V Wake:
    state = 'wake';
    BoutDurationBeforeStim = 5;  % give in sec
    ValueStim = 1.5;
    StimWithLongBout = FindEyelidStimWithLongBout_AF(WakeWiNoise,SleepWiNoise,state,BoutDurationBeforeStim,ValueStim);
%     Start_StimWithLongBout = Start_StimWithLongBout/1e4
    PlotOrNot = 0;
    PlotNewfig = 0;
    try
    [M,T] = PlotRipRaw(MovAcctsd,StimWithLongBout,[-20 20]*1e3,0,PlotOrNot,PlotNewfig);
    clear Start_StimWithLongBout
    for l = 1:length(M)
    megaM_15V_accelero_wake_temps(l,c15Aw) = M(l); 
    megaM_15V_accelero_wake_mean(l,c15Aw) = M(l,2);
    megaM_15V_accelero_wake_std(l,c15Aw) = M(l,4);
    end
    c15Aw = c15Aw + 1;
end

        % For 1.5V Sleep : 
    state = 'sleep';
    BoutDurationBeforeStim = 5;  % give in sec
    ValueStim = 1.5;
    StimWithLongBout = FindEyelidStimWithLongBout_AF(WakeWiNoise,SleepWiNoise,state,BoutDurationBeforeStim,ValueStim);
%     Start_StimWithLongBout = Start_StimWithLongBout/1e4
    PlotOrNot = 0;
    PlotNewfig = 0;
    try
    [M,T] = PlotRipRaw(MovAcctsd,StimWithLongBout,[-20 20]*1e3,0,PlotOrNot,PlotNewfig);
    clear Start_StimWithLongBout
    for l = 1:length(M)
    megaM_15V_accelero_sleep_temps(l,c15As) = M(l); 
    megaM_15V_accelero_sleep_mean(l,c15As) = M(l,2);
    megaM_15V_accelero_sleep_std(l,c15As) = M(l,4);
    end
    c15As = c15As + 1;
end
    
        % For 2V Wake:
    state = 'wake';
    BoutDurationBeforeStim = 5;  % give in sec
    ValueStim = 2;
    StimWithLongBout = FindEyelidStimWithLongBout_AF(WakeWiNoise,SleepWiNoise,state,BoutDurationBeforeStim,ValueStim);
%     Start_StimWithLongBout = Start_StimWithLongBout/1e4
    PlotOrNot = 0;
    PlotNewfig = 0;
    try
    [M,T] = PlotRipRaw(MovAcctsd,StimWithLongBout,[-20 20]*1e3,0,PlotOrNot,PlotNewfig);
    clear Start_StimWithLongBout
    for l = 1:length(M)
    megaM_2V_accelero_wake_temps(l,c2Aw) = M(l); 
    megaM_2V_accelero_wake_mean(l,c2Aw) = M(l,2);
    megaM_2V_accelero_wake_std(l,c2Aw) = M(l,4);
    end
    c2Aw = c2Aw + 1;
end
    
        % For 2V Sleep : 
    state = 'sleep';
    BoutDurationBeforeStim = 5;  % give in sec
    ValueStim = 2;
    StimWithLongBout = FindEyelidStimWithLongBout_AF(WakeWiNoise,SleepWiNoise,state,BoutDurationBeforeStim,ValueStim);
%     Start_StimWithLongBout = Start_StimWithLongBout/1e4
    PlotOrNot = 0;
    PlotNewfig = 0;
    try
    [M,T] = PlotRipRaw(MovAcctsd,StimWithLongBout,[-20 20]*1e3,0,PlotOrNot,PlotNewfig);
    clear Start_StimWithLongBout
    for l = 1:length(M)
    megaM_2V_accelero_sleep_temps(l,c2As) = M(l); 
    megaM_2V_accelero_sleep_mean(l,c2As) = M(l,2);
    megaM_2V_accelero_sleep_std(l,c2As) = M(l,4);
    end
    c2As = c2As+1;
end
    
    % For Piezo :
load 'PiezoData_SleepScoring.mat' Piezo_Mouse_tsd WakeEpoch_Piezo SleepEpoch_Piezo;

    % For 1V Wake:
state = 'wake';
BoutDurationBeforeStim = 5;  % give in sec
ValueStim = 1;
StimWithLongBout = FindEyelidStimWithLongBout_AF(WakeEpoch_Piezo,SleepEpoch_Piezo,state,BoutDurationBeforeStim,ValueStim);
PlotOrNot = 0;
PlotNewfig = 0;
try
[M,T] = PlotRipRaw(Piezo_Mouse_tsd,StimWithLongBout,[-20 20]*1e3,0,PlotOrNot,PlotNewfig);
clear Start_StimWithLongBout
for l = 1:length(M)
megaM_1V_piezo_wake_temps(l,c1Pw) = M(l); 
megaM_1V_piezo_wake_mean(l,c1Pw) = M(l,2);
megaM_1V_piezo_wake_std(l,c1Pw) = M(l,4);
end
c1Pw = c1Pw +1; 
end

    % For 1V Sleep : 
state = 'sleep';
BoutDurationBeforeStim = 5;  % give in sec
ValueStim = 1;
StimWithLongBout = FindEyelidStimWithLongBout_AF(WakeEpoch_Piezo,SleepEpoch_Piezo,state,BoutDurationBeforeStim,ValueStim);
PlotOrNot = 0;
PlotNewfig = 0;
try
[M,T] = PlotRipRaw(Piezo_Mouse_tsd,StimWithLongBout,[-20 20]*1e3,0,PlotOrNot,PlotNewfig);
clear Start_StimWithLongBout
for l = 1:length(M)
megaM_1V_piezo_sleep_temps(l,c1Ps) = M(l); 
megaM_1V_piezo_sleep_mean(l,c1Ps) = M(l,2);
megaM_1V_piezo_sleep_std(l,c1Ps) = M(l,4);
end
c1Ps = c1Ps+1;
end

    % For 1.5V Wake:
state = 'wake';
BoutDurationBeforeStim = 5;  % give in sec
ValueStim = 1.5;
StimWithLongBout = FindEyelidStimWithLongBout_AF(WakeEpoch_Piezo,SleepEpoch_Piezo,state,BoutDurationBeforeStim,ValueStim);
%     Start_StimWithLongBout = Start_StimWithLongBout/1e4
PlotOrNot = 0;
PlotNewfig = 0;
try
[M,T] = PlotRipRaw(Piezo_Mouse_tsd,StimWithLongBout,[-20 20]*1e3,0,PlotOrNot,PlotNewfig);
clear Start_StimWithLongBout
for l = 1:length(M)
megaM_15V_piezo_wake_temps(l,c15Pw) = M(l); 
megaM_15V_piezo_wake_mean(l,c15Pw) = M(l,2);
megaM_15V_piezo_wake_std(l,c15Pw) = M(l,4);
end
c15Pw = c15Pw+1;
end

    % For 1.5V Sleep : 
state = 'sleep';
BoutDurationBeforeStim = 5;  % give in sec
ValueStim = 1.5;
StimWithLongBout = FindEyelidStimWithLongBout_AF(WakeEpoch_Piezo,SleepEpoch_Piezo,state,BoutDurationBeforeStim,ValueStim);
%     Start_StimWithLongBout = Start_StimWithLongBout/1e4
PlotOrNot = 0;
PlotNewfig = 0;
try
[M,T] = PlotRipRaw(Piezo_Mouse_tsd,StimWithLongBout,[-20 20]*1e3,0,PlotOrNot,PlotNewfig);
clear Start_StimWithLongBout
for l = 1:length(M)
megaM_15V_piezo_sleep_temps(l,c15Ps) = M(l); 
megaM_15V_piezo_sleep_mean(l,c15Ps) = M(l,2);
megaM_15V_piezo_sleep_std(l,c15Ps) = M(l,4);
end
c15Ps = c15Ps+1;
end

    % For 2V Wake:
state = 'wake';
BoutDurationBeforeStim = 5;  % give in sec
ValueStim = 2;
StimWithLongBout = FindEyelidStimWithLongBout_AF(WakeEpoch_Piezo,SleepEpoch_Piezo,state,BoutDurationBeforeStim,ValueStim);
%     Start_StimWithLongBout = Start_StimWithLongBout/1e4
PlotOrNot = 0;
PlotNewfig = 0;
try
[M,T] = PlotRipRaw(Piezo_Mouse_tsd,StimWithLongBout,[-20 20]*1e3,0,PlotOrNot,PlotNewfig);
clear Start_StimWithLongBout
for l = 1:length(M)
megaM_2V_piezo_wake_temps(l,c2Pw) = M(l); 
megaM_2V_piezo_wake_mean(l,c2Pw) = M(l,2);
megaM_2V_piezo_wake_std(l,c2Pw) = M(l,4);
end
c2Pw = c2Pw+1;
end

    % For 2V Sleep : 
state = 'sleep';
BoutDurationBeforeStim = 5;  % give in sec
ValueStim = 2;
StimWithLongBout = FindEyelidStimWithLongBout_AF(WakeEpoch_Piezo,SleepEpoch_Piezo,state,BoutDurationBeforeStim,ValueStim);
%     Start_StimWithLongBout = Start_StimWithLongBout/1e4
PlotOrNot = 0;
PlotNewfig = 0;
try
[M,T] = PlotRipRaw(Piezo_Mouse_tsd,StimWithLongBout,[-20 20]*1e3,0,PlotOrNot,PlotNewfig);
clear Start_StimWithLongBout
for l = 1:length(M)
megaM_2V_piezo_sleep_temps(l,c2Ps) = M(l); 
megaM_2V_piezo_sleep_mean(l,c2Ps) = M(l,2);
megaM_2V_piezo_sleep_std(l,c2Ps) = M(l,4);
end
c2Ps = c2Ps+1;
end



end



% For Accelero 
    %For 1 Volt
        % For Wake
nb_column = size(megaM_1V_accelero_wake_mean)
for l = 1:length(megaM_1V_accelero_wake_mean)
    megaM_1V_accelero_wake_mean(l,nb_column(2)+1) = mean(megaM_1V_accelero_wake_mean(l,1:nb_column(2)));
    megaM_1V_accelero_wake_mean_std(l,1) = std(megaM_1V_accelero_wake_mean(l,1:nb_column(2)));
    megaM_1V_accelero_wake_median(l,1) = median(megaM_1V_accelero_wake_mean(l,1:nb_column(2)));
end

figure
shadedErrorBar(megaM_1V_accelero_wake_temps(:,1),megaM_1V_accelero_wake_mean(:,nb_column(2)+1),megaM_1V_accelero_wake_mean_std(:,1));

        % For Sleep
nb_column = size(megaM_1V_accelero_sleep_mean)
for l = 1:length(megaM_1V_accelero_sleep_mean)
    megaM_1V_accelero_sleep_mean(l,nb_column(2)+1) = mean(megaM_1V_accelero_sleep_mean(l,1:nb_column(2)));
    megaM_1V_accelero_sleep_mean_std(l,1) = std(megaM_1V_accelero_sleep_mean(l,1:nb_column(2)));
    megaM_1V_accelero_sleep_median(l,1) = median(megaM_1V_accelero_sleep_mean(l,1:nb_column(2)));
end

figure
shadedErrorBar(megaM_1V_accelero_sleep_temps(:,1),megaM_1V_accelero_sleep_mean(:,nb_column(2)+1),megaM_1V_accelero_sleep_mean_std(:,1));
