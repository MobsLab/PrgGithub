

% after running AllSalineAnalysis_Maze_Paper_SBM

figure
subplot(121)
MakeSpreadAndBoxPlot2_SB({FreezeTime_Shock.(Session_type{sess}) FreezeTime_Safe.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('time (s)'), title('Freezing duration')
subplot(122)
MakeSpreadAndBoxPlot2_SB({ActiveTime_Shock.TestPost+FreezeTime_Shock.TestPost  ActiveTime_Safe.TestPost+FreezeTime_Safe.TestPost},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('time (s)'), title('Freezing duration')


% after running Nicotine_Analysis_Sleep_BM

Cols2 = {[1 .5 .5],[.5 .5 1],[.5 1 .5]};
X2 = [1:3];
Legends2 = {'Shock','Safe','Nicotine'};

Cols1 = {[.8 .8 .8],[.5 1 .5]};
X1 = [1:2];
Legends1 = {'Saline','Nicotine'};

load('')

figure
MakeSpreadAndBoxPlot3_SB({FreezeTime.Just_Aft_Inj{1}./time_aft_inj FreezeTime.Just_Aft_Inj{4}./time_aft_inj},Cols1,X1,Legends1,'showpoints',1,'paired',0);
ylabel('proportion')
title('Freezing proportion')

figure
subplot(121)
MakeSpreadAndBoxPlot2_SB({Respi_Shock_Fz.Ext Respi_Safe_Fz.Ext Respi_mean.FreezeAccEpoch{4}},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('Frequency (Hz)')

subplot(122)
MakeSpreadAndBoxPlot2_SB({Ripples_Shock_Fz.Ext Ripples_Safe_Fz.Ext RipDensity_mean.FreezeAccEpoch{4}},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('#/s')


%% after running DrugsGroups_Comparison_Overview_Maze_BM.m
% chronic flx
Cols2 = {[1 .5 .5],[1 .8 .8],[.5 .5 1],[.8 .8 1]};
X2 = [1:4];
Legends2 = {'Saline','Chronic Flx','Saline','Chronic Flx'};


OutPutData.SalineSB.Ext.ripples.mean(OutPutData.SalineSB.Ext.ripples.mean==0)=NaN;
OutPutData.ChronicFlx.Ext.ripples.mean(OutPutData.ChronicFlx.Ext.ripples.mean==0)=NaN;

figure; sess=5;
subplot(151)
MakeSpreadAndBoxPlot2_SB({Proportionnal_Time_Freezing_ofZone.(Side{2}).(Session_type{sess}){[1 2]} Proportionnal_Time_Freezing_ofZone.(Side{3}).(Session_type{sess}){[1 2]}},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('proportion')
subplot(152)
MakeSpreadAndBoxPlot2_SB({FzEpNumber.Shock.(Session_type{sess}){[1 2]} FzEpNumber.Safe.(Session_type{sess}){[1 2]}},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('#')
subplot(153)
MakeSpreadAndBoxPlot2_SB({ShockZoneEntries_Density.(Session_type{sess}){[1 2]} SafeZoneEntries_Density.(Session_type{sess}){[1 2]}},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('entries/min')
sess=4;
subplot(154)
MakeSpreadAndBoxPlot2_SB({OutPutData.SalineSB.Ext.ripples.mean(:,5) OutPutData.ChronicFlx.Ext.ripples.mean(:,5) OutPutData.SalineSB.Ext.ripples.mean(:,6) OutPutData.ChronicFlx.Ext.ripples.mean(:,6)},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('#/s'), ylim([0 1.3])
subplot(155)
MakeSpreadAndBoxPlot2_SB({OutPutData.SalineSB.Ext.respi_freq_BM.mean(:,5) OutPutData.ChronicFlx.Ext.respi_freq_BM.mean(:,5) OutPutData.SalineSB.Ext.respi_freq_BM.mean(:,6) OutPutData.ChronicFlx.Ext.respi_freq_BM.mean(:,6)},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('Frequency (Hz)')


% diazepam
Cols2 = {[1 .5 .5],[1 .8 .8],[.5 .5 1],[.8 .8 1]};
X2 = [1:4];
Legends2 = {'Saline','Diazepam','Saline','Diazepam'};


OutPutData.Saline.CondPost.ripples.mean(OutPutData.Saline.CondPost.ripples.mean==0)=NaN;
OutPutData.Diazepam.CondPost.ripples.mean(OutPutData.Diazepam.CondPost.ripples.mean==0)=NaN;

figure; sess=5;
subplot(151)
MakeSpreadAndBoxPlot2_SB({Proportionnal_Time_Freezing_ofZone.(Side{2}).(Session_type{sess}){[1 2]} Proportionnal_Time_Freezing_ofZone.(Side{3}).(Session_type{sess}){[1 2]}},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('proportion')
subplot(152)
MakeSpreadAndBoxPlot2_SB({FzEpNumber.Shock.(Session_type{sess}){[1 2]} FzEpNumber.Safe.(Session_type{sess}){[1 2]}},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('#')
subplot(153)
MakeSpreadAndBoxPlot2_SB({ShockZoneEntries_Density.(Session_type{sess}){[1 2]} SafeZoneEntries_Density.(Session_type{sess}){[1 2]}},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('entries/min')
subplot(154)
MakeSpreadAndBoxPlot2_SB({OutPutData.Saline.CondPost.ripples.mean(:,5) OutPutData.Diazepam.CondPost.ripples.mean(:,5) OutPutData.Saline.CondPost.ripples.mean(:,6) OutPutData.Diazepam.CondPost.ripples.mean(:,6)},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('#/s'), ylim([0 1.5])
subplot(155)
MakeSpreadAndBoxPlot2_SB({OutPutData.Saline.CondPost.respi_freq_BM.mean(:,5) OutPutData.Diazepam.CondPost.respi_freq_BM.mean(:,5) OutPutData.Saline.CondPost.respi_freq_BM.mean(:,6) OutPutData.Diazepam.CondPost.respi_freq_BM.mean(:,6)},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('Frequency (Hz)')



% rip inhib
Cols2 = {[1 .5 .5],[1 .8 .8],[.5 .5 1],[.8 .8 1]};
X2 = [1:4];
Legends2 = {'Rip Control','Rip Inhib','Rip Control','Rip Inhib'};

figure; sess=5;
subplot(151)
MakeSpreadAndBoxPlot2_SB({Proportionnal_Time_Freezing_ofZone.(Side{2}).(Session_type{sess}){[3 4]} Proportionnal_Time_Freezing_ofZone.(Side{3}).(Session_type{sess}){[3 4]}},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('proportion')
subplot(152)
MakeSpreadAndBoxPlot2_SB({FzEpNumber.Shock.(Session_type{sess}){[3 4]} FzEpNumber.Safe.(Session_type{sess}){[3 4]}},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('#')
subplot(153)
MakeSpreadAndBoxPlot2_SB({ShockZoneEntries_Density.(Session_type{sess}){[3 4]} SafeZoneEntries_Density.(Session_type{sess}){[3 4]}},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('entries/min')
subplot(154)
MakeSpreadAndBoxPlot2_SB({OutPutData.RipControl.CondPost.ripples.mean(:,5) OutPutData.RipInhib.CondPost.ripples.mean(:,5) OutPutData.RipControl.CondPost.ripples.mean(:,6) OutPutData.RipInhib.CondPost.ripples.mean(:,6)},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('#/s'), ylim([0 1.5])
subplot(155)
MakeSpreadAndBoxPlot2_SB({OutPutData.RipControl.CondPost.respi_freq_BM.mean(:,5) OutPutData.RipInhib.CondPost.respi_freq_BM.mean(:,5) OutPutData.RipControl.CondPost.respi_freq_BM.mean(:,6) OutPutData.RipInhib.CondPost.respi_freq_BM.mean(:,6)},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('Frequency (Hz)')


figure
MakeSpreadAndBoxPlot2_SB({OutPutData.RipControl.Ext.ripples.mean(:,5) OutPutData.RipInhib.Ext.ripples.mean(:,5) OutPutData.RipControl.Ext.ripples.mean(:,6) OutPutData.RipInhib.Ext.ripples.mean(:,6)},Cols2,X2,Legends2,'showpoints',1,'paired',0);



