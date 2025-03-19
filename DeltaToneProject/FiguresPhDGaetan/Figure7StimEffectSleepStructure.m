% Figure7StimEffectSleepStructure
% 05.12.2016 KJ
%
% Collect data to plot the figures from the Figure7.pdf of Gaetan PhD
% 
% 
%   see Figure7StimEffectSleepStructurePlot1 Figure7StimEffectSleepStructurePlot2 Figure7StimEffectSleepStructurePlot3
%


Dir1 = PathForExperimentsDeltaWavesTone('Basal');
for p=1:length(Dir1.path)
    Dir1.delay{p}=0;
end
Dir2=PathForExperimentsDeltaWavesTone('RdmTone');
Dir3=PathForExperimentsDeltaWavesTone('DeltaToneAll');
Dir = MergePathForExperiment(Dir2,Dir3);
Dir = MergePathForExperiment(Dir1,Dir);
% 
% Dir1 = PathForExperimentsDeltaKJHD('Basal');
% for p=1:length(Dir1.path)
%     Dir1.delay{p}=0;
% end
% Dir2 = PathForExperimentsDeltaKJHD('RdmTone');
% Dir3 =PathForExperimentsDeltaKJHD('DeltaToneAll');
% Dir = MergePathForExperiment(Dir2,Dir3);
% Dir = MergePathForExperiment(Dir1,Dir);
clear Dir1 Dir2 Dir3

%params
substage_ind=1:6;
hours_expe = 10:1:20;

load([FolderProjetDelta 'Data/Figure7StimEffectSleepStructure.mat']) 


for p=1:length(Dir.path)
    try
        disp(' ')
        disp('****************************************************************')
        eval(['cd(Dir.path{',num2str(p),'}'')'])
        disp(pwd)
        figure7_res.path{p}=Dir.path{p};
        figure7_res.manipe{p}=Dir.manipe{p};
        figure7_res.delay{p}=Dir.delay{p};
        figure7_res.name{p}=Dir.name{p};
       
        %% Load
        %Times will be convert in seconds or 1E-4s
        load behavResources TimeDebRec TimeEndRec
        start_time = (TimeDebRec(1,1)*3600 + TimeDebRec(1,2)*60 + TimeDebRec(1,3))*1E4; %start time in sec
        for h=1:length(hours_expe)
            hours_epoch{h} = intervalSet(hours_expe(h)*3600E4 - start_time, (hours_expe(h)+1)*3600E4-1 - start_time);
        end
        midday_epoch = intervalSet(12*3600E4 - start_time, 14*3600E4 - start_time);
        evening_epoch = intervalSet(17*3600E4 - start_time, 19*3600E4 - start_time);
        
        %Epoch and Spikes
        load StateEpochSB SWSEpoch Wake REMEpoch
        SWSEpoch = intervalSet(Start(SWSEpoch),End(SWSEpoch));
        Wake = intervalSet(Start(Wake),End(Wake));
        REMEpoch = intervalSet(Start(REMEpoch),End(REMEpoch));
        
        %Delta waves
        try
            load DeltaPFCx DeltaOffline
        catch
            load newDeltaPFCx DeltaEpoch
            DeltaOffline = DeltaEpoch;
            clear DeltaEpoch
        end
        tdeltas = ts((Start(DeltaOffline)+End(DeltaOffline))/2);
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
        tdowns = ts((Start(Down)+End(Down))/2);
        
        %Ripples
        load newRipHPC Ripples_tmp
        tripples = ts(Ripples_tmp(:,2)*1E4);
        %Spindles
        load SpindlesPFCxSup SpiHigh SpiLow
        tSpiHigh_sup = ts(SpiHigh(:,2)*1E4);
        tSpiLow_sup = ts(SpiLow(:,2)*1E4);
        load SpindlesPFCxDeep SpiHigh SpiLow
        tSpiHigh_deep = ts(SpiHigh(:,2)*1E4);
        tSpiLow_deep = ts(SpiLow(:,2)*1E4);
        
        %Substages and stages
        clear op NamesOp Dpfc Epoch noise
        load NREMepochsML.mat op NamesOp Dpfc Epoch noise
        disp('Loading epochs from NREMepochsML.m')
        [Substages,NamesSubstages]=DefineSubStages(op,noise);
        %Session
        load IntervalSession
        sessions{1}=Session1;sessions{2}=Session2;sessions{3}=Session3;sessions{4}=Session4;sessions{5}=Session5;                       
        
        
        %% Sleep stage duration
        for sub=substage_ind
            for s=1:length(sessions)
                figure7_res.stageDuration(p,sub,s) = tot_length(intersect(Substages{sub},sessions{s}));
            end
        end
        
        %% Delta number and density
        for s=1:length(sessions)
            figure7_res.delta.nb(p,s) = length(Restrict(tdeltas,sessions{s}));
        end

        for s=1:length(sessions)
            duration_sleep = (tot_length(intersect(Substages{6},sessions{s})) + tot_length(intersect(Substages{4},sessions{s}))) * 1E-4;
            figure7_res.delta.density(p,s) = length(Restrict(tdeltas,sessions{s})) / duration_sleep;
        end
        
        %% Down number and density
        for s=1:length(sessions)
            figure7_res.down.nb(p,s) = length(Restrict(tdowns,sessions{s}));
        end
        
        for s=1:length(sessions)
            duration_sleep = (tot_length(intersect(Substages{6},sessions{s})) + tot_length(intersect(Substages{4},sessions{s}))) * 1E-4;
            figure7_res.down.density(p,s) = length(Restrict(tdowns,sessions{s})) / duration_sleep;
        end
        
        %% SPW-Rs number and density
        for s=1:length(sessions)
            figure7_res.ripples.nb(p,s) = length(Restrict(tripples,sessions{s}));
        end
        
        for s=1:length(sessions)
            duration_sleep = (tot_length(intersect(Substages{6},sessions{s})) + tot_length(intersect(Substages{4},sessions{s}))) * 1E-4;
            figure7_res.ripples.density(p,s) = length(Restrict(tripples,sessions{s})) / duration_sleep;
        end
        
    end
end


%saving data
cd([FolderProjetDelta 'Data/']) 
save Figure7StimEffectSleepStructure.mat figure7_res hours_expe substage_ind

