
%% Generating data
clear all

cd(FearSess.(Mouse_names{mouse}){1})
load('B_Low_Spectrum.mat')
Session_type={'Fear','Cond','Ext','Sleep'};
State1={'Active','Fz','Fz_Shock','Fz_Safe'};
State2={'Active','Sleep','NREM','REM'};

Mouse=[1184 1205 1224 1225 1226 1227];
[EMG_Fear_TSD , Epoch1 , NameEpoch]=MeanValuesPhysiologicalParameters_BM(Mouse,'fear','emg');
[EMG_Sleep_TSD , Epoch2 , NameEpoch2]=MeanValuesPhysiologicalParameters_BM(Mouse,'slmz','emg');

for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
end

ind=[4 3 5 6]; ind2=[2:5]; % indices for corresponding Epoch, cf NameEpoch and NameEpoch2
% Calculating data for each mouse
for mouse=1:length(Mouse_names)
    sess=1;
    for state=1:length(State1)
        DataEMG.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})=Data(EMG_Fear_TSD.emg.tsd{mouse,ind(state)}); DataEMG.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})(DataEMG.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})==0)=NaN;
    end
    sess=4;
    for state=1:length(State2)
        DataEMG.(Session_type{sess}).(State2{state}).(Mouse_names{mouse})=Data(EMG_Sleep_TSD.emg.tsd{mouse,ind2(state)}); DataEMG.(Session_type{sess}).(State2{state}).(Mouse_names{mouse})(DataEMG.(Session_type{sess}).(State2{state}).(Mouse_names{mouse})==0)=NaN;
    end
    disp(Mouse_names{mouse})
end

% Filter Data
for mouse=1:length(Mouse_names)
    for sess=1
        for state=1:length(State1)
            try
                EMG_Filtered_Pre.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})=FilterLFP(EMG_Fear_TSD.emg.tsd{mouse,ind(state)},[50 300],1024);
                DataEMG_Filtered.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})=runmean(Data((EMG_Filtered_Pre.(Session_type{sess}).(State1{state}).(Mouse_names{mouse}))).^2,ceil(3/median(diff(Range(EMG_Filtered_Pre.(Session_type{sess}).(State1{state}).(Mouse_names{mouse}),'s')))));
            catch
                DataEMG_Filtered.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})=NaN;
            end
        end
    end
    for sess=4
        for state=1:length(State2)
            try
                EMG_Filtered_Pre.(Session_type{sess}).(State2{state}).(Mouse_names{mouse})=FilterLFP(EMG_Sleep_TSD.emg.tsd{mouse,ind2(state)},[50 300],1024);
                DataEMG_Filtered.(Session_type{sess}).(State2{state}).(Mouse_names{mouse})=runmean(Data((EMG_Filtered_Pre.(Session_type{sess}).(State2{state}).(Mouse_names{mouse}))).^2,ceil(3/median(diff(Range(EMG_Filtered_Pre.(Session_type{sess}).(State2{state}).(Mouse_names{mouse}),'s')))));
            catch
                DataEMG_Filtered.(Session_type{sess}).(State2{state}).(Mouse_names{mouse})=NaN;
            end
        end
    end
    disp(Mouse_names{mouse})
end


%% Gathering data
% Unfiltered data
for mouse=1:length(Mouse)
    for sess=1
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for state=1:length(State1)
            try
                MeanEMG_Unfiltered.(Session_type{sess}).(State1{state})(mouse)=nanmean((DataEMG.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})).^2);
            catch
                MeanEMG_Unfiltered.(Session_type{sess}).(State1{state})(mouse)=NaN;
            end
        end
    end
    for sess=4
        for state=1:length(State2)
            try
                MeanEMG_Unfiltered.(Session_type{sess}).(State2{state})(mouse)=nanmean((DataEMG.(Session_type{sess}).(State2{state}).(Mouse_names{mouse})).^2);
            catch
                MeanEMG_Unfiltered.(Session_type{sess}).(State2{state})(mouse)=NaN;
            end
        end
    end
end


