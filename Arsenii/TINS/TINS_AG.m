function [] = TINS_AG()
%%
% The function is written to test PCA and ICA on different datasets in order to compare their 
    % reactivation strengths
% PCA and ICA work in the same manner as it in Peyrache et al., 2010
%
% INPUT
%
%   nmice               array with mice numbers that will harvested from ERC
%                       PathForExperiments. Each mouse should contain
%                       PlaceCells structure in its SpikeData.mat
%   experiment          type of experiment: 'PAG', 'MFB', 'Novel'
%   TemplatePeriod      type of period to be taken as a template. The
%                       following periods supported: 'wake', 'cond',
%                       'condFree', 'postRip', 'condRip'
%
%   SpeedThresh         threshold (in cm/s) to calculate place fields
%                       (default = 4) (optional)
%   PlotResults         whether to plot results or not (optional - default=true)
%   BinSize             binsize (in tsd units) used to creat spike-time
%                       histograms (default = 0.1*1e4). In RepeatOPostRipplesEpochriginalPaper
%                       mode equals 10 (1 ms) (optional)
%   SplitSleep          Splits 40 min of NREM sleep into n intervals, each
%                       SplitSleep min long. If empty, no split happens (default=20)
%   IncludeInterneurons if false, removes all interneurons (default = true)
%   IsSaveFig           if true, saves figures in dropbox (default = false)(optional)
%
% OUTPUT
%
%  None
%
%
% By Arsenii Goriachenkov and Marion Mallet, ENS, Paris, 2021-2022
% github.com/arsgorv

%% ToDo
% Add buttons to choose parameters "nmice", "experiment", "Template
% Period", "numtemplates", "IsSaveFig", "binsize", "PCA/ICA choice"

%% 
% Local Parameters
parameters.fig_path = 'D:\Work and Education\Science\MOBS\Dropbox\Kteam\PrgMatlab\Arsenii\TINS\Figures';
parameters.work_path = 'D:\Work and Education\Science\MOBS\Dropbox\Kteam\PrgMatlab\Arsenii';
cd(parameters.work_path)
AddMyPaths_Arsenii

% Changable parameters
parameters.calc = "PCA"; % "PCA" if you want to calculate PCA (pcacov); "ICA" if you want to calculate ICA
parameters.nmice = [1199]; % 1199 vs 1168 vs 1161 vs 1162
parameters.experiment = "PAG";
parameters.TemplatePeriod = {'condRip'}; % Choose between 'wake', 'cond', 'condFree', 'postRip', 'condRip'
parameters.numtemplates = 13; % Number of PCs or number of templates for PCA and ICA; You should check if they explain more than 50% of variance
parameters.IsSaveFig = 1; % Put 1 if you want to save figures to your pathway
parameters.binsize = 0.025*1e4; % Reminder: 0.1*1e4 = 100 ms; 0.025*1e4 = 25 ms.
parameters.issaveweight = 1; % Save neurons weight associated with PCs or ICs
parameters.multiU = 'K'; % 'D' to delete or 'K' to keep the MU (multiunit) associated channels
parameters.interN = 'K'; % 'D' to delete or 'K' to keep the IN (interneurons) associated channels

close all;

%% Running ICA/PCA over all chosen template periods. Usually, just one.
for i=1:length(parameters.TemplatePeriod)
    
    %run PCA
%     [PCAtemplates, s_PCA, EV_PCA] = react_pca_ica_AG(nmice,experiment,TemplatePeriod{1,i}, numtemplates, "PCA", interN, multiU, issaveweight, 'binsize', binsize, 'IsSaveFig', IsSaveFig);
%     [PCAtemplates, s_PCA, EV_PCA] = react_pca_ica_AG(nmice,experiment,TemplatePeriod{1,i}, numtemplates, "PCA", interN, multiU, issaveweight, binsize, IsSaveFig);
    [PCAtemplates, s_PCA, EV_PCA] = react_pca_ica_AG(parameters);

    PCAtemplates = [PCAtemplates{:}];
    PCAtemplates = PCAtemplates(:,1:parameters.numtemplates); %only extract selected number of components

    EV_PCA = [EV_PCA{:}];
    EV = sum(EV_PCA(1:parameters.numtemplates));

    %run ICA
    [ICAtemplates, s_ICA] = react_pca_ica_AG(parameters);
    ICAtemplates = [ICAtemplates{:}];

    corrcoef(PCAtemplates(:,1), ICAtemplates(:,1));

    %Calculates correlations between ICA and PCA compnents
    corrcoef(PCAtemplates(:,1), ICAtemplates(:,1));
    PC_correl = zeros(parameters.numtemplates);

    for nPC_PCA = 1:parameters.numtemplates
        for nPC_ICA = 1:parameters.numtemplates
            A = corrcoef(PCAtemplates(:,nPC_PCA), ICAtemplates(:, nPC_ICA));
            PC_correl(nPC_PCA, nPC_ICA) = A(1,2);
        end
    end
