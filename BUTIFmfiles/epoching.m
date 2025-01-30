function [epochs,header] = epoching(signal, epochsize, overlap, header)
% epochs = epoching(signal, epochsize, overlap, header);
%
% This file will epich a multichannel ExT signal
% where T is the number of time samples and E is the number of electrodes.
% The epochs are computed so that the border effect of bump modeling is
% taken into account. 
% This m-file should be used for long signals (>30 sec duration).
%
% - signal: ExT matrix.
% 
% - epochsize: desired epoch size in seconds. The epoch must be smaller
% than half of the signal duration (e.g. 2 sec. for a 4 sec. signal). It
% should also be larger than 4 cycles at the lowest modeled frequency to
% assure accurate results (e.g. 4 sec. if minimal frequency is 1 Hz).
%
% - overlap: percentage of overlap between the windows.
% Value between 0 and 99 indicating percentage.  
% if this parameter is assigned a nul values [], default value is 0.
% 
% - header: decomposition header.
% after epoching, a new header is returned, with the correct epoch timing.
% note that this header uses by default self-referencing.
%
% Copyright (C) 2009 Lab. ABSP, Riken (Japan) Francois-B. Vialatte et al.
% Please cite related papers when publishing results obtained with this
% toolbox


if isempty(overlap)
    overlap = 0;
end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%           evaluate resolutions         %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
freqech = header.freqsmp;
freqmin = header.freqmin;
freqmax = header.freqmax;
freqstp = header.freqstp;
freqdown = header.freqdown;
Freqs = freqmin:freqstp:freqmax;

resols = all_resolutions(Freqs, header,freqdown,freqstp);
bornes.byup = ceil(resols(length(Freqs),1)/2)+1;
bornes.bydn = ceil(resols(1,1)/2)+1;
resdwn = all_resolutions(max(freqmin-bornes.bydn*freqstp,1), header,freqech,freqstp);
bornes.bx = ceil(resols(1,2)/2)+1;
borneslat = round((freqech/(freqmin-bornes.bydn*freqstp))*3.5);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%                cycling                 %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

windowsize = round(epochsize * freqech) + 2*borneslat + 2*bornes.bx;
overlapsize = round(windowsize*overlap/100) + borneslat + bornes.bx;
lengthsig = size(signal,2);
if (windowsize*2-overlapsize) > lengthsig
    disp('epoch size is too large (impossible to insert more than 1 epoch)');      
    disp('epoching takes into account the border effects of wavelet and bump transforms');
    disp(['Parameters: epoch = ',num2str(round(epochsize * freqech)),...
        ' minimal frequency = ',num2str(freqmin)]);   
    disp(['resulting border effects: wavelet = ',num2str(borneslat),...
        'bumps = ',num2str(bornes.bx)]);
    disp(['total epoch = ',num2str(windowsize),' but signal size = ',num2str(lengthsig)]);
    return;
end;

numwindows = floor((lengthsig-windowsize) / (windowsize-overlapsize))+1;
for n=1:numwindows
    epochs{n} = signal(:,(n-1)*(windowsize-overlapsize)+1:(n-1)*(windowsize-overlapsize)+windowsize);
end;

header.begin = 1/freqech;
header.end = windowsize/freqech;
header.beginref = header.begin;
header.endref = header.end;
