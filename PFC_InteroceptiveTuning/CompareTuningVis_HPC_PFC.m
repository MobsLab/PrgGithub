%% Make all plots
clear all
Variables = {'HR','BR','speed'};
Periods = {'Freezing','All','Sleep','Wake','Wake_Explo','Habituation','Conditionning',...
    'Conditionning_NoFreeze','Habituation_NoFreeze','Umaze_NoFreeze'};
Regions = {'HPC','PFC'};
FigFolder = '/media/DataMOBsRAIDN/PFC_InteroceptiveTuning/Figures/TuningCurveRecap';
FigNames = {'TuningCurves','RSA','MutInfo'};
for pp = 1:length(Periods)
    for reg = 1:length(Regions)
        for vv = 1:length(Variables)
            [TrainTuning.(Regions{reg}).(Periods{pp}).(Variables{vv}),CVTuning.(Regions{reg}).(Periods{pp}).(Variables{vv}),...
                AllP.(Regions{reg}).(Periods{pp}).(Variables{vv}),AllMI.(Regions{reg}).(Periods{pp}).(Variables{vv}),AllMI_Norm.(Regions{reg}).(Periods{pp}).(Variables{vv}),fignum] = BasicPlotsTuningCurves_PFCinteroceptive_SB(Variables{vv},Periods{pp},Regions{reg},0.2,6,1);
            for i = 1:3
                saveas(fignum{i}.Number,[FigFolder filesep   Regions{reg} '_' Variables{vv} '_' Periods{pp} '_' FigNames{i} '.png'])
            end
        end
    end
end

% Special case position
Variables = {'position'};
Periods = {'Habituation','Conditionning',...
    'Conditionning_NoFreeze','Habituation_NoFreeze','Umaze_NoFreeze'};
for pp = 1:length(Periods)
    for reg = 1:length(Regions)
        for vv = 1:length(Variables)
            [TrainTuning.(Regions{reg}).(Periods{pp}).(Variables{vv}),CVTuning.(Regions{reg}).(Periods{pp}).(Variables{vv}),...
                AllP.(Regions{reg}).(Periods{pp}).(Variables{vv}),AllMI.(Regions{reg}).(Periods{pp}).(Variables{vv}),AllMI_Norm.(Regions{reg}).(Periods{pp}).(Variables{vv}),fignum] = BasicPlotsTuningCurves_PFCinteroceptive_SB(Variables{vv},Periods{pp},Regions{reg},0.2,6,1);
            for i = 1:3
                saveas(fignum{i}.Number,[FigFolder filesep   Regions{reg} '_' Variables{vv} '_' Periods{pp} '_' FigNames{i} '.png'])
            end
        end
    end
end

% visual
Variables = {'Orientation'};
Periods = {'All'};
Regions = {'Vis'};
for pp = 1:length(Periods)
    for reg = 1:length(Regions)
        for vv = 1:length(Variables)
            [TrainTuning.(Regions{reg}).(Periods{pp}).(Variables{vv}),CVTuning.(Regions{reg}).(Periods{pp}).(Variables{vv}),...
                AllP.(Regions{reg}).(Periods{pp}).(Variables{vv}),AllMI.(Regions{reg}).(Periods{pp}).(Variables{vv}),AllMI_Norm.(Regions{reg}).(Periods{pp}).(Variables{vv}),fignum] = BasicPlotsTuningCurves_PFCinteroceptive_SB(Variables{vv},Periods{pp},Regions{reg},0.2,6,1);
            for i = 1:3
                saveas(fignum{i}.Number,[FigFolder filesep   Regions{reg} '_' Variables{vv} '_' Periods{pp} '_' FigNames{i} '.png'])
            end
        end
    end
end

cd('/media/DataMOBsRAIDN/PFC_InteroceptiveTuning')
save('TuningInfoallStructures.mat','TrainTuning','CVTuning','AllP','AllMI')


