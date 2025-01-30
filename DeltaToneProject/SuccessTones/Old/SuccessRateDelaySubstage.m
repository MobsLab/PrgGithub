% SuccessRateDelaySubstage
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


clear
%params
yes=2;
no=1;
NameSubstages = {'N1','N2', 'N3','REM','Wake','SWS'}; % Sleep substages
substage_ind = 1:6;

%% DELTA TONE
eval(['load ' FolderProjetDelta 'Data/QuantifSuccessDeltaShamToneSubstage_bis2.mat'])
labels_deltatone = {'140ms','200ms','320ms','490ms'};
for sub=substage_ind
    %delta
    ratio_sucess.delta.deltatone{sub} = [];
    for d=1:length(delays)
        success = squeeze(sum(deltas.tone.density(d,sub,:,yes,yes),2));
        fail = squeeze(sum(deltas.tone.density(d,sub,:,yes,no),2));
        if isempty(ratio_sucess.delta.deltatone)
            ratio_sucess.delta.deltatone{sub} = success ./ (success + fail);
        else
            ratio_sucess.delta.deltatone{sub} = [ratio_sucess.delta.deltatone{sub} success ./ (success + fail)];
        end

    end
    %down
    ratio_sucess.down.deltatone{sub} = [];
    for d=1:length(delays)
        success = squeeze(sum(downs.tone.density(d,sub,:,yes,yes),2));
        fail = squeeze(sum(downs.tone.density(d,sub,:,yes,no),2));
        if isempty(ratio_sucess.down.deltatone)
            ratio_sucess.down.deltatone{sub} = success ./ (success + fail);
        else
            ratio_sucess.down.deltatone{sub} = [ratio_sucess.down.deltatone{sub} success ./ (success + fail)];
        end
    end
end

%% RANDOM TONE
eval(['load ' FolderProjetDelta 'Data/RandomPethAnalysis_bis.mat'])
labels_rdm = {'120-160ms','180-220ms','300-340ms','460-520ms'};
ranges_delay = [120 160;180 220; 300 340; 460 520]*10;   

for sub=substage_ind
    % For each animal
    for m=1:length(animals)
        %delta
        delay = diff.delay{m};
        substages = diff.substage{m};
        for i=1:length(ranges_delay)
            good_delay = delay>=ranges_delay(i,1) & delay<ranges_delay(i,2);
            good_substage = ismember(substages,sub);
            selection_tone = logical(good_delay .* good_substage);

            random.delta.induce(m,i) = sum(diff.induce{m}(selection_tone));
            random.delta.number(m,i) = sum(selection_tone);
        end
        %down
        delay = mua.delay{m};
        substages = mua.substage{m};
        for i=1:length(ranges_delay)
            good_delay = delay>=ranges_delay(i,1) & delay<ranges_delay(i,2);
            good_substage = ismember(substages,sub);
            selection_tone = logical(good_delay .* good_substage);

            random.down.induce(m,i) = sum(mua.induce{m}(selection_tone));
            random.down.number(m,i) = sum(selection_tone);
        end
    end
    ratio_sucess.delta.random{sub} = random.delta.induce ./ random.delta.number;
    ratio_sucess.down.random{sub} = random.down.induce ./ random.down.number;
end

%% PLOT
figure, hold on
for sub=substage_ind
    subplot(2,6,sub), hold on
    PlotErrorBarN_KJ(ratio_sucess.delta.deltatone{sub},'newfig',0);
    title(['Delta Tone - ' NameSubstages{sub}])
    set(gca, 'XTickLabel',labels_deltatone, 'XTick',1:numel(labels_deltatone), 'XTickLabelRotation', 30), hold on,

    subplot(2,6,sub+6), hold on
    PlotErrorBarN_KJ(ratio_sucess.delta.random{sub},'newfig',0);
    title(['Random Tone - ' NameSubstages{sub}])
    set(gca, 'XTickLabel',labels_rdm, 'XTick',1:numel(labels_rdm), 'XTickLabelRotation', 30), hold on,
end






