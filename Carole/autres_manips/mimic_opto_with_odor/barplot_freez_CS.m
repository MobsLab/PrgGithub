% mouvement pendant les cs en fonctions des conditions, souris par souris
%869
clear all
close all
Mice=[862 864 866 870 878 863 865 867 871 879];


%% clean air
Mat=zeros(length(Mice),3);
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
    CSPlusEpoch=intervalSet(TTLInfo.CSPlusTimes, TTLInfo.CSPlusTimes+30*1e4);
    Ep = and(CSPlusEpoch,FreezeEpoch);
    percent=(sum(Stop(Ep)-Start(Ep)))/(sum(Stop(CSPlusEpoch)-Start(CSPlusEpoch)));
    Mat(i,3)=percent;
    
end

PlotErrorBarN_KJ(Mat);
set(gca,'xticklabel',{'','','baseline','','CS-','','CS+','',''});


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

