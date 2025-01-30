% GenerateIDSleepRecord2
% 25.11.2016 KJ
%
% Compute and plot description figures of a sleep record
% It is the second Id Sleep Record Figure
%
%
% See
%     GenerateIDSleepRecord 
%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load and Compute
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%params
binsize_mua=10; %10ms
binsize_density = 60E4; % 60s


%% Load

% substages
load NREMepochsML.mat op NamesOp Dpfc Epoch noise
[EP,NamesEP]=DefineSubStages(op,noise);
N1=EP{1}; N2=EP{2}; N3=EP{3}; REM=EP{4}; WAKE=EP{5}; SWS=EP{6};

%MUA and spikes
load SpikeData
try
    eval('load SpikesToAnalyse/PFCx_Neurons')
catch
    try
        eval('load SpikesToAnalyse/PFCx_MUA')
    catch
        number=[];
    end
end
NumNeurons=number;
clear number
T=PoolNeurons(S,NumNeurons);
clear ST
ST{1}=T;
try
    ST=tsdArray(ST);
end
Qmua=MakeQfromS(ST,binsize_mua*10);
Qmua=tsd(Range(Qmua),full(Data(Qmua)));
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
clear channel

%Down states
try
    load newDownState Down
catch
    try
        load DownSpk Down
    catch
        Down = intervalSet([],[]);
    end
end
tdowns = (Start(Down)+End(Down))/2; 
%Delta waves
try
    load DeltaPFCx DeltaOffline
catch
    try
        load newDeltaPFCx DeltaEpoch
    catch
        load AllDeltaPFCx DeltaEpoch
    end
    DeltaOffline =  DeltaEpoch;
    clear DeltaEpoch
end
tdeltas = (Start(DeltaOffline)+End(DeltaOffline))/2;

%Ripples
try
    load newRipHPC Ripples_tmp
catch
    load AllRipplesdHPC25.mat dHPCrip
end

%Spindles
try
    load SpindlesPFCxSup SpiHigh SpiLow
    load SpindlesPFCxDeep SpiHigh SpiLow
catch
    load AllSpindlesPFCxSup SpiHigh SpiLow
    load AllSpindlesPFCxDeep SpiHigh SpiLow
end
SpiHigh_sup = SpiHigh;
SpiLow_sup = SpiLow;
SpiHigh_deep = SpiHigh;
SpiLow_deep = SpiLow;

%Tones/Shams
try
    load('DeltaSleepEvent.mat', 'TONEtime1')
    delay = Dir.delay{p}*1E4; %in 1E-4s
    Events = ts(TONEtime1 + delay);
    with_tone=1;with_sham=0;
catch
    load('ShamSleepEvent.mat', 'SHAMtime')
    delay = 0;
    Events = ts(Range(SHAMtime) + delay);
    with_tone=0;with_sham=1;
end
if with_tone
    leg_event = 'Tones';
else
    leg_event = 'Shams';
end
nb_events = length(Events);


%% Spindles and Ripples 

%delta density
ST1{1}=ts(tdeltas);
try
    ST1=tsdArray(ST1);
end
QDelta = MakeQfromS(ST1,binsize_density);
QDelta = tsd(Range(QDelta),full(Data(QDelta)));
clear ST
%down density
ST1{1}=ts(tdowns);
try
    ST1=tsdArray(ST1);
end
QDown = MakeQfromS(ST1,binsize_density);
QDown = tsd(Range(QDown),full(Data(QDown)));
clear ST

%spindles density
ST1{1}=ts(SpiHigh_sup(:,2)*1E4);
try
    ST1=tsdArray(ST1);
end
QSpindleHigh = MakeQfromS(ST1,binsize_density);
QSpindleHigh = tsd(Range(QSpindleHigh),full(Data(QSpindleHigh)));
clear ST
%ripples density
ST1{1}=ts(Ripples_tmp(:,2)*1E4);
try
    ST1=tsdArray(ST1);
end
QRipples = MakeQfromS(ST1,binsize_density);
QRipples = tsd(Range(QRipples),full(Data(QRipples)));
clear ST

%tone/sham density
ST1{1}=Events;
try
    ST1=tsdArray(ST1);
end
Qevents = MakeQfromS(ST1,binsize_density);
Qevents = tsd(Range(Qevents),full(Data(Qevents)));
clear ST


%% Delta and Down 

%% Down and delta detection
% intersection delta waves and down states
intvDur = 1E3;
larger_delta_epochs = [Start(DeltaOffline)-intvDur, End(DeltaOffline)+intvDur];
if ~isempty(tdowns)
    [status,~,~] = InIntervals(tdowns,larger_delta_epochs);
else
    status = [];
end
nb_down = length(tdowns);
nb_delta = length(tdeltas);
nb_delta_down = length(tdowns(status));

% LFP averaged on events
binsize_MET = 4;
nb_bins_MET = 300;
[Md_down.y,~,Md_down.x]             = mETAverage(tdowns, Range(LFPdeep), Data(LFPdeep), binsize_MET, nb_bins_MET);
[Md_deltadown.y,~,Md_deltadown.x]   = mETAverage(tDownDelta, Range(LFPdeep), Data(LFPdeep),binsize_MET, nb_bins_MET);
[Md_delta.y,~,Md_delta.x]           = mETAverage(tdeltas, Range(LFPdeep), Data(LFPdeep), binsize_MET, nb_bins_MET);

% MUA averaged on events
binsize_MET=12;
nb_bins_MET=100;
[Mmua_down.y, ~, Mmua_down.x]             = mETAverage(tdowns, Range(Qmua), Data(Qmua), binsize_MET, nb_bins_MET);
[Mmua_deltadown.y, ~, Mmua_deltadown.x]   = mETAverage(tDownDelta, Range(Qmua), Data(Qmua),binsize_MET, nb_bins_MET);
[Mmua_delta.y, ~, Mmua_delta.x]           = mETAverage(tdeltas, Range(Qmua), Data(Qmua), binsize_MET, nb_bins_MET);


