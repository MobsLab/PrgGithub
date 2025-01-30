%% Objectives of this code

% Compare frequency measured with the Peak and Trough method (PT) vs the
% Spectrogram method for the canonical mice 

% Compare the frequencies measured with PT on shock and safe sides to set
%%% a threshold when they significantly differ

% Correlation between PT and Spectrogram measurements

%% Selected canonical mice
clear all

%from
%Mouse_gr1=[688 739 777 779 849 893] % group1: saline mice, long protocol, SB
%Mouse_gr5=[1170 1171 9184 1189 9205 1391 1392 1393 1394] % group 5: saline short BM first Maze

%to : mice with an OB frequency during freezing safe in conditionning sessions that show a canonical behaviour 
%mice that have a sufficient time of freezing safe and ripples
Mouse_C = [688 739 777 849 1171 1189 1393 1394]; % C stands for Canonical 

%% Extract data for all mice
Session_type={'Cond'};
for sess=1:length(Session_type) % generate all data required for analyses
    [C_TSD_DATA.(Session_type{sess}) , EpochC.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse_C,lower(Session_type{sess}),'respi_freq_BM','ripples','linearposition', 'instfreq');
end

%% Frequency generated instantaneously with the signal 

% Compute OB frequency and ripples during freezing shock
for mousenum=1:length(Mouse_C)
    C_Mouse_names{mousenum}=['M' num2str(Mouse_C(mousenum))];
    C_Inst_Freq_Respi_ShockFz.(C_Mouse_names{mousenum}) = Data(C_TSD_DATA.Cond.instfreq.tsd{mousenum,5});
    if isnan(C_Inst_Freq_Respi_ShockFz.(C_Mouse_names{mousenum})(1))
        C_Inst_Freq_Respi_ShockFz.(C_Mouse_names{mousenum})(1:find(~isnan(C_Inst_Freq_Respi_ShockFz.(C_Mouse_names{mousenum})), 1)) = C_Inst_Freq_Respi_ShockFz.(C_Mouse_names{mousenum})(find(~isnan(C_Inst_Freq_Respi_ShockFz.(C_Mouse_names{mousenum})), 1));
    end
    if isnan(C_Inst_Freq_Respi_ShockFz.(C_Mouse_names{mousenum})(end))
        C_Inst_Freq_Respi_ShockFz.(C_Mouse_names{mousenum})(find(~isnan(C_Inst_Freq_Respi_ShockFz.(C_Mouse_names{mousenum})), 1, 'last'):end) = C_Inst_Freq_Respi_ShockFz.(C_Mouse_names{mousenum})(find(~isnan(C_Inst_Freq_Respi_ShockFz.(C_Mouse_names{mousenum})), 1, 'last'));
    end
    C_Inst_RunMeanFq_ShockFz.(C_Mouse_names{mousenum}) = runmean_BM(C_Inst_Freq_Respi_ShockFz.(C_Mouse_names{mousenum}),30);
    C_Inst_Ind_OB_ShockFz.(C_Mouse_names{mousenum}) = Range(C_TSD_DATA.Cond.instfreq.tsd{mousenum,5});
    if isempty(C_TSD_DATA.Cond.ripples.ts{mousenum,5})
        C_TSD_DATA.Cond.ripples.ts{mousenum,5}=NaN;  
    else
        C_Inst_Ind_Ripples_ShockFz.(C_Mouse_names{mousenum}) = Range(C_TSD_DATA.Cond.ripples.ts{mousenum,5}); 
    end
end

