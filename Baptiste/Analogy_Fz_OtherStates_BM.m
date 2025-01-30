
%% generate data
GetAllSalineSessions_BM
smoofact_Acc = 30;
thtps_immob=2;

for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    try 
        UMazeSleepSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Sleep')))));
        SleepPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(1);
        if length(UMazeSleepSess.(Mouse_names{mouse}))==3
            SleepPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(1);
            SleepPostPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(2);
            SleepPostSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(3);
        else
            try
                SleepPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(1);
                SleepPostSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(2);
            catch 
                SleepPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(1);
                SleepPostSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(1);
            end
        end
    end
end


for mouse = 1:length(Mouse)
    try
        if mouse<36
            th_immob_Acc = 1e7;
        else
            th_immob_Acc = 1.7e7;
        end
        
        NewMovAcctsd=tsd(Range(Sleep.OutPutData.sleep_pre.accelero.tsd{mouse,1}),runmean(Data(Sleep.OutPutData.sleep_pre.accelero.tsd{mouse,1}),smoofact_Acc));
        FreezeAccEpoch=thresholdIntervals(NewMovAcctsd,th_immob_Acc,'Direction','Below');
        FreezeAccEpoch=mergeCloseIntervals(FreezeAccEpoch,0.3*1e4);
        FreezeAccEpoch=dropShortIntervals(FreezeAccEpoch,thtps_immob*1e4);
        
        Sleep1 = Sleep.Epoch1.sleep_pre{mouse,3};
        Sleep1 = dropShortIntervals(Sleep1,30e4);
        
        Sleep_Beginning = Start(Sleep1) ;
        Wake_Before_Sleep_Epoch{mouse} = intervalSet(0 , Sleep_Beginning(1));
        
        Freezing_Before_Sleep{mouse} = and(FreezeAccEpoch , Wake_Before_Sleep_Epoch{mouse});
        Freezing_After_Sleep{mouse} = (FreezeAccEpoch-Freezing_Before_Sleep{mouse})-Sleep1;
        
        try
            OB = ConcatenateDataFromFolders_SB(SleepPreSess.(Mouse_names{mouse}),'spectrum','prefix','B_Low');
            OB_Sp_Wake_Before_Sleep{mouse} = Restrict(OB , Wake_Before_Sleep_Epoch{mouse});
            OB_Sp_Fz_Before_Sleep{mouse} = Restrict(OB , Freezing_Before_Sleep{mouse});
            OB_Sp_Fz_After_Sleep{mouse} = Restrict(OB , Freezing_After_Sleep{mouse});
        end
    end
    disp(mouse)
end

for mouse = 1:length(Mouse)
    try, Fz_Dur_HC(mouse) = sum(DurationEpoch(Freezing_Before_Sleep{mouse}))/1e4; end
    try, OB_Low_Fz_Before_Sleep(mouse,:) = nanmean(Data(OB_Sp_Fz_Before_Sleep{mouse})); end
end
OB_Low_Fz_Before_Sleep(OB_Low_Fz_Before_Sleep==0)=NaN;








%% sleep
load('/media/nas7/ProjetEmbReact/DataEmbReact/States_Comparison_Fz_Sleep_QW_Act.mat')
Params = Fear.Params; Params{8} = 'hpc_theta_delta';
Params2 = {'accelero','emg_pect','ob_gamma_power'};
load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/MeanBodyValues_Fz.mat', 'Freq_Max1', 'Freq_Max2')
Mouse = Fear.Mouse;

Sleep.OutPutData.sleep_pre.accelero.mean([21 23 27 37],3)=NaN;
Fear.OutPutData.Fear.accelero.mean([21 23],[5 6])=NaN;
Sleep.OutPutData.sleep_pre.emg_pect.mean([27],3)=NaN;
Sleep.OutPutData.sleep_pre.ob_gamma_power.mean([37:39],3)=NaN;
Sleep.OutPutData.sleep_pre.ob_gamma_freq.mean(24,3)=NaN;



Cols = {[.5 .5 .5],[.5 .5 1],[1 .5 .5]};
X = [1:3];
Legends = {'Sleep','Safe','Shock'};
NoLegends = {'','',''};

figure
[~ , ~ , Freq_Max_Sleep] = Plot_MeanSpectrumForMice_BM(squeeze(Sleep.OutPutData.sleep_pre.ob_low.mean(:,3,:)));
xlabel('Frequency (Hz)'); ylabel('Power (a.u.)'); xlim([0 10]); ylim([0 1])
makepretty
v1=vline(nanmean(4.73)); set(v1,'LineStyle','--','Color',[1 .5 .5]); v2=vline(nanmean(3.053)); set(v2,'LineStyle','--','Color',[.5 .5 1])
xticks([0:2:14])
axis square


figure
for param = 1:3
    subplot(1,3,param)
    
        ind = and(and(~isnan(Sleep.OutPutData.sleep_pre.(Params2{param}).mean(:,3)) , ~isnan(Fear.OutPutData.Fear.(Params2{param}).mean(:,5))) ,...
            ~isnan(Fear.OutPutData.Fear.(Params2{param}).mean(:,6)));
        
        MakeSpreadAndBoxPlot3_SB({Sleep.OutPutData.sleep_pre.(Params2{param}).mean(ind,3) Fear.OutPutData.Fear.(Params2{param}).mean(ind,6)...
            Fear.OutPutData.Fear.(Params2{param}).mean(ind,5)},Cols,X,Legends,'showpoints',0,'paired',1);

    if param==1
        ylabel('Motion (log scale)')
    elseif param==2
        ylabel('EMG power (log scale)')
    elseif param==3
        ylabel('OB gamma power (log scale)')
    end
    makepretty_BM2
    set(gca,'YScale','log')
end
ylim([150 1100])


