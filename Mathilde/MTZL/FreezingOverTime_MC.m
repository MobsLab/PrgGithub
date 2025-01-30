
% number of freezing period
Mice = [756 758 761 763 765 ; 757 759 760 762 764];

Gr(1,1)=5;
Gr(1,2)=5;

MatNum=[];
MiceNumber = [756 757 758 759 760 761 762 763 764 765];
for k = 1:size(Mice,1)
    for j = 1 : Gr(1,k)
        MatNum(k,j) = find(MiceNumber==Mice(k,j));
    end
end



for i = 1 : length(MiceNumber)
    cd(['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/MethimazoleBehaviourExperiment/4DqysPost/FEAR-Mouse-',num2str(MiceNumber(i)),'-16062018-Hab_00'])
    load('behavResources.mat')

    
    %freezing at beginning
    StartEpoch = intervalSet(0,200*1e4);
    Freeze_start(i) = (sum((Stop(and(FreezeEpoch,StartEpoch), 's') - Start(and(FreezeEpoch,StartEpoch), 's')))/200);
    
    %freezing at end
    EndEpoch = intervalSet(200*1e4,900*1e4);
    Freeze_end(i) = (sum((Stop(and(FreezeEpoch,EndEpoch), 's') - Start(and(FreezeEpoch,EndEpoch), 's')))/700);

end


clf
all_fz_time = [];
for i = 1:5
cd(['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/MethimazoleBehaviourExperiment/4DqysPost/FEAR-Mouse-',num2str(MiceNumber(MatNum(1,i))),'-16062018-Hab_00']) 
load('behavResources.mat')
    all_fz_time = [all_fz_time;Range(Restrict(Vtsd,FreezeEpoch),'s')];
   %     all_fz_time = [all_fz_time;Stop(FreezeEpoch,'s')-Start(FreezeEpoch,'s')];
end


all_fz_time_mtzl = [];
for i = 1:5
cd(['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/MethimazoleBehaviourExperiment/4DqysPost/FEAR-Mouse-',num2str(MiceNumber(MatNum(2,i))),'-16062018-Hab_00']) 
load('behavResources.mat')
    all_fz_time_mtzl = [all_fz_time_mtzl;Range(Restrict(Vtsd,FreezeEpoch),'s')];
   %     all_fz_time_mtzl = [all_fz_time_mtzl;Stop(FreezeEpoch,'s')-Start(FreezeEpoch,'s')];

end


% freezing au cours du tps

PlotBarCrossProtocol_FreezeTime((Freeze_start(MatNum(1,i)))*100,(Freeze_start(MatNum(2,i)))*100,(Freeze_end(MatNum(1,i)))*100 ,(Freeze_end(MatNum(2,i)))*100,1)
xticks(1:2)
xtickangle(45)
xticklabels({'0-200s','200-900s'});
ylabel('% time freezing')
ylim([0 40])

ranksum(Freeze_start(MatNum(2,:)), Freeze_end(MatNum(2,:)));
ranksum(Freeze_start(MatNum(1,:)), Freeze_end(MatNum(1,:)));
set(gca,'FontSize',15)
set(gca,'Linewidth',2)



% freezing au cours du tps BINS
nhist({all_fz_time,all_fz_time_mtzl},'numbers','noerror','binfactor',2,'samebins')
xlabel('Time (s)')
ylabel('Time spent freezing')
legend('saline ','methimazole', 'Location','northwest')

[Y,X] = hist(all_fz_time,[0:20:900]);
[Y1,X1] = hist(all_fz_time_mtzl,[0:20:900]);
figure
stairs(X,100*Y/(15*4*20),'k','linewidth',2)
hold on
stairs(X1,100*Y1/(15*4*20),'r','linewidth',2)
box off


% freezing and tail temp over time
figure
subplot(211)
[Y,X] = hist(all_fz_time,[0:20:900]);
[Y1,X1] = hist(all_fz_time_mtzl,[0:20:900]);
plot(X,100*Y/(15*4*20),'k','linewidth',2)
hold on
plot(X1,100*Y1/(15*4*20),'r','linewidth',2)
% box off

subplot(212)
errorbar([5:10:895],nanmean(Temp_tail_sal),stdError(Temp_tail_sal),'k')
hold on
errorbar([5:10:895],nanmean(Temp_tail_mtzl),stdError(Temp_tail_mtzl),'r')
ylim([24 37])
title('Tail temperature')
ylabel('T (°C)')
xlabel('Time (s)')


