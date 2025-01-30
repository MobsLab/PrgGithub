function AverageSleepSpectrogramEpochs(fbasename)

fname = [fbasename filesep];

analysisDir = [fname 'Analysis'];
if ~exist(analysisDir,'dir')
   mkdir(analysisDir);   
end
resFile = [analysisDir filesep 'PSD.mat'];

load([fname 'SleepStateEpochs'],'epREM','epSWS','chanIx');
acqSyst = LoadPar([fname fbasename '.xml']);

Fs = 1250;
params.Fs = Fs;
freqRange = [0 230];
window = 20;
specWindow = 2^round(log2(window*Fs));% choose window length as power of two
nFFT = specWindow*4;
    
chan = chanIx(1); %we take the channel from sleepPre

fprintf('REM epoch...\n')

Srem = [];
d = epREM(:,2)-epREM(:,1);
for e=1:size(epREM,1)
    start = epREM(e,1);
    duration = d(e);
    
    lfp = LoadBinary([fname fbasename '.eeg'],'nChannels',str2num(acqSyst.nChannels),'channels',chan,'frequency',Fs,'start',start,'duration',duration);
    lfp = lfp-mean(lfp);
    [S,f] = whitePSD(lfp,nFFT,Fs,specWindow,freqRange);
    Srem = [Srem S];
end

fprintf('SWS epoch...\n')
Ssws = [];
d = epSWS(:,2)-epSWS(:,1);
for e=1:size(epSWS,1)
    start = epSWS(e);
    duration = d(e);
    lfp = LoadBinary([fname fbasename '.eeg'],'nChannels',str2num(acqSyst.nChannels),'channels',chan,'frequency',Fs,'start',start,'duration',duration);
    lfp = lfp-mean(lfp);
    [S,f] = whitePSD(lfp,nFFT,Fs,specWindow,freqRange);
    Ssws = [Ssws S];        
end

Fsleep=f;
if exist(resFile,'file')
    save(resFile,'Srem','Ssws','Fsleep','-append');
else
    save(resFile,'Srem','Ssws','Fsleep');
end

end
    
    
function [S,f] = whitePSD(lfp,nFFT,Fs,specWindow,freqRange)
%    lfp = Remove60Hz(double(lfp),Fs);
    weeg = WhitenSignal(lfp,Fs*2000,1);
    [S,f] = mtpsd(weeg,nFFT,Fs,specWindow,[],2,'linear',[],freqRange);
end
    