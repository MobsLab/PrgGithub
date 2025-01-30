
Cols = {[0.66 0.66 1],[0 0 0.33]};
Cols1 = {[1 0.66 0.66],[0.33 0 0]};
X = [1,2];
Legends ={'Pre Drug' 'Post Drug'};
NoLegends ={'' '' ''};

X2 = [1,2,3,4];
Cols2 = {[0, 0, 1],[1, 0, 0],[1, 0.5, 0.5],[0, 0.5, 0]};
Legends_Drugs ={'Saline' 'Chronic Flx' 'Acute Flx' 'Midazolam'};
NoLegends_Drugs ={'' '' '' '' ''};


%% Fz time
X = [1,2,3,4,5,6];
Cols = {[0, 0, 1],[1, 0, 0],[1, 0.5, 0.5],[0, 0.5, 0],[0.8500, 0.3250, 0.0980],[0.3010, 0.7450, 0.9330]};
Legends_Drugs ={'Saline' 'Chronic Flx' 'Acute Flx' 'Midazolam' 'Diazepam' 'New saline'};


figure
subplot(331)
MakeSpreadAndBoxPlot2_SB({FreezingProp.All.Fear.Saline , FreezingProp.All.Fear.ChronicFlx , FreezingProp.All.Fear.AcuteFlx, FreezingProp.All.Fear.Midazolam , FreezingProp.All.Fear.Diazepam , FreezingProp.All.Fear.NewSaline},Cols,X,Legends_Drugs,'showpoints',1,'paired',0);
title('Fear'); %ylim([-0.02 0.65])
ylabel('All')

subplot(332)
MakeSpreadAndBoxPlot2_SB({FreezingProp.All.Cond.Saline , FreezingProp.All.Cond.ChronicFlx , FreezingProp.All.Cond.AcuteFlx, FreezingProp.All.Cond.Midazolam , FreezingProp.All.Cond.Diazepam , FreezingProp.All.Cond.NewSaline},Cols,X,Legends_Drugs,'showpoints',1,'paired',0);
title('Cond'); %ylim([-0.02 0.65])

subplot(333)
MakeSpreadAndBoxPlot2_SB({FreezingProp.All.Ext.Saline , FreezingProp.All.Ext.ChronicFlx , FreezingProp.All.Ext.AcuteFlx, FreezingProp.All.Ext.Midazolam , FreezingProp.All.Ext.Diazepam , FreezingProp.All.Ext.NewSaline},Cols,X,Legends_Drugs,'showpoints',1,'paired',0);
title('Ext'); %ylim([-0.02 0.65])

subplot(334)
MakeSpreadAndBoxPlot2_SB({FreezingProp.Shock.Fear.Saline , FreezingProp.Shock.Fear.ChronicFlx , FreezingProp.Shock.Fear.AcuteFlx, FreezingProp.Shock.Fear.Midazolam , FreezingProp.Shock.Fear.Diazepam , FreezingProp.Shock.Fear.NewSaline},Cols,X,Legends_Drugs,'showpoints',1,'paired',0);
ylabel('Shock'); %ylim([-0.02 0.65])

subplot(335)
MakeSpreadAndBoxPlot2_SB({FreezingProp.Shock.Cond.Saline , FreezingProp.Shock.Cond.ChronicFlx , FreezingProp.Shock.Cond.AcuteFlx, FreezingProp.Shock.Cond.Midazolam , FreezingProp.Shock.Cond.Diazepam , FreezingProp.Shock.Cond.NewSaline},Cols,X,Legends_Drugs,'showpoints',1,'paired',0);
%ylim([-0.02 0.65])

subplot(336)
MakeSpreadAndBoxPlot2_SB({FreezingProp.Shock.Ext.Saline , FreezingProp.Shock.Ext.ChronicFlx , FreezingProp.Shock.Ext.AcuteFlx, FreezingProp.Shock.Ext.Midazolam , FreezingProp.Shock.Ext.Diazepam , FreezingProp.Shock.Ext.NewSaline},Cols,X,Legends_Drugs,'showpoints',1,'paired',0);
%ylim([-0.02 0.65])

subplot(337)
MakeSpreadAndBoxPlot2_SB({FreezingProp.Safe.Fear.Saline , FreezingProp.Safe.Fear.ChronicFlx , FreezingProp.Safe.Fear.AcuteFlx, FreezingProp.Safe.Fear.Midazolam , FreezingProp.Safe.Fear.Diazepam , FreezingProp.Safe.Fear.NewSaline},Cols,X,Legends_Drugs,'showpoints',1,'paired',0);
ylabel('Safe')
%ylim([-0.02 0.65])

subplot(338)
MakeSpreadAndBoxPlot2_SB({FreezingProp.Safe.Cond.Saline , FreezingProp.Safe.Cond.ChronicFlx , FreezingProp.Safe.Cond.AcuteFlx, FreezingProp.Safe.Cond.Midazolam , FreezingProp.Safe.Cond.Diazepam , FreezingProp.Safe.Cond.NewSaline},Cols,X,Legends_Drugs,'showpoints',1,'paired',0);
%ylim([-0.02 0.65])

