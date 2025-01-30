function A = AmyphysCatSpec(A)

doFig = false;
params.Fs = 200; % everything is brought to seconds units 
params.fpass = [0 50]; 
params.err = 0;
params.trialave = 1;

win = [0.5 1.6] ;
movingwin = [0.25 0.25]  ;

A = getResource(A, 'GoodImageTime');
A = getResource(A, 'StimCode');
A = getResource(A, 'AnovasTotal');
A = getResource(A, 'AmygdalaSpikeData');
A = getResource(A, 'AmygdalaCellList');
A = getResource(A, 'Experiment');

nCells = length(S);

A = registerResource(A, 'SpecGramTime', 'cell', {'AmygdalaCellList', 1}, ...
    'specGramTime', ...
    'specgram time index for specgram');

specGramTime = cell(length(S), 1);

A = registerResource(A, 'SpecGramFreq', 'cell', {'AmygdalaCellList', 1}, ...
    'specGramFreq', ...
    'specgram frequency index for specgram');

specGramFreq = cell(length(S), 1);

A = registerResource(A, 'SpecGramThreat', 'cell', {'AmygdalaCellList', 1}, ...
    'specGramThreat', ...
    'specgram triggered by threat presentation');

specGramThreat = cell(length(S), 1);

A = registerResource(A, 'SpecGramMonkey', 'cell', {'AmygdalaCellList', 1}, ...
    'specGramMonkey', ...
    'specgram triggered by Monkey presentation');

specGramMonkey = cell(length(S), 1);

A = registerResource(A, 'SpecGramNeutral', 'cell', {'AmygdalaCellList', 1}, ...
    'specGramNeutral', ...
    'specgram triggered by neutral faces presentation');

specGramNeutral = cell(length(S), 1);

A = registerResource(A, 'SpecGramLipsmack', 'cell', {'AmygdalaCellList', 1}, ...
    'specGramLipsmack', ...
    'specgram triggered by lipsmack presentation');

specGramLipsmack = cell(length(S), 1);

A = registerResource(A, 'SpecGramObject', 'cell', {'AmygdalaCellList', 1}, ...
    'specGramObject', ...
    'specgram triggered by object presentation');

specGramObject = cell(length(S), 1);

A = registerResource(A, 'SpecGramHuman', 'cell', {'AmygdalaCellList', 1}, ...
    'specGramHuman', ...
    'specgram triggered by human presentation');

specGramHuman = cell(length(S), 1);


load AmyphysLookupTables
lookups = dictArray;
lookups{'amyphys'} = 'Amyphys_StimLookup';
lookups{'phys1'} = 'Phys1_StimLookup';
lookups{'phys2'} = 'Phys2_StimLookup';
lookups{'d&m'} = 'DandM_StimLookup';
lookups{'face'} = 'Face_StimLookup';



isTwoWay = zeros(nCells, 1);

for i = 1:nCells
    aT = anovasTotal{i};
    if has_key(aT, '2WayExprId')
        isTwoWay(i) = 1;
    end
end

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

    k = keys(lookupInUse);
    kHuman = find(~cellfun('isempty', regexp(k, 'Human')));
    humanStim = [];
    for i = kHuman
        humanStim = [humanStim lookupInUse{k{i}}];
    end
    k = keys(lookupInUse);
    kObject = find(~cellfun('isempty', regexp(k, 'Object')));
    objectStim = [];
    for i = kObject
        objectStim = [objectStim lookupInUse{k{i}}];
    end

    kThreat = find(~cellfun('isempty', regexp(k, 'Threat')));
    threatStim = [];
    for i = kThreat
        threatStim = [threatStim lookupInUse{k{i}}];
    end

    neutralStim = lookupInUse{'Expr Neutral'};
    lipsmackStim = lookupInUse{'Expr Lipsmack'};
    
    
    for i = 1:nCells
        cellnames{i}
        sc = Data(stimCode{i});
        g = Range(goodImageTime{i}, 'ts')/10000  ;
        if length(sc) ~= length(g)
            error('Problem with stimulus code');
        end

        rMonkey = g(find(ismember(sc, monkeyStim)));
        rThreat = g(find(ismember(sc, threatStim)));
        rNeutral = g(find(ismember(sc, neutralStim)));
        rLipsmack = g(find(ismember(sc, lipsmackStim)));
        rHuman = g(find(ismember(sc, humanStim)));
        rObject = g(find(ismember(sc, objectStim)));
            
        sCat = {'Monkey', 'Threat', 'Neutral', 'Lipsmack', 'Object', 'Human'};
        data = Data(S{i}) / (10000) ;
        for cat = sCat
            cat = cat{1};
            rCat = eval(['r' cat ]);
            [sp,t,f,R]=mtspecgramtrigpt(data,rCat,win,movingwin,params);
            if doFig
                imagesc(t-win(1), f,log10(abs(sp')+eps) );
                colorbar
                axis xy
                cat 
                keyboard
            end
            
            eval(['specGram' cat '{i} = sp;']);
        end % for cat 
        specGramTime{i} = t;
        specGramFreq{i} = f;
    end % for i = 1:nCells
    
end %if isTwoWay

A = saveAllResources(A)