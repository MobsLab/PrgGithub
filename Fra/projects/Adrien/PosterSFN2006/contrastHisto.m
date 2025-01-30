%  function A = contrastHisto(A)


MIN_PVAL = 0.05;


parent_dir =  '/media/sdb6/Data'
cd(parent_dir);
A = Analysis(parent_dir);

datasets = List2Cell([ parent_dir filesep 'datasets_noYMPpb.list' ] );

% # conditions
nbC = 4;

%nbEpochs in each trials
nbE = 4;

%nb task
nbT = 4;

nbCells = cell(nbT,1);

% for each task (or rules...) and for each conditions we make a vector containing all the cells

contGlobal = cell(nbT,nbC);
pValGlobal = cell(nbT,nbC);
contSigGlobal = cell(nbT,nbC);
contNoSigGlobal = cell(nbT,nbC);
%  

for focusEpoch=1:5

for i=1:nbT
	
	for j=1:nbC
	
		contGlobal{i,j} = [];
		pValGlobal{i,j} = [];
		contSigGlobal{i,j} = [];
		contNoSigGlobal{i,j} = [];

	end

end

for dset=1:length(datasets)
	
	A = getResource(A, 'ContCE', datasets{dset});
	A = getResource(A, 'ContLR', datasets{dset});
	A = getResource(A, 'ContLPos', datasets{dset});
	A = getResource(A, 'ContLD', datasets{dset});
	
	A = getResource(A, 'PValCE', datasets{dset});
	A = getResource(A, 'PValLR', datasets{dset});
	A = getResource(A, 'PValLPos', datasets{dset});
	A = getResource(A, 'PValLD', datasets{dset});

	for i=1:nbT
		
		contGlobal{i,1} = [contGlobal{i,1} ; contCE{i}];
		contGlobal{i,2} = [contGlobal{i,2} ; contLR{i}];
		contGlobal{i,3} = [contGlobal{i,3} ; contLPos{i}];
		contGlobal{i,4} = [contGlobal{i,4} ; contLD{i}];
		
		pValGlobal{i,1} = [pValGlobal{i,1} ; pValCE{i}];
		pValGlobal{i,2} = [pValGlobal{i,2} ; pValLR{i}];
		pValGlobal{i,3} = [pValGlobal{i,3} ; pValLPos{i}];
		pValGlobal{i,4} = [pValGlobal{i,4} ; pValLD{i}];
	
	end

end

condition = cell(nbC,1);
condition{1} = 'Correct/Error'; 
condition{2} = 'Left/Right';
condition{3} = 'Light left/Light right';
condition{4} = 'Go Light/Go Dark';

name = cell(nbC,1);
name{1} = 'Correct_Error'; 
name{2} = 'Right_Left';
name{3} = 'LightLeft_LightRight';
name{4} = 'GoLight_GoDark';

taskName = cell(nbT,1);
taskName{1} = 'Right Task';
taskName{2} = 'Light Task';
taskName{3} = 'Left Task';
taskName{4} = 'Dark Task';

epoch = cell(nbE,1);
epoch {1} = 'preTrial';
epoch {2} = '1stHalfTrial';
epoch {3} = '2ndHalfpreTrial';
epoch {4} = 'postOutcome';
epoch {5} = 'Global';

%  focusEpoch = 1;

taskBegin = 1;
taskEnd = nbT;
condBegin = 1;
condEnd = nbC;

