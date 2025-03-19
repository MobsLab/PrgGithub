%% Load the FolderPath 
FolderPath_2Eyelid_Audiodream_AF

%%
n10o = 0;
n15o = 0;
n20o = 0;
n10a = 0;
n15a = 0;
n20a = 0;
n10p = 0;
n15p = 0;
n20p = 0;
for fol = 1:length(FolderName)
    % Load
    cd(FolderName{fol});

%% Get stim events intan
load('behavResources.mat')
Stim_Event_Start = [Start(TTLInfo.StimEpoch)];
Sync_Event_Start = [Start(TTLInfo.Sync)];

duration_stim = 4e4 ; % e4 -> en secondes
Stim_Epoch_Start = Stim_Event_Start+duration_stim;

duration = 6e4 ;  % 
Stim_Epoch_End = Stim_Epoch_Start + duration;

%% Create the Stim Epoch
Epoch_Stim = intervalSet(Stim_Epoch_Start, Stim_Epoch_End);

Event_Stim = intervalSet(Stim_Event_Start, Stim_Event_Start+0.2e4);

% Analysis for OB
load('SleepScoring_OBGamma.mat','SmoothGamma')
load('SleepScoring_OBGamma.mat','Wake')
load('SleepScoring_OBGamma.mat','Sleep')
Stim_Epoch_Start_1 = [];
Stim_Epoch_End_1 = [];
Stim_Epoch_Start_15 = [];
Stim_Epoch_End_15 = [];
Stim_Epoch_Start_2 = [];
Stim_Epoch_End_2 = [];
% Classify the Stim :
load('journal_stim.mat')


for i = 1:length(Start(Event_Stim))
    if journal_stim{i,1} == 1; 
        Stim_Epoch_Start_1 = [Stim_Epoch_Start_1, Stim_Epoch_Start(i)];
        Stim_Epoch_End_1 = [Stim_Epoch_End_1, Stim_Epoch_End(i)];
        n10o = n10o + 1;
        
        Stim_Start = [Stim_Epoch_Start(i)];
        Stim_End = [Stim_Epoch_End(i)];
        Epoch = intervalSet(Stim_Start, Stim_End);
        Stim_Epoch_Wake_1(n10o,1) = sum(Stop(and(Wake,Epoch),'s') - Start(and(Wake,Epoch),'s'));
        percent_Stim_Epoch_Wake_1(n10o,1) = Stim_Epoch_Wake_1(n10o,1)/(sum(Stop(Epoch,'s') - Start(Epoch,'s')));
        clear Epoch
        clear Stim_Start
        clear Stim_End
    end
    if journal_stim{i,1} == 1.5; 
        Stim_Epoch_Start_15 = [Stim_Epoch_Start_15, Stim_Epoch_Start(i)];
        Stim_Epoch_End_15 = [Stim_Epoch_End_15, Stim_Epoch_End(i)];
        n15o = n15o + 1;
        
        Stim_Start = [Stim_Epoch_Start(i)];
        Stim_End = [Stim_Epoch_End(i)];
        Epoch = intervalSet(Stim_Start, Stim_End);
        Stim_Epoch_Wake_15(n15o,1) = sum(Stop(and(Wake,Epoch),'s') - Start(and(Wake,Epoch),'s'));;
        percent_Stim_Epoch_Wake_15(n15o,1) = Stim_Epoch_Wake_15(n15o,1)/(sum(Stop(Epoch,'s') - Start(Epoch,'s')));
        clear Epoch
        clear Stim_Start
        clear Stim_End
    end
    if journal_stim{i,1} == 2; 
        Stim_Epoch_Start_2 = [Stim_Epoch_Start_2, Stim_Epoch_Start(i)];
        Stim_Epoch_End_2 = [Stim_Epoch_End_2, Stim_Epoch_End(i)];
        n20o = n20o + 1;
                
        Stim_Start = [Stim_Epoch_Start(i)];
        Stim_End = [Stim_Epoch_End(i)];
        Epoch = intervalSet(Stim_Start, Stim_End);
        Stim_Epoch_Wake_2(n20o,1) = sum(Stop(and(Wake,Epoch),'s') - Start(and(Wake,Epoch),'s'));
        percent_Stim_Epoch_Wake_2(n20o,1) = Stim_Epoch_Wake_2(n20o,1)/(sum(Stop(Epoch,'s') - Start(Epoch,'s')));
        clear Epoch
        clear Stim_Start
        clear Stim_End
    end
    
end


