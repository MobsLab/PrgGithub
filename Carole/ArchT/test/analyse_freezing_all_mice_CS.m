clear all
Mice_arch=[915,916,917,918];
Mice_cherry=[919,920];


Mat_percent_freeze_arch=zeros(length(Mice_arch),8);
Mat_percent_freeze_cherry=zeros(length(Mice_cherry),8);

%%

Mat_mean_freeze_duration_arch=zeros(length(Mice_arch),5);
Mat_mean_freeze_duration_cherry=zeros(length(Mice_cherry),5);
%
Mat_mean_active_duration_arch=zeros(length(Mice_arch),5);
Mat_mean_active_duration_cherry=zeros(length(Mice_cherry),5);
% 
Mat_freeze_number_arch=zeros(length(Mice_arch),5);
Mat_freeze_number_cherry=zeros(length(Mice_cherry),5);

%% matrices arch

for i=1:length(Mice_arch)
    mouse_num=Mice_arch(i);
    path=strcat('/media/gruffalo/09E7077B1FE07CCB/ARCHT/ArchT/', num2str(mouse_num), '/test');
    cd(path)
    load('ExpeInfo.mat');
    load('behavResources.mat');
    load('Epoch.mat');
    
    %during cs-
    Ep = and(Epoch.CSMoins,Epoch.FreezeAcc);
    %percent
    percent=(sum(Stop(Ep)-Start(Ep)))/(sum(Stop(Epoch.CSMoins)-Start(Epoch.CSMoins)));
    Mat_percent_freeze_arch(i,1)=NaN;
    Mat_percent_freeze_arch(i,2)=percent;
    Mat_percent_freeze_arch(i,3)=NaN;

    
    % during first 2 cs+
    Ep = and(Epoch.CSPlus_12,Epoch.FreezeAcc);
    %percent
    percent=(sum(Stop(Ep)-Start(Ep)))/(sum(Stop(Epoch.CSPlus_12)-Start(Epoch.CSPlus_12)));
    Mat_percent_freeze_arch(i,4)=NaN;
    Mat_percent_freeze_arch(i,5)=percent;
    Mat_percent_freeze_arch(i,6)=NaN;
    %mean_fz_duration
    mean_fz_duration=(sum(Stop(Ep)-Start(Ep)))/(length(Start(Ep)));
    if isnan(mean_fz_duration)
        mean_fz_duration=0
    end
    Mat_mean_freeze_duration_arch(i,1)=NaN;
    Mat_mean_freeze_duration_arch(i,2)=mean_fz_duration;
    Mat_mean_freeze_duration_arch(i,3)=NaN;
    %nb_fz_bouts
    number=length(Start(Ep))/2;
    Mat_freeze_number_arch(i,1)=NaN;
    Mat_freeze_number_arch(i,2)=number;
    Mat_freeze_number_arch(i,3)=NaN;
    %mean_active_duration
    Ep = and(Epoch.CSPlus_12,Epoch.Non_FreezeAcc);
    mean_act_duration=(sum(Stop(Ep)-Start(Ep)))/(length(Start(Ep)));
    if isnan(mean_act_duration)
        mean_act_duration=0
    end
    Mat_mean_active_duration_arch(i,1)=NaN;
    Mat_mean_active_duration_arch(i,2)=mean_act_duration;
    Mat_mean_active_duration_arch(i,3)=NaN;  
    
    
    
    % during 2nd cs+
    Ep = and(Epoch.CSPlus_34,Epoch.FreezeAcc);
    %percentage
    percent=(sum(Stop(Ep)-Start(Ep)))/(sum(Stop(Epoch.CSPlus_34)-Start(Epoch.CSPlus_34)));
    Mat_percent_freeze_arch(i,7)=NaN;
    Mat_percent_freeze_arch(i,8)=percent;
    %mean_fz_duration
    mean_fz_duration=(sum(Stop(Ep)-Start(Ep)))/(length(Start(Ep)));
    if isnan(mean_fz_duration)
        mean_fz_duration=0
    end
    Mat_mean_freeze_duration_arch(i,4)=NaN;
    Mat_mean_freeze_duration_arch(i,5)=mean_fz_duration;
    %nb_fz_bouts
    number=length(Start(Ep))/2;
    Mat_freeze_number_arch(i,4)=NaN;
    Mat_freeze_number_arch(i,5)=number;
    %mean_active_duration
    Ep = and(Epoch.CSPlus_34,Epoch.Non_FreezeAcc);
    mean_act_duration=(sum(Stop(Ep)-Start(Ep)))/(length(Start(Ep)));
    if isnan(mean_act_duration)
        mean_act_duration=0
    end
    Mat_mean_active_duration_arch(i,4)=NaN;
    Mat_mean_active_duration_arch(i,5)=mean_act_duration;
   
