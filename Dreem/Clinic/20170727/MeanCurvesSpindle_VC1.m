% MeanCurvesSpindle_VC1
% 24.07.2017 KJ
%
% Mean curves, in the spindle band, sync on stimulation time - VIRTUAL CHANNEL DATA
% -> Collect data
%
%   see 
%       MotherCurves1 
%

clear

%Dir
Dir = ListOfClinicalTrialDreemAnalyse('study');


%params
common_data = GetClinicCommonData();
lim_between_stim = common_data.lim_between_stim;  %1.6sec maximum between two stim of the same train
met_window = 6000; %in ms
spindle_band = [11 17];


for p=1:length(Dir.filename)
    %init
    disp(' ')
    disp('****************************************************************')
    disp(Dir.filename{p})
    curves_res.filename{p} = Dir.filename{p};
    curves_res.condition{p} = Dir.condition{p};
    curves_res.subject{p} = Dir.subject{p};
    curves_res.date{p} = Dir.date{p};
    curves_res.night{p} = Dir.night{p};


    %% load signals
    [signals, stimulations, StageEpochs, name_channel, domain] = GetRecordClinic(Dir.filename{p});
    
    %Hypnograms
    [Hypnograms, ~, ~] = GetHypnogramClinic(Dir.filereference{p});
    if ~isempty(Hypnograms)
        StageEpochs = Hypnograms{2};
    end

    % VIRTUAL CHANNEL SIGNAL
    [index_dreem, index_psg, ~, ~] = GetVirtualChannels(Dir.filereference{p});
    [signals_dreem_vc, signals_psg_vc, badEpochsDreem, badEpochsPsg] = ComputeDataVirtualChannel(signals, index_dreem, index_psg, name_channel);
    rg = Range(signals_dreem_vc);
    All_night = intervalSet(rg(1),rg(end));
    goodEpochs = All_night - badEpochsDreem;
    
    [~, signal_spindles] = ComputeHilbertData(signals_dreem_vc,'bandpass',spindle_band);
    
    
    %% TONES
    %only real auditory stimulations 
    time_stim = Range(stimulations);
    int_stim = Data(stimulations);
    if any(int_stim>0)
        time_stim = time_stim(int_stim>0);
    end
    
    %distinguish 1st and 2nd tones   
    second_idx = [0 ; diff(time_stim)<lim_between_stim];
    isolated_idx = [diff(second_idx)==0;0].* (second_idx==0);
    first_tones = (second_idx==0) .* (isolated_idx==0);
    first_stim = Restrict(ts(time_stim(first_tones==1)), goodEpochs);
    
    
    %% Mean Curves sync on Tones
    curves_res.nb_tones{p} = length(first_stim);
    curves_res.Ms_tone_dreem{p} = PlotRipRaw(signal_spindles,Range(first_stim)/1E4, met_window); close    
    
    
end


%saving data
cd(FolderPrecomputeDreem)
save MeanCurvesSpindle_VC1.mat curves_res met_window spindle_band Dir