figure
for param = 1:8
    subplot(1,8,param)
    
    if param>1
        ind = and(and(~isnan(Sleep.OutPutData.sleep_pre.(Params{param}).mean(:,3)) , ~isnan(Fear.OutPutData.Fear.(Params{param}).mean(:,5))) ,...
            ~isnan(Fear.OutPutData.Fear.(Params{param}).mean(:,6)));
        
        MakeSpreadAndBoxPlot3_SB({Sleep.OutPutData.sleep_pre.(Params{param}).mean(ind,3) Fear.OutPutData.Fear.(Params{param}).mean(ind,6)...
            Fear.OutPutData.Fear.(Params{param}).mean(ind,5)},Cols,X,Legends,'showpoints',0,'paired',1);
    else
        ind = and(and(~isnan(Freq_Max_Sleep) , ~isnan(Freq_Max1)) , ~isnan(Freq_Max2));
        
        MakeSpreadAndBoxPlot3_SB({Freq_Max_Sleep(ind) Freq_Max2(ind) Freq_Max1(ind)},Cols,X,Legends,'showpoints',0,'paired',1);
    end
    if param==1
        ylabel('Breathing (Hz)')
    elseif param==2
        ylabel('Heart rate (Hz)')
    elseif param==3
        ylabel('Heart rate variability (a.u.)')
    elseif param==4
        ylabel('OB gamma frequency (Hz)')
    elseif param==5
        ylabel('OB gamma power (a.u.)')
    elseif param==6
        ylabel('Ripples occurence (#/s)')
    elseif param==7
        ylabel('HPC theta frequency (Hz)')
    elseif param==8
        ylabel('HPC theta power (log scale)')
        set(gca,'YScale','log')
    end
    makepretty_BM2
end




for param=[1 2 4 7 3 6 5 8]
    if or(param==8 , param==5)
        P_Sleep(:,param) = [nanmedian(log10(Sleep.OutPutData.sleep_pre.(Params{param}).mean(ind,3))) nanmedian(log10(Fear.OutPutData.Fear.(Params{param}).mean(ind,5)))...
            nanmedian(log10(Fear.OutPutData.Fear.(Params{param}).mean(ind,6)))];
    elseif param==1
        P_Sleep(:,param) = [nanmedian(Freq_Max_Sleep(ind)) nanmedian(Freq_Max1(ind)) nanmedian(Freq_Max2(ind))];
    else
        P_Sleep(:,param) = [nanmedian(Sleep.OutPutData.sleep_pre.(Params{param}).mean(ind,3)) nanmedian(Fear.OutPutData.Fear.(Params{param}).mean(ind,5))...
            nanmedian(Fear.OutPutData.Fear.(Params{param}).mean(ind,6))];
    end
end
save('/media/nas7/ProjetEmbReact/DataEmbReact/SpiderMap_OtherStates.mat','P_Sleep','-append')



load('/media/nas7/ProjetEmbReact/DataEmbReact/SpiderMap_OtherStates.mat','P_Sleep')

figure
s = spider_plot_class(P_Sleep([2 3 1],:));
s.AxesLabels =  {'','','','','','','',''};
s.LegendLabels = {'Freezing shock', 'Freezing safe','Sleep'};
s.AxesInterval = 2;
s.FillOption = { 'on','on', 'on'};
s.Color = [1 .5 .5; .5 .5 1 ; .5 .5 .5];
s.LegendHandle.Location = 'northeastoutside';
s.AxesLabelsEdge = 'none';
% s.AxesLimits(:,:) = [2.21 9.5 63.5 6.2 .1 .1 1.09 1.56 ; 5.12 11.84 68.6 12 .24 .308 3 2.09];
s.MarkerSize=[1e2 1e2 1e2];
s.AxesTickLabels={''};


DATA_sleep(1,:) = Freq_Max_Sleep;

for param=2:8
    DATA_sleep(param,:) = Sleep.OutPutData.sleep_pre.(Params{param}).mean(:,3)';
end
save('/media/nas7/ProjetEmbReact/DataEmbReact/NewData/CondPost_corrected.mat','DATA_sleep','-append')



load('/media/nas7/ProjetEmbReact/DataEmbReact/Control_TemporalBiased.mat', 'FreezeSafe_Time', 'FreezeShock_Time')
for mouse=1:length(Mouse)
    try, MeanDur{1}(mouse) = nanmean(DurationEpoch(Sleep.Epoch1.sleep_pre{mouse,3})/1e4); end
    try, MeanDur{2}(mouse) = nanmean([FreezeSafe_Time{3}{mouse} ; FreezeSafe_Time{4}{mouse}]); end
    try, MeanDur{3}(mouse) = nanmean([FreezeShock_Time{3}{mouse} ; FreezeShock_Time{4}{mouse}]); end
    try, [M{mouse},T] = PlotRipRaw(Sleep.OutPutData.sleep_pre.accelero.tsd{mouse,1}, Start(Sleep.Epoch1.sleep_pre{mouse,3})/1e4, 1e4, 0, 0, 0);
        MeanAcc_Before{1}(mouse,:) = M{mouse}(:,2); end
    try
        ind = (DurationEpoch(Fear.Epoch1.Fear{mouse,5})/1e4)>2; St = Start(Fear.Epoch1.Fear{mouse,5});
        [M{mouse},T] = PlotRipRaw(Fear.OutPutData.Fear.accelero.tsd{mouse,1}, St(ind)/1e4, 1e4, 0, 0, 0);
        MeanAcc_Before{2}(mouse,:) = M{mouse}(:,2);
    end
    try
        ind = (DurationEpoch(Fear.Epoch1.Fear{mouse,6})/1e4)>2; St = Start(Fear.Epoch1.Fear{mouse,6});
        [M{mouse},T] = PlotRipRaw(Fear.OutPutData.Fear.accelero.tsd{mouse,1}, St(ind)/1e4, 1e4, 0, 0, 0);
        MeanAcc_Before{3}(mouse,:) = M{mouse}(:,2);
    end
end
for i=1:3
    MeanDur{i}(MeanDur{i}==0) = NaN; 
    MeanAcc_Before{i}(MeanAcc_Before{i}==0) = NaN; 
    MeanAcc_Before{i}(37:end,:) = MeanAcc_Before{i}(37:end,:)./1.7;
end
ind = and(and(~isnan(MeanDur{1}) , ~isnan(MeanDur{2})) , ~isnan(MeanDur{3}));
MeanAcc_Before{1}(27,:) = NaN;