% Compute OB frequency and ripples during freezing safe
for mousenum=1:length(Mouse_C)
    C_Inst_Freq_Respi_SafeFz.(C_Mouse_names{mousenum}) = Data(C_TSD_DATA.Cond.instfreq.tsd{mousenum,6});
    if isnan(C_Inst_Freq_Respi_SafeFz.(C_Mouse_names{mousenum})(1))
        C_Inst_Freq_Respi_SafeFz.(C_Mouse_names{mousenum})(1:find(~isnan(C_Inst_Freq_Respi_SafeFz.(C_Mouse_names{mousenum})), 1)) = C_Inst_Freq_Respi_SafeFz.(C_Mouse_names{mousenum})(find(~isnan(C_Inst_Freq_Respi_SafeFz.(C_Mouse_names{mousenum})), 1));
    end
    if isnan(C_Inst_Freq_Respi_SafeFz.(C_Mouse_names{mousenum})(end))
        C_Inst_Freq_Respi_SafeFz.(C_Mouse_names{mousenum})(find(~isnan(C_Inst_Freq_Respi_SafeFz.(C_Mouse_names{mousenum})), 1, 'last'):end) = C_Inst_Freq_Respi_SafeFz.(C_Mouse_names{mousenum})(find(~isnan(C_Inst_Freq_Respi_SafeFz.(C_Mouse_names{mousenum})), 1, 'last'));
    end
    C_Inst_RunMeanFq_SafeFz.(C_Mouse_names{mousenum}) = runmean_BM(C_Inst_Freq_Respi_SafeFz.(C_Mouse_names{mousenum}),30);
    C_Inst_Ind_OB_SafeFz.(C_Mouse_names{mousenum}) = Range(C_TSD_DATA.Cond.instfreq.tsd{mousenum,6});
    if isempty(C_TSD_DATA.Cond.ripples.ts{mousenum,6})
        C_TSD_DATA.Cond.ripples.ts{mousenum,6}=NaN;  
    else
        C_Inst_Ind_Ripples_SafeFz.(C_Mouse_names{mousenum}) = Range(C_TSD_DATA.Cond.ripples.ts{mousenum,6}); 
    end
end

%% OB frequency along freezing shock and safe 

% Plot freezing shock and safe for each mouse
fig=figure;
colors = [0 0.6 .4; 0 0.4 .4; 1 0.4 0; 1 0.2 0; 0 0.6 .4; 0 0.4 .4; 1 0.4 0; 1 0.2 0];
for mousenum=1:length(Mouse_C)
    mouse=C_Mouse_names(mousenum);
    subplot(4,2,mousenum)
    plot((1:length(C_Inst_RunMeanFq_ShockFz.(C_Mouse_names{mousenum})))*0.2, C_Inst_RunMeanFq_ShockFz.(C_Mouse_names{mousenum}),'Color',colors(3,:)), hold on
    plot((1:length(C_Inst_RunMeanFq_SafeFz.(C_Mouse_names{mousenum})))*0.2, C_Inst_RunMeanFq_SafeFz.(C_Mouse_names{mousenum}),'Color',colors(1,:)), hold on
    title(mouse)
    legend({'Shock', 'Safe'})
    makepretty
end
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Frequency (Hz)', 'FontSize', 25);
xlabel(han,'Time freezing (s)', 'FontSize', 25);
title(han,'Inst frequencies during shock and safe side freezing', 'FontSize', 30);

% Add significativity in difference (Fshock > Fsafe)
for mousenum=1:length(Mouse_C)
    for i=1:length(C_Inst_RunMeanFq_SafeFz.(C_Mouse_names{mousenum}))
        [C_Inst_h_Fsk_Fsafe(mousenum,i),C_Inst_p_Fsk_Fsafe(mousenum,i)] = ttest2(C_Inst_RunMeanFq_ShockFz.(C_Mouse_names{mousenum}), C_Inst_RunMeanFq_SafeFz.(C_Mouse_names{mousenum})(i), 'Tail','right', 'Alpha', 0.001);
    end
    for j=1:length(C_Inst_h_Fsk_Fsafe(mousenum,:))
        if j>length(C_Inst_RunMeanFq_SafeFz.(C_Mouse_names{mousenum}))
            C_Inst_h_Fsk_Fsafe(mousenum,j)=NaN; 
        end
    end
    for j=1:length(C_Inst_p_Fsk_Fsafe(mousenum,:))
        if j>length(C_Inst_RunMeanFq_SafeFz.(C_Mouse_names{mousenum}))
            C_Inst_p_Fsk_Fsafe(mousenum,j)=NaN; 
        end
    end
end

