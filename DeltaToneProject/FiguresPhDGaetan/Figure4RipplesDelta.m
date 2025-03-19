% Figure4RipplesDelta
% 10.12.2016 KJ
%
% Collect data to plot the figures from the Figure4.pdf of Gaetan PhD
% 
% 
%   see Figure4RipplesDeltaPlot
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

%Dir with spikes
Dir_spikes1 = PathForExperimentsDeltaSleepSpikes('Basal');
Dir_spikes2 = PathForExperimentsDeltaSleepSpikes('RdmTone');
Dir_spikes3 = PathForExperimentsDeltaSleepSpikes('DeltaToneAll');
Dir_spikes = MergePathForExperiment(Dir_spikes1,Dir_spikes2);
Dir_spikes = MergePathForExperiment(Dir_spikes,Dir_spikes3);
Dir = IntersectPathForExperiment(Dir,Dir_spikes);

clear Dir1 Dir2 Dir3 Dir_spikes Dir_spikes1 Dir_spikes2 Dir_spikes3



%params
substage_ind=1:6;
binsize_cc = 100; %10ms
nbins_cc = 100;
predown_window = 5000; %500ms
postripples_window = 1800; %180

%extract data from figure 7 res
load([FolderProjetDelta 'Data/Figure7StimEffectSleepStructure.mat']) 
figure4_res.ripples = figure7_res.ripples;
figure4_res.down = figure7_res.down;
figure4_res.delta = figure7_res.delta;
clear figure7_res


