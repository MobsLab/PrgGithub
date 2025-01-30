function AO = DIRACPrePostSleep(A)
  
  

  

  warning off
  load([current_dir(A) filesep 'DIRACPosFile0627'], 'epoch_start', 'epoch_end');
  warning on 
  
  
  A = registerResource(A, 'PreSleep1_10min_Epoch', 'cell', {1, 1}, ...
		       'PreSleep1', ...
		       ['the portion of sleep 1 before the 10 min epoch in',...
		  'Sleep1_10min_Epoch' ]);
  
  A = registerResource(A, 'PostSleep2_10min_Epoch', 'cell', {1, 1}, ...
		       'PostSleep2', ...
		       ['the portion of sleep after  the 10 min epoch in',...
		  'Sleep2_10min_Epoch']);
  
 
  EEGfname = List2Cell([current_dir(A) filesep 'ripples_EEG.txt']);
  CR = ReadCR_tsd([current_dir(A) filesep EEGfname{1}]);
  
  
  
  
  epoch_start = epoch_start(1);
  epoch_end = epoch_end(1);
  
  S1 = intervalSet(StartTime(CR), epoch_start-7200000);
  S2 = intervalSet( epoch_end+7200000, EndTime(CR));

  

  PreSleep1{1} = S1;
  PostSleep2{1} = S2;

  
  A = saveAllResources(A);
      
  
  AO = A;
  
  
  