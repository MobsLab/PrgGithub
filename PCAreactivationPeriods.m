function [sigHiCo, sigLoCo, nbBinsHiCo,nbBinsLoCo,QHiCo,rHiCo,QLoCo,rLoCo,pc1hc]=PCAreactivationPeriods(S,Epoch1,Epoch2,synchro,ppc)



% HighCoh = periode de forte coherence
% LowCoh = periode de failbe coherence

% Parameters

sigTresh = 2;
synchro=synchro*10;

nbC = length(S);
Q = MakeQfromS(S,synchro);

QHiCo = Restrict(Q,Epoch1);
QLoCo = Restrict(Q,Epoch2);


% CHiCo = corrcoef(zscore(full(Data(QHiCo))));

temp=full(Data(QHiCo));
temp(temp>0)=1;
%CHiCo = corrcoef(temp);
%CHiCo=CHiCo-diag(diag(CHiCo));

CHiCo = cov(temp);

CHiCo(isnan(CHiCo))=0;



% CLoCo = corrcoef(full(Data(QLoCo)));
% CLoCo(isnan(CLoCo))=0;

[Vhc,Lhc] = pcacov(CHiCo);
% [Vlc,Llc] = pcacov(CLoCo);

% Let's try with the first principal component

pc1hc = Vhc(:,ppc); %change 1 to i to have the it h principal component
% pc1lc = Vlc(:,ppc);

projHiCo = pc1hc*pc1hc';
projHiCo = projHiCo - diag(diag(projHiCo));
% projLoCo = pc1lc*pc1lc';
% projLoCo = projLoCo - diag(diag(projLoCo));

zQHiCo = zscore(full(Data(QHiCo)));
zQLoCo = zscore(full(Data(QLoCo)));

nbBinsHiCo = size(zQHiCo,1);
nbBinsLoCo = size(zQLoCo,1);

rHiCo = zeros(nbBinsHiCo,1);
rLoCo = zeros(nbBinsLoCo,1);

rHiCoInv = zeros(nbBinsHiCo,1);
rLoCoInv = zeros(nbBinsLoCo,1);

for i=1:nbBinsHiCo
	pv = zQHiCo(i,:);
	rHiCo(i) = pv*projHiCo*pv';
% 	rHiCoInv(i) = pv*projLoCo*pv';
end

for i=1:nbBinsLoCo
	pv = zQLoCo(i,:);
	rLoCo(i) = pv*projHiCo*pv';
% 	rLoCoInv(i) = pv*projHiCo*pv';
end


rg = Range(QHiCo);
sigHiCo = ts(rg(rHiCo>sigTresh));
% sigHiCoInv = ts(rg(rHiCoInv>sigTresh));

rg2 = Range(QLoCo);
sigLoCo = ts(rg2(rLoCo>sigTresh));
% sigLoCoInv = ts(rg(rLoCoInv>sigTresh));

%Maintenant tu as 2 ts des temps des pics significatifs de correlations. A toi de voir voir si il y a une préférence de phase... 
% en appelant le même programme que celui pour la phase des spikes

%  figure
%  plot(Range(QHiCo),rHiCo)
%  
%  figure
%  plot(Range(QLoCo),rLoCo)

