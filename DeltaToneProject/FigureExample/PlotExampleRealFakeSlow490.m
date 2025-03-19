%%PlotExampleRealFakeSlow490
% 15.10.2019 KJ
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
pathexample = '/media/nas4/ProjetDeltaToneFeedback/Mouse490/20161124';
filename = 'ProjectEmbReact_M490_20161124_BaselineSleep.dat';
channels = [56 36 47];
ch_deep = 56;
nb_channels = 71;

% startimes(1) = 45980000; 
% startimes(2) = 47216211;
% startimes(3) = 51972712; 
% startimes(4) = 105128924; 

starttimes(1) = 45980000; endtimes(1) = 46000000;
starttimes(2) = 47220000; endtimes(2) = 47240000;
starttimes(3) = 51970000; endtimes(3) = 52000000;
starttimes(4) = 105130000; endtimes(4) = 105155000;



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
S = S([1:40 42:44]);


for t=1:length(starttimes)
    
    
    %% Epoch to Plot
    starttime = starttimes(t);
    endtime = endtimes(t);
    duration = endtime-starttime;


    LitEpoch = intervalSet(starttime,endtime);
    Sexmpl = Restrict(S,LitEpoch);
    orderspikes = randperm(length(Sexmpl));

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
    color_spikes = 'k';
    gap = [0,0];
    offset = [1400 2800 8000];

    BarHeight = 1;
    BarFraction = 0.8;
    LineWidth = 2;


    % figure
    figure, hold on
    subtightplot(2,1,1,gap), hold on
    %PFC
    plot(Range(FiltEpoch,'ms'),Data(FiltEpoch) + offset(3),'color','r','linewidth',2)
    line([starttime endtime]/10,[thresh_delta thresh_delta] + offset(3), 'color',[0.4 0.4 0.4],'LineWidth',1, 'linestyle','--')


    plot(Range(PFCraw{1},'ms'),Data(PFCraw{1}) + offset(2),'color','r','linewidth',2) % deep
    plot(Range(FiltEpoch,'ms'),Data(FiltEpoch) + offset(2),'color','k','linewidth',1)

    plot(Range(PFCraw{2},'ms'),Data(PFCraw{2}) + offset(1),'color',[0.6 0 0],'linewidth',2)
    plot(Range(PFCraw{3},'ms'),Data(PFCraw{3}),'color','b','linewidth',2) %sup
    %options
    xlim([starttime endtime]/10),
    YL=ylim;
    set(gca, 'xtick',[],'ytick',[])
    set(gca,'xcolor','w','ycolor','w')


    % Raster
    subtightplot(2,1,2,gap), hold on
    for k=1:length(Sexmpl)
      sp = Range(Sexmpl{orderspikes(k)}, 'ms');
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
















