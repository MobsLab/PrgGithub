function sp = pspecvals(y,nfft,flim)
%  This function computes the positive half frequency power Spectrum of data
%  segment Y with zero padding and trimming.  The spectral values are normalize
%  with respect to energy (i.e. sum of sp = 1).  FLIM is an optional vector
%  denoting the beginging ending frequencies for the output array.  Values
%  are normalized by half the sampling frequecy. Default is the entire spectrum
%  [0 fs/2]
%
%    sp = pspecvals(y,nfft,flim)
%
%  Output SP the vector of the normalized power spectrum for non-negative
%  frequencies
%
%  Written by Kevin D. Donohue (donohue@engr.uky.edu) June 14, 2006
%


hlen = nfft/2;  % Number of points in postive half spectrum
% Compute Spectrum
sp = fft(y,nfft);
%  if normalized frequency axis given, extract a portion of the specturm
if nargin == 3
    fq = [0:hlen-1]/nfft;
    %  Extract frequency indeces in requested range
    fout = find(fq >= flim(1)/2 & fq <= flim(2)/2);
    sp = abs(sp(fout)).^2;  % Power spectrum
else
    sp = abs(sp(1:hlen,:)).^2;  %  Take first half (positive frequencies)
end
engr = sum(sp)/(nfft);  %  Compute energy
%  Normalize
sp = sp / (engr + eps);