for task=taskBegin:taskEnd

	nbEpochCells{task} = length(contGlobal{task,1}); % = nbCells * nbEpoch
	nbCells{task} = nbEpochCells{task}/nbE;
	countSigCells = [];

	%First we sort the significant/non significant contrast cells 

	for cond=condBegin:condEnd

		for i=1:nbE:nbEpochCells{task}-3 
			
			if focusEpoch<5
				%take the values of the focus epoch for one cell
				intervalPVal = pValGlobal{task,cond}(i+focusEpoch-1);
				intervalCont = contGlobal{task,cond}(i+focusEpoch-1);
				if intervalPVal<MIN_PVAL
					contSigGlobal{task,cond} = [contSigGlobal{task,cond} intervalCont];
					countSigCells = [countSigCells (i+3)/4];
				else
					contNoSigGlobal{task,cond} = [contNoSigGlobal{task,cond} intervalCont];
				end;
			else
				%take all the values of each epoch for one cell
				intervalPVal = pValGlobal{task,cond}(i:i+nbE-1);
				intervalCont = contGlobal{task,cond}(i:i+nbE-1);
				if sum(intervalPVal<MIN_PVAL)
					%if there are several sig val, we keep the one of these w/ the biggest contrast...
					[merde ix] = max(abs(intervalCont(intervalPVal<MIN_PVAL))); 
					contSigGlobal{task,cond} = [contSigGlobal{task,cond} intervalCont(ix)];
					countSigCells = [countSigCells (i+3)/4];
				else
					% .. otherwise we keep only the one w/ the biggest contrast in the 4 intervals
					[merde ix] = max(abs(intervalCont)); 
					contNoSigGlobal{task,cond} = [contNoSigGlobal{task,cond} intervalCont(ix)];
				end;
			end	

		end

	end

	%And now we compute the histograms...

	histSig = cell(4,1);
	histNoSig = cell(4,1);

	x = -1:0.1:1;
	
	for cond=condBegin:condEnd
			
		[histSig{cond},x] = hist(contSigGlobal{task,cond},x);
		histNoSig{cond} = hist(contNoSigGlobal{task,cond},x);
	
		histNoSig{cond}(1) = 0;
		histNoSig{cond}(end) = 0;

	end
	
	% ...compute mean, std...
	
	for cond=condBegin:condEnd
	
		meanHistSig{cond} = round(100*sum(histSig{cond}.*x)/sum(histSig{cond}))/100;
		meanHistNoSig{cond} = round(100*sum(histNoSig{cond}.*x)/sum(histNoSig{cond}))/100;

		stdHistSig{cond} = round(100*sum(histSig{cond}.*(x.*x))/sum(histSig{cond}))/100;
		stdHistNoSig{cond} = round(100*sum(histNoSig{cond}.*(x.*x))/sum(histNoSig{cond}))/100;

	end

	% ...and we plot them.

	fh = figure(task);clf;
	set(fh,'Name',[taskName{task} ' ' epoch{focusEpoch}],'Position',[300, 300, 800, 600]);	

	for cond=condBegin:condEnd

		%YMax = max((histSig{cond}+histNoSig{cond})/nbCells{task}*100);
	
		subplot(2,2,cond)
		bar(x,[histSig{cond}' histNoSig{cond}']/nbCells{task}*100, 'stack');
		title([condition{cond} ' : ' num2str(round(sum(histSig{cond})/nbCells{task}*100)) '% significant']);
		set(gca,'XLim',[-1 1]);
		Ymax = get(gca,'YLim');
		Ymax = Ymax(2);
		text('Position',[-0.8 0.8*Ymax],'String',['mean : ' num2str(meanHistSig{cond})],'Color','b')
		text('Position',[-0.8 0.7*Ymax],'String',['std : ' num2str(stdHistSig{cond})],'Color','b')
		text('Position',[0.5 0.8*Ymax],'String',['mean : ' num2str(meanHistNoSig{cond})],'Color','r')
		text('Position',[0.5 0.7*Ymax],'String',['std : ' num2str(stdHistNoSig{cond})],'Color','r')


	end	

	saveas(fh,[parent_dir filesep 'Contrast' filesep taskName{task} '_' epoch{focusEpoch}],'fig');
	saveas(fh,[parent_dir filesep 'Contrast' filesep taskName{task} '_' epoch{focusEpoch}],'png');
	
end

end
