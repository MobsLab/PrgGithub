%makeWaveformDataKJ
% 18.10.2016 KJ
%
% generate waveform data
%
% Info
%   see makeDataBulbeSB, MakeSpikeDataKJ
%

        
load ChannelsToAnalyse/PFCx_deep
eval(['load LFPData/LFP',num2str(channel)])
Tmax=max(Range(LFP,'s'));
clear LFP channel

load Waveforms
load SpikeData S
% Get WF info
for spk=1:length(W)
    for elec=1:size(W{spk},2)
        tempW{spk}(elec,1:32)=mean(squeeze( W{spk}(:,elec,:)));
    end
end
W=tempW;
clear tempW

for ww=1:length(W)
    for elec=1:4
        try
            Peak{ww}(elec)=min(W{ww}(elec,:));
        end
    end
    [~,BestElec{ww}]=min(Peak{ww});
    Params{ww}(1)=length(Data(S{ww}))/Tmax; % Get the FR
    WaveToUse=W{ww}(BestElec{ww},:);
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
    if isempty(valmax)
        valmax=length(WaveToUseResample);
    end
    Params{ww}(2)=(valmax-valmin)*5e-5/300;
    [~,valmin2]=min(WaveToUseResample);
    WaveToUseResample=WaveToUseResample(valmin2:end);
    valzero=find(WaveToUseResample>0,1,'first');
    WaveToCalc=WaveToUseResample(valzero:end);
    Params{ww}(3)=sum(abs(WaveToCalc));
end
save('MeanWaveform.mat','BestElec','Peak','Params','W','cellnames')





