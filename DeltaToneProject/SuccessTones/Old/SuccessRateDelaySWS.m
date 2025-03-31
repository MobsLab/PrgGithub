% SuccessRateDelaySWS
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
labels_deltatone = {'140ms','200ms','320ms','490ms'};

%% DELTA TONE

%delta
ratio_sucess.delta.deltatone = [];
for d=1:length(delays)
    success = squeeze(sum(deltas.tone.density(d,sws_ind,animals_ind,yes,yes),2));
    fail = squeeze(sum(deltas.tone.density(d,sws_ind,animals_ind,yes,no),2));
    if isempty(ratio_sucess.delta.deltatone)
        ratio_sucess.delta.deltatone = success ./ (success + fail);
    else
        ratio_sucess.delta.deltatone = [ratio_sucess.delta.deltatone success ./ (success + fail)];
    end
    
end
%down
ratio_sucess.down.deltatone = [];
for d=1:length(delays)
    success = squeeze(sum(downs.tone.density(d,sws_ind,animals_ind,yes,yes),2));
    fail = squeeze(sum(downs.tone.density(d,sws_ind,animals_ind,yes,no),2));
    if isempty(ratio_sucess.down.deltatone)
        ratio_sucess.down.deltatone = success ./ (success + fail);
    else
        ratio_sucess.down.deltatone = [ratio_sucess.down.deltatone success ./ (success + fail)];
    end
end


%% RANDOM TONE
eval(['load ' FolderProjetDelta 'Data/RandomPethAnalysis_bis.mat'])
labels_rdm = {'120-160ms','180-220ms','300-340ms','460-520ms'};
ranges_delay = [120 160;180 220; 300 340; 460 520]*10;   

% For each animal
for m=1:length(animals)
    %delta
    delay = diff.delay{m};
    substages = diff.substage{m};
    for i=1:length(ranges_delay)
        good_delay = delay>=ranges_delay(i,1) & delay<ranges_delay(i,2);
        good_substage = ismember(substages,sws_ind);
        selection_tone = logical(good_delay .* good_substage);
        
        random.delta.induce(m,i) = sum(diff.induce{m}(selection_tone));
        random.delta.number(m,i) = sum(selection_tone);
    end
    %down
    delay = mua.delay{m};
    substages = mua.substage{m};
    for i=1:length(ranges_delay)
        good_delay = delay>=ranges_delay(i,1) & delay<ranges_delay(i,2);
        good_substage = ismember(substages,sws_ind);
        selection_tone = logical(good_delay .* good_substage);
        
        random.down.induce(m,i) = sum(mua.induce{m}(selection_tone));
        random.down.number(m,i) = sum(selection_tone);
    end
end
ratio_sucess.delta.random = random.delta.induce ./ random.delta.number;
ratio_sucess.down.random = random.down.induce ./ random.down.number;


%% PLOT
figure, hold on
subplot(2,1,1), hold on
PlotErrorBarN_KJ(ratio_sucess.delta.deltatone,'newfig',0);
title('Delta Tone - delta waves')
set(gca, 'XTickLabel',labels_deltatone, 'XTick',1:numel(labels_deltatone), 'XTickLabelRotation', 30), hold on,

subplot(2,1,2), hold on
PlotErrorBarN_KJ(ratio_sucess.delta.random,'newfig',0);
title('Random Tone - delta waves')
set(gca, 'XTickLabel',labels_rdm, 'XTick',1:numel(labels_rdm), 'XTickLabelRotation', 30), hold on,








