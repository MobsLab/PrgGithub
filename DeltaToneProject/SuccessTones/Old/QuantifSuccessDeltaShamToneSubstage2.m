% QuantifSuccessDeltaShamToneSubstage2
% 30.11.2016 KJ
%
% plot data for the quantification of the success of tones/shams to induce delta/down, 
% for different substages
%   - Substages = N1, N2, N3, REM, WAKE
%
%
%   see 
%       QuantifSuccessDeltaToneSubstage QuantifSuccessDeltaShamToneSubstage_bis
%
%


%load
clear
eval(['load ' FolderProjetDelta 'Data/QuantifSuccessDeltaShamToneSubstage_bis.mat'])

%params
NameSubstages = {'N1','N2', 'N3','REM','Wake','SWS'}; % Sleep substages
yes=2;
no=1;
labels = {...
    'Sham: non-trig/failed', 'trig/failed', 'non-trig/success', 'trig/success',...
    'Tone: non-trig/failed', 'trig/failed', 'non-trig/success', 'trig/success',...
    'Random: non-trig/failed', 'trig/failed', 'non-trig/success', 'trig/success'};
barcolors = {'k','k','k','k','r','r','r','r','y','y','y','y'};
columntest = [1 5; 1 9; 5 9];
columntest = [columntest; columntest + 1; columntest + 2;columntest + 3];

for cond=3:length(conditions)
    d=cond-2;
    figure, hold on
    for sub=substages_ind
        
        data_sham = [...
            squeeze(deltas.sham.density(d,sub,:,no,no))...
            squeeze(deltas.sham.density(d,sub,:,yes,no))...
            squeeze(deltas.sham.density(d,sub,:,no,yes))...
            squeeze(deltas.sham.density(d,sub,:,yes,yes))...
            ];
        
        data_tone = [...
            squeeze(deltas.tone.density(d,sub,:,no,no))...
            squeeze(deltas.tone.density(d,sub,:,yes,no))...
            squeeze(deltas.tone.density(d,sub,:,no,yes))...
            squeeze(deltas.tone.density(d,sub,:,yes,yes))...
            ];
        
        data_random = [...
            squeeze(deltas.random.density(sub,:,no,no))'...
            squeeze(deltas.random.density(sub,:,yes,no))'...
            squeeze(deltas.random.density(sub,:,no,yes))'...
            squeeze(deltas.random.density(sub,:,yes,yes))'...
            ];
        
        data_sham = data_sham ./ repmat(sum(data_sham,2), [1, size(data_sham,2)]);
        data_tone = data_tone ./ repmat(sum(data_tone,2), [1, size(data_tone,2)]);
        data_random = data_random ./ repmat(sum(data_random,2), [1, size(data_random,2)]);
        
        data = [data_sham data_tone data_random];
        
        subplot(2,3,sub), hold on
        PlotErrorBarN_KJ(data,'newfig',0,'ColumnTest',columntest,'barcolors',barcolors);
        title(NameSubstages{sub})
        set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels), 'XTickLabelRotation', 30), hold on,
    end
    suplabel(['Sham / RandomTone / ' conditions{cond}],'t');
    
end