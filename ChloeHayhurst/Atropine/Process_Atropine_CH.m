%% Process atropine tests

clear all; close all;

GetAtropineMice_CH

MouseToDo = 1500; % Change this to process the mouse you want
MouseName{1} = ['M' num2str(MouseToDo)];

%% Spectrums

for i = 1 : length(AtropineSess.(MouseName{1}))
    cd(AtropineSess.(MouseName{1}){1,i})
    disp(AtropineSess.(MouseName{1}){1,i})
    
    if exist('B_Low_Spectrum.mat')==0
        disp('calculating OB')
        clear channel
        load('ChannelsToAnalyse/Bulb_deep.mat')
        channel;
        LowSpectrumSB([cd filesep],channel,'B')
    end
    
    if exist('B_High_Spectrum.mat')==0
        disp('calculating OBhigh')
        clear channel
        try
            load('ChannelsToAnalyse/Bulb_gamma.mat')
        catch
            load('ChannelsToAnalyse/Bulb_deep.mat')
        end
        channel;
        HighSpectrum([cd filesep],channel,'B');
    end
    
    if exist('H_Low_Spectrum.mat')==0
        disp('calculating H')
        clear channel
        try,load('ChannelsToAnalyse/dHPC_rip.mat'), catch,
            try,load('ChannelsToAnalyse/dHPC_deep.mat'),
            catch
                try,load('ChannelsToAnalyse/dHPC_sup.mat'),
                end
            end
        end
        channel;
        LowSpectrumSB([cd filesep],channel,'H')
    end
    
    if exist('H_VHigh_Spectrum.mat')==0
        disp('calculating H_high')
        clear channel
        try,load('ChannelsToAnalyse/dHPC_rip.mat'), catch,
            try,load('ChannelsToAnalyse/dHPC_sup.mat'),
            catch
                try,load('ChannelsToAnalyse/dHPC_deep.mat'),
                end
            end
        end
        channel;
        VeryHighSpectrum([cd filesep],channel,'H')
    end
    
%     if exist('PFCx_Low_Spectrum.mat')==0
%         disp('calculating PFC')
%         clear channel
%         load('ChannelsToAnalyse/PFCx_deep.mat')
%         channel;
%         LowSpectrumSB([cd filesep],channel,'PFCx')
%     end
%     
end

    %% Epochs for OF
    for i = 1 : length(AtropineSess.(MouseName{1}))
        cd(AtropineSess.(MouseName{1}){1,i})
        disp(AtropineSess.(MouseName{1}){1,i})
        
        load('ExpeInfo.mat')
        
        if ExpeInfo.SleepSession==0
            
            load('ChannelsToAnalyse/Bulb_deep.mat')
            FindNoiseEpoch_BM([cd filesep],channel,0);
            
            % defining epochs and variables
            load('behavResources.mat')
            load('StateEpochSB.mat')
            smoofact_Acc = 30;
            NewMovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),smoofact_Acc));
            disp('Threshold for accelero')
            thresh = GetGaussianThresh_BM(Data(NewMovAcctsd)); close
            thtps_slow=1;
            th_slow_Acc = 10^(thresh);
            TotEpoch=intervalSet(0,max(Range(NewMovAcctsd)))-TotalNoiseEpoch;
            SlowAccEpoch=thresholdIntervals(NewMovAcctsd,th_slow_Acc,'Direction','Below');
            SlowAccEpoch=mergeCloseIntervals(SlowAccEpoch,0.5*1e4);
            SlowAccEpoch=dropShortIntervals(SlowAccEpoch,thtps_slow*1e4);
            SlowAccEpoch=and(SlowAccEpoch , TotEpoch);
            ActiveEpoch=TotEpoch-SlowAccEpoch;

            
            
            Behav.SlowAccEpoch = SlowAccEpoch;
            Behav.ActiveEpoch = ActiveEpoch;
            Params.Accelero_thresh = thresh;
            
            save('behavResources_SB.mat','Behav','Params')
            
            load('StateEpochSB.mat', 'Epoch')
            FindGammaEpoch(Epoch,54,3,[pwd filesep])
            
        else
                SleepScoring_Accelero_OBgamma
        end
        
        if (exist('ChannelsToAnalyse/EKG.mat')>0)
            MakeHeartRateForSession_BM
        end
        
        if ExpeInfo.SleepSession==1
            CreateRipplesSleep('scoring','accelero','stim',0,'restrict',1,'sleep',1)
        else
            CreateRipplesSleep('scoring','accelero','stim',0,'restrict',1,'sleep',0)
        end
    end


