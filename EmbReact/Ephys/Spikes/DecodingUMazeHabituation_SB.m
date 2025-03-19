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
    x1 = strfind(Dir,'Habituation');
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
    
    %% Zscore over all data
    MeanFr = nanmean([MouseByMouse.FRMov{mm},MouseByMouse.FRFz{mm}]');
    StdFr = nanstd([MouseByMouse.FRMov{mm},MouseByMouse.FRFz{mm}]');
    
    for i=1:length(Spikes)
        MouseByMouse.FRMov{mm}(i,:) = (MouseByMouse.FRMov{mm}(i,:) - MeanFr(i))./StdFr(i);
    end
    
    
    %% Decoding
    % Need to use same number of bins to be fair
    BinType  = [MouseByMouse.FRMov{mm}(1,:)*0]; % movement = 0, freezing = 1
    LinPosMovFz = [MouseByMouse.LinPosMov{mm}];
    
    BinsToUse = floor(min(min([sum(BinType==0 & LinPosMovFz>DecodingLimits(2)),sum(BinType==0 & LinPosMovFz<DecodingLimits(1))]))/2);
    
    
    % Do the decoding - movement
    FRZ = (MouseByMouse.FRMov{mm}')';
    AllDatProj.SkVsSf.TrainMov{mm} = [];
    W.SkVsSf.TrainMov{mm} = [];
    
    if BinsToUse>1
        for perm = 1:500
            
            ShockBins = find(MouseByMouse.LinPosMov{mm}<DecodingLimits(1));
            ShockBinsToUse = ShockBins(randperm(length(ShockBins),BinsToUse*2));
            ShockSideFrTrain = [FRZ(:,ShockBinsToUse(BinsToUse+1:end))];
            ShockSideFrTest = [FRZ(:,ShockBinsToUse(1:BinsToUse))];
            
            SafeBins = find(MouseByMouse.LinPosMov{mm}>DecodingLimits(2));
            SafeBinsToUse = SafeBins(randperm(length(SafeBins),BinsToUse*2));
            SafeSideFrTrain = [FRZ(:,SafeBinsToUse(BinsToUse+1:end))];
            SafeSideFrTest = [FRZ(:,SafeBinsToUse(1:BinsToUse))];
            
            W.SkVsSf.TrainMov{mm}(perm,:) = (nanmean(ShockSideFrTrain')-nanmean(SafeSideFrTrain'));
            W.SkVsSf.TrainMov{mm}(perm,:) = W.SkVsSf.TrainMov{mm}(perm,:)./norm(W.SkVsSf.TrainMov{mm}(perm,:));
            
            Bias.SkVsSf.TrainMov{mm}(perm) = (nanmean(ShockSideFrTrain'*W.SkVsSf.TrainMov{mm}(perm,:)') + nanmean(SafeSideFrTrain'*W.SkVsSf.TrainMov{mm}(perm,:)'))/2;
            clear ShockGuess SafeGuess
            for trial = 1 : BinsToUse
                ShockGuess(trial) = ShockSideFrTest(:,trial)'*W.SkVsSf.TrainMov{mm}(perm,:)'>Bias.SkVsSf.TrainMov{mm}(perm);
                SafeGuess(trial) = SafeSideFrTest(:,trial)'*W.SkVsSf.TrainMov{mm}(perm,:)'<Bias.SkVsSf.TrainMov{mm}(perm);
            end
            
            Score.SkVsSf.TrainMov(mm,perm) = (nanmean(ShockGuess)+nanmean(SafeGuess))/2;
            AllDatProj.SkVsSf.TrainMov{mm}(perm,:)=FRZ'*W.SkVsSf.TrainMov{mm}(perm,:)'-Bias.SkVsSf.TrainMov{mm}(perm);
            
        end
    end
        
end

cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/UnitAnalysisphD/Decoding
save('SpikesDecodingSkvsSafe_UMazeHab.mat','ProjData','AllDatProj','W','Score','-V7.3')

