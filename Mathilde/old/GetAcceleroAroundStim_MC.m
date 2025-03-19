function [M_start, M_end, M_stim] = GetAcceleroAroundStim_MC(state)
%%
load('SleepScoring_OBGamma', 'REMEpochWiNoise', 'SWSEpochWiNoise', 'WakeWiNoise');
REMEpoch  = mergeCloseIntervals(REMEpochWiNoise,1E4);
SWSEpoch = mergeCloseIntervals(SWSEpochWiNoise,1E4);
Wake =  mergeCloseIntervals(WakeWiNoise,1E4);

% get accelero
load('behavResources.mat')
SqurdAccTsd=tsd(Range(MovAcctsd),Data(MovAcctsd).^2);

% to get opto stimulations
if exist('StimOpto.mat')
    load('StimOpto.mat');
elseif exist('StimOpto_sham.mat')
    load('StimOpto_sham.mat')
else
end

%%
if strcmp(lower(state),'wake')
    [M_start,T_start] = PlotRipRaw_MC(SqurdAccTsd, Start(Wake)/1E4, 60000, 0, 0); % PlotRipRaw_MC computes the median
    [M_end,T_end] = PlotRipRaw_MC(SqurdAccTsd, End(Wake)/1E4, 60000, 0, 0);
    if exist('StimOpto.mat') || exist('StimOpto_sham.mat')
        [M_stim,T_stim] = PlotRipRaw_MC(SqurdAccTsd, StimWake/1E4, 60000, 0, 0);
    else
        M_stim = zeros(1,4);
        M_stim(:,:) = NaN;
    end
    
elseif strcmp(lower(state),'sws')
    [M_start,T_start] = PlotRipRaw_MC(SqurdAccTsd, Start(SWSEpoch)/1E4, 60000, 0, 0);
    [M_end,T_end] = PlotRipRaw_MC(SqurdAccTsd, End(SWSEpoch)/1E4, 60000, 0, 0);
    if exist('StimOpto.mat') || exist('StimOpto_sham.mat')
        [M_stim,T_stim] = PlotRipRaw_MC(SqurdAccTsd, StimSWS/1E4, 60000, 0, 0);
    else
        M_stim = zeros(1,4);
        M_stim(:,:) = NaN;
    end
    
elseif strcmp(lower(state),'rem')
    [M_start,T_start] = PlotRipRaw_MC(SqurdAccTsd, Start(REMEpoch)/1E4, 60000, 0, 0);
    [M_end,T_end] = PlotRipRaw_MC(SqurdAccTsd, End(REMEpoch)/1E4, 60000, 0, 0);
    if exist('StimOpto.mat') || exist('StimOpto_sham.mat')
        [M_stim,T_stim] = PlotRipRaw_MC(SqurdAccTsd, StimREM/1E4, 60000, 0, 0);
    else
        M_stim = zeros(1,4);
        M_stim(:,:) = NaN;
    end
end
end

