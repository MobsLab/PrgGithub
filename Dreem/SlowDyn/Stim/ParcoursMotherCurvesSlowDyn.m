% ParcoursMotherCurvesSlowDyn
% 02.10.2018 KJ
%
% Infos
%   for each night :
%       - mean curves
%       
%
% SEE 
%   QuantifEffectStimSlowDyn
%

clear
load(fullfile(FolderSlowDyn,'PathSlowDynSfrms.mat'))


for p=1:length(Dir.filereference)
    clearvars -except Dir p mother_res     
    
    disp(' ')
    disp('****************************************************************')
    disp(Dir.filename{p})
    
    %% init
    
    mother_res.filename{p} = Dir.filename{p};
    mother_res.filereference{p} = Dir.filereference{p};
    mother_res.subject{p} = Dir.subject{p};
    mother_res.date{p} = Dir.date(p);
    mother_res.age{p} = Dir.age{p};
    mother_res.gender{p} = Dir.gender{p};
    
    %params
    channel_frontal = [1 2 5 6];
    binsize_met = 10;
    nbBins_met  = 200;
    
    %load signals and data
    [signals, ~, stimulations, StageEpochs, labels_eeg] = GetRecordDreem(Dir.filename{p});
    N1 = StageEpochs{1}; N2 = StageEpochs{2}; N3 = StageEpochs{3};
    signals = signals(channel_frontal);
    labels_eeg = labels_eeg(channel_frontal);

    %stimulations
    [stim_tmp, sham_tmp, int_stim, stim_train, sham_train, StimEpoch, ShamEpoch] = SortDreemStimSham(stimulations);
    mother_res.nb_stim{p} = length(stim_tmp);

    
    %% Mean Curves sync on Tones/Sham
    if ~isempty(stim_tmp)
        for ch=1:length(signals)
            [m,~,tps] = mETAverage(stim_tmp, Range(signals{ch}), Data(signals{ch}), binsize_met, nbBins_met);
            mother_res.met_tones{p,ch}(:,1) = tps; mother_res.met_tones{p,ch}(:,2) = m;

            [m,~,tps] = mETAverage(sham_tmp, Range(signals{ch}), Data(signals{ch}), binsize_met, nbBins_met);
            mother_res.met_sham{p,ch}(:,1) = tps; mother_res.met_sham{p,ch}(:,2) = m;
        end
    end
end

%saving data
cd(FolderSlowDynData)
save ParcoursMotherCurvesSlowDyn.mat mother_res channel_frontal binsize_met nbBins_met

