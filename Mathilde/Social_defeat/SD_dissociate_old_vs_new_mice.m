%% compare to lab baseline + restrict to 3h post SD
%% states percentage
figure,
ax_perc(1)=subplot(331),PlotErrorBarN_KJ({percWAKE_totSess_LabBasal_3hPostSD,percWAKE_totSess_3hPostSD_SD(1:3) percWAKE_totSess_3hPostSD_SD(4:10)},'newfig',0,'paired',0);
set(gca,'Xtick',[1:2],'XtickLabel',{'Baseline', 'SD'}); xtickangle(45)
ylabel('Percentage of WAKE (%)')
makepretty
ax_perc(2)=subplot(332),PlotErrorBarN_KJ({percSWS_totSess_LabBasal_3hPostSD,percSWS_totSess_3hPostSD_SD(1:3) percSWS_totSess_3hPostSD_SD(4:10)},'newfig',0,'paired',0);
set(gca,'Xtick',[1:2],'XtickLabel',{'Baseline', 'SD'}); xtickangle(45)
ylabel('Percentage of NREM (%)')
makepretty
ax_perc(3)=subplot(333),PlotErrorBarN_KJ({percREM_totSess_LabBasal_3hPostSD,percREM_totSess_3hPostSD_SD(1:3) percREM_totSess_3hPostSD_SD(4:10)},'newfig',0,'paired',0);
set(gca,'Xtick',[1:2],'XtickLabel',{'Baseline', 'SD'}); xtickangle(45)
ylabel('Percentage of REM (%)')
% suptitle('3h')
makepretty

% set(ax_perc,'ylim',[0 100])

% Bouts number
ax_num(1)=subplot(334),PlotErrorBarN_KJ({NumWAKE_LabBasal_3hPostSD,NumWAKE_3hPostSD_SD(1:3) NumWAKE_3hPostSD_SD(4:10)},'newfig',0,'paired',0)
set(gca,'Xtick',[1:2],'XtickLabel',{'Baseline', 'SD'}); xtickangle(45)
ylabel('Number of WAKE bouts')
makepretty
ax_num(2)=subplot(335),PlotErrorBarN_KJ({NumSWS_LabBasal_3hPostSD,NumSWS_3hPostSD_SD(1:3) NumSWS_3hPostSD_SD(4:10)},'newfig',0,'paired',0)
set(gca,'Xtick',[1:2],'XtickLabel',{'Baseline', 'SD'}); xtickangle(45)
ylabel('Number of NREM bouts')
makepretty
ax_num(3)=subplot(336),PlotErrorBarN_KJ({NumREM_LabBasal_3hPostSD,NumREM_3hPostSD_SD(1:3) NumREM_3hPostSD_SD(4:10)},'newfig',0,'paired',0)
set(gca,'Xtick',[1:2],'XtickLabel',{'Baseline', 'SD'}); xtickangle(45)
ylabel('Number of REM bouts')
% suptitle('3h')
makepretty
% set(ax_num,'ylim',[0 200]) 

% Bouts duration
ax_dur(1)=subplot(337),PlotErrorBarN_KJ({durWAKE_LabBasal_3hPostSD,durWAKE_3hPostSD_SD(1:3) durWAKE_3hPostSD_SD(4:10)},'newfig',0,'paired',0)
set(gca,'Xtick',[1:2],'XtickLabel',{'Baseline', 'SD'}); xtickangle(45)
ylabel('Duration of WAKE (s)')
makepretty
ax_dur(2)=subplot(338),PlotErrorBarN_KJ({durSWS_LabBasal_3hPostSD,durSWS_3hPostSD_SD(1:3) durSWS_3hPostSD_SD(4:10)},'newfig',0,'paired',0)
set(gca,'Xtick',[1:2],'XtickLabel',{'Baseline', 'SD'}); xtickangle(45)
ylabel('Duration of NREM (s)')
makepretty
ax_dur(3)=subplot(339),PlotErrorBarN_KJ({durREM_LabBasal_3hPostSD,durREM_3hPostSD_SD(1:3) durREM_3hPostSD_SD(4:10)},'newfig',0,'paired',0)
set(gca,'Xtick',[1:2],'XtickLabel',{'Baseline', 'SD'}); xtickangle(45)
ylabel('Duration of REM (s)')
% suptitle('Bouts duration')
makepretty
% set(ax_dur,'ylim',[0 200])