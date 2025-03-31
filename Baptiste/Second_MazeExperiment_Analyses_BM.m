




figure
subplot(151)
MakeSpreadAndBoxPlot3_SB(ShockZoneEntries_Density.Cond...
    ,{[.3, .745, .93],[.85, .325, .098],[.1, .745, .73],[.65, .325, .098]},1:4,{'Saline1','Diazepam1','Saline2','Diazepam2'},'showpoints',1,'paired',0);
ylabel('#/min active')
title('Shock zone entries, Cond')

subplot(152)
MakeSpreadAndBoxPlot3_SB(ShockZoneEntries_Density.TestPost...
    ,{[.3, .745, .93],[.85, .325, .098],[.1, .745, .73],[.65, .325, .098]},1:4,{'Saline1','Diazepam1','Saline2','Diazepam2'},'showpoints',1,'paired',0);
ylabel('#/min active'), ylim([0 3])
title('Shock zone entries, TestPost')

% axes('Position',[.39 .75 .05 .2]); box on
% MakeSpreadAndBoxPlot3_SB(Proportional_Time_Unblocked.(Side{2}).TestPost...
%     ,{[.3, .745, .93],[.85, .325, .098],[.1, .745, .73],[.65, .325, .098]},1:4,{'','','',''},'showpoints',1,'paired',0);
% ylabel('prop'), ylim([0 .3])
% title('Occupancy')

subplot(153)
MakeSpreadAndBoxPlot3_SB(Tigmo_score_all.Active_Unblocked.Cond...
    ,{[.3, .745, .93],[.85, .325, .098],[.1, .745, .73],[.65, .325, .098]},1:4,{'Saline1','Diazepam1','Saline2','Diazepam2'},'showpoints',1,'paired',0);
ylabel('thigmo score (a.u.)')
title('Thigmotaxis, Cond')

subplot(154)
MakeSpreadAndBoxPlot3_SB(Proportionnal_Time_Freezing_ofZone.Shock.Cond...
    ,{[.3, .745, .93],[.85, .325, .098],[.1, .745, .73],[.65, .325, .098]},1:4,{'Saline1','Diazepam1','Saline2','Diazepam2'},'showpoints',1,'paired',0);
ylabel('proportion')
title('Shock fz duration, Cond')

subplot(155)
MakeSpreadAndBoxPlot3_SB(Proportionnal_Time_Freezing_ofZone.Safe.Cond...
    ,{[.3, .745, .93],[.85, .325, .098],[.1, .745, .73],[.65, .325, .098]},1:4,{'Saline1','Diazepam1','Saline2','Diazepam2'},'showpoints',1,'paired',0);
ylabel('proportion')
title('Safe fz duration, Cond')

a=suptitle('Comparing first and second Maze experiments, Saline-DZP'); a.FontSize=20;



%% ephys
figure
sess=5; 
subplot(221); thr=13;
[m1,Freq_Shock_Sal] = max(squeeze(OutPutData.Saline.(Session_type{sess}).ob_low.mean(:,5,thr:end))');
Data_to_use = squeeze(OutPutData.Saline.(Session_type{sess}).ob_low.mean(:,5,:))./m1';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-r',1); hold on;
[c,d]=max(Mean_All_Sp(thr+1:end));

