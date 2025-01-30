function [m,s,tps]=mETAverage(e,t,v,bins,nbBins)

% Input:
% t: time of the values
% v: values
% e: times of events
% bins: taille des bins
% nbBins: number of bins
% 
% Output:
% R mean
% S time
% E varaince

%   * input  ev: an event time series 
%   *        t1 time series  in 1/10000 sec
%   *               (assumed to be sorted)
%   *        d the values in the dataset 
%   *        binsize: the size of the bin in ms
%   *        nbins: the number of bins to compute 
%   * output C the event triggered average 
%   *        B (optional) a vector with the times corresponding to the bins
 
 

[m,s,tps]=ETAverage(e,t,v,bins,nbBins);


s=sqrt(s);

