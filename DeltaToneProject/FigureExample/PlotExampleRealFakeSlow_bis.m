%%PlotExampleRealFakeSlow_bis
% 13.09.2019 KJ
%
% Infos
%   Examples figures :
%       - good inversion with down states
%       - bad inversion without down states
%
% see
%     FindExampleRealFakeSlow
%
%


clear

%path
pathexample = '/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243';
filename = 'Breath-Mouse-243-09042015.dat';
channels = [0 26 25 27];
ch_deep = 0;
nb_channels = 35;

%path
pathexample = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170126/ProjectEmbReact_M508_20170126_BaselineSleep';
filename = 'ProjectEmbReact_M508_20170126_BaselineSleep.dat';
channels = [28 4 0 19];
ch_deep = 28;
nb_channels = 70;

%path
pathexample = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170127/ProjectEmbReact_M508_20170127_BaselineSleep';
filename = 'ProjectEmbReact_M508_20170127_BaselineSleep.dat';
channels = [28 4 0 19];
ch_deep = 28;
nb_channels = 70;

%path
pathexample = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170127/ProjectEmbReact_M509_20170127_BaselineSleep';
filename = 'ProjectEmbReact_M509_20170127_BaselineSleep.dat';
channels = [22 0 28 44];
ch_deep = 22;
nb_channels = 70;

%path
pathexample = '/media/nas4/ProjetDeltaToneFeedback/Mouse490/20161124';
filename = 'ProjectEmbReact_M490_20161124_BaselineSleep.dat';
channels = [56 36 48 47];
ch_deep = 56;
nb_channels = 71;



%% init
disp(' ')
disp('****************************************************************')
cd(pathexample)
disp(pwd)

%params
factorLFP = 0.195;
freq_delta = [1 6];

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

%examples
load('fake_example.mat', 'st_exemple_fake')

for t=150:200%1:length(st_exemple_fake)
    
    
    %% Epoch to Plot
    starttime = st_exemple_fake(t)-1e4;
    duration = 3e4;
    endtime = starttime + duration;



    LitEpoch = intervalSet(starttime,endtime);
    Sexmpl = Restrict(S,LitEpoch);

    %
    for ch=1:length(channels)

        data_pfc = LoadBinary(filename,'duration',duration/1e4,'frequency',2e4,'nchannels',nb_channels,'start',starttime/1e4,'channels',channels(ch)+1);
        tmp = starttime:0.5:starttime+duration-0.5; tmp=tmp';

        PFCraw{ch} = tsd(tmp, data_pfc);

    end
    FiltEpoch= Restrict(FiltDeep, LitEpoch);


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
    plot(Range(FiltEpoch,'ms'),Data(FiltEpoch) + offset(4),'color','r','linewidth',2)
    line([starttime endtime]/10,[thresh_delta thresh_delta] + offset(4), 'color',[0.4 0.4 0.4],'LineWidth',1, 'linestyle','--')


    plot(Range(PFCraw{1},'ms'),Data(PFCraw{1}) + offset(3),'color','r','linewidth',2) % deep
    plot(Range(FiltEpoch,'ms'),Data(FiltEpoch) + offset(3),'color','k','linewidth',1)

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


end
















