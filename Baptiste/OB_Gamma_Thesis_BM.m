
%% OB gamma
% put after stim epoch at 1s

Session_type={'Cond'};
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','RipSham','RipInhib','PAG','All_eyelid','All_saline','Elisa','Saline','RipInhib2','Diazepam','ChronicBUS','AcuteBUS','RipControl','RipInhib1','RipControl1','RipInhibPaired','RipControlPaired','Sal_Maze1_1stMaze','Sal_Maze4_1stMaze','DZP_Maze1_1stMaze','DZP_Maze4_1stMaze'};
Group=[22];

for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for sess=1:length(Session_type)
        [OutPutData3.(Drug_Group{group}).(Session_type{sess}) , Epoch1.(Drug_Group{group}).(Session_type{sess}) , NameEpoch] = ...
            MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),...
            'accelero','ob_gamma_power','ob_gamma_ratio','ob_gamma_freq','ob_high');
    end
end




wdw_size = 3e4;
GetAllSalineSessions_BM

for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for sess=1:length(Session_type)
        Sessions_List_ForLoop_BM
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            TotEpoch.(Session_type{sess}).(Mouse_names{mouse}) = intervalSet(0,max(Range(OutPutData3.RipControlPaired.Cond.accelero.tsd{mouse,1})));
            BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','blockedepoch');
            UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) = TotEpoch.(Session_type{sess}).(Mouse_names{mouse})-BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse});
        end
    end
end

clear Acc_Around_Stim_all
clear Gamma_Around_Stim_all
clear GammaRatio_Around_Stim_all

for mouse=1:length(Mouse)
    try
        clear Stim
        %         Stim = and(Epoch1.RipControlPaired.Cond{mouse,2} , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}));
        Stim = Epoch1.RipControlPaired.Cond{mouse,2};
        
        % OB gamma power
        [M{mouse},T] = PlotRipRaw(OutPutData3.RipControlPaired.Cond.ob_gamma_power.tsd{mouse,1}, Start(Stim)/1e4,...
            wdw_size , 1, 0, 0);
        
        Gamma_Around_Stim_all(mouse,:) = M{mouse}(:,2);
        
        % accelero
        [M2{mouse},T2] = PlotRipRaw(OutPutData3.RipControlPaired.Cond.accelero.tsd{mouse,1}, Start(Stim)/1e4,...
            wdw_size, 0, 0, 0);
        if length(M2{mouse})==3001
            Acc_Around_Stim_all(mouse,:) = M2{mouse}(:,2);
        end
        
        % OB gamma ratio
        [M3{mouse},T3] = PlotRipRaw(OutPutData3.RipControlPaired.Cond.ob_gamma_ratio.tsd{mouse,1}, Start(Stim)/1e4,...
            wdw_size, 0, 0, 0);
        
        GammaRatio_Around_Stim_all(mouse,:) = M3{mouse}(:,2);
    end
    disp(mouse)
end
Gamma_Around_Stim_all(Gamma_Around_Stim_all==0) = NaN;
Acc_Around_Stim_all(Acc_Around_Stim_all==0) = NaN;
GammaRatio_Around_Stim_all(GammaRatio_Around_Stim_all==0) = NaN;
Acc_Around_Stim_all([14:end],:)=Acc_Around_Stim_all([14:end],:)./1.7;

