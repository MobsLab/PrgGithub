
preStartInterval = intervalSet(Range(startTrial) - 25000, Range(startTrial) );
earlyTrialInterval = intervalSet(Range(startTrial), Range(startTrial) +  min(25000, Range(trialOutcome) - Range(startTrial)) );
lateTrialInterval = intervalSet(Range(trialOutcome) - 25000, Range(trialOutcome)) ;
 
for i = 1:length(S)

%Pour les ANOVA	
      preStartRate{i} = intervalRate(S{i}, preStartInterval);
      earlyTrialRate{i} = intervalRate(S{i}, earlyTrialInterval);
      lateTrialRate{i} = intervalRate(S{i}, lateTrialInterval);

%Pour les vecteurs de pop
      vectorPreStartRate(i,:) = (Data(intervalRate(S{i}, preStartInterval)))';
      vectorEarlyTrialRate(i,:) = (Data(intervalRate(S{i}, earlyTrialInterval)))';
      vectorLateTrialRate(i,:) = (Data(intervalRate(S{i}, lateTrialInterval)))';

end

vectorPreStartRate = {vectorPreStartRate};
vectorEarlyTrialRate = {vectorEarlyTrialRate};
vectorLateTrialRate = {vectorLateTrialRate};

 ps = vectorPreStartRate{1};
 et = vectorEarlyTrialRate{1};
 lt = vectorLateTrialRate{1};
 
 figure(1)
 popVect = [ps;et;lt];

 imagesc(corrcoef(popVect));
 colorbar 

 figure(2)
 imagesc(corrcoef(ps));
 colorbar

 figure(3)
 imagesc(corrcoef(et));
 colorbar

 figure(4)
 imagesc(corrcoef(lt));
 colorbar


clear preStartinterval earlyTrialInterval lateTrialInterval preStartRate earlyTrialRate lateTrialRate vectorPreStartRate vectorEarlyTrialRAte vectorLateTrialRate ps et lt