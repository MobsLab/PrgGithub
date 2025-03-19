function peth_tsd = PSTH_KJ(S, center, t_start, t_end, binsize)

% Generate tsd of PSTH 
%
%%  USAGE
% peth_tsd = psth_kj(S, center, t_start, t_end, binsize);
%
%% INPUT
%
%    S              tsd : signal used to compute raster 
%                   e.g. LFP, MUA, SUA...
%
%    center         ts : center of the rasters, generally events 
%                   e.g. down states, stimuli...
%    t_start        num : time where the rasters start from the stimuli (in 1E-4s)
%                   (negative if before)
%    t_end          num : time where the rasters end from the stimuli (in 1E-4s)
%                   (negative if before)
%    binsize        num : size of the bins
%
%% OUTPUT
%
%    peth_tsd       tsd : PSTH
%
%% 
%  NOTE
%    
%
%  SEE
%
%    See also RasterPETH


%intervals around stimuli/event
is = intervalSet(Range(center)+t_start, Range(center)+t_end);

%sweeps : data in intervals
sweeps = intervalSplit(S, is, 'OffsetStart', t_start);

% histogram (sum)
ss = oneSeries(sweeps);
sq = intervalRate(ss, regular_interval(t_start, t_end, binsize));

% tsd
peth_tsd = tsd(Range(sq), Data(sq)/length(sweeps));



end