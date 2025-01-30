nbExp = 9;
%  rMS1 = zeros(3,nbExp);
%  rMS2 = zeros(3,nbExp);
%  pMS1 = zeros(3,nbExp);
%  pMS2 = zeros(3,nbExp);

for i=1:nbExp
%  
%  	rMS1(1,i) = sleepPairCov{i}.rMS1;
%  	rMS1(2,i) = swsPairCov{i}.rMS1;
%  	rMS1(3,i) = remPairCov{i}.rMS1;
%  
%  	rMS2(1,i) = sleepPairCov{i}.rMS2;
%  	rMS2(2,i) = swsPairCov{i}.rMS2;
%  	rMS2(3,i) = remPairCov{i}.rMS2;
%  
%  	pMS1(1,i) = sleepPairCov{i}.pMS1(1);
%  	pMS1(2,i) = swsPairCov{i}.pMS1(1);
%  	pMS1(3,i) = remPairCov{i}.pMS1(1);
%  
%  	pMS2(1,i) = sleepPairCov{i}.pMS2(1);
%  	pMS2(2,i) = swsPairCov{i}.pMS2(1);
%  	pMS2(3,i) = remPairCov{i}.pMS2(1);
%  

	EV(i) = sleepPairCov{i}.EV;


end
%  
%  meanSlopeChg = zeros(3);
%  stdSlopeChg =zeros(3);
%  
%  meanSlopChg(1) = mean(pMS2(1,:) - pMS1(1,:));
%  meanSlopChg(2) = mean(pMS2(2,:) - pMS1(2,:));
%  meanSlopChg(3) = mean(pMS2(3,:) - pMS1(3,:));
%  
%  meanCorrChg(1) = mean(pMS2(1,:) - pMS1(1,:));
%  meanCorrChg(2) = mean(pMS2(2,:) - pMS1(2,:));
%  meanCorrChg(3) = mean(pMS2(3,:) - pMS1(3,:));

%  
%  figure(1),clf
%  bar(meanSlopChg)
%  
%  figure(2)
%  bar(meanCorrChg)



%  stdSlopeChg = std(pMS2(1,:) - pMS1(1,:));
%  
%  figure(1)
%  bar([(pMS2(1,:) - pMS1(1,:))'  (pMS2(2,:) - pMS1(2,:))' (pMS2(3,:) - pMS1(3,:))'])
%  
%  figure(2)
%  bar([(rMS2(1,:) - rMS1(1,:))'  (rMS2(2,:) - rMS1(2,:))' (rMS2(3,:) - rMS1(3,:))'])

expNb = 1;

%  
%  S1vect = sleepPairCov{expNb}.CS1Vect;
%  S2vect = sleepPairCov{expNb}.CS2Vect;
%  Mvect = sleepPairCov{expNb}.CMVect;

%  figure(1),clf
%  
%  bar(pMS2(1,:) - pMS1(1,:))


%  figure(3),clf
%  
%  bar(rMS2(1,:) - rMS1(1,:))

figure(4)
bar(EV)

%  
%  figure(2),clf
%  hold on;
%  scatter(Mvect,S1vect)
%  	axis([-0.1 0.5 -0.1 0.5])
%  	line([-0.1 0.5],pMS1(2,expNb)*[-0.1 0.5])
%  	xlabel('AWAKE')
%  	ylabel('SLEEP')
%  %  	title('Plot of sin(\Theta)')
%  
%  scatter(Mvect,S2vect,'r')
%  	axis([-0.1 0.5 -0.1 0.5])
%  	line([-0.1 0.5],pMS2(2,expNb)*[-0.1 0.5],'Color','r')
%  %  	ylabel('PRE SLEEP','TextColor','b')
%  hold off;



%  
%  
%  S1vect = remPairCov{expNb}.CS1Vect;
%  S2vect = remPairCov{expNb}.CS2Vect;
%  Mvect = remPairCov{expNb}.CMVect;
%  
%  figure(3),clf
%  hold on;
%  scatter(S1vect,Mvect)
%  	axis([-0.1 0.5 -0.1 0.5])
%  	line([-0.1 0.5],pMS1(3,expNb)*[-0.1 0.5])
%  scatter(S2vect,Mvect,'r')
%  	axis([-0.1 0.5 -0.1 0.5])
%  	line([-0.1 0.5],pMS2(3,expNb)*[-0.1 0.5],'Color','r')
%  hold off;
%  


%  
%  
%  figure(1)
%  scatter(rMS1(1,:),rMS2(1,:))
%  axis([-0.1 0.8 -0.1 0.8]