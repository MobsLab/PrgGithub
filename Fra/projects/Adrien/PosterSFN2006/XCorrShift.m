clear all
parent_dir =  '/media/sdb6/Data'
cd(parent_dir);
A = Analysis(parent_dir);

datasets = List2Cell([ parent_dir filesep 'datasets_rat20.list' ] );

A = getResource(A,'TrialRules',datasets);
A = getResource(A,'MazeEpoch',datasets);
A = getResource(A,'StartTrial',datasets);
A = getResource(A,'TrialOutcome',datasets);
A = getResource(A,'GoodCells',datasets);

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
			
			trialRules{i+nbShifts} = trialRules{i};
			trialOutcome{i+nbShifts} = trialOutcome{i};
			startTrial{i+nbShifts} = startTrial{i};
			mazeEpoch{i+nbShifts} = mazeEpoch{i};
			datasets{i+nbShifts} = datasets{i};
			goodCells{i+nbShifts} = goodCells{i};

		end

		for i=1+nbShifts:-1:1

			t = Range(trialOutcome{day});
			t = t(shiftVect(i)+1:shiftVect(i+1));
			d = Data(trialOutcome{day});
			d = d(shiftVect(i)+1:shiftVect(i+1));
			trialOutcome{day+i-1} = tsd(t,d);

			t = Range(startTrial{day});
			t = t(shiftVect(i)+1:shiftVect(i+1));
			d = Data(startTrial{day});
			d = d(shiftVect(i)+1:shiftVect(i+1));
			startTrial{day+i-1} = tsd(t,d);


		end

		nbDays = nbDays + nbShifts;

	end

	day = day + 1 + nbShifts;

end

for day=2:length(shiftDays)

	A = getResource(A,'SpikeData',datasets{shiftDays(day)});
	A = getResource(A,'CellNames',datasets{shiftDays(day)});
		
	cellsIx = find(goodCells{shiftDays(day)});
	nbCells = length(cellsIx);	

	for i=1:nbCells
		for j=1:i+1:nbCells
			cell1=cellnames{i};
			cell2=cellnames{j};
			ok1=0;
			ok2=0;
			if cell1(3)~=cell2(3)

				f1b = Range(Restrict(S{cellsIx(i)},mazeEpoch{shiftDays(day)}));
				f2b = Range(Restrict(S{cellsIx(j)},mazeEpoch{shiftDays(day)}));
				if length(f1b)&&length(f2b)
					[hLong_before, tLong] = CrossCorr(f1b,f2b,50,200);
					[hShort_before, tShort] = CrossCorr(f1b,f2b,5,200);
					ok1=1;
					f1b = intervalRate(S{cellsIx(i)},mazeEpoch{shiftDays(day)});	
					f2b = intervalRate(S{cellsIx(j)},mazeEpoch{shiftDays(day)});	
				end
				f1a = Range(Restrict(S{cellsIx(i)},mazeEpoch{shiftDays(day)+1}));
				f2a = Range(Restrict(S{cellsIx(j)},mazeEpoch{shiftDays(day)+1}));
				if length(f1a)&&length(f2a)				
					hLong_after = CrossCorr(f1a,f2a,50,200);
					hShort_after = CrossCorr(f1a,f2a,5,200);
					ok2=1;
					f1a = intervalRate(S{cellsIx(i)},mazeEpoch{shiftDays(day)+1});	
					f2a = intervalRate(S{cellsIx(j)},mazeEpoch{shiftDays(day)+1});	

				end

				if ok1&&ok2

					fh = figure(1);clf;

					subplot(2,2,1)
					bar(tLong,hLong_before)	
					title(['Before shift. f1 = ' num2str(round(100*mean(f1b))/100) ', f2 = ' num2str(round(100*mean(f2b))/100)])

					subplot(2,2,2)
					bar(tShort,hShort_before)	
					
					subplot(2,2,3)
					bar(tLong,hLong_after)	
					title(['After shift. f1 = ' num2str(round(100*mean(f1a))/100) ', f2 = ' num2str(round(100*mean(f2a))/100)])

					subplot(2,2,4)
					bar(tShort,hShort_after)	

					saveas(fh,[parent_dir filesep 'Figures' filesep 'XCorrShifts' filesep datasets{shiftDays(day)} cellnames{i} cellnames{j}],'png');
				end

			end

		end
	end

end