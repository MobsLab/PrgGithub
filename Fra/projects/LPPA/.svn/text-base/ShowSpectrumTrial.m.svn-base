function A = ShowSpectrumTrial(A)

A = getResource(A, 'SpectrumMaze');
A = getResource(A, 'SpectrumTrials');
A = getResource(A, 'SpectrumTrialsErr');


A = getResource(A,'PfcTrace');
A = getResource(A, 'HcTrace');



pfcTrace
hcTrace

f = spectrumTrials{7};
for n = 1:6
    figure(1);
    plot(f, log10(spectrumTrials{n}));
    title(['EEG ' num2str(n)]);
    keyboard
end

