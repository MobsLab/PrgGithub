function binnedFiringRate = binnedFiringRate(Spk,Epoch,binSize,shuffle)

%  this function bins firing rate
%  expSet : char of the type 'XX/YY' (example 20/1014 : rat nb 20 and day 10/14)
%  binSize : in 10^-4 sec
%  nonZero : set to 1 if non firing cells over one the 3 epochs (S1,Maze,S2) has to be excluded (may generates null corr coef). 0 otherwise
%  suffle : set to 1 to shuffle the binned firing rates  by randomly permutes the firing rates vectors
%  
%  
%  Adrien Peyrache 2006        


%Parameters

binSize = 1000;
nonZero = 1;
shuffle = 0;

st = Start(Epoch);
sp = Stop(Epoch);
binEpoch = regular_interval(st,sp,binSize);


binnedFiringRate = Data(intervalRate(Spk,binEpoch));
binnedFiringRate(binnedFiringRate > 0) = 1;