% Analysis for accelero 
load('SleepScoring_Accelero.mat')
Stim_Epoch_Start_1 = [];
Stim_Epoch_End_1 = [];
Stim_Epoch_Start_15 = [];
Stim_Epoch_End_15 = [];
Stim_Epoch_Start_2 = [];
Stim_Epoch_End_2 = [];
% Classify the Stim :
load('journal_stim.mat')
for i = 1:length(Start(Event_Stim))
    if journal_stim{i,1} == 1; 
        Stim_Epoch_Start_1 = [Stim_Epoch_Start_1, Stim_Epoch_Start(i)];
        Stim_Epoch_End_1 = [Stim_Epoch_End_1, Stim_Epoch_End(i)];
        n10a = n10a + 1;
        
        Stim_Start = [Stim_Epoch_Start(i)];
        Stim_End = [Stim_Epoch_End(i)];
        Epoch = intervalSet(Stim_Start, Stim_End);
        Stim_Epoch_Wake_1(n10a,2) = sum(Stop(and(Wake,Epoch),'s') - Start(and(Wake,Epoch),'s'));
        percent_Stim_Epoch_Wake_1(n10a,2) = Stim_Epoch_Wake_1(n10a,2)/(sum(Stop(Epoch,'s') - Start(Epoch,'s')));
        clear Epoch
        clear Stim_Start
        clear Stim_End
    end
    if journal_stim{i,1} == 1.5; 
        Stim_Epoch_Start_15 = [Stim_Epoch_Start_15, Stim_Epoch_Start(i)];
        Stim_Epoch_End_15 = [Stim_Epoch_End_15, Stim_Epoch_End(i)];
        n15a = n15a + 1;
        
        Stim_Start = [Stim_Epoch_Start(i)];
        Stim_End = [Stim_Epoch_End(i)];
        Epoch = intervalSet(Stim_Start, Stim_End);
        Stim_Epoch_Wake_15(n15a,2) = sum(Stop(and(Wake,Epoch),'s') - Start(and(Wake,Epoch),'s'));
        percent_Stim_Epoch_Wake_15(n15a,2) = Stim_Epoch_Wake_15(n15a,2)/(sum(Stop(Epoch,'s') - Start(Epoch,'s')));
        clear Epoch
        clear Stim_Start
        clear Stim_End
    end
    if journal_stim{i,1} == 2; 
        Stim_Epoch_Start_2 = [Stim_Epoch_Start_2, Stim_Epoch_Start(i)];
        Stim_Epoch_End_2 = [Stim_Epoch_End_2, Stim_Epoch_End(i)];
        n20a = n20a + 1;
                
        Stim_Start = [Stim_Epoch_Start(i)];
        Stim_End = [Stim_Epoch_End(i)];
        Epoch = intervalSet(Stim_Start, Stim_End);
        Stim_Epoch_Wake_2(n20a,2) = sum(Stop(and(Wake,Epoch),'s') - Start(and(Wake,Epoch),'s'));
        percent_Stim_Epoch_Wake_2(n20a,2) = Stim_Epoch_Wake_2(n20a,2)/(sum(Stop(Epoch,'s') - Start(Epoch,'s')));
        clear Epoch
        clear Stim_Start
        clear Stim_End
    end
end

% Analysis for piezo
load('PiezoData_SleepScoring.mat')
Stim_Epoch_Start_1 = [];
Stim_Epoch_End_1 = [];
Stim_Epoch_Start_15 = [];
Stim_Epoch_End_15 = [];
Stim_Epoch_Start_2 = [];
Stim_Epoch_End_2 = [];
% Classify the Stim :
load('journal_stim.mat')
for i = 1:length(Start(Event_Stim))
    if journal_stim{i,1} == 1; 
        Stim_Epoch_Start_1 = [Stim_Epoch_Start_1, Stim_Epoch_Start(i)];
        Stim_Epoch_End_1 = [Stim_Epoch_End_1, Stim_Epoch_End(i)];
        n10p = n10p + 1;
        
        Stim_Start = [Stim_Epoch_Start(i)];
        Stim_End = [Stim_Epoch_End(i)];
        Epoch = intervalSet(Stim_Start, Stim_End);
        % Change in other places
        Stim_Epoch_Wake_1(n10p,3) =  sum(Stop(and(WakeEpoch_Piezo,Epoch),'s') - Start(and(WakeEpoch_Piezo,Epoch),'s'));
        percent_Stim_Epoch_Wake_1(n10p,3) = Stim_Epoch_Wake_1(n10p,3)/(sum(Stop(Epoch,'s') - Start(Epoch,'s')));
        clear Epoch
        clear Stim_Start
        clear Stim_End
    end
    if journal_stim{i,1} == 1.5; 
        Stim_Epoch_Start_15 = [Stim_Epoch_Start_15, Stim_Epoch_Start(i)];
        Stim_Epoch_End_15 = [Stim_Epoch_End_15, Stim_Epoch_End(i)];
        n15p = n15p + 1;
        
        Stim_Start = [Stim_Epoch_Start(i)];
        Stim_End = [Stim_Epoch_End(i)];
        Epoch = intervalSet(Stim_Start, Stim_End);
        Stim_Epoch_Wake_15(n15p,3) = sum(Stop(and(WakeEpoch_Piezo,Epoch),'s') - Start(and(WakeEpoch_Piezo,Epoch),'s'));
        percent_Stim_Epoch_Wake_15(n15p,3) = Stim_Epoch_Wake_15(n15p,3)/(sum(Stop(Epoch,'s') - Start(Epoch,'s')));
        clear Epoch
        clear Stim_Start
        clear Stim_End
    end
    if journal_stim{i,1} == 2; 
        Stim_Epoch_Start_2 = [Stim_Epoch_Start_2, Stim_Epoch_Start(i)];
        Stim_Epoch_End_2 = [Stim_Epoch_End_2, Stim_Epoch_End(i)];
        n20p = n20p + 1;
                
        Stim_Start = [Stim_Epoch_Start(i)];
        Stim_End = [Stim_Epoch_End(i)];
        Epoch = intervalSet(Stim_Start, Stim_End);
        Stim_Epoch_Wake_2(n20p,3) = sum(Stop(and(WakeEpoch_Piezo,Epoch),'s') - Start(and(WakeEpoch_Piezo,Epoch),'s'));
        percent_Stim_Epoch_Wake_2(n20p,3) = Stim_Epoch_Wake_2(n20p,3)/(sum(Stop(Epoch,'s') - Start(Epoch,'s')));
        clear Epoch
        clear Stim_Start
        clear Stim_End
    end
   
