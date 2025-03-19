% ParcoursOnlineDeltaDetectionQuality 2

if ~exist('Res','var')
    clear
    % params
    tbefore = 70; %time before threshold crossing, in ms
    tafter = 70; %time after threshold crossing
    freqDeltaInf=1;
    freqDeltaSup = [4:2:20 30:20:90];
    thD_list = 0.2:0.2:3;
    minDeltaDuration = [0 20 50 70 100]; %in ms


    exp='DeltaToneAll';
    Dir=PathForExperimentsDeltaSleep2016(exp);

    a=0;
    for manip=1:length(Dir.path)
        a = a + 1;
        disp('  ')
        disp(Dir.path{manip})
        disp(' ')
        cd(Dir.path{manip})

        %load data 
        error_loading = 0;
        try
            load ChannelsToAnalyse/PFCx_deep
            eval(['load LFPData/LFP',num2str(channel)])
            LFPdeep=LFP;
            clear LFP
            load ChannelsToAnalyse/PFCx_sup
            eval(['load LFPData/LFP',num2str(channel)])
            LFPsup=LFP;
            clear LFP
            clear channel
            load StateEpochSB SWSEpoch Wake
            load DeltaSleepEvent
            online_deltas = ts(DeltaDetect);
        catch
            error_loading = 1;
            disp('loading error for this record')
        end

        if error_loading
            continue
        end


        Res.path{a} = Dir.path{manip};

        %prefactor and Diff
        k=1;
        for i=0.1:0.1:4
            distance(k)=std(Data(LFPdeep)-i*Data(LFPsup));
            k=k+1;
        end
        Factor=find(distance==min(distance))*0.1;
        EEGsleepDiff=ResampleTSD(tsd(Range(LFPdeep),Data(LFPdeep) - Factor*Data(LFPsup)),300);


        %% loop over params
        nb_deltasOff = zeros(length(freqDeltaSup),length(thD_list), length(minDeltaDuration));
        nb_deltasOn = zeros(length(freqDeltaSup),length(thD_list), length(minDeltaDuration));
        nb_intersOnOff = zeros(length(freqDeltaSup),length(thD_list), length(minDeltaDuration));

        for f=1:length(freqDeltaSup)
            Filt_diff = FilterLFP(EEGsleepDiff, [freqDeltaInf freqDeltaSup(f)], 1024);
            pos_filtdiff = max(Data(Filt_diff),0);
            std_diff = std(pos_filtdiff(pos_filtdiff>0));  % std that determines thresholds

            for t=1:length(thD_list)
                thD = thD_list(t);
                thresh_delta = thD * std_diff;

                all_cross_thresh = thresholdIntervals(tsd(Range(Filt_diff), pos_filtdiff), thresh_delta, 'Direction', 'Above');
                for m=1:length(minDeltaDuration)
                    DeltaOffline = dropShortIntervals(all_cross_thresh, minDeltaDuration(m) * 10); % crucial element for noise detection.
                    deltas_off_intervals = [Start(DeltaOffline,'ms')-tbefore End(DeltaOffline,'ms')+tafter];

                    [status,interval,index] = InIntervals(Range(online_deltas,'ms'), deltas_off_intervals);
                    nb_deltasOn(f,t,m) = length(status);
                    nb_deltasOff(f,t,m) = size(deltas_off_intervals,1);
                    nb_intersOnOff(f,t,m) = sum(status);
                end
            end
        end
        Res.nb_deltasOn{a} = nb_deltasOn;
        Res.nb_deltasOff{a} = nb_deltasOff;
        Res.nb_intersOnOff{a} = nb_intersOnOff;

    end

end


%% Analyse result
tbefore = Res.tbefore;
tafter = Res.tafter; 
freqDeltaInf=Res.freqDeltaInf;
freqDeltaSup = Res.freqDeltaSup;
thD_list = Res.thD_list;
minDeltaDuration = Res.minDeltaDuration; 


nb_deltasOff = zeros(length(freqDeltaSup),length(thD_list), length(minDeltaDuration));
nb_deltasOn = zeros(length(freqDeltaSup),length(thD_list), length(minDeltaDuration));
nb_intersOnOff = zeros(length(freqDeltaSup),length(thD_list), length(minDeltaDuration));

for a = 1:length(Res.path)
        nb_deltasOn = nb_deltasOn + Res.nb_deltasOn{a};
        nb_deltasOff = nb_deltasOff + Res.nb_deltasOff{a};
        nb_intersOnOff = nb_intersOnOff + Res.nb_intersOnOff{a};
end

precision_all = nb_intersOnOff ./ nb_deltasOn; 
recall_all = nb_intersOnOff ./ nb_deltasOff;










