%%

function [All_Freq , EpLength , EpProp_2_4 , TimeProp_2_4 , AbsoluteTime_2_4] = FreezingSpectrumEpisodesAnalysis_BM(FreezeEpoch , RespiFreq , Freq_Limit)

% - FreqRange often Spectro{3}, the values of spectrum frequencies


Start_FzEp=Start(FreezeEpoch);
Stop_FzEp=Stop(FreezeEpoch);
if isempty(Start_FzEp)
    All_Freq=NaN; EpLength=NaN; EpProp_2_4=NaN; TimeProp_2_4=NaN; AbsoluteTime_2_4=NaN; 
else
    
    for ep=1:length(Start_FzEp)
        
        EpLength(ep) = Stop_FzEp(ep)-Start_FzEp(ep);
        Epoch_To_use = intervalSet(Start_FzEp(ep),Stop_FzEp(ep));
        Respi_duringFzEp = Restrict(RespiFreq , Epoch_To_use);
        DataRespi = Data(Respi_duringFzEp);
        
        if isempty(DataRespi)
            All_Freq(ep,:)=NaN;
        else
            
            All_Freq(ep,1:length(DataRespi))=DataRespi';
        end
    end
    All_Freq(All_Freq==0)=NaN;


All_Freq_2_4=All_Freq<Freq_Limit;
All_Freq_4_6=All_Freq>Freq_Limit;

EpProp_2_4 = sum(All_Freq_2_4')'./(sum(All_Freq_2_4')'+sum(All_Freq_4_6')'); % column vector with proportion for each episode of fz 2-4


Epoch_2_4= thresholdIntervals(RespiFreq,Freq_Limit,'Direction','Below');
TimeProp_2_4 = sum(Stop(Epoch_2_4)-Start(Epoch_2_4))/sum(Stop(FreezeEpoch)-Start(FreezeEpoch));
AbsoluteTime_2_4 = sum(Stop(Epoch_2_4)-Start(Epoch_2_4))/1e4;

end