for mouse=1:length(Mouse)
    for sess=1
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for state=1:length(State1)
            try
                MeanStdEMG_Unfiltered.(Session_type{sess}).(State1{state})(mouse)=nanstd((DataEMG.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})).^2);
            catch
                MeanStdEMG_Unfiltered.(Session_type{sess}).(State1{state})(mouse)=NaN;
            end
        end
    end
    for sess=4
        for state=1:length(State2)
            try
                MeanStdEMG_Unfiltered.(Session_type{sess}).(State2{state})(mouse)=nanstd((DataEMG.(Session_type{sess}).(State2{state}).(Mouse_names{mouse})).^2);
            catch
                MeanStdEMG_Unfiltered.(Session_type{sess}).(State2{state})(mouse)=NaN;
            end
        end
    end
end


% Filtered Data
for mouse=1:length(Mouse)
    for sess=1
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for state=1:length(State1)
            MeanEMG_Filtered.(Session_type{sess}).(State1{state})(mouse)=nanmean(DataEMG_Filtered.(Session_type{sess}).(State1{state}).(Mouse_names{mouse}));
        end
    end
    for sess=4
        for state=1:length(State2)
            MeanEMG_Filtered.(Session_type{sess}).(State2{state})(mouse)=nanmean(DataEMG_Filtered.(Session_type{sess}).(State2{state}).(Mouse_names{mouse}));
        end
    end
end


for mouse=1:length(Mouse)
    for sess=1
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for state=1:length(State1)
            MeanStdEMG_Filtered.(Session_type{sess}).(State1{state})(mouse)=nanstd(DataEMG_Filtered.(Session_type{sess}).(State1{state}).(Mouse_names{mouse}));
        end
    end
    for sess=4
        for state=1:length(State2)
            MeanStdEMG_Filtered.(Session_type{sess}).(State2{state})(mouse)=nanstd(DataEMG_Filtered.(Session_type{sess}).(State2{state}).(Mouse_names{mouse}));
        end
    end
end


%% Figures
Cols = {[0.3 0.3 0.3],[0.7 0.7 0.7],[0 0 0],[1 0.5 0.5],[0.5 0.5 1]};
X = [1,2,3,4,5];
Legends = {'Active','Sleep','Freezing','Shock','Safe'};
NoLegends = {'','','','',''};
%Mean
figure
subplot(221)
MakeSpreadAndBoxPlot2_SB({MeanEMG_Unfiltered.Fear.Active , MeanEMG_Unfiltered.Sleep.Sleep , MeanEMG_Unfiltered.Fear.Fz , MeanEMG_Unfiltered.Fear.Fz_Shock , MeanEMG_Unfiltered.Fear.Fz_Safe},Cols,X,NoLegends,'showpoints',0,'paired',1); makepretty; xtickangle(45);
ylabel('EMG power (a.u.)'); a=text(-1,2e5,'Raw data','FontSize',20,'FontWeight','bold'); set(a,'Rotation',90)
set(gca, 'YScale', 'log'); ylim([5e4 4e6]); title('UMaze analysis')
subplot(222)
MakeSpreadAndBoxPlot2_SB({MeanEMG_Unfiltered.Sleep.Active , MeanEMG_Unfiltered.Sleep.Sleep , MeanEMG_Unfiltered.Sleep.NREM , MeanEMG_Unfiltered.Sleep.REM},{[0 0 1],[0.3 0.3 0.3],[1 0 0],[0 1 0]},[1:4],{'','','',''},'showpoints',0,'paired',1); makepretty; xtickangle(45);
set(gca, 'YScale', 'log'); ylim([5e4 4e6]); title('Sleep analysis')

subplot(223)
MakeSpreadAndBoxPlot2_SB({MeanEMG_Filtered.Fear.Active , MeanEMG_Filtered.Sleep.Sleep , MeanEMG_Filtered.Fear.Fz , MeanEMG_Filtered.Fear.Fz_Shock , MeanEMG_Filtered.Fear.Fz_Safe},Cols,X,Legends,'showpoints',0,'paired',1); makepretty; xtickangle(45);
set(gca, 'YScale', 'log'); ylim([3e3 5e5])
ylabel('EMG power (a.u.)'); a=text(-1,1.2e4,'Filtered data','FontSize',20,'FontWeight','bold'); set(a,'Rotation',90)
subplot(224)
MakeSpreadAndBoxPlot2_SB({MeanEMG_Filtered.Sleep.Active , MeanEMG_Filtered.Sleep.Sleep , MeanEMG_Filtered.Sleep.NREM , MeanEMG_Filtered.Sleep.REM},{[0 0 1],[0.3 0.3 0.3],[1 0 0],[0 1 0]},[1:4],{'Active','Sleep','NREM','REM'},'showpoints',0,'paired',1); makepretty; xtickangle(45);
set(gca, 'YScale', 'log'); ylim([3e3 5e5])