figure
subplot(131)
MakeSpreadAndBoxPlot3_SB({MeanDur{1}(ind) MeanDur{2}(ind) MeanDur{3}(ind)},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('mean duration (s)')
makepretty_BM2

subplot(1,3,2:3)
Data_to_use = MeanAcc_Before{1};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-10,10,1001) , runmean(Mean_All_Sp,50) , runmean(Conf_Inter,50) ,'-k',1); hold on;
color= [.3 .3 .3]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
Data_to_use = MeanAcc_Before{2};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-10,10,1001) , runmean(Mean_All_Sp,50) , runmean(Conf_Inter,50) ,'-k',1); hold on;
color= [1 .5 .5]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
Data_to_use = MeanAcc_Before{3};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-10,10,1001) , runmean(Mean_All_Sp,50) , runmean(Conf_Inter,50) ,'-k',1); hold on;
color= [.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
makepretty
xlabel('time (s)'), ylabel('Motion (a.u.)')
f=get(gca,'Children'); legend([f([9 5 1])],'Sleep','Shock','Safe');



%% Quiet wake
Legends = {'Quiet wake','Safe','Shock'};

for mouse=1:length(Mouse)
    if mouse<36
        th_immob_Acc = 1e7;
    else
        th_immob_Acc = 1.7e7;
    end
    try
        NewMovAcctsd=tsd(Range(Sleep.OutPutData.sleep_pre.accelero.tsd{mouse,1}),runmean(Data(Sleep.OutPutData.sleep_pre.accelero.tsd{mouse,1}),30));
        FreezeAccEpoch=thresholdIntervals(NewMovAcctsd,th_immob_Acc,'Direction','Below');
        FreezeAccEpoch=mergeCloseIntervals(FreezeAccEpoch,0.3*1e4);
        FreezeAccEpoch=dropShortIntervals(FreezeAccEpoch,2*1e4);
        Sleep.FreezeAccEpoch_Wake{mouse} = and(FreezeAccEpoch , Sleep.Epoch1.sleep_pre{mouse,2});
    end
end

for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    try
        for param=1:8
            MeanVal_QW.(Params{param})(mouse) = nanmean(Data(Restrict(Sleep.OutPutData.sleep_pre.(Params{param}).tsd{mouse,1} , Sleep.FreezeAccEpoch_Wake{mouse})));
        end
        for param=1:3
            MeanVal_QW.(Params2{param})(mouse) = nanmean(Data(Restrict(Sleep.OutPutData.sleep_pre.(Params2{param}).tsd{mouse,1} , Sleep.FreezeAccEpoch_Wake{mouse})));
        end
        disp(Mouse_names{mouse})
    end
end
for param=1:8
    MeanVal_QW.(Params{param})(MeanVal_QW.(Params{param})==0) = NaN;
    MeanVal_QW.(Params{param}) = MeanVal_QW.(Params{param})';
end
for param=1:3
    MeanVal_QW.(Params2{param})(MeanVal_QW.(Params2{param})==0)=NaN;
    MeanVal_QW.(Params2{param}) = MeanVal_QW.(Params2{param})';
end
MeanVal_QW.(Params{4})(24)=NaN;
MeanVal_QW.(Params{5})(24)=NaN;
MeanVal_QW.ob_gamma_power=MeanVal_QW.ob_gamma_power';
MeanVal_QW.accelero(29)=NaN;
MeanVal_QW.ob_gamma_power([37:39])=NaN;


figure
[~ , ~ , Freq_Max_QW] = Plot_MeanSpectrumForMice_BM(Sleep.OB_Low_Fz_Before_Sleep);
xlabel('Frequency (Hz)'); ylabel('Power (a.u.)'); xlim([0 10]); ylim([0 1])
makepretty
v1=vline(nanmean(4.73)); set(v1,'LineStyle','--','Color',[1 .5 .5]); v2=vline(nanmean(3.053)); set(v2,'LineStyle','--','Color',[.5 .5 1])
xticks([0:2:14])
axis square


figure
for param = 1:3
    subplot(1,3,param)
    
    ind = and(and(~isnan(MeanVal_QW.(Params2{param})) , ~isnan(Fear.OutPutData.Fear.(Params2{param}).mean(:,5))) ,...
        ~isnan(Fear.OutPutData.Fear.(Params2{param}).mean(:,6)));
    
    MakeSpreadAndBoxPlot3_SB({MeanVal_QW.(Params2{param})(ind) Fear.OutPutData.Fear.(Params2{param}).mean(ind,6) Fear.OutPutData.Fear.(Params2{param}).mean(ind,5)},Cols,X,Legends,'showpoints',0,'paired',1);
    
    if param==1
        ylabel('Motion (a.u.)')
    elseif param==2
        ylabel('EMG power (a.u.)')
    elseif param==3
        ylabel('OB gamma power (a.u.)')
    end
    makepretty_BM2
    set(gca,'YScale','log')
end


figure
for param = 1:8
    subplot(1,8,param)
    if param>1
        
        ind = and(and(~isnan(MeanVal_QW.(Params{param})) , ~isnan(Fear.OutPutData.Fear.(Params{param}).mean(:,5))) , ~isnan(Fear.OutPutData.Fear.(Params{param}).mean(:,6)));
        MakeSpreadAndBoxPlot3_SB({MeanVal_QW.(Params{param})(ind) Fear.OutPutData.Fear.(Params{param}).mean(ind,6)...
            Fear.OutPutData.Fear.(Params{param}).mean(ind,5)},Cols,X,Legends,'showpoints',0,'paired',1);
        
    else
        
        ind = and(and(~isnan(Freq_Max_QW) , ~isnan(Freq_Max1)) , ~isnan(Freq_Max2));
        MakeSpreadAndBoxPlot3_SB({Freq_Max_QW(ind) Freq_Max2(ind) Freq_Max1(ind)},Cols,X,Legends,'showpoints',0,'paired',1);
        
    end
    if param==1
        ylabel('Breathing (Hz)')
    elseif param==2
        ylabel('Heart rate (Hz)')
    elseif param==3
        ylabel('Heart rate variability (a.u.)')
    elseif param==4
        ylabel('OB gamma frequency (Hz)')
    elseif param==5
        ylabel('OB gamma power (a.u.)')
    elseif param==6
        ylabel('Ripples occurence (#/s)')
    elseif param==7
        ylabel('HPC theta frequency (Hz)')
    elseif param==8
        ylabel('HPC theta power (log scale)')
        set(gca,'YScale','log')
    end
    makepretty_BM2
end


for param=[1 2 4 7 3 6 5 8]
    ind = and(and(~isnan(MeanVal_QW.(Params{param})) , ~isnan(Fear.OutPutData.Fear.(Params{param}).mean(:,5))) ,...
        ~isnan(Fear.OutPutData.Fear.(Params{param}).mean(:,6)));
    
    if or(param==8 , param==5)
        P_QW(:,param) = [nanmedian(log10(MeanVal_QW.(Params{param})(ind))) nanmedian(log10(Fear.OutPutData.Fear.(Params{param}).mean(ind,5)))...
            nanmedian(log10(Fear.OutPutData.Fear.(Params{param}).mean(ind,6)))];
    elseif param==1
        P_QW(:,param) = [nanmedian(Freq_Max_QW(ind)) nanmedian(Freq_Max1(ind)) nanmedian(Freq_Max2(ind))];
    else
        ind = and(and(~isnan(Freq_Max_QW) , ~isnan(Freq_Max1)) , ~isnan(Freq_Max2));
        
        P_QW(:,param) = [nanmedian(MeanVal_QW.(Params{param})(ind)) nanmedian(Fear.OutPutData.Fear.(Params{param}).mean(ind,5))...
            nanmedian(Fear.OutPutData.Fear.(Params{param}).mean(ind,6))];
    end
end
save('/media/nas7/ProjetEmbReact/DataEmbReact/SpiderMap_OtherStates.mat','P_QW','-append')



load('/media/nas7/ProjetEmbReact/DataEmbReact/SpiderMap_OtherStates.mat','P_QW')
clear s

figure
s = spider_plot_class(P_QW([2 3 1],:));
s.AxesLabels =  {'','','','','','','',''};
s.LegendLabels = {'Freezing shock', 'Freezing safe','Quiet wake'};
s.AxesInterval = 2;
s.FillOption = { 'on','on', 'on'};
s.Color = [1 .5 .5; .5 .5 1 ; .5 .5 .5];
s.LegendHandle.Location = 'northeastoutside';
s.AxesLabelsEdge = 'none';
% s.AxesLimits(:,:) = [2.21 9.5 63.5 6.2 .1 .1 1.09 1.56 ; 5.12 11.84 68.6 12 .24 .308 3 2.09];
s.MarkerSize=[1e2 1e2 1e2];
s.AxesTickLabels={''};


DATA_QW(1,:) = Freq_Max_QW;

for param=2:8
    DATA_QW(param,:) = MeanVal_QW.(Params{param})';
end
save('/media/nas7/ProjetEmbReact/DataEmbReact/NewData/CondPost_corrected.mat','DATA_QW','-append')

MeanAcc_Before{1} = [];
for mouse=1:length(Mouse)
    try, MeanDur{1}(mouse) = nanmean(DurationEpoch(Sleep.FreezeAccEpoch_Wake{mouse})/1e4); end
    try
        [M{mouse},T] = PlotRipRaw(Sleep.OutPutData.sleep_pre.accelero.tsd{mouse,1}, Start(Sleep.FreezeAccEpoch_Wake{mouse})/1e4, 1e4, 0, 0, 0);
        MeanAcc_Before{1}(mouse,:) = M{mouse}(:,2); 
    end
end
for i=1
    MeanDur{i}(MeanDur{i}==0) = NaN; 
    MeanAcc_Before{i}(MeanAcc_Before{i}==0) = NaN; 
    MeanAcc_Before{i}(37:end,:) = MeanAcc_Before{i}(37:end,:)./1.7;
end
MeanDur{1}(26) = NaN;
ind = and(and(~isnan(MeanDur{1}) , ~isnan(MeanDur{2})) , ~isnan(MeanDur{3}));
MeanAcc_Before{1}(27,:) = NaN;


figure
subplot(131)
MakeSpreadAndBoxPlot3_SB({MeanDur{1}(ind) MeanDur{2}(ind) MeanDur{3}(ind)},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('mean duration (s)')
makepretty_BM2

subplot(1,3,2:3)
Data_to_use = MeanAcc_Before{1};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-10,10,1001) , runmean(Mean_All_Sp,50) , runmean(Conf_Inter,50) ,'-k',1); hold on;
color= [.3 .3 .3]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
Data_to_use = MeanAcc_Before{2};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-10,10,1001) , runmean(Mean_All_Sp,50) , runmean(Conf_Inter,50) ,'-k',1); hold on;
color= [1 .5 .5]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
Data_to_use = MeanAcc_Before{3};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-10,10,1001) , runmean(Mean_All_Sp,50) , runmean(Conf_Inter,50) ,'-k',1); hold on;
color= [.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
makepretty
xlabel('time (s)'), ylabel('Motion (a.u.)')
f=get(gca,'Children'); legend([f([9 5 1])],'Quiet wake','Shock','Safe');



%% Active
Legends = {'Active','Shock','Safe'};

for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    try
        for param=1:8
            MeanVal_Act.(Params{param})(mouse) = nanmean(Data(Restrict(Fear.OutPutData.Fear.(Params{param}).tsd{mouse,4} , Fear.Moving{mouse})));
        end
        for param=1:3
            MeanVal_Act.(Params2{param})(mouse) = nanmean(Data(Restrict(Fear.OutPutData.Fear.(Params2{param}).tsd{mouse,4} , Fear.Moving{mouse})));
        end
    end
    disp(Mouse_names{mouse})
end
for param=1:8
    MeanVal_Act.(Params{param})(MeanVal_Act.(Params{param})==0)=NaN;
    MeanVal_Act.(Params{param}) = MeanVal_Act.(Params{param})';
end
for param=1:3
    MeanVal_Act.(Params2{param})(MeanVal_Act.(Params2{param})==0)=NaN;
    MeanVal_Act.(Params2{param}) = MeanVal_Act.(Params2{param})';
end
MeanVal_Act.(Params2{1})([21 23 25])=NaN;
MeanVal_Act.ob_gamma_power=MeanVal_Act.ob_gamma_power';



figure
[~ , ~ , Freq_Max_Act] = Plot_MeanSpectrumForMice_BM(Fear.OB_Low_Moving);
xlabel('Frequency (Hz)'); ylabel('Power (a.u.)'); xlim([0 15]); ylim([0 1])
makepretty
v1=vline(nanmean(4.73)); set(v1,'LineStyle','--','Color',[1 .5 .5]); v2=vline(nanmean(3.053)); set(v2,'LineStyle','--','Color',[.5 .5 1])
xticks([0:2:14])
axis square

figure
load('/media/nas6/ProjetEmbReact/Mouse1226/20210826/ProjectEmbReact_M11226_20210826_ExtinctionBlockedSafe_PostDrug/Ext1/B_Low_Spectrum.mat')
[~ , ~ , Freq_Max_Act] = Plot_MeanSpectrumForMice_BM(Spectro{3}.*Fear.OB_Low_Moving);
close

figure
for param = 1:3
    subplot(1,3,param)
    
    ind = and(and(~isnan(MeanVal_Act.(Params2{param})) , ~isnan(Fear.OutPutData.Fear.(Params2{param}).mean(:,6))) ,...
        ~isnan(Fear.OutPutData.Fear.(Params2{param}).mean(:,5)));
    
    MakeSpreadAndBoxPlot3_SB({MeanVal_Act.(Params2{param})(ind) Fear.OutPutData.Fear.(Params2{param}).mean(ind,6) Fear.OutPutData.Fear.(Params2{param}).mean(ind,5)},Cols,X,Legends,'showpoints',0,'paired',1);
    
    if param==1
        ylabel('Motion (a.u.)')
    elseif param==2
        ylabel('EMG power (a.u.)')
    elseif param==3
        ylabel('OB gamma power (a.u.)')
    end
    makepretty_BM2
    set(gca,'YScale','log')
end




figure
for param = 1:8
    subplot(1,8,param)
    if param>1
        
        ind = and(and(~isnan(MeanVal_Act.(Params{param})) , ~isnan(Fear.OutPutData.Fear.(Params{param}).mean(:,5))) , ~isnan(Fear.OutPutData.Fear.(Params{param}).mean(:,6)));
        MakeSpreadAndBoxPlot3_SB({MeanVal_Act.(Params{param})(ind) Fear.OutPutData.Fear.(Params{param}).mean(ind,6)...
            Fear.OutPutData.Fear.(Params{param}).mean(ind,5)},Cols,X,Legends,'showpoints',0,'paired',1);
        
    else
        
        ind = and(and(~isnan(Freq_Max_Act) , ~isnan(Freq_Max1)) , ~isnan(Freq_Max2));
        MakeSpreadAndBoxPlot3_SB({Freq_Max_Act(ind) Freq_Max2(ind) Freq_Max1(ind)},Cols,X,Legends,'showpoints',0,'paired',1);
        
    end
    if param==1
        ylabel('Breathing (Hz)')
    elseif param==2
        ylabel('Heart rate (Hz)')
    elseif param==3
        ylabel('Heart rate variability (a.u.)')
    elseif param==4
        ylabel('OB gamma frequency (Hz)')
    elseif param==5
        ylabel('OB gamma power (a.u.)')
    elseif param==6
        ylabel('Ripples occurence (#/s)')
    elseif param==7
        ylabel('HPC theta frequency (Hz)')
    elseif param==8
        ylabel('HPC theta power (log scale)')
        set(gca,'YScale','log')
    end
    makepretty_BM2
end


for param=[1 2 4 7 3 6 5 8]
    ind = and(and(~isnan(MeanVal_Act.(Params{param})) , ~isnan(Fear.OutPutData.Fear.(Params{param}).mean(:,5))) ,...
        ~isnan(Fear.OutPutData.Fear.(Params{param}).mean(:,6)));
    
    if or(param==8 , param==5)
        P_Act(:,param) = [nanmedian(log10(MeanVal_Act.(Params{param})(ind))) nanmedian(log10(Fear.OutPutData.Fear.(Params{param}).mean(ind,5)))...
            nanmedian(log10(Fear.OutPutData.Fear.(Params{param}).mean(ind,6)))];
    elseif param==1
        P_Act(:,param) = [nanmedian(Freq_Max_Act(ind)) nanmedian(Freq_Max1(ind)) nanmedian(Freq_Max2(ind))];
    else
        ind = and(and(~isnan(Freq_Max_Act) , ~isnan(Freq_Max1)) , ~isnan(Freq_Max2));
        
        P_Act(:,param) = [nanmedian(MeanVal_Act.(Params{param})(ind)) nanmedian(Fear.OutPutData.Fear.(Params{param}).mean(ind,5))...
            nanmedian(Fear.OutPutData.Fear.(Params{param}).mean(ind,6))];
    end
end
save('/media/nas7/ProjetEmbReact/DataEmbReact/SpiderMap_OtherStates.mat','P_Act','-append')



load('/media/nas7/ProjetEmbReact/DataEmbReact/SpiderMap_OtherStates.mat','P_Act')
clear s

figure
s = spider_plot_class(P_Act([2 3 1],:));
s.AxesLabels =  {'','','','','','','',''};
s.LegendLabels = {'Freezing shock', 'Freezing safe','Quiet wake'};
s.AxesInterval = 2;
s.FillOption = { 'on','on', 'on'};
s.Color = [1 .5 .5; .5 .5 1 ; .5 .5 .5];
s.LegendHandle.Location = 'northeastoutside';
s.AxesLabelsEdge = 'none';
% s.AxesLimits(:,:) = [2.21 9.5 63.5 6.2 .1 .1 1.09 1.56 ; 5.12 11.84 68.6 12 .24 .308 3 2.09];
s.MarkerSize=[1e2 1e2 1e2];
s.AxesTickLabels={''};


DATA_Act(1,:) = Freq_Max_Act;

for param=2:8
    DATA_Act(param,:) = MeanVal_Act.(Params{param})';
end
save('/media/nas7/ProjetEmbReact/DataEmbReact/NewData/CondPost_corrected.mat','DATA_Act','-append')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Freezing is not sleep
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



Mouse=[1376 1377 1385 1386 1502 1530 1532];

Session_type={'Fear','sleep_pre'};
for sess=1:length(Session_type) % generate all data required for analyses
        [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('drugs',Mouse,lower(Session_type{sess}),...
            'emg_neck');
end

for mouse=1:length(Mouse)
    try, h=histogram(log10(Data(OutPutData.Fear.emg_neck.tsd{mouse,5})),'BinLimits',[3 7],'NumBins',100); hold on
        HistData_EMG_Shock(mouse,:) = h.Values./sum(h.Values); end
    try, h=histogram(log10(Data(OutPutData.Fear.emg_neck.tsd{mouse,6})),'BinLimits',[3 7],'NumBins',100); hold on
        HistData_EMG_Safe(mouse,:) = h.Values./sum(h.Values); end
    try, h=histogram(log10(Data(OutPutData.sleep_pre.emg_neck.tsd{mouse,2})),'BinLimits',[3 7],'NumBins',100);
        HistData_EMG_Wake(mouse,:) = h.Values./sum(h.Values); end
    try, h=histogram(log10(Data(OutPutData.sleep_pre.emg_neck.tsd{mouse,3})),'BinLimits',[3 7],'NumBins',100);
        HistData_EMG_Sleep(mouse,:) = h.Values./sum(h.Values); end
    
    
    p = percentile(log10(Data(OutPutData.sleep_pre.emg_neck.tsd{mouse,3})),90);
    FzShock_prop(mouse) = sum(log10(Data(OutPutData.Fear.emg_neck.tsd{mouse,5}))<p)./length(OutPutData.Fear.emg_neck.tsd{mouse,5});
    FzSafe_prop(mouse) = sum(log10(Data(OutPutData.Fear.emg_neck.tsd{mouse,6}))<p)./length(OutPutData.Fear.emg_neck.tsd{mouse,6});
    Wake_prop(mouse) = sum(log10(Data(OutPutData.sleep_pre.emg_neck.tsd{mouse,2}))<p)./length(OutPutData.sleep_pre.emg_neck.tsd{mouse,2});
    for i=1:4
        if i==1; X=HistData_EMG_Shock(mouse,:);
        elseif i==2; X=HistData_EMG_Safe(mouse,:);
        elseif i==3; X=HistData_EMG_Wake(mouse,:);
        elseif i==4; X=HistData_EMG_Sleep(mouse,:); end
        for j=1:4
            if j==1; Y=HistData_EMG_Shock(mouse,:);
            elseif j==2; Y=HistData_EMG_Safe(mouse,:);
            elseif j==3; Y=HistData_EMG_Wake(mouse,:);
            elseif j==4; Y=HistData_EMG_Sleep(mouse,:); end
            
            Confus_Matrix(mouse,i,j) = kldiv_BM(X , Y);
        end
    end
end
Confus_Matrix_all = squeeze(nanmedian(Confus_Matrix));

Cols = {[1 .5 .5],[.5 .5 1],[.7 .7 .7]};
X = [1:3];
Legends = {'Fz shock','Fz safe','Wake homecage'};

figure
subplot(131)
plot(linspace(3,7,100) , runmean(HistData_EMG_Shock(2,:) , 5) , 'Color', [1 .5 .5] , 'LineWidth' , 2), hold on
plot(linspace(3,7,100) , runmean(HistData_EMG_Safe(2,:) , 5) , 'Color', [.5 .5 1] , 'LineWidth' , 2)
plot(linspace(3,7,100) , runmean(HistData_EMG_Wake(2,:) , 5) , 'Color', [.7 .7 .7] , 'LineWidth' , 2)
plot(linspace(3,7,100) , runmean(HistData_EMG_Sleep(2,:) , 5) , 'Color', [.3 .3 .3] , 'LineWidth' , 2)
xlabel('EMG power (log scale)'), ylabel('PDF')
legend('Fz shock','Fz safe','Wake homecage','Sleep homecage')
makepretty
axis square
xlim([3 7])

subplot(132)
imagesc(Confus_Matrix_all)
xticks([1:4]), yticks([1:4])
xticklabels({'Fz shock','Fz safe','Wake homecage','Sleep homecage'}), xtickangle(45)
yticklabels({'Fz shock','Fz safe','Wake homecage','Sleep homecage'})
axis square
caxis([0 2])
c=colorbar; c.Ticks=[0 2];
c.Label.String='KLD (nats)';
colormap jet
makepretty
axis xy

subplot(133)
MakeSpreadAndBoxPlot3_SB({FzShock_prop FzSafe_prop Wake_prop},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('proportion under 95th sleep percentile')
makepretty_BM2
ylim([0 1])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PCA stuff
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('/media/nas7/ProjetEmbReact/DataEmbReact/NewData/CondPost_corrected.mat','PC_values_safe', 'PC_values_shock', 'mu', 'sigma', 'eigen_vector')


%%
load('/media/nas7/ProjetEmbReact/DataEmbReact/NewData/CondPost_corrected.mat','DATA_sleep')

clear DATA3
DATA3 = ((DATA_sleep-mu')./sigma')';

for mouse=1:size(DATA3,1)
    ind = ~isnan(DATA3(mouse,:));
    for pc=1:size(eigen_vector,2)
        try
%             PC_values_sleep{pc}(mouse) = eigen_vector(ind,pc)'*DATA3(mouse,ind)';
            PC_values_sleep{pc}(mouse) = eigen_vector(:,pc)'*DATA3(mouse,:)';
        end
    end
end


%%
load('/media/nas7/ProjetEmbReact/DataEmbReact/NewData/CondPost_corrected.mat','DATA_QW')

clear DATA3
DATA3 = ((DATA_QW-mu')./sigma')';

for mouse=1:size(DATA3,1)
    ind = ~isnan(DATA3(mouse,:));
    for pc=1:size(eigen_vector,2)
        try
%             PC_values_sleep{pc}(mouse) = eigen_vector(ind,pc)'*DATA3(mouse,ind)';
            PC_values_QW{pc}(mouse) = eigen_vector(:,pc)'*DATA3(mouse,:)';
        end
    end
end


%%
load('/media/nas7/ProjetEmbReact/DataEmbReact/NewData/CondPost_corrected.mat','DATA_Act')

clear DATA3
DATA3 = ((DATA_Act-mu')./sigma')';

for mouse=1:size(DATA3,1)
    ind = ~isnan(DATA3(mouse,:));
    for pc=1:size(eigen_vector,2)
        try
%             PC_values_sleep{pc}(mouse) = eigen_vector(ind,pc)'*DATA3(mouse,ind)';
            PC_values_Act{pc}(mouse) = eigen_vector(:,pc)'*DATA3(mouse,:)';
        end
    end
end

%%
Cols = {[1 .5 .5],[.5 .5 1],[.5 .8 .5],[.7 .7 .4],[.8 .5 0]};
ind = and(and(~isnan(PC_values_Act{1}) , ~isnan(PC_values_QW{1})) , ~isnan(PC_values_sleep{1}));


figure
subplot(121)
plot(PC_values_shock{1}(ind) , PC_values_shock{2}(ind),'.','MarkerSize',10,'Color',Cols{1})
hold on
plot(PC_values_sleep{1}(ind) , PC_values_sleep{2}(ind),'.','MarkerSize',10,'Color',Cols{5})
plot(PC_values_safe{1}(ind) , PC_values_safe{2}(ind),'.','MarkerSize',10,'Color',Cols{2})
plot(PC_values_QW{1}(ind) , PC_values_QW{2}(ind),'.','MarkerSize',10,'Color',Cols{4})
plot(PC_values_Act{1}(ind) , PC_values_Act{2}(ind),'.','MarkerSize',10,'Color',Cols{3})
axis square
xlabel('PC1 value'), ylabel('PC2 value')
grid on
Bar_shock = [nanmedian(PC_values_shock{1}(ind)) nanmedian(PC_values_shock{2}(ind))];
Bar_safe = [nanmedian(PC_values_safe{1}(ind)) nanmedian(PC_values_safe{2}(ind))];
Bar_sleep = [nanmedian(PC_values_sleep{1}) nanmedian(PC_values_sleep{2})];
Bar_QW = [nanmedian(PC_values_QW{1}(ind)) nanmedian(PC_values_QW{2}(ind))];
Bar_Act = [nanmedian(PC_values_Act{1}(ind)) nanmedian(PC_values_Act{2}(ind))];
for mouse=find(ind)
    line([Bar_shock(1) PC_values_shock{1}(mouse)],[Bar_shock(2) PC_values_shock{2}(mouse)],'LineStyle','--','Color',Cols{1})
    line([Bar_safe(1) PC_values_safe{1}(mouse)],[Bar_safe(2) PC_values_safe{2}(mouse)],'LineStyle','--','Color',Cols{2})
    line([Bar_Act(1) PC_values_Act{1}(mouse)],[Bar_Act(2) PC_values_Act{2}(mouse)],'LineStyle','--','Color',Cols{3})
    line([Bar_QW(1) PC_values_QW{1}(mouse)],[Bar_QW(2) PC_values_QW{2}(mouse)],'LineStyle','--','Color',Cols{4})
    line([Bar_sleep(1) PC_values_sleep{1}(mouse)],[Bar_sleep(2) PC_values_sleep{2}(mouse)],'LineStyle','--','Color',Cols{5})
end
plot(Bar_shock(1),Bar_shock(2),'.','MarkerSize',50,'Color',Cols{1})
plot(Bar_safe(1),Bar_safe(2),'.','MarkerSize',50,'Color',Cols{2})
plot(Bar_Act(1),Bar_Act(2),'.','MarkerSize',50,'Color',Cols{3})
plot(Bar_QW(1),Bar_QW(2),'.','MarkerSize',50,'Color',Cols{4})
plot(Bar_sleep(1),Bar_sleep(2),'.','MarkerSize',50,'Color',Cols{5})


subplot(122)
plot(PC_values_shock{3}(ind) , PC_values_shock{4}(ind),'.','MarkerSize',10,'Color',Cols{1})
hold on
plot(PC_values_safe{3}(ind) , PC_values_safe{4}(ind),'.','MarkerSize',10,'Color',Cols{2})
plot(PC_values_sleep{3}(ind) , PC_values_sleep{4}(ind),'.','MarkerSize',10,'Color',Cols{5})
plot(PC_values_QW{3}(ind) , PC_values_QW{4}(ind),'.','MarkerSize',10,'Color',Cols{4})
plot(PC_values_Act{3}(ind) , PC_values_Act{4}(ind),'.','MarkerSize',10,'Color',Cols{3})
axis square
xlabel('PC3 value'), ylabel('PC4 value')
grid on
Bar_shock = [nanmedian(PC_values_shock{3}(ind)) nanmedian(PC_values_shock{4}(ind))];
Bar_safe = [nanmedian(PC_values_safe{3}(ind)) nanmedian(PC_values_safe{4}(ind))];
Bar_sleep = [nanmedian(PC_values_sleep{3}) nanmedian(PC_values_sleep{4}(ind))];
Bar_QW = [nanmedian(PC_values_QW{3}(ind)) nanmedian(PC_values_QW{4}(ind))];
Bar_Act = [nanmedian(PC_values_Act{3}(ind)) nanmedian(PC_values_Act{4}(ind))];
for mouse=find(ind)
    line([Bar_shock(1) PC_values_shock{3}(mouse)],[Bar_shock(2) PC_values_shock{4}(mouse)],'LineStyle','--','Color',Cols{1})
    line([Bar_safe(1) PC_values_safe{3}(mouse)],[Bar_safe(2) PC_values_safe{4}(mouse)],'LineStyle','--','Color',Cols{2})
    line([Bar_Act(1) PC_values_Act{3}(mouse)],[Bar_Act(2) PC_values_Act{4}(mouse)],'LineStyle','--','Color',Cols{3})
    line([Bar_QW(1) PC_values_QW{3}(mouse)],[Bar_QW(2) PC_values_QW{4}(mouse)],'LineStyle','--','Color',Cols{4})
    line([Bar_sleep(1) PC_values_sleep{3}(mouse)],[Bar_sleep(2) PC_values_sleep{4}(mouse)],'LineStyle','--','Color',Cols{5})
end
plot(Bar_shock(1),Bar_shock(2),'.','MarkerSize',50,'Color',Cols{1})
plot(Bar_safe(1),Bar_safe(2),'.','MarkerSize',50,'Color',Cols{2})
plot(Bar_Act(1),Bar_Act(2),'.','MarkerSize',50,'Color',Cols{3})
plot(Bar_QW(1),Bar_QW(2),'.','MarkerSize',50,'Color',Cols{4})
plot(Bar_sleep(1),Bar_sleep(2),'.','MarkerSize',50,'Color',Cols{5})


f=get(gca,'Children'); legend([f([5 4 3 2 1])],'Shock','Safe','Sleep','Quiet wake','Active');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Freezing is not quiet wakefulness
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all, close all
Dir = PathForExperimentsERC('UMazePAG');
Mouse = [905,906,911,994,1161,1162,1168,1182,1186,1230,1239];
Session_type = {'Habituation','sleep_pre','Fear'};
mouse = 1;

for ff = 1:length(Dir.name)
    if ismember(eval(Dir.name{ff}(6:end)),Mouse)
        cd(Dir.path{ff}{1})
        disp(Dir.path{ff}{1})
        
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        clear MovAcctsd tRipples Wake SessionEpoch
        
        load('behavResources.mat', 'MovAcctsd', 'SessionEpoch')
        NewMovAcctsd = tsd(Range(MovAcctsd) , runmean(Data(MovAcctsd),30));
        load('SWR.mat')
        try
            load('SleepScoring_OBGamma.mat', 'Wake' , 'Sleep')
        catch
            load('SleepScoring_Accelero.mat', 'Wake' , 'Sleep')
        end
        if or(mouse<7 , mouse>9)
            load('H_VHigh_Spectrum.mat')
            HPC_VHigh_Sptsd = tsd(Spectro{2}*1e4 , Spectro{1});
            HPC_VHigh_Sptsd = CleanSpectro(HPC_VHigh_Sptsd , Spectro{3} , 8);
        else
            HPC_VHigh_Sptsd = tsd([],[]);
        end
        
        
        try
            ExtEpoch.(Mouse_names{mouse}) =  SessionEpoch.Ext;
        catch
            try
                ExtEpoch.(Mouse_names{mouse}) =  SessionEpoch.Extinction;
            catch
                try
                    ExtEpoch.(Mouse_names{mouse}) = SessionEpoch.ExploAfter;
                catch
                    ExtEpoch.(Mouse_names{mouse}) = intervalSet([],[]);
                end
            end
        end
        CondEpoch.(Mouse_names{mouse}) =  or(SessionEpoch.Cond1,or(SessionEpoch.Cond2,or(SessionEpoch.Cond3,SessionEpoch.Cond4)));
        FearEpoch.(Mouse_names{mouse}) =  or(CondEpoch.(Mouse_names{mouse}) , ExtEpoch.(Mouse_names{mouse}));
        
        try
            HabEpoch.(Mouse_names{mouse}) = or(SessionEpoch.Hab1 , SessionEpoch.Hab2);
        catch
            HabEpoch.(Mouse_names{mouse}) = SessionEpoch.Hab;
        end
        
        Sleep1 = dropShortIntervals(and(Sleep , SessionEpoch.PreSleep),30e4);
        Sleep_Beginning = Start(Sleep1) ;
        Wake_Before_Sleep_Epoch = intervalSet(0 , Sleep_Beginning(1));
        
        for sess=1:3
            if sess==1
                Epoch_to_use = HabEpoch.(Mouse_names{mouse});
            elseif sess==2
                Epoch_to_use = Wake_Before_Sleep_Epoch;
            elseif sess==3
                Epoch_to_use = FearEpoch.(Mouse_names{mouse});
            end
            
            ControlDuration(mouse,sess) = sum(DurationEpoch(and(Epoch_to_use , Wake)));
            
            for thr=1:10
                
                FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = thresholdIntervals(Restrict(NewMovAcctsd , Epoch_to_use),1.7e7*thr,'Direction','Below');
                FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = mergeCloseIntervals(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}),0.3*1E4);
                FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = dropShortIntervals(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}),2*1E4);
                FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , Wake);
                
                FreezeAll_Prop{thr,sess}(mouse) = sum(DurationEpoch(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})))/ControlDuration(mouse,sess);
                RipplesOccurence{thr,sess}(mouse) = length(Restrict(tRipples , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})))./(sum(DurationEpoch(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})))/1e4);
                VHigh_Sp{thr,sess}(mouse,:) = nanmean(Data(Restrict(HPC_VHigh_Sptsd , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}))));
            end
        end
        mouse=mouse+1;
    end
