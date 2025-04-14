
clear all

%% path & load data
% eyelid
Group=22;
Drug_Group={'Saline'};
GetAllSalineSessions_BM
l{1} = load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_Eyelid_Cond_2sFullBins.mat');
load('/media/nas7/ProjetEmbReact/DataEmbReact/NewData/SVM_tsd.mat')

% rip inhib
Group=[7 8];
Drug_Group={'RipControl','RipInhib'};
GetEmbReactMiceFolderList_BM
l{1} = load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_RipInhib_Cond_2sFullBins.mat');
l{2} = load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_RipInhib_Ctrl_Cond_2sFullBins.mat');

% DZP
Group=[13 15];
Drug_Group={'Saline','Diazepam'};
GetEmbReactMiceFolderList_BM
l{1} = load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_SalineShort_Cond_2sFullBin.mat');
l{2} = load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_DZPShort_Cond_2sFullBin.mat');

% PAG
Group=[9];
GetAllSalineSessions_BM
l{1} = load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_PAG_Cond_2sFullBins.mat');

%% parameters
bin_size = 6; % in minutes
bin_tot = round(110/bin_size);
ind=6:50;

%% data collection
Session_type={'TestPre','Cond'};
for sess=1:2
    for group=1:length(Drug_Group)
        Mouse=Drugs_Groups_UMaze_BM(Group(group));
        [OutPutData.(Session_type{sess}).(Drug_Group{group}) , Epoch1.(Session_type{sess}).(Drug_Group{group}) , NameEpoch] = ...
            MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),'speed','heartrate','ripples');
    end
end

for group=1:length(Group)
    Mouse=Drugs_Groups_UMaze_BM(Group(group));
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        TotTime.(Mouse_names{mouse}) = max(Range(l{group}.OutPutData.Cond.respi_freq_bm.tsd{mouse,1}))/1e4;
        TotEpoch.(Mouse_names{mouse}) = intervalSet(0,max(Range(l{group}.OutPutData.Cond.respi_freq_bm.tsd{mouse,1})));
        Blocked_Epoch.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'epoch','epochname','blockedepoch');
        UnblockedEpoch.(Mouse_names{mouse}) = TotEpoch.(Mouse_names{mouse})-Blocked_Epoch.(Mouse_names{mouse});
        FreezeEpoch.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'epoch','epochname','fz_epoch_withsleep_withnoise');
        ActiveEpoch.(Mouse_names{mouse}) = TotEpoch.(Mouse_names{mouse}) - FreezeEpoch.(Mouse_names{mouse});
        Active_Unblocked.(Mouse_names{mouse}) = and(ActiveEpoch.(Mouse_names{mouse}) , UnblockedEpoch.(Mouse_names{mouse}));
        
        disp(Mouse_names{mouse})
    end
end

for sess=1:2
    for group=1:length(Drug_Group)
        Mouse=Drugs_Groups_UMaze_BM(Group(group));
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            for side=1:2
                for i=1:bin_tot
                    SmallEp = intervalSet((i-1)*60e4*bin_size , i*60e4*bin_size);
                    
                    HR = Restrict(OutPutData.(Session_type{sess}).(Drug_Group{group}).heartrate.tsd{mouse,7} , SmallEp);
                    Speed = Restrict(OutPutData.(Session_type{sess}).(Drug_Group{group}).speed.tsd{mouse,7} , SmallEp);
                    [meanHeartRatesInBins_Shock{sess}{group}(mouse,i,:) , binCenters , Dur_in_bin_Shock{sess}{group}(mouse,i,:)] =...
                        HeartRateVsSpeed_Curve_BM(Speed,HR);
                    HR = Restrict(OutPutData.(Session_type{sess}).(Drug_Group{group}).heartrate.tsd{mouse,8} , SmallEp);
                    Speed = Restrict(OutPutData.(Session_type{sess}).(Drug_Group{group}).speed.tsd{mouse,8} , SmallEp);
                    [meanHeartRatesInBins_Safe{sess}{group}(mouse,i,:) , binCenters , Dur_in_bin_Safe{sess}{group}(mouse,i,:)] =...
                        HeartRateVsSpeed_Curve_BM(Speed,HR);
                    
                end
            end
        end
    end
end


