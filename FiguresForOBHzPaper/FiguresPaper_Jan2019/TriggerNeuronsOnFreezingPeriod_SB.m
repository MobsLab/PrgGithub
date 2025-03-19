clear all

% Get sessions
Dir = PathForExperimentFEAR('Fear-electrophy');


ArdFreezePer = 3*1e4;
DurFreezePer = 5*1e4;
BeepPer = 0.5*1e4;
bi = 0.05*1e4;
bi_Tone = 0.01*1e4;

for mm=1:length(Dir.path)
    
    cd(Dir.path{mm})
    
    if exist('SpikeData.mat')>0
        clear Movtsd FreezeEpoch FreezeAccEpoch S NeurRespWholeNorm NeurRespStart NeurRespEnd NeurRespWhole Qs
        disp(Dir.path{mm})
        
        load('SpikeData.mat')
        Qs = MakeQfromS(S,bi);
        Qs_Tone = MakeQfromS(S,bi_Tone);

        try, load('behavResources.mat');catch,load('Behavior.mat'); end
        if exist('FreezeAccEpoch','var')
            FreezeEpoch = FreezeAccEpoch;
        end
        
        FreezeEpoch = mergeCloseIntervals(FreezeEpoch,2*1e4);
        FreezeEpoch = dropShortIntervals(FreezeEpoch,2*1e4);
        
        FreezeEpoch = subset(FreezeEpoch,find((Stop(FreezeEpoch)+DurFreezePer)< max(Range(Qs))));  
        
        FreezingEpDur = (Stop(FreezeEpoch)-Start(FreezeEpoch))/1E4;
        
        %% TriggerOnFreezingStart
        is = intervalSet(Start(FreezeEpoch)-ArdFreezePer, Start(FreezeEpoch)+DurFreezePer);
        sweeps = intervalSplit(Qs, is, 'OffsetStart', Start(is)*0);
        
        % matrix is time * neurons * trials
        clear AllDat_Start
        for ep = 1:length(Start(is))
            AllDat_Start(ep,:,:) = full(Data(sweeps{ep}))';
        end
        NeurRespStart = tsd(Range(sweeps{1}),permute(AllDat_Start,[3,2,1]));
        
        
        %% TriggerOnFreezingStop
        is = intervalSet(Stop(FreezeEpoch)-DurFreezePer, Stop(FreezeEpoch)+DurFreezePer);
        sweeps = intervalSplit(Qs, is, 'OffsetStart', Start(is)*0);
        
        % matrix is time * neurons * trials
        clear AllDat_End
        for ep = 1:length(Start(is))
            AllDat_End(ep,:,:) = full(Data(sweeps{ep}))';
        end
        NeurRespEnd = tsd(Range(sweeps{1}),permute(AllDat_End,[3,2,1]));
        
        
        %% Whole freezing period
        sweeps = intervalSplit(Qs, FreezeEpoch, 'OffsetStart', Start(FreezeEpoch)*0);
        NeurRespWhole = sweeps;
        
        % matrix is time * neurons * trials
        clear AllDat_Whole
        for ep = 1:length(Start(FreezeEpoch))
            AllDat_Whole(ep,:,:) = interp1((Range(sweeps{ep})-min(Range(sweeps{ep})))/(range(Range(sweeps{ep}))),full(Data(sweeps{ep})),[0:0.1:1])';
        end
        NeurRespWholeNorm = tsd([0:0.1:1],permute(AllDat_Whole,[3,2,1]));
        
        
        %% Trigger on beeps
        if exist('LFPData/DigInfo1.mat')>0
            load('ExpeInfo.mat')
            CSPlusChan = load(['LFPData/DigInfo',num2str(find(strcmp(ExpeInfo.DigID,'CS+WN'))), '.mat']);
            PlusTimes = thresholdIntervals(CSPlusChan.DigTSD, 0.9, 'Direction','Above');
            CSMoinsChan = load(['LFPData/DigInfo',num2str(find(strcmp(ExpeInfo.DigID,'CS+WN'))), '.mat']);
            MinusTimes = thresholdIntervals(CSMoinsChan.DigTSD, 0.9, 'Direction','Above');

            % CS PLUS
            sweeps = intervalSplit(Qs_Tone, intervalSet(Start(PlusTimes)-BeepPer,Start(PlusTimes)+BeepPer), 'OffsetStart', Start(PlusTimes)*0);
            
            % matrix is time * neurons * trials
            clear AllDat_BeepPlus
            for ep = 1:length(Start(PlusTimes))
                AllDat_BeepPlus(ep,:,:) = full(Data(sweeps{ep}))';
            end
            NeurRespBeepPlus = tsd(Range(sweeps{1}),permute(AllDat_BeepPlus,[3,2,1]));
            
            % CS MINUS
            sweeps = intervalSplit(Qs_Tone, intervalSet(Start(MinusTimes)-BeepPer,Start(MinusTimes)+BeepPer), 'OffsetStart', Start(MinusTimes)*0);
            
            % matrix is time * neurons * trials
            clear AllDat_BeepMinus
            for ep = 1:length(Start(MinusTimes))
                AllDat_BeepMinus(ep,:,:) = full(Data(sweeps{ep}))';
            end
            NeurRespBeepMinus = tsd(Range(sweeps{1}),permute(AllDat_BeepMinus,[3,2,1]));
        else
            NeurRespBeepPlus = [];
            NeurRespBeepMinus = [];
            
        end
        
        Info.BefAfterFreeze = ArdFreezePer;
        Info.InsideFreeze = DurFreezePer;
        Info.FreezeEpochMerge = 2*1e4;
        Info.FreezeEpochDrop = NaN;
        Info.FreezeEpochDur = Stop(FreezeEpoch)-Start(FreezeEpoch);
        Info.Binsize = bi;
        Info.Units = 'ts';
        
        save TriggerNeuronOnFzPeriod.mat Info NeurRespWhole NeurRespWholeNorm NeurRespStart NeurRespEnd NeurRespBeepMinus NeurRespBeepPlus FreezingEpDur
        clear Info NeurRespWhole NeurRespWholeNorm NeurRespStart NeurRespEnd NeurRespBeepMinus NeurRespBeepPlus FreezingEpDur
        
    end
