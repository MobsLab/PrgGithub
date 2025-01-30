%%RipplesFakeDeltaDeepLayer
% 13.03.2018 KJ
%
%   Show that fake detections happen after SPW-Rs and change the coupling
%   
%   
%

clear
Dir=PathForExperimentsBasalSleepSpike;

for p=[1:4 17 19]

    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p onrip ondelta rip_corr
    
    %params
    binsize = 10;
    durations_peth = 500;
    nb_group = 200;
    
    %init
    load([FolderProjetDelta 'Data/DetectDeltaDepthSingleChannel.mat'])
    load([FolderProjetDelta 'Data/DeltaSingleChannelAnalysisCrossCorr.mat'])
    

    %% load data
    load('DeltaWaves.mat', 'deltas_PFCx')
    deltas_ch = depth_res.deltas{p};
    
    load('Ripples.mat', 'Ripples')
    ripples_tmp = Ripples(:,2) * 10;
    load('DownState.mat','down_PFCx')
    
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
    
    %channels deep and sup
    [~,idx] = sort(singcor_res.peak_value{p});
    idch_sup = idx(1);
    idch_deep = idx(end);
    nb_channels = length(singcor_res.channels{p});
  
    
    %LFP
    load('ChannelsToAnalyse/PFCx_deep.mat')
    load(['LFPData/LFP' num2str(singcor_res.channels{p}(idch_deep))])
    PFCdeep = LFP;
    clear LFP

    load('ChannelsToAnalyse/PFCx_sup.mat')
    load(['LFPData/LFP' num2str(singcor_res.channels{p}(idch_sup))])
    PFCsup = LFP;
    clear LFP
    

    %% Raster of LFP and MUA on Ripples and deltas
    
    % LFP on delta
    [MatDelta_deep, TDelta_deep] = PlotRipRaw(PFCdeep, Start(deltas_PFCx,'s'), durations_peth,0,0);
    [MatDelta_sup, TDelta_sup]   = PlotRipRaw(PFCsup, Start(deltas_PFCx,'s'), durations_peth,0,0);
    
    % LFP on ripples
    [MatRip_deep, TRip_deep] = PlotRipRaw(PFCdeep, ripples_tmp/1E4, durations_peth,0,0);
    [MatRip_sup, TRip_sup]   = PlotRipRaw(PFCsup, ripples_tmp/1E4, durations_peth,0,0);
    
    %MUA on ripples and delta waves
    [MatRip_MUA, TRip_MUA]     = PlotRipRaw(MUA,ripples_tmp/1E4,durations_peth,0,0);
    [MatDelta_MUA, TDelta_MUA] = PlotRipRaw(MUA,Start(deltas_PFCx,'s'),durations_peth,0,0);

    
    %sort ripples by the response of LFPsup
    [~, id_sup] = sort(mean(TRip_sup(:,780:900),2));
    %sort ripples by the response of MUA
    [~, id_mua] = sort(mean(TRip_MUA(:,60:75),2));
    
    % Low response of LFP sup
    onrip.low_sup.lfp_deep{p}  = mean(TRip_deep(id_sup(1:nb_group),:));
    onrip.low_sup.lfp_sup{p}   = mean(TRip_sup(id_sup(1:nb_group),:));
    onrip.low_sup.mua{p}       = mean(TRip_MUA(id_sup(1:nb_group),:));
    
    % High response of LFP sup
    onrip.high_sup.lfp_deep{p} = mean(TRip_deep(id_sup(end-nb_group:end),:));
    onrip.high_sup.lfp_sup{p}  = mean(TRip_sup(id_sup(end-nb_group:end),:));
    onrip.high_sup.mua{p}      = mean(TRip_MUA(id_sup(end-nb_group:end),:));
    
    % High and Low response of MUA
    onrip.low_mua.lfp_deep{p}  = mean(TRip_deep(id_mua(1:nb_group),:));
    onrip.low_mua.lfp_sup{p}   = mean(TRip_sup(id_mua(1:nb_group),:));
    onrip.high_mua.lfp_deep{p} = mean(TRip_deep(id_mua(end-nb_group:end),:));
    onrip.high_mua.lfp_sup{p}  = mean(TRip_sup(id_mua(end-nb_group:end),:));
    
    % Response on delta
    ondelta.lfp_deep{p} = mean(TDelta_deep);
    ondelta.lfp_sup{p}  = mean(TDelta_sup);
    ondelta.mua{p}      = mean(TDelta_MUA);

    %x
    x_resp = MatRip_sup(:,1);
    x_mua = MatDelta_MUA(:,1);
    
    %Correlograms
    rip_corr.deep{p} = singcor_res.rip_delta.y{p,idch_deep};
    rip_corr.sup{p}  = singcor_res.rip_delta.y{p,idch_sup};
    rip_corr.diff{p} = singcor_res.rip_delta.y{p,nb_channels};
    rip_corr.down{p} = singcor_res.rip_down.y{p};
    
    rip_corr.x_cor{p} = singcor_res.rip_down.x{p};


end


%saving data
cd([FolderProjetDelta 'Data/'])
save RipplesFakeDeltaDeepLayer.mat onrip ondelta rip_corr x_resp x_mua
















