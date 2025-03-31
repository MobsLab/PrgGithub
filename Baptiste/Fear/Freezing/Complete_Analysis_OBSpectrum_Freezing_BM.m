

Cols = {[1 0 0],[0 0 1]};
X = [1,2];
Legends = {'Saline','Chronic Flx'};

%% Mean OB Spectrum

GetEmbReactMiceFolderList_BM

Session_type={'Fear','Cond','Ext'};
Restrain={'All','Free','Blocked'};

for sess=1:3%:length(Session_type) % generate all data required for analyses
    for res=1%:length(Restrain)
        
        if sess==1
            FolderList=FearSess;
        elseif sess==2
            FolderList=CondSess;
        elseif sess==3
            FolderList=ExtSess;
        end
        
        for mouse = 1:length(Mouse_names)
            try
                OBSpec_Prelim=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'spectrum','prefix','B_Low');
                Freeze_Epoch_Prelim=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'Epoch','epochname','freezeepoch');
                ZoneEpoch_Prelim=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'Epoch','epochname','zoneepoch');
                BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'Epoch','epochname','blockedepoch');
                TotEpoch.(Session_type{sess}).(Mouse_names{mouse})=intervalSet(0,max(Range(OBSpec_Prelim)));
                Non_BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse})=TotEpoch.(Session_type{sess}).(Mouse_names{mouse})-BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse});
                if res==1
                    OBSpecConcat.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse})=OBSpec_Prelim;
                    FreezeEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse})=Freeze_Epoch_Prelim;
                    ZoneEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse})=ZoneEpoch_Prelim;
                elseif res==2
                    OBSpecConcat.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}) = Restrict( OBSpec_Prelim , Non_BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) );
                    FreezeEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}) = and(Freeze_Epoch_Prelim , Non_BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}));
                    for zones=1:5; ZoneEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}){zones} = and(ZoneEpoch_Prelim{zones} , Non_BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse})); end
                elseif res==3
                    OBSpecConcat.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}) = Restrict( OBSpec_Prelim , BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) );
                    FreezeEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}) = and(Freeze_Epoch_Prelim , BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}));
                    for zones=1:5; ZoneEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}){zones} = and(ZoneEpoch_Prelim{zones} , BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse})); end
                end
                ShockEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}) = ZoneEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}){1};
                SafeEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}) = or(ZoneEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}){2},ZoneEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}){5});
                
                OB_Freeze.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}) = Restrict(OBSpecConcat.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}),FreezeEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}));
                OB_Freeze.(Session_type{sess}).(Restrain{res}).Shock.(Mouse_names{mouse}) = Restrict(OB_Freeze.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}),ShockEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}));
                OB_Freeze.(Session_type{sess}).(Restrain{res}).Safe.(Mouse_names{mouse}) = Restrict(OB_Freeze.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}),SafeEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}));
                
            end
            Mouse_names{mouse}
        end
    end
end

cd(CondSess.M666{1})
% group all data in drugs groups

load('B_Low_Spectrum.mat')
OBSpectrumCorrections_PreBM

% actual maxima for mean OB spetrums for saline
MaxShock=4.501; MaxSafe=2.823;
[thr_1,thr_2,thr_3,thr_4]=FrequencyThresholdSpectro_BM(MaxSafe-0.5,MaxSafe+0.5,MaxShock-0.5,MaxShock+0.5,Spectro{3});

