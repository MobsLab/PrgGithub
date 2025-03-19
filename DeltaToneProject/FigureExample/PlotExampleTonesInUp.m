%%PlotExampleTonesInUp
% 18.09.2019 KJ
%
% Infos
%   Examples figures :
%       - tones in Up states > Down
%
% see
%     PlotExampleRealFakeSlow
%
%


clear

%params
pathexample = '/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150416/Breath-Mouse-243-244-16042015/Mouse243';
filename = 'Breath-Mouse-243-16042015.dat';
nb_channels = 35;
channels = [0 25 27];
labels = {'PFC deep', 'PFC', 'PFC sup'};

% pathexample = '/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150417/Breath-Mouse-243-244-17042015/Mouse244';
% filename = 'Breath-Mouse-244-17042015.dat';
% nb_channels = 35;
% channels = [0 28 27];
% labels = {'PFC deep', 'PFC', 'PFC'};

duration = 2.8e4;

success_down = [80828314 85511500 97004126 101623220 115017550 120271428 120367064];


%init
disp(' ')
disp('****************************************************************')
cd(pathexample)
disp(pwd)


%NREM
[NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
NREM = CleanUpEpoch(NREM - TotalNoiseEpoch,1);


%MUA & Spikes
load('SpikeData.mat')
load('SpikesToAnalyse/PFCx_Neurons.mat')
S = S(number);
S = tsdArray(S);

%tones
load('behavResources.mat', 'ToneEvent')
tones_res.nb_tones = length(ToneEvent);
    

for sd=1:length(success_down)
    starttime = success_down(sd)-0.5e4;

    %% Epoch to Plot
    endtime = starttime+duration;
    LitEpoch = intervalSet(starttime,endtime);

    %Restrict
    tones_tmp = Range(Restrict(ToneEvent,LitEpoch));
    Sepoch = Restrict(S,LitEpoch);
    Sepoch = Sepoch(randperm(size(Sepoch,1)),:);

    %raw LFP
    for ch=1:length(channels)
        data_pfc = LoadBinary(filename,'duration',duration/1e4,'frequency',2e4,'nchannels',nb_channels,'start',starttime/1e4,'channels',channels(ch)+1);
        tmp = starttime:0.5:starttime+duration-0.5; tmp=tmp';
        PFCraw{ch} = tsd(tmp, data_pfc);
    end


    %% Plot

    %params plot
    gap = [0,0];
    offset = [2800 1400 0];
    color_channels = {'r',[1 0 0.5], 'b'};
    color_spikes = 'k';

    BarHeight = 1;
    BarFraction = 0.8;
    LineWidth = 2;


    % figure
    figure, hold on
    subtightplot(2,1,1,gap), hold on

    %PFC
    for ch=1:length(PFCraw)
        plot(Range(PFCraw{ch},'ms'),Data(PFCraw{ch}) + offset(ch), 'color',color_channels{ch},'linewidth',2)
    end
    YL=ylim;
    line([tones_tmp tones_tmp]/10, YL,'Linewidth',2,'color',[0.4 0.4 0.4],'LineStyle','--'), hold on
    %options
    xlim([starttime endtime]/10),
    set(gca, 'xtick',[],'ytick',[])
    set(gca,'xcolor','w','ycolor','w')


    % Raster
    subtightplot(2,1,2,gap), hold on
    for k=1:length(Sepoch)
      sp = Range(Sepoch{k}, 'ms');
      sx = [sp sp repmat(NaN, length(sp), 1)];
      sy = repmat([(k*BarHeight) (k*BarHeight + BarHeight *BarFraction) NaN], length(sp), 1);
      sx = reshape(sx', 1, length(sp)*3);
      sy = reshape(sy', 1, length(sp)*3);

      line(sx, sy, 'Color', color_spikes, 'LineWidth', LineWidth);
      hold on

    end
    set(gca, 'ylim', [-3 length(Sepoch)+1]);
    line([tones_tmp tones_tmp]/10, ylim,'Linewidth',2,'color',[0.4 0.4 0.4],'LineStyle','--'), hold on
    xlim([starttime endtime]/10),
    set(gca, 'xtick',[],'ytick',[])
    set(gca,'xcolor','w','ycolor','w')


    %scale bar
    line([endtime-0.25e4 endtime-0.05e4]/10,[-1 -1], 'color','k','LineWidth', 3)
    text((endtime-0.15e4)/10,-2, '200 ms', 'HorizontalAlignment','center')



end












