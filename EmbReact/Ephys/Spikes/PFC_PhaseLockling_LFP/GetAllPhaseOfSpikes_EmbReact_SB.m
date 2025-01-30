clear all
MiceNumber=[490,507,508,509,510,512,514];
SessNames={'EPM','Habituation','TestPre','UMazeCond','TestPost','Extinction','SoundHab','SoundCond','SoundTest',...
    'Habituation_EyeShockTempProt','SleepPreUMaze','SleepPostUMaze','SleepPreSound','SleepPostSound'};
    nbin=30;
    stringToBeFound='InstFreqAndPhase';

for ss=1:length(SessNames)
    Dir = PathForExperimentsEmbReact(SessNames{ss});
    
    
    for dd=1:length(Dir.path)
        if ismember(Dir.ExpeInfo{dd}{1}.nmouse,MiceNumber)
            
            %% Get all the phases of spikes during both kinds of freezing
            for ddd=1:length(Dir.path{dd})
                
                % Go to location and load data
                cd(Dir.path{dd}{ddd})
                disp(Dir.path{dd}{ddd})
                
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
                    save([FilesToUse(file).name(1:end-4),'.mat'],'PhaseSpikes')
                    clear PhaseSpikes
                end
            end
        end
    end
    
end


%% Correction to turn everything into tsds, much more manageable

clear all
MiceNumber=[490,507,508,509,510,512,514];
SessNames={'EPM','Habituation','TestPre','UMazeCond','TestPost','Extinction','SoundHab','SoundCond','SoundTest',...
    'Habituation_EyeShockTempProt','SleepPreUMaze','SleepPostUMaze','SleepPreSound','SleepPostSound'};
nbin=30;
stringToBeFound='NeuronPhaseLocking';

for ss=4:length(SessNames)
    Dir = PathForExperimentsEmbReact(SessNames{ss});
    
    
    for dd=1:length(Dir.path)
        if ismember(Dir.ExpeInfo{dd}{1}.nmouse,MiceNumber)
            
            %% Get all the phases of spikes during both kinds of freezing
            for ddd=1:length(Dir.path{dd})
                
                % Go to location and load data
                cd(Dir.path{dd}{ddd})
                disp(Dir.path{dd}{ddd})
                
                % Get the ID of all instantaneous phase and frequency files
                DirectoryList=dir;
                filesInDir = DirectoryList(~([DirectoryList.isdir]));  % Returns only the files in the directory
                for filenum=1:length(filesInDir)
                    found(filenum) = ~isempty(strfind(filesInDir(filenum).name,stringToBeFound));         % Search for the stringToBeFound in contentOfFile
                end
                FilesToUse = filesInDir(found);
                
                % load the spikes
                load('SpikeData.mat')
                
                for file = 1:length(FilesToUse)
                    clear PhaseSpikes
                    load(FilesToUse(file).name)
                    
                    a=PhaseSpikes.WV{1}.Transf;
                    b=whos('a');
                    if not(strcmp(b.class,'tsd'))
                    for sp=1:length(S)
                        PhaseSpikes.WV{sp}.Transf = tsd(Range(S{sp}),PhaseSpikes.WV{sp}.Transf);
                        PhaseSpikes.PT{sp}.Transf = tsd(Range(S{sp}),PhaseSpikes.PT{sp}.Transf);
                        PhaseSpikes.WV{sp}.Nontransf = tsd(Range(S{sp}),PhaseSpikes.WV{sp}.Nontransf);
                        PhaseSpikes.PT{sp}.Nontransf = tsd(Range(S{sp}),PhaseSpikes.PT{sp}.Nontransf);
                    end
                    save(FilesToUse(file).name,'PhaseSpikes')
                    end
                end
                clear S
            end
        end
    end
end