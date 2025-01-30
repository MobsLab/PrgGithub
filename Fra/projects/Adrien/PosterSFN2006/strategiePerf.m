clear all
parent_dir =  '/media/sdb6/Data'
cd(parent_dir);
A = Analysis(parent_dir);

datasets = List2Cell([ parent_dir filesep 'datasets_rat20.list' ] );

A = getResource(A,'TrialRules',datasets);
A = getResource(A,'PreTrialFiring',datasets);
A = getResource(A,'FirstHalfTrialFiring',datasets);
A = getResource(A,'SecHalfTrialFiring',datasets);
A = getResource(A,'PostOutcomeFiring',datasets);
A = getResource(A,'TrialOutcome',datasets);
A = getResource(A,'LightRecord',datasets);
A = getResource(A,'CorrectError',datasets);

nbE=4;
nbC=4;

nbDays = length(datasets);
nbShiftsTotal = 0;

day = 1;
shiftDays = [];

while day<nbDays

	rules = Data(trialRules{day});
	shiftVect = [0;find(diff(rules));length(rules)];
	
	nbShifts = length(shiftVect)-2;

	if nbShifts>0
		
        for i=1:nbShifts
            shiftDays = [shiftDays ; day+(i-1)];
        end

		for i=nbDays:-1:day+1	
			correctError{i+nbShifts} = correctError{i};
			lightRecord{i+nbShifts} = lightRecord{i};
			trialOutcome{i+nbShifts} = trialOutcome{i};
			preTrialFiring{i+nbShifts} = preTrialFiring{i};
			firstHalfTrialFiring{i+nbShifts} = firstHalfTrialFiring{i};
			secHalfTrialFiring{i+nbShifts} = secHalfTrialFiring{i};
			postOutcomeFiring{i+nbShifts} = postOutcomeFiring{i};
			trialRules{i+nbShifts} = trialRules{i};

		end

		nbCells = length(preTrialFiring{day});

		for i=1+nbShifts:-1:1
		
			for j=1:nbCells

				preTrialFiring{day+i-1}{j} = preTrialFiring{day}{j}(shiftVect(i)+1:shiftVect(i+1));
				firstHalfTrialFiring{day+i-1}{j} = firstHalfTrialFiring{day}{j}(shiftVect(i)+1:shiftVect(i+1));
				secHalfTrialFiring{day+i-1}{j} = secHalfTrialFiring{day}{j}(shiftVect(i)+1:shiftVect(i+1));
				postOutcomeFiring{day+i-1}{j} = postOutcomeFiring{day}{j}(shiftVect(i)+1:shiftVect(i+1));
				
			end

			t = Range(trialRules{day});
			t = t(shiftVect(i)+1:shiftVect(i+1));
			d = Data(trialRules{day});
			d = d(shiftVect(i)+1:shiftVect(i+1));
			trialRules{day+i-1} = tsd(t,d);
			
			t = Range(trialOutcome{day});
			t = t(shiftVect(i)+1:shiftVect(i+1));
			d = Data(trialOutcome{day});
			d = d(shiftVect(i)+1:shiftVect(i+1));
			trialOutcome{day+i-1} = tsd(t,d);

			t = Range(correctError{day});
			t = t(shiftVect(i)+1:shiftVect(i+1));
			d = Data(correctError{day});
			d = d(shiftVect(i)+1:shiftVect(i+1));
			correctError{day+i-1} = tsd(t,d);

			t = Range(lightRecord{day});
			t = t(shiftVect(i)+1:shiftVect(i+1));
			d = Data(lightRecord{day});
			d = d(shiftVect(i)+1:shiftVect(i+1));
			lightRecord{day+i-1} = tsd(t,d);

		end

		nbDays = nbDays + nbShifts;

	end

	day = day + 1 + nbShifts;

end


perf = zeros(nbDays,1);
highCorrectCells = cell(nbE,1);
highErrorCells = cell(nbE,1);
highContCells = cell(nbE,nbC);
nbCells = zeros(nbDays,1);

for e=1:nbE
	for c=1:nbC

		highContCells{e,c} = zeros(nbDays,1);

	end

	highCorrectCells{e} = zeros(nbDays,1);
	highErrorCells{e} = zeros(nbDays,1);
end

for day=1:nbDays

%  	fprintf([datasets{day} '\n']);

%  	stratShift = [0 ; find(diff(stratVect)) ; length(stratVect)]; % diff ~=0 for the last trials
	
	rate{1} = preTrialFiring{day};
	rate{2} = firstHalfTrialFiring{day};
	rate{3} = secHalfTrialFiring{day};
	rate{4} = postOutcomeFiring{day};

	nbCells(day) = length(rate{1});

