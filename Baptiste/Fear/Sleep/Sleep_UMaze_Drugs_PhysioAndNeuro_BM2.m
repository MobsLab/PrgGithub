


Cols = {[0.66 0.66 1],[0 0 1],[0 0 0.33]};
X = [1,2,3];
Legends ={'Sleep Pre C' 'Sleep Post C Pre D' 'Sleep Post C Post D'};
NoLegends ={'' '' ''};

X2 = [1,2,3,4,5];
Cols2 = {[0, 0, 1],[1, 0, 0],[1, 0.5, 0.5],[0, 0.5, 0],[0.4940, 0.1840, 0.5560]};
Legends_Drugs ={'Saline' 'Chronic Flx' 'Acute Flx' 'Midazolam' 'Classic'};
NoLegends_Drugs ={'' '' '' '' ''};

a=figure; a.Position=[1e3 1e3 1e3 1e3];
subplot(341)
MakeSpreadAndBoxPlot2_SB(REM_prop.Saline,Cols,X,NoLegends,'showpoints',0);
ylabel('REM proportion (%)')
title('Saline')
ylim([0 19])
subplot(345)
MakeSpreadAndBoxPlot2_SB(Sleep_prop.Saline,Cols,X,NoLegends,'showpoints',0);
ylabel('Sleep proportion (%)');
ylim([0 100])
subplot(349)
MakeSpreadAndBoxPlot2_SB(RipplesDensity.Saline,Cols,X,Legends,'showpoints',0);
ylabel('Ripples density (riiples/sec)');  xtickangle(45)
ylim([0 0.5])

for sleep_sess=1:3
    
    subplot(3,4,1+sleep_sess)
    MakeSpreadAndBoxPlot2_SB({REM_prop.Saline(:,sleep_sess) REM_prop.ChronicFlx(:,sleep_sess) REM_prop.AcuteFlx(:,sleep_sess)  REM_prop.Midazolam(:,sleep_sess)  REM_prop.Classic(:,sleep_sess)},Cols2,X2,NoLegends_Drugs,'showpoints',1,'paired',0);
    if sleep_sess==1; title('Sleep Pre C'); elseif sleep_sess==2; title('Sleep Post C Pre D'); else title('Sleep Post C Post D'); end
    ylim([0 19])
    
    subplot(3,4,5+sleep_sess)
    MakeSpreadAndBoxPlot2_SB({Sleep_prop.Saline(:,sleep_sess) Sleep_prop.ChronicFlx(:,sleep_sess) Sleep_prop.AcuteFlx(:,sleep_sess)  Sleep_prop.Midazolam(:,sleep_sess)  Sleep_prop.Classic(:,sleep_sess)},Cols2,X2,NoLegends_Drugs,'showpoints',1,'paired',0);
    ylim([0 100])
    
    subplot(3,4,9+sleep_sess)
    MakeSpreadAndBoxPlot2_SB({RipplesDensity.Saline(:,sleep_sess) RipplesDensity.ChronicFlx(:,sleep_sess) RipplesDensity.AcuteFlx(:,sleep_sess)  RipplesDensity.Midazolam(:,sleep_sess)  RipplesDensity.Classic(:,sleep_sess)},Cols2,X2,Legends_Drugs,'showpoints',1,'paired',0);
    ylim([0 0.5])
    xtickangle(45)
    
end
a=suptitle('Sleep characteristics, UMaze, drugs experiments'); a.FontSize=30;




a=figure; a.Position=[1e3 1e3 1e3 1e3];
subplot(341)
MakeSpreadAndBoxPlot2_SB(N1_prop.Saline,Cols,X,NoLegends,'showpoints',0);
ylabel('N1 proportion (%)');
title('Saline')
ylim([0 20])
subplot(345)
MakeSpreadAndBoxPlot2_SB(N2_prop.Saline,Cols,X,NoLegends,'showpoints',0);
ylabel('N2 proportion (%)');
ylim([0 110])
subplot(349)
MakeSpreadAndBoxPlot2_SB(N3_prop.Saline,Cols,X,Legends,'showpoints',0);
ylabel('N3 proportion (%)');  xtickangle(45)
ylim([0 110])

