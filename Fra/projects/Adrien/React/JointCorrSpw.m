function A = JointCorrSpw(A)

%  dataset = '/media/sdb1/Data/Rat18/181014/181014';
%  dset = 'Rat18/181014';

[dummy1,dataset,dummy2] = fileparts(current_dir(A));


%Parameters
windowSize = 20000; % in 10^-4 sec
b = fir1(96,[0.1 0.3]);
doFig = 1;
MAX_RATE = 150;
binSizeMaze = 250;
binSizeSleep = 250;
nbBins = windowSize/binSizeSleep+1;

dataDir = parent_dir(A);
SPWCorr_dir = [dataDir filesep 'SPWCorr2/z25'];

clear eegfname dummy1 dummy2

A = getResource(A,'Sleep2Epoch');
sleep2Epoch = sleep2Epoch{1};

A = getResource(A,'Sleep1Epoch');
sleep1Epoch = sleep1Epoch{1};

A = getResource(A,'MazeEpoch');
mazeEpoch = mazeEpoch{1};

A = getResource(A,'CellNames');
A = getResource(A,'SpikeData');
A = getResource(A,'TrialOutcome');
to = Range(trialOutcome{1});
A = getResource(A,'StartTrial');
st = Range(startTrial{1});
A = getResource(A,'MidRipS1');
midRipS1 = Range(midRipS1{1});
nbRipples1 = length(midRipS1);
A = getResource(A,'MidRipS2');
midRipS2 = Range(midRipS2{1});
nbRipples2 = length(midRipS2);

%  A = getResource(A,'CM');
%  cM = cM{1};

%  
%  
%  A = registerResource(A, 'SpwTrigCorrMS1_PCA', 'tsdArray', {[],1}, ...
%      'spwTrigCorrMS1_PCA', ...
%      'spwTrigCorrMS sleep1/maze correlation of PC');
%  
%  A = registerResource(A, 'SpwTrigCorrMS2_PCA', 'tsdArray', {[],1}, ...
%      'spwTrigCorrMS2_PCA', ...
%      'spw triggered binned sleep2/maze correlation of PC');
%  

%spikes bins:

binSpk = MakeQfromS(S,binSizeSleep);

binSpkS1 = Restrict(binSpk,sleep1Epoch);
zBinSpkS1 = tsd(Range(binSpkS1),zscore(full(Data(binSpkS1))));

binSpkS2 = Restrict(binSpk,sleep2Epoch);
zBinSpkS2 = tsd(Range(binSpkS2),zscore(full(Data(binSpkS2))));

cM = spkZcorrcoef(S,binSizeMaze,mazeEpoch);
nbCells = size(cM,2);
 

% PCA-like analysis on the 3 first components
[PCACoef, PCAvar, PCAexp] = pcacov(cM);

fprintf(['explained variance : ' num2str(sum(PCAexp(1:3))) '\n']);

nbPC = size(PCACoef,1);

reactPCA1 = zeros(nbRipples1,nbPC,nbBins);
reactPCA2 = zeros(nbRipples2,nbPC,nbBins);
reactRaw1 = zeros(nbRipples1,nbBins);
reactRaw2 = zeros(nbRipples2,nbBins);

t0 = midRipS1-windowSize/2;

tic
for i=1:nbRipples1

	tBins = [t0(i):binSizeSleep:t0(i)+windowSize];
	zFiring = Data(Restrict(zBinSpkS1,tBins,'align','closest'))';

	%Raw data:
	for j=1:nbBins;
		popVect = zFiring(:,j);
		norm = popVect'*popVect;
		if (norm ~=0) reactRaw1(i,j) = popVect'*cM*popVect/norm; end;
%  		reactRaw1(i,j) = popVect'*cM*popVect;
	end
	%PCA score
	normVect = sqrt(sum(zFiring.*zFiring));
	reactPCA1(i,:,:) = PCACoef'*zFiring./(ones(nbPC,1)*normVect); %element by element division by norm of popVect
%  	reactPCA1(i,:,:) = PCACoef'*zFiring;


end
toc

t0 = midRipS2-windowSize/2;

