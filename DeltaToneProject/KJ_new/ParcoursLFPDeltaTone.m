%ParcoursLFPDeltaTone
% 19.09.2016 KJ
%
% LFP mean curves synchronized on tones
%   - plot event triggered correlogram
%   - save them


Dir=PathForExperimentsDeltaIDfigures;

%% params
binsize=10;  %for mua
durations = [-1000 1000];

%% MUA for DeltaTone
for p=1:length(Dir.path)
    if strcmpi(Dir.condition{p},'DeltaTone')
        disp(' ')
        disp('****************************************************************')
        eval(['cd(Dir.path{',num2str(p),'}'')'])
        disp(pwd)   
        
        %% load
        %epoch
        load StateEpochSB SWSEpoch Wake
        %lfp
        load ChannelsToAnalyse/PFCx_deep
        eval(['load LFPData/LFP',num2str(channel)])
        LFPdeep=LFP;
        clear LFP
        load ChannelsToAnalyse/PFCx_sup
        eval(['load LFPData/LFP',num2str(channel)])
        LFPsup=LFP;
        clear LFP
        clear channel
        %tones
        load('DeltaSleepEvent.mat', 'TONEtime2')
        delay = Dir.delay{p}*1E4; %in 1E-4s
        ToneEvent = Restrict(ts(TONEtime2 + delay),SWSEpoch);
        nb_tones = length(ToneEvent);
 
        %deep
        [~, ~] = PlotEventTriggeredCorrelogram(LFPdeep, ToneEvent, durations, 'smooth', [0.7 0.7], 'pmax', 0.1);
        suplabel(['LFP deep on tones - ' Dir.title{p}],'t');
    
        cd('/home/mobsjunior/Dropbox/Kteam/Projets KarimJr/Projet Delta/Figures Projet DeltaFeedback/KJ/New')
        savefig(['ParcoursLFPdeepDeltaTone - ' Dir.title{p}])
        close all
        
        %sup
        [~, ~] = PlotEventTriggeredCorrelogram(LFPsup, ToneEvent, durations, 'smooth', [0.7 0.7], 'pmax', 0.1);
        suplabel(['LFP sup on tones - ' Dir.title{p}],'t');
    
        cd('/home/mobsjunior/Dropbox/Kteam/Projets KarimJr/Projet Delta/Figures Projet DeltaFeedback/KJ/New')
        savefig(['ParcoursLFPsupDeltaTone - ' Dir.title{p}])
        close all
        
        %sup
        k=1;
        for i=0.1:0.1:4
            distance(k)=std(Data(LFPdeep)-i*Data(LFPsup));
            k=k+1;
        end
        Factor=find(distance==min(distance))*0.1;
        LFPdiff = tsd(Range(LFPdeep),Data(LFPdeep) - Factor*Data(LFPsup));
        [~, ~] = PlotEventTriggeredCorrelogram(LFPdiff, ToneEvent, durations, 'smooth', [0.7 0.7], 'pmax', 0.1);
        suplabel(['LFP diff on tones - ' Dir.title{p}],'t');
    
        cd('/home/mobsjunior/Dropbox/Kteam/Projets KarimJr/Projet Delta/Figures Projet DeltaFeedback/KJ/New')
        savefig(['ParcoursLFPdiffDeltaTone - ' Dir.title{p}])
        close all
        

    end
end

