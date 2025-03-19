%%EndDownVertexLFPLayer
% 17.10.2018 KJ
%
%
%
%
% see
%   
%


cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243


%% init

%down
load('DownState.mat', 'down_PFCx')
end_down = End(down_PFCx);

%lfp
load('ChannelsToAnalyse/PFCx_locations.mat')
for ch=1:length(channels)
    load(['LFPData/LFP' num2str(ch) '.mat'])
    PFC{ch} = LFP;
    clear LFP
end
clear channels

load('ChannelsToAnalyse/PFCx_clusters.mat')



%%
intv_enddown = intervalSet(end_down-9000,end_down+900);

for ch=1:length(PFC)
    func_slope = @(a) slopeLFPonEpoch(a,'coucou');
    [slopeLfp{ch}, peakamp{ch}, troughamp{ch}] = functionOnEpochs(PFC{ch}, intv_enddown, func_slope);

end


figure, hold on
for ch=1:length(PFC)
    subplot(2,3,ch), hold on
    hist(slopeLfp{ch},200),    
    xlim([-20 5]),
end