subplot(339)
MakeSpreadAndBoxPlot2_SB({FreezingProp.Safe.Ext.Saline , FreezingProp.Safe.Ext.ChronicFlx , FreezingProp.Safe.Ext.AcuteFlx, FreezingProp.Safe.Ext.Midazolam , FreezingProp.Safe.Ext.Diazepam , FreezingProp.Safe.Ext.NewSaline},Cols,X,Legends_Drugs,'showpoints',1,'paired',0);
%ylim([-0.02 0.65])

a=suptitle('Freezing proportion, UMaze drugs experiments'); a.FontSize=20;

%% Fz epoch mean duration

figure
subplot(331)
MakeSpreadAndBoxPlot2_SB({FreezingMeanDur.All.Fear.Saline , FreezingMeanDur.All.Fear.ChronicFlx , FreezingMeanDur.All.Fear.AcuteFlx, FreezingMeanDur.All.Fear.Midazolam , FreezingMeanDur.All.Fear.Diazepam , FreezingMeanDur.All.Fear.NewSaline},Cols,X,Legends_Drugs,'showpoints',1,'paired',0);
title('Fear'); ylim([0 12])
ylabel('All')

subplot(332)
MakeSpreadAndBoxPlot2_SB({FreezingMeanDur.All.Cond.Saline , FreezingMeanDur.All.Cond.ChronicFlx , FreezingMeanDur.All.Cond.AcuteFlx, FreezingMeanDur.All.Cond.Midazolam , FreezingMeanDur.All.Cond.Diazepam , FreezingMeanDur.All.Cond.NewSaline},Cols,X,Legends_Drugs,'showpoints',1,'paired',0);
title('Cond'); ylim([0 12])

subplot(333)
MakeSpreadAndBoxPlot2_SB({FreezingMeanDur.All.Ext.Saline , FreezingMeanDur.All.Ext.ChronicFlx , FreezingMeanDur.All.Ext.AcuteFlx, FreezingMeanDur.All.Ext.Midazolam , FreezingMeanDur.All.Ext.Diazepam , FreezingMeanDur.All.Ext.NewSaline},Cols,X,Legends_Drugs,'showpoints',1,'paired',0);
title('Ext'); ylim([0 12])

subplot(334)
MakeSpreadAndBoxPlot2_SB({FreezingMeanDur.Shock.Fear.Saline , FreezingMeanDur.Shock.Fear.ChronicFlx , FreezingMeanDur.Shock.Fear.AcuteFlx, FreezingMeanDur.Shock.Fear.Midazolam , FreezingMeanDur.Shock.Fear.Diazepam , FreezingMeanDur.Shock.Fear.NewSaline},Cols,X,Legends_Drugs,'showpoints',1,'paired',0);
ylabel('Shock'); ylim([0 12])

subplot(335)
MakeSpreadAndBoxPlot2_SB({FreezingMeanDur.Shock.Cond.Saline , FreezingMeanDur.Shock.Cond.ChronicFlx , FreezingMeanDur.Shock.Cond.AcuteFlx, FreezingMeanDur.Shock.Cond.Midazolam , FreezingMeanDur.Shock.Cond.Diazepam , FreezingMeanDur.Shock.Cond.NewSaline},Cols,X,Legends_Drugs,'showpoints',1,'paired',0);
ylim([0 12])

subplot(336)
MakeSpreadAndBoxPlot2_SB({FreezingMeanDur.Shock.Ext.Saline , FreezingMeanDur.Shock.Ext.ChronicFlx , FreezingMeanDur.Shock.Ext.AcuteFlx, FreezingMeanDur.Shock.Ext.Midazolam , FreezingMeanDur.Shock.Ext.Diazepam , FreezingMeanDur.Shock.Ext.NewSaline},Cols,X,Legends_Drugs,'showpoints',1,'paired',0);
ylim([0 12])

subplot(337)
MakeSpreadAndBoxPlot2_SB({FreezingMeanDur.Safe.Fear.Saline , FreezingMeanDur.Safe.Fear.ChronicFlx , FreezingMeanDur.Safe.Fear.AcuteFlx, FreezingMeanDur.Safe.Fear.Midazolam , FreezingMeanDur.Safe.Fear.Diazepam , FreezingMeanDur.Safe.Fear.NewSaline},Cols,X,Legends_Drugs,'showpoints',1,'paired',0);
ylabel('Safe')
ylim([0 12])

subplot(338)
MakeSpreadAndBoxPlot2_SB({FreezingMeanDur.Safe.Cond.Saline , FreezingMeanDur.Safe.Cond.ChronicFlx , FreezingMeanDur.Safe.Cond.AcuteFlx, FreezingMeanDur.Safe.Cond.Midazolam , FreezingMeanDur.Safe.Cond.Diazepam , FreezingMeanDur.Safe.Cond.NewSaline},Cols,X,Legends_Drugs,'showpoints',1,'paired',0);
ylim([0 12])

subplot(339)
MakeSpreadAndBoxPlot2_SB({FreezingMeanDur.Safe.Ext.Saline , FreezingMeanDur.Safe.Ext.ChronicFlx , FreezingMeanDur.Safe.Ext.AcuteFlx, FreezingMeanDur.Safe.Ext.Midazolam , FreezingMeanDur.Safe.Ext.Diazepam , FreezingMeanDur.Safe.Ext.NewSaline},Cols,X,Legends_Drugs,'showpoints',1,'paired',0);
ylim([0 12])

a=suptitle('Freezing mean duration, UMaze drugs experiments'); a.FontSize=20;

%% Fz transition proba

