function [S,X,Y,V,Mvt,MvtOK,goEpoch]=RemoveImmobilePosition(S,X,Y,V,Vth,TrackingEpoch,SleepEpoch,RestEpoch)



Mvt=thresholdIntervals(V,Vth,'Direction','Above');


kl=Range(X);
MvtOK=intersect(intervalSet(kl(1),kl(end)),Mvt);
goEpoch=intersect(TrackingEpoch,intervalSet(kl(1),kl(end))-SleepEpoch-RestEpoch);

%figure('color',[1 1 1]), 
%hist(Data(Restrict(V,goEpoch)),[0:1:100]), xlim([0 100])
%pause(0)
%close
S=Restrict(S,MvtOK);
X=Restrict(X,MvtOK);
Y=Restrict(Y,MvtOK);
V=Restrict(V,MvtOK);

