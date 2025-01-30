% SolistChoristAnalysis2
% 05.05.2017 KJ
%
% 
% 
%   see SolistChoristDetection SolistChoristAnalysis1
%


clear

binsize_cc = 5;
nbins_cc = 500;

tbefore = 1E3; 
tafter = 1E3;

%% Load
%Epoch and Spikes
load StateEpochSB SWSEpoch Wake REMEpoch

%MUA
load SpikeData
eval('load SpikesToAnalyse/PFCx_Neurons')
NumNeurons=number;
clear number

%Down states
try
    load newDownState Down
catch
    try
        load DownSpk Down
    catch
        Down = intervalSet([],[]);
    end
end
start_down = Start(Down);
end_down = End(Down);
tdowns = (Start(Down)+End(Down)/2);


%% Soloist vs Chorist

Ssws=Restrict(S,SWSEpoch);
nb_neuron = length(NumNeurons);

for i=1:length(NumNeurons)
    num=1:length(NumNeurons);
    num(i)=[];
    [Cc(i,:), Bc] = CrossCorr(Range(Ssws{NumNeurons(i)}),Range(PoolNeurons(Ssws,NumNeurons(num))), binsize_cc, nbins_cc);
end

Cc_norm = Cc;
Cc_norm(isnan(Cc_norm))=0;
Cc_norm=zscore(Cc_norm')';
Cc_norm=SmoothDec(Cc_norm,[0.001 3]);

Chorist_idx = [];
Soloist_idx = [];
for i=1:length(NumNeurons)
    if mean(Cc_norm(i,240:260)) > mean(Cc_norm(i,1:200))
        Chorist_idx = [Chorist_idx i];
    else
        Soloist_idx = [Soloist_idx i];
    end
end

%MUA
Qchor = Ssws{Chorist_idx};
Qsol = Ssws{Soloist_idx};


%% Restrict MUA to periods around down states
BeforeDown = intervalSet(Start(Down)-tbefore, Start(Down));
AfterDown = intervalSet(End(Down), End(Down)+tafter);

%before
Qchor_bef = Restrict(Qchor,BeforeDown);
Qsol_bef = Restrict(Qsol,BeforeDown);
[CcBefore, Bc1] = CrossCorr(Range(Qsol_bef), Range(Qchor_bef), binsize_cc, 100);
[Cc_chor_Before, Bc3] = CrossCorr(Range(Qchor_bef), Range(Qchor_bef), binsize_cc, 100);

%after
Qchor_after = Restrict(Qchor,AfterDown);
Qsol_after = Restrict(Qsol,AfterDown);
[CcAfter, Bc2] = CrossCorr(Range(Qsol_after), Range(Qchor_after), binsize_cc, 100);
[Cc_chor_After, Bc4] = CrossCorr(Range(Qchor_after), Range(Qchor_after), binsize_cc, 100);





