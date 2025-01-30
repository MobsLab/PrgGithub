%%AnalyzTonesResponseNeuronPop
% 14.09.2018 KJ
%
%
%
%
% see
%   
%  
%


clear


Dir1=PathForExperimentsDeltaSleepSpikes('RdmTone');



%get data for each record
for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p analyz_res
    
    analyz_res.path{p}   = Dir.path{p};
    analyz_res.manipe{p} = Dir.manipe{p};
    analyz_res.name{p}   = Dir.name{p};
    analyz_res.date{p}   = Dir.date{p};
    
    
    %% init
    
    %params
    binsize_met = 10;
    nbBins_met  = 80;
    binsize_mua = 2;
    
    minDuration = 40;
    
    load('SpikesToAnalyse/PFCx_Neurons.mat')
    NumNeurons = number; clear number
    
    %neuron response to tones
    load(fullfile(FolderDeltaDataKJ, 'neuronResponseTones.mat'), 'responses')
    tone_neurons    = find(responses.Big{p}(NumNeurons)==1 & responses.Up{p}(NumNeurons)==1);
    neutral_neurons = find(~(responses.Big{p}(NumNeurons)==1 & responses.Up{p}(NumNeurons)==1));
    
    %MUA & Down
    MUA.all     = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua); 
    MUA.excited = GetMuaNeurons_KJ(tone_neurons, 'binsize',binsize_mua); 
    MUA.neutral = GetMuaNeurons_KJ(neutral_neurons, 'binsize',binsize_mua);
    
    down_PFCx   = FindDownKJ(MUA.all, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
    down_excited = FindDownKJ(MUA.excited, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
    down_neutral = FindDownKJ(MUA.neutral, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
    
    % tones
    load('behavResources.mat', 'ToneEvent')
    ToneIn = Restrict(ToneEvent, down_PFCx);
    
    analyz_res.nb_tone{p} = length(ToneIn);
    analyz_res.nb_tonin{p} = length(ToneIn);
    
    
    %% neurons info
    %FR and nb_neuron
    analyz_res.fr.all{p}      = mean(Data(MUA.all)) / (binsize_mua/1000);
    analyz_res.fr.excited{p}  = mean(Data(MUA.excited)) / (binsize_mua/1000);
    analyz_res.fr.neutral{p}  = mean(Data(MUA.neutral)) / (binsize_mua/1000);

    analyz_res.nb.all{p}      = length(NumNeurons);
    analyz_res.nb.excited{p}  = length(excited_neurons);
    analyz_res.nb.neutral{p}  = length(neutral_neurons);
     
    
    %% Delay between tones and down

    %tones in
    tonesin_tmp = Range(ToneIn);
    
    analyz_res.tones_bef{p} = nan(length(tonesin_tmp), 1);
    analyz_res.tones_aft{p} = nan(length(tonesin_tmp), 1);
    for i=1:length(tonesin_tmp)
        st_bef = st_down(find(st_down<tonesin_tmp(i),1,'last'));
        analyz_res.tones_bef{p}(i) = tonesin_tmp(i) - st_bef;
        
        end_aft = end_down(find(end_down>tonesin_tmp(i),1));
        analyz_res.tones_aft{p}(i) = end_aft - tonesin_tmp(i);
    end
    
    
    %% MUA response for tones & sham
    
    % All neurons
    [m,~,tps] = mETAverage(Range(ToneIn), Range(MUA.all), Data(MUA.all), binsize_met, nbBins_met);
    analyz_res.met_inside{p}(:,1) = tps; analyz_res.met_inside{p}(:,2) = m;
    analyz_res.nb_inside{p} = length(ToneIn);
    % neurons
    [m,~,tps] = mETAverage(Range(ToneIn), Range(MUA.excited), Data(MUA.excited), binsize_met, nbBins_met);
    analyz_res.excited{p}(:,1) = tps; analyz_res.excited{p}(:,2) = m;
    % excited
    [m,~,tps] = mETAverage(Range(ToneIn), Range(MUA.neutral), Data(MUA.neutral), binsize_met, nbBins_met);
    analyz_res.neutral{p}(:,1) = tps; analyz_res.neutral{p}(:,2) = m;
    
    
    
end


%saving data
cd(FolderDeltaDataKJ)
save AnalyzTonesResponseNeuronPop.mat analyz_res


