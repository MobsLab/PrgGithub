%% input dir
DirDREADD = PathForExperiments_DREADD_MC('OneInject_Nacl');
DirDREADD = RestrictPathForExperiment(DirDREADD, 'nMice', [ 1150]); % to get mice with EMG only
DirOpto_BL = PathForExperiments_Opto_MC('PFC_Baseline_20Hz');
DirOpto_BL = RestrictPathForExperiment(DirOpto_BL, 'nMice', [675 733 1076 1109]);
DirOpto_Ctrl = PathForExperiments_Opto_MC('PFC_Control_20Hz');
DirOpto_Ctrl = RestrictPathForExperiment(DirOpto_Ctrl, 'nMice', [1075 1112 1180]);
DirOpto = MergePathForExperiment(DirOpto_BL, DirOpto_Ctrl);

DirEMG = MergePathForExperiment(DirDREADD, DirOpto);

%% get data for all mice with EMG
for i=1:length(DirEMG.path)
    cd(DirEMG.path{i}{1});
    [emg_wake, emg_sws, emg_rem] = GetEMGForEachState_MC;
    wakeEMG{:,i} = emg_wake;
    swsEMG{:,i} = emg_sws;
    remEMG{:,i} = emg_rem;

% calculate average EMG (per mouse)
for ii=1:length(swsEMG)
    swsEMG_mean(ii) = mean(swsEMG{ii});
end
for ii=1:length(remEMG)
    remEMG_mean(ii) = mean(remEMG{ii});
end
for ii=1:length(wakeEMG)
    wakeEMG_mean(ii) = mean(wakeEMG{ii});
end
end

% % filter extreme values
wakeEMG_mean = sort(wakeEMG_mean);
wakeEMG_mean = wakeEMG_mean(1:7);
% 
% swsEMG_mean = sort(swsEMG_mean);
% swsEMG_mean = swsEMG_mean(1:8);
% 
% remEMG_mean = sort(remEMG_mean);
% remEMG_mean = remEMG_mean(1:7);
%%
data = {swsEMG_mean, remEMG_mean, wakeEMG_mean};
figure, MakeBoxPlot_DB(data,{[1 0 0],[0 1 0],[0 .2 .8]},[1 2 3], {'NREM','REM','Wake'},1)
ylabel('Mean value EMG^2')
ylim([-0.1e6 1.6e6])

% Rank sum test
p = ranksum(swsEMG_mean, remEMG_mean);
if p<0.05
    sigstar_DB({[1 2]},p,0,'LineWigth',16,'StarSize',12);
end

p = ranksum(swsEMG_mean, wakeEMG_mean);
if p<0.05
    sigstar_DB({[1 3]},p,0,'LineWigth',16,'StarSize',12);
end

p = ranksum(remEMG_mean, wakeEMG_mean);
if p<0.05
    sigstar_DB({[2 3]},p,0,'LineWigth',16,'StarSize',12);
end

%%

data = {log10(swsEMG_mean), log10(remEMG_mean), log10(wakeEMG_mean)};
figure, MakeBoxPlot_DB(data,{[1 0 0],[0 1 0],[0 .2 .8]},[1 2 3], {'NREM','REM','Wake'},1)
ylabel('Mean value EMG^2 (log scale)')
% ylim([-0.1e6 1.6e6])

% Rank sum test
p = ranksum(swsEMG_mean, remEMG_mean);
if p<0.05
    sigstar_DB({[1 2]},p,0,'LineWigth',16,'StarSize',12);
end

p = ranksum(swsEMG_mean, wakeEMG_mean);
if p<0.05
    sigstar_DB({[1 3]},p,0,'LineWigth',16,'StarSize',12);
end

p = ranksum(remEMG_mean, wakeEMG_mean);
if p<0.05
    sigstar_DB({[2 3]},p,0,'LineWigth',16,'StarSize',12);
end


