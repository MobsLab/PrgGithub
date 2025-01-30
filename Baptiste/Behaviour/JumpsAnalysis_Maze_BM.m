

clear all

GetAllSalineSessions_BM
smootime=.2;
Session_type={'Cond','Ext','Fear'};
Group=1;

for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for sess=1%:length(Session_type)
            
            Sessions_List_ForLoop_BM
            try
                Acc_TestPre.(Mouse_names{mouse}) = ConcatenateDataFromFolders_BM(TestPreSess.(Mouse_names{mouse}) , 'accelero');
                Acc_TestPre_smooth.(Mouse_names{mouse}) = tsd(Range(Acc_TestPre.(Mouse_names{mouse})) , runmean_BM(Data(Acc_TestPre.(Mouse_names{mouse})),ceil(smootime/median(diff(Range(Acc_TestPre.(Mouse_names{mouse}),'s'))))));
                clear thr; thr = percentile(Data(Acc_TestPre_smooth.(Mouse_names{mouse})),99.95);
                
                Acc.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_BM(FolderList.(Mouse_names{mouse}) , 'accelero');
                Acc_smooth.(Session_type{sess}).(Mouse_names{mouse}) = tsd(Range(Acc.(Session_type{sess}).(Mouse_names{mouse})) , runmean(Data(Acc.(Session_type{sess}).(Mouse_names{mouse})),ceil(smootime/median(diff(Range(Acc.(Session_type{sess}).(Mouse_names{mouse}),'s'))))));
                StimEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_BM(FolderList.(Mouse_names{mouse}) , 'epoch' , 'epochname' , 'stimepoch');
                AfterStim.(Session_type{sess}).(Mouse_names{mouse}) = intervalSet(Start(StimEpoch.(Session_type{sess}).(Mouse_names{mouse})) , Start(StimEpoch.(Session_type{sess}).(Mouse_names{mouse}))+1e4);
                TotEpoch.(Session_type{sess}).(Mouse_names{mouse}) = intervalSet(0,max(Range(Acc.(Session_type{sess}).(Mouse_names{mouse}))));
                No_StimEpoch.(Session_type{sess}).(Mouse_names{mouse}) = TotEpoch.(Session_type{sess}).(Mouse_names{mouse})-AfterStim.(Session_type{sess}).(Mouse_names{mouse});
                BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_BM(FolderList.(Mouse_names{mouse}) , 'epoch' , 'epochname' , 'blockedepoch');
                UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) = TotEpoch.(Session_type{sess}).(Mouse_names{mouse})-BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse});
                ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_BM(FolderList.(Mouse_names{mouse}) , 'epoch' , 'epochname' , 'zoneepoch');
                ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){1};
                SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = or(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){2} , ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){5});
                FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_BM(FolderList.(Mouse_names{mouse}) , 'epoch' , 'epochname' , 'freezeepoch');
                ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}) = TotEpoch.(Session_type{sess}).(Mouse_names{mouse})-FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse});
                
                % exclude moments after stims to detect jumps
                Acc_smooth2.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Acc_smooth.(Session_type{sess}).(Mouse_names{mouse}) , No_StimEpoch.(Session_type{sess}).(Mouse_names{mouse}));
                
                JumpEp.(Session_type{sess}).(Mouse_names{mouse}) = thresholdIntervals(Acc_smooth2.(Session_type{sess}).(Mouse_names{mouse}),thr,'Direction','Above');
                JumpEp.(Session_type{sess}).(Mouse_names{mouse}) = dropLongIntervals(JumpEp.(Session_type{sess}).(Mouse_names{mouse}),4*1e4);
                JumpEp.(Session_type{sess}).(Mouse_names{mouse}) = mergeCloseIntervals(JumpEp.(Session_type{sess}).(Mouse_names{mouse}),0.5*1e4);
                
                JumpEp_Unblocked.(Session_type{sess}).(Mouse_names{mouse}) = and(UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) , JumpEp.(Session_type{sess}).(Mouse_names{mouse}));
                
                TotEpochDuration.(Session_type{sess}).(Mouse_names{mouse}) = sum(DurationEpoch(TotEpoch.(Session_type{sess}).(Mouse_names{mouse})))/1e4;
                TotEpochDuration_Shock.(Session_type{sess}).(Mouse_names{mouse}) = sum(DurationEpoch(and(TotEpoch.(Session_type{sess}).(Mouse_names{mouse}) , ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}))))/1e4;
                TotEpochDuration_Safe.(Session_type{sess}).(Mouse_names{mouse}) = sum(DurationEpoch(and(TotEpoch.(Session_type{sess}).(Mouse_names{mouse}) , SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}))))/1e4;
                TotDuration_Active.(Session_type{sess}).(Mouse_names{mouse}) = sum(DurationEpoch(ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse})))/1e4;
                TotDuration_Active_Shock.(Session_type{sess}).(Mouse_names{mouse}) = sum(DurationEpoch(and(ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}) , ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}))))/1e4;
                TotDuration_Active_Safe.(Session_type{sess}).(Mouse_names{mouse}) = sum(DurationEpoch(and(ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}) , SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}))))/1e4;
                
                LinearDist.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_BM(FolderList.(Mouse_names{mouse}) , 'linearposition');
                LinearDist_WhenJump.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(LinearDist.(Session_type{sess}).(Mouse_names{mouse}) , JumpEp.(Session_type{sess}).(Mouse_names{mouse}));
                LinearDist_WhenJump_Unblocked.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(LinearDist.(Session_type{sess}).(Mouse_names{mouse}) , JumpEp_Unblocked.(Session_type{sess}).(Mouse_names{mouse}));
            end
        end
        disp(Mouse_names{mouse})
    end
