

%%
Session_type={'Cond','Ext'};
Mouse=[117 404 425 431 436 437 438 439 469 470 471 483 484 485 490 507 508 509 510 512 514 561 567 568 569 566 666 667 668 669 688 739 777 779 849 1144 1146 1147  1170 1171 9184 1189 9205 1391 1392 1393 1394 1224 1225 1226];

% Physio
for sess=1:length(Session_type) % generate all data required for analyses
    [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(...
        'all_saline',Mouse,lower(Session_type{sess}),'ob_low','pfc_low','hpc_low','ob_pfc_coherence','hpc_pfc_coherence');
end

%% figures
Cols={[1 .5 .5],[.5 .5 1]};
X=[1:2];
Legends={'Shock','Safe'};

for i=1:2
    if i==1
        mice=1:22;
    else
        mice=23:50;
    end
    
    figure
    [~ , MaxPowerValues1] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).ob_low.mean(mice,5,:)), 'color' , 'b' , 'threshold' , 13);
    [~ , MaxPowerValues2] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).ob_low.mean(mice,6,:)), 'color' , 'b' , 'threshold' , 13);
    [~ , MaxPowerValues3] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).pfc_low.mean(mice,5,:)), 'color' , 'b' , 'threshold' , 65);
    [~ , MaxPowerValues4] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).pfc_low.mean(mice,6,:)), 'color' , 'b' , 'threshold' , 65);
    [~ , MaxPowerValues5] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).hpc_low.mean(mice,5,:)), 'color' , 'b' , 'threshold' , 26);
    [~ , MaxPowerValues6] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).hpc_low.mean(mice,6,:)), 'color' , 'b' , 'threshold' , 26);
    clf

    subplot(231)
    Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).ob_low.mean(mice,5,:)) , 'Color' , 'r' , 'power_norm_value' , max([MaxPowerValues1' MaxPowerValues2']'))
    hold on
    Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).ob_low.mean(mice,6,:)) , 'Color' , 'b' , 'power_norm_value' , max([MaxPowerValues1' MaxPowerValues2']'))
    xlim([1 15]), ylim([0 1])
    xlabel('Frequency (Hz)'), ylabel('Power (a.u.)')
    title('OB')
    
    subplot(232)
    [u,v] = max([squeeze(OutPutData.(Session_type{sess}).pfc_low.mean(mice,5,13:end)) ; squeeze(OutPutData.(Session_type{sess}).pfc_low.mean(mice,5,13:end))]);
    Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).pfc_low.mean(mice,5,:)) , 'Color' , 'r' , 'power_norm_value' , max([MaxPowerValues3' MaxPowerValues4']'))
    hold on
    Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).pfc_low.mean(mice,6,:)) , 'Color' , 'b' , 'power_norm_value' , max([MaxPowerValues3' MaxPowerValues4']'))
    xlim([1 15]), ylim([0 1])
    xlabel('Frequency (Hz)')
    title('PFC')
    
    subplot(233)
        [u,v] = max([squeeze(OutPutData.(Session_type{sess}).hpc_low.mean(mice,5,13:end)) ; squeeze(OutPutData.(Session_type{sess}).hpc_low.mean(mice,5,13:end))]);
    Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).hpc_low.mean(mice,5,:)) , 'Color' , 'r' , 'power_norm_value' , max([MaxPowerValues5' MaxPowerValues6']'))
    hold on
    Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).hpc_low.mean(mice,6,:)) , 'Color' , 'b' , 'power_norm_value' , max([MaxPowerValues5' MaxPowerValues6']'))
  
        
        
%         Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).hpc_low.mean(mice,5,:)) , 'Color' , 'r' , 'power_norm_value' , u)
%     hold on
%     [u,v] = max(squeeze(OutPutData.(Session_type{sess}).hpc_low.mean(mice,5,27:end))');
%     Data_to_use = squeeze(OutPutData.(Session_type{sess}).hpc_low.mean(mice,6,:))./u';
%        Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
%     clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
%     shadedErrorBar(Spectro{3} , Mean_All_Sp,Conf_Inter,'-b',1); hold on;
    xlim([1 15]), ylim([0 1])
    xlabel('Frequency (Hz)')
    title('HPC')
    
    subplot(234)
    Data_to_use = squeeze(OutPutData.(Session_type{sess}).ob_pfc_coherence.mean(mice,5,:));
    Data_to_use(Data_to_use==0)=NaN;
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
    shadedErrorBar(linspace(0,20,65) , Mean_All_Sp,Conf_Inter,'-r',1); hold on;
    Data_to_use = squeeze(OutPutData.(Session_type{sess}).ob_pfc_coherence.mean(mice,6,:));
    Data_to_use(Data_to_use==0)=NaN;
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
    shadedErrorBar(linspace(0,20,65) , Mean_All_Sp,Conf_Inter,'-b',1); hold on;
    xlim([1 15])%, ylim([0 1])
    xlabel('Frequency (Hz)'), ylabel('Power (a.u.)')
    title('OB-PFC coherence')
    
    subplot(236)
    Data_to_use = squeeze(OutPutData.(Session_type{sess}).hpc_pfc_coherence.mean(mice,5,:));
    Data_to_use(Data_to_use==0)=NaN;
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
    shadedErrorBar(linspace(0,20,65) , Mean_All_Sp,Conf_Inter,'-r',1); hold on;
    Data_to_use = squeeze(OutPutData.(Session_type{sess}).hpc_pfc_coherence.mean(mice,6,:));
    Data_to_use(Data_to_use==0)=NaN;
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
    shadedErrorBar(linspace(0,20,65) , Mean_All_Sp,Conf_Inter,'-b',1); hold on;
    xlim([1 15])%, ylim([0 1])
    xlabel('Frequency (Hz)')
    title('HPC-PFC coherence')
    
    [Coh_OB_PFC_Shk,v] = max(squeeze(OutPutData.(Session_type{sess}).ob_pfc_coherence.mean(mice,5,5:65))');
    Coh_OB_PFC_Shk(v==1)=NaN;
    [Coh_OB_PFC_Saf,v] = max(squeeze(OutPutData.(Session_type{sess}).ob_pfc_coherence.mean(mice,6,5:65))');
    Coh_OB_PFC_Saf(v==1)=NaN;
    
    [Coh_HPC_PFC_Shk,v] = max(squeeze(OutPutData.(Session_type{sess}).hpc_pfc_coherence.mean(mice,5,5:65))');
    Coh_HPC_PFC_Shk(v==1)=NaN;
    [Coh_HPC_PFC_Saf,v] = max(squeeze(OutPutData.(Session_type{sess}).hpc_pfc_coherence.mean(mice,6,5:65))');
    Coh_HPC_PFC_Saf(v==1)=NaN;
    
    
    subplot(2,12,17)
    MakeSpreadAndBoxPlot3_SB({Coh_OB_PFC_Shk Coh_OB_PFC_Saf},Cols,X,Legends,'showpoints',1,'paired',0);
    ylim([.5 1.1]), ylabel('coherence')
    
    subplot(2,12,20)
    MakeSpreadAndBoxPlot3_SB({Coh_HPC_PFC_Shk Coh_HPC_PFC_Saf},Cols,X,Legends,'showpoints',1,'paired',0);
    ylim([.5 1.1]), ylabel('coherence')
    
    if i==1
        a=suptitle('OB-PFC-HPC coherence during freezing, PAG, n=26'); a.FontSize=20;
    else
        a=suptitle('OB-PFC-HPC coherence during freezing, Saline eyeshock, n=24'); a.FontSize=20;
    end
end



for i=1:2
    if i==1
        mice=1:22;
    else
        mice=23:50;
    end
    
    figure
    
    subplot(131)
    MakeSpreadAndBoxPlot3_SB({log10(OutPutData.Cond.ob_low.power(mice,5)) log10(OutPutData.Cond.ob_low.power(mice,6))},Cols,X,Legends,'showpoints',1,'paired',0);
    subplot(132)
    MakeSpreadAndBoxPlot3_SB({log10(OutPutData.Cond.pfc_low.power(mice,5)) log10(OutPutData.Cond.pfc_low.power(mice,6))},Cols,X,Legends,'showpoints',1,'paired',0);
    subplot(133)
    MakeSpreadAndBoxPlot3_SB({log10(OutPutData.Cond.hpc_low.power(mice,5)) log10(OutPutData.Cond.hpc_low.power(mice,6))},Cols,X,Legends,'showpoints',1,'paired',0);
    
end





