function common_data=GetClinicCommonData()
    
    % INFO
    %   return common data value used in many code
    %
    

    common_data.effect_period = 8000; %800ms
    common_data.pre_period = 8000; %800ms
    common_data.lim_between_stim = 1.6E4;  %1.6sec maximum between two stim of the same train
    common_data.stage_epoch_duration = 30E4; %epoch duration in Hypnograms
    common_data.spindle_band = [10 17]; % 10-17Hz
    
    %predetect_so
    common_data.predetect_so.threshold = -60;
    common_data.predetect_so.threshDuration = 0; 
    common_data.predetect_so.minDuration = 200;
    common_data.predetect_so.maxDuration = 1500;
    common_data.predetect_so.noiseThreshold = 210;
    
end
