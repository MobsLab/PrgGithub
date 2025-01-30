function AO = AmyphysVisualResponsiveness(A)
  
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
    % the phasic interval is from 100 to 300 ms from image
    
    fh = RasterPETH(S{i}, R_on, -500, 1000);
    saveas(fh, [cellnames{i}, '_img'], 'png');

    
    
    bsc = intervalRate(S{i}, bs);
    bsCounts{i} = (Data(bsc))';
    
    psc = intervalRate(S{i}, ps);
    visCountsPhasic{i} = (Data(psc))';
    
    baselineRate(i) = rate(S{i}, bs);
    phasicRatio(i) = mean(visCountsPhasic{i}) / mean(bsCounts{i});
    [phasicPval(i), t, df] = t_test2(visCountsPhasic{i}, bsCounts{i});
    
    tosc = intervalRate(S{i}, tos);
    visCountsTonic{i} = (Data(tosc))';
    tonicRatio(i) = mean(visCountsTonic{i}) / mean(bsCounts{i});
    [tonicPval(i), t, df] = t_test2(visCountsTonic{i}, bsCounts{i});
    
    fsc = intervalRate(S{i}, fs);
    fixCountsFastPhasic{i} = (Data(fsc))';
    fixFastPhasicRatio(i) = mean(fixCountsFastPhasic{i}) / ...
        mean(bsCounts{i});
    [fixFastPhasicPval(i), t, df] = t_test2(fixCountsFastPhasic{i}, bsCounts{i});
  end
  
                
  
  A = saveAllResources(A);
  AO = A;
  
  
    
    
    
    