a=suptitle('Mean data analysis'); a.FontSize=20;


% Std
figure
subplot(221)
MakeSpreadAndBoxPlot2_SB({MeanStdEMG_Unfiltered.Fear.Active , MeanStdEMG_Unfiltered.Sleep.Sleep , MeanStdEMG_Unfiltered.Fear.Fz , MeanStdEMG_Unfiltered.Fear.Fz_Shock , MeanStdEMG_Unfiltered.Fear.Fz_Safe},Cols,X,NoLegends,'showpoints',0,'paired',1); makepretty; xtickangle(45);
ylabel('EMG power (a.u.)'); a=text(-1,6e5,'Raw data','FontSize',20,'FontWeight','bold'); set(a,'Rotation',90)
set(gca, 'YScale', 'log'); ylim([5e4 1e8]); title('UMaze analysis')
subplot(222)
MakeSpreadAndBoxPlot2_SB({MeanStdEMG_Unfiltered.Sleep.Active , MeanStdEMG_Unfiltered.Sleep.Sleep , MeanStdEMG_Unfiltered.Sleep.NREM , MeanStdEMG_Unfiltered.Sleep.REM},{[0 0 1],[0.3 0.3 0.3],[1 0 0],[0 1 0]},[1:4],{'','','',''},'showpoints',0,'paired',1); makepretty; xtickangle(45);
set(gca, 'YScale', 'log'); ylim([5e4 1e8]); title('Sleep analysis')

subplot(223)
MakeSpreadAndBoxPlot2_SB({MeanStdEMG_Filtered.Fear.Active , MeanStdEMG_Filtered.Sleep.Sleep , MeanStdEMG_Filtered.Fear.Fz , MeanStdEMG_Filtered.Fear.Fz_Shock , MeanStdEMG_Filtered.Fear.Fz_Safe},Cols,X,Legends,'showpoints',0,'paired',1); makepretty; xtickangle(45);
set(gca, 'YScale', 'log'); ylim([6e2 2e6])
ylabel('EMG power (a.u.)'); a=text(-1,4e3,'Filtered data','FontSize',20,'FontWeight','bold'); set(a,'Rotation',90)
subplot(224)
MakeSpreadAndBoxPlot2_SB({MeanStdEMG_Filtered.Sleep.Active , MeanStdEMG_Filtered.Sleep.Sleep , MeanStdEMG_Filtered.Sleep.NREM , MeanStdEMG_Filtered.Sleep.REM},{[0 0 1],[0.3 0.3 0.3],[1 0 0],[0 1 0]},[1:4],{'Active','Sleep','NREM','REM'},'showpoints',0,'paired',1); makepretty; xtickangle(45);
set(gca, 'YScale', 'log'); ylim([6e2 2e6])

a=suptitle('Mean std analysis'); a.FontSize=20;


%% Distrib
sess=1; % correct where respi is nan
for mouse=1:length(Mouse) 
    for state=2:length(State1)
        Log_to_use = ~isnan(Respi_Rythm2.Fear.(State1{state}).(Mouse_names{mouse}));
        Respi_Rythm2.Fear.(State1{state}).(Mouse_names{mouse}) = Respi_Rythm2.Fear.(State1{state}).(Mouse_names{mouse})(Log_to_use);
        DataEMG_Filtered.Fear.(State1{state}).(Mouse_names{mouse})=DataEMG_Filtered.Fear.(State1{state}).(Mouse_names{mouse})(Log_to_use);
    end
end

