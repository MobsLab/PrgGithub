
cd('/media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_TestPre_PreDrug/TestPre2')
load('H_Low_Spectrum.mat'); RangeLow=Spectro{3};
load('B_Middle_Spectrum.mat'); RangeMiddle=Spectro{3};
load('B_High_Spectrum.mat'); RangeHigh=Spectro{3};
load('H_VHigh_Spectrum.mat'); RangeVHigh=Spectro{3};
Session_type={'Cond','CondPre','CondPost','Ext'};

Mouse=[1251 1253 1254 11251 11252 11253 11254];
clear Mouse_names
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
end
for sess=1:length(Session_type) % generate all data required for analyses
    [OutPutData.(Session_type{sess}) , Epoch.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type{sess}),'ob_low','heartrate','respi_freq_bm');
end

%% OB Low
figure; sess=2;
subplot(231)
Data_to_use = squeeze(OutPutData.(Session_type{sess}).ob_low.mean(1:3,5,:))./max([OutPutData.(Session_type{sess}).ob_low.power(1:3,5) OutPutData.(Session_type{sess}).ob_low.power(1:3,6)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-r',1); hold on;
[c,d]=max(Mean_All_Sp);
vline(RangeLow(d),'--r')
Data_to_use = squeeze(OutPutData.(Session_type{sess}).ob_low.mean(1:3,6,:))./max([OutPutData.(Session_type{sess}).ob_low.power(1:3,5) OutPutData.(Session_type{sess}).ob_low.power(1:3,6)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-b',1); hold on;
[c,d]=max(Mean_All_Sp(19:end));
vline(RangeLow(d+18),'--b')
f=get(gca,'Children');
a=legend([f(8),f(4)],'Shock side freezing','Safe side freezing');
makepretty; ylabel('Power (a.u.)'); xlim([0 10]); ylim([0 1])
title('CondPre')
u=text(-2,0.2,'Saline, n=3','FontSize',20,'FontWeight','bold'); set(u,'Rotation',90)

subplot(234)
Data_to_use = squeeze(OutPutData.(Session_type{sess}).ob_low.mean(4:7,5,:))./max([OutPutData.(Session_type{sess}).ob_low.power(4:7,5) OutPutData.(Session_type{sess}).ob_low.power(4:7,6)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-r',1); hold on;
[c,d]=max(Mean_All_Sp);
vline(RangeLow(d),'--r')
Data_to_use = squeeze(OutPutData.(Session_type{sess}).ob_low.mean(4:7,6,:))./max([OutPutData.(Session_type{sess}).ob_low.power(4:7,5) OutPutData.(Session_type{sess}).ob_low.power(4:7,6)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-b',1); hold on;
[c,d]=max(Mean_All_Sp(19:end));
vline(RangeLow(d+18),'--b')
makepretty; xlabel('Frequency (Hz)'); ylabel('Power (a.u.)'); xlim([0 10]); ylim([0 1])
u=text(-2,0.2,'Diazepam, n=4','FontSize',20,'FontWeight','bold'); set(u,'Rotation',90)

sess=3;
subplot(232)
Data_to_use = squeeze(OutPutData.(Session_type{sess}).ob_low.mean(1:3,5,:))./max([OutPutData.(Session_type{sess}).ob_low.power(1:3,5) OutPutData.(Session_type{sess}).ob_low.power(1:3,6)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-r',1); hold on;
[c,d]=max(Mean_All_Sp);
vline(RangeLow(d),'--r')
Data_to_use = squeeze(OutPutData.(Session_type{sess}).ob_low.mean(1:3,6,:))./max([OutPutData.(Session_type{sess}).ob_low.power(1:3,5) OutPutData.(Session_type{sess}).ob_low.power(1:3,6)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-b',1); hold on;
[c,d]=max(Mean_All_Sp(19:end));
vline(RangeLow(d+18),'--b')
f=get(gca,'Children');
a=legend([f(8),f(4)],'Shock side freezing','Safe side freezing');
makepretty;  xlim([0 10]); ylim([0 1])
title('CondPost')

subplot(235)
Data_to_use = squeeze(OutPutData.(Session_type{sess}).ob_low.mean(4:7,5,:))./max([OutPutData.(Session_type{sess}).ob_low.power(4:7,5) OutPutData.(Session_type{sess}).ob_low.power(4:7,6)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-r',1); hold on;
[c,d]=max(Mean_All_Sp);
vline(RangeLow(d),'--r')
Data_to_use = squeeze(OutPutData.(Session_type{sess}).ob_low.mean(4:7,6,:))./max([OutPutData.(Session_type{sess}).ob_low.power(4:7,5) OutPutData.(Session_type{sess}).ob_low.power(4:7,6)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-b',1); hold on;
[c,d]=max(Mean_All_Sp(19:end));
vline(RangeLow(d+18),'--b')
makepretty; xlabel('Frequency (Hz)'); xlim([0 10]); ylim([0 1])

sess=4;
subplot(233)
Data_to_use = squeeze(OutPutData.(Session_type{sess}).ob_low.mean(1:3,5,:))./max([OutPutData.(Session_type{sess}).ob_low.power(1:3,5) OutPutData.(Session_type{sess}).ob_low.power(1:3,6)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-r',1); hold on;
[c,d]=max(Mean_All_Sp);
vline(RangeLow(d),'--r')
Data_to_use = squeeze(OutPutData.(Session_type{sess}).ob_low.mean(1:3,6,:))./max([OutPutData.(Session_type{sess}).ob_low.power(1:3,5) OutPutData.(Session_type{sess}).ob_low.power(1:3,6)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-b',1); hold on;
[c,d]=max(Mean_All_Sp(19:end));
vline(RangeLow(d+18),'--b')
f=get(gca,'Children');
makepretty; xlim([0 10]); ylim([0 1])
title('Ext')

subplot(236)
Data_to_use = squeeze(OutPutData.(Session_type{sess}).ob_low.mean(4:7,5,:))./max([OutPutData.(Session_type{sess}).ob_low.power(4:7,5) OutPutData.(Session_type{sess}).ob_low.power(4:7,6)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-r',1); hold on;
[c,d]=max(Mean_All_Sp);
vline(RangeLow(d),'--r')
Data_to_use = squeeze(OutPutData.(Session_type{sess}).ob_low.mean(4:7,6,:))./max([OutPutData.(Session_type{sess}).ob_low.power(4:7,5) OutPutData.(Session_type{sess}).ob_low.power(4:7,6)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-b',1); hold on;
[c,d]=max(Mean_All_Sp(19:end));
vline(RangeLow(d+18),'--b')
makepretty; xlabel('Frequency (Hz)');  xlim([0 10]); ylim([0 1])



%% Heart rate
Cols = {[1 0.5 0.5],[0.5 0.5 1],[1 0.8 0.8],[0.8 0.8 1]};
X = [1:4];
Legends = {'Shock','Safe','Shock','Safe'};

figure
subplot(131); sess=2;
MakeSpreadAndBoxPlot2_SB([[OutPutData.(Session_type{sess}).heartrate.mean(1:3,5:6) ; [NaN NaN]] OutPutData.(Session_type{sess}).heartrate.mean(4:7,5:6)],Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Frequency (Hz)'); title('CondPre'); ylim([8 13])

subplot(132); sess=3;
MakeSpreadAndBoxPlot2_SB([[OutPutData.(Session_type{sess}).heartrate.mean(1:3,5:6) ; [NaN NaN]] OutPutData.(Session_type{sess}).heartrate.mean(4:7,5:6)],Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Frequency (Hz)'); title('CondPost'); ylim([8 13])

subplot(133); sess=4;
MakeSpreadAndBoxPlot2_SB([[OutPutData.(Session_type{sess}).heartrate.mean(1:3,5:6) ; [NaN NaN]] OutPutData.(Session_type{sess}).heartrate.mean(4:7,5:6)],Cols,X,Legends,'showpoints',1,'paired',0);
title('Ext'); ylim([8 13])



%% Hist of respi

clear all
GetEmbReactMiceFolderList_BM

Session_type={'Fear','Cond','Ext','CondPre','CondPost'};
cd('/media/nas6/ProjetEmbReact/Mouse1189/20210420/ProjectEmbReact_M11189_20210420_UMazeCondBlockedShock_PostDrug/Cond2'); load('B_Low_Spectrum.mat')
Side={'All','Shock','Safe'}; Side_ind=[3 5 6];
X = [1:8];
Cols = {[0, 0, 1],[1, 0, 0],[1, 0.5, 0.5],[0, 0.5, 0],[0.3, 0.745, 0.93],[0.85, 0.325, 0.098],[0.2, 0.645, 0.83],[0.75, 0.225, 0]};
Legends_Drugs ={'SalineSB' 'Chronic Flx' 'Acute Flx' 'Midazolam','Saline_Short','DZP_Short','Saline_Long','DZP_Long'};
NoLegends_Drugs ={'', '', '', '','','','',''};

Mouse=[1251 1253 1254 11251 11252 11253 11254];
clear Mouse_names
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
end

for sess=1:length(Session_type) % generate all data required for analyses
    [TSD_DATA.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch]=MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type{sess}),'respi_freq_BM');
end

for sess=1:length(Session_type) % generate all data required for analyses
    
    if sess==1
        FolderList=FearSess;
    elseif sess==2
        FolderList=CondSess;
    elseif sess==3
        FolderList=ExtSess;
    elseif sess==4
        FolderList=CondPreSess;
    elseif sess==5
        FolderList=CondPostSess;
    end
    
    for mouse = 1:length(Mouse_names)
        
        for side=1:length(Side)
            try
                h=histogram(Data(TSD_DATA.(Session_type{sess}).respi_freq_BM.tsd{mouse,Side_ind(side)}),'BinLimits',[1 8],'NumBins',91); % 91=nansum(and(1<Spectro{3},Spectro{3}<8))
                HistData.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) = h.Values;
            end
            %                 TimeSpentFreezing.(Session_type{sess}).(Mouse_names{mouse}) = nansum((Stop(Epoch1)-Start())/(Stop()-Start()));
        end
    end
end

Drug_Group={'Saline','DZP'};
for group=1:length(Drug_Group)
    
    if group==1 % saline mice
        Mouse=[1251 1253 1254]; % add 1096
    elseif group==2 % DZP mice
        Mouse=[11251 11252 11253 11254];
    end
    
    for sess=1:length(Session_type) % generate all data required for analyses
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            for side=1:length(Side)
                try
                    if isnan(runmean(HistData.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})/nansum(HistData.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})),3))
                        HistData.(Side{side}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = NaN(1,91);
                    else
                        HistData.(Side{side}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = runmean(HistData.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})/nansum(HistData.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})),3);
                    end
                catch
                    HistData.(Side{side}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = NaN(1,91);
                end
            end
        end
    end
end


for group=1:2
    n=1;
    for sess=[4 5 3]
        
        subplot(2,3,3*(group-1)+n)
        
        Conf_Inter=nanstd(HistData.Shock.(Drug_Group{group}).(Session_type{sess}))/sqrt(size(HistData.Shock.(Drug_Group{group}).(Session_type{sess}),1));
        shadedErrorBar(Spectro{3}(13:103),nanmean(HistData.Shock.(Drug_Group{group}).(Session_type{sess})),Conf_Inter,'r',1); hold on;
        Conf_Inter=nanstd(HistData.Safe.(Drug_Group{group}).(Session_type{sess}))/sqrt(size(HistData.Safe.(Drug_Group{group}).(Session_type{sess}),1));
        shadedErrorBar(Spectro{3}(13:103),nanmean(HistData.Safe.(Drug_Group{group}).(Session_type{sess})),Conf_Inter,'b',1); hold on;
        makepretty; grid on
        a=ylim; ylim([0 a(2)]);
        if and(n==1,group==1); title('CondPre'); end
        if and(n==2,group==1); title('CondPost'); end
        if and(n==3,group==1); title('Ext'); end
        if sess==4; ylabel(Drug_Group{group}); end
        if group==2; xlabel('Frequency (Hz)'); end
        if and(n==1,group==1); f=get(gca,'Children'); legend([f(8),f(4)],'Shock','Safe'); end
        
        n=n+1;
    end
end
a=suptitle('Breathing frequency during freezing, spent time analysis'); a.FontSize=20;


figure;
for side=2:3
    n=1;
    for sess=[4 5 3]
        subplot(2,3,3*(side-2)+n)
        if side==2
            Conf_Inter=nanstd(HistData.(Side{side}).Saline.(Session_type{sess}))/sqrt(size(HistData.(Side{side}).Saline.(Session_type{sess}),1));
            shadedErrorBar(Spectro{3}(13:103),nanmean(HistData.(Side{side}).Saline.(Session_type{sess})),Conf_Inter,'r',1); hold on;
        elseif side==3
            Conf_Inter=nanstd(HistData.(Side{side}).Saline.(Session_type{sess}))/sqrt(size(HistData.(Side{side}).Saline.(Session_type{sess}),1));
            shadedErrorBar(Spectro{3}(13:103),nanmean(HistData.(Side{side}).Saline.(Session_type{sess})),Conf_Inter,'b',1); hold on;
        end
        Conf_Inter=nanstd(HistData.(Side{side}).DZP.(Session_type{sess}))/sqrt(size(HistData.(Side{side}).DZP.(Session_type{sess}),1));
        shadedErrorBar(Spectro{3}(13:103),nanmean(HistData.(Side{side}).DZP.(Session_type{sess})),Conf_Inter,'k',1); hold on;
        makepretty; grid on
        if side==3; xlabel('Frequency (Hz)'); end
        if side==2; title(Session_type{sess}); end
        a=ylim; ylim([0 a(2)]); xlim([0 8])
        if and(n==1,side==2); f=get(gca,'Children'); legend([f(5),f(1)],'Saline','DZP'); end
        if and(n==1,side==2); ylabel('Shock'); end
        if and(n==1,side==3); ylabel('Safe'); end
        
        n=n+1;
    end
end
a=suptitle('Breathing frequency during freezing, spent time analysis'); a.FontSize=20;


figure; n=1;
for sess=[4 5 3]
    
    subplot(1,3,n)
    Conf_Inter=nanstd(HistData.All.Saline.(Session_type{sess}))/sqrt(size(HistData.All.Saline.(Session_type{sess}),1));
    shadedErrorBar(Spectro{3}(13:103),nanmean(HistData.All.Saline.(Session_type{sess})),Conf_Inter,'k',1); hold on;
    Conf_Inter=nanstd(HistData.All.DZP.(Session_type{sess}))/sqrt(size(HistData.All.DZP.(Session_type{sess}),1));
    shadedErrorBar(Spectro{3}(13:103),nanmean(HistData.All.DZP.(Session_type{sess})),Conf_Inter,'m',1); hold on;
    makepretty; grid on; axis square;
    a=ylim; ylim([0 a(2)]);
    f=get(gca,'Children'); legend([f(5),f(1)],'Saline','DZP');
    title(Session_type{sess});
    xlabel('Frequency (Hz)');
    n=n+1;
    
end