[m1,Freq_Shock_DZP] = max(squeeze(OutPutData.Diazepam.(Session_type{sess}).ob_low.mean(:,5,thr:end))');
Data_to_use = squeeze(OutPutData.Diazepam.(Session_type{sess}).ob_low.mean(:,5,:))./m1';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'--r',1); hold on;
col= [1 .3 .3]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
[c,d]=max(Mean_All_Sp(thr+1:end));

u=vline(2.213,'-b'); set(u,'LineWidth',2);
u=vline(4.196,'-r'); set(u,'LineWidth',2);
u=vline(3.357,'--r'); set(u,'LineWidth',2);


f=get(gca,'Children');
a=legend([f(5),f(1)],'Saline','Diazepam');
makepretty; xlabel('Frequency (Hz)'); ylabel('Power (a.u.)'); xticks([0:2:10]); xlim([0 10]); ylim([0 1])
title('Shock freezing')


subplot(222)
[m1,Freq_Safe_Sal] = max(squeeze(OutPutData.Saline.(Session_type{sess}).ob_low.mean(:,6,thr:end))');
Data_to_use = squeeze(OutPutData.Saline.(Session_type{sess}).ob_low.mean(:,6,:))./m1';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-b',1); hold on;
[c,d]=max(Mean_All_Sp(thr+1:end));

[m1,Freq_Safe_DZP] = max(squeeze(OutPutData.Diazepam.(Session_type{sess}).ob_low.mean(:,6,thr:end))');
Data_to_use = squeeze(OutPutData.Diazepam.(Session_type{sess}).ob_low.mean(:,6,:))./m1';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'--b',1); hold on;
col= [.3 .3 1]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
[c,d]=max(Mean_All_Sp(thr+1:end));

u=vline(2.213,'-b'); set(u,'LineWidth',2);
u=vline(4.196,'-r'); set(u,'LineWidth',2);
u=vline(2.594,'--b'); set(u,'LineWidth',2);

f=get(gca,'Children');
a=legend([f(5),f(1)],'Saline','Diazepam');
makepretty; xlabel('Frequency (Hz)'); ylabel('Power (a.u.)'); xticks([0:2:10]); xlim([0 10]); ylim([0 1])


% 2nd Maze
subplot(223); thr=13;
[m1,Freq_Shock_Sal2] = max(squeeze(OutPutData.Saline2.(Session_type{sess}).ob_low.mean(:,5,thr:end))');
Data_to_use = squeeze(OutPutData.Saline2.(Session_type{sess}).ob_low.mean(:,5,:))./m1';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-r',1); hold on;
[c,d]=max(Mean_All_Sp(thr+1:end));

[m1,Freq_Shock_DZP2] = max(squeeze(OutPutData.DZP2.(Session_type{sess}).ob_low.mean(:,5,thr:end))');
Data_to_use = squeeze(OutPutData.DZP2.(Session_type{sess}).ob_low.mean(:,5,:))./m1';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'--r',1); hold on;
col= [1 .3 .3]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
[c,d]=max(Mean_All_Sp(thr+1:end));

u=vline(1.755,'-b'); set(u,'LineWidth',2);
u=vline(3.891,'-r'); set(u,'LineWidth',2);
u=vline(3.738,'--r'); set(u,'LineWidth',2);

f=get(gca,'Children');
a=legend([f(5),f(1)],'Saline2','Diazepam2');
makepretty; xlabel('Frequency (Hz)'); ylabel('Power (a.u.)'); xticks([0:2:10]); xlim([0 10]); ylim([0 1])
title('Safe freezing')


subplot(224)
[m1,Freq_Safe_Sal2] = max(squeeze(OutPutData.Saline2.(Session_type{sess}).ob_low.mean(:,6,thr:end))');
Data_to_use = squeeze(OutPutData.Saline2.(Session_type{sess}).ob_low.mean(:,6,:))./m1';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-b',1); hold on;
[c,d]=max(Mean_All_Sp(thr+1:end));

[m1,Freq_Safe_DZP2] = max(squeeze(OutPutData.DZP2.(Session_type{sess}).ob_low.mean(:,6,thr:end))');
Data_to_use = squeeze(OutPutData.DZP2.(Session_type{sess}).ob_low.mean(:,6,:))./m1';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'--b',1); hold on;
col= [.3 .3 1]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
[c,d]=max(Mean_All_Sp(thr+1:end));

u=vline(1.755,'-b'); set(u,'LineWidth',2);
u=vline(3.891,'-r'); set(u,'LineWidth',2);
u=vline(3.433,'--b'); set(u,'LineWidth',2);

f=get(gca,'Children');
a=legend([f(5),f(1)],'Saline2','Diazepam2');
makepretty; xlabel('Frequency (Hz)'); ylabel('Power (a.u.)'); xticks([0:2:10]); xlim([0 10]); ylim([0 1])


%%
Freq_Shock_Sal = RangeLow(Freq_Shock_Sal+thr-1);
Freq_Safe_Sal = RangeLow(Freq_Safe_Sal+thr-1);
Freq_Shock_DZP = RangeLow(Freq_Shock_DZP+thr-1);
Freq_Safe_DZP = RangeLow(Freq_Safe_DZP+thr-1);

Freq_Shock_Sal2 = RangeLow(Freq_Shock_Sal2+thr-1);
Freq_Safe_Sal2 = RangeLow(Freq_Safe_Sal2+thr-1);
Freq_Shock_DZP2 = RangeLow(Freq_Shock_DZP2+thr-1);
Freq_Safe_DZP2 = RangeLow(Freq_Safe_DZP2+thr-1);



figure, sess=5;
subplot(121)
MakeSpreadAndBoxPlot3_SB(Ripples_Shock.(Session_type{sess}),{[.3, .745, .93],[.85, .325, .098],[.1, .745, .73],[.65, .325, .098]},...
    1:4,{'Saline1','Diazepam1','Saline2','Diazepam2'},'showpoints',1,'paired',0);
title('Cond')
ylabel('#/s'), ylim([0 1])

sess=4;
subplot(122)
MakeSpreadAndBoxPlot3_SB(Ripples_Shock.(Session_type{sess}),{[.3, .745, .93],[.85, .325, .098],[.1, .745, .73],[.65, .325, .098]},...
    1:4,{'Saline1','Diazepam1','Saline2','Diazepam2'},'showpoints',1,'paired',0);
title('Ext'), ylim([0 1])

a=suptitle('Ripples occurence during freezing'); a.FontSize=20;

Cols={[1 .5 .5],[.5 .5 1]};
X=[1:2];
Legends={'Shock','Safe'};

figure
subplot(141)
MakeSpreadAndBoxPlot3_SB({Freq_Shock_Sal Freq_Safe_Sal},Cols,X,Legends,'showpoints',0,'paired',1);
ylim([1 7]), title('Saline1')

subplot(142)
MakeSpreadAndBoxPlot3_SB({Freq_Shock_DZP Freq_Safe_DZP},Cols,X,Legends,'showpoints',0,'paired',1);
ylim([1 7]), title('DZP1')

subplot(143)
MakeSpreadAndBoxPlot3_SB({OB_Max_Freq.Saline2.Cond.Shock OB_Max_Freq.Saline2.Cond.Safe},Cols,X,Legends,'showpoints',0,'paired',1);
ylim([1 7]), title('Saline2')

subplot(144)
MakeSpreadAndBoxPlot3_SB({OB_Max_Freq.DZP2.Cond.Shock OB_Max_Freq.DZP2.Cond.Safe},Cols,X,Legends,'showpoints',0,'paired',1);
ylim([1 7]), title('DZP2')



figure
subplot(141)
MakeSpreadAndBoxPlot3_SB({OB_Max_Freq.SalineBM.Ext.Shock OB_Max_Freq.SalineBM.Ext.Safe},Cols,X,Legends,'showpoints',0,'paired',1);
ylim([1 7]), ylabel('Frequency (Hz)'), title('Saline1')

subplot(142)
MakeSpreadAndBoxPlot3_SB({OB_Max_Freq.Diazepam.Ext.Shock OB_Max_Freq.Diazepam.Ext.Safe},Cols,X,Legends,'showpoints',0,'paired',1);
ylim([1 7]), title('DZP1')

subplot(143)
MakeSpreadAndBoxPlot3_SB({OB_Max_Freq.Saline2.Ext.Shock OB_Max_Freq.Saline2.Ext.Safe},Cols,X,Legends,'showpoints',0,'paired',1);
ylim([1 7]), title('Saline2')

subplot(144)
MakeSpreadAndBoxPlot3_SB({OB_Max_Freq.DZP2.Ext.Shock OB_Max_Freq.DZP2.Ext.Safe},Cols,X,Legends,'showpoints',0,'paired',1);
ylim([1 7]), title('DZP2')

a=suptitle('Respiratory rate during freezing, Ext'); a.FontSize=20;





figure
subplot(131)
MakeSpreadAndBoxPlot3_SB({[OB_Max_Freq.SalineBM.Ext.Shock OB_Max_Freq.Saline2.Ext.Shock] [OB_Max_Freq.SalineBM.Ext.Safe OB_Max_Freq.Saline2.Ext.Safe]},Cols,X,Legends,'showpoints',0,'paired',1);
ylim([1 7]), title('Saline')
ylabel('Frequency (Hz)')

subplot(132)
MakeSpreadAndBoxPlot3_SB({[OB_Max_Freq.Diazepam.Ext.Shock OB_Max_Freq.DZP2.Ext.Shock] [OB_Max_Freq.Diazepam.Ext.Safe OB_Max_Freq.DZP2.Ext.Safe]},Cols,X,Legends,'showpoints',0,'paired',1);
ylim([1 7]), title('Diazepam')


Diff_Respi{1} = OB_Max_Freq.SalineBM.(Session_type{sess}).Shock-OB_Max_Freq.SalineBM.(Session_type{sess}).Safe;
Diff_Respi{2} = OB_Max_Freq.Diazepam.(Session_type{sess}).Shock-OB_Max_Freq.Diazepam.(Session_type{sess}).Safe;
Diff_Respi{3} = OB_Max_Freq.Saline2.(Session_type{sess}).Shock-OB_Max_Freq.Saline2.(Session_type{sess}).Safe;
Diff_Respi{4} = OB_Max_Freq.DZP2.(Session_type{sess}).Shock-OB_Max_Freq.DZP2.(Session_type{sess}).Safe;

[h,p] = ttest(Diff_Respi{1},zeros(1,length(Diff_Respi{1})))
[h,p] = ttest(Diff_Respi{2},zeros(1,length(Diff_Respi{2})))
[h,p] = ttest(Diff_Respi{3},zeros(1,length(Diff_Respi{3})))
[h,p] = ttest(Diff_Respi{4},zeros(1,length(Diff_Respi{4})))


subplot(133)
MakeSpreadAndBoxPlot3_SB({[Diff_Respi{1} Diff_Respi{3}] [Diff_Respi{2} Diff_Respi{4}]},{[.3, .745, .93],[.85, .325, .098]},...
    1:2,{'Saline','Diazepam'},'showpoints',1,'paired',0);
u=hline(0); set(u,'LineWidth',2); ylim([-1 3.5])
title('Respi diff')








