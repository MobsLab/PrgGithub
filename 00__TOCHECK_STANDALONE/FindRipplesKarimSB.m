% FindRipplesKarimSB - Find Ripples in LFP signals
%
%%  USAGE
% [Ripples_tmp,usedEpoch]=FindRipplesKarimSB(LFP,Epoch,thresh,duration)
%
%% INPUT
%
%    LFP            LFP signal where ripples are detected (HPCrip)
%
%    Epoch (opt)    Epoch/IntervalSet where detection is retricted 
%                     default: no restriction 
%    thresh (opt)   Thresholds in std [low_threshold high_threshold]
%                   - high_threshold is to detect a ripple
%                   - low_threshold is to find start and end of the ripples
%                     default: [5,7]
%    duration (opt) Duration parameters 
%                     [min interval - min ripple dur -max ripple duration]
%                     default: [30 30 100]
%% OUTPUT
%
%    Ripples_tmp    list of ripples events (timestamps)
%    usedEpoch      Epoch/IntervalSet (same as input)
%
%% 
%  NOTE
%    thresh is [5 7] by default and it is exigent, it can be [2 5] if the
%    amplitude of the HPC signal is not high enough.
%
%  SEE
%
%    See also FindRipples, FindRipplesKarim


function [Ripples_tmp,usedEpoch]=FindRipplesKarimSB(LFP,Epoch,thresh,duration)


try
    Epoch;
catch
    rg=Range(LFP);
    Epoch=intervalSet(rg(1),rg(end));
end
usedEpoch=Epoch;

try
    thresh;
catch
    thresh=[5 7]; % default [2 5] , exigent [5,7]
end

try
    duration;
catch
    duration=[30 30 100];
end

clear Rip
clear ripples
Ripples_tmp=[];

for i=1:length(Start(Epoch))
    try
        Filsp = FilterLFP(Restrict(LFP,subset(Epoch,i)),[120 200],1024);
        rgFilsp = Range(Filsp,'s');
        filtered = [rgFilsp-rgFilsp(1) Data(Filsp)];
        [ripples, ~, ~] = FindRipples(filtered,'thresholds',thresh,'durations',duration);
        ripples(:,1:3) = ripples(:,1:3)+rgFilsp(1);
        Ripples_tmp = [Ripples_tmp;ripples];
    catch
        usedEpoch=usedEpoch-subset(Epoch,i);
        usedEpoch=CleanUpEpoch(usedEpoch);
    end
end
