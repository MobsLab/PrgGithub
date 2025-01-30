clear all
Mice=[915,916,917,919,920];
type=[{'ArchT'},{'ArchT'},{'ArchT'},{'mCherry'},{'mCherry'}];

Mat_percent_freeze=zeros(length(Mice),3);

Mat_mean_freeze_duration=zeros(length(Mice),2);
Mat_mean_active_duration=zeros(length(Mice),2);

Mat_freeze_number=zeros(length(Mice),2);


for i=1:length(Mice)
    mouse_num=Mice(i);
    path=strcat('/media/gruffalo/09E7077B1FE07CCB/ARCHT/ArchT/', num2str(mouse_num), '/test');
    cd(path)
    load('ExpeInfo.mat');
    load('behavResources.mat');
    load('Epoch.mat');
    
    %during cs-
    Ep = and(Epoch.CSMoins,Epoch.FreezeAcc);
    percent=(sum(Stop(Ep)-Start(Ep)))/(sum(Stop(Epoch.CSMoins)-Start(Epoch.CSMoins)));
    Mat_percent_freeze(i,1)=percent;
    
    % during first 2 cs+
    Ep = and(Epoch.CSPlus_12,Epoch.FreezeAcc);
    percent=(sum(Stop(Ep)-Start(Ep)))/(sum(Stop(Epoch.CSPlus_12)-Start(Epoch.CSPlus_12)));
    Mat_percent_freeze(i,2)=percent;
    mean_duration=(sum(Stop(Ep)-Start(Ep)))/(length(Start(Ep)));
    if isnan(mean_duration)
        mean_duration=0
    end
    Mat_mean_freeze_duration(i,1)=mean_duration;
    number=length(Start(Ep))/2;
    Mat_freeze_number(i,1)=number;
    
    Ep = and(Epoch.CSPlus_12,Epoch.Non_FreezeAcc);
    mean_duration=(sum(Stop(Ep)-Start(Ep)))/(length(Start(Ep)));
    if isnan(mean_duration)
        mean_duration=0
    end
    Mat_mean_active_duration(i,1)=mean_duration;
    
    % during 2nd cs+
    Ep = and(Epoch.CSPlus_34,Epoch.FreezeAcc);
    percent=(sum(Stop(Ep)-Start(Ep)))/(sum(Stop(Epoch.CSPlus_34)-Start(Epoch.CSPlus_34)));
    Mat_percent_freeze(i,3)=percent;
    mean_duration=(sum(Stop(Ep)-Start(Ep)))/(length(Start(Ep)));
    if isnan(mean_duration)
        mean_duration=0
    end
    Mat_mean_freeze_duration(i,2)=mean_duration;
    number=length(Start(Ep))/2;
    Mat_freeze_number(i,2)=number;
    
    Ep = and(Epoch.CSPlus_34,Epoch.Non_FreezeAcc);
    mean_duration=(sum(Stop(Ep)-Start(Ep)))/(length(Start(Ep)));
    if isnan(mean_duration)
        mean_duration=0
    end
    Mat_mean_active_duration(i,2)=mean_duration;
    
    
    
end
%% percentage of freezing
figure
subplot(1,3,1)
line([-1 0],[-1 0],'color','r','linewidth',4)
hold on
line([-1 0],[-1 0],'color','b','linewidth',4)
hold on
line([-1 0],[-1 0],'color','c','linewidth',4)
hold on
line([-1 0],[-1 0],'color','y','linewidth',4)
hold on
PlotErrorBar_color_points_CS(Mat_percent_freeze(1:3,:)*100, 'newfig', 0, 'pointscolors','rbcy', 'optiontest','ttest');
title('ArchT');
xticklabels({'CS-','CS+ 1&2','CS+ 3&4'})
xticks([1:3])
xlim([0 4])
ylabel('% of freezing')
legend('M915','M916','M917', 'Location', 'northwest')
subplot(1,3,2)

PlotErrorBarN_KJ(Mat_percent_freeze(4:5,:)*100, 'newfig', 0, 'optiontest','ttest');
title('mCherry');
xticklabels({'CS-','CS+ 1&2','CS+ 3&4'})
xticks([1:3])
ylabel('% of freezing')

