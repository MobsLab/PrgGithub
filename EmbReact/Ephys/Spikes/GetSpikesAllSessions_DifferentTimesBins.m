clear all, close all
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/FiguresAllMice
MiceNumber=[490,507,508,509,510,512,514];

% Everything Together
SessionType{1} =  GetRightSessionsUMaze_SB('AllFreezingSessions');
Name{1} = 'AllCondSessions';

WndwSzAll = [0.05,0.1,0.2,0.3,0.5,0.7,1,1.5,2,2.5,3]*1e4
for w = 1 :length(WndwSzAll)
    WndwSz = WndwSzAll(w);
    
    for mm=1:length(MiceNumber)
        mm
        clear Dir
        Dir = GetAllMouseTaskSessions(MiceNumber(mm));
        x1 = strfind(Dir,'UMazeCond');
        ToKeep = find(~cellfun(@isempty,x1));
        Dir = Dir(ToKeep);
        
        MouseByMouse.FR{mm} = [];
        MouseByMouse.LinPos{mm} = [];
        MouseByMouse.RippleDensity{mm} = [];
        
        
        for d=1:length(Dir)
            
            cd(Dir{d})
            disp(Dir{d})
            
            clear TTLInfo Behav SleepyEpoch TotalNoiseEpoch
            load('behavResources_SB.mat')
            load('ExpeInfo.mat')
            
            % Get epochs
            load('StateEpochSB.mat','SleepyEpoch')
            load('StateEpochSB.mat','TotalNoiseEpoch','SleepyEpoch')
            TTLInfo.StimEpoch=intervalSet(Start(TTLInfo.StimEpoch)-0.5*1e4,Stop(TTLInfo.StimEpoch)+2.5*1e4);
            RemovEpoch=or(or(TTLInfo.StimEpoch,TotalNoiseEpoch),SleepyEpoch);
            TotalEpoch = intervalSet(0,max(Range(Behav.Vtsd)));
            if isfield(Behav,'FreezeAccEpoch')
                if not(isempty(Behav.FreezeAccEpoch))
                    Behav.FreezeEpoch = Behav.FreezeAccEpoch;
                end
            end
            CleanFreezeEpoch  = Behav.FreezeEpoch-RemovEpoch;
            
            % Ripple density
            clear RipplesEpochR RipPower
            if exist('ChannelsToAnalyse/dHPC_rip.mat')>0
                load('Ripples.mat')
            else
                RipplesEpochR = [];
            end
            
            % Spikes
            load('SpikeData.mat')
            [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx')
            S = S(numNeurons);
            
            
            % Get periods one by one
            if not(isempty(Start(CleanFreezeEpoch)))
                if sum(Stop(CleanFreezeEpoch)-Start(CleanFreezeEpoch))>WndwSz
                    
                    for s=1:length(Start(CleanFreezeEpoch))
                        dur=(Stop(subset(CleanFreezeEpoch,s))-Start(subset(CleanFreezeEpoch,s)));
                        Str=Start(subset(CleanFreezeEpoch,s));
                        
                        if  dur<(WndwSz*2-0.5*1e4) & dur>(WndwSz-0.5*1e4)
                            LitEpoch = subset(CleanFreezeEpoch,s);
                            
                            MouseByMouse.LinPos{mm} = [MouseByMouse.LinPos{mm},nanmean(Data(Restrict(Behav.LinearDist,LitEpoch)))];
                            
                            % Spikes
                            clear FiringRates
                            for i=1:length(S)
                                FiringRates(i) = length(Restrict(S{i},LitEpoch)) / sum(Stop(LitEpoch,'s')-Start(LitEpoch,'s'));
                            end
                            MouseByMouse.FR{mm} = [MouseByMouse.FR{mm},FiringRates'];
                            if not(isempty(RipplesEpochR)),
                                MouseByMouse.RippleDensity{mm} = [MouseByMouse.RippleDensity{mm},length(Start(and(RipplesEpochR,LitEpoch)))./sum(Stop(LitEpoch,'s')-Start(LitEpoch,'s'))];
                                
                            else
                                MouseByMouse.RippleDensity{mm} = [MouseByMouse.RippleDensity{mm},NaN];
                            end
                            
                            
                        else
                            numbins=round(dur/WndwSz);
                            epdur=dur/numbins;
                            for nn=1:numbins
                                LitEpoch = intervalSet(Str+epdur*(nn-1),Str+epdur*(nn));
                                
                                MouseByMouse.LinPos{mm} = [MouseByMouse.LinPos{mm},nanmean(Data(Restrict(Behav.LinearDist,LitEpoch)))];
                                % Spikes
                                clear FiringRates
                                for i=1:length(S)
                                    FiringRates(i) = length(Restrict(S{i},LitEpoch)) / (Stop(LitEpoch,'s')-Start(LitEpoch,'s'));
                                end
                                MouseByMouse.FR{mm} = [MouseByMouse.FR{mm},FiringRates'];
                                if not(isempty(RipplesEpochR)),
                                    MouseByMouse.RippleDensity{mm} = [MouseByMouse.RippleDensity{mm},length(Start(and(RipplesEpochR,LitEpoch)))./sum(Stop(LitEpoch,'s')-Start(LitEpoch,'s'))];
                                    
                                else
                                    MouseByMouse.RippleDensity{mm} = [MouseByMouse.RippleDensity{mm},NaN];
                                    
                                end
                                
                                
                            end
                            
                        end
                    end
                end
            end
            
        end
    end
    cd('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/UnitAnalysisphD')
    save(['OverallInfoSpikesOnly',num2str(WndwSz/1e4),'.mat'],'MouseByMouse','MiceNumber','-v7.3')
end