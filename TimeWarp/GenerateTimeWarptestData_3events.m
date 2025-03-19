%% Generate data with random jitter to test twPCA
clear all

% parameters
tau = [5,30,20]; % exponential for each event
eventtime = [200,300,450];
totallength = 600; % total length of trial
time = [1:totallength];
% low
jitterrange = 20; %range of time to jitter each neuron
% mid
%  jitterrange = 60; %range of time to jitter each neuron
% high
% jitterrange = 100; %range of time to jitter each neuron

trialnum = 500; % number of trials to simulate
NumNeurons = 200; % number of neurons to simulate
NeuronWeights = abs(randn(NumNeurons,3)+3); % Weights of the three components for all neurons
NoiseLevel = 0.05;

FiringRate = zeros(NumNeurons,trialnum,totallength);
u = heaviside(-10:200);

for tr = 1:trialnum
    
%     % same jitter for all events
    JitterTrial(1:3,tr) = (rand*ones(3,1)-0.5)*jitterrange;

    for ev = 1:length(tau)
        FiringRate_toadd = zeros(1,totallength);
        h = exp(-[0:210]/tau(ev)).* u;
        h = h/max(h);
%         % for different jitter per event
%         JitterTrial(ev,tr) = (rand-0.5)*jitterrange;
        FiringRate_toadd(eventtime(ev) + ceil(JitterTrial(ev,tr))) = 1;
        FiringRate_toadd = conv(h,FiringRate_toadd);
        FiringRate_toadd = FiringRate_toadd(1:end-length(h)+1);
        
        for neur = 1:NumNeurons
            FiringRate(neur,tr,:) = squeeze(FiringRate(neur,tr,:))' + NeuronWeights(neur,ev).*FiringRate_toadd;
        end
        
    end
    
end

% add in some noise
for neur = 1:NumNeurons
    FiringRate_noise(neur,:,:) = FiringRate(neur,:,:) + max(max(FiringRate(neur,:,:)))*NoiseLevel;
    FiringRate_noise(neur,:,:) = 0.2*FiringRate_noise(neur,:,:)./max(max(FiringRate_noise(neur,:,:)));
    
    randvals = rand(trialnum,totallength);
    PoissonSpiking(neur,:,:) =  randvals<squeeze(FiringRate_noise(neur,:,:));
    
    for tr = 1:trialnum
        PSTH(neur,tr,:) = hist(find(PoissonSpiking(neur,tr,:)),[0:10:600]);
    end
    
%     subplot(131)
%     imagesc(squeeze(FiringRate(neur,:,:)))
%     subplot(132)
%     imagesc(squeeze(PoissonSpiking(neur,:,:)))
%     subplot(133)
%     imagesc(squeeze(PSTH(neur,:,:)))
%     
%     pause
%     clf
end

save('/home/vador/Dropbox/MOBS_workingON/TimeWarpAlgorithm/TimeWarpTestData_3Events_LowSameJitter.mat','PoissonSpiking','PSTH','FiringRate','JitterTrial','NeuronWeights','jitterrange')


clf
neur = 1;
load('TimeWarpTestData_3Events_LowSameJitter.mat')
subplot(341)
imagesc(squeeze(FiringRate(neur,:,:)))
title('Firing rate')
ylabel('TrialNum')
subplot(342)
imagesc(squeeze(PoissonSpiking(neur,:,:)))
title('Sim Poisson spking')
subplot(343)
imagesc(squeeze(PSTH(neur,:,:)))
title('PSTH from spiking')
subplot(344)
plot(JitterTrial(1,:),[1:500])

load('TimeWarpTestData_3Events_MidSameJitter.mat')
subplot(345)
imagesc(squeeze(FiringRate(neur,:,:)))
title('Firing rate')
ylabel('TrialNum')
subplot(346)
imagesc(squeeze(PoissonSpiking(neur,:,:)))
title('Sim Poisson spking')
subplot(347)
imagesc(squeeze(PSTH(neur,:,:)))
title('PSTH from spiking')
subplot(348)
plot(JitterTrial(1,:),[1:500])

load('TimeWarpTestData_3Events_HighSameJitter.mat')
subplot(349)
imagesc(squeeze(FiringRate(neur,:,:)))
title('Firing rate')
ylabel('TrialNum')
subplot(3,4,10)
imagesc(squeeze(PoissonSpiking(neur,:,:)))
title('Sim Poisson spking')
subplot(3,4,11)
imagesc(squeeze(PSTH(neur,:,:)))
title('PSTH from spiking')
subplot(3,4,12)
plot(JitterTrial(1,:),[1:500])