%%%% Make figures  %%%%
FigFolder = '/media/DataMOBsRAIDN/PFC_InteroceptiveTuning/Figures/OverviewMI/';
% Sanity check - position higher in HPC
clear X Cols  LegendName
SigThresh = Inf;
Regions = {'HPC','PFC'};
Periods = {'Habituation_NoFreeze','Conditionning_NoFreeze'};
Variables = {'position'};

i=0;
X(1) = 0;
addon = 1;
AllMItoPlot = [];
AllMI_NormToPlot = [];
for reg = 1:length(Regions)
    for per = 1:length(Periods)
        for var = 1:length(Variables)
            i = i+1;
            
            Temp_AllMI = AllMI.(Regions{reg}).(Periods{per}).(Variables{var});
            Temp_AllMINorm = AllMI_Norm.(Regions{reg}).(Periods{per}).(Variables{var});
            Temp_AllP = AllP.(Regions{reg}).(Periods{pp}).(Variables{var});
            AllMItoPlot{i} = (Temp_AllMI(Temp_AllP<SigThresh));
            AllMI_NormToPlot{i} = (Temp_AllMINorm(Temp_AllP<SigThresh));
            
            X(i) = X(max([1,i-1]))+addon;
            addon = 1;
            switch Regions{reg}
                case 'PFC'
                    Cols{i} = [1 0 0];
                case 'HPC'
                    Cols{i} = [0 0 1];
            end
            LegendName{i} = Periods{per};
        end
    end
    addon = 2;
    
end

fig = figure;
subplot(121)
MakeSpreadAndBoxPlot_BM(AllMItoPlot,Cols,X,LegendName,1,0)
ylabel('Mutual info - position')
subplot(122)
MakeSpreadAndBoxPlot_BM(AllMI_NormToPlot,Cols,X,LegendName,1,0)
ylabel('Mutual info norm - position')
saveas(fig.Number,[FigFolder filesep 'PositionInfo_HPCvsPFC_SigThresh' num2str(SigThresh) '.png'])


% Main variables in UMaze
clear X Cols  LegendName
SigThresh = Inf;
Regions = {'HPC','PFC'};
Periods = {'Habituation','Conditionning','Conditionning_NoFreeze','Habituation_NoFreeze'};
Variables = {'HR','BR','speed','position'};

i=0;
X(1) = 0;
AllMItoPlot = [];
AllMI_NormToPlot = [];

for reg = 1:length(Regions)
    for per = 1:length(Periods)
        for var = 1:length(Variables)
            i = i+1;
            
            Temp_AllMI = AllMI.(Regions{reg}).(Periods{per}).(Variables{var});
            Temp_AllMINorm = AllMI_Norm.(Regions{reg}).(Periods{per}).(Variables{var});
            Temp_AllP = AllP.(Regions{reg}).(Periods{pp}).(Variables{var});
            AllMItoPlot{i} = (Temp_AllMI(Temp_AllP<SigThresh));
            AllMI_NormToPlot{i} = (Temp_AllMINorm(Temp_AllP<SigThresh));
            
            X(i) = X(max([1,i-1]))+addon;
            addon = 1;
            switch Regions{reg}
                case 'PFC'
                    Cols{i} = [1 0 0];
                case 'HPC'
                    Cols{i} = [0 0 1];
            end
            LegendName{i} = Variables{var};
        end
        addon = 2;
    end
end

% orientation visual - Conditionning_NoFreeze
i=i+1;
Temp_AllMI = AllMI.Vis.All.Orientation;
Temp_AllMINorm = AllMI_Norm.Vis.All.Orientation;
Temp_AllP = AllP.Vis.All.Orientation;
AllMItoPlot{i} = (Temp_AllMI(Temp_AllP<SigThresh));
AllMI_NormToPlot{i} = (Temp_AllMINorm(Temp_AllP<SigThresh));
X(i) = X(max([1,i-1]))+addon;
Cols{i} = [0 1 0];
LegendName{i} = 'Orientation';

fig = figure;
subplot(211)
MakeSpreadAndBoxPlot_BM(AllMItoPlot,Cols,X,LegendName,0,0)
ylabel('Mutual info')
subplot(212)
MakeSpreadAndBoxPlot_BM(AllMI_NormToPlot,Cols,X,LegendName,0,0)
ylabel('Mutual info norm ')

