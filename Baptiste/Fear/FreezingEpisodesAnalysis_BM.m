
function [All_Freq,Start_FzEp,Stop_FzEp]=FreezingEpisodesAnalysis_BM(FreezeEpoch,Spectrum,FreqRange,thr)

% thr : threshold for noise
% FreqRange often Spectro{3}, the values of spectrum frequencies

Start_FzEp=Start(FreezeEpoch);
Stop_FzEp=Stop(FreezeEpoch);
thr_ind=find(FreqRange>thr-0.05 & FreqRange<thr+0.05); % threshold for noise on mean spectrum
for ep=1:length(Start_FzEp)
    
    Epoch_To_use=intervalSet(Start_FzEp(ep),Stop_FzEp(ep));
    Spectro_duringFzEp=Restrict(Spectrum,Epoch_To_use);
    DataSpectro=Data(Spectro_duringFzEp);
    for data=1:size(DataSpectro,1)
        [Power,Freq]=max(zscore_nan_BM(DataSpectro(data,thr+1:end)));
        Freq_bis=FreqRange(Freq+thr);
        All_Freq(ep,data)=Freq_bis; % line are freezing episodes, colums are number of data in this episode
    end
end

All_Freq(All_Freq==0)=NaN;


