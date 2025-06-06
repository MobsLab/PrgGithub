 function Datatsd  = ReSampleDataInTime_ForPFCInterTuning(Datatsd,subSample,TimeBins,TempBinsize)
        vartime = median(diff(Range(Datatsd,'s')));
        if vartime<TempBinsize/2
            Datatsd = tsd(Range(Datatsd),movmean(Data(Datatsd), round((TempBinsize/vartime)), 'omitnan'));
        end
        y=interp1(Range(Datatsd),Data(Datatsd),TimeBins);
        Datatsd = tsd(TimeBins,y);
    end