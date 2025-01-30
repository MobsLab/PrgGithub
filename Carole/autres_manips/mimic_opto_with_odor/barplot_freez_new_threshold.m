% mouvement pendant les cs en fonctions des conditions, souris par souris
%869
clear all
close all
Mice=[862 864 866 870 878 863 865 867 871 879];
th=[10 10 10 20 10 10 10 10 20 10];

%% determiner le threshold de freezing
% 
% mouse_num=Mice(10);
% path=strcat('/media/mobschapeau/09E7077B1FE07CCB/manip_mimic_opto/', num2str(mouse_num), '/ext');
% cd(path);
% load('behavResources.mat');
% load('TTLInfo.mat');
% 
% % plot(Range(Imdifftsd,'s'),Data(Imdifftsd))
% hist(Data(Imdifftsd),[0:50])
% 

%% gros hist
% 
% mouse_num=Mice(10);
% path=strcat('/media/mobschapeau/09E7077B1FE07CCB/manip_mimic_opto/', num2str(mouse_num), '/ext');
% cd(path);
% load('behavResources.mat');
% 
% 
% 
% hist([Data(Im1); Data(Im2); Data(Im3); Data(Im4); Data(Im5); Data(Im6); Data(Im7); Data(Im8); Data(Im9); Data(Im10)],[0:50]);
% 

%%

% mouse_num=Mice(10);
% path=strcat('/media/mobschapeau/09E7077B1FE07CCB/manip_mimic_opto/', num2str(mouse_num), '/ext');
% cd(path);
% load('behavResources.mat');
% load('TTLInfo.mat');
% FreezeEpoch=thresholdIntervals(Imdifftsd,10,'Direction','Below');
% FreezeEpoch=mergeCloseIntervals(FreezeEpoch,0.4*1E4);
% FreezeEpoch=dropShortIntervals(FreezeEpoch,thtps_immob*1E4);
% 
% Freezets = Range(Restrict(Imdifftsd,FreezeEpoch));
% %[Y,X]=hist(Freezets/1e4,500);
% subplot(2,1,1);
% plot(Range(Imdifftsd,'s'),Data(Imdifftsd))
% ylim([0,600])
% xlim([0, 800])
% subplot(2,1,2);
% hist(Freezets/1e4,[0:800]);
% xlim([0, 800])
% %Freeingtsd = tsd(X*1e4,Y');

%% toutes les souris
Mat=zeros(length(Mice),4);

supertit = 'Proportion of freezing';
figure('Color',[1 1 1], 'rend','painters','pos',[10 10 1400 700],'Name',supertit, 'NumberTitle','off')
    si = 0;
    
for i=1:length(Mice)
    mouse_num=Mice(i);
    path=strcat('/media/mobschapeau/09E7077B1FE07CCB/manip_mimic_opto/', num2str(mouse_num), '/ext');
    cd(path);
    load('behavResources.mat');
    load('TTLInfo.mat');
    %SmooVtsd = tsd(Range(Vtsd),runmean(Data(Vtsd),5));

    %Freezets = Range(Restrict(Imdifftsd,FreezeEpoch));
    %[Y,X]=hist(Freezets/1e4,500);
    %Freeingtsd = tsd(X*1e4,Y');
    FreezeEpoch=thresholdIntervals(Imdifftsd,th(i),'Direction','Below');
    FreezeEpoch=mergeCloseIntervals(FreezeEpoch,0.4*1E4);
    FreezeEpoch=dropShortIntervals(FreezeEpoch,thtps_immob*1E4);
    
    % percentage of freezing during baseline
    BaselineEpoch=intervalSet(0*1e4, 120*1e4);
    Ep = and(BaselineEpoch,FreezeEpoch);
    percent=(sum(Stop(Ep)-Start(Ep)))/(sum(Stop(BaselineEpoch)-Start(BaselineEpoch)));
    Mat(i,1)=percent;
    
    % percentage of freezing during cs-
    CSMoinsEpoch=intervalSet(TTLInfo.CSMoinsTimes, TTLInfo.CSMoinsTimes+60*1e4);
    Ep = and(CSMoinsEpoch,FreezeEpoch);
    percent=(sum(Stop(Ep)-Start(Ep)))/(sum(Stop(CSMoinsEpoch)-Start(CSMoinsEpoch)));
    Mat(i,2)=percent;
    
    % percentage of freezing during first 2 cs+
    CSPlusEpoch=intervalSet(TTLInfo.CSPlusTimes(1:2), TTLInfo.CSPlusTimes(1:2)+60*1e4);
    Ep = and(CSPlusEpoch,FreezeEpoch);
    percent=(sum(Stop(Ep)-Start(Ep)))/(sum(Stop(CSPlusEpoch)-Start(CSPlusEpoch)));
    Mat(i,3)=percent;
    
     % percentage of freezing during last 2 cs+
    CSPlusEpoch=intervalSet(TTLInfo.CSPlusTimes(3:4), TTLInfo.CSPlusTimes(3:4)+60*1e4);
    Ep = and(CSPlusEpoch,FreezeEpoch);
    percent=(sum(Stop(Ep)-Start(Ep)))/(sum(Stop(CSPlusEpoch)-Start(CSPlusEpoch)));
    Mat(i,4)=percent;
    
    
end
subplot(1,2,1);
PlotErrorBar_mov_odor_CS(Mat(1:5,:), 'newfig', 0);
set(gca,'xticklabel',{'','baseline','CS-','first 2 CS+','last 2 CS+',''});
title('Clean air')
%leue:862
%noir:864
%rouge:866
%vert:870
%jaune:878
Colors='bkrgycm';
subplot(1,2,2);
PlotErrorBar_mov_odor_CS(Mat(6:10,:), 'newfig', 0);
set(gca,'xticklabel',{'','baseline','CS-','first 2 CS+','last 2 CS+',''});
title('Odor')
%leue:863
%noir:865
%rouge:867
%vert:871
%jaune:879


mtit(supertit, 'fontsize',14, 'xoff', 0, 'yoff', 0.03);
