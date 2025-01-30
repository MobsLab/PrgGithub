

%% rip control / rip inhib, based on 15/02/2024
OB_Max_Freq.RipControl.Cond.Shock=[4.578 4.501 5.951 5.112 4.807 NaN 3.891 4.578 3.738 NaN];
OB_Max_Freq.RipControl.Cond.Safe=[3.51 4.501 4.272 NaN 4.12 NaN 3.586 3.738 3.204 NaN];

OB_Max_Freq.RipInhib.Cond.Shock=[4.272 4.196 NaN 5.417 4.883 4.959 4.73 4.807 NaN 5.875];
OB_Max_Freq.RipInhib.Cond.Safe=[4.272 5.112 4.578 4.73 4.883 4.807 4.349 4.501 NaN 4.425];


OB_Max_Freq.RipControl.Ext.Shock=[3.967 2.67 4.196 4.196 2.747 NaN 3.738 3.967 2.975 4.044];
OB_Max_Freq.RipControl.Ext.Safe=[2.899 2.975 3.357 3.433 2.365 NaN 2.594 2.747 2.975 3.51];

OB_Max_Freq.RipInhib.Ext.Shock=[4.272 4.12 4.12 4.425 4.578 3.357 4.349 4.272 3.204 4.578];
OB_Max_Freq.RipInhib.Ext.Safe=[5.112 2.594 4.349 NaN 3.128 NaN 2.823 4.501 2.67 4.044];


OB_Max_Freq.RipControl.CondPost.Shock=[5.341 5.569 6.943 4.73 4.73 5.798 4.044 4.12 3.891 7.553];
OB_Max_Freq.RipControl.CondPost.Safe=[3.815 4.272 5.112 4.04 3.815 4.883 3.586 3.586 3.052 4.807];

OB_Max_Freq.RipInhib.CondPost.Shock=[4.12 4.12 7.12 5.417 4.425 4.73 4.959 4.959 NaN 6.104]; 
OB_Max_Freq.RipInhib.CondPost.Safe=[4.501 3.204 5.304 4.578 4.959 4.654 4.654 4.654 NaN 4.349];




%% Saline / DZP
OB_Max_Freq.Saline_short_all.Cond.Shock=[5.264 NaN 3.281 5.646 5.569 4.425 5.493 4.044 5.035 4.73 5.112]; % Mouse=[1144 1147 1170 1171 1189 9205 1251 1253 1254 1392 1394];
OB_Max_Freq.Saline_short_all.Cond.Safe=[5.264 3.891 1.755 4.196 2.975 4.044 4.501 3.357 3.433 4.272 4.272];

OB_Max_Freq.Saline_short_all.Ext.Shock=[5.112 4.196 2.213 4.044 4.425 3.815 3.433 3.51 4.272 4.272 4.959];
OB_Max_Freq.Saline_short_all.Ext.Safe=[3.662 3.204 2.365 2.441 1.678 2.365 2.06 NaN NaN 1.984 4.425];


OB_Max_Freq.DZP_short_all.Cond.Shock=[4.196 3.815 3.662 4.196 3.586 3.738 4.272 3.967 4.349 4.349 3.815 3.967]; % Mouse=[11147 11184 11189 11200 11204 11205 11206 11207 11251 11252 11253 11254];
OB_Max_Freq.DZP_short_all.Cond.Safe=[4.12 3.891 3.128 3.967 2.747 3.204 4.044 3.433 4.349 3.204 3.204 3.052];

OB_Max_Freq.DZP_short_all.Ext.Shock=[4.425 3.738 1.831 4.349 5.264 3.357 4.807 3.662 3.967 2.975 2.975 2.975];
OB_Max_Freq.DZP_short_all.Ext.Safe=[4.12 3.738 1.678 3.738 NaN 2.441 2.67 2.365 3.204 2.518 2.747 2.594];


%% Saline / Chronic fluo
OB_Max_Freq.SalineSB.Ext.Shock= [4.3511    4.0457    4.5801    3.6641    4.7328    4.2748];
OB_Max_Freq.SalineSB.Ext.Safe= [2.2900    1.7557    1.6030      2.823    1.2213       2.594];

OB_Max_Freq.ChronicFlx.Ext.Shock= [4.9618    1.8320    2.0610    2.6717    2.4427    1.9847];
OB_Max_Freq.ChronicFlx.Ext.Safe= [2.7480    2.4427       NaN    1.9847    2.6717    2.2137];


OB_Max_Freq.SalineSB.Fear.Shock= [4.196 3.815 4.578 3.662 4.807 4.425];
OB_Max_Freq.SalineSB.Fear.Safe= [2.365 4.349 3.815 2.889 1.297 2.747];

OB_Max_Freq.ChronicFlx.Fear.Shock= [4.501 2.289 4.807 2.67 1.907 2.213 2.975];
OB_Max_Freq.ChronicFlx.Fear.Safe= [3.128 2.67 3.052 2.289 2.594 2.213 2.67];


%% Toolbox
% clf
% mouse=mouse+1;
% plot(Spectro{3} , squeeze(OutPutData.DZP_short_all.Ext.ob_low.mean(mouse,5,:)) , 'r')
% hold on
% plot(Spectro{3} , squeeze(OutPutData.DZP_short_all.Ext.ob_low.mean(mouse,6,:)) , 'b')
% xlim([0 10])