Session_type={'Cond'};
clear STIM_Number RESPI_Shock RESPI_Safe HR_Shock HR_Safe Rip_Shock Rip_Safe SVM_Shock SVM_Safe
for group=1:length(Group)
    Mouse=Drugs_Groups_UMaze_BM(Group(group));
    for sess=1:length(Session_type)
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            Sessions_List_ForLoop_BM
            
            StimEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','stimepoch');
            for i=1:bin_tot
                SmallEp = intervalSet((i-1)*60e4*bin_size , i*60e4*bin_size);
                
                if sum(DurationEpoch(and(SmallEp , Active_Unblocked.(Mouse_names{mouse}))))>0
                    STIM_Number{group}(mouse,i) = length(Start(and(StimEpoch.(Session_type{sess}).(Mouse_names{mouse}) , and(SmallEp , Active_Unblocked.(Mouse_names{mouse})))));
                else
                    STIM_Number{group}(mouse,i) = NaN;
                end
                RESPI_Safe{group}(mouse,i) = nanmean(Data(Restrict(l{group}.OutPutData.Cond.respi_freq_bm.tsd{mouse,6} , SmallEp)));
                HR_Safe{group}(mouse,i) = nanmean(Data(Restrict(l{group}.OutPutData.Cond.heartrate.tsd{mouse,6} , SmallEp)));
                HRVar_Safe{group}(mouse,i) = nanmean(Data(Restrict(l{group}.OutPutData.Cond.heartratevar.tsd{mouse,6} , SmallEp)));
                Rip_Safe{group}(mouse,i) = nanmean(Data(Restrict(l{group}.OutPutData.Cond.ripples_density.tsd{mouse,6} , SmallEp)));
                try, SVM_Safe{group}(mouse,i) = nanmean(Data(Restrict(SVM_Sf_TSD{mouse} , SmallEp))); end
                
                RESPI_Shock{group}(mouse,i) = nanmean(Data(Restrict(l{group}.OutPutData.Cond.respi_freq_bm.tsd{mouse,5} , SmallEp)));
                HR_Shock{group}(mouse,i) = nanmean(Data(Restrict(l{group}.OutPutData.Cond.heartrate.tsd{mouse,5} , SmallEp)));
                HRVar_Shock{group}(mouse,i) = nanmean(Data(Restrict(l{group}.OutPutData.Cond.heartratevar.tsd{mouse,5} , SmallEp)));
                Rip_Shock{group}(mouse,i) = nanmean(Data(Restrict(l{group}.OutPutData.Cond.ripples_density.tsd{mouse,5} , SmallEp)));
                try, SVM_Shock{group}(mouse,i) = nanmean(Data(Restrict(SVM_Sk_TSD{mouse} , SmallEp))); end
                
                HR_Active_Shock{group}(mouse,i) = nanmean(Data(Restrict(l{group}.OutPutData.Cond.heartrate.tsd{mouse,7} , SmallEp)));
                HR_Active_Safe{group}(mouse,i) = nanmean(Data(Restrict(l{group}.OutPutData.Cond.heartrate.tsd{mouse,8} , SmallEp)));
                HRVar_Active_Shock{group}(mouse,i) = nanmean(Data(Restrict(l{group}.OutPutData.Cond.heartratevar.tsd{mouse,7} , SmallEp)));
                HRVar_Active_Safe{group}(mouse,i) = nanmean(Data(Restrict(l{group}.OutPutData.Cond.heartratevar.tsd{mouse,8} , SmallEp)));
                
                Average_HR_Above_Shock{group}(mouse,i) = nansum(squeeze(meanHeartRatesInBins_Shock{2}{group}(mouse,i,ind)-...
                    nanmean(meanHeartRatesInBins_Shock{1}{group}(mouse,:,ind),2)).*squeeze(Dur_in_bin_Shock{2}{group}(mouse,i,ind)));
                Average_HR_Above_Safe{group}(mouse,i) = nansum(squeeze(meanHeartRatesInBins_Safe{2}{group}(mouse,i,ind)-...
                    nanmean(meanHeartRatesInBins_Safe{1}{group}(mouse,:,ind),2)).*squeeze(Dur_in_bin_Safe{2}{group}(mouse,i,ind)));
                
                try
                    if length(OutPutData.Cond.Saline.ripples.ts{mouse,3})>30
                        Rip_Numb_Tot{group}(mouse,i) = length(Data(Restrict(OutPutData.Cond.Saline.ripples.ts{mouse,3} , SmallEp)))./length(Data(OutPutData.Cond.Saline.ripples.ts{mouse,3}));
                        Rip_Numb_Safe{group}(mouse,i) = length(Data(Restrict(OutPutData.Cond.Saline.ripples.ts{mouse,6} , SmallEp)))./length(Data(OutPutData.Cond.Saline.ripples.ts{mouse,6}));
                    end
                end
            end
            disp(Mouse_names{mouse})
        end
    end
    HR_Safe{group}(HR_Safe{group}<7.5) = NaN;
    HR_Shock{group}(HR_Shock{group}<7.5) = NaN;
    RESPI_Safe{group}(RESPI_Safe{group}>6) = NaN;
Rip_Numb_Tot{group}(isnan(STIM_Number{1})) = NaN;
    Rip_Numb_Safe{group}(isnan(STIM_Number{1})) = NaN;
end


for group=1:length(Drug_Group)
    for side=1:2
        Average_HR_Above_Shock{group}(Average_HR_Above_Shock{group}==0) = NaN;
        Average_HR_Above_Safe{group}(Average_HR_Above_Safe{group}==0) = NaN;
    end
end


% Rip_Numb_Tot{1}(21,11) = NaN;  

%% Figures all eyelid
Average_HR_Above_Shock{1}(:,16)=NaN; % all eyelid
HR_Active_Shock{1}(:,16)=NaN;

