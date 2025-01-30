% CreateSignalsIDFigures
% 03.10.2016 KJ
%
% Detect and save sleep events:
%   - Down states       (newDownState.mat Down)
%   - Ripples           (newRipHPC.mat Ripples_tmp)
%   - Spindles          ()
%   - Delta waves PFCx  (DeltaPFCx.mat DeltaOffline)
%   - Runsubstages      (NREMepochsML.mat)
%
%
% see CreateSignalsIDFigures



% Dir=PathForExperimentsDeltaWavesTone('all');
% Dir.path='/media/DataMOBsRAIDN/ProjetOREXIN/DataSleep/Mouse570/20171019-BasalSleep-8-20h';
% Dir.path='/media/DataMOBsRAIDN/ProjetOREXIN/DataSleep/Mouse571/20171019-BasalSleep-8-20h';
% Dir.path='/media/DataMOBsRAIDN/ProjetOREXIN/DataSleep/Mouse554/20170719_BasalSleep/OREXIN-Mouse-554-19072017';
% Dir.path={'/media/DataMobs73bis/Mouse573/20171222_BasalSleep_day/process/OREX-Mouse-573-22122017'};
% '/media/DataMobs73bis/Mouse573/20171221_BasalSleep_day/process/OREX-Mouse-573-21122017';
res=pwd; 
Dir.path={res}; 
Do_Down=0;
        load StateEpochSB SWSEpoch Wake REMEpoch
        
%       execute lines  98-131
   