end

%% matrice mcherry

for i=1:length(Mice_cherry)
    mouse_num=Mice_cherry(i);
    path=strcat('/media/gruffalo/09E7077B1FE07CCB/ARCHT/ArchT/', num2str(mouse_num), '/test');
    cd(path)
    load('ExpeInfo.mat');
    load('behavResources.mat');
    load('Epoch.mat');
    
    %during cs-
    Ep = and(Epoch.CSMoins,Epoch.FreezeAcc);
    %percentage
    percent=(sum(Stop(Ep)-Start(Ep)))/(sum(Stop(Epoch.CSMoins)-Start(Epoch.CSMoins)));
    Mat_percent_freeze_cherry(i,1)=percent;
    Mat_percent_freeze_cherry(i,2)=NaN;
    Mat_percent_freeze_cherry(i,3)=NaN;
    
    % during first 2 cs+
    Ep = and(Epoch.CSPlus_12,Epoch.FreezeAcc);
    %percentage
    percent=(sum(Stop(Ep)-Start(Ep)))/(sum(Stop(Epoch.CSPlus_12)-Start(Epoch.CSPlus_12)));
    Mat_percent_freeze_cherry(i,4)=percent;
    Mat_percent_freeze_cherry(i,5)=NaN;
    Mat_percent_freeze_cherry(i,6)=NaN;
    %mean_fz_duration
    mean_fz_duration=(sum(Stop(Ep)-Start(Ep)))/(length(Start(Ep)));
    if isnan(mean_fz_duration)
        mean_fz_duration=0
    end
    Mat_mean_freeze_duration_cherry(i,1)=mean_fz_duration;
    Mat_mean_freeze_duration_cherry(i,2)=NaN;
    Mat_mean_freeze_duration_cherry(i,3)=NaN;
    %number_fz_bout
    number=length(Start(Ep))/2;
    Mat_freeze_number_cherry(i,1)=number;
    Mat_freeze_number_cherry(i,2)=NaN;
    Mat_freeze_number_cherry(i,3)=NaN;
    %mean_active_duration
    Ep = and(Epoch.CSPlus_12,Epoch.Non_FreezeAcc);
    mean_act_duration=(sum(Stop(Ep)-Start(Ep)))/(length(Start(Ep)));
    if isnan(mean_act_duration)
        mean_act_duration=0
    end
    Mat_mean_active_duration_cherry(i,1)=mean_act_duration;
    Mat_mean_active_duration_cherry(i,2)=NaN;
    Mat_mean_active_duration_cherry(i,3)=NaN;  
    
    % during 2nd cs+
    Ep = and(Epoch.CSPlus_34,Epoch.FreezeAcc);
    %percentage
    percent=(sum(Stop(Ep)-Start(Ep)))/(sum(Stop(Epoch.CSPlus_34)-Start(Epoch.CSPlus_34)));
    Mat_percent_freeze_cherry(i,7)=percent;
    Mat_percent_freeze_cherry(i,8)=NaN;
    %mean_fz_duration
    mean_fz_duration=(sum(Stop(Ep)-Start(Ep)))/(length(Start(Ep)));
    if isnan(mean_fz_duration)
        mean_fz_duration=0
    end
    Mat_mean_freeze_duration_cherry(i,4)=mean_fz_duration;
    Mat_mean_freeze_duration_cherry(i,5)=NaN;
    %nb_fz_bouts
    number=length(Start(Ep))/2;
    Mat_freeze_number_cherry(i,4)=number;
    Mat_freeze_number_cherry(i,5)=NaN;
    %mean_active_duration
    Ep = and(Epoch.CSPlus_34,Epoch.Non_FreezeAcc);
    mean_act_duration=(sum(Stop(Ep)-Start(Ep)))/(length(Start(Ep)));
    if isnan(mean_act_duration)
        mean_act_duration=0
    end
    Mat_mean_active_duration_cherry(i,4)=mean_act_duration;
    Mat_mean_active_duration_cherry(i,5)=NaN;  
   
