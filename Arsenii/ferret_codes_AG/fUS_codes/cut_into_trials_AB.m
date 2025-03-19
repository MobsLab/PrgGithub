function [y_reshaped, t_query] = cut_into_trials_AB(y, sess, f_trigs, b_trigs, plt, exp_info, params, phase)

%% Special case for F1 Chabichou
% b_trigs = [b_trigs(1:162)' b_trigs(162)+1000 b_trigs(162)+2000 b_trigs(163:end)']';

%% Special case for I1 Chabichou
% b_trigs(31) = [];
% b_trigs(31) = [];
% b_trigs(31) = [];

%% this is the way to compensate for the missing triggers and recover the full timeline, assuming that the frame rate is regular, but I need to imaging something cleaner
disp(['number of missed trigs: ' num2str(sum(diff(f_trigs)>450))])
missing_fUS_trigs_idx = find(diff(f_trigs)>450);

t_fus_recovered = f_trigs;


%% Recover the missing triggers and remove inserted
t_fus = 0;
count = 1;
while length(t_fus) ~= size(y,3)
    disp(['recovering triggers. Count #' num2str(count)])
    sup_count = 0;
    for trig_count = 1:size(missing_fUS_trigs_idx,1)
        t_fus_recovered = [t_fus_recovered(1:missing_fUS_trigs_idx(trig_count)+sup_count); (t_fus_recovered(missing_fUS_trigs_idx(trig_count)+sup_count) + t_fus_recovered(missing_fUS_trigs_idx(trig_count)+sup_count+1))/2; (t_fus_recovered(missing_fUS_trigs_idx(trig_count)+sup_count+1:end))];
        sup_count = sup_count + 1;
    end
    
    false_fUS_trigs_idx = find(diff(t_fus_recovered)<300);
    t_fus_recovered(false_fUS_trigs_idx) = [];
    
    missing_fUS_trigs_idx = find(diff(t_fus_recovered)>450);
    
    if length(t_fus_recovered) > size(y, 3)
        t_fus_recovered(end) = [];
    end
    t_fus = t_fus_recovered/1000; %fUS trigger timestamps in seconds
    count = count + 1;
end

%% Extract the timings of stimuli - relevant for AB version
% % 3 x n_trials => [start_stim, continue_stim, end stim; start_stim, continue_stim, end_stim; ...]
%
% % Define the block size
% block_size = 11;
%
% % Preallocate an array to store the extracted elements
% extracted_stim_trigs = [];
%
% % Loop through the array and extract elements
% for i = 1:block_size:1100
%     block = b_trigs(i:i+block_size-1);
%     extracted_indices = 6:8;  % Calculate indices within the block
%     extracted_stim_trigs = [extracted_stim_trigs, block(extracted_indices)];
% end
%
% t_onset = extracted_stim_trigs(1,:)'/1e3;
% n_trials = length(t_onset);