Prc=1;
for mouse=1:length(Mouse) % if you want beautiful distrib figures make state=3:4
    %figure
    Y1 = prctile(log10(DataEMG_Filtered.Fear.Fz.(Mouse_names{mouse})),Prc);
    Y2 = prctile(log10(DataEMG_Filtered.Fear.Fz.(Mouse_names{mouse})),100-Prc);
    Z1 = prctile(Respi_Rythm2.Fear.Fz.(Mouse_names{mouse}),Prc);
    Z2 = prctile(Respi_Rythm2.Fear.Fz.(Mouse_names{mouse}),100-Prc);
    try
        for state=2:length(State1)
            h=histogram(log10(DataEMG_Filtered.Fear.(State1{state}).(Mouse_names{mouse})),'BinLimits',[Y1 Y2],'NumBins',100); hold on
            HistData.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})=h.Values;
            Logical_to_use = and(and(log10(DataEMG_Filtered.Fear.(State1{state}).(Mouse_names{mouse}))<Y2 , log10(DataEMG_Filtered.Fear.(State1{state}).(Mouse_names{mouse}))>Y1) , and(Respi_Rythm2.Fear.(State1{state}).(Mouse_names{mouse})<Z2 , Respi_Rythm2.Fear.(State1{state}).(Mouse_names{mouse})>Z1));
            
            Clean_DataEMG_Filtered.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})=DataEMG_Filtered.Fear.(State1{state}).(Mouse_names{mouse})(Logical_to_use);
            Clean_Respi_Rythm2.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})=Respi_Rythm2.Fear.(State1{state}).(Mouse_names{mouse})(Logical_to_use);
         end
    end
end


Mouse=[829 851 858 859 1006 777 849];
for mouse=1:length(Mouse)
        for state=2:length(State1)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        HistData_All.(Session_type{sess}).(State1{state})(mouse,:) = HistData.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})/sum(HistData.(Session_type{sess}).(State1{state}).(Mouse_names{mouse}));
    end
end

figure
Conf_Inter=nanstd(HistData_All.Fear.Fz)/sqrt(size(HistData_All.Fear.Fz,1));
shadedErrorBar([1:100],runmean(nanmean(HistData_All.Fear.Fz),3)*2,Conf_Inter,'k',1); hold on;
Conf_Inter=nanstd(HistData_All.Fear.Fz_Shock)/sqrt(size(HistData_All.Fear.Fz_Shock,1));
shadedErrorBar([1:100],runmean(nanmean(HistData_All.Fear.Fz_Shock),3),Conf_Inter,'r',1);
Conf_Inter=nanstd(HistData_All.Fear.Fz_Safe)/sqrt(size(HistData_All.Fear.Fz_Safe,1));
shadedErrorBar([1:100],runmean(nanmean(HistData_All.Fear.Fz_Safe),3),Conf_Inter,'b',1);
makepretty;
f=get(gca,'Children'); legend([f(9),f(5),f(1)],'All fz','Fz shock','Fz safe');
xlabel('EMG values (a.u.)'); ylabel('%');
title('EMG values distribution, UMaze, saline-like, n=7')


%% Correlation OB frequency - EMG values
for mouse=1:length(Mouse) % zscoring from data all freezing
    for state=2:4
        LogZscoredClean_DataEMG_Filtered.Fear.(State1{state}).(Mouse_names{mouse}) = (log10(Clean_DataEMG_Filtered.Fear.(State1{state}).(Mouse_names{mouse}))-nanmean(log10(Clean_DataEMG_Filtered.Fear.(State1{2}).(Mouse_names{mouse}))))/nanstd(log10(Clean_DataEMG_Filtered.Fear.(State1{2}).(Mouse_names{mouse})));
    end
end

bin=1000; mouse=4;
colo={'.r','.b'}; colo2={'r','b'}; 

figure
plot(LogZscoredClean_DataEMG_Filtered.Fear.(State1{2}).(Mouse_names{mouse})(bin:bin:end) , Clean_Respi_Rythm2.Fear.(State1{2}).(Mouse_names{mouse})(bin:bin:end),'.k','MarkerSize',10)
hold on; makepretty
xlabel('EMG power (a.u.)'); 
ylabel('OB frequency (Hz)')
[R , P]=corrcoef_BM(LogZscoredClean_DataEMG_Filtered.Fear.(State1{2}).(Mouse_names{mouse}) , Clean_Respi_Rythm2.Fear.(State1{2}).(Mouse_names{mouse}));
p=polyfit( LogZscoredClean_DataEMG_Filtered.Fear.(State1{2}).(Mouse_names{mouse})(bin:bin:end) , Clean_Respi_Rythm2.Fear.(State1{2}).(Mouse_names{mouse})(bin:bin:end) ,1);
x=[-1.8:0.2:1.8]; y=x.*p(1)+p(2); plot(x,y,'r','LineWidth',2)
t=text(1,8,['R = ' num2str(R(2,1)) '     P = ' num2str(P(2,1))]); t.FontSize=20;
title('OB frequency and EMG power relations during freezing')