fig=figure;
colors = [0 0.6 .4; 0 0.4 .4; 1 0.4 0; 1 0.2 0; 0 0.6 .4; 0 0.4 .4; 1 0.4 0; 1 0.2 0];
for mousenum=1:length(Mouse_C)
    mouse=C_Mouse_names(mousenum);
    subplot(4,2,mousenum)
    
    C_Inst_Time_SafeFz = (1:length(C_Inst_RunMeanFq_SafeFz.(C_Mouse_names{mousenum})))*0.2;
    C_Inst_h_mouse=C_Inst_h_Fsk_Fsafe(mousenum,:);
    ind_Nan=isnan(C_Inst_h_Fsk_Fsafe(mousenum,:));
    C_Inst_h_Fsk_Fsafe_mouse=C_Inst_h_mouse(~ind_Nan);
    
    plot((1:length(C_Inst_RunMeanFq_ShockFz.(C_Mouse_names{mousenum})))*0.2, C_Inst_RunMeanFq_ShockFz.(C_Mouse_names{mousenum}),'Color',colors(3,:)), hold on
    plot(C_Inst_Time_SafeFz, C_Inst_RunMeanFq_SafeFz.(C_Mouse_names{mousenum}),'Color',colors(1,:)), hold on
    try; plot(C_Inst_Time_SafeFz(logical(C_Inst_h_Fsk_Fsafe_mouse)), max(C_Inst_RunMeanFq_ShockFz.(C_Mouse_names{mousenum}))+1, '*k'); end
    title(mouse)
    legend({'Shock', 'Safe'})
    makepretty
end
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Frequency (Hz)', 'FontSize', 25);
xlabel(han,'Time freezing (s)', 'FontSize', 25);
title(han,'Inst frequencies during shock and safe side freezing with timepoints significantly different', 'FontSize', 30);

%% Frequency generated with the spectrogram (respi_freq_BM)

% Compute OB frequency and ripples during freezing shock
for mousenum=1:length(Mouse_C)
    C_Mouse_names{mousenum}=['M' num2str(Mouse_C(mousenum))];
    C_Spect_Freq_Respi_ShockFz.(C_Mouse_names{mousenum}) = Data(C_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,5});
    if isnan(C_Spect_Freq_Respi_ShockFz.(C_Mouse_names{mousenum})(1))
        C_Spect_Freq_Respi_ShockFz.(C_Mouse_names{mousenum})(1:find(~isnan(C_Spect_Freq_Respi_ShockFz.(C_Mouse_names{mousenum})), 1)) = C_Spect_Freq_Respi_ShockFz.(C_Mouse_names{mousenum})(find(~isnan(C_Spect_Freq_Respi_ShockFz.(C_Mouse_names{mousenum})), 1));
    end
    if isnan(C_Spect_Freq_Respi_ShockFz.(C_Mouse_names{mousenum})(end))
        C_Spect_Freq_Respi_ShockFz.(C_Mouse_names{mousenum})(find(~isnan(C_Spect_Freq_Respi_ShockFz.(C_Mouse_names{mousenum})), 1, 'last'):end) = C_Spect_Freq_Respi_ShockFz.(C_Mouse_names{mousenum})(find(~isnan(C_Spect_Freq_Respi_ShockFz.(C_Mouse_names{mousenum})), 1, 'last'));
    end
    C_Spect_RunMeanFq_ShockFz.(C_Mouse_names{mousenum}) = runmean_BM(C_Spect_Freq_Respi_ShockFz.(C_Mouse_names{mousenum}),30);
    C_Spect_Ind_OB_ShockFz.(C_Mouse_names{mousenum}) = Range(C_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,5});
    if isempty(C_TSD_DATA.Cond.ripples.ts{mousenum,5})
        C_TSD_DATA.Cond.ripples.ts{mousenum,5}=NaN;  
    else
        C_Spect_Ind_Ripples_ShockFz.(C_Mouse_names{mousenum}) = Range(C_TSD_DATA.Cond.ripples.ts{mousenum,5}); 
    end
end

