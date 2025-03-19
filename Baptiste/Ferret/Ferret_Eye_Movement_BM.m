function Ferret_Eye_Movement_BM()
% This is a master script to process the DLC behavioural ferret data
% Steps:
%   - Synchronization with LFP signal (sync_video_ob). It creates a correct timeline taking into account the delay between the video and ephys
%   - Generation of the basic figures (OB_face_analysis_DLC)
% Under construction  - Study the correlation between OB/Cortical/Hippocampal gamma and pupil area (gamma_pupil_corr)
% Under construction  - Producing the composition video with all variables synced (composition_video_OB_DLC_ferret)

%% Manual initialization of sessions (done)
% User input parameters
% Session_params.session_selection = '20241212_TORCs';
% Session_params.fps = 15;
% 
% % Flags
% Session_params.animal_selection = 3;
% Session_params.experiment_type_selection = 1;
% Session_params.pharma_selection = 1;
% Session_params.plt = [0 1]; 
% Session_params.fig_visibility = 'on';
% 
% % Parameters       
% Session_params.animal_name = {'Labneh','Brynza', 'Shropshire'};
% Session_params.experiment_type = {'head-fixed', 'freely_moving'};
% Session_params.pharma = {'No pharmacology','Domitor', 'Atropine'};
% datapath = ['/media/nas7/React_Passive_AG/OBG/' Session_params.animal_name{Session_params.animal_selection} '/' Session_params.experiment_type{Session_params.experiment_type_selection} '/' Session_params.session_selection];

%% List of sessions
Dir = PathForExperimentsOB({'Shropshire', 'Labneh', 'Brynza'}, 'head-fixed');
sessions = Dir.path';

k = 1;
session_dlc = {};

for c = 1:length(sessions)
    dlc_path = fullfile(sessions{c}, 'DLC'); 
    files = dir(fullfile(dlc_path, '*_filtered.csv')); % Search for files ending with "_filtered.csv"
    
    if ~isempty(files) % Check if there are any matching files
        session_dlc{k} = sessions{c}; % Store the session path
        k = k + 1;
    else
        disp([Dir.path{c} ' - No DLC found']);
    end
end

session_dlc = session_dlc';

%% Synchronize LFP and DLC
% Produces synced timeline in DLC_data.mat
for sess = 2:length(session_dlc)
    % cd(session_dlc{1})
    disp(['Running session: ' session_dlc{sess}])
    disp('Syncing DLC and Ephys...')
    sync_video_ob(session_dlc{sess})
end
    %% Do the basic DLC pre-processing
    % Produces raw behavioural variables in DLC_data.mat
%     cd(session_dlc{sess})
for sess = 1:length(session_dlc)
    disp('Analysing DLC data...')
    OB_face_analysis_DLC(session_dlc{sess})
end  
    
    %% Correlate brain signals with pupil size
    cd(session_dlc{sess})
    disp('Running pupil-brain correlation analysis...')
    gamma_pupil_corr(Session_params, session_dlc{sess})
end

%% Under construction: Generate composition video
cd(session_dlc{sess})

composition_video_OB_DLC_ferret

%% Template to run scripts for the full dataset
allCorrelations = NaN(6, length(session_list), 8);
allPValues = NaN(6, length(session_list), 8);

for sess = 1:length(session_list)
    cd(session_list{sess})

    load([session_list{sess} '/DLC/DLC_data.mat'], 'Session_params');
    datapath = session_list{sess};
    Session_params.fig_visibility = 'off';

    disp(' ')
    disp(' ')
    disp(['Running ' Session_params.animal_name{Session_params.animal_selection} ' ' Session_params.session_selection ' session'])
    
    %% Pull out correlation values
    clear brain_pupil_corr
    correlations{sess} = load('SleepScoring_OBGamma.mat', 'brain_pupil_corr');
    
    for region = 1:length(correlations{sess}.brain_pupil_corr)
        if region <= size(correlations{sess}.brain_pupil_corr, 1)
            corrData = correlations{sess}.brain_pupil_corr{region, 1}; % First column for correlations
            pvalData = correlations{sess}.brain_pupil_corr{region, 2}; % Second column for p-values
            
            % Populate the matrices with correlation and p-value data for this session
            for epoch = 1:length(corrData)
                if ~isempty(corrData{epoch})
                    allCorrelations(region, sess, epoch) = corrData{epoch};
                end
                if ~isempty(pvalData{epoch})
                    allPValues(region, sess, epoch) = pvalData{epoch};
                end
            end
        end
    end

end


%% Under construction: Manual correction of outlier DLC scoring frames
% it could work but I was lazy and decided to smooth data instead AG 05/11/24
% Ferret_DLC_correct_outlier_coordinates(Session_params, datapath)

end