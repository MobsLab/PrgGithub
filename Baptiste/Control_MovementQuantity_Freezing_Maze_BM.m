
clear all
GetEmbReactMiceFolderList_BM
Mouse = Drugs_Groups_UMaze_BM(22);
Session_type = {'Cond'}; sess=1;

window_bef_fz = 5;

%% generate data
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    
    % load data
    Acc = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'accelero');
%     Respi = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'respi_freq_bm');
    Respi = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'instfreq','method','WV','suffix_instfreq','B');
    
    FreezeEpoch = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'epoch','epochname','freezeepoch_withnoise');
    FreezeEpoch=mergeCloseIntervals(FreezeEpoch,0.3*1E4);
    FreezeEpoch=dropShortIntervals(FreezeEpoch,2*1E4);
    ZoneEpoch = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'epoch','epochname','zoneepoch_behav');
    ShockZone = ZoneEpoch{1};
    SafeZone = or(ZoneEpoch{2} , ZoneEpoch{5});
    Fz_Shock = and(FreezeEpoch , ShockZone);
    Fz_Shock=mergeCloseIntervals(Fz_Shock,0.3*1E4);
    Fz_Shock=dropShortIntervals(Fz_Shock,2*1E4);
    Fz_Safe = and(FreezeEpoch , SafeZone);
    Fz_Safe=mergeCloseIntervals(Fz_Safe,0.3*1E4);
    Fz_Safe=dropShortIntervals(Fz_Safe,2*1E4);
    
    % histogram duration
    h=histogram(DurationEpoch(FreezeEpoch)/1e4,'BinLimits',[2 20],'NumBins',19);
    HistData_Fz(mouse,:) = h.Values;
    h=histogram(DurationEpoch(Fz_Shock)/1e4,'BinLimits',[2 20],'NumBins',19);
    HistData_FzShock(mouse,:) = h.Values;
    h=histogram(DurationEpoch(Fz_Safe)/1e4,'BinLimits',[2 20],'NumBins',19);
    HistData_FzSafe(mouse,:) = h.Values;
    
    % median duration
    MedDur_Fz(mouse) = nanmedian(DurationEpoch(FreezeEpoch));
    MedDur_FzShock(mouse) = nanmedian(DurationEpoch(Fz_Shock));
    MedDur_FzSafe(mouse) = nanmedian(DurationEpoch(Fz_Safe));
    
    % correlation respi, movement quantity
    clear St, St = Start(FreezeEpoch);
    for ep=1:length(St)
        Ep_bef_Fz = intervalSet(St(ep)-5e4 , St(ep));
        MeanRespi{mouse}(ep) = nanmean(Data(Restrict(Respi , subset(FreezeEpoch,ep))));
        MeanMvtBef{mouse}(ep) = nanmean(Data(Restrict(Acc , Ep_bef_Fz)));
    end
    [r(mouse) , p(mouse)] = corr(MeanRespi{mouse}(~isnan(MeanRespi{mouse}))' , log10(MeanMvtBef{mouse}(~isnan(MeanRespi{mouse})))');
    
    try % for 1147
        FzShockEp_numb = length(Start(Fz_Shock));
        clear St, St = Start(Fz_Shock);
        n=1;
        for ep=round(FzShockEp_numb*.9):FzShockEp_numb
            Ep_bef_Fz = intervalSet(St(ep)-window_bef_fz*1e4 , St(ep));
            MeanRespi_EpShock{mouse}(n) = nanmean(Data(Restrict(Respi , subset(Fz_Shock , ep))));
            MeanMvtBef_EpShock{mouse}(n) = log10(nanmean(Data(Restrict(Acc , Ep_bef_Fz))));
            n=n+1;
        end
        [M_respi_shock{mouse} , T_respi_shock{mouse}] = PlotRipRaw(Respi, St(round(FzShockEp_numb*.9):FzShockEp_numb)./1e4 , 5000 ,0,0,0);
        [M_Acc_shock{mouse} , T_acc_shock{mouse}] = PlotRipRaw(Acc, St(round(FzShockEp_numb*.9):FzShockEp_numb)./1e4 , 5000 ,0,0,0);
    end
    
    FzSafeEp_numb = length(Start(Fz_Safe));
    clear St, St = Start(Fz_Safe);
    n=1;
    for ep=round(FzSafeEp_numb*.9):FzSafeEp_numb
        Ep_bef_Fz = intervalSet(St(ep)-window_bef_fz*1e4 , St(ep));
        MeanRespi_EpSafe{mouse}(n) = nanmean(Data(Restrict(Respi , subset(Fz_Safe , ep))));
        MeanMvtBef_EpSafe{mouse}(n) = log10(nanmean(Data(Restrict(Acc , Ep_bef_Fz))));
        
        n=n+1;
    end
    [M_respi_safe{mouse} , T_respi_safe{mouse}] = PlotRipRaw(Respi, St(round(FzSafeEp_numb*.9):FzSafeEp_numb)./1e4 , window_bef_fz*1e3 ,0,0,0);
    [M_Acc_safe{mouse} , T_acc_safe{mouse}] = PlotRipRaw(Acc, St(round(FzSafeEp_numb*.9):FzSafeEp_numb)./1e4 , window_bef_fz*1e3 ,0,0,0);
    
    disp(Mouse_names{mouse})
