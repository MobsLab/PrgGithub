%%PlotExampleRealFakeSlow2
% 13.09.2019 KJ
%
% Infos
%   Examples figures as in Sirota 2005, but with :
%       - good inversion with down states
%       - bad inversion without down states
%
% see
%     FindExampleRealFakeSlow
%
%


clear

%params
pathexample = '/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Breath-Mouse-243-244-31032015/Mouse243';
filename = 'Breath-Mouse-243-31032015.dat';
channels = [0 26 25 27];
ch_deep = 0;
ch_sup = 27;
factorLFP = 0.195;
binsize_mua = 2;
freq_delta = [1 6];


starttime = 110239121; endtime = starttime + 4e4;
starttime = 133691350; endtime = 133727176;
duration = endtime-starttime;


%init
disp(' ')
disp('****************************************************************')
cd(pathexample)
disp(pwd)

%NREM
[NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
NREM = CleanUpEpoch(NREM - TotalNoiseEpoch,1);

%LFP PFCx
labels_ch = cell(0);
PFC = cell(0);
for ch=1:length(channels)
    load(['LFPData/LFP' num2str(channels(ch)) '.mat'])
    PFC{ch} = LFP;
    clear LFP
    labels_ch{ch} = ['Ch ' num2str(channels(ch))];
end

PFCdeep = PFC{channels==ch_deep};
PFCsup = PFC{channels==ch_sup};

%Filter deep
thresh_std = 2;
FiltDeep = FilterLFP(PFCdeep, freq_delta, 1024);
positive_filtered = max(Data(FiltDeep),0);
std_of_signal = std(positive_filtered(positive_filtered>0));  % std that determines thresholds
thresh_delta = thresh_std * std_of_signal;



%Spikes
load('SpikeData.mat')
load('SpikesToAnalyse/PFCx_Neurons.mat')
S = S(number);

%down
load('DownState.mat', 'down_PFCx')
 
%Delta Deep
name_var = ['delta_ch_' num2str(ch_deep)];
load('DeltaWavesChannels.mat', name_var)
eval(['deltas = ' name_var ';'])
DeltaDeep = and(deltas, NREM);
st_deep = Start(DeltaDeep);
center_deep = (Start(DeltaDeep) + End(DeltaDeep))/2;
%Delta Sup
name_var = ['delta_ch_' num2str(ch_sup)];
load('DeltaWavesChannels.mat', name_var)
eval(['deltas = ' name_var ';'])
DeltaSup = and(deltas, NREM);
st_sup = Start(DeltaSup);
center_sup = (Start(DeltaSup) + End(DeltaSup))/2;



%% Fake and real

%strict down
MUA = MakeQfromS(S, binsize_mua*10);
MUA = tsd(Range(MUA), sum(full(Data(MUA)),2));
StrictDown = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', 75, 'maxduration',800, 'mergeGap', 0, 'predown_size', 30, 'method', 'mono');
StrictDown = and(StrictDown,NREM);

%deep
[RealDeep,~,Istat, idreal] = GetIntersectionsEpochs(DeltaDeep, down_PFCx);
FakeDeep = subset(DeltaDeep, setdiff(1:length(Start(DeltaDeep)), idreal)');
%sup
[RealSup,~,Istat, idreal] = GetIntersectionsEpochs(DeltaSup, down_PFCx);
FakeSup = subset(DeltaSup, setdiff(1:length(Start(DeltaSup)), idreal)');


%% Epoch to Plot

LitEpoch = intervalSet(starttime,endtime);

%delta waves and donw states
DeltaExample = and(or(RealDeep,RealSup),LitEpoch);
st_real  = Start(DeltaExample,'ms');
end_real = End(DeltaExample,'ms');

DeltaExample = and(FakeDeep,LitEpoch);
st_deep  = Start(DeltaExample,'ms');
end_deep = End(DeltaExample,'ms');

DeltaExample = and(FakeSup,LitEpoch);
st_sup  = Start(DeltaExample,'ms');
end_sup = End(DeltaExample,'ms');

DownExample = and(down_PFCx,LitEpoch);
st_down  = Start(DownExample,'ms');
end_down = End(DownExample,'ms');

StrictExample = and(StrictDown,LitEpoch);
st_strictdown  = Start(StrictExample,'ms');
end_strictdown = End(StrictExample,'ms');


%
for ch=1:length(channels)

    data_pfc = LoadBinary(filename,'duration',duration/1e4,'frequency',2e4,'nchannels',32,'start',starttime/1e4,'channels',channels(ch)+1);
    tmp = starttime:0.5:starttime+duration-0.5; tmp=tmp';
    
    PFCraw{ch} = tsd(tmp, data_pfc);
    
end
FiltDeep = Restrict(FiltDeep, LitEpoch);




%% Plot

%params plot
alpha = 0.2;
colorReal = 'b';
colorFake = [0.4 0.4 0.4];
gap = [0,0];
offset = [700 1400 2800];

BarHeight = 1;
BarFraction = 0.8;
LineWidth = 2;


% figure
figure, hold on
subtightplot(2,1,1,gap), hold on
%PFC
plot(Range(PFCraw{1},'ms'),Data(PFCraw{1}) + offset(3),'color','r','linewidth',2) % deep
plot(Range(FiltDeep,'ms'),Data(FiltDeep) + offset(3),'color','k','linewidth',1)
line([starttime endtime]/10,[thresh_delta thresh_delta] + offset(3), 'color','k','LineWidth',1)

plot(Range(PFCraw{2},'ms'),Data(PFCraw{2}) + offset(2),'color',[0.6 0 0],'linewidth',2)
plot(Range(PFCraw{3},'ms'),Data(PFCraw{3}) + offset(1),'color',[0.3 0 0],'linewidth',2)
plot(Range(PFCraw{4},'ms'),Data(PFCraw{4}),'color','b','linewidth',2) %sup
%options
xlim([starttime endtime]/10),
YL=ylim;
% for i=[1 2 4 5 6]%1:length(st_strictdown)
%     x_rec = [st_strictdown(i) end_strictdown(i) end_strictdown(i) st_strictdown(i)];
%     y_rec = [YL(1) YL(1) YL(2) YL(2)];
%     pa=patch(x_rec,y_rec,colorReal);
%     set(pa,'FaceAlpha',alpha,'EdgeColor','w');
% end
% for i=1:length(st_deep)
%     x_rec = [st_deep(i) end_deep(i) end_deep(i) st_deep(i)];
%     y_rec = [YL(1) YL(1) YL(2) YL(2)];
%     pa=patch(x_rec,y_rec,colorFake);
%     set(pa,'FaceAlpha',alpha,'EdgeColor','w');
% end

set(gca, 'xtick',[],'ytick',[])
set(gca,'xcolor','w','ycolor','w')


% Raster
Sexmpl = Restrict(S,LitEpoch);
[colori{1:length(Sexmpl)}] = deal('k');

subtightplot(2,1,2,gap), hold on
for k=1:length(Sexmpl)
  sp = Range(Sexmpl{k}, 'ms');
  sx = [sp sp repmat(NaN, length(sp), 1)];
  sy = repmat([(k*BarHeight) (k*BarHeight + BarHeight *BarFraction) NaN], length(sp), 1);
  sx = reshape(sx', 1, length(sp)*3);
  sy = reshape(sy', 1, length(sp)*3);

  line(sx, sy, 'Color', colori{k}, 'LineWidth', LineWidth);
  set(gca, 'ylim', [1 length(Sexmpl)+1]);

  hold on

end
xlim([starttime endtime]/10),
% for i=1:length(st_strictdown)
%     x_rec = [st_strictdown(i) end_strictdown(i) end_strictdown(i) st_strictdown(i)];
%     y_rec = [YL(1) YL(1) YL(2) YL(2)];
%     pa=patch(x_rec,y_rec,colorReal);
%     set(pa,'FaceAlpha',alpha,'EdgeColor','w');
% end
% for i=1:length(st_deep)
%     x_rec = [st_deep(i) end_deep(i) end_deep(i) st_deep(i)];
%     y_rec = [YL(1) YL(1) YL(2) YL(2)];
%     pa=patch(x_rec,y_rec,colorFake);
%     set(pa,'FaceAlpha',alpha,'EdgeColor','w');
% end
set(gca, 'xtick',[],'ytick',[])
set(gca,'xcolor','w','ycolor','w')


%scale bar
line([endtime-0.25e4 endtime-0.05e4]/10,[3 3], 'color','k','LineWidth', 3)
text((endtime-0.15e4)/10,2, '200 ms', 'HorizontalAlignment','center')



















