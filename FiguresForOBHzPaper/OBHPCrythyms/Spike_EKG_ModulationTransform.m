clear all
MiceNumber=[507,508,509,510];
SessNames={'EPM','Habituation','TestPre','UMazeCond','TestPost','Extinction','SoundHab','SoundCond','SoundTest',...
    'Habituation_EyeShockTempProt','SleepPreUMaze','SleepPostUMaze','SleepPreSound','SleepPostSound'};
nbin=30;

for ss=1:length(SessNames)
    Dir = PathForExperimentsEmbReact(SessNames{ss});
    
    
    for dd=1:length(Dir.path)
        if ismember(Dir.ExpeInfo{dd}{1}.nmouse,MiceNumber)
            
            %% Get all the phases of spikes during both kinds of freezing
            for ddd=1:length(Dir.path{dd})
                
                % Go to location and load data
                cd(Dir.path{dd}{ddd})
                disp(Dir.path{dd}{ddd})
                
                
                % load the spikes
                load('SpikeData.mat')
                                
                % Get totalepoch and time bins
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
        end
    end
end
