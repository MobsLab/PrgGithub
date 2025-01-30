% ParcoursOnlineDeltaDetectionQuality3

if ~exist('Res','var')
    clear
    % params
    binsize=10;
    thresh0 = 0.8;
    minDownDur = 75;
    maxDownDur = 1000;
    mergeGap = 10; % merge
    predown_size = 30;
    % params
    tbefore = 100; %time before threshold crossing, in ms
    tafter = 100; %time after threshold crossing
    freqDeltaInf=1;
    freqDeltaSup = [4:2:20 30:20:90];
    thD_list = 0.2:0.2:3;
    minDeltaDuration = [0 20 50 70 100]; %in ms


    exp='Basal';
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
            load SpikeData
            eval('load SpikesToAnalyse/PFCx_Neurons')
            NumNeurons=number;
            clear number
        catch
            error_loading = 1;
            disp('loading error for this record')
        end

        if error_loading
            continue
        end


        Res.path{a} = Dir.path{manip};
        
        %% Find downstates
        T=PoolNeurons(S,NumNeurons);
        ST{1}=T;
        try
            ST=tsdArray(ST);
        end
        Q = MakeQfromS(ST,binsize*10); %binsize*10 to be in E-4s

        Res.FRsws{a} = mean(full(Data(Restrict(Q, SWSEpoch))), 1); % firing rate for a bin of 10ms
        Res.FRwake{a} = mean(full(Data(Restrict(Q, Wake))), 1);

        %Down
        Down = FindDown2_KJ(Q, 'low_thresh', thresh0, 'minDuration', minDownDur,'maxDuration', maxDownDur, 'mergeGap', mergeGap, 'predown_size', predown_size, 'method', 'mono');
        down_interval = [Start(Down) End(Down)];
        down_durations = End(Down) - Start(Down);
        largeDown = [Start(Down,'ms')-tbefore End(Down,'ms')+tafter];
        nb_down = length(down_interval);

        %prefactor and Diff
        k=1;
        for i=0.1:0.1:4
            distance(k)=std(Data(LFPdeep)-i*Data(LFPsup));
            k=k+1;
        end
        Factor=find(distance==min(distance))*0.1;
        EEGsleepDiff=ResampleTSD(tsd(Range(LFPdeep),Data(LFPdeep) - Factor*Data(LFPsup)),300);


        %% loop over params
        nb_down = nb_down * ones(length(freqDeltaSup),length(thD_list), length(minDeltaDuration));
        nb_deltas = zeros(length(freqDeltaSup),length(thD_list), length(minDeltaDuration));
        nb_inters = zeros(length(freqDeltaSup),length(thD_list), length(minDeltaDuration));

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
                    deltas_tmp = Start(DeltaOffline,'ms') + (End(DeltaOffline,'ms')-Start(DeltaOffline,'ms')) / 2;

                    [status,interval,index] = InIntervals(deltas_tmp, largeDown);
                    nb_deltas(f,t,m) = length(status);
                    nb_inters(f,t,m) = sum(status);
                end
            end
        end
        Res.nb_down{a} = nb_down;
        Res.nb_deltas{a} = nb_deltas;
        Res.nb_inters{a} = nb_inters;

    end

end



%% Analyse result 
freqDeltaInf=Res.freqDeltaInf;
freqDeltaSup = Res.freqDeltaSup;
thD_list = Res.thD_list;
minDeltaDuration = Res.minDeltaDuration; 


nb_down = zeros(length(freqDeltaSup),length(thD_list), length(minDeltaDuration));
nb_deltas = zeros(length(freqDeltaSup),length(thD_list), length(minDeltaDuration));
nb_inters = zeros(length(freqDeltaSup),length(thD_list), length(minDeltaDuration));

for a = 1:length(Res.path)
        nb_deltas = nb_deltas + Res.nb_deltas{a};
        nb_down = nb_down + Res.nb_down{a};
        nb_inters = nb_inters + Res.nb_inters{a};
end

precision_all = nb_inters ./ nb_deltas; 
recall_all = nb_inters ./ nb_down;

















