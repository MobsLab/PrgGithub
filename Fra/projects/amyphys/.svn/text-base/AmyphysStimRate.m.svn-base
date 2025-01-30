function A = AmyphysStimRate(A)

A = getResource(A, 'IsTwoWay');

A = getResource(A, 'VisualCountsTotal');
A = getResource(A, 'StimCode');
A = getResource(A, 'Experiment');

    %%%%%%%%%%%

        
    A = registerResource(A, 'StimRates', 'cell', {'AmygdalaCellList', 1}, ...
        'stimRates', ...
        ['firing rate for each one of the stimuli']);

load AmyphysStimCodes
stims = dictArray;
stims{'amyphys'} = 'AmyphysStims';
stims{'phys1'} = 'Phys1Stims';
stims{'phys2'} = 'Phys2Stims';

nCells = length(visCountsTotal);

monkeyStim = [];
stimExpression = [];
  
stimRates = cell(nCells,1);

if isTwoWay(1)
    eval(['stimsInUse = ' stims{experiment{1}} ';']);
    for i = 1:nCells
        totr = visCountsTotal{i};
        sc = Data(stimCode{i});
        if strcmp(experiment, 'amyphys')
            sc(sc > 30) = sc(sc > 30) - 30;
        end
        
        msr = zeros(1, length(stimsInUse));
        
        for s = 1:length(stimsInUse)
            if any(sc == stimsInUse(s))
                msr(s) = mean(totr(sc == stimsInUse(s)));
            else
                msr(s) = NaN;
            end
            
        end   
        stimRates{i} = msr;
    end   
end

A = saveAllResources(A);


