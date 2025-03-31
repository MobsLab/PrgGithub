%noiseWithDeltas

clear 
%load data
load ChannelsToAnalyse/PFCx_deep
eval(['load LFPData/LFP',num2str(channel)])
LFPdeep=LFP;
clear LFP
load ChannelsToAnalyse/PFCx_sup
eval(['load LFPData/LFP',num2str(channel)])
LFPsup=LFP;
clear LFP
clear channel
load StateEpochSB SWSEpoch Wake
clear number

%% detection of delta waves
minDeltaDuration = 75;
freqDelta=[1 5];
thD = 2;
tlarge = 1000;

%diff between deep and sup
k=1;
for i=0.1:0.1:4
    distance(k)=std(Data(LFPdeep)-i*Data(LFPsup));
    k=k+1;
end
Factor=find(distance==min(distance))*0.1;
EEGsleepDiff=ResampleTSD(tsd(Range(LFPdeep),Data(LFPdeep) - Factor*Data(LFPsup)),100);
Filt_diff = FilterLFP(EEGsleepDiff, freqDelta, 1024);
pos_filtdiff = max(Data(Filt_diff),0);
std_diff = std(pos_filtdiff(pos_filtdiff>0));  % std that determines thresholds

%threshold crossing
thresh_delta = thD * std_diff;
all_cross_thresh = thresholdIntervals(tsd(Range(Filt_diff), pos_filtdiff), thresh_delta, 'Direction', 'Above');
DeltaOffline = dropShortIntervals(all_cross_thresh, minDeltaDuration * 10); % crucial element for noise detection.
large_deltas = intervalSet(Start(DeltaOffline)-tlarge, End(DeltaOffline)+tlarge);

%deltas
nb_deltas = length(length(large_deltas));
delta_ampli = zeros(1,nb_deltas);
for i=1:nb_deltas
    subDelta = subset(large_deltas,i);
    delta_ampli(i) = max(Data(Restrict(LFPsup, subDelta)));
end

high_delta = find(delta_ampli>1400);
middle_delta = find(delta_ampli>900 & delta_ampli<1100); 
low_delta = find(delta_ampli<700);



%% Random delta waves
% Create a long signal of pink noise (30min at 20khZ)
signoise = pinknoise(10 * 60 * 1250) * 50;

% signal with 200ms between each delta
new_sig1 = signoise;
spacing = 0.2 * 1250; %min time between two deltas
t=1;
i=1; 
while 1
    subDelta = subset(large_deltas,i);
    sig_deltas = Data(Restrict(LFPsup, subDelta));
        
    if t + length(sig_deltas) > length(new_sig1)
        break
    end
    
    new_sig1(t:t+length(sig_deltas)-1) = sig_deltas;
    t = t + length(sig_deltas) + spacing + randi([-10 10]);
    i=i+1;
end

% signal with 500ms between each delta
new_sig2 = signoise;
spacing = 0.5 * 1250; %min time between two deltas
t=1;
i=1; 
while 1
    subDelta = subset(large_deltas,i);
    sig_deltas = Data(Restrict(LFPsup, subDelta));
        
    if t + length(sig_deltas) > length(new_sig2)
        break
    end
    
    new_sig2(t:t+length(sig_deltas)-1) = sig_deltas;
    t = t + length(sig_deltas) + spacing + randi([-10 10]);
    i=i+1;
end

% signal with 2s between each delta
new_sig3 = signoise;
spacing = 2 * 1250; %min time between two deltas
t=1;
i=1; 
while 1
    subDelta = subset(large_deltas,i);
    sig_deltas = Data(Restrict(LFPsup, subDelta));
        
    if t + length(sig_deltas) > length(new_sig3)
        break
    end
    
    new_sig3(t:t+length(sig_deltas)-1) = sig_deltas;
    t = t + length(sig_deltas) + spacing + randi([-10 10]);
    i=i+1;
end

