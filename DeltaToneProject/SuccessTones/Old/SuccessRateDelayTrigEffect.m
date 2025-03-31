% SuccessRateDelayTrigEffect
% 12.12.2016 KJ
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
eval(['load ' FolderProjetDelta 'Data/QuantifSuccessDeltaShamToneSubstage_bis2.mat'])

%params
yes=2;
no=1;
sws_ind = [2 3];
animals_ind = 1:length(animals);
labels = {'140ms','200ms','320ms','490ms'};

%% ALL SUCCESS

%delta
ratio_sucess.delta.nontrig = [];
for d=1:length(delays)
    trig_success = squeeze(sum(deltas.tone.density(d,sws_ind,animals_ind,yes,yes),2));
    nontrig_success = squeeze(sum(deltas.tone.density(d,sws_ind,animals_ind,no,yes),2));
    if isempty(ratio_sucess.delta.nontrig)
        ratio_sucess.delta.nontrig = nontrig_success ./ (trig_success + nontrig_success);
    else
        ratio_sucess.delta.nontrig = [ratio_sucess.delta.nontrig nontrig_success ./ (trig_success + nontrig_success)];
    end
    
end
%down
ratio_sucess.down.nontrig = [];
for d=1:length(delays)
    trig_success = squeeze(sum(downs.tone.density(d,sws_ind,animals_ind,yes,yes),2));
    nontrig_success = squeeze(sum(downs.tone.density(d,sws_ind,animals_ind,no,yes),2));
    if isempty(ratio_sucess.delta.nontrig)
        ratio_sucess.down.nontrig = nontrig_success ./ (trig_success + nontrig_success);
    else
        ratio_sucess.down.nontrig = [ratio_sucess.down.nontrig nontrig_success ./ (trig_success + nontrig_success)];
    end
    
end

%% ALL NON-TRIGGED
%delta
ratio_sucess2.delta.nontrig = [];
for d=1:length(delays)
    nontrig_fail = squeeze(sum(deltas.tone.density(d,sws_ind,animals_ind,no,no),2));
    nontrig_success = squeeze(sum(deltas.tone.density(d,sws_ind,animals_ind,no,yes),2));
    if isempty(ratio_sucess2.delta.nontrig)
        ratio_sucess2.delta.nontrig = nontrig_success ./ (nontrig_fail + nontrig_success);
    else
        ratio_sucess2.delta.nontrig = [ratio_sucess2.delta.nontrig nontrig_success ./ (nontrig_fail + nontrig_success)];
    end
    
end
%down
ratio_sucess2.down.nontrig = [];
for d=1:length(delays)
    nontrig_fail = squeeze(sum(downs.tone.density(d,sws_ind,animals_ind,no,no),2));
    nontrig_success = squeeze(sum(downs.tone.density(d,sws_ind,animals_ind,no,yes),2));
    if isempty(ratio_sucess2.delta.nontrig)
        ratio_sucess2.down.nontrig = nontrig_success ./ (nontrig_fail + nontrig_success);
    else
        ratio_sucess2.down.nontrig = [ratio_sucess2.down.nontrig nontrig_success ./ (nontrig_fail + nontrig_success)];
    end
    
end


%% PLOT
figure, hold on
subplot(2,1,1), hold on
PlotErrorBarN_KJ(ratio_sucess.delta.nontrig,'newfig',0);
title('Delta Tone Success- percentage of non-trig')
set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels), 'XTickLabelRotation', 30), hold on,

subplot(2,1,2), hold on
PlotErrorBarN_KJ(ratio_sucess2.delta.nontrig,'newfig',0);
title('Delta Tone Non trig - percentage of success')
set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels), 'XTickLabelRotation', 30), hold on,








