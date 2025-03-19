
function [megaM_temps,megaM_mean,megaM_std,T] = Mean_functionPlotRipRaw_AF(FolderName,ValueStim,BoutDurationBeforeStim,state,system)
% input : 
% system : 'OB', 'accelero' ou 'piezo'
BoutDurationBeforeStim;     % Time to take before the stim in seconde
ValueStim;      % in Volt (based on journal_stim)

ligne = 0;

c1Aw = 1;
c1As = 1;

megaM_temps= []; 
    megaM_mean = [];
    megaM_std = [];
    T={};
    
    
% Create the Stim Epoch
for i = 1:length(FolderName)

    % Load
    cd(FolderName{i});

    if strcmp(lower(system),'OB')

    
    elseif strcmp(lower(system),'accelero')
    load 'SleepScoring_Accelero.mat' tsdMovement WakeWiNoise SleepWiNoise;
    tsd = tsdMovement;
    Wake = WakeWiNoise;
    Sleep = SleepWiNoise;
    elseif strcmp(lower(system),'piezo')
    load 'PiezoData_SleepScoring.mat' Piezo_Mouse_tsd WakeEpoch_Piezo SleepEpoch_Piezo;
    tsd = Piezo_Mouse_tsd;
    Wake = WakeEpoch_Piezo;
    Sleep = SleepEpoch_Piezo;

    end


    % For 1V Wake:
    StimWithLongBout = FindEyelidStimWithLongBout_AF(Wake,Sleep,state,BoutDurationBeforeStim,ValueStim,system);
    PlotOrNot = 0;
    PlotNewfig = 0;
    try
    [M,T{i}] = PlotRipRaw_modifAF(tsd,StimWithLongBout/1e4,[-20 20]*1e3,0,PlotOrNot,PlotNewfig);
    system,
    clear Start_StimWithLongBout
    for l = 1:length(M)
    megaM_temps(l,c1Aw) = M(l); 
    megaM_mean(l,c1Aw) = M(l,2);
    megaM_std(l,c1Aw) = M(l,4);
    end
    c1Aw = c1Aw + 1;
    end

    
end
