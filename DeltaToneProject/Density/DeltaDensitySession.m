% DeltaDensitySession
% 13.12.2016 KJ
%
% Collect data to plot the figures from the Figure7.pdf (f), corrected, of Gaetan PhD
% 
% 
%   see Figure7StimEffectSleepStructure
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

for p=1:length(Dir.path)
    try
        disp(' ')
        disp('****************************************************************')
        eval(['cd(Dir.path{',num2str(p),'}'')'])
        disp(pwd)
        deltadens_res.path{p}=Dir.path{p};
        deltadens_res.manipe{p}=Dir.manipe{p};
        deltadens_res.delay{p}=Dir.delay{p};
        deltadens_res.name{p}=Dir.name{p};
       
        %% Load        
        %Epoch and Spikes
        load StateEpochSB SWSEpoch Wake REMEpoch
        
        %Delta waves
        try
            load DeltaPFCx DeltaOffline
        catch
            load newDeltaPFCx DeltaEpoch
            DeltaOffline = DeltaEpoch;
            clear DeltaEpoch
        end
        tdeltas = ts((Start(DeltaOffline)+End(DeltaOffline))/2);
        %Session
        clear sessions
        load IntervalSession
        %cut the beginning of session1
        start_session1 = Start(Session1) + (End(Session1)-Start(Session1))*0.75;
        sessions{1}=intervalSet(start_session1, End(Session1));
        sessions{2}=Session2;sessions{3}=Session3;sessions{4}=Session4;sessions{5}=Session5;
        
        
        %% Delta number and density
        for s=1:length(sessions)
            deltadens_res.delta.nb(p,s) = length(Restrict(tdeltas,sessions{s}));
        end

        for s=1:length(sessions)
            duration_sleep = tot_length(intersect(SWSEpoch,sessions{s}))  * 1E-4;
            deltadens_res.delta.density(p,s) = length(Restrict(tdeltas,sessions{s})) / duration_sleep;
        end
        

        
        
    end
end

%saving data
cd([FolderProjetDelta 'Data/']) 
save DeltaDensitySession.mat deltadens_res hours_expe substage_ind

