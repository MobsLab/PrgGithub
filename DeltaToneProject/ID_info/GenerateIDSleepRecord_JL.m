% GenerateIDSleepRecord
% 28.09.2016 KJ
%
% Compute and plot description figures of a sleep record
%
%
% see ParcoursGenerateIDSleepRecord


if 0
    checkBeforeGenerateID % aims at checking that all needed codes have been ran before GenerateIDSleepRecord
end
Spk=0;Spi=1 ;NumNeurons=[];nb_neuron=0;
%% params

%MUA and down states
binsize=10;
thresh0 = 0.7;
minDownDur = 60;
maxDownDur = 1000;
mergeGap = 0; % merge
predown_size = 0;
minDurBins = 0:10:1500; %minimum duration bins for downstates
%ripples
thresh_rip = [5 7];
duration_rip = [30 30 100];
binsize_distrib = 20E4; % 20s
ripdown_thresh = 0.2E4; % 200ms


%% Load data
load StateEpochSB SWSEpoch Wake

%LFP
load ChannelsToAnalyse/PFCx_deep
eval(['load LFPData/LFP',num2str(channel)])
LFPdeep=LFP;
clear LFP
try
    load ChannelsToAnalyse/PFCx_sup
catch
    load ChannelsToAnalyse/PFCx_deltasup
end
eval(['load LFPData/LFP',num2str(channel)])
LFPsup=LFP;
clear LFP
try
    load ChannelsToAnalyse/dHPC_rip
    if isempty(channel); error;end
catch
    load ChannelsToAnalyse/dHPC_deep
end
eval(['load LFPData/LFP',num2str(channel)])
HPCrip=LFP;
clear LFP
clear channel


%Down states
if Spk
    try
        load newDownState Down
    catch
        try
            load DownSpk Down
        catch
            Down = intervalSet([],[]);
        end
    end
    start_down = Start(Down); 
    end_down = End(Down);
    down_duration = End(Down) - Start(Down);
end
%Delta waves
try
    load DeltaPFCx DeltaOffline
    tdeltas = (Start(DeltaOffline)+End(DeltaOffline))/2; 
    delta_duration = End(DeltaOffline) - Start(DeltaOffline);
catch
    try
        load newDeltaPFCx DeltaEpoch
    catch
        load AllDeltaPFCx DeltaEpoch
    end
    tdeltas = (Start(DeltaEpoch)+End(DeltaEpoch))/2; 
    delta_duration = End(DeltaEpoch) - Start(DeltaEpoch);
end
%Ripples
try
    load newRipHPC Ripples_tmp
catch
    try
        load AllRipplesdHPC25 dHPCrip;
        Ripples_tmp=dHPCrip;
    catch
        [Ripples_tmp,usedEpoch] = FindRipplesKarimSB(HPCrip,SWSEpoch,thresh_rip,duration_rip);
        save newRipHPC.mat Ripples_tmp
    end
end
if Spi
    %Spindles (sup & deep)
    try
        load SpindlesPFCxDeep SpiHigh SpiLow
    catch
        load AllSpindlesPFCxDeep SpiHigh SpiLow
    end
    SpiHigh_deep = SpiHigh; SpiLow_deep = SpiLow;
    try
        load SpindlesPFCxSup SpiHigh SpiLow
    catch
        load AllSpindlesPFCxSup SpiHigh SpiLow
    end
    SpiHigh_sup = SpiHigh; SpiLow_sup = SpiLow;
end

%% Down characteristics
if Spk 
DurationSWS=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));
DurationWake=sum(End((Wake),'s')-Start((Wake),'s'));
Qsws = Restrict(Q, SWSEpoch);
Qwake = Restrict(Q, Wake);

% Mean firing rates
nb_neuron = length(NumNeurons);
firingRates_sws = round(mean(full(Data(Restrict(Q, SWSEpoch))), 1)*100,2); % firing rate for a bin of 10ms
firingRates_wake = round(mean(full(Data(Restrict(Q, Wake))), 1)*100,2); % firing rate for a bin of 10ms

