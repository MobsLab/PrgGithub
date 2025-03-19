% DatasetSubstageFromSUA
% 24.01.2018 KJ
%
% Try to predict substages (N1,N2,N3,REM and Wake) from neural activity
%   - create a dataset
% 
%   see 
%       ClassifySubstageFromSUA TestClassifierSubstage



%% Dir
a=0;
% ------------ 243 ------------
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Breath-Mouse-243-244-29032015/Mouse243'; 
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Breath-Mouse-243-244-31032015/Mouse243'; 
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150401/Breath-Mouse-243-244-01042015/Mouse243';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243';
% ------------ 244 ------------
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Breath-Mouse-243-244-29032015/Mouse244';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Breath-Mouse-243-244-31032015/Mouse244';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150401/Breath-Mouse-243-244-01042015/Mouse244';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse244';
% ------------ 403 ------------
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161205/Mouse403/Breath-Mouse-403-05122016/';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161209/Mouse403/Breath-Mouse-403-09122016/';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161212/Mouse403/Breath-Mouse-403-12122016/';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161217/Mouse403/Breath-Mouse-403-17122016/';
%------------ 451 ------------
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161205/Mouse451/Breath-Mouse-451-05122016/';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161209/Mouse451/Breath-Mouse-451-09122016/';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161212/Mouse451/Breath-Mouse-451-12122016/';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161217/Mouse451/Breath-Mouse-451-17122016/';
% ------------ 508 ------------
a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170126/ProjectEmbReact_M508_20170126_BaselineSleep/';
a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170127/ProjectEmbReact_M508_20170127_BaselineSleep/';
% ------------ 509 ------------
a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170127/ProjectEmbReact_M509_20170127_BaselineSleep/'; 
a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170130/ProjectEmbReact_M509_20170130_BaselineSleep/'; 
% ------------ 512 ------------
a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse512/20170202/ProjectEmbReact_M512_20170202_BaselineSleep/'; 
a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse512/20170204/ProjectEmbReact_M512_20170204_BaselineSleep/'; 

for i=1:length(Dir.path)
    %mouse name
    Dir.name{i}=Dir.path{i}(strfind(Dir.path{i},'/Mouse'):strfind(Dir.path{i},'/Mouse')+8);
    Dir.name{i}(Dir.name{i}=='-')=[];
    Dir.name{i}(Dir.name{i}=='/')=[];
    
    %date
    ind = strfind(Dir.path{i},'/201');
    Dir.date{i} = Dir.path{i}(ind + [7 8 5 6 1:4]);

end


%% Dataset

%params
binsize = 5; % in ms
windowstage = 3e4; % 3 sec
minsize_epoch = 4e4; % 4 sec, to avoid border issue
nb_sample = 400; % number of epoch (sample) taken in each record, for each sleep stage

size_spiketrain = windowstage/(binsize*10);


for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    data_csfs.path{p} = Dir.path{p};
    data_csfs.name{p} = Dir.name{p};
    data_csfs.date{p} = Dir.date{p};

    
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
    nb_neurons = length(S);
    nb_int = sum(UnitID(:,1)<0);
    nb_pyr = sum(UnitID(:,1)>0);
    
    try
        FiringRate = MakeQfromS(tsdArray(S),binsize*10);
    catch
        FiringRate = MakeQfromS(S,binsize*10);
    end
    
    data_csfs.unitID{p} = UnitID;
    data_csfs.nb_neuron.all{p} = nb_neurons;
    data_csfs.nb_neuron.int{p} = nb_int;
    data_csfs.nb_neuron.pyr{p} = nb_pyr;
    
    %% X and Y   
    Y = [];
    X = cell(0);
    for i=1:length(samples_intervals)
        intv = samples_intervals{i};
        try
            sample_features = full(Data(Restrict(FiringRate,intv)))';
            %add samples only if well processed, no error
            if all(~isnan(sample_features(:))) 
                X{end+1} = sample_features;
                Y(end+1) =  samples_class(i);
            end
        catch
            disp(['error for i=' num2str(i)])
        end
    end

    %concatenate
    data_csfs.X{p} = X;
    data_csfs.Y{p} = Y;

end


%saving data
cd(fullfile(FolderDeltaDataKJ,'Datasets'))
save DatasetSubstageFromSUA2.mat -v7.3 data_csfs Dir binsize windowstage nb_sample nb_neurons size_spiketrain



