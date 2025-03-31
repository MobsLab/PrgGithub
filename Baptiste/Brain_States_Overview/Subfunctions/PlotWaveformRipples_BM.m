function [M_pre, M_post, T_pre, T_post] = PlotWaveformRipples_BM(Epoch_to_use)
% from PlotWaveformRipples_MC

%% parameter
windowsize=400; %in ms

% load LFP of ripp channel
try
    load('ChannelsToAnalyse/dHPC_rip.mat')
    load(strcat('LFPData/LFP',num2str(channel),'.mat'));
    LFPHPCrip=LFP;


% load ripples
if exist('SWR.mat')
    load('SWR', 'RipplesEpoch');
else
    load('Ripples.mat', 'RipplesEpoch');
end

%
[tRipples, RipplesEpoch] = GetRipples;
tRipples = Restrict(tRipples,Epoch_to_use);
ripples_time = Range(tRipples,'s');
[M_pre,T_pre] = PlotRipRaw(LFPHPCrip, ripples_time, windowsize, 0,0);


catch
    disp('no rip channels')
    M_pre = NaN;
    M_post = NaN; 
    T_pre  = NaN;
    T_post = NaN;
end

%
% if plo
%     figure,plot(M_pre(:,1),mean(T_pre))
%     xlim([-0.1 0.4])
% end
end
