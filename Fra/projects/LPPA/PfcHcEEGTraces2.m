function A = PfcHcEEGTraces(A)

A = getResource(A, 'SpectrumMaze');
A = getResource(A, 'SpectrumTrials');



A = registerResource(A, 'PfcTrace2', 'numeric', {1,1}, ...
    'pfcTrace', ...
    [' the best  trace for prefraontal EEG']);

A = registerResource(A, 'HcTrace2', 'numeric', {1,1}, ...
    'hcTrace', ...
    ['the best trace for hippocampal EEG']);

try
    
    % make a mistake so we fall back on manual choice 
    a = rrr;
    A = getResource(A, 'PfcTrace');
    A = getResource(A, 'HcTrace');

catch



    f = spectrumTrials{7};
    for n = 1:6
        figure(1);
        plot(f, log10(spectrumTrials{n}));
        title(['EEG ' num2str(n)]);
        keyboard
    end

    pfcTrace = input('PFC Trace? ');
    hcTrace = input('HCTrace? ');


end


    pfcTrace2 = pfcTrace;
    hcTrace2 = hcTrace;

    A = saveAllResources(A);