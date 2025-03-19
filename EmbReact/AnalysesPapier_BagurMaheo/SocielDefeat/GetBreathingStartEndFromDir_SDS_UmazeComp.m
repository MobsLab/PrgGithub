function Out = GetBreathingStartEndFromDir_SDS_UmazeComp(Dir)

cd(Dir)
if exist('B_High_Spectrum.mat')
    
    %% Get freezing
    load('behavResources.mat', 'MovAcctsd')
    thtps_immob = 2;
    th_immob_Acc = 1.7e7;
    smoofact_Acc = 30;
    NewMovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),smoofact_Acc));
    FreezeAccEpoch=thresholdIntervals(NewMovAcctsd,th_immob_Acc,'Direction','Below');
    FreezeAccEpoch=mergeCloseIntervals(FreezeAccEpoch,0.3*1e4);
    FreezeAccEpoch=dropShortIntervals(FreezeAccEpoch,thtps_immob*1e4);
    
    % Beginning vs end
    MaxTime = max(Range(NewMovAcctsd,'s'));
    Half1 = intervalSet(0,MaxTime/2*1e4);
    Half2 = intervalSet(MaxTime*1e4/2,MaxTime*1e4);
    
    Out.FzTime1 = sum(Stop(and(FreezeAccEpoch,Half1),'s') - Start(and(FreezeAccEpoch,Half1),'s'));
    Out.FzTime2 = sum(Stop(and(FreezeAccEpoch,Half2),'s') - Start(and(FreezeAccEpoch,Half2),'s'));
    
    
    if sum(Stop(FreezeAccEpoch)-Start(FreezeAccEpoch))>0
        
        try
            load('StateEpochSB.mat','TotalNoiseEpoch')
            TotalNoiseEpoch
        catch
            disp('no noise')
            keyboard
            
            load('StateEpochSB.mat','TotalNoiseEpoch')
            
        end
        TotalNoiseEpoch = CleanUpEpoch(TotalNoiseEpoch);
        FreezeAccEpoch = FreezeAccEpoch-TotalNoiseEpoch;
        
        
        %% Get respi frequency
        OB_Low = load('Bulb_deep_Low_Spectrum.mat');
        OB_Low_Sptsd = tsd(OB_Low.Spectro{2}*1e4 , OB_Low.Spectro{1});
        if sum(Stop(and(FreezeAccEpoch,Half1))-Start(and(FreezeAccEpoch,Half1)))>0
            Out.OBSpec_Lo1 = nanmean(Data(Restrict(OB_Low_Sptsd , and(FreezeAccEpoch,Half1))));
        else
            Out.OBSpec_Lo1 = nanmean(1,249);
        end
        if sum(Stop(and(FreezeAccEpoch,Half2))-Start(and(FreezeAccEpoch,Half2)))>0
            Out.OBSpec_Lo2 = nanmean(Data(Restrict(OB_Low_Sptsd , and(FreezeAccEpoch,Half2))));
        else
            Out.OBSpec_Lo2  = nanmean(1,249);
        end
        
    else
        disp('no freezing')
        
        Out.FzTime1 = NaN;
        Out.FzTime2 = NaN;
        Out.OBSpec_Lo1 = nan(1,249);
        Out.OBSpec_Lo2 = nan(1,249);
        
    end
else
    disp('problem')
    
    Out.FzTime1 = NaN;
    Out.FzTime2 = NaN;
    Out.OBSpec_Lo1 = nan(1,249);
    Out.OBSpec_Lo2 = nan(1,249);
    
end