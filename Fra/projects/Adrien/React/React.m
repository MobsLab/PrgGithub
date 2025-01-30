%  expSet = {'Rat18/1014/','Rat18/1017/','Rat18/1018/','Rat18/1021/','Rat18/1024/','Rat15/150704/','Rat15/150705/','Rat15/150706/','Rat15/150721/'};

dataDir = '/media/sdc6/Data';

cd(dataDir);

A = Analysis(pwd);

datasets = List2Cell('datasets_noYMPpb.list');

nbExp = length(datasets);


%Firing Rate modulation
%  
%  rReact = zeros(nbExp,1);
%  rControl = zeros(nbExp,1);
%  
%  
%  
%  for t=1:nbExp
%  
%  	fprintf(['Exp : Rat' expSet{t} '\n']);
%  	[rReact(t) rControl(t)] = LogFiring(expSet{t});
%  	
%  end

%Pair Covariation

sleepPairCov = cell(nbExp,1);
sleepPairCovShuffle = cell(nbExp,1);



for t=1:nbExp

	PairCovResult = {3};

	fprintf(['Exp : ' expSet{t} '\n']);
%  	sleepPairCov{t} = PairCov(binnedFiringRate(expSet{t},1000,1,0));
	sleepPairCovShuffle{t} = PairCov(binnedFiringRate(expSet{t},1000,1,0));
end






%  
%  
%  
%  %SPW Pair Covariation
%  
%  for t=1:nbExp
%  
%  	fprintf(['Exp : Rat' expSet{t} '\n']);
%  	swsPairCov = PairCovSPW(expSet{t},2);
%  	
%  end
%  
%  for t=1:nbExp
%  
%  	fprintf(['Exp : Rat' expSet{t} '\n']);
%  	remPairCov = PairCovREM(expSet{t},2);
%  	
%  end


%  
%  figure(1), clf
%  scatter(rMS1,rMS2)
%  axis([-1 1 -1 1])
%  line([0 1],[0 1],'LineStyle','--')
%  
%  

%  figure(2),clf
%  scatter(rMS1,rMS2,rMSPW1,rMSPW2)
%  line([0 1],[0 1],'LineStyle','--')
%  
%  
%  
%  figure(2),clf
%  scatter(rControl,rReact)
%  axis([-1 1 -1 1])
%  line([0 1],[0 1],'LineStyle','--')
%  
%  figure(3),clf
%  scatter(EV,rReact)
%  axis([-1 1 -1 1])