for sleep_sess=1:3
    
    subplot(3,4,1+sleep_sess)
    MakeSpreadAndBoxPlot2_SB({N1_prop.Saline(:,sleep_sess) N1_prop.ChronicFlx(:,sleep_sess) N1_prop.AcuteFlx(:,sleep_sess)  N1_prop.Midazolam(:,sleep_sess)  N1_prop.Classic(:,sleep_sess)},Cols2,X2,NoLegends_Drugs,'showpoints',1,'paired',0);
    if sleep_sess==1; title('Sleep Pre C'); elseif sleep_sess==2; title('Sleep Post C Pre D'); else title('Sleep Post C Post D'); end
    ylim([0 20])
    
    subplot(3,4,5+sleep_sess)
    MakeSpreadAndBoxPlot2_SB({N2_prop.Saline(:,sleep_sess) N2_prop.ChronicFlx(:,sleep_sess) N2_prop.AcuteFlx(:,sleep_sess)  N2_prop.Midazolam(:,sleep_sess)  N2_prop.Classic(:,sleep_sess)},Cols2,X2,NoLegends_Drugs,'showpoints',1,'paired',0);
    ylim([0 110])
    
    subplot(3,4,9+sleep_sess)
    MakeSpreadAndBoxPlot2_SB({N3_prop.Saline(:,sleep_sess) N3_prop.ChronicFlx(:,sleep_sess) N3_prop.AcuteFlx(:,sleep_sess)  N3_prop.Midazolam(:,sleep_sess)  N3_prop.Classic(:,sleep_sess)},Cols2,X2,Legends_Drugs,'showpoints',1,'paired',0);
    ylim([0 110])
    xtickangle(45)
    
end
a=suptitle('Sleep characteristics, NREM substages, drugs experiments'); a.FontSize=30;



a=figure; a.Position=[1e3 1e3 1e3 1e3];
subplot(441)
MakeSpreadAndBoxPlot2_SB(AbsoluteTemperature.Saline,Cols,X,NoLegends,'showpoints',0);
ylabel('Absolute Temperature (°C)');
title('Saline')
ylim([27 32])
subplot(445)
MakeSpreadAndBoxPlot2_SB(Temperature_Wake.Saline,Cols,X,NoLegends,'showpoints',0);
ylabel('Temperature Wake');
ylim([-0.2 1])
subplot(449)
MakeSpreadAndBoxPlot2_SB(Temperature_NREM.Saline,Cols,X,Legends,'showpoints',0);
ylabel('Temperature NREM');  xtickangle(45)
ylim([-0.6 0.2])
subplot(4,4,13)
MakeSpreadAndBoxPlot2_SB(Temperature_REM.Saline,Cols,X,Legends,'showpoints',0);
ylabel('Temperature REM');  xtickangle(45)
ylim([-0.8 0.3])

for sleep_sess=1:3
    
    subplot(4,4,1+sleep_sess)
    MakeSpreadAndBoxPlot2_SB({AbsoluteTemperature.Saline(:,sleep_sess) AbsoluteTemperature.ChronicFlx(:,sleep_sess) AbsoluteTemperature.AcuteFlx(:,sleep_sess)  AbsoluteTemperature.Midazolam(:,sleep_sess)  AbsoluteTemperature.Classic(:,sleep_sess)},Cols2,X2,NoLegends_Drugs,'showpoints',1,'paired',0);
    if sleep_sess==1; title('Sleep Pre'); elseif sleep_sess==2; title('Sleep Post Pre'); else title('Sleep Post Post'); end
    ylim([27 32])
    
    subplot(4,4,5+sleep_sess)
    MakeSpreadAndBoxPlot2_SB({Temperature_Wake.Saline(:,sleep_sess) Temperature_Wake.ChronicFlx(:,sleep_sess) Temperature_Wake.AcuteFlx(:,sleep_sess)  Temperature_Wake.Midazolam(:,sleep_sess)  Temperature_Wake.Classic(:,sleep_sess)},Cols2,X2,NoLegends_Drugs,'showpoints',1,'paired',0);
    ylim([-0.2 1])
    
    subplot(4,4,9+sleep_sess)
    MakeSpreadAndBoxPlot2_SB({Temperature_NREM.Saline(:,sleep_sess) Temperature_NREM.ChronicFlx(:,sleep_sess) Temperature_NREM.AcuteFlx(:,sleep_sess)  Temperature_NREM.Midazolam(:,sleep_sess)  Temperature_NREM.Classic(:,sleep_sess)},Cols2,X2,NoLegends_Drugs,'showpoints',1,'paired',0);
    ylim([-0.6 0.2])
    
    subplot(4,4,13+sleep_sess)
    MakeSpreadAndBoxPlot2_SB({Temperature_REM.Saline(:,sleep_sess) Temperature_REM.ChronicFlx(:,sleep_sess) Temperature_REM.AcuteFlx(:,sleep_sess)  Temperature_REM.Midazolam(:,sleep_sess)  Temperature_REM.Classic(:,sleep_sess)},Cols2,X2,Legends_Drugs,'showpoints',1,'paired',0);
    ylim([-0.8 0.3])
    xtickangle(45)
    