end
%% percentage of freezing
figure
line([-1 0],[-1 0],'color',[1,0,0],'linewidth',4);
hold on
line([-1 0],[-1 0],'color',[0,0,1],'linewidth',4);
hold on
line([-1 0],[-1 0],'color','k','linewidth',4)
hold on
line([-1 0],[-1 0],'color','c','linewidth',4)
hold on
line([-1 0],[-1 0],'color','m','linewidth',4)
hold on
line([-1 0],[-1 0],'color','y','linewidth',4)
hold on

PlotErrorBar_color_points_CS(Mat_percent_freeze_arch, 'newfig', 0,'barcolors',[1 0 0],'pointscolors','kcmykw');
hold on
PlotErrorBar_color_points_CS(Mat_percent_freeze_cherry, 'newfig', 0,'barcolors',[0 0 1],'pointscolors','kcmykw');
set(gca,'xticklabel',{'','CS-','','','CS+1/2','(laserOFF)','','CS+3/4','(laserON)','','','',''});
xlim([0 9])
legend('ArchT','mCherry','915/919','916/920','917','918','Location','northwest');
title('% of freezing');

%
%% mean duration
figure
subplot(1,2,1)
line([-1 0],[-1 0],'color',[1,0,0],'linewidth',4);
hold on
line([-1 0],[-1 0],'color',[0,0,1],'linewidth',4);
hold on
line([-1 0],[-1 0],'color','k','linewidth',4)
hold on
line([-1 0],[-1 0],'color','c','linewidth',4)
hold on
line([-1 0],[-1 0],'color','m','linewidth',4)
hold on
line([-1 0],[-1 0],'color','y','linewidth',4)
hold on
PlotErrorBar_color_points_CS(Mat_mean_freeze_duration_arch, 'newfig', 0,'barcolors',[1 0 0],'pointscolors','kcmykw');
hold on
PlotErrorBar_color_points_CS(Mat_mean_freeze_duration_cherry, 'newfig', 0,'barcolors',[0 0 1],'pointscolors','kcmykw');
set(gca,'xticklabel',{'','CS+1/2','(laserOFF)','','CS+3/4','(laserON)','',''});
title('mean freeze duration');
legend('ArchT','mCherry','915/919','916/920','917','918','Location','northwest');
xlim([0 6]);
subplot(1,2,2)
line([-1 0],[-1 0],'color',[1,0,0],'linewidth',4);
hold on
line([-1 0],[-1 0],'color',[0,0,1],'linewidth',4);
hold on
line([-1 0],[-1 0],'color','k','linewidth',4)
hold on
line([-1 0],[-1 0],'color','c','linewidth',4)
hold on
line([-1 0],[-1 0],'color','m','linewidth',4)
hold on
line([-1 0],[-1 0],'color','y','linewidth',4)
hold on
PlotErrorBar_color_points_CS(Mat_mean_active_duration_arch, 'newfig', 0,'barcolors',[1 0 0],'pointscolors','kcmykw');
hold on
PlotErrorBar_color_points_CS(Mat_mean_active_duration_cherry, 'newfig', 0,'barcolors',[0 0 1],'pointscolors','kcmykw');
set(gca,'xticklabel',{'','CS+1/2','(laserOFF)','','CS+3/4','(laserON)','',''});
legend('ArchT','mCherry','915/919','916/920','917','918');
xlim([0 6]);
title('mean active duration');

%% mean freezing period number (on 1 cs)
figure
line([-1 0],[-1 0],'color',[1,0,0],'linewidth',4);
hold on
line([-1 0],[-1 0],'color',[0,0,1],'linewidth',4);
hold on
line([-1 0],[-1 0],'color','k','linewidth',4)
hold on
line([-1 0],[-1 0],'color','c','linewidth',4)
hold on
line([-1 0],[-1 0],'color','m','linewidth',4)
hold on
line([-1 0],[-1 0],'color','y','linewidth',4)
hold on
PlotErrorBar_color_points_CS(Mat_freeze_number_arch, 'newfig', 0,'barcolors',[1 0 0],'pointscolors','kcmykw');
hold on
PlotErrorBar_color_points_CS(Mat_freeze_number_cherry, 'newfig', 0,'barcolors',[0 0 1],'pointscolors','kcmykw');
set(gca,'xticklabel',{'','CS+1/2','(laserOFF)','','CS+3/4','(laserON)','',''});
legend('ArchT','mCherry','915/919','916/920','917','918','Location','northwest');
xlim([0 6]);
ylim([0 3]);
title('mean nb of fz episode/CS');




