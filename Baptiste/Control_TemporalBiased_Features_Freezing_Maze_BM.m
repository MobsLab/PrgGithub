
%% load data

load('/media/nas7/ProjetEmbReact/DataEmbReact/Control_TemporalBiased.mat')


%% generate data
clear all

GetAllSalineSessions_BM
GetEmbReactMiceFolderList_BM
Mouse = Drugs_Groups_UMaze_BM(11);
Session_type = {'Habituation','sleep_pre','Cond','Ext'};

for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for sess=2%1:4
        Sessions_List_ForLoop_BM
        
        if sess~=2
            try
                %                 Acc.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'accelero');
                %                 FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','fz_epoch_withnoise');
                %                 ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','zoneepoch_behav');
                %                 ShockZone.(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){1};
                %                 SafeZone.(Session_type{sess}).(Mouse_names{mouse}) = or(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){2} , ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){5});
                %
                %                 FreezingShock.(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , ShockZone.(Session_type{sess}).(Mouse_names{mouse}));
                %                 FreezingSafe.(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , SafeZone.(Session_type{sess}).(Mouse_names{mouse}));
                %                 TotDur.(Session_type{sess}).(Mouse_names{mouse}) = max(Range(Acc.(Session_type{sess}).(Mouse_names{mouse})));
                FreezeAll_Prop{sess}(mouse) = sum(DurationEpoch(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})))/TotDur.(Session_type{sess}).(Mouse_names{mouse});
                FreezeShock_Prop{sess}(mouse) = sum(DurationEpoch(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})))/TotDur.(Session_type{sess}).(Mouse_names{mouse});
                FreezeSafe_Prop{sess}(mouse) = sum(DurationEpoch(FreezingSafe.(Session_type{sess}).(Mouse_names{mouse})))/TotDur.(Session_type{sess}).(Mouse_names{mouse});
                %                 FreezeAll_Time{sess}{mouse} = DurationEpoch(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}))/1e4;
                                FreezeShock_Time{sess}{mouse} = DurationEpoch(FreezingShock.(Session_type{sess}).(Mouse_names{mouse}))/1e4;
                %                 FreezeSafe_Time{sess}{mouse} = DurationEpoch(FreezingSafe.(Session_type{sess}).(Mouse_names{mouse}))/1e4;
                
                for bin=1:20
                    SmallEp = intervalSet((TotDur.(Session_type{sess}).(Mouse_names{mouse})/20)*(bin-1) , (TotDur.(Session_type{sess}).(Mouse_names{mouse})/20)*bin);
                    FreezeAll_Prop_bin{sess}(mouse,bin) = sum(DurationEpoch(and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , SmallEp)))/sum(DurationEpoch(SmallEp));
                    FreezeShock_Prop_bin{sess}(mouse,bin) = sum(DurationEpoch(and(FreezingShock.(Session_type{sess}).(Mouse_names{mouse}) , SmallEp)))/sum(DurationEpoch(SmallEp));
                    FreezeSafe_Prop_bin{sess}(mouse,bin) = sum(DurationEpoch(and(FreezingSafe.(Session_type{sess}).(Mouse_names{mouse}) , SmallEp)))/sum(DurationEpoch(SmallEp));
                end
            end
        else
            try
                NewMovAcctsd = tsd(Range(OutPutData.sleep_pre.accelero.tsd{mouse,2}) , runmean(Data(OutPutData.sleep_pre.accelero.tsd{mouse,2}),30));
                if mouse<36
                    FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = thresholdIntervals(NewMovAcctsd,1e7,'Direction','Below');
                else
                    FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = thresholdIntervals(NewMovAcctsd,1.7e7,'Direction','Below');
                end
                FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = mergeCloseIntervals(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}),0.3*1E4);
                FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = dropShortIntervals(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}),2*1E4);
                WakeDur.(Session_type{sess}).(Mouse_names{mouse}) = sum(DurationEpoch(Epoch1.sleep_pre{mouse,2}));
                TotDur.(Session_type{sess}).(Mouse_names{mouse}) = max(Range(OutPutData.sleep_pre.accelero.tsd{mouse,2}));

                % if you want to consider only wake before first 30s sleep