end


%%

Epoch_Stim_1 = intervalSet(Stim_Epoch_Start_1, Stim_Epoch_End_1);
Epoch_Stim_15 = intervalSet(Stim_Epoch_Start_15, Stim_Epoch_End_15);
Epoch_Stim_2 = intervalSet(Stim_Epoch_Start_2, Stim_Epoch_End_2);


Vartsd_WakePostStim = Restrict(SmoothGamma, and(Wake,Epoch_Stim_1));


% Plot it
Colors.Sleep = 'r';
Colors.Wake = 'c';
Colors.Stim1 = 'y';
Colors.Stim15 = 'g';
Colors.Stim2 = 'k';
t = Range(SmoothGamma);
begin = t(1);
endin = t(end);
% 
figure
plot(Range(SmoothGamma,'s'),Data(SmoothGamma))
hold on
plot(Range(Restrict(SmoothGamma,Epoch_Stim),'s'),Data(Restrict(SmoothGamma,Epoch_Stim)),'g')
plot(Range(Restrict(SmoothGamma,Wake),'s'),Data(Restrict(SmoothGamma,Wake)),'k')
hold on 
plot(Range(Restrict(SmoothGamma,Event_Stim),'s'),Data(Restrict(SmoothGamma,Event_Stim)),'r')
ylim([0 2000]);
yl=ylim;
LineHeight = yl(2);
PlotPerAsLine(Sleep, LineHeight, Colors.Sleep, 'timescaling', 1e4, 'linewidth',100);
PlotPerAsLine(Wake, LineHeight, Colors.Wake, 'timescaling', 1e4, 'linewidth',100);
PlotPerAsLine(Epoch_Stim_1, LineHeight, Colors.Stim1, 'timescaling', 1e4, 'linewidth',100);
PlotPerAsLine(Epoch_Stim_15, LineHeight, Colors.Stim15, 'timescaling', 1e4, 'linewidth',100);
PlotPerAsLine(Epoch_Stim_2, LineHeight, Colors.Stim2, 'timescaling', 1e4, 'linewidth',100);
xlim([0 max(Range(SmoothGamma,'s'))])
yyaxis right
load('PiezoData_SleepScoring.mat')
plot(Range(Piezo_Mouse_tsd,'s') , Data(Piezo_Mouse_tsd))
hold on
plot(Range(Restrict(Piezo_Mouse_tsd,WakeEpoch_Piezo),'s') , Data(Restrict(Piezo_Mouse_tsd,WakeEpoch_Piezo)),'k')
hold on
load('SleepScoring_Accelero.mat')
plot(Range(MovAcctsd,'s'),5+Data(MovAcctsd)/1e9, 'g')
hold on
plot(Range(Restrict(MovAcctsd,Wake),'s'),5+Data(Restrict(MovAcctsd,Wake))/1e9,'k--')
xlim([0 max(Range(Piezo_Mouse_tsd,'s'))])
ylim([-2.5 7.5])
% 
% 
% % % plot Gamma Brut
% load('SleepScoring_OBGamma.mat')
% 
% % Recalculate gamm no smoothing
%     load('ChannelsToAnalyse/Bulb_deep.mat','channel')
%     load([cd,'/LFPData/LFP',num2str(channel)],'LFP');
%     FilGamma=FilterLFP(LFP,[50 70],1024);
%     HilGamma=hilbert(Data(FilGamma));
%     H=abs(HilGamma);
%     tot_ghi=tsd(Range(LFP),H);
%     
% Plot it
% Colors.Sleep = 'r';
% Colors.Wake = 'c';
% Colors.Stim1 = 'y';
% Colors.Stim15 = 'g';
% Colors.Stim2 = 'k';
% t = Range(SmoothGamma);
% begin = t(1);
% endin = t(end);
% 
% figure
% plot(Range(tot_ghi, 's'),Data(tot_ghi),'color',[0.9290 0.6940 0.1250]);
% hold on, plot(Range(SmoothGamma, 's'),Data(SmoothGamma)*2,'k');
% plot(Range(Restrict(SmoothGamma,Event_Stim),'s'),Data(Restrict(SmoothGamma,Event_Stim))*2,'r')
% plot(Range(Restrict(tot_ghi,Event_Stim),'s'),Data(Restrict(tot_ghi,Event_Stim)),'r')
% 
% ylim([0 2000]);
% yl=ylim;
% LineHeight = yl(2);
% PlotPerAsLine(Sleep, LineHeight, Colors.Sleep, 'timescaling', 1e4, 'linewidth',10);
% PlotPerAsLine(Wake, LineHeight, Colors.Wake, 'timescaling', 1e4, 'linewidth',10);
% xlabel('Temps en s')
% legend('Données brutes filtrées dans la fréquence du Gamma','Données brutes filtrées et smoothées dans la fréquence du Gamma')