end
r([1 3 4]) = NaN;
close

for mouse=[2 5:29]
    try
        MeanAcc_AroundFzShockOnset(mouse,:) = M_Acc_shock{mouse}(:,2);
        MeanRespi_AroundFzShockOnset(mouse,:) = M_respi_shock{mouse}(:,2);
        MeanAcc_AroundFzSafeOnset(mouse,:) = M_Acc_safe{mouse}(:,2);
        MeanRespi_AroundFzSafeOnset(mouse,:) = M_respi_safe{mouse}(:,2);
    end
end
MeanAcc_AroundFzShockOnset(MeanAcc_AroundFzShockOnset==0) = NaN;
MeanRespi_AroundFzShockOnset(MeanRespi_AroundFzShockOnset==0) = NaN;
MeanAcc_AroundFzSafeOnset(MeanAcc_AroundFzSafeOnset==0) = NaN;
MeanRespi_AroundFzSafeOnset(MeanRespi_AroundFzSafeOnset==0) = NaN;

%% figures
% median dur
Cols = {[1 .5 .5],[.5 .5 1]};
X = 1:2;
Legends = {'Fz shock','Fz safe'};

figure
subplot(131)
MakeSpreadAndBoxPlot3_SB({MedDur_FzShock./1e4 MedDur_FzSafe./1e4},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('median duration fz (s)')
makepretty_BM2

subplot(1,3,2:3)
Data_to_use = HistData_FzShock./sum(HistData_FzShock')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
errhigh = Conf_Inter;
er = errorbar([3:2:39] , nanmean(Data_to_use) , errhigh);    
er.Color = [0 0 0];
er.LineStyle = 'none';  
hold on
b=bar([3:2:39] , nanmean(Data_to_use)); b.FaceColor=[1 .5 .5]; b.BarWidth=.4;

Data_to_use = HistData_FzSafe./sum(HistData_FzSafe')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
errhigh = Conf_Inter;
er = errorbar([4:2:40] , nanmean(Data_to_use) , errhigh);    
er.Color = [0 0 0];
er.LineStyle = 'none';  
hold on
b=bar([4:2:40] , nanmean(Data_to_use)); b.FaceColor=[.5 .5 1]; b.BarWidth=.4;             

xticks([10 20 30 40]), xticklabels({'5','10','15','20'})
xlabel('duration (s)'), ylabel('proportion')
f=get(gca,'Children'); legend([f(3),f(1)],'Shock','Safe');
makepretty



% examples
figure
subplot(121), mouse=10;
PlotCorrelations_BM(log10(MeanMvtBef{mouse}) , MeanRespi{mouse})
xlabel('Movement before fz ep (log)'), ylabel('mean respi in fz ep (Hz)')
makepretty_BM2, axis square

subplot(122), mouse=9;
PlotCorrelations_BM(log10(MeanMvtBef{mouse}) , MeanRespi{mouse})
xlabel('Movement before fz ep (log)'), ylabel('mean respi in fz ep (Hz)')
makepretty_BM2, axis square


figure
MakeSpreadAndBoxPlot4_SB({r},{[.3 .3 .3]},[1],{'R'},'showpoints',1,'paired',0)
hline(0,'--k'), ylabel('R values')
makepretty_BM2

[h,p] =ttest(r(~isnan(r)) , zeros(1,sum(~isnan(r))))
sigstar({[.7 1.3]},p)



%
figure
subplot(121)
Data_to_use = movmean(log10(MeanAcc_AroundFzShockOnset)',20)';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-5,5,501) , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
color= [1 .5 .5]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
hold on
Data_to_use = movmean(log10(MeanAcc_AroundFzSafeOnset)',20)';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-5,5,501) , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
color= [.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
xlabel('time (s)'), ylabel('Quantity movement (log)'), vline(0,'--k'), xticks([-5:1:5])
f=get(gca,'Children'); legend([f(5),f(1)],'Shock','Safe');
makepretty

subplot(122)
Data_to_use = movmean(MeanRespi_AroundFzShockOnset',50,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-5,5,1251) , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
color= [1 .5 .5]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
hold on
Data_to_use = movmean(MeanRespi_AroundFzSafeOnset',50,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-5,5,1251) , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
color= [.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
xlabel('time (s)'), ylabel('Breathing (Hz)'), vline(0,'--k'), xticks([-5:1:5]), xlim([-5 2])
makepretty




%% tools
figure
for mouse=1:29
    subplot(4,8,mouse)
    hist(MedDur_Fz{mouse},20)
end

figure
for mouse=1:29
    subplot(4,8,mouse)
    hist(MedDur_FzShock{mouse},20)
end

figure
for mouse=1:29
    subplot(4,8,mouse)
    hist(MedDur_FzSafe{mouse},20)
end


figure
hist(r(p<.05))


nansum(r(p<.05)>0)

nansum(r>0)./(nansum(r>0)+nansum(r<0))



figure, 
for mouse=1:10
    subplot(2,5,mouse)
    PlotCorrelations_BM(MeanRespi{mouse} , log10(MeanMvtBef{mouse}))
end















