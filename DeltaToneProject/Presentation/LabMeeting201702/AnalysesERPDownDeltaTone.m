% AnalysesERPDownDeltaTone
% 20.02.2017 KJ
%
%
% Data to analyse tone effect on signals:
%   - show MUA raster synchronized on tones
%   - show PFC averaged LFP synchronized on tones (may depth)
%   - distinguish delta-triggered tones
%   - distinguish delta-inducing tones
%
% See AnalysesERPDownDeltaTonePlot AnalysesERPDownDeltaToneMousePlot
%   
%


clear

Dir = PathForExperimentsDeltaSleepSpikes('DeltaToneAll');

% Dir2 = PathForExperimentsDeltaKJHD('DeltaToneAll');
% Dir = IntersectPathForExperiment(Dir,Dir2);


for p=1:length(Dir.path)
    if strcmpi(Dir.manipe{p},'DeltaToneAll')
        Dir.condition{p} = ['Tone ' num2str(Dir.delay{p}*1000) 'ms'];
    end
end

%params
t_before = -4E4; %in 1E-4s
t_after = 4E4; %in 1E-4s
binsize_mua=10;
effect_period = 2000; %200ms
substage_ind = 1:5;

%
for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    down_tone.path{p}=Dir.path{p};
    down_tone.manipe{p}=Dir.manipe{p};
    down_tone.delay{p}=Dir.delay{p};
    down_tone.name{p}=Dir.name{p};
    down_tone.condition{p}=Dir.condition{p};
        
    %% Load

    %Substages
    clear op noise
    load NREMepochsML.mat op noise
    if ~isempty(op)
        disp('Loading epochs from NREMepochsML.m')
    else
        clear op NamesOp Dpfc Epoch noise
        load NREMepochsML_old.mat op noise
        disp('Loading epochs from NREMepochsML.m')
    end
    [Substages,NamesSubstages]=DefineSubStages(op,noise);
    
    %LFP
    load ChannelsToAnalyse/PFCx_deep
    eval(['load LFPData/LFP',num2str(channel)])
    LFPdeep=LFP;
    clear LFP channel
    try
        load ChannelsToAnalyse/PFCx_sup
    catch
        load ChannelsToAnalyse/PFCx_deltasup
    end
    eval(['load LFPData/LFP',num2str(channel)])
    LFPsup=LFP;
    clear LFP channel
    load ChannelsToAnalyse/PFCx_1
    eval(['load LFPData/LFP',num2str(channel)])
    PFC1=LFP;
    clear LFP channel
    load ChannelsToAnalyse/PFCx_2
    eval(['load LFPData/LFP',num2str(channel)])
    PFC2=LFP;
    clear LFP channel
    load ChannelsToAnalyse/PFCx_3
    eval(['load LFPData/LFP',num2str(channel)])
    PFC3=LFP;
    clear LFP channel

    %MUA
    load SpikeData
    eval('load SpikesToAnalyse/PFCx_Neurons')
    NumNeurons=number;
    clear number
    T=PoolNeurons(S,NumNeurons);
    ST{1}=T;
    try
        ST=tsdArray(ST);
    end
    Q = MakeQfromS(ST,binsize_mua*10); %binsize*10 to be in E-4s
    nb_neuron = length(NumNeurons);
        
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
    tdowns = ts((Start(Down)+End(Down))/2);
    start_down = Start(Down);
    end_down = End(Down);

    %tones
    load('DeltaSleepEvent.mat', 'TONEtime2')
    load('DeltaSleepEvent.mat', 'TONEtime1')
    delay = Dir.delay{p}*1E4;
    if exist('TONEtime2','var')
        tones_tmp = TONEtime2 + delay;
    else
        tones_tmp = TONEtime1 + delay;
    end
    ToneEvent = ts(tones_tmp);
    nb_tones = length(tones_tmp);
    tone_intv_post = intervalSet(tones_tmp, tones_tmp + effect_period);  % Tone and its window where an effect could be observed
    
    
    %% DELAY        
    %down
    delay_down_tone = nan(nb_tones, 1);
    for i=1:nb_tones
        try
            idx_down_before = find(end_down < tones_tmp(i), 1,'last');
            delay_down_tone(i) = tones_tmp(i) - end_down(idx_down_before);    
        end
    end
    
    %% INDUCED Delta or Down ?
    if ~isempty(start_down)
        induce_down = zeros(nb_tones, 1);
        [~,interval,~] = InIntervals(start_down, [Start(tone_intv_post) End(tone_intv_post)]);
        down_tone_success = unique(interval);
        induce_down(down_tone_success(2:end)) = 1;  %do not consider the first nul element
    else
        induce_down = [];
    end
    
    %% SUBSTAGE
    substage_tone = nan(1,length(tones_tmp));
    for sub=substage_ind
        substage_tone(ismember(tones_tmp, Range(Restrict(ToneEvent, Substages{sub})))) = sub;
    end
    
    %% Raster and save
    down_tone.deep.raster{p} = RasterMatrixKJ(LFPdeep, ToneEvent, t_before, t_after);
    down_tone.sup.raster{p}  = RasterMatrixKJ(LFPsup, ToneEvent, t_before, t_after);
    down_tone.pfc1.raster{p} = RasterMatrixKJ(PFC1, ToneEvent, t_before, t_after);
    down_tone.pfc2.raster{p} = RasterMatrixKJ(PFC2, ToneEvent, t_before, t_after);
    down_tone.pfc3.raster{p} = RasterMatrixKJ(PFC3, ToneEvent, t_before, t_after);
    
    down_tone.mua.raster{p} = RasterMatrixKJ(Q, ToneEvent, t_before, t_after);
    down_tone.down_delay{p} = delay_down_tone;
    down_tone.induced{p} = induce_down;
        
    down_tone.substage_tone{p} = substage_tone;
    down_tone.nrem_tone{p} = ismember(substage_tone,1:3);
        
end


%% save
cd([FolderProjetDelta 'Data/'])
save AnalysesERPDownDeltaTone -v7.3 down_tone substage_ind effect_period



