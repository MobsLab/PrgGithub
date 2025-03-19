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
        MouseByMouse.FRFz{mm}(i,:) = (MouseByMouse.FRFz{mm}(i,:) - MeanFr(i))./StdFr(i);
    end
    
    %% Decoding
    
    % Need to use same number of bins to be fair
    BinType  = [MouseByMouse.FRMov{mm}(1,:)*0,MouseByMouse.FRFz{mm}(1,:)*0+1]; % movement = 0, freezing = 1
    LinPosMovFz = [MouseByMouse.LinPosMov{mm},MouseByMouse.LinPosFz{mm}];
    
    BinsToUse = floor(min(min([sum(BinType==0 & LinPosMovFz>DecodingLimits(2)),sum(BinType==1 & LinPosMovFz>DecodingLimits(2)),...
        sum(BinType==0 & LinPosMovFz<DecodingLimits(1)),sum(BinType==1 & LinPosMovFz<DecodingLimits(1))]))/2);
    
    % Do the decoding - freezing
    FRZ = (MouseByMouse.FRFz{mm}')';
    AllDatProj.SkVsSf.TrainFz{mm} = [];
    W.SkVsSf.TrainFz{mm} = [];
    
    if BinsToUse>1
        for perm = 1:500
            
            ShockBins = find(MouseByMouse.LinPosFz{mm}<DecodingLimits(1));
            ShockBinsToUse = ShockBins(randperm(length(ShockBins),BinsToUse*2));
            ShockSideFrTrain = [FRZ(:,ShockBinsToUse(BinsToUse+1:end))];
            ShockSideFrTest = [FRZ(:,ShockBinsToUse(1:BinsToUse))];
            
            SafeBins = find(MouseByMouse.LinPosFz{mm}>DecodingLimits(2));
            SafeBinsToUse = SafeBins(randperm(length(SafeBins),BinsToUse*2));
            SafeSideFrTrain = [FRZ(:,SafeBinsToUse(BinsToUse+1:end))];
            SafeSideFrTest = [FRZ(:,SafeBinsToUse(1:BinsToUse))];
            
            
            W.SkVsSf.TrainFz{mm}(perm,:) = (nanmean(ShockSideFrTrain')-nanmean(SafeSideFrTrain'));
            W.SkVsSf.TrainFz{mm}(perm,:) = W.SkVsSf.TrainFz{mm}(perm,:)./norm(W.SkVsSf.TrainFz{mm}(perm,:));
            
            Bias.SkVsSf.TrainFz{mm}(perm) = (nanmean(ShockSideFrTrain'*W.SkVsSf.TrainFz{mm}(perm,:)') + nanmean(SafeSideFrTrain'*W.SkVsSf.TrainFz{mm}(perm,:)'))/2;
            clear ShockGuess SafeGuess
            for trial = 1 : BinsToUse
                ShockGuess(trial) = ShockSideFrTest(:,trial)'*W.SkVsSf.TrainFz{mm}(perm,:)'>Bias.SkVsSf.TrainFz{mm}(perm);
                SafeGuess(trial) = SafeSideFrTest(:,trial)'*W.SkVsSf.TrainFz{mm}(perm,:)'<Bias.SkVsSf.TrainFz{mm}(perm);
            end
            
            Score.SkVsSf.TrainFz(mm,perm) = (nanmean(ShockGuess)+nanmean(SafeGuess))/2;
            AllDatProj.SkVsSf.TrainFz{mm}(perm,:)=FRZ'*W.SkVsSf.TrainFz{mm}(perm,:)'-Bias.SkVsSf.TrainFz{mm}(perm);
            
        end
    end
    
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
    
    % Do the decoding - alltogether
    AllFr  = [MouseByMouse.FRMov{mm},MouseByMouse.FRFz{mm}];
    LinPosMovFz = [MouseByMouse.LinPosMov{mm},MouseByMouse.LinPosFz{mm}];
    BinType  = [MouseByMouse.FRMov{mm}(1,:)*0,MouseByMouse.FRFz{mm}(1,:)*0+1]; % movement = 0, freezing = 1
    
    FRZ = (AllFr')';
    AllDatProj.SkVsSf.TrainMovFz{mm} = [];
    W.SkVsSf.TrainMovFz{mm} = [];
    
    if BinsToUse>1
        for perm = 1:500
            
            
            ShockBinsFz = find(BinType==1 & LinPosMovFz<DecodingLimits(1));
            ShockBinsMov = find(BinType==0 & LinPosMovFz<DecodingLimits(1));
            ShockBinsFz = ShockBinsFz(randperm(length(ShockBinsFz),BinsToUse));
            ShockBinsMov = ShockBinsMov(randperm(length(ShockBinsMov),BinsToUse));
            ShockBins = [ShockBinsMov,ShockBinsFz];
            ShockBinsToUse = ShockBins(randperm(length(ShockBins),BinsToUse*2));
            ShockSideFrTrain = [FRZ(:,ShockBinsToUse(BinsToUse+1:end))];
            ShockSideFrTest = [FRZ(:,ShockBinsToUse(1:BinsToUse))];
            
            
            SafeBinsFz = find(BinType==1 & LinPosMovFz>DecodingLimits(2));
            SafeBinsMov = find(BinType==0 & LinPosMovFz>DecodingLimits(2));
            SafeBinsFz = SafeBinsFz(randperm(length(SafeBinsFz),BinsToUse));
            SafeBinsMov = SafeBinsMov(randperm(length(SafeBinsMov),BinsToUse));
            SafeBins = [SafeBinsMov,SafeBinsFz];
            SafeBinsToUse = SafeBins(randperm(length(SafeBins),BinsToUse*2));
            SafeSideFrTrain = [FRZ(:,SafeBinsToUse(BinsToUse+1:end))];
            SafeSideFrTest = [FRZ(:,SafeBinsToUse(1:BinsToUse))];
            
            W.SkVsSf.TrainMovFz{mm}(perm,:) = (nanmean(ShockSideFrTrain')-nanmean(SafeSideFrTrain'));
            W.SkVsSf.TrainMovFz{mm}(perm,:) = W.SkVsSf.TrainMovFz{mm}(perm,:)./norm(W.SkVsSf.TrainMovFz{mm}(perm,:));
            
            Bias.SkVsSf.TrainMovFz{mm}(perm) = (nanmean(ShockSideFrTrain'*W.SkVsSf.TrainMovFz{mm}(perm,:)') + nanmean(SafeSideFrTrain'*W.SkVsSf.TrainMovFz{mm}(perm,:)'))/2;
            clear ShockGuess SafeGuess
            for trial = 1 : BinsToUse
                ShockGuess(trial) = ShockSideFrTest(:,trial)'*W.SkVsSf.TrainMovFz{mm}(perm,:)'>Bias.SkVsSf.TrainMovFz{mm}(perm);
                SafeGuess(trial) = SafeSideFrTest(:,trial)'*W.SkVsSf.TrainMovFz{mm}(perm,:)'<Bias.SkVsSf.TrainMovFz{mm}(perm);
            end
            
            Score.SkVsSf.TrainMovFz(mm,perm) = (nanmean(ShockGuess)+nanmean(SafeGuess))/2;
            AllDatProj.SkVsSf.TrainMovFz{mm}(perm,:)=FRZ'*W.SkVsSf.TrainMovFz{mm}(perm,:)'-Bias.SkVsSf.TrainMovFz{mm}(perm);
            
        end
    end
    
    % Do the decoding - freezing vs  movement
    AllFr  = [MouseByMouse.FRMov{mm},MouseByMouse.FRFz{mm}];
    LinPosMovFz = [MouseByMouse.LinPosMov{mm},MouseByMouse.LinPosFz{mm}];
    BinType  = [MouseByMouse.FRMov{mm}(1,:)*0,MouseByMouse.FRFz{mm}(1,:)*0+1]; % movement = 0, freezing = 1
    
    FRZ = (AllFr')';
    AllDatProj.MovVsFz.TrainSkSf{mm} = [];
    W.MovVsFz.TrainSkSf{mm} = [];
    
    if BinsToUse>1
        for perm = 1:500
            
            % need to randomize bins coming from shock and safe side to
            % avoid biases
            MovBinsSk = find(BinType==0 & LinPosMovFz<DecodingLimits(1));
            MovBinsSf = find(BinType==0 & LinPosMovFz>DecodingLimits(2));
            MovBinsSk = MovBinsSk(randperm(length(MovBinsSk),BinsToUse));
            MovBinsSf = MovBinsSf(randperm(length(MovBinsSf),BinsToUse));
            MovBins = [MovBinsSf,MovBinsSk];
            MovBinsToUse = MovBins(randperm(length(MovBins),BinsToUse*2));
            MovFrTrain = [FRZ(:,MovBinsToUse(BinsToUse+1:end))];
            MovFrTest = [FRZ(:,MovBinsToUse(1:BinsToUse))];
            
            FzBinsSk = find(BinType==1 & LinPosMovFz<DecodingLimits(1));
            FzBinsSf = find(BinType==1 & LinPosMovFz>DecodingLimits(2));
            FzBinsSk = FzBinsSk(randperm(length(FzBinsSk),BinsToUse));
            FzBinsSf = FzBinsSf(randperm(length(FzBinsSf),BinsToUse));
            FzBins = [FzBinsSk,FzBinsSf];
            FzBinsToUse = FzBins(randperm(length(FzBins),BinsToUse*2));
            FzFrTrain = [FRZ(:,FzBinsToUse(BinsToUse+1:end))];
            FzFrTest = [FRZ(:,FzBinsToUse(1:BinsToUse))];
            
            W.MovVsFz.TrainSkSf{mm}(perm,:) = (nanmean(MovFrTrain')-nanmean(FzFrTrain'));
            W.MovVsFz.TrainSkSf{mm}(perm,:) = W.MovVsFz.TrainSkSf{mm}(perm,:)./norm(W.MovVsFz.TrainSkSf{mm}(perm,:));
            
            Bias.MovVsFz.TrainSkSf{mm}(perm) = (nanmean(MovFrTrain'*W.MovVsFz.TrainSkSf{mm}(perm,:)') + nanmean(FzFrTrain'*W.MovVsFz.TrainSkSf{mm}(perm,:)'))/2;
            clear MovGuess FzGuess
            for trial = 1 : BinsToUse
                MovGuess(trial) = MovFrTest(:,trial)'*W.MovVsFz.TrainSkSf{mm}(perm,:)'>Bias.MovVsFz.TrainSkSf{mm}(perm);
                FzGuess(trial) = FzFrTest(:,trial)'*W.MovVsFz.TrainSkSf{mm}(perm,:)'<Bias.MovVsFz.TrainSkSf{mm}(perm);
            end
            
            Score.MovVsFz.TrainSkSf(mm,perm) = (nanmean(MovGuess)+nanmean(FzGuess))/2;
            AllDatProj.MovVsFz.TrainSkSf{mm}(perm,:)=FRZ'*W.MovVsFz.TrainSkSf{mm}(perm,:)'-Bias.MovVsFz.TrainSkSf{mm}(perm);
        end
    end
    
    % Do the decoding - freezing vs  movement shock side
    AllFr  = [MouseByMouse.FRMov{mm},MouseByMouse.FRFz{mm}];
    LinPosMovFzShock = [MouseByMouse.LinPosMov{mm},MouseByMouse.LinPosFz{mm}];
    BinType  = [MouseByMouse.FRMov{mm}(1,:)*0,MouseByMouse.FRFz{mm}(1,:)*0+1]; % movement = 0, freezing = 1
    
    FRZ = (AllFr')';
    AllDatProj.MovVsFz.TrainSk{mm} = [];
    W.MovVsFz.TrainSk{mm} = [];
    
    if BinsToUse>1
        for perm = 1:500
            
            MovBins = find(BinType==0 & LinPosMovFzShock<DecodingLimits(1));
            MovBinsToUse = MovBins(randperm(length(MovBins),BinsToUse*2));
            MovFrTrain = [FRZ(:,MovBinsToUse(BinsToUse+1:end))];
            MovFrTest = [FRZ(:,MovBinsToUse(1:BinsToUse))];
            
            FzBins = find(BinType==1 & LinPosMovFzShock<DecodingLimits(1));
            FzBinsToUse = FzBins(randperm(length(FzBins),BinsToUse*2));
            FzFrTrain = [FRZ(:,FzBinsToUse(BinsToUse+1:end))];
            FzFrTest = [FRZ(:,FzBinsToUse(1:BinsToUse))];
            
            W.MovVsFz.TrainSk{mm}(perm,:) = (nanmean(MovFrTrain')-nanmean(FzFrTrain'));
            W.MovVsFz.TrainSk{mm}(perm,:) = W.MovVsFz.TrainSk{mm}(perm,:)./norm(W.MovVsFz.TrainSk{mm}(perm,:));
            
            Bias.MovVsFz.TrainSk{mm}(perm) = (nanmean(MovFrTrain'*W.MovVsFz.TrainSk{mm}(perm,:)') + nanmean(FzFrTrain'*W.MovVsFz.TrainSk{mm}(perm,:)'))/2;
            clear MovGuess FzGuess
            for trial = 1 : BinsToUse
                MovGuess(trial) = MovFrTest(:,trial)'*W.MovVsFz.TrainSk{mm}(perm,:)'>Bias.MovVsFz.TrainSk{mm}(perm);
                FzGuess(trial) = FzFrTest(:,trial)'*W.MovVsFz.TrainSk{mm}(perm,:)'<Bias.MovVsFz.TrainSk{mm}(perm);
            end
            
            Score.MovVsFz.TrainSk(mm,perm) = (nanmean(MovGuess)+nanmean(FzGuess))/2;
            AllDatProj.MovVsFz.TrainSk{mm}(perm,:)=FRZ'*W.MovVsFz.TrainSk{mm}(perm,:)'-Bias.MovVsFz.TrainSk{mm}(perm);
            
        end
    end
    
    % Do the decoding - freezing vs  movement Safe side
    AllFr  = [MouseByMouse.FRMov{mm},MouseByMouse.FRFz{mm}];
    LinPosMovFzSafe = [MouseByMouse.LinPosMov{mm},MouseByMouse.LinPosFz{mm}];
    BinType  = [MouseByMouse.FRMov{mm}(1,:)*0,MouseByMouse.FRFz{mm}(1,:)*0+1]; % movement = 0, freezing = 1
    FRZ = (AllFr')';
    AllDatProj.MovVsFz.TrainSf{mm} = [];
    W.MovVsFz.TrainSf{mm} = [];
    
    if BinsToUse>1
        for perm = 1:500
            
            MovBins = find(BinType==0 & LinPosMovFzSafe>DecodingLimits(2));
            MovBinsToUse = MovBins(randperm(length(MovBins),BinsToUse*2));
            MovFrTrain = [FRZ(:,MovBinsToUse(BinsToUse+1:end))];
            MovFrTest = [FRZ(:,MovBinsToUse(1:BinsToUse))];
            
            FzBins = find(BinType==1 & LinPosMovFzSafe<DecodingLimits(1));
            FzBinsToUse = FzBins(randperm(length(FzBins),BinsToUse*2));
            FzFrTrain = [FRZ(:,FzBinsToUse(BinsToUse+1:end))];
            FzFrTest = [FRZ(:,FzBinsToUse(1:BinsToUse))];
            
            W.MovVsFz.TrainSf{mm}(perm,:) = (nanmean(MovFrTrain')-nanmean(FzFrTrain'));
            W.MovVsFz.TrainSf{mm}(perm,:) = W.MovVsFz.TrainSf{mm}(perm,:)./norm(W.MovVsFz.TrainSf{mm}(perm,:));
            
            Bias.MovVsFz.TrainSf{mm}(perm) = (nanmean(MovFrTrain'*W.MovVsFz.TrainSf{mm}(perm,:)') + nanmean(FzFrTrain'*W.MovVsFz.TrainSf{mm}(perm,:)'))/2;
            clear MovGuess FzGuess
            for trial = 1 : BinsToUse
                MovGuess(trial) = MovFrTest(:,trial)'*W.MovVsFz.TrainSf{mm}(perm,:)'>Bias.MovVsFz.TrainSf{mm}(perm);
                FzGuess(trial) = FzFrTest(:,trial)'*W.MovVsFz.TrainSf{mm}(perm,:)'<Bias.MovVsFz.TrainSf{mm}(perm);
            end
            
            Score.MovVsFz.TrainSf(mm,perm) = (nanmean(MovGuess)+nanmean(FzGuess))/2;
            AllDatProj.MovVsFz.TrainSf{mm}(perm,:)=FRZ'*W.MovVsFz.TrainSf{mm}(perm,:)'-Bias.MovVsFz.TrainSf{mm}(perm);
            
        end
    end
    
    %% Cross decoding
    % Trained on freezing - check on movement
    FRZ = (MouseByMouse.FRMov{mm}')';
    ShockBins = find(MouseByMouse.LinPosMov{mm}<DecodingLimits(1));
    SafeBins = find(MouseByMouse.LinPosMov{mm}>DecodingLimits(2));
    
    if BinsToUse>1
        for perm = 1:500
            
            Proj = FRZ'*W.SkVsSf.TrainFz{mm}(perm,:)';
            BiasTemp = (nanmean(Proj(SafeBins)) + nanmean(Proj(ShockBins)))/2;
            
            Score.SkVsSf.TrainFzTestMov(mm,perm) = (nanmean(Proj(ShockBins)>BiasTemp)+nanmean(Proj(SafeBins)<BiasTemp))/2;
            
        end
    end
    
    % Trained on movement - check on freezing
    FRZ = (MouseByMouse.FRFz{mm}')';
    ShockBins = find(MouseByMouse.LinPosFz{mm}<DecodingLimits(1));
    SafeBins = find(MouseByMouse.LinPosFz{mm}>DecodingLimits(2));
    
    if BinsToUse>1
        for perm = 1:500
            
            Proj = FRZ'*W.SkVsSf.TrainMov{mm}(perm,:)';
            BiasTemp = (nanmean(Proj(SafeBins)) + nanmean(Proj(ShockBins)))/2;
            
            Score.SkVsSf.TrainMovTestFz(mm,perm) = (nanmean(Proj(ShockBins)>BiasTemp)+nanmean(Proj(SafeBins)<BiasTemp))/2
            
        end
    end
    
    % Freezing vs movement - trained on shock, test on safe
    AllFr  = [MouseByMouse.FRMov{mm},MouseByMouse.FRFz{mm}];
    LinPosTogether = [MouseByMouse.LinPosMov{mm},MouseByMouse.LinPosFz{mm}];
    BinType  = [MouseByMouse.FRMov{mm}(1,:)*0,MouseByMouse.FRFz{mm}(1,:)*0+1]; % movement = 0, freezing = 1
    FRZ = (AllFr')';
    FRZ = FRZ(:,LinPosTogether>DecodingLimits(2));
    BinType_Res = BinType(LinPosTogether>DecodingLimits(2));
    
    MovBins = find(BinType_Res==0);
    FzBins = find(BinType_Res==1);
    
    if BinsToUse>1
        for perm = 1:500
            
            Proj = FRZ'*W.MovVsFz.TrainSk{mm}(perm,:)';
            BiasTemp = (nanmean(Proj(MovBins)) + nanmean(Proj(FzBins)))/2;
            
            Score.MovVsFz.TrainSkTestSf(mm,perm) = (nanmean(Proj(MovBins)>BiasTemp)+nanmean(Proj(FzBins)<BiasTemp))/2;
            
        end
    end
    
    % Freezing vs movement - trained on safe, test on shock
    AllFr  = [MouseByMouse.FRMov{mm},MouseByMouse.FRFz{mm}];
    LinPosTogether = [MouseByMouse.LinPosMov{mm},MouseByMouse.LinPosFz{mm}];
    BinType  = [MouseByMouse.FRMov{mm}(1,:)*0,MouseByMouse.FRFz{mm}(1,:)*0+1]; % movement = 0, freezing = 1
    FRZ = (AllFr')';
    FRZ = FRZ(:,LinPosTogether<DecodingLimits(1));
    BinType_Res = BinType(LinPosTogether<DecodingLimits(1));
    
    MovBins = find(BinType_Res==0);
    FzBins = find(BinType_Res==1);
    
    if BinsToUse>1
        for perm = 1:500
            
            Proj = FRZ'*W.MovVsFz.TrainSf{mm}(perm,:)';
            BiasTemp = (nanmean(Proj(MovBins)) + nanmean(Proj(FzBins)))/2;
            
            Score.MovVsFz.TrainSfTestSk(mm,perm) = (nanmean(Proj(MovBins)>BiasTemp)+nanmean(Proj(FzBins)<BiasTemp))/2;
            
        end
    end
    
    %% Projections
    Q = MakeQfromS(Spikes,0.05*1E4);
    TotalEpoch = intervalSet(0,max(Range(Q)));
    Q = Restrict(Q,TotalEpoch-NoiseEpoch);
    Q = tsd(Range(Q),nanzscore(Data(Q)));
    
    FreezeEpoch=dropShortIntervals(FreezeEpoch,3*1e4);
    FreezeEpochBis=FreezeEpoch;
    for fr_ep=1:length(Start(FreezeEpoch))
        LitEp=subset(FreezeEpoch,fr_ep);
        NotLitEp=FreezeEpoch-LitEp;
        StopEp=intervalSet(Stop(LitEp)-3*1e4,Stop(LitEp)+3*1e4);
        if not(isempty(Data(Restrict(Vtsd,and(NotLitEp,StopEp)))))
            FreezeEpochBis=FreezeEpochBis-LitEp;
        end
    end
    FreezeEpoch=CleanUpEpoch(FreezeEpochBis);
    
    % trained to distinguish safe vs shock during movement
    Projtsd = tsd(Range(Q),Data(Q)*nanmean(W.SkVsSf.TrainMov{mm})'-nanmean(Bias.SkVsSf.TrainMov{mm}));
    [M,TUp] = PlotRipRaw(Projtsd,Start(and(FreezeEpoch,thresholdIntervals(LinPos,0.4,'Direction','Below')),'s'),2000,0,0);
    ProjData.FzStartSk.SkVsSf.TrainMov(mm,:) = M(:,2);
    [M,TUp] = PlotRipRaw(Projtsd,Stop(and(FreezeEpoch,thresholdIntervals(LinPos,0.4,'Direction','Below')),'s'),2000,0,0);
    ProjData.FzStopSk.SkVsSf.TrainMov(mm,:) = M(:,2);
    
    [M,TUp] = PlotRipRaw(Projtsd,Start(and(FreezeEpoch,thresholdIntervals(LinPos,0.6,'Direction','Above')),'s'),2000,0,0);
    ProjData.FzStartSf.SkVsSf.TrainMov(mm,:) = M(:,2);
    [M,TUp] = PlotRipRaw(Projtsd,Stop(and(FreezeEpoch,thresholdIntervals(LinPos,0.6,'Direction','Above')),'s'),2000,0,0);
    ProjData.FzStopSf.SkVsSf.TrainMov(mm,:) = M(:,2);
    
    ProjData.MeanFzSk.SkVsSf.TrainMov(mm) = nanmean(Data(Restrict(Projtsd,and(CleanFreezeEpoch,thresholdIntervals(LinPos,0.4,'Direction','Below')))));
    ProjData.MeanFzSf.SkVsSf.TrainMov(mm) = nanmean(Data(Restrict(Projtsd,and(CleanFreezeEpoch,thresholdIntervals(LinPos,0.6,'Direction','Above')))));
    ProjData.MeanMovSk.SkVsSf.TrainMov(mm) = nanmean(Data(Restrict(Projtsd,and(CleanMovEpoch,thresholdIntervals(LinPos,0.4,'Direction','Below')))));
    ProjData.MeanMovSf.SkVsSf.TrainMov(mm) = nanmean(Data(Restrict(Projtsd,and(CleanMovEpoch,thresholdIntervals(LinPos,0.6,'Direction','Above')))));
    
    % trained to distinguish safe vs shock during freezing
    Projtsd = tsd(Range(Q),Data(Q)*nanmean(W.SkVsSf.TrainFz{mm})'-nanmean(Bias.SkVsSf.TrainFz{mm}));
    [M,TUp] = PlotRipRaw(Projtsd,Start(and(FreezeEpoch,thresholdIntervals(LinPos,0.4,'Direction','Below')),'s'),2000,0,0);
    ProjData.FzStartSk.SkVsSf.TrainFz(mm,:) = M(:,2);
    [M,TUp] = PlotRipRaw(Projtsd,Stop(and(FreezeEpoch,thresholdIntervals(LinPos,0.4,'Direction','Below')),'s'),2000,0,0);
    ProjData.FzStopSk.SkVsSf.TrainFz(mm,:) = M(:,2);
    
    [M,TUp] = PlotRipRaw(Projtsd,Start(and(FreezeEpoch,thresholdIntervals(LinPos,0.6,'Direction','Above')),'s'),2000,0,0);
    ProjData.FzStartSf.SkVsSf.TrainFz(mm,:) = M(:,2);
    [M,TUp] = PlotRipRaw(Projtsd,Stop(and(FreezeEpoch,thresholdIntervals(LinPos,0.6,'Direction','Above')),'s'),2000,0,0);
    ProjData.FzStopSf.SkVsSf.TrainFz(mm,:) = M(:,2);
    
    ProjData.MeanFzSk.SkVsSf.TrainFz(mm) = nanmean(Data(Restrict(Projtsd,and(CleanFreezeEpoch,thresholdIntervals(LinPos,0.4,'Direction','Below')))));
    ProjData.MeanFzSf.SkVsSf.TrainFz(mm) = nanmean(Data(Restrict(Projtsd,and(CleanFreezeEpoch,thresholdIntervals(LinPos,0.6,'Direction','Above')))));
    ProjData.MeanMovSk.SkVsSf.TrainFz(mm) = nanmean(Data(Restrict(Projtsd,and(CleanMovEpoch,thresholdIntervals(LinPos,0.4,'Direction','Below')))));
    ProjData.MeanMovSf.SkVsSf.TrainFz(mm) = nanmean(Data(Restrict(Projtsd,and(CleanMovEpoch,thresholdIntervals(LinPos,0.6,'Direction','Above')))));
           
    % trained to distinguish safe vs shock over everything
    Projtsd = tsd(Range(Q),Data(Q)*nanmean(W.SkVsSf.TrainMovFz{mm})'-nanmean(Bias.SkVsSf.TrainMovFz{mm}));
    [M,TUp] = PlotRipRaw(Projtsd,Start(and(FreezeEpoch,thresholdIntervals(LinPos,0.4,'Direction','Below')),'s'),2000,0,0);
    ProjData.FzStartSk.SkVsSf.TrainMovFz(mm,:) = M(:,2);
    [M,TUp] = PlotRipRaw(Projtsd,Stop(and(FreezeEpoch,thresholdIntervals(LinPos,0.4,'Direction','Below')),'s'),2000,0,0);
    ProjData.FzStopSk.SkVsSf.TrainMovFz(mm,:) = M(:,2);
    
    [M,TUp] = PlotRipRaw(Projtsd,Start(and(FreezeEpoch,thresholdIntervals(LinPos,0.6,'Direction','Above')),'s'),2000,0,0);
    ProjData.FzStartSf.SkVsSf.TrainMovFz(mm,:) = M(:,2);
    [M,TUp] = PlotRipRaw(Projtsd,Stop(and(FreezeEpoch,thresholdIntervals(LinPos,0.6,'Direction','Above')),'s'),2000,0,0);
    ProjData.FzStopSf.SkVsSf.TrainMovFz(mm,:) = M(:,2);
    
    ProjData.MeanFzSk.SkVsSf.TrainMovFz(mm) = nanmean(Data(Restrict(Projtsd,and(CleanFreezeEpoch,thresholdIntervals(LinPos,0.4,'Direction','Below')))));
    ProjData.MeanFzSf.SkVsSf.TrainMovFz(mm) = nanmean(Data(Restrict(Projtsd,and(CleanFreezeEpoch,thresholdIntervals(LinPos,0.6,'Direction','Above')))));
    ProjData.MeanMovSk.SkVsSf.TrainMovFz(mm) = nanmean(Data(Restrict(Projtsd,and(CleanMovEpoch,thresholdIntervals(LinPos,0.4,'Direction','Below')))));
    ProjData.MeanMovSf.SkVsSf.TrainMovFz(mm) = nanmean(Data(Restrict(Projtsd,and(CleanMovEpoch,thresholdIntervals(LinPos,0.6,'Direction','Above')))));

    
    % Trained to distinguish movement from freezing 
    Projtsd = tsd(Range(Q),Data(Q)*nanmean(W.MovVsFz.TrainSkSf{mm})'-nanmean(Bias.MovVsFz.TrainSkSf{mm}));
    [M,TUp] = PlotRipRaw(Projtsd,Start(and(FreezeEpoch,thresholdIntervals(LinPos,0.4,'Direction','Below')),'s'),2000,0,0);
    ProjData.FzStartSk.MovVsFz.TrainSkSf(mm,:) = M(:,2);
    [M,TUp] = PlotRipRaw(Projtsd,Stop(and(FreezeEpoch,thresholdIntervals(LinPos,0.4,'Direction','Below')),'s'),2000,0,0);
    ProjData.FzStopSk.MovVsFz.TrainSkSf(mm,:) = M(:,2);
    
    [M,TUp] = PlotRipRaw(Projtsd,Start(and(FreezeEpoch,thresholdIntervals(LinPos,0.6,'Direction','Above')),'s'),2000,0,0);
    ProjData.FzStartSf.MovVsFz.TrainSkSf(mm,:) = M(:,2);
    [M,TUp] = PlotRipRaw(Projtsd,Stop(and(FreezeEpoch,thresholdIntervals(LinPos,0.6,'Direction','Above')),'s'),2000,0,0);
    ProjData.FzStopSf.MovVsFz.TrainSkSf(mm,:) = M(:,2);
    
    ProjData.MeanFzSk.MovVsFz.TrainSkSf(mm) = nanmean(Data(Restrict(Projtsd,and(CleanFreezeEpoch,thresholdIntervals(LinPos,0.4,'Direction','Below')))));
    ProjData.MeanFzSf.MovVsFz.TrainSkSf(mm) = nanmean(Data(Restrict(Projtsd,and(CleanFreezeEpoch,thresholdIntervals(LinPos,0.6,'Direction','Above')))));
    ProjData.MeanMovSk.MovVsFz.TrainSkSf(mm) = nanmean(Data(Restrict(Projtsd,and(CleanMovEpoch,thresholdIntervals(LinPos,0.4,'Direction','Below')))));
    ProjData.MeanMovSf.MovVsFz.TrainSkSf(mm) = nanmean(Data(Restrict(Projtsd,and(CleanMovEpoch,thresholdIntervals(LinPos,0.6,'Direction','Above')))));
    
    % Trained to distinguish movement from freezing on safe side
    Projtsd = tsd(Range(Q),Data(Q)*nanmean(W.MovVsFz.TrainSf{mm})'-nanmean(Bias.MovVsFz.TrainSf{mm}));
    [M,TUp] = PlotRipRaw(Projtsd,Start(and(FreezeEpoch,thresholdIntervals(LinPos,0.4,'Direction','Below')),'s'),2000,0,0);
    ProjData.FzStartSk.MovVsFz.TrainSf(mm,:) = M(:,2);
    [M,TUp] = PlotRipRaw(Projtsd,Stop(and(FreezeEpoch,thresholdIntervals(LinPos,0.4,'Direction','Below')),'s'),2000,0,0);
    ProjData.FzStopSk.MovVsFz.TrainSf(mm,:) = M(:,2);
    
    [M,TUp] = PlotRipRaw(Projtsd,Start(and(FreezeEpoch,thresholdIntervals(LinPos,0.6,'Direction','Above')),'s'),2000,0,0);
    ProjData.FzStartSf.MovVsFz.TrainSf(mm,:) = M(:,2);
    [M,TUp] = PlotRipRaw(Projtsd,Stop(and(FreezeEpoch,thresholdIntervals(LinPos,0.6,'Direction','Above')),'s'),2000,0,0);
    ProjData.FzStopSf.MovVsFz.TrainSf(mm,:) = M(:,2);
    
    ProjData.MeanFzSk.MovVsFz.TrainSf(mm) = nanmean(Data(Restrict(Projtsd,and(CleanFreezeEpoch,thresholdIntervals(LinPos,0.4,'Direction','Below')))));
    ProjData.MeanFzSf.MovVsFz.TrainSf(mm) = nanmean(Data(Restrict(Projtsd,and(CleanFreezeEpoch,thresholdIntervals(LinPos,0.6,'Direction','Above')))));
    ProjData.MeanMovSk.MovVsFz.TrainSf(mm) = nanmean(Data(Restrict(Projtsd,and(CleanMovEpoch,thresholdIntervals(LinPos,0.4,'Direction','Below')))));
    ProjData.MeanMovSf.MovVsFz.TrainSf(mm) = nanmean(Data(Restrict(Projtsd,and(CleanMovEpoch,thresholdIntervals(LinPos,0.6,'Direction','Above')))));
    
    % Trained to distinguish movement from freezing on shock side
    Projtsd = tsd(Range(Q),Data(Q)*nanmean(W.MovVsFz.TrainSk{mm})'-nanmean(Bias.MovVsFz.TrainSk{mm}));
    [M,TUp] = PlotRipRaw(Projtsd,Start(and(FreezeEpoch,thresholdIntervals(LinPos,0.4,'Direction','Below')),'s'),2000,0,0);
    ProjData.FzStartSk.MovVsFz.TrainSk(mm,:) = M(:,2);
    [M,TUp] = PlotRipRaw(Projtsd,Stop(and(FreezeEpoch,thresholdIntervals(LinPos,0.4,'Direction','Below')),'s'),2000,0,0);
    ProjData.FzStopSk.MovVsFz.TrainSk(mm,:) = M(:,2);
    
    [M,TUp] = PlotRipRaw(Projtsd,Start(and(FreezeEpoch,thresholdIntervals(LinPos,0.6,'Direction','Above')),'s'),2000,0,0);
    ProjData.FzStartSf.MovVsFz.TrainSk(mm,:) = M(:,2);
    [M,TUp] = PlotRipRaw(Projtsd,Stop(and(FreezeEpoch,thresholdIntervals(LinPos,0.6,'Direction','Above')),'s'),2000,0,0);
    ProjData.FzStopSf.MovVsFz.TrainSf(mm,:) = M(:,2);
    
    ProjData.MeanFzSk.MovVsFz.TrainSk(mm) = nanmean(Data(Restrict(Projtsd,and(CleanFreezeEpoch,thresholdIntervals(LinPos,0.4,'Direction','Below')))));
    ProjData.MeanFzSf.MovVsFz.TrainSk(mm) = nanmean(Data(Restrict(Projtsd,and(CleanFreezeEpoch,thresholdIntervals(LinPos,0.6,'Direction','Above')))));
    ProjData.MeanMovSk.MovVsFz.TrainSk(mm) = nanmean(Data(Restrict(Projtsd,and(CleanMovEpoch,thresholdIntervals(LinPos,0.4,'Direction','Below')))));
    ProjData.MeanMovSf.MovVsFz.TrainSk(mm) = nanmean(Data(Restrict(Projtsd,and(CleanMovEpoch,thresholdIntervals(LinPos,0.6,'Direction','Above')))));
    
    % Compare speed
    ProjData.MeanSpeedShock(mm) = nanmean(Data(Restrict(Vtsd,(thresholdIntervals(LinPos,0.4,'Direction','Below')-NoiseEpoch)-CleanFreezeEpoch)));
    MeanSpeedSafe(mm) = nanmean(Data(Restrict(Vtsd,(thresholdIntervals(LinPos,0.6,'Direction','Above')-NoiseEpoch)-CleanFreezeEpoch)));
    
    [M,TUp] = PlotRipRaw(MovAcctsd,Start(and(FreezeEpoch,thresholdIntervals(LinPos,0.6,'Direction','Above')),'s'),2000,0,0);
    ProjData.FzStart.Acc(mm,:) = M(:,2);
    [M,TUp] = PlotRipRaw(MovAcctsd,Stop(and(FreezeEpoch,thresholdIntervals(LinPos,0.6,'Direction','Above')),'s'),2000,0,0);
    ProjData.FzStopSf.Acc(mm,:) = M(:,2);
    
    [M,TUp] = PlotRipRaw(MovAcctsd,Start(and(FreezeEpoch,thresholdIntervals(LinPos,0.4,'Direction','Below')),'s'),2000,0,0);
    ProjData.FzStartSk.Acc(mm,:) = M(:,2);
    [M,TUp] = PlotRipRaw(MovAcctsd,Stop(and(FreezeEpoch,thresholdIntervals(LinPos,0.4,'Direction','Below')),'s'),2000,0,0);
    ProjData.FzStopSk.Acc(mm,:) = M(:,2);
end

save('SpikesDecodingFzVsNoFzSkvsSafe_UMazeBis.mat','ProjData','AllDatProj','W','Score','-V7.3')

figure
tps = [-2+4/81:4/81:2];
subplot(3,2,1)
plot(tps,nanmean(ProjData.FzStartSk.SkVsSf.TrainFz)-nanmean(nanmean(ProjData.FzStartSk.SkVsSf.TrainFz(:,1:40))),'linewidth',3,'color',UMazeColors('shock'))
hold on
plot(tps,nanmean(ProjData.FzStartSf.SkVsSf.TrainFz)-nanmean(nanmean(ProjData.FzStartSf.SkVsSf.TrainFz(:,1:40))),'linewidth',3,'color',UMazeColors('safe'))
ylim([-0.9 0.9])
xlabel('time to Fz start(s)')
ylabel('Proj Sk vs Sf')
line([0 0],ylim,'color','k','linestyle',':')
box off
set(gca,'FontSize',12,'linewidth',2)

subplot(3,2,2)
plot(tps,nanmean(ProjData.FzStopSk.SkVsSf.TrainFz)-nanmean(nanmean(ProjData.FzStopSk.SkVsSf.TrainFz(:,45:end))),'linewidth',3,'color',UMazeColors('shock'))
hold on
plot(tps,nanmean(ProjData.FzStopSf.SkVsSf.TrainFz)-nanmean(nanmean(ProjData.FzStopSf.SkVsSf.TrainFz(:,45:end))),'linewidth',3,'color',UMazeColors('safe'))
ylim([-0.9 0.9])
xlabel('time to Fz stop(s)')
ylabel('Proj Sk vs Sf')
line([0 0],ylim,'color','k','linestyle',':')
box off
set(gca,'FontSize',12,'linewidth',2)

subplot(3,2,3)
plot(tps,nanmean(ProjData.FzStartSk.MovVsFz.TrainSkSf)-nanmean(nanmean(ProjData.FzStartSk.MovVsFz.TrainSkSf(:,1:40))),'linewidth',3,'color',UMazeColors('shock'))
hold on
plot(tps,nanmean(ProjData.FzStartSf.MovVsFz.TrainSkSf)-nanmean(nanmean(ProjData.FzStartSf.MovVsFz.TrainSkSf(:,1:40))),'linewidth',3,'color',UMazeColors('safe'))
ylim([-1 0.4])
xlabel('time to Fz start(s)')
ylabel('Proj Mov vs Fz')
line([0 0],ylim,'color','k','linestyle',':')
box off
set(gca,'FontSize',12,'linewidth',2)
subplot(3,2,4)
plot(tps,nanmean(ProjData.FzStopSk.MovVsFz.TrainSkSf)-nanmean(nanmean(ProjData.FzStopSk.MovVsFz.TrainSkSf(:,45:end))),'linewidth',3,'color',UMazeColors('shock'))
hold on
plot(tps,nanmean(ProjData.FzStopSf.MovVsFz.TrainSkSf)-nanmean(nanmean(ProjData.FzStopSf.MovVsFz.TrainSkSf(:,45:end))),'linewidth',3,'color',UMazeColors('safe'))
ylim([-1 0.4])
xlabel('time to Fz start(s)')
ylabel('Proj Mov vs Fz')
line([0 0],ylim,'color','k','linestyle',':')
box off
set(gca,'FontSize',12,'linewidth',2)

tps = [-2+4/201:4/201:2];
subplot(3,2,5)
plot(tps,nanmean(ProjData.FzStartSk.Acc),'linewidth',3,'color',UMazeColors('shock'))
hold on
plot(tps,nanmean(ProjData.FzStart.Acc),'linewidth',3,'color',UMazeColors('safe'))
ylim([0 6e7])
xlabel('time to Fz start(s)')
ylabel('Accelero')
line([0 0],ylim,'color','k','linestyle',':')
box off
set(gca,'FontSize',12,'linewidth',2)
subplot(3,2,6)
plot(tps,nanmean(ProjData.FzStopSf.Acc),'linewidth',3,'color',UMazeColors('shock'))
hold on
plot(tps,nanmean(ProjData.FzStopSk.Acc),'linewidth',3,'color',UMazeColors('safe'))
ylim([0 6e7])
xlabel('Accelero')
ylabel('Proj Mov vs Fz')
line([0 0],ylim,'color','k','linestyle',':')
box off
set(gca,'FontSize',12,'linewidth',2)

figure
clf
for mm = 1:7

plot(ProjData.MeanFzSk.SkVsSf.TrainMovFz(mm),ProjData.MeanFzSk.MovVsFz.TrainSkSf(mm),'.','MarkerSize',20,'color',UMazeColors('shock'))
hold on
plot(ProjData.MeanFzSf.SkVsSf.TrainMovFz(mm),ProjData.MeanFzSf.MovVsFz.TrainSkSf(mm),'.','MarkerSize',20,'color',UMazeColors('safe'))

plot(ProjData.MeanMovSk.SkVsSf.TrainMovFz(mm),ProjData.MeanMovSk.MovVsFz.TrainSkSf(mm),'.','MarkerSize',20,'color',UMazeColors('shock')*0.5)
hold on
plot(ProjData.MeanMovSf.SkVsSf.TrainMovFz(mm),ProjData.MeanMovSf.MovVsFz.TrainSkSf(mm),'.','MarkerSize',20,'color',UMazeColors('safe')*0.5)
% ProjData
% clf
end
plot(nanmean(ProjData.MeanFzSk.SkVsSf.TrainMovFz),nanmean(ProjData.MeanFzSk.MovVsFz.TrainSkSf),'.','MarkerSize',50,'color',UMazeColors('shock'))
hold on
plot(nanmean(ProjData.MeanFzSf.SkVsSf.TrainMovFz),nanmean(ProjData.MeanFzSf.MovVsFz.TrainSkSf),'.','MarkerSize',50,'color',UMazeColors('safe'))
plot(nanmean(ProjData.MeanMovSk.SkVsSf.TrainMovFz),nanmean(ProjData.MeanMovSk.MovVsFz.TrainSkSf),'.','MarkerSize',50,'color',UMazeColors('shock')*0.5)
plot(nanmean(ProjData.MeanMovSf.SkVsSf.TrainMovFz),nanmean(ProjData.MeanMovSf.MovVsFz.TrainSkSf),'.','MarkerSize',50,'color',UMazeColors('safe')*0.5)
xlabel('Fz Shock vs Fz Safe')
ylabel('Mov vs Fz')

%Plot freezing onset and offset
figure
subplot(121)
plot(nanmean(ProjData.FzStartSk.SkVsSf.TrainFz(:,1:40)),nanmean(ProjData.FzStartSk.MovVsFz.TrainSkSf(:,1:40)),'color',UMazeColors('shock')*0.5,'linewidth',2)
hold on
plot(nanmean(ProjData.FzStartSk.SkVsSf.TrainFz(:,41:end)),nanmean(ProjData.FzStartSk.MovVsFz.TrainSkSf(:,41:end)),'color',UMazeColors('shock'),'linewidth',2)
plot(nanmean(ProjData.FzStartSf.SkVsSf.TrainFz(:,1:40)),nanmean(ProjData.FzStartSf.MovVsFz.TrainSkSf(:,1:40)),'color',UMazeColors('safe')*0.5,'linewidth',2)
plot(nanmean(ProjData.FzStartSf.SkVsSf.TrainFz(:,41:end)),nanmean(ProjData.FzStartSf.MovVsFz.TrainSkSf(:,41:end)),'color',UMazeColors('safe'),'linewidth',2)
xlim([-0.6 0.8])
ylim([-0.8 0.3])
xlabel('Fz Shock vs Fz Safe')
ylabel('Mov vs Fz')
legend('PreFz-Sk','Fz-Sk','PreFz-Sf','Fz-Sf')
set(gca,'FontSize',15,'linewidth',2)
box off

subplot(122)
plot(nanmean(ProjData.FzStopSk.SkVsSf.TrainFz(:,1:40)),nanmean(ProjData.FzStopSk.MovVsFz.TrainSkSf(:,1:40)),'color',UMazeColors('shock'),'linewidth',2)
hold on
plot(nanmean(ProjData.FzStopSk.SkVsSf.TrainFz(:,41:end)),nanmean(ProjData.FzStopSk.MovVsFz.TrainSkSf(:,41:end)),'color',UMazeColors('shock')*0.5,'linewidth',2)
plot(nanmean(ProjData.FzStopSf.SkVsSf.TrainFz(:,1:40)),nanmean(ProjData.FzStopSf.MovVsFz.TrainSkSf(:,1:40)),'color',UMazeColors('safe'),'linewidth',2)
plot(nanmean(ProjData.FzStopSf.SkVsSf.TrainFz(:,41:end)),nanmean(ProjData.FzStopSf.MovVsFz.TrainSkSf(:,41:end)),'color',UMazeColors('safe')*0.5,'linewidth',2)
xlim([-0.6 0.8])
ylim([-0.8 0.3])
xlabel('Fz Shock vs Fz Safe')
ylabel('Mov vs Fz')
legend('Fz-Sk','PostFz-Sk','Fz-Sf','PostFz-Sf')
set(gca,'FontSize',15,'linewidth',2)
box off


figure
subplot(121)
A = {nanmean(Score.SkVsSf.TrainFz'),nanmean(Score.SkVsSf.TrainMov')};
[p,h,stats] = signrank(A{1},A{2})
Cols = {[0.6 0.6 0.6],[0.5 0.5 0.5]};
hold on
MakeSpreadAndBoxPlot_SB(A,Cols,1:2,{},1,0)
title('Shock vs Safe decoding')
set(gca,'XTick',[1:2],'XTickLabel',{'Fz','Mov'})
ylim([0.3 1])
line(xlim,[0.5 0.5],'color','k')
sigstar_DB({{1,2}},p)
ylabel('Accuracy')
set(gca,'FontSize',15,'linewidth',2)
subplot(122)
A = {nanmean(Score.MovVsFz.TrainSkSf'),nanmean(Score.MovVsFz.TrainSk'),nanmean(Score.MovVsFz.TrainSf')};
Cols = {[0.3 0.3 0.3]*2,UMazeColors('shock'),UMazeColors('safe')};
hold on
MakeSpreadAndBoxPlot_SB(A,Cols,1:3,{},1,0)
title('Mov vs Fz decoding')
set(gca,'XTick',[1:3],'XTickLabel',{'All','Shock','Safe'})
ylim([0.3 1])
line(xlim,[0.5 0.5],'color','k')
[p1,h,stats] = signrank(A{1},A{2})
[p2,h,stats] = signrank(A{1},A{3})
[p3,h,stats] = signrank(A{2},A{3})
sigstar_DB({{1,2},{1,3},{2,3}},[p1,p2,p3])
ylabel('Accuracy')
set(gca,'FontSize',15,'linewidth',2)

figure
subplot(121)
A = {nanmean(Score.SkVsSf.TrainMov'),nanmean(Score.SkVsSf.TrainFzTestMov')};
[p,h,stats] = signrank(A{1},A{2})
Cols = {[0.6 0.6 0.6],[0.5 0.5 0.5]};
hold on
MakeSpreadAndBoxPlot_SB(A,Cols,1:2,{},1,0)
title('Shock vs Safe decoding')

subplot(122)
A = {nanmean(Score.SkVsSf.TrainFz'),nanmean(Score.SkVsSf.TrainMovTestFz')};
[p,h,stats] = signrank(A{1},A{2})
Cols = {[0.6 0.6 0.6],[0.5 0.5 0.5]};
hold on
MakeSpreadAndBoxPlot_SB(A,Cols,1:2,{},1,0)
title('Shock vs Safe decoding')


figure
subplot(121)
plot(nanmean(Proj.FzStartSk.MovVsFz.TrainSf(:,1:40)),nanmean(Proj.FzStartSf.MovVsFz.TrainSk(:,1:40)),'color',UMazeColors('shock')*0.5,'linewidth',2)
hold on
plot(nanmean(Proj.FzStartSk.MovVsFz.TrainSf(:,41:end)),nanmean(Proj.FzStartSf.MovVsFz.TrainSk(:,41:end)),'color',UMazeColors('shock'),'linewidth',2)
plot(nanmean(Proj.FzStartSf.MovVsFz.TrainSf(:,1:40)),nanmean(Proj.FzStartSk.MovVsFz.TrainSk (:,1:40)),'color',UMazeColors('safe')*0.5,'linewidth',2)
plot(nanmean(Proj.FzStartSf.MovVsFz.TrainSf(:,41:end)),nanmean(Proj.FzStartSk.MovVsFz.TrainSk(:,41:end)),'color',UMazeColors('safe'),'linewidth',2)
xlabel('Mov vs Fz - trained safe')
ylabel('Mov vs Fz - trained shock')
legend('PreFz-Sk','Fz-Sk','PreFz-Sf','Fz-Sf')
xlim([-1 0.7])
ylim([-1 0.4])
set(gca,'FontSize',15,'linewidth',2)
box off

subplot(122)
plot(nanmean(Proj.FzStopSk.MovVsFz.TrainSf(:,1:40)),nanmean(Proj.FzStopSf.MovVsFz.TrainSf(:,1:40)),'color',UMazeColors('shock'),'linewidth',2)
hold on
plot(nanmean(Proj.FzStopSk.MovVsFz.TrainSf(:,41:end)),nanmean(Proj.FzStopSf.MovVsFz.TrainSf(:,41:end)),'color',UMazeColors('shock')*0.5,'linewidth',2)
plot(nanmean(Proj.FzStopSf.MovVsFz.TrainSf(:,1:40)),nanmean(Proj.FzStopSk.MovVsFz.TrainSk (:,1:40)),'color',UMazeColors('safe'),'linewidth',2)
plot(nanmean(Proj.FzStopSf.MovVsFz.TrainSf(:,41:end)),nanmean(Proj.FzStopSk.MovVsFz.TrainSk(:,41:end)),'color',UMazeColors('safe')*0.5,'linewidth',2)
xlabel('Mov vs Fz - trained safe')
ylabel('Mov vs Fz - trained shock')
legend('PreFz-Sk','Fz-Sk','PreFz-Sf','Fz-Sf')
xlim([-1 0.7])
ylim([-1 0.4])
set(gca,'FontSize',15,'linewidth',2)
box off


%% Look at weights
AllWMovFz = [];
AllWTog = [];

for mm = 1:7
    AllWMovFz = [AllWMovFz,nanmean(W.SkVsSf.TrainFz{mm})];
    AllWTog = [AllWTog,nanmean(W.SkVsSf.TrainMov{mm})];
end
[R,P] = corrcoef(AllWMovFz,AllWTog)