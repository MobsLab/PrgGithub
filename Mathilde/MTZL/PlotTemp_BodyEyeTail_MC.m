Mice = [756 758 761 763 765 ; 757 759 760 762 764];

Gr(1,1)=5;
Gr(1,2)=5;

MatNum=[];
MiceNumber = [756:765];
for k = 1:size(Mice,1)
    for j = 1 : Gr(1,k)
        MatNum(k,j) = find(MiceNumber==Mice(k,j));
    end
end

% Plot temperature of body, eye and tail for each mouse
clf
for i = 1:5
%cd(['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/MethimazoleBehaviourExperiment/BeforeInjection/FEAR-Mouse-',num2str(MiceNumber(MatNum(1,i))),'-12062018-Hab_00'])
cd(['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/MethimazoleBehaviourExperiment/4DqysPost/FEAR-Mouse-',num2str(MiceNumber(MatNum(1,i))),'-16062018-Hab_00'])

try
    subplot(2,5,i)
load('ManualTemp.mat')
plot(Temp_time,naninterp(Temp_body_InDegrees))
hold on
plot(Temp_time,naninterp(Temp_eye_InDegrees))
plot(Temp_time,naninterp(Temp_tail_InDegrees))
ylim([24 37])
ylabel('temperature (°C)')
xlabel('time (s)')
end

Temp_body_sal(i,:) = interp1(Temp_time,naninterp(Temp_body_InDegrees),[5:10:895]);
Temp_tail_sal(i,:) = interp1(Temp_time,naninterp(Temp_tail_InDegrees),[5:10:895]);
Temp_eye_sal(i,:) = interp1(Temp_time,naninterp(Temp_eye_InDegrees),[5:10:895]);


end


for i = 1:5
%cd(['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/MethimazoleBehaviourExperiment/BeforeInjection/FEAR-Mouse-',num2str(MiceNumber(MatNum(2,i))),'-12062018-Hab_00'])
cd(['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/MethimazoleBehaviourExperiment/4DqysPost/FEAR-Mouse-',num2str(MiceNumber(MatNum(2,i))),'-16062018-Hab_00'])

try
        subplot(2,5,i+5)

load('ManualTemp.mat')
plot(Temp_time,naninterp(Temp_body_InDegrees))
hold on
plot(Temp_time,naninterp(Temp_eye_InDegrees))
plot(Temp_time,naninterp(Temp_tail_InDegrees))
ylim([24 37])
ylabel('temperature (°C)')
xlabel('time (s)')
end
Temp_body_mtzl(i,:) = interp1(Temp_time,naninterp(Temp_body_InDegrees),[5:10:895]);
Temp_tail_mtzl(i,:) = interp1(Temp_time,naninterp(Temp_tail_InDegrees),[5:10:895]);
Temp_eye_mtzl(i,:) = interp1(Temp_time,naninterp(Temp_eye_InDegrees),[5:10:895]);

end

% Mean temperature for body, eyes and tail over time
figure
subplot(3,1,1)
errorbar([5:10:895],nanmean(Temp_body_sal),stdError(Temp_body_sal),'k')
hold on
errorbar([5:10:895],nanmean(Temp_body_mtzl),stdError(Temp_body_mtzl),'r')
ylim([23 36])
title('Body temperature')
ylabel('T (°C)')
% xlabel('Time (s)')
legend('sal', 'mtzl')
subplot(3,1,2)
errorbar([5:10:895],nanmean(Temp_eye_sal),stdError(Temp_eye_sal),'k')
hold on
errorbar([5:10:895],nanmean(Temp_eye_mtzl),stdError(Temp_eye_mtzl),'r')
ylim([23 36])
title('Eyes temperature')
ylabel('T (°C)')
% xlabel('Time (s)')
subplot(3,1,3)
errorbar([5:10:895],nanmean(Temp_tail_sal),stdError(Temp_tail_sal),'k')
hold on
errorbar([5:10:895],nanmean(Temp_tail_mtzl),stdError(Temp_tail_mtzl),'r')
ylim([23 36])
title('Tail temperature')
ylabel('T (°C)')
xlabel('Time (s)')

