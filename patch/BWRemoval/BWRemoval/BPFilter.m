function y = BPFilter(x,fl,fu)
%
% y = BPFilter(x,fl,fu),
% Bandpass filter using FFT filtering
%
% inputs:
% x: vector or matrix of input data (channels x samples)
% fl: normalized lower frequency 
% fu: normalized upper frequency
%
% output:
% y: vector or matrix of filtered data (channels x samples)
%
% Note:
% - fl and fu are the lower and upper frequency ranges of the bandpass filter
% normalized by the sampling frequency
% - The filter does not perform any windowing on the data
%
%
% Open Source ECG Toolbox, version 1.0, November 2006
% Released under the GNU General Public License
% Copyright (C) 2006  Reza Sameni
% Sharif University of Technology, Tehran, Iran -- LIS-INPG, Grenoble, France
% reza.sameni@gmail.com

% This program is free software; you can redistribute it and/or modify it
% under the terms of the GNU General Public License as published by the
% Free Software Foundation; either version 2 of the License, or (at your
% option) any later version.
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
% Public License for more details. You should have received a copy of the
% GNU General Public License along with this program; if not, write to the
% Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
% MA  02110-1301, USA.


N = size(x,2);

S = fft(x,N,2);
k = 1:ceil(fl*N);
if(~isempty(k)),
    S(:,k) = 0; S(:,N-k+2) = 0;
end
k = floor(fu*N):ceil(N/2)+1;
S(:,k) = 0; S(:,N-k+2) = 0;

y = real(ifft(S,N,2));