% mouvement pendant les cs en fonctions des conditions, souris par souris
%869
clear all
close all
Mice_cleanair=[862 864 866 870 878];
Mice_odor=[863 865 867 871 879];
colors='bkrgycmw';

%% clean air

for i=1:length(Mice_cleanair)
    mouse_num=Mice_cleanair(i);
    mouse_col=colors(i);
    path=strcat('/media/mobschapeau/09E7077B1FE07CCB/manip_mimic_opto/', num2str(mouse_num), '/ext');
    cd(path);
    load('behavResources.mat');
    load('TTLInfo.mat');
    %SmooVtsd = tsd(Range(Vtsd),runmean(Data(Vtsd),5));
    % CSMoins
    subplot(3,2,1);
    [M,T]=PlotRipRaw(Imdifftsd,TTLInfo.CSMoinsTimes'/1e4,30000,0,0);
    plot(M(:,1),M(:,2)', 'color', mouse_col);
    hold on
    % CSPlus sans air
    subplot(3,2,3);
    [M,T]=PlotRipRaw(Imdifftsd,TTLInfo.CSPlusTimes(1:2)'/1e4,30000,0,0);
    M(:,2)  = T(1,:)';
    plot(M(:,1),M(:,2)', 'color', mouse_col);
    hold on
    % CSPlus avec air
    subplot(3,2,5);
    [M,T]=PlotRipRaw(Imdifftsd,TTLInfo.CSPlusTimes(3:4)'/1e4,30000,0,0);
    M(:,2)  = T(1,:)';
    plot(M(:,1),M(:,2)', 'color', mouse_col);
    hold on    
end

subplot(3,2,1);
title('clean air, CS-');
vline(0);
subplot(3,2,3);
title('clean air, CS+ 1 and 2');
vline(0);
subplot(3,2,5);
title('clean air, CS+ 3 and 4');
vline(0);
%% odor

for i=1:length(Mice_odor)
    mouse_num=Mice_odor(i);
    mouse_col=colors(i);
    path=strcat('/media/mobschapeau/09E7077B1FE07CCB/manip_mimic_opto/', num2str(mouse_num), '/ext');
    cd(path);
    load('behavResources.mat');
    load('TTLInfo.mat');
    %SmooVtsd = tsd(Range(Vtsd),runmean(Data(Vtsd),5));
    % CSMoins
    subplot(3,2,2);
    [M,T]=PlotRipRaw(Imdifftsd,TTLInfo.CSMoinsTimes'/1e4,30000,0,0);
    plot(M(:,1),M(:,2)', 'color', mouse_col);
    hold on
    % CSPlus sans air
    subplot(3,2,4);
    [M,T]=PlotRipRaw(Imdifftsd,TTLInfo.CSPlusTimes(1:2)'/1e4,30000,0,0);
    M(:,2)  = T(1,:)';
    plot(M(:,1),M(:,2)', 'color', mouse_col);
    hold on
    % CSPlus avec air
    subplot(3,2,6);
    [M,T]=PlotRipRaw(Imdifftsd,TTLInfo.CSPlusTimes(3:4)'/1e4,30000,0,0);
    M(:,2)  = T(1,:)';
    plot(M(:,1),M(:,2)', 'color', mouse_col);
    hold on    
end

subplot(3,2,2);
title('odor, CS-');
vline(0);
subplot(3,2,4);
title('odor, CS+ 1 and 2');
vline(0);
subplot(3,2,6);
title('odor, CS+ 3 and 4');
vline(0);