for p=1:length(Dir.path)
%     try
        disp(' ')
        disp('****************************************************************')
        eval(['cd(Dir.path{',num2str(p),'}'')'])
        disp(pwd)
        
        clearvars -except Dir p Do_Down res
        %params
        freqDelta = [1 6];
        thD = 2;
        minDeltaDuration = 50;
        binsize=10;
        thresh0 = 0.7;
        minDownDur = 90;
        maxDownDur = 500;
        mergeGap = 10; % merge
        predown_size = 50;
        thresh_rip = [5 7];
        duration_rip = [30 30 100];
        
        %Epoch and Spikes
        load StateEpochSB SWSEpoch Wake REMEpoch
   
       if Do_Down %% Down states
            try
                 load newDownState.mat Down
                 Down;  disp('Down states already generated')
            catch
                try
                    load SpikeData
                    eval('load SpikesToAnalyse/PFCx_Neurons')
                    NumNeurons=number;
                    clear number
                    T=PoolNeurons(S,NumNeurons);
                    ST{1}=T;
                    try
                        ST=tsdArray(ST);
                    end
                    Q = MakeQfromS(ST,binsize*10); %binsize*10 to be in E-4s
                    MUA = Q;
                    Q = Restrict(Q, SWSEpoch);
                    %Down
                    Down = FindDown2_KJ(Q, 'low_thresh', thresh0, 'minDuration', minDownDur,'maxDuration', maxDownDur, 'mergeGap', mergeGap, 'predown_size', predown_size, 'method', 'mono');

                    try
                        delete('newDownState.mat')
                    end
                    save newDownState.mat Down
                catch
                    disp('Spike problem')
                end
            end
        end
        
        %% Ripples
        try
            load newRipHPC.mat
        catch
            try
                load ChannelsToAnalyse/dHPC_rip
            catch
                load ChannelsToAnalyse/dHPC_deep
            end
            eval(['load LFPData/LFP',num2str(channel)])
            HPCrip=LFP;
            clear LFP
            [Ripples_tmp,usedEpoch] = FindRipplesKarimSB(HPCrip,SWSEpoch,thresh_rip,duration_rip);
            chHPC = channel;
            save newRipHPC.mat chHPC Ripples_tmp
        end

        
        %% Load LFP
        %PFCx
        load ChannelsToAnalyse/PFCx_deep
        eval(['load LFPData/LFP',num2str(channel)])
        PFCdeep=LFP;
        clear LFP channel        
        try
            load ChannelsToAnalyse/PFCx_deltadeep
            eval(['load LFPData/LFP',num2str(channel)])
            PFCdeltadeep=LFP;
        catch
            PFCdeltadeep = PFCdeep;
        end
        clear LFP channel
        
        try
            load ChannelsToAnalyse/PFCx_sup
            eval(['load LFPData/LFP',num2str(channel)])
            PFCsup=LFP;
        end
        try
            load ChannelsToAnalyse/PFCx_deltasup
            eval(['load LFPData/LFP',num2str(channel)])
            PFCdeltasup=LFP;
        catch
            PFCdeltasup=PFCsup;
        end
        if exist('ChannelsToAnalyse/PFCx_spindles','file')==2
            load ChannelsToAnalyse/PFCx_spindles
            eval(['load LFPData/LFP',num2str(channel)])
            PFCspindles=LFP;
        elseif exist('PFCsup','var')
            PFCspindles=PFCsup;
        elseif exist('PFCdeltasup','var')
            PFCspindles=PFCdeltasup;
        end
        %PaCx
        try
            load ChannelsToAnalyse/PaCx_deep
            eval(['load LFPData/LFP',num2str(channel)])
            PaCdeep=LFP;
            clear LFP channel
            load ChannelsToAnalyse/PaCx_sup
            eval(['load LFPData/LFP',num2str(channel)])
            PaCsup=LFP;
            clear LFP channel
        catch
            disp('no PaCx')
        end
        %MoCx
        try
            load ChannelsToAnalyse/MoCx_deep
            eval(['load LFPData/LFP',num2str(channel)])
            MoCdeep=LFP;
            clear LFP channel
            load ChannelsToAnalyse/MoCx_sup
            eval(['load LFPData/LFP',num2str(channel)])
            MoCsup=LFP;
            clear LFP channel
        catch
            disp('no MoCx')
        end
        
        %% PFCx Delta
        try 
            load DeltaPFCx.mat DeltaOffline
            nb_delta = length(Start(DeltaOffline));
        catch
            nb_delta = 0;
        end
        if nb_delta==0
            try
                clear distance
                k=1;
                for i=0.1:0.1:4
                    distance(k)=std(Data(PFCdeltadeep)-i*Data(PFCdeltasup));
                    k=k+1;
                end
                Factor = find(distance==min(distance))*0.1;
                EEGsleepDiff = ResampleTSD(tsd(Range(PFCdeep),Data(PFCdeltadeep) - Factor*Data(PFCdeltasup)),100);
                Filt_diff = FilterLFP(EEGsleepDiff, freqDelta, 1024);
                pos_filtdiff = max(Data(Filt_diff),0);
                std_diff = std(pos_filtdiff(pos_filtdiff>0));  % std that determines thresholds

                % deltas
                thresh_delta = thD * std_diff;
                all_cross_thresh = thresholdIntervals(tsd(Range(Filt_diff), pos_filtdiff), thresh_delta, 'Direction', 'Above');
                DeltaOffline = dropShortIntervals(all_cross_thresh, minDeltaDuration * 10); % crucial element for noise detection.

                try
                    delete('DeltaPFCx.mat')
                end
                save DeltaPFCx.mat DeltaOffline
            catch
                disp('error in delta PFCx generation')
            end
        end
        clear DeltaOffline nb_delta
        
        %% PaCx Delta
        if exist('PaCsup','var')==1
            try 
                load DeltaPaCx.mat DeltaOffline
                nb_delta = length(Start(DeltaOffline));
            catch
                nb_delta = 0;
            end
            if nb_delta==0
                try
                    clear distance
                    for i=0.1:0.1:4
                        distance(k)=std(Data(PaCdeep)-i*Data(PaCsup));
                        k=k+1;
                    end
                    Factor = find(distance==min(distance),1)*0.1;
                    EEGsleepDiff = ResampleTSD(tsd(Range(PaCdeep),Data(PaCdeep) - Factor*Data(PaCsup)),100);
                    Filt_diff = FilterLFP(EEGsleepDiff, freqDelta, 1024);
                    pos_filtdiff = max(Data(Filt_diff),0);
                    std_diff = std(pos_filtdiff(pos_filtdiff>0));  % std that determines thresholds

                    % deltas
                    thresh_delta = thD * std_diff;
                    all_cross_thresh = thresholdIntervals(tsd(Range(Filt_diff), pos_filtdiff), thresh_delta, 'Direction', 'Above');
                    DeltaOffline = dropShortIntervals(all_cross_thresh, minDeltaDuration * 10); % crucial element for noise detection.

                    try
                        delete('DeltaPaCx.mat')
                    end
                    save DeltaPaCx.mat DeltaOffline
                catch
                    disp('error in delta PaCx generation')
                end
            end
        end
        clear DeltaOffline nb_delta
        
        %% MoCx Delta
        if exist('MoCsup','var')==1
            try 
                load DeltaMoCx.mat DeltaOffline
                nb_delta = length(Start(DeltaOffline));
            catch
                nb_delta = 0;
            end
            if nb_delta==0
                try
                    clear distance
                    for i=0.1:0.1:4
                        distance(k)=std(Data(MoCdeep)-i*Data(MoCsup));
                        k=k+1;
                    end
                    Factor = find(distance==min(distance))*0.1;
                    EEGsleepDiff = ResampleTSD(tsd(Range(MoCdeep),Data(MoCdeep) - Factor*Data(MoCsup)),100);
                    Filt_diff = FilterLFP(EEGsleepDiff, freqDelta, 1024);
                    pos_filtdiff = max(Data(Filt_diff),0);
                    std_diff = std(pos_filtdiff(pos_filtdiff>0));  % std that determines thresholds

                    % deltas
                    thresh_delta = thD * std_diff;
                    all_cross_thresh = thresholdIntervals(tsd(Range(Filt_diff), pos_filtdiff), thresh_delta, 'Direction', 'Above');
                    DeltaOffline = dropShortIntervals(all_cross_thresh, minDeltaDuration * 10); % crucial element for noise detection.

                    try
                        delete('DeltaMoCx.mat')
                    end
                    save DeltaMoCx.mat DeltaOffline
                catch
                    disp('error in delta MoCx generation')
                end
            end
        end
        clear DeltaOffline nb_delta
        
        
        %% Spindles
        %PFCdeep
        try
            clear SpiTot
            load SpindlesPFCxDeep SpiTot SpiHigh SpiLow
            SpiTot;
            clear SpiTot
        catch
            try
                [SpiTot,SWATot]   = FindSpindlesKarimNewSB(PFCdeep,[2 20],SWSEpoch,'off');
                [SpiHigh,SWAHigh] = FindSpindlesKarimNewSB(PFCdeep,[12 15],SWSEpoch,'off');
                [SpiLow,SWALow]   = FindSpindlesKarimNewSB(PFCdeep,[9 12],SWSEpoch,'off');
                [SpiULow,SWAULow] = FindSpindlesKarimNewSB(PFCdeep,[6 8],SWSEpoch,'off');
                save SpindlesPFCxDeep SpiTot SWATot SpiHigh SWAHigh SpiLow SWALow SpiULow SWAULow
            catch
                disp('error in spindles PFCdeep generation')
            end
        end
        %PFCsup
        try
            clear SpiTot
            load SpindlesPFCxSup SpiTot SpiHigh SpiLow
            SpiTot;
            clear SpiTot
        catch
            try
                [SpiTot,SWATot]   = FindSpindlesKarimNewSB(PFCspindles,[2 20],SWSEpoch,'off');
                [SpiHigh,SWAHigh] = FindSpindlesKarimNewSB(PFCspindles,[12 15],SWSEpoch,'off');
                [SpiLow,SWALow]   = FindSpindlesKarimNewSB(PFCspindles,[9 12],SWSEpoch,'off');
                [SpiULow,SWAULow] = FindSpindlesKarimNewSB(PFCspindles,[6 8],SWSEpoch,'off');
                save SpindlesPFCxSup SpiTot SWATot SpiHigh SWAHigh SpiLow SWALow SpiULow SWAULow
            catch
                disp('error in spindles PFCsup generation')
            end
        end
        
        %PaCdeep
        if exist('PaCdeep','var')==1
            try
                clear SpiTot
                load SpindlesPaCxDeep SpiTot SpiHigh SpiLow
                SpiTot;
                clear SpiTot
            catch
                try
                    [SpiTot,SWATot]   = FindSpindlesKarimNewSB(PaCdeep,[2 20],SWSEpoch,'off');
                    [SpiHigh,SWAHigh] = FindSpindlesKarimNewSB(PaCdeep,[12 15],SWSEpoch,'off');
                    [SpiLow,SWALow]   = FindSpindlesKarimNewSB(PaCdeep,[9 12],SWSEpoch,'off');
                    [SpiULow,SWAULow] = FindSpindlesKarimNewSB(PaCdeep,[6 8],SWSEpoch,'off');
                    save SpindlesPaCxDeep SpiTot SWATot SpiHigh SWAHigh SpiLow SWALow SpiULow SWAULow
                catch
                    disp('error in spindles PaCdeep generation')
                end
            end
        end
        %PaCsup
        if exist('PaCsup','var')==1
            try
                clear SpiTot
                load SpindlesPaCxSup SpiTot SpiHigh SpiLow
                SpiTot;
                clear SpiTot
            catch
                try
                    [SpiTot,SWATot]   = FindSpindlesKarimNewSB(PaCsup,[2 20],SWSEpoch,'off');
                    [SpiHigh,SWAHigh] = FindSpindlesKarimNewSB(PaCsup,[12 15],SWSEpoch,'off');
                    [SpiLow,SWALow]   = FindSpindlesKarimNewSB(PaCsup,[9 12],SWSEpoch,'off');
                    [SpiULow,SWAULow] = FindSpindlesKarimNewSB(PaCsup,[6 8],SWSEpoch,'off');
                    save SpindlesPaCxSup SpiTot SWATot SpiHigh SWAHigh SpiLow SWALow SpiULow SWAULow
                catch
                    disp('error in spindles PaCsup generation')
                end
            end
        end
        
        %MoCdeep
        if exist('MoCdeep','var')==1
            try
                clear SpiTot
                load SpindlesMoCxDeep SpiTot SpiHigh SpiLow
                SpiTot;
                clear SpiTot
            catch
                try
                    [SpiTot,SWATot]   = FindSpindlesKarimNewSB(MoCdeep,[2 20],SWSEpoch,'off');
                    [SpiHigh,SWAHigh] = FindSpindlesKarimNewSB(MoCdeep,[12 15],SWSEpoch,'off');
                    [SpiLow,SWALow]   = FindSpindlesKarimNewSB(MoCdeep,[9 12],SWSEpoch,'off');
                    [SpiULow,SWAULow] = FindSpindlesKarimNewSB(MoCdeep,[6 8],SWSEpoch,'off');
                    save SpindlesMoCxDeep SpiTot SWATot SpiHigh SWAHigh SpiLow SWALow SpiULow SWAULow
                catch
                    disp('error in spindles MoCdeep generation')
                end
            end
        end
        %MoCsup
        if exist('MoCsup','var')==1
            try
                clear SpiTot
                load SpindlesMoCxSup SpiTot SpiHigh SpiLow
                SpiTot;
                clear SpiTot
            catch
                try
                    [SpiTot,SWATot]   = FindSpindlesKarimNewSB(MoCsup,[2 20],SWSEpoch,'off');
                    [SpiHigh,SWAHigh] = FindSpindlesKarimNewSB(MoCsup,[12 15],SWSEpoch,'off');
                    [SpiLow,SWALow]   = FindSpindlesKarimNewSB(MoCsup,[9 12],SWSEpoch,'off');
                    [SpiULow,SWAULow] = FindSpindlesKarimNewSB(MoCsup,[6 8],SWSEpoch,'off');
                    save SpindlesMoCxSup SpiTot SWATot SpiHigh SWAHigh SpiLow SWALow SpiULow SWAULow
                catch
                    disp('error in spindles MoCsup generation')
                end
            end
        end
        
        
        %% Substages
        clear op NamesOp Dpfc Epoch noise
        try
            load NREMepochsML.mat op NamesOp Dpfc Epoch noise
            op; disp('Substages already generated')
        catch
            [op,NamesOp,Dpfc,Epoch,noise]=FindNREMepochsML;
            disp('saving in NREMepochsML.mat')
            save NREMepochsML.mat op NamesOp Dpfc Epoch noise
        end
        

%     catch
%         disp('error for this record')
%     end
end