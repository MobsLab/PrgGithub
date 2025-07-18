function A = Analyse(A)


A = getResource(A,'Sleep2Epoch');
sleep2Epoch = sleep2Epoch{1};

A = getResource(A,'Sleep1Epoch');
sleep1Epoch = sleep1Epoch{1};

A = getResource(A,'MazeEpoch');
mazeEpoch = mazeEpoch{1};

A = getResource(A,'SpikeData');
nbCells = length(S);

A = getResource(A,'MidRipS1');
midRipS1 = Range(midRipS1{1});
nbRipples1 = length(midRipS1);
A = getResource(A,'MidRipS2');
midRipS2 = Range(midRipS2{1});
nbRipples2 = length(midRipS2);


Q = MakeQfromS(S,250);
QS2 = Restrict(Q,sleep2Epoch);
zQS2 = tsd(Range(QS2),zscore(full(Data(QS2))));

zQRip = Data(Restrict(zQS2,midRipS2,'align','closest'));

zQS2 = Data(zQS2);

cM = spkZcorrcoef(S,1000,mazeEpoch);
[PCACoef, PCAvar, PCAexp] = pcacov(cM);

rip = PCACoef'*zQRip';

[maxRip,ixRip] = max(abs(rip));	

for i=1:nbCells

	maxPCRip(i) = sum(ixRip == i);

end;

[maxS2,ixS2] = max(abs(PCACoef'*zQS2'));	

for i=1:nbCells

	maxPCS2(i) = sum(ixS2 == i);

end;


maxPc1Rip = find(ixRip == 2);
maxPc1S2 = find(ixS2 == 2);

norm = sqrt(sum(zQRip(maxPc1Rip,:)'.*zQRip(maxPc1Rip,:)'));
ripPc1 = PCACoef'*zQRip(maxPc1Rip,:)'./(ones(nbCells,1)*norm);
%  [ripPc1Distr,I] = sort(abs(ripPc1'),2);
ripPc1Distr = abs(ripPc1'),2;

nbTests = 100;

norm = sqrt(sum(zQRip'.*zQRip'));
ripAll = PCACoef'*zQRip'./(ones(nbCells,1)*norm);
%  ripAllDistr = sort(abs(ripAll'),2);
ripAllDistr = abs(ripAll');

norm = sqrt(sum(zQS2'.*zQS2'));
s2All = PCACoef'*zQS2'./(ones(nbCells,1)*norm);
%  s2AllDistr = sort(abs(s2All'),2);
s2AllDistr = abs(s2All');

norm = sqrt(sum(zQS2(maxPc1S2,:)'.*zQS2(maxPc1S2,:)'));
s2Pc1 = PCACoef'*zQS2(maxPc1S2,:)'./(ones(nbCells,1)*norm);
s2Pc1Distr = sort(abs(s2Pc1'),2);
s2Pc1Distr = abs(s2Pc1');

%  ripPc1RndDistr = zeros(nbTests,21);
%  
%  for i=1:nbTests
%  	ripNorm = sqrt(sum(ripPc1.*ripPc1));
%  	ripRnd = 2*rand(size(ripPc1))-1;
%  	ripRndNorm = ripNorm./sqrt(sum(ripPc1.*ripPc1));
%  	ripRnd = ripRnd./(ones(size(ripRnd,1),1)*ripRndNorm);
%  	ripPc1RndDistr(i,:) = sort(abs(mean(ripRnd')))	;
%  end

%  figure(1),clf
%  bar(maxPC);

figure(2),clf
hold on
bar(mean(ripPc1Distr))
errorbar([1:21],mean(ripAllDistr),std(ripAllDistr),-std(ripAllDistr),'b')
errorbar([1:21],mean(s2AllDistr),std(s2AllDistr),-std(s2AllDistr),'r')
errorbar([1:21],mean(s2Pc1Distr),std(s2Pc1Distr),-std(s2Pc1Distr),'k')
keyboard