% Histogram Inter-Delta-Intervals and Inter-Down-Intervals
step=100;
edges=0:step:5000;
%down
h1_downs = histogram(diff(tdowns/10), edges);
downs.histo.x = h1_downs.BinEdges(1:end-1);
downs.histo.y = h1_downs.Values; close
h2_downs = histogram(Data(Restrict(tsd(tdowns(1:end-1),diff(tdowns/10)),N2)), edges);
downs.histo_n2.x = h2_downs.BinEdges(1:end-1);
downs.histo_n2.y = h2_downs.Values; close
h3_downs = histogram(Data(Restrict(tsd(tdowns(1:end-1),diff(tdowns/10)),N3)), edges);
downs.histo_n3.x = h3_downs.BinEdges(1:end-1);
downs.histo_n3.y = h3_downs.Values; close
%delta
h1_deltas = histogram(diff(tdeltas/10), edges);
deltas.histo.x = h1_deltas.BinEdges(1:end-1);
deltas.histo.y = h1_deltas.Values; close
h2_deltas = histogram(Data(Restrict(tsd(tdeltas(1:end-1),diff(tdeltas/10)),N2)), edges);
deltas.histo_n2.x = h2_deltas.BinEdges(1:end-1);
deltas.histo_n2.y = h2_deltas.Values; close
h3_deltas = histogram(Data(Restrict(tsd(tdeltas(1:end-1),diff(tdeltas/10)),N3)), edges);
deltas.histo_n3.x = h3_deltas.BinEdges(1:end-1);
deltas.histo_n3.y = h3_deltas.Values; close

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Save data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
save IdFigureData2 QDelta QDown QSpindleHigh QRipples QRipples
save IdFigureData2 -append nb_down nb_delta_down nb_delta
save IdFigureData2 -append Md_down Md_deltadown Md_delta
try
    save IdFigureData2 -append Mmua_down Mmua_deltadown Mmua_delta
end
save IdFigureData2 -append downs deltas edges

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure('units','normalized','outerposition',[0 0 1 1]);
RipplesSpindles_Axes = axes('position', [0.05 0.67 0.5 0.29]);
DeltaDown_Axes1 = axes('position', [0.05 0.37 0.25 0.25]);
DeltaDown_Axes2 = axes('position', [0.35 0.37 0.25 0.25]);
DeltaDown_Axes3 = axes('position', [0.05 0.05 0.25 0.25]);
DeltaDown_Axes4 = axes('position', [0.35 0.05 0.25 0.25]);


%% Spindles and Ripples
axes(RipplesSpindles_Axes);
smoothing=1;

yyaxis left
plot(Range(QDelta,'s')/3600,SmoothDec(Data(QDelta),smoothing),'-',  'color','k'), hold on,
if length(QDown)>0
    plot(Range(QDown,'s')/3600,SmoothDec(Data(QDown),smoothing),'--',  'color','k'), hold on,
end
yyaxis right
plot(Range(QSpindleHigh,'s')/3600,SmoothDec(Data(QSpindleHigh),smoothing),'-',  'color','r'), hold on,
plot(Range(QRipples,'s')/3600,SmoothDec(Data(QRipples),smoothing),'-',  'color','b'), hold on,
plot(Range(Qevents,'s')/3600,SmoothDec(Data(Qevents),smoothing),'-',  'color','g'), hold on,
if length(QDown)>0
    legend('Delta', 'Down', 'spindles (high)', 'Ripples', leg_event), hold on,
else
    legend('Delta', 'spindles (high)', 'Ripples', leg_event), hold on,
end
xlim([0 max(Range(LFPdeep,'s'))/3600]), hold on,
xlabel('Time (h)'),title('Density of events'), 

%% Delta and down
axes(DeltaDown_Axes1);
plot(Md_down.x,Md_down.y,'linewidth',2), hold on
plot(Md_deltadown.x,Md_deltadown.y,'linewidth',2), hold on
plot(Md_delta.x,Md_delta.y,'linewidth',2), hold on
legend(['AllDown n=' num2str(nb_down)], ['Down on delta n=' num2str(nb_delta_down)], ['AllDelta n=' num2str(nb_delta)])
ylabel('LFP averaged on time of...'); xlabel('Time (ms)')

axes(DeltaDown_Axes2);
plot(Mmua_down.x,Mmua_down.y,'linewidth',2), hold on
plot(Mmua_deltadown.x,Mmua_deltadown.y,'linewidth',2), hold on
plot(Mmua_delta.x,Mmua_delta.y,'linewidth',2), hold on
legend('AllDown','Down on delta','AllDelta')
ylabel('MUA averaged on time of...'); xlabel('Time (ms)')

axes(DeltaDown_Axes3);
bar(downs.histo.x,downs.histo.y), hold on
plot(downs.histo_n2.x, downs.histo_n2.y), hold on
plot(downs.histo_n3.x, downs.histo_n3.y), hold on
xlim([min(edges),edges(end-1)])
title('#Down'); xlabel('Inter Down Interval')
legend('All down','N2','N3')

axes(DeltaDown_Axes4);
bar(deltas.histo.x,deltas.histo.y), hold on
plot(deltas.histo_n2.x, deltas.histo_n2.y), hold on
plot(deltas.histo_n3.x, deltas.histo_n3.y), hold on
xlim([min(edges),edges(end-1)])
title('#Delta'); xlabel('Inter Delta Interval')
legend('All down','N2','N3')







