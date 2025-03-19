%ParcoursMUADeltaTone
% 19.09.2016 KJ
%
% MUA mean curves synchronized on tones
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
        %mua
        load SpikeData
        eval('load SpikesToAnalyse/PFCx_Neurons')
        NumNeurons=number;
        clear number
        T=PoolNeurons(S,NumNeurons);
        ST{1}=T;
        try
            ST=tsdArray(ST);
        end
        MUA = MakeQfromS(ST,binsize*10);
        %tones
        load('DeltaSleepEvent.mat', 'TONEtime2')
        delay = Dir.delay{p}*1E4; %in 1E-4s
        ToneEvent = Restrict(ts(TONEtime2 + delay),SWSEpoch);
        nb_tones = length(ToneEvent);
        
%         %Down states
%         load newDownState Down
%         start_down = Start(Down);
%         %Delta
%         load DeltaPFCx DeltaOffline
%         start_delta = Start(DeltaOffline);
%         %Ripples
%         load newRipHPC Ripples_tmp
        
        [corr_matrix, event_triggered_matrix] = PlotEventTriggeredCorrelogram(MUA, ToneEvent, durations, 'smooth', [0.7 0.7], 'pmax', 0.1);
        suplabel(['MUA on tones - ' Dir.title{p}],'t');
    
        cd('/home/mobsjunior/Dropbox/Kteam/Projets KarimJr/Projet Delta/Figures Projet DeltaFeedback/KJ/New')
        savefig(['ParcoursMUADeltaTone - ' Dir.title{p}])
        close all
        

    end
end

