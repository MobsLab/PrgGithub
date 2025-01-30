clear all
close all

Dir{1} = PathForExperimentsSleepWithDrugs('FLX_Ch_Baseline');

% Get a rem, wake, remOB matrix with lines=days columms=mice
mouse =3
    for day=1:size(Dir{1}.path{1,mouse},2)
        
        cd(Dir{1}.path{mouse}{day})
        
        if isfile('H_Low_Spectrum.mat') & isfile('StateEpochSBAllOB.mat')
            load('SleepScoring_OBGamma.mat','REMEpoch','SWSEpoch','Wake','Sleep')
            rem(day,mouse) = sum(Stop(REMEpoch)-Start(REMEpoch))./(sum(Stop(SWSEpoch)-Start(SWSEpoch))+sum(Stop(REMEpoch)-Start(REMEpoch)));
            wake(day,mouse) = sum(Stop(Wake)-Start(Wake))./(sum(Stop(Wake)-Start(Wake))+sum(Stop(Sleep)-Start(Sleep)));
            clear('REMEpoch','SWSEpoch','Sleep','Wake')
            load('StateEpochSBAllOB.mat','REMEpoch','SWSEpoch','Wake','Sleep')
            remOB(day,mouse) = sum(Stop(REMEpoch)-Start(REMEpoch))./(sum(Stop(SWSEpoch)-Start(SWSEpoch))+sum(Stop(REMEpoch)-Start(REMEpoch)));
            load('StateEpochSBAllOB_Bis.mat','REMEpoch','SWSEpoch','Wake','Sleep')
            remOB1525(day,mouse) = sum(Stop(REMEpoch)-Start(REMEpoch))./(sum(Stop(SWSEpoch)-Start(SWSEpoch))+sum(Stop(REMEpoch)-Start(REMEpoch)));
            load('StateEpochSBAllOB_Ter.mat','REMEpoch','SWSEpoch','Wake','Sleep')
            remOB2030(day,mouse) = sum(Stop(REMEpoch)-Start(REMEpoch))./(sum(Stop(SWSEpoch)-Start(SWSEpoch))+sum(Stop(REMEpoch)-Start(REMEpoch)));
        else
            rem(day,mouse) =NaN;
            remOB(day,mouse) = NaN;
            wake(day,mouse)=NaN;
            remOB1525(day,mouse)=NaN;
            remOB2030(day,mouse)=NaN;
            
        end
        
    end


Dir{2} = PathForExperimentsSleepWithDrugs('FLX_Ch_Admin');


    for day = 1:size(Dir{2}.path{1,mouse},2)
        cd(Dir{2}.path{mouse}{day})
        if isfile('H_Low_Spectrum.mat') & isfile('StateEpochSBAllOB.mat')
            load('SleepScoring_OBGamma.mat','REMEpoch','SWSEpoch','Wake','Sleep')
            rem(day+1,mouse) = sum(Stop(REMEpoch)-Start(REMEpoch))./(sum(Stop(SWSEpoch)-Start(SWSEpoch))+sum(Stop(REMEpoch)-Start(REMEpoch)));
            wake(day+1,mouse) = sum(Stop(Wake)-Start(Wake))./(sum(Stop(Wake)-Start(Wake))+sum(Stop(Sleep)-Start(Sleep)));
            clear('REMEpoch','SWSEpoch','Sleep','Wake')
            load('StateEpochSBAllOB.mat','REMEpoch','SWSEpoch','Wake','Sleep')
            remOB(day+1,mouse) = sum(Stop(REMEpoch)-Start(REMEpoch))./(sum(Stop(SWSEpoch)-Start(SWSEpoch))+sum(Stop(REMEpoch)-Start(REMEpoch)));
            load('StateEpochSBAllOB_Bis.mat','REMEpoch','SWSEpoch','Wake','Sleep')
            remOB1525(day+1,mouse) = sum(Stop(REMEpoch)-Start(REMEpoch))./(sum(Stop(SWSEpoch)-Start(SWSEpoch))+sum(Stop(REMEpoch)-Start(REMEpoch)));
            load('StateEpochSBAllOB_Ter.mat','REMEpoch','SWSEpoch','Wake','Sleep')
            remOB2030(day+1,mouse) = sum(Stop(REMEpoch)-Start(REMEpoch))./(sum(Stop(SWSEpoch)-Start(SWSEpoch))+sum(Stop(REMEpoch)-Start(REMEpoch)));
        else
            rem(day+1,mouse) =NaN;
            remOB(day+1,mouse) = NaN;
            wake(day+1,mouse)=NaN;
            remOB1525(day,mouse)=NaN;
            remOB2030(day,mouse)=NaN;
        end
        
    end


    
    Day{3} = [-1,5,12,18];


figure

subplot(1,1,1)
plot(Day{mouse},100*rem(:,mouse),'.-','linewidth',4,'color','r')
hold on
plot(Day{mouse},100*remOB(:,mouse),'.-','linewidth',4,'color','b')
plot(Day{mouse},100*remOB1525(:,mouse),'.-','linewidth',4,'color','y')
plot(Day{mouse},100*remOB2030(:,mouse),'.-','linewidth',4,'color','g')
title(num2str(Dir{1}.ExpeInfo{1,mouse}{1}.nmouse))

xlim([-3 23])
ylim([0 20])

xlabel('Days on Fluo')
ylabel('% REM')
set(gca,'FontSize',12,'FontWeight','bold','linewidth',2)
box off
legend({'SleepScoring OB/HPC','SleepScoring OB1015','SleepScoring OB1525','SleepScoring OB2030'})



    
    
    