for p=1:length(Dir.path)
%     try
        disp(' ')
        disp('****************************************************************')
        eval(['cd(Dir.path{',num2str(p),'}'')'])
        disp(pwd)
        figure4_res.path{p}=Dir.path{p};
        figure4_res.manipe{p}=Dir.manipe{p};
        figure4_res.delay{p}=Dir.delay{p};
        figure4_res.name{p}=Dir.name{p};
       
        %% Load
        
        %Epoch
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
        
        %Down states
        try
            load newDownState Down
        catch
            try
                load DownSpk Down
            catch
                Down = intervalSet([],[]);
            end
        end
        start_down = Start(Down);
        end_down = End(Down);
        nb_down = length(start_down);
        
        %Ripples
        load newRipHPC Ripples_tmp
        ripples_center = Ripples_tmp(:,2)*1E4;
        tRipples = ts(ripples_center);
        
        %Substages and stages
        clear op NamesOp Dpfc Epoch noise
        load NREMepochsML.mat op NamesOp Dpfc Epoch noise
        disp('Loading epochs from NREMepochsML.m')
        [Substages,NamesSubstages]=DefineSubStages(op,noise);
        %Session
        load IntervalSession
        sessions{1}=Session1;sessions{2}=Session2;sessions{3}=Session3;sessions{4}=Session4;sessions{5}=Session5;
        
        
        %% Correction : down not preceeded by another down, in a time window
        predown_intervals = [start_down-predown_window start_down];
        [~,interval,~] = InIntervals(start_down,predown_intervals);
        interval(interval==0)=[];
        interval=unique(interval);
        start_down_alone = start_down(~ismember(1:length(start_down),interval));
        
        predown_intervals = [end_down-predown_window end_down];
        [~,interval,~] = InIntervals(end_down,predown_intervals);
        interval(interval==0)=[];
        interval=unique(interval);
        end_down_alone = end_down(~ismember(1:length(end_down),interval));
        
        
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
        %% ON WHOLE NIGHT
        
        %% Correlogram
        %delta onset
        Cc_delta_onset = CrossCorr(ts(start_delta), tRipples, binsize_cc, nbins_cc);        
        %delta offset
        Cc_delta_offset = CrossCorr(ts(end_delta), tRipples, binsize_cc, nbins_cc);
        %down onset
        Cc_down_onset = CrossCorr(ts(start_down), tRipples, binsize_cc, nbins_cc);        
        %down offset
        Cc_down_offset = CrossCorr(ts(end_down), tRipples, binsize_cc, nbins_cc);
        %down onset
        Cc_down_corrected_onset = CrossCorr(ts(start_down_alone), tRipples, binsize_cc, nbins_cc);        
        %down offset
        Cc_down_corrected_offset = CrossCorr(ts(end_down_alone), tRipples, binsize_cc, nbins_cc);
        
        %save
        figure4_res.all.correlogram.delta.onset{p} = Cc_delta_onset;
        figure4_res.all.correlogram.delta.offset{p} = Cc_delta_offset;
        figure4_res.all.correlogram.down.onset{p} = Cc_down_onset;
        figure4_res.all.correlogram.down.offset{p} = Cc_down_offset;
        figure4_res.all.correlogram.down_corr.onset{p} = Cc_down_corrected_onset;
        figure4_res.all.correlogram.down_corr.offset{p} = Cc_down_corrected_offset;
        
        figure4_res.all.number.delta(p) = nb_delta;
        figure4_res.all.number.down(p) = nb_down;
        figure4_res.all.number.down_corr.onset(p) = length(start_down_alone);
        figure4_res.all.number.down_corr.offset(p) = length(end_down_alone);
        
        %% Number of SPW-Rs followed by delta
        postripples_intervals = [ripples_center ripples_center+postripples_window];
        [status,interval,~] = InIntervals(start_delta,postripples_intervals);
        nb_delta_ripped = sum(status);
        nb_delta_nonripped = sum(~status);
        
        figure4_res.all.number.delta_ripped(p) = nb_delta_ripped;
        figure4_res.all.number.delta_alone(p) = nb_delta_nonripped;

        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
        %% PER SESSION
        
        for s=1:length(sessions)
            %delta onset
            Cc_delta_onset = CrossCorr(Restrict(ts(start_delta),sessions{s}), tRipples, binsize_cc, nbins_cc);        
            %delta offset
            Cc_delta_offset = CrossCorr(Restrict(ts(end_delta),sessions{s}), tRipples, binsize_cc, nbins_cc);
            %down onset
            Cc_down_onset = CrossCorr(Restrict(ts(start_down),sessions{s}), tRipples, binsize_cc, nbins_cc);        
            %down offset
            Cc_down_offset = CrossCorr(Restrict(ts(end_down),sessions{s}), tRipples, binsize_cc, nbins_cc);
            %down onset
            Cc_down_corrected_onset = CrossCorr(Restrict(ts(start_down_alone),sessions{s}), tRipples, binsize_cc, nbins_cc);        
            %down offset
            Cc_down_corrected_offset = CrossCorr(Restrict(ts(end_down_alone),sessions{s}), tRipples, binsize_cc, nbins_cc);
            
            %save
            figure4_res.session.correlogram.delta.onset{p,s} = Cc_delta_onset;
            figure4_res.session.correlogram.delta.offset{p,s} = Cc_delta_offset;
            figure4_res.session.correlogram.down.onset{p,s} = Cc_down_onset;
            figure4_res.session.correlogram.down.offset{p,s} = Cc_down_offset;
            figure4_res.session.correlogram.down_corr.onset{p,s} = Cc_down_corrected_onset;
            figure4_res.session.correlogram.down_corr.offset{p,s} = Cc_down_corrected_offset;

            figure4_res.session.number.delta(p,s) = length(Restrict(ts(start_delta),sessions{s}));
            figure4_res.session.number.down(p,s) = length(Restrict(ts(start_down),sessions{s}));
            figure4_res.session.number.down_corr.onset(p,s) = length(Restrict(ts(start_down_alone),sessions{s}));
            figure4_res.session.number.down_corr.offset(p,s) = length(Restrict(ts(end_down_alone),sessions{s}));
        end
        
        %% Number of SPW-Rs followed by delta
        for s=1:length(sessions)
            ripples_session = Range(Restrict(tRipples,sessions{s}));
            postripples_intervals = [ripples_session ripples_session+postripples_window];
            [status,interval,~] = InIntervals(start_delta,postripples_intervals);
            nb_delta_ripped = sum(status);
            nb_delta_nonripped = length(Restrict(ts(start_delta),sessions{s})) - nb_delta_ripped;

            figure4_res.session.number.delta_ripped(p,s) = nb_delta_ripped;
            figure4_res.session.number.delta_alone(p,s) = nb_delta_nonripped;
        end
        
        
%     catch
%         disp('error for this record')
%     end
end
        

%saving data
cd([FolderProjetDelta 'Data/']) 
save Figure4RipplesDelta.mat figure4_res substage_ind binsize_cc nbins_cc predown_window
        










        