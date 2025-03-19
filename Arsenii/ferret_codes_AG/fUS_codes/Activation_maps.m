%to do: uncomment 151 line where you define the lenght of the fus trial. At Ln session it appears to be 31 instead of 32
animal = {'Edel', 'Chabichou'};
animal_choice = 1;
%% Parameters Edel
% Day sessions
% F - 1; G/W - 2; D - 3; S - 4; U - 6, E - 7; T - 10; C - 11

% Night session
% A/O - 5; K - 8; M - 9; J - 12

% To be added:
% G/W, B/M

% Select sessions Edel

% slots = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X'}; % Full dataset
% slots = {'A','B','C','D','E','F','G','H','I','J','K','L'}; %The first block
% slots = {'M','N','O','P','Q','R','S','T','U','V','W','X'}; %The second block
% slots = {'A','B','C','D','E','F','S','T','U','V','W','X'}; %Day-Night
% slots = {'G','H','I','J','K','L','M','N','O','P','Q','R'}; %Night-Day

% Selected
% slots = {'B','C','D','E','F','S','T','U','W'}; %Day-Night
% slots = {'I','J','K','L','M','N','O','P','Q','R'}; %Night-Day
% 'B' - fix the duration bug
% slots = {{'C','D','E','F','G','H','I','J','K','L'}; {'M','N','O','P','Q','R','S','T','U','V', 'W'}};

%% Parameters Chabichou
% cd('/home/arsenii/data5/Arsenii/Codes/')
% AddMyPaths_AG
% slots = {{'R','S','P','Q','N','O','C','F','G'};{'J','K','H','I','L','M','D','E','T','U'}}; 
slots = {{'V','S','P','Q','N','O','C','F','G'}}; 


data_name = {'raw_data', 'data_cat', 'data_aligned', 'data_CCA', 'data_cut_in_trials', 'data_cut_in_trials_data_cat', 'data_cut_in_trials_data_cat_all_phases'}';
sessions = {'Morning','Evening'}'; %'Morning' 'Evening'

%%
folder_code = 'Activation_maps';
figpath = ['/Figs/' folder_code '/'];

%% Stable params
comp = 'icelos'; % 'icelos' or 'biggerguy'

switch comp
    case 'biggerguy'
        prefix = '/mnt/working1/';
        
    case 'icelos'
        prefix = '/home/';
end

% figpath = ['/Figs/2023_analysis/Sound-Evoked_responses/' folder_code '/'];
datapath = [prefix 'arsenii/data5/Arsenii/React_Passive_AG/fUS/Processed_Data/' animal{animal_choice}];

% choose normalisation period
baseline_period = '3-5s'; % '1-12' ; '8-12' ; '8-12, single trial' this is points, not seconds. take another measure to see how much in seconds it is.
% Do you want to check the saved mask?
check_mask = 0;
% Plot fUS trigs?
plt=1;

ITI=400;

%%
for analysis_count = 2
    % Flags
    if analysis_count == 1
        data_flag = 1;
        data_cut_flag = 5;
        tag = 'with_CCA';
        fig_tag = 'with CCA';

    else
        data_flag = 2;
        data_cut_flag = 7;
        tag = 'without_CCA';
        fig_tag = 'without CCA';

    end
    
    %% group wise
    for group_count = 1:size(slots, 1)
        clear slotlist
        for i = 1:size(slots{group_count}, 2)
            slotlist(i) = slots{group_count}{i};
        end

        %% session wise
        for sess_count = 1:size(sessions, 1)
            
            if sessions{sess_count} == 'Morning'
                sess = 1;
            elseif sessions{sess_count} == 'Evening'
                sess = 2;
            end
            
            %% Plot the figures
            f1 = figure;
            sgtitle(['Activation maps ' fig_tag], 'FontSize', 24, 'FontWeight', 'bold')
            set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);            
            
            f2 = figure;
            sgtitle(['Sound-Evoked response ' fig_tag '. Auditory Cortex region'], 'FontSize', 24, 'FontWeight', 'bold')
            set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
            
            f3 = figure;
            sgtitle(['Sound-Evoked response ' fig_tag '. Hippocampal region. ACx scale'], 'FontSize', 24, 'FontWeight', 'bold')
            set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
            
            f4 = figure;
            sgtitle(['Sound-Evoked response ' fig_tag '. Hippocampal region. Hpc scale'], 'FontSize', 24, 'FontWeight', 'bold')
            set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
            
            
            %% slot wise
            for slot_count = 1:size(slots{group_count},2)
               
                %% Load data
                % Choose the day
                slot_code = slots{group_count}{slot_count};
                
                % Change path
