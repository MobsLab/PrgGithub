% FigureSuccessRateDelay
% 17.12.2016 KJ
%
% Success rate in function of the delay between delta waves and tones (in DeltaToneConditions)
% 
%   see SuccessRateDelaySWS QuantifSuccessDeltaShamToneSubstage
%   FigureSuccessRateDelay2
%


%load
clear
load(fullfile(FolderDeltaDataKJ,'QuantifSuccessDeltaShamToneSubstage_bis2.mat'))

%params
yes=2;
no=1;
sws_ind = [2 3];
animals_ind = 1:length(animals);
labels_deltatone = {'0ms','140ms','320ms','490ms'};

%% DELTA TONE

idx_delay = [1 2 3 4];
%delta
percentage_sucess.delta.deltatone = [];
for d=idx_delay
    success = squeeze(sum(deltas.tone.density(d,sws_ind,animals_ind,yes,yes),2));
    fail = squeeze(sum(deltas.tone.density(d,sws_ind,animals_ind,yes,no),2));
    if isempty(percentage_sucess.delta.deltatone)
        percentage_sucess.delta.deltatone = success ./ (success + fail);
    else
        percentage_sucess.delta.deltatone = [percentage_sucess.delta.deltatone success ./ (success + fail)];
    end
    
end
percentage_sucess.delta.deltatone = 100 * percentage_sucess.delta.deltatone;


%% RANDOM TONE
load(fullfile(FolderDeltaDataKJ,'RandomPethAnalysis_bis.mat'))

labels_rdm = {'0-50ms', '130-150ms','300-340ms','460-520ms'};
ranges_delay = [0 50; 130 150; 300 340; 460 520]*10;  

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
end
percentage_sucess.delta.random = 100*random.delta.induce ./ random.delta.number;
percentage_sucess.delta.random(4,:)=[]; %problem with mouse 328


%% PLOT

%Line
labels_tone={'~0ms','~140ms','~320ms','~490ms'};
figure, hold on
[~,h(1)]=PlotErrorLineN_KJ(percentage_sucess.delta.deltatone,'newfig',0,'linecolor','r','ShowSigstar','none');
[~,h(2)]=PlotErrorLineN_KJ(percentage_sucess.delta.random,'newfig',0,'linecolor','b','ShowSigstar','none');
legend(h,'Delta Triggered tone','Random tone')
title('Success rate for Delta triggered and Random Condition','fontsize',16)
set(gca, 'XTickLabel',labels_tone, 'XTick',1:numel(labels_tone),'YTick',0:20:80,'YLim',[0 80],'FontName','Times','fontsize',20), hold on,
ylabel('% of tones evoking a delta waves'),



% figure, hold on
% subplot(1,2,1), hold on
% [~,eb]=PlotErrorBarN_KJ(percentage_sucess.delta.deltatone,'newfig',0);
% set(eb,'Linewidth',2); %bold error bar
% title('Delta triggered Tone','fontsize',16)
% set(gca, 'XTickLabel',labels_deltatone, 'XTick',1:numel(labels_deltatone),'YTick',0:20:80,'YLim',[0 80],'FontName','Times','fontsize',16), hold on,
% ylabel('% of tones evoking a delta waves'),
% 
% subplot(1,2,2), hold on
% [~,eb]=PlotErrorBarN_KJ(percentage_sucess.delta.random,'newfig',0);
% set(eb,'Linewidth',2); %bold error bar
% title('Random Tone','fontsize',16)
% set(gca, 'XTickLabel',labels_rdm, 'XTick',1:numel(labels_rdm),'YTick',0:20:80,'YLim',[0 80],'FontName','Times','fontsize',16), hold on,


