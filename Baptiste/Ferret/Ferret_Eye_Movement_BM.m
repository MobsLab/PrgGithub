function Ferret_Eye_Movement_BM()
% This is a master script to process the DLC behavioural ferret data
% Steps:
%   - Synchronization with LFP signal (sync_video_ob). It creates a correct timeline taking into account the delay between the video and ephys
%   - Generation of the basic figures (OB_face_analysis_DLC)
% Under construction  - Study the correlation between OB/Cortical/Hippocampal gamma and pupil area (gamma_pupil_corr)
% Under construction  - Producing the composition video with all variables synced (composition_video_OB_DLC_ferret)

%% Select sessions
Dir_1 = PathForExperimentsOB({'Labneh'}, 'head-fixed', 'none');
Dir_2 = PathForExperimentsOB({'Brynza'}, 'head-fixed', 'none');
Dir_3 = PathForExperimentsOB({'Shropshire'}, 'head-fixed', 'none');
Dir = PathForExperimentsOB({'Shropshire', 'Labneh', 'Brynza'}, 'head-fixed', 'none');

Dirs = {Dir_1,Dir_2, Dir_3, Dir};
Dirs_names = {'Labneh', 'Brynza', 'Shropshire', 'All animals'};

%% Form the list of sessions
selection = 4;

sessions = Dirs{selection}.path';

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

% Remove shady sessions
remove = {'/media/nas7/React_Passive_AG/OBG/Labneh/head-fixed/20230308', ...
    '/media/nas7/React_Passive_AG/OBG/Labneh/head-fixed/20230225', ...
    '/media/nas7/React_Passive_AG/OBG/Labneh/head-fixed/20230505_1',...
    '/media/nas8/OB_ferret_AG_BM/Shropshire/head-fixed/20241120_yves_train',...
    '/media/nas8/OB_ferret_AG_BM/Shropshire/head-fixed/20241123_yves_train', ...
    '/media/nas8/OB_ferret_AG_BM/Shropshire/head-fixed/20241125_yves_train', ...
    '/media/nas8/OB_ferret_AG_BM/Shropshire/head-fixed/20241126_yves_train', ...
    '/media/nas8/OB_ferret_AG_BM/Shropshire/head-fixed/20241128_yves_train', ...
    '/media/nas8/OB_ferret_AG_BM/Shropshire/head-fixed/20241129_yves_test' , ...
    '/media/nas8/OB_ferret_AG_BM/Shropshire/head-fixed/20241130_yves_test' , ...
    '/media/nas8/OB_ferret_AG_BM/Shropshire/head-fixed/20241203_yves_test',...
    '/media/nas8/OB_ferret_AG_BM/Shropshire/head-fixed/20241204_TORCs', ...
    '/media/nas8/OB_ferret_AG_BM/Shropshire/head-fixed/20241205_TORCs', ...
    '/media/nas8/OB_ferret_AG_BM/Shropshire/head-fixed/20241206_TORCs',...
    '/media/nas8/OB_ferret_AG_BM/Shropshire/head-fixed/20241209_TORCs',...    
    '/media/nas8/OB_ferret_AG_BM/Shropshire/head-fixed/20241212_TORCs',...
    '/media/nas8/OB_ferret_AG_BM/Shropshire/head-fixed/20241214_TORCs', ...
    '/media/nas8/OB_ferret_AG_BM/Shropshire/head-fixed/20241228_TORCs_saline',...   % Almost closed eyes
    '/media/nas8/OB_ferret_AG_BM/Shropshire/head-fixed/20250102_TORCs_atropine',... % unreliable tracking
    '/media/nas8/OB_ferret_AG_BM/Shropshire/head-fixed/20250103_TORCs_saline',... % unreliable tracking
    '/media/nas8/OB_ferret_AG_BM/Shropshire/head-fixed/20250104_TORCs_saline',... % unreliable tracking
    '/media/nas7/React_Passive_AG/OBG/Brynza/head-fixed/20240124',... % shit
    '/media/nas7/React_Passive_AG/OBG/Brynza/head-fixed/20240125',... % shit
    '/media/nas7/React_Passive_AG/OBG/Brynza/head-fixed/20240205',...
    '/media/nas7/React_Passive_AG/OBG/Brynza/head-fixed/20240313',...
    '/media/nas7/React_Passive_AG/OBG/Labneh/head-fixed/20230113',...
    '/media/nas7/React_Passive_AG/OBG/Labneh/head-fixed/20230427',...
    '/media/nas7/React_Passive_AG/OBG/Labneh/head-fixed/20230505_3',...
    };
remove = remove';

keepIdx = ~ismember(session_dlc, remove);
session_dlc = session_dlc(keepIdx);

%% Synchronize LFP and DLC
% Produces synced timeline in DLC_data.mat
for sess = 1:length(session_dlc)
    % cd(session_dlc{1})
    disp(['Running session: ' session_dlc{sess}])
    disp('Syncing DLC and Ephys...')
    sync_video_ob(session_dlc{sess})
end

