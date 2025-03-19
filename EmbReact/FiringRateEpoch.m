function Fr=FiringRateEpoch(S,Epoch)

Fr=length(Restrict(S,Epoch))/sum(Stop(Epoch,'s')-Start(Epoch,'s'));