end


n=1;
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse = 1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for sess=1:length(Session_type) % generate all data required for analyses
            try
                h=histogram(Data(LinearDist_WhenJump.(Session_type{sess}).(Mouse_names{mouse})),'BinLimits',[0 1],'NumBins',25);
                JumpsDistrib.(Session_type{sess}){n}(mouse,:) = h.Values;
                
                h=histogram(Data(LinearDist_WhenJump_Unblocked.(Session_type{sess}).(Mouse_names{mouse})),'BinLimits',[0 1],'NumBins',25);
                Jumps_Unblocked.(Session_type{sess}){n}(mouse,:) = h.Values;
            end
            try
                if sum(JumpsDistrib.(Session_type{sess}){n}(mouse,:)) ==0
                    JumpsDistrib.(Session_type{sess}){n}(mouse,:) = NaN;
                    Jumps_Unblocked.(Session_type{sess}){n}(mouse,:) = NaN;
                end
            end
        end
    end
    n=n+1;
end

save('/media/nas7/ProjetEmbReact/DataEmbReact/BehaviourAlongMaze.mat','JumpsDistrib','-append')


%%
n=1;
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for sess=1%:length(Session_type)
            
            Jumps_Numb.(Session_type{sess}){n}(mouse) = length(Start(JumpEp.(Session_type{sess}).(Mouse_names{mouse})));
            Jumps_Numb_Shock.(Session_type{sess}){n}(mouse) = length(Start(and(JumpEp.(Session_type{sess}).(Mouse_names{mouse}) , ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}))));
            Jumps_Numb_Safe.(Session_type{sess}){n}(mouse) = length(Start(and(JumpEp.(Session_type{sess}).(Mouse_names{mouse}) , SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}))));
            
            Jumps_Density.(Session_type{sess}){n}(mouse) = length(Start(JumpEp.(Session_type{sess}).(Mouse_names{mouse})))./(TotEpochDuration.(Session_type{sess}).(Mouse_names{mouse})/60);
            Jumps_Density_Shock.(Session_type{sess}){n}(mouse) = length(Start(JumpEp.(Session_type{sess}).(Mouse_names{mouse})))./(TotEpochDuration_Shock.(Session_type{sess}).(Mouse_names{mouse})/60);
            Jumps_Density_Safe.(Session_type{sess}){n}(mouse) = length(Start(JumpEp.(Session_type{sess}).(Mouse_names{mouse})))./(TotEpochDuration_Safe.(Session_type{sess}).(Mouse_names{mouse})/60);
            
            Jumps_Density_ByMinActive.(Session_type{sess}){n}(mouse) = length(Start(JumpEp.(Session_type{sess}).(Mouse_names{mouse})))./(TotDuration_Active.(Session_type{sess}).(Mouse_names{mouse})/60);
            Jumps_Density_ByMinActive_Shock.(Session_type{sess}){n}(mouse) = length(Start(JumpEp.(Session_type{sess}).(Mouse_names{mouse})))./(TotDuration_Active_Shock.(Session_type{sess}).(Mouse_names{mouse})/60);
            Jumps_Density_ByMinActive_Safe.(Session_type{sess}){n}(mouse) = length(Start(JumpEp.(Session_type{sess}).(Mouse_names{mouse})))./(TotDuration_Active_Safe.(Session_type{sess}).(Mouse_names{mouse})/60);
            
        end
    end
    n=n+1;
