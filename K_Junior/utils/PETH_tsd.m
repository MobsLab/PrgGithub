function peth_tsd = PETH_tsd(S, center, t_start, t_end, binsize)

% Generate PETH
%
%%  USAGE
% peth_tsd = PETH_tsd(S, center, t_start, t_end);
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
%    binsize        num : size of the bins for PETH
%
%
%% OUTPUT
%
%    peth_tsd    	tsd : PETH
%
%% 
%  NOTE
%    
%
%  SEE
%
%    See also RasterPETH


is = intervalSet(Range(center)+t_start, Range(center)+t_end);
sweeps = intervalSplit(S, is, 'OffsetStart', t_start);
ss = oneSeries(sweeps);
sq = intervalRate(ss, regular_interval(t_start, t_end, binsize));

peth_tsd = tsd(Range(sq), Data(sq)/length(sweeps));


end