tic
for i=1:nbRipples2
	
	tBins = [t0(i):binSizeSleep:t0(i)+windowSize];
	zFiring = Data(Restrict(zBinSpkS2,tBins,'align','closest'))';

	%Raw data:
	for j=1:nbBins;
		popVect = zFiring(:,j);
		norm = popVect'*popVect;
		if (norm ~=0) reactRaw2(i,j) = popVect'*cM*popVect/norm; end;
%  		reactRaw2(i,j) = popVect'*cM*popVect;
	end;

	%PCA score
	normVect = sqrt(sum(zFiring.*zFiring));
	reactPCA2(i,:,:) = PCACoef'*zFiring./(ones(nbPC,1)*normVect); %element by element division by norm of popVect
%  	reactPCA2(i,:,:) = PCACoef'*zFiring;

end
toc

%  keyboard

clear norm i j t t0 maxTime

spwTrigCorrMS1_PCArray = {};
spwTrigCorrMS2_PCArray = {};

for pc=1:nbPC

	tmp = zeros(nbRipples1,nbBins);
	tmp(:,:) = reactPCA1(:,pc,:);
	spwTrigCorrMS1_PCArray = [spwTrigCorrMS1_PCArray; {tsd(midRipS1,tmp)}]; 
	tmp = zeros(nbRipples2,nbBins);
	tmp(:,:) = reactPCA2(:,pc,:);
	spwTrigCorrMS2_PCArray = [spwTrigCorrMS2_PCArray; {tsd(midRipS2,tmp)}];

end

spwTrigCorrMS1_PCA = tsdArray(spwTrigCorrMS1_PCArray);
spwTrigCorrMS2_PCA = tsdArray(spwTrigCorrMS2_PCArray);



%Raw data:

mCorrS1 = mean(reactRaw1);
varCorrS1 = std(reactRaw1)/sqrt(nbRipples1);
varSupS1 = mCorrS1+varCorrS1;
varInfS1 = mCorrS1-varCorrS1;

mCorrS2 = mean(reactRaw2);
varCorrS2 = std(reactRaw2)/sqrt(nbRipples2);
varSupS2 = mCorrS2+varCorrS2;
varInfS2 = mCorrS2-varCorrS2;


times = [-windowSize/(2*binSizeSleep):windowSize/(2*binSizeSleep)];
Ymax = max(max(varSupS1),max(varSupS2));
Ymax = Ymax*(1+0.2*sign(Ymax));
Ymin = min(min(varInfS1),min(varInfS2));
Ymin = Ymin/(1+0.2*sign(Ymin));

fh = figure(6);clf;

subplot(1,2,1)
	hold on;
	plot(times,mCorrS1,'LineWidth',2)
	plot(times,varInfS1,'--r','LineWidth',1)
	plot(times,varSupS1,'--r','LineWidth',1)
	title(['Sleep 1 Epoch'],'FontSize', 15,'FontWeight', 'bold');
	set(gca, 'FontName', 'Verdana');
	set(gca, 'FontWeight', 'bold');
	set(gca, 'FontSize', 14);
	set(gca, 'LineWidth', 2);
	set(gca,'XLim',[-windowSize/(2*binSizeSleep) windowSize/(2*binSizeSleep)]);
	set(gca,'YLim',[Ymin Ymax]);
	set(gca,'XTick',-windowSize/(2*binSizeSleep):windowSize/(4*binSizeSleep):windowSize/(2*binSizeSleep))
	set(gca,'XTickLabel',{num2str(-windowSize/20),num2str(-windowSize/40),'0',num2str(windowSize/40),num2str(windowSize/20)})
	xlabel('time (ms)')
	ylabel('Correlation between sleep 1 and maze epoch')
	hold off;

subplot(1,2,2)
	hold on;
	plot(times,mCorrS2,'LineWidth',2)
	plot(times,varInfS2,'--r','LineWidth',1)
	plot(times,varSupS2,'--r','LineWidth',1)
	title(['Sleep 2 Epoch'],'FontSize', 15,'FontWeight', 'bold');
	set(gca, 'FontName', 'Verdana');
	set(gca, 'FontWeight', 'bold');
	set(gca, 'FontSize', 14);
	set(gca, 'LineWidth', 2);
	set(gca,'XLim',[-windowSize/(2*binSizeSleep) windowSize/(2*binSizeSleep)]);
	set(gca,'YLim',[Ymin Ymax]);
	set(gca,'XTick',-windowSize/(2*binSizeSleep):windowSize/(4*binSizeSleep):windowSize/(2*binSizeSleep))
	set(gca,'XTickLabel',{num2str(-windowSize/20),num2str(-windowSize/40),'0',num2str(windowSize/40),num2str(windowSize/20)})
	xlabel('time (ms)')
	ylabel('Correlation between sleep 2 and maze epoch')

	hold off;