%% Do the basic DLC pre-processing
% TS: B20240410_domitor (sort); S20241206 (sort, nans); L20230727 (nans); L20230505_3 (nans)
for sess = 1:length(session_dlc)
    disp('Analysing DLC data...')
    OB_face_analysis_DLC(session_dlc{sess})
end

%% Correlate brain signals with pupil size
for sess = sess_ts % 1:length(session_dlc)
%     cd(session_dlc{sess})
    disp('Running pupil-brain correlation analysis...')
    gamma_pupil_corr(session_dlc{sess})
end

%% Full dataset analysis
% Initialize
smootime = 300;
allCorrelations = NaN(6, numel(session_dlc), 8);
allPValues = NaN(6, numel(session_dlc), 8);
% allPupilSizes = NaN(numel(session_dlc), 8);
% Define colours for plotting each epoch (as cell array of two colours per epoch)
colours = { {[0 0 0], [1 0.5 0]}; ...         % Full Session
            {[0 0 1], [0.2 0.75 1]}; ...        % Wake
            {[1 0 0], [1 0.5 0.75]}; ...         % Sleep
            {[1 0.71 0.76], [1.0, 0.82, 0.86]}; ...  % NREM1
            {[0.55 0 0], [0.71, 0.20, 0.20]}; ... % NREM2
            {[0 1 0], [0.75 1 0.5]}; ...         % REM
            {[0.5 0 0.5], [0.2 0.6 0.5]}; ...      % Wake-NREM
            {[0.50 0.35 0.88], [0.2 0.6 0.5]} };   % Wake-NREM1

%% Pupil sizes distributions
for sess = 1:numel(session_dlc)
    datapath = session_dlc{sess};
    [~, sess_name, ~] = fileparts(datapath);
    disp(['Processing: ' sess_name])
    
    % Pull out pupil sizes and zscore
    load(fullfile(datapath, 'DLC', 'DLC_data.mat'), 'areas_pupil')
%     D1 = Data(areas_pupil);
    D1 = zscore(Data(areas_pupil));
    D1(movstd(zscore(Data(areas_pupil)),10)>.5) = NaN;
    D1 = movmean(D1,ceil(smootime/median(diff(Range(areas_pupil,'s')))),'omitnan');
    TSD1 = tsd(Range(areas_pupil) , D1);

        % Pull out states
    clear Epoch Sleep Wake REMEpoch SWSEpoch Epoch_S1 Epoch_S2
    load(fullfile(datapath, 'SleepScoring_OBGamma.mat'), ...
        'Epoch', 'Sleep', 'Wake', 'REMEpoch', 'SWSEpoch', 'Epoch_S1', 'Epoch_S2');
    
    % Define NREM epochs (here defined as combinations of Sleep and sub-epochs)
    NREM_S1 = and(Sleep, Epoch_S2) - REMEpoch;
    NREM_S2 = and(Sleep, Epoch_S1) - REMEpoch;
    
    Epochs = {Epoch, Wake, Sleep, SWSEpoch, NREM_S1, NREM_S2, REMEpoch, or(Wake, SWSEpoch), or(Wake, NREM_S1)};
    Epoch_names = {'Full Session', 'Wake', 'Sleep', 'NREM', 'NREM1', 'NREM2', 'REM', 'Wake-NREM', 'Wake-NREM1'};
    
    % Populate the matrices with correlation and p-value data for this session
    for epoch = 1:length(Epochs)
        allPupilSizes(sess, epoch) = Restrict(TSD1, Epochs{epoch});
    end
end

%%
nSessions = size(session_dlc,1);
% nEpochs = size(Epoch_names(selected),2);

X = [1 2 3];
selected = [2 4 7]; 
Cols = {[0 0 1], [0.55 0 0], [0 1 0]};
Legends = {'Wake','NREM','REM'};

figure
clf
subplot(121)
MakeSpreadAndBoxPlot3_SB({Data(allPupilSizes(:, 2)) Data(allPupilSizes(:, 4)) Data(allPupilSizes(:, 7))},Cols,X,Legends,'showpoints',0,'paired',0)

subplot(122)
% ——————— Extract your three epochs ———————
wake = Data(allPupilSizes(:,2));   % epoch 2 = Wake
nrem = Data(allPupilSizes(:,4));   % epoch 4 = NREM
rem  = Data(allPupilSizes(:,7));   % epoch 7 = REM

% ——————— Compute common bins ———————
allData = [wake; nrem; rem];
nbins   = 200;  % adjust as needed
edges   = linspace(min(allData), max(allData), nbins+1);
centers = edges(1:end-1) + diff(edges)/2;

% ——————— Bin each series ———————
cw = histcounts(wake, edges);
cn = histcounts(nrem, edges);
cr = histcounts(rem,  edges);

cw = (cw - min(cw)) / (max(cw) - min(cw));
cn = (cn - min(cn)) / (max(cn) - min(cn));
cr  = (cr  - min(cr )) / (max(cr ) - min(cr ));


% ——————— Plot histogram-areas ———————
hold on
area(centers, cw, 'FaceColor',Cols{1}, 'FaceAlpha',0.4, 'EdgeColor','none');
area(centers, cn, 'FaceColor',Cols{2}, 'FaceAlpha',0.4, 'EdgeColor','none');
area(centers, cr, 'FaceColor',Cols{3}, 'FaceAlpha',0.4, 'EdgeColor','none');
hold off