%% Compute spectrum
figure, hold on,
[spectrum,~,f] = MTSpectrum(signoise','frequency',1250, 'range',[0 20]);
subplot(2,2,1),hold on, plot(f,spectrum), ylim([0 3E4]), title('pink noise')
[spectrum,~,f] = MTSpectrum(new_sig1','frequency',1250, 'range',[0 20]);
subplot(2,2,2),hold on, plot(f,spectrum), ylim([0 3E4]), title('spacing  200ms')
[spectrum,~,f] = MTSpectrum(new_sig2','frequency',1250, 'range',[0 20]);
subplot(2,2,3),hold on, plot(f,spectrum), ylim([0 3E4]), title('spacing  500ms')
[spectrum,~,f] = MTSpectrum(new_sig3','frequency',1250, 'range',[0 20]);
subplot(2,2,4),hold on, plot(f,spectrum), ylim([0 3E4]), title('spacing  2s')



%% High delta waves
% Create a long signal of pink noise (30min at 20khZ)
signoise = pinknoise(10 * 60 * 1250) * 50;

% signal with 200ms between each delta
new_sig1 = signoise;
spacing = 0.2 * 1250; %min time between two deltas
t=1;
i=1; 
while i<=length(high_delta)
    subDelta = subset(large_deltas,high_delta(i));
    sig_deltas = Data(Restrict(LFPsup, subDelta));
        
    if t + length(sig_deltas) > length(new_sig1)
        break
    end
    
    new_sig1(t:t+length(sig_deltas)-1) = sig_deltas;
    t = t + length(sig_deltas) + spacing + randi([-10 10]);
    i=i+1;
end

% signal with 500ms between each delta
new_sig2 = signoise;
spacing = 0.5 * 1250; %min time between two deltas
t=1;
i=1; 
while i<=length(high_delta)
    subDelta = subset(large_deltas,high_delta(i));
    sig_deltas = Data(Restrict(LFPsup, subDelta));
        
    if t + length(sig_deltas) > length(new_sig2)
        break
    end
    
    new_sig2(t:t+length(sig_deltas)-1) = sig_deltas;
    t = t + length(sig_deltas) + spacing + randi([-10 10]);
    i=i+1;
end

% signal with 2s between each delta
new_sig3 = signoise;
spacing = 2 * 1250; %min time between two deltas
t=1;
i=1; 
while i<=length(high_delta)
    subDelta = subset(large_deltas,high_delta(i));
    sig_deltas = Data(Restrict(LFPsup, subDelta));
        
    if t + length(sig_deltas) > length(new_sig3)
        break
    end
    
    new_sig3(t:t+length(sig_deltas)-1) = sig_deltas;
    t = t + length(sig_deltas) + spacing + randi([-10 10]);
    i=i+1;
end

%% Compute spectrum
figure, hold on,
[spectrum,~,f] = MTSpectrum(signoise','frequency',1250, 'range',[0 20]);
subplot(2,2,1),hold on, plot(f,spectrum), ylim([0 3E4]), title('pink noise')
[spectrum,~,f] = MTSpectrum(new_sig1','frequency',1250, 'range',[0 20]);
subplot(2,2,2),hold on, plot(f,spectrum), ylim([0 3E4]), title('spacing  200ms (high delta)')
[spectrum,~,f] = MTSpectrum(new_sig2','frequency',1250, 'range',[0 20]);
subplot(2,2,3),hold on, plot(f,spectrum), ylim([0 3E4]), title('spacing  500ms (high delta)')
[spectrum,~,f] = MTSpectrum(new_sig3','frequency',1250, 'range',[0 20]);
subplot(2,2,4),hold on, plot(f,spectrum), ylim([0 3E4]), title('spacing  2s (high delta)')



%% Middle delta waves
% Create a long signal of pink noise (30min at 20khZ)
signoise = pinknoise(10 * 60 * 1250) * 50;

% signal with 200ms between each delta
new_sig1 = signoise;
spacing = 0.2 * 1250; %min time between two deltas
t=1;
i=1; 
while i<=length(middle_delta)
    subDelta = subset(large_deltas,middle_delta(i));
    sig_deltas = Data(Restrict(LFPsup, subDelta));
        
    if t + length(sig_deltas) > length(new_sig1)
        break
    end
    
    new_sig1(t:t+length(sig_deltas)-1) = sig_deltas;
    t = t + length(sig_deltas) + spacing + randi([-10 10]);
    i=i+1;
end

% signal with 500ms between each delta
new_sig2 = signoise;
spacing = 0.5 * 1250; %min time between two deltas
t=1;
i=1; 
while i<=length(middle_delta)
    subDelta = subset(large_deltas,middle_delta(i));
    sig_deltas = Data(Restrict(LFPsup, subDelta));
        
    if t + length(sig_deltas) > length(new_sig2)
        break
    end
    
    new_sig2(t:t+length(sig_deltas)-1) = sig_deltas;
    t = t + length(sig_deltas) + spacing + randi([-10 10]);
    i=i+1;
end

% signal with 2s between each delta
new_sig3 = signoise;
spacing = 2 * 1250; %min time between two deltas
t=1;
i=1; 
while i<=length(middle_delta)
    subDelta = subset(large_deltas,middle_delta(i));
    sig_deltas = Data(Restrict(LFPsup, subDelta));
        
    if t + length(sig_deltas) > length(new_sig3)
        break
    end
    
    new_sig3(t:t+length(sig_deltas)-1) = sig_deltas;
    t = t + length(sig_deltas) + spacing + randi([-10 10]);
    i=i+1;
end

%% Compute spectrum
figure, hold on,
[spectrum,~,f] = MTSpectrum(signoise','frequency',1250, 'range',[0 20]);
subplot(2,2,1),hold on, plot(f,spectrum), ylim([0 3E4]), title('pink noise')
[spectrum,~,f] = MTSpectrum(new_sig1','frequency',1250, 'range',[0 20]);
subplot(2,2,2),hold on, plot(f,spectrum), ylim([0 3E4]), title('spacing  200ms (middle delta)')
[spectrum,~,f] = MTSpectrum(new_sig2','frequency',1250, 'range',[0 20]);
subplot(2,2,3),hold on, plot(f,spectrum), ylim([0 3E4]), title('spacing  500ms (middle delta)')
[spectrum,~,f] = MTSpectrum(new_sig3','frequency',1250, 'range',[0 20]);
subplot(2,2,4),hold on, plot(f,spectrum), ylim([0 3E4]), title('spacing  2s (middle delta)')



%% Middle delta waves
% Create a long signal of pink noise (30min at 20khZ)
signoise = pinknoise(10 * 60 * 1250) * 50;

% signal with 200ms between each delta
new_sig1 = signoise;
spacing = 0.2 * 1250; %min time between two deltas
t=1;
i=1; 
while i<=length(low_delta)
    subDelta = subset(large_deltas,low_delta(i));
    sig_deltas = Data(Restrict(LFPsup, subDelta));
        
    if t + length(sig_deltas) > length(new_sig1)
        break
    end
    
    new_sig1(t:t+length(sig_deltas)-1) = sig_deltas;
    t = t + length(sig_deltas) + spacing + randi([-10 10]);
    i=i+1;
end

% signal with 500ms between each delta
new_sig2 = signoise;
spacing = 0.5 * 1250; %min time between two deltas
t=1;
i=1; 
while i<=length(low_delta)
    subDelta = subset(large_deltas,low_delta(i));
    sig_deltas = Data(Restrict(LFPsup, subDelta));
        
    if t + length(sig_deltas) > length(new_sig2)
        break
    end
    
    new_sig2(t:t+length(sig_deltas)-1) = sig_deltas;
    t = t + length(sig_deltas) + spacing + randi([-10 10]);
    i=i+1;
end

% signal with 2s between each delta
new_sig3 = signoise;
spacing = 2 * 1250; %min time between two deltas
t=1;
i=1; 
while i<=length(low_delta)
    subDelta = subset(large_deltas,low_delta(i));
    sig_deltas = Data(Restrict(LFPsup, subDelta));
        
    if t + length(sig_deltas) > length(new_sig3)
        break
    end
    
    new_sig3(t:t+length(sig_deltas)-1) = sig_deltas;
    t = t + length(sig_deltas) + spacing + randi([-10 10]);
    i=i+1;
end

%% Compute spectrum
figure, hold on,
[spectrum,~,f] = MTSpectrum(signoise','frequency',1250, 'range',[0 20]);
subplot(2,2,1),hold on, plot(f,spectrum), ylim([0 3E4]), title('pink noise')
[spectrum,~,f] = MTSpectrum(new_sig1','frequency',1250, 'range',[0 20]);
subplot(2,2,2),hold on, plot(f,spectrum), ylim([0 3E4]), title('spacing  200ms (low delta)')
[spectrum,~,f] = MTSpectrum(new_sig2','frequency',1250, 'range',[0 20]);
subplot(2,2,3),hold on, plot(f,spectrum), ylim([0 3E4]), title('spacing  500ms (low delta)')
[spectrum,~,f] = MTSpectrum(new_sig3','frequency',1250, 'range',[0 20]);
subplot(2,2,4),hold on, plot(f,spectrum), ylim([0 3E4]), title('spacing  2s (low delta)')