%                 Sleep1 = Epoch1.sleep_pre{mouse,3};
%                 Sleep1 = dropShortIntervals(Sleep1,30e4);
%                 Sleep_Beginning = Start(Sleep1) ;
%                 Wake_Before_Sleep_Epoch{mouse} = intervalSet(0 , Sleep_Beginning(1));
%                 Wake_Before_Sleep_dur.(Session_type{sess}).(Mouse_names{mouse}) = sum(DurationEpoch(Wake_Before_Sleep_Epoch{mouse}));
                
%                 Wake_Before_Sleep_dur.(Session_type{sess}).(Mouse_names{mouse}) = sum(DurationEpoch(Wake_Before_Sleep_Epoch{mouse}));
                FreezeAll_Prop{sess}(mouse) = sum(DurationEpoch(and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) ,...
                    Epoch1.sleep_pre{mouse,2})))/TotDur.(Session_type{sess}).(Mouse_names{mouse});
                %                 FreezeAll_Prop{sess}(mouse) = sum(DurationEpoch(and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) ,...
                %                     Epoch1.sleep_pre{mouse,2})))/WakeDur.(Session_type{sess}).(Mouse_names{mouse});
                QW_HC_Time{sess}{mouse} = DurationEpoch(and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) ,...
                    Epoch1.sleep_pre{mouse,2}))/1e4;
                
                for bin=1:20
                    SmallEp = intervalSet((TotDur.(Session_type{sess}).(Mouse_names{mouse})/21)*(bin-1) , (TotDur.(Session_type{sess}).(Mouse_names{mouse})/21)*bin);
                    FreezeAll_Prop_bin{sess}(mouse,bin) = sum(DurationEpoch(and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , SmallEp)))/sum(DurationEpoch(SmallEp));
                end
            end
        end
    end
    disp(Mouse_names{mouse})
end

FreezeAll_Prop_All=[]; FreezeShock_Prop_All=[]; FreezeSafe_Prop_All=[];
for sess=1:4
    FreezeAll_Prop_All = [FreezeAll_Prop_All FreezeAll_Prop_bin{sess}];
    if sess~=2
        FreezeShock_Prop_All = [FreezeShock_Prop_All FreezeShock_Prop_bin{sess}];
        FreezeSafe_Prop_All = [FreezeSafe_Prop_All FreezeSafe_Prop_bin{sess}];
    end
end

FreezeAll_Time_All=[]; FreezeShock_Time_All=[]; FreezeSafe_Time_All=[]; QW_HC_Time_All=[];
for sess=1:4
    try 
        for mouse=1:length(Mouse)
            FreezeAll_Time_All = [FreezeAll_Time_All ; FreezeAll_Time{sess}{mouse}];
            if sess~=2
                FreezeShock_Time_All = [FreezeShock_Time_All ; FreezeShock_Time{sess}{mouse}];
                FreezeSafe_Time_All = [FreezeSafe_Time_All ; FreezeSafe_Time{sess}{mouse}];
            else
                QW_HC_Time_All = [QW_HC_Time_All ; QW_HC_Time{sess}{mouse}];
            end
        end
    end
end