% Compute OB frequency and ripples during freezing safe
for mousenum=1:length(Mouse_C)
    C_Spect_Freq_Respi_SafeFz.(C_Mouse_names{mousenum}) = Data(C_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,6});
    if isnan(C_Spect_Freq_Respi_SafeFz.(C_Mouse_names{mousenum})(1))
        C_Spect_Freq_Respi_SafeFz.(C_Mouse_names{mousenum})(1:find(~isnan(C_Spect_Freq_Respi_SafeFz.(C_Mouse_names{mousenum})), 1)) = C_Spect_Freq_Respi_SafeFz.(C_Mouse_names{mousenum})(find(~isnan(C_Spect_Freq_Respi_SafeFz.(C_Mouse_names{mousenum})), 1));
    end
    if isnan(C_Spect_Freq_Respi_SafeFz.(C_Mouse_names{mousenum})(end))
        C_Spect_Freq_Respi_SafeFz.(C_Mouse_names{mousenum})(find(~isnan(C_Spect_Freq_Respi_SafeFz.(C_Mouse_names{mousenum})), 1, 'last'):end) = C_Spect_Freq_Respi_SafeFz.(C_Mouse_names{mousenum})(find(~isnan(C_Spect_Freq_Respi_SafeFz.(C_Mouse_names{mousenum})), 1, 'last'));
    end
    C_Spect_RunMeanFq_SafeFz.(C_Mouse_names{mousenum}) = runmean_BM(C_Spect_Freq_Respi_SafeFz.(C_Mouse_names{mousenum}),30);
    C_Spect_Ind_OB_SafeFz.(C_Mouse_names{mousenum}) = Range(C_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,6});
    if isempty(C_TSD_DATA.Cond.ripples.ts{mousenum,6})
        C_TSD_DATA.Cond.ripples.ts{mousenum,6}=NaN;  
    else
        C_Spect_Ind_Ripples_SafeFz.(C_Mouse_names{mousenum}) = Range(C_TSD_DATA.Cond.ripples.ts{mousenum,6}); 
    end
end

%% OB frequency along freezing shock and safe 

% Plot freezing shock and safe for each mouse
fig=figure;
colors = [0 0.6 .4; 0 0.4 .4; 1 0.4 0; 1 0.2 0; 0 0.6 .4; 0 0.4 .4; 1 0.4 0; 1 0.2 0];
for mousenum=1:length(Mouse_C)
    mouse=C_Mouse_names(mousenum);
    subplot(4,2,mousenum)
    plot((1:length(C_Spect_RunMeanFq_ShockFz.(C_Mouse_names{mousenum})))*0.2, C_Spect_RunMeanFq_ShockFz.(C_Mouse_names{mousenum}),'Color',colors(3,:)), hold on
    plot((1:length(C_Spect_RunMeanFq_SafeFz.(C_Mouse_names{mousenum})))*0.2, C_Spect_RunMeanFq_SafeFz.(C_Mouse_names{mousenum}),'Color',colors(1,:)), hold on
    title(mouse)
    legend({'Shock', 'Safe'})
    makepretty
end
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Frequency (Hz)', 'FontSize', 25);
xlabel(han,'Time freezing (s)', 'FontSize', 25);
title(han,'Spect frequencies during shock and safe side freezing', 'FontSize', 30);

% Add significativity in difference (Fshock > Fsafe)
for mousenum=1:length(Mouse_C)
    for i=1:length(C_Spect_RunMeanFq_SafeFz.(C_Mouse_names{mousenum}))
        [C_Spect_h_Fsk_Fsafe(mousenum,i),C_Spect_p_Fsk_Fsafe(mousenum,i)] = ttest2(C_Spect_RunMeanFq_ShockFz.(C_Mouse_names{mousenum}), C_Spect_RunMeanFq_SafeFz.(C_Mouse_names{mousenum})(i), 'Tail','right', 'Alpha', 0.001);
    end
    for j=1:length(C_Spect_h_Fsk_Fsafe(mousenum,:))
        if j>length(C_Spect_RunMeanFq_SafeFz.(C_Mouse_names{mousenum}))
            C_Spect_h_Fsk_Fsafe(mousenum,j)=NaN; 
        end
    end
    for j=1:length(C_Spect_p_Fsk_Fsafe(mousenum,:))
        if j>length(C_Spect_RunMeanFq_SafeFz.(C_Mouse_names{mousenum}))
            C_Spect_p_Fsk_Fsafe(mousenum,j)=NaN; 
        end
    end
end

