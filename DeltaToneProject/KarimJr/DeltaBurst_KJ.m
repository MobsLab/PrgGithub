%DeltaBurst_KJ

%Load data
load ChannelsToAnalyse/PFCx_deep
eval(['load LFPData/LFP',num2str(channel)])
LFPdeep=LFP;
clear LFP
load ChannelsToAnalyse/PFCx_sup
eval(['load LFPData/LFP',num2str(channel)])
LFPsup=LFP;
clear LFP
clear channel
load StateEpochSB SWSEpoch
load SpikeData
eval('load SpikesToAnalyse/PFCx_Neurons')
NumNeurons=number;
clear number
load DeltaSleepEvent TONEtime2
tones = ts(TONEtime2);  % real tones
shams = randsample(floor((Range(Restrict(LFPdeep,SWSEpoch),'ms'))), length(Range(tones)));  % random sham

%Args
binsize=10;
thresh0 = 0.7;
minDownDur = 75;
maxDownDur = 500;
mergeGap = 10; % duration max to allow a merge of silence period
predown_size = 50;
%Burst
isiBurst_limit = 500;  % in ms
mergeBurst_limit = 700;


%% Find Down
T=PoolNeurons(S,NumNeurons);
ST{1}=T;
try
    ST=tsdArray(ST);
end
Q=MakeQfromS(ST,binsize);
Down = FindDown2_KJ(Q, 'low_thresh', thresh0, 'minDuration', minDownDur,'maxDuration', maxDownDur, 'mergeGap', mergeGap, 'predown_size', predown_size, 'method', 'mono');
DownCenters = ts(Start(Down) + (End(Down) - Start(Down)) / 2);
down_intervals = [Start(Down) End(Down)];
down_durations = End(Down, 'ms') - Start(Down, 'ms');
down_start = Start(Down);
down_end = End(Down);
nb_down = length(down_durations);


%% ISI
down_isi = (down_intervals(2:end,1) - down_intervals(1:end-1,2)) / 10;
small_isi = down_isi < isiBurst_limit;
start_burst = down_start(diff([0; small_isi])==1);% todo
end_burst = down_end(diff([0; small_isi])==-1);
if length(start_burst)>length(end_burst)
    end_burst = [end_burst;down_end(end)];
end


%% Correction of burst
Bursts = intervalSet(start_burst,end_burst);
Bursts = mergeCloseIntervals(Bursts, mergeBurst_limit*10);
DeltaBurst=zeros(length(End(Bursts)), 2);
for k=1:length(Start(Bursts))  
    DeltaBurst(k,1)=length(Range(Restrict(DownCenters,subset(Bursts,k))));  % numbers of delta in the subset
    DeltaBurst(k,2)=End(subset(Bursts,k),'s')-Start(subset(Bursts,k),'s');  % burst size
end
burst_int = [Start(Bursts,'ms') End(Bursts,'ms')];

burst_ok = burst_int(DeltaBurst(:,1)>2,:); % only burst with more than 2 delta waves
DeltaBurst_ok = DeltaBurst(DeltaBurst(:,1)>2,:);





                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           

%% Effect of Tone During Burst

