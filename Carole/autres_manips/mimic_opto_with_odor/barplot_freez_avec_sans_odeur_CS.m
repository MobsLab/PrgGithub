% mouvement pendant les cs en fonctions des conditions, souris par souris
%869
clear all
close all
Mice=[862 864 866 870 878 863 865 867 871 879];

Mat=zeros(length(Mice),4);

%% clean air
supertit = 'Percentage of freezing';
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
    
    
    % percentage of freezing during baseline
    BaselineEpoch=intervalSet(0*1e4, 100*1e4);
    Ep = and(BaselineEpoch,FreezeEpoch);
    percent=(sum(Stop(Ep)-Start(Ep)))/(sum(Stop(BaselineEpoch)-Start(BaselineEpoch)));
    Mat(i,1)=percent;
    
    % percentage of freezing during cs-
    CSMoinsEpoch=intervalSet(TTLInfo.CSMoinsTimes, TTLInfo.CSMoinsTimes+30*1e4);
    Ep = and(CSMoinsEpoch,FreezeEpoch);
    percent=(sum(Stop(Ep)-Start(Ep)))/(sum(Stop(CSMoinsEpoch)-Start(CSMoinsEpoch)));
    Mat(i,2)=percent;
    
    % percentage of freezing during first 2 cs+
    CSPlusEpoch=intervalSet(TTLInfo.CSPlusTimes(1:2), TTLInfo.CSPlusTimes(1:2)+30*1e4);
    Ep = and(CSPlusEpoch,FreezeEpoch);
    percent=(sum(Stop(Ep)-Start(Ep)))/(sum(Stop(CSPlusEpoch)-Start(CSPlusEpoch)));
    Mat(i,3)=percent;
    
     % percentage of freezing during last 2 cs+
    CSPlusEpoch=intervalSet(TTLInfo.CSPlusTimes(3:4), TTLInfo.CSPlusTimes(3:4)+30*1e4);
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


% %% odor
% 
% for i=1:length(Mice_odor)
%     mouse_num=Mice_odor(i);
%     mouse_col=colors(i);
%     path=strcat('/media/mobschapeau/09E7077B1FE07CCB/manip_mimic_opto/', num2str(mouse_num), '/ext');
%     cd(path);
%     load('behavResources.mat');
%     load('TTLInfo.mat');
%         Freezets = Range(Restrict(Imdifftsd,FreezeEpoch));
%     [Y,X]=hist(Freezets/1e4,500);
%     Freeingtsd = tsd(X*1e4,Y');
% 
%     %SmooVtsd = tsd(Range(Vtsd),runmean(Data(Vtsd),5));
%     % CSMoins
%     subplot(3,2,2);
%     [M,T]=PlotRipRaw(Freeingtsd,TTLInfo.CSMoinsTimes'/1e4,30000,0,0);
%     plot(M(:,1),M(:,2)', 'color', mouse_col);
%     hold on
%     % CSPlus sans air
%     subplot(3,2,4);
%     [M,T]=PlotRipRaw(Freeingtsd,TTLInfo.CSPlusTimes(1:2)'/1e4,30000,0,0);
%     M(:,2)  = T(1,:)';
%     plot(M(:,1),M(:,2)', 'color', mouse_col);
%     hold on
%     % CSPlus avec air
%     subplot(3,2,6);
%     [M,T]=PlotRipRaw(Freeingtsd,TTLInfo.CSPlusTimes(3:4)'/1e4,30000,0,0);
%     M(:,2)  = T(1,:)';
%     plot(M(:,1),M(:,2)', 'color', mouse_col);
%     hold on    
% end

