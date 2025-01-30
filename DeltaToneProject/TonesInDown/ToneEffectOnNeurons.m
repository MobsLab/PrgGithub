%%ToneEffectOnNeurons
% 12.04.2018 KJ
%
%
% see
%   ToneDuringDownStateRaster ToneDuringDownStateEffect
%



clear


Dir1=PathForExperimentsDeltaSleepSpikes('RdmTone');
Dir2=PathForExperimentsDeltaSleepSpikes('DeltaT0');
Dir = MergePathForExperiment(Dir1,Dir2);


p=2;


disp(' ')
disp('****************************************************************')
eval(['cd(Dir.path{',num2str(p),'}'')'])
disp(pwd)


%params
binsize_mua  = 2; %2ms
minDuration  = 50;


%MUA & Down
MUA = GetMuaNeurons_KJ('PFCx','binsize',binsize_mua); %2ms
down_PFCx = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 0, 'predown_size', 20, 'method', 'mono');
st_down = Start(down_PFCx);
end_down = End(down_PFCx);
down_duration = End(down_PFCx) - Start(down_PFCx);

%tones
load('DeltaSleepEvent.mat', 'TONEtime2')
tones_tmp = TONEtime2 + Dir.delay{p}*1E4;
ToneEvent = ts(tones_tmp);

%epochs
intwindow = 4000;
aroundDown = intervalSet(Start(down_PFCx)-intwindow, End(down_PFCx)+intwindow);
Allnight = intervalSet(0,max(Range(MUA)));


%% Tones in or out
ToneIn = Restrict(ToneEvent, down_PFCx);
tonein_tmp = Range(ToneIn);
ToneOut = Restrict(ToneEvent, CleanUpEpoch(Allnight-aroundDown));
toneout_tmp = Range(ToneOut);


%% Create sham
nb_sham=3000;
sham_tmp = [];
for i=1:nb_sham
    timetone = randsample(tones_tmp, 1);
    sham_tmp = [sham_tmp;timetone + (rand-0.5)*4e4];
end
sham_tmp = sort(sham_tmp);
ShamEvent = ts(sham_tmp);

%sham in and out down states
ShamIn = Restrict(ShamEvent, down_PFCx);
shamin_tmp = Range(ShamIn);
ShamOut = Restrict(ShamEvent, CleanUpEpoch(Allnight-aroundDown));
shamout_tmp = Range(ShamOut);


%% spikes
load('SpikeData.mat', 'neuronsLayers','S')
load('SpikesToAnalyse/PFCx_Neurons.mat')
NumNeurons = number;
neuronsLayers = neuronsLayers(NumNeurons);
S = S(NumNeurons);


%% correlo
clear CT xtones xsham Corr Corrz Cout Coutz Cin Cinz

%Tones
for i=1:length(S)
    
    %all tones
    [CT, ~] = CrossCorr(tones_tmp, Range(PoolNeurons(S,i)),20,200);
    baseline = CT(1:40);
    
    %all tones
    [Corr.tones(i,:), xtones] = CrossCorr(tones_tmp, Range(PoolNeurons(S,i)),20,50);
    Corrz.tones(i,:) = (Corr.tones(i,:) -mean(baseline)) / std(baseline);
    
    %out of down
    [Cout.tones(i,:), xtones] = CrossCorr(toneout_tmp, Range(PoolNeurons(S,i)),20,50);    
    Coutz.tones(i,:) = (Cout.tones(i,:) -mean(baseline)) / std(baseline);
    
    %indown
    [Cin.tones(i,:), xtones] = CrossCorr(tonein_tmp, Range(PoolNeurons(S,i)),20,50);    
    Cinz.tones(i,:) = (Cin.tones(i,:) -mean(baseline)) / std(baseline);
    
end

