% SWAEvolutionDeltaFeedback
% 10.10.2017 KJ
%
% Evolution of SWA during the night
% 
% 
%   see Figure3PowerDensity
%

clear
Dir = PathForExperimentsDeltaLongSleepNew('all');
 
% Dir = PathForExperimentsDeltaKJHD('all');


%condition 
Dir.condition=Dir.manipe;
for p=1:length(Dir.path)
    if strcmpi(Dir.manipe{p},'DeltaToneAll')
        Dir.condition{p} = ['Tone ' num2str(Dir.delay{p}*1000) 'ms'];
    end
end


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
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    swa_res.path{p}=Dir.path{p};
    swa_res.manipe{p}=Dir.manipe{p};
    swa_res.delay{p}=Dir.delay{p};
    swa_res.name{p}=Dir.name{p};

    %% Load
    %Times will be convert in seconds or 1E-4s
    load behavResources TimeDebRec TimeEndRec
    start_time = (TimeDebRec(1,1)*3600 + TimeDebRec(1,2)*60 + TimeDebRec(1,3))*1E4; %start time in sec

    %Epoch and Spikes
    load StateEpochSB SWSEpoch Wake REMEpoch
    SWSEpoch = intervalSet(Start(SWSEpoch)+start_time,End(SWSEpoch)+start_time);
    Wake = intervalSet(Start(Wake)+start_time,End(Wake)+start_time);
    REMEpoch = intervalSet(Start(REMEpoch)+start_time,End(REMEpoch)+start_time);

    %LFP deep
    load ChannelsToAnalyse/PFCx_deep
    eval(['load LFPData/LFP',num2str(channel)])
    LFPdeep=LFP;
    clear LFP channel
    LFPdeep = tsd(Range(LFPdeep)+start_time, Data(LFPdeep));
    %LFP sup
    try
        load ChannelsToAnalyse/PFCx_sup
    catch
        load ChannelsToAnalyse/PFCx_deltasup
    end
    eval(['load LFPData/LFP',num2str(channel)])
    LFPsup=LFP;
    clear LFP channel
    LFPsup = tsd(Range(LFPsup)+start_time, Data(LFPsup));

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


    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% 2-4Hz Oscillation power (a - right)
    clear so_power
    for h=1:length(hours_epoch)
        try
            [Spectral_power, ~]=mtspectrumc(Data(Restrict(LFPdeep, and(hours_epoch{h}, SWSEpoch))),params);
            so_power(h) = sum(Spectral_power);
        catch
            so_power(h) = nan;
        end
    end
    swa_res.so_power_hours{p} = so_power;


    %% 2-4Hz Oscillation power, midday and evening (a - left)
    clear so_power2
    try
        [Spectral_power, ~] = mtspectrumc(Data(Restrict(LFPdeep, and(midday_epoch,SWSEpoch))),params);
        so_power2(1) = sum(Spectral_power);
    catch
        so_power2(1) = nan;
    end
    try
        [Spectral_power, ~] = mtspectrumc(Data(Restrict(LFPdeep, and(evening_epoch,SWSEpoch))),params);
        so_power2(2) = sum(Spectral_power);
    catch
        so_power2(2) = nan;
    end
    swa_res.so_power_noonevening{p} = so_power2;


    %% Delta frequency (b - right)
    clear delta_density
    for h=1:length(hours_epoch)
        delta_density(h) = length(Restrict(tdeltas, and(hours_epoch{h},SWSEpoch))) / tot_length(and(hours_epoch{h},SWSEpoch));
    end
    swa_res.delta_density{p} = delta_density;


    %% Ratio of SWS (b - left)
    clear sws_ratio
    for h=1:length(hours_epoch)
        sws_time = tot_length(intersect(SWSEpoch,hours_epoch{h})); 
        total = sws_time + tot_length(intersect(union(REMEpoch,Wake),hours_epoch{h}));
        sws_ratio(h) = sws_time / total;
    end
    swa_res.sws_ratio{p} = sws_ratio;
    swa_res.sws_time{p} = sws_time;

    %% Up and Down duration vs Delta Amplitudes
    start_down = Start(Down);
    end_down = End(Down);
    tDownDuration = tsd(start_down + start_time, end_down - start_down);
    tUpDuration = tsd(end_down(1:end-1) + start_time, start_down(2:end) - end_down(1:end-1));


    for h=1:length(hours_epoch)
        down_durations(h) = nanmedian(Data(Restrict(tDownDuration,hours_epoch{h})));
        up_durations(h) = nanmedian(Data(Restrict(tUpDuration,hours_epoch{h})));
    end

    swa_res.down_durations{p} = down_durations;
    swa_res.up_durations{p} = up_durations;

        
end


%saving data
cd([FolderProjetDelta 'Data/']) 
save SWAEvolutionDeltaFeedback.mat swa_res hours_expe freqSO

