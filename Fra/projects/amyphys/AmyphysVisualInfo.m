function AO = AmyphysVisualInfo(A)
  
  
  A = getResource(A, 'StableInterval');
  A = getResource(A, 'Experiment');
  experiment = experiment{1};
  twoWayExperiments = {'amyphys', 'phys1', 'phys2'};
  
  
  kgroups = dictArray;
  kgroups{'amyphys'} = {'Monkey', 'Object', 'Human'};
  kgroups{'phys1'} = {'Monkey', 'Object', 'Human', 'Animal'};
  kgroups{'phys2'} = {'Monkey', 'Object', 'Human', 'Animal'};
  kgroups{'d&m'} = {'Monkey', 'Dog'};
  kgroups{'face'} = {'Expr Fullbody', 'Expr Faces'};
  
  load AmyphysLookupTables

  lookup = dictArray;
  lookup{'amyphys'} = Amyphys_StimLookup;
  lookup{'phys1'} = Phys1_StimLookup;
  lookup{'phys2'} = Phys2_StimLookup;
  lookup{'d&m'} = DandM_StimLookup;
  lookup{'face'} = Face_StimLookup;
  
  A = getResource(A, 'AmygdalaCellList');
  A = getResource(A, 'AmygdalaSpikeData');
  dim_by_cell = {'AmygdalaCellList', 1};
  
  A = getResource(A, 'BaselinePeriod');
  baselinePeriod = baselinePeriod{1};       

  A = getResource(A, 'ImageOn');
  imageOn = imageOn{1};
  
  A = getResource(A, 'TrialOutcome');
  trialOutcome = trialOutcome{1};
    
  
  A = getResource(A, 'ImageFlag');
  imageFlags = imageFlags{1};
  A = getResource(A, 'StableInterval');

  
A = registerResource(A, 'IdInfo', 'cell', {'AmygdalaCellList', 1}, ...
		       'idInfo', ...
		       ['information timecourse for the id of the stimulus']);

A = registerResource(A, 'StimInfo', 'cell', {'AmygdalaCellList', 1}, ...
		       'stimInfo', ...
		       ['information timecourse for the kind of the  of the stimulus']);

A = registerResource(A, 'MonkeyInfo', 'cell', {'AmygdalaCellList', 1}, ...
		       'monkeyInfo', ...
		       ['information timecourse for the monkey id']);