%  	nbShift = length(stratShift) - 2;

	Condition = cell(nbC,1);
	% Diff in activity for the correct/error condition
	Condition{1} = Data(correctError{day});
	% for the "rat went left"/"rt went right" cond
	Condition{2} = Data(trialOutcome{day}); 
	% for the "light was on the right"/"light on the left" cond
	Condition{3} = Data(lightRecord{day});
	% for the "rat went to lit arm/rat went to the dark arm" cond
	Condition{4} = ~xor(Condition{2},Condition{3}); 

	
	perf(day) = length(find(Condition{1} == 1))/length(Condition{1});
	
	for e=1:nbE
		for c=1:nbC
			for neurone=1:nbCells(day)
				grp1 = rate{e}{neurone}(Condition{c} == 1);
				grp2 = rate{e}{neurone}(Condition{c} == 0);
		
				if length(grp1)>0
					mGrp1 = mean(grp1);
				else
					mGrp1 = 0;
				end;
				if length(grp2)>0
					mGrp2 = mean(grp2);
				else
					mGrp2 = 0;
				end;

				if (mGrp1 || mGrp2) 
					cont = (mGrp1-mGrp2)/(mGrp1+mGrp2);
				end;

				if abs(cont)>0.5
					highContCells{e,c}(day) = highContCells{c,e}(day) + 100/nbCells(day);
				end;
%  
%  				if cont>0.5
%  					highCorrectCells{e}(day) = highCorrectCells{e}(day) + 1/nbCells(day);
%  				end
%  
%  				if cont<-0.5
%  					highErrorCells{e}(day) = highErrorCells{e}(day) + 1/nbCells(day);
%  				end

	
			end
		end
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

epoch = cell(nbE,1);
epoch{1} = 'preTrial';
epoch{2} = '1stHalfTrial';
epoch{3} = '2ndHalfpreTrial';
epoch{4} = 'postOutcome';
epoch{5} = 'Global';

%  
%  for e=1:1
%  
%  	fh = figure(e),clf;
%  	set(fh,'Name',[epoch{e}],'Position',[300, 300, 1000, 500]);	

%  	subplot(1,2,1)
%  	plot([1:nbDays],highCorrectCells{e},[1:nbDays],perf*max(highCorrectCells{e})/max(perf),'--',[1:nbDays],-1*[0;diff(perf)]*max(highCorrectCells{e})/max(diff(perf)),'--')
%  	title('Correct')
%  	subplot(1,2,2)
%  	plot([1:nbDays],highErrorCells{e},[1:nbDays],perf*max(highErrorCells{e})/max(perf),'--',[1:nbDays],-1*[0;diff(perf)]*max(highErrorCells{e})/max(diff(perf)),'--')
%  	title('Error')
	
%  	deriv = [0 ; diff(perf)];
%  
%  	
%  	subplot(1,2,1)
%  		nonZero = find(highCorrectCells{e});
%  		c = corrcoef(highCorrectCells{e}(nonZero),deriv(nonZero)); %*max(highCorrectCells{e})/max(diff(perf)));
%  		c = c(1,2);
%  		p = polyfit(highCorrectCells{e}(nonZero),deriv(nonZero),1);
%  
%  		hold on;
%  		scatter(highCorrectCells{e},deriv,nbCells,'filled') %*max(highCorrectCells{e})/max(diff(perf))
%  		plot([0:0.1:0.5],([0:0.1:0.5]*p(1)+p(2)),'--r')
%  		text(0.3,0.2,['Corr coef : ' num2str(c)]);
%  		title('Correct')
%  		hold off;
%  
%  	subplot(1,2,2)
%  		nonZero = find(highErrorCells{e});
%  		c = corrcoef(highErrorCells{e}(nonZero),deriv(nonZero)); %*max(highCorrectCells{e})/max(diff(perf)));
%  		c = c(1,2);
%  		p = polyfit(highErrorCells{e}(nonZero),deriv(nonZero),1);
%  
%  		hold on;
%  		scatter(highErrorCells{e},-1*deriv,nbCells,'filled')%*MAX(HIGHERRORCELLS{E})/MAX(DIFF(PERF))
%  		plot([0:0.1:0.5],([0:0.1:0.5]*p(1)+p(2)),'--r')
%  		text(0.3,0.2,['Corr coef : ' num2str(c)]);
%  		title('Error')
%  		hold off;

%  	for c=1:nbC
%  
%  		subplot(2,2,c)
%  		plotyy([1:nbDays],highContCells{e,c},[1:nbDays],perf);
%  		title([condition{c}]);
%  	end





%  	saveas(fh,[parent_dir filesep 'Contrast' filesep 'Scatter_CE-DiffPerf_' epoch{e}],'fig');
%  	saveas(fh,[parent_dir filesep 'Contrast' filesep 'DayByDay_CE-DiffPerf_' epoch{e}],'png');
	
%  end






