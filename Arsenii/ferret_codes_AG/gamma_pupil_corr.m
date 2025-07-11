function gamma_pupil_corr(datapath)
%% gamma_pupil_corr
% This function calculates correlations and distributions between OB gamma (and
% other brain power signals) and pupil parameters.
%
% Epochs are used to compare states:
%   - For no drugs sessions
%   - For Atropine/Saline: before injection vs after injection.
%   - For Domitor: before injection, during Domitor, and after Antisedan.
%
% The script assumes that DLC data (and derived parameters) and ephys signals
% are already synchronized (via synchronized_DLC_data.csv and SleepScoring_OBGamma.mat).

%% -------------------- Initialization --------------------
smootime = 3;
FigFolder = fullfile(datapath, 'DLC', 'Figures', 'brain_pupil_corr');

[~, Session_params.session_selection, ~] = fileparts(datapath);
if contains(Session_params.session_selection, 'atropine') || contains(Session_params.session_selection, 'LSP')
    Session_params.pharma = 'atropine';
elseif contains(Session_params.session_selection, 'domitor')
    Session_params.pharma = 'domitor';    
elseif contains(Session_params.session_selection, 'saline')
    Session_params.pharma = 'saline';       
else
    Session_params.pharma = 'no drugs';       
end

Session_params.fig_visibility = 'off';

if contains(datapath, 'Shropshire')
    Session_params.animal_name = 'Shropshire';
elseif contains(datapath, 'Brynza')
    Session_params.animal_name = 'Brynza';
elseif contains(datapath, 'Labneh')
    Session_params.animal_name = 'Labneh';
end

disp(['Processing session: '  Session_params.animal_name ' ' Session_params.session_selection]);

%% NOT DONE AND NOT USED YET: Filtering pupil data
% cd([datapath '/DLC'])
% file=dir([Session_params.animal_name{Session_params.animal_selection} '*filtered.csv']);
% 
% filename=file.name; disp(['DLC data: ' filename]) %don't forget to specify the csv if you have many
% pathname=pwd;
% data=csvread(fullfile(pathname,filename),3); %loads the csv from line 3 to the end (to skip the Header)
% 
% % Compute the thresholds
% likelihood_pupil = data(:, 4:3:25);
% 
% % Not sure it is the best approach!
% lower_threshold = mean(mean(likelihood_pupil) - 2 * std(likelihood_pupil));
% upper_threshold = mean(mean(likelihood_pupil) + 2 * std(likelihood_pupil));
% 
% % Compute filtered data
% temp_p_areas = Data(areas_pupil);
% 
% filtered_pupil_x = temp_p_areas(all(likelihood_pupil >= (mean(likelihood_pupil,1:2) - 2*mean(std(likelihood_pupil))), 2), :);
% 
% % !!!! Rewriting variable !!!!
% time = ts(time_s(find(all(likelihood_pupil >= lower_threshold & likelihood_pupil <= upper_threshold, 2) == 1))*1e4);
% pupil_x = tsd(Range(time), filtered_pupil_x);
% pupil_y = tsd(Range(time), filtered_pupil_y);
% areas_pupil = Restrict(areas_pupil, time);
% pupil_center = Restrict(pupil_center, time);
% pupil_mvt_tsd = Restrict(pupil_mvt_tsd, time);
% % !!!! Rewriting variable !!!!

%% -------------------- Load LFP Power Data --------------------
% Load basic LFP power traces (OB Gamma, Theta, 0.1-0.5 Hz) from file.
load(fullfile(datapath, 'SleepScoring_OBGamma.mat'), 'SmoothGamma', 'SmoothTheta', 'smooth_01_05');

%% -------------------- Load DLC Data --------------------
% Change to DLC folder and load previously saved DLC parameters.
load([fullfile(datapath, 'DLC/') 'DLC_data.mat'], 'areas_pupil', 'pupil_mvt', 'velocity_nostril_center');

%% -------------------- Load and Define Epochs --------------------
% Load epoch definitions and additional brain power variables.
load(fullfile(datapath, 'SleepScoring_OBGamma.mat'), ...
    'Epoch', 'Sleep', 'Wake', 'REMEpoch', 'SWSEpoch', 'Epoch_S1', 'Epoch_S2');

% Define NREM epochs (here defined as combinations of Sleep and sub-epochs)
NREM_S1 = and(Sleep, Epoch_S2) - REMEpoch; 
NREM_S2 = and(Sleep, Epoch_S1) - REMEpoch;

Epochs = {Epoch, Wake, Sleep, NREM_S1, NREM_S2, REMEpoch, or(Wake, SWSEpoch), or(Wake, NREM_S1)};
Epoch_names = {'Full Session', 'Wake', 'Sleep', 'NREM1', 'NREM2', 'REM', 'Wake-NREM', 'Wake-NREM1'};
Epoch_names_save = {'Full_Session', 'Wake', 'Sleep', 'NREM1', 'NREM2', 'REM', 'Wake_NREM', 'Wake_NREM1'};

% Define colours for plotting each epoch (as cell array of two colours per epoch)
colours = { {[0 0 0], [1 0.5 0]}; ...         % Full Session
            {[0 0 1], [0.2 0.75 1]}; ...        % Wake
            {[1 0 0], [1 0.5 0.75]}; ...         % Sleep
            {[1 0.71 0.76], [1.0, 0.82, 0.86]}; ...  % NREM1
            {[0.55 0 0], [0.71, 0.20, 0.20]}; ... % NREM2
            {[0 1 0], [0.75 1 0.5]}; ...         % REM
            {[0.5 0 0.5], [0.2 0.6 0.5]}; ...      % Wake-NREM
            {[0.50 0.35 0.88], [0.2 0.6 0.5]} };   % Wake-NREM1