A = registerResource(A, 'ExprInfo', 'cell', {'AmygdalaCellList', 1}, ...
		       'exprInfo', ...
		       ['information timecourse for the monkey id']);

  
  idInfo = cell(length(cellnames), 1);
  stimInfo = cell(length(cellnames), 1);
  monkeyInfo = cell(length(cellnames), 1);
  exprInfo = cell(length(cellnames), 1);
  
  
  goodTrials_ix = find(Data(trialOutcome) <= 3 & ~isnan(Range(imageOn))) ;
  goodTrials_ix = goodTrials_ix(goodTrials_ix < length(Start(baselinePeriod)));
  goodImageOn = subset(imageOn, goodTrials_ix);
  goodImageCode = Restrict(imageFlags, goodImageOn);
  
  stimCode = cell(length(S), 1);
  
  
  sc = Restrict(imageFlags, goodImageOn, 'align', 'closest');

  binSize = 100; % in ms
  binning = regular_interval(-200, 1200, binSize, binSize, ...
      'TimeUnits', 'ms');
  
   start_b = Start(binning);
   end_b = End(binning);
  
  for i = 1:length(S)
     
      %     consider only trials for which CueImageOn fell in the
      %     stableInterval
    [R_on, stable_ix] = Restrict(goodImageOn, stableInterval{i});
    six = stable_ix;
    stimCode{i} = subset(goodImageCode, stable_ix);
    Ti = (Range(R_on))';
    
    startMatrix = repmat(Ti, length(start_b), 1) + ...
        repmat(start_b, 1, length(Ti));
    startMatrix = startMatrix(:);
    
    endMatrix = repmat(Ti, length(end_b), 1) + ...
        repmat(end_b, 1, length(Ti));
    endMatrix = endMatrix(:);
    
    allBinning = intervalSet(startMatrix, endMatrix);
    
    binnedFiring = intervalCount(S{i}, allBinning);
    binnedFiring = reshape(Data(binnedFiring), length(start_b), length(Ti));
    
    % at this point binnedFiring is a matrix where each row represent all 
    % the trials at a certain time lag nbins x ntrials
    % sc is a colunm ntrials
    
    sc = Data(stimCode{i});
    
    ii = zeros(length(start_b), 1);
    si = zeros(length(start_b), 1);
    mi = zeros(length(start_b), 1);
    ei = zeros(length(start_b), 1);
    
    inforsOption.max_b = 40;
    inforsOption.timeWin = binSize;
    inforsOption.min_t = 3;
    inforsOption.max_t = 100;
    inforsOption.s0err = 0;
    
    sc0  = sc-1; % the zero based version of sc
    for sb = 1:length(start_b)
        ii(sb) = infors(sc0, (binnedFiring(sb,:))', max(sc(:)), inforsOption);
    end
    
        
    
    gr = getGroups(sc, lookup{experiment}, kgroups{experiment});
    gr0 = gr(find(gr))-1;
    bf = binnedFiring(:,find(gr));
    
    for sb = 1:length(start_b)
      si(sb) = infors(gr0, (bf(sb,:))', max(gr), inforsOption);
    end
    
    
    if strmatch(experiment, twoWayExperiments)
        mgroups = {'Monkey', 'Expr'};
        [grm, levelKeys] = getMultiGroups(sc, lookup{experiment},mgroups);
        gz = ones(size(grm{1}));

        for iii = 1:length(grm)
            gz = gz .* grm{iii};
        end
        gz = find(gz);

        for iii = 1:length(grm)
            gp = grm{iii};
            gp = gp(gz);
            grm{iii} = gp;
        end

        bf = binnedFiring(:,gz);
        gr0_monkey = grm{1}-1;
        gr0_expr = grm{2}-1;
        for sb = 1:length(start_b)
            mi(sb) = infors(gr0_monkey, (bf(sb,:))', max(grm{1}(:)), inforsOption);
            ei(sb) = infors(gr0_expr, (bf(sb,:))', max(grm{2}(:)), inforsOption);
        end  
    else
        ei = [];
        mi = [];
    end
    
    idInfo{i} = ii;
    stimInfo{i} = si;
    exprInfo{i} = ei;
    monkeyInfo{i} = mi;
    
    
    
    
    
    
    
    
    
   
  end
  
                
  
  
  
  
  A = saveAllResources(A);
  AO = A;
  
  
function stims = getStims(dict, ks)
stims = [];
for i = 1:length(ks);
    stims = [stims dict{ (ks{i}) }];
end


    
function gr = getGroups(sc, dict, kgroups)
gr = zeros(size(sc));
k = keys(dict);

for i = 1:length(kgroups)
    ks = strmatch(kgroups{i}, k);
    ks = k(ks);
    kstims{i} = getStims(dict, ks);
    gr(ismember(sc, kstims{i})) = i;

end


function [grm, levelKeys] = getMultiGroups(sc, dict, kgroups)
    
    grm = cell(1, length(kgroups));
    k = keys(dict); % all the keys
    
    
    for g = 1:length(kgroups) % each item in kroups is a level
        gr = zeros(size(sc));
        ks = strmatch(kgroups{g}, k); % indices to all the keys for that
                                      % level
        sgroups = k(ks);
        levelKeys{g} = sgroups;
        for i = 1:length(sgroups)
            sstims = dict{ (sgroups{i}) };
            gr(ismember(sc, sstims)) = i;
        end
        
        grm{g} = gr;
    end
    
    