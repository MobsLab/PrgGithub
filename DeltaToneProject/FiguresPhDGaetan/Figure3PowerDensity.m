% Figure3PowerDensity
% 04.12.2016 KJ
%
% Collect data to plot the figures from the Figure3.pdf of Gaetan PhD
% 
% 
%   see Figure3PowerDensityPlot 
%


Dir = PathForExperimentsDeltaLongSleepNew('all');
 
% Dir = PathForExperimentsDeltaKJHD('all');


%params
freqSO = [2 4];
params.tapers = [3 5];
params.Fs = 1250;
params.fpass = freqSO;
 
hours_expe = 10:1:20;
for h=1:length(hours_expe)
    hours_epoch{h} = intervalSet(hours_expe(h)*3600E4, (hours_expe(h)+1)*3600E4-1);
end
midday_epoch = intervalSet(12*3600E4, 14*3600E4);
evening_epoch = intervalSet(17*3600E4, 19*3600E4);


for p=1:length(Dir.path)
    try
        disp(' ')
        disp('****************************************************************')
        eval(['cd(Dir.path{',num2str(p),'}'')'])
        disp(pwd)
        figure3_res.path{p}=Dir.path{p};
        figure3_res.manipe{p}=Dir.manipe{p};
        figure3_res.delay{p}=Dir.delay{p};
        figure3_res.name{p}=Dir.name{p};
       
        %% Load
        %Times will be convert in seconds or 1E-4s
        load behavResources TimeDebRec TimeEndRec
        start_time = (TimeDebRec(1,1)*3600 + TimeDebRec(1,2)*60 + TimeDebRec(1,3))*1E4; %start time in sec
        
        %Epoch and Spikes
        load StateEpochSB SWSEpoch Wake REMEpoch
        SWSEpoch = intervalSet(Start(SWSEpoch)+start_time,End(SWSEpoch)+start_time);
        Wake = intervalSet(Start(Wake)+start_time,End(Wake)+start_time);
        REMEpoch = intervalSet(Start(REMEpoch)+start_time,End(REMEpoch)+start_time);
        
        %LFP
        load ChannelsToAnalyse/PFCx_deep
        eval(['load LFPData/LFP',num2str(channel)])
        LFPdeep=LFP;
        clear LFP channel
        LFPdeep = tsd(Range(LFPdeep)+start_time, Data(LFPdeep));
        
        %Delta waves
        try
            load DeltaPFCx DeltaOffline
        catch
            load newDeltaPFCx DeltaEpoch
            DeltaOffline = DeltaEpoch;
            clear DeltaEpoch
        end
        tdeltas = ts((Start(DeltaOffline)+End(DeltaOffline))/2 + start_time);
        %Down states
        try
            load newDownState Down
        catch
            try
                load DownSpk Down
            catch
                Down = intervalSet([],[]);
            end
        end
        tdowns = ts((Start(Down)+End(Down))/2 + start_time);
        
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% 2-4Hz Oscillation power (a - right)
        clear so_power
        for h=1:length(hours_epoch)
            try
                [Spectral_power, ~]=mtspectrumc(Data(Restrict(LFPdeep, hours_epoch{h})),params);
                so_power(h) = sum(Spectral_power);
            catch
                so_power(h) = nan;
            end
        end
        figure3_res.graphA.so_power_hours{p} = so_power;
        
        %% 2-4Hz Oscillation power, midday and evening (a - left)
        clear so_power2
        try
            [Spectral_power, ~]=mtspectrumc(Data(Restrict(LFPdeep, midday_epoch)),params);
            so_power2(1) = sum(Spectral_power);
        catch
            so_power2(1) = nan;
        end
        try
            [Spectral_power, ~]=mtspectrumc(Data(Restrict(LFPdeep, evening_epoch)),params);
            so_power2(2) = sum(Spectral_power);
        catch
            so_power2(2) = nan;
        end
        figure3_res.graphA.so_power_noonevening{p} = so_power2;
        
        %% Delta frequency (b - right)
        clear delta_density
        for h=1:length(hours_epoch)
            delta_density(h) = length(Restrict(tdeltas,hours_epoch{h})) / 3600;
        end
        figure3_res.graphB.delta_density{p} = delta_density;
        
        
        %% Ratio of SWS (b - left)
        clear sws_ratio
        for h=1:length(hours_epoch)
            sws_time = tot_length(intersect(SWSEpoch,hours_epoch{h})); 
            total = sws_time + tot_length(intersect(union(REMEpoch,Wake),hours_epoch{h}));
            sws_ratio(h) = sws_time / total;
        end
        figure3_res.graphB.sws_ratio{p} = sws_ratio;
        
        %% Up and Down duration vs Delta Amplitudes
        st_down = Start(Down);
        en_down = End(Down);
        tDownDuration = tsd(st_down + start_time, en_down - st_down);
        tUpDuration = tsd(en_down(1:end-1) + start_time, st_down(2:end) - en_down(1:end-1));
        
        EEGsleepD = ResampleTSD(LFPdeep,100);
        Filt_EEGd = FilterLFP(EEGsleepD, freqSO, 1024);
        
        for i=1:length(Start(SWSEpoch))
            SubSws = subset(SWSEpoch,i);
            down_duration_sub = Restrict(tDownDuration,SubSws);
            up_duration_sub = Restrict(tUpDuration,SubSws);
            
            down_durations(i) = nanmean(Data(down_duration_sub));
            up_durations(i) = nanmean(Data(up_duration_sub));
            
            signal = Restrict(Filt_EEGd,SubSws);
            signal = abs(Data(signal));
            so_amplitudes(i) = nanmean(signal);
            
        end
        
        figure3_res.graphE.down_durations{p} = down_durations;
        figure3_res.graphE.up_durations{p} = up_durations;
        figure3_res.graphE.so_amplitudes{p} = so_amplitudes;
        
        
    end
end


%saving data
cd([FolderProjetDelta 'Data/']) 
save Figure3PowerDensity.mat figure3_res hours_expe freqSO

