% MotherCurves2
% 28.03.2017 KJ
%
% Mean curves sync on stimulation time
% -> Collect data
%
%   see 
%       MotherCurves1 MotherCurvesPlot2
%

clear

%Dir
Dir = ListOfClinicalTrialDreemAnalyse('all');


%params
lim_between_stim = 1.6E4;  %1.6sec maximum between two stim of the same train
met_window = 4000; %in ms
channels = [1 2 7 10];
name_channels = {'FP1-M1','FP2-M2','REF F3','REF F4'};

for p=1:length(Dir.filename)
   
    if ~isempty(Dir.channel_sw{p})
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
        %N2+N3
        N2N3 = or(StageEpochs{2},StageEpochs{3});

        %only real auditory stimulations 
        time_stim = Range(stimulations);
        int_stim = Data(stimulations);
        if any(int_stim>0)
            time_stim = time_stim(int_stim>0);
        end

        %% TONES - distinguish 1st and 2nd tones    
        second_idx = [0 ; diff(time_stim)<lim_between_stim];
        isolated_idx = [diff(second_idx)==0;0].* (second_idx==0);
        first_tones = (second_idx==0) .* (isolated_idx==0);
        first_stim = Restrict(ts(time_stim(first_tones==1)), N2N3);


        %% Mean Curves sync on Tones
        mother_res.nb_tones{p} = length(first_stim);
        for ch=1:length(channels)
            if ismember(channels(ch),Dir.channel_sw{p})
                mother_res.Ms_tone{p,ch} = PlotRipRaw(signals{channels(ch)},Range(first_stim)/1E4, met_window); close
            end
        end
    end
    
end


%saving data
cd(FolderPrecomputeDreem)
save MotherCurves2.mat mother_res met_window channels name_channels




