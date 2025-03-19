function SleepScoreObOnly_Ferret(SS_base)
%%
% SS_base = '0.1-0.5'; % '0.1-0.5' or '1-8' (0.1-0.5Hz is a default now)

if exist('StateEpochSBAllOB.mat')~=2
    
    %% Parameters initialisation
    load('ChannelsToAnalyse/Bulb_deep.mat')
    chB = channel;
    
    filename=cd;
    if filename(end)~='/'
        filename(end+1)='/';
    end
    scrsz = get(0,'ScreenSize');
    
    load(['LFPData/LFP',num2str(chB),'.mat']);
    
    % defining total epoch
    r=Range(LFP);
    TotalEpoch=intervalSet(0*1e4,r(end));
    
    mindur_w=3; % min duration of wake episode
    ThetaI=[3 3]; %merge and drop
    mindur=3; %abs cut off for events;
    mw_dur=5; %max length of microarousal
    sl_dur=15; %min duration of sleep around microarousal
    ms_dur=10; % max length of microsleep
    wa_dur=20; %min duration of wake around microsleep
    smootime = 3; % smooth time from sleep scoring algo

    
%     minduration = 3; % bout min duration (from sleep scoring algo)
    
%     % new set up parameters , the 14th of june BM
%     mindur=30; %abs cut off for events;
%     mindur_w=3; % min duration of wake episode
%     ThetaI=[30 30]; %merge and drop
%     mw_dur=5; %max length of microarousal
%     sl_dur=15; %min duration of sleep around microarousal
%     ms_dur=10; % max length of microsleep
%     wa_dur=20; %min duration of wake around microsleep
%     minduration = 30; % bout min duration (from sleep scoring algo)
%     smootime = 30; % smooth time from sleep scoring algorithm
    
    %% Creating spectrums
    
    % Create OB High spectrum
    if exist('B_High_Spectrum.mat')==0
        HighSpectrum(filename,chB,'B');
        disp('High Bulb Spectrum done')
    end
    
    % Create Middle Spectrum
    if exist('B_Middle_Spectrum.mat')==0
        MiddleSpectrum_BM(filename,chB,'B');
        disp('Middle Bulb Spectrum done')
    end
    
    % Create OB Low spectrum
    if exist('B_Low_Spectrum.mat')==0
        LowSpectrumSB(filename,chB,'B');
        disp('Low Bulb Spectrum done')
    end

    % Create UltraLow Spectrum
    if exist('B_UltraLow_Spectrum.mat')==0
        UltraLowSpectrumBM(filename,chB,'B')
        disp('UltraLow Bulb Spectrum done')
    end
    
    %% Defining noise and epochs
    
%     if exist('StateEpochSB.mat')==0
%         ThreshEpoch=TotalEpoch;
%         FindNoiseEpoch_BM([cd filesep],channel,0);
%         load('StateEpochSB.mat')
%         ThreshEpoch = Epoch-TotalNoiseEpoch;
%     else
%         load('StateEpochSB.mat')
%         ThreshEpoch = Epoch-TotalNoiseEpoch;
%     end

% Added 09/10/2024 AG to complete SB SleepScoring
    if exist('SleepScoring_OBGamma.mat')==0
        ThreshEpoch=TotalEpoch;
        FindNoiseEpoch_BM([cd filesep],channel,0);
        load('SleepScoring_OBGamma.mat')
        ThreshEpoch = Epoch-TotalNoiseEpoch;
    else
        load('SleepScoring_OBGamma.mat')
        ThreshEpoch = Epoch-TotalNoiseEpoch;
    end
    
    %% Create gamma tsd and sleep epoch
    % output:
    %   sleeper - sleep epoch defined by gamma
    %   smooth_ghi - smooth gamma power
    %   gamma_thresh
    
%     FindGammaEpoch_AG(ThreshEpoch,chB,mindur_w,filename); % with ferret values, 40-60Hz
    
    %% SS. Here we now actually define SS epoch as Total Epoch - Noise. Should we restrict to sleep though? No, better not to. Otherwise it'll skip wake epochs on the full trace
%     load('StateEpochSB.mat', 'sleepper')
%     save('StateEpochSB.mat','chB','sleepper','-append')
      
    switch SS_base
        case '1-8'
            %% SleepScoring on OB 1-8 Hz
%             Find_1_8_Epoch(ThreshEpoch,ThetaI,chB,filename);
%             close all
%             
%             OBfrequency='_1_8';
%             
%             load('StateEpochSB.mat', 'OneEightEpoch', 'smooth_1_8', 'OneEight_thresh')
%             smooth_freq = smooth_1_8;
           
        case '0.1-0.5'
            %% SleepScoring on OB 0.1-0.5 Hz
            % output:
            %   Epoch_01_05 - sleep epoch defined by gamma
            %   smooth_01_05 - smooth gamma power
            %   thresh_01_05
            if exist('Epoch_01_05')==0
                Find_01_05_Epoch(ThreshEpoch,ThetaI,chB,filename);
                close all
            else
                disp('0.1-0.5 Epoch is already calculated. Loading...')
            end
            OBfrequency='_01_05';
            
            % Added 09/10/2024 AG to complete SB SleepScoring
            
%             load('StateEpochSB.mat', 'Epoch_01_05', 'smooth_01_05', 'thresh_01_05')
            load('SleepScoring_OBGamma.mat', 'Epoch_01_05', 'smooth_01_05', 'thresh_01_05')
            
            smooth_freq = smooth_01_05;
    end
%     name_to_use=strcat(filename,'StateEpochSB');
    name_to_use=strcat(filename,'SleepScoring_OBGamma');

    %%
    %     FindBehavEpochsAllOB_Ferret(TotalEpoch,mindur,mw_dur,sl_dur,ms_dur,wa_dur,filename,name_to_use)
    FindBehavEpochsAllOB_Ferret_AG(TotalEpoch,mindur,mw_dur,sl_dur,ms_dur,wa_dur,filename,name_to_use, SS_base)
    
    PlotEp=TotalEpoch;
    SleepScoreFigureAllOB_Ferret(filename,PlotEp,OBfrequency,name_to_use,smooth_freq, SS_base)
    close all
    
    %% Define immobility and mobility periods
    % [ImmobilityEpoch,MovementEpoch,tsdMovement,Info,microWakeEpoch,microSleepEpoch] = FindMovementAccelero_SleepScoring(Epoch);
    smootime = 3;
    load('behavResources.mat', 'MovAcctsd')
    NewMovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),ceil(smootime/median(diff(Range(MovAcctsd,'s'))))));
    
    disp('Accelerometer values distribution')
    
    thresh = GetGaussianThresh_BM(Data(NewMovAcctsd)); close
    th_immob_Acc = 10^(thresh);
    
    TotEpoch=intervalSet(0,max(Range(NewMovAcctsd)))-TotalNoiseEpoch;
    FreezeAccEpoch=thresholdIntervals(NewMovAcctsd,th_immob_Acc,'Direction','Below');
    FreezeAccEpoch=mergeCloseIntervals(FreezeAccEpoch,mindur*1e4);
    FreezeAccEpoch=dropShortIntervals(FreezeAccEpoch,mindur*1e4);
    ImmobilityEpoch=and(FreezeAccEpoch , TotEpoch);
    MovingEpoch=TotEpoch-ImmobilityEpoch;
    Immobility_thresh = th_immob_Acc;
    
    save('StateEpochSB', 'ImmobilityEpoch', 'MovingEpoch', 'Immobility_thresh' ,  '-append');
    
end