Drug_Group={'Saline','ChronicFlx','AcuteFlx','Midazolam','BM','NewSal'};
noise_thr=12;
for group=1:length(Drug_Group)
    
    if group==1 % saline mice
        Mouse=[688 739 777 779 849 893 1096];
    elseif group==2 % chronic flx mice
        Mouse=[875 876 877 1001 1002 1095];
    elseif group==3 % Acute Flx
        Mouse=[740 750 775 778 794];
    elseif group==4 % midazolam mice
        Mouse=[829 851 857 858 859 1005 1006];
    elseif group==5 % BM mice
        Mouse=[1184 1205 1224 1225 1226 11225 11226];
    end
    
    for sess=1%:length(Session_type)
        for res=1%:length(Restrain)
            for mouse=1:length(Mouse)
                Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
                try
                    AllSpectrum.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Shock(mouse,:) = nanmean(zscore_nan_BM(Data(OB_Freeze.(Session_type{sess}).(Restrain{res}).Shock.(Mouse_names{mouse}))')') ;
                    [PowerMax.(Session_type{sess}).(Restrain{res}).Shock.(Mouse_names{mouse}),FreqMax.(Session_type{sess}).(Restrain{res}).Shock.(Mouse_names{mouse})]=max(AllSpectrum.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Shock(mouse,noise_thr:end));
                    FreqMax.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Shock(mouse) = Spectro{3}(FreqMax.(Session_type{sess}).(Restrain{res}).Shock.(Mouse_names{mouse})+noise_thr);
                    clear Mean_All_Sp; Mean_All_Sp=nanmean(Data(OB_Freeze.(Session_type{sess}).(Restrain{res}).Shock.(Mouse_names{mouse})));
                    AUC.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Shock2_4(mouse) =sum(Mean_All_Sp(thr_1:thr_2-1)/max(Mean_All_Sp));
                    AUC.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Shock4_6(mouse) =sum(Mean_All_Sp(thr_3:thr_4-1)/max(Mean_All_Sp));
                    
                    AllSpectrum.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Safe(mouse,:) = nanmean(zscore_nan_BM(Data(OB_Freeze.(Session_type{sess}).(Restrain{res}).Safe.(Mouse_names{mouse}))')') ;
                    [PowerMax.(Session_type{sess}).(Restrain{res}).Safe.(Mouse_names{mouse}),FreqMax.(Session_type{sess}).(Restrain{res}).Safe.(Mouse_names{mouse})]=max(AllSpectrum.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Safe(mouse,noise_thr:end));
                    FreqMax.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Safe(mouse) = Spectro{3}(FreqMax.(Session_type{sess}).(Restrain{res}).Safe.(Mouse_names{mouse})+noise_thr);
                    clear Mean_All_Sp; Mean_All_Sp=nanmean(Data(OB_Freeze.(Session_type{sess}).(Restrain{res}).Safe.(Mouse_names{mouse})));
                    AUC.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Safe2_4(mouse) =sum(Mean_All_Sp(thr_1:thr_2-1)/max(Mean_All_Sp));
                    AUC.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Safe4_6(mouse) =sum(Mean_All_Sp(thr_3:thr_4-1)/max(Mean_All_Sp));
                    
                end
                FreqMax.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Safe(FreqMax.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Safe==1.068115234375)=NaN;
                FreqMax.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Shock(FreqMax.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Shock==1.068115234375)=NaN;
            end
        end
    end
end
OBSpectrumCorrectionsBM

%% Figure of each mouse of each group

sess=1; % choose if you want to study fear (1), cond (2) or ext (3) sessions
res=1; % choose if you want to study all (1), free (2) or blocked (3) conditions
for group=1:length(Drug_Group)
    
    if group==1 % saline mice
        Mouse=[688 739 777 779 849 893 1096 ];
    elseif group==2 % chronic flx mice
        Mouse=[875 876 877 1001 1002 1095];
    elseif group==3 % Acute Flx
        Mouse=[740 750 775 778 794];
    elseif group==4 % midazolam mice
        Mouse=[829 851 857 858 859 1005 1006];
    elseif group==5 % classic mice
        Mouse=[1184 1205 1224 1225 1226 11225 11226];
    end
    
    figure
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        subplot(221)
        plot(Spectro{3},nanmean(Data(OB_Freeze.(Session_type{sess}).(Restrain{res}).Shock.(Mouse_names{mouse})))/max(nanmean(Data(OB_Freeze.(Session_type{sess}).(Restrain{res}).Shock.(Mouse_names{mouse})))),'r','linewidth',2); hold on
        xlim([0 10]); ylim([0 1.2]); makepretty; xlabel('Frequency (Hz)'); ylabel('Power (A.U.)')
        title('Shock side freezing')
        subplot(222)
        plot(Spectro{3},nanmean(Data(OB_Freeze.(Session_type{sess}).(Restrain{res}).Safe.(Mouse_names{mouse})))/max(nanmean(Data(OB_Freeze.(Session_type{sess}).(Restrain{res}).Safe.(Mouse_names{mouse})))),'b','linewidth',2); hold on
        xlim([0 10]); ylim([0 1.2]); makepretty; xlabel('Frequency (Hz)');
        title('Safe side freezing')
    end
    
    a=subplot(223); a.Position=[0.25 0.1 0.5 0.4];
    Conf_Inter=nanstd(AllSpectrum.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Shock)/sqrt(size(AllSpectrum.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Shock,1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(AllSpectrum.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Shock);
    shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-r',1); hold on;
    Conf_Inter=nanstd(AllSpectrum.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Safe)/sqrt(size(AllSpectrum.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Safe,1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(AllSpectrum.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Safe);
    h=shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-b',1); hold on;
    makepretty;
    xlabel('Frequency (Hz)'); ylabel('Power (A.U.)'); xlim([0 10]);
    [c,d]=max(nanmean(AllSpectrum.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Shock));
    vline(Spectro{3}(d),'--r')
    [c,d]=max(nanmean(AllSpectrum.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Safe(:,26:end)));
    vline(Spectro{3}(d+25),'--b')
    f=get(gca,'Children');
    legend([f(5),f(1)],'Shock side freezing','Safe side freezing')
    title('mean OB spectrum for all mice')
    
end

a=suptitle('Mean OB spectrum during freezing, ext sessions, saline n=11'); a.FontSize=20;
a=suptitle('Mean OB spectrum during freezing, ext sessions, chronic flx n=8'); a.FontSize=20;
a=suptitle('Mean OB spectrum during freezing, classic mice n=5'); a.FontSize=20;

PeakSpectrumAnalysis_Freezing_BM

figure
for group=1:5
    
    subplot(1,5,group)
    MakeSpreadAndBoxPlot2_SB({FreqMax.(Drug_Group{group}).Fear.All.Shock , FreqMax.(Drug_Group{group}).Fear.All.Safe},Cols,X,Legends,'showpoints',0); makepretty; xtickangle(45);
    title(Drug_Group{group}); ylim([1 6])
    if group==1; ylabel('Frequency (Hz)'); end
    
end
%% Saline and chronic fluo comparison, OB max
% Plot parameters
Cols = {[1 0.5 0.5],[0.5 0.5 1]};
X = [1,2];
Legends = {'Shock','Safe'};

figure
subplot(321)
Conf_Inter=nanstd(AllSpectrum.Saline.(Session_type{sess}).All.Shock)/sqrt(size(AllSpectrum.Saline.(Session_type{sess}).All.Shock,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(AllSpectrum.Saline.(Session_type{sess}).All.Shock);
shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-r',1); hold on;
Conf_Inter=nanstd(AllSpectrum.ChronicFlx.(Session_type{sess}).All.Shock)/sqrt(size(AllSpectrum.ChronicFlx.(Session_type{sess}).All.Shock,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(AllSpectrum.ChronicFlx.(Session_type{sess}).All.Shock);
h=shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-r',1); hold on;
h.mainLine.Color=[0.7 0 0]; h.patch.FaceColor=[1 0.6 0.6];
makepretty;
xlabel('Frequency (Hz)'); ylabel('Power (A.U.)'); xlim([0 10]); ylim([-0.3 1.2])
[c,d]=max(nanmean(AllSpectrum.Saline.(Session_type{sess}).All.Shock));
vline(Spectro{3}(d),'--r')
[c,d]=max(nanmean(AllSpectrum.ChronicFlx.(Session_type{sess}).All.Shock));
vline(Spectro{3}(d),'-r')
f=get(gca,'Children');
legend([f(5),f(1)],'Saline','Chronic fluoxetine')
title('Shock side')

subplot(322)
Conf_Inter=nanstd(AllSpectrum.Saline.(Session_type{sess}).All.Safe)/sqrt(size(AllSpectrum.Saline.(Session_type{sess}).All.Safe,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(AllSpectrum.Saline.(Session_type{sess}).All.Safe);
shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-b',1); hold on;
Conf_Inter=nanstd(AllSpectrum.ChronicFlx.(Session_type{sess}).All.Safe)/sqrt(size(AllSpectrum.ChronicFlx.(Session_type{sess}).All.Safe,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(AllSpectrum.ChronicFlx.(Session_type{sess}).All.Safe);
k=shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-b',1); hold on;
k.mainLine.Color=[0 0 0.5]; k.patch.FaceColor=[1 1 1];
xlim([0 10]); ylim([-0.3 1.2]); makepretty
xlabel('Frequency (Hz)'); xlim([0 10])
[c,d]=max(nanmean(AllSpectrum.Saline.(Session_type{sess}).All.Safe(:,26:end)));
vline(Spectro{3}(d+25),'--b')
[c,d]=max(nanmean(AllSpectrum.ChronicFlx.(Session_type{sess}).All.Safe));
vline(Spectro{3}(d),'-b')
f=get(gca,'Children');
legend([f(5),f(1)],'Saline','Chronic fluoxetine')
title('Safe side')

a=subplot(345); a.Position=[0.1300 0.4 0.1566 0.2052];
MakeSpreadAndBoxPlot2_SB({FreqMax.Saline.Fear.All.Shock,FreqMax.Saline.Fear.All.Safe},Cols,X,Legends,'showpoints',0); makepretty; xtickangle(45);
title('Saline');  ylabel('Frequency (Hz)');

a=subplot(349); a.Position=[0.1300 0.1 0.1566 0.2052];
MakeSpreadAndBoxPlot2_SB({FreqMax.ChronicFlx.Fear.All.Shock,FreqMax.ChronicFlx.Fear.All.Safe},Cols,X,Legends,'showpoints',0);
makepretty; xtickangle(45); title('Chronic Flx'); ylabel('Frequency (Hz)');

% other way
Figure_to_use(:,1)=FreqMax.Saline.Fear.All.Shock;
Figure_to_use(:,2)=FreqMax.Saline.Fear.All.Safe;
Figure_to_use(1:7,3)=FreqMax.ChronicFlx.Fear.All.Shock;
Figure_to_use(1:7,4)=FreqMax.ChronicFlx.Fear.All.Safe;
Figure_to_use(Figure_to_use==0)=NaN;

a=subplot(346); a.Position=[0.3361 0.1096 0.1566 0.4157];
[pval,hb,eb]=PlotErrorBoxPlotN_BM(Figure_to_use,'paired',0,'newfig',0,'showpoints',1); makepretty; set(hb, 'linewidth' ,2)
xticks([1 2 3 4]); xticklabels({'Saline Shock','Saline Safe','Chr flx Shock','Chr flx Safe'}); xtickangle(45);
xtickangle(45); ylim([0 7])
ylabel('Frequency (Hz)');

%a=suptitle('Mean OB spectrum maximum analysis'); a.FontSize=20;


%% Area Under Curve (AUC)

% example figure
Mouse_names={'M849'}; mouse=1;

figure
subplot(121)
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data(OB_Freeze.Fear.All.Shock.(Mouse_names{mouse})));
plot(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),'r','linewidth',2); hold on
xlim([0 10]); ylim([0 1.2]); makepretty; xlabel('Frequency (Hz)'); ylabel('Power (A.U.)')

bar(Spectro{3}(thr_1:thr_2-1),Mean_All_Sp(thr_1:thr_2-1)/max(Mean_All_Sp))
bar(Spectro{3}(thr_3:thr_4-1),Mean_All_Sp(thr_3:thr_4-1)/max(Mean_All_Sp))


subplot(122)
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data(OB_Freeze.Fear.All.Safe.(Mouse_names{mouse})));
plot(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),'b','linewidth',2); hold on
xlim([0 10]); ylim([0 1.2]); makepretty; xlabel('Frequency (Hz)'); ylabel('Power (A.U.)')

bar(Spectro{3}(thr_1:thr_2-1),Mean_All_Sp(thr_1:thr_2-1)/max(Mean_All_Sp))
bar(Spectro{3}(thr_3:thr_4-1),Mean_All_Sp(thr_3:thr_4-1)/max(Mean_All_Sp))

% All mice
A1=(AUC.Saline.Fear.All.Shock2_4 - AUC.Saline.Fear.All.Shock4_6)./(AUC.Saline.Fear.All.Shock2_4 + AUC.Saline.Fear.All.Shock4_6);
A2=(AUC.Saline.Fear.All.Safe2_4 - AUC.Saline.Fear.All.Safe4_6)./(AUC.Saline.Fear.All.Safe2_4 + AUC.Saline.Fear.All.Safe4_6);
A3=(AUC.AcuteFlx.Fear.All.Shock2_4 - AUC.AcuteFlx.Fear.All.Shock4_6)./(AUC.AcuteFlx.Fear.All.Shock2_4 + AUC.AcuteFlx.Fear.All.Shock4_6);
A4=(AUC.AcuteFlx.Fear.All.Safe2_4 - AUC.AcuteFlx.Fear.All.Safe4_6)./(AUC.AcuteFlx.Fear.All.Safe2_4 + AUC.AcuteFlx.Fear.All.Safe4_6);
A5=(AUC.ChronicFlx.Fear.All.Shock2_4 - AUC.ChronicFlx.Fear.All.Shock4_6 ) ./ (AUC.ChronicFlx.Fear.All.Shock2_4 + AUC.ChronicFlx.Fear.All.Shock4_6 );
A6=(AUC.ChronicFlx.Fear.All.Safe2_4 - AUC.ChronicFlx.Fear.All.Safe4_6) ./ (AUC.ChronicFlx.Fear.All.Safe2_4 + AUC.ChronicFlx.Fear.All.Safe4_6);


a=subplot(347); a.Position=[0.5722 0.4 0.1566 0.2052];
MakeSpreadAndBoxPlot2_SB({A1,A2},Cols,X,Legends,'showpoints',0); makepretty; xtickangle(45);
title('Saline'); hline(0,'--k'); ylabel('Ratio AUC')

a=subplot(3,4,11); a.Position=[0.5722 0.1 0.1566 0.2052];
MakeSpreadAndBoxPlot2_SB({A5,A6},Cols,X,Legends,'showpoints',0); makepretty; xtickangle(45);
title('Chronic Flx'); hline(0,'--k'); ylabel('Ratio AUC')


B=[A1' A2']; B(1:5,3)=A3' ; B(1:5,4)=A4' ; B(1:7,5)=A5' ; B(1:7,6)=A6'; B(B==0)=NaN;

a=subplot(3,4,12); a.Position=[0.7800 0.1096 0.1566 0.4157];
[pval,hb,eb]=PlotErrorBoxPlotN_BM(B(:,[1 2 5 6]),'showpoints',1,'paired',0,'newfig',0,'optiontest','ttest'); makepretty; set(hb, 'linewidth' ,2)
xticks([1 2 3 4]); xticklabels({'Saline Shock','Saline Safe','Chr flx Shock','Chr flx Safe'}); xtickangle(45);
ylabel('Ratio AUC')


a=suptitle('UMaze drugs experiments, mean OB spectrum analysis, chonic flx and saline mice'); a.FontSize=20;




%% Heart rate
Mouse=[666 668 688 739 777 779 849 893 1096 1134 1135 875 876 877 1001 1002 1095 1131 1130 740 750 775 778 794 829 851 856 857 858 859 1005 1006 561 567 568 566 569];
for mouse = 1:length(Mouse) % generate all sessions of interest
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
end

Session_type={'Fear','Cond','Ext'};
Restrain={'All','Free','Blocked'};

for sess=1%:length(Session_type) % generate all data required for analyses
    for res=1%:length(Restrain)
        
        if sess==1
            FolderList=FearSess;
        elseif sess==2
            FolderList=CondSess;
        elseif sess==3
            FolderList=ExtSess;
        end
        
        for mouse = 1:length(Mouse_names)
            
            try
                HR_Prelim=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'heartrate');
                HRVar_Prelim=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'heartratevar');
                Freeze_Epoch_Prelim=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'Epoch','epochname','freezeepoch');
                ZoneEpoch_Prelim=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'Epoch','epochname','zoneepoch');
                
                if res==1
                    HRConcat.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse})=HR_Prelim;
                    HRVarConcat.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse})=HRVar_Prelim;
                    FreezeEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse})=Freeze_Epoch_Prelim;
                    ZoneEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse})=ZoneEpoch_Prelim;
                elseif res==2
                    HRConcat.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}) = Restrict( HR_Prelim , Non_BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) );
                    HRVarConcat.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}) = Restrict( HRVar_Prelim , Non_BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) );
                    FreezeEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}) = and(Freeze_Epoch_Prelim , Non_BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}));
                    for zones=1:5; ZoneEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}){zones} = and(ZoneEpoch_Prelim{zones} , Non_BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse})); end
                elseif res==3
                    HRConcat.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}) = Restrict( HR_Prelim , BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) );
                    HRVarConcat.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}) = Restrict( HRVar_Prelim , BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) );
                    FreezeEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}) = and(Freeze_Epoch_Prelim , BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}));
                    for zones=1:5; ZoneEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}){zones} = and(ZoneEpoch_Prelim{zones} , BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse})); end
                end
                
                ShockEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}) = ZoneEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}){1};
                SafeEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}) = or(ZoneEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}){2},ZoneEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}){5});
                
                HR_Freeze.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}) = Restrict(HRConcat.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}),FreezeEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}));
                HR_Freeze.(Session_type{sess}).(Restrain{res}).Shock.(Mouse_names{mouse}) = Restrict(HR_Freeze.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}),ShockEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}));
                HR_Freeze.(Session_type{sess}).(Restrain{res}).Safe.(Mouse_names{mouse}) = Restrict(HR_Freeze.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}),SafeEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}));
                
                HRVar_Freeze.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}) = Restrict(HRVarConcat.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}),FreezeEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}));
                HRVar_Freeze.(Session_type{sess}).(Restrain{res}).Shock.(Mouse_names{mouse}) = Restrict(HRVar_Freeze.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}),ShockEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}));
                HRVar_Freeze.(Session_type{sess}).(Restrain{res}).Safe.(Mouse_names{mouse}) = Restrict(HRVar_Freeze.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}),SafeEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}));
                
            catch
            end
            
        end
    end