%interneurons vs pyramidal cells
nb_pyramidal = length(NumNeurons(id_neurons>0));
T_pyr=PoolNeurons(S,NumNeurons(id_neurons>0)); %pyramidal
clear ST
ST{1}=T_pyr;
try
    ST=tsdArray(ST);
end
Q_pyr=MakeQfromS(ST,binsize*10);

nb_interneuron = length(NumNeurons(id_neurons<0));
T_int=PoolNeurons(S,NumNeurons(id_neurons<0)); %interneuron
clear ST
ST{1}=T_int;
try
    ST=tsdArray(ST);
end
Q_int=MakeQfromS(ST,binsize*10);
clear ST T_int T_pyr

firingRates_sws_pyr = round(mean(full(Data(Restrict(Q_pyr, SWSEpoch))), 1)*100,2); % firing rate for a bin of 10ms
firingRates_wake_pyr = round(mean(full(Data(Restrict(Q_pyr, Wake))), 1)*100,2); % firing rate for a bin of 10ms
firingRates_sws_int = round(mean(full(Data(Restrict(Q_int, SWSEpoch))), 1)*100,2); % firing rate for a bin of 10ms
firingRates_wake_int = round(mean(full(Data(Restrict(Q_int, Wake))), 1)*100,2); % firing rate for a bin of 10ms
clear Q_pyr Q_int

% Number of down
if ~isempty(NumNeurons)
    DownSws = FindDownKJ(Qsws, 'low_thresh', thresh0, 'minDuration', 0,'maxDuration', maxDownDur, 'mergeGap', mergeGap, 'predown_size', predown_size);
    downSws_dur = (End(DownSws) - Start(DownSws)) / 10;
    DownWake = FindDownKJ(Qwake, 'low_thresh', thresh0, 'minDuration', 0,'maxDuration', maxDownDur, 'mergeGap', mergeGap, 'predown_size', predown_size);
    downWake_dur = (End(DownWake) - Start(DownWake)) / 10;

    nbDownSWS = zeros(1, length(minDurBins));
    nbDownWake = zeros(1, length(minDurBins));
    for j=1:length(minDurBins)
        bmin = minDurBins(j);
        nbDownSWS(j) = sum(downSws_dur==bmin);
        nbDownWake(j) = sum(downWake_dur==bmin);
    end

    % Raster
    true_DownSws = dropShortIntervals(DownSws, minDownDur*10);
    true_DownSws_dur = (End(true_DownSws) - Start(true_DownSws)) / 10;
    [~, idx_down] = sort(true_DownSws_dur,'descend');
    t_before = -2000; %in 1E-4s
    t_after = 5000; %in 1E-4s
    raster_tsd = RasterMatrixKJ(Q, ts(Start(true_DownSws)), t_before, t_after, idx_down);
    raster_matrix = Data(raster_tsd)';
    raster_x = Range(raster_tsd);
end
end % end of Spk

%% RunSubstages
load NREMepochsML.mat op NamesOp Dpfc Epoch noise
[EP,NamesEP]=DefineSubStages(op,noise);
N1=EP{1}; N2=EP{2}; N3=EP{3}; REM=EP{4}; WAKE=EP{5}; SWS=EP{6}; swaOB=EP{8};
Rec=or(or(SWS,REM),WAKE);
Epochs={N1,N2,N3,REM,WAKE};
num_substage=[2 1.5 1 3 4]; %ordinate in graph

indtime=min(Start(Rec)):500:max(Stop(Rec));
timeTsd=tsd(indtime,zeros(length(indtime),1));
SleepStages=zeros(1,length(Range(timeTsd)))+4.5;
rg=Range(timeTsd);
sample_size = median(diff(rg))/10; %in ms
time_substages = zeros(1,5);
meanDuration_substages = zeros(1,5);
for ep=1:length(Epochs)
    idx=find(ismember(rg,Range(Restrict(timeTsd,Epochs{ep})))==1);
    SleepStages(idx)=num_substage(ep);
    time_substages(ep) = length(idx) * sample_size;
    meanDuration_substages(ep) = mean(diff([0;find(diff(idx)~=1);length(idx)])) * sample_size;
