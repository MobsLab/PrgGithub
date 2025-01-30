function AO = AmyphysVisualPETH2(A)
  
  debugIS = 0;
  A = getResource(A, 'StableInterval');

  
  A = getResource(A, 'AmygdalaCellList');
  A = getResource(A, 'AmygdalaSpikeData');
  dim_by_cell = {'AmygdalaCellList', 1};
  
  A = getResource(A, 'BaselinePeriod');
  baselinePeriod = baselinePeriod{1};       

  A = getResource(A, 'ImageOn');
  imageOn = imageOn{1};
  A = getResource(A, 'ImageOff');
  imageOff = imageOff{1};
  A = getResource(A, 'Reward');
  reward = reward{1};
  A = getResource(A, 'FixationStart');
  fixationStart = fixationStart{1};
  
  
  A = getResource(A, 'TrialOutcome');
  trialOutcome = trialOutcome{1};
  
  A = getResource(A, 'Experiment');
  
  
  A = getResource(A, 'ImageFlag');
  imageFlags = imageFlags{1};
  A = getResource(A, 'StableInterval');

  A = getResource(A, 'Experiment');
  
 
  
  
  
  goodTrials_ix = find(Data(trialOutcome) <= 3 & ~isnan(Range(imageOn))) ;
  
  goodTrials_ix = goodTrials_ix(goodTrials_ix < length(Start(baselinePeriod)));
  goodBaseline = subset(baselinePeriod, goodTrials_ix);
  
  goodImageOn = subset(imageOn, goodTrials_ix);
  goodImageOff = subset(imageOff, goodTrials_ix);
  goodFixationStart = subset(fixationStart, goodTrials_ix);
  goodImageOff = ts(max(Range(goodImageOn)+10000, Range(goodImageOff)));
  goodImageCode = Restrict(imageFlags, goodImageOn);
  
  
  load AmyphysLookupTables
  
  reward = find(reward, 'isfinite(Tt)');
  
  
  
  sc = Restrict(imageFlags, goodImageOn, 'align', 'closest');

  
  
  
  for i = 1:length(S)
     
      %     consider only trials for which CueImageOn fell in the
      %     stableInterval
    [R_on, stable_ix] = Restrict(goodImageOn, stableInterval{i});
    
    rew = Restrict(reward, stableInterval{i});
   
    fh = RasterPETH(S{i}, rew, -500*10, 1000*10);
    title([cellnames{i} ' - reward delivery'], 'interpreter', 'none');
    [p,n,e] = fileparts(cellnames{i});
    saveas(fh, [n, '_reward.png'], 'png');
    
    if strcmp(experiment, 'amyphys')
        aa ='amyphys'
        R_off = subset(goodImageOff, stable_ix);
        img = subset(goodImageCode, stable_ix);
        d = Data(img);
        im = ismember(d, Amyphys_StimLookup{'Trial Rewarded'});
        
        rew_ix = find(im);
        nonrew_ix = find(~im);
        
        R_off_rew = subset(R_off, rew_ix);
        R_off_nonrew = subset(R_off, nonrew_ix);
        
        
        fh = RasterPETH(S{i}, R_off_rew, -500*10, 1000*10);
        title([cellnames{i} ' - image offset, rewarded'], 'interpreter', 'none');
        [p,n,e] = fileparts(cellnames{i});
        saveas(fh, [n, '_imgoffrew.png'], 'png');
    
        fh = RasterPETH(S{i}, R_off_nonrew, -500*10, 1000*10);
        title([cellnames{i} ' - image offset, non rewarded'], 'interpreter', 'none');
        [p,n,e] = fileparts(cellnames{i});
        saveas(fh, [n, '_imgoffnonrew.png'], 'png');
    end
%    keyboard;
    
  end
 
  AO = A;