end


Drug_Group={'Saline','ChronicFlx','AcuteFlx','Midazolam','Eyelid'};
noise_thr=12;
for group=1:length(Drug_Group)
    
    if group==1 % saline mice
        Mouse_names={'M666','M668','M688','M739','M777','M779','M849','M893','M1096','M1134','M1135'};
        Mouse=[666 668 688 739 777 779 849 893 1096 1134 1135];
    elseif group==2 % chronic flx mice
        Mouse_names={'M875','M876','M877','M1001','M1002','M1095','M1130','M1131'};
        Mouse=[875 876 877 1001 1002 1095 1130 1131];
    elseif group==3 % Acute Flx
        Mouse_names={'M740','M750','M775','M778','M794'};
        Mouse=[740 750 775 778 794];
    elseif group==4 % midazolam mice
        Mouse_names={'M829','M851','M857','M858','M859','M1005','M1006'};
        Mouse=[829 851 857 858 859 1005 1006];
    elseif group==5 % classic mice
        Mouse_names={'M561','M566','M567','M568','M569'};
        Mouse=[561 566 567 568 569];
    end
    
    for sess=1:length(Session_type)
        for res=1:length(Restrain)
            for mouse=1:length(Mouse_names)
                try
                    All_HR.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Shock(mouse,:) = nanmean(Data(HR_Freeze.(Session_type{sess}).(Restrain{res}).Shock.(Mouse_names{mouse})));
                    All_HR.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Safe(mouse,:) = nanmean(Data(HR_Freeze.(Session_type{sess}).(Restrain{res}).Safe.(Mouse_names{mouse})));
                    
                    All_HRVar.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Shock(mouse,:) = nanmean(Data(HRVar_Freeze.(Session_type{sess}).(Restrain{res}).Shock.(Mouse_names{mouse})));
                    All_HRVar.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Safe(mouse,:) = nanmean(Data(HRVar_Freeze.(Session_type{sess}).(Restrain{res}).Safe.(Mouse_names{mouse})));
                end
            end
        end
    end
