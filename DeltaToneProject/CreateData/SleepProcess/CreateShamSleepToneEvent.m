% CreateShamSleepToneEvent
% 05.10.2016 KJ
%
% Create sham event for basal records
% Restrict sounds to periods of stim (S2-S4) and use a refractory period
%
% params : 
%   - thD : determine the threshold for detection (*std)
%   - StimOnPeriods : intervalSet where sham are restricted
%   - pause_duration : minimum duration between two sham (refractory period)
%
%
% OUTPUT
%   ShamSleepEvent.mat :
%   - DeltaDetect
%   - SHAMtime
%   - SHAMtime_SWS
%   - SHAMtime_REM
%   - SHAMtime_Wake
%
% SEE
%   PlotShamVsToneObserver
%


Dir=PathForExperimentsRandomShamSpikes;

%params
pause_duration = 4*1E4;

for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    if exist('ShamSleepEventRandom.mat','file')==2
        continue
    end
    
%     try

        clearvars -except Dir p pause_duration

        %Epoch
        try
            load SleepScoring_OBGamma SWSEpoch Wake REMEpoch
        catch
            load StateEpochSB SWSEpoch Wake REMEpoch
        end
        %Session
        load IntervalSession Session2 Session4
        session_stim = union(Session2,Session4);
        %% Load LFP
        %PFCx
        load ChannelsToAnalyse/PFCx_deep
        try
            load ChannelsToAnalyse/PFCx_deltadeep
        catch
            load ChannelsToAnalyse/PFCx_deep
        end
        eval(['load LFPData/LFP',num2str(channel)])
        LFPdeep=LFP;
        clear LFP channel
        try
            load ChannelsToAnalyse/PFCx_deltasup
        catch
            load ChannelsToAnalyse/PFCx_sup
        end
        eval(['load LFPData/LFP',num2str(channel)])
        LFPsup=LFP;
        clear LFP channel


        %% Detection 
        % create diff signal
        EEGsleepDiff = ResampleTSD(tsd(Range(LFPdeep),Data(LFPdeep) - Data(LFPsup)),250);
        % crossing thresholds
        thresh_delta = 1000;
        all_cross_thresh = thresholdIntervals(EEGsleepDiff, thresh_delta, 'Direction', 'Above');


        %% sham event
        delta_detected = ts(Start(all_cross_thresh));
        delta_on_period = Range(Restrict(delta_detected, session_stim));

        sham_event = delta_on_period;
        sham_event = sham_event + rand(size(sham_event))*100;
        nb_delta_remaining = length(sham_event);

        %refractory period
        k=1;
        while k<=nb_delta_remaining
            delta_current = sham_event(k);
            sham_event(sham_event>delta_current & sham_event<delta_current+pause_duration)=[];
            nb_delta_remaining = length(sham_event);
            k = k+1;
        end


        %% save
        DeltaDetectSham = delta_detected;
        SHAMtime = ts(sham_event);
        SHAMtime_SWS = Restrict(SHAMtime, SWSEpoch);
        SHAMtime_REM = Restrict(SHAMtime, REMEpoch);
        SHAMtime_Wake = Restrict(SHAMtime, Wake);

        save ShamSleepEvent.mat DeltaDetectSham SHAMtime SHAMtime_SWS SHAMtime_REM SHAMtime_Wake thresh_delta

%     catch
%         disp('error for this record')
%     end


end





