function DistanceToZone

% Compute Distance to stimZone PAS FINI

disp('pas fini')

Xm=Restrict(X,QuantifExploEpoch);
Ym=Restrict(Y,QuantifExploEpoch);

dxm=rescale([0 ;Data(X) ;300],0,si);
dym=rescale([0 ;Data(Y) ;300],0,si);

dxm=dxm(2:end-1);
dym=dym(2:end-1);

Xm=tsd(Range(X),dxm);
Ym=tsd(Range(Y),dym);
%dis=tsd(Range(Xm),sqrt((Data(Xm)-kk(1)).*(Data(Xm)-kk(1))+(Data(Ym)-kk(2)).*(Data(Ym)-kk(2))));

Gstim(1)=mean(pxS);
Gstim(2)=mean(pyS);

dis=tsd(Range(X),sqrt((Data(X)-Gstim(1)).*(Data(X)-Gstim(1))+(Data(Y)-Gstim(2)).*(Data(Y)-Gstim(2))));