end 



groups = {'OB','Movement','Actimetry'};

fig = figure;
suptitle('Pourcentage du Temps de Réveil, pendant les 5s suivant une stim')
subplot(1,3,1)
A = {percent_Stim_Epoch_Wake_1(:,1),percent_Stim_Epoch_Wake_1(:,2),percent_Stim_Epoch_Wake_1(:,3)};
Cols = {[0.9290 0.6940 0.1250],[0 1 0],[0.3010 0.7450 0.9330]};
X = [1,2,3];
Legends = {'OB','Movement','Actimetry'};
ShowPoints = 1;
[boxhandle, pointshandle] = MakeBoxPlot_DB(A,Cols,X,Legends,ShowPoints,'connectdots',1);
xlabel('Groups')
ylabel('Pourcentage du Temps de Réveil')
title('1 Volt')
set(gca, 'XTickLabel',groups);
b.FaceColor = 'flat';
b.CData(1,:) = [0.9290 0.6940 0.1250];
b.CData(2,:) = [0 1 0];
b.CData(3,:) = [0.3010 0.7450 0.9330];

subplot(1,3,2)
A = {percent_Stim_Epoch_Wake_15(:,1),percent_Stim_Epoch_Wake_15(:,2),percent_Stim_Epoch_Wake_15(:,3)};
Cols = {[0.9290 0.6940 0.1250],[0 1 0],[0.3010 0.7450 0.9330]};
X = [1,2,3];
Legends = {'OB','Movement','Actimetry'};
ShowPoints = 1;
[boxhandle, pointshandle] = MakeBoxPlot_DB(A,Cols,X,Legends,ShowPoints,'connectdots',1);
xlabel('Groups')
ylabel('Pourcentage du Temps de Réveil')
title('1.5 Volt')
set(gca, 'XTickLabel',groups);
b.FaceColor = 'flat';
b.CData(1,:) = [0.9290 0.6940 0.1250];
b.CData(2,:) = [0 1 0];
b.CData(3,:) = [0.3010 0.7450 0.9330];

subplot(1,3,3)
A = {percent_Stim_Epoch_Wake_2(:,1),percent_Stim_Epoch_Wake_2(:,2),percent_Stim_Epoch_Wake_2(:,3)};
Cols = {[0.9290 0.6940 0.1250],[0 1 0],[0.3010 0.7450 0.9330]};
X = [1,2,3];
Legends = {'OB','Movement','Actimetry'};
ShowPoints = 1;
[boxhandle, pointshandle] = MakeBoxPlot_DB(A,Cols,X,Legends,ShowPoints,'connectdots',1);
xlabel('Groups')
ylabel('Pourcentage du Temps de Réveil')
title('2 Volt')
set(gca, 'XTickLabel',groups);
b.FaceColor = 'flat';
b.CData(1,:) = [0.9290 0.6940 0.1250];
b.CData(2,:) = [0 1 0];
b.CData(3,:) = [0.3010 0.7450 0.9330];



groups = {'OB','Movement','Actimetry'};

fig = figure;
suptitle('Durée du Temps de Réveil, dans la période 1 à 10s suivant une stim')
subplot(1,3,1)
A = {Stim_Epoch_Wake_1(:,1),Stim_Epoch_Wake_1(:,2),Stim_Epoch_Wake_1(:,3)};
Cols = {[0.9290 0.6940 0.1250],[0 1 0],[0.3010 0.7450 0.9330]};
X = [1,2,3];
Legends = {'OB','Movement','Actimetry'};
ShowPoints = 1;
[boxhandle, pointshandle] = MakeBoxPlot_DB(A,Cols,X,Legends,ShowPoints,'connectdots',1);
xlabel('Groups')
ylabel('Durée du Temps de Réveil en s')
title('1 Volt')
set(gca, 'XTickLabel',groups);
b.FaceColor = 'flat';
b.CData(1,:) = [0.9290 0.6940 0.1250];
b.CData(2,:) = [0 1 0];
b.CData(3,:) = [0.3010 0.7450 0.9330];

