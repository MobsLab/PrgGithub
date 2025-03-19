%%TestQuantifyPethResponse
% 17.04.2018 KJ

clear
load('SpikeData.mat')
load('SpikesToAnalyse/PFCx_Neurons.mat')
NumNeurons=number;
S = S(NumNeurons);

load('DeltaSleepEvent.mat', 'TONEtime2') 
tones_tmp = TONEtime2 ;
tEvents=ts(tones_tmp);


%params
binsize_mua  = 2; %2ms
minDuration  = 50;
binsize=2;
nb_bins = 500;

nb_perm = 1000;
window=[0 2000];
smoothing=1;

%MUA & Down
MUA = GetMuaNeurons_KJ('PFCx','binsize',binsize_mua); %2ms
down_PFCx = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 0, 'predown_size', 20, 'method', 'mono');
%epochs
intwindow = 4000;
aroundDown = intervalSet(Start(down_PFCx)-intwindow, End(down_PFCx)+intwindow);
Allnight = intervalSet(0,max(Range(MUA)));
Epoch = CleanUpEpoch(Allnight-aroundDown);


%% Events
if exist('Epoch','var')
    tEvents = Restrict(tEvents, Epoch);
end
event_tmp = Range(tEvents);


%% tone impact
load('NeuronTones', 'Ctones', 'xtones', 'Csham', 'xsham', 'NumNeurons', 'neuronsLayers')
 %responding neurons
Cdiff = Ctones.up - Csham;
idt = xtones.around>0 & xtones.around<80;

for i=1:length(neuronsLayers)
    effect_peak(i) = max(Cdiff(i,idt));
    effect_mean(i) = mean(Cdiff(i,idt));
end

responses = zeros(length(neuronsLayers),1);
idn = effect_peak>4;
resp_neurons = NumNeurons(idn);
regular_neurons = NumNeurons(~idn);





%% z-scored correlograms


for i=1:length(S)

    %Correlogram for each neuron
    [Cevents{i}, xc] = CrossCorr(event_tmp, Range(PoolNeurons(S,i)), binsize,nb_bins);
    %zscore
    Cevents{i} = zscore(Cevents{i});
    %smooth
    sCevents{i} = smooth(Cevents{i}, 1);
    
    % Cumsum of shuffle sPETH
    for n=1:nb_perm
        shuffleC{i}(n,:) = cumsum(sCevents{i}(randperm(length(sCevents{i}))));
    end
    
    realC{i}   = cumsum(sCevents{i});
    
end

%measure
clear Sdiff Sderiv perc_sdiff perc_sderiv Rdiff Rderiv 
for i=1:length(S)
    for n=1:nb_perm
        Sdiff{i}(n) = max(shuffleC{i}(n,:)) - min(shuffleC{i}(n,:));
        Sderiv{i}(n) = mean(diff(shuffleC{i}(n,xc>0&xc<150)));
    end
    
    %percentile
    perc_sdiff(i,1) = prctile(Sdiff{i},95);
    perc_sderiv(i,1) = prctile(Sderiv{i},92);
    
    %
    Rdiff(i,1) = max(realC{i}) - min(realC{i});
    Rderiv(i,1) = mean(diff(realC{i}(xc>0&xc<150)));
    
end

a = [perc_sdiff Rdiff Rdiff>perc_sdiff];
b = [perc_sderiv Rderiv Rderiv>perc_sderiv];

unique([find(Rderiv>perc_sderiv & Rdiff>perc_sdiff) ; find(Rdiff>1.3*perc_sdiff)])



%% PLOT
i=30;
figure, hold on

subplot(2,2,1), hold on
plot(xc, shuffleC{i}'),
plot(xc, realC{i},'k','linewidth',2),
title(num2str(i)),

subplot(2,2,3), hold on
% plot(xc, sCevents{i},'k'),
plot(xtones, smooth(Ctones(i,:), 1),'b'),
plot(xsham, smooth(Csham(i,:),1),'r'),
xlim([-200 400])

subplot(2,2,2), hold on
hist(Sdiff{i},50),
line([perc_sdiff(i) perc_sdiff(i)], get(gca, 'ylim'), 'color', 'r', 'linewidth', 2);
line([Rdiff(i) Rdiff(i)], get(gca, 'ylim'), 'color', 'k');
title('Sdiff'),


subplot(2,2,4), hold on
hist(Sderiv{i},50),
line([perc_sderiv(i) perc_sderiv(i)], get(gca, 'ylim'), 'color', 'r', 'linewidth', 2);
line([Rderiv(i) Rderiv(i)], get(gca, 'ylim'), 'color', 'k');
title('Sderiv'),




figure, hold on

for i=1:length(S)
    pause
    clf

    subplot(2,2,1), hold on
    plot(xc, shuffleC{i}'),
    plot(xc, realC{i},'k','linewidth',2),
    title(num2str(i)),

    subplot(2,2,3), hold on
    plot(xtones, smooth(Ctones(i,:), 1)),
    plot(xsham, smooth(Csham(i,:),1)),
    xlim([-200 400])

    subplot(2,2,2), hold on
    hist(Sdiff{i},50),
    line([perc_sdiff(i) perc_sdiff(i)], get(gca, 'ylim'), 'color', 'r', 'linewidth', 2);
    line([Rdiff(i) Rdiff(i)], get(gca, 'ylim'), 'color', 'k');
    title('Sdiff'),


    subplot(2,2,4), hold on
    hist(Sderiv{i},50),
    line([perc_sderiv(i) perc_sderiv(i)], get(gca, 'ylim'), 'color', 'r', 'linewidth', 2);
    line([Rderiv(i) Rderiv(i)], get(gca, 'ylim'), 'color', 'k');
    title('Sderiv'),
    
    
end





