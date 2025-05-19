clear all

% options
smootime = 3;
minduration = 3; %abs cut off for events;
Frequency{1} = [5 10];
Frequency{2} = [2 5];

% Get folder names
DataLocation = '/media/nas8/ProjetPFCVLPO/';
Dates = {'17042021','17042026'};
SessionName = {'Sleep_PreSDS','Sleep_PostSDS'};


% loop on both sessions
for ss = 1:length(SessionName)
    % loop on mice
    for mousenum = 2:4
        
        DirectoryToUse = [DataLocation,'M', num2str(mousenum),filesep,Dates{ss},filesep,SessionName{ss}];
        cd(DirectoryToUse)
        
        %% Get EMG threshold on pre SDS
        load('LFPData/LFP1.mat')
        Epoch = intervalSet(0,max(Range(LFP)));
        LFP = FilterLFP(LFP,[10 49],256);
        EMGData=tsd(Range(LFP),runmean(Data((LFP)).^2,(ceil(smootime/median(diff(Range(LFP,'s')))))));
        if ss == 1
            EMG_thresh = exp(GetGammaThresh(Data(EMGData)));
        elseif ss == 2
            load([DataLocation,'M', num2str(mousenum),filesep,Dates{1},filesep,SessionName{1},'SleepScoring_EMG.mat'],'Info')
            EMG_thresh = Info.EMG_thresh;
        end
        
        %% Offer manual correction
        SleepEpoch_all = thresholdIntervals(EMGData, EMG_thresh, 'Direction','Below');
        SleepEpoch = mergeCloseIntervals(SleepEpoch_all, minduration*1e4);
        SleepEpoch = dropShortIntervals(SleepEpoch, minduration*1e4);
        happy = 0;
        figure
        while happy==0
            
            subplot(311)
            plot(Range(EMGData,'s'),Data(EMGData))
            hold on
            plot(Range(Restrict(EMGData,SleepEpoch),'s'),Data(Restrict(EMGData,SleepEpoch)))
            line(xlim,[EMG_thresh EMG_thresh])
            ylabel('EMG')
            title('EMG linear scale')
            
            subplot(312)
            plot(Range(EMGData,'s'),Data(EMGData))
            hold on
            plot(Range(Restrict(EMGData,SleepEpoch),'s'),Data(Restrict(EMGData,SleepEpoch)))
            line(xlim,[EMG_thresh EMG_thresh])
            ylabel('EMG')
            title('EMG log scale')
            set(gca,'YScale','log')

            subplot(313)
            nhist(log(Data(EMGData)))
            hold on
            line(log([EMG_thresh EMG_thresh]),ylim)
            happy = input('are you happy? 0/1');
            if happy ==0
                subplot(312)
                [~,EMG_thresh] = ginput(1);
                SleepEpoch_all = thresholdIntervals(EMGData, EMG_thresh, 'Direction','Below');
                SleepEpoch = mergeCloseIntervals(SleepEpoch_all, minduration*1e4);
                SleepEpoch = dropShortIntervals(SleepEpoch, minduration*1e4);
                clf
            end
        end
        
        close all
        
        %% Get sleep vs wake
        % define sleep epoch
        SleepEpoch_all = thresholdIntervals(EMGData, EMG_thresh, 'Direction','Below');
        SleepEpoch = mergeCloseIntervals(SleepEpoch_all, minduration*1e4);
        SleepEpoch = dropShortIntervals(SleepEpoch, minduration*1e4);
        
        % defining micro wake and sleep (< 3s; added by SL: 2021-05;2021-10 (3s instead of 2s))
        SleepEpoch_drop = dropShortIntervals(and(SleepEpoch_all,SleepEpoch), minduration*1e4);
        microWakeEpoch = SleepEpoch - SleepEpoch_drop;
        Wake_all = Epoch-SleepEpoch;
        Wake_drop = dropShortIntervals(Wake_all, minduration*1e4);
        microSleepEpoch = Wake_all - Wake_drop;
        
        Info.EMG_thresh      = EMG_thresh;
        Info.EMG_minduration = minduration;
        
        save('SleepScoring_EMG.mat','Info')
        
        %% Get theta Epoch
        load('LFPData/LFP3.mat')
        FilTheta = FilterLFP(LFP,Frequency{1},1024);
        FilDelta = FilterLFP(LFP,Frequency{2},1024);
        hilbert_theta = abs(hilbert(Data(FilTheta)));
        hilbert_delta = abs(hilbert(Data(FilDelta)));
        theta_ratio = runmean(hilbert_theta,200) ./ runmean(hilbert_delta,200);
        ThetaRatioTSD = tsd(Range(FilTheta), theta_ratio);
        
        % smooth Theta / delta ratio
        SmoothTheta = tsd(Range(ThetaRatioTSD),runmean(Data(ThetaRatioTSD),ceil(smootime/median(diff(Range(ThetaRatioTSD,'s'))))));
        
        % Get threshold
        log_theta = log(Data(Restrict(SmoothTheta,SleepEpoch)));
        
        theta_thresh = exp(GetThetaThresh(log_theta, 1, 1));
        
        % define high theta epochs
        ThetaEpoch = thresholdIntervals(SmoothTheta, theta_thresh, 'Direction','Above');
        Info.theta_thresh = theta_thresh;
        
        %% Get all epochs
        [REMEpoch,SWSEpoch,Wake,REMEpochWiNoise, SWSEpochWiNoise, WakeWiNoise] = ...
            ScoreEpochs_SleepScoring(intervalSet(0,1*1e4), Epoch, SleepEpoch, ThetaEpoch, minduration,SmoothTheta,Info);
        SleepWiNoise = or(REMEpochWiNoise,SWSEpochWiNoise)
        Sleep = or(REMEpoch,SWSEpoch);
        
        disp(' >>>  Saving EMG sleep stages  <<<')
        save('SleepScoring_EMG','REMEpoch','SWSEpoch','Wake','REMEpochWiNoise', ...
            'SWSEpochWiNoise', 'WakeWiNoise','Sleep','SleepWiNoise', ...
            'ThetaEpoch','SmoothTheta','Info',...
            'Epoch','microWakeEpoch','microSleepEpoch','EMGData');
        
        Figure_SleepScoring_EMG(1, cd)
        
    end
end