subplot(1,3,2)
A = {Stim_Epoch_Wake_15(:,1),Stim_Epoch_Wake_15(:,2),Stim_Epoch_Wake_15(:,3)};
Cols = {[0.9290 0.6940 0.1250],[0 1 0],[0.3010 0.7450 0.9330]};
X = [1,2,3];
Legends = {'OB','Movement','Actimetry'};
ShowPoints = 1;
[boxhandle, pointshandle] = MakeBoxPlot_DB(A,Cols,X,Legends,ShowPoints,'connectdots',1);
xlabel('Groups')
ylabel('Durée du Temps de Réveil en s')
title('1.5 Volt')
set(gca, 'XTickLabel',groups);
b.FaceColor = 'flat';
b.CData(1,:) = [0.9290 0.6940 0.1250];
b.CData(2,:) = [0 1 0];
b.CData(3,:) = [0.3010 0.7450 0.9330];

subplot(1,3,3)
A = {Stim_Epoch_Wake_2(:,1),Stim_Epoch_Wake_2(:,2),Stim_Epoch_Wake_2(:,3)};
Cols = {[0.9290 0.6940 0.1250],[0 1 0],[0.3010 0.7450 0.9330]};
X = [1,2,3];
Legends = {'OB','Movement','Actimetry'};
ShowPoints = 1;
[boxhandle, pointshandle] = MakeBoxPlot_DB(A,Cols,X,Legends,ShowPoints,'connectdots',1);
xlabel('Groups')
ylabel('Durée du Temps de Réveil en s')
title('2 Volt')
set(gca, 'XTickLabel',groups);
b.FaceColor = 'flat';
b.CData(1,:) = [0.9290 0.6940 0.1250];
b.CData(2,:) = [0 1 0];
b.CData(3,:) = [0.3010 0.7450 0.9330];



%% zscore 
zscore_Stim_Epoch_Wake_1(:,1) = zscore(Stim_Epoch_Wake_1(:,1));
zscore_Stim_Epoch_Wake_1(:,2) = zscore(Stim_Epoch_Wake_1(:,2));
zscore_Stim_Epoch_Wake_1(:,3) = zscore(Stim_Epoch_Wake_1(:,3));

zscore_Stim_Epoch_Wake_15(:,1) = zscore(Stim_Epoch_Wake_15(:,1));
zscore_Stim_Epoch_Wake_15(:,2) = zscore(Stim_Epoch_Wake_15(:,2));
zscore_Stim_Epoch_Wake_15(:,3) = zscore(Stim_Epoch_Wake_15(:,3));

zscore_Stim_Epoch_Wake_2(:,1) = zscore(Stim_Epoch_Wake_2(:,1));
zscore_Stim_Epoch_Wake_2(:,2) = zscore(Stim_Epoch_Wake_2(:,2));
zscore_Stim_Epoch_Wake_2(:,3) = zscore(Stim_Epoch_Wake_2(:,3));

fig = figure;
suptitle('zscore de la durée du Temps de Réveil, dans la période de 4 à 10s suivant une stim')
subplot(1,3,1)
A = {zscore_Stim_Epoch_Wake_1(:,1),zscore_Stim_Epoch_Wake_1(:,2),zscore_Stim_Epoch_Wake_1(:,3)};
Cols = {[0.9290 0.6940 0.1250],[0 1 0],[0.3010 0.7450 0.9330]};
X = [1,2,3];
Legends = {'OB','Movement','Actimetry'};
ShowPoints = 1;
[boxhandle, pointshandle] = MakeBoxPlot_DB(A,Cols,X,Legends,ShowPoints,'connectdots',1);
xlabel('Groups')
ylabel('zscore de la durée de réveil')
title('1 Volt')
set(gca, 'XTickLabel',groups);
b.FaceColor = 'flat';
b.CData(1,:) = [0.9290 0.6940 0.1250];
b.CData(2,:) = [0 1 0];
b.CData(3,:) = [0.3010 0.7450 0.9330];
ylim([-1 5])

subplot(1,3,2)
A = {zscore_Stim_Epoch_Wake_15(:,1),zscore_Stim_Epoch_Wake_15(:,2),zscore_Stim_Epoch_Wake_15(:,3)};
Cols = {[0.9290 0.6940 0.1250],[0 1 0],[0.3010 0.7450 0.9330]};
X = [1,2,3];
Legends = {'OB','Movement','Actimetry'};
ShowPoints = 1;
[boxhandle, pointshandle] = MakeBoxPlot_DB(A,Cols,X,Legends,ShowPoints,'connectdots',1);
xlabel('Groups')
ylabel('zscore de la durée de réveil')
title('1.5 Volt')
set(gca, 'XTickLabel',groups);
b.FaceColor = 'flat';
b.CData(1,:) = [0.9290 0.6940 0.1250];
b.CData(2,:) = [0 1 0];
b.CData(3,:) = [0.3010 0.7450 0.9330];
ylim([-1 5])

