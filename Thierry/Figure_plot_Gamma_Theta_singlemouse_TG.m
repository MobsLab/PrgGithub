figure('color',[1 1 1]),

    %%Theta
    subplot(343), imagesc(temps,freq, SpREM), axis xy, caxis([0 5]), colormap(jet)
    line([0 0], ylim,'color','w','linestyle',':')
    xlim([-30 +30])
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    colorbar
    title('HPC REM')    
    set(gca,'FontSize', 14)

    subplot(347), imagesc(temps,freq, SpSWS), axis xy, caxis([0 5]), colormap(jet)
    line([0 0], ylim,'color','w','linestyle',':')
    xlim([-30 +30])
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    colorbar
    title('HPC NREM')    
    set(gca,'FontSize', 14)

    subplot(3,4,11), imagesc(temps,freq, SpWake), axis xy, caxis([0 5]), colormap(jet)
    line([0 0], ylim,'color','w','linestyle',':')
    xlim([-30 +30])
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    colorbar
    title('HPC Wake')        
    set(gca,'FontSize', 14)
    
    subplot(344), 
    plot(temps,mean(SpREM(idx1,:)/facREM,1),'k','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
    hold on 
    plot(temps,runmean(mean(SpREM(idx1,:),1)/facREM,runfac),'k','linewidth',2), xlim([temps(1) temps(end)])
%     line([temps(1) temps(end)],[facREM facREM]/facREM,'linewidth',1)
%     line([temps(1) temps(end)],[facREM+stdfacREM facREM+stdfacREM]/facREM,'linestyle',':','linewidth',1)
%     line([temps(1) temps(end)],[facREM-stdfacREM facREM-stdfacREM]/facREM,'linestyle',':','linewidth',1)
    xlim([-30 +30])
    xlabel('time (s)')
    ylim([0.2 1.6])
    ylabel('theta power')
    line([0 0], ylim,'color','k','linestyle',':')    
    set(gca,'FontSize', 14)

    subplot(348), 
    plot(temps,mean(SpSWS(idx1,:)/facSWS,1),'k','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
    hold on 
    plot(temps,runmean(mean(SpSWS(idx1,:),1)/facSWS,runfac),'k','linewidth',2), xlim([temps(1) temps(end)])
%     line([temps(1) temps(end)],[facREM facREM]/facREM,'linewidth',1)
%     line([temps(1) temps(end)],[facREM+stdfacREM facREM+stdfacREM]/facREM,'linestyle',':','linewidth',1)
%     line([temps(1) temps(end)],[facREM-stdfacREM facREM-stdfacREM]/facREM,'linestyle',':','linewidth',1)
    xlim([-30 +30])
    xlabel('time (s)')
    ylim([0.2 1.6])
    ylabel('theta power')
    line([0 0], ylim,'color','k','linestyle',':')    
    set(gca,'FontSize', 14)
    
    subplot(3,4,12), 
    plot(temps,mean(SpWake(idx1,:)/facWake,1),'k','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
    hold on 
    plot(temps,runmean(mean(SpWake(idx1,:),1)/facWake,runfac),'k','linewidth',2), xlim([temps(1) temps(end)])

    % line([temps(1) temps(end)],[facREM facREM]/facREM,'linewidth',1)
    % line([temps(1) temps(end)],[facREM+stdfacREM facREM+stdfacREM]/facREM,'linestyle',':','linewidth',1)
    % line([temps(1) temps(end)],[facREM-stdfacREM facREM-stdfacREM]/facREM,'linestyle',':','linewidth',1)
    xlim([-30 +30])
    xlabel('time (s)')
    ylim([0.2 1.6])
    ylabel('theta power')
    line([0 0], ylim,'color','k','linestyle',':')    
    set(gca,'FontSize', 14)
    
    
    %%%%Gamma
    subplot(341), imagesc(temps,freqG, SpectroREMG), axis xy, colormap(jet), caxis([0 2])
    line([0 0], ylim,'color','w','linestyle',':')
    xlim([-30 +30])
    ylim([35 +100])
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    colorbar
    title('OB REM')
    set(gca,'FontSize', 14)

    subplot(345), imagesc(temps,freqG, SpectroSWSG), axis xy,  colormap(jet), caxis([0 2])
    line([0 0], ylim,'color','w','linestyle',':')
    xlim([-30 +30])
    ylim([35 +100])
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    colorbar
    title('OB NREM')
    set(gca,'FontSize', 14)

    
    subplot(3,4,9), imagesc(temps,freqG, SpectroWakeG), axis xy, colormap(jet), caxis([0 2])
    line([0 0], ylim,'color','w','linestyle',':')
    xlim([-30 +30])
    ylim([35 +100])
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    colorbar
    title('OB Wake')
    set(gca,'FontSize', 14)
    
    subplot(342),
    plot(temps,mean(SpectroREMG(idx1_gamma,:),1),'k','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
    hold on 
    plot(temps,runmean(mean(SpectroREMG(idx1_gamma,:),1),runfac),'k','linewidth',2), xlim([temps(1) temps(end)])
%     line([temps(1) temps(end)],[facREMG facREMG],'linewidth',1)
%     line([temps(1) temps(end)],[facREMG+stdfacREMG facREMG+stdfacREMG],facWakeW,'linestyle',':','linewidth',1)
%     line([temps(1) temps(end)],[facREMG-stdfacREMG facREMG-stdfacREMG],facWakeW,'linestyle',':','linewidth',1)
    xlim([-30 +30])
    xlabel('time (s)')
    ylim([0 1.5])
    ylabel('Gamma power')
    line([0 0], ylim,'color','k','linestyle',':')
    set(gca,'FontSize', 14)
    
    subplot(346),
    plot(temps,mean(SpectroSWSG(idx1_gamma,:),1),'k','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
    hold on
    plot(temps,runmean(mean(SpectroSWSG(idx1_gamma,:),1),runfac),'k','linewidth',2), xlim([temps(1) temps(end)])
%     line([temps(1) temps(end)],[facSWSG facSWSG]/facSWSG,'linewidth',1)
%     line([temps(1) temps(end)],[facSWSG+stdfacSWSG facSWSG+stdfacSWSG]/,facWakeS,'linestyle',':','linewidth',1)
%     line([temps(1) temps(end)],[facSWSG-stdfacSWSG facWakeG-stdfacSWSG]/,facWakeS,'linestyle',':','linewidth',1)
    xlim([-30 +30])
    xlabel('time (s)')
    ylim([0 1.5])
    ylabel('Gamma power')
    line([0 0], ylim,'color','k','linestyle',':')
    set(gca,'FontSize', 14)
    
    subplot(3,4,10),
    plot(temps,mean(SpectroWakeG(idx1_gamma,:),1),'k','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
    hold on
    plot(temps,runmean(mean(SpectroWakeG(idx1_gamma,:),1),runfac),'k','linewidth',2), xlim([temps(1) temps(end)])
%     line([temps(1) temps(end)],[facWakeG facWakeG]/facWakeG,'linewidth',1)
%     line([temps(1) temps(end)],[facWakeG+stdfacWakeG facWakeG+stdfacWakeG]/facWakeG,'linestyle',':','linewidth',1)
%     line([temps(1) temps(end)],[facWakeG-stdfacWakeG facWakeG-stdfacWakeG]/facWakeG,'linestyle',':','linewidth',1)
    xlim([-30 +30])
    xlabel('time (s)')
    ylabel('Gamma power')
    line([0 0], ylim,'color','k','linestyle',':')
    set(gca,'FontSize', 14)
    
    %suptitle('M1052 200527')
    saveas(gcf,'Theta_Gamma_aroundStim.png')
    saveas(gcf,'Theta_Gamma_aroundStim.fig')