% number of tones per burst
nbTonePerBurst = zeros(1,length(burst_int));
[status,interval,index] = InIntervals(Range(tones,'ms'), burst_int);
[c,b] = hist(interval,unique(interval));
c = c(2:end);  %remove zero
b = b(2:end)'; 
nbTonePerBurst(b) = c;
res_tones = [DeltaBurst nbTonePerBurst'];  %Nb of delta, duration, number of tones

% The same with a random sham 
[status,interval,index] = InIntervals(shams, burst_int);
[c,b] = hist(interval,unique(interval));
c = c(2:end); %remove zero
b = b(2:end)';
nbShamPerBurst = zeros(1,length(burst_int));
nbShamPerBurst(b) = c;
res_sham = [DeltaBurst nbShamPerBurst']; %Nb of delta, duration, number of tones

% Compare
maxsound = max([unique(res_sham(:,3));unique(res_tones(:,3))]);
nb_delta_burst = DeltaBurst(:,1);
mean_burst_tone = zeros(1,maxsound+1);
std_burst_tone = zeros(1,maxsound+1);
mean_burst_sham = zeros(1,maxsound+1);
std_burst_sham = zeros(1,maxsound+1);

for k=0:maxsound
    try
        mean_burst_tone(k+1) = mean(nb_delta_burst(res_tones(:,3)==k));
        std_burst_tone(k+1) = std(nb_delta_burst(res_tones(:,3)==k));
    end
    try
        mean_burst_sham(k+1) = mean(nb_delta_burst(res_sham(:,3)==k));
        std_burst_sham(k+1) = std(nb_delta_burst(res_sham(:,3)==k));
    end
end
mean_burst_tone(isnan(mean_burst_tone)) = 0;
std_burst_tone(isnan(std_burst_tone)) = 0 ;
mean_burst_sham(isnan(mean_burst_sham)) = 0;
std_burst_sham(isnan(std_burst_sham)) = 0;


%% Plot
figure
hold on
data_series = [mean_burst_tone' mean_burst_sham'];
data_error = [std_burst_tone' std_burst_sham'];
bar(0:maxsound, data_series)
numgroups = size(data_series, 1); 
numbars = size(data_series, 2);  
groupwidth = min(0.8, numbars/(numbars+1.5));

for i = 1:numbars
      x = (0:numgroups-1) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
      errorbar(x, data_series(:,i), data_error(:,i), 'k', 'linestyle', 'none');
end


%% Correlogram of burst with tone
[corr_tones, tps]=CrossCorr(Range(tones,'ms'),burst_int(:,1),100,500);
[corr_sham, tps]=CrossCorr(shams, burst_int(:,1),100,500);
figure, hold on
subplot(2,1,1), hold on, plot(tps/1E3,corr_tones,'k'), ylim([0 2.5])
subplot(2,1,2), hold on, plot(tps/1E3,corr_sham,'k'), ylim([0 2.5])





% %Not used
%
% isi_bins = 0:10:2000;
% [c, b] = hist(down_isi,isi_bins);
% 
% nbdown_inburst = sum(find(diff([0; small_isi])==-1) - find(diff([0; small_isi])==1));
% nbdownPerBurst = find(diff([0; small_isi])==-1) - find(diff([0; small_isi])==1);
% 
%
% %% Burst Colormap: time gap, hour of the night
%burst_thr_list = 0:100:1000;
% nightHours = 0.5:1:9.5;
% NightEpoch = nightHours * 3600E4; %timebins, hour in E-4s
% 
% res_hist = zeros(length(burst_thr_list), length(NightEpoch));
% res_downInBurst = zeros(1, length(burst_thr_list));
% res_meanDownPerBurst = zeros(1, length(burst_thr_list));
% 
% for i=1:length(burst_thr_list)
%     burst_thr = burst_thr_list(i);
%     small_isi = down_isi < burst_thr;
%     start_burst = down_start(diff([0; small_isi])==1);
%     end_burst = down_end(diff([0; small_isi])==-1);
%     Bursts = intervalSet(start_burst,end_burst);
%     Bursts = mergeCloseIntervals(Bursts, burst_thr*2*10);
%     
%     nbdown_inburst = sum(find(diff([0; small_isi])==-1) - find(diff([0; small_isi])==1));
%     nbdownPerBurst = find(diff([0; small_isi])==-1) - find(diff([0; small_isi])==1);
%     
%     [count, b] = hist(start_burst, NightEpoch);
%     
%     res_downInBurst(i) = nbdown_inburst;
%     res_meanDownPerBurst(i) = mean(nbdownPerBurst);
%     res_hist(i,:) = count;
% end
% 
% 
% figure, hold on
% imagesc(nightHours, burst_thr_list, res_hist)
% set(gca,'YDir','normal'), colorbar
% xlabel('Hours of night'), ylabel('Burst threshold definition')
% xlim([0 10]), ylim([0 1000])
% hold on, title('Burst')








