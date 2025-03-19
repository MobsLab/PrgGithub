cd /media/nas4/ProjetMTZL/Mouse778/20181218
clear all
TimeAroundEvent = 2;

% Options For calculation
AfterOnly = 'AferOnly'; % If is set to 'AferOnly', only do post-acc time, if ''BefAndAfter' before and after
NormBreathPhase = 'NoNormBreath'; % If is set to 'NormBreath', norm by breathingPhase, If is set to 'NoNormBreath' doesn't

% load correct LFP for accelero and clean it up
load('LFPData/LFP34.mat')
a = Data(LFP);
a(a<-3.5e4)=NaN;
a(a>-1)=NaN;
aint = naninterp(a);
A=tsd(Range(LFP),[0;diff(aint)]);
LFPClean = tsd(Range(LFP),aint);
LFPClean = tsd(Range(LFP),Data(LFPClean)-movmean(Data(LFPClean),1250*60))

% Get breathing phase
load('BreathingInfo_ZeroCross.mat')
AllPeaks=[0:2*pi:2*pi*(length(Data(Breathtsd))-1)];
Y=interp1(Range(Breathtsd,'s'),AllPeaks,Range(LFP,'s'));
PhaseInterpol=tsd(Range(LFP),mod(Y,2*pi));

% Load the times of detected events
load('NeuronResponseToMovement/Results.mat')

% Classify the types of movement
[MAcc,TAcc]=PlotRipRaw(LFPClean,Start(AccBurst,'s'),5000,0,0);
[EigVect,EigVals]=PerformPCA(zscore(TAcc')');
times = Start(AccBurst);
timesStp = Stop(AccBurst);
[val,ind] = sort(EigVect(:,2));
times = Start(AccBurst);
timessorted = times(ind);

figure
subplot(131)
DatMat = sortrows([EigVect(:,2),zscore(TAcc')']);
imagesc(MAcc(:,1),1:size(DatMat,1),DatMat)
hold on
line([-3 -3],[1 400],'color','b','linewidth',5)
line([-3 -3],[900 1300],'color','r','linewidth',5)
clim([-2 2])
xlabel('time to onset(s)')
ylabel('Events ordered by 2nd eigenvectot')


EventType{1} = sort(timessorted(1:400)); % Normal events
EventType{2} = sort(timessorted(900:1300)); % MTZl specific events

clear MRespi TRespi
[MRespi{1},TRespi{1}]=PlotRipRaw(PhaseInterpol,EventType{1}/1E4,5000,0,0);
[MRespi{2},TRespi{2}]=PlotRipRaw(PhaseInterpol,EventType{2}/1E4,5000,0,0);

subplot(232)
plot(MAcc(:,1),MRespi{1}(:,2),'b')
xlim([-2 2])
ylim([0 2*pi])
xlabel('time to onset(s)')
ylabel('Average phase')
title('Respi phase on type 1 events')
subplot(235)
plot(MAcc(:,1),MRespi{2}(:,2),'r')
xlim([-2 2])
ylim([0 2*pi])
xlabel('time to onset(s)')
ylabel('Average phase')
title('Respi phase on type 2 events')

% Get neuron firing triggered on events that we also see in SAL animals
load('/media/nas4/ProjetMTZL/Mouse778/20181218/NeuronResponseToMovement/ResultsNormMov.mat')
clear AllNeur
for n = 1:length(sq)
    AllNeur(n,:) = Data(sq{n});
end
subplot(233)
imagesc(MAcc(:,1),1:size(AllNeur,1),zscore(AllNeur')')
clim([-2 2])
xlabel('time to onset(s)')
ylabel('NeuronNum')
title('Neuron firing on type 1 events')

% Get neuron firing triggered on events that we also see in SAL animals
load('/media/nas4/ProjetMTZL/Mouse778/20181218/NeuronResponseToMovement/ResultsWeirdMov.mat')
clear AllNeur
for n = 1:length(sq)
    AllNeur(n,:) = Data(sq{n});
end
subplot(236)
imagesc(MAcc(:,1),1:size(AllNeur,1),zscore(AllNeur')')
clim([-2 2])
xlabel('time to onset(s)')
ylabel('NeuronNum')
title('Neuron firing on type 2 events')

