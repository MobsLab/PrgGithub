%%% CalibAccPlot
% I'm plotting accelerometer data for all mice at calibratoin (red - stimulus)

%% Parameters
dir_out = '/home/mobsrick/Dropbox/Mobs_member/Dima/5-Ongoing results/PAGTest/CalibAccelero/';

%% Mouse 783ant
   dirin={
       '/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-0V/';
       '/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-1V/';
       '/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-2V/';
       '/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-3V/';
       '/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-4V/';
       '/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-5V/';
       '/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationB/Calib-6V/';
       };

fi1 = figure('units','normalized','outerposition',[0 0 0.5 1]);
for i=1:length(dirin)
    cd(dirin{i});
    
    load('behavResources.mat');
    A = Start(TTLInfo.StimEpoch);
    thtps_immob=2;
    smoofact_Acc = 30;
    NewMovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),smoofact_Acc));
    
    
    subplot(7,1,i),
    plot(Range(NewMovAcctsd,'s'), Data(NewMovAcctsd)); line(xlim,[17E6 17E6],'color','k');
    for i = 1:length(A)
        line([A(i)/1e4 A(i)/1e4], ylim, 'color', 'r');
    end
    set(gca, 'YTickLabel', []);
    clearvars -except dirin fi1 dir_out
end
mtit('Mouse 783 - ??dlPAGant - ContextB','xoff', 0, 'yoff', 0.03,'fontsize',16);

saveas(fi1, [dir_out 'M783antB.fig']);
saveFigure(fi1,'M783antB',dir_out);

clearvars -except dir_out
%% Mouse 783post
dirin={
       '/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationC/Calib-0V/';
       '/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationC/Calib-1V/';
       '/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationC/Calib-2V/';
       '/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationC/Calib-2.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationC/Calib-3V/';
       '/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationC/Calib-4V/';
       '/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationC/Calib-5V/';
       '/media/mobsrick/DataMOBS87/Mouse-783/09092018/CalibrationC/Calib-6V/';
       };

fi2 = figure('units','normalized','outerposition',[0 0 0.5 1]);
for i=1:length(dirin)
    cd(dirin{i});
    
    load('behavResources.mat');
    A = Start(TTLInfo.StimEpoch);
    thtps_immob=2;
    smoofact_Acc = 30;
    NewMovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),smoofact_Acc));
    
    
    subplot(8,1,i),
    plot(Range(NewMovAcctsd,'s'), Data(NewMovAcctsd)); line(xlim,[17E6 17E6],'color','k');
    for i = 1:length(A)
        line([A(i)/1e4 A(i)/1e4], ylim, 'color', 'r');
    end
    set(gca, 'YTickLabel', []);
    clearvars -except dirin fi2 dir_out
end
mtit('Mouse 783 - ??dlPAGpost - ContextC','xoff', 0, 'yoff', 0.03,'fontsize',16);

saveas(fi2, [dir_out 'M783postC.fig']);
saveFigure(fi2,'M783postC',dir_out);

clearvars -except dir_out

%% Mouse 785ant
dirin={
       '/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-0V/';
       '/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-1V/';
       '/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-2V/';
       '/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-3.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-3V/';
       '/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-4V/';
       '/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-5V/';
       '/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationC/Calib-6V/';
       };

fi3 = figure('units','normalized','outerposition',[0 0 0.5 1]);
for i=1:length(dirin)
    cd(dirin{i});
    
    load('behavResources.mat');
    A = Start(TTLInfo.StimEpoch);
    thtps_immob=2;
    smoofact_Acc = 30;
    NewMovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),smoofact_Acc));
    
    
    subplot(8,1,i),
    plot(Range(NewMovAcctsd,'s'), Data(NewMovAcctsd)); line(xlim,[17E6 17E6],'color','k');
    for i = 1:length(A)
        line([A(i)/1e4 A(i)/1e4], ylim, 'color', 'r');
    end
    set(gca, 'YTickLabel', []);
    clearvars -except dirin fi3 dir_out
end
mtit('Mouse 785 - ??dlPAGant - ContextC','xoff', 0, 'yoff', 0.03,'fontsize',16);

saveas(fi3, [dir_out 'M785antC.fig']);
saveFigure(fi3,'M785antC',dir_out);

clearvars -except dir_out
%% Mouse 785post
dirin={
       '/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationB/Calib-0V/';
       '/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationB/Calib-0.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationB/Calib-1V/';
       '/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationB/Calib-1.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationB/Calib-2V/';
       '/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationB/Calib-2.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-785/09092018/CalibrationB/Calib-3V/';
       };

