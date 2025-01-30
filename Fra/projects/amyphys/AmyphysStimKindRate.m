function A = AmyphysMonkeyStimRate(A)

A = getResource(A, 'VisualCountsTotal');
A = getResource(A, 'StimCode');
A = getResource(A, 'Experiment');
A = getResource(A, 'IsTwoWay');

A = registerResource(A, 'RateObject', 'numeric', {'AmygdalaCellList', 1}, ...
        'rateObject', ...
        ['firing rate for Object presentation']);
    
 A = registerResource(A, 'RateHuman', 'numeric', {'AmygdalaCellList', 1}, ...
        'rateHuman', ...
        ['firing rate for human presentation']);       

 A = registerResource(A, 'RateMonkey', 'numeric', {'AmygdalaCellList', 1}, ...
        'rateMonkey', ...
        ['firing rate for monkey presentation']);       
    
  A = registerResource(A, 'RateObjectUnfamiliar', 'numeric', {'AmygdalaCellList', 1}, ...
        'rateObjectUnfamiliar', ...
        ['firing rate for object unfamliar presentation']);
    
 A = registerResource(A, 'RatioObjectFamiliar', 'numeric', {'AmygdalaCellList', 1}, ...
        'rateObjectFamiliar', ...
        ['firing rate for object familiar presentation']);       

 
        
  A = registerResource(A, 'PostHocPvalMonkey', 'numeric', {'AmygdalaCellList', 1}, ...
      'postHocPvalMonkey', ...
      ['p value for the post-hoc comparison for monkey versus others']);
   A = registerResource(A, 'PostHocPvalHuman', 'numeric', {'AmygdalaCellList', 1}, ...
      'postHocPvalHuman', ...
      ['p value for the post-hoc comparison for human versus others']);
  
  
  A = registerResource(A, 'PostHocPvalObject', 'numeric', {'AmygdalaCellList', 1}, ...
      'postHocPvalObject', ...
      ['p value for the post-hoc comparison for object versus others']);
  
 A = registerResource(A, 'PostHocPvalObjectFamiliar', 'numeric', {'AmygdalaCellList', 1}, ...
      'postHocPvalObjectFamiliar', ...
      ['p value for the post-hoc comparison for object familiar versus others']);
        
A = registerResource(A, 'PostHocPvaObjectUnfamliar', 'numeric', {'AmygdalaCellList', 1}, ...
      'postHocPvalObjectUnfamiliar', ...
      ['p value for the post-hoc comparison for objectUnfamliar versus others']);
 
 
 
load AmyphysLookupTables
lookups = dictArray;
lookups{'amyphys'} = 'Amyphys_StimLookup';
lookups{'phys1'} = 'Phys1_StimLookup';
lookups{'phys2'} = 'Phys2_StimLookup';
lookups{'d&m'} = 'DandM_StimLookup';
lookups{'face'} = 'Face_StimLookup';

nCells = length(visCountsTotal);

rateObject = zeros(nCells, 1);
rateHuman = zeros(nCells, 1);
rateMonkey = zeros(nCells, 1);
rateObjectFamiliar = zeros(nCells, 1);
rateObjectUnfamiliar = zeros(nCells, 1);

postHocPvalHuman = zeros(nCells, 1);
postHocPvalObject = zeros(nCells, 1);
postHocPvalMonkey = zeros(nCells, 1);
postHocPvalObjectFamiliar = zeros(nCells, 1);
postHocPvalObjectUnfamiliar = zeros(nCells, 1);


if isTwoWay(1)

    eval(['lookupInUse = ' lookups{experiment{1}} ';']);
    k = keys(lookupInUse);
    kMonkey = find(~cellfun('isempty', regexp(k, 'Monkey')));
    monkeyStim = [];
    
    
    for i = kMonkey
        monkeyStim = [monkeyStim lookupInUse{k{i}}];
      
    end


    if strcmp(experiment{1}, 'amyphys');
        humanStim = lookupInUse{'Human faces'};
        objectFamiliarStim = lookupInUse{'Object familiar'};
        objectUnfamiliarStim = lookupInUse{'Object unfamiliar'};
    else
        humanStim = lookupInUse{'Human'};
        objectStim = lookupInUse{'Objects'};
    end
        
 
   
    for i = 1:nCells
        totr = visCountsTotal{i};
        sc = Data(stimCode{i});
        
        mr = find(ismember(sc, monkeyStim));
        hr = find(ismember(sc, humanStim));
        rateMonkey(i) = mean(totr(mr));
        rateHuman(i) = mean(totr(hr));
        
        if strcmp(experiment{1}, 'amyphys');
            ofr = find(ismember(sc, objectFamiliarStim));
            our = find(ismember(sc, objectUnfamiliarStim));
            rateObjectFamiliar(i) = mean(totr(ofr));
            rateObjectUnfamiliar(i) = mean(totr(our));
            rateObject(i) = mean(totr([ofr;our])) ;
            
            [h, postHocPvalObjectFamiliar(i), ci, stats] = ttest2(totr(ofr), totr([hr; mr;our]));
            if  mean(totr(ofr)) <  mean(totr([hr; mr; our]))
                postHocPvalObjectFamiliar(i) = -  postHocPvalObjectFamiliar(i);
            end
           [h, postHocPvalObjectUnfamiliar(i), ci, stats] = ttest2(totr(our), totr([hr; mr;ofr]));
            if  mean(totr(our)) <  mean(totr([hr; mr; ofr]))
                postHocPvalObjectUnfamiliar(i) = -  postHocPvalObjectUnfamiliar(i);
            end
            otr = [ofr;our];
            [h, postHocPvalObject(i), ci, stats] = ttest2(totr(otr), totr([hr; mr]));
            if  mean(totr(otr)) <  mean(totr([hr; mr]))
                postHocPvalObject(i) = -  postHocPvalObject(i);
            end

        else
            otr = find(ismember(sc, objectStim));
            rateObject(i) = mean(totr(otr));
            rateObjectFamiliar(i) = NaN ;
            rateObjectUnfamiliar(i) = NaN ;
            [h, postHocPvalObject(i), ci, stats] = ttest2(totr(otr), totr([hr; mr]));
            if  mean(totr(otr)) <  mean(totr([hr; mr]))
                postHocPvalObject(i) = -  postHocPvalObject(i);
            end
        end
        
        
        
        [h, postHocPvalMonkey(i), ci, stats] = ttest2(totr(mr), totr([hr; otr]));
        if  mean(totr(mr)) <  mean(totr([hr; otr]))
            postHocPvalMonkey(i) = -  postHocPvalMonkey(i);
        end
         [h, postHocPvalHuman(i), ci, stats] = ttest2(totr(hr), totr([mr; otr]));
        if  mean(totr(hr)) <  mean(totr([mr; otr]))
            postHocPvalHuman(i) = -  postHocPvalHuman(i);
        end
        
 
    end

end






A = saveAllResources(A);

