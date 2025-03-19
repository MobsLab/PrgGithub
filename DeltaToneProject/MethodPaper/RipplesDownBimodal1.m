% RipplesDownBimodal1
% 14.03.2018 KJ
% 
% 
% Data to analyse tone effect on signals:
%   - show MUA raster synchronized on ripples
%   - show PFC averaged LFP synchronized on ripples (many depth)
%
%   On mouse 243 (PaCx)
% 
% See AnalysesERPDownDeltaTone AnalysesERPRipplesDelta RipplesDownBimodalNight
% RipplesDownBimodalPlot
%   
% 
% 

clear

Dir=PathForExperimentsBasalSleepSpike;

for p=4:8

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p ripple_res

    ripple_res.path{p}   = Dir.path{p};
    ripple_res.manipe{p} = Dir.manipe{p};
    ripple_res.name{p}   = Dir.name{p};
    ripple_res.date{p}   = Dir.date{p};
    
    %params
    t_before = -4E4; %in 1E-4s
    t_after = 4E4; %in 1E-4s
    binsize=10;
    effect_period_down = 1500; %150ms


    %% load
    load(fullfile(FolderProjetDelta,'Data','DeltaSingleChannelAnalysisCrossCorr.mat'))

    load('DownState.mat', 'down_PFCx')
    start_down = Start(down_PFCx);
    center_down = (End(down_PFCx) + Start(down_PFCx))/2;
    down_durations = End(down_PFCx) - Start(down_PFCx);


    load('Ripples.mat', 'Ripples')
    ripples_tmp = Ripples(:,2) * 10;
    ripples_intv_down = intervalSet(ripples_tmp, ripples_tmp + effect_period_down);
    nb_ripples = length(ripples_tmp);

    %spikes
    load('SpikesToAnalyse/PFCx_Neurons')
    NumNeurons=number;
    load('SpikeData','S')
    if isa(S,'tsdArray')
        MUA = MakeQfromS(S(NumNeurons), binsize*10);
    else
        MUA = MakeQfromS(tsdArray(S(NumNeurons)),binsize*10);
    end
    MUA = tsd(Range(MUA), sum(full(Data(MUA)),2));

    %LFP
    %channels deep and sup
    [~,idx] = sort(singcor_res.peak_value{p});
    idch_sup = idx(1);
    idch_deep = idx(end);
    nb_channels = length(singcor_res.channels{p});


    load('ChannelsToAnalyse/PFCx_deep.mat')
    load(['LFPData/LFP' num2str(singcor_res.channels{p}(idch_deep))])
    PFCdeep = LFP;
    clear LFP

    load('ChannelsToAnalyse/PFCx_sup.mat')
    load(['LFPData/LFP' num2str(singcor_res.channels{p}(idch_sup))])
    PFCsup = LFP;
    clear LFP
    
    load('ChannelsToAnalyse/PaCx_deep.mat')
    load(['LFPData/LFP' num2str(channel)])
    PaCxdeep = LFP;
    clear LFP
    load('ChannelsToAnalyse/PaCx_sup.mat')
    load(['LFPData/LFP' num2str(channel)])
    PaCxsup = LFP;
    clear LFP
    
    load('ChannelsToAnalyse/MoCx_deep.mat')
    load(['LFPData/LFP' num2str(channel)])
    MoCxdeep = LFP;
    clear LFP
    load('ChannelsToAnalyse/MoCx_sup.mat')
    load(['LFPData/LFP' num2str(channel)])
    MOCxsup = LFP;
    clear LFP
    

    %% INDUCED a Down ?
    induce_down = zeros(nb_ripples, 1);
    [~,interval,~] = InIntervals(start_down, [Start(ripples_intv_down) End(ripples_intv_down)]);
    down_ripples_success = unique(interval);
    down_ripples_success(down_ripples_success==0)=[];
    induce_down(down_ripples_success) = 1;  %do not consider the first nul element


    %% Raster MUA
    ripple_res.raster_mua{p} = RasterMatrixKJ(MUA, ts(ripples_tmp), t_before, t_after);
    ripple_res.induce_down{p} = induce_down;

    %% Raster LFP
    ripple_res.raster_deep{p} = RasterMatrixKJ(PFCdeep, ts(ripples_tmp), t_before, t_after);
    ripple_res.raster_sup{p} = RasterMatrixKJ(PFCsup, ts(ripples_tmp), t_before, t_after);
    
    ripple_res.pacx_deep{p} = RasterMatrixKJ(PaCxdeep, ts(ripples_tmp), t_before, t_after);
    ripple_res.pacx_sup{p} = RasterMatrixKJ(PaCxsup, ts(ripples_tmp), t_before, t_after);
    
    ripple_res.mocx_deep{p} = RasterMatrixKJ(MoCxdeep, ts(ripples_tmp), t_before, t_after);
    ripple_res.mocx_sup{p} = RasterMatrixKJ(MOCxsup, ts(ripples_tmp), t_before, t_after);
    
    ripple_res.down.pacx_deep{p} = RasterMatrixKJ(PaCxdeep, ts(start_down), t_before, t_after);
    ripple_res.down.pacx_sup{p} = RasterMatrixKJ(PaCxsup, ts(start_down), t_before, t_after);
    
    ripple_res.down.mocx_deep{p} = RasterMatrixKJ(MoCxdeep, ts(start_down), t_before, t_after);
    ripple_res.down.mocx_sup{p} = RasterMatrixKJ(MOCxsup, ts(start_down), t_before, t_after);
    
    
end
    
cd([FolderProjetDelta 'Data/'])
save RipplesDownBimodal2.mat -v7.3 ripple_res t_before t_after binsize effect_period_down