for mouse=1:length(Mouse)
    %figure
    for state=2:4
        X_to_use = LogZscoredClean_DataEMG_Filtered.Fear.(State1{state}).(Mouse_names{mouse})(bin:bin:end);
        Y_to_use = Clean_Respi_Rythm2.Fear.(State1{state}).(Mouse_names{mouse})(bin:bin:end);
        %plot(X_to_use,Y_to_use,colo{state-2})
        hold on
        Ellipse.(State1{state}).(Mouse_names{mouse}) = Ellipse_From_Data_BM(X_to_use,Y_to_use);
    end
%     makepretty
%     title(Mouse_names{mouse})
%     xlabel('EMG power (a.u.)'); %ylim([0 8])
%     ylabel('OB frequency (Hz)')
%     legend('Shock side freezing','Safe side freezing')
end

for mouse=1:length(Mouse)
    for state=2:4
        %plot(Ellipse.(State1{state}).(Mouse_names{mouse})(:,1),Ellipse.(State1{state}).(Mouse_names{mouse})(:,2),colo2{state-2},'LineWidth',5)
        hold on
        EllipseX_All.(State1{state})(mouse,:) = Ellipse.(State1{state}).(Mouse_names{mouse})(:,1);
        EllipseY_All.(State1{state})(mouse,:) = Ellipse.(State1{state}).(Mouse_names{mouse})(:,2);        
    end
%     makepretty
%     title(Mouse_names{mouse})
%     xlabel('EMG power (a.u.)'); %ylim([0 8])
%     ylabel('OB frequency (Hz)')
%     legend('Shock side freezing','Safe side freezing')
end

figure
for state=3:4
    Conf_Inter=nanstd(EllipseY_All.(State1{state}))/sqrt(size(EllipseY_All.(State1{state}),1));
    shadedErrorBar(nanmean(EllipseX_All.(State1{state})) , nanmean(EllipseY_All.(State1{state})),Conf_Inter,colo2{state-2},1); hold on;
end
xlabel('EMG power (a.u.)'); ylabel('OB frequency (Hz)')
makepretty
f=get(gca,'Children'); legend([f(9),f(5),f(1)],'All Fz','Fz shock','Fz safe');


% Who is more specific ?
for mouse=1:length(Mouse)
    Mid_Distance_X = nanmedian(LogZscoredClean_DataEMG_Filtered.Fear.(State1{4}).(Mouse_names{mouse}))+((nanmedian(LogZscoredClean_DataEMG_Filtered.Fear.(State1{3}).(Mouse_names{mouse}))-nanmedian(LogZscoredClean_DataEMG_Filtered.Fear.(State1{4}).(Mouse_names{mouse})))/2);
    Mid_Distance_Y = nanmedian(Clean_Respi_Rythm2.Fear.(State1{4}).(Mouse_names{mouse}))+((nanmedian(Clean_Respi_Rythm2.Fear.(State1{3}).(Mouse_names{mouse}))-nanmedian(Clean_Respi_Rythm2.Fear.(State1{4}).(Mouse_names{mouse})))/2);
    
    N.Shock.(Mouse_names{mouse}) = Confusion_Matrix_BM([LogZscoredClean_DataEMG_Filtered.Fear.(State1{3}).(Mouse_names{mouse}) Clean_Respi_Rythm2.Fear.(State1{3}).(Mouse_names{mouse})],[LogZscoredClean_DataEMG_Filtered.Fear.(State1{4}).(Mouse_names{mouse}) Clean_Respi_Rythm2.Fear.(State1{4}).(Mouse_names{mouse})],Mid_Distance_X,Mid_Distance_Y,'1');
    N.Safe.(Mouse_names{mouse}) = Confusion_Matrix_BM([LogZscoredClean_DataEMG_Filtered.Fear.(State1{4}).(Mouse_names{mouse}) Clean_Respi_Rythm2.Fear.(State1{4}).(Mouse_names{mouse})],[LogZscoredClean_DataEMG_Filtered.Fear.(State1{3}).(Mouse_names{mouse}) Clean_Respi_Rythm2.Fear.(State1{3}).(Mouse_names{mouse})],Mid_Distance_X,Mid_Distance_Y,'1');
    
    N.Shock.All(mouse,:,:)=N.Shock.(Mouse_names{mouse});
    N.Safe.All(mouse,:,:)=N.Safe.(Mouse_names{mouse});
