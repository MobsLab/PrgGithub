function ThetaPhase(channel)

% USAGE FindHDCells(channel)
%     -channel is the Hpc channel
% This function computes spikes' phase relative to theta during waking and
% REM
%
% Must be launched from the folder containing data
% Adrien Peyrache 2012

%Parameters
%thetaR

fbasename = extractfbasename(pwd);
xml_data = LoadXml([fbasename '.xml']);
lfp = LoadLfp(fbasename,xml_data.nChannels,channel);

load('Analysis/BehavEpochs.mat');
load('Analysis/SpikeData.mat','S','shank');
sleepAll = union(sleepPreEp,sleepPostEp);
remEp = intersect(sleepAll,LoadEpoch(fbasename,'REM')); %Exclude Opto stimulations if any

S = S(shank<9);
nbC = length(S);


lfp = LoadLfp(fbasename,90,65);
dLfp = Data(lfp);
dLfp = resample(dLfp,1,5);
rg = Range(lfp);
rg = rg(1:5:end);   

b = fir1(16,[2 20]/(1250/10));
dLfp = filtfilt(b,1,dLfp);

lfp = tsd(rg,abs(dLfp));
badEp = thresholdIntervals(lfp,1500); %empirical values here to remove artifacts
badEp = mergeCloseIntervals(badEp,20000);
badEp = intervalSet(Start(badEp)-9999,End(badEp)+9999);
badEp = mergeCloseIntervals(badEp,20000);
badEp = dropShortIntervals(badEp,10);
goodEp = timeSpan(lfp)-badEp;
goodEp = dropShortIntervals(goodEp,10000);

% h = hilbert(dLfp);
% ph = atan2(imag(h),real(h));
% ph = tsd(rg,ph);
% Let's look for the troughs. At 250Hz (1250/5), 2 troughs cannont be
% closer than 20 points (if theta reaches 12Hz);
trghs = LocalMinima(dLfp,20,0);

% Here we interpolate between trough in time. Hilbert is bad (non uniform
% distribution of phases in most cases).
ph = interp1(rg(trghs),2*pi*(0:length(trghs)-1),rg); 
% Then, we just need to mod this value with 2pi
ph = tsd(rg,mod(ph,2*pi));

thetaPh = cell(length(S),1);
thetaModWake = zeros(length(S),3);
thetaModREM = zeros(length(S),3);
wakeEp = intersect(wakeEp,goodEp);
remEp = intersect(remEp,goodEp);

S = Restrict(S,union(wakeEp,remEp));

for c=1:length(S)
    
    thetaPh{c} = Restrict(ph,S{c}); %There was a bug here, function should be restarted
    [mu, Kappa, pval] = CircularMean(Data(Restrict(thetaPh{c},wakeEp)));
    thetaModWake(c,:) = [mu, pval, Kappa];    
    [mu, Kappa, pval] = CircularMean(Data(Restrict(thetaPh{c},remEp)));
    thetaModREM(c,:) = [mu, pval, Kappa];
    
end

info = {'Tsd Array of cell spikes'' phase relative to theta';'Wake Theta Stats: 1st column, preferred theta phase; 2nd, p-value; 3rd, kappa value';'Same as thetaModWake but during REM'};

SaveAnalysis(pwd,'ThetaInfo',{thetaPh;thetaModWake;thetaModREM},{'thetaPh';'thetaModWake';'thetaModREM'},info);