end

n=1;
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
%         Jumps_Density_ByMinActive.After_Sess{n}(mouse) = (length(Start(JumpEp.(Session_type{7}).(Mouse_names{mouse}))) + length(Start(JumpEp.(Session_type{3}).(Mouse_names{mouse}))))...
%             ./((TotDuration_Active.(Session_type{7}).(Mouse_names{mouse}) + TotDuration_Active.(Session_type{3}).(Mouse_names{mouse}))/60);
        Jumps_Density_ByMinActive.After_Sess{n}(mouse) = length(Start(JumpEp.(Session_type{1}).(Mouse_names{mouse})))...
            ./(TotDuration_Active.(Session_type{1}).(Mouse_names{mouse}));
        
    end
    n=n+1;
end



%%
load('/media/nas6/ProjetEmbReact/DataEmbReact/Create_Behav_Drugs_BM.mat','FreezingTime','FreezingProportion')

sess=1; clear Jumps_Tot Freezing_Tot JumpsDensity_Tot FreezingProportionShock_Tot FreezingProportionSafe_Tot
Jumps_Tot.(Session_type{sess})=[]; Freezing_Tot.(Session_type{sess})=[]; JumpsDensity_Tot.(Session_type{sess})=[];
FreezingProportionShock_Tot.(Session_type{sess})=[]; FreezingProportionSafe_Tot.(Session_type{sess})=[];
for group=1:6
    Jumps_Tot.(Session_type{sess}) = [Jumps_Tot.(Session_type{sess}) ; Jumps_Numb.(Session_type{sess}){group}'];
    Freezing_Tot.(Session_type{sess}) = [Freezing_Tot.(Session_type{sess}) ; FreezingTime.Figure.All.(Session_type{sess}){group}];
    JumpsDensity_Tot.(Session_type{sess}) = [JumpsDensity_Tot.(Session_type{sess}) ; Jumps_Density_ByMinActive.(Session_type{sess}){group}'];
    FreezingProportionShock_Tot.(Session_type{sess}) = [FreezingProportionShock_Tot.(Session_type{sess}) ; FreezingProportion.Figure.Shock.(Session_type{sess}){group}];
    FreezingProportionSafe_Tot.(Session_type{sess}) = [FreezingProportionSafe_Tot.(Session_type{sess}) ; FreezingProportion.Figure.Safe.(Session_type{sess}){group}];
end

%% figures
Cols = {[0, 0, 1],[1, 0, 0],[1, 0.5, 0.5],[0, 0.5, 0],[0.3, 0.745, 0.93],[0.85, 0.325, 0.098],[0.2, 0.645, 0.83],[0.75, 0.225, 0]};
X = [1:8];
Legends={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','RipControl','RipInhib','Saline1','Saline2','DZP1','DZP2','RipInhib','ChronicBUS','AcuteBUS','RipControl','RipInhib1','RipControl1','RipInhibPaired','RipControlPaired','Sal_Maze1_1stMaze','Sal_Maze4_1stMaze','DZP_Maze1_1stMaze','DZP_Maze4_1stMaze'};
NoLegends = {'','','','','','','','',''};

Cols2 = {[0, 0, 1],[1, 0, 0]};
X2 = [1:2];
Legends2={'SalineSB','ChronicFlx'};
NoLegends = {'','','','','','','','',''};


figure; n=1;
for sess=[6 2 7 3]
    subplot(1,4,n)
    MakeSpreadAndBoxPlot2_SB(Jumps_Numb.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0);
    if n==1; ylabel('#'); end
    title(Session_type{sess})
    ylim([0 350])
    
    n=n+1;
end
a=suptitle('Jumps total number, Maze experiments'); a.FontSize=20;

figure; n=1;
for sess=[2 7 3]
    %     subplot(2,3,n)
    %     MakeSpreadAndBoxPlot2_SB(Jumps_Density.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0);
    %     if n==1; ylabel('jumps/min of expe'); end
    %     title(Session_type{sess})
    %     ylim([0 3])
    %
    subplot(1,3,n)
    MakeSpreadAndBoxPlot2_SB(Jumps_Density_ByMinActive.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0);
    if n==1; ylabel('jumps/min active'); end
    ylim([0 3])
    title(Session_type{sess})
    
    n=n+1;
end
a=suptitle('Jumps density, Maze experiments'); a.FontSize=20;


figure
MakeSpreadAndBoxPlot2_SB(Jumps_Density_ByMinActive.After_Sess,Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('jumps/min active'), ylim([0 1.4])
u=text(1.2,1.2,'p = 0.09'); set(u,'FontSize',15);
title('Jumps density, TestPost + Ext')


figure; n=1;
for sess=[2 7 3]
    subplot(2,3,n)
    MakeSpreadAndBoxPlot2_SB(Jumps_Numb_Shock.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if n==1; ylabel('jumps shock side (#)'); end
    title(Session_type{sess})
    ylim([0 120])
    
    subplot(2,3,n+3)
    MakeSpreadAndBoxPlot2_SB(Jumps_Numb_Safe.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0);
    if n==1; ylabel('jumps safe side (#)'); end
    ylim([0 80])
    n=n+1;
end
a=suptitle('Jumps number, Maze experiments'); a.FontSize=20;


figure; n=1;
for sess=[2 7 3]
    subplot(2,3,n)
    MakeSpreadAndBoxPlot2_SB(Jumps_Density_Shock.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if n==1; ylabel('jumps shock side (#)'); end
    title(Session_type{sess})
    %     ylim([0 120])
    
    subplot(2,3,n+3)
    MakeSpreadAndBoxPlot2_SB(Jumps_Density_Safe.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0);
    if n==1; ylabel('jumps safe side (#)'); end
    %     ylim([0 80])
    n=n+1;
end
a=suptitle('Jumps number, Maze experiments'); a.FontSize=20;


figure; n=1;
for sess=[2 7 3]
    subplot(2,3,n)
    MakeSpreadAndBoxPlot2_SB(Jumps_Density_ByMinActive_Shock.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if n==1; ylabel('jumps/min of active shock'); end
    title(Session_type{sess})
    %     ylim([0 3])
    
    subplot(2,3,n+3)
    MakeSpreadAndBoxPlot2_SB(Jumps_Density_ByMinActive_Safe.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0);
    if n==1; ylabel('jumps/min of active safe'); end
    %     ylim([0 3])
    
    n=n+1;
end
a=suptitle('Jumps density, Maze experiments'); a.FontSize=20;



Cols1 = {'-b','-r','-m','-g','-b','-r','-m','-g'};

figure; sess=1;
for group=1%:4
    Data_to_use = HistData.(Session_type{sess}){group}./(nansum(HistData.(Session_type{sess}){group}')');
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
    shadedErrorBar(linspace(0,1,25) , Mean_All_Sp , Conf_Inter ,Cols1{group},1); hold on;
end
makepretty
xlabel('linear distance (a.u.'), ylabel('jumps number (#)')
f=get(gca,'Children'); legend([f(13),f(9),f(5),f(1)],'Saline','Chronic Flx','Acute Flx','Midazolam');
title('Localisation of jumps, Cond sessions')


Jumps=HistData.Cond; save('/media/nas7/ProjetEmbReact/DataEmbReact/BehaviourAlongMaze.mat','Jumps','-append')



figure; sess=2;
Data_to_use = HistData.(Session_type{sess}){5};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(0,1,25) , Mean_All_Sp , Conf_Inter ,'-c',1); hold on;
Data_to_use = HistData.(Session_type{sess}){6};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(0,1,25) , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
h.mainLine.Color=[0.85, 0.325, 0.1]; h.patch.FaceColor=[0.85, 0.325, 0.1]; h.edge(1).Color=[0.85, 0.325, 0.1]; h.edge(2).Color=[0.85, 0.325, 0.1];
makepretty
xlabel('linear distance (a.u.'), ylabel('jumps number (#)')
f=get(gca,'Children'); legend([f(5),f(1)],'Saline','Diazepam');
title('Localisation of jumps, Cond sessions')



%% correlations
clear A; A=Jumps_Tot.Cond; A(A==0)=NaN;
clear B; B=JumpsDensity_Tot.Cond; B(B==0)=NaN;

figure
PlotCorrelations_BM(log10(Freezing_Tot.Cond) , A);
axis square
xlabel('freezing time (log scale)'), ylabel('jumps (#)')

figure
subplot(121)
PlotCorrelations_BM(FreezingProportionShock_Tot.(Session_type{sess}) , B);
axis square
xlabel('shock freezing proportion'), ylabel('jumps density (#/min active)')

subplot(122)
PlotCorrelations_BM(FreezingProportionSafe_Tot.(Session_type{sess}) , B);
axis square
xlabel('safe freezing proportion'), ylabel('jumps density (#/min active)')



