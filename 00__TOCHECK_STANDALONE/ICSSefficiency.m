load behavResources

%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
smo=2;
sizeMap=50;
tpsTh=0.75*1E4;
Limdist=30;
Vth=20;

EpochS=subset(ICSSEpoch,o);
RgStim=Range(Restrict(stim,EpochS));

FirstStim=RgStim(1);
LastStim=RgStim(end);
StimEpoch=intervalSet(FirstStim,LastStim);


Mvt=thresholdIntervals(V,Vth,'Direction','Above');
XS=Restrict(X,StimEpoch);
YS=Restrict(Y,StimEpoch);
stimS=Restrict(stim,StimEpoch);

[mapS,statsS,pxS,pyS,Fr,si,PF,centre]=PlaceField(stimS,XS,YS,'size',sizeMap,'limitmaze',[0 350]);
    
rS=corrcoef(mapS.rate(:),mapS.time(:));
ICSSeff=rS(1,2)