end

%% rename columns and rows for correlation figure
row = strings([1, parameters.numtemplates]);
col = strings([1, parameters.numtemplates]);
for nPC_PCA = 1:parameters.numtemplates
    row(nPC_PCA) = strjoin({'PCA' num2str(nPC_PCA)});
    col(nPC_PCA) = strjoin({'ICA' num2str(nPC_PCA)});
end

%%%%%%%%%%%%%% clean that ! Test: PC_correl = PC_correl(:, I);
[~, I] = sort(abs(PC_correl(1,:)), 'descend');
col = col(I);
PC_correl = PC_correl(:, I);

ICAtemplates = ICAtemplates(:, I);

for nPC_PCA = 1:parameters.numtemplates
     for nPC_ICA = 1:parameters.numtemplates
            A = corrcoef(PCAtemplates(:,nPC_PCA), ICAtemplates(:, nPC_ICA));
            PC_correl(nPC_PCA, nPC_ICA) = A(1,2);
     end
 end

%fig of correlation coefficients between PC and IC
figure
imagesc(PC_correl)
set(gca,'Xtick',1:parameters.numtemplates,'XTickLabel',col);
set(gca, 'Ytick', 1:parameters.numtemplates, 'YtickLabel', row);
caxis([-1 1]);
colormap jet;
colorbar;
textStrings = num2str(PC_correl(:), '%0.2f');       % Create strings from the matrix values
textStrings = strtrim(cellstr(textStrings));
[x, y] = meshgrid(1:parameters.numtemplates);  % Create x and y coordinates for the strings
hStrings = text(x(:), y(:), textStrings(:), ...  % Plot the strings
                'HorizontalAlignment', 'center');
title("Correlation between ICA and PCA components");

if parameters.IsSaveFig== 1
     saveas(gcf, ['PCA_ICA_Correlations' parameters.nmice(1) '_templateEpoch_' parameters.TemplatePeriod{1} '.png']);
     saveas(gcf, ['PCA_ICA_Correlations' parameters.nmice(1) '_templateEpoch_' parameters.TemplatePeriod{1} '.svg']);
end

% close all;

num_sign_PCA = [];
neuron_sign_PCA = {};
temp_neuron_PCA = [];
num_sign_ICA = [];
neuron_sign_ICA = {};
temp_neuron_ICA = [];

for temp=1:parameters.numtemplates
    temporary_PCA = 0;
    temporary_ICA = 0;
    for neuron = 1:size(PCAtemplates,1)
        if abs(PCAtemplates(neuron,temp)) > (mean(PCAtemplates(:,temp)) + 2*std(PCAtemplates(:,temp)))
            temporary_PCA = temporary_PCA + 1;
            temp_neuron_PCA = [temp_neuron_PCA, neuron];
        end

        if abs(ICAtemplates(neuron,temp)) > (mean(ICAtemplates(:,temp)) + 2*std(ICAtemplates(:,temp)))
            temporary_ICA = temporary_ICA + 1;
            temp_neuron_ICA = [temp_neuron_ICA, neuron];
        end

    end 
    num_sign_PCA(temp) = temporary_PCA;
    neuron_sign_PCA{temp} = [temp_neuron_PCA];
    num_sign_ICA(temp) = temporary_ICA;
    neuron_sign_ICA{temp} = [temp_neuron_ICA];
end

p = ranksum(num_sign_PCA(:), num_sign_ICA(:));

figure
boxplot([num_sign_PCA(:), num_sign_ICA(:)], 'Labels', {'PCA', 'ICA'}, 'Whisker',1)
text(1, 1, num2str(p));
title('Comparison of mean number of significant neurons per cell assemblies')

if parameters.IsSaveFig== 1
    saveas(gcf, ['PCA_ICA_CompSignW_param_' parameters.nmice(1) '_templateEpoch_' parameters.TemplatePeriod{1} '.png']);
end

% close all;
end