end


figure; bin=20;
for state=3:4
    X_to_use = LogZscoredClean_DataEMG_Filtered.Fear.(State1{state}).(Mouse_names{mouse})(bin:bin:end);
    Y_to_use = Clean_Respi_Rythm2.Fear.(State1{state}).(Mouse_names{mouse})(bin:bin:end);
    plot(X_to_use,Y_to_use,colo{state-2})
    hold on
end
h=hline(Mid_Distance_Y,'-k'); h.LineWidth=5;
h=vline(Mid_Distance_X,'-k'); h.LineWidth=5;
makepretty


figure
subplot(121)
Data=squeeze(nanmean(N.Shock.All));
imagesc(Data)
text(0.75,1.1,num2str(Data(1,1))); text(1.75,1.1,num2str(Data(1,2))); text(0.75,2.1,num2str(Data(2,1))); text(1.75,2.1,num2str(Data(2,2)))
subplot(122)
Data=squeeze(nanmean(N.Safe.All));
imagesc(Data)
text(0.75,1.1,num2str(Data(1,1))); text(1.75,1.1,num2str(Data(1,2))); text(0.75,2.1,num2str(Data(2,1))); text(1.75,2.1,num2str(Data(2,2)))







figure
plot(log10(DataEMG_Filtered.Fear.(State1{3}).(Mouse_names{5})(bin:bin:end)),log10(Gamma_Power2.Fear.(State1{3}).(Mouse_names{5})(bin:bin:end)),'.r')
hold on
plot(log10(DataEMG_Filtered.Fear.(State1{4}).(Mouse_names{5})(bin:bin:end)),log10(Gamma_Power2.Fear.(State1{4}).(Mouse_names{5})(bin:bin:end)),'.b')
makepretty







%% Contour
for mouse=1:length(Mouse)
    for state=2:length(State1)
        Cont.(State1{state}).(Mouse_names{mouse}) = Contour_BM(log10(DataEMG_Filtered.Fear.(State1{state}).(Mouse_names{mouse})) , Respi_Rythm2.Fear.(State1{state}).(Mouse_names{mouse}),85);
    end
end

for mouse=1:length(Mouse)
    figure
    plot(Cont.(State1{3}).(Mouse_names{mouse})(1,:),Cont.(State1{3}).(Mouse_names{mouse})(2,:),'r','linewidth',2)
    hold on;
    plot(Cont.(State1{4}).(Mouse_names{mouse})(1,:),Cont.(State1{4}).(Mouse_names{mouse})(2,:),'b','linewidth',2)
    makepretty
    title(Mouse_names{mouse})
end

% dscatter
for mouse=1:length(Mouse)
    figure
    HRAxes=dscatter(log10(DataEMG_Filtered.Fear.(State1{3}).(Mouse_names{mouse})(bin:bin:end)) , Respi_Rythm2.Fear.(State1{3}).(Mouse_names{mouse})(bin:bin:end),'smoothing',7);
    colormap hot
    freezeColors
    hold on
    HRAxes=dscatter(log10(DataEMG_Filtered.Fear.(State1{4}).(Mouse_names{mouse})(bin:bin:end)) , Respi_Rythm2.Fear.(State1{4}).(Mouse_names{mouse})(bin:bin:end),'smoothing',7);
    colormap cool
    makepretty
    xlabel('EMG power (a.u.)'); ylim([0 8])
    ylabel('OB frequency (Hz)')
end






