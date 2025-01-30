%  
%  parent_dir = '/media/sdb1/Data'
%  
%  cd(parent_dir);
%  datasets = List2Cell([ parent_dir filesep 'datasets_rat20.list' ] );
%  A = Analysis(parent_dir);
%  
%  A = getResource(A,'PCReactDiff',datasets);
%  A = getResource(A,'TrialRules',datasets);
%  

nbDays = length(datasets);
shiftDays = [];
shiftfromL = [];
shiftfromR = [];
shift2L = [];
shift2R = [];
noShiftDaysRules = [];

for i=1:nbDays

	reactDiff = pcReactDiff{i};
	react(i) = sum(abs(reactDiff(1:end)));
	rules = Data(trialRules{i});
	if length(find(diff(rules)~=0)) > 0
		shiftDays = [shiftDays;i];
		if rules(1)==1
			shiftfromR = [shiftfromR;i];
		end
		if rules(1)==3
			shiftfromL = [shiftfromL;i];
		end
		if rules(end)==1
			shift2R = [shift2R;i];
		end
		if rules(end)==3
			shift2L = [shift2L;i];
		end
	else
		noShiftDaysRules = [noShiftDaysRules ;rules(1)];
	end
	
	

end

nbShifts = length(shiftDays);
noShiftDays = setdiff(1:nbDays,shiftDays)
nbNoShifts = length(noShiftDays);

figure(1), clf
hold on;
plot(left(shiftDays)./nbTrials(shiftDays),log(react(shiftDays)),'+r')
for i=1:nbNoShifts

	if noShiftDaysRules(i) == 1
		plot(left(noShiftDays(i))./nbTrials(noShiftDays(i)),log(react(noShiftDays(i))),'go')
	elseif noShiftDaysRules(i) == 2
		plot(left(noShiftDays(i))./nbTrials(noShiftDays(i)),log(react(noShiftDays(i))),'bo')
	elseif noShiftDaysRules(i) == 3
		plot(left(noShiftDays(i))./nbTrials(noShiftDays(i)),log(react(noShiftDays(i))),'mo')
	elseif noShiftDaysRules(i) == 4
		plot(left(noShiftDays(i))./nbTrials(noShiftDays(i)),log(react(noShiftDays(i))),'co')
	end
end



%  
%  figure(1),clf
%  hold on;
%  scatter(log(react(shiftDays)),left(shiftDays)./nbTrials(shiftDays),'g','SizeData',1000)
%  scatter(log(react(shift2L)),left(shift2L)./nbTrials(shift2L),'r')
%  scatter(log(react(shiftfromL)),left(shiftfromL)./nbTrials(shiftfromL),'b')
%  
%  figure(2),clf
%  hold on;
%  scatter(log(react(shiftDays)),right(shiftDays),'g','SizeData',1000)
%  scatter(log(react(shift2R)),right(shift2R),'r','SizeData',500)
%  scatter(log(react(shiftfromR)),right(shiftfromR),'b')
%  
%  figure(3),clf
%  hold on;
%  scatter(log(react(shiftDays)),left(shiftDays),'g','SizeData',1000)
%  scatter(log(react(shift2R)),left(shift2R),'r','SizeData',500)
%  scatter(log(react(shiftfromR)),left(shiftfromR),'b')
%  
%  
%  figure(4),clf
%  hold on;
%  scatter(log(react(shiftDays)),right(shiftDays),'g','SizeData',1000)
%  scatter(log(react(shift2L)),right(shift2L),'r')
%  scatter(log(react(shiftfromL)),right(shiftfromL),'b')



%  
%  nxShiftDays = shiftDays+1;
%  p= [2:nbShifts 1];
%  nxShiftDays(nxShiftDays == shiftDays(p)) = []; % keep days following shifts which are not shift days
%  
%  prevShiftDays = shiftDays-1;
%  p = [nbShifts 1:(nbShifts-1)];
%  prevShiftDays(prevShiftDays == shiftDays(p)) = [];
%  
%  display('correlation w/ error on all days:')
%  [R,P] = corrcoef(log(react),error)
%  
%  display('correlation w/ error on shift days:')
%  [R,P] = corrcoef(log(react(shiftDays)),error(shiftDays))
%  
%  display('correlation w/ error on days following shift:')
%  [R,P] = corrcoef(log(react(nxShiftDays)),error(nxShiftDays))
%  
%  display('correlation w/ error on days before shift:')
%  [R,P] = corrcoef(log(react(prevShiftDays)),error(prevShiftDays))
%  
%  
%  display('correlation w/ correct on all days:')
%  [R,P] = corrcoef(log(react),correct)
%  
%  display('correlation w/ correct on shift days:')
%  [R,P] = corrcoef(log(react(shiftDays)),correct(shiftDays))
%  
%  display('correlation w/ correct on days following shift:')
%  [R,P] = corrcoef(log(react(nxShiftDays)),correct(nxShiftDays))
%  
%  display('correlation w/ correct on days before shift:')
%  [R,P] = corrcoef(log(react(prevShiftDays)),correct(prevShiftDays))



%  
%  figure(1),clf
%  plot([1:nbDays],react);
%  for i=1:length(shiftDays);line(shiftDays(i),1,'LineStyle', 'none', 'Marker', '*', 'MarkerEdgeColor', 'r');end;