end




clear all
Dir = PathForExperimentFEAR('Fear-electrophy');

AllStartResp_FirstHalf = [];
AllStartResp_SecondHalf = [];
AllStopResp_FirstHalf = [];
AllStopResp_SecondHalf = [];
AllBeepResp_FirstHalf = [];
AllBeepResp_SecondHalf = [];
for mm=1:length(Dir.path)
    
    cd(Dir.path{mm})
    
    if exist('SpikeData.mat')>0
        load TriggerNeuronOnFzPeriod.mat
        temp = Data(NeurRespStart);
        temp = temp(:,:,FreezingEpDur>6);
        AllStartResp_FirstHalf = [AllStartResp_FirstHalf,nanmean(temp(:,:,1:2:end),3)];
        AllStartResp_SecondHalf= [AllStartResp_SecondHalf,nanmean(temp(:,:,2:2:end),3)];
        
        temp = Data(NeurRespEnd);
        temp = temp(:,:,FreezingEpDur>6);
        AllStopResp_FirstHalf = [AllStopResp_FirstHalf,nanmean(temp(:,:,1:2:end),3)];
        AllStopResp_SecondHalf= [AllStopResp_SecondHalf,nanmean(temp(:,:,2:2:end),3)];
        
        if not(isempty(NeurRespBeepPlus))
        temp = Data(NeurRespBeepPlus);
        AllBeepResp_FirstHalf = [AllBeepResp_FirstHalf,nanmean(temp(:,:,1:2:end),3)];
        AllBeepResp_SecondHalf= [AllBeepResp_SecondHalf,nanmean(temp(:,:,2:2:end),3)];
        end

        
    end
end

NanNum = sum(isnan(AllStartResp_FirstHalf)) + sum(isnan(AllStartResp_SecondHalf)) ;
AllStartResp_FirstHalf(:,NanNum>0) = [];
AllStartResp_SecondHalf(:,NanNum>0) = [];

NanNum = sum(isnan(AllStopResp_FirstHalf)) + sum(isnan(AllStopResp_SecondHalf)) ;
AllStopResp_FirstHalf(:,NanNum>0) = [];
AllStopResp_SecondHalf(:,NanNum>0) = [];

NanNum = sum(isnan(AllBeepResp_FirstHalf)) + sum(isnan(AllBeepResp_SecondHalf)) ;
AllBeepResp_FirstHalf(:,NanNum>0) = [];
AllBeepResp_SecondHalf(:,NanNum>0) = [];


