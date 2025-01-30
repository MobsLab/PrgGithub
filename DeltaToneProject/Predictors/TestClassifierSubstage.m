% TestClassifierSubstage
% 25.01.2018 KJ
%
% create a one night dataset
% 
%   see ClassifySubstageFromSUA TestClassifierSubstage2 TestClassifierSubstage3
%


% ------------ 508 ------------
cd('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170126/ProjectEmbReact_M508_20170126_BaselineSleep/')
disp(' ')
disp('****************************************************************')
disp(pwd)


%% Dataset

%params
binsize = 100; % in ms
windowstage = 3e4; % 3 sec
minsize_epoch = 4e4; % 4 sec, to avoid border issue
nb_sample = 400; % number of epoch (sample) taken in each record, for each sleep stage
nb_neurons = 60; %select 30 neurons

size_spiketrain = windowstage/(binsize*10);

    
%% load
%substages
load('SleepSubstages.mat', 'Epoch')
Substages = Epoch(1:5); %N1,N2,N3,REM and Wake
%spikes
load('SpikeData.mat', 'S')
load('NeuronClassification.mat', 'UnitID')


%% Intervals selection
samples_intervals = cell(0);
samples_class = [];
for ep=1:length(Substages)
    k=1;
    Substage = Substages{ep};
    nb_epoch = length(Start(Substage));

    while k<=nb_sample
        ep_stage = subset(Substage, randi(nb_epoch));

        if tot_length(ep_stage)<minsize_epoch
            continue %work only with epoch longer than 4sec
        else
            start_ep = Start(ep_stage) + rand*(tot_length(ep_stage) - windowstage);
            samples_intervals{end+1} = intervalSet(start_ep, start_ep+windowstage);
            samples_class = [samples_class ep];

            k = k+1;
        end
    end
end
    
    
%% select neurons and Firing rates
nb_int = floor(nb_neurons/3);
nb_pyr = nb_neurons - nb_int;
selected_int = randsample(find(UnitID(:,1)==-1), nb_int);
selected_pyr = randsample(find(UnitID(:,1)==1), nb_pyr);
selected_neurons = [selected_int ; selected_pyr];

FiringRate = MakeQfromS(S(selected_neurons),binsize*10);
    
%% X and Y 
Y = [];
X = cell(0);
for i=1:length(samples_intervals)
    intv = samples_intervals{i};
    try
        sample_features = full(Data(Restrict(FiringRate,intv)))';
    catch
        disp(['error for i=' num2str(i)])
    end
    %add samples only if well processed, no error
    if all(~isnan(sample_features(:))) 
        X{end+1} = sample_features;
        Y(end+1) =  samples_class(i);
    end
end
    

%% saving data
save('/home/mobsjunior/Documents/TestClassifierSubstage3.mat', 'X','Y','binsize') 