% 
% 
% clf
% mouse=mouse+1;
% plot(Spectro{3} , Spectro{3}'.*squeeze(OutPutData.Saline_short_all.Ext.ob_low.mean(mouse,5,:)) , 'r')
% hold on
% plot(Spectro{3} , Spectro{3}'.*squeeze(OutPutData.Saline_short_all.Ext.ob_low.mean(mouse,6,:)) , 'b')
% xlim([0 10])


%
% need to be corrected because removed 1376 & 41352
% OB_Max_Freq.RipControl2.Cond.Shock=[5.264 5.264 5.341 4.578 5.646 5.417];
% OB_Max_Freq.RipControl2.Cond.Safe=[4.73 4.654 4.272 4.501 4.959 4.349];
% 
% OB_Max_Freq.RipInhib2.Cond.Shock=[NaN 4.807 NaN 3.891 4.959];
% OB_Max_Freq.RipInhib2.Cond.Safe=[3.204 4.73 4.807 3.51 4.349];
% 
% 
% OB_Max_Freq.RipControl2.Ext.Shock=[4.501 4.349 3.738 2.899 4.578 2.975];
% OB_Max_Freq.RipControl2.Ext.Safe=[2.518 2.975 2.136 1.45 2.518 2.899];
% 
% OB_Max_Freq.RipInhib2.Ext.Shock=[2.594 4.807 2.06 3.738 4.578];
% OB_Max_Freq.RipInhib2.Ext.Safe=[1.602 2.67 1.755 2.594 2.67];
% % on 15/09/2023
% OB_Max_Freq.Saline2.Cond.Shock=[5.493 4.044 5.035];
% OB_Max_Freq.Saline2.Cond.Safe=[4.501 3.281 4.654];
% 
% OB_Max_Freq.DZP2.Cond.Shock=[4.12 3.815 3.662 3.51 3.815];
% OB_Max_Freq.DZP2.Cond.Safe=[4.12 3.891 3.128 2.747 3.204];
% 
% OB_Max_Freq.Saline2.Ext.Shock=[3.433 3.51 4.272];
% OB_Max_Freq.Saline2.Ext.Safe=[2.136 2.06 NaN];
% 
% OB_Max_Freq.DZP2.Ext.Shock=[4.501 3.738 1.907 5.264 3.357];
% OB_Max_Freq.DZP2.Ext.Safe=[3.967 3.738 1.755 NaN 2.441];


%% old
% OB_Max_Freq.SalineBM.CondPre.Shock=[3.357 4.12 5.341 5.417 4.425 5.569 4.196 5.341 5.417];
% OB_Max_Freq.SalineBM.CondPre.Safe=[2.365 4.501 4.12 4.654 4.12 4.807 4.196 4.044 4.501];
% 
% OB_Max_Freq.SalineBM.CondPost.Shock=[3.128 6.104 2.975 5.789 NaN 6.485 4.807 4.12 4.73];
% OB_Max_Freq.SalineBM.CondPost.Safe=[2.213 3.738 3.052 2.975 3.815 4.73 4.501 3.378 3.204];
% 
% OB_Max_Freq.SalineBM.Ext.Shock=[1.907 3.891 3.891 4.425 3.815 4.73 4.196 4.883 4.044];
% OB_Max_Freq.SalineBM.Ext.Safe=[2.518 NaN 2.441 1.678 2.594 3.891 1.984 2.365 2.441];
% 
% 
% OB_Max_Freq.Diazepam.CondPre.Shock=[4.196 4.349 3.967 4.578 4.425 3.586 4.044];
% OB_Max_Freq.Diazepam.CondPre.Safe=[3.815 4.425 3.052 4.349 4.349 3.128 3.357];
% 
% OB_Max_Freq.Diazepam.CondPost.Shock=[4.12 NaN 3.738 3.815 4.272 3.967 3.586];
% OB_Max_Freq.Diazepam.CondPost.Safe=[3.891 4.044 3.586 3.357 3.128 3.204 3.052];
% 
% OB_Max_Freq.Diazepam.Ext.Shock=[NaN 4.807 3.51 4.73 2.975 2.975 2.899];
% OB_Max_Freq.Diazepam.Ext.Safe=[NaN 2.67 2.365 NaN 2.67 2.747 2.67];
% 
% 
% OB_Max_Freq.RipControl.CondPre.Shock=[4.501 3.891 5.875 5.264 4.807 NaN 5.112 4.959];
% OB_Max_Freq.RipControl.CondPre.Safe=[4.425 3.891 4.959 5.035 4.196 NaN 4.654 4.501];
% 
% OB_Max_Freq.RipControl.CondPost.Shock=[5.341 5.569 5.722 4.73 4.73 NaN 4.73 5.722];
% OB_Max_Freq.RipControl.CondPost.Safe=[3.815 4.272 NaN 4.04 3.815 NaN 3.891 5.646];
% 
% OB_Max_Freq.RipControl.Ext.Shock=[3.967 2.67 4.196 4.196 2.975 NaN 2.823 5.112];
% OB_Max_Freq.RipControl.Ext.Safe=[2.899 2.899 3.357 3.357 2.441 NaN 4.349 4.493];
% 
% 
% OB_Max_Freq.RipInhib.CondPre.Shock=[4.349 5.188 4.654 5.112 4.272 NaN 5.112 5.875];
% OB_Max_Freq.RipInhib.CondPre.Safe=[4.272 4.654 4.349 NaN 4.807 NaN 4.959 5.493];
% 
% OB_Max_Freq.RipInhib.CondPost.Shock=[4.12 4.807 4.73 5.417 3.815 NaN 5.493 NaN];
% OB_Max_Freq.RipInhib.CondPost.Safe=[4.501 4.501 3.967 3.357 NaN NaN 4.578 NaN];
% 
% OB_Max_Freq.RipInhib.Ext.Shock=[4.349 4.501 3.51 1.907 4.044 4.959 4.425 3.378];
% OB_Max_Freq.RipInhib.Ext.Safe=[5.112 3.357 2.518 0.9918 2.594 4.73 2.06 3.586];