end
SleepStages=tsd(rg,SleepStages');
percentvalues_NREM = zeros(1,3);
for ep=1:3
    percentvalues_NREM(ep) = time_substages(ep)/sum(time_substages(1:3));
end
percentvalues_NREM = round(percentvalues_NREM*100,2);

%% Ripples and Spindles
%ripples
Mripples = PlotRipRaw(HPCrip,Ripples_tmp(:,2),50); close
if Spi
%spindles
Mspindles_low_sup = PlotRipRaw(LFPsup,SpiLow_sup(:,2),500); close
Mspindles_high_sup = PlotRipRaw(LFPsup,SpiHigh_sup(:,2),500); close
try
    Mmua_ls_sup = PlotRipRaw(Q,SpiLow_sup(:,2),500); close
    Mmua_hs_sup = PlotRipRaw(Q,SpiHigh_sup(:,2),500); close
end
Mspindles_low_deep = PlotRipRaw(LFPsup,SpiLow_deep(:,2),500); close
Mspindles_high_deep = PlotRipRaw(LFPsup,SpiHigh_deep(:,2),500); close
end
if Spk
try
    Mmua_ls_deep = PlotRipRaw(Q,SpiLow_deep(:,2),500); close
    Mmua_hs_deep = PlotRipRaw(Q,SpiHigh_deep(:,2),500); close
end
end
%% Sleepscoring SB

%PlotEp
PlotEpSleepScoring = intervalSet(0,max(Range(LFPsup)));

%load theta and gamma and Epochs
load('StateEpochSB')
try
    ghi_new=Restrict(smooth_ghi,PlotEpSleepScoring);
    theta_new=Restrict(smooth_Theta,PlotEpSleepScoring);
catch
    ghi_new=smooth_ghi;
    theta_new=smooth_Theta;   
end

% Restrict gamma and theta signals to intervalSet
t=Range(theta_new);
ti=t(5:1200:end);
ghi_new=(Restrict(ghi_new,ts(ti)));
theta_new=(Restrict(theta_new,ts(ti)));

%beginning and start
try
    begin=Start(PlotEpSleepScoring)/1e4;
    begin=begin(1);
    endin=Stop(PlotEpSleepScoring)/1e4;
    endin=endin(end);
catch
    begin=t(1)/1e4;
    endin=t(end)/1e4;
end

%restrict signals to Epochs
try
    remtheta = (Restrict(theta_new,And(PlotEpSleepScoring,REMEpoch)));
catch
    remtheta = (Restrict(theta_new,REMEpoch));
end
ghi_new_rem = Restrict(ghi_new,ts(Range(remtheta)));

try
    sleeptheta = (Restrict(theta_new,And(PlotEpSleepScoring,SWSEpoch)));
catch
    sleeptheta = (Restrict(theta_new,SWSEpoch));
end
ghi_new_sws = Restrict(ghi_new,ts(Range(sleeptheta)));

waketheta = (Restrict(theta_new,Wake));
ghi_new_wake = Restrict(ghi_new,ts(Range(waketheta)));


%% Average delta curves
nb_deltas=length(tdeltas);
[~, idx_delta_sorted] = sort(delta_duration,'ascend');
if nb_deltas >= 1000
   small_delta = idx_delta_sorted(1:500);
   big_delta = idx_delta_sorted(end-499:end);
else
    halfsize = floor(nb_deltas/2);
    small_delta = idx_delta_sorted(1:halfsize);
    big_delta = idx_delta_sorted(end-halfsize+1:end);
end 
Ms_delta_small = PlotRipRaw(LFPsup,tdeltas(small_delta)/1E4,500); close
Ms_delta_big = PlotRipRaw(LFPsup,tdeltas(big_delta)/1E4,500); close
Md_delta_small = PlotRipRaw(LFPdeep,tdeltas(small_delta)/1E4,500); close
Md_delta_big = PlotRipRaw(LFPdeep,tdeltas(big_delta)/1E4,500); close

if Spk
try
    Mmua_delta_small = PlotRipRaw(Q,tdeltas(small_delta)/1E4,500); close
    Mmua_delta_big = PlotRipRaw(Q,tdeltas(big_delta)/1E4,500); close
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Save data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
save IdFigureData SleepStages Epochs time_substages percentvalues_NREM meanDuration_substages

if ~isempty(NumNeurons)
    save IdFigureData -append raster_x raster_matrix minDurBins nbDownSWS nbDownWake
    save IdFigureData -append nb_neuron nb_pyramidal nb_interneuron firingRates_sws firingRates_wake firingRates_sws_pyr firingRates_wake_pyr firingRates_sws_int firingRates_wake_int
end

try
save IdFigureData -append Mripples Mspindles_low_sup Mspindles_high_sup Mspindles_low_deep Mspindles_high_deep
catch
    save IdFigureData -append Mripples 
end
try
    save IdFigureData -append Mmua_ls_sup Mmua_hs_sup Mmua_ls_deep Mmua_hs_deep
end
save IdFigureData -append Ms_delta_small Md_delta_small Ms_delta_big Md_delta_big
try
    save IdFigureData -append Mmua_delta_small Mmua_delta_big
end
save IdFigureData -append ghi_new_rem ghi_new_sws ghi_new_wake remtheta sleeptheta waketheta sleepper smooth_Theta theta_thresh smooth_ghi gamma_thresh


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure('Color',[1 1 1],'units','normalized','outerposition',[0 0 1 1]);
RasterDown_Axes = axes('position', [0.27 0.72 0.15 0.21]);
DistribDown_Axes = axes('position', [0.45 0.72 0.15 0.21]);
textbox_dim = [0.05 0.75 0.18 0.17];

Sleepscoring_Axes = axes('position', [0.74 0.6 0.2 0.32]);
SleepscoringTheta_Axes = axes('position', [0.66 0.6 0.07 0.32]);
SleepscoringGamma_Axes = axes('position', [0.74 0.49 0.2 0.1]);

AverageRipple_Axes = axes('position', [0.05 0.54 0.3 0.13]);
AverageSpindle_Axes = axes('position', [0.05 0.3 0.3 0.19]);
AverageDelta_Axes = axes('position', [0.41 0.3 0.3 0.25]);

Substages_Axes = axes('position', [0.05 0.05 0.4075 0.2]);
StatSubstage_Axes = axes('position', [0.52 0.05 0.2 0.2]);
MeanDurSubstage_Axes = axes('position', [0.75 0.05 0.2 0.2]);


%% Down states
% Create textbox
if nb_neuron
    textbox_str = {[num2str(nb_neuron) ' neurons'], [num2str(nb_pyramidal) ' pyramidal(s) / ' num2str(nb_interneuron) ' interneuron(s)'],... 
                    ['FR (SWS) = ' num2str(firingRates_sws) ' Hz ( ' num2str(firingRates_sws/nb_neuron) ' Hz)'],...
                    ['FR (Wake) = ' num2str(firingRates_wake) ' Hz ( ' num2str(firingRates_wake/nb_neuron) ' Hz)'],...
                    ['Pyr (SWS) = ' num2str(firingRates_sws_pyr) ' Hz ( ' num2str(firingRates_sws_pyr/nb_pyramidal) ' Hz)'],...
                    ['Pyr (Wake) = ' num2str(firingRates_wake_pyr) ' Hz ( ' num2str(firingRates_wake_pyr/nb_pyramidal) ' Hz)'],...
                    ['Int (SWS) = ' num2str(firingRates_sws_int) ' Hz ( ' num2str(firingRates_sws_int/nb_interneuron) ' Hz)'],...
                    ['int (Wake) = ' num2str(firingRates_wake_int) ' Hz ( ' num2str(firingRates_wake_int/nb_interneuron) ' Hz)']};
else
   textbox_str = {'No neurons'}; 
end

annotation(gcf,'textbox',...
    textbox_dim,...
    'String',textbox_str,...
    'LineWidth',1,...
    'HorizontalAlignment','center',...
    'FontWeight','bold',...
    'FitBoxToText','off');

%raster
if Spk
axes(RasterDown_Axes);
if exist('raster_x','var')
    imagesc(raster_x/1E4, 1:size(raster_matrix,1), raster_matrix), hold on
    axis xy, xlabel('time (sec)'), ylabel('# down'), hold on
    colorbar, hold on
end
try title({pwd,' '});end

%distribution of down
axes(DistribDown_Axes);
if nb_neuron>0
    plot(minDurBins, nbDownSWS ,'r'), hold on
    plot(minDurBins, nbDownWake ,'k'), hold on
    set(gca,'xscale','log','yscale','log'), hold on
    set(gca,'ylim',[1 1E6],'xlim',[10 1500]), hold on
    set(gca,'xtick',[10 50 100 200 500 1500]), hold on
    legend('SWS','Wake'), xlabel('down duration (ms)'), ylabel('number of down')
end
end
%% Substages
axes(Substages_Axes);
ylabel_substage = {'N3','N2','N1','REM','WAKE'};
ytick_substage = [1 1.5 2 3 4]; %ordinate in graph
colori = {[0.5 0.3 1], [1 0.5 1], [0.8 0 0.7], [0.1 0.7 0], [0.5 0.2 0.1]}; %substage color
plot(Range(SleepStages,'s')/3600,Data(SleepStages),'k'), hold on,
for ep=1:length(Epochs)
    plot(Range(Restrict(SleepStages,Epochs{ep}),'s')/3600 ,Data(Restrict(SleepStages,Epochs{ep})),'.','Color',colori{ep}), hold on,
end
xlim([0 max(Range(SleepStages,'s')/3600)]), ylim([0.5 5]), set(gca,'Ytick',ytick_substage,'YTickLabel',ylabel_substage), hold on,
title('Hypnogram'); xlabel('Time (h)')

axes(StatSubstage_Axes);
for ep=1:length(time_substages)
    h = bar(ep, time_substages(ep)/1000); hold on
    set(h,'FaceColor', colori{ep}), hold on
    if any(1:3==ep)
        text(ep - 0.3, time_substages(ep)/1000 + 1000, [num2str(percentvalues_NREM(ep)) '%'], 'VerticalAlignment', 'top', 'FontSize', 8)
    end
end
set(gca, 'XTickLabel',{'N1','N2','N3','REM','WAKE'}, 'XTick',1:5), hold on
ylim([0, max(time_substages/1000) * 1.2]);
title('Total duration'); ylabel('duration (s)')


axes(MeanDurSubstage_Axes)
for ep=1:length(meanDuration_substages)
    h = bar(ep, meanDuration_substages(ep)/1000); hold on
    set(h,'FaceColor', colori{ep}), hold on
end
set(gca, 'XTickLabel',{'N1','N2','N3','REM','WAKE'}, 'XTick',1:5), hold on
title('Episode mean duration'); ylabel('duration (s)')


%% Ripples and spindles
%ripples
axes(AverageRipple_Axes);
plot(Mripples(:,1),Mripples(:,2),'r','linewidth',2), hold on 
line([0 0],get(gca,'YLim')), hold on
title('Mean ripples signal : -50 +50 ms'), hold on

if Spi
%spindles
axes(AverageSpindle_Axes);
yyaxis left
plot(Mspindles_low_sup(:,1),Mspindles_low_sup(:,2),'b','linewidth',2), hold on
plot(Mspindles_high_sup(:,1),Mspindles_high_sup(:,2),'r','linewidth',2), hold on
ylabel('LFP')
try
    yyaxis right
    plot(Mmua_ls_sup(:,1),Mmua_ls_sup(:,2), 'color','b'), hold on
    plot(Mmua_hs_sup(:,1),Mmua_hs_sup(:,2), 'color','r'), hold on
    ylabel('MUA (10s bin)')
    legend('LFP: low spindles','LFP: high spindles','MUA: low spindles','MUA: high spindles')
catch
    legend('LFP: low spindles','LFP: high spindles')
end
line([0 0],get(gca,'YLim')), hold on
title('Mean spindles signal : -500 +500 ms'), hold on
end
%% Delta waves
axes(AverageDelta_Axes);
yyaxis left
plot(Ms_delta_small(:,1),Ms_delta_small(:,2),'--', 'color', 'b'), hold on
plot(Md_delta_small(:,1),Md_delta_small(:,2),'--', 'color', 'r'), hold on
plot(Ms_delta_big(:,1),Ms_delta_big(:,2), '-', 'color', 'b'), hold on
plot(Md_delta_big(:,1),Md_delta_big(:,2),'-', 'color', 'r'), hold on
ylabel('LFP')
try %MUA average sync
    yyaxis right
    maxvalue = ceil(max([Mmua_delta_small(:,2);Mmua_delta_big(:,2)]));
    plot(Mmua_delta_small(:,1),Mmua_delta_small(:,2),'--', 'color','k'), hold on
    plot(Mmua_delta_big(:,1),Mmua_delta_big(:,2),'-',  'color','k'), hold on
    ylabel('MUA (10s bin)'), ylim([0 maxvalue*3])
    legend('LFP Sup (short deltas)','LFP deep (short deltas)','LFP Sup (long deltas)','LFP deep (long deltas)','MUA (short deltas)','MUA (long deltas)')
    title_ax = 'Mean LFP and MUA: averaged on delta waves centers';
catch
    legend('LFP Sup (short deltas)','LFP deep (short deltas)','LFP Sup (long deltas)','LFP deep (long deltas)')
    title_ax = 'Mean LFP  averaged on delta waves centers';
end

line([0 0],get(gca,'YLim')), hold on
title(title_ax), hold on


%% Sleep scoring
axes(Sleepscoring_Axes);
plot(log(Data(ghi_new_rem)),log(Data(remtheta)),'.','color',[1 0.2 0.2],'MarkerSize',1); hold on
plot(log(Data(ghi_new_sws)),log(Data(sleeptheta)),'.','color',[0.4 0.5 1],'MarkerSize',1); hold on
plot(log(Data(ghi_new_wake)),log(Data(waketheta)),'.','color',[0.6 0.6 0.6],'MarkerSize',1); hold on
[~,icons,~,~]=legend('REM','SWS','Wake'); hold on
set(icons(5),'MarkerSize',20)
set(icons(7),'MarkerSize',20)
set(icons(9),'MarkerSize',20)
ys=get(gca,'Ylim');
xs=get(gca,'Xlim');
box on
set(gca,'XTick',[],'YTick',[])

axes(SleepscoringTheta_Axes);
[~, rawN, ~] = nhist(log(Data(Restrict(smooth_Theta,sleepper))),'maxx',max(log(Data(Restrict(smooth_Theta,sleepper)))),'noerror','xlabel','Theta power','ylabel',[]); axis xy
view(90,-90)
line([log(theta_thresh) log(theta_thresh)],[0 max(rawN)],'linewidth',4,'color','r')
set(gca,'YTick',[],'Xlim',ys)

axes(SleepscoringGamma_Axes);
[~, rawN, ~] = nhist(log(Data(smooth_ghi)),'maxx',max(log(Data(smooth_ghi))),'noerror','xlabel','Gamma power','ylabel',[]);
line([log(gamma_thresh) log(gamma_thresh)],[0 max(rawN)],'linewidth',4,'color','r')
set(gca,'YTick',[],'Xlim',xs)