fig=figure;
colors = [0 0.6 .4; 0 0.4 .4; 1 0.4 0; 1 0.2 0; 0 0.6 .4; 0 0.4 .4; 1 0.4 0; 1 0.2 0];
for mousenum=1:length(Mouse_C)
    mouse=C_Mouse_names(mousenum);
    subplot(4,2,mousenum)
    
    C_Spect_Time_SafeFz = (1:length(C_Spect_RunMeanFq_SafeFz.(C_Mouse_names{mousenum})))*0.2;
    C_Spect_h_mouse=C_Spect_h_Fsk_Fsafe(mousenum,:);
    ind_Nan=isnan(C_Spect_h_Fsk_Fsafe(mousenum,:));
    C_Spect_h_Fsk_Fsafe_mouse=C_Spect_h_mouse(~ind_Nan);
    
    plot((1:length(C_Spect_RunMeanFq_ShockFz.(C_Mouse_names{mousenum})))*0.2, C_Spect_RunMeanFq_ShockFz.(C_Mouse_names{mousenum}),'Color',colors(3,:)), hold on
    plot(C_Spect_Time_SafeFz, C_Spect_RunMeanFq_SafeFz.(C_Mouse_names{mousenum}),'Color',colors(1,:)), hold on
    try; plot(C_Spect_Time_SafeFz(logical(C_Spect_h_Fsk_Fsafe_mouse)), max(C_Spect_RunMeanFq_ShockFz.(C_Mouse_names{mousenum}))+1, '*k'); end
    title(mouse)
    legend({'Shock', 'Safe'})
    makepretty
end
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Frequency (Hz)', 'FontSize', 25);
xlabel(han,'Time freezing (s)', 'FontSize', 25);
title(han,'Spect frequencies during shock and safe side freezing', 'FontSize', 30);

%% Correlations 

% Compute restricted frequency from spectrogram to instantaneous
for mousenum=1:length(Mouse_C)
    C_Restricted_SpectoInst_SafeFz.(C_Mouse_names{mousenum}) = Restrict(C_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,6}, C_TSD_DATA.Cond.instfreq.tsd{mousenum,6});
    C_ResFreq_SpectoInst_SafeFz.(C_Mouse_names{mousenum}) = Data(C_Restricted_SpectoInst_SafeFz.(C_Mouse_names{mousenum}));
    C_Ind_SafeFz_Freqband.(C_Mouse_names{mousenum}) = and(and(C_ResFreq_SpectoInst_SafeFz.(C_Mouse_names{mousenum})<7,C_ResFreq_SpectoInst_SafeFz.(C_Mouse_names{mousenum})>1), and(C_Inst_Freq_Respi_SafeFz.(C_Mouse_names{mousenum})<7,C_Inst_Freq_Respi_SafeFz.(C_Mouse_names{mousenum})>1));
end

% Plot instantaneous data vs restricted spectrogram data
% For a given mouse
mousenum=7;
mouse=C_Mouse_names(mousenum);

figure
plot(C_ResFreq_SpectoInst_SafeFz.(C_Mouse_names{mousenum}), C_Inst_Freq_Respi_SafeFz.(C_Mouse_names{mousenum}), '.k')
axis square
line([0 14],[0 14],'LineStyle','--','Color','r','LineWidth',4)
xlim([0 14]), ylim([0 14])
xlabel('Spectrogram measured frequencies restricted to instantaneous measured timepoints')
ylabel('Instantaneous measured frequecies')
title(mouse)

% For all mice
fig=figure;
for mousenum=1:length(Mouse_C)
    mouse=C_Mouse_names(mousenum);
    subplot(2,4,mousenum)
    plot(C_ResFreq_SpectoInst_SafeFz.(C_Mouse_names{mousenum}), C_Inst_Freq_Respi_SafeFz.(C_Mouse_names{mousenum}), '.k')
    axis square
    line([0 14],[0 14],'LineStyle','--','Color','r','LineWidth',4)
    xlim([0 14]), ylim([0 14])
    title(mouse)
    makepretty
end
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Instantaneous measured frequecies', 'FontSize', 25);
xlabel(han,'Spectrogram measured frequencies restricted to instantaneous measured timepoints (Hz)', 'FontSize', 25);
title(han,'Correlation between Inst and Spect measured frequencies', 'FontSize', 30);

% Histogram (not that informative)
% figure
% subplot(2,1,1)
% hist(C_ResFreq_SpectoInst_SafeFz.(C_Mouse_names{mousenum}),30)
% xlim([0 14])
% ylim([0 70])
% subplot(2,1,2)
% hist(C_Inst_Freq_Respi_SafeFz.(C_Mouse_names{mousenum}),30)
% xlim([0 14])
% ylim([0 70])

