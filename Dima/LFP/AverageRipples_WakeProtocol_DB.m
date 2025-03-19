%% Parameters
sav=0;
dir_out = '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/LFP/';

Dir = PathForExperimentsERC_Dima('UMazePAG');
Dir = RestrictPathForExperiment(Dir, 'nMice', [797 798 828 861 882 905 906 911 912]);

durations = [-60 60]/1000;
%% Get Data
for i = 1:length(Dir.path)
        Rip{i} = load([Dir.path{i}{1} 'Ripples.mat'], 'ripples');
        hipchan{i} = load([Dir.path{i}{1} '/ChannelsToAnalyse/dHPC_rip.mat'], 'channel');
        LFP{i} = load([Dir.path{i}{1} '/LFPData/LFP' num2str(hipchan.channel) '.mat']);
end

%% Plot

f1 = figure('units', 'normalized', 'outerposition', [0 0 1 1])
for j = 1:length(Dir.path)
% Absolute number

%params
samplingRate = round(1/median(diff(Range(LFP{j}.LFP,'s'))));
nBins = floor(samplingRate*diff(durations)/2)*2+1;
%events
events_tmp = Rip{j}.ripples(:,2);
%signals
rg = Range(LFP{j}.LFP)/1e4;
LFP_signal = [rg-rg(1) Data(LFP{j}.LFP)];
% Sync
[r,i] = Sync(LFP_signal,events_tmp,'durations',durations);
T = SyncMap(r,i,'durations',durations,'nbins',nBins,'smooth',0);
% result
%nbin
if size(T,2)>nBins
    nBins=nBins+1;
elseif size(T,2)<nBins
    nBins=nBins-1;
end
%result
try
    M=[((1:nBins)'-ceil(nBins/2))/nBins*diff(durations)' mean(T)' std(T)' stdError(T)'];
catch
    M=[];
    disp('error')
end
subplot(3,3,j)
hold on
plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),T,'k');
plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(T),'r','linewidth',2);
plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(T)+std(T),'r--');
plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(T)-std(T),'r--');
title([Dir.name{j} ' - Ripples (raw data) n=' num2str(size(events_tmp,1))])
xlim(durations)
ylim([-1.5e4 1.5e4])
end

AddScriptName



f2 = figure('units', 'normalized', 'outerposition', [0 0 1 1])
for j = 1:length(Dir.path)
% Absolute number

%params
samplingRate = round(1/median(diff(Range(LFP{j}.LFP,'s'))));
nBins = floor(samplingRate*diff(durations)/2)*2+1;
%events
events_tmp = Rip{j}.ripples(:,2);
%signals
rg = Range(LFP{j}.LFP)/1e4;
LFP_signal = [rg-rg(1) Data(LFP{j}.LFP)];
% Sync
[r,i] = Sync(LFP_signal,events_tmp,'durations',durations);
T = SyncMap(r,i,'durations',durations,'nbins',nBins,'smooth',0);
% result
%nbin
if size(T,2)>nBins
    nBins=nBins+1;
elseif size(T,2)<nBins
    nBins=nBins-1;
end
%result
try
    M=[((1:nBins)'-ceil(nBins/2))/nBins*diff(durations)' mean(T)' std(T)' stdError(T)'];
catch
    M=[];
    disp('error')
end
subplot(3,3,j)
hold on
plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations), zscore(T')', 'k');
plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations), mean(zscore(T')'), 'r', 'linewidth',2);
plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations), mean(zscore(T')')+std(zscore(T')'), 'r--');
plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations), mean(zscore(T')')-std(zscore(T')'), 'r--');
title(['zscore n=' num2str(size(T,1))])
xlim(durations);
% ylim([-1.5e4 1.5e4])
end
%% Save figure
if sav
    saveas(f1, [dir_out 'AveragedRipplesAllMice.fig']);
    saveFigure(f1,'AveragedRipplesAllMice',dir_out);
end