subplot(1,3,3)
A = {zscore_Stim_Epoch_Wake_2(:,1),zscore_Stim_Epoch_Wake_2(:,2),zscore_Stim_Epoch_Wake_2(:,3)};
Cols = {[0.9290 0.6940 0.1250],[0 1 0],[0.3010 0.7450 0.9330]};
X = [1,2,3];
Legends = {'OB','Movement','Actimetry'};
ShowPoints = 1;
[boxhandle, pointshandle] = MakeBoxPlot_DB(A,Cols,X,Legends,ShowPoints,'connectdots',1);
xlabel('Groups')
ylabel('zscore de la durée de réveil')
title('2 Volt')
set(gca, 'XTickLabel',groups);
b.FaceColor = 'flat';
b.CData(1,:) = [0.9290 0.6940 0.1250];
b.CData(2,:) = [0 1 0];
b.CData(3,:) = [0.3010 0.7450 0.9330];
ylim([-1 5])



%% Quantif durée Wake et sleep par épisode de stim
i = 0
ligne_wake_ob = 1;
ligne_wake_accelero = 1;
ligne_wake_piezo = 1;
ligne_sleep_ob = 1;
ligne_sleep_accelero = 1;
ligne_sleep_piezo = 1;
for i = 1:length(FolderName)
    % Load
    cd(FolderName{i});
%% Quantify Sleep and Wake for each
load('PiezoData_SleepScoring.mat','SleepEpoch_Piezo')
load('PiezoData_SleepScoring.mat','WakeEpoch_Piezo')

load('SleepScoring_OBGamma.mat','Sleep')
load('SleepScoring_OBGamma.mat','Wake')
Sleep_OB = Sleep
Wake_OB = Wake

load('SleepScoring_Accelero.mat','Sleep')
load('SleepScoring_Accelero.mat','Wake')
Sleep_Accelero = Sleep
Wake_Accelero = Wake

load('behavResources.mat')
Stim_Event_Start = [Start(TTLInfo.StimEpoch)];

Stim_Epoch_Start = Stim_Event_Start + duration_stim;   % duration_stim and duration are defined in the first for boucle
Stim_Epoch_End = Stim_Epoch_Start + duration;

% Wake
for n = 1:length(Stim_Epoch_Start)
    Epoch_Stim = intervalSet(Stim_Epoch_Start(n), Stim_Epoch_End(n));
    Wake_Stim_OB = and(Wake_OB, Epoch_Stim);
    tot_duration_wake_OB(ligne_wake_ob,1) = sum(Stop(Wake_Stim_OB,'s')-Start(Wake_Stim_OB,'s'));
    zscore_tot_duration_wake_OB = zscore(tot_duration_wake_OB);
    mean_duration_wake_OB(ligne_wake_ob,1) = mean(Stop(Wake_Stim_OB,'s')-Start(Wake_Stim_OB,'s'));
    ligne_wake_ob = ligne_wake_ob+1;
end

for n = 1:length(Stim_Epoch_Start)
    Epoch_Stim = intervalSet(Stim_Epoch_Start(n), Stim_Epoch_End(n));
Wake_Stim_Accelero = and(Wake_Accelero, Epoch_Stim);
tot_duration_wake_Accelero(ligne_wake_accelero,1) = sum(Stop(Wake_Stim_Accelero,'s')-Start(Wake_Stim_Accelero,'s'));
mean_duration_wake_Accelero(ligne_wake_accelero,1) = mean(Stop(Wake_Stim_Accelero,'s')-Start(Wake_Stim_Accelero,'s'));
ligne_wake_accelero = ligne_wake_accelero + 1;
end

for n = 1:length(Stim_Epoch_Start)
    Epoch_Stim = intervalSet(Stim_Epoch_Start(n), Stim_Epoch_End(n));
Wake_Stim_Piezo = and(WakeEpoch_Piezo, Epoch_Stim);
tot_duration_wake_Piezo(ligne_wake_piezo,1) = sum(Stop(Wake_Stim_Piezo,'s')-Start(Wake_Stim_Piezo,'s'));
mean_duration_wake_Piezo(ligne_wake_piezo,1) = mean(Stop(Wake_Stim_Piezo,'s')-Start(Wake_Stim_Piezo,'s'));
ligne_wake_piezo = ligne_wake_piezo + 1;
end


% Sleep
for n = 1:length(Stim_Epoch_Start)
    Epoch_Stim = intervalSet(Stim_Epoch_Start(n), Stim_Epoch_End(n));
Sleep_Stim_OB = and(Sleep_OB, Epoch_Stim);
tot_duration_sleep_OB(ligne_sleep_ob,1) = sum(Stop(Sleep_Stim_OB,'s')-Start(Sleep_Stim_OB,'s'));
mean_duration_sleep_OB(ligne_sleep_ob,1) = mean(Stop(Sleep_Stim_OB,'s')-Start(Sleep_Stim_OB,'s'));
ligne_sleep_ob = ligne_sleep_ob+1;
end

for n = 1:length(Stim_Epoch_Start)
    Epoch_Stim = intervalSet(Stim_Epoch_Start(n), Stim_Epoch_End(n));
