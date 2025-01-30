clear all, close all
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/FiguresAllMice

DecodingLimits = [0.4,0.6]; MiceNumber=[490,507,508,509,510,512,514];
% DecodingLimits = [0.2,0.8]; MiceNumber=[490,507,508,509,510,512,514];

Binsize = 0.1*1e4;
SpeedLim = 3;
WndwSz = 0.5*1e4;

for mm=1:length(MiceNumber)
    mm
    clear Dir Spikes numNeurons NoiseEpoch FreezeEpoch Vtsd StimEpoch MovEpoch
    Dir = GetAllMouseTaskSessions(MiceNumber(mm));
    x1 = strfind(Dir,'UMazeCond');
    ToKeep = find(~cellfun(@isempty,x1));
    Dir = Dir(ToKeep);
    
    
    % epochs
    NoiseEpoch = ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','noiseepoch');
    FreezeEpoch = ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','freezeepoch');
    StimEpoch= ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','stimepoch');
    Vtsd = ConcatenateDataFromFolders_SB(Dir,'speed');
    MovAcctsd = ConcatenateDataFromFolders_SB(Dir,'accelero');
    
    MovEpoch = thresholdIntervals(Vtsd,SpeedLim,'Direction','Above');
    MovEpoch = mergeCloseIntervals(MovEpoch,2*1e4) - FreezeEpoch;
    
    CleanMovEpoch = MovEpoch - NoiseEpoch;
    CleanFreezeEpoch = FreezeEpoch - NoiseEpoch;
    
    % spikes
    Spikes = ConcatenateDataFromFolders_SB(Dir,'Spikes');
    cd(Dir{1})
    [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx','remove_MUA',1);
    Spikes = Spikes(numNeurons);
    
    %linear position
    LinPos = ConcatenateDataFromFolders_SB(Dir,'linearposition');
    
    % OBFreq
    OBFreq = ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','noiseepoch');
    
    % Initilaize
    MouseByMouse.FRFz{mm} = [];
    MouseByMouse.LinPosFz{mm} = [];
    % Get freezing periods one by one
    for s=1:length(Start(CleanFreezeEpoch))
        dur=(Stop(subset(CleanFreezeEpoch,s))-Start(subset(CleanFreezeEpoch,s)));
        Str=Start(subset(CleanFreezeEpoch,s));
        
        if  dur<(WndwSz*2-0.5*1e4) & dur>(WndwSz-0.5*1e4)
            LitEpoch = subset(CleanFreezeEpoch,s);
            
            MouseByMouse.LinPosFz{mm} = [MouseByMouse.LinPosFz{mm},nanmean(Data(Restrict(LinPos,LitEpoch)))];
            % Spikes
            clear FiringRates
            for i=1:length(Spikes)
                FiringRates(i) = length(Restrict(Spikes{i},LitEpoch)) / sum(Stop(LitEpoch,'s')-Start(LitEpoch,'s'));
            end
            MouseByMouse.FRFz{mm} = [MouseByMouse.FRFz{mm},FiringRates'];
            
            
        else
            numbins=round(dur/WndwSz);
            epdur=dur/numbins;
            for nn=1:numbins
                LitEpoch = intervalSet(Str+epdur*(nn-1),Str+epdur*(nn));
                
                MouseByMouse.LinPosFz{mm} = [MouseByMouse.LinPosFz{mm},nanmean(Data(Restrict(LinPos,LitEpoch)))];
                % Spikes
                clear FiringRates
                for i=1:length(Spikes)
                    FiringRates(i) = length(Restrict(Spikes{i},LitEpoch)) / (Stop(LitEpoch,'s')-Start(LitEpoch,'s'));
                end
                MouseByMouse.FRFz{mm} = [MouseByMouse.FRFz{mm},FiringRates'];
                
                
            end
            
        end
    end
    
    % Get movement periods one by one
    MouseByMouse.FRMov{mm} = [];
    MouseByMouse.LinPosMov{mm} = [];
    
    for s=1:length(Start(CleanMovEpoch))
        dur=(Stop(subset(CleanMovEpoch,s))-Start(subset(CleanMovEpoch,s)));
        Str=Start(subset(CleanMovEpoch,s));
        
        if  dur<(WndwSz*2-0.5*1e4) & dur>(WndwSz-0.5*1e4)
            LitEpoch = subset(CleanMovEpoch,s);
            
            MouseByMouse.LinPosMov{mm} = [MouseByMouse.LinPosMov{mm},nanmean(Data(Restrict(LinPos,LitEpoch)))];
            % Spikes
            clear FiringRates
            for i=1:length(Spikes)
                FiringRates(i) = length(Restrict(Spikes{i},LitEpoch)) / sum(Stop(LitEpoch,'s')-Start(LitEpoch,'s'));
            end
            MouseByMouse.FRMov{mm} = [MouseByMouse.FRMov{mm},FiringRates'];
            
            
        else
            numbins=round(dur/WndwSz);
            epdur=dur/numbins;
            for nn=1:numbins
                LitEpoch = intervalSet(Str+epdur*(nn-1),Str+epdur*(nn));
                
                MouseByMouse.LinPosMov{mm} = [MouseByMouse.LinPosMov{mm},nanmean(Data(Restrict(LinPos,LitEpoch)))];
                % Spikes
                clear FiringRates
                for i=1:length(Spikes)
                    FiringRates(i) = length(Restrict(Spikes{i},LitEpoch)) / (Stop(LitEpoch,'s')-Start(LitEpoch,'s'));
                end
                MouseByMouse.FRMov{mm} = [MouseByMouse.FRMov{mm},FiringRates'];
                
            end
            
        end
    end
end

cd('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/UnitAnalysisphD')
save(['OverallSpikesFzandMov',num2str(WndwSz/1e4),'.mat'],'MouseByMouse','MiceNumber','-v7.3')