end
a=suptitle('Sleep characteristics, temperature, drugs experiments'); a.FontSize=20;



a=figure; a.Position=[1e3 1e3 1e3 1e3];
subplot(441)
MakeSpreadAndBoxPlot2_SB(MeanEKG.Saline,Cols,X,NoLegends,'showpoints',0);
ylabel('Mean EKG (Hz)');
title('Saline')
ylim([7 12])
subplot(445)
MakeSpreadAndBoxPlot2_SB(EKG_Wake.Saline,Cols,X,NoLegends,'showpoints',0);
ylabel('EKG Wake (Hz)');
ylim([8.5 13])
subplot(449)
MakeSpreadAndBoxPlot2_SB(EKG_NREM.Saline,Cols,X,NoLegends,'showpoints',0);
ylabel('EKG NREM (Hz)');  xtickangle(45)
ylim([6 9.5])
subplot(4,4,13)
MakeSpreadAndBoxPlot2_SB(EKG_REM.Saline,Cols,X,Legends,'showpoints',0);
ylabel('EKG REM (Hz)');  xtickangle(45)
ylim([6.8 11.2])

for sleep_sess=1:3
    
    subplot(4,4,1+sleep_sess)
    MakeSpreadAndBoxPlot2_SB({MeanEKG.Saline(:,sleep_sess) MeanEKG.ChronicFlx(:,sleep_sess) MeanEKG.AcuteFlx(:,sleep_sess)  MeanEKG.Midazolam(:,sleep_sess)  MeanEKG.Classic(:,sleep_sess)},Cols2,X2,NoLegends_Drugs,'showpoints',1,'paired',0);
    if sleep_sess==1; title('Sleep Pre C'); elseif sleep_sess==2; title('Sleep Post C Pre D'); else title('Sleep Post C Post D'); end
    ylim([7 12])
    
    subplot(4,4,5+sleep_sess)
    MakeSpreadAndBoxPlot2_SB({EKG_Wake.Saline(:,sleep_sess) EKG_Wake.ChronicFlx(:,sleep_sess) EKG_Wake.AcuteFlx(:,sleep_sess)  EKG_Wake.Midazolam(:,sleep_sess)  EKG_Wake.Classic(:,sleep_sess)},Cols2,X2,NoLegends_Drugs,'showpoints',1,'paired',0);
    ylim([8.5 13])
    
    subplot(4,4,9+sleep_sess)
    MakeSpreadAndBoxPlot2_SB({EKG_NREM.Saline(:,sleep_sess) EKG_NREM.ChronicFlx(:,sleep_sess) EKG_NREM.AcuteFlx(:,sleep_sess)  EKG_NREM.Midazolam(:,sleep_sess)  EKG_NREM.Classic(:,sleep_sess)},Cols2,X2,NoLegends_Drugs,'showpoints',1,'paired',0);
ylim([6 9.5])
    
    subplot(4,4,13+sleep_sess)
    MakeSpreadAndBoxPlot2_SB({EKG_REM.Saline(:,sleep_sess) EKG_REM.ChronicFlx(:,sleep_sess) EKG_REM.AcuteFlx(:,sleep_sess)  EKG_REM.Midazolam(:,sleep_sess)  EKG_REM.Classic(:,sleep_sess)},Cols2,X2,Legends_Drugs,'showpoints',1,'paired',0);
    ylim([6.8 11.2])
    xtickangle(45)
    
end
a=suptitle('Sleep characteristics, heart rate, drugs experiments'); a.FontSize=30;




