function A = AmyphysMonkeyStimRate(A)

A = getResource(A, 'VisualCountsTotal');
A = getResource(A, 'StimCode');
A = getResource(A, 'Experiment');
A = getResource(A, 'IsTwoWay');
A= getResource(A, 'BsCounts');

A = registerResource(A, 'RateThreat', 'numeric', {'AmygdalaCellList', 1}, ...
        'rateThreat', ...
        ['firing rate for threat presentation']);
    
 A = registerResource(A, 'RateLipsmack', 'numeric', {'AmygdalaCellList', 1}, ...
        'rateLipsmack', ...
        ['firing rate for lipsmack presentation']);       

 A = registerResource(A, 'RateNeutral', 'numeric', {'AmygdalaCellList', 1}, ...
        'rateNeutral', ...
        ['firing rate for neutral presentation']);       
    
  A = registerResource(A, 'RatioThreat', 'numeric', {'AmygdalaCellList', 1}, ...
        'ratioThreat', ...
        ['firing rate for threat presentation']);
    
 A = registerResource(A, 'RatioLipsmack', 'numeric', {'AmygdalaCellList', 1}, ...
        'ratioLipsmack', ...
        ['firing rate for lipsmack presentation']);       

 A = registerResource(A, 'RatioNeutral', 'numeric', {'AmygdalaCellList', 1}, ...
        'ratioNeutral', ...
        ['firing rate for neutral presentation']);       

    
        
    A = registerResource(A, 'RateMonkeyStim', 'cell', {'AmygdalaCellList', 1}, ...
        'rateMonkeyStim', ...
        ['firing rate for each one of the monkey stimuli']);       

  A = registerResource(A, 'MonkeyStim', 'cell', {[], []}, ...
      'monkeyStim', ...
      ['the stimulus codes for each of the monkey stimuli']);
  
  A = registerResource(A, 'PostHocPvalThreat', 'numeric', {'AmygdalaCellList', 1}, ...
      'postHocPvalThreat', ...
      ['p value for the post-hoc comparison for threat versus others']);
  
 A = registerResource(A, 'PostHocPvalLipsmack', 'numeric', {'AmygdalaCellList', 1}, ...
      'postHocPvalLipsmack', ...
      ['p value for the post-hoc comparison for lipsmack versus others']);
        
A = registerResource(A, 'PostHocPvalNeutral', 'numeric', {'AmygdalaCellList', 1}, ...
      'postHocPvalNeutral', ...
      ['p value for the post-hoc comparison for neutral versus others']);
 
 A = registerResource(A, 'RateId', 'cell', {'AmygdalaCellList', 1}, ...
     'rateId', ...
     ['firing rate for each of the monkey']);
      
 A = registerResource(A, 'PostHocPvalId', 'cell', {'AmygdalaCellList', 1},      ...
     'postHocPvalId', ...
     ['p values for the post-hoc comparisons for each monkey vs all the others']);
 
 A = registerResource(A, 'PostHocUpDownModulated', 'cell', {'AmygdalaCellList', 1}, ...
     'postHocUpDownModulated', ...
     ['whether the cell was up or down modulated']);
      
  
 A = registerResource(A, 'StimExpression', 'cell', {[],[]}, ...
     'stimExpression', ...
     ['for each monkeyStim, a code indicateing 1 for threat 2 for neutral, 3 for lipsmack']);
load AmyphysLookupTables
lookups = dictArray;
lookups{'amyphys'} = 'Amyphys_StimLookup';
lookups{'phys1'} = 'Phys1_StimLookup';
lookups{'phys2'} = 'Phys2_StimLookup';
lookups{'d&m'} = 'DandM_StimLookup';
lookups{'face'} = 'Face_StimLookup';

nCells = length(visCountsTotal);

rateThreat = zeros(nCells, 1);
rateNeutral = zeros(nCells, 1);
rateLipsmack = zeros(nCells, 1);
ratioThreat = zeros(nCells, 1);
ratioNeutral = zeros(nCells, 1);
ratioLipsmack = zeros(nCells, 1);
postHocPvalThreat = zeros(nCells, 1);
postHocPvalLipsmack = zeros(nCells, 1);
postHocPvalNeutral = zeros(nCells, 1);

