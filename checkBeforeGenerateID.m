%checkBeforeGenerateID
% check whether all processing nedded for GenerateIDSleepRecord is done

% see functions in /home/mobssenior/Dropbox/Kteam/PrgMatlab/K_Junior/utils
% see functions in /home/mobssenior/Dropbox/Kteam/PrgMatlab/DeltaToneProject/CreateData


%% StateEpochSB
doStateEpochSB='run';
if exist('StateEpochSB.mat','file')
    disp('StateEpochSB.mat exists')
    doStateEpochSB='done';
else
    disp('-> missing StateEpochSB.mat')
end


%% SpikeData
doSpikeData='run';
if exist('SpikeData.mat','file') && exist('Waveforms.mat','file')
    disp('SpikeData.mat and Waveforms.mat exist')
    doSpikeData='done';
else
    disp('-> missing SpikeData.mat or Waveforms.mat')
end

%% SpikesToAnalyse
doSpikToAnalyse='run';
if exist('SpikesToAnalyse','dir')
    disp('folder SpikesToAnalyse exists')
    doSpikToAnalyse='done';
else
    disp('-> missing folder SpikesToAnalyse')
end

%% MeanWaveform
DoMeanWfm='run';
if exist('MeanWaveform.mat','file')
    disp('MeanWaveform.mat exists')
    DoMeanWfm='done';
else
    disp('-> missing MeanWaveform.mat')
end

%% SpikeClassif
doSpikeClassif='run';
if exist('SpikeClassification.mat','file')
    disp('SpikeClassification.mat exists')
    doSpikeClassif='done';
else
    disp('-> missing SpikeClassification.mat')
end

%% substages
doSubstages='run';
if exist('NREMepochsML.mat','file')
    disp('NREMepochsML.mat exists')
    doSubstages='done';
else
    disp('-> missing NREMepochsML.mat')
end

%% Run functions
defaultvalues={doStateEpochSB,doSpikeData,doSpikToAnalyse,DoMeanWfm,doSpikeClassif,doSubstages};
if 0
    answer = inputdlg({'StateEpochSB.mat','SpikeData.mat & Waveforms.mat','SpikesToAnalyse','MeanWaveform.mat',...
    'SpikeClassification.mat','NREMepochsML.mat'},'for GenerateIDSleepRecord',1,defaultvalues);
else 
    answer=defaultvalues;
end
% run functions to get missing data
RunStateEpochSB=strcmp(answer{1},'run');
RunSpikeData=strcmp(answer{2},'run');
RunSpikesToAnalyse=strcmp(answer{3},'run');
RunMeanWaveform=strcmp(answer{4},'run');
RunSpikeClassif=strcmp(answer{5},'run');
RunNREMSubstages=strcmp(answer{6},'run');


%% function RunStateEpochSB
if RunStateEpochSB
    disp('Run StateEpochSB')
    
    try
        clear channel; load('ChannelsToAnalyse/dHPC_deep.mat');
        chH=channel;
    catch
        try
            load('ChannelsToAnalyse/dHPC_rip.mat');
            chH=channel;
        end
    end
    
    try
        load('ChannelsToAnalyse/Bulb_deep.mat');
        chB=channel;
    end
    
    if ~(exist('B_High_Spectrum.mat', 'file') == 2)
        disp('calculating Bulb Spectrum');
        HighSpectrum([pwd,'/'],chB,'B');
    end
    disp('Bulb Spectrum done')
    
    if ~(exist('H_Low_Spectrum.mat', 'file') == 2)
        disp('calculating Hpc spectrum');
        LowSpectrumSB([pwd,'/'],chH,'H');
    end
    disp('Hpc spectrum done')
    
    
    disp('Running BulbSleepScript')
    try
        BulbSleepScript;
    catch
        disp('Problem, skip')
    end
end

%% function RunSpikeData
if RunSpikeData
    disp('Run SpikeData')
    
    SetCurrentSession
    SetCurrentSession('same')
    global DATA
    tetrodeChannels=DATA.spikeGroups.groups;
    
    s=GetSpikes('output','full');
    a=1;
    clear S
    for i=1:20
        for j=1:200
            try
                if length(find(s(:,2)==i&s(:,3)==j))>1
                    S{a}=tsd(s(find(s(:,2)==i&s(:,3)==j),1)*1E4,s(find(s(:,2)==i&s(:,3)==j),1)*1E4);
                    TT{a}=[i,j];
                    cellnames{a}=['TT',num2str(i),'c',num2str(j)];
                    
                    W{a} = GetSpikeWaveforms([i j]);
                    disp(['Cluster : ',cellnames{a},' > done'])
                    for elec=1:size(W{a},2)
                        tempW{a}=mean(squeeze( W{a}(:,elec,:)));
                    end
                    a=a+1;
                end
            end
        end
        disp(['Tetrodes #',num2str(i),' > done'])
    end
    
    try
        S=tsdArray(S);
    end
    save SpikeData -v7.3 S s TT cellnames tetrodeChannels
    save Waveforms -v7.3 W cellnames
    disp('Done')
end

%% function RunSpikesToAnalyse
if RunSpikesToAnalyse
    disp('Run SpikesToAnalyse')
    clear S numNeurons numtt TT
    
    [S,numNeurons,numtt,TT] = GetSpikesFromStructure('PFCx');
    % remove MUA from the analysis
    nN=numNeurons;
    num_mua = [];
    num_single = [];
    for s=1:length(numNeurons)
        if TT{numNeurons(s)}(2)==1
            num_mua = [num_mua numNeurons(s)];
        else
            num_single = [num_single numNeurons(s)];
        end
    end
    number = num_single;
    if ~exist('SpikesToAnalyse','dir'),mkdir('SpikesToAnalyse');end
    save SpikesToAnalyse/PFCx_Neurons.mat number
    number = num_mua;
    save SpikesToAnalyse/PFCx_MUA.mat number
end

%% function RunMeanWaveform
if RunMeanWaveform
    disp('Run MeanWaveform')
    MakeWaveformDataKJ;
end

%% function RunSpikeClassif
if RunSpikeClassif
    disp('Run SpikeClassif')
    load SpikeData.mat
    numNeurons = 1:length(S);
    Filename = [pwd '/'];
    FilenamDropBox=which('checkBeforeGenerateID');
    FilenamDropBox=FilenamDropBox(1:strfind(FilenamDropBox,'Dropbox')-1);
    [WfId,W]=IdentifyWaveforms(Filename,FilenamDropBox,1,numNeurons);
    save SpikeClassification WfId W
end

%% function RunNREMSubstages
if RunNREMSubstages
    disp('Run NREMSubstages')
    RunSubstages;
end

