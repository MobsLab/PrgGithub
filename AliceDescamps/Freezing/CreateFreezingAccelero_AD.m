%% Get Directories
Dir = PathForExperiments_ExposuresSD_AD('SecondSensoryExposure_C57cage_SecondRun_inhibDREADD_CRH_VLPO');
%% Parameters
thtps_immob=2;
smoofact_Acc = 15;
th_immob_Acc = 17000000;

%% Do the job
for i=1:length(Dir.path)
    DirCur=Dir.path{i}{1};
    
    cd(DirCur);
    
    
    if exist('behavResources_Offline.mat')>0
        load('behavResources_Offline.mat');
    else
        load('behavResources.mat');
    end
    
    if exist('MovAcctsd')>0
        NewMovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),smoofact_Acc));
        FreezeAccEpoch=thresholdIntervals(NewMovAcctsd,th_immob_Acc,'Direction','Below');
        FreezeAccEpoch=mergeCloseIntervals(FreezeAccEpoch,0.3*1e4);
        FreezeAccEpoch=dropShortIntervals(FreezeAccEpoch,thtps_immob*1e4);
        
        if exist('behavResources_Offline.mat')>0
            save ('behavResources_Offline.mat', 'FreezeAccEpoch', 'thtps_immob', 'smoofact_Acc', 'th_immob_Acc',  '-append');
        else
            
            save ('behavResources.mat', 'FreezeAccEpoch', 'thtps_immob', 'smoofact_Acc', 'th_immob_Acc',  '-append');
        end
        
        
    end

    clearvars -except Dir thtps_immob smoofact_Acc th_immob_Acc
end
