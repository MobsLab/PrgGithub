
doSpec = true;
doStart = false;
doPost = true;
doCohgram = true;

cd('/home/fpbatta/Data/LPPA');
A = Analysis('/home/fpbatta/Data/LPPA');

dset = 'Rat15/150713';
neeg = 3;
neeghc = 5;

A = getResource(A, 'MazeInterval', dset);
mazeInterval = mazeInterval{1};
A = getResource(A, 'StartTrial', dset);
startTrial = startTrial{1};

A = getResource(A, 'TrialOutcome', dset);
trialOutcome = trialOutcome{1};

A = getResource(A, 'PostReward', dset);
postReward = postReward{1};


A = getResource(A, 'CorrectError', dset);
correctError= correctError{1};


trials = intervalSet(startTrial, trialOutcome);

cd(parent_dir(A))
cd(dset)

eegfname = [dset(7:end) 'eeg' num2str(neeg) '.mat'];
load(eegfname)
eval(['EEG = EEG' num2str(neeg), ';']);
eval(['clear EEG' num2str(neeg) ';']);


eegfnamehc = [dset(7:end) 'eeg' num2str(neeghc) '.mat'];
load(eegfnamehc)
eval(['EEGhc = EEG' num2str(neeghc), ';']);
eval(['clear EEG' num2str(neeghc) ';']);


EEG = Restrict(EEG, mazeInterval);
EEGhc = Restrict(EEGhc,mazeInterval);

params.Fs = 200;
params.fpass = [0 40];
params.err = [2, 0.95];
params.trialave = 0;

%%%%%%%%%
if doSpec
    EEGrest = Restrict(EEG, trials);
    deeg1 = resample(Data(EEGrest), 600, 6250);
    
  [S,f,Serr]=mtspectrumsegc(deeg1,2, params);

    sr = S;
    fr = f;

    % sr = resample(S, 1, 500);
    % fr = resample(f, 1, 500);

    figure
    plot(fr, log10(sr));
    %errorbar(fr, log10(sr), log10(Serr));
    title(eegfname);
end
%%%%%%%%%%

if doCohgram
    EEGresthc = Restrict(EEGhc, trials);
    deeghc = resample(Data(EEGresthc), 600, 6250);
    %deeg1 = resample(Data(EEG));
    if(length(deeg1) > length(deeghc))
        deeg1 = deeg1(1:length(deeghc));
    elseif length(deeghc) > length(deeg1)
        deeghc = deeghc(1:length(deeg1));
    end
    
        
    movingWin = [1 0.5];
    [C,phi,S12,S1,S2,t,f]=cohgramc(deeg1,deeghc,movingwin,params);
    figure;
    imagesc(t, f, C');
    axis xy
    [C,phi,S12,S1,S2,f,confC,phierr,Cerr]=coherencyc(deeg1,deeghc,params);
    figure
    Csm = smooth(C, 1000);
    plot(f,Csm);
    
    keyboard
end
%%%%%%%%%%%%%%
if doStart
    deeg1 = resample(Data(EEG), 600, 6250);

    E = Range(startTrial, 's')-StartTime(EEG, 's');
    movingwin = [1 0.5];
    win = [5 10];

    figure

    [S,t,f,Serr]=mtspecgramtrigc(deeg1,E,win,movingwin,params);
    imagesc(t-5,f, log10(S'));
    title([eegfname ' - startTrial']);
end
%%%%%%%%

if doPost
    trg = startTrial
    deeg1 = resample(Data(EEG), 600, 6250);

    ix_corr = find(Data(correctError) ==1);
    ix_err= find(Data(correctError) ==0);

    E = Range(subset(trg, ix_corr), 's')-StartTime(EEG, 's');
    movingwin = [1 0.5];
    win = [5 30];

    figure

    [S,t,f,Serr]=mtspecgramtrigc(deeg1,E,win,movingwin,params);
    keyboard
    cax = [];
   for n = 1:size(S,3)
       st = squeeze(S(:,:,n));
        imagesc(t-5,f, log10(st'));
        title([eegfname ' - startTrial correct']);
        if isempty(cax)
            cax = caxis;
        else
            caxis(cax);
        end
        axis xy
        keyboard
   end
    
    %%%%
    E = Range(subset(trg, ix_err), 's')-StartTime(EEG, 's');
    movingwin = [1 0.5];

    [S,t,f,Serr]=mtspecgramtrigc(deeg1,E,win,movingwin,params);

    figure
   for n = 1:size(S,3)
       st = squeeze(S(:,:,n));
        imagesc(t-5,f, log10(st'));
        title([eegfname ' - startTrial error']);
        if isempty(cax)
            cax = caxis;
        else
            caxis(cax);
        end
        axis xy
        keyboard
   end
    
end