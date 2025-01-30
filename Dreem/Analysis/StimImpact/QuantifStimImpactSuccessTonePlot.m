% QuantifStimImpactSuccessTonePlot
% 14.05.2018 KJ
%
% success rate
%
%   see 
%       QuantifStimImpactDelayToneSlowWave QuantifStimImpactDelayToneSlowWavePlot
%

%load
clear
cd(FolderStimImpactData)
load(fullfile(FolderStimImpactData, 'QuantifStimImpactDelayToneSlowWave.mat'))


%% Concatenate
%params
step = 20;
max_edge = 1400;
edges = 0:step:max_edge;
smoothing=2;

delay_success = [400 900 ; 500 1100 ; 400 900; 400 900];

%% Pool data

for k=1:4
    delay_slowwave.tone{k} = [];
    delay_slowwave.sham{k} = [];
    for sstage=sleepstage_ind
        for p=1:length(delay_res.filename)
            try
                delay_slowwave.tone{k}  = [delay_slowwave.tone{k}  ; delay_res.tone.delay_slowwave{p}{sstage,k}'/10];
            end
            try
                delay_slowwave.sham{k}  = [delay_slowwave.sham{k}  ; delay_res.sham.delay_slowwave{p}{sstage,k}'/10];
            end
        end
    end
end

for k=1:4
    nb_tones(k) = length(delay_slowwave.tone{k});
    nb_success(k) = sum(delay_slowwave.tone{k}>delay_success(k,1) & delay_slowwave.tone{k}<delay_success(k,2));
    
    ratio(k) = nb_success(k)/ nb_tones(k);
    
end