figure
subplot(121)
Data_to_use = movmean(zscore(Acc_Around_Stim_all') , round(length(Acc_Around_Stim_all)/100))';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(-wdw_size/1e3 , wdw_size/1e3 , length(Mean_All_Sp)) , Mean_All_Sp,Conf_Inter,'-k',1); hold on;
xlim([-20 30])
xlabel('time (s)'), ylabel('Motion (a.u.)')

subplot(122)
Data_to_use = movmean(zscore(Gamma_Around_Stim_all(:,1:6e3)') , round(length(Gamma_Around_Stim_all)/30))';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(-wdw_size/1e3 , 0 , 6e3) , runmean(Mean_All_Sp,round(length(Mean_All_Sp)/100)) , runmean(Conf_Inter,round(length(Mean_All_Sp)/100)),'-k',1); hold on;
Data_to_use = movmean(zscore(Gamma_Around_Stim_all(:,7e3:12e3)') , round(length(Gamma_Around_Stim_all)/30))';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(5 , wdw_size/1e3 , 5.001e3) , runmean(Mean_All_Sp,round(length(Mean_All_Sp)/100)) , runmean(Conf_Inter,round(length(Mean_All_Sp)/100)) ,'-k',1); hold on;
xlim([-10 30])
a=vline(2.5,'-'); a.LineWidth=20; a.Color=[1 0 0];
xlabel('time (s)'), ylabel('OB gamma power (a.u.)')


figure
Data_to_use = movmean(zscore(Gamma_Around_Stim_all(:,1:round(length(Gamma_Around_Stim_all)/2))') , round(length(Gamma_Around_Stim_all)/30))';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(-wdw_size/1e3 , 0 , round(length(Gamma_Around_Stim_all)/2)) , Mean_All_Sp,Conf_Inter,'-k',1); hold on;
Data_to_use = movmean(zscore(Gamma_Around_Stim_all(:,round(length(Gamma_Around_Stim_all)/1.8):end)') , round(length(Gamma_Around_Stim_all)/30))';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(5 , wdw_size/1e3 , length(Data_to_use)) , Mean_All_Sp,Conf_Inter,'-k',1); hold on;
xlim([-10 20])
a=vline(0,'-'); a.LineWidth=100; a.Color=[1 0 0];


figure
for i=1:5
    
    subplot(1,5,i)
    Data_to_use = movmean(zscore(GammaRatio_Around_Stim_all(IDX==i,1:6e3)') , round(length(GammaRatio_Around_Stim_all)/30))';
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
    shadedErrorBar(linspace(-wdw_size/1e3 , 0 , 6e3) , runmean(Mean_All_Sp,round(length(Mean_All_Sp)/100)) , runmean(Conf_Inter,round(length(Mean_All_Sp)/100)),'-k',1); hold on;
    Data_to_use = movmean(zscore(GammaRatio_Around_Stim_all(IDX==i,7e3:12e3)') , round(length(GammaRatio_Around_Stim_all)/30))';
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
    shadedErrorBar(linspace(5 , wdw_size/1e3 , 5.001e3) , runmean(Mean_All_Sp,round(length(Mean_All_Sp)/100)) , runmean(Conf_Inter,round(length(Mean_All_Sp)/100)) ,'-k',1); hold on;
    xlim([-10 30]), ylim([-.8 .6])
    a=vline(2.5,'-'); a.LineWidth=20; a.Color=[1 0 0];
    xlabel('time (s)'), ylabel('OB gamma power (a.u.)')
    
end

figure
for i=1:5
    
    subplot(1,5,i)
    Data_to_use = movmean(zscore(GammaRatio_Around_Stim_all(IDX==i,1:6e3)') , round(length(GammaRatio_Around_Stim_all)/30))';
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
    shadedErrorBar(linspace(-wdw_size/1e3 , 0 , 6e3) , runmean(Mean_All_Sp,round(length(Mean_All_Sp)/100)) , runmean(Conf_Inter,round(length(Mean_All_Sp)/100)),'-k',1); hold on;
    Data_to_use = movmean(zscore(GammaRatio_Around_Stim_all(IDX==i,7e3:12e3)') , round(length(GammaRatio_Around_Stim_all)/30))';
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
    shadedErrorBar(linspace(5 , wdw_size/1e3 , 5.001e3) , runmean(Mean_All_Sp,round(length(Mean_All_Sp)/100)) , runmean(Conf_Inter,round(length(Mean_All_Sp)/100)) ,'-k',1); hold on;
    xlim([-10 30]), ylim([-.8 .6])
    a=vline(2.5,'-'); a.LineWidth=20; a.Color=[1 0 0];
    xlabel('time (s)'), ylabel('OB gamma power (a.u.)')
    
end

TSD = OutPutData3.RipControlPaired.Cond.ob_gamma_power.tsd{mouse,1};
TSD = OutPutData3.RipControlPaired.Cond.ob_gamma_ratio.tsd{mouse,1};
figure
plot(Range(TSD,'s') , Data(TSD)), vline(Start(Stim)/1e4,'--r')


figure
plot(Gamma_Around_Stim_all')

plot(Acc_Around_Stim_all')

plot(GammaRatio_Around_Stim_all')




[M{mouse},T] = PlotRipRaw(OutPutData3.RipControlPaired.Cond.ob_gamma_power.tsd{mouse,1}, Start(Epoch1.RipControlPaired.Cond{mouse,2})/1e4,...
        2000, 0, 1, 0);


Cols = {[.3, .745, .93],[.85, .325, .098],[.85, .325, .098]};
X = 1:3;
Legends = {'Post shock','Fz shock','Fz safe'};


figure
MakeSpreadAndBoxPlot3_SB({OutPutData3.RipControlPaired.Cond.ob_gamma_power.mean(:,2) OutPutData3.RipControlPaired.Cond.ob_gamma_power.mean(:,5)...
   OutPutData3.RipControlPaired.Cond.ob_gamma_power.mean(:,6) },Cols,X,Legends,'showpoints',0,'paired',1);

figure
MakeSpreadAndBoxPlot3_SB({OutPutData3.RipControlPaired.Cond.ob_gamma_freq.mean(:,2) OutPutData3.RipControlPaired.Cond.ob_gamma_freq.mean(:,5)...
   OutPutData3.RipControlPaired.Cond.ob_gamma_freq.mean(:,6) },Cols,X,Legends,'showpoints',0,'paired',1);






figure
plot(Spectro{3} , zscore((Spectro{3}'.*(squeeze(OutPutData3.RipControlPaired.Cond.ob_high.mean(:,2,:))'))))

figure
[h , MaxPowerValues , Freq_Max] = Plot_MeanSpectrumForMice_BM(runmean(zscore((Spectro{3}'.*(squeeze(OutPutData3.RipControlPaired.Cond.ob_high.mean(:,2,:))'))),5)' , 'threshold' , 10 , 'Color' , [.3 .3 .3])
[h , MaxPowerValues , Freq_Max] = Plot_MeanSpectrumForMice_BM(runmean(zscore(((squeeze(OutPutData3.RipControlPaired.Cond.ob_high.mean(:,5,:))'))),5)' , 'threshold' , 10 , 'Color' , [1 .5 .5])
[h , MaxPowerValues , Freq_Max] = Plot_MeanSpectrumForMice_BM(runmean(zscore(((squeeze(OutPutData3.RipControlPaired.Cond.ob_high.mean(:,6,:))'))),5)' , 'threshold' , 10 , 'Color' , [.5 .5 1])

figure
plot(nanmean(zscore((Spectro{3}'.*(squeeze(OutPutData3.RipControlPaired.Cond.ob_high.mean(:,2,:))')))))

plot(Spectro{3} , nanmean(squeeze(OutPutData3.RipControlPaired.Cond.ob_high.mean(:,2,:))))



















%%
figure
subplot(121)
Data_to_use = movmean(zscore(Acc_Around_Stim_all') , round(length(Acc_Around_Stim_all)/100))';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(-wdw_size/1e3 , wdw_size/1e3 , length(Mean_All_Sp)) , Mean_All_Sp,Conf_Inter,'-k',1); hold on;
xlim([-20 20])
xlabel('time (s)'), ylabel('Motion (a.u.)')

subplot(122)
Data_to_use = movmean(zscore(Gamma_Around_Stim_all(:,1:round(length(Gamma_Around_Stim_all)*.42))') , round(length(Gamma_Around_Stim_all)/30))';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(-wdw_size/1e3 , -5 , length(Data_to_use)) , runmean(Mean_All_Sp,round(length(Mean_All_Sp)/100)) , runmean(Conf_Inter,round(length(Mean_All_Sp)/100)),'-k',1); hold on;
% shadedErrorBar(linspace(-wdw_size/1e3 , wdw_size/1e3 , length(Gamma_Around_Stim_all)) , Mean_All_Sp , Conf_Inter,'-k',1); hold on;
Data_to_use = movmean(zscore(Gamma_Around_Stim_all(:,round(length(Gamma_Around_Stim_all)*.58:end))') , round(length(Gamma_Around_Stim_all)/30))';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(5 , wdw_size/1e3 , length(Data_to_use)) , runmean(Mean_All_Sp,round(length(Mean_All_Sp)/100)) , runmean(Conf_Inter,round(length(Mean_All_Sp)/100)),'-k',1); hold on;
% shadedErrorBar(linspace(-wdw_size/1e3 , wdw_size/1e3 , length(Gamma_Around_Stim_all)) , Mean_All_Sp , Conf_Inter,'-k',1); hold on;

xlim([-20 20])
a=vline([-5 5],'--r');
xlabel('time (s)'), ylabel('OB gamma power (a.u.)')



figure
for i=[3 1 2 4 5]
    try
        subplot(1,5,i)
        Data_to_use = movmean(zscore(Gamma_Around_Stim_all(IDX==i,1:round(length(Gamma_Around_Stim_all)*.42))') , round(length(Gamma_Around_Stim_all)/30))';
        Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
        clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
        shadedErrorBar(linspace(-wdw_size/1e3 , -5 , length(Data_to_use)) , runmean(Mean_All_Sp,round(length(Mean_All_Sp)/100)) , runmean(Conf_Inter,round(length(Mean_All_Sp)/100)),'-k',1); hold on;
        % shadedErrorBar(linspace(-wdw_size/1e3 , wdw_size/1e3 , length(Gamma_Around_Stim_all)) , Mean_All_Sp , Conf_Inter,'-k',1); hold on;
        Data_to_use = movmean(zscore(Gamma_Around_Stim_all(IDX==i,round(length(Gamma_Around_Stim_all)*.58):end)') , round(length(Gamma_Around_Stim_all)/30))';
        Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
        clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
        shadedErrorBar(linspace(5 , wdw_size/1e3 , length(Data_to_use)) , runmean(Mean_All_Sp,round(length(Mean_All_Sp)/100)) , runmean(Conf_Inter,round(length(Mean_All_Sp)/100)),'-k',1); hold on;
        % shadedErrorBar(linspace(-wdw_size/1e3 , wdw_size/1e3 , length(Gamma_Around_Stim_all)) , Mean_All_Sp , Conf_Inter,'-k',1); hold on;
        xlim([-20 20]), ylim([-2 2])
    end
end



Cols = {[.5 .3 .8],[.7 .5 .8],[.8 .5 .3],[.8 .7 .5],[.3 .3 .3]};

figure
n=1;
for i=[3 1 2 4 5]
    try
        hold on
        Data_to_use = movmean(zscore(Acc_Around_Stim_all(IDX==i,:)') , round(length(Acc_Around_Stim_all)/100))';
        Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
        clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
        h=shadedErrorBar(linspace(-wdw_size/1e3 , wdw_size/1e3 , length(Mean_All_Sp)) , Mean_All_Sp,Conf_Inter,'-k',1); hold on;
%         color= Cols{n}; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
        color= Cols{n}; h.mainLine.Color=color; h.patch.FaceColor=[1 1 1]; h.edge(1).Color=[1 1 1]; h.edge(2).Color=[1 1 1];
        xlim([-20 20])
        xlabel('time (s)'), ylabel('Motion (a.u.)')
    end
    n=n+1;
end
