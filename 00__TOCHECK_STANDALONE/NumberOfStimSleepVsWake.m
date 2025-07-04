%NumberOfStimSleepVsWake

Plo=0;


%
%filename='/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/';
%
%
%sleep
%
%cd([filename,'Mouse026/20120109'])
%cd([filename,'Mouse029/20120207'])
%cd([filename,'Mouse035/20120515'])
%cd([filename,'Mouse042/20120801'])
%
%
%wakePlaceCell
%
%cd([filename,'Mouse026/20111128'])
%cd([filename,'Mouse029/20120209'])
%cd([filename,'Mouse017/20110622'])
%
%
%wake
%
%cd([filename,'Mouse013/20110420'])
%cd([filename,'Mouse015/20110615'])
%cd([filename,'Mouse017/20110614'])
%
%


%--------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%--------------------------------------------------------------------------




a=1;

filename='/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/';



cd([filename,'Mouse013/20110420'])
load behavResources
load stimMFB
Epoch=intervalSet(tpsdeb{4}*1E4,tpsfin{5}*1E4);
NumStim(a)=length(Range(Restrict(stim,Epoch)));
NumBurst(a)=length(Range(Restrict(burst,Epoch)));
TimeEpoch(a)=End(Epoch,'s')-Start(Epoch,'s');
a=a+1;
if Plo
PlotVerifMFBstimEfficiencySpace(stim,X,Y,Epoch,paramMin,paramMax)
title(pwd)
end

cd([filename,'Mouse015/20110615'])
load behavResources
load stimMFB
Epoch=intervalSet(tpsdeb{4}*1E4,tpsfin{4}*1E4);
NumStim(a)=length(Range(Restrict(stim,Epoch)));
NumBurst(a)=length(Range(Restrict(burst,Epoch)));
TimeEpoch(a)=End(Epoch,'s')-Start(Epoch,'s');
a=a+1;
if Plo
PlotVerifMFBstimEfficiencySpace(stim,X,Y,Epoch,paramMin,paramMax)
title(pwd)
end

cd([filename,'Mouse017/20110622'])
load behavResources
load stimMFB
Epoch=intervalSet(tpsdeb{11}*1E4,tpsfin{12}*1E4);
length(Range(Restrict(stim,Epoch)))
length(Range(Restrict(burst,Epoch)))
End(Epoch,'s')-Start(Epoch,'s')
if Plo
PlotVerifMFBstimEfficiencySpace(stim,X,Y,Epoch,paramMin,paramMax)
title(pwd)
end

cd([filename,'Mouse026/20111128'])
load behavResources
load stimMFB
Epoch=intervalSet(tpsdeb{9}*1E4,tpsfin{9}*1E4);
NumStim(a)=length(Range(Restrict(stim,Epoch)));
NumBurst(a)=length(Range(Restrict(burst,Epoch)));
TimeEpoch(a)=End(Epoch,'s')-Start(Epoch,'s');
a=a+1;
if Plo
PlotVerifMFBstimEfficiencySpace(stim,X,Y,Epoch,paramMin,paramMax)
title(pwd)
end

cd([filename,'Mouse029/20120209'])
load behavResources
load stimMFB
Epoch=intervalSet(tpsdeb{4}*1E4,tpsfin{4}*1E4);
NumStim(a)=length(Range(Restrict(stim,Epoch)));
NumBurst(a)=length(Range(Restrict(burst,Epoch)));
TimeEpoch(a)=End(Epoch,'s')-Start(Epoch,'s');
a=a+1;
if Plo
PlotVerifMFBstimEfficiencySpace(stim,X,Y,Epoch,paramMin,paramMax)
title(pwd)
end


%--------------------------------------------------------------------------
%%
%--------------------------------------------------------------------------


NumBurst
NumStim
TimeEpoch

NumBurst./TimeEpoch
NumStim./TimeEpoch

NumStim./NumBurst


mean(NumBurst)
stdError(NumBurst)

mean(NumStim)
stdError(NumStim)

mean(TimeEpoch)
stdError(TimeEpoch)

mean(NumBurst./TimeEpoch)
stdError(NumBurst./TimeEpoch)

mean(NumStim./TimeEpoch)
stdError(NumStim./TimeEpoch)

mean(NumStim./NumBurst)
stdError(NumStim./NumBurst)


%--------------------------------------------------------------------------
%%
%--------------------------------------------------------------------------


% 
% NumBurst =  139   128   194
% NumStim =  5819  1441  3120
% 
% TimeEpoch (en sec) =  953.4555          599.802500000001          733.351999999999
% 
% FreqStim =   6.10306406539162          2.40245747558571          4.25443715978139
% FreqBurst =  0.145785513849362         0.213403578677981         0.264538720832561
% 
% 
% StimPerBurst = 41.863309352518                11.2578125          16.0824742268041
% 
% TimeEpoch (en min)=  15.890925          9.99670833333334          12.2225333333333





%--------------------------------------------------------------------------
%%
%--------------------------------------------------------------------------





%wakePlaceCell
%
%cd([filename,'Mouse026/20111128'])
%cd([filename,'Mouse029/20120209'])
%cd([filename,'Mouse017/20110622'])
%
%
%wake
%
%cd([filename,'Mouse013/20110420'])
%cd([filename,'Mouse015/20110615'])
%cd([filename,'Mouse017/20110614'])
