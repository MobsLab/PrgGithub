
%% 1

figure
x = 0:0.1:10;
y = gaussmf(x,[1 5]);
area(x,y,'FaceColor',[1 .2 .2],'Linewidth',2), hold on
area(x+5,y,'FaceColor',[1 .7 .7],'Linewidth',2)
area(x+10,y,'FaceColor',[.5 .5 1],'Linewidth',2)
alpha(.3)
axis off


%% 2
% freezing distrib



%% 3

figure
subplot(141)
MakeSpreadAndBoxPlot3_SB(OutPutData.(Session_type{sess}).respi_freq_bm.mean(:,5:6),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Frequency (Hz)'); title('Respiratory rate')

subplot(142)
MakeSpreadAndBoxPlot3_SB(OutPutData.(Session_type{sess}).heartrate.mean(:,5:6),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Frequency (Hz)'); title('Heart rate')

subplot(143)
MakeSpreadAndBoxPlot3_SB(OutPutData.(Session_type{sess}).heartratevar.mean(:,5:6),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Frequency (Hz)'); title('Respiratory rate')

subplot(144)
MakeSpreadAndBoxPlot3_SB(OutPutData.(Session_type{sess}).tailtemperature.mean(:,5:6),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Temperature (°C)'); title('Tail temperature')



figure
polygonplot_BM(DATA_TO_PLOT.Cond,opt_axes,opt_lines,opt_area);
makepretty




%%
figure
[~ , MaxPowerValues1] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).ob_low.mean(mice,5,:)), 'color' , 'b' , 'threshold' , 13);
[~ , MaxPowerValues2] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).ob_low.mean(mice,6,:)), 'color' , 'b' , 'threshold' , 13);
[~ , MaxPowerValues3] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).pfc_low.mean(mice,5,:)), 'color' , 'b' , 'threshold' , 65);
[~ , MaxPowerValues4] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).pfc_low.mean(mice,6,:)), 'color' , 'b' , 'threshold' , 65);
[~ , MaxPowerValues5] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).hpc_low.mean(mice,5,:)), 'color' , 'b' , 'threshold' , 26);
[~ , MaxPowerValues6] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).hpc_low.mean(mice,6,:)), 'color' , 'b' , 'threshold' , 26);
clf


[u,v] = max([squeeze(OutPutData.(Session_type{sess}).hpc_low.mean(mice,5,13:end)) ; squeeze(OutPutData.(Session_type{sess}).hpc_low.mean(mice,5,13:end))]);
Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).hpc_low.mean(mice,5,:)) , 'Color' , 'r' , 'power_norm_value' , max([MaxPowerValues5' MaxPowerValues6']') , 'smoothing' ,5)
hold on
Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).hpc_low.mean(mice,6,:)) , 'Color' , 'b' , 'power_norm_value' , max([MaxPowerValues5' MaxPowerValues6']') , 'smoothing' ,5)
xlim([0 10]), ylim([0 1])
xlabel('Frequency (Hz)')
title('HPC')
vline(2.1,'--b'), vline(4.122,'--r'), u=vline(6.849,'--'); u.Color=[.5 .5 .5];

Data_to_use = squeeze(OutPutData.(Session_type{sess}).ob_pfc_coherence.mean(mice,5,:));
Data_to_use(Data_to_use==0)=NaN;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
% shadedErrorBar(linspace(0,20,65) , Mean_All_Sp , Conf_Inter, '-r',1); hold on;
shadedErrorBar(linspace(0,20,65) , runmean(Mean_All_Sp,2) , runmean(Conf_Inter,2) ,'-r',1); hold on;
Data_to_use = squeeze(OutPutData.(Session_type{sess}).ob_pfc_coherence.mean(mice,6,:));
Data_to_use(Data_to_use==0)=NaN;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
% shadedErrorBar(linspace(0,20,65) , Mean_All_Sp , Conf_Inter, '-b',1); hold on;
shadedErrorBar(linspace(0,20,65) , runmean(Mean_All_Sp,2) , runmean(Conf_Inter,2) ,'-b',1); hold on;
xlim([0 10]),% ylim([0 1])
xlabel('Frequency (Hz)'), ylabel('Power (a.u.)')
box off
vline(2.1,'--b'), vline(4.122,'--r'), u=vline(6.849,'--'); u.Color=[.5 .5 .5];

Data_to_use = squeeze(OutPutData.(Session_type{sess}).hpc_pfc_coherence.mean(mice,5,:));
Data_to_use(Data_to_use==0)=NaN;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
% shadedErrorBar(linspace(0,20,65) , Mean_All_Sp , Conf_Inter, '-r',1); hold on;
shadedErrorBar(linspace(0,20,65) , runmean(Mean_All_Sp,2) , runmean(Conf_Inter,2) ,'-r',1); hold on;
Data_to_use = squeeze(OutPutData.(Session_type{sess}).hpc_pfc_coherence.mean(mice,6,:));
Data_to_use(Data_to_use==0)=NaN;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
% shadedErrorBar(linspace(0,20,65) , Mean_All_Sp , Conf_Inter, '-b',1); hold on;
shadedErrorBar(linspace(0,20,65) , runmean(Mean_All_Sp,2) , runmean(Conf_Inter,2) ,'-b',1); hold on;
xlim([0 10]),% ylim([0 1])
xlabel('Frequency (Hz)'), ylabel('Power (a.u.)')
box off
vline(2.1,'--b'), vline(4.122,'--r'), u=vline(6.849,'--'); u.Color=[.5 .5 .5];


