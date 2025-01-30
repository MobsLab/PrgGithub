function MultiFilLFP=FilterRangeOfBdWidths(LFP,FreqRg,FreqStep,BandWidth,DoWhitening)

% This function takes an LFP and filters it in a range of frequency bands
% LFP : tsd with your LFP
% Freg Rg : [LowestFreq HighestFreq]
% Freq step : step to sample between LowestFreq and HighestFreq
% HalBandWidth : for each freq the LFP will be filtered with between
% -BandWidth(1) and+BandWidth(2)
% DoWhitening=1 if need to do whitening

FreqVals=[FreqRg(1):FreqStep:FreqRg(2)];
if DoWhitening
    [y, ARmodel] = WhitenSignal(Data(LFP),[],1,[],2);
    LFP=tsd(Range(LFP),y);
end

for f=1:length(FreqVals)
    FilterCenter=FreqVals(f);
    
    if FilterCenter<12
        fi=1024;
    elseif FilterCenter<30
        fi=512;
    else
        fi=256;
    end
    MultiFilLFP.FilLFP{f}=FilterLFP(LFP,[max(FilterCenter-BandWidth(1),0.5) FilterCenter+BandWidth(2)],fi);
    MultiFilLFP.FreqRange(f,:)=[FilterCenter-BandWidth(1) FilterCenter+BandWidth(2)];
end

end