%% -------------------- Load Additional LFP Power Data (for Cortex/PFC/HPC) --------------------
if contains(Session_params.animal_name, 'Brynza') || contains(Session_params.animal_name, 'Shropshire')
    if contains(Session_params.animal_name, 'Brynza')
        channels = [1 11 21 13]; % AuCx, OB, HPC, PFC for Brynza
    elseif contains(Session_params.animal_name, 'Shropshire')
        channels = [65 21 18 12]; % AuCx, OB, HPC, PFC for Shropshire
    end
    load(fullfile(datapath, 'SleepScoring_OBGamma.mat'), 'SmoothACxGamma', 'SmoothHPCGamma', 'SmoothPFCGamma');
    if ~exist('SmoothHPCGamma', 'var') || ~exist('SmoothACxGamma', 'var') || ~exist('SmoothPFCGamma', 'var')
        load(fullfile(datapath, 'SleepScoring_OBGamma.mat'), 'Epoch');
        minduration = 3;
        foldername = datapath;
        % HPC
        load(strcat([datapath,'/LFPData/LFP',num2str(channels(3)),'.mat']));
        FilGamma = FilterLFP(LFP,[40 60],1024); % filtering
        tEnveloppeGamma = tsd(Range(LFP), abs(hilbert(Data(FilGamma))) );
        SmoothHPCGamma = tsd(Range(tEnveloppeGamma), runmean(Data(tEnveloppeGamma), ...
            ceil(smootime/median(diff(Range(tEnveloppeGamma,'s'))))));
        close;
        clear LFP FilGamma tEnveloppeGamma
        % PFC
        load(strcat([datapath,'/LFPData/LFP',num2str(channels(4)),'.mat']));
        FilGamma = FilterLFP(LFP,[40 60],1024); % filtering
        tEnveloppeGamma = tsd(Range(LFP), abs(hilbert(Data(FilGamma))) );
        SmoothPFCGamma = tsd(Range(tEnveloppeGamma), runmean(Data(tEnveloppeGamma), ...
            ceil(smootime/median(diff(Range(tEnveloppeGamma,'s'))))));
        close;
        clear LFP FilGamma tEnveloppeGamma
        % ACx
        load(strcat([datapath,'/LFPData/LFP',num2str(channels(1)),'.mat']));
        FilGamma = FilterLFP(LFP,[40 60],1024); % filtering
        tEnveloppeGamma = tsd(Range(LFP), abs(hilbert(Data(FilGamma))) );
        SmoothACxGamma = tsd(Range(tEnveloppeGamma), runmean(Data(tEnveloppeGamma), ...
            ceil(smootime/median(diff(Range(tEnveloppeGamma,'s'))))));
        close;
        clear LFP FilGamma tEnveloppeGamma
        save(fullfile(datapath, 'SleepScoring_OBGamma.mat'), 'SmoothHPCGamma', 'SmoothPFCGamma', 'SmoothACxGamma', '-append');
    end
end

%% -------------------- Smoothing of DLC and Brain Signals  !!!! Rewriting variables !!!! --------------------
disp('I rewrite varibales areas_pupil; pupil_mvt; SmoothGamma; smooth_01_05; SmoothTheta; SmoothHPCGamma; SmoothPFCGamma; SmoothACxGamma')

% Smooth DLC parameters using runmean.
areas_pupil = tsd(Range(areas_pupil), runmean(Data(areas_pupil), ceil(smootime/median(diff(Range(areas_pupil, 's'))))));
pupil_mvt = tsd(Range(pupil_mvt), runmean(Data(pupil_mvt), ceil(smootime/median(diff(Range(pupil_mvt, 's'))))));

% Smooth brain power signals.
SmoothGamma = tsd(Range(SmoothGamma), runmean(Data(SmoothGamma), ceil(smootime/median(diff(Range(SmoothGamma, 's'))))));
smooth_01_05 = tsd(Range(smooth_01_05), runmean(Data(smooth_01_05), ceil(smootime/median(diff(Range(smooth_01_05, 's'))))));
SmoothTheta = tsd(Range(SmoothTheta), runmean(Data(SmoothTheta), ceil(smootime/median(diff(Range(SmoothTheta, 's'))))));
if contains(Session_params.animal_name, 'Brynza') || contains(Session_params.animal_name, 'Shropshire')
    SmoothHPCGamma = tsd(Range(SmoothHPCGamma), runmean(Data(SmoothHPCGamma), ceil(smootime/median(diff(Range(SmoothHPCGamma, 's'))))));
    SmoothPFCGamma = tsd(Range(SmoothPFCGamma), runmean(Data(SmoothPFCGamma), ceil(smootime/median(diff(Range(SmoothPFCGamma, 's'))))));
    SmoothACxGamma = tsd(Range(SmoothACxGamma), runmean(Data(SmoothACxGamma), ceil(smootime/median(diff(Range(SmoothACxGamma, 's'))))));
end

%% -------------------- Z-Scoring --------------------
SmoothGamma_zs = tsd(Range(SmoothGamma), zscore(Data(SmoothGamma)));
SmoothTheta_zs = tsd(Range(SmoothTheta), zscore(Data(SmoothTheta)));
smooth_01_05_zs = tsd(Range(smooth_01_05), zscore(Data(smooth_01_05)));
if contains(Session_params.animal_name, 'Brynza') || contains(Session_params.animal_name, 'Shropshire') 
    SmoothHPCGamma_zs = tsd(Range(SmoothHPCGamma), zscore(Data(SmoothHPCGamma)));
    SmoothPFCGamma_zs = tsd(Range(SmoothPFCGamma), zscore(Data(SmoothPFCGamma)));
    SmoothACxGamma_zs = tsd(Range(SmoothACxGamma), zscore(Data(SmoothACxGamma)));
end
areas_pupil_zs = tsd(Range(areas_pupil), zscore(Data(areas_pupil)));
pupil_mvt_zs = tsd(Range(pupil_mvt), zscore(Data(pupil_mvt)));
velocity_nostril_center_zs = tsd(Range(velocity_nostril_center), zscore(Data(velocity_nostril_center)));