end
All_HR.Saline.Fear.All.Shock(8)=NaN;  All_HR.Saline.Fear.All.Safe(8)=NaN;
All_HRVar.Saline.Fear.All.Shock(8)=NaN;  All_HRVar.Saline.Fear.All.Safe(8)=NaN;
All_HR.Saline.Fear.All.Shock(9)=NaN;  All_HR.Saline.Fear.All.Safe(9)=NaN;
All_HRVar.Saline.Fear.All.Shock(9)=NaN;  All_HRVar.Saline.Fear.All.Safe(9)=NaN;


%% figures HR

figure
for group=1:5
    
    subplot(1,5,group)
    MakeSpreadAndBoxPlot2_SB({All_HR.(Drug_Group{group}).Fear.All.Shock , All_HR.(Drug_Group{group}).Fear.All.Safe},Cols,X,Legends,'showpoints',0); makepretty; xtickangle(45);
    title(Drug_Group{group}); ylim([7 13])
    if group==1; ylabel('Frequency (Hz)'); end
    
end

for group=1:5
    
    subplot(2,5,group+5)
    MakeSpreadAndBoxPlot2_SB({All_HRVar.(Drug_Group{group}).Fear.All.Shock , All_HRVar.(Drug_Group{group}).Fear.All.Safe},Cols,X,Legends,'showpoints',0); makepretty; xtickangle(45);
    if group==1; ylabel('Variability'); end
    
end

a=suptitle('Heart rate and variability during freezing, UMaze drugs experiments'); a.FontSize=20;
c=text(-17.2,0.48,'Heart rate','FontSize',24); set(c,'Rotation',90);
d=text(-17.2,0.05,'Heart rate variability','FontSize',20); set(d,'Rotation',90);

% Saline and Chronic flx
figure
a=subplot(241); a.Position=[0.1 0.5 0.15 0.3];
MakeSpreadAndBoxPlot2_SB({[All_HR.Saline.Fear.All.Shock ; All_HR.Eyelid.Fear.All.Shock] , [All_HR.Saline.Fear.All.Safe ; All_HR.Eyelid.Fear.All.Safe] },Cols,X,Legends,'showpoints',0); makepretty; xtickangle(45);
title('Saline'); ylim([7 13]); ylabel('Frequency (Hz)')

a=subplot(242); a.Position=[0.3 0.5 0.15 0.3]; group=2;
MakeSpreadAndBoxPlot2_SB({All_HR.(Drug_Group{group}).Fear.All.Shock , All_HR.(Drug_Group{group}).Fear.All.Safe},Cols,X,Legends,'showpoints',0); makepretty; xtickangle(45);
title('Chronic Flx'); ylim([7 13])

a=subplot(243); a.Position=[0.6 0.5 0.15 0.3];
MakeSpreadAndBoxPlot2_SB({[All_HRVar.Saline.Fear.All.Shock ; All_HRVar.Eyelid.Fear.All.Shock] , [All_HRVar.Saline.Fear.All.Safe ; All_HRVar.Eyelid.Fear.All.Safe] },Cols,X,Legends,'showpoints',0); makepretty; xtickangle(45);
title('Saline'); ylabel('Variability') %ylim([7 13])

a=subplot(244); a.Position=[0.8 0.5 0.15 0.3]; group=2;
MakeSpreadAndBoxPlot2_SB({All_HRVar.(Drug_Group{group}).Fear.All.Shock , All_HRVar.(Drug_Group{group}).Fear.All.Safe},Cols,X,Legends,'showpoints',0); makepretty; xtickangle(45);
title('Chronic Flx'); %ylim([7 13])

a=suptitle('Heart rate and heart rate variability during freezing, UMaze drugs experiments'); a.FontSize=20;
txt = '----------------------------------------------------------------------------------------';
b=text(-6,-4.3,txt,'FontSize',24); set(b,'Rotation',90);
c=text(-12,1.8,'Heart rate','FontSize',24); d=text(-3,1.8,'Heart rate variability','FontSize',24);

DrugGroupsHR=[[All_HR.Saline.Fear.All.Shock ; All_HR.Eyelid.Fear.All.Shock]  [All_HR.Saline.Fear.All.Safe ; All_HR.Eyelid.Fear.All.Safe]];
DrugGroupsHR(1:8,3)=All_HR.ChronicFlx.Fear.All.Shock; DrugGroupsHR(1:8,4)=All_HR.ChronicFlx.Fear.All.Safe;
DrugGroupsHR(DrugGroupsHR==0)=NaN;

a=subplot(245); a.Position=[0.15 0.05 0.3 0.3];
[pval,hb,eb]=PlotErrorBoxPlotN_BM(DrugGroupsHR,'showpoints',1,'paired',0,'newfig',0); makepretty; set(hb, 'linewidth' ,2)
xticks([1 2 3 4 5 6]); xticklabels({'Saline Shock','Saline Safe','Chr flx Shock','Chr flx Safe'}); xtickangle(45);
ylabel('Frequency (Hz)'); ylim([7 13.5])

