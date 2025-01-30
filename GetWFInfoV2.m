function GetWFInfoV2(Filename)

% This function creates  MeanWaveform.mat that can be used to identify
% putative IN or PyrCells
% It would be better to automatically perform this stage during
% pre-processing : see makeDataSBVfin to get lines of code

%% Required Input
% Filename : where the data is and where MeanWaveform.mat will be saved
% numNeurons : neurons you want to use

cd(Filename)
try,load('ChannelsToAnalyse/Bulb_deep.mat')
load(['LFPData/LFP' num2str(channel) '.mat'])
catch
    try,load('ChannelsToAnalyse/PFCx_deep.mat')
load(['LFPData/LFP' num2str(channel) '.mat'])
    end
end
Tmax=max(Range(LFP,'s'));
clear LFP
load('SpikeData.mat')
load('Waveforms.mat')
spk=1;
% Now we extract the relevant parameters
for ww=1:length(W)
    % Get the FR
    Params{ww}(1)=length(Data(S{ww}))/Tmax; 
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
            valmax=find(WaveToUseResample(valmax:end)>0,1,'first')+valmax;
        catch
            valmax=length(WaveToUseResample);
        end
        if isempty(valmax)
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