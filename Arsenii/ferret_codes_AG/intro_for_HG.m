%% Helpful script to start using sleep scoring
%{
1) Download a tsd package from: https://github.com/MobsLab/neuroEncoders/tree/master/tsdPackage
tsd (timestamp data) is a format which allows for storing both the data and its timeline in one variable. 
2) Add 'load_wave_clus' function
3) directory for spike sorted data:
/data5/Arsenii/OBG_AG/Shropshire/spike_sorting
You can find which sessions are sorted in the google sheet

%}

%{ 
Let's load sleep scoring data and look at it:
For example, we will look at SmoothGamma - power of OB-gamma oscillations.
It can be accessed as Data(SmoothGamma) – values, Range(SmoothGamma, 's') – its timeline in seconds or Range(SmoothGamma, 'min') in minutes. 
By default (Range(SmoothGamma)) values are stored in timestamps, which are ms*1e4 (don’t ask me why)
%}

load('SleepScoring_OBGamma.mat')

Data_gamma = Data(SmoothGamma);
Time_gamma = Range(SmoothGamma, 'min');

% Define colors, we will use them later for plotting figures
colours = { {[0 0 1], [0.2 0.75 1]}; ...        % Wake
            {[1 0 0], [1 0.5 0.75]}; ...         % Sleep
            {[1 0.71 0.76], [1.0, 0.82, 0.86]}; ...  % IS
            {[0.55 0 0], [0.71, 0.20, 0.20]}; ... % NREM
            {[0 1 0], [0.75 1 0.5]}; ...         % REM
            };
%{
In a tsd package you will also find a intervalSet.m function, which is a way to store time epochs, that are later used to restrict your data to a certain time period. 
Output of the Sleep Scoring gives us exactly this: epochs of Sleep, Wake, NREM, REM (REMEpoch) etc
You can take your data (for this example I will use SmoothGamma, but it could be literally anything) and restrict it to an epoch.
%}

% At first, I will create Intermediate sleep and NREM epochs
% The only thing that will change in a couple of weeks is values of epochs i.e. time periods. I'll update you
ISEpoch = and(Sleep, Epoch_S2) - REMEpoch;
NREM = and(Sleep, Epoch_S1) - REMEpoch;

Epochs = {Wake, Sleep, ISEpoch, NREM, REMEpoch};
Epoch_names = {'Wake', 'Sleep', 'IS', 'NREM', 'REM'};

% Now I will restrict gamma power to these epochs
for i = 1:length(Epochs)
   Gamma{i} = Restrict(SmoothGamma, Epochs{i});
end

% You can also create an arbitrary epoch to isolate a specific time period within the session. For example, from 50 to 60 minutes
BegEpoch = 50*60*1e4;
EndEpoch = 60*60*1e4;
Example_Epoch = intervalSet(BegEpoch, EndEpoch); 
Gamma_ExampleEpoch = Restrict(SmoothGamma, Example_Epoch);

% Let's vizualize them all
figure;
hold on
for i = 1:length(Epochs)
    plot(Range(Gamma{i}, 'min'), Data(Gamma{i}), '.', 'color', colours{i}{1}, 'MarkerSize', 1)
end
plot(Range(Gamma_ExampleEpoch, 'min'), Data(Gamma_ExampleEpoch), '.k', 'MarkerSize', 1)
title('OB gamma power'), xlabel('time (min)'), ylabel('power, a.u.')
legend({Epoch_names{:}})

%{ 
Instead of SmoothGamma, you can take any other data time series, just making sure it is in the same time scale as you epochs.
For example, let's take a spike sorted unit firing rate. Let me just load and prepare them a bit at first
%}

% Load spikes
directory = pwd; 
[spikes, metadata] = load_wave_clus(directory);

