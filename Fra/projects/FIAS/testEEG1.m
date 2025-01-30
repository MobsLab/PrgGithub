
params.Fs = 200;
params.fpass = [0 40];
params.err = [1 0.95];
params.trialave = 0;

%[p,dset,e] = fileparts(pwd);

trials = intervalSet(startTrial, trialOutcome);

%for neeg = 1:4
    %EEG = Restrict(EEGpfc, mazeInterval);  
    EEGhc = Restrict(EEGhc, trials);
    EEGpfc = Restrict(EEGpfc, trials);
    deegpfc = resample(Data(EEGpfc), 600, 6250);
    deeghc = resample(Data(EEGhc), 600, 6250);
    %[spectrumTrials{neeg},f,Serr]=mtspectrumsegc(deeg1,2, params);
    [spectrumTrialsHc,f,Serr]=mtspectrumsegc(deeghc,2, params);
    [spectrumTrialsPfc,f,Serr]=mtspectrumsegc(deegpfc,2, params);
    
%end


%spectrumTrials{7} = f;

%for n = 1:6
    figure(1);
    %plot(f, log10(spectrumTrials{n}));
    plot(f, log10(spectrumTrialsHc));
    title('EEGHc');
    figure(2);
    plot(f, log10(spectrumTrialsPfc));
    title('EEGPfc');
%    keyboard
%end


clear p dset e deeg1 params spectrumMaze spectrumTrials trials f Serr 