% CorrelationDeltaRipplesTone
% 11.12.2016 KJ
%
% Inspired from Figure4RipplesDelta, continuing of the analysis between
% delta waves and SPW-Rs
% 
% 
%   see Figure4RipplesDelta CorrelationDeltaRipplesTonePlot CorrelationDeltaRipplesTonePlotSession
%


Dir1 = PathForExperimentsDeltaWavesTone('Basal');
for p=1:length(Dir1.path)
    Dir1.delay{p}=0;
end
Dir2=PathForExperimentsDeltaWavesTone('RdmTone');
Dir3=PathForExperimentsDeltaWavesTone('DeltaToneAll');
Dir = MergePathForExperiment(Dir2,Dir3);
Dir = MergePathForExperiment(Dir1,Dir);

% Dir1 = PathForExperimentsDeltaKJHD('Basal');
% for p=1:length(Dir1.path)
%     Dir1.delay{p}=0;
% end
% Dir2 = PathForExperimentsDeltaKJHD('RdmTone');
% Dir3 =PathForExperimentsDeltaKJHD('DeltaToneAll');
% Dir = MergePathForExperiment(Dir2,Dir3);
% Dir = MergePathForExperiment(Dir1,Dir);

clear Dir1 Dir2 Dir3


%params
binsize_cc = 100; %10ms
nbins_cc = 100;
postripples_window = 1800; %180

%extract data from figure 7 res
load([FolderProjetDelta 'Data/Figure7StimEffectSleepStructure.mat']) 
deltarip_res.ripples = figure7_res.ripples;
deltarip_res.delta = figure7_res.delta;
clear figure7_res



for p=1:length(Dir.path)
%     try
        disp(' ')
        disp('****************************************************************')
        eval(['cd(Dir.path{',num2str(p),'}'')'])
        disp(pwd)
        deltarip_res.path{p}=Dir.path{p};
        deltarip_res.manipe{p}=Dir.manipe{p};
        deltarip_res.delay{p}=Dir.delay{p};
        deltarip_res.name{p}=Dir.name{p};
       
        %% Load
        
        %Epoch and Spikes
        load StateEpochSB SWSEpoch Wake REMEpoch
        
        %Delta waves
        try
            load DeltaPFCx DeltaOffline
        catch
            load newDeltaPFCx DeltaEpoch
            DeltaOffline = DeltaEpoch;
            clear DeltaEpoch
        end
        start_delta = Start(DeltaOffline);
        end_delta = End(DeltaOffline);
        nb_delta = length(start_delta);
        
        %Ripples
        load newRipHPC Ripples_tmp
        ripples_center = Ripples_tmp(:,2)*1E4;
        tRipples = ts(ripples_center);
        
        %Tones/Shams
        try
            load('DeltaSleepEvent.mat', 'TONEtime1')
            delay = Dir.delay{p}*1E4; %in 1E-4s
            tEvents = ts(TONEtime1 + delay);
            with_tone=1;
        catch
            load('ShamSleepEvent.mat', 'SHAMtime')
            delay = 0;
            tEvents = ts(Range(SHAMtime) + delay);
            with_tone=0;
        end
        nb_events = length(tEvents);
        
        %Session
        load IntervalSession
        sessions{1}=Session1;sessions{2}=Session2;sessions{3}=Session3;sessions{4}=Session4;sessions{5}=Session5;
        
        %% Couples SPW-Rs Delta
        postripples_intervals = [ripples_center ripples_center+postripples_window];
        [status,interval,~] = InIntervals(start_delta,postripples_intervals);
        ripdelta = start_delta(status);
        delta_alone = start_delta(~status);
        nb_delta_ripped = length(ripdelta);
        nb_delta_nonripped = length(delta_alone);

        
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
        %% ON WHOLE NIGHT
        
        %% Correlogram
        %delta onset
        Cc_delta_onset = CrossCorr(ts(start_delta), tRipples, binsize_cc, nbins_cc);        
        %delta offset
        Cc_delta_offset = CrossCorr(ts(end_delta), tRipples, binsize_cc, nbins_cc);
        %ripples_delta vs tones
        Cc_event_deltarip = CrossCorr(tEvents, ts(ripdelta), binsize_cc, nbins_cc);
        
        
        %save
        deltarip_res.all.correlogram.delta.onset{p} = Cc_delta_onset;
        deltarip_res.all.correlogram.delta.offset{p} = Cc_delta_offset;
        deltarip_res.all.correlogram.event.deltarip{p} = Cc_event_deltarip;
        
        deltarip_res.all.number.delta(p) = nb_delta;
        deltarip_res.all.number.event(p) = nb_events;
        
        

        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
        %% PER SESSION
        
        for s=1:length(sessions)
            %delta onset
            Cc_delta_onset = CrossCorr(Restrict(ts(start_delta),sessions{s}), tRipples, binsize_cc, nbins_cc);        
            %delta offset
            Cc_delta_offset = CrossCorr(Restrict(ts(end_delta),sessions{s}), tRipples, binsize_cc, nbins_cc);
            %ripples_delta vs tones
            Cc_event_deltarip = CrossCorr(Restrict(tEvents,sessions{s}), ts(ripdelta), binsize_cc, nbins_cc);
            
            %save
            deltarip_res.session.correlogram.delta.onset{p,s} = Cc_delta_onset;
            deltarip_res.session.correlogram.delta.offset{p,s} = Cc_delta_offset;
            deltarip_res.session.correlogram.event.deltarip{p,s} = Cc_event_deltarip;

            deltarip_res.session.number.delta(p,s) = length(Restrict(ts(start_delta),sessions{s}));
            deltarip_res.session.number.event(p,s) = length(Restrict(tEvents,sessions{s}));

        end
        
        %% Number of SPW-Rs followed by delta
        for s=1:length(sessions)
            nb_delta_ripped = length(Restrict(ts(ripdelta),sessions{s}));
            nb_delta_nonripped = length(Restrict(ts(start_delta),sessions{s})) - nb_delta_ripped;

            deltarip_res.session.number.delta_ripped(p,s) = nb_delta_ripped;
            deltarip_res.session.number.delta_alone(p,s) = nb_delta_nonripped;
        end
        
end


%saving data
cd([FolderProjetDelta 'Data/']) 
save CorrelationDeltaRipplesTone.mat deltarip_res binsize_cc nbins_cc postripples_window
        