%% Extract the beginning and the end of baphy trial - relevant for AG version
% Find indices of the last b_trig before the break of 2050 ms duration
BetweenTrialsBreak = find(diff(b_trigs)>2050);
% BetweenTrialsBreak(find(diff(BetweenTrialsBreak)<10)) = [];
% BetweenTrialsBreak = [BetweenTrialsBreak(1:find(diff(BetweenTrialsBreak)>10))

NewTrialsBaphy = [b_trigs(1); b_trigs(BetweenTrialsBreak+1)];
if b_trigs(end)>f_trigs(end)
    disp('Beware, your fUS ends before baphy. I''m cutting the number of trials')
    NewTrialsBaphy(end) = [];
end


n_trials = size(NewTrialsBaphy,1);
if n_trials ~= 100
    disp('Revisit this one. You have an issue with number of trials')
end
%% Building the query

% Centering on the onset of the baphy trial + 12 seconds
t_query = repmat(NewTrialsBaphy/1e3,[1,61])+repmat(0:.2:12,[n_trials,1]);

t_q = sort(t_query(:));
y_q = interp1(t_fus,permute(y, [3 1 2]),t_q);
y_q = permute(y_q, [2 3 1]);

% compose the trials times and values
t_reshaped=reshape(t_q,[61,n_trials]);
y_reshaped=reshape(y_q,[size(y_q, 1), size(y_q, 2), 61, n_trials]);
y_reshaped = permute(y_reshaped, [1 2 4 3]);

%% Some irrelevant figures
if plt == 1
    
    %     % Quickly glance through all trials
    %     figure
    %     for i = 1:100
    %         plot(squeeze(mean(y_reshaped(:, :, i, :), 1:2)))
    %         pause(0.2)
    %     end
    
    
    fig_visibility = 'off';
    f1 = figure('Visible', fig_visibility);
    subplot(2,1,1)
    sgtitle(['Result overview'], 'FontWeight', 'bold', 'FontSize', 23)
    %             set(f1, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    set(f1, 'Units', 'Normalized', 'Position', [0.0146 0 0.5000 0.9124]);
    hold all
    scatter(f_trigs,ones(length(f_trigs),1),'+');
    scatter(b_trigs,1.21*ones(length(b_trigs),1),'r+');
    %     missing_trigs = find(diff(f_trigs)>ITI+50);
    %     scatter(f_trigs(missing_trigs)+ITI,0.9*ones(length(missing_trigs),1),'g+');
    scatter(f_trigs(missing_fUS_trigs_idx),0.9*ones(length(missing_fUS_trigs_idx),1),'g+');
    scatter(t_fus_recovered,0.7*ones(length(t_fus_recovered),1),'+');
    ylim([0 3])
    
    %     figure
    %     subplot(153)
    %     imagesc(squeeze(mean(y_reshaped, 1:2)))
    %     xline(25, 'r', 'LineWidth', 2) % mark the onset of the sound
    %     xline(35, 'r', 'LineWidth', 2) % mark the offset of the sound
    
    %     figure
    %     imagesc(t_reshaped)

    
    % Check that mean datacut is not very different from the mean original data
    %     figure;
    %     subplot(121);
    %     imagesc(mean(y_reshaped, 3:4));
    %     subplot(122);
    %     imagesc(mean(data(:, :, :, sess), 3))
    
    
    
    %     hplot = figure;
    %     sgtitle(['Slice ' params.slice{sess} ' pair ' params.pair{sess} ' session ' params.session{sess}], 'FontWeight', 'bold')
    %     subplot(211)
    %     title('after CCA')
    subplot(2,1,2)
    hold all
    plot(t_fus,squeeze(mean(y, 1:2)), 'LineWidth', 2)
    plot(t_q,squeeze(mean(y_q, 1:2)),'ro')
    
    % plot trials
    for i = 1:n_trials
        % stims
        x_stim = [t_query(i, 25), t_query(i, 35), t_query(i, 35),t_query(i, 25)];
        y_patch = [6, 6, 12, 12];  % Assuming a y-range from 0 to 10
        patch(x_stim, y_patch, 'r', 'FaceAlpha', 0.3);  % 'b' for blue color, 0.3 for transparency
        % trials
        x_patch = [t_query(i, 1), t_query(i, end), t_query(i, end), t_query(i, 1)];
        patch(x_patch, y_patch, 'b', 'FaceAlpha', 0.3);  % 'b' for blue color, 0.3 for transparency
    end
    
    %         scatter((b_trigs/1e3)*2.5,11*ones(length(b_trigs),1),'+');
    scatter((b_trigs/1e3),11*ones(length(b_trigs),1),'b+');
    
    
%     scatter((b_trigs(163)/1e3),12*ones(length(b_trigs),1),'r+');

    %     subplot(212)
    %     title('before CCA')
    %     if sess == 1
    %         data_temp = squeeze(data_cat(:,:,exp_info.size{1}(3):exp_info.size{1}(3)*2-1,sess));
    %     elseif sess == 2
    %         data_temp = squeeze(data_cat(:,:,exp_info.size{4}(3):exp_info.size{4}(3)*2-1,sess));
    %     end
    %
    %
    %     hold all
    %     plot(t_fus,squeeze(mean(data_temp, 1:2)), 'LineWidth', 2)
    %
    %     % plot trials
    %     for i = 1:n_trials
    %         % stims
    %         x_stim = [t_query(i, 25), t_query(i, 35), t_query(i, 35),t_query(i, 25)];
    %         y_patch = [6, 6, 12, 12];  % Assuming a y-range from 0 to 10
    %         patch(x_stim, y_patch, 'r', 'FaceAlpha', 0.3);  % 'b' for blue color, 0.3 for transparency
    %         % trials
    %         x_patch = [t_query(i, 1), t_query(i, end), t_query(i, end), t_query(i, 1)];
    %         patch(x_patch, y_patch, 'b', 'FaceAlpha', 0.3);  % 'b' for blue color, 0.3 for transparency
    %     end
    %
    %     %         scatter((b_trigs/1e3)*2.5,11*ones(length(b_trigs),1),'+');
    %     scatter((b_trigs/1e3),11*ones(length(b_trigs),1),'+');
    %     linkaxes([subplot(211) subplot(212)], 'x')
    if phase == 1
        name = 'PreExp';
    elseif phase == 2
        name = 'Exp';
    elseif phase == 3
        name = 'PostExp';        
    end
    saveas(f1, ['/home/arsenii/data5/Arsenii/React_Passive_AG/fUS/Processed_Data/Chabichou/Figs/Dataset_overview/' 'svg/' 'cutting_to_trials_check_' params.slice{1} '_' params.pair{1} '_' name '_sess_' num2str(sess)], 'svg')
    saveas(f1, ['/home/arsenii/data5/Arsenii/React_Passive_AG/fUS/Processed_Data/Chabichou/Figs/Dataset_overview/' 'cutting_to_trials_check_' params.slice{1} '_' params.pair{1} '_' name '_sess_' num2str(sess)], 'png')
    close all
    
    
end
end