Sleep_Stim_Accelero = and(Sleep_Accelero, Epoch_Stim);
tot_duration_sleep_Accelero(ligne_sleep_accelero,1) = sum(Stop(Sleep_Stim_Accelero,'s')-Start(Sleep_Stim_Accelero,'s'));
mean_duration_sleep_Accelero(ligne_sleep_accelero,1) = mean(Stop(Sleep_Stim_Accelero,'s')-Start(Sleep_Stim_Accelero,'s'));
ligne_sleep_accelero = ligne_sleep_accelero + 1;
end

for n = 1:length(Stim_Epoch_Start)
    Epoch_Stim = intervalSet(Stim_Epoch_Start(n), Stim_Epoch_End(n));
Sleep_Stim_Piezo = and(SleepEpoch_Piezo, Epoch_Stim);
tot_duration_sleep_Piezo(ligne_sleep_piezo,1) = sum(Stop(Sleep_Stim_Piezo,'s')-Start(Sleep_Stim_Piezo,'s'));
mean_duration_sleep_Piezo(ligne_sleep_piezo,1) = mean(Stop(Sleep_Stim_Piezo,'s')-Start(Sleep_Stim_Piezo,'s'));
ligne_sleep_piezo = ligne_sleep_piezo +1;

end

end


groups = {'OB','Movement','Actimetry'};
fig = figure; 
subplot(2,2,1);
Vartsd_WakePostStim = {tot_duration_wake_OB,tot_duration_wake_Accelero,tot_duration_wake_Piezo};
Cols = {[0.9290 0.6940 0.1250],[0 1 0],[0.3010 0.7450 0.9330]};
X = [1,2,3];
Legends = {'OB','Movement','Actimetry'};
ShowPoints = 1;
[boxhandle, pointshandle] = MakeBoxPlot_DB(Vartsd_WakePostStim,Cols,X,Legends,ShowPoints,'connectdots',1)
xlabel('Groups')
ylabel('Durée d éveil en s')
title('Durée d éveil')
set(gca, 'XTickLabel',groups);
hold on 

subplot(2,2,2);
Vartsd_WakePostStim = {mean_duration_wake_OB,mean_duration_wake_Accelero,mean_duration_wake_Piezo};
Cols = {[0.9290 0.6940 0.1250],[0 1 0],[0.3010 0.7450 0.9330]};
X = [1,2,3];
Legends = {'OB','Movement','Actimetry'};
ShowPoints = 1;
[boxhandle, pointshandle] = MakeBoxPlot_DB(Vartsd_WakePostStim,Cols,X,Legends,ShowPoints,'connectdots',1)
xlabel('Groups')
ylabel('Moyenne d éveil en s')
title('Moyenne d éveil')
set(gca, 'XTickLabel',groups);
hold on 

subplot(2,2,3);
Vartsd_WakePostStim = {tot_duration_sleep_OB,tot_duration_sleep_Accelero,tot_duration_sleep_Piezo};
Cols = {[0.9290 0.6940 0.1250],[0 1 0],[0.3010 0.7450 0.9330]};
X = [1,2,3];
Legends = {'OB','Movement','Actimetry'};
ShowPoints = 1;
[boxhandle, pointshandle] = MakeBoxPlot_DB(Vartsd_WakePostStim,Cols,X,Legends,ShowPoints,'connectdots',1)
xlabel('Groups')
ylabel('Durée de sommeil en s')
title('Durée de sommeil')
set(gca, 'XTickLabel',groups);
hold on 

subplot(2,2,4);
Vartsd_WakePostStim = {mean_duration_sleep_OB,mean_duration_sleep_Accelero,mean_duration_sleep_Piezo};
Cols = {[0.9290 0.6940 0.1250],[0 1 0],[0.3010 0.7450 0.9330]};
X = [1,2,3];
Legends = {'OB','Movement','Actimetry'};
ShowPoints = 1;
[boxhandle, pointshandle] = MakeBoxPlot_DB(Vartsd_WakePostStim,Cols,X,Legends,ShowPoints,'connectdots',1)
xlabel('Groups')
ylabel('Moyenne de sommeil en s')
title('Moyenne de sommeil')
set(gca, 'XTickLabel',groups);
hold on 






%% corrélation
figure, 
suptitle('Corrélations des durées de réveil pendant la période 4 à 10s après la stim')
subplot(331)
plot(Stim_Epoch_Wake_1(:,1),Stim_Epoch_Wake_1(:,2),'.','MarkerSize',20)
xlabel('OB Gamma')
ylabel('Accéléromètre')
title('1 Volt')

subplot(332)
plot(Stim_Epoch_Wake_1(:,1),Stim_Epoch_Wake_1(:,3),'.','MarkerSize',20)
xlabel('OB Gamma')
ylabel('Piezo')
title('1 Volt')

subplot(333)
plot(Stim_Epoch_Wake_1(:,2),Stim_Epoch_Wake_1(:,3),'.','MarkerSize',20)
xlabel('Accéléromètre')
ylabel('Piezo')
title('1 Volt')

