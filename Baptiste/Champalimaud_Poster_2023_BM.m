

figure
Data_to_use = (Jumps{1}'./nansum(Jumps{1}'))';Jumps{1};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(0,1,25) , runmean(Mean_All_Sp,3) ,runmean( Conf_Inter,3),'-r',1); hold on;
col= [1 .3 .3]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
% area(linspace(0,1,25) , Mean_All_Sp,'FaceColor',col,'FaceAlpha',.07)

Data_to_use = (RA{1}'./nansum(RA{1}'))';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(0,1,25) , runmean(Mean_All_Sp,3) ,runmean( Conf_Inter,3),'-r',1); hold on;
col= [1 .3 1]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
% area(linspace(0,1,25) , Mean_All_Sp,'FaceColor',col,'FaceAlpha',.07)

Data_to_use = (Grooming{1}'./nansum(Grooming{1}'))';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(0,1,25) , runmean(Mean_All_Sp,3)/2 ,runmean( Conf_Inter,3),'-r',1); hold on;
col= [.3 .3 1]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
% area(linspace(0,1,25) , Mean_All_Sp,'FaceColor',col,'FaceAlpha',.07)

xlabel('linear distance (a.u.)'), ylabel('#'), ylim([0 .2])
f=get(gca,'Children'); l=legend([f(4),f(8),f(12)],'Grooming','Risk assessment','Jumps');
makepretty




figure
Data_to_use = (FreezingDistrib{1}'./nansum(FreezingDistrib{1}'))';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(0,1,25) , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
col= [.3 .3 .3]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
xlabel('linear distance (a.u.)'), ylabel('#')
makepretty

area([0 .3] , [.2 .2] ,'FaceColor',[1 .5 .5],'FaceAlpha',.2)
area([.3 .45] , [.2 .2] ,'FaceColor',[1 .7 .7],'FaceAlpha',.2)
area([.45 .55] , [.2 .2] ,'FaceColor',[1 .5 1],'FaceAlpha',.2)
area([.55 .7] , [.2 .2] ,'FaceColor',[.7 .7 1],'FaceAlpha',.2)
area([.7 1] , [.2 .2] ,'FaceColor',[.5 .5 1],'FaceAlpha',.2)



%% drugs
figure
subplot(131)
MakeSpreadAndBoxPlot3_SB({Proportionnal_Time_Freezing_ofZone.(Side{2}).CondPost{1} Proportionnal_Time_Freezing_ofZone.(Side{2}).CondPost{2} Proportionnal_Time_Freezing_ofZone.(Side{3}).CondPost{1} Proportionnal_Time_Freezing_ofZone.(Side{3}).CondPost{2}}...
    ,{[1 .5 .5],[1 .7 .7],[.5 .5 1],[.7 .7 1],},[1:4],{'Saline','Diazepam','Saline','Diazepam'},'showpoints',1,'paired',0);
ylabel('proportion')
title('Freezing duration')

subplot(132)
MakeSpreadAndBoxPlot3_SB({Respi_Shock.CondPost{1}  Respi_Shock.CondPost{2}...
    Respi_Safe.CondPost{1}  Respi_Safe.CondPost{2}},{[1 .5 .5],[1 .7 .7],[.5 .5 1],[.7 .7 1],},[1:4],{'Saline','Diazepam','Saline','Diazepam'},'showpoints',1,'paired',0);
ylabel('Frequency (Hz)')

subplot(133)
MakeSpreadAndBoxPlot3_SB({Ripples_Shock.CondPost{1} Ripples_Shock.CondPost{2}   Ripples_Safe.CondPost{1} Ripples_Safe.CondPost{2}}...
    ,{[1 .5 .5],[1 .7 .7],[.5 .5 1],[.7 .7 1],},[1:4],{'Saline','Diazepam','Saline','Diazepam'},'showpoints',1,'paired',0);
ylabel('#/s')


%% nicotine
[h , MaxPowerValues] = Plot_MeanSpectrumForMice_BM(OB_Low.(EpochName{7}){4}(:,20:261) , 'color',[.5 .5 1]);
xlim([0 10])
f=get(gca,'Children'); l=legend([f(4)],'Nicotine');
makepretty
title('Mean OB spectrum during freezing')

figure
MakeSpreadAndBoxPlot4_SB(Respi_mean.FreezeAccEpoch(4) ,{[.5 .5 1]},1,{'Nicotine'},'showpoints',1,'paired',0);
ylim([1 6.5]), ylabel('Frequency (Hz)')
title('Ripples density during freezing')

 

%% dPAG
figure
Data_to_use = H(:,20:end);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(Spectro{3}(20:end) , runmean(Mean_All_Sp,5) , runmean(Conf_Inter,5) , '-r',1); hold on;
xlim([0 10]), xlabel('Frequency (Hz)'), ylabel('Power (a.u.)')
makepretty
a=title('OB mean spectrum following PAG stim during calibration, n=7'); a.FontSize=10;

figure
MakeSpreadAndBoxPlot4_SB({[5.722 5.493 5.417 5.875 6.027 5.264]} ,{[1 .5 .5]},1,{'dPAG'},'showpoints',1,'paired',0);
ylim([1 6.5]), ylabel('Frequency (Hz)')