%                 datapath = [prefix 'arsenii/data5/Arsenii/React_Passive_AG/fUS/Processed_Data/Edel'];
%                 dailypath = ['/' slot_code '/CCA/'];
                addpath(genpath([datapath '/' slot_code]))
                cd([datapath '/' slot_code]);
                
                % Load data
                load('params.mat')
                load('exp_info.mat')
                load(data_name{data_flag});
                data = eval(data_name{data_flag});
                load(data_name{data_cut_flag});
                
                if sess == 1
                    data_cut = eval([data_name{data_cut_flag} '_m']);
                elseif sess == 2
                    data_cut = eval([data_name{data_cut_flag} '_n']);
                end
                
                n_trials = size(data_cut, 3);
                
                disp(['Calculating ' slots{group_count}{slot_count} ', session ' params.session{sess} '...'])
                
                
                % Build an activation map
                switch baseline_period
                    case '1-12'
                        % Baseline normalization on the full exposure period (1-12). Mean over all 100 trials
                        baselineCBV = mean(data_cut(:,:,:,1:12),3:4);
                        title_case = 'baseline: 1-12';
                    case '3-5s'
                        %Baseline normalization on the short period before the exposure (3-5s). Mean over all 100 trials
                        baselineCBV = mean(data_cut(:,:,:,15:25),3:4);
                        title_case = 'baseline: 3-5s';
                        
                    case '8-12, single trial'
                        % Baseline normalization on the short period before the exposure (8-12). A dCBV for every single trial
                        baselineCBV = mean(data_cut(:,:,:,8:12),4);
                        title_case = 'baseline: 8-12, single trial';
                end
                
                % Calculate dCBV - normalized rawdatacut
                dCBV = (data_cut-baselineCBV)./baselineCBV;
                
                % Here we focus on the peak activation time (7-10s)
                activationMap = mean(dCBV(:,:,:,35:50),3:4);
                
                %% Assign indices
                
                % Load what exptparams from the Mfile
                mfilename = [datapath '/MatFiles/' '*REA_' params.slice{sess} '_' params.pair{sess} '_' params.session{sess} '*.m'];
                list_mfiles = dir(mfilename);
                
                if isempty(list_mfiles)
                    mfilename = [datapath '/MatFiles/' '*REA_' params.slice{sess} '_p' params.pair{sess} '_' params.session{sess} '*.m'];
                    list_mfiles = dir(mfilename);
                end
                
                run([datapath '/MatFiles/' list_mfiles.name])
                
                % Asign indices
                n_stim = n_trials;
                for i = 1:n_stim
                    stim = exptevents((i-1)*9+6).Note;
                    stim = split(stim, ' ');
                    stim = stim{3};
                    stim = split(stim, '_');
                    stim = stim(1);
                    index{i} = stim{1};
                end
                
                index = categorical(index);
                idx2 = index == index(1);
                
                %% Make sure you apply the mask you want
                
                data_cut_time_trial_mean = squeeze(mean(data_cut(:,:,:,:),3:4));
                
                
                load([pwd '/masks_' params.slice{sess} '_' params.pair{sess}])
                
                if sess == 1
                    ACx_mask = eval(['ACx_mask' '_m']);
                    Hpc_mask = eval(['Hpc_mask' '_m']);
                elseif sess == 2
                    ACx_mask = eval(['ACx_mask' '_n']);
                    Hpc_mask = eval(['Hpc_mask' '_n']);
                end
                
                
                if check_mask == 1
                    if exist('ACx_mask', 'var')
                        f10 = figure;
                        set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
                        sgtitle(['Masks. Slice №' params.slice{sess} '. Slot ' slot_code, '. Session ' params.session{sess}], 'FontSize', 40, 'FontWeight', 'bold')
                        
                        subplot(1, 2, 1)
                        imagesc(data_cut_time_trial_mean); axis equal tight;
                        subplot(1, 2, 2)
                        imfused_raw_acx = imfuse(data_cut_time_trial_mean, ACx_mask, 'Method', 'blend');
                        
                        if exist('Hpc_mask', 'var')
                            imfused_raw_acx_hpc = imfuse(imfused_raw_acx, Hpc_mask, 'Scaling', 'none', 'Method', 'blend');
                            imagesc(imfused_raw_acx_hpc); axis equal tight; colormap('turbo');
                        else
                            imagesc(imfused_raw_acx); axis equal tight; colormap('turbo');
                        end
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        %                 draw_new_mask = input('Would you like to draw another mask? (1/0) ');
                        draw_new_mask = 0;
                        
                    else
                        draw_new_mask = 1;
                    end
                else
                    draw_new_mask = 0;
                end
                
                if draw_new_mask == 1
                    %         close
                    satisfied = 0;
                    while satisfied == 0
                        % If you are not satisfied with the mask, you're welcome to redo it
                        disp("Let's draw masks")
                        f5 = figure('units', 'normalized', 'position', [0.1 0 .8 0.9],'Color','w');
                        mask_image = imagesc(data_cut_time_trial_mean); axis equal tight; colormap('turbo')
                        
                        sgtitle('Draw the mask for Auditory Cortex', 'FontSize', 40, 'FontWeight', 'bold')
                        ACx_mask = roipoly;
                        
                        sgtitle('Draw the mask for Hippocampus', 'FontSize', 40, 'FontWeight', 'bold')
                        Hpc_mask = roipoly;
                        
                        % sgtitle('Draw the mask for Auditory Thalamus', 'FontSize', 40, 'FontWeight', 'bold')
                        % Thlms_mask = roipoly;
                        close
                        % let's save the figure
                        f6 = figure;
                        set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
                        sgtitle(['Masks. Slice №' params.slice{1} '. Slot ' slot_code, '. Session ' params.session{sess}], 'FontSize', 40, 'FontWeight', 'bold')
                        
                        subplot(1, 2, 1)
                        imagesc(data_cut_time_trial_mean); axis equal tight;
                        subplot(1, 2, 2)
                        imfused_raw_acx = imfuse(data_cut_time_trial_mean, ACx_mask, 'Method', 'blend');
                        imfused_raw_acx_hpc = imfuse(imfused_raw_acx, Hpc_mask, 'Scaling', 'none', 'Method', 'blend');
                        imagesc(imfused_raw_acx_hpc); axis equal tight; colormap('turbo');
                        
                        satisfied = input('Satisfied with the mask? (1/0) ', 's');
                    end
                    save([pwd '/masks_' params.slice{sess} '_' params.pair{sess} '.mat'], 'ACx_mask', 'Hpc_mask')
                    saveas(gcf, [pwd '/masks_' params.slice{sess} '_' params.pair{sess}], 'png')
                    %         close
                    
                elseif draw_new_mask == 0
                    disp('checkpoint')
                    %         close
                end
                                
                %% Plot the Activation map
                set(0,'CurrentFigure',f1)
                subplot(3, 4, slot_count)
                
                imagesc(activationMap)
                caxis([-0.05, 0.25])
                colorbar
                colormap('parula')
                title(['Activation map. Slice №' params.slice{sess} '. Slot ' slot_code, '. Session ' params.session{sess}])
                hold on
                
                %% Plot the PSTH
                
                % Choose the mask
                choose_mask = {'ACx', 'Hpc', 'Hpc'};
                for mask_count = 1:size(choose_mask, 2)
                    disp(['Plotting PSTH for ' choose_mask{mask_count}])
                    
                    clear MaskIdx
                    if mask_count == 1
                        MaskIdx = ACx_mask(:);
                        set(0,'CurrentFigure',f2)
                        disp('Choosing ACx mask')
                    elseif mask_count == 2
                        MaskIdx = Hpc_mask(:);
                        set(0,'CurrentFigure',f3)
                        disp('Choosing Hpc mask. ACx scale')
                    elseif mask_count == 3
                        MaskIdx = Hpc_mask(:);
                        set(0,'CurrentFigure',f4)
                        disp('Choosing Hpc mask. Hpc scale')
                    elseif mask_count == 4
                        MaskIdx = Thlm_mask(:);
                        disp('Choosing Thalamus mask')
                    end
                    
                    % Prepare data. datacut is [ time x all trials x ACx voxels ]
                    clear datacut
                    for t = 1:size(dCBV,4)
                        for trial = 1:size(dCBV,3)
                            temp = dCBV(:,:,trial,t);
                            datacut(t,trial,:) = temp(MaskIdx);
                        end
                    end
                    
                    d1 = datacut(:, idx2, :);
                    d2 = datacut(:, ~idx2, :);
                    
                    datacut_merge{mask_count} = datacut;
                    d1_merge{mask_count} = d1;
                    d2_merge{mask_count} = d2;
                    
                    subplot(3, 4, slot_count)
                    PSTH_figure(d1, d2, choose_mask{mask_count}, params, slot_code, sess, index, mask_count)
                    hold on
                end
                
                %% Plot raw traces
                [f5, f6] = raw_signal_figure(data, datacut_merge, d1_merge, d2_merge, dCBV, ACx_mask, Hpc_mask, params, sess, datapath, exp_info, slot_code, analysis_count);
                set(0,'CurrentFigure',f5)
                saveas(gcf, [pwd '/figs/' folder_code '/average_activation_' tag '_' slot_code params.session{sess}], 'svg')
                set(0,'CurrentFigure',f5)
                saveas(gcf, [pwd '/figs/' folder_code '/average_activation_' tag '_' slot_code params.session{sess}], 'png')
                
                set(0,'CurrentFigure',f6)
                saveas(gcf, [pwd '/figs/' folder_code '/traces_trials_' tag '_' slot_code params.session{sess}], 'svg')
                set(0,'CurrentFigure',f6)
                saveas(gcf, [pwd '/figs/' folder_code '/traces_trials_' tag '_' slot_code params.session{sess}], 'png')
                
                close(f5)

                %% Clear variables
                clearvars -except sessions slot_count sess_count analysis_count group_count slots slotlist folder_code...
                    data_name data_flag data_cut_flag tag fig_tag...
                    comp prefix sess...
                    baseline_period check_mask plt ITI...
                    f1 f2 f3 f4...
                    datapath figpath...
                    params
                
            end
            set(0,'CurrentFigure',f1)
            saveas(gcf, [datapath figpath 'Activation_maps' '_' tag '_' params.session{sess} '_' slotlist], 'svg')
            saveas(gcf, [datapath figpath 'Activation_maps' '_' tag '_' params.session{sess} '_' slotlist], 'png')
            set(0,'CurrentFigure',f2)
            saveas(gcf, [datapath figpath 'ACx_PSTH' '_' tag '_' params.session{sess} '_' slotlist], 'svg')
            saveas(gcf, [datapath figpath 'ACx_PSTH' '_' tag '_' params.session{sess} '_' slotlist], 'png')
            set(0,'CurrentFigure',f3)
            saveas(gcf, [datapath figpath 'Hpc_PSTH_ACx_scale' '_' tag '_' params.session{sess} '_' slotlist], 'svg')
            saveas(gcf, [datapath figpath 'Hpc_PSTH_ACx_scale' '_' tag '_' params.session{sess} '_' slotlist], 'png')
            set(0,'CurrentFigure',f4)
            saveas(gcf, [datapath figpath 'Hpc_PSTH_Hpc_scale' '_' tag '_' params.session{sess} '_' slotlist], 'svg')
            saveas(gcf, [datapath figpath 'Hpc_PSTH_Hpc_scale' '_' tag '_' params.session{sess} '_' slotlist], 'png')
            
            clear f1 f2 f3 f4 f5 f6
        end
    end
end