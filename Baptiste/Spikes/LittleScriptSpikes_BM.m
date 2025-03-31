


binsize = 1000;

cd(UMazeSleepSess.M490{1}{1})
load('SpikeData.mat')
Q=MakeQfromS(S,binsize);
load('StateEpochSB.mat', 'REMEpoch')
QPre = Restrict(Q,SWSEpoch); 

cd(UMazeSleepSess.M490{2}{1})
load('SpikeData.mat')
Q=MakeQfromS(S,binsize);
load('StateEpochSB.mat', 'REMEpoch')
QPost = Restrict(Q,SWSEpoch); 

Conc=[];
for sess=1:length(CondSess.M490)
    cd(CondSess.M490{sess})
    
    load('SpikeData.mat'), load('behavResources_SB.mat')
    Q=MakeQfromS(S,binsize);
    Q=Restrict(Q,Behav.FreezeEpoch);
    
    q=full(Data(Q));
    Conc=[Conc ; q];
end


[EV,REV,corr] = ExplainedVariance(Data(QPre) , Conc , Data(QPost)); 

