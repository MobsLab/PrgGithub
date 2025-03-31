clear all
close all
Dir{1} = PathForExperimentsSleepWithDrugs('FLX_Ch_Baseline');
Dir{2} = PathForExperimentsSleepWithDrugs('FLX_Ch_Admin');


for mouse = 1:size(Dir{1}.path,2)
    for day = 1:size(Dir{1}.path{1,mouse},2)
        
        cd(Dir{1}.path{mouse}{1})
        load('SleepScoring_OBGamma.mat','REMEpoch','SWSEpoch','Sleep','Wake')
        
        if sum(Stop(Sleep,'s')-Start(Sleep,'s'))>7200
            
            % Sleep duration
            SleepDur(day,mouse) = sum(Stop(Sleep,'s')-Start(Sleep,'s'));
            
            % get the transition probability into REM sleep
            RemProba(day,mouse) = length(Stop(REMEpoch))./sum(Stop(Sleep)-Start(Sleep));
            
            % get the average duration of a REM bout
            RemDurMean(day,mouse) = nanmean(Stop(REMEpoch,'s')-Start(REMEpoch,'s'));
            
            % get the average duration of a REM Epoch
            RemDurPerc(day,mouse) = sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))/sum(Stop(Sleep,'s')-Start(Sleep,'s'));
            
            try load('StateEpochSBAllOB.mat')
                SleepOB10_15(day,mouse)=sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))/sum(Stop(Sleep,'s')-Start(Sleep,'s'));
            end
            try load('StateEpochSBAllOB_Bis.mat')
                SleepOB15_25(day,mouse)=sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))/sum(Stop(Sleep,'s')-Start(Sleep,'s'));
            end
            try load('StateEpochSBAllOB_Ter.mat')
                SleepOB20_30(day,mouse)=sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))/sum(Stop(Sleep,'s')-Start(Sleep,'s'));
            end
        end
        
        for day = 1:size(Dir{2}.path{1,mouse},2)
            
            cd(Dir{2}.path{mouse}{day})
            load('SleepScoring_OBGamma.mat','REMEpoch','SWSEpoch','Sleep','Wake')
            
            if sum(Stop(Sleep,'s')-Start(Sleep,'s'))>7200
                
                % Sleep duration
                SleepDur(day+3,mouse) = sum(Stop(Sleep,'s')-Start(Sleep,'s'));
                
                % get the transition probability into REM sleep
                RemProba(day+3,mouse) = length(Stop(REMEpoch))./sum(Stop(Sleep)-Start(Sleep));
                
                % get the average duration of a REM bout
                RemDurMean(day+3,mouse) = nanmean(Stop(REMEpoch,'s')-Start(REMEpoch,'s'));
                
                % get the average duration of a REM bout
                RemDurPerc(day+3,mouse) = sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))/sum(Stop(Sleep,'s')-Start(Sleep,'s'));
                
                try load('StateEpochSBAllOB.mat')
                    SleepOB10_15(day+3,mouse)=sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))/sum(Stop(Sleep,'s')-Start(Sleep,'s'));
                end
                try load('StateEpochSBAllOB_Bis.mat')
                    SleepOB15_25(day+3,mouse)=sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))/sum(Stop(Sleep,'s')-Start(Sleep,'s'));
                end
                try load('StateEpochSBAllOB_Ter.mat')
                    SleepOB20_30(day+3,mouse)=sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))/sum(Stop(Sleep,'s')-Start(Sleep,'s'));
                end
            end
        end
    end
end

% Placing Nan
SleepDur(SleepDur==0)=NaN;
RemDurPerc(RemDurPerc==0)=NaN;
RemDurMean(RemDurMean==0)=NaN;
RemProba(RemProba==0)=NaN;
SleepOB10_15(SleepOB10_15==0)=NaN;
SleepOB15_25(SleepOB15_25==0)=NaN;
SleepOB20_30(SleepOB20_30==0)=NaN;
SleepDur=SleepDur/3600;


figure
subplot(221); PlotErrorBarN_KJ(SleepDur','newfig',0); makepretty; title('Sleep duration'); ylabel('time (hours)');
xticks([1.5 4 5 6 7]); xticklabels({'Baseline','Flx2','Flx5','Flx12','Flx18'})
subplot(222); PlotErrorBarN_KJ(RemDurPerc','newfig',0); makepretty; title('REM proportion'); ylabel('%');
xticks([1.5 4 5 6 7]); xticklabels({'Baseline','Flx2','Flx5','Flx12','Flx18'})
subplot(223); PlotErrorBarN_KJ(RemDurMean','newfig',0); makepretty; title('Mean duration of REM episodes'); ylabel('time (s)');
xticks([1.5 4 5 6 7]); xticklabels({'Baseline','Flx2','Flx5','Flx12','Flx18'})
subplot(224); PlotErrorBarN_KJ(RemProba','newfig',0); makepretty; title('REM transition probability'); ylabel('%');
xticks([1.5 4 5 6 7]); xticklabels({'Baseline','Flx2','Flx5','Flx12','Flx18'})

a=suptitle('Chronic fluoxetine mice, sleep analysis, n=9'); a.FontSize=20;




figure
subplot(411)
bar([RemDurPerc(:,5) SleepOB10_15(:,5) SleepOB15_25(:,5) SleepOB20_30(:,5) ])

subplot(412)
bar([RemDurPerc(:,5) SleepOB10_15(:,2) SleepOB15_25(:,2) SleepOB20_30(:,2) ])

subplot(413)
bar([RemDurPerc(1,1:8)' SleepOB10_15(1,:)' SleepOB15_25(1,:)' SleepOB20_30(1,:)' ])

subplot(411)
bar([RemDurPerc(:,5) SleepOB10_15(:,5) SleepOB15_25(:,5) SleepOB20_30(:,5) ])


legend('HPC','10-15','15-25','20-30')


     
     

