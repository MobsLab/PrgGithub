function [m,s,tps]=mETAverage(e,t,v,binsize,nbBins)

%
%[m,s,tps]=mETAverage(e,t,v,bins,nbBins)
%
% Input:
% e       : times of events
% t       : time of the values  - in 1/10000 sec (assumed to be sorted)
% v       : values
% binsize : size of the bin in ms
% nbBins  : number of bins
% 
% Output:
% m   : mean
% S   : standard error
% tps : times

 
try
    [m,s,tps]=ETAverage(e,t,v,binsize,nbBins);
    s=sqrt(s);

catch
    
    try
        [m,s,tps]=ETAverage2(e,t,v,binsize,nbBins);
        s=sqrt(s);

    catch
        [m,tps]=ETAverage(e,t,v,binsize,nbBins);
        s=[];
    end
end


