function [C, B] = CrossCorrGL(t1, t2, binsize, nbins)

% [C, B] = CrossCorr(t1, t2, binsize, nbins)
%
% Cross Correlation of two time series
% INPUTS
% t1, t2: arrays containing sorted time series
% binsize: size of the bin for the cross correlation histogram
% nbins: number of bins in the histogram
% OUTPUTS
% C: the cross correlation histogram
% B: a vector with the time corresponding to the bins (optional)

% batta 1999
% MEX file
% status: beta

% if ~isempty(t1) | ~isempty(t2)
%     [C, B] = CrossCorr(t1, t2, binsize, nbins);
% end
if ~isempty(t1) && ~isempty(t2)
    [C, B] = CrossCorr(t1, t2, binsize, nbins);
elseif isempty(t1) || isempty(t2)
    disp('one of the two time series is empty')
    C=[];
    B=[];
end