%% -------------------- Restrict Variables to Epochs --------------------
for i = 1:length(Epochs)
    % Behavioral/DLC parameters
    pupil_mvt_r{i} = Restrict(pupil_mvt, Epochs{i});
    areas_pupil_r{i} = Restrict(areas_pupil, Epochs{i});
    velocity_nostril_center_r{i} = Restrict(velocity_nostril_center, Epochs{i});
    
    pupil_mvt_r_zs{i} = Restrict(pupil_mvt_zs, Epochs{i});
    areas_pupil_r_zs{i} = Restrict(areas_pupil_zs, Epochs{i});
    velocity_nostril_center_r_zs{i} = Restrict(velocity_nostril_center_zs, Epochs{i});
    
    % OB Power traces
    SmoothGamma_r{i} = Restrict(SmoothGamma, Epochs{i});
    Smooth_01_05_r{i} = Restrict(smooth_01_05, Epochs{i});
    SmoothTheta_r{i} = Restrict(SmoothTheta, Epochs{i});
    SmoothGamma_r_zs{i} = Restrict(SmoothGamma_zs, Epochs{i});
    Smooth_01_05_r_zs{i} = Restrict(smooth_01_05_zs, Epochs{i});
    SmoothTheta_r_zs{i} = Restrict(SmoothTheta_zs, Epochs{i});
    
    if contains(Session_params.animal_name, 'Brynza') || contains(Session_params.animal_name, 'Shropshire') 
        SmoothHPCGamma_r{i} = Restrict(SmoothHPCGamma, Epochs{i});
        SmoothHPCGamma_r_zs{i} = Restrict(SmoothHPCGamma_zs, Epochs{i});
        SmoothPFCGamma_r{i} = Restrict(SmoothPFCGamma, Epochs{i});
        SmoothPFCGamma_r_zs{i} = Restrict(SmoothPFCGamma_zs, Epochs{i});
        SmoothACxGamma_r{i} = Restrict(SmoothACxGamma, Epochs{i});
        SmoothACxGamma_r_zs{i} = Restrict(SmoothACxGamma_zs, Epochs{i});
    end
end

% Assemble brain power signals into cell arrays.
brain_signals = {SmoothGamma_r, Smooth_01_05_r, SmoothTheta_r};
brain_signals_zs = {SmoothGamma_r_zs, Smooth_01_05_r_zs, SmoothTheta_r_zs};
brain_signals_names = {'OB Gamma', 'OB 0.1-0.5Hz', 'HPC Theta/Delta'};
brain_signals_names_save = {'OB_Gamma', 'OB_01_05Hz', 'HPC_Theta_Delta'};
if contains(Session_params.animal_name, 'Brynza') || contains(Session_params.animal_name, 'Shropshire') 
    brain_signals = [brain_signals {SmoothHPCGamma_r, SmoothPFCGamma_r, SmoothACxGamma_r}];
    brain_signals_zs = [brain_signals_zs {SmoothHPCGamma_r_zs, SmoothPFCGamma_r_zs, SmoothACxGamma_r_zs}];
    brain_signals_names = [brain_signals_names {'HPC Gamma', 'PFC Gamma', 'ACx Gamma'}];
    brain_signals_names_save = [brain_signals_names_save {'HPC_Gamma', 'PFC_Gamma', 'ACx_Gamma'}];
end
  
%% -------------------- f1) Time Evolution: Brain Power vs. Pupil Size --------------------
clear f i
for i = 1:length(brain_signals_zs)
    f{i} = figure('Visible', Session_params.fig_visibility);
    set(f{i}, 'Units', 'Normalized', 'Position', [0 0 1 1]);
    sgtitle(['Time evolution of ' brain_signals_names{i} ' power and pupil size (z-scored). ' ...
        Session_params.animal_name '. Session: ' Session_params.session_selection ...
        '. ' Session_params.pharma], 'FontWeight', 'bold');
    
    % Plot full session signals (subplot 1)
    subplot(3,1,1)
    plot(Range(brain_signals_zs{i}{1}, 'min'), Data(brain_signals_zs{i}{1}), '.k', 'MarkerSize', 3);
    hold on;
    plot(Range(areas_pupil_r_zs{1}, 'min'), Data(areas_pupil_r_zs{1}), '.', 'MarkerSize', 3, 'color', [1 0.5 0]);
    a = Range(brain_signals_zs{i}{1}, 'min');
    len = a(end);
    xlim([0 len]);
    xlabel('Time (min)');
    ylabel('Z-scored power');
    legend({brain_signals_names{i}, 'Pupil size'}, 'location', 'southwest');
    
    % Plot state-specific segments (subplot 2)
    subplot(3,1,2)
    hold on;
    for j = [2, 4, 5, 6]
        plot(Range(brain_signals_zs{i}{j}, 'min'), Data(brain_signals_zs{i}{j}), '.', 'MarkerSize', 3, 'color', colours{j}{1});
        plot(Range(areas_pupil_r_zs{j}, 'min'), Data(areas_pupil_r_zs{j}), '.', 'MarkerSize', 3, 'color', colours{j}{2});
    end
    xlim([0 len]);
    title([brain_signals_names{i} ' power & pupil size (states)']);
    xlabel('Time (min)'); ylabel('Z-scored power');
    legend({[brain_signals_names{i} ' ' Epoch_names{2}], ['Pupil area ' Epoch_names{2}], ...
        [brain_signals_names{i} ' ' Epoch_names{4}], ['Pupil area ' Epoch_names{4}], ...
        [brain_signals_names{i} ' ' Epoch_names{5}], ['Pupil area ' Epoch_names{5}], ...
        [brain_signals_names{i} ' ' Epoch_names{6}], ['Pupil area ' Epoch_names{6}]}, 'location', 'southwest');
    
end

% Save f1 figures
if ~exist(FigFolder, 'dir')
    mkdir(FigFolder);
end

for i = 1:length(f)
    saveas(f{i}, fullfile(FigFolder, ...
        [brain_signals_names_save{i} '_pupil_size_time_evolution_' Session_params.session_selection '.svg']));
end
close all