end



for sess=1:3
    for i=1:10
        FreezeProp.(Session_type{sess}){i} = FreezeAll_Prop{i,sess};
        FreezeProp.(Session_type{sess}){i}(FreezeProp.(Session_type{sess}){i}==0) = NaN;
        RipOccur.(Session_type{sess}){i} = RipplesOccurence{i,sess};
        RipOccur.(Session_type{sess}){i}(RipOccur.(Session_type{sess}){i}==0) = NaN;
        
        RipTot.(Session_type{sess}){i} = FreezeProp.(Session_type{sess}){i}.*RipOccur.(Session_type{sess}){i};
        
        Cols{i} = [1-i/10 .5 i/10];
        Legends{i} = ['thr ' num2str(i)];
    end
end
X = 1:10;


figure
for sess=1:3
    subplot(3,3,1+(sess-1)*3)
    MakeSpreadAndBoxPlot3_SB(FreezeProp.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0,'showsigstar','none');
    ylabel('proportion of time under threshold')
    ylim([0 1])
    
    subplot(3,3,2+(sess-1)*3)
    MakeSpreadAndBoxPlot3_SB(RipOccur.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0,'showsigstar','none');
    ylabel('rip occurence')
    ylim([0 1.4])
    
    subplot(3,3,3+(sess-1)*3)
    MakeSpreadAndBoxPlot3_SB(RipTot.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0,'showsigstar','none');
    ylabel('rip number')
    ylim([0 .35])
end


figure
for sess=1:3
    for i=1:10
        
        subplot(3,10,i+(sess-1)*10)
        Plot_MeanSpectrumForMice_BM(Spectro{3}.*VHigh_Sp{thr,sess})
        xlim([10 250]), ylim([0 3])
    end
end



figure
plot(Spectro{3} , VHigh_Sp{1,3}')






















