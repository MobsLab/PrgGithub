function HPC_TuningCurves_ByState_V3(Parameter, Period,BinNumber,TempBinsize,SaveFolder)

%% Inputs
% Parameter : which paramater to study
%   - HR : heart rate
%   - BR : breathing rate
%   - speed : actually head mouvement of rnow because we don't have the
%   speed
%   - position : linear position, only works with UMaaze
%
% Period : which period in time
%   - Freezing : all freezing from the umaze conditionning
%   - Sleep : all sleep periods
%   - Wake : all wake
%   - Wake_Explo : all wake periods that do not involve freezing
%   - Habituation : All periods before fear so hab and test pre
%   - Conditionning : All the conditionning
%   - Conditionning_NoFreeze  : All the conditionning, no freezing
%   - Habituation_NoFreeze  : Habituation, no freezing
%   - Umaze_NoFreeze : UMaze (pre, cond, post), no freezing
%   - All
%

%%

% Basic parameters
Opts.Num_bootstraps = 100;
Opts.NeuronBins = [0:10];
Opts.TempBinsize = TempBinsize;
Opts.BinNumber = BinNumber;

% get all the data
[VarOfInterest,spike_dat,Opts] = HPC_DataSpikesAndParameter_ByState(Parameter, Period,Opts);


% Analyse the tuning curves
for mm = 1:length(spike_dat)
    for sp = 1:size(spike_dat{mm},1)
        [TuningCurves{mm}{sp},MutInfo{mm}{sp},CorrInfo{mm}{sp},...
            MutInfo_rand{mm}{sp},CorrInfo_rand{mm}{sp}] = GetTuningCurveDescriptions(spike_dat{mm}(sp,:)',VarOfInterest{mm},Opts);
    end
end

save([SaveFolder filesep Parameter 'NTuning_',Period,'_HPC_',num2str(Opts.TempBinsize),'s_',num2str(BinNumber),'ParamBinNumber.mat'],'TuningCurves','MutInfo','CorrInfo','MutInfo_rand',...
    'CorrInfo_rand','Opts')