% %% augmentation
% 
% AUG=NaN(length(Mice),2);
% for i=1:length(Mice)
%     AUG(i,1)=0
%     AUG(i,2)=((Mat_percent_freeze(i,3)-Mat_percent_freeze(i,2))/Mat_percent_freeze(i,2))
% end
% 
% %subplot(1,3,3)
% figure
% col='rbc'
% 
% 
% plot([1,2],AUG(2,:)*100,'Color','k','LineWidth',1,'Marker','o','MarkerFaceColor',col(2), 'MarkerEdgeColor','k')
% hold on
% plot([1,2],AUG(3,:)*100,'Color','k','LineWidth',1,'Marker','o','MarkerFaceColor',col(3), 'MarkerEdgeColor','k')
% hold on
% plot([1,2],AUG(1,:)*100,'Color','k','LineWidth',1,'Marker','o','MarkerFaceColor',col(1), 'MarkerEdgeColor','k')
% hold on
% 
% plot([1],0*100,'Color','k','LineWidth',1,'Marker','o','MarkerFaceColor','k', 'MarkerEdgeColor','k')
% 
% legend('M916','M917','M915','Location','NorthWest')
% ylabel('% of increase')
% xlim([0.5,2.5])
% xticklabels({'CS+ 1&2','CS+ 3&4'})
% xticks([1:2])

%%



% %% mean freezing duration
% figure
% subplot(1,2,1)
% line([-1 0],[-1 0],'color','r','linewidth',4)
% hold on
% line([-1 0],[-1 0],'color','b','linewidth',4)
% hold on
% line([-1 0],[-1 0],'color','c','linewidth',4)
% hold on
% line([-1 0],[-1 0],'color','y','linewidth',4)
% hold on
% PlotErrorBar_color_points_CS(Mat_mean_freeze_duration(1:3,:)*1e-4, 'newfig', 0, 'pointscolors','rbcy');
% title('ArchT');
% xticklabels({'CS+ 1&2','CS+ 3&4'})
% xticks([1:2])
% legend('M915','M916','M917','M918')
% xlim([0 3])
% ylabel('mean freezing episode duration (s)')
% subplot(1,2,2)
% PlotErrorBarN_KJ(Mat_mean_freeze_duration(5:6,:)*1e-4, 'newfig', 0);
% title('mCherry');
% xticklabels({'CS+ 1&2','CS+ 3&4'})
% xticks([1:2])
% ylabel('mean freezing episode duration (s)')
% 
% %% mean active duration
% figure
% subplot(1,2,1)
% line([-1 0],[-1 0],'color','r','linewidth',4)
% hold on
% line([-1 0],[-1 0],'color','b','linewidth',4)
% hold on
% line([-1 0],[-1 0],'color','c','linewidth',4)
% hold on
% line([-1 0],[-1 0],'color','y','linewidth',4)
% hold on
% % , 'pointscolors','rbcy'
% PlotErrorBar_color_points_CS(Mat_mean_active_duration(1:4,:)*1e-4, 'newfig', 0, 'pointscolors','rbcy');
% title('ArchT');
% xticklabels({'CS+ 1&2','CS+ 3&4'})
% xticks([1:2])
% legend('M915','M916','M917','M918')
% xlim([0 3])
% ylim([0 12])
% ylabel('mean active episode duration (s)')
% subplot(1,2,2)
% PlotErrorBarN_KJ(Mat_mean_active_duration(5:6,:)*1e-4, 'newfig', 0);
% title('mCherry');
% xticklabels({'CS+ 1&2','CS+ 3&4'})
% xticks([1:2])
% ylim([0 12])
% ylabel('mean active episode duration (s)')
% 
% 
% 
% 
% 
% %% mean freezing period number (on 1 cs)
% figure
% subplot(1,2,1)
% PlotErrorBarN_KJ(Mat_freeze_number(1:4,:), 'newfig', 0);
% set(gca,'xticklabel',{'','CS-','CS+ 1-2','CS+ 3-4',''});
% title('mean number of freeze episode per CS ArchT');
% subplot(1,2,2)
% PlotErrorBarN_KJ(Mat_freeze_number(5:6,:), 'newfig', 0);
% set(gca,'xticklabel',{'','CS-','CS+ 1-2','CS+ 3-4',''});
% title('mean number of freeze episode per CS  mCherry');
% 
% 
% 
