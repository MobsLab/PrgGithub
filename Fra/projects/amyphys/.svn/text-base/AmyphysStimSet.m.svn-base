function A = AmyphysStimSet(A)





A = getResource(A, 'Experiment');
A = getResource(A, 'AmygdalaCellList');


A = registerResource(A, 'StimSet', 'cell', {1,1}, ...
    'stimSet', ['the stimulus set used for the session']);

stimSet = '';
if  strcmp(experiment, 'phys1') | strcmp(experiment, 'phys2')
  stimSet =  experiment
elseif strcmp(experiment, 'amyphys')
    gg = cellnames{1};
    x = strfind(gg, 'phys') + 4;
    n = (gg(x));
    stimSet = ['amyphys' n];
    display(gg);
    display(stimSet);
    
end















A = saveAllResources(A);
