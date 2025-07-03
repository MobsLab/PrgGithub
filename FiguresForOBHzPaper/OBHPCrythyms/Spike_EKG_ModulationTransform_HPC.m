clear all
Dir=PathForExperimentsERC_Dima('UMazePAG');
MiceNumber = [905,911,994,1161,1162,1168,1186,1230,1239];
MiceInDir = cellfun(@(x) eval(x(6:end)),Dir.name);
MiceToKeep = ismember(MiceInDir,MiceNumber);
AllMiceFolders = Dir.path(MiceToKeep);

nbin=30;
stringToBeFound='InstFreqAndPhase';

for ss = 1:3%length(AllMiceFolders)
    cd(AllMiceFolders{ss}{1})
    
    
    % Get totalepoch
    load('LFPData/LFP1.mat')
    TotalEpoch = intervalSet(0,max(Range(LFP)));
    
    
    % Get the phase from the heart beat
    load('HeartBeatInfo.mat')
    phase = nan(1,length(Range(LFP)));
    fs = median(diff(Range(LFP)));
    t_HB = [0;Range(EKG.HBTimes);max(Range(LFP))];
    for evt = 1:length(t_HB)-1
        t_start = max([1,floor(t_HB(evt)/fs)]);
        t_stop = ceil(t_HB(evt+1)/fs);
        phase(t_start:t_stop) = 2*pi*[0:t_stop - t_start] / (t_stop - t_start);
    end
    phase(isnan(phase)) = 0;
    
    
    load('SpikeData.mat')
    clear PhaseSpikes_temp PhaseSpikes
    for sp=1:length(S)
        
        [PhaseSpikes_temp,~,~,~]=SpikeLFPModulationTransform(S{sp},tsd(Range(LFP),phase'),...
            TotalEpoch,nbin,0,0);
        PhaseSpikes{sp}.Transf = tsd(Range(S{sp}),PhaseSpikes_temp.Transf);
        PhaseSpikes{sp}.Nontransf = tsd(Range(S{sp}),PhaseSpikes_temp.Nontransf);
    end
    save(['HeartBeatPhaseLocing_Spikes.mat'],'PhaseSpikes')
    clear PhaseSpikes
end