subplot(334)
plot(Stim_Epoch_Wake_15(:,1),Stim_Epoch_Wake_15(:,2),'.','MarkerSize',20)
xlabel('OB Gamma')
ylabel('Accéléromètre')
title('1.5 Volt')

subplot(335)
plot(Stim_Epoch_Wake_15(:,1),Stim_Epoch_Wake_15(:,3),'.','MarkerSize',20)
xlabel('OB Gamma')
ylabel('Piezo')
title('1.5 Volt')

subplot(336)
plot(Stim_Epoch_Wake_15(:,2),Stim_Epoch_Wake_15(:,3),'.','MarkerSize',20)
xlabel('Accéléromètre')
ylabel('Piezo')
title('1.5 Volt')

subplot(337)
plot(Stim_Epoch_Wake_2(:,1),Stim_Epoch_Wake_2(:,2),'.','MarkerSize',20)
xlabel('OB Gamma')
ylabel('Accéléromètre')
title('2 Volt')

subplot(338)
plot(Stim_Epoch_Wake_2(:,1),Stim_Epoch_Wake_2(:,3),'.','MarkerSize',20)
xlabel('OB Gamma')
ylabel('Piezo')
title('2 Volt')

subplot(339)
plot(Stim_Epoch_Wake_2(:,2),Stim_Epoch_Wake_2(:,3),'.','MarkerSize',20)
xlabel('Accéléromètre')
ylabel('Piezo')
title('2 Volt')





%%
x = [0 1 2 3 4 5 6 7 8 9 10]
y = x

figure, 
suptitle('Corrélations des durées de réveil pendant la période 4 à 14s après la stim')
subplot(131)
plot(Stim_Epoch_Wake_1(:,1),Stim_Epoch_Wake_1(:,2),'r.','MarkerSize',20)
hold on 
plot(Stim_Epoch_Wake_15(:,1),Stim_Epoch_Wake_15(:,2),'g.','MarkerSize',20)
hold on
plot(Stim_Epoch_Wake_2(:,1),Stim_Epoch_Wake_2(:,2),'k.','MarkerSize',20)
hold on 
% plot(x,y,'b--')
xlabel('OB Gamma')
ylabel('Accéléromètre')
ylim([0 10])


subplot(132)
plot(Stim_Epoch_Wake_1(:,1),Stim_Epoch_Wake_1(:,3),'r.','MarkerSize',20)
hold on 
plot(Stim_Epoch_Wake_15(:,1),Stim_Epoch_Wake_15(:,3),'g.','MarkerSize',20)
hold on
plot(Stim_Epoch_Wake_2(:,1),Stim_Epoch_Wake_2(:,3),'k.','MarkerSize',20)
hold on 
% plot(x,y,'b--')
xlabel('OB Gamma')
ylabel('Piézo')
ylim([0 10])


subplot(133)
plot(Stim_Epoch_Wake_1(:,2),Stim_Epoch_Wake_1(:,3),'r.','MarkerSize',20)
hold on 
plot(Stim_Epoch_Wake_15(:,2),Stim_Epoch_Wake_15(:,3),'g.','MarkerSize',20)
hold on
plot(Stim_Epoch_Wake_2(:,2),Stim_Epoch_Wake_2(:,3),'k.','MarkerSize',20)
hold on 
% plot(x,y,'b--')
xlabel('Accéléromètre')
ylabel('Piézo')
ylim([0 10])




%% For separate ob piézo and accelero

for i = 1:length(Stim_Epoch_Wake_1)
    stim_wake_ob(i,1) = Stim_Epoch_Wake_1(i,1);
end
l = length(stim_wake_ob);
for i = 1:length(Stim_Epoch_Wake_15)
    stim_wake_ob(i+l,1) = Stim_Epoch_Wake_15(i,1);
end
l = length(stim_wake_ob);
for i = 1:length(Stim_Epoch_Wake_2)
    stim_wake_ob(i+l,1) = Stim_Epoch_Wake_2(i,1);
end

for i = 1:length(Stim_Epoch_Wake_1)
    stim_wake_accelero(i,1) = Stim_Epoch_Wake_1(i,2);
end
l = length(stim_wake_accelero);
for i = 1:length(Stim_Epoch_Wake_15)
    stim_wake_accelero(i+l,1) = Stim_Epoch_Wake_15(i,2);
end
l = length(stim_wake_accelero);
for i = 1:length(Stim_Epoch_Wake_2)
    stim_wake_accelero(i+l,1) = Stim_Epoch_Wake_2(i,2);
end


for i = 1:length(Stim_Epoch_Wake_1)
    stim_wake_piezo(i,1) = Stim_Epoch_Wake_1(i,3);
end
l = length(stim_wake_piezo);
for i = 1:length(Stim_Epoch_Wake_15)
    stim_wake_piezo(i+l,1) = Stim_Epoch_Wake_15(i,3);
end
l = length(stim_wake_piezo);
for i = 1:length(Stim_Epoch_Wake_2)
    stim_wake_piezo(i+l,1) = Stim_Epoch_Wake_2(i,3);
end