rateMonkeyStim = cell(nCells, 1);
rateId = cell(nCells, 1);
postHocPvalId = cell(nCells, 1);
postHocUpDownModulated = cell(nCells, 1);

monkeyStim = [];
stimExpression = [];
if isTwoWay(1)

    eval(['lookupInUse = ' lookups{experiment{1}} ';']);
    k = keys(lookupInUse);
    kMonkey = find(~cellfun('isempty', regexp(k, 'Monkey')));
    monkeyStim = [];
    
    idStim = {};
    l = 0;
    for i = kMonkey
        monkeyStim = [monkeyStim lookupInUse{k{i}}];
        l = l+1;
        idStim{l} = lookupInUse{k{i}};
    end

    kThreat = find(~cellfun('isempty', regexp(k, 'Threat')));
    threatStim = [];
    for i = kThreat
        threatStim = [threatStim lookupInUse{k{i}}];
    end

        
    
    neutralStim = lookupInUse{'Expr Neutral'};
    lipsmackStim = lookupInUse{'Expr Lipsmack'};
    
    stimExpression = zeros(size(monkeyStim));
    stimExpression(ismember(monkeyStim, threatStim)) = 1;
    stimExpression(ismember(monkeyStim, neutralStim)) = 2;
    stimExpression(ismember(monkeyStim, lipsmackStim)) = 3;
   
    for i = 1:nCells
        totr = visCountsTotal{i};
        bs = mean(totr);
        sc = Data(stimCode{i});
        
        mr = find(ismember(sc, monkeyStim));
        thr = find(ismember(sc, threatStim));
        nr = find(ismember(sc, neutralStim));
        lr = find(ismember(sc, lipsmackStim));
        bs = mean(totr(mr));

       rateThreat(i) = mean(totr(thr) );
        rateLipsmack(i) = mean(totr(lr));
        rateNeutral(i) = mean(totr(nr));
        
       ratioThreat(i) = mean(totr(thr) /bs);

       ratioLipsmack(i) = mean(totr(lr)/bs);
        ratioNeutral(i) = mean(totr(nr)/bs);
        
        
        [h, postHocPvalThreat(i), ci, stats] = ttest2(totr(thr), totr([lr; nr]));
        if mean(totr(thr)) <  mean(totr([lr; nr]))
            postHocPvalThreat(i) = - postHocPvalThreat(i);
        end
        
        [h, postHocPvalLipsmack(i), ci, stats] = ttest2(totr(lr), totr([thr; nr]));
        if mean(totr(lr)) < mean(totr([thr; nr]))
            postHocPvalLipsmack(i) = - postHocPvalLipsmack(i);
        end
        
        [h, postHocPvalNeutral(i), ci, stats] = ttest2(totr(nr), totr([lr; thr]));
        if mean(totr(nr)) <  mean(totr([lr; thr]))
            postHocPvalNeutral(i) = - postHocPvalNeutral(i);
        end
        
        msr = zeros(1, length(monkeyStim));
        
        for s = 1:length(monkeyStim)
            msr(s) = mean(totr(sc == monkeyStim(s)));
        end
        
        rateMonkeyStim{i} = msr;
        [rateId{i}, postHocPvalId{i}, postHocUpDownModulated{i}] = idTtests(totr, sc, idStim);
    end

end






A = saveAllResources(A);


function [ri, pval, ud] = idTtests(r, s, idStim)
    
    allStim = [];
    for i = 1:length(idStim)
        allStim = [allStim idStim{i}];
    end
    
    for i = 1:length(idStim)
        stimS = idStim{i};
        stimC = setdiff(allStim, stimS);
        rateS = mean(r(ismember(s, stimS)));
        rateC = mean(r(ismember(s, stimC)));
        ud(i) = sign(rateS-rateC);
        [h, pval(i), ci, stats] = ttest2(r(ismember(s, stimS)), r(ismember(s, stimC)));
        ri(i) = rateS;
    end
    
    