fi4 = figure('units','normalized','outerposition',[0 0 0.5 1]);
for i=1:length(dirin)
    cd(dirin{i});
    
    load('behavResources.mat');
    A = Start(TTLInfo.StimEpoch);
    thtps_immob=2;
    smoofact_Acc = 30;
    NewMovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),smoofact_Acc));
    
    
    subplot(7,1,i),
    plot(Range(NewMovAcctsd,'s'), Data(NewMovAcctsd)); line(xlim,[17E6 17E6],'color','k');
    for i = 1:length(A)
        line([A(i)/1e4 A(i)/1e4], ylim, 'color', 'r');
    end
    set(gca, 'YTickLabel', []);
    clearvars -except dirin fi4 dir_out
end
mtit('Mouse 785 - ??dlPAGpost - ContextB','xoff', 0, 'yoff', 0.03,'fontsize',16);

saveas(fi4, [dir_out 'M785postB.fig']);
saveFigure(fi4,'M785postB',dir_out);

clearvars -except dir_out

%% Mouse 786ant
dirin={
       '/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationB/Calib-0V/';
       '/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationB/Calib-1V/';
       '/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationB/Calib-1.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationB/Calib-2V/';
       '/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationB/Calib-2.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationB/Calib-3V/';
       '/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationB/Calib-3.5V/';
       };

fi5 = figure('units','normalized','outerposition',[0 0 0.5 1]);
for i=1:length(dirin)
    cd(dirin{i});
    
    load('behavResources.mat');
    A = Start(TTLInfo.StimEpoch);
    thtps_immob=2;
    smoofact_Acc = 30;
    NewMovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),smoofact_Acc));
    
    
    subplot(7,1,i),
    plot(Range(NewMovAcctsd,'s'), Data(NewMovAcctsd)); line(xlim,[17E6 17E6],'color','k');
    for i = 1:length(A)
        line([A(i)/1e4 A(i)/1e4], ylim, 'color', 'r');
    end
    set(gca, 'YTickLabel', []);
    clearvars -except dirin fi5 dir_out
end
mtit('Mouse 786 - ??vlPAGant - ContextB','xoff', 0, 'yoff', 0.03,'fontsize',16);

saveas(fi5, [dir_out 'M786antB.fig']);
saveFigure(fi5,'M786antB',dir_out);

clearvars -except dir_out

%% Mouse786post
   dirin={
       '/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationC/Calib-0V/';
       '/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationC/Calib-1V/';
       '/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationC/Calib-2V/';
       '/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationC/Calib-3V/';
       '/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationC/Calib-3.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationC/Calib-4V/';
       '/media/mobsrick/DataMOBS87/Mouse-786/09092018/CalibrationC/Calib-5V/'
       };

fi6 = figure('units','normalized','outerposition',[0 0 0.5 1]);
for i=1:length(dirin)
    cd(dirin{i});
    
    load('behavResources.mat');
    A = Start(TTLInfo.StimEpoch);
    thtps_immob=2;
    smoofact_Acc = 30;
    NewMovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),smoofact_Acc));
    
    
    subplot(7,1,i),
    plot(Range(NewMovAcctsd,'s'), Data(NewMovAcctsd)); line(xlim,[17E6 17E6],'color','k');
    for i = 1:length(A)
        line([A(i)/1e4 A(i)/1e4], ylim, 'color', 'r');
    end
    set(gca, 'YTickLabel', []);
    clearvars -except dirin fi6 dir_out

end
mtit('Mouse 786 - ??vlPAGpost - ContextC','xoff', 0, 'yoff', 0.03,'fontsize',16);

saveas(fi6, [dir_out 'M786postC.fig']);
saveFigure(fi6,'M786postC',dir_out);

clearvars -except dir_out

%% Mouse787ant
   dirin={
       '/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationC/Calib-0V/';
       '/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationC/Calib-1V/';
       '/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationC/Calib-2V/';
       '/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationC/Calib-3V/';
       '/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationC/Calib-4V/';
       '/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationC/Calib-5V/';
       '/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationC/Calib-6V/';
       };

fi7 = figure('units','normalized','outerposition',[0 0 0.5 1]);
for i=1:length(dirin)
    cd(dirin{i});
    
    load('behavResources.mat');
    A = Start(TTLInfo.StimEpoch);
    thtps_immob=2;
    smoofact_Acc = 30;
    NewMovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),smoofact_Acc));
    
    
    subplot(7,1,i),
    plot(Range(NewMovAcctsd,'s'), Data(NewMovAcctsd)); line(xlim,[17E6 17E6],'color','k');
    for i = 1:length(A)
        line([A(i)/1e4 A(i)/1e4], ylim, 'color', 'r');
    end
    set(gca, 'YTickLabel', []);
    clearvars -except dirin fi7 dir_out

