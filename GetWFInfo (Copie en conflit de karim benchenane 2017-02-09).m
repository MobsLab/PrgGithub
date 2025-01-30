function GetWFInfo(Filename,FilenameXml)

% This function creates  MeanWaveform.mat that can be used to identify
% putative IN or PyrCells
% It would be better to automatically perform this stage during
% pre-processing : see makeDataSBVfin to get lines of code

%% Required Input
% Filename : where the data is and where MeanWaveform.mat will be saved
% FilenameXml : xml to use (the one use used to generate the matlab files initially)

cd(Filename)
load('ChannelsToAnalyse/Bulb_deep.mat')
load(['LFPData/LFP' num2str(channel) '.mat'])
Tmax=max(Range(LFP,'s'));
clear LFP
load('SpikeData.mat')

SetCurrentSession(FilenameXml)
global DATA;

% Make Sure We get the right neurons
[S,numNeurons,numtt,TT]=GetSpikesFromStructure('PFCx',S,Filename);
GoodNeurons=reshape([TT{numNeurons}],2,length(numNeurons));
spk=1;

% Go through each tetrode and load the data
for tetr=unique(GoodNeurons(1,:))
    filename = [DATA.session.path '/' DATA.session.basename '.spk.' int2str(tetr)];
    nChannels = length(DATA.spikeGroups.groups{tetr});
    nSamplesPerWaveform = DATA.spikeGroups.nSamples(tetr);
    % If the recording is very long, there's no point loading everything
    % since this is very time consuming
    if Tmax>3*3600
        data = LoadSomeSpikeWaveforms(filename,nChannels,nSamplesPerWaveform,3*3600);
        D=DATA.spikes(DATA.spikes(:,1)<=3*3600,:);
    else
        data = LoadSpikeWaveforms(filename,nChannels,nSamplesPerWaveform);
    end
    % Now get the average waveform on each electrode
    D=D(D(:,2)==tetr,:);
    NeurToUse=GoodNeurons(2,find(GoodNeurons(1,:)==tetr));
    for neur=1:length(NeurToUse)
        keep=find(D(:,3)==NeurToUse(neur));
        tempW = data(keep,:,:);
        for elec=1:4
            try,W{spk}(elec,1:32)=mean(squeeze(tempW(:,elec,:)));end
        end
        spk=spk+1;
    end
    clear data
end

cd(Filename)

% Now we extract the relevant parameters
for ww=1:length(W)
    % Get the FR
    Params{ww}(1)=length(Data(S{numNeurons(ww)}))/Tmax; 
    % First identify the largetst WF to use
    for elec=1:4
        try
            Peak{ww}(elec)=min(W{ww}(elec,:));
        end
    end
    [~,BestElec{ww}]=min(Peak{ww});
    WaveToUse=W{ww}(BestElec{ww},:);
    % Resample to make estimations smoother
    WaveToUseResample = resample(WaveToUse,300,1);
    % Get half width using null derivative
    [~,valmin]=min(WaveToUseResample);
    
    DD=diff(WaveToUseResample);
    diffpeak=find(DD(valmin:end)==max(DD(valmin:end)))+valmin;
    DD=DD(diffpeak:end);
   valmax=find(DD<max(abs(diff(WaveToUseResample)))*0.01,1,'first')+diffpeak; 
    
    if WaveToUseResample(valmax)<0
        try
            valmax=find(WaveToUseResample(valmax:end)>0,1,'first')+valmax ;
        catch
            valmax=length(WaveToUseResample);
        end
    end
    
    Params{ww}(2)=(valmax-valmin)*5e-5/300;
    % Get area under the curve 
    [~,valmin2]=min(WaveToUseResample);
    WaveToUseResample=WaveToUseResample(valmin2:end);
    valzero=find(WaveToUseResample>0,1,'first');
    WaveToCalc=WaveToUseResample(valzero:end);
    Params{ww}(3)=sum(abs(WaveToCalc));
end


save('MeanWaveform.mat','BestElec','Peak','Params','W')



end