%Sham
for i=1:length(S)
    
    %all tones
    [CT, ~] = CrossCorr(sham_tmp, Range(PoolNeurons(S,i)),20,200);
    baseline = CT(1:40);
    
    %all tones
    [Corr.sham(i,:), xsham] = CrossCorr(sham_tmp, Range(PoolNeurons(S,i)),20,50);
    Corrz.sham(i,:) = (Corr.sham(i,:) -mean(baseline)) / std(baseline);
    
    %out of down
    [Cout.sham(i,:), xsham] = CrossCorr(shamout_tmp, Range(PoolNeurons(S,i)),20,50);    
    Coutz.sham(i,:) = (Cout.sham(i,:) -mean(baseline)) / std(baseline);
    
    %indown
    [Cin.sham(i,:), xsham] = CrossCorr(shamin_tmp, Range(PoolNeurons(S,i)),20,50);    
    Cinz.sham(i,:) = (Cin.sham(i,:) -mean(baseline)) / std(baseline);
    
end


%% matrix

%smooth
smoothing = [0.001,1];

%Tones
MT_all = Corrz.tones; %mat all tones
MT_out = Coutz.tones; %mat out
MT_in  = Cinz.tones; %mat in

[m, idt] = sort(max(MT_all(:,xtones>0&xtones<100),[],2));

MT_all = SmoothDec(MT_all(idt,:), smoothing);
MT_out = SmoothDec(MT_out(idt,:), smoothing);
MT_in  = SmoothDec(MT_in(idt,:), smoothing);


%sham
MS_all = Corrz.sham; %mat all tones
MS_out = Coutz.sham; %mat out
MS_in  = Cinz.sham; %mat in

[m, ids] = sort(max(MS_all(:,xsham>0&xsham<100),[],2));
ids=idt;

MS_all = SmoothDec(MS_all(ids,:), smoothing);
MS_out = SmoothDec(MS_out(ids,:), smoothing);
MS_in  = SmoothDec(MS_in(ids,:), smoothing);


%% PLOT
figure, 
subplot(1,3,1),
imagesc(xtones, 1:size(MT_all,1), MT_all), hold on
line([0 0], ylim,'Linewidth',2,'color','k'), hold on
caxis([-20 50]),
title('All tones'),

subplot(1,3,2),
imagesc(xtones, 1:size(MT_out,1), MT_out), hold on
line([0 0], ylim,'Linewidth',2,'color','k'), hold on
caxis([-20 50]),
title('Out of down'),

subplot(1,3,3),
imagesc(xtones, 1:size(MT_in,1), MT_in), hold on
line([0 0], ylim,'Linewidth',2,'color','k'), hold on
caxis([-20 50]),
title('In down'),

suplabel('SUA around tones','t');


%% PLOT
figure, 
subplot(1,3,1),
imagesc(xsham, 1:size(MS_all,1), MS_all), hold on
line([0 0], ylim,'Linewidth',2,'color','k'), hold on
caxis([-20 50]),
title('All sham'),

subplot(1,3,2),
imagesc(xsham, 1:size(MS_out,1), MS_out), hold on
line([0 0], ylim,'Linewidth',2,'color','k'), hold on
caxis([-20 50]),
title('Out of down'),

subplot(1,3,3),
imagesc(xsham, 1:size(MS_in,1), MS_in), hold on
line([0 0], ylim,'Linewidth',2,'color','k'), hold on
caxis([-20 50]),
title('In down'),

suplabel('SUA around sham','t');


%% PLOT
figure, 
subplot(1,3,1),
imagesc(xsham, 1:size(MS_all,1), MT_all - MS_all), hold on
line([0 0], ylim,'Linewidth',2,'color','k'), hold on
% caxis([-20 50]),
title('All events'),

subplot(1,3,2),
imagesc(xsham, 1:size(MS_out,1), MT_out - MS_out), hold on
line([0 0], ylim,'Linewidth',2,'color','k'), hold on
% caxis([-20 50]),
title('Out of down'),

subplot(1,3,3),
imagesc(xsham, 1:size(MS_in,1), MT_in - MS_in), hold on
line([0 0], ylim,'Linewidth',2,'color','k'), hold on
% caxis([-20 50]),
title('In down'),

suplabel('SUA difference','t');



%% plot correlo
figure, 
k=1;
hold on, plot(xtones, Corrz.tones(idt(end-k),:)),ylim([-8 6]),
hold on, plot(xsham, Corrz.sham(idt(end-k),:)),ylim([-8 6]),


