clear all
close all

Dir{1} = PathForExperimentsSleepWithDrugs('FLX_Ch_Baseline');

% Get a rem, wake, remOB, remOB1525,remOB2030 matrix with lines=days columms=mice
for mouse = 1:size(Dir{1}.path,2)
    for day=1:2
        
        try cd(Dir{1}.path{mouse}{day})
        
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
            catch 
                  rem(day,mouse) =NaN;
            remOB(day,mouse) = NaN;
            wake(day,mouse)=NaN;
            remOB1525(day,mouse)=NaN;
            remOB2030(day,mouse)=NaN;
        end
    end
end

% switch the first two lines for convenience
rem=flip(rem);
remOB=flip(remOB);
remOB1525=flip(remOB1525);
remOB2030=flip(remOB2030);
wake=flip(wake);

Dir{2} = PathForExperimentsSleepWithDrugs('FLX_Ch_Admin');


for mouse = 1:size(Dir{2}.path,2)
    for day = 1:size(Dir{2}.path{1,mouse},2)
        
            cd(Dir{2}.path{mouse}{day})
            
            if isfile('H_Low_Spectrum.mat') & isfile('StateEpochSBAllOB.mat')
                load('SleepScoring_OBGamma.mat','REMEpoch','SWSEpoch','Wake','Sleep')
                rem(day+2,mouse) = sum(Stop(REMEpoch)-Start(REMEpoch))./(sum(Stop(SWSEpoch)-Start(SWSEpoch))+sum(Stop(REMEpoch)-Start(REMEpoch)));
                wake(day+2,mouse) = sum(Stop(Wake)-Start(Wake))./(sum(Stop(Wake)-Start(Wake))+sum(Stop(Sleep)-Start(Sleep)));
                clear('REMEpoch','SWSEpoch','Sleep','Wake')
                load('StateEpochSBAllOB.mat','REMEpoch','SWSEpoch','Wake','Sleep')
                remOB(day+2,mouse) = sum(Stop(REMEpoch)-Start(REMEpoch))./(sum(Stop(SWSEpoch)-Start(SWSEpoch))+sum(Stop(REMEpoch)-Start(REMEpoch)));
                load('StateEpochSBAllOB_Bis.mat','REMEpoch','SWSEpoch','Wake','Sleep')
                remOB1525(day+2,mouse) = sum(Stop(REMEpoch)-Start(REMEpoch))./(sum(Stop(SWSEpoch)-Start(SWSEpoch))+sum(Stop(REMEpoch)-Start(REMEpoch)));
                load('StateEpochSBAllOB_Ter.mat','REMEpoch','SWSEpoch','Wake','Sleep')
                remOB2030(day+2,mouse) = sum(Stop(REMEpoch)-Start(REMEpoch))./(sum(Stop(SWSEpoch)-Start(SWSEpoch))+sum(Stop(REMEpoch)-Start(REMEpoch)));
            else
                rem(day+2,mouse) =NaN;
                remOB(day+2,mouse) = NaN;
                wake(day+1,mouse)=NaN;
                remOB1525(day+2,mouse)=NaN;
                remOB2030(day+2,mouse)=NaN;
                
            end
    end
end



%Replace 0 by NaN
for k=1:size(rem,1)
    for j=1:size(rem,2)
        if rem(k,j)==0;
            rem(k,j)=NaN;
        end
        if remOB(k,j)==0
            remOB(k,j)=NaN;
        end
         if remOB1525(k,j)==0
            remOB1525(k,j)=NaN;
         end
         if remOB2030(k,j)==0
            remOB2030(k,j)=NaN;
        end
    end
end

% Weird data
remOB1525(4,3)=NaN;

% Data splitting CS - BM
%rem_CS=zeros(5,3);
%rem_BM=zeros(5,3);
%remOB_CS=zeros(5,3);
%remOB_BM=zeros(5,3);

%for k=1:size(rem_CS,1)
    %for i=1:size(rem_CS,2)
      %  rem_CS(k,i)=rem(k,i);
      %  rem_BM(k,i)=rem(k,i+3);
     %   remOB_CS(k,i)=remOB(k,i);
     %   remOB_BM(k,i)=remOB(k,i+3);
  %  end
%end

% FIRST WAY TO PLOT
%figure
%clf
%subplot(2,2,1)
%PlotErrorBarN_KJ(rem_CS','newfig',0)
%xticks([1 2 3 4 5])
%xticklabels({'Baseline','Flx2','Flx5','Flx12','Flx15'})
%ylim([0 0.16])
%title('REM Sleep Duration CS')
 %subplot(2,2,2)
%PlotErrorBarN_KJ(rem_BM','newfig',0)
%xticks([1 2 3 4 5])
%xticklabels({'Baseline','Flx2','Flx5','Flx12','Flx15' })
%ylim([0 0.16])
%title('REM Sleep Duration BM')
%subplot(2,2,3)
%PlotErrorBarN_KJ(remOB_CS','newfig',0)
%xticks([1 2 3 4 5])
%xticklabels({'Baseline','Flx2','Flx5','Flx12','Flx15' })
%ylim([0 0.16])
%title('REM_OB Sleep Duration CS')
%subplot(2,2,4)
%PlotErrorBarN_KJ(remOB_BM','newfig',0)
%xticks([1 2 3 4 5])
%xticklabels({'Baseline','Flx2','Flx5','Flx12','Flx15' })
%ylim([0 0.16])
%title('REM_OB Sleep Duration BM')

% SECOND WAY TO PLOT
Day{1} = [-2,-1,2,5,12,18];
Day{2} = [-2,-1,2,5,12,18];
Day{3} = [-2,-1,5,12,18,19];
Day{4} = [-2,-1,2,5,12,15];
Day{5} = [-2,-1,2,6,15,18];
Day{6} = [-2,-1,2,4,12,22];


clf
for mouse = 1:size(Dir{2}.path,2)

subplot(2,3,mouse)
plot(Day{mouse},100*rem(:,mouse),'o-','linewidth',4,'color','r')
hold on
plot(Day{mouse},100*remOB(:,mouse),'o-','linewidth',4,'color','b')
plot(Day{mouse},100*remOB1525(:,mouse),'o-','linewidth',4,'color','y')
plot(Day{mouse},100*remOB2030(:,mouse),'o-','linewidth',4,'color','g')
title(num2str(Dir{1}.ExpeInfo{1,mouse}{1}.nmouse))

xlim([-3 23])
ylim([0 20])

xlabel('Days on Fluo')
ylabel('% REM')
set(gca,'FontSize',12,'FontWeight','bold','linewidth',2)
box off

end
legend({'SleepScoring OB/HPC','SleepScoring OBOnly','SleepScoring OB1525','SleepScoring OB2030'})


