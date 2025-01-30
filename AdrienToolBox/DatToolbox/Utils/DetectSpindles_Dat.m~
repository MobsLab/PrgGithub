function DetectSpindles()

% This programs detects spindles shank by shank during already detected SWS

fname = [fbasename filesep];
analysisDir = [fname 'Analysis'];
if ~exist(analysisDir,'dir')
   mkdir(analysisDir);   
end
matFile = [analysisDir filesep 'Spindles.mat'];

%Parameters
info = LoadXml([fname fb    asename '.xml']);
nbSh = length(info.ElecGp)-1;
nbStd = 1; %Thresholdd for detection
nChannels = info.nChannels;
Fs = info.lfpSampleRate;
ResampleTo = 200;
FreqRange = [6 20];
MinLgth = 0.5; %in sec.

nSmooth = round(ResampleTo/FreqRange(1)*2);
if mod(nSmooth,2)==0
	nSmooth =nSmooth+1;
end


epSpindles = cell(nbSh,1);

load([fname 'SleepStateEpochs'],'epSWS')
    
for e=1:size(epSWS,1)
    h=waitbar(e/size(epSWS,1));
    start = epSWS(e,1);
    duration = epSWS(e,2)-start;
    for ii=1:nbSh
        chan = info.ElecGp{ii}+1;      
        lfp = LoadBinary([fname fbasename '.eeg'],'nChannels',nChannels,'channels',chan,'frequency',Fs,'start',start,'duration',duration);
        for l=1:length(chan)
            lfp(:,l)=lfp(:,l)-mean(lfp(:,l));
        end
        lfp = mean(lfp,2);
        lfp = resample(lfp,ResampleTo,Fs);
        t = (0:length(lfp)-1)/ResampleTo;
        
        lfp = ButFilter(lfp,2,FreqRange/(ResampleTo/2),'bandpass');
        seg = Filter0(ones(nSmooth,1)/nSmooth, abs(lfp));
        thr = nbStd*std(seg);
        seg = tsd(t,seg);
        
        ep = thresholdIntervals(seg,thr);
        ep = mergeCloseIntervals(ep,0.1);
        ep = dropShortIntervals(ep,MinLgth);
        ep = dropLongIntervals(ep,10); %Just in case there's a long noisy epoch...
        
        epSpindles{ii} = [epSpindles{ii};[Start(ep) End(ep)]+start];
        
    end
end
close(h)

save(matFile,'epSpindles')