DrugGroupsHRVar=[[All_HRVar.Saline.Fear.All.Shock ; All_HRVar.Eyelid.Fear.All.Shock]  [All_HRVar.Saline.Fear.All.Safe ; All_HRVar.Eyelid.Fear.All.Safe]];
DrugGroupsHRVar(1:8,3)=All_HRVar.ChronicFlx.Fear.All.Shock; DrugGroupsHRVar(1:8,4)=All_HRVar.ChronicFlx.Fear.All.Safe;
DrugGroupsHRVar(DrugGroupsHRVar==0)=NaN;

a=subplot(247); a.Position=[0.6 0.05 0.3 0.3];
[pval,hb,eb]=PlotErrorBoxPlotN_BM(DrugGroupsHRVar,'showpoints',1,'paired',0,'newfig',0); makepretty; set(hb, 'linewidth' ,2)
xticks([1 2 3 4 5 6]); xticklabels({'Saline Shock','Saline Safe','Chr flx Shock','Chr flx Safe'}); xtickangle(45);
ylabel('Frequency (Hz)'); %ylim([7 13.5])




%% Comparing the differents freezing in a drug group, restrain is still

Drug_Group={'Saline','ChronicFlx','AcuteFlx','Midazolam','Eyelid'};
noise_thr=12;
for group=1:2%length(Drug_Group)
    
    if group==1 % saline mice
        Mouse_names={'M666','M668','M688','M739','M777','M779','M849','M893','M1096'}; % add 1096
        Mouse=[666 668 688 739 777 779 849 893 1096];
    elseif group==2 % chronic flx mice
        Mouse_names={'M875','M876','M877','M1001','M1002','M1095','M1130'};
        Mouse=[875 876 877 1001 1002 1095 1130];
    elseif group==3 % Acute Flx
        Mouse_names={'M740','M750','M775','M778','M794'};
        Mouse=[740 750 775 778 794];
    elseif group==4 % midazolam mice
        Mouse_names={'M829','M851','M857','M858','M859','M1005','M1006'};
        Mouse=[829 851 857 858 859 1005 1006];
    elseif group==5 % classic mice
        Mouse_names={'M561','M566','M567','M568','M569'};
        Mouse=[561 566 567 568 569];
    end
    
    for mouse=1:length(Mouse_names)
        TimeFz.(Drug_Group{group})(mouse)=sum(Stop(FreezeEpoch.Fear.All.(Mouse_names{mouse}))-Start(FreezeEpoch.Fear.All.(Mouse_names{mouse})));
        TotalTime.(Drug_Group{group})(mouse) = sum(Stop(TotEpoch.Fear.(Mouse_names{mouse}))-Start(TotEpoch.Fear.(Mouse_names{mouse})));
        
        TimeFzCond.(Drug_Group{group})(mouse)=sum(Stop(FreezeEpoch.Cond.All.(Mouse_names{mouse}))-Start(FreezeEpoch.Cond.All.(Mouse_names{mouse})));
        TimeFzExt.(Drug_Group{group})(mouse)=sum(Stop(FreezeEpoch.Ext.All.(Mouse_names{mouse}))-Start(FreezeEpoch.Ext.All.(Mouse_names{mouse})));
        TotalTimeCond.(Drug_Group{group})(mouse)=sum(Stop(TotEpoch.Cond.(Mouse_names{mouse}))-Start(TotEpoch.Cond.(Mouse_names{mouse})));
        TotalTimeExt.(Drug_Group{group})(mouse)=sum(Stop(TotEpoch.Ext.(Mouse_names{mouse}))-Start(TotEpoch.Ext.(Mouse_names{mouse})));
        
        TimeFzCondShock.(Drug_Group{group})(mouse)=sum(Stop(and(FreezeEpoch.Cond.All.(Mouse_names{mouse}),ShockEpoch.Cond.All.(Mouse_names{mouse})))-Start(and(FreezeEpoch.Cond.All.(Mouse_names{mouse}),ShockEpoch.Cond.All.(Mouse_names{mouse}))));
        TimeFzExtShock.(Drug_Group{group})(mouse)=sum(Stop(and(FreezeEpoch.Ext.All.(Mouse_names{mouse}),ShockEpoch.Ext.All.(Mouse_names{mouse})))-Start(and(FreezeEpoch.Ext.All.(Mouse_names{mouse}),ShockEpoch.Ext.All.(Mouse_names{mouse}))));
        
        TimeFzCondSafe.(Drug_Group{group})(mouse)=sum(Stop(and(FreezeEpoch.Cond.All.(Mouse_names{mouse}),SafeEpoch.Cond.All.(Mouse_names{mouse})))-Start(and(FreezeEpoch.Cond.All.(Mouse_names{mouse}),SafeEpoch.Cond.All.(Mouse_names{mouse}))));
        TimeFzExtSafe.(Drug_Group{group})(mouse)=sum(Stop(and(FreezeEpoch.Ext.All.(Mouse_names{mouse}),SafeEpoch.Ext.All.(Mouse_names{mouse})))-Start(and(FreezeEpoch.Ext.All.(Mouse_names{mouse}),SafeEpoch.Ext.All.(Mouse_names{mouse}))));
        
        TotalTimeCondShock.(Drug_Group{group})(mouse)=sum(Stop(and(TotEpoch.Cond.(Mouse_names{mouse}),ShockEpoch.Cond.All.(Mouse_names{mouse})))-Start(and(TotEpoch.Cond.(Mouse_names{mouse}),ShockEpoch.Cond.All.(Mouse_names{mouse}))));
        TotalTimeExtShock.(Drug_Group{group})(mouse)=sum(Stop(and(TotEpoch.Ext.(Mouse_names{mouse}),ShockEpoch.Ext.All.(Mouse_names{mouse})))-Start(and(TotEpoch.Ext.(Mouse_names{mouse}),ShockEpoch.Ext.All.(Mouse_names{mouse}))));
        
        TotalTimeCondSafe.(Drug_Group{group})(mouse)=sum(Stop(and(TotEpoch.Cond.(Mouse_names{mouse}),SafeEpoch.Cond.All.(Mouse_names{mouse})))-Start(and(TotEpoch.Cond.(Mouse_names{mouse}),SafeEpoch.Cond.All.(Mouse_names{mouse}))));
        TotalTimeExtSafe.(Drug_Group{group})(mouse)=sum(Stop(and(TotEpoch.Ext.(Mouse_names{mouse}),SafeEpoch.Ext.All.(Mouse_names{mouse})))-Start(and(TotEpoch.Ext.(Mouse_names{mouse}),SafeEpoch.Ext.All.(Mouse_names{mouse}))));
    end
    
    FreezingProp.(Drug_Group{group})=(TimeFz.(Drug_Group{group})./TotalTime.(Drug_Group{group}))*100;
    FreezingPropCond.(Drug_Group{group})=(TimeFzCond.(Drug_Group{group})./TotalTimeCond.(Drug_Group{group}))*100;
    FreezingPropExt.(Drug_Group{group})=(TimeFzExt.(Drug_Group{group})./TotalTimeExt.(Drug_Group{group}))*100;
    FreezingPropCondShock.(Drug_Group{group})=(TimeFzCondShock.(Drug_Group{group})./TotalTimeCondShock.(Drug_Group{group}))*100;
    FreezingPropExtShock.(Drug_Group{group})=(TimeFzExtShock.(Drug_Group{group})./TotalTimeExtShock.(Drug_Group{group}))*100;
    FreezingPropCondSafe.(Drug_Group{group})=(TimeFzCondSafe.(Drug_Group{group})./TotalTimeCondSafe.(Drug_Group{group}))*100;
    FreezingPropExtSafe.(Drug_Group{group})=(TimeFzExtSafe.(Drug_Group{group})./TotalTimeExtSafe.(Drug_Group{group}))*100;
    
end


res=1; % choose if you want to study all (1), free (2) or blocked (3) conditions

figure
subplot(332);
MakeSpreadAndBoxPlot2_SB({FreezingProp.Saline,FreezingProp.ChronicFlx},Cols,X,Legends,'showpoints',1,'paired',0); makepretty; xtickangle(45);
xticks([1 2]); xticklabels({'Saline','Chronic flx'}); makepretty; title('All sessions'); ylabel('Freezing / Total time (%)'); xtickangle(45)

subplot(346);
MakeSpreadAndBoxPlot2_SB({FreezingPropCond.Saline,FreezingPropCond.ChronicFlx},Cols,X,Legends,'showpoints',1,'paired',0); makepretty; xtickangle(45);
makepretty; title('Cond sessions'); ylabel('Freezing / Total time (%)'); xtickangle(45); ylim([-2 25])

subplot(347);
MakeSpreadAndBoxPlot2_SB({FreezingPropExt.Saline,FreezingPropExt.ChronicFlx},Cols,X,Legends,'showpoints',1,'paired',0); makepretty; xtickangle(45);
makepretty; title('Ext sessions'); xtickangle(45); ylim([-2 25])

subplot(349);
MakeSpreadAndBoxPlot2_SB({FreezingPropCondShock.Saline,FreezingPropCondShock.ChronicFlx},Cols,X,Legends,'showpoints',1,'paired',0); makepretty; xtickangle(45);
makepretty; title('Cond sessions, shock side'); ylabel('Freezing / Total time (%)'); xtickangle(45); ylim([-2 30])

subplot(3,4,10);
MakeSpreadAndBoxPlot2_SB({FreezingPropCondSafe.Saline,FreezingPropCondSafe.ChronicFlx},Cols,X,Legends,'showpoints',1,'paired',0); makepretty; xtickangle(45);
makepretty; title('Cond sessions, safe side'); ylim([-2 30])

subplot(3,4,11);
MakeSpreadAndBoxPlot2_SB({FreezingPropExtShock.Saline,FreezingPropExtShock.ChronicFlx},Cols,X,Legends,'showpoints',1,'paired',0); makepretty; xtickangle(45);
makepretty; title('Ext sessions, shock side'); ylim([-2 30])

subplot(3,4,12);
MakeSpreadAndBoxPlot2_SB({FreezingPropExtSafe.Saline,FreezingPropExtSafe.ChronicFlx},Cols,X,Legends,'showpoints',1,'paired',0); makepretty; xtickangle(45);
makepretty; title('Ext sessions, safe side'); ylim([-2 30])

a=suptitle('Freezing proportion, Saline/Chronic flx, UMaze'); a.FontSize=20;



%% Comparing freezing when mice are free or blocked

figure
subplot(121)
[pval,hb,eb]=PlotErrorBoxPlotN_BM([FreqMax.Saline.Cond.Blocked.Shock' FreqMax.Saline.Cond.Free.Shock'],'newfig',0,'showpoints',1,'paired',1)
makepretty; set(hb, 'linewidth' ,2)
xticklabels({'Blocked','Free'}); xtickangle(45)
title('Shock side freezing')
ylabel('Frequency (Hz)'); ylim([1 6])

subplot(122)
[pval,hb,eb]=PlotErrorBoxPlotN_BM([FreqMax.Saline.Cond.Blocked.Safe' FreqMax.Saline.Cond.Free.Safe'],'newfig',0,'showpoints',1,'paired',1)
makepretty; set(hb, 'linewidth' ,2)
xticklabels({'Blocked','Free'}); xtickangle(45)
title('Safe side freezing')
ylabel('Frequency (Hz)'); ylim([1 6])

a=suptitle('OB oscillations during freezing, conditionning sessions, blocked, saline group, n = 8'); a.FontSize=20;



%% OB gamma and HPC theta
Mouse=[666 668 688 739 777 779 849 893 1096 1134 1135 875 876 877 1001 1002 1095 1131 1130 740 750 775 778 794 829 851 856 857 858 859 1005 1006 561 567 568 566 569];

for mouse = 1:length(Mouse) % generate all sessions of interest
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
end

for sess=1%:length(Session_type) % generate all data required for analyses
    for res=1%:length(Restrain)
        
        if sess==1
            FolderList=FearSess;
        elseif sess==2
            FolderList=CondSess;
        elseif sess==3
            FolderList=ExtSess;
        end
        
        for mouse =1:length(Mouse_names)
            
            try HighOBSpec_Prelim=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'spectrum','prefix','B_High');
            catch
                keyboard
            end
            try  HPCSpec_Prelim=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'spectrum','prefix','H_Low'); end
            Freeze_Epoch_Prelim=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'Epoch','epochname','freezeepoch');
            ZoneEpoch_Prelim=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'Epoch','epochname','zoneepoch');
            BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'Epoch','epochname','blockedepoch');
            TotEpoch.(Session_type{sess}).(Mouse_names{mouse})=intervalSet(0,max(Range(HighOBSpec_Prelim)));
            Non_BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse})=TotEpoch.(Session_type{sess}).(Mouse_names{mouse})-BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse});
            
            if res==1
                HighOBSpecConcat.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse})=HighOBSpec_Prelim;
                try  HPCSpecConcat.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse})=HPCSpec_Prelim; end
                try FreezeEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse})=Freeze_Epoch_Prelim; end
                ZoneEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse})=ZoneEpoch_Prelim;
            end
            
            ShockEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}) = ZoneEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}){1};
            SafeEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}) = or(ZoneEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}){2},ZoneEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}){5});
            try
                HighOB_Freeze.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}) = Restrict(HighOBSpecConcat.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}),FreezeEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}));
                HighOB_Freeze.(Session_type{sess}).(Restrain{res}).Shock.(Mouse_names{mouse}) = Restrict(HighOB_Freeze.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}),ShockEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}));
                HighOB_Freeze.(Session_type{sess}).(Restrain{res}).Safe.(Mouse_names{mouse}) = Restrict(HighOB_Freeze.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}),SafeEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}));
            end
            try;
                HPC_Freeze.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}) = Restrict(HPCSpecConcat.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}),FreezeEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}));
                HPC_Freeze.(Session_type{sess}).(Restrain{res}).Shock.(Mouse_names{mouse}) = Restrict(HPC_Freeze.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}),ShockEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}));
                HPC_Freeze.(Session_type{sess}).(Restrain{res}).Safe.(Mouse_names{mouse}) = Restrict(HPC_Freeze.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}),SafeEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}));
            end
            disp(Mouse_names{mouse})
        end
    end
end


% group all data in drugs groups

load('B_High_Spectrum.mat'); RangeHighOB=Spectro{3};
load('H_Low_Spectrum.mat'); RangeHPC=Spectro{3};


Drug_Group={'Saline','ChronicFlx','AcuteFlx','Midazolam','Eyelid'};
for group=1:length(Drug_Group)
    
    if group==1 % saline mice
        Mouse_names={'M666','M668','M688','M739','M777','M779','M849','M893','M1096'}; % add 1096
        Mouse=[666 668 688 739 777 779 849 893 1096];
    elseif group==2 % chronic flx mice
        Mouse_names={'M875','M876','M877','M1001','M1002','M1095','M1130'};
        Mouse=[875 876 877 1001 1002 1095 1130 ];
    elseif group==3 % Acute Flx
        Mouse_names={'M740','M750','M775','M778','M794'};
        Mouse=[740 750 775 778 794];
    elseif group==4 % midazolam mice
        Mouse_names={'M829','M851','M857','M858','M859','M1005','M1006'};
        Mouse=[829 851 857 858 859 1005 1006];
    elseif group==5 % classic mice
        Mouse_names={'M561','M566','M567','M568','M569'};
        Mouse=[561 566 567 568 569];
    end
    
    figure
    for mouse=1:length(Mouse_names)
        
        AllSpectrumHighOB.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Shock(mouse,:) = nanmean(zscore_nan_BM(Data(HighOB_Freeze.(Session_type{sess}).(Restrain{res}).Shock.(Mouse_names{mouse}))')') ;
        [PowerMaxHighOB.(Session_type{sess}).(Restrain{res}).Shock.(Mouse_names{mouse}),FreqMaxHighOB.(Session_type{sess}).(Restrain{res}).Shock.(Mouse_names{mouse})]=max(AllSpectrumHighOB.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Shock(mouse,9:end))
        FreqMaxHighOB.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Shock(mouse) = RangeHighOB(FreqMaxHighOB.(Session_type{sess}).(Restrain{res}).Shock.(Mouse_names{mouse})+8);
        PowerMaxHighOB.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Shock(mouse) = PowerMaxHighOB.(Session_type{sess}).(Restrain{res}).Shock.(Mouse_names{mouse});
        
        AllSpectrumHighOB.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Safe(mouse,:) = nanmean(zscore_nan_BM(Data(HighOB_Freeze.(Session_type{sess}).(Restrain{res}).Safe.(Mouse_names{mouse}))')') ;
        [PowerMaxHighOB.(Session_type{sess}).(Restrain{res}).Safe.(Mouse_names{mouse}),FreqMaxHighOB.(Session_type{sess}).(Restrain{res}).Safe.(Mouse_names{mouse})]=max(AllSpectrumHighOB.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Safe(mouse,9:end));
        FreqMaxHighOB.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Safe(mouse) = RangeHighOB(FreqMaxHighOB.(Session_type{sess}).(Restrain{res}).Safe.(Mouse_names{mouse})+8);
        PowerMaxHighOB.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Safe(mouse) = PowerMaxHighOB.(Session_type{sess}).(Restrain{res}).Safe.(Mouse_names{mouse});

        subplot(221)
        plot(RangeHighOB,nanmean(Data(HighOB_Freeze.(Session_type{sess}).(Restrain{res}).Shock.(Mouse_names{mouse})))/max(nanmean(Data(HighOB_Freeze.(Session_type{sess}).(Restrain{res}).Shock.(Mouse_names{mouse})))),'r','linewidth',2); hold on
        ylim([0 1.2]); makepretty; xlabel('Frequency (Hz)'); ylabel('Power (A.U.)')
        title('Shock side freezing')
        subplot(222)
        plot(RangeHighOB,nanmean(Data(HighOB_Freeze.(Session_type{sess}).(Restrain{res}).Safe.(Mouse_names{mouse})))/max(nanmean(Data(HighOB_Freeze.(Session_type{sess}).(Restrain{res}).Safe.(Mouse_names{mouse})))),'b','linewidth',2); hold on
        ylim([0 1.2]); makepretty; xlabel('Frequency (Hz)');
        title('Safe side freezing')
        
    end
    
    a=subplot(223); a.Position=[0.25 0.1 0.5 0.4];
    Conf_Inter=nanstd(AllSpectrumHighOB.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Shock)/sqrt(size(AllSpectrumHighOB.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Shock,1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(AllSpectrumHighOB.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Shock);
    shadedErrorBar(RangeHighOB,Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-r',1); hold on;
    Conf_Inter=nanstd(AllSpectrumHighOB.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Safe)/sqrt(size(AllSpectrumHighOB.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Safe,1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(AllSpectrumHighOB.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Safe);
    h=shadedErrorBar(RangeHighOB,Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-b',1); hold on;
    makepretty;
    xlabel('Frequency (Hz)'); ylabel('Power (A.U.)');
    [c,d]=max(nanmean(AllSpectrumHighOB.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Shock(:,9:end)));
    vline(RangeHighOB(d+8),'--r')
    [c,d]=max(nanmean(AllSpectrumHighOB.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Safe(:,9:end)));
    vline(RangeHighOB(d+8),'--b')
    f=get(gca,'Children');
    legend([f(5),f(1)],'Shock side freezing','Safe side freezing')
    title('mean OB spectrum for all mice')
    
end
FreqMaxHighOB.Saline.Fear.All.Safe(7)=51.27;

figure
for group=1:5
    
    subplot(1,5,group)
    MakeSpreadAndBoxPlot2_SB({FreqMaxHighOB.(Drug_Group{group}).Fear.All.Shock , FreqMaxHighOB.(Drug_Group{group}).Fear.All.Safe},Cols,X,Legends,'showpoints',0); makepretty; xtickangle(45);
    title(Drug_Group{group}); ylim([40 80])
    if group==1; ylabel('Frequency (Hz)'); end
    
end
a=suptitle('Mean High OB spectrum maximum analysis, UMaze drugs experiments'); a.FontSize=20;

% Chronic flx and saline
figure
subplot(321)
Conf_Inter=nanstd(AllSpectrumHighOB.Saline.(Session_type{sess}).All.Shock)/sqrt(size(AllSpectrumHighOB.Saline.(Session_type{sess}).All.Shock,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(AllSpectrumHighOB.Saline.(Session_type{sess}).All.Shock);
shadedErrorBar(RangeHighOB,Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-r',1); hold on;
Conf_Inter=nanstd(AllSpectrumHighOB.ChronicFlx.(Session_type{sess}).All.Shock)/sqrt(size(AllSpectrumHighOB.ChronicFlx.(Session_type{sess}).All.Shock,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(AllSpectrumHighOB.ChronicFlx.(Session_type{sess}).All.Shock);
h=shadedErrorBar(RangeHighOB,Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-r',1); hold on;
h.mainLine.Color=[0.7 0 0]; h.patch.FaceColor=[1 0.6 0.6];
makepretty;
xlabel('Frequency (Hz)'); ylabel('Power (A.U.)');  %ylim([-0.3 1.2])
[c,d]=max(nanmean(AllSpectrumHighOB.Saline.(Session_type{sess}).All.Shock(:,9:25)));
vline(RangeHighOB(d+8),'--r')
[c,d]=max(nanmean(AllSpectrumHighOB.ChronicFlx.(Session_type{sess}).All.Shock(:,9:25)));
vline(RangeHighOB(d+8),'-r')
f=get(gca,'Children');
legend([f(5),f(1)],'Saline','Chronic fluoxetine')
title('Shock side')

subplot(322)
Conf_Inter=nanstd(AllSpectrumHighOB.Saline.(Session_type{sess}).All.Safe)/sqrt(size(AllSpectrumHighOB.Saline.(Session_type{sess}).All.Safe,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(AllSpectrumHighOB.Saline.(Session_type{sess}).All.Safe);
shadedErrorBar(RangeHighOB,Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-b',1); hold on;
Conf_Inter=nanstd(AllSpectrumHighOB.ChronicFlx.(Session_type{sess}).All.Safe)/sqrt(size(AllSpectrumHighOB.ChronicFlx.(Session_type{sess}).All.Safe,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(AllSpectrumHighOB.ChronicFlx.(Session_type{sess}).All.Safe);
k=shadedErrorBar(RangeHighOB,Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-b',1); hold on;
k.mainLine.Color=[0 0 0.5]; k.patch.FaceColor=[1 1 1];
makepretty; %ylim([-0.3 1.2]);
xlabel('Frequency (Hz)'); %xlim([0 10])
[c,d]=max(nanmean(AllSpectrumHighOB.Saline.(Session_type{sess}).All.Safe(:,9:25)));
vline(RangeHighOB(d+8),'--b')
[c,d]=max(nanmean(AllSpectrumHighOB.ChronicFlx.(Session_type{sess}).All.Safe(:,9:25)));
vline(RangeHighOB(d+8),'-b')
f=get(gca,'Children');
legend([f(5),f(1)],'Saline','Chronic fluoxetine')
title('Safe side')

a=subplot(323); %a.Position=[0.1300 0.4 0.1566 0.2052];
MakeSpreadAndBoxPlot2_SB({FreqMaxHighOB.Saline.Fear.All.Shock,FreqMaxHighOB.Saline.Fear.All.Safe},Cols,X,Legends,'showpoints',0); makepretty; xtickangle(45);
title('Saline');  ylabel('Frequency (Hz)');
ylim([50 80])

a=subplot(324); %a.Position=[0.1300 0.1 0.1566 0.2052];
MakeSpreadAndBoxPlot2_SB({FreqMaxHighOB.ChronicFlx.Fear.All.Shock,FreqMaxHighOB.ChronicFlx.Fear.All.Safe},Cols,X,Legends,'showpoints',0);
makepretty; xtickangle(45); title('Chronic Flx'); ylabel('Frequency (Hz)');
ylim([50 80])

% other way
Figure_to_use(:,1)=FreqMaxHighOB.Saline.Fear.All.Safe;
Figure_to_use(:,2)=FreqMaxHighOB.Saline.Fear.All.Shock;
Figure_to_use(1:7,3)=FreqMaxHighOB.ChronicFlx.Fear.All.Shock;
Figure_to_use(1:7,4)=FreqMaxHighOB.ChronicFlx.Fear.All.Safe;
Figure_to_use(Figure_to_use==0)=NaN;

a=subplot(325); %a.Position=[0.3361 0.1096 0.1566 0.4157];
MakeSpreadAndBoxPlot2_SB(Figure_to_use,Cols,X,Legends,'showpoints',1, 'paired',0);
ylabel('Frequency (Hz)');

a=suptitle('UMaze drugs experiments, mean High OB spectrum, chronic flx and saline mice'); a.FontSize=20;

%% HPC

for group=1:length(Drug_Group)
    
    if group==1 % saline mice
        Mouse_names={'M666','M668','M688','M739','M777','M779','M849','M893','M1096'}; % add 1096
        Mouse=[666 668 688 739 777 779 849 893 1096];
    elseif group==2 % chronic flx mice
        Mouse_names={'M875','M876','M877','M1001','M1002'};
        Mouse=[875 876 877 1001 1002 1095 1130 1131];
    elseif group==3 % Acute Flx
        Mouse_names={'M740','M750','M775','M778','M794'};
        Mouse=[740 750 775 778 794];
    elseif group==4 % midazolam mice
        Mouse_names={'M829','M851','M857','M858','M859','M1005','M1006'};
        Mouse=[829 851 857 858 859 1005 1006];
    elseif group==5 % classic mice
        Mouse_names={'M561','M566','M567','M568','M569'};
        Mouse=[561 566 567 568 569];
    end
    
    figure
    for mouse=1:length(Mouse_names)
        
        AllSpectrumHPC.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Shock(mouse,:) = nanmean(zscore_nan_BM(Data(HPC_Freeze.(Session_type{sess}).(Restrain{res}).Shock.(Mouse_names{mouse}))')') ;
        [PowerMaxHPC.(Session_type{sess}).(Restrain{res}).Shock.(Mouse_names{mouse}),FreqMaxHPC.(Session_type{sess}).(Restrain{res}).Shock.(Mouse_names{mouse})]=max(AllSpectrumHPC.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Shock(mouse,:));
        FreqMaxHPC.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Shock(mouse) = RangeHPC(FreqMaxHPC.(Session_type{sess}).(Restrain{res}).Shock.(Mouse_names{mouse}));
        
        AllSpectrumHPC.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Safe(mouse,:) = nanmean(zscore_nan_BM(Data(HPC_Freeze.(Session_type{sess}).(Restrain{res}).Safe.(Mouse_names{mouse}))')') ;
        [PowerMaxHPC.(Session_type{sess}).(Restrain{res}).Safe.(Mouse_names{mouse}),FreqMaxHPC.(Session_type{sess}).(Restrain{res}).Safe.(Mouse_names{mouse})]=max(AllSpectrumHPC.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Safe(mouse,:));
        FreqMaxHPC.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Safe(mouse) = RangeHPC(FreqMaxHPC.(Session_type{sess}).(Restrain{res}).Safe.(Mouse_names{mouse}));
        
        subplot(221)
        plot(RangeHPC,nanmean(Data(HPC_Freeze.(Session_type{sess}).(Restrain{res}).Shock.(Mouse_names{mouse})))/max(nanmean(Data(HPC_Freeze.(Session_type{sess}).(Restrain{res}).Shock.(Mouse_names{mouse})))),'r','linewidth',2); hold on
        ylim([0 1.2]); makepretty; xlabel('Frequency (Hz)'); ylabel('Power (A.U.)')
        title('Shock side freezing')
        subplot(222)
        plot(RangeHPC,nanmean(Data(HPC_Freeze.(Session_type{sess}).(Restrain{res}).Safe.(Mouse_names{mouse})))/max(nanmean(Data(HPC_Freeze.(Session_type{sess}).(Restrain{res}).Safe.(Mouse_names{mouse})))),'b','linewidth',2); hold on
        ylim([0 1.2]); makepretty; xlabel('Frequency (Hz)');
        title('Safe side freezing')
        
    end
    
    a=subplot(223); a.Position=[0.25 0.1 0.5 0.4];
    Conf_Inter=nanstd(AllSpectrumHPC.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Shock)/sqrt(size(AllSpectrumHPC.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Shock,1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(AllSpectrumHPC.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Shock);
    shadedErrorBar(RangeHPC,Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-r',1); hold on;
    Conf_Inter=nanstd(AllSpectrumHPC.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Safe)/sqrt(size(AllSpectrumHPC.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Safe,1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(AllSpectrumHPC.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Safe);
    h=shadedErrorBar(RangeHPC,Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-b',1); hold on;
    makepretty;
    xlabel('Frequency (Hz)'); ylabel('Power (A.U.)');
    [c,d]=max(nanmean(AllSpectrumHPC.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Shock));
    vline(RangeHPC(d),'--r')
    [c,d]=max(nanmean(AllSpectrumHPC.(Drug_Group{group}).(Session_type{sess}).(Restrain{res}).Safe(:,1:end)));
    vline(RangeHPC(d),'--b')
    f=get(gca,'Children');
    legend([f(5),f(1)],'Shock side freezing','Safe side freezing')
    title('mean OB spectrum for all mice')
    
end





