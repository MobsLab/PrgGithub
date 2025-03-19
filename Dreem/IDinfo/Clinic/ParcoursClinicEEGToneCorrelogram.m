% ParcoursClinicEEGToneCorrelogram
% 18.01.2017 KJ
%
% Infos
%   Loop over all record: generate correlogram around tones 
%
% SEE 
%   PlotEventTriggeredCorrelogram
%

Dir1 = ListOfClinicalTrialDreem('Random');
Dir2 = ListOfClinicalTrialDreem('UpPhase');
Dir = FusionListOfClinicalTrial(Dir1,Dir2);


for p=1:length(Dir.filename)
    clearvars -except Dir p
    
    disp(' ')
    disp('****************************************************************')
    disp(['actiwave:' Dir.refname{p}])
    disp(['dreem: ' Dir.dreemname{p}])
    
    
    %params
    durations = [-5000 5000]; %in ms
    smoothing = [0.7 0.7];
    pmaxi = 0.1;
    labels = {'FP1','FP2','FP2_FP1','FP1_FPz','O1','C3','F3','E1','O2','C4','F4','E2','ECG','EMG'};
    
    
    %% load
    [signals, stimulations, ~, name_channel, ~] = GetRecordClinic(Dir.refname{p},Dir.dreemname{p});
    
%     %% TONES - distinguish 1st and 2nd tones    
%     all_tones = Range(stimulations);
%     second_idx = [0 ; diff(all_tones)<lim_between_stim];
%     isolated_idx = [diff(second_idx)==0;0].* (second_idx==0);
%     
%     first_tones = (second_idx==0) .* (isolated_idx==0);
%     second_tones = second_idx;
%     isolated_tones = isolated_idx;
    
    
    %% COMPUTE PLOT SAVE
    cd(FolderClinicFigures)
    sig_idx = [1 6 7];
    
    for i=sig_idx
        %compute&plot
        [~, ~] = PlotEventTriggeredCorrelogram(signals{i}, stimulations, durations, 'smooth', smoothing, 'pmax', pmaxi);
        suplabel(['EEG ' name_channel{i} ' on tones - ' num2str(Dir.filereference{p})],'t');

        %title
        filename_fig = ['EEGtoneCorrelo_' labels{i} '_' num2str(Dir.filereference{p})];
        filename_png = [filename_fig  '.png'];
        %save
        set(gcf,'units','normalized','outerposition',[0 0 1 1])
        saveas(gcf,filename_fig,'png')
        close all
    end
    
end