% Mean temp for body, eye and tail
figure
subplot(1,3,1)
PlotErrorBarN_KJ([nanmean(Temp_body_sal(:,:)');nanmean(Temp_body_mtzl(:,:)')]','newfig',0,'paired',0)
title('Body')
ylabel('Temperature (°C)')
xtickangle(45)
xticks(1:2)
xticklabels({'saline','methimazole'});
subplot(1,3,2)
PlotErrorBarN_KJ([nanmean(Temp_eye_sal(:,:)');nanmean(Temp_eye_mtzl(:,:)')]','newfig',0,'paired',0)
title('Eyes')
ylabel('Temperature (°C)')
xtickangle(45)
xticks(1:2)
xticklabels({'saline','methimazole'});
subplot(1,3,3)
PlotErrorBarN_KJ([nanmean(Temp_tail_sal(:,:)');nanmean(Temp_tail_mtzl(:,:)')]','newfig',0,'paired',0)
title('Tail')
ylabel('Temperature (°C)')
xtickangle(45)
xticks(1:2)
xticklabels({'saline','methimazole'});

% Mean temp for body, eye and tail 0-200s and 200-900s
figure
subplot(3,2,1)
PlotErrorBarN_KJ([nanmean(Temp_body_sal(:,1:20)');nanmean(Temp_body_mtzl(:,1:20)')]','newfig',0,'paired',0)
subplot(3,2,2)
PlotErrorBarN_KJ([nanmean(Temp_body_sal(:,20:end)');nanmean(Temp_body_mtzl(:,20:end)')]','newfig',0,'paired',0)

subplot(3,2,3)
PlotErrorBarN_KJ([nanmean(Temp_eye_sal(:,1:20)');nanmean(Temp_eye_mtzl(:,1:20)')]','newfig',0,'paired',0)
subplot(3,2,4)
PlotErrorBarN_KJ([nanmean(Temp_eye_sal(:,20:end)');nanmean(Temp_eye_mtzl(:,20:end)')]','newfig',0,'paired',0)

subplot(3,2,5)
PlotErrorBarN_KJ([nanmean(Temp_tail_sal(:,1:20)');nanmean(Temp_tail_mtzl(:,1:20)')]','newfig',0,'paired',0)
subplot(3,2,6)
PlotErrorBarN_KJ([nanmean(Temp_tail_sal(:,20:end)');nanmean(Temp_tail_mtzl(:,20:end)')]','newfig',0,'paired',0)


% boxplot temperature
figure
x = [nanmean(Temp_tail_sal(:,1:20)'); nanmean(Temp_tail_mtzl(:,1:20)'); nanmean(Temp_tail_sal(:,20:end)'); nanmean(Temp_tail_mtzl(:,20:end)')];
group = [1,1,2,2];
positions = [1 1.25 2 2.25];

boxplot(x','ColorGroup',[1,2,1,2],'color',[0 0 0;1 0 0]), hold on
set(gca, 'XTick', [1.5 3.5])
set(gca, 'XTickLabels', {'0-200s', '200-900s'})
clear p
[p(1),h]=ranksum(nanmean(Temp_tail_sal(:,1:20)), nanmean(Temp_tail_mtzl(:,1:20)));
[p(2),h]=ranksum(nanmean(Temp_tail_sal(:,20:end)), nanmean(Temp_tail_mtzl(:,20:end)));
sigstar({[1,2],[3,4]},p)
plot(1,x(1,:),'k.','MarkerSize',30)
plot(2,x(2,:),'k.','MarkerSize',30)
plot(3,x(3,:),'k.','MarkerSize',30)
plot(4,x(4,:),'k.','MarkerSize',30)
ylabel('Temperature (°C)')