FreezeAll_Prop_All(nanmean(FreezeAll_Prop_All')==0,:)=NaN;
FreezeShock_Prop_All(nanmean(FreezeShock_Prop_All')==0,:)=NaN;
FreezeSafe_Prop_All(nanmean(FreezeSafe_Prop_All')==0,:)=NaN;

for sess=1:4
    FreezeAll_Prop{sess}([1:13 25:26]) = NaN;
end

%% figures
Cols1 = {[.8 .8 .8],[.6 .6 .6],[.4 .4 .4],[.2 .2 .2]};
X = 1:4; X2 = 1:3;
Legends = {'Habituation','Sleep Pre','Conditionning','Recall'};
Legends2 = {'Habituation','Conditionning','Recall'};
Cols2 = {[1 .8 .8],[1 .4 .4],[1 .2 .2]};
Cols3 = {[.8 .8 1],[.4 .4 1],[.2 .2 1]};
NoLegends = {'','','',''};
NoLegends2 = {'','',''};

figure
subplot(355)
PlotErrorBarN_KJ(FreezeAll_Prop,'barcolors',{[.5 .5 .5]},'paired',0,'newfig',0)
xticks([1:4]), xticklabels(Legends), xtickangle(45)
% MakeSpreadAndBoxPlot3_SB(FreezeAll_Prop,Cols1,X,Legends,'showpoints',0,'paired',1);
ylabel('freezing proportion'), ylim([0 .85])
makepretty_BM2

subplot(3,5,10)
PlotErrorBarN_KJ(FreezeShock_Prop([1 3 4]),'barcolors',{[1 .5 .5]},'paired',0,'newfig',0)
xticks([1:4]), xticklabels(NoLegends2), xtickangle(45)
% MakeSpreadAndBoxPlot3_SB(FreezeShock_Prop([1 3 4]),Cols2,X2,NoLegends2,'showpoints',0,'paired',1);
ylabel('freezing proportion'),ylim([0 .85])
makepretty_BM2

subplot(3,5,15)
PlotErrorBarN_KJ(FreezeSafe_Prop([1 3 4]),'barcolors',{[.5 .5 1]},'paired',0,'newfig',0)
xticks([1:4]), xticklabels(Legends2), xtickangle(45)
% MakeSpreadAndBoxPlot3_SB(FreezeSafe_Prop([1 3 4]),Cols3,X2,Legends2,'showpoints',0,'paired',1);
ylabel('freezing proportion'), ylim([0 .85])
makepretty_BM2


subplot(3,5,1:4)
Data_to_use = FreezeAll_Prop_All;
Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
b=bar(Mean_All_Sp); b.FaceColor=[.5 .5 .5]; hold on
errorbar([1:60],Mean_All_Sp,zeros(size(Conf_Inter)),Conf_Inter,'.','vertical','Color','k')
ylim([0 .45])
box off
ylabel('freezing proportion')
makepretty_BM2
vline([40.5 60.5],'--k'), line([20.5 20.5],[0 .3],'LineStyle','--','Color','k'), text(15,.35,'first aversive stimulation')
text(6,.45,'Habituation','FontSize',15), text(26,.45,'Awake in homecage','FontSize',15), text(46,.45,'Conditioning','FontSize',15)
text(66,.45,'Recall','FontSize',15)

subplot(3,5,6:9)
Data_to_use = FreezeShock_Prop_All;
Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
b=bar([1:60],Mean_All_Sp); b.FaceColor=[1 .5 .5]; hold on
errorbar([1:60],Mean_All_Sp,zeros(size(Conf_Inter)),Conf_Inter,'.','vertical','Color','k')
ylim([0 .45])
box off
ylabel('freezing proportion')
makepretty_BM2
vline([40.5 60.5],'--k'), line([20.5 20.5],[0 .2],'LineStyle','--','Color','k')

subplot(3,5,11:14)
Data_to_use = FreezeSafe_Prop_All;
Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
b=bar([1:60],Mean_All_Sp); b.FaceColor=[.5 .5 1]; hold on
errorbar([1:60],Mean_All_Sp,zeros(size(Conf_Inter)),Conf_Inter,'.','vertical','Color','k')
ylim([0 .45])
box off
xlabel('time (norm)'), ylabel('freezing proportion')
makepretty_BM2
vline([40.5 60.5],'--k'), line([20.5 20.5],[0 .2],'LineStyle','--','Color','k')



% Freezing duration
FreezeAll_Time_All(FreezeAll_Time_All>30)=NaN;
FreezeShock_Time_All(or(FreezeShock_Time_All>30 , FreezeShock_Time_All<2))=NaN;
FreezeSafe_Time_All(or(FreezeSafe_Time_All>30 , FreezeSafe_Time_All<2))=NaN;

figure
[theText, rawN, x] = nhist({FreezeShock_Time_All FreezeSafe_Time_All});
f=get(gca,'Children');
for i=[1:5 11:14], f(i).Color=[1 .5 .5]; end
for i=[6:10 15:18], f(i).Color=[.5 .5 1]; end
xlabel('freezing time (s)'), ylabel('episodes number (proportion)')
makepretty_BM2




%% no fz safe before stim
Mouse = Drugs_Groups_UMaze_BM(11);
DATA_train = load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_all_CondPost_2sFullBins.mat');
Params = DATA_train.Params;
DATA_test = load('/media/nas7/ProjetEmbReact/DataEmbReact/Decode_Safe.mat','DATA');
DATA_sleep = load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Sleep_Saline.mat');

Session_type = {'Hab','sleep_pre','Cond','Ext'};


for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    try
        clear DATA2
        for par=[1:5 7 8]
            DATA2(par,:) = (DATA_train.OutPutData.CondPost.(Params{par}).mean(mouse,6)-nanmean(DATA_test.DATA.Hab.(Mouse_names{mouse})(par,:)))/nanstd(DATA_test.DATA.Hab.(Mouse_names{mouse})(par,:));
        end
        for sess=1:length(Session_type)
            try
                clear D X Y
                if sess~=2
                    X = (DATA_test.DATA.(Session_type{sess}).(Mouse_names{mouse})([1:5 7 8],:)-nanmean(DATA_test.DATA.Hab.(Mouse_names{mouse})([1:5 7 8],:)')')./nanstd(DATA_test.DATA.Hab.(Mouse_names{mouse})([1:5 7 8],:)')';
                else
                    D = DATA_sleep.DATA.(Session_type{sess}).(Mouse_names{mouse})([1:5 7 8],DATA_sleep.DATA.(Session_type{sess}).(Mouse_names{mouse})(10,:)==1); % only select wake
                    X = (D-nanmean(DATA_test.DATA.Hab.(Mouse_names{mouse})([1:5 7 8],:)')')./nanstd(DATA_test.DATA.Hab.(Mouse_names{mouse})([1:5 7 8],:)')';
                end
                Y = DATA2;
                
                if sum(isnan(Y))==0
                    ind_shock = DATA_test.DATA.(Session_type{sess}).(Mouse_names{mouse})(9,:)<.3;
                    ind_safe = DATA_test.DATA.(Session_type{sess}).(Mouse_names{mouse})(9,:)>.5;
                    
                    X_shock = (DATA_test.DATA.(Session_type{sess}).(Mouse_names{mouse})([1:5 7 8],ind_shock)-nanmean(DATA_test.DATA.Hab.(Mouse_names{mouse})([1:5 7 8],:)')')./nanstd(DATA_test.DATA.Hab.(Mouse_names{mouse})([1:5 7 8],:)')';
                    X_safe = (DATA_test.DATA.(Session_type{sess}).(Mouse_names{mouse})([1:5 7 8],ind_safe)-nanmean(DATA_test.DATA.Hab.(Mouse_names{mouse})([1:5 7 8],:)')')./nanstd(DATA_test.DATA.Hab.(Mouse_names{mouse})([1:5 7 8],:)')';
                    
                    ind = ~isnan(DATA2([1:5 7 8]));
                    for i=1:size(DATA_test.DATA.(Session_type{sess}).(Mouse_names{mouse}),2)
                        
                        [R{mouse}{sess}(i), ~] = corr(X(ind,i) , Y(ind));
                        clear Dist
                        for j=[3 6 7]
                            Dist(j) = abs(X(j,i)-Y(j));
                        end
                        Dist2{mouse}{sess}(i) = sum(Dist);
                    end
                    R{mouse}{sess}(or(R{mouse}{sess}==0 , R{mouse}{sess}==1)) = NaN;
                    if sess~=2
                        R_shock{mouse}{sess} = R{mouse}{sess}(ind_shock);
                        R_safe{mouse}{sess} = R{mouse}{sess}(ind_safe);
                    end
                end
            end
        end
        disp(Mouse_names{mouse})
    end
end


for sess=1:length(Session_type)
    n=0;
    for mouse=1:47
        
        try
            n=n+1;
            bin_size = round(length(R{mouse}{sess})/20);
            for i=1:20
                try
                    
                    BIN_corr(sess,n,i) = sum(R{mouse}{sess}((i-1)*bin_size+1:i*bin_size)>.9)./bin_size;
                    BIN_corr2(sess,n,i) = nanmean(R{mouse}{sess}((i-1)*bin_size+1:i*bin_size))./bin_size;
                    
                end
            end
        end
    end
end
% BIN_corr(BIN_corr==0)=NaN;

BIN_corr_all=[]; BIN_corr_all2=[];
for sess=1:4
    BIN_corr_all = [BIN_corr_all squeeze(BIN_corr(sess,:,:))];
    BIN_corr_all2 = [BIN_corr_all2 squeeze(BIN_corr2(sess,:,:))];
    
    for mouse=1:length(Mouse)
        try, h=histogram(R{mouse}{sess},'BinLimits',[-1 1],'NumBins',100);
            HistData{sess}(mouse,:) = h.Values./sum(h.Values); end
        try, h=histogram(R_shock{mouse}{sess},'BinLimits',[-1 1],'NumBins',100);
            HistData_Shock{sess}(mouse,:) = h.Values./sum(h.Values); end
        try, h=histogram(R_safe{mouse}{sess},'BinLimits',[-1 1],'NumBins',100);
            HistData_Safe{sess}(mouse,:) = h.Values./sum(h.Values); end
        
        try, h=histogram(Dist2{mouse}{sess},'BinLimits',[0 32],'NumBins',100);
            HistData2{sess}(mouse,:) = h.Values./sum(h.Values); end
    end
    HistData2{sess}(nanmean(HistData2{sess}')==0,:) = NaN;
end


BIN_corr_all(nanmean(BIN_corr_all')==0,:)=NaN;

figure
subplot(1,5,1:4)
Data_to_use = BIN_corr_all;
Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
b=bar([1:20 41:80],Mean_All_Sp(:,[1:20 41:80])); b.FaceColor=[.5 .5 1]; hold on
errorbar([1:20 41:80],Mean_All_Sp(:,[1:20 41:80]),zeros(size(Conf_Inter([1:20 41:80]))),Conf_Inter([1:20 41:80]),'.','vertical','Color','k')
ylim([0 .55])
box off
y=ylabel('proportion body state matching safe freezing'); y.FontSize = 10; xlabel('time (norm)')
makepretty_BM2
vline([40.5],'--k'), line([20.5 20.5],[0 .2],'LineStyle','--','Color','k'), 
% text(15,.25,'first aversive stimulation')
% text(6,.35,'Habituation','FontSize',15), text(26,.35,'Conditionning','FontSize',15), text(46,.35,'Recall','FontSize',15)


X = 1:3;
Legends = {'Habituation','Conditionning','Recall'};
Cols3 = {[.7 .7 1],[.5 .5 1],[.3 .3 1]};

subplot(155)
PlotErrorBarN_KJ({nanmean(BIN_corr_all(:,1:20)') nanmean(BIN_corr_all(:,41:60)') nanmean(BIN_corr_all(:,61:80)')},'barcolors',{[.5 .5 1]},'paired',0,'newfig',0)
xticks([1:4]), xticklabels(Legends2), xtickangle(45)
% MakeSpreadAndBoxPlot3_SB({nanmean(BIN_corr_all(:,1:20)') nanmean(BIN_corr_all(:,41:60)') nanmean(BIN_corr_all(:,61:80)')},Cols3,X,Legends,'showpoints',0,'paired',1);
ylabel('freezing proportion'), ylim([0 .85])
makepretty_BM2



for i=1:100
    X(i) = exp(sqrt(i));
end

figure
stairs(1-linspace(0,1,100) , runmean(HistData{1},3) , 'LineWidth' ,2 , 'Color' , 'k'), hold on
stairs(1-linspace(0,1,100) , runmean(HistData{2},3) , 'LineWidth' ,2 , 'Color' , 'r')
stairs(1-linspace(0,1,100) , runmean(HistData{3},3) , 'LineWidth' ,2 , 'Color' , 'b')
stairs(1-linspace(0,1,100) , runmean(HistData{4},3) , 'LineWidth' ,2 , 'Color' , 'g')
xticks([1e-2 1e-1 1]), xticklabels({'1','0.9','0'})
xlabel('R values (log scale)'), ylabel('#')
legend('Habituation','Cond','Recall')
set(gca,'XDir','reverse'); box off

figure
stairs(linspace(0,1,100) , runmean(HistData{1},3) , 'LineWidth' ,2 , 'Color' , 'k'), hold on
stairs(linspace(0,1,100) , runmean(HistData{2},3) , 'LineWidth' ,2 , 'Color' , 'r')
stairs(linspace(0,1,100) , runmean(HistData{3},3) , 'LineWidth' ,2 , 'Color' , 'b')
legend('Habituation','Cond','Recall')


figure
subplot(211)
stairs(linspace(-1,1,100) , runmean(HistData_Shock{1},3) , 'LineWidth' ,2 , 'Color' , 'k'), hold on
stairs(linspace(-1,1,100) , runmean(HistData_Shock{2},3) , 'LineWidth' ,2 , 'Color' , 'r')
stairs(linspace(-1,1,100) , runmean(HistData_Shock{3},3) , 'LineWidth' ,2 , 'Color' , 'b')
ylabel('#'), axis square
legend('Habituation','Cond','Recall')
box off

subplot(212)
stairs(linspace(-1,1,100) , runmean(HistData_Safe{1},3) , 'LineWidth' ,2 , 'Color' , 'k'), hold on
stairs(linspace(-1,1,100) , runmean(HistData_Safe{2},3) , 'LineWidth' ,2 , 'Color' , 'r')
stairs(linspace(-1,1,100) , runmean(HistData_Safe{3},3) , 'LineWidth' ,2 , 'Color' , 'b')
xlabel('R values'), ylabel('#'), axis square
box off

xticks([1e-2 1e-1 1]), xticklabels({'1','0.9','0'})
xlabel('R values'), ylabel('#')
legend('Habituation','Cond','Recall')
set(gca,'XDir','reverse'); box off




%% distance
for param=1:8
  P_perMouse(:,param,:) = [Sleep.OutPutData.sleep_pre.(Params{param}).mean(:,3) Fear.OutPutData.Fear.(Params{param}).mean(:,5)...
        Fear.OutPutData.Fear.(Params{param}).mean(:,6)];
end


figure
for mouse=1:length(Mouse)
    % sleep with sleep
    try
        clear Param_bin2s R_val
        R = Range(Sleep.OutPutData.sleep_pre.respi_freq_bm.tsd{mouse,3});
        D = Data(Sleep.OutPutData.sleep_pre.respi_freq_bm.tsd{mouse,3});
        
        Par = tsd(R(1:10:end) , D(1:10:end));
        for param = 1:8
            Param_bin2s{mouse}(param,:) = Data(Restrict(Sleep.OutPutData.sleep_pre.(Params{param}).tsd{mouse,3} , Par));
        end
        for i=1:size(Param_bin2s{mouse},2)
            %         D = Data(Param_bin2s{mouse,param});
            %             Dist{mouse,param}(i) = abs(D(i) - Fear.OutPutData.Fear.(Params{param}).mean(mouse,5));
            %         X = (Param_bin2s{mouse}(:,i)-nanmean(squeeze(P_perMouse(mouse,:,:))')')./nanstd(squeeze(P_perMouse(mouse,:,:))')';
            %         Y = (squeeze(P_perMouse(mouse,:,1)')-nanmean(squeeze(P_perMouse(mouse,:,:))')')./nanstd(squeeze(P_perMouse(mouse,:,:))')';
            X = (Param_bin2s{mouse}(:,i)-nanmean(squeeze(P_perMouse(mouse,:,:))')');
            Y = (squeeze(P_perMouse(mouse,:,1)')-nanmean(squeeze(P_perMouse(mouse,:,:))')');
            [R_val{mouse}(i),~] = corr(X , Y);
        end
        R_val{mouse}(or(R_val{mouse}==0 , R_val{mouse}==1))=NaN;
        h=histogram(R_val{mouse},'BinLimits',[-1 1],'NumBins',100);
        HistData_Sleep_on_Sleep(mouse,:) = h.Values./sum(h.Values);
        R_val_Over90_Sleep_on_Sleep(mouse,:) = sum(R_val{mouse}>.9)/sum(~isnan(R_val{mouse}));
    end
    
    % Fz shock with sleep
    try
        clear Param_bin2s R_val
        R = Range(Fear.OutPutData.Fear.respi_freq_bm.tsd{mouse,5});
        D = Data(Fear.OutPutData.Fear.respi_freq_bm.tsd{mouse,5});
        
        Par = tsd(R(1:10:end) , D(1:10:end));
        for param = 1:8
            Param_bin2s{mouse}(param,:) = Data(Restrict(Fear.OutPutData.Fear.(Params{param}).tsd{mouse,5} , Par));
        end
        for i=1:size(Param_bin2s{mouse},2)
            X = (Param_bin2s{mouse}(:,i)-nanmean(squeeze(P_perMouse(mouse,:,:))')');
            Y = (squeeze(P_perMouse(mouse,:,1)')-nanmean(squeeze(P_perMouse(mouse,:,:))')');
            [R_val{mouse}(i),~] = corr(X , Y);
        end
        R_val{mouse}(or(R_val{mouse}==0 , R_val{mouse}==1))=NaN;
        h=histogram(R_val{mouse},'BinLimits',[-1 1],'NumBins',100);
        HistData_FzShock_on_Sleep(mouse,:) = h.Values./sum(h.Values);
        R_val_Over90_FzShock_on_Sleep(mouse,:) = sum(R_val{mouse}>.9)/sum(~isnan(R_val{mouse}));
    end
    
    % Fz safe with sleep
    try
        clear Param_bin2s R_val
        R = Range(Fear.OutPutData.Fear.respi_freq_bm.tsd{mouse,6});
        D = Data(Fear.OutPutData.Fear.respi_freq_bm.tsd{mouse,6});
        
        Par = tsd(R(1:10:end) , D(1:10:end));
        for param = 1:8
            Param_bin2s{mouse}(param,:) = Data(Restrict(Fear.OutPutData.Fear.(Params{param}).tsd{mouse,6} , Par));
        end
        for i=1:size(Param_bin2s{mouse},2)
            X = (Param_bin2s{mouse}(:,i)-nanmean(squeeze(P_perMouse(mouse,:,:))')');
            Y = (squeeze(P_perMouse(mouse,:,1)')-nanmean(squeeze(P_perMouse(mouse,:,:))')');
            [R_val{mouse}(i),~] = corr(X , Y);
        end
        R_val{mouse}(or(R_val{mouse}==0 , R_val{mouse}==1))=NaN;
        h=histogram(R_val{mouse},'BinLimits',[-1 1],'NumBins',100);
        HistData_FzSafe_on_Sleep(mouse,:) = h.Values./sum(h.Values);
        R_val_Over90_FzSafe_on_Sleep(mouse,:) = sum(R_val{mouse}>.9)/sum(~isnan(R_val{mouse}));
    end
    disp(mouse)
end
close
ind = or( or(or(nanmean(HistData_Sleep_on_Sleep')==0 , nanmean(HistData_FzShock_on_Sleep')==0) , nanmean(R_val_Over90_FzSafe_on_Sleep')==0) ,...
or(or(isnan(nanmean(HistData_Sleep_on_Sleep')) , isnan(nanmean(HistData_FzShock_on_Sleep'))) , isnan(nanmean(R_val_Over90_FzSafe_on_Sleep'))));

figure
Data_to_use = HistData_Sleep_on_Sleep;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(-1,1,100) , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
Data_to_use = HistData_FzShock_on_Sleep;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(-1,1,100) , Mean_All_Sp , Conf_Inter ,'-r',1); hold on;
Data_to_use = HistData_FzSafe_on_Sleep;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(-1,1,100) , Mean_All_Sp , Conf_Inter ,'-b',1); hold on;


X = [1:3];

figure
MakeSpreadAndBoxPlot3_SB({R_val_Over90_Sleep_on_Sleep(~ind) R_val_Over90_FzShock_on_Sleep(~ind) R_val_Over90_FzSafe_on_Sleep(~ind)},...
    Cols,X,Legends,'showpoints',0,'paired',1);