% ——————— Beautify ———————
xlim([centers(1) centers(end)]);
camroll(270)
xlabel('Z-scored pupil size');
ylabel('Count');
legend({'Wake','NREM','REM'}, 'Location','NorthWest');
set(gca,'Box','off','TickDir','out');
set(gca,'YDir','reverse')

[Y,X] = hist(log10(wake),1000);
a = area(X , runmean(Y,3)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
xlabel('OB 0.1-1 power (a.u.)'), xlim([1.4 2.8])
set(gca,'XDir','reverse'), camroll(270), box off
v2=vline(2.13,'-r'); v2.LineWidth=5;

%
for sess = 1:size(allPValues, 2)
    for epoch = 1:size(allPValues, 3)
        D{sess, epoch} = Data(allPupilSizes(sess, epoch));
        data_mean_pupil(sess, epoch) = nanmean(D{sess, epoch}, 1);
        h{epoch}=histogram(D{sess, epoch},'NumBins',200);
        HistData(sess,epoch,:) = h{epoch}.Values./sum(h{epoch}.Values);
    end
end

figure
cols = {'-b', '-r', '-g'};
    i = 1;

for epoch = [2 4 7]
    hold on
    Data_to_use = squeeze(HistData(:, epoch, :));
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    shadedErrorBar(linspace(-2,4,200), runmean(nanmean(Data_to_use),3) , runmean(Conf_Inter,3) ,cols{i},1); hold on;
    % ylim([0 .045])
    xlabel('Pupil size (zscore)'), ylabel('PDF')
    makepretty
    i = i + 1;
end


%% Brain-pupil correlations
for sess = 1:numel(session_dlc)
    datapath = session_dlc{sess};
    [~, sess_name, ~] = fileparts(datapath);
    disp(['Processing: ' sess_name])
        
    % Pull out barin-pupil correlation values
    clear brain_pupil_corr
    correlations{sess} = load(fullfile(datapath, 'SleepScoring_OBGamma.mat'), 'brain_pupil_corr');
    load(fullfile(datapath, 'SleepScoring_OBGamma.mat'), 'SmoothGamma')
    
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
    
    % Pull out pupil sizes and zscore
    load(fullfile(datapath, 'DLC', 'DLC_data.mat'), 'areas_pupil')
    D1 = zscore(Data(areas_pupil));
    D1(movstd(zscore(Data(areas_pupil)),10)>.5) = NaN;
    D1 = movmean(D1,ceil(smootime/median(diff(Range(areas_pupil,'s')))),'omitnan');
    TSD1 = tsd(Range(areas_pupil) , D1);

    % Calculate occupation maps
    D2 = zscore(log10(Data(Restrict(SmoothGamma,areas_pupil))));
    D2(movstd(D2,10)>.2) = NaN;
    D2 = movmean(D2,ceil(smootime/median(diff(Range(areas_pupil,'s')))),'omitnan');
    TSD2 = tsd(Range(areas_pupil) , D2);
    
    % Pull out states
    clear Epoch Sleep Wake REMEpoch SWSEpoch Epoch_S1 Epoch_S2
    load(fullfile(datapath, 'SleepScoring_OBGamma.mat'), ...
        'Epoch', 'Sleep', 'Wake', 'REMEpoch', 'SWSEpoch', 'Epoch_S1', 'Epoch_S2');
    
    % Define NREM epochs (here defined as combinations of Sleep and sub-epochs)
    NREM_S1 = and(Sleep, Epoch_S2) - REMEpoch;
    NREM_S2 = and(Sleep, Epoch_S1) - REMEpoch;
    
    Epochs = {Epoch, Wake, Sleep, SWSEpoch, NREM_S1, NREM_S2, REMEpoch, or(Wake, SWSEpoch), or(Wake, NREM_S1)};
    Epoch_names = {'Full Session', 'Wake', 'Sleep', 'NREM', 'NREM1', 'NREM2', 'REM', 'Wake-NREM', 'Wake-NREM1'};
    
    % Populate the matrices with correlation and p-value data for this session
    for epoch = 1:length(Epochs)
        allPupilSizes(sess, epoch) = Restrict(TSD1, Epochs{epoch});
        OccupMaps(sess,epoch,:,:) = hist2d([Data(Restrict(TSD1 , Epochs{epoch})) ;-2; -2; 2; 2] , [Data(Restrict(TSD2 ,  Epochs{epoch})) ;-2; 2;-2; 2] , 100 , 100);
    end
end
    % Figures pupil vs brain correlations
fig_4_OB_ferret_paper(allPValues, allCorrelations, allPupilSizes, OccupMaps)

%% Under construction: Generate composition video
composition_video_OB_DLC_ferret
%% Under construction: Manual correction of outlier DLC scoring frames
% it could work but I was lazy and decided to smooth data instead AG 05/11/24
% Ferret_DLC_correct_outlier_coordinates(Session_params, datapath)
%% LEGACY: Manual initialization of sessions 
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

end