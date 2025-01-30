function [sigHiCo,nbBinsHiCo,QHiCo,QHiCoW,rHiCo,pc1hc,Vhc,Lhc]=ComputeReactivationMeasure(S,WakeEpoch,TotalEpoch,synchro,ppc)



% HighCoh = periode de forte coherence
% LowCoh = periode de failbe coherence

% Parameters

sigTresh = 30;
synchro=synchro*10;

nbC = length(S);
Q = MakeQfromS(S,synchro);


QHiCoW = Restrict(Q,WakeEpoch);
CHiCo = corrcoef(full(Data(QHiCoW)));
CHiCo(isnan(CHiCo))=0;


[Vhc,Lhc] = pcacov(CHiCo);


% Let's try with the first principal component

pc1hc = Vhc(:,ppc); %change 1 to i to have the it h principal component


projHiCo = pc1hc*pc1hc';
projHiCo = projHiCo - diag(diag(projHiCo));




%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


QHiCo = Restrict(Q,TotalEpoch);

zQHiCo = zscore(full(Data(QHiCo)));


nbBinsHiCo = size(zQHiCo,1);
rHiCo = zeros(nbBinsHiCo,1);
rHiCoInv = zeros(nbBinsHiCo,1);

for i=1:nbBinsHiCo
	pv = zQHiCo(i,:);
	rHiCo(i) = pv*projHiCo*pv';
end



rg = Range(QHiCo);
sigHiCo = ts(rg(rHiCo>sigTresh));




%Maintenant tu as 2 ts des temps des pics significatifs de correlations. A toi de voir voir si il y a une préférence de phase... 
% en appelant le même programme que celui pour la phase des spikes

%  figure
%  plot(Range(QHiCo),rHiCo)
%  
%  figure
%  plot(Range(QLoCo),rLoCo)

