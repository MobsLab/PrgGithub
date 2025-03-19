
function EpochSlow = FindSlowOscillation(Spectrum, t, freq)
        
        % parameters
        freq_band = [2 4]; % band of interest
        lower_band = [0.5 1.5]; % lower band
        upper_band = [4.5 6]; % upper band
        thresh1 = 1.1;
        thresh2 = 2;
        
        % spectrograms value corresponding to those bands
        V1 = mean(Spectrum(:,freq>freq_band(1) & freq<freq_band(2)), 2);
        V2 = mean(Spectrum(:,freq>lower_band(1) & freq<lower_band(2)), 2);
        V3 = mean(Spectrum(:,freq>upper_band(1) & freq<upper_band(2)), 2);
        
        % find slow osc EpochSleep
        Vts1 = tsd(t*1E4, (V1./V2));
        EpochSlow1 = thresholdIntervals(Vts1, thresh1, 'Direction','Above');
        Vts2 = tsd(t*1E4, (V1./V3));
        EpochSlow2 = thresholdIntervals(Vts2, thresh2, 'Direction','Above');
        
        %union of intervals where power(freq_band) is >power(lower_band) and >>power(upper_band)
        EpochSlow = and(EpochSlow1, EpochSlow2);
        EpochSlow = mergeCloseIntervals(EpochSlow, 1E4);
        EpochSlow = dropShortIntervals(EpochSlow, 1E4);
        
    end


