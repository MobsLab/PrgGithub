function A = SpwTrigReactDiff(A)

doFig = 0;


A = getResource(A,'SpwTrigCorrMS1_PCA');
A = getResource(A,'SpwTrigCorrMS2_PCA');
nbPC = length(spwTrigCorrMS2_PCA);

A = registerResource(A, 'PCReactDiff', 'numeric', {[],1}, ...
    'pcReactDiff', ...
    'above threshold princ comp reactivation difference between sleep2 and sleep1');



cd(current_dir(A));
dset = current_dataset(A);
[dummy1,dataset,dummy2] = fileparts(current_dir(A));
cd('..');

[dataDir,dummy1,dummy2] = fileparts(pwd);
SPWCorr_dir = [dataDir filesep 'SPWCorr2'];
cd('..');


nbRipples1 = length(Range(spwTrigCorrMS1_PCA{1}));
nbRipples2 = length(Range(spwTrigCorrMS2_PCA{1}));

windowSize = 50000; % in 10^-4 sec
binSizeSleep = 1000;
nbBins = windowSize/binSizeSleep+1;

peak1Vect = zeros(nbPC,1);
peak2Vect = zeros(nbPC,1);

for pc=1:nbPC

	corrMS1 = Data(spwTrigCorrMS1_PCA{pc});
	corrMS2 = Data(spwTrigCorrMS2_PCA{pc});

	mCorr1 = mean(corrMS1);
	mCorr2 = mean(corrMS2);

	% Select control points to screen reactivation peak
	quartBins = round(nbBins/4);
	ctrlPts1 = [corrMS1(:,1:quartBins);corrMS1(:,3*quartBins:end)];
	ctrlPts2 = [corrMS2(:,1:quartBins);corrMS2(:,3*quartBins:end)];

	mCtrl1 = mean(ctrlPts1);
	mCtrl2 = mean(ctrlPts2);

	varCtrl1 = std(ctrlPts1)/sqrt(nbRipples1);
	varCtrl2 = std(ctrlPts2)/sqrt(nbRipples2);

	maxVarSup1 = max(mCtrl1+varCtrl1);
	maxVarSup2 = max(mCtrl2+varCtrl2);

	minVarInf1 = min(mCtrl1-varCtrl1);
	minVarInf2 = min(mCtrl2-varCtrl2);

	peak1 = mCorr1((nbBins-1)/2:(nbBins+1)/2);
	peak2 = mCorr2((nbBins-1)/2:(nbBins+1)/2);

	maxPeak1 = max(peak1(peak1 > maxVarSup1));
	if length(maxPeak1)>0
		peak1Vect(pc) = maxPeak1 - mean(mCtrl1);
	end;
	
	minPeak1 = min(peak1(peak1 < minVarInf1));
	if length(minPeak1)>0
		if peak1Vect(pc) == 0
			peak1Vect(pc) = minPeak1 - mean(mCtrl1);
		else
			keyboard;
		end;
	end;
	
	maxPeak2 = max(peak2(peak2 > maxVarSup2));
	if length(maxPeak2)>0
		peak2Vect(pc) = maxPeak2 - mean(mCtrl2);
	end;
	
	minPeak2 = min(peak2(peak2 < minVarInf2));
	if length(minPeak2)>0
		if peak2Vect(pc) == 0
			peak2Vect(pc) = minPeak2 - mean(mCtrl2);
		else
			keyboard;
		end;
	end;

%  	keyboard
end

pcReactDiff = {peak2Vect-peak1Vect};
	
if doFig

	fh = figure(1),clf
	bar(peak1Vect)
	saveas(fh,[SPWCorr_dir filesep dataset 'PCReact1_Thr'],'png');
	%  saveas(fh,[SPWCorr_dir filesep dataset 'PCReactDiff'],'fig');
	
	fh = figure(2),clf
	bar(peak2Vect)
	saveas(fh,[SPWCorr_dir filesep dataset 'PCReact2_Thr'],'png');
	%  saveas(fh,[SPWCorr_dir filesep dataset 'PCReactRate2'],'fig');
	
	
	
	fh = figure(3),clf
	bar(peak2Vect-peak1Vect)
	saveas(fh,[SPWCorr_dir filesep dataset 'PCReactDiff_Thr'],'png');
	%  saveas(fh,[SPWCorr_dir filesep dataset 'PCReactDiff'],'fig');

end;

A = saveAllResources(A);


