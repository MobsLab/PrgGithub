%%ScriptDeltavsDownOneNight
% 12.07.2019 KJ
%
%
%   see 
%       
%

clearvars -except Dir p

disp(' ')
disp('****************************************************************')
cd(Dir.path{p})
disp(pwd)


%% params
binsize_cc = 10;
nbBins_cc  = 100;
binsize_met = 10;
nbBins_met  = 80;

intvDur = 50*10; %100ms


%% load

%Delta waves
delta_PFCx   = GetDeltaWaves;
st_deltas    = Start(delta_PFCx);
end_deltas   = End(delta_PFCx);
delta_center = (st_deltas+end_deltas)/2;
delta_duration = End(delta_PFCx) - Start(delta_PFCx);
%Down States
down_PFCx   = GetDownStates;
st_down     = Start(down_PFCx);
end_down    = End(down_PFCx);
down_center = (st_down+end_down)/2;
down_duration = End(down_PFCx) - Start(down_PFCx);
%Substages
[N1, N2, N3, REM, Wake] = GetSubstages('scoring','ob');
NREM = or(N1,or(N2,N3));
Substages = {N1,N2,N3,REM,Wake,NREM};


%LFP deep
if exist('ChannelsToAnalyse/PFCx_deltadeep.mat','file')==2
    load('ChannelsToAnalyse/PFCx_deltadeep.mat', 'channel')
else
    load('ChannelsToAnalyse/PFCx_deep.mat', 'channel')
end
load(['LFPData/LFP' num2str(channel) '.mat'])
ch_deep = channel;
PFCdeep = LFP; clear LFP
%LFP sup
if exist('ChannelsToAnalyse/PFCx_sup.mat','file')==2
    load('ChannelsToAnalyse/PFCx_sup.mat', 'channel')
else
    load('ChannelsToAnalyse/PFCx_sup.mat', 'channel')
end
load(['LFPData/LFP' num2str(channel) '.mat'])
ch_sup = channel;
PFCsup = LFP; clear LFP



%% meancurves
% Start
[m,~,tps] = mETAverage(st_down, Range(PFCdeep), Data(PFCdeep), binsize_met, nbBins_met);
met_start.deep(:,1) = tps; met_start.deep(:,2) = m; 
[m,~,tps] = mETAverage(st_down, Range(PFCsup), Data(PFCsup), binsize_met, nbBins_met);
met_start.sup(:,1) = tps; met_start.sup(:,2) = m; 
% End
[m,~,tps] = mETAverage(end_down, Range(PFCdeep), Data(PFCdeep), binsize_met, nbBins_met);
met_end.deep(:,1) = tps; met_end.deep(:,2) = m; 
[m,~,tps] = mETAverage(end_down, Range(PFCsup), Data(PFCsup), binsize_met, nbBins_met);
met_end.sup(:,1) = tps; met_end.sup(:,2) = m; 


%% Cross correlograms
%starts
[Cc_start.y, Cc_start.x] = CrossCorr(st_down, st_deltas, binsize_cc,nbBins_cc);
%ends
[Cc_end.y, Cc_end.x] = CrossCorr(end_down, end_deltas, binsize_cc,nbBins_cc);
%center of down with borders of deltas
[Cc_center.start.y, Cc_center.start.x] = CrossCorr(down_center, st_deltas, binsize_cc,nbBins_cc);
[Cc_center.end.y, Cc_center.end.x] = CrossCorr(down_center, end_deltas, binsize_cc,nbBins_cc);


%% Down and deltas intersection
larger_down_epochs = [st_down, end_down+intvDur];
[status, intervals, index] = InIntervals(delta_center,larger_down_epochs);

idx_down  = [];
idx_delta = [];
for i=1:length(delta_center)
    if status(i) && index(i)==1
        idx_down   = [idx_down;intervals(i)];
        idx_delta  = [idx_delta;i];
    end
end

delta_rec = st_deltas(idx_delta);
down_rec  = st_down(idx_down);

%durations
deltaDur_rec = delta_duration(idx_delta)/10;
downDur_rec  = down_duration(idx_down)/10;

% count
down_delta = sum(status);
down_only = length(st_down) - down_delta;
delta_only = length(st_deltas) - down_delta;


%% Plot
figure, hold on

%Cross-corr on Starts
subplot(2,3,1), hold on
plot(Cc_start.x, Cc_start.y)
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7]);
xlabel('time from down start'), ylabel('delta frequency')

%Cross-corr on Ends
subplot(2,3,2), hold on
plot(Cc_end.x, Cc_end.y)
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7]);
xlabel('time from down ends'), %ylabel('frequency of occurence')

%Cross-corr on Ends
subplot(2,3,3), hold on
h(1) = plot(Cc_center.start.x, Cc_center.start.y, 'color', 'k');
h(2) = plot(Cc_center.end.x, Cc_center.end.y, 'color', 'm');
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7]);
legend(h,'start deltas', 'end deltas')
xlabel('time from down centers'), %ylabel('frequency of occurence')

%Mean curves LFP on down starts
subplot(2,3,4), hold on
h(1) = plot(met_start.deep(:,1), met_start.deep(:,2), 'color', 'r');
h(2) = plot(met_start.sup(:,1), met_start.sup(:,2), 'color', 'b');
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7]);
legend(h,'deep','sup')
xlabel('time from down start'), ylabel('mean LFP amplitude')

%Mean curves LFP on down ends
subplot(2,3,5), hold on
h(1) = plot(met_end.deep(:,1), met_end.deep(:,2), 'color', 'r');
h(2) = plot(met_end.sup(:,1), met_end.sup(:,2), 'color', 'b');
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7]);
xlabel('time from down end'), ylabel('mean LFP amplitude')

%Durations
subplot(2,3,6), hold on
sz=25;
scatter(downDur_rec, deltaDur_rec, sz, 'filled'),
xlabel('down durations'), ylabel('delta durations'),


%suplabel
suplabel([Dir.name{p} ' - ' Dir.date{p}],'t');





