%  function A =  PCscore(A)


binSizeMaze = 1000;

A = getResource(A,'MazeEpoch',dset);
mazeEpoch = mazeEpoch{1};

A = getResource(A,'SpikeData', dset);

A = getResource(A,'CellNames', dset);
A = getResource(A,'TrialOutcome', dset);
side = Data(trialOutcome{1});
to = Range(trialOutcome{1});
A = getResource(A,'StartTrial', dset);
st = Range(startTrial{1});

A = getResource(A,'CorrectError',dset);
ce = Data(correctError{1});

nbCells = length(S);


%  
%  %Filter EEG and find Ripples
%  %  eegS = Restrict(EEG5,sleep1Epoch);
%  %  eegSFilt = filtfilt(b,1,Data(eegS));
%  %  sigma = std(eegSFilt);
%  %  eegSFilt = tsd(Range(eegS),eegSFilt);
%  %  [stRip midRip1 endRip] = findRipples(eegSFilt,5*sigma,2*sigma);
%  %  midRip1 = Range(midRip1);
%  %  
%  %  
%  %  eegS = Restrict(EEG5,sleep2Epoch);
%  %  eegSFilt = filtfilt(b,1,Data(eegS));
%  %  sigma = std(eegSFilt);
%  %  eegSFilt = tsd(Range(eegS),eegSFilt);
%  %  [stRip midRip2 endRip] = findRipples(eegSFilt,5*sigma,2*sigma);
%  %  midRip2 = Range(midRip2);
%  %  
%  %  
%  %  clear eegS b dset stRip endRip dataDir eegSFilt
%  
%  


%Avoid correlation computation between cells of the same TT

for i=1:nbCells

	for j=i+1:nbCells
		cell1 = cellnames{i};
		cell2 = cellnames{j};
		if (cell1(3) == cell2(3))
			cM(i,j) = 0;
			cM(j,i) = 0;
		end
	end

end

% bins spikes and computes correlation coefficients of spikes during maze epoch
binSpk = MakeQfromS(S,binSizeMaze);
%  cM = spkZcorrcoef(S,binSizeMaze,mazeEpoch);
cM = spkLogcorrcoef(S,binSizeMaze,intervalset(st,to));


zFiring = Data(Restrict(binSpk,mazeEpoch));
tBins = full(Range(Restrict(binSpk,mazeEpoch)));
zFiring = full(log(zFiring+10^-6))';

[PCACoef, PCAvar, PCAexp] = pcacov(cM);

pc1 = PCACoef(:,1);
pc2 = PCACoef(:,2);
pc3 = PCACoef(:,3);