% 2D Histogram
% For a given mouse
for mousenum=1
    mouse=C_Mouse_names(mousenum);
    % generate spectrogram data restricted to band 1-7Hz for a mouse
    C_ResFreq_SpectoInst_SafeFz_mouse = C_ResFreq_SpectoInst_SafeFz.(C_Mouse_names{mousenum});
    C_Ind_SafeFz_Freqband_mouse = C_Ind_SafeFz_Freqband.(C_Mouse_names{mousenum});
    C_ResBandFreq_SpectoInst_SafeFz_mouse = C_ResFreq_SpectoInst_SafeFz_mouse(C_Ind_SafeFz_Freqband_mouse);
    % generate instantaneous data restricted to band 1-7Hz for a mouse
    C_Inst_Freq_Respi_SafeFz_mouse = C_Inst_Freq_Respi_SafeFz.(C_Mouse_names{mousenum});
    C_Inst_BandFreq_Respi_SafeFz_mouse = C_Inst_Freq_Respi_SafeFz_mouse(C_Ind_SafeFz_Freqband_mouse);
end

figure
H = hist2d([C_ResBandFreq_SpectoInst_SafeFz_mouse; [1 1 7 7]'],[C_Inst_BandFreq_Respi_SafeFz_mouse; [1 7 1 7]'],30,30);
imagesc(linspace(1,7,30) , linspace(1,7,30) , SmoothDec(H,.7)'), axis xy, axis square
line([0 7],[0 7],'LineStyle','--','Color','r','LineWidth',5)
colorbar
caxis
xlabel('Spectrogram measured frequencies restricted to instantaneous measured timepoints (Hz)')
ylabel('Instantaneous measured frequecies (Hz)')
title(mouse)

% 2D Histogram for all mice
fig=figure;
for mousenum=1:length(Mouse_C)
    mouse=C_Mouse_names(mousenum);
    subplot(2,4,mousenum)
    
    % generate spectrogram data restricted to band 1-7Hz for a mouse
    C_ResFreq_SpectoInst_SafeFz_mouse = C_ResFreq_SpectoInst_SafeFz.(C_Mouse_names{mousenum});
    C_Ind_SafeFz_Freqband_mouse = C_Ind_SafeFz_Freqband.(C_Mouse_names{mousenum});
    C_ResBandFreq_SpectoInst_SafeFz_mouse = C_ResFreq_SpectoInst_SafeFz_mouse(C_Ind_SafeFz_Freqband_mouse);
    % generate instantaneous data restricted to band 1-7Hz for a mouse
    C_Inst_Freq_Respi_SafeFz_mouse = C_Inst_Freq_Respi_SafeFz.(C_Mouse_names{mousenum});
    C_Inst_BandFreq_Respi_SafeFz_mouse = C_Inst_Freq_Respi_SafeFz_mouse(C_Ind_SafeFz_Freqband_mouse);
    
    H = hist2d([C_ResBandFreq_SpectoInst_SafeFz_mouse; [1 1 7 7]'],[C_Inst_BandFreq_Respi_SafeFz_mouse; [1 7 1 7]'],30,30);
    imagesc(linspace(1,7,30) , linspace(1,7,30) , SmoothDec(H,.7)'), axis xy, axis square
    xticks([0:2:14])
    line([0 7],[0 7],'LineStyle','--','Color','r','LineWidth',5);
    colorbar
    caxis
    title(mouse)
    makepretty
end
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Instantaneous measured frequecies', 'FontSize', 25);
xlabel(han,'Spectrogram measured frequencies restricted to instantaneous measured timepoints (Hz)', 'FontSize', 25);
title(han,'Spect frequencies during shock and safe side freezing (Hz)', 'FontSize', 30);

% Look at the signals
figure
plot(runmean_BM(C_ResFreq_SpectoInst_SafeFz.(C_Mouse_names{mousenum}),30))
hold on
plot(runmean_BM(C_Inst_Freq_Respi_SafeFz.(C_Mouse_names{mousenum}),30))
ylim([1 7])
%plot(runmean_BM(C_Inst_Freq_Respi_SafeFz.(C_Mouse_names{mousenum})-2,30))
title(mouse)

fig=figure;
colors = [0 0.6 .4; 0 0.4 .4; 1 0.4 0; 1 0.2 0; 0 0.6 .4; 0 0.4 .4; 1 0.4 0; 1 0.2 0];
for mousenum=1:length(Mouse_C)
    mouse=C_Mouse_names(mousenum);
    subplot(4,2,mousenum)
    plot(runmean_BM(C_ResFreq_SpectoInst_SafeFz.(C_Mouse_names{mousenum}),30)); hold on
    plot(runmean_BM(C_Inst_Freq_Respi_SafeFz.(C_Mouse_names{mousenum}),30))
    ylim([0.5 7])
    title(mouse)
    makepretty
end
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Frequency (Hz)', 'FontSize', 25);
xlabel(han,'Timepoints freezing', 'FontSize', 25);
title(han,'Spect (blue) vs Inst (red) frequencies during safe side freezing', 'FontSize', 25);


%% Conclusion 

% Difference in fOB between the one measured with the spectrogram and the
% one measured with the LFP of the OB (instfreq). 

% Decision to correct the frequency measurement, to be continued

%% To test Freezing shock and safe across absolute time of the conditionning session

%OB frequencies during freezing episodes across the global time of the trial
% for mousenum=1:length(Mouse_C)
%     C_Spect_Time_spent_maze.(C_Mouse_names{mousenum}) = min(Range(C_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,1})):ceil(min(diff(C_Spect_Ind_OB_SafeFz.(C_Mouse_names{mousenum})))):max(Range(C_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,1}));
%     C_Spect_Global_Freq_Respi_SafeFz.(C_Mouse_names{mousenum}) = interp1(C_Spect_Ind_OB_SafeFz.(C_Mouse_names{mousenum}), runmean_BM(C_Spect_Freq_Respi_SafeFz.(C_Mouse_names{mousenum}),30), C_Spect_Time_spent_maze.(C_Mouse_names{mousenum}));
%     C_Spect_Global_Freq_Respi_SafeFz.(C_Mouse_names{mousenum})(1:find(~isnan(C_Spect_Global_Freq_Respi_SafeFz.(C_Mouse_names{mousenum})), 1)) = C_Spect_Global_Freq_Respi_SafeFz.(C_Mouse_names{mousenum})(find(~isnan(C_Spect_Global_Freq_Respi_SafeFz.(C_Mouse_names{mousenum})), 1));
%     C_Spect_Global_Freq_Respi_SafeFz.(C_Mouse_names{mousenum})(find(~isnan(C_Spect_Global_Freq_Respi_SafeFz.(C_Mouse_names{mousenum})), 1, 'last'):end) = C_Spect_Global_Freq_Respi_SafeFz.(C_Mouse_names{mousenum})(find(~isnan(C_Spect_Global_Freq_Respi_SafeFz.(C_Mouse_names{mousenum})), 1, 'last'));
% end
% 
% % Plot the OB mean frequency during freezing across absolute time of the conditionning session
% figure;
% colors = [0 0.6 .4; 0 0.4 .7; 1 0.4 0; 1 0.2 0; 0 0.6 .4; 0 0.4 .7; 1 0.4 0; 1 0.2 0];
% for mousenum=1:length(Mouse_C)
%     mouse=C_Mouse_names(mousenum);
%     subplot(2,4,mousenum)
%     plot(C_Spect_Time_spent_maze.(C_Mouse_names{mousenum}), runmean_BM(C_Spect_Global_Freq_Respi_SafeFz.(C_Mouse_names{mousenum}),30),'Color',colors(mousenum,:)), hold on
%     plot(C_Spect_Ind_OB_SafeFz.(C_Mouse_names{mousenum}), max(runmean_BM(C_Spect_Global_Freq_Respi_SafeFz.(C_Mouse_names{mousenum}),30))+0.5, '.k')
%     ylim([min(C_Spect_Global_Freq_Respi_SafeFz.(C_Mouse_names{mousenum}))-0.8 max(C_Spect_Global_Freq_Respi_SafeFz.(C_Mouse_names{mousenum}))+0.8])
%     title(mouse)
%     xlabel('Absolute time freezing')
%     ylabel('Frequency (Hz)')
%     makepretty
% end
% suptitle('C OB frequency during absolute time freezing')






