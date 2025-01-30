%%PlotExampleInterCortexDown
% 13.09.2019 KJ
%
% Infos
%   Examples figures as in Sirota 2005
%
% see
%     FindExampleLocalDown1 PlotExampleLocalDown
%
%


clear

%params
pathexample = '/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Breath-Mouse-243-244-29032015/Mouse244';
filename = 'Breath-Mouse-244-29032015.dat';
nb_channelrecord = 32;
id_tetrodes = [1 2 3];

starttime = 33883200;
% starttime = 74848000;
% starttime = 152232700;
duration = 3.5e4;
endtime = starttime+duration;


%init
disp(' ')
disp('****************************************************************')
cd(pathexample)
disp(pwd)


%PFC
load('ChannelsToAnalyse/PFCx_locations.mat')
channels_pfc = channels;

%PaCx
load('ChannelsToAnalyse/PaCx_deep.mat')
ch_Padeep = channel;
load('ChannelsToAnalyse/PaCx_mid.mat')
ch_Pamid = channel;
load('ChannelsToAnalyse/PaCx_sup.mat')
ch_Pasup = channel;
%MoCx
load('ChannelsToAnalyse/MoCx_deep.mat')
ch_Modeep = channel;
load('ChannelsToAnalyse/MoCx_mid.mat')
ch_Momid = channel;
load('ChannelsToAnalyse/MoCx_sup.mat')
ch_Mosup = channel;

    
%Spikes
load('SpikeData.mat', 'S');
if ~isa(S,'tsdArray')
    S = tsdArray(S);
end
%Spike tetrode
load('SpikesToAnalyse/PFCx_tetrodes.mat')
NeuronTetrodes = numbers;
tetrodeChannelsCell = channels;
nb_tetrodes = length(tetrodeChannelsCell);
tetrodeChannels = [];
for tt=1:nb_tetrodes
    tetrodeChannels(tt) = channels_pfc(ismember(channels_pfc,tetrodeChannelsCell{tt}));
end

NeuronTetrodes = NeuronTetrodes(id_tetrodes);
tetrodeChannelsCell = tetrodeChannelsCell(id_tetrodes);
tetrodeChannels = tetrodeChannels(id_tetrodes);
nb_tetrodes = length(tetrodeChannelsCell);



%% Epoch to Plot

LitEpoch = intervalSet(starttime,endtime);

tmp = starttime:0.5:starttime+duration-0.5; tmp=tmp';
%PFc
for ch=1:nb_tetrodes
    data_lfp = LoadBinary(filename,'duration',duration/1e4,'frequency',2e4,'nchannels',nb_channelrecord,'start',starttime/1e4,'channels',tetrodeChannels(ch)+1);
    PFCraw{ch} = tsd(tmp, data_lfp);
end

%PaCx
data_lfp = LoadBinary(filename,'duration',duration/1e4,'frequency',2e4,'nchannels',nb_channelrecord,'start',starttime/1e4,'channels',ch_Padeep+1);
PaDeepRaw = tsd(tmp, data_lfp);
data_lfp = LoadBinary(filename,'duration',duration/1e4,'frequency',2e4,'nchannels',nb_channelrecord,'start',starttime/1e4,'channels',ch_Pamid+1);
PaMidRaw = tsd(tmp, data_lfp);
data_lfp = LoadBinary(filename,'duration',duration/1e4,'frequency',2e4,'nchannels',nb_channelrecord,'start',starttime/1e4,'channels',ch_Pasup+1);
PaSupRaw = tsd(tmp, data_lfp);
%MoCx
data_lfp = LoadBinary(filename,'duration',duration/1e4,'frequency',2e4,'nchannels',nb_channelrecord,'start',starttime/1e4,'channels',ch_Modeep+1);
MoDeepRaw = tsd(tmp, data_lfp);
data_lfp = LoadBinary(filename,'duration',duration/1e4,'frequency',2e4,'nchannels',nb_channelrecord,'start',starttime/1e4,'channels',ch_Momid+1);
MoMidRaw = tsd(tmp, data_lfp);
data_lfp = LoadBinary(filename,'duration',duration/1e4,'frequency',2e4,'nchannels',nb_channelrecord,'start',starttime/1e4,'channels',ch_Mosup+1);
MoSupRaw = tsd(tmp, data_lfp);


%% Plot

%params plot
alpha = 0.2;
colorGlobal = 'b';
colorLocal = [0.6 0.6 0.6];
gap = [0,0];

offset = -1500 + (0:length(NeuronTetrodes)-1)*1600;
offset = [offset offset(end)+4000 offset(end)+5600 offset(end)+7200];
offset = [offset offset(end)+6000 offset(end)+7600 offset(end)+9000];

BarHeight = 1;
BarFraction = 0.8;
LineWidth = 4;

%colors
color_pfc = 'k';
color_pa = 'r';
color_mo = [1 0.6 0];


%%  figure
figure, hold on
subtightplot(3,1,1:2,gap), hold on
%PFC
for tt=1:length(PFCraw)
    h(3) = plot(Range(PFCraw{tt},'ms'),Data(PFCraw{tt}) + offset(tt), 'color',color_pfc,'linewidth',2);
end
plot(Range(PaSupRaw,'ms'),Data(PaSupRaw) + offset(tt+1), 'color',color_pa,'linewidth',1.5)
plot(Range(PaMidRaw,'ms'),Data(PaMidRaw) + offset(tt+2), 'color',color_pa,'linewidth',1.5)
h(2) = plot(Range(PaDeepRaw,'ms'),Data(PaDeepRaw) + offset(tt+3), 'color',color_pa,'linewidth',2.5);

plot(Range(MoSupRaw,'ms'),Data(MoSupRaw) + offset(tt+4), 'color',color_mo,'linewidth',1.5)
plot(Range(MoMidRaw,'ms'),Data(MoMidRaw) + offset(tt+5), 'color',color_mo,'linewidth',1.5)
h(1) = plot(Range(MoDeepRaw,'ms'),Data(MoDeepRaw) + offset(tt+6), 'color',color_mo,'linewidth',2.5);


%options
xlim([starttime endtime]/10),
YL=ylim;

set(gca, 'xtick',[],'ytick',[])
set(gca,'xcolor','w','ycolor','w')



% Raster
S_epoch = Restrict(S,LitEpoch);
subtightplot(3,1,3,gap), hold on
k=0;
for tt=1:length(NeuronTetrodes)
    Stet = S_epoch(NeuronTetrodes{tt});
    for j=1:length(Stet)
        k=k+1; %offset
        
        sp = Range(Stet{j}, 'ms');
        sx = [sp sp repmat(NaN, length(sp), 1)];
        sy = repmat([(k*BarHeight) (k*BarHeight + BarHeight *BarFraction) NaN], length(sp), 1);
        sx = reshape(sx', 1, length(sp)*3);
        sy = reshape(sy', 1, length(sp)*3);

        line(sx, sy, 'Color', color_pfc, 'LineWidth', LineWidth);
        hold on

    end
end
set(gca, 'ylim', [-3 k+1], 'xlim', [starttime endtime]/10);

set(gca, 'xtick',[],'ytick',[],'Fontsize',20)
set(gca,'xcolor','w','ycolor','w')


%scale bar
line([endtime-0.25e4 endtime-0.05e4]/10, [0 0], 'color','k','LineWidth', 3)
text((endtime-0.15e4)/10,-2, '200 ms', 'HorizontalAlignment','center','Fontsize',15)


%legend
legend(h,'MoCx','PaCx','PFCx','Fontsize',20),