scorePC1 = conv(pc1'*zFiring,gausswin(10));
scorePC1 = tsd(tBins,scorePC1(5:end-5)');

scorePC2 = conv(pc2'*zFiring,gausswin(10));
scorePC2 = tsd(tBins,scorePC2(5:end-5)');

scorePC3 = conv(pc3'*zFiring,gausswin(10));
scorePC3 = tsd(tBins,scorePC3(5:end-5)');

%  
%  pc1_1 = zeros(length(pc1),1);
%  pc1_2 = zeros(length(pc1),1);
%  pc1_1(2) = 1;
%  pc1_2(15) = 1;
%  
%  scorePC1_1 = conv(pc1_1'*zFiring,gausswin(10));
%  scorePC1_1 = tsd(tBins,scorePC1_1(5:end-5)');
%  
%  scorePC1_2 = conv(pc1_2'*zFiring,gausswin(10));
%  scorePC1_2 = tsd(tBins,scorePC1_2(5:end-5)');
%  
%  scorePC1_2 = conv(pc1_2'*zFiring,gausswin(10));
%  scorePC1_2 = tsd(tBins,scorePC1_2(5:end-5)');
%  
%  
%  stC = st(ce==1);
%  
figure(1),clf
hold on;
plot(Range(scorePC1),Data(scorePC1),'b');
plot(Range(scorePC2),-Data(scorePC2),'m');
for i=1:length(to);line(to(i),4,'LineStyle', 'none', 'Marker', '*', 'MarkerEdgeColor', 'r');end;
for i=1:length(st);line(st(i),4,'LineStyle', 'none', 'Marker', '*', 'MarkerEdgeColor', 'g');end;
hold off;


%  for i=1:lengt(to)-1	
%  	figure(1),clf
%  	hold on;
%  	sPC1 = Restrict(scorePC1,to(i),to(i+1));
%  	sPC2 = Restrict(scorePC2,to(i),to(i+1));
%  	plot(Range(scorePC1),Data(scorePC1),'b');
%  	plot(Range(scorePC3),Data(scorePC2),'r');
%  	line(st(i+1),4,'LineStyle', 'none', 'Marker', '*', 'MarkerEdgeColor', 'g')
%  	hold off;
%  end


 
%  
%  %  scorePC1_L = Restrict(scorePC1,Range(phiL),'align','closest') 
%  %  scorePC1_R = Restrict(scorePC1,Range(phiR),'align','closest') 
%  

%  
%  phiTrial = tsd([],[]);
%  is = intervalSet(0,0);
%  
%  for i=1:length(side)
%  
%  	if side(i)==1
%  		phi = Restrict(phiL,to(i),to(i+1),'align','next');
%  		tBegin = Range(Restrict(phiL,st(i),'align','next'));
%  		is = cat(is,intervalSet(tBegin,to(i)));
%  	else
%  		phi = Restrict(phiR,st(i),to(i+1),'align','next');
%  		tBegin = Range(Restrict(phiR,st(i),'align','next'));
%  		is = cat(is,intervalSet(tBegin,to(i)));
%  
%  	end
%  		
%  	tN = [Range(phiTrial);Range(phi)];
%  	vN = [Data(phiTrial);Data(phi)];
%  	phiTrial = tsd(tN,vN);
%  
%  end
%  
%  for i=1:length(side)-1
%  
%  	is = cat(is,intervalSet(to(i),to(i+1)));
%  
%  end
%  
%  nbTrials = length(side);




%  
%  figure(2),clf
%  hold on;
%  
%  for i=1:nbTrials-1
%  
%  	isTrial = subset(is,i+1);
%  	score = Restrict(scorePC1,isTrial,'align','closest');
%  %  	scatter(1-Data(Restrict(phiTrial,Range(score),'align','closest')),Data(score),'MarkerFaceColor',[i/nbTrials i/nbTrials 0.5]);
%  %  	plot(1-Data(Restrict(phiTrial,Range(score),'align','closest')),Data(score),'Color',[i/nbTrials i/nbTrials 0.5])
%  
%  	tBegin = Start(isTrial);
%  	
%  	tEnd = Stop(isTrial);
%  scatter((Range(score)-tBegin)/(tEnd-tBegin),Data(score),'MarkerFaceColor',[i/nbTrials i/nbTrials 0.5]);
%  	plot((Range(score)-tBegin)/(tEnd-tBegin),Data(score),'Color',[i/nbTrials i/nbTrials 0.5])
%  	
%  end

%  l = ceil(length(Data(scorePC1))/10);
%  
%  for i=1:l
%  	plot3(dPC1(i*10:(i+1)*10),dPC2(i*10:(i+1)*10),dPC3(i*10:(i+1)*10),'Color',[i/l i/l 0.5])
%  	pause(0.01)
%  end
%  
%  toC = to(find(ce==0));
%  
%  dPC1 = Data(Restrict(scorePC1,toC-20000,toC+20000));
%  dPC2 = Data(Restrict(scorePC2,toC-20000,toC+20000));
%  
%  %  dPC3 = Data(scorePC3);
%  
%  scatter(dPC1,dPC2);
%  
%  %  for i=1:length(to)-1
%  %  
%  %  	dPC1 = Data(Restrict(scorePC1,to(i),to(i+1)));
%  %  	dPC2 = Data(Restrict(scorePC2,to(i),to(i+1)));
%  %  
%  %  	plot(dPC1,dPC2);
%  %  	pause(1);
%  %  
%  %  end
%  
%  
%  
%  hold off;