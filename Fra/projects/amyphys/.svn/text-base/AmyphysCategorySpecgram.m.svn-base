function AO = AmyphysVisualResponsiveness(A)
  
  
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

  
  A = registerResource(A, 'BsCounts', 'cell', {'AmygdalaCellList', 1}, ...
		       'bsCounts', ...
		       ['spike counts in each baseline periods preceding', ...
		    ' a successful presentation']);
  A = registerResource(A, 'VisualCountsPhasic', 'cell', {'AmygdalaCellList', 1}, ...
		       'visCountsPhasic', ...
		       ['spike counts in  (100-300ms) periods following', ...
		    ' a successful presentation']);
  A = registerResource(A, 'VisualCountsTonic', 'cell', {'AmygdalaCellList', 1}, ...
		       'visCountsTonic', ...
		       ['spike counts in  (300-1000ms) periods following', ...
		    ' a successful presentation']);
   A = registerResource(A, 'VisualCountsTotal', 'cell', {'AmygdalaCellList', 1}, ...
		       'visCountsTotal', ...
		       ['spike counts in  (100-1000ms) periods following', ...
		    ' a successful presentation']);
   A = registerResource(A, 'VisualCountsOff', 'cell', {'AmygdalaCellList', 1}, ...
		       'visCountsOff', ...
		       ['spike counts in  (100-300ms) periods following', ...
		    ' imgoff']);
    A = registerResource(A, 'FixCountsFastPhasic', 'cell', {'AmygdalaCellList', 1}, ...
		       'fixCountsFastPhasic', ...
		       ['spike counts in  (0-100ms) periods following fixation spot', ...
		    ' in a successful presentation']);
     
  A = registerResource(A, 'TotalRatio', 'numeric', {'AmygdalaCellList', 1}, ...
              'totalRatio', ...
              ['ratio between total f.r. and baseline f.r.']);
    A = registerResource(A,  'TotalPval', 'numeric', {'AmygdalaCellList', 1}, ...
             'totalPval', ...
             ['ttest pvalue of total vs. baseline']);
         
  A = registerResource(A, 'TonicRatio', 'numeric', {'AmygdalaCellList', 1}, ...
              'tonicRatio', ...
              ['ratio between tonic f.r. and baseline f.r.']);
        
  A = registerResource(A,  'TonicPval', 'numeric', {'AmygdalaCellList', 1}, ...
             'tonicPval', ...
             ['ttest pvalue of tonic vs. baseline']);
         
  A = registerResource(A,  'PhasicPval', 'numeric', {'AmygdalaCellList', 1}, ...
             'phasicPval', ...
             ['ttest pvalue of phasic vs. baseline']);
         
             
  A = registerResource(A, 'PhasicRatio', 'numeric', {'AmygdalaCellList', 1}, ...
              'phasicRatio', ...
              ['ratio between phasic f.r. and baseline f.r.']);

   A = registerResource(A,  'FixFastPhasicPval', 'numeric', {'AmygdalaCellList', 1}, ...
             'fixFastPhasicPval', ...
             ['ttest pvalue of phasic vs. baseline']);
         
             
  A = registerResource(A, 'FixFastPhasicRatio', 'numeric', {'AmygdalaCellList', 1}, ...
              'fixFastPhasicRatio', ...
              ['ratio between phasic f.r. and baseline f.r.']);

  A = registerResource(A,  'OffPhasicPval', 'numeric', {'AmygdalaCellList', 1}, ...
             'offPhasicPval', ...
             ['ttest pvalue of phasic imgoff vs. baseline']);
         
             
  A = registerResource(A, 'OffPhasicRatio', 'numeric', {'AmygdalaCellList', 1}, ...
              'offPhasicRatio', ...
              ['ratio between phasic imgoff f.r. and baseline f.r.']);


  A = registerResource(A, 'StimCode', 'cell', {'AmygdalaCellList', 1}, ...
		       'stimCode', ...
		       ['stimulus code for each stimulus presentation'] ...
		       );
  
 A = registerResource(A, 'GoodImageTime', 'cell', {'AmygdalaCellList', 1}, ...
                'goodImageTime', ...
                ['times of presentation of stimuli that are viable for analysis (celll stable, fixation suceeded)']);
            
  
  
  
  goodTrials_ix = find(Data(trialOutcome) <= 3 & ~isnan(Range(imageOn))) ;
  
  goodTrials_ix = goodTrials_ix(goodTrials_ix < length(Start(baselinePeriod)));
  goodBaseline = subset(baselinePeriod, goodTrials_ix);
  
  goodImageOn = subset(imageOn, goodTrials_ix);
  goodImageOff = subset(imageOff, goodTrials_ix);
  goodFixationStart = subset(fixationStart, goodTrials_ix);
  goodImageOff = ts(max(Range(goodImageOn)+10000, Range(goodImageOff)));
  goodImageCode = Restrict(imageFlags, goodImageOn);
  
  
  
  bsCounts = cell(length(S), 1);
  visCountsPhasic = cell(length(S), 1);
  visCountsTonic = cell(length(S), 1);  
  visCountsTotal = cell(length(S), 1);  
  visCountsOff = cell(length(S), 1);    
  
  fixCountsFastPhasic = cell(length(S), 1);
  
  stimCode = cell(length(S), 1);
  goodImageTime = cell(length(S), 1);
  
  phasicRatio = zeros(length(S), 1);
  phasicPval = zeros(length(S), 1);
  tonicRatio = zeros(length(S), 1);
  tonicPval = zeros(length(S), 1);
  totalRatio = zeros(length(S), 1);
  totalPval = zeros(length(S), 1);
  fixFastPhasicRatio = zeros(length(S), 1);
  fixFastPhasicPval = zeros(length(S), 1);
  offPhasicRatio = zeros(length(S), 1);
  offPhasicPval = zeros(length(S), 1);
  
  
  
  sc = Restrict(imageFlags, goodImageOn, 'align', 'closest');

  
  
  
  for i = 1:length(S)
     
      %     consider only trials for which CueImageOn fell in the
      %     stableInterval
    [R_on, stable_ix] = Restrict(goodImageOn, stableInterval{i});
    goodImageTime{i} = R_on;
    R_off = subset(goodImageOff, stable_ix);
    six = stable_ix;
    bs = subset(goodBaseline, six);
    % the phasic interval is from 100 to 300 ms from image
    tots = intervalSet(Range(R_on)+1000, Range(R_off) );
    ps = intervalSet(Range(R_on)+1000, Range(R_on) + 3000);
    tos = intervalSet(Range(R_on) + 3000, Range(R_off));
    offs = intervalSet(Range(R_off)+1000, Range(R_off)+3000);
    F_on = subset(goodFixationStart, stable_ix);
    fs = intervalSet(Range(F_on), Range(F_on)+1000);
    
    
    stimCode{i} = subset(goodImageCode, stable_ix);
    
    
    bsc = intervalRate(S{i}, bs);
    bsCounts{i} = (Data(bsc))';
    
    psc = intervalRate(S{i}, ps);
    visCountsPhasic{i} = (Data(psc))';
    phasicRatio(i) = mean(visCountsPhasic{i}) / mean(bsCounts{i});
    [phasicPval(i), t, df] = t_test2(visCountsPhasic{i}, bsCounts{i});
    
    tosc = intervalRate(S{i}, tos);
    visCountsTonic{i} = (Data(tosc))';
    tonicRatio(i) = mean(visCountsTonic{i}) / mean(bsCounts{i});
    [tonicPval(i), t, df] = t_test2(visCountsTonic{i}, bsCounts{i});
    
    totsc = intervalRate(S{i}, tots);
    visCountsTotal{i} = (Data(totsc))';
    totalRatio(i) = mean(visCountsTotal{i}) / mean(bsCounts{i});
    [totalPval(i), t, df] = t_test2(visCountsTotal{i}, bsCounts{i});
   
    fsc = intervalRate(S{i}, fs);
    fixCountsFastPhasic{i} = (Data(fsc))';
    fixFastPhasicRatio(i) = mean(fixCountsFastPhasic{i}) / ...
      mean(bsCounts{i});
    [fixFastPhasicPval(i), t, df] = t_test2(fixCountsFastPhasic{i}, bsCounts{i});

    offsc = intervalRate(S{i}, offs);
    visCountsOff{i} = (Data(offsc))';
    offPhasicRatio(i) = mean(visCountsOff{i}) / mean(bsCounts{i});
    [offPhasicPval(i), t, df] = t_test2(visCountsOff{i}, bsCounts{i});
   
  end
  
                
  
  A = saveAllResources(A);
  AO = A;
  
  
    
    
    
    