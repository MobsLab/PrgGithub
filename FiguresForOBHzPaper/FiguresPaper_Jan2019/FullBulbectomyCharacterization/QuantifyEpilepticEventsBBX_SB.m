
clear all
Dir = PathForExperimentFEAR('Sleep-OBX');
LongSession = [2,4,6,13,16];
Thresh = 1.2e4;
for dd = 1:length(Dir.path)
    
    cd(Dir.path{dd})
    disp(Dir.path{dd})
    % HPC
    if exist('ChannelsToAnalyse/dHPC_deep.mat','file')==2
        load('ChannelsToAnalyse/dHPC_deep.mat')
        channel_hpc=channel;
    elseif exist('ChannelsToAnalyse/dHPC_rip.mat','file')==2
        load('ChannelsToAnalyse/dHPC_rip.mat')
        channel_hpc=channel;
    elseif exist('ChannelsToAnalyse/dHPC_sup.mat','file')==2
        load('ChannelsToAnalyse/dHPC_sup.mat')
        channel_hpc=channel;
    else
        error('No HPC channel, cannot do sleep scoring');
    end
    load(['LFPData/LFP' num2str(channel_hpc) '.mat'])
    
    %     plot(Range(LFP),Data(LFP))
    %     [x,~] = ginput(2);
    %     NoSpikeEpoch = intervalSet(x(1),x(2));
    %
    %     Thresh = 5*std(Data(Restrict(LFP,NoSpikeEpoch)));
    EpEpoch = thresholdIntervals(LFP,Thresh,'Direction','Above');
    
    load('SleepScoring_Accelero.mat','SWSEpoch','REMEpoch','Wake','TotalNoiseEpoch')
    Wake = or(Wake,TotalNoiseEpoch);
    
    Events.SWS(dd) = length(Start(and(EpEpoch,SWSEpoch)))./sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'));
    if length(Start(and(EpEpoch,SWSEpoch)))>1
        [M,T] = PlotRipRaw(LFP,Start(and(EpEpoch,SWSEpoch),'s'),500,0,0);
        EventProfile.SWS(dd,:) = M(:,2)';
    else
        EventProfile.SWS(dd,:) = NaN(1,1251);
    end
    
    Events.REM(dd) = length(Start(and(EpEpoch,REMEpoch)))./sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'));
    if length(Start(and(EpEpoch,REMEpoch)))>1
        [M,T] = PlotRipRaw(LFP,Start(and(EpEpoch,REMEpoch),'s'),500,0,0);
        EventProfile.REM(dd,:) = M(:,2)';
    else
        EventProfile.REM(dd,:) = NaN(1,1251);
    end
    
    Events.Wake(dd) = length(Start(and(EpEpoch,Wake)))./sum(Stop(Wake,'s')-Start(Wake,'s'));
    if length(Start(and(EpEpoch,Wake)))>1
        [M,T] = PlotRipRaw(LFP,Start(and(EpEpoch,Wake),'s'),500,0,0);
        EventProfile.Wake(dd,:) = M(:,2)';
    else
        EventProfile.Wake(dd,:) = NaN(1,1251);
    end
    
    
    MouseNum(dd) = eval(Dir.name{dd}(end-2:end));
end

AllMice = unique(MouseNum);
for i = 1:length(AllMice)
MiceAverages.SWS(i,:) = nanmean(EventProfile.SWS(find(MouseNum==AllMice(i)),:));
MiceAverages.Wake(i,:) = nanmean(EventProfile.Wake(MouseNum==AllMice(i),:));
MiceAverages.REM(i,:) = nanmean(EventProfile.REM(MouseNum==AllMice(i),:));

MiceAveragesEventFreq.SWS(i,:) = nanmean(Events.SWS(find(MouseNum==AllMice(i))));
MiceAveragesEventFreq.Wake(i,:) = nanmean(Events.Wake(MouseNum==AllMice(i)));
MiceAveragesEventFreq.REM(i,:) = nanmean(Events.REM(MouseNum==AllMice(i)));

end


figure
Cols = {[1 0.4 0.4],[1 0.4 0.4],[1 0.4 0.4],[0.8 0.6 0.6],[0.8 0.6 0.6],[0.8 0.6 0.6]};
A = {MiceAveragesEventFreq.SWS([1:2]),MiceAveragesEventFreq.REM([1:2]),MiceAveragesEventFreq.Wake([1:2]),...
    MiceAveragesEventFreq.SWS([3:end]),MiceAveragesEventFreq.REM([3:end]),MiceAveragesEventFreq.Wake([3:end])};
X = [1,2,3,5,6,7];
Legends = {'SWS','REM','Wake','SWS','REM','Wake'};
MakeSpreadAndBoxPlot_SB(A,Cols,X,Legends)
ylabel('Event frequency (Hz)')

figure
plot(M(:,1),MiceAverages.SWS(3:end,:)','linewidth',3)
xlim([-0.25 0.25])
set(gca,'YTick',[],'YColor','none','FontSize',15,'linewidth',1.5)
box off
xlabel('time (s)')
