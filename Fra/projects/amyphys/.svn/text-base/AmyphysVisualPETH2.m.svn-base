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

  
 
  
  
  
  goodTrials_ix = find(Data(trialOutcome) <= 3 & ~isnan(Range(imageOn))) ;
  
  goodTrials_ix = goodTrials_ix(goodTrials_ix < length(Start(baselinePeriod)));
  goodBaseline = subset(baselinePeriod, goodTrials_ix);
  
  goodImageOn = subset(imageOn, goodTrials_ix);
  goodImageOff = subset(imageOff, goodTrials_ix);
  goodFixationStart = subset(fixationStart, goodTrials_ix);
  goodImageOff = ts(max(Range(goodImageOn)+10000, Range(goodImageOff)));
  goodImageCode = Restrict(imageFlags, goodImageOn);
  
  
  
  
  
  
  sc = Restrict(imageFlags, goodImageOn, 'align', 'closest');

  
  
  
  for i = 1:length(S)
     
      %     consider only trials for which CueImageOn fell in the
      %     stableInterval
    [R_on, stable_ix] = Restrict(goodImageOn, stableInterval{i});
    R_off = subset(goodImageOff, stable_ix);
    
    
    six = stable_ix;
    bs = subset(goodBaseline, six);
    
    fh = RasterPETH(S{i}, R_on, -500*10, 1000*10);
    title([cellnames{i} ' - image presentation'], 'interpreter', 'none');
    [p,n,e] = fileparts(cellnames{i});
    saveas(fh, [n, '_img.png'], 'png');

    fh = RasterPETH(S{i}, R_off, -500*10, 1000*10);
    title([cellnames{i} ' - image offset'], 'interpreter', 'none');
    [p,n,e] = fileparts(cellnames{i});
    saveas(fh, [n, '_imgoff.png'], 'png');

    
    F_on = subset(goodFixationStart, stable_ix);
    fh = RasterPETH(S{i}, F_on, -500*10, 1000*10);
    title([cellnames{i} ' - fixspot onset'], 'interpreter', 'none');
    [p,n,e] = fileparts(cellnames{i});
    saveas(fh, [n, '_fixon.png'], 'png');
    
%    keyboard;
    
  end
  
                
  

  AO = A;
  
  
    
    
    
    