figure
subplot(121)
Data_to_use = movmean(STIM_Number{1}',3,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar([bin_size/2:bin_size:bin_tot*bin_size-bin_size/2] , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
color= [.2 .2 .2]; h.mainLine.Color=color; %h.patch.FaceColor=[]; 
ylim([0 2]), ylabel('shocks (#/min)')
makepretty
yyaxis right
Data_to_use = movmean(RESPI_Safe{1}',3,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar([bin_size:bin_size:bin_tot*bin_size] , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
color= [.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=[.3 .3 1]; 
xlim([0 100]), ylim([2.9 3.9]), xlabel('time (min)'), ylabel('Breathing, safe freezing (Hz)')
makepretty


subplot(122)
Data_to_use = movmean(Rip_Numb_Safe{1}',3,'omitnan')'; %Data_to_use(23,11:13) = NaN;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar([bin_size/2:bin_size:bin_tot*bin_size-bin_size/2] , Mean_All_Sp , Conf_Inter ,'-r',1); hold on;
color= [.1 .3 .5]; h.mainLine.Color=color; h.patch.FaceColor=color; 
ylabel('SWR numb (norm)'), ylim([.02 .16]), hline(nanmean(nanmean(Rip_Numb_Safe{1}')),'--k'), xlim([0 100])
makepretty

plot([bin_size/2:bin_size:bin_tot*bin_size-bin_size/2] , Mean_All_Sp , 'o'  , 'Color' , [.1 .3 .5] , 'MarkerSize',5)
plot([bin_size/2:bin_size:bin_tot*bin_size-bin_size/2] , Mean_All_Sp , 'o'  , 'Color' , [.1 .3 .5] , 'MarkerSize',10)

clear h p
Data_to_use = movmean(Rip_Numb_Safe{1}',3,'omitnan')'; 
for i=1:18
    clear d, d = Data_to_use(:,i);
    try, [h(i) , p(i)] = ttest(d(~isnan(d)) , ones(sum(~isnan(d)),1)*nanmean(nanmean(Rip_Numb_Safe{1}'))); end
    try, [p2(i) , h(i)] = ranksum(d(~isnan(d)) , ones(sum(~isnan(d)),1)*nanmean(nanmean(Rip_Numb_Safe{1}'))); end
end
[corrected_p, h]=bonf_holm(p);
[corrected_p2, h]=bonf_holm(p2);
X_ax = [bin_size/2:bin_size:bin_tot*bin_size-bin_size/2];
plot(X_ax(corrected_p<.05) , .16 , '*' , 'Color' , [.1 .3 .5] , 'MarkerSize' , 15)

yyaxis right
Data_to_use = movmean(RESPI_Safe{1}',3,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar([bin_size/2:bin_size:bin_tot*bin_size-bin_size/2] , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
color= [.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=[.3 .3 1]; 
xlim([0 100]), ylim([2.9 3.9]), xlabel('time (min)'), ylabel('Breathing, safe freezing (Hz)')
makepretty

plot([bin_size/2:bin_size:bin_tot*bin_size-bin_size/2] , Mean_All_Sp , 'o'  , 'Color' , [.3 .3 1] , 'MarkerSize',5)
plot([bin_size/2:bin_size:bin_tot*bin_size-bin_size/2] , Mean_All_Sp , 'o'  , 'Color' , [.3 .3 1] , 'MarkerSize',10)

clear h p
Data_to_use = movmean(RESPI_Safe{1}',3,'omitnan')'; 
for i=1:18
    clear d, d = Data_to_use(:,i); D = nanmean(Data_to_use(:,1:4)');
    try, [h(i) , p(i)] = ttest(d(~isnan(d)) , D(~isnan(d))'); end
    try, [p2(i) , h(i)] = ranksum(d(~isnan(d)) , ones(sum(~isnan(d)),1)*nanmean(nanmean(RESPI_Safe{1}'))); end
end
[corrected_p, h]=bonf_holm(p);
[corrected_p2, h]=bonf_holm(p2);
X_ax = [bin_size/2:bin_size:bin_tot*bin_size-bin_size/2];
plot(X_ax(corrected_p<.05) , 3.8 , '*' , 'Color' , [.5 .5 1] , 'MarkerSize' , 15)






%% others
figure
Data_to_use = movmean(Rip_Safe{1}',3,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar([bin_size/2:bin_size:bin_tot*bin_size-bin_size/2] , Mean_All_Sp , Conf_Inter ,'-r',1); hold on;
color= [.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
xlim([0 100]), ylim([.25 .75]), xlabel('time (min)'), ylabel('SWR occurence (#/s)')
makepretty


figure
subplot(231)
Data_to_use = movmean(STIM_Number{1}',3,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar([bin_size:bin_size:bin_tot*bin_size] , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
box off, ylim([0 2])
ylabel('shocks (#/min)')
Data_to_use = movmean(RESPI_Shock{1}',3,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
yyaxis right
h=shadedErrorBar([bin_size:bin_size:bin_tot*bin_size] , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
color= [1 .5 .5]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
Data_to_use = movmean(RESPI_Safe{1}',3,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar([bin_size:bin_size:bin_tot*bin_size] , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
color= [.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
xlim([0 100]), xlabel('time (min)'), ylabel('Breathing, freezing (Hz)')
makepretty
f=get(gca,'Children'); legend([f(5),f(1)],'shock','safe');

subplot(232)
Data_to_use = movmean(STIM_Number{1}',3,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar([bin_size:bin_size:bin_tot*bin_size] , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
box off, ylim([0 2])
ylabel('shocks (#/min)')
Data_to_use = movmean(HR_Active_Shock{1}',3,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
yyaxis right
h=shadedErrorBar([bin_size:bin_size:bin_tot*bin_size] , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
color= [1 .5 .5]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
Data_to_use = movmean(HR_Active_Safe{1}',3,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar([bin_size:bin_size:bin_tot*bin_size] , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
color= [.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
xlim([0 100]), ylim([10.5 13.2]), xlabel('time (min)'), ylabel('Heart rate active (Hz)')
makepretty

subplot(233)
Data_to_use = Average_HR_Above_Shock{1};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar([0:6:6*17], nanmean(Data_to_use) , Conf_Inter ,'-k',1); hold on;
color=[1 .5 .5]; h.mainLine.Color=color; h.patch.FaceColor=color; h.FaceAlpha=.5; h.edge(1).Color=color; h.edge(2).Color=color;
Data_to_use = Average_HR_Above_Safe{1};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar([0:6:6*17], nanmean(Data_to_use) , Conf_Inter ,'-k',1); hold on;
color=[.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=color; h.FaceAlpha=.5; h.edge(1).Color=color; h.edge(2).Color=color;
hline(0,'--k')
makepretty
xlabel('time (min)'), ylabel('HR diff corrected, active'), ylim([-.4 .7])


Cols = {[1 .5 .5],[.5 .5 1]};
X = [1:2];
Legends = {'Shock','Safe'};

subplot(2,9,10)
MakeSpreadAndBoxPlot3_SB({nanmean(RESPI_Shock{1}(:,1:5)') nanmean(RESPI_Safe{1}(:,1:2)')},Cols,X,Legends,'showpoints',0,'paired',1);
ylim([2 6.5]), ylabel('Breathing, freezing (Hz)'), title('beg')
subplot(2,9,12)
MakeSpreadAndBoxPlot3_SB({nanmean(RESPI_Shock{1}(:,7:end)') nanmean(RESPI_Safe{1}(:,10:end)')},Cols,X,Legends,'showpoints',0,'paired',1);
ylim([2 6.5]), title('end')


subplot(2,9,13)
MakeSpreadAndBoxPlot3_SB({nanmean(HR_Active_Shock{1}(:,1:2)') nanmean(HR_Active_Safe{1}(:,1:2)')},Cols,X,Legends,'showpoints',0,'paired',1);
ylim([10.5 14]), ylabel('HR, active (Hz)'), title('beg')
subplot(2,9,15)
MakeSpreadAndBoxPlot3_SB({nanmean(HR_Active_Shock{1}(:,10:end)') nanmean(HR_Active_Safe{1}(:,10:end)')},Cols,X,Legends,'showpoints',0,'paired',1);
ylim([10.5 14]), title('end')


subplot(2,9,16)
MakeSpreadAndBoxPlot3_SB({nanmean(Average_HR_Above_Shock{1}(:,1:2)') nanmean(Average_HR_Above_Safe{1}(:,1:2)')},Cols,X,Legends,'showpoints',0,'paired',1);
ylim([-.8 1]), ylabel('HR diff, active (Hz)'), title('beg')
subplot(2,9,18)
MakeSpreadAndBoxPlot3_SB({nanmean(Average_HR_Above_Shock{1}(:,10:end)') nanmean(Average_HR_Above_Safe{1}(:,10:end)')},Cols,X,Legends,'showpoints',0,'paired',1);
ylim([-.8 1]), title('end')



%% figures drug group
Average_HR_Above_Shock{2}(:,13)=NaN; % DZP
Average_HR_Above_Shock{1}(9,:)=NaN;
Average_HR_Above_Safe{1}(9,:)=NaN;
Average_HR_Above_Shock{2}(6,:)=NaN;

HR_Active_Shock{1}(1,:)=NaN; % rip inhib
HR_Active_Shock{2}([3 5 1],[7 7 11])=NaN;



figure
subplot(211)
Data_to_use = movmean(STIM_Number{1}',3,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar([bin_size/2:bin_size:bin_tot*bin_size-bin_size/2] , Mean_All_Sp , Conf_Inter ,'-r',1); hold on;
color= [.3 .3 .3]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
box off, ylim([0 4.5])
ylabel('shocks (#/min)')
makepretty
yyaxis right
Data_to_use = movmean(RESPI_Safe{1}',3,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar([bin_size:bin_size:bin_tot*bin_size] , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
color= [.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
xlim([0 100]), xlabel('time (min)'), ylabel('Breathing, safe freezing (Hz)')
makepretty


subplot(212)
Data_to_use = movmean(STIM_Number{2}',3,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar([bin_size/2:bin_size:bin_tot*bin_size-bin_size/2] , Mean_All_Sp , Conf_Inter ,'-r',1); hold on;
color= [.3 .3 .3]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
box off, ylim([0 4.5])
ylabel('shocks (#/min)')
makepretty
yyaxis right
Data_to_use = movmean(RESPI_Safe{2}',3,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar([bin_size:bin_size:bin_tot*bin_size] , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
color= [.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
xlim([0 100]), xlabel('time (min)'), ylabel('Breathing, safe freezing (Hz)')
makepretty





figure
subplot(331)
Data_to_use = movmean(STIM_Number{1}',3,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar([bin_size:bin_size:bin_tot*bin_size] , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
box off, ylim([0 4.5])
ylabel('shocks (#/min)')
Data_to_use = movmean(RESPI_Shock{1}',3,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
yyaxis right
h=shadedErrorBar([bin_size:bin_size:bin_tot*bin_size] , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
color= [1 .5 .5]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
Data_to_use = movmean(RESPI_Safe{1}',3,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar([bin_size:bin_size:bin_tot*bin_size] , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
color= [.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
xlim([0 85]), ylim([2 6]), xlabel('time (min)'), ylabel('Breathing (Hz)')
f=get(gca,'Children'); legend([f(5),f(1)],'shock','safe');
title(Drug_Group{1})

subplot(334)
Data_to_use = movmean(STIM_Number{2}',3,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar([bin_size:bin_size:bin_tot*bin_size] , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
box off, ylim([0 4.5])
ylabel('shocks (#/min)')
Data_to_use = movmean(RESPI_Shock{2}',3,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
yyaxis right
h=shadedErrorBar([bin_size:bin_size:bin_tot*bin_size] , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
color= [1 .5 .5]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
Data_to_use = movmean(RESPI_Safe{2}',3,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar([bin_size:bin_size:bin_tot*bin_size] , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
color= [.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
xlim([0 85]), ylim([2 6]), xlabel('time (min)'), ylabel('Breathing (Hz)')
title(Drug_Group{2})


Cols = {[1 .5 .5],[1 .3 .3],[.5 .5 1],[.3 .3 1]};
X = [1:4];
Legends = {'Shock','Shock','Safe','Safe'};

subplot(3,9,19)
MakeSpreadAndBoxPlot3_SB({nanmean(RESPI_Shock{1}(:,1:5)') nanmean(RESPI_Shock{2}(:,1:5)')...
    nanmean(RESPI_Safe{1}(:,1:2)') nanmean(RESPI_Safe{2}(:,1:2)')},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([2 6.5]), ylabel('Breathing, freezing (Hz)'), title('beg')
subplot(3,9,21)
MakeSpreadAndBoxPlot3_SB({nanmean(RESPI_Shock{1}(:,7:end)') nanmean(RESPI_Shock{2}(:,7:end)')...
    nanmean(RESPI_Safe{1}(:,10:end)') nanmean(RESPI_Safe{2}(:,10:end)')},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([2 6.5]), title('end')


subplot(332)
Data_to_use = movmean(STIM_Number{1}',3,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar([bin_size:bin_size:bin_tot*bin_size] , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
box off, ylim([0 4.5])
ylabel('shocks (#/min)')
Data_to_use = movmean(HR_Active_Shock{1}',3,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
yyaxis right
h=shadedErrorBar([bin_size:bin_size:bin_tot*bin_size] , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
color= [1 .5 .5]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
Data_to_use = movmean(HR_Active_Safe{1}',3,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar([bin_size:bin_size:bin_tot*bin_size] , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
color= [.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
xlim([0 85]), ylim([11.2 13.4]), xlabel('time (min)'), ylabel('Heart rate active (Hz)')

subplot(335)
Data_to_use = movmean(STIM_Number{2}',3,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar([bin_size:bin_size:bin_tot*bin_size] , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
box off, ylim([0 4.5])
ylabel('shocks (#/min)')
Data_to_use = movmean(HR_Active_Shock{2}',3,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
yyaxis right
h=shadedErrorBar([bin_size:bin_size:bin_tot*bin_size] , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
color= [1 .5 .5]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
Data_to_use = movmean(HR_Active_Safe{2}',3,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar([bin_size:bin_size:bin_tot*bin_size] , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
color= [.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
xlim([0 85]), ylim([11.2 13.4]), xlabel('time (min)'), ylabel('Heart rate active (Hz)')


subplot(3,9,22)
MakeSpreadAndBoxPlot3_SB({nanmean(HR_Active_Shock{1}(:,1:2)') nanmean(HR_Active_Shock{2}(:,1:2)')...
    nanmean(HR_Active_Safe{1}(:,1:2)') nanmean(HR_Active_Safe{2}(:,1:2)')},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([10.5 14]), ylabel('Heart rate, active (Hz)'), title('beg')
subplot(3,9,24)
MakeSpreadAndBoxPlot3_SB({nanmean(HR_Active_Shock{1}(:,10:end)') nanmean(HR_Active_Shock{2}(:,10:end)')...
    nanmean(HR_Active_Safe{1}(:,10:end)') nanmean(HR_Active_Safe{2}(:,10:end)')},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([10.5 14]), title('end')



subplot(333)
Data_to_use = movmean(Average_HR_Above_Shock{1}',3,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar([0:6:6*17], nanmean(Data_to_use) , Conf_Inter ,'-k',1); hold on;
color=[1 .5 .5]; h.mainLine.Color=color; h.patch.FaceColor=color; h.FaceAlpha=.5; h.edge(1).Color=color; h.edge(2).Color=color;
Data_to_use = movmean(Average_HR_Above_Safe{1}',3,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar([0:6:6*17], nanmean(Data_to_use) , Conf_Inter ,'-k',1); hold on;
color=[.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=color; h.FaceAlpha=.5; h.edge(1).Color=color; h.edge(2).Color=color;
hline(0,'--k')
xlabel('time (min)'), ylabel('HR diff'), ylim([-.3 .6]), xlim([0 72]), box off

subplot(336)
Data_to_use = movmean(Average_HR_Above_Shock{2}',3,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar([0:6:6*17], nanmean(Data_to_use) , Conf_Inter ,'-k',1); hold on;
color=[1 .5 .5]; h.mainLine.Color=color; h.patch.FaceColor=color; h.FaceAlpha=.5; h.edge(1).Color=color; h.edge(2).Color=color;
Data_to_use = movmean(Average_HR_Above_Safe{2}',3,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar([0:6:6*17], nanmean(Data_to_use) , Conf_Inter ,'-k',1); hold on;
color=[.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=color; h.FaceAlpha=.5; h.edge(1).Color=color; h.edge(2).Color=color;
hline(0,'--k')
xlabel('time (min)'), ylabel('HR diff (Hz)'), ylim([-.2 .5]), xlim([0 72]), box off


subplot(3,9,25)
MakeSpreadAndBoxPlot3_SB({nanmean(Average_HR_Above_Shock{1}(:,1:2)') nanmean(Average_HR_Above_Shock{2}(:,1:2)')...
    nanmean(Average_HR_Above_Safe{1}(:,1:2)') nanmean(Average_HR_Above_Safe{2}(:,1:2)')},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([-.7 1]), ylabel('Heart rate diff, active (Hz)'), title('beg')
subplot(3,9,27)
MakeSpreadAndBoxPlot3_SB({nanmean(Average_HR_Above_Shock{1}(:,10:end)') nanmean(Average_HR_Above_Shock{2}(:,10:end)')...
    nanmean(Average_HR_Above_Safe{1}(:,10:end)') nanmean(Average_HR_Above_Safe{2}(:,10:end)')},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([-.7 1]), title('end')





%% figures
% HR var
subplot(322)
Data_to_use = movmean(STIM_Number{1}',3,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar([bin_size:bin_size:bin_tot*bin_size] , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
box off, ylim([0 4.5])
ylabel('shocks (#/min)')
Data_to_use = movmean(HRVar_Active_Shock{1}',3,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
yyaxis right
h=shadedErrorBar([bin_size:bin_size:bin_tot*bin_size] , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
color= [1 .5 .5]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
Data_to_use = movmean(HRVar_Active_Safe{1}',3,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar([bin_size:bin_size:bin_tot*bin_size] , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
color= [.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
xlim([0 85]), ylim([0 .18]), xlabel('time (min)'), ylabel('Heart rate var active (Hz)')
title('Saline')

subplot(324)
Data_to_use = movmean(STIM_Number{2}',3,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar([bin_size:bin_size:bin_tot*bin_size] , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
box off, ylim([0 4.5])
ylabel('shocks (#/min)')
Data_to_use = movmean(HRVar_Active_Shock{2}',3,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
yyaxis right
h=shadedErrorBar([bin_size:bin_size:bin_tot*bin_size] , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
color= [1 .5 .5]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
Data_to_use = movmean(HRVar_Active_Safe{2}',3,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar([bin_size:bin_size:bin_tot*bin_size] , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
color= [.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
xlim([0 85]), ylim([0 .18]), xlabel('time (min)'), ylabel('Heart rate var active (Hz)')
title('Diazepam')


subplot(3,6,16)
MakeSpreadAndBoxPlot3_SB({nanmean(HRVar_Active_Shock{1}(:,1:2)') nanmean(HRVar_Active_Shock{2}(:,1:2)')...
    nanmean(HRVar_Active_Safe{1}(:,1:2)') nanmean(HRVar_Active_Safe{2}(:,1:2)')},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 .3]), ylabel('Heart rate var, active (Hz)'), title('beg')
subplot(3,6,18)
MakeSpreadAndBoxPlot3_SB({nanmean(HRVar_Active_Shock{1}(:,10:end)') nanmean(HRVar_Active_Shock{2}(:,10:end)')...
    nanmean(HRVar_Active_Safe{1}(:,10:end)') nanmean(HRVar_Active_Safe{2}(:,10:end)')},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 .2]), title('end')


% Rip
subplot(133)
Data_to_use = movmean(STIM_Number{1}',4,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar([1:3:40*3] , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
box off, ylim([0 2])
ylabel('shocks (#/min)')
Data_to_use = movmean(Rip_Shock{1}',4,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
yyaxis right
h=shadedErrorBar([1:6:20*6] , Mean_All_Sp , Conf_Inter ,'-r',1); hold on;
color= [1 .5 .5]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
Data_to_use = movmean(Rip_Safe{1}',4,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar([1:3:40*3] , Mean_All_Sp , Conf_Inter ,'-r',1); hold on;
color= [.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
xlim([0 100]), xlabel('time (min)'), ylabel('SWR occurence (#/s)')


% SVM
SVM_Safe{1}(SVM_Safe{1}==0)=NaN;
SVM_Shock{1}(SVM_Shock{1}==0)=NaN;

figure
Data_to_use = movmean(STIM_Number{1}',4,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar([1:3:40*3] , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
box off, ylim([0 2])
ylabel('shocks (#/min)')

Data_to_use = movmean(SVM_Safe{1}',4,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
yyaxis right
h=shadedErrorBar([1:3:40*3] , Mean_All_Sp , Conf_Inter ,'-r',1); hold on;
color= [.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;

Data_to_use = movmean(SVM_Shock{1}',2,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar([1:6:20*6] , Mean_All_Sp , Conf_Inter ,'-r',1); hold on;
color= [1 .5 .5]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
xlim([0 72]), xlabel('time (min)'), ylabel('Breathing (Hz)')



%% old
for mouse=1:length(Mouse)
    T_respi(mouse) = sum(RESPI_Safe(mouse,:)<(max(RESPI_Safe(mouse,:))-min(RESPI_Safe(mouse,:)))/2+min(RESPI_Safe(mouse,:)))*6;
    T_shocks(mouse) = sum(STIM_Number(mouse,:)<(max(STIM_Number(mouse,:))-min(STIM_Number(mouse,:)))/2+min(STIM_Number(mouse,:)))*6;
    
    T_respi2(mouse) = find(RESPI_Safe(mouse,:)<(max(RESPI_Safe(mouse,:))-min(RESPI_Safe(mouse,:)))/2+min(RESPI_Safe(mouse,:)),1,'first')*6;
    T_shocks2(mouse) = find(STIM_Number(mouse,:)<(max(STIM_Number(mouse,:))-min(STIM_Number(mouse,:)))/2+min(STIM_Number(mouse,:)),1,'first')*6;
end

% big bin
clear STIM_Number2 RESPI_Shock_corr2 RESPI_Safe_corr2
size_bin = 40;
for bin=1:bin_tot/size_bin
    
    STIM_Number2{1}(:,bin) = nansum(STIM_Number{1}(:,[(bin-1)+1:bin])');
    RESPI_Shock_corr2{1}(:,bin) = nanmean(RESPI_Shock{1}(:,[(bin-1)+1:bin])');
    RESPI_Safe_corr2{1}(:,bin) = nanmean(RESPI_Safe{1}(:,[(bin-1)+1:bin])');
    
end


%% fit
clear R_respi_linear R_respi_exp R_shocks_linear R_shocks_exp
for mouse=1:length(Mouse)
    if sum(~isnan(RESPI_Safe(mouse,:)))>7
        % respi
        mdl = fitlm([1:17] , RESPI_Safe(mouse,1:17)', 'linear');
        R_respi_linear(mouse) = mdl.Rsquared.Ordinary;
        Coeff_respi_linear(mouse) = table2array(mdl.Coefficients(2,1));
        
        mdl = fitlm(exp(-linspace(0,10,17)) , RESPI_Safe(mouse,1:17)' , 'linear');
        R_respi_exp(mouse) = mdl.Rsquared.Ordinary;
        Coeff_respi_exp(mouse) = table2array(mdl.Coefficients(2,1));
    
        % HR
        mdl = fitlm([1:17] , HR_Safe(mouse,1:17)', 'linear');
        R_hr_linear(mouse) = mdl.Rsquared.Ordinary;
        Coeff_hr_linear(mouse) = table2array(mdl.Coefficients(2,1));
        
        mdl = fitlm(exp(-linspace(0,10,17)) , HR_Safe(mouse,1:17)' , 'linear');
        R_hr_exp(mouse) = mdl.Rsquared.Ordinary;
        Coeff_hr_exp(mouse) = table2array(mdl.Coefficients(2,1));
        
        % shocks
        mdl = fitlm([1:17] , STIM_Number(mouse,1:17)', 'linear');
        R_shocks_linear(mouse) = mdl.Rsquared.Ordinary;
        Coeff_shocks_linear(mouse) = table2array(mdl.Coefficients(2,1));

        mdl = fitlm(exp(-linspace(0,10,17)) , STIM_Number(mouse,1:17)' , 'linear');
        R_shocks_exp(mouse) = mdl.Rsquared.Ordinary;
        Coeff_shocks_exp(mouse) = table2array(mdl.Coefficients(2,1));
    end
end
R_respi_linear(R_respi_linear==0)=NaN;
R_respi_exp(R_respi_exp==0)=NaN;
R_hr_linear(R_hr_linear==0)=NaN;
R_hr_exp(R_hr_exp==0)=NaN;
R_shocks_linear(R_shocks_linear==0)=NaN;
R_shocks_exp(R_shocks_exp==0)=NaN;
Coeff_respi_linear(Coeff_respi_linear==0)=NaN;
R_respi_linear(Coeff_respi_linear>0) = NaN;
R_respi_exp(Coeff_respi_linear>0) = NaN;


figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({R_respi_linear R_respi_exp},{[.3 .3 .3],[.5 .5 .5]},[1,2],{'linear','exp(-x)'},'showpoints',0,'paired',1,'optiontest','ttest')
ylabel('R values, respi')

subplot(122)
MakeSpreadAndBoxPlot3_SB({R_shocks_linear R_shocks_exp},{[.3 .3 .3],[.5 .5 .5]},[1,2],{'linear','exp(-x)'},'showpoints',0,'paired',1)
ylabel('R values, shocks')


figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({R_hr_linear R_hr_exp},{[.3 .3 .3],[.5 .5 .5]},[1,2],{'linear','exp(-x)'},'showpoints',0,'paired',1)
ylabel('R values, respi')


%% tools
figure
subplot(411)
plot(STIM_Number{1}','.k','MarkerSize',30), ylim([1 6.5])
axis square

subplot(423)
plot(RESPI_Shock{1}','.k','MarkerSize',30), ylim([1 6.5])
subplot(424)
plot(RESPI_Safe{1}','.k','MarkerSize',30), ylim([1 6.5])

subplot(425)
plot(HR_Shock{1}','.k','MarkerSize',30), ylim([7 13.5])
subplot(426)
plot(HR_Safe{1}','.k','MarkerSize',30), ylim([7 13.5])

subplot(427)
plot(Rip_Shock{1}','.k','MarkerSize',30), ylim([0  2])
subplot(428)
plot(Rip_Safe{1}','.k','MarkerSize',30), ylim([0 2])




figure
subplot(131)
plot([1:6:20*6]+((.5-rand(1,20))*.2)*20 , STIM_Number'+(.5-rand(20,29))*.4 , '.b','MarkerSize',10)
makepretty_BM2
xlabel('time (min)'), ylabel('shocks (#/min)')
xlim([-1 100]), ylim([-.1 8])

subplot(132)
plot([1:6:20*6]+((.5-rand(1,20))*.2)*20 , RESPI_Safe'+(.5-rand(20,29))*.4 , '.r','MarkerSize',10)
makepretty_BM2
xlabel('time (min)'), ylabel('Breathing (Hz)')
xlim([-1 100]), ylim([1 6])

subplot(133)
plot([1:6:20*6]+((.5-rand(1,20))*.2)*20 , HR_Safe'+(.5-rand(20,29))*.4 , '.m','MarkerSize',10)
makepretty_BM2
xlabel('time (min)'), ylabel('Heart rate (Hz)')
xlim([-1 100]), ylim([8 13])


figure
imagesc(RESPI_Safe{1})
xlabel('time (min)')
ylabel('mice #')
colorbar
colormap viridis


X = []; Y1 = []; Y2 = [];
for mouse=1:length(Mouse)
    
    X = [X [1:6:17*6]+(1-2*rand(1,17))];
    Y1 = [Y1 zscore_nan_BM(RESPI_Safe(mouse,1:17))];
    Y2 = [Y2 STIM_Number(mouse,1:17)];
    
end

figure
plot(X,Y1,'.k')
plot(X,Y2,'.k')


mdl = fitlm(X , Y1 , 'linear');
mdl = fitlm(X , Y2 , 'linear');

mdl = fitlm(exp(-X./1.7) , Y1 , 'linear');
mdl = fitlm(exp(-X./1.7) , Y2 , 'linear');

        mdl = fitlm(exp(-linspace(0,10,17)) , STIM_Number(mouse,1:17)' , 'linear');

        

figure
PlotCorrelations_BM(X,Y2_exp)
PlotCorrelations_BM(X,exp(-Y2_exp))

        %         x = RESPI_Safe(mouse,1:17);
        %         X = ((x-min(x))./(max(x)-min(x)))*10;
        %         mdl = fitlm([1:17] , exp(-X') , 'linear');
        %         R_respi_exp(mouse) = mdl.Rsquared.Ordinary;
        
%% old
% Mouse=Drugs_Groups_UMaze_BM(11);
% load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_all_Cond_2sFullBins.mat')

% for sess=1
%     [OutPutData , Epoch1 , NameEpoch] = MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),...
%         'respi_freq_bm');
% end


clear DATA_stim
for mouse = 1:length(Mouse)
    clear A R
    R = Range(OutPutData.Cond.(Params{param}).tsd{mouse,6});
    St = Start(and(StimEpoch.(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Mouse_names{mouse})));
    for i=1:length(St)
        
        A(R>St(i)) = i;
        Stim_tsd = tsd(R , A');
        
    end
    try
        clear D, D = Data(Stim_tsd);
        DATA_stim(mouse,:) = interp1(linspace(0,1,length(D)) , D , linspace(0,1,100));
    end
    disp(Mouse_names{mouse})
end
DATA_stim(:,1)=0;

figure
plot(nanmean(DATA_stim./max(DATA_stim')') , 'k'), hold on
ylabel('shocks, norm')
makepretty
yyaxis right
plot(nanmean(DATA_safe.respi_freq_bm) , 'Color' , [.5 .5 1])
plot(nanmean(DATA_shock.respi_freq_bm) , 'Color' , [1 .5 .5])
ylabel('Safe breathing (Hz)')
makepretty
legend('stims','safe','shock')
xlabel('time (min)')


imagesc(DATA_stim)

figure
plot(nanmean(DATA_stim./max(DATA_stim')'))
line([0 100],[0 1],'LineStyle','--')

A = abs(diff(DATA_stim)); A = A./max(A')';
plot(nanmean(A(:,2:100)))

%%
for mouse = 1:length(Mouse)
%     StimEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'epoch','epochname','stimepoch');
%     TotEpoch.(Mouse_names{mouse}) = intervalSet(0,max(Range(OutPutData.Cond.respi_freq_bm.tsd{mouse,1})));
%     Blocked_Epoch.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'epoch','epochname','blockedepoch');
%     UnblockedEpoch.(Mouse_names{mouse}) = TotEpoch.(Mouse_names{mouse})-Blocked_Epoch.(Mouse_names{mouse});
    clear St, St = Start(and(StimEpoch.(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Mouse_names{mouse})));
    Stim_number = tsd(St , [1:length(St)]');
    clear Stim_tsd Stim_tsd2 A
    for i=1:100
        SmallEp = intervalSet((i-1)*60e4 , i*60e4);
        A(i,1) = i*60e4+30e4;
        A(i,2) = length(Start(and(and(Epoch1.Cond{mouse,2} , SmallEp) , UnblockedEpoch.(Mouse_names{mouse}))));
    end
    Stim_tsd = tsd(A(:,1) , A(:,2));
    Stim_tsd2 = Restrict(Stim_tsd , OutPutData.Cond.(Params{param}).tsd{mouse,6});
    try
        clear D, D = Data(Stim_tsd2);
        DATA_stim(mouse,:) = interp1(linspace(0,1,length(D)) , D , linspace(0,1,100));
    end
    
    disp(Mouse_names{mouse})
end


figure
Data_to_use = DATA_stim;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar(x , nanmean(Data_to_use) , Conf_Inter ,'-k',1); hold on;


%% cumulative ripples
Session_type={'TestPre','Cond'};
for sess=1:2
    for group=1:length(Drug_Group)
        Mouse=Drugs_Groups_UMaze_BM(Group(group));
        [OutPutData.(Session_type{sess}).(Drug_Group{group}) , Epoch1.(Session_type{sess}).(Drug_Group{group}) , NameEpoch] = ...
            MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),'speed','heartrate','ripples');
    end
end

for mouse=1:length(Mouse)
    try, RipCumTsd{mouse} = tsd(Range(OutPutData.Cond.Saline.ripples.ts{mouse,3}) , ([1:length(OutPutData.Cond.Saline.ripples.ts{mouse,3})]./length(OutPutData.Cond.Saline.ripples.ts{mouse,3}))'); end
    try, RipCumTsd_shock{mouse} = tsd(Range(OutPutData.Cond.Saline.ripples.ts{mouse,5}) , ([1:length(OutPutData.Cond.Saline.ripples.ts{mouse,5})]./length(OutPutData.Cond.Saline.ripples.ts{mouse,5}))'); end
    try, RipCumTsd_safe{mouse} = tsd(Range(OutPutData.Cond.Saline.ripples.ts{mouse,6}) , ([1:length(OutPutData.Cond.Saline.ripples.ts{mouse,6})]./length(OutPutData.Cond.Saline.ripples.ts{mouse,6}))'); end
end




Session_type={'Cond'}; sess=1;
Mouse=Drugs_Groups_UMaze_BM(22);
[OutPutData , Epoch1 , NameEpoch] = MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),'ripples');



for mouse=1:length(Mouse)
    try, RipCumTsd{mouse} = tsd(Range(OutPutData.ripples.ts{mouse,3}) , ([1:length(OutPutData.ripples.ts{mouse,3})]./length(OutPutData.ripples.ts{mouse,3}))'); end
end


for mouse = 1:length(Mouse)
    if length(RipCumTsd{mouse})>30
        try
            clear D, D = Range(OutPutData.ripples.ts{mouse,3});
            DATA_Fz(mouse,:) = interp1(linspace(0,1,length(D)) , D , linspace(0,1,100));
        end
    end
end
DATA_Fz(DATA_Fz==0) = NaN;


figure
plot(nanmean(DATA_Fz) , [1:100])

plot(Range(RipCumTsd{mouse}) , Data(RipCumTsd{mouse})')

figure
for mouse=1:length(Mouse)
    try, plot(Range(OutPutData.ripples.ts{mouse,3}) , ([1:length(OutPutData.ripples.ts{mouse,3})]./length(OutPutData.ripples.ts{mouse,3}))'), hold on, end
end










load('/media/nas7/ProjetEmbReact/DataEmbReact/Respi_FromModel.mat')
clear RESPI_Safe RESPI_Shock RESPI_Diff RESPI_Shock_corr RESPI_Safe_corr
Session_type={'Cond'}; sess=1;
for group=1:length(Group)
    Mouse=Drugs_Groups_UMaze_BM(Group(group));
    for sess=1:length(Session_type)
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            Sessions_List_ForLoop_BM
            
            %             StimEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','stimepoch');
            for i=1:bin_tot
                SmallEp = intervalSet((i-1)*60e4*bin_size , i*60e4*bin_size);
                
                %                 if sum(DurationEpoch(and(SmallEp , Active_Unblocked.(Mouse_names{mouse}))))>0
                %                     STIM_Number{group}(mouse,i) = length(Start(and(StimEpoch.(Session_type{sess}).(Mouse_names{mouse}) , and(SmallEp , Active_Unblocked.(Mouse_names{mouse})))));
                %                 else
                %                     STIM_Number{group}(mouse,i) = NaN;
                %                 end
                try
                    RESPI_Safe{group}(mouse,i) = nanmean(Data(Restrict(Respi_safe_tsd{mouse} , SmallEp)));
                    RESPI_Safe_corr{group}(mouse,i) = nanmean(Data(Restrict(Respi_safe_corr_tsd{mouse} , SmallEp)));
                    RESPI_Diff{group}(mouse,i) = nanmean(Data(Restrict(Respi_shock_tsd{mouse} , SmallEp)))-nanmean(Data(Restrict(Respi_safe_tsd{mouse} , SmallEp)));
                end
                try
                    RESPI_Shock{group}(mouse,i) = nanmean(Data(Restrict(Respi_shock_tsd{mouse} , SmallEp)));
                    RESPI_Shock_corr{group}(mouse,i) = nanmean(Data(Restrict(Respi_shock_corr_tsd{mouse} , SmallEp)));
                end
                
                if length(RipCumTsd{mouse})>30
                    Rip_Numb_Tot{group}(mouse,i) = length(Data(Restrict(OutPutData.Cond.Saline.ripples.ts{mouse,3} , SmallEp)))./length(Data(OutPutData.Cond.Saline.ripples.ts{mouse,3}));
                    Rip_Numb_Safe{group}(mouse,i) = length(Data(Restrict(OutPutData.Cond.Saline.ripples.ts{mouse,6} , SmallEp)))./length(Data(OutPutData.Cond.Saline.ripples.ts{mouse,6}));
                    
                    
                    RipCum{group}(mouse,i) = nanmean(Data(Restrict(RipCumTsd{mouse} , SmallEp)));
                    %                     RipCum_shock{group}(mouse,i) = nanmean(Data(Restrict(RipCumTsd_shock{mouse} , SmallEp)));
                    RipCum_safe{group}(mouse,i) = nanmean(Data(Restrict(RipCumTsd_safe{mouse} , SmallEp)));
                end
            end
            disp(Mouse_names{mouse})
        end
    end
    RESPI_Safe{group}(RESPI_Safe{group}>6) = NaN;
    RipCum{group}(RipCum{group}==0) = NaN;
    RipCum_safe{group}(RipCum_safe{group}==0) = NaN;
    %     RipCum_shock{group}(RipCum_shock{group}==0) = NaN;
    RESPI_Safe{group}(RESPI_Safe{group}==0) = NaN;
    RESPI_Diff{group}(RESPI_Diff{group}==0) = NaN;
    RESPI_Shock{group}(RESPI_Shock{group}==0) = NaN;
    RESPI_Shock_corr{group}(RESPI_Shock_corr{group}==0) = NaN;
    RESPI_Safe_corr{group}(RESPI_Safe_corr{group}==0) = NaN;
    Rip_Numb_Tot{group}(isnan(STIM_Number{1})) = NaN;
    Rip_Numb_Safe{group}(isnan(STIM_Number{1})) = NaN;
end


figure
Data_to_use = movmean(STIM_Number{1}',3,'omitnan')';
% Data_to_use = STIM_Number{1};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar([bin_size:bin_size:bin_tot*bin_size] , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
box off, ylim([0 2])
ylabel('shocks (#/min)')
makepretty
yyaxis right
Data_to_use = movmean(RESPI_Safe{1}',3,'omitnan')';
% Data_to_use = RESPI_Safe{1};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar([bin_size:bin_size:bin_tot*bin_size] , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
color= [.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
xlim([0 100]), ylim([2.5 3.9])
makepretty


RipCum_safe{1}(21,:)=NaN;
RipCum_safe{1} = RipCum_safe{1}./max(RipCum_safe{1}(:,1:12)')';
plot(RipCum_safe{1}')

Data_to_use = RipCum_safe{1};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar([bin_size/2:bin_size:bin_tot*bin_size-bin_size/2] , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
line([0 69],[0 1],'LineStyle','--','Color','r','LineWidth',2)
xlim([0 69])


RipCum_shock{1}(21,:)=NaN;
RipCum_shock{1} = RipCum_shock{1}./max(RipCum_shock{1}(:,1:12)')';
plot(RipCum_shock{1}')

figure
Data_to_use = RipCum_shock{1};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar([bin_size/2:bin_size:bin_tot*bin_size-bin_size/2] , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
line([0 69],[0 1],'LineStyle','--','Color','r','LineWidth',2)
xlim([0 69])





color= [.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
xlim([0 100]), xlabel('time (min)'), ylabel('Breathing, freezing (Hz)')
makepretty


f=get(gca,'Children'); legend([f(5),f(1)],'shock','safe');




figure
Data_to_use = movmean(RipCum{1}',3,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar([bin_size:bin_size:bin_tot*bin_size] , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;


RipCum{1}(21,:)=NaN;
RipCum{1} = RipCum{1}./max(RipCum{1}(:,1:12)')';

figure
imagesc(RipCum{1}), xlim([.5 12.5]), caxis([0 1])


figure
plot(RipCum{1}'), xlim([.5 12.5]), caxis([0 1])


figure
plot(nanmean(RipCum{1})), xlim([0 12])
line([0 12],[0 1],'LineStyle','--','Color','r','LineWidth',2)







