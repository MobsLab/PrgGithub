% StimImpactMeanCurves
% 23.05.2018 KJ
%
% mean curves on stim - STIM IMPACT
% -> Collect and save data 
%
%   see 
%       
%

clear

%Dir
Dir = ListOfDreemRecordsStimImpact('all');
    
%params
sleepstage_ind = 1:5; %N1, N2, N3, REM, WAKE
met_window = 4000; %in ms


for p=1:length(Dir.filename)
    
    %init
    disp(' ')
    disp('****************************************************************')
    disp(Dir.filename{p})
    curves_res.filename{p} = Dir.filename{p};
    curves_res.filereference{p} = Dir.filereference{p};
    curves_res.condition{p} = Dir.condition{p};
    curves_res.subject{p} = Dir.subject{p};
    curves_res.date{p} = Dir.date{p};
    curves_res.age{p} = Dir.age{p};
    
    
    %% load signals
    [eeg, ~, stimulations, StageEpochs, ~] = GetRecordDreem(Dir.filename{p});

    %stimulations
    [~, ~, ~, stim_train, sham_train, StimEpoch, ShamEpoch] = SortDreemStimSham(stimulations);
    
    
    %% Curves
    for ch=1:length(eeg)
        %tones
        for k=1:size(stim_train,2)
            %restrict
            tones_tmp = stim_train(:,k);
            tones_tmp = tones_tmp(~isnan(tones_tmp));

            %mean curves
            curves_res.tones.meancurve{p}{ch,k} = PlotRipRaw(eeg{ch}, tones_tmp/1E4, met_window,0,0);
            curves_res.tones.nb_stim{p}(k) = length(tones_tmp);
            
        end

        %sham
        for k=1:size(sham_train,2)
            %restrict
            sham_tmp = sham_train(:,k);
            sham_tmp = sham_tmp(~isnan(sham_tmp));

            %mean curves
            curves_res.sham.meancurve{p}{ch,k} = PlotRipRaw(eeg{ch}, sham_tmp/1E4, met_window,0,0);
            curves_res.sham.nb_stim{p}(k) = length(sham_tmp);

        end
    end

end

%saving data
cd(FolderStimImpactData)
save StimImpactMeanCurves.mat curves_res met_window



