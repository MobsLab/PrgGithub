function CellSpindlePhase()

% USAGE SpindlePhase()
% This function computes spikes' and ripples' phase relative to spindles during SWS
%
% Must be launched from the folder containing data
% Adrien Peyrache 2012

ResampleTo = 250;
FreqRange = [8 20];

[dummy fbasename dummy] = fileparts(pwd);
xml_data = LoadXml([fbasename '.xml']);

nChannels = xml_data.nChannels;
Fs = xml_data.lfpSampleRate;
nbSh = length(xml_data.ElecGp);

load('Analysis/BehavEpochs.mat');
load('Analysis/SpikeData.mat','S','shank');
sleepAll = union(sleepPreEp,sleepPostEp);
swsEp = intersect(sleepAll,LoadEpoch(fbasename,'SWS')); %Exclude Opto stimulations if any
[ripTsd ripEp] = LoadRipples(fbasename);
load('Analysis/Spindles.mat','epSpindles');

S = S(shank<9);
nbC = length(S);

nEp = length(Start(swsEp));

spindlePh = cell(nbC,1);
spindlesMod = NaN(nbC,3);

spinRipPh = cell(nbSh,1);
spinRipMod = NaN(nbSh,3);

for ii=1:nbSh
    chan = xml_data.ElecGp{ii}+1;

    phShRg = []; %timestamps of phase
    phSh = []; %phase
    for e=1:nEp
        h=waitbar(e/nEp);
        start = Start(subset(swsEp,e),'s');
        duration = tot_length(subset(swsEp,e),'s');
        lfp = LoadBinary([fbasename '.eeg'],'nchannels',nChannels,'channels',chan,'start',start,'duration',duration,'frequency',Fs);
        rg = (0:length(lfp)-1)/Fs+start;
        for l=1:length(chan)
            lfp(:,l)=lfp(:,l)-mean(lfp(:,l));
        end
        
        lfp = mean(lfp,2);
        lfp = resample(lfp,ResampleTo,Fs);
        rg = rg(1:Fs/ResampleTo:end);
        lfp = ButFilter(lfp,2,FreqRange/(ResampleTo/2),'bandpass');     
        lfp = tsd(10000*rg,lfp);
        trIx = LocalMinima(Data(lfp),10,0);
        ph = interp1(rg(trIx),2*pi*(0:length(trIx)-1),rg);
        phShRg = [phShRg;Range(lfp)];
        phSh = [phSh;mod(ph(:),2*pi)];
        
    end
    
    ph = tsd(phShRg,phSh);
    
    ix = find(shank==ii);
    for c=1:length(ix)
        d = Restrict(ph,Restrict(S{ix(c)},epSpindles{ii}));
        if ~isempty(d)
            spindlePh{ix(c)} = d;
            [mu, Kappa, pval] = CircularMean(Data(d));
            spindlesMod(ix(c),:) = [mu, pval, Kappa];
        else
            spindlePh{ix(c)} = tsd([],[]);
        end
    end
    
    d = Restrict(ph,Restrict(ripTsd,epSpindles{ii}));
    
    if ~isempty(d)
        spinRipPh{ii} = d;
        [mu, Kappa, pval] = CircularMean(Data(d));
        spinRipMod(ii,:) = [mu, pval, Kappa];
        
    else
        spinRipPh{ii} = tsd([],[]);
    end
    
end

info = {'Tsd Array of cell spikes'' phase relative to spindles';'Cells'' Spindles Stats: 1st column, preferred theta phase; 2nd, p-value; 3rd, kappa value'};
info = [info;{'Tsd array of SWR '' phase relative to spindles for the different electrode groups';'SWRs'' Spindles Stats'}];

SaveAnalysis(pwd,'Spindles',{spindlePh;spindlesMod;spinRipPh;spinRipMod},{'spindlePh';'spindlesMod';'spinRipPh';'spinRipMod'},info);