clear all, close all
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/FiguresAllMice
MiceNumber=[490,507,508,509,510,512,514];

% Everything Together
SessionType{1} =  GetRightSessionsUMaze_SB('AllFreezingSessions');
Name{1} = 'AllCondSessions';

WndwSz = 0.5*1e4;
Recalc = 1;
SessTypes = {'Habituation','TestPre','UMazeCond','TestPost','Extinction'};

if Recalc
    for mm=1:length(MiceNumber)
        mm
        clear DirAll
        DirAll = GetAllMouseTaskSessions(MiceNumber(mm));
        
        for sstyp = 1:length(SessTypes)
            
            x1 = strfind(DirAll,SessTypes{sstyp});
            ToKeep = find(~cellfun(@isempty,x1));
            Dir = DirAll(ToKeep);
            
            MouseByMouse.(SessTypes{sstyp}).FR{mm} = [];
            MouseByMouse.(SessTypes{sstyp}).Speed{mm} = [];
            MouseByMouse.(SessTypes{sstyp}).IsFz{mm} = [];
            MouseByMouse.(SessTypes{sstyp}).LinPos{mm} = [];
            MouseByMouse.(SessTypes{sstyp}).OBFreq{mm} = [];
            MouseByMouse.(SessTypes{sstyp}).HPCPower{mm} = [];
            MouseByMouse.(SessTypes{sstyp}).RippleDensity{mm} = [];
            MouseByMouse.(SessTypes{sstyp}).HR{mm} = [];
            MouseByMouse.(SessTypes{sstyp}).HRVar{mm} = [];
            MouseByMouse.(SessTypes{sstyp}).RipplePower{mm}= [];
            
            
            for d=1:length(Dir)
                
                cd(Dir{d})
                disp(Dir{d})
                
                clear TTLInfo Behav SleepyEpoch TotalNoiseEpoch
                load('behavResources_SB.mat')
                load('ExpeInfo.mat')
                
                % Get epochs
                load('StateEpochSB.mat','TotalNoiseEpoch','SleepyEpoch','Epoch')
                TTLInfo.StimEpoch=intervalSet(Start(TTLInfo.StimEpoch)-0.5*1e4,Stop(TTLInfo.StimEpoch)+2.5*1e4);
                RemovEpoch=or(or(TTLInfo.StimEpoch,TotalNoiseEpoch),SleepyEpoch);
                TotalEpoch = intervalSet(0,max(Range(Behav.Vtsd)));
                if isfield(Behav,'FreezeAccEpoch')
                    if not(isempty(Behav.FreezeAccEpoch))
                        Behav.FreezeEpoch = Behav.FreezeAccEpoch;
                    end
                end
                CleanEpoch  = Epoch-RemovEpoch;
                
                % Get all the data types
                % OB frequency
                clear LocalFreq
                load('InstFreqAndPhase_B.mat','LocalFreq')
                % smooth the estimates
                WVBinsize = length(Range(LocalFreq.WV))./length(Range(Behav.LinearDist));
                LocalFreq.WV = tsd(Range(LocalFreq.WV),movmedian(Data(LocalFreq.WV),ceil(WVBinsize)*2));
                LocalFreq.PT = tsd(Range(LocalFreq.PT),movmedian(Data(LocalFreq.PT),4));
                
                % Ripple density
                clear RipplesEpochR RipPower
                if exist('ChannelsToAnalyse/dHPC_rip.mat')>0
                    load('Ripples.mat')
                    load('H_VHigh_Spectrum.mat')
                    RipPower = nanmean(Spectro{1}(:,find(Spectro{3}>150,1,'first'):find(Spectro{3}>220,1,'first'))')./nanmean(Spectro{1}(:,find(Spectro{3}>0,1,'first'):find(Spectro{3}>150,1,'first'))');
                    RipPower=tsd(Spectro{2}*1e4,RipPower');
                    
                else
                    RipplesEpochR = [];
                end
                
                % Heart rate and heart rate variability in and out of freezing
                clear EKG HRVar
                if exist('HeartBeatInfo.mat')>0
                    load('HeartBeatInfo.mat')
                    HRVar = tsd(Range(EKG.HBRate),movstd(Data(EKG.HBRate),5));
                end
                
                % Spikes
                load('SpikeData.mat')
                [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx')
                S = S(numNeurons);
                
                
                % HPC spec
                clear Sp
                if exist('ChannelsToAnalyse/dHPC_deep.mat')>0
                    [Sp,t,f]=LoadSpectrumML('dHPC_deep');
                elseif exist('ChannelsToAnalyse/dHPC_sup.mat')>0
                    [Sp,t,f]=LoadSpectrumML('dHPC_sup');
                elseif  exist('ChannelsToAnalyse/dHPC_rip.mat')>0
                    [Sp,t,f]=LoadSpectrumML('dHPC_rip');
                end
                Sptsd=tsd(t*1e4,Sp);
                PowerThetaTemp = nanmean(Sp(:,find(f<5.5,1,'last'):find(f<7.5,1,'last'))')';
                PowerThetaTemp = interp1(Range(Sptsd),PowerThetaTemp,Range(Behav.Vtsd));
                ThetaPowerSlow = PowerThetaTemp;
                
                PowerThetaTemp = nanmean(Sp(:,find(f<10,1,'last'):find(f<15,1,'last'))')';
                PowerThetaTemp = interp1(Range(Sptsd),PowerThetaTemp,Range(Behav.Vtsd));
                ThetaPowerFast = PowerThetaTemp;
                
                PowerThetaSlow = tsd(Range(Behav.Vtsd),ThetaPowerSlow./ThetaPowerFast);
                
                
                % Get periods one by one
                
                for s=1:length(Start(CleanEpoch))
                    dur=(Stop(subset(CleanEpoch,s))-Start(subset(CleanEpoch,s)));
                    Str=Start(subset(CleanEpoch,s));
                    
                    if  dur<(WndwSz*2-0.5*1e4) & dur>(WndwSz-0.5*1e4)
                        LitEpoch = subset(CleanEpoch,s);
                        
                        MouseByMouse.(SessTypes{sstyp}).IsFz{mm} = [MouseByMouse.(SessTypes{sstyp}).IsFz{mm},length(Data(Restrict(Behav.Vtsd,and(LitEpoch,Behav.FreezeEpoch))))./length(Data(Restrict(Behav.Vtsd,LitEpoch)))];
                        MouseByMouse.(SessTypes{sstyp}).Speed{mm} = [MouseByMouse.(SessTypes{sstyp}).Speed{mm},nanmean(Data(Restrict(Behav.Vtsd,LitEpoch)))];
                        MouseByMouse.(SessTypes{sstyp}).LinPos{mm} = [MouseByMouse.(SessTypes{sstyp}).LinPos{mm},nanmean(Data(Restrict(Behav.LinearDist,LitEpoch)))];
                        MouseByMouse.(SessTypes{sstyp}).OBFreq{mm} = [MouseByMouse.(SessTypes{sstyp}).OBFreq{mm},(nanmedian(Data(Restrict(LocalFreq.WV,LitEpoch)))+nanmedian(Data(Restrict(LocalFreq.PT,LitEpoch))))/2];
                        MouseByMouse.(SessTypes{sstyp}).HPCPower{mm} = [MouseByMouse.(SessTypes{sstyp}).HPCPower{mm},nanmean(Data(Restrict(PowerThetaSlow,LitEpoch)))];
                        if not(isempty(RipplesEpochR)),
                            MouseByMouse.(SessTypes{sstyp}).RippleDensity{mm} = [MouseByMouse.(SessTypes{sstyp}).RippleDensity{mm},length(Start(and(RipplesEpochR,LitEpoch)))./sum(Stop(LitEpoch,'s')-Start(LitEpoch,'s'))];
                            MouseByMouse.(SessTypes{sstyp}).RipplePower{mm} = [MouseByMouse.(SessTypes{sstyp}).RipplePower{mm},nanmean(Data(Restrict(RipPower,LitEpoch)))];
                            
                        else
                            MouseByMouse.(SessTypes{sstyp}).RippleDensity{mm} = [MouseByMouse.(SessTypes{sstyp}).RippleDensity{mm},NaN];
                            MouseByMouse.(SessTypes{sstyp}).RipplePower{mm} = [MouseByMouse.(SessTypes{sstyp}).RipplePower{mm},NaN];
                        end
                        
                        if exist('HeartBeatInfo.mat')>0
                            
                            MouseByMouse.(SessTypes{sstyp}).HR{mm} = [MouseByMouse.(SessTypes{sstyp}).HR{mm},nanmean(Data(Restrict(EKG.HBRate,LitEpoch)))];
                            MouseByMouse.(SessTypes{sstyp}).HRVar{mm} = [MouseByMouse.(SessTypes{sstyp}).HRVar{mm},nanmean(Data(Restrict(HRVar,LitEpoch)))];
                        else
                            MouseByMouse.(SessTypes{sstyp}).HR{mm} = [MouseByMouse.(SessTypes{sstyp}).HR{mm},NaN];
                            MouseByMouse.(SessTypes{sstyp}).HRVar{mm} = [MouseByMouse.(SessTypes{sstyp}).HRVar{mm},NaN];
                        end
                        
                        % Spikes
                        clear FiringRates
                        for i=1:length(S)
                            FiringRates(i) = length(Restrict(S{i},LitEpoch)) / sum(Stop(LitEpoch,'s')-Start(LitEpoch,'s'));
                        end
                        MouseByMouse.(SessTypes{sstyp}).FR{mm} = [MouseByMouse.(SessTypes{sstyp}).FR{mm},FiringRates'];
                        
                        
                    else
                        numbins=round(dur/WndwSz);
                        epdur=dur/numbins;
                        for nn=1:numbins
                            LitEpoch = intervalSet(Str+epdur*(nn-1),Str+epdur*(nn));
                            
                            MouseByMouse.(SessTypes{sstyp}).IsFz{mm} = [MouseByMouse.(SessTypes{sstyp}).IsFz{mm},length(Data(Restrict(Behav.Vtsd,and(LitEpoch,Behav.FreezeEpoch))))./length(Data(Restrict(Behav.Vtsd,LitEpoch)))];
                            MouseByMouse.(SessTypes{sstyp}).Speed{mm} = [MouseByMouse.(SessTypes{sstyp}).Speed{mm},nanmean(Data(Restrict(Behav.Vtsd,LitEpoch)))];
                            MouseByMouse.(SessTypes{sstyp}).LinPos{mm} = [MouseByMouse.(SessTypes{sstyp}).LinPos{mm},nanmean(Data(Restrict(Behav.LinearDist,LitEpoch)))];
                            MouseByMouse.(SessTypes{sstyp}).OBFreq{mm} = [MouseByMouse.(SessTypes{sstyp}).OBFreq{mm},(nanmedian(Data(Restrict(LocalFreq.WV,LitEpoch)))+nanmedian(Data(Restrict(LocalFreq.PT,LitEpoch))))/2];
                            MouseByMouse.(SessTypes{sstyp}).HPCPower{mm} = [MouseByMouse.(SessTypes{sstyp}).HPCPower{mm},nanmean(Data(Restrict(PowerThetaSlow,LitEpoch)))];
                            if not(isempty(RipplesEpochR)),
                                MouseByMouse.(SessTypes{sstyp}).RippleDensity{mm} = [MouseByMouse.(SessTypes{sstyp}).RippleDensity{mm},length(Start(and(RipplesEpochR,LitEpoch)))./sum(Stop(LitEpoch,'s')-Start(LitEpoch,'s'))];
                                MouseByMouse.(SessTypes{sstyp}).RipplePower{mm} = [MouseByMouse.(SessTypes{sstyp}).RipplePower{mm},nanmean(Data(Restrict(RipPower,LitEpoch)))];
                                
                            else
                                MouseByMouse.(SessTypes{sstyp}).RippleDensity{mm} = [MouseByMouse.(SessTypes{sstyp}).RippleDensity{mm},NaN];
                                MouseByMouse.(SessTypes{sstyp}).RipplePower{mm} = [MouseByMouse.(SessTypes{sstyp}).RipplePower{mm},NaN];
                                
                            end
                            
                            if exist('HeartBeatInfo.mat')>0
                                
                                MouseByMouse.(SessTypes{sstyp}).HR{mm} = [MouseByMouse.(SessTypes{sstyp}).HR{mm},nanmean(Data(Restrict(EKG.HBRate,LitEpoch)))];
                                MouseByMouse.(SessTypes{sstyp}).HRVar{mm} = [MouseByMouse.(SessTypes{sstyp}).HRVar{mm},nanmean(Data(Restrict(HRVar,LitEpoch)))];
                            else
                                MouseByMouse.(SessTypes{sstyp}).HR{mm} = [MouseByMouse.(SessTypes{sstyp}).HR{mm},NaN];
                                MouseByMouse.(SessTypes{sstyp}).HRVar{mm} = [MouseByMouse.(SessTypes{sstyp}).HRVar{mm},NaN];
                                
                            end
                            
                            % Spikes
                            clear FiringRates
                            for i=1:length(S)
                                FiringRates(i) = length(Restrict(S{i},LitEpoch)) / (Stop(LitEpoch,'s')-Start(LitEpoch,'s'));
                            end
                            MouseByMouse.(SessTypes{sstyp}).FR{mm} = [MouseByMouse.(SessTypes{sstyp}).FR{mm},FiringRates'];
                            
                            
                        end
                        
                    end
                end
            end
        end
        
    end
    cd('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/UnitAnalysisphD')
    save(['OverallInfoPhysioSpikesAllSess',num2str(WndwSz/1e4),'.mat'],'MouseByMouse','MiceNumber','-v7.3')
else
    cd('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/UnitAnalysisphD')
    load(['OverallInfoPhysioSpikesAllSess',num2str(WndwSz/1e4),'.mat'])
end