saveas(fh,[SPWCorr_dir filesep dataset 'ch5_z100RawNorm'],'png');
%  saveas(fh,[SPWCorr_dir filesep dataset 'ch5_z100Raw'],'fig');




for i=1:8
	
	corrMS1 = Data(spwTrigCorrMS1_PCArray{i});
	corrMS2 = Data(spwTrigCorrMS2_PCArray{i});
	mCorrS1 = mean(corrMS1);
	varCorrS1 = std(corrMS1)/sqrt(nbRipples1);
	varSupS1 = mCorrS1+varCorrS1;
	varInfS1 = mCorrS1-varCorrS1;
	
	mCorrS2 = mean(corrMS2);
	varCorrS2 = std(corrMS2)/sqrt(nbRipples2);
	varSupS2 = mCorrS2+varCorrS2;
	varInfS2 = mCorrS2-varCorrS2;
	
	
	times = [-windowSize/(2*binSizeSleep):windowSize/(2*binSizeSleep)];
	Ymax = max(max(varSupS1),max(varSupS2));
	Ymax = Ymax*(1+0.2*sign(Ymax));
	Ymin = min(min(varInfS1),min(varInfS2));
	Ymin = Ymin/(1+0.2*sign(Ymin));
	
	if ~(Ymin<Ymax) doFig=0;end;
	
	if doFig
	
	fh = figure(6);clf;
	
	subplot(1,2,1)
		hold on;
		plot(times,mCorrS1,'LineWidth',2)
		plot(times,varInfS1,'--r','LineWidth',1)
		plot(times,varSupS1,'--r','LineWidth',1)
		title(['Sleep 1 Epoch'],'FontSize', 15,'FontWeight', 'bold');
		set(gca, 'FontName', 'Verdana');
		set(gca, 'FontWeight', 'bold');
		set(gca, 'FontSize', 14);
		set(gca, 'LineWidth', 2);
		set(gca,'XLim',[-windowSize/(2*binSizeSleep) windowSize/(2*binSizeSleep)]);
		set(gca,'YLim',[Ymin Ymax]);
		set(gca,'XTick',-windowSize/(2*binSizeSleep):windowSize/(4*binSizeSleep):windowSize/(2*binSizeSleep))
		set(gca,'XTickLabel',{num2str(-windowSize/20),num2str(-windowSize/40),'0',num2str(windowSize/40),num2str(windowSize/20)})
		xlabel('time (ms)')
		ylabel('Correlation between sleep 1 and maze epoch')
		hold off;
	
	subplot(1,2,2)
		hold on;
		plot(times,mCorrS2,'LineWidth',2)
		plot(times,varInfS2,'--r','LineWidth',1)
		plot(times,varSupS2,'--r','LineWidth',1)
		title(['Sleep 2 Epoch'],'FontSize', 15,'FontWeight', 'bold');
		set(gca, 'FontName', 'Verdana');
		set(gca, 'FontWeight', 'bold');
		set(gca, 'FontSize', 14);
		set(gca, 'LineWidth', 2);
		set(gca,'XLim',[-windowSize/(2*binSizeSleep) windowSize/(2*binSizeSleep)]);
		set(gca,'YLim',[Ymin Ymax]);
		set(gca,'XTick',-windowSize/(2*binSizeSleep):windowSize/(4*binSizeSleep):windowSize/(2*binSizeSleep))
		set(gca,'XTickLabel',{num2str(-windowSize/20),num2str(-windowSize/40),'0',num2str(windowSize/40),num2str(windowSize/20)})
		xlabel('time (ms)')
		ylabel('Correlation between sleep 2 and maze epoch')
	
		hold off;
	
	
	saveas(fh,[SPWCorr_dir filesep dataset 'ch5_z100PCNorm' num2str(i)],'png');
%  	saveas(fh,[SPWCorr_dir filesep dataset 'ch5_z25PC' num2str(i)],'fig');
	
	end
	
	
end

%  A = saveAllResources(A)