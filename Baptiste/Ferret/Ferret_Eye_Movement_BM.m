function Ferret_Eye_Movement_BM()
% This is a master script to process the DLC behavioural ferret data
% Steps:
%   - Synchronization with LFP signal (sync_video_ob). It creates a correct timeline taking into account the delay between the video and ephys
%   - Generation of the basic figures (OB_face_analysis_DLC)
% Under construction  - Study the correlation between OB/Cortical/Hippocampal gamma and pupil area (gamma_pupil_corr)
% Under construction  - Producing the composition video with all variables synced (composition_video_OB_DLC_ferret)

%% Manual initialization of sessions (done)
% User input parameters
Session_params.session_selection = '20241212_TORCs';
Session_params.fps = 15;

% Flags
Session_params.animal_selection = 3;
Session_params.experiment_type_selection = 1;
Session_params.pharma_selection = 1;
Session_params.plt = [0 1]; 
Session_params.fig_visibility = 'on';

% Parameters       
Session_params.animal_name = {'Labneh','Brynza', 'Shropshire'};
Session_params.experiment_type = {'head-fixed', 'freely_moving'};
Session_params.pharma = {'No pharmacology','Domitor', 'Atropine'};
datapath = ['/media/nas7/React_Passive_AG/OBG/' Session_params.animal_name{Session_params.animal_selection} '/' Session_params.experiment_type{Session_params.experiment_type_selection} '/' Session_params.session_selection];

%% List of sessions
dataset_path{1} = '/media/nas7/React_Passive_AG/OBG/Labneh/head-fixed/';
dataset_path{2} = '/media/nas7/React_Passive_AG/OBG/Brynza/head-fixed/';

session_list = {...
                % Labneh
                [dataset_path{1} '20230208'];...
                [dataset_path{1} '20230225'];...
                [dataset_path{1} '20230227'];...    
                [dataset_path{1} '20230303'];...
                [dataset_path{1} '20230307'];...    
                [dataset_path{1} '20230308'];...
                [dataset_path{1} '20230315'];...    
                [dataset_path{1} '20230321'];...
                [dataset_path{1} '20230323'];...    
                [dataset_path{1} '20230407'];...
                [dataset_path{1} '20230418'];...    
                [dataset_path{1} '20230419'];...
%                 [dataset_path{1} '20230427'];...    % shit
                [dataset_path{1} '20230504_1'];...
                [dataset_path{1} '20230504_2'];...    
                [dataset_path{1} '20230505_1'];...
                [dataset_path{1} '20230505_2'];...    
%                 [dataset_path{1} '20230505_3'];...  % shit
                [dataset_path{1} '20230508_1'];...    
                [dataset_path{1} '20230508_2'];...
                [dataset_path{1} '20230508_3'];...    
                % Brynza
%                 [dataset_path{2} '20240124'];...  % shit
                [dataset_path{2} '20240125'];...    
                [dataset_path{2} '20240126'];...
                [dataset_path{2} '20240129'];...    
                [dataset_path{2} '20240204'];...
                [dataset_path{2} '20240205'];...    
                [dataset_path{2} '20240305'];...
                [dataset_path{2} '20240307'];...    
                [dataset_path{2} '20240308'];...    
                };

%% Template to run scripts for the full dataset
allCorrelations = NaN(6, length(session_list), 8); % 27 sessions, 8 epochs
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

%% Synchronize LFP and DLC
% Produces synced timeline in DLC_data.mat
cd(datapath)
disp('Syncing DLC and Ephys...')
sync_video_ob(Session_params, datapath)

%% Do the basic DLC pre-processing
% Produces raw behavioural variables in DLC_data.mat
cd(datapath)
disp('Analysing DLC data...')
OB_face_analysis_DLC(Session_params, datapath)

%% Correlate brain signals with pupil size
cd(datapath)
disp('Running pupil-brain correlation analysis...')
gamma_pupil_corr(Session_params, datapath)

%% Under construction: Generate composition video
cd(datapath)

composition_video_OB_DLC_ferret

%% Under construction: Manual correction of outlier DLC scoring frames
% it could work but I was lazy and decided to smooth data instead AG 05/11/24
% Ferret_DLC_correct_outlier_coordinates(Session_params, datapath)

end