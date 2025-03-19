% CreateSignalsIDFigures2
% 12.09.2016 KJ
%
% Detect and save sleep events:
%   - Down states       (newDownState.mat Down)
%   - Ripples           (newRipHPC.mat Ripples_tmp)
%   - Delta waves PFCx  (DeltaPFCx.mat DeltaOffline)
%   - Delta waves PaCx  (DeltaPaCx.mat DeltaOffline)
%   - Delta waves MoCx  (DeltaMoCx.mat DeltaOffline)
%
%
% see CreateSignalsIDFigures 


Dir=PathForExperimentsDeltaIDfigures;

%params
freqDelta = [1 6];
thD = 2;
minDeltaDuration = 50;
binsize=10;
thresh0 = 0.7;
minDownDur = 90;
maxDownDur = 500;
mergeGap = 10; % merge
predown_size = 50;
thresh_rip = [5 7];
duration_rip = [30 30 100];

for p=1:length(Dir.path)
    try
        disp(' ')
        disp('****************************************************************')
        eval(['cd(Dir.path{',num2str(p),'}'')'])
        disp(pwd)

        %Epoch and Spikes
        load StateEpochSB SWSEpoch Wake REMEpoch
        load SpikeData
        try
            eval('load SpikesToAnalyse/PFCx_down')
        catch
            eval('load SpikesToAnalyse/PFCx_Neurons')
        end
        NumNeurons=number;
        clear number
   
        %% Down states
        T=PoolNeurons(S,NumNeurons);
        ST{1}=T;
        try
            ST=tsdArray(ST);
        end
        Q = MakeQfromS(ST,binsize*10); %binsize*10 to be in E-4s
        MUA = Q;
        Q = Restrict(Q, SWSEpoch);
        %Down
        [Down, small_Down] = FindDown2_KJ(Q, 'low_thresh', thresh0, 'minDuration', minDownDur,'maxDuration', maxDownDur, 'mergeGap', mergeGap, 'predown_size', predown_size, 'method', 'mono');
        
        try
            delete('newDownState.mat')
        end
        save newDownState.mat Down
        
        %% Ripples
        load ChannelsToAnalyse/dHPC_rip
        eval(['load LFPData/LFP',num2str(channel)])
        HPCrip=LFP;
        clear LFP
        [Ripples_tmp,usedEpoch] = FindRipplesKarimSB(HPCrip,SWSEpoch,thresh_rip,duration_rip);
        save newRipHPC.mat Ripples_tmp
        
        %% PFCx Delta
        load ChannelsToAnalyse/PFCx_deep
        eval(['load LFPData/LFP',num2str(channel)])
        LFPdeep=LFP;
        clear LFP
        load ChannelsToAnalyse/PFCx_sup
        eval(['load LFPData/LFP',num2str(channel)])
        LFPsup=LFP;
        clear LFP
        k=1;
        for i=0.1:0.1:4
            distance(k)=std(Data(LFPdeep)-i*Data(LFPsup));
            k=k+1;
        end
        Factor=find(distance==min(distance))*0.1;
        EEGsleepDiff=ResampleTSD(tsd(Range(LFPdeep),Data(LFPdeep) - Factor*Data(LFPsup)),100);
        Filt_diff = FilterLFP(EEGsleepDiff, freqDelta, 1024);
        pos_filtdiff = max(Data(Filt_diff),0);
        std_diff = std(pos_filtdiff(pos_filtdiff>0));  % std that determines thresholds

        % deltas
        thresh_delta = thD * std_diff;
        all_cross_thresh = thresholdIntervals(tsd(Range(Filt_diff), pos_filtdiff), thresh_delta, 'Direction', 'Above');
        DeltaOffline = dropShortIntervals(all_cross_thresh, minDeltaDuration * 10); % crucial element for noise detection.
        
        try
            delete('DeltaPFCx.mat')
        end
        save DeltaPFCx.mat DeltaOffline
        
%         
%         %% PaCx Delta
%         clear LFPdeep
%         clear LFPsup
%         clear distance
%         load ChannelsToAnalyse/PaCx_deep
%         eval(['load LFPData/LFP',num2str(channel)])
%         LFPdeep=LFP;
%         clear LFP
%         load ChannelsToAnalyse/PaCx_sup
%         eval(['load LFPData/LFP',num2str(channel)])
%         LFPsup=LFP;
%         clear LFP
%         k=1;
%         for i=0.1:0.1:4
%             distance(k)=std(Data(LFPdeep)-i*Data(LFPsup));
%             k=k+1;
%         end
%         Factor=find(distance==min(distance))*0.1;
%         EEGsleepDiff=ResampleTSD(tsd(Range(LFPdeep),Data(LFPdeep) - Factor*Data(LFPsup)),100);
%         Filt_diff = FilterLFP(EEGsleepDiff, freqDelta, 1024);
%         pos_filtdiff = max(Data(Filt_diff),0);
%         std_diff = std(pos_filtdiff(pos_filtdiff>0));  % std that determines thresholds
% 
%         % deltas
%         thresh_delta = thD * std_diff;
%         all_cross_thresh = thresholdIntervals(tsd(Range(Filt_diff), pos_filtdiff), thresh_delta, 'Direction', 'Above');
%         DeltaOffline = dropShortIntervals(all_cross_thresh, minDeltaDuration * 10); % crucial element for noise detection.
%         
%         try
%             delete('DeltaPaCx.mat')
%         end
%         save DeltaPaCx.mat DeltaOffline
        
        
%         %% MoCx Delta
%         clear LFPdeep
%         clear LFPsup
%         clear distance
%         load ChannelsToAnalyse/MoCx_deep
%         eval(['load LFPData/LFP',num2str(channel)])
%         LFPdeep=LFP;
%         clear LFP
%         load ChannelsToAnalyse/MoCx_sup
%         eval(['load LFPData/LFP',num2str(channel)])
%         LFPsup=LFP;
%         clear LFP
%         k=1;
%         for i=0.1:0.1:4
%             distance(k)=std(Data(LFPdeep)-i*Data(LFPsup));
%             k=k+1;
%         end
%         Factor=find(distance==min(distance))*0.1;
%         EEGsleepDiff=ResampleTSD(tsd(Range(LFPdeep),Data(LFPdeep) - Factor*Data(LFPsup)),100);
%         Filt_diff = FilterLFP(EEGsleepDiff, freqDelta, 1024);
%         pos_filtdiff = max(Data(Filt_diff),0);
%         std_diff = std(pos_filtdiff(pos_filtdiff>0));  % std that determines thresholds
% 
%         % deltas
%         thresh_delta = thD * std_diff;
%         all_cross_thresh = thresholdIntervals(tsd(Range(Filt_diff), pos_filtdiff), thresh_delta, 'Direction', 'Above');
%         DeltaOffline = dropShortIntervals(all_cross_thresh, minDeltaDuration * 10); % crucial element for noise detection.
%         
%         try
%             delete('DeltaMoCx.mat')
%         end
%         save DeltaMoCx.mat DeltaOffline
        
        
    end
end


