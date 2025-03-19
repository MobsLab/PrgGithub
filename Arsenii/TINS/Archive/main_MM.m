
numtemplates = 8;  %number of templates for PCA and to run ICA on; check they explain more than 50%variance
nmice=[1161]; % 1199 vs 1168 vs 1161 vs 1162
experiment = "PAG";
TemplatePeriod = {'cond'}; % 'wake' 'cond', 'condFree', 'postRip', 'condRip'
binsize = 250;  %0.1*1e4 = 100 ms
issavefig = 1;    %to save fig put 1
issaveweight = 1;   %save neurons weight associated with PCs or ICs
multiU = 'D'; % 'D' for delete or 'K' for keep the MU associated channels
interN = 'D'; % 'D' for delete or 'K' for keep the IN associated channels

close all;

%run PCA
[PCAtemplates, s_PCA, EV_PCA ] = react_pca_ica_MM(nmice, experiment, TemplatePeriod{1}, numtemplates, multiU, "PCA", interN, issaveweight, 'binsize', binsize, 'issavefig', issavefig);
PCAtemplates = [PCAtemplates{:}];
PCAtemplates = PCAtemplates(:,1:numtemplates); %only extract selected number of components

%run ICA
[ICAtemplates, s_ICA] = react_pca_ica_MM(nmice, experiment, TemplatePeriod{1}, numtemplates, multiU, "ICA", interN, issaveweight, 'binsize', binsize, 'issavefig', issavefig);
ICAtemplates = [ICAtemplates{:}];


%Calculates correlations between ICA and PCA compnents
PC_correl = zeros(numtemplates);

for nPC_PCA = 1:numtemplates
     for nPC_ICA = 1:numtemplates
            A = corrcoef(PCAtemplates(:,nPC_PCA), ICAtemplates(:, nPC_ICA));
            PC_correl(nPC_PCA, nPC_ICA) = A(1,2);
     end
 end

%rename columns and rows for correlation figure
row = strings([1, numtemplates]);
col = strings([1, numtemplates]);
for nPC_PCA = 1:numtemplates
    row(nPC_PCA) = strjoin({'PCA' num2str(nPC_PCA)});
    col(nPC_PCA) = strjoin({'ICA' num2str(nPC_PCA)});
end



%%%%%%%%%%%%%% clean that ! Test: PC_correl = PC_correl(:, I);
[~, I] = sort(abs(PC_correl(1,:)), 'descend');
col = col(I);
PC_correl = PC_correl(:, I)
%{
ICAtemplates = ICAtemplates(:, I);

for nPC_PCA = 1:numtemplates
     for nPC_ICA = 1:numtemplates
            A = corrcoef(PCAtemplates(:,nPC_PCA), ICAtemplates(:, nPC_ICA));
            PC_correl(nPC_PCA, nPC_ICA) = A(1,2);
     end
 end
%}

%fig of correlation coefficients between PC and IC
figure
imagesc(PC_correl)
set(gca,'Xtick',1:numtemplates,'XTickLabel',col);
set(gca, 'Ytick', 1:numtemplates, 'YtickLabel', row);
caxis([-1 1]);
colormap jet;
colorbar;
textStrings = num2str(PC_correl(:), '%0.2f');       % Create strings from the matrix values
textStrings = strtrim(cellstr(textStrings));
[x, y] = meshgrid(1:numtemplates);  % Create x and y coordinates for the strings
hStrings = text(x(:), y(:), textStrings(:), ...  % Plot the strings
                'HorizontalAlignment', 'center');
title("Correlation between ICA and PCA components");

if issavefig == 1
     saveas(gcf, ['PCA_ICA_Correlations' nmice(1) '_templateEpoch_' TemplatePeriod{1} '.png']);
     saveas(gcf, ['PCA_ICA_Correlations' nmice(1) '_templateEpoch_' TemplatePeriod{1} '.svg']);
end

close all;