%{
At this step you will want to select channels that have responses to sounds. 
I'm working now on implementing the zeta-test and/or manually selecting and grouping units that we are interested in. 
For now, we just load and use all spike sorted channels (but this is stupid).
Stay tuned.

Below is an example script which you can use to select channels

clear chcl
 chcl = {...
        [33 2], ...
        [35 1], ...
        ...}

colIndex = [];
for s = 1:length(chcl)
    % Find row in metadata matching [channel cluster]
    row = find(metadata(:,1)==chcl{s}(1) & metadata(:,2)==chcl{s}(2));
    colIndex(s) = row;
end
%}

% Load stim triggers
lfpFile = fullfile(directory, 'LFPData', 'LFP111.mat');
if exist(lfpFile,'file')
    load(lfpFile,'LFP');
else
    error('LFP file not found: %s', lfpFile);
end

% Extract stimulus onsets:
StartSound = thresholdIntervals(LFP, 4000, 'Direction','Above');
Starttime  = Start(StartSound); 

% Create an array of units
A = {};
n=1;
for i = 1:size(spikes, 2) % or length(colIndex) if you've selected channels
    A{n} = ts(spikes(:,i)*1e1);
    n = n+1;
end

% Bin the spikes
Binsize = 1*1e4;
B = tsdArray(A);
Q = MakeQfromS(B,Binsize); % This function just bins your tsdArray
Q = tsd(Range(Q),nanzscore(full(Data(Q)))); % I use zscore here
D = Data(Q);

% Interpolate firing rate on Gamma's timeline
Mean_FR_on_Gamma = interp1(linspace(0,1,length(D)), movmean(nanmean(D'),5), ...
                   linspace(0,1,length(SmoothGamma)));
Mean_FR_on_Gamma_tsd = tsd(Range(SmoothGamma), Mean_FR_on_Gamma'); 

%{ 
So, this is the way to convert a variable to tsd. Range(SmoothGamma) allows to use the same timeline as SmoothGamma. 
But Range(SmoothGamma) and Mean_FR_on_Gamma must be the same size. 
That's why I interpolated FR values to fit them to the same size as SmoothGamma.
%}

% Plot. 
% I use runmean here to smooth data and (1:1e3:end) to plot only every 1000th point for the sake of visualization. You can just ignore it if you want
figure('Name','Gamma vs Firing Rate','Color','w');
subplot(3,1,2)
clear R D, R = Range(SmoothGamma,'min'); D = Data(SmoothGamma);
plot(R(1:1e3:end), runmean(D(1:1e3:end),100), 'k');
ylabel('OB gamma power (log scale)'); 
yyaxis right
clear R D, R = Range(Mean_FR_on_Gamma_tsd,'min'); D = Data(Mean_FR_on_Gamma_tsd);
plot(R(1:1e4:end), runmean(D(1:1e4:end),10), 'r');
xlabel('time (min)'); ylabel('FR (zscore)'); xlim([R(1) R(end)])
legend({'OB gamma', 'Mean firing rate'})

% Now, let's restrict mean firing rate to different states
for i = 1:length(Epochs)
   FR{i} = Restrict(Mean_FR_on_Gamma_tsd, Epochs{i}); 
end

% Let's put everything together just for the sake of demostration
figure;
subplot(312)
hold on
% plot gamma
for i = 1:length(Epochs)
    clear R D
    R = Range(Gamma{i}, 'min'); D = runmean(Data(Gamma{i}),100);
    plot(R(1:0.5e3:end), D(1:0.5e3:end), '.', 'color', colours{i}{1}, 'MarkerSize', 1)
end
ylabel('OB gamma power (log scale)'); 

% plot FR
yyaxis right
for i = 1:length(Epochs)
    clear R D
    R = Range(FR{i}, 'min'); D = runmean(Data(FR{i}), 10);
    plot(R(1:0.5e3:end), D(1:0.5e3:end), '.', 'color', colours{i}{2}, 'MarkerSize', 1)
end
ylabel('FR (zscore)')

% et voila, enjoy :) Let me know if you have any questions













