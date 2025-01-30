function SwrSpindlePhase()

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

sleepAll = union(sleepPreEp,sleepPostEp);
swsEp = intersect(sleepAll,LoadEpoch(fbasename,'SWS')); %Exclude Opto stimulations if any
[ripTsd ripEp] = LoadRipples(fbasename);
load('Analysis/Spindles.mat','epSpindles');


nEp = length(Start(swsEp));

spinRipPh = cell(nbSh,1);
spinRipMod = NaN(nbSh,3);


for ii=1:nbSh
    chan = xml_data.ElecGp{ii}+1;

    epSp = []; %Epochs realignes to troughs
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
        
        epSpin = intersect(epSpindles{ii},subset(swsEp,e)); %Detected Spindles Epochs
        
        for sp=1:length(Start(epSpin))
            lfpR = Restrict(lfp,subset(epSpin,sp));
            trIx = LocalMinima(Data(lfpR),10,0);
            rg = Range(lfpR);
            
            rg(trIx(end)+1:end) = [];
            rg(1:trIx(1)-1) = [];
            trIx = trIx-trIx(1)+1;
            ph = interp1(rg(trIx),2*pi*(0:length(trIx)-1),rg);
            
            epSp = [epSp;[rg(1),rg(end)]];
            phSh = [phSh;ph(:)];
            phShRg = [phShRg;rg(:)];
        end
        
    end
    
    ph = tsd(phShRg,phSh);
    epSp = intervalSet(epSp(:,1),epSp(:,2));
    
    d = Restrict(ph,Restrict(ripTsd,epSp));
    if ~isempty(d)
        spinRipPh{ii} = d;
        [mu, Kappa, pval] = CircularMean(Data(d));
        spinRipMod(ii,:) = [mu, pval, Kappa];    
    else
        spinRipPh{ii} = tsd([],[]);
    end
    
end

info = {'Tsd array of SWR '' phase relative to spindles for the different electrode groups';'SWRs'' Spindles Stats'};

SaveAnalysis(pwd,'Spindles',{spinRipPh;spinRipMod},{'spinRipPh';'spinRipMod'},info);