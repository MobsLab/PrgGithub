function [isi_interval, fr_interval] = IsiOnInterval(spikeTimes, interval)
%   
% INPUTS:  
% spikeTimes: ts of spike times
% interval: intervalSet
%
% OUTPUT:
% isi_interval : isi on the interval
%

if nargin < 2
  error('Incorrect number of parameters.');
end


isi_interval = mean(diff(Data(Restrict(spikeTimes, intervalSet(interval(1),interval(2)) ))));
fr_interval = length(Data(Restrict(spikeTimes, intervalSet(interval(1),interval(2)) )));


end