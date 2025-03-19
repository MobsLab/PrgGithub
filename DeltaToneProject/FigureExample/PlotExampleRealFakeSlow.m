%%PlotExampleRealFakeSlow
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
factorLFP = 0.195;
freq_delta = [1 6];


starttime = 110239121; endtime = starttime + 4e4;
starttime = 133691350; endtime = 133727176;

starttime = 133700000; endtime = 133727176;
duration = endtime-starttime;


%init
disp(' ')
disp('****************************************************************')
cd(pathexample)
disp(pwd)


%Filter deep
load(['LFPData/LFP' num2str(ch_deep) '.mat'])
PFCdeep = LFP;
clear LFP

thresh_std = 2;
FiltDeep = FilterLFP(PFCdeep, freq_delta, 1024);
positive_filtered = max(Data(FiltDeep),0);
std_of_signal = std(positive_filtered(positive_filtered>0));  % std that determines thresholds
thresh_delta = thresh_std * std_of_signal;



%Spikes
load('SpikeData.mat')
load('SpikesToAnalyse/PFCx_Neurons.mat')
S = S(number);


%% Epoch to Plot

LitEpoch = intervalSet(starttime,endtime);
Sexmpl = Restrict(S,LitEpoch);

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
color_spikes = 'k';
gap = [0,0];
offset = [700 1400 2800 9000];

BarHeight = 1;
BarFraction = 0.8;
LineWidth = 2;


% figure
figure, hold on
subtightplot(2,1,1,gap), hold on
%PFC
plot(Range(FiltDeep,'ms'),Data(FiltDeep) + offset(4),'color','r','linewidth',2)
line([starttime endtime]/10,[thresh_delta thresh_delta] + offset(4), 'color',[0.4 0.4 0.4],'LineWidth',1, 'linestyle','--')


plot(Range(PFCraw{1},'ms'),Data(PFCraw{1}) + offset(3),'color','r','linewidth',2) % deep
plot(Range(FiltDeep,'ms'),Data(FiltDeep) + offset(3),'color','k','linewidth',1)

plot(Range(PFCraw{2},'ms'),Data(PFCraw{2}) + offset(2),'color',[0.6 0 0],'linewidth',2)
plot(Range(PFCraw{3},'ms'),Data(PFCraw{3}) + offset(1),'color',[0.3 0 0],'linewidth',2)
plot(Range(PFCraw{4},'ms'),Data(PFCraw{4}),'color','b','linewidth',2) %sup
%options
xlim([starttime endtime]/10),
YL=ylim;
set(gca, 'xtick',[],'ytick',[])
set(gca,'xcolor','w','ycolor','w')


% Raster
subtightplot(2,1,2,gap), hold on
for k=1:length(Sexmpl)
  sp = Range(Sexmpl{k}, 'ms');
  sx = [sp sp repmat(NaN, length(sp), 1)];
  sy = repmat([(k*BarHeight) (k*BarHeight + BarHeight *BarFraction) NaN], length(sp), 1);
  sx = reshape(sx', 1, length(sp)*3);
  sy = reshape(sy', 1, length(sp)*3);

  line(sx, sy, 'Color', color_spikes, 'LineWidth', LineWidth);
  set(gca, 'ylim', [1 length(Sexmpl)+1]);

  hold on

end
xlim([starttime endtime]/10),

set(gca, 'xtick',[],'ytick',[])
set(gca,'xcolor','w','ycolor','w')


%scale bar
line([endtime-0.25e4 endtime-0.05e4]/10,[3 3], 'color','k','LineWidth', 3)
text((endtime-0.15e4)/10,2, '200 ms', 'HorizontalAlignment','center')



















