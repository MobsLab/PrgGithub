function eeg = ReadCR_tsd(fname)
%
% Reads a CSC file (new NT format)and returns a tsd
%
% function tsd = ReadCR_tsd(cr)
%
%
% INPUT:
%       fname ... full filename of Cheetah_NT CSC*.dat file     
%  
% OUTPUT:
%
%       tsd of the csc data.
%
% ADR 1999 called CR2EEG
% status PROMOTED
% version 1.0
% cowen Sat Jul  3 14:59:47 1999
% lipa  modified for NT   Jul 18 1999

% o Got rid of the diplay progress and rounded the timestamps
% o Fixed the dT to be in timestamps 
% o Added a dummy value to the end of cr.ts
% o Made the for look go to nBlocks and not nBlocks -1 

%       ReadCR_nt returns 2 arrays and 1 double of the form...
%       ts = nrec x 1 array of the timestamps that start each block.
%       cr = nrec x 512 array of the data
%       sFreq = sampling frequency

[ts,cr,sFreq] = ReadCR_nt(fname);  %  timestams ts are in 0.1 milliseconds units!!!!!

dd=reshape(cr',1,length(cr(:)));
blockSize = 512;
nBlocks = size(cr,1);
dT = 10000/sFreq; % in tstamps

clear cr;
TIME = zeros(size(dd));
ts = [ts;ts(end) + 512*dT];     
for iBlock = 1:(nBlocks)
  %DisplayProgress(iBlock, nBlocks-1);
  TIME((blockSize * (iBlock-1) + 1):(blockSize * iBlock)) = ...
      linspace(ts(iBlock), ts(iBlock+1) - dT, blockSize);
end

eeg = tsd(TIME', dd');