saveas(fig.Number,[FigFolder filesep 'MainVarUMaze_SigThresh' num2str(SigThresh) '.png'])





% HR across states
clear X Cols  LegendName
SigThresh = Inf;
Regions = {'HPC','PFC'};
Periods = {'All','Wake_Explo','Habituation','Conditionning','Conditionning_NoFreeze','Habituation_NoFreeze','Sleep','Freezing'};
Variables = {'HR'};
AllMItoPlot = [];
AllMI_NormToPlot = [];

i=0;
clear X Cols  LegendName
X(1) = 0;
for reg = 1:length(Regions)
    for per = 1:length(Periods)
        for var = 1:length(Variables)
            i = i+1;
            
            Temp_AllMI = AllMI.(Regions{reg}).(Periods{per}).(Variables{var});
            Temp_AllMINorm = AllMI_Norm.(Regions{reg}).(Periods{per}).(Variables{var});
            Temp_AllP = AllP.(Regions{reg}).(Periods{pp}).(Variables{var});
            AllMItoPlot{i} = (Temp_AllMI(Temp_AllP<SigThresh));
            AllMI_NormToPlot{i} = (Temp_AllMINorm(Temp_AllP<SigThresh));
            
            X(i) = X(max([1,i-1]))+addon;
            addon = 1;
            switch Regions{reg}
                case 'PFC'
                    Cols{i} = [1 0 0];
                case 'HPC'
                    Cols{i} = [0 0 1];
            end
            LegendName{i} = Periods{per};
            
        end
    end
    addon = 2;
    
end

fig = figure;
subplot(211)
MakeSpreadAndBoxPlot_BM(AllMItoPlot,Cols,X,LegendName,0,0)
ylabel('Mutual info')
subplot(212)
MakeSpreadAndBoxPlot_BM(AllMI_NormToPlot,Cols,X,LegendName,0,0)
ylabel('Mutual info norm ')

saveas(fig.Number,[FigFolder filesep 'HRAllStates_SigThresh' num2str(SigThresh) '.png'])






% BR across states
SigThresh = Inf;
Regions = {'HPC','PFC'};
Periods = {'All','Wake_Explo','Habituation','Conditionning','Conditionning_NoFreeze','Habituation_NoFreeze','Sleep','Freezing'};
Variables = {'BR'};
AllMItoPlot = [];
AllMI_NormToPlot = [];

i=0;
clear X Cols  LegendName
X(1) = 0;
for reg = 1:length(Regions)
    for per = 1:length(Periods)
        for var = 1:length(Variables)
            i = i+1;
            
            Temp_AllMI = AllMI.(Regions{reg}).(Periods{per}).(Variables{var});
            Temp_AllMINorm = AllMI_Norm.(Regions{reg}).(Periods{per}).(Variables{var});
            Temp_AllP = AllP.(Regions{reg}).(Periods{pp}).(Variables{var});
            AllMItoPlot{i} = (Temp_AllMI(Temp_AllP<SigThresh));
            AllMI_NormToPlot{i} = (Temp_AllMINorm(Temp_AllP<SigThresh));
            
            X(i) = X(max([1,i-1]))+addon;
            addon = 1;
            switch Regions{reg}
                case 'PFC'
                    Cols{i} = [1 0 0];
                case 'HPC'
                    Cols{i} = [0 0 1];
            end
            LegendName{i} = Periods{per};
        end
    end
    addon = 2;
    
end

fig = figure;
subplot(211)
MakeSpreadAndBoxPlot_BM(AllMItoPlot,Cols,X,LegendName,0,0)
ylabel('Mutual info')
subplot(212)
MakeSpreadAndBoxPlot_BM(AllMI_NormToPlot,Cols,X,LegendName,0,0)
ylabel('Mutual info norm ')
saveas(fig.Number,[FigFolder filesep 'BRAllStatess_HPCvsPFC_SigThresh' num2str(SigThresh) '.png'])

