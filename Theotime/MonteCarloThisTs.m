function RandomizedData = MonteCarloThisTs(Ts, stddelay)
%MONTECARLOTHISDATA This function randomizes the data in Ts by adding a zero-centered random delay to each data point. The delay is drawn from a uniform distribution between -stddelay and + stddelay.

% input:
% Ts: a timeseries object
% stddelay: the standard deviation of the delay

% output:
% RandomizedData: a timeseries object with the same data as Ts, but with
% random delays added to each data point
RandomizedData = Range(Ts) - random('uniform',-stddelay, stddelay, size(Range(Ts)));
RandomizedData = sort(RandomizedData);
end