%% -------------------- f2) Correlation Scatter: Pupil Size vs. OB Gamma --------------------
clear f i
for i = 1:length(brain_signals)
    for j = 1:length(Epochs)
        if ~isempty(Range(areas_pupil_r{j}))
            
            Data_brain_r = log10(Data(brain_signals{i}{j}));
            Data_areas_pupil_r = Data(Restrict(areas_pupil_r{j}, brain_signals{i}{j}));
            
            f{j} = figure('Visible', Session_params.fig_visibility);
            set(f{j}, 'Units', 'Normalized', 'Position', [1, 1, 0.44, 0.76]);
            sgtitle(['Correlation between pupil size and ' brain_signals_names{i} ' power in ' Epoch_names{j}], 'FontWeight', 'bold');
            
            % Subplot for brain power histogram
            sp_1{j} = subplot(6,6,32:36);
            [Y, X] = hist(Data_brain_r, 1000);
            a_hist = area(X, runmean(Y, 10));
            a_hist.FaceColor = [0.8 0.8 0.8];
            a_hist.LineWidth = 3; a_hist.EdgeColor = [0 0 0];
            box off;
            xlabel([brain_signals_names{i} ' power (log scale)']);
            ax1{j} = ancestor(sp_1{j}, 'axes');
            
            % Subplot for pupil size histogram
            sp_2{j} = subplot(6,6, [25 19 13 7 1]);
            [Y, X] = hist(Data_areas_pupil_r, 1000);
            a_hist = area(X, runmean(Y, 10));
            a_hist.FaceColor = [0.8 0.8 0.8];
            a_hist.LineWidth = 3; a_hist.EdgeColor = [0 0 0];
            set(gca, 'XDir', 'reverse'), camroll(270), box off;
            xlabel('Pupil size');
            ax2{j} = ancestor(sp_2{j}, 'axes');
            
            % Scatter plot: brain power vs. pupil size
            sp_3{j} = subplot(6,6, [2:6 8:12 14:18 20:24 26:30]);
            hold on;
            plot(Data_brain_r(1:2000:end), Data_areas_pupil_r(1:2000:end), '.', 'MarkerSize', 4, 'color', colours{j}{1});
            xticks([]); yticks([]);
            ax3{j} = ancestor(sp_3{j}, 'axes');
            link_axes_callback = @(~, ~) set(ax3{j}, 'YLim', get(ax2{j}, 'XLim'));
            addlistener(ax2{j}, 'XLim', 'PostSet', link_axes_callback);
            link_axes_callback();
            linkaxes([sp_3{j}, sp_1{j}], 'x');
            axis square;
            
            % Downsample for correlation and p-value calculation
            numSamples = 1000;
            rng(1); % For reproducibility
            idx = randperm(length(Data_brain_r), numSamples);
            [correlations{i}{j}, pval{i}{j}] = corr(Data_brain_r(idx), Data_areas_pupil_r(idx));
            % PlotCorrelations_BM(Data_brain_r(1:10000:end) , Data_areas_pupil_r(1:10000:end), 'color', 'k', 'Marker_Size', 1)
            
            hold on;
            p_fit = polyfit(Data_brain_r(idx), Data_areas_pupil_r(idx), 1);
            x_fit = [min(Data_brain_r(idx))*1.1, max(Data_brain_r(idx))*1.1];
            y_fit = x_fit * p_fit(1) + p_fit(2);
            line(x_fit, y_fit, 'Color', 'r', 'LineWidth', 2);
            
            
            a=p_fit(1); b=p_fit(2);
            
            %         k = get(gca,'Children'); legend(['R = ' num2str(correlations{i}{j}) '     P = ' num2str(pval{i}{j})]);
            l = [ax3{j}.XLim ax3{j}.YLim];
            %     LINE = [l(1)*.8 l(2)*.8 ; a*l(1)+b a*l(2)+b];
            LINE = [l(1) l(2) ; a*l(1)+b a*l(2)+b];
            
            line([LINE(1,1) LINE(1,2)] , [LINE(2,1) LINE(2,2)] , 'Color' , 'r' , 'LineWidth' , 2)
            
            % Annotate plot with correlation values
            subplot(sp_3{j});
            annotationText = sprintf('r = %.2f\np = %.2e', correlations{i}{j}, pval{i}{j});
            xText = ax3{j}.XLim(1) + 0.05 * diff(ax3{j}.XLim);
            yText = ax3{j}.YLim(2) - 0.1 * diff(ax3{j}.YLim);
            text(xText, yText, annotationText, 'FontWeight', 'bold', 'FontSize', 10, 'Color', 'k');
            pause(0.1);
            % Save figures
            saveas(f{j}, fullfile(FigFolder, [brain_signals_names_save{i} '_pupil_size_corr_' Epoch_names_save{j} '_' Session_params.session_selection '.svg']))
        end
    end
end

brain_pupil_corr = [correlations; pval]';
save(fullfile(datapath, 'SleepScoring_OBGamma.mat'), 'brain_pupil_corr', '-append');

%% -------------------- f3) Pupil Size Distributions in Substates --------------------
clear j i f
f{1} = figure('Visible', Session_params.fig_visibility);
set(f{1}, 'Units', 'Normalized', 'Position', [1, 1, 0.44, 0.76]);
for j = [2, 4, 5, 6]
    [Y, X] = hist(Data(areas_pupil_r{j}), 1000);
    Y = Y/sum(Y);
    hold on;
    plot(X, runmean(Y, smootime * 20), 'color', colours{j}{1}, 'LineWidth', 2);
end
legend({Epoch_names{2}, Epoch_names{4}, Epoch_names{5}, Epoch_names{6}}, 'location', 'northeast');
axis square;
xlabel('Pupil size values (a.u.)'); ylabel('#');
makepretty;
sgtitle(['Distribution of pupil sizes: ' Session_params.animal_name ' ' Session_params.session_selection], ...
    'FontWeight', 'bold', 'FontSize', 20);

saveas(f{1}, fullfile(FigFolder, ['pupil_size_distribution_' Session_params.session_selection '.svg']));
close all;

%% -------------------- f4) Brain Power Distributions in Substates --------------------
clear j i f
f{2} = figure('Visible', Session_params.fig_visibility);
set(f{2}, 'Units', 'Normalized', 'Position', [0 0 1 1]);
for i = 1:length(brain_signals)
    subplot(2, 3, i);
    for j = [2, 4, 5, 6]
        [Y, X] = hist(Data(brain_signals{i}{j}), 1000);
        Y = Y/sum(Y);
        hold on;
        plot(X, runmean(Y, smootime + 10), 'color', colours{j}{1}, 'LineWidth', 2);
    end
    title(brain_signals_names{i});
    legend({Epoch_names{2}, Epoch_names{4}, Epoch_names{5}, Epoch_names{6}});
    axis square;
    xlabel('Power (a.u.)'); ylabel('#');
    makepretty;
end
sgtitle(['Distribution of brain power values: ' Session_params.animal_name ' ' Session_params.session_selection], 'FontWeight', 'bold', 'FontSize', 20);
saveas(f{2}, fullfile(FigFolder, ['brain_power_distribution_' Session_params.session_selection '.svg']));
close all;

%% LEGACY CODES
%{
%% DOMITOR: Before/During/After epochs
% Define the injection epochs
inj_1_time = 25*60; %20240312 domitor
inj_2_time = 53*60;

min_inj_1 = nan(length(time), 1);
min_inj_2 = nan(length(time), 1);

for i = 1:length(time)
    min_inj_1(i) = time(i) - inj_1_time;
    min_inj_2(i) = time(i) - inj_2_time;
end
inj_1_time_idx = find(abs(min_inj_1) == min(abs(min_inj_1)));
inj_2_time_idx = find(abs(min_inj_2) == min(abs(min_inj_2)));

time_before = ts(linspace(time(1)*1e4, time(inj_1_time_idx)*1e4, length(time(1:inj_1_time_idx))));
time_during = ts(linspace(time(inj_1_time_idx+1)*1e4, time(inj_2_time_idx)*1e4, length(time((inj_1_time_idx+1):inj_2_time_idx))));
time_after = ts(linspace(time(inj_2_time_idx+1)*1e4, time(end)*1e4, length(time((inj_2_time_idx+1):end))));

% Restrict data to injection epochs
gamma_before = log10(Data(Restrict(smooth_ghi, time_before)));
pupil_before = Data(Restrict(Restrict(areas_pupil_corr_tsd, smooth_ghi), time_before));

gamma_during = log10(Data(Restrict(smooth_ghi, time_during)));
pupil_during = Data(Restrict(Restrict(areas_pupil_corr_tsd, smooth_ghi), time_during));

gamma_after = log10(Data(Restrict(smooth_ghi, time_after)));
pupil_after = Data(Restrict(Restrict(areas_pupil_corr_tsd, smooth_ghi), time_after));

%% Restricted for domitor

gamma_during(gamma_during > 2.15) = NaN;
pupil_during(find(isnan(gamma_during))) = [];
gamma_during(find(isnan(gamma_during))) = [];

%% DOMITOR: Correlation plot: Pre-Injection
figure
sgtitle(['Correlation between the pupil size and OB gamma power: Pre-injection ' date], 'FontWeight', 'bold')
subplot(6,6,32:36)
[Y,X] = hist(gamma_before,1000);
a = area(X , runmean(Y,10)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
box off
xlabel('OB gamma power (log scale)');

subplot(6,6,[25 19 13 7 1])
[Y,X] = hist(pupil_before,1000);
a = area(X , runmean(Y,10)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
set(gca,'XDir','reverse'), camroll(270), box off
xlabel('Pupil size');

subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
hold on
% plot(gamma_before(1:2000:end) , pupil_before(1:2000:end) , '.k')
plot(gamma_before(1:5:end) , pupil_before(1:5:end) , '.k')

axis square

hold on
X_to_use = gamma_before;
Y_to_use = pupil_before;
[R,P] = corr(X_to_use , Y_to_use , 'Type', 'Pearson');
p=polyfit( X_to_use , Y_to_use , 1);
x=[min(X_to_use)*1.1 max(X_to_use)*1.1]; y=x.*p(1)+p(2);

a=p(1); b=p(2);
f=get(gca,'Children'); legend(['R = ' num2str(R) '     P = ' num2str(P)]);
l = [xlim ylim];
%     LINE = [l(1)*.8 l(2)*.8 ; a*l(1)+b a*l(2)+b];
LINE = [l(1) l(2) ; a*l(1)+b a*l(2)+b]; %Temporary modification by Arsenii 03072024

line([LINE(1,1) LINE(1,2)] , [LINE(2,1) LINE(2,2)] , 'Color' , 'r' , 'LineWidth' , 3)

%% DOMITOR: Correlation plot: After Domitor Injection
figure
sgtitle(['Correlation between the pupil size and OB gamma power: Domitor Epoch ' date], 'FontWeight', 'bold')
subplot(6,6,32:36)
[Y,X] = hist(gamma_during,1000);
a = area(X , runmean(Y,10)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
box off
xlabel('OB gamma power (log scale)');

subplot(6,6,[25 19 13 7 1])
[Y,X] = hist(pupil_during,1000);
a = area(X , runmean(Y,10)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
set(gca,'XDir','reverse'), camroll(270), box off
xlabel('Pupil size');

subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
hold on
% plot(gamma_before(1:2000:end) , pupil_before(1:2000:end) , '.k')
plot(gamma_during(1:5:end) , pupil_during(1:5:end) , '.k')

axis square

hold on
% X_to_use = gamma_during(1:1000:end);
% Y_to_use = pupil_during(1:1000:end);
X_to_use = gamma_during;
Y_to_use = pupil_during;

[R,P] = corr(X_to_use(4:end) , Y_to_use(4:end) , 'Type', 'Pearson');
p=polyfit( X_to_use , Y_to_use , 1);
x=[min(X_to_use)*1.1 max(X_to_use)*1.1]; y=x.*p(1)+p(2);

a=p(1); b=p(2);
f=get(gca,'Children'); legend(['R = ' num2str(R) '     P = ' num2str(P)]);
l = [xlim ylim];
%     LINE = [l(1)*.8 l(2)*.8 ; a*l(1)+b a*l(2)+b];
LINE = [l(1) l(2) ; a*l(1)+b a*l(2)+b]; %Temporary modification by Arsenii 03072024

line([LINE(1,1) LINE(1,2)] , [LINE(2,1) LINE(2,2)] , 'Color' , 'r' , 'LineWidth' , 3)

%% DOMITOR: Correlation plot: After Antiseda Injection
figure
sgtitle(['Correlation between the pupil size and OB gamma power: Antisedan Epoch ' date], 'FontWeight', 'bold')
subplot(6,6,32:36)
[Y,X] = hist(gamma_after,1000);
a = area(X , runmean(Y,10)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
box off
xlabel('OB gamma power (log scale)');

subplot(6,6,[25 19 13 7 1])
[Y,X] = hist(pupil_after,1000);
a = area(X , runmean(Y,10)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
set(gca,'XDir','reverse'), camroll(270), box off
xlabel('Pupil size');

subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
hold on
% plot(gamma_before(1:2000:end) , pupil_before(1:2000:end) , '.k')
plot(gamma_after(1:5:end) , pupil_after(1:5:end) , '.k')

axis square

hold on
% X_to_use = gamma_after(1:1000:end);
% Y_to_use = pupil_after(1:1000:end);
X_to_use = gamma_after;
Y_to_use = pupil_after;

[R,P] = corr(X_to_use , Y_to_use , 'Type', 'Pearson');
p=polyfit( X_to_use , Y_to_use , 1);
x=[min(X_to_use)*1.1 max(X_to_use)*1.1]; y=x.*p(1)+p(2);

a=p(1); b=p(2);
f=get(gca,'Children'); legend(['R = ' num2str(R) '     P = ' num2str(P)]);
l = [xlim ylim];
%     LINE = [l(1)*.8 l(2)*.8 ; a*l(1)+b a*l(2)+b];
LINE = [l(1) l(2) ; a*l(1)+b a*l(2)+b]; %Temporary modification by Arsenii 03072024

line([LINE(1,1) LINE(1,2)] , [LINE(2,1) LINE(2,2)] , 'Color' , 'r' , 'LineWidth' , 3)

%% ATROPINE: Before/After epochs
% Define the injection epochs
inj_1_time = 97*60+30; %20240131 atropine

min_inj_1 = nan(length(time), 1);

for i = 1:length(time)
    min_inj_1(i) = time(i) - inj_1_time;
end
inj_1_time_idx = find(abs(min_inj_1) == min(abs(min_inj_1)));

time_before = ts(linspace(time(1)*1e4, time(inj_1_time_idx)*1e4, length(time(1:inj_1_time_idx))));
time_after = ts(linspace(time(inj_1_time_idx+1)*1e4, time(end)*1e4, length(time((inj_1_time_idx+1):end))));

% Restrict data to injection epochs
gamma_before = log10(Data(Restrict(smooth_ghi, time_before)));
pupil_before = Data(Restrict(Restrict(areas_pupil_corr_tsd, smooth_ghi), time_before));

gamma_after = log10(Data(Restrict(smooth_ghi, time_after)));
pupil_after = Data(Restrict(Restrict(areas_pupil_corr_tsd, smooth_ghi), time_after));

%% Correlation plot: Pre-Injection
figure
sgtitle(['Correlation between the pupil size and OB gamma power: Pre-injection ' date], 'FontWeight', 'bold')
subplot(6,6,32:36)
[Y,X] = hist(gamma_before,1000);
a = area(X , runmean(Y,10)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
box off
xlabel('OB gamma power (log scale)');

subplot(6,6,[25 19 13 7 1])
[Y,X] = hist(pupil_before,1000);
a = area(X , runmean(Y,10)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
set(gca,'XDir','reverse'), camroll(270), box off
xlabel('Pupil size');

subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
hold on
% plot(gamma_before(1:2000:end) , pupil_before(1:2000:end) , '.k')
plot(gamma_before(1:5:end) , pupil_before(1:5:end) , '.k')

axis square

hold on
X_to_use = gamma_before(1:1000:end);
Y_to_use = pupil_before(1:1000:end);
[R,P] = corr(X_to_use , Y_to_use , 'Type', 'Pearson');
p=polyfit( X_to_use , Y_to_use , 1);
x=[min(X_to_use)*1.1 max(X_to_use)*1.1]; y=x.*p(1)+p(2);

a=p(1); b=p(2);
f=get(gca,'Children'); legend(['R = ' num2str(R) '     P = ' num2str(P)]);
l = [xlim ylim];
%     LINE = [l(1)*.8 l(2)*.8 ; a*l(1)+b a*l(2)+b];
LINE = [l(1) l(2) ; a*l(1)+b a*l(2)+b]; %Temporary modification by Arsenii 03072024

line([LINE(1,1) LINE(1,2)] , [LINE(2,1) LINE(2,2)] , 'Color' , 'r' , 'LineWidth' , 3)

%% Correlation plot: After Domitor Injection
figure
sgtitle(['Correlation between the pupil size and OB gamma power: Atropine Epoch ' date], 'FontWeight', 'bold')
subplot(6,6,32:36)
[Y,X] = hist(gamma_after,1000);
a = area(X , runmean(Y,10)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
box off
xlabel('OB gamma power (log scale)');

subplot(6,6,[25 19 13 7 1])
[Y,X] = hist(pupil_after,1000);
a = area(X , runmean(Y,10)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
set(gca,'XDir','reverse'), camroll(270), box off
xlabel('Pupil size');

subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
hold on
% plot(gamma_before(1:2000:end) , pupil_before(1:2000:end) , '.k')
plot(gamma_after(1:5:end) , pupil_after(1:5:end) , '.k')

axis square

hold on
X_to_use = gamma_after(1:1000:end);
Y_to_use = pupil_after(1:1000:end);
[R,P] = corr(X_to_use , Y_to_use , 'Type', 'Pearson');
p=polyfit( X_to_use , Y_to_use , 1);
x=[min(X_to_use)*1.1 max(X_to_use)*1.1]; y=x.*p(1)+p(2);

a=p(1); b=p(2);
f=get(gca,'Children'); legend(['R = ' num2str(R) '     P = ' num2str(P)]);
l = [xlim ylim];
%     LINE = [l(1)*.8 l(2)*.8 ; a*l(1)+b a*l(2)+b];
LINE = [l(1) l(2) ; a*l(1)+b a*l(2)+b]; %Temporary modification by Arsenii 03072024

line([LINE(1,1) LINE(1,2)] , [LINE(2,1) LINE(2,2)] , 'Color' , 'r' , 'LineWidth' , 3)

%% Not used: Baptiste's playground
%{
[pupil_mvt_thresh] = GetThetaThresh(Data(pupil_mvt_sleep) , 1 , 1);
close
[pupil_size_thresh] = GetThetaThresh(Data(areas_pupil_sleep) , 1 , 1);
close

Pupil_Mvt_Sleep_Epoch = thresholdIntervals(pupil_mvt_sleep,pupil_mvt_thresh);
Pupil_Mvt_Sleep_Epoch = mergeCloseIntervals(Pupil_Mvt_Sleep_Epoch,5*1e4);
Pupil_Mvt_Sleep_Epoch = dropShortIntervals(Pupil_Mvt_Sleep_Epoch,10*1e4);

Pupil_Small_Sleep_Epoch = thresholdIntervals(areas_pupil_sleep,pupil_size_thresh,'Direction','Below');
Pupil_Small_Sleep_Epoch = mergeCloseIntervals(Pupil_Small_Sleep_Epoch,5*1e4);
Pupil_Small_Sleep_Epoch = dropShortIntervals(Pupil_Small_Sleep_Epoch,10*1e4);


% plot evolution of value
figure
subplot(211)
plot(Range(pupil_mvt_smooth)/60e4 , Data(pupil_mvt_smooth) , 'b')
hold on
plot(Range(Restrict(pupil_mvt_smooth,Sleep))/60e4 , Data(Restrict(pupil_mvt_smooth,Sleep)) , 'r')
plot(Range(Restrict(pupil_mvt_smooth,and(Sleep,Pupil_Mvt_Sleep_Epoch)))/60e4 , Data(Restrict(pupil_mvt_smooth,and(Sleep,Pupil_Mvt_Sleep_Epoch))) , 'g')
xlim([0 180]), ylim([0 .5])
ylabel('pupil movement (a.u.)')
legend('Wake','Sleep','Sleep with pupil movement')
title('Pupil movement')

subplot(212)
plot(Range(areas_pupil_smooth)/60e4 , Data(areas_pupil_smooth) , 'b')
hold on
plot(Range(Restrict(areas_pupil_smooth,Sleep))/60e4 , Data(Restrict(areas_pupil_smooth,Sleep)) , 'r')
plot(Range(Restrict(areas_pupil_smooth,and(Sleep,Pupil_Small_Sleep_Epoch)))/60e4 , Data(Restrict(areas_pupil_smooth,and(Sleep,Pupil_Small_Sleep_Epoch))) , 'g')
xlim([0 180])
xlabel('time (min)'), ylabel('pupil size (a.u.)')
legend('Wake','Sleep','Sleep with small pupil size')
title('Pupil size')

a=suptitle('Pupil tracking, temporal evolution analysis, head restraint sleep session, Labneh'); a.FontSize=20;


% check how REM and eye mvt epoch are similar
figure
Hypnogram_LineColor_BM(1,'time','min')
Hypnogram_LineColor_BM(2,'time','min','scoring','bm')

load('LFPData/LFP0.mat')
t=Range(LFP); val=60; thr=3;
begin=t(1)/(val*1e4);
endin=t(end)/(val*1e4);

line([begin endin],[thr thr],'linewidth',5,'color','r')

clear sleepstart sleepstop
sleepstart=Start(Wake);
sleepstop=Stop(Wake);
for k=1:length(sleepstart)
    line([sleepstart(k)/(val*1e4) sleepstop(k)/(val*1e4)],[thr thr],'color','b','linewidth',5);
end

clear sleepstart sleepstop
sleepstart=Start(SWSEpoch);
sleepstop=Stop(SWSEpoch);
for k=1:length(sleepstart)
    line([sleepstart(k)/(val*1e4) sleepstop(k)/(val*1e4)],[thr thr],'color','r','linewidth',5);
end

clear sleepstart sleepstop
sleepstart=Start(Pupil_Mvt_Sleep_Epoch);
sleepstop=Stop(Pupil_Mvt_Sleep_Epoch);
for k=1:length(sleepstart)
    line([sleepstart(k)/(val*1e4) sleepstop(k)/(val*1e4)],[thr thr],'color','g','linewidth',5);
end

t=Range(LFP); val=60; thr=4;
begin=t(1)/(val*1e4);
endin=t(end)/(val*1e4);

line([begin endin],[thr thr],'linewidth',5,'color','r')

clear sleepstart sleepstop
sleepstart=Start(Wake);
sleepstop=Stop(Wake);
for k=1:length(sleepstart)
    line([sleepstart(k)/(val*1e4) sleepstop(k)/(val*1e4)],[thr thr],'color','b','linewidth',5);
end

clear sleepstart sleepstop
sleepstart=Start(SWSEpoch);
sleepstop=Stop(SWSEpoch);
for k=1:length(sleepstart)
    line([sleepstart(k)/(val*1e4) sleepstop(k)/(val*1e4)],[thr thr],'color','r','linewidth',5);
end

clear sleepstart sleepstop
sleepstart=Start(Pupil_Small_Sleep_Epoch);
sleepstop=Stop(Pupil_Small_Sleep_Epoch);
for k=1:length(sleepstart)
    line([sleepstart(k)/(val*1e4) sleepstop(k)/(val*1e4)],[thr thr],'color','g','linewidth',5);
end

ylim([.5 4.5])
xlabel('time (min)')


REM_dur = sum(DurationEpoch(REMEpoch))/60e4
EyeMovementSleep = sum(DurationEpoch(Pupil_Mvt_Sleep_Epoch))/60e4
EyeSmallSleep = sum(DurationEpoch(Pupil_Small_Sleep_Epoch))/60e4

EyeMovement_DuringREM = sum(DurationEpoch(and(REMEpoch,Pupil_Mvt_Sleep_Epoch)))/60e4
REM_NoEyeMvt = sum(DurationEpoch(REMEpoch-Pupil_Mvt_Sleep_Epoch))/60e4
EyeMovement_NoREM = sum(DurationEpoch(Pupil_Mvt_Sleep_Epoch-REMEpoch))/60e4

Se1 = EyeMovement_DuringREM/REM_dur
Sp1 = EyeMovement_DuringREM/EyeMovementSleep

PupilSmall_DuringREM = sum(DurationEpoch(and(REMEpoch,Pupil_Small_Sleep_Epoch)))/60e4
REM_PupilBig = sum(DurationEpoch(REMEpoch-Pupil_Small_Sleep_Epoch))/60e4
PupilSmall_NoREM = sum(DurationEpoch(Pupil_Small_Sleep_Epoch-REMEpoch))/60e4

Se1 = PupilSmall_DuringREM/REM_dur
Sp1 = PupilSmall_DuringREM/EyeSmallSleep
%}

%% Not used: Gamma - pupil distributions
%{
set(0, 'CurrentFigure', f4)
gamma_wake = log10(Data(Restrict(smooth_ghi, Wake)));
gamma_sleep = log10(Data(Restrict(smooth_ghi, Sleep)));
% gamma_after = log10(Data(Restrict(smooth_ghi, time_after)));

subplot(221)
[Y,X]=hist(gamma_wake,1000);
Y=Y/sum(Y);
plot(X,runmean(Y,smootime+10),'k')
hold on
[Y,X]=hist(gamma_sleep,1000);
Y=Y/sum(Y);
plot(X,runmean(Y,smootime+10),'m')

% [Y,X]=hist(gamma_after,1000);
% Y=Y/sum(Y);
% plot(X,runmean(Y,smootime+10),'g')
xlabel('gamma power values (a.u.)'), ylabel('#')
makepretty
title('Gamma power')
legend({'Wake', 'Sleep'})
axis square


pupil_wake = Data(Restrict(Restrict(areas_pupil_corr_tsd, smooth_ghi), Wake));
pupil_sleep = Data(Restrict(Restrict(areas_pupil_corr_tsd, smooth_ghi), Sleep));

% pupil_after = Data(Restrict(Restrict(areas_pupil_corr_tsd, smooth_ghi), time_after));

subplot(222)
[Y,X]=hist(pupil_wake,1000);
Y=Y/sum(Y);
plot(X,runmean(Y,smootime),'k')
hold on
[Y,X]=hist(pupil_sleep,1000);
Y=Y/sum(Y);
plot(X,runmean(Y,smootime),'m')
% [Y,X]=hist(pupil_after,1000);
% Y=Y/sum(Y);
% plot(X,runmean(Y,smootime),'g')
xlabel('pupil size values (a.u.)'), ylabel('#')
makepretty
title('Pupil size')
legend({'Wake', 'Sleep'}, 'location', 'northwest')
axis square

gamma_01_05 = log10(Data(Restrict(smooth_ghi, S1_epoch)));
gamma_no_01_05 = log10(Data(Restrict(smooth_ghi,S2_epoch)));
% gamma_after = log10(Data(Restrict(smooth_ghi, time_after)));

subplot(223)
[Y,X]=hist(gamma_01_05,1000);
Y=Y/sum(Y);
plot(X,runmean(Y,smootime+10),'k')
hold on
[Y,X]=hist(gamma_no_01_05,1000);
Y=Y/sum(Y);
plot(X,runmean(Y,smootime+10),'m')

% [Y,X]=hist(gamma_after,1000);
% Y=Y/sum(Y);
% plot(X,runmean(Y,smootime+10),'g')
xlabel('gamma power values (a.u.)'), ylabel('#')
makepretty
title('Gamma power')
legend({'Wake', 'Sleep'})
axis square


pupil_wake = Data(Restrict(Restrict(areas_pupil_corr_tsd, smooth_ghi), S1_epoch));
pupil_sleep = Data(Restrict(Restrict(areas_pupil_corr_tsd, smooth_ghi), S2_epoch));

% pupil_after = Data(Restrict(Restrict(areas_pupil_corr_tsd, smooth_ghi), time_after));

subplot(222)
[Y,X]=hist(pupil_wake,1000);
Y=Y/sum(Y);
plot(X,runmean(Y,smootime),'k')
hold on
[Y,X]=hist(pupil_sleep,1000);
Y=Y/sum(Y);
plot(X,runmean(Y,smootime),'m')
% [Y,X]=hist(pupil_after,1000);
% Y=Y/sum(Y);
% plot(X,runmean(Y,smootime),'g')
xlabel('pupil size values (a.u.)'), ylabel('#')
makepretty
title('Pupil size')
legend({'Wake', 'Sleep'}, 'location', 'northwest')
axis square
%}

%% Not used: Distributions
%{
[Y,X]=hist(Data(pupil_mvt_tsd),1000);
Y=Y/sum(Y);
plot(X,runmean(Y,30),'g')
plot(X, Y)
xlabel('pupil movement values (a.u.)'), ylabel('#'), legend('all epoch','sleep','REM')
makepretty
title('Pupil movement')

subplot(122)
hold on
[Y,X]=hist(Data(areas_pupil_smooth),1000);
Y=Y/sum(Y);
plot(X,runmean(Y,3),'k')

[Y,X]=hist(Data(areas_pupil_sleep),1000);
Y=Y/sum(Y);
plot(X,runmean(Y,10),'m')

[Y,X]=hist(Data(areas_pupil_wake),1000);
Y=Y/sum(Y);
plot(X,runmean(Y,30),'g')

xlabel('pupil size values (a.u.)'), ylabel('#')
makepretty
title('Pupil size')
legend({'All epochs', 'Sleep', 'Wake'})

sgtitle(['Pupil tracking, distribution analysis, head-fixed sleep session: ' Session_params.animal_name{Session_params.animal_selection}], 'FontWeight', 'bold', 'FontSize', 20);
%}


%% Not used: Drug session evolution
%{
set(0, 'CurrentFigure', f4)
gamma_before = log10(Data(Restrict(smooth_ghi, time_before)));
gamma_during = log10(Data(Restrict(smooth_ghi, time_during)));
gamma_after = log10(Data(Restrict(smooth_ghi, time_after)));

subplot(121)
[Y,X]=hist(gamma_before,1000);
Y=Y/sum(Y);
plot(X,runmean(Y,smootime+10),'k')
hold on
[Y,X]=hist(gamma_during,1000);
Y=Y/sum(Y);
plot(X,runmean(Y,smootime+10),'m')
[Y,X]=hist(gamma_after,1000);
Y=Y/sum(Y);
plot(X,runmean(Y,smootime+10),'g')
xlabel('gamma power values (a.u.)'), ylabel('#')
makepretty
title('Gamma power')
% legend({'Before inj', 'Domitor', 'Antisedan'})
legend({'Before inj', 'Atropine'})


pupil_before = Data(Restrict(Restrict(areas_pupil_corr_tsd, smooth_ghi), time_before));
pupil_during = Data(Restrict(Restrict(areas_pupil_corr_tsd, smooth_ghi), time_during));
pupil_after = Data(Restrict(Restrict(areas_pupil_corr_tsd, smooth_ghi), time_after));

subplot(122)
[Y,X]=hist(pupil_before,1000);
Y=Y/sum(Y);
plot(X,runmean(Y,smootime),'k')
hold on
[Y,X]=hist(pupil_during,1000);
Y=Y/sum(Y);
plot(X,runmean(Y,smootime),'m')
[Y,X]=hist(pupil_after,1000);
Y=Y/sum(Y);
plot(X,runmean(Y,smootime),'g')
xlabel('pupil size values (a.u.)'), ylabel('#')
makepretty
title('Pupil size')
% legend({'Before inj', 'Domitor', 'Antisedan'}, 'location', 'northwest')
legend({'Before inj', 'Atropine'}, 'location', 'northwest')
%}

%}

end