figure
subplot(331)
MakeSpreadAndBoxPlot2_SB({FreezingProba.All.Fear.Saline , FreezingProba.All.Fear.ChronicFlx , FreezingProba.All.Fear.AcuteFlx, FreezingProba.All.Fear.Midazolam , FreezingProba.All.Fear.Diazepam , FreezingProba.All.Fear.NewSaline},Cols,X,Legends_Drugs,'showpoints',1,'paired',0);
title('Fear'); ylim([0 0.7])
ylabel('All')

subplot(332)
MakeSpreadAndBoxPlot2_SB({FreezingProba.All.Cond.Saline , FreezingProba.All.Cond.ChronicFlx , FreezingProba.All.Cond.AcuteFlx, FreezingProba.All.Cond.Midazolam , FreezingProba.All.Cond.Diazepam , FreezingProba.All.Cond.NewSaline},Cols,X,Legends_Drugs,'showpoints',1,'paired',0);
title('Cond'); ylim([0 0.7])

subplot(333)
MakeSpreadAndBoxPlot2_SB({FreezingProba.All.Ext.Saline , FreezingProba.All.Ext.ChronicFlx , FreezingProba.All.Ext.AcuteFlx, FreezingProba.All.Ext.Midazolam , FreezingProba.All.Ext.Diazepam , FreezingProba.All.Ext.NewSaline},Cols,X,Legends_Drugs,'showpoints',1,'paired',0);
title('Ext'); ylim([0 0.7])

subplot(334)
MakeSpreadAndBoxPlot2_SB({FreezingProba.Shock.Fear.Saline , FreezingProba.Shock.Fear.ChronicFlx , FreezingProba.Shock.Fear.AcuteFlx, FreezingProba.Shock.Fear.Midazolam , FreezingProba.Shock.Fear.Diazepam , FreezingProba.Shock.Fear.NewSaline},Cols,X,Legends_Drugs,'showpoints',1,'paired',0);
ylabel('Shock'); ylim([0 0.7])

subplot(335)
MakeSpreadAndBoxPlot2_SB({FreezingProba.Shock.Cond.Saline , FreezingProba.Shock.Cond.ChronicFlx , FreezingProba.Shock.Cond.AcuteFlx, FreezingProba.Shock.Cond.Midazolam , FreezingProba.Shock.Cond.Diazepam , FreezingProba.Shock.Cond.NewSaline},Cols,X,Legends_Drugs,'showpoints',1,'paired',0);
ylim([0 0.7])

subplot(336)
MakeSpreadAndBoxPlot2_SB({FreezingProba.Shock.Ext.Saline , FreezingProba.Shock.Ext.ChronicFlx , FreezingProba.Shock.Ext.AcuteFlx, FreezingProba.Shock.Ext.Midazolam , FreezingProba.Shock.Ext.Diazepam , FreezingProba.Shock.Ext.NewSaline},Cols,X,Legends_Drugs,'showpoints',1,'paired',0);
ylim([0 0.7])

subplot(337)
MakeSpreadAndBoxPlot2_SB({FreezingProba.Safe.Fear.Saline , FreezingProba.Safe.Fear.ChronicFlx , FreezingProba.Safe.Fear.AcuteFlx, FreezingProba.Safe.Fear.Midazolam , FreezingProba.Safe.Fear.Diazepam , FreezingProba.Safe.Fear.NewSaline},Cols,X,Legends_Drugs,'showpoints',1,'paired',0);
ylabel('Safe')
ylim([0 0.7])

subplot(338)
MakeSpreadAndBoxPlot2_SB({FreezingProba.Safe.Cond.Saline , FreezingProba.Safe.Cond.ChronicFlx , FreezingProba.Safe.Cond.AcuteFlx, FreezingProba.Safe.Cond.Midazolam , FreezingProba.Safe.Cond.Diazepam , FreezingProba.Safe.Cond.NewSaline},Cols,X,Legends_Drugs,'showpoints',1,'paired',0);
ylim([0 0.7])

subplot(339)
MakeSpreadAndBoxPlot2_SB({FreezingProba.Safe.Ext.Saline , FreezingProba.Safe.Ext.ChronicFlx , FreezingProba.Safe.Ext.AcuteFlx, FreezingProba.Safe.Ext.Midazolam , FreezingProba.Safe.Ext.Diazepam , FreezingProba.Safe.Ext.NewSaline},Cols,X,Legends_Drugs,'showpoints',1,'paired',0);
ylim([0 0.7])


a=suptitle('Freezing proba, UMaze drugs experiments'); a.FontSize=20;



%% Active

figure
subplot(311)
imagesc( Range(OBSpec.Active.(Mouse_names{mouse})), Spectro{3} , zscore_nan_BM(Data(OBSpec.Active.(Mouse_names{mouse}))')), axis xy; makepretty
l=hline([2 4 6],{'-k','-k','-k'},{'','',''});
title('Active OB Low')

subplot(312)
imagesc( Range(OBSpec.Active_Shock.(Mouse_names{mouse})), Spectro{3} , zscore_nan_BM(Data(OBSpec.Active_Shock.(Mouse_names{mouse}))')), axis xy; makepretty
l=hline([2 4 6],{'-k','-k','-k'},{'','',''});
title('Active OB Low shock')

subplot(313)
imagesc( Range(OBSpec.Active_Safe.(Mouse_names{mouse})), Spectro{3} , zscore_nan_BM(Data(OBSpec.Active_Safe.(Mouse_names{mouse}))')), axis xy; makepretty
l=hline([2 4 6],{'-k','-k','-k'},{'','',''});
title('Active OB Low safe')

figure
clear Mean_All_Sp; Mean_All_Sp=nanmean(zscore_nan_BM(Data(OBSpec.Active_Shock.(Mouse_names{mouse}))')');
plot(Spectro{3} , Mean_All_Sp/max(Mean_All_Sp),'r','linewidth',2), hold on
clear Mean_All_Sp; Mean_All_Sp=nanmean(zscore_nan_BM(Data(OBSpec.Active_Safe.(Mouse_names{mouse}))')');
plot(Spectro{3} , Mean_All_Sp/max(Mean_All_Sp),'b','linewidth',2), hold on
xlim([0 12])

figure
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data(OBSpec.Active_Shock.(Mouse_names{mouse})));
plot(Spectro{3} , Mean_All_Sp,'r','linewidth',2), hold on
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data(OBSpec.Active_Safe.(Mouse_names{mouse})));
plot(Spectro{3} , Mean_All_Sp,'b','linewidth',2), hold on
xlim([0 10])

figure
subplot(221)
Conf_Inter=nanstd(OB_Shock_Active_All.(Session_type{sess}).Saline)/sqrt(size(OB_Shock_Active_All.(Session_type{sess}).Saline,1));
shadedErrorBar(Spectro{3} , nanmean(OB_Shock_Active_All.(Session_type{sess}).Saline) , Conf_Inter,'-r',1); hold on;
Conf_Inter=nanstd(OB_Safe_Active_All.(Session_type{sess}).Saline)/sqrt(size(OB_Safe_Active_All.(Session_type{sess}).Saline,1));
shadedErrorBar(Spectro{3} , nanmean(OB_Safe_Active_All.(Session_type{sess}).Saline) , Conf_Inter,'-b',1); hold on;
makepretty
xlim([0 13])
xlabel('Frequency (Hz)'); ylabel('Power (A.U)')
f=get(gca,'Children'); legend([f(5),f(1)],'Shock side','Safe side');
title('Saline')
subplot(222)
Conf_Inter=nanstd(OB_Shock_Active_All.(Session_type{sess}).ChronicFlx)/sqrt(size(OB_Shock_Active_All.(Session_type{sess}).ChronicFlx,1));
h=shadedErrorBar(Spectro{3} , nanmean(OB_Shock_Active_All.(Session_type{sess}).ChronicFlx) , Conf_Inter,'-r',1); hold on;
h.mainLine.Color=[0.7 0 0]; h.patch.FaceColor=[1 0.6 0.6];
Conf_Inter=nanstd(OB_Safe_Active_All.(Session_type{sess}).ChronicFlx)/sqrt(size(OB_Safe_Active_All.(Session_type{sess}).ChronicFlx,1));
h=shadedErrorBar(Spectro{3} , nanmean(OB_Safe_Active_All.(Session_type{sess}).Saline) , Conf_Inter,'-b',1); hold on;
h.mainLine.Color=[0 0 0.5]; h.patch.FaceColor=[0.8 0.8 1];
f=get(gca,'Children'); legend([f(5),f(1)],'Shock side','Safe side');
makepretty
xlabel('Frequency (Hz)')
xlim([0 13])
title('Chronic Flx')

subplot(223)
Conf_Inter=nanstd(OB_Shock_Active_All.(Session_type{sess}).Saline)/sqrt(size(OB_Shock_Active_All.(Session_type{sess}).Saline,1));
shadedErrorBar(Spectro{3} , nanmean(OB_Shock_Active_All.(Session_type{sess}).Saline) , Conf_Inter,'-r',1); hold on;
Conf_Inter=nanstd(OB_Shock_Active_All.(Session_type{sess}).ChronicFlx)/sqrt(size(OB_Shock_Active_All.(Session_type{sess}).ChronicFlx,1));
h=shadedErrorBar(Spectro{3} , nanmean(OB_Shock_Active_All.(Session_type{sess}).ChronicFlx) , Conf_Inter,'-r',1); hold on;
h.mainLine.Color=[0.7 0 0]; h.patch.FaceColor=[1 0.6 0.6];
makepretty
xlim([0 13])
xlabel('Frequency (Hz)'); ylabel('Power (A.U)')
f=get(gca,'Children'); legend([f(5),f(1)],'Saline','Chronic Flx');
title('Shock side freezing')
subplot(224)
Conf_Inter=nanstd(OB_Safe_Active_All.(Session_type{sess}).Saline)/sqrt(size(OB_Safe_Active_All.(Session_type{sess}).Saline,1));
shadedErrorBar(Spectro{3} , nanmean(OB_Safe_Active_All.(Session_type{sess}).Saline) , Conf_Inter,'-b',1); hold on;
Conf_Inter=nanstd(OB_Safe_Active_All.(Session_type{sess}).ChronicFlx)/sqrt(size(OB_Safe_Active_All.(Session_type{sess}).ChronicFlx,1));
h=shadedErrorBar(Spectro{3} , nanmean(OB_Safe_Active_All.(Session_type{sess}).Saline) , Conf_Inter,'-b',1); hold on;
h.mainLine.Color=[0 0 0.5]; h.patch.FaceColor=[0.8 0.8 1];
f=get(gca,'Children'); legend([f(5),f(1)],'Saline','Chronic Flx');
makepretty
xlabel('Frequency (Hz)')
xlim([0 13])
title('Safe side freezing')

a=suptitle('OB Low spectrum, normalized, Active, fear sessions'); a.FontSize=20;

%------------------------------------------------------------------------------------------------------

figure
subplot(231)
Conf_Inter=nanstd(OB_Shock_Active_All.Cond_Pre.Saline)/sqrt(size(OB_Shock_Active_All.Cond_Pre.Saline,1));
shadedErrorBar(Spectro{3} , nanmean(OB_Shock_Active_All.Cond_Pre.Saline) , Conf_Inter,'-k',1); hold on;
Conf_Inter=nanstd(OB_Shock_Active_All.Cond_Post.Saline)/sqrt(size(OB_Shock_Active_All.Cond_Post.Saline,1));
shadedErrorBar(Spectro{3} , nanmean(OB_Shock_Active_All.Cond_Post.Saline) , Conf_Inter,'-r',1); hold on;
makepretty
xlim([0 13])
ylabel('Power (A.U)')
f=get(gca,'Children'); legend([f(16),f(4)],'Pre Drug','Post Drug');
title('Saline')
%vline(2,'--r'); vline(4,'--r'); vline(6,'--r');

subplot(234)
Conf_Inter=nanstd(OB_Safe_Active_All.Cond_Pre.Saline)/sqrt(size(OB_Safe_Active_All.Cond_Pre.Saline,1));
shadedErrorBar(Spectro{3} , nanmean(OB_Safe_Active_All.Cond_Pre.Saline) , Conf_Inter,'-k',1); hold on;
Conf_Inter=nanstd(OB_Safe_Active_All.Cond_Post.Saline)/sqrt(size(OB_Safe_Active_All.Cond_Post.Saline,1));
shadedErrorBar(Spectro{3} , nanmean(OB_Safe_Active_All.Cond_Post.Saline) , Conf_Inter,'-b',1); hold on;
makepretty
xlim([0 13])
xlabel('Frequency (Hz)'); ylabel('Power (A.U)')
f=get(gca,'Children'); legend([f(16),f(4)],'Pre Drug','Post Drug');
%vline(2,'--r'); vline(4,'--r'); vline(6,'--r');

b=text(15,-3,'--------------------------------------------------------------------------------------------------------------------','FontSize',24); set(b,'Rotation',90);

subplot(232)
Conf_Inter=nanstd(OB_Shock_Active_All.Cond_Pre.Saline)/sqrt(size(OB_Shock_Active_All.Cond_Pre.Saline,1));
shadedErrorBar(Spectro{3} , nanmean(OB_Shock_Active_All.Cond_Pre.Saline) , Conf_Inter,'-b',1); hold on;
Conf_Inter=nanstd(OB_Shock_Active_All.Cond_Pre.ChronicFlx)/sqrt(size(OB_Shock_Active_All.Cond_Pre.ChronicFlx,1));
shadedErrorBar(Spectro{3} , nanmean(OB_Shock_Active_All.Cond_Pre.ChronicFlx)+0.5 , Conf_Inter,'-r',1); hold on;
Conf_Inter=nanstd(OB_Shock_Active_All.Cond_Pre.AcuteFlx)/sqrt(size(OB_Shock_Active_All.Cond_Pre.AcuteFlx,1));
shadedErrorBar(Spectro{3} , nanmean(OB_Shock_Active_All.Cond_Pre.AcuteFlx)+1 , Conf_Inter,'-m',1); hold on;
Conf_Inter=nanstd(OB_Shock_Active_All.Cond_Pre.Midazolam)/sqrt(size(OB_Shock_Active_All.Cond_Pre.Midazolam,1));
shadedErrorBar(Spectro{3} , nanmean(OB_Shock_Active_All.Cond_Pre.Midazolam)+1.5 , Conf_Inter,'-g',1); hold on;
makepretty
xlim([0 13])
f=get(gca,'Children'); legend([f(13),f(9),f(5),f(1)],'Saline','Chronic flx','Acute Flx','Midazolam');
title('Pre Drug')
xlabel('Frequency (Hz)'); 

subplot(233)
Conf_Inter=nanstd(OB_Shock_Active_All.Cond_Post.Saline)/sqrt(size(OB_Shock_Active_All.Cond_Post.Saline,1));
shadedErrorBar(Spectro{3} , nanmean(OB_Shock_Active_All.Cond_Post.Saline) , Conf_Inter,'-b',1); hold on;
Conf_Inter=nanstd(OB_Shock_Active_All.Cond_Post.ChronicFlx)/sqrt(size(OB_Shock_Active_All.Cond_Post.ChronicFlx,1));
shadedErrorBar(Spectro{3} , nanmean(OB_Shock_Active_All.Cond_Post.ChronicFlx)+0.5 , Conf_Inter,'-r',1); hold on;
Conf_Inter=nanstd(OB_Shock_Active_All.Cond_Post.AcuteFlx)/sqrt(size(OB_Shock_Active_All.Cond_Post.AcuteFlx,1));
shadedErrorBar(Spectro{3} , nanmean(OB_Shock_Active_All.Cond_Post.AcuteFlx)+1 , Conf_Inter,'-m',1); hold on;
Conf_Inter=nanstd(OB_Shock_Active_All.Cond_Post.Midazolam)/sqrt(size(OB_Shock_Active_All.Cond_Post.Midazolam,1));
shadedErrorBar(Spectro{3} , nanmean(OB_Shock_Active_All.Cond_Post.Midazolam)+1.5 , Conf_Inter,'-g',1); hold on;
makepretty
xlim([0 13])
title('Post Drug')
xlabel('Frequency (Hz)'); 

subplot(235)
Conf_Inter=nanstd(OB_Safe_Active_All.Cond_Pre.Saline)/sqrt(size(OB_Safe_Active_All.Cond_Pre.Saline,1));
shadedErrorBar(Spectro{3} , nanmean(OB_Safe_Active_All.Cond_Pre.Saline) , Conf_Inter,'-b',1); hold on;
Conf_Inter=nanstd(OB_Safe_Active_All.Cond_Pre.ChronicFlx)/sqrt(size(OB_Safe_Active_All.Cond_Pre.ChronicFlx,1));
shadedErrorBar(Spectro{3} , nanmean(OB_Safe_Active_All.Cond_Pre.ChronicFlx)+0.5 , Conf_Inter,'-r',1); hold on;
Conf_Inter=nanstd(OB_Safe_Active_All.Cond_Pre.AcuteFlx)/sqrt(size(OB_Safe_Active_All.Cond_Pre.AcuteFlx,1));
shadedErrorBar(Spectro{3} , nanmean(OB_Safe_Active_All.Cond_Pre.AcuteFlx)+1 , Conf_Inter,'-m',1); hold on;
Conf_Inter=nanstd(OB_Safe_Active_All.Cond_Pre.Midazolam)/sqrt(size(OB_Safe_Active_All.Cond_Pre.Midazolam,1));
shadedErrorBar(Spectro{3} , nanmean(OB_Safe_Active_All.Cond_Pre.Midazolam)+1.5 , Conf_Inter,'-g',1); hold on;
makepretty
xlim([0 13])

subplot(236)
Conf_Inter=nanstd(OB_Safe_Active_All.Cond_Post.Saline)/sqrt(size(OB_Safe_Active_All.Cond_Post.Saline,1));
shadedErrorBar(Spectro{3} , nanmean(OB_Safe_Active_All.Cond_Post.Saline) , Conf_Inter,'-b',1); hold on;
Conf_Inter=nanstd(OB_Safe_Active_All.Cond_Post.ChronicFlx)/sqrt(size(OB_Safe_Active_All.Cond_Post.ChronicFlx,1));
shadedErrorBar(Spectro{3} , nanmean(OB_Safe_Active_All.Cond_Post.ChronicFlx)+0.5 , Conf_Inter,'-r',1); hold on;
Conf_Inter=nanstd(OB_Safe_Active_All.Cond_Post.AcuteFlx)/sqrt(size(OB_Safe_Active_All.Cond_Post.AcuteFlx,1));
shadedErrorBar(Spectro{3} , nanmean(OB_Safe_Active_All.Cond_Post.AcuteFlx)+1 , Conf_Inter,'-m',1); hold on;
Conf_Inter=nanstd(OB_Safe_Active_All.Cond_Post.Midazolam)/sqrt(size(OB_Safe_Active_All.Cond_Post.Midazolam,1));
shadedErrorBar(Spectro{3} , nanmean(OB_Safe_Active_All.Cond_Post.Midazolam)+1.5 , Conf_Inter,'-g',1); hold on;
makepretty
xlim([0 13])

a=suptitle('OB Low spectrum, normalized, Active, cond sessions'); a.FontSize=20;


%% Fz spectrum freezing Cond Pre & Post
figure
subplot(231)
Conf_Inter=nanstd(OB_Shock_Fz_All.Cond_Pre.Saline)/sqrt(size(OB_Shock_Fz_All.Cond_Pre.Saline,1));
shadedErrorBar(Spectro{3} , nanmean(OB_Shock_Fz_All.Cond_Pre.Saline) , Conf_Inter,'-k',1); hold on;
Conf_Inter=nanstd(OB_Shock_Fz_All.Cond_Post.Saline)/sqrt(size(OB_Shock_Fz_All.Cond_Post.Saline,1));
shadedErrorBar(Spectro{3} , nanmean(OB_Shock_Fz_All.Cond_Post.Saline) , Conf_Inter,'-r',1); hold on;
makepretty
xlim([0 10])
ylabel('Power (A.U)')
f=get(gca,'Children'); legend([f(8),f(4)],'Pre Drug','Post Drug');
title('Saline')

subplot(234)
Conf_Inter=nanstd(OB_Safe_Fz_All.Cond_Pre.Saline)/sqrt(size(OB_Safe_Fz_All.Cond_Pre.Saline,1));
shadedErrorBar(Spectro{3} , nanmean(OB_Safe_Fz_All.Cond_Pre.Saline) , Conf_Inter,'-k',1); hold on;
Conf_Inter=nanstd(OB_Safe_Fz_All.Cond_Post.Saline)/sqrt(size(OB_Safe_Fz_All.Cond_Post.Saline,1));
shadedErrorBar(Spectro{3} , nanmean(OB_Safe_Fz_All.Cond_Post.Saline) , Conf_Inter,'-b',1); hold on;
makepretty
xlim([0 10])
xlabel('Frequency (Hz)'); ylabel('Power (A.U)')
f=get(gca,'Children'); legend([f(16),f(4)],'Pre Drug','Post Drug');

b=text(12,-1.5,'--------------------------------------------------------------------------------------------------------------------','FontSize',24); set(b,'Rotation',90);

subplot(232)
Conf_Inter=nanstd(OB_Shock_Fz_All.Cond_Pre.Saline)/sqrt(size(OB_Shock_Fz_All.Cond_Pre.Saline,1));
shadedErrorBar(Spectro{3} , nanmean(OB_Shock_Fz_All.Cond_Pre.Saline) , Conf_Inter,'-b',1); hold on;
Conf_Inter=nanstd(OB_Shock_Fz_All.Cond_Pre.ChronicFlx)/sqrt(size(OB_Shock_Fz_All.Cond_Pre.ChronicFlx,1));
shadedErrorBar(Spectro{3} , nanmean(OB_Shock_Fz_All.Cond_Pre.ChronicFlx)+0.5 , Conf_Inter,'-r',1); hold on;
Conf_Inter=nanstd(OB_Shock_Fz_All.Cond_Pre.AcuteFlx)/sqrt(size(OB_Shock_Fz_All.Cond_Pre.AcuteFlx,1));
shadedErrorBar(Spectro{3} , nanmean(OB_Shock_Fz_All.Cond_Pre.AcuteFlx)+1 , Conf_Inter,'-m',1); hold on;
Conf_Inter=nanstd(OB_Shock_Fz_All.Cond_Pre.Midazolam)/sqrt(size(OB_Shock_Fz_All.Cond_Pre.Midazolam,1));
shadedErrorBar(Spectro{3} , nanmean(OB_Shock_Fz_All.Cond_Pre.Midazolam)+1.5 , Conf_Inter,'-g',1); hold on;
makepretty
xlim([0 10])
f=get(gca,'Children'); legend([f(13),f(9),f(5),f(1)],'Saline','Chronic flx','Acute Flx','Midazolam');
title('Pre Drug')

subplot(233)
Conf_Inter=nanstd(OB_Shock_Fz_All.Cond_Post.Saline)/sqrt(size(OB_Shock_Fz_All.Cond_Post.Saline,1));
shadedErrorBar(Spectro{3} , nanmean(OB_Shock_Fz_All.Cond_Post.Saline) , Conf_Inter,'-b',1); hold on;
Conf_Inter=nanstd(OB_Shock_Fz_All.Cond_Post.ChronicFlx)/sqrt(size(OB_Shock_Fz_All.Cond_Post.ChronicFlx,1));
shadedErrorBar(Spectro{3} , nanmean(OB_Shock_Fz_All.Cond_Post.ChronicFlx)+0.5 , Conf_Inter,'-r',1); hold on;
Conf_Inter=nanstd(OB_Shock_Fz_All.Cond_Post.AcuteFlx)/sqrt(size(OB_Shock_Fz_All.Cond_Post.AcuteFlx,1));
shadedErrorBar(Spectro{3} , nanmean(OB_Shock_Fz_All.Cond_Post.AcuteFlx)+1 , Conf_Inter,'-m',1); hold on;
Conf_Inter=nanstd(OB_Shock_Fz_All.Cond_Post.Midazolam)/sqrt(size(OB_Shock_Fz_All.Cond_Post.Midazolam,1));
shadedErrorBar(Spectro{3} , nanmean(OB_Shock_Fz_All.Cond_Post.Midazolam)+1.5 , Conf_Inter,'-g',1); hold on;
makepretty
xlim([0 10])
title('Post Drug')

subplot(235)
Conf_Inter=nanstd(OB_Safe_Fz_All.Cond_Pre.Saline)/sqrt(size(OB_Safe_Fz_All.Cond_Pre.Saline,1));
shadedErrorBar(Spectro{3} , nanmean(OB_Safe_Fz_All.Cond_Pre.Saline) , Conf_Inter,'-b',1); hold on;
Conf_Inter=nanstd(OB_Safe_Fz_All.Cond_Pre.ChronicFlx)/sqrt(size(OB_Safe_Fz_All.Cond_Pre.ChronicFlx,1));
shadedErrorBar(Spectro{3} , nanmean(OB_Safe_Fz_All.Cond_Pre.ChronicFlx)+0.5 , Conf_Inter,'-r',1); hold on;
Conf_Inter=nanstd(OB_Safe_Fz_All.Cond_Pre.AcuteFlx)/sqrt(size(OB_Safe_Fz_All.Cond_Pre.AcuteFlx,1));
shadedErrorBar(Spectro{3} , nanmean(OB_Safe_Fz_All.Cond_Pre.AcuteFlx)+1 , Conf_Inter,'-m',1); hold on;
Conf_Inter=nanstd(OB_Safe_Fz_All.Cond_Pre.Midazolam)/sqrt(size(OB_Safe_Fz_All.Cond_Pre.Midazolam,1));
shadedErrorBar(Spectro{3} , nanmean(OB_Safe_Fz_All.Cond_Pre.Midazolam)+1.5 , Conf_Inter,'-g',1); hold on;
makepretty
xlim([0 10])
xlabel('Frequency (Hz)');

subplot(236)
Conf_Inter=nanstd(OB_Safe_Fz_All.Cond_Post.Saline)/sqrt(size(OB_Safe_Fz_All.Cond_Post.Saline,1));
shadedErrorBar(Spectro{3} , nanmean(OB_Safe_Fz_All.Cond_Post.Saline) , Conf_Inter,'-b',1); hold on;
Conf_Inter=nanstd(OB_Safe_Fz_All.Cond_Post.ChronicFlx)/sqrt(size(OB_Safe_Fz_All.Cond_Post.ChronicFlx,1));
shadedErrorBar(Spectro{3} , nanmean(OB_Safe_Fz_All.Cond_Post.ChronicFlx)+0.5 , Conf_Inter,'-r',1); hold on;
Conf_Inter=nanstd(OB_Safe_Fz_All.Cond_Post.AcuteFlx)/sqrt(size(OB_Safe_Fz_All.Cond_Post.AcuteFlx,1));
shadedErrorBar(Spectro{3} , nanmean(OB_Safe_Fz_All.Cond_Post.AcuteFlx)+1 , Conf_Inter,'-m',1); hold on;
Conf_Inter=nanstd(OB_Safe_Fz_All.Cond_Post.Midazolam)/sqrt(size(OB_Safe_Fz_All.Cond_Post.Midazolam,1));
shadedErrorBar(Spectro{3} , nanmean(OB_Safe_Fz_All.Cond_Post.Midazolam)+1.5 , Conf_Inter,'-g',1); hold on;
makepretty
xlim([0 10]); xlabel('Frequency (Hz)');

a=suptitle('OB Low Spectrum, UMaze, drug groups, cond sessions'); a.FontSize=20;




figure
subplot(232)
MakeSpreadAndBoxPlot2_SB([{FreqMax.Saline.Cond_Pre.Shock}, {FreqMax.Saline.Cond_Post.Shock}],{[0.5 0.5 0.5],[0.5 0.2 0.2]},X,NoLegends,'showpoints',0,'paired',1);
ylabel('Frequency (Hz)')
title('Saline')
ylim([1 7])
b=text(-1,4,'Shock','FontSize',24); set(b,'Rotation',90);

subplot(235)
MakeSpreadAndBoxPlot2_SB([{FreqMax.Saline.Cond_Pre.Safe}, {FreqMax.Saline.Cond_Post.Safe}],{[0.5 0.5 0.5],[0.5 0.5 1]},X,Legends,'showpoints',0,'paired',1);
ylabel('Frequency (Hz)')
ylim([1 7])
xtickangle(45)
b=text(-1,3,'Safe','FontSize',24); set(b,'Rotation',90);

b=text(3,-1,'--------------------------------------------------------------------------------------------------------------------','FontSize',24); set(b,'Rotation',90);

subplot(232)
MakeSpreadAndBoxPlot2_SB([{FreqMax.Cond_Pre.Shock.Saline}, {FreqMax.Cond_Pre.Shock.ChronicFlx} , {FreqMax.Cond_Pre.Shock.AcuteFlx} , {FreqMax.Cond_Pre.Shock.Midazolam}],Cols2,X2,NoLegends_Drugs,'showpoints',1,'paired',0);
title('Cond Pre')
ylim([2.5 7])

subplot(233)
MakeSpreadAndBoxPlot2_SB([{FreqMax.Cond_Post.Shock.Saline}, {FreqMax.Cond_Post.Shock.ChronicFlx} , {FreqMax.Cond_Post.Shock.AcuteFlx} , {FreqMax.Cond_Post.Shock.Midazolam}],Cols2,X2,NoLegends_Drugs,'showpoints',1,'paired',0);
title('Cond Post')
ylim([2.5 7])

subplot(235)
MakeSpreadAndBoxPlot2_SB([{FreqMax.Cond_Pre.Safe.Saline}, {FreqMax.Cond_Pre.Safe.ChronicFlx} , {FreqMax.Cond_Pre.Safe.AcuteFlx} , {FreqMax.Cond_Pre.Safe.Midazolam}],Cols2,X2,Legends_Drugs,'showpoints',1,'paired',0);
ylim([1 6.5])
xtickangle(45)

subplot(236)
MakeSpreadAndBoxPlot2_SB([{FreqMax.Cond_Post.Safe.Saline}, {FreqMax.Cond_Post.Safe.ChronicFlx} , {FreqMax.Cond_Post.Safe.AcuteFlx} , {FreqMax.Cond_Post.Safe.Midazolam}],Cols2,X2,Legends_Drugs,'showpoints',1,'paired',0);
ylim([1 6.5])
xtickangle(45)

a=suptitle('Mean spectrum, UMaze, drug groups, cond sessions'); a.FontSize=20;







%% Ripples


length(RipplesFreezing.Shock.(Session_type{sess}).(Mouse_names{mouse}))

subplot(233)
MakeSpreadAndBoxPlot2_SB([{RipplesFreezing.Saline.Cond_Pre.Shock}, {RipplesFreezing.Saline.Cond_Post.Shock}],{[0.5 0.5 0.5],[0.5 0.2 0.2]},X,NoLegends,'showpoints',0,'paired',1);
ylim([0 0.5])

subplot(236)
MakeSpreadAndBoxPlot2_SB([{RipplesFreezing.Saline.Cond_Pre.Safe}, {RipplesFreezing.Saline.Cond_Post.Safe}],{[0.5 0.5 0.5],[0.5 0.5 1]},X,Legends,'showpoints',0,'paired',1);
ylim([0 0.5])










