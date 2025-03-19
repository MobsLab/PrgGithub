% MeanSpecgramGraph_VC
% 05.07.2017 KJ
%
% Mean spectrogram sync on stimulation time - VIRTUAL CHANNEL DATA
% -> Collect data
%
%   see 
%       MotherCurves1 MeanSpecgramGraphPlot_VC
%

clear

%Dir
Dir = ListOfClinicalTrialDreemAnalyse('study');


%params
lim_between_stim = 1.6E4;  %1.6sec maximum between two stim of the same train
met_window = 5; %in s
movingwin = [3 0.2];
params.fpass = [2 50];
params.tapers = [1 2];

argum = {'durations',met_window,'movingwin',movingwin, 'params', params};


%loop
for p=1:length(Dir.filename)
    %init
    disp(' ')
    disp('****************************************************************')
    disp(Dir.filename{p})
    meanspec_res.filename{p} = Dir.filename{p};
    meanspec_res.condition{p} = Dir.condition{p};
    meanspec_res.subject{p} = Dir.subject{p};
    meanspec_res.date{p} = Dir.date{p};
    meanspec_res.night{p} = Dir.night{p};

    
    %% load signals
    [signals, stimulations, StageEpochs, name_channel, domain] = GetRecordClinic(Dir.filename{p});

    % VIRTUAL CHANNEL SIGNAL
    [index_dreem, index_psg, ~, ~] = GetVirtualChannels(Dir.filereference{p});
    [signals_dreem_vc, signals_psg_vc, badEpochsDreem, badEpochsPsg] = ComputeDataVirtualChannel(signals, index_dreem, index_psg, name_channel);
    rg = Range(signals_dreem_vc);
    All_night = intervalSet(rg(1),rg(end));
    goodEpochs = All_night - badEpochsDreem;

    %only real auditory stimulations
    time_stim = Range(stimulations);
    int_stim = Data(stimulations);
    if any(int_stim>0)
        time_stim = time_stim(int_stim>0);
    end
    
    %Hypnograms
    [Hypnograms, ~, ~] = GetHypnogramClinic(Dir.filereference{p});
    if ~isempty(Hypnograms)
        StageEpochs = Hypnograms{2};
    end
    
    %Resample
    signals_dreem_vc = ResampleTSD(signals_dreem_vc,100);

    %% TONES - distinguish 1st and 2nd tones    
    second_idx = [0 ; diff(time_stim)<lim_between_stim];
    isolated_idx = [diff(second_idx)==0;0].* (second_idx==0);
    first_tones = (second_idx==0) .* (isolated_idx==0);
    first_stim = Restrict(ts(time_stim(first_tones==1)), goodEpochs);


    %% Mean Curves sync on Tones
    meanspec_res.nb_tones{p} = length(first_stim);
    [meanspec_res.dreem.Specg{p}, meanspec_res.dreem.times{p}, meanspec_res.dreem.freq{p}] = SyncSpecgram_KJ(signals_dreem_vc, Range(first_stim)/1E4, argum{:});

end


%saving data
cd(FolderPrecomputeDreem)
save MeanSpecgramGraph_VC2.mat meanspec_res met_window Dir movingwin params




