% MotherCurves_VC1
% 26.06.2017 KJ
%
% Mean curves sync on stimulation time - VIRTUAL CHANNEL DATA
% -> Collect data
%
%   see 
%       MotherCurves1 MotherCurvesPlot_VC1
%

clear

%Dir
Dir = ListOfClinicalTrialDreemAnalyse('study');


%params
common_data = GetClinicCommonData();
lim_between_stim = common_data.lim_between_stim;  %1.6sec maximum between two stim of the same train
met_window = 4000; %in ms


for p=1:length(Dir.filename)
    %init
    disp(' ')
    disp('****************************************************************')
    disp(Dir.filename{p})
    mother_res.filename{p} = Dir.filename{p};
    mother_res.condition{p} = Dir.condition{p};
    mother_res.subject{p} = Dir.subject{p};
    mother_res.date{p} = Dir.date{p};
    mother_res.night{p} = Dir.night{p};


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
    mother_res.nb_tones{p} = length(first_stim);
    mother_res.Ms_tone_dreem{p} = PlotRipRaw(signals_dreem_vc,Range(first_stim)/1E4, met_window); close
    mother_res.Ms_tone_psg{p} = PlotRipRaw(signals_psg_vc,Range(first_stim)/1E4, met_window); close
    
    
    
end


%saving data
cd(FolderPrecomputeDreem)
save MotherCurves_VC1.mat mother_res met_window Dir