% Calculating data for each mouse
for mouse=1:length(Mouse_names)
    for sess=1:length(Session_type)-1
        
        if sess==1
            Epoch_to_use=FearSess.(Mouse_names{mouse});
        elseif sess==2
            Epoch_to_use=CondSess.(Mouse_names{mouse});
        elseif sess==3
            Epoch_to_use=ExtSess.(Mouse_names{mouse});
        end
        try
            EMG.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(Epoch_to_use,'emg');
            OBSpec.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(Epoch_to_use,'spectrum','prefix','B_Low');
            HighOBSpec.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(Epoch_to_use,'spectrum','prefix','B_High');
            
            Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(Epoch_to_use,'Epoch','epochname','freezeepoch');
            ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(Epoch_to_use,'Epoch','epochname','zoneepoch');
            
            ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){1};
            SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = or(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){2},ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){5});
            
            TotEpoch.(Session_type{sess}).(Mouse_names{mouse}) = intervalSet(0,max(Range(ConcatenateDataFromFolders_SB(Epoch_to_use,'accelero'))));
            NonFreeze_Epoch.(Session_type{sess}).(Mouse_names{mouse})=TotEpoch.(Session_type{sess}).(Mouse_names{mouse})-Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse});
            
            EMG.(Session_type{sess}).Active.(Mouse_names{mouse})=Restrict(EMG.(Session_type{sess}).(Mouse_names{mouse}),NonFreeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}));
            EMG.(Session_type{sess}).Fz.(Mouse_names{mouse})=Restrict(EMG.(Session_type{sess}).(Mouse_names{mouse}),Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}));
            EMG.(Session_type{sess}).Fz_Shock.(Mouse_names{mouse})=Restrict(EMG.(Session_type{sess}).Fz.(Mouse_names{mouse}),ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}) );
            EMG.(Session_type{sess}).Fz_Safe.(Mouse_names{mouse})=Restrict(EMG.(Session_type{sess}).Fz.(Mouse_names{mouse}),SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}));
            
            OBSpec.(Session_type{sess}).Active.(Mouse_names{mouse})=Restrict(OBSpec.(Session_type{sess}).(Mouse_names{mouse}),NonFreeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}));
            OBSpec.(Session_type{sess}).Fz.(Mouse_names{mouse})=Restrict(OBSpec.(Session_type{sess}).(Mouse_names{mouse}),Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}));
            OBSpec.(Session_type{sess}).Fz_Shock.(Mouse_names{mouse})=Restrict(OBSpec.(Session_type{sess}).Fz.(Mouse_names{mouse}),ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}) );
            OBSpec.(Session_type{sess}).Fz_Safe.(Mouse_names{mouse})=Restrict(OBSpec.(Session_type{sess}).Fz.(Mouse_names{mouse}),SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}));
            
            HighOBSpec.(Session_type{sess}).Active.(Mouse_names{mouse})=Restrict(HighOBSpec.(Session_type{sess}).(Mouse_names{mouse}),NonFreeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}));
            HighOBSpec.(Session_type{sess}).Fz.(Mouse_names{mouse})=Restrict(HighOBSpec.(Session_type{sess}).(Mouse_names{mouse}),Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}));
            HighOBSpec.(Session_type{sess}).Fz_Shock.(Mouse_names{mouse})=Restrict(HighOBSpec.(Session_type{sess}).Fz.(Mouse_names{mouse}),ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}) );
            HighOBSpec.(Session_type{sess}).Fz_Safe.(Mouse_names{mouse})=Restrict(HighOBSpec.(Session_type{sess}).Fz.(Mouse_names{mouse}),SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}));
            
            for state=1:length(State1)
                Respi_Rythm.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})=ConvertSpectrum_in_Frequencies_BM(Spectro{3} , Range(OBSpec.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})) , Data(OBSpec.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})));
                Respi_Rythm2.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})=interp1(Range(Respi_Rythm.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})) , Data(Respi_Rythm.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})) , Range(EMG.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})));
                
                DataHighOBSpec.(State1{state}) = Data(HighOBSpec.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})); [Gamma_Power.(Session_type{sess}).(State1{state}).(Mouse_names{mouse}),b] = max(DataHighOBSpec.(State1{state})(:,10:25)');
                
                Gamma_Power2.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})=interp1(Range(HighOBSpec.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})) , Gamma_Power.(Session_type{sess}).(State1{state}).(Mouse_names{mouse}) , Range(EMG.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})));
                DataEMG.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})=Data(EMG.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})); DataEMG.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})(DataEMG.(Session_type{sess}).(State1{state}).(Mouse_names{mouse})==0)=NaN;
            end
        end
    end
    disp(Mouse_names{mouse})
end