end
mtit('Mouse 787 - ??vlPAGant - ContextC','xoff', 0, 'yoff', 0.03,'fontsize',16);

saveas(fi7, [dir_out 'M787antC.fig']);
saveFigure(fi7,'M787antC',dir_out);

clearvars -except dir_out
%% Mouse 787post
dirin={
       '/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationB/Calib-0V/';
       '/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationB/Calib-0.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationB/Calib-1V/';
       '/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationB/Calib-1.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-787/09092018/CalibrationB/Calib-2V/';
       };

fi8 = figure('units','normalized','outerposition',[0 0 0.5 1]);
for i=1:length(dirin)
    cd(dirin{i});
    
    load('behavResources.mat');
    A = Start(TTLInfo.StimEpoch);
    thtps_immob=2;
    smoofact_Acc = 30;
    NewMovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),smoofact_Acc));
    
    
    subplot(5,1,i),
    plot(Range(NewMovAcctsd,'s'), Data(NewMovAcctsd)); line(xlim,[17E6 17E6],'color','k');
    for i = 1:length(A)
        line([A(i)/1e4 A(i)/1e4], ylim, 'color', 'r');
    end
    set(gca, 'YTickLabel', []);
    clearvars -except dirin fi8 dir_out
end
mtit('Mouse 787 - ??vlPAGpost - ContextB','xoff', 0, 'yoff', 0.03,'fontsize',16);

saveas(fi8, [dir_out 'M787postB.fig']);
saveFigure(fi8,'M787postB',dir_out);

clearvars -except dir_out

%% Mouse788ant
   dirin={
       '/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationB/Calib-0V/';
       '/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationB/Calib-0.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationB/Calib-1V/';
       '/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationB/Calib-1.5V/';
       '/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationB/Calib-2V/';
       '/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationB/Calib-2.5V/'
       };

fi9 = figure('units','normalized','outerposition',[0 0 0.5 1]);
for i=1:length(dirin)
    cd(dirin{i});
    
    load('behavResources.mat');
    A = Start(TTLInfo.StimEpoch);
    thtps_immob=2;
    smoofact_Acc = 30;
    NewMovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),smoofact_Acc));
    
    
    subplot(6,1,i),
    plot(Range(NewMovAcctsd,'s'), Data(NewMovAcctsd)); line(xlim,[17E6 17E6],'color','k');
    for i = 1:length(A)
        line([A(i)/1e4 A(i)/1e4], ylim, 'color', 'r');
    end
    set(gca, 'YTickLabel', []);
    clearvars -except dirin fi9 dir_out
end
mtit('Mouse 788 - ??dmPAGant - ContextB','xoff', 0, 'yoff', 0.03,'fontsize',16);

saveas(fi9, [dir_out 'M788antB.fig']);
saveFigure(fi9,'M788antB',dir_out);

clearvars -except dir_out

%% Mouse788post
   dirin={
       '/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationC/Calib-0V/';
       '/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationC/Calib-2V/';
       '/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationC/Calib-3V/';
       '/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationC/Calib-4V/';
       '/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationC/Calib-5V/';
       '/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationC/Calib-6V/';
       '/media/mobsrick/DataMOBS87/Mouse-788/09092018/CalibrationC/Calib-8V/';
       };

fi10 = figure('units','normalized','outerposition',[0 0 0.5 1]);
for i=1:length(dirin)
    cd(dirin{i});
    
    load('behavResources.mat');
    A = Start(TTLInfo.StimEpoch);
    thtps_immob=2;
    smoofact_Acc = 30;
    NewMovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),smoofact_Acc));
    
    
    subplot(7,1,i),
    plot(Range(NewMovAcctsd,'s'), Data(NewMovAcctsd)); line(xlim,[17E6 17E6],'color','k');
    for i = 1:length(A)
        line([A(i)/1e4 A(i)/1e4], ylim, 'color', 'r');
    end
    set(gca, 'YTickLabel', []);
    clearvars -except dirin fi10 dir_out
end
mtit('Mouse 788 - ??dmPAGpost - ContextC','xoff', 0, 'yoff', 0.03,'fontsize',16);

saveas(fi10, [dir_out 'M788postC.fig']);
saveFigure(fi10,'M788postC',dir_out);

clearvars -except dir_out