clear all
Dir=PathForExperimentsERC_Dima('UMazePAG');
MiceNumber = [905,911,994,1161,1162,1168,1186,1230,1239];
MiceInDir = cellfun(@(x) eval(x(6:end)),Dir.name);
MiceToKeep = ismember(MiceInDir,MiceNumber);
AllMiceFolders = Dir.path(MiceToKeep);

nbin=30;
stringToBeFound='InstFreqAndPhase';

for ss=1:length(AllMiceFolders)
    cd(AllMiceFolders{ss}{1})
    
    
    % Get the ID of all instantaneous phase and frequency files
    DirectoryList=dir;
    filesInDir = DirectoryList(~([DirectoryList.isdir]));  % Returns only the files in the directory
    for filenum=1:length(filesInDir)
        found(filenum) = ~isempty(strfind(filesInDir(filenum).name,stringToBeFound));         % Search for the stringToBeFound in contentOfFile
    end
    FilesToUse = filesInDir(found);
    
    % load the spikes
    load('SpikeData.mat')
    
    % Get totalepoch
    load('LFPData/LFP1.mat')
    TotalEpoch = intervalSet(0,max(Range(LFP)));
    clear LFP
    
    for file = 1:length(FilesToUse)
        load(FilesToUse(file).name)
        tps=Range(LocalPhase.PT);
        dat=Data(LocalPhase.PT);
        ToElim=find(isnan(dat));
        dat(ToElim)=[];
        tps(ToElim)=[];
        LocalPhase.PT=tsd(tps,dat);
        
        for sp=1:length(S)
            
            [PhaseSpikes.WV{sp},~,~,~]=SpikeLFPModulationTransform(S{sp},tsd(Range(LocalPhase.WV),mod(Data(LocalPhase.WV)+pi/2,2*pi)),...
                TotalEpoch,nbin,0,0);
            [PhaseSpikes.PT{sp},~,~,~]=SpikeLFPModulationTransform(S{sp},tsd(Range(LocalPhase.PT),mod(Data(LocalPhase.PT)+pi/2,2*pi)),...
                TotalEpoch,nbin,0,0);
            
        end
        save([FilesToUse(file).name(1:end-4),'_SpikeLocking.mat'],'PhaseSpikes')
        clear PhaseSpikes
    end
end


%% Correction to turn everything into tsds, much more manageable
clear all
Dir=PathForExperimentsERC_Dima('UMazePAG');
MiceNumber = [905,911,994,1161,1162,1168,1186,1230,1239];
MiceInDir = cellfun(@(x) eval(x(6:end)),Dir.name);
MiceToKeep = ismember(MiceInDir,MiceNumber);
AllMiceFolders = Dir.path(MiceToKeep);

nbin=30;
stringToBeFound='InstFreqAndPhase_B_SpikeLocking';

for ss=2:length(AllMiceFolders)
    cd(AllMiceFolders{ss}{1})
    
    
    % Get the ID of all instantaneous phase and frequency files
    DirectoryList=dir;
    filesInDir = DirectoryList(~([DirectoryList.isdir]));  % Returns only the files in the directory
    for filenum=1:length(filesInDir)
        found(filenum) = ~isempty(strfind(filesInDir(filenum).name,stringToBeFound));         % Search for the stringToBeFound in contentOfFile
    end
    FilesToUse = filesInDir(found);
    
    % load the spikes
    load('SpikeData.mat')
    
    % Get totalepoch
    load('LFPData/LFP1.mat')
    TotalEpoch = intervalSet(0,max(Range(LFP)));
    clear LFP
    
    for file = 1%:length(FilesToUse)
        
        load('InstFreqAndPhase_B_SpikeLocking.mat')
        for sp=1:length(S)
            PhaseSpikes.WV{sp}.Transf = tsd(Range(S{sp}),PhaseSpikes.WV{sp}.Transf);
            PhaseSpikes.PT{sp}.Transf = tsd(Range(S{sp}),PhaseSpikes.PT{sp}.Transf);
            PhaseSpikes.WV{sp}.Nontransf = tsd(Range(S{sp}),PhaseSpikes.WV{sp}.Nontransf);
            PhaseSpikes.PT{sp}.Nontransf = tsd(Range(S{sp}),PhaseSpikes.PT{sp}.Nontransf);
        end
        save('InstFreqAndPhase_B_SpikeLocking','PhaseSpikes')
        
        clear PhaseSpikes
    end
end

