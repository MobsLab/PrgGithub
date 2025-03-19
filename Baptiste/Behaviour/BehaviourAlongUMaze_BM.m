
% Behaviour Along UMaze

clear all
GetAllSalineSessions_BM
Session_type={'Cond'};
Group=11;

smootime = .1;
bin_size = 20;

for sess=1:length(Session_type)
    Sessions_List_ForLoop_BM
    n=1;
    for group=Group
        Mouse=Drugs_Groups_UMaze_BM(group);
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            LinearDist.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'linearposition');
            try; Acc.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'accelero'); end
            Speed.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'speed');
            
            EpochLinDist.(Session_type{sess}).(Mouse_names{mouse}) = EpochFromLinDist(LinearDist.(Session_type{sess}).(Mouse_names{mouse}) , bin_size);
            
            TotEpoch.(Session_type{sess}).(Mouse_names{mouse}) = intervalSet(0,max(Range(LinearDist.(Session_type{sess}).(Mouse_names{mouse}))));
            BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'epoch' , 'epochname' , 'blockedepoch');
            UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) = TotEpoch.(Session_type{sess}).(Mouse_names{mouse})-BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse});
            FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','freezeepoch');
            ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'Epoch','epochname','zoneepoch');
            ShockZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){1};
            SafeZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = or(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){2},ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){5});
            
            % Linear distance and freezing
            try
                LinearDist_Fz.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(LinearDist.(Session_type{sess}).(Mouse_names{mouse}) , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}));
                LinearDist_Unblocked.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(LinearDist.(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}));
                LinearDist_FzUnblocked.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(LinearDist.(Session_type{sess}).(Mouse_names{mouse}) , and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse})));
                
                EpochLinDist_Fz.(Session_type{sess}).(Mouse_names{mouse}) = EpochFromLinDist(LinearDist_Fz.(Session_type{sess}).(Mouse_names{mouse}) , bin_size);
                for i=1:bin_size; EpochLinDist_Fz_prop.(Session_type{sess})(mouse,i) = sum(DurationEpoch(EpochLinDist_Fz.(Session_type{sess}).(Mouse_names{mouse}){i}))/sum(DurationEpoch(EpochLinDist.(Session_type{sess}).(Mouse_names{mouse}){i})); end
                for i=1:bin_size; EpochLinDist_Fz_prop2.(Session_type{sess})(mouse,i) = sum(and(Data(LinearDist_Fz.(Session_type{sess}).(Mouse_names{mouse}))>((i-1)/bin_size) , Data(LinearDist_Fz.(Session_type{sess}).(Mouse_names{mouse}))<(i/bin_size)))/...
                        sum(and(Data(LinearDist.(Session_type{sess}).(Mouse_names{mouse}))>((i-1)/bin_size) , Data(LinearDist.(Session_type{sess}).(Mouse_names{mouse}))<(i/bin_size))); end
            end
            
            % Risk asessment
            try
                try
                    RA.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}) , 'risk_assessment');
                    RA_grade.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}) , 'ra_grade');
                catch
                    RA_grade.(Session_type{sess}).(Mouse_names{mouse}) = NaN;
                end
                RA_number.(Session_type{sess}){n}(mouse) = sum(RA_grade.(Session_type{sess}).(Mouse_names{mouse}));
                LinearDist_WhenRA.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(LinearDist.(Session_type{sess}).(Mouse_names{mouse}) , RA.(Session_type{sess}).(Mouse_names{mouse}));
                
                EpochLinDist_RA.(Session_type{sess}).(Mouse_names{mouse}) = EpochFromLinDist(LinearDist_WhenRA.(Session_type{sess}).(Mouse_names{mouse}) , bin_size);
                for i=1:bin_size; EpochLinDist_RA_prop.(Session_type{sess})(mouse,i) = sum(DurationEpoch(EpochLinDist_RA.(Session_type{sess}).(Mouse_names{mouse}){i}))/sum(DurationEpoch(EpochLinDist.(Session_type{sess}).(Mouse_names{mouse}){i})); end
                for i=1:bin_size; EpochLinDist_RA_prop2.(Session_type{sess})(mouse,i) = sum(and(Data(LinearDist_WhenRA.(Session_type{sess}).(Mouse_names{mouse}))>((i-1)/bin_size) , Data(LinearDist_WhenRA.(Session_type{sess}).(Mouse_names{mouse}))<(i/bin_size)))/...
                        sum(and(Data(LinearDist.(Session_type{sess}).(Mouse_names{mouse}))>((i-1)/bin_size) , Data(LinearDist.(Session_type{sess}).(Mouse_names{mouse}))<(i/bin_size))); end
            end
            
            % Jumps
            try
                Acc_TestPre.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(TestPreSess.(Mouse_names{mouse}) , 'accelero');
                Acc_TestPre_smooth.(Mouse_names{mouse}) = tsd(Range(Acc_TestPre.(Mouse_names{mouse})) , runmean_BM(Data(Acc_TestPre.(Mouse_names{mouse})),ceil(smootime/median(diff(Range(Acc_TestPre.(Mouse_names{mouse}),'s'))))));
                clear thr; thr = percentile(Data(Acc_TestPre_smooth.(Mouse_names{mouse})),99.95);
                
                Acc_smooth.(Session_type{sess}).(Mouse_names{mouse}) = tsd(Range(Acc.(Session_type{sess}).(Mouse_names{mouse})) , runmean(Data(Acc.(Session_type{sess}).(Mouse_names{mouse})),ceil(smootime/median(diff(Range(Acc.(Session_type{sess}).(Mouse_names{mouse}),'s'))))));
                StimEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'epoch' , 'epochname' , 'stimepoch');
                AfterStim.(Session_type{sess}).(Mouse_names{mouse}) = intervalSet(Start(StimEpoch.(Session_type{sess}).(Mouse_names{mouse})) , Start(StimEpoch.(Session_type{sess}).(Mouse_names{mouse}))+1e4);
                No_StimEpoch.(Session_type{sess}).(Mouse_names{mouse}) = TotEpoch.(Session_type{sess}).(Mouse_names{mouse})-AfterStim.(Session_type{sess}).(Mouse_names{mouse});
                Acc_smooth2.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Acc_smooth.(Session_type{sess}).(Mouse_names{mouse}) , No_StimEpoch.(Session_type{sess}).(Mouse_names{mouse}));
                
                JumpEp.(Session_type{sess}).(Mouse_names{mouse}) = thresholdIntervals(Acc_smooth2.(Session_type{sess}).(Mouse_names{mouse}),thr,'Direction','Above');
                JumpEp.(Session_type{sess}).(Mouse_names{mouse}) = dropLongIntervals(JumpEp.(Session_type{sess}).(Mouse_names{mouse}),4*1e4);
                JumpEp.(Session_type{sess}).(Mouse_names{mouse}) = mergeCloseIntervals(JumpEp.(Session_type{sess}).(Mouse_names{mouse}),0.5*1e4);
                LinearDist_WhenJump.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(LinearDist.(Session_type{sess}).(Mouse_names{mouse}) , JumpEp.(Session_type{sess}).(Mouse_names{mouse}));
                
                EpochLinDist_Jumps.(Session_type{sess}).(Mouse_names{mouse}) = EpochFromLinDist(LinearDist_WhenJump.(Session_type{sess}).(Mouse_names{mouse}) , bin_size);
                for i=1:bin_size; EpochLinDist_Jumps_prop.(Session_type{sess})(mouse,i) = sum(DurationEpoch(EpochLinDist_Jumps.(Session_type{sess}).(Mouse_names{mouse}){i}))/sum(DurationEpoch(EpochLinDist.(Session_type{sess}).(Mouse_names{mouse}){i})); end
                for i=1:bin_size; EpochLinDist_Jumps_prop2.(Session_type{sess})(mouse,i) = sum(and(Data(LinearDist_WhenJump.(Session_type{sess}).(Mouse_names{mouse}))>((i-1)/bin_size) , Data(LinearDist_WhenJump.(Session_type{sess}).(Mouse_names{mouse}))<(i/bin_size)))/...
                        sum(and(Data(LinearDist.(Session_type{sess}).(Mouse_names{mouse}))>((i-1)/bin_size) , Data(LinearDist.(Session_type{sess}).(Mouse_names{mouse}))<(i/bin_size))); end
            end
            
            % Grooming
            try
                Acc_smooth_bis.(Session_type{sess}).(Mouse_names{mouse}) = tsd(Range(Acc.(Session_type{sess}).(Mouse_names{mouse})) , runmean(Data(Acc.(Session_type{sess}).(Mouse_names{mouse})),30));
                Speed_Smooth.(Session_type{sess}).(Mouse_names{mouse}) = tsd(Range(Speed.(Session_type{sess}).(Mouse_names{mouse})) , runmean(Data(Speed.(Session_type{sess}).(Mouse_names{mouse})),ceil(1/median(diff(Range(Speed.(Session_type{sess}).(Mouse_names{mouse}),'s'))))));
                LinearDist_smooth.(Session_type{sess}).(Mouse_names{mouse}) = tsd(Range(LinearDist.(Session_type{sess}).(Mouse_names{mouse})) , runmean(Data(LinearDist.(Session_type{sess}).(Mouse_names{mouse})),ceil(1/median(diff(Range(LinearDist.(Session_type{sess}).(Mouse_names{mouse}),'s'))))));
                LinearDist_Diff.(Session_type{sess}).(Mouse_names{mouse}) = tsd(Range(LinearDist.(Session_type{sess}).(Mouse_names{mouse})) , [0 ; abs(diff(Data(LinearDist_smooth.(Session_type{sess}).(Mouse_names{mouse}))))]);
                
                NotMoving_LinDist.(Session_type{sess}).(Mouse_names{mouse}) = thresholdIntervals(LinearDist_Diff.(Session_type{sess}).(Mouse_names{mouse}) , .0012 , 'Direction' , 'Below');
                NotMoving_LinDist.(Session_type{sess}).(Mouse_names{mouse}) = mergeCloseIntervals(NotMoving_LinDist.(Session_type{sess}).(Mouse_names{mouse}),0.3*1E4);
                NotMoving_LinDist.(Session_type{sess}).(Mouse_names{mouse}) = dropShortIntervals(NotMoving_LinDist.(Session_type{sess}).(Mouse_names{mouse}),4*1E4);
                
                NotMoving_Speed.(Session_type{sess}).(Mouse_names{mouse}) = thresholdIntervals(Speed_Smooth.(Session_type{sess}).(Mouse_names{mouse}) , 5 , 'Direction' , 'Below');
                NotMoving_Speed.(Session_type{sess}).(Mouse_names{mouse}) = mergeCloseIntervals(NotMoving_Speed.(Session_type{sess}).(Mouse_names{mouse}),0.3*1E4);
                NotMoving_Speed.(Session_type{sess}).(Mouse_names{mouse}) = dropShortIntervals(NotMoving_Speed.(Session_type{sess}).(Mouse_names{mouse}),4*1E4);
                
                NotMoving.(Session_type{sess}).(Mouse_names{mouse}) = and(NotMoving_LinDist.(Session_type{sess}).(Mouse_names{mouse}) , NotMoving_Speed.(Session_type{sess}).(Mouse_names{mouse}));
                Acc_NotMoving.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Acc_smooth_bis.(Session_type{sess}).(Mouse_names{mouse}) , NotMoving.(Session_type{sess}).(Mouse_names{mouse}));
                
                HighAcc.(Session_type{sess}).(Mouse_names{mouse}) = thresholdIntervals(Acc_smooth_bis.(Session_type{sess}).(Mouse_names{mouse}) , 4e7);
                HighAcc.(Session_type{sess}).(Mouse_names{mouse}) = mergeCloseIntervals(HighAcc.(Session_type{sess}).(Mouse_names{mouse}),0.3*1E4);
                HighAcc.(Session_type{sess}).(Mouse_names{mouse}) = dropShortIntervals(HighAcc.(Session_type{sess}).(Mouse_names{mouse}),3*1E4);
                
                NotMoving_HighAcc.(Session_type{sess}).(Mouse_names{mouse}) = and(NotMoving.(Session_type{sess}).(Mouse_names{mouse}) , HighAcc.(Session_type{sess}).(Mouse_names{mouse}));
                NotMoving_HighAcc.(Session_type{sess}).(Mouse_names{mouse}) = mergeCloseIntervals(NotMoving_HighAcc.(Session_type{sess}).(Mouse_names{mouse}),0.3*1E4);
                NotMoving_HighAcc.(Session_type{sess}).(Mouse_names{mouse}) = dropShortIntervals(NotMoving_HighAcc.(Session_type{sess}).(Mouse_names{mouse}),3*1E4);
                Acc_NotMoving_HighAcc.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Acc_smooth_bis.(Session_type{sess}).(Mouse_names{mouse}) , NotMoving_HighAcc.(Session_type{sess}).(Mouse_names{mouse}));
                LinearDist_WhenGrooming.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(LinearDist.(Session_type{sess}).(Mouse_names{mouse}) , NotMoving_HighAcc.(Session_type{sess}).(Mouse_names{mouse}));
                LinearDist_WhenGrooming_Unblocked.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(LinearDist.(Session_type{sess}).(Mouse_names{mouse}) , and(NotMoving_HighAcc.(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse})));
                
                EpochLinDist_Grooming.(Session_type{sess}).(Mouse_names{mouse}) = EpochFromLinDist(LinearDist_WhenGrooming.(Session_type{sess}).(Mouse_names{mouse}) , bin_size);
                EpochLinDist_Grooming_Unblocked.(Session_type{sess}).(Mouse_names{mouse}) = EpochFromLinDist(LinearDist_WhenGrooming_Unblocked.(Session_type{sess}).(Mouse_names{mouse}) , bin_size);
                for i=1:bin_size; EpochLinDist_Grooming_prop.(Session_type{sess})(mouse,i) = sum(DurationEpoch(EpochLinDist_Grooming.(Session_type{sess}).(Mouse_names{mouse}){i}))/sum(DurationEpoch(EpochLinDist.(Session_type{sess}).(Mouse_names{mouse}){i})); end
                for i=1:bin_size; EpochLinDist_Grooming_Unblocked_prop.(Session_type{sess})(mouse,i) = sum(DurationEpoch(EpochLinDist_Grooming_Unblocked.(Session_type{sess}).(Mouse_names{mouse}){i}))/sum(DurationEpoch(EpochLinDist.(Session_type{sess}).(Mouse_names{mouse}){i})); end
                for i=1:bin_size; EpochLinDist_Grooming_prop2.(Session_type{sess})(mouse,i) = sum(and(Data(LinearDist_WhenGrooming.(Session_type{sess}).(Mouse_names{mouse}))>((i-1)/bin_size) , Data(LinearDist_WhenGrooming.(Session_type{sess}).(Mouse_names{mouse}))<(i/bin_size)))/...
                        sum(and(Data(LinearDist.(Session_type{sess}).(Mouse_names{mouse}))>((i-1)/bin_size) , Data(LinearDist.(Session_type{sess}).(Mouse_names{mouse}))<(i/bin_size))); end
                
                for i=1:bin_size; EpochLinDist_Grooming_Unblocked_prop2.(Session_type{sess})(mouse,i) = sum(and(Data(LinearDist_WhenGrooming_Unblocked.(Session_type{sess}).(Mouse_names{mouse}))>((i-1)/bin_size) , Data(LinearDist_WhenGrooming_Unblocked.(Session_type{sess}).(Mouse_names{mouse}))<(i/bin_size)))/...
                        sum(and(Data(LinearDist.(Session_type{sess}).(Mouse_names{mouse}))>((i-1)/bin_size) , Data(LinearDist.(Session_type{sess}).(Mouse_names{mouse}))<(i/bin_size))); end
            end
            
            disp(Mouse_names{mouse})
        end
        n=n+1;
    end
end



figure
x =linspace(0,1,bin_size);
for i=1:4
    if i==1
        DATA = EpochLinDist_Jumps_prop2.Cond;
        txt = 'proportion of jumps';
        val = .035;
    elseif i==2
        DATA = EpochLinDist_RA_prop2.Cond;
        txt = 'proportion of RA';
        val = .1;
    elseif i==3
        DATA = EpochLinDist_Grooming_Unblocked_prop2.Cond  ;
        txt = 'proportion of grooming';
        val = .3;
    else
        DATA = EpochLinDist_Fz_prop2.Cond;
        txt = 'proportion of freezing';
        val = .2;
    end
    
    subplot(4,1,i)
    area([-.1 .3] , [.8 .8] ,'FaceColor',[1 .5 .5],'FaceAlpha',.3)
    hold on
    area([.3 .45] , [.8 .8] ,'FaceColor',[1 .5 .5],'FaceAlpha',.2)
    area([.45 .55] , [.8 .8] ,'FaceColor',[1 .5 1],'FaceAlpha',.2)
    area([.55 .7] , [.8 .8] ,'FaceColor',[.5 .5 1],'FaceAlpha',.2)
    area([.7 1.1] , [.8 .8] ,'FaceColor',[.5 .5 1],'FaceAlpha',.3)
    
    errhigh = nanstd(DATA)/sqrt(size(DATA,1));
    errlow  = zeros(1,bin_size);
    
    b=bar(x,nanmean(DATA));
    b.FaceColor=[.3 .3 .3];
    
    box off
    
    er = errorbar(x,nanmean(DATA),errlow,errhigh);
    er.Color = [0 0 0];
    er.LineStyle = 'none';
    ylabel(txt)
    xlim([-.05 1.05]), ylim([0 val])
    if i==4
        xlabel('linear distance (a.u.)')
    end
end




%% other ways to plot,...
% individually look for JumpsAnalysis_Maze_BM Find_Grooming_UMaze_BM RA_Drugs_UMaze_BM
% LinearDistance_WhenFreezing_BM


figure
subplot(121)
DATA = JumpsDistrib.Cond{1};
Data_to_use = (DATA'./nansum(DATA'))';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(0,1,25) , runmean(Mean_All_Sp,3) , runmean(Conf_Inter,3) ,'-r',1); hold on;
col= [1 .3 .3]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
% area(linspace(0,1,25) , Mean_All_Sp,'FaceColor',col,'FaceAlpha',.07)

DATA = RA_Distrib.Cond{1};
Data_to_use = (DATA'./nansum(DATA'))';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(0,1,25) , Mean_All_Sp , Conf_Inter ,'-r',1); hold on;
col= [1 .3 1]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
% area(linspace(0,1,25) , Mean_All_Sp,'FaceColor',col,'FaceAlpha',.07)

DATA = GroomingDistrib_Unblocked.Cond{1};
Data_to_use = (DATA'./nansum(DATA'))';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(0,1,25) , Mean_All_Sp , Conf_Inter ,'-r',1); hold on;
col= [.3 .3 1]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
% area(linspace(0,1,25) , Mean_All_Sp,'FaceColor',col,'FaceAlpha',.07)

xlabel('linear distance (a.u.)'), ylabel('#'), ylim([0 .4])
f=get(gca,'Children'); l=legend([f(4),f(8),f(12)],'Grooming','Risk assessment','Jumps');



% d) Freezing is both at the shock and safe side
load('/media/nas7/ProjetEmbReact/DataEmbReact/LinearDistanceAllSaline.mat')


subplot(122)
DATA = FreezingDistrib.Cond{1};
Data_to_use = (DATA'./nansum(DATA'))';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(0,1,25) , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
col= [.3 .3 .3]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
% area(linspace(0,1,25) , Mean_All_Sp,'FaceColor',col,'FaceAlpha',.3)
xlabel('linear distance (a.u.)'), ylabel('#')






figure
subplot(121)
DATA = runmean(JumpsDistrib.Cond{1}',3)';
Data_to_use = (DATA'./nansum(DATA'))';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(0,1,25) , runmean(Mean_All_Sp,3) , runmean(Conf_Inter,3) ,'-r',1); hold on;
col= [1 .3 .3]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
% area(linspace(0,1,25) , Mean_All_Sp,'FaceColor',col,'FaceAlpha',.07)

DATA = runmean(RA_Distrib.Cond{1}',3)';
Data_to_use = (DATA'./nansum(DATA'))';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(0,1,25) , runmean(Mean_All_Sp,3) , runmean(Conf_Inter,3) ,'-r',1); hold on;
col= [1 .3 1]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
% area(linspace(0,1,25) , Mean_All_Sp,'FaceColor',col,'FaceAlpha',.07)

DATA = runmean(GroomingDistrib_Unblocked.Cond{1}',3)';
Data_to_use = (DATA'./nansum(DATA'))';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(0,1,25) , runmean(Mean_All_Sp,3) , runmean(Conf_Inter,3) ,'-r',1); hold on;
col= [.3 .3 1]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
% area(linspace(0,1,25) , Mean_All_Sp,'FaceColor',col,'FaceAlpha',.07)


subplot(122)
DATA = runmean(FreezingDistrib.Cond{1}',3)';
Data_to_use = (DATA'./nansum(DATA'))';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(0,1,25) , runmean(Mean_All_Sp,3) , runmean(Conf_Inter,3) ,'-k',1); hold on;
col= [.3 .3 .3]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
% area(linspace(0,1,25) , Mean_All_Sp,'FaceColor',col,'FaceAlpha',.3)
xlabel('linear distance (a.u.)'), ylabel('#')


%%
figure
x =linspace(0,1,25);
for i=1:4
    if i==1
        DATA = runmean(JumpsDistrib.Cond{1}',3)';
        txt = 'proportion of jumps';
    elseif i==2
        DATA = runmean(RA_Distrib.Cond{1}',3)';
        txt = 'proportion of RA';
    elseif i==3
        DATA = runmean(GroomingDistrib_Unblocked.Cond{1}',3)';
        txt = 'proportion of grooming';
    else
        DATA = runmean(FreezingDistrib.Cond{1}',3)';
        txt = 'proportion of freezing';
    end
    
    subplot(4,1,i)
    area([-.1 .3] , [.4 .4] ,'FaceColor',[1 .5 .5],'FaceAlpha',.2)
    hold on
    area([.3 .45] , [.4 .4] ,'FaceColor',[1 .7 .7],'FaceAlpha',.2)
    area([.45 .55] , [.4 .4] ,'FaceColor',[1 .5 1],'FaceAlpha',.2)
    area([.55 .7] , [.4 .4] ,'FaceColor',[.7 .7 1],'FaceAlpha',.2)
    area([.7 1.1] , [.4 .4] ,'FaceColor',[.5 .5 1],'FaceAlpha',.2)
    
    Data_to_use = (DATA'./nansum(DATA'))';
    errhigh = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    errlow  = zeros(1,25);
    
    b=bar(x,nanmean(Data_to_use));
    b.FaceColor=[.3 .3 .3];
    
    box off
    
    er = errorbar(x,nanmean(Data_to_use),errlow,errhigh);
    er.Color = [0 0 0];
    er.LineStyle = 'none';
    ylabel(txt)
    xlim([-.05 1.05]), ylim([0 .35])
    if i==4
        xlabel('linear distance (a.u.)')
    end
    
end

figure
bar(Mean_All_Sp)


figure
bar(nanmean(Jumps.Cond{1}))







figure
x =linspace(0,1,25);
for i=1:4
    if i==1
        DATA = JumpsDistrib.Cond{1};
        txt = 'proportion of jumps';
    elseif i==2
        DATA = RA_Distrib.Cond{1};
        txt = 'proportion of RA';
    elseif i==3
        DATA = GroomingDistrib_Unblocked.Cond{1};
        txt = 'proportion of grooming';
    else
        DATA = FreezingDistrib.Cond{1};
        txt = 'proportion of freezing';
    end
    
    subplot(4,1,i)
    area([-.1 .3] , [.8 .8] ,'FaceColor',[1 .5 .5],'FaceAlpha',.2)
    hold on
    area([.3 .45] , [.8 .8] ,'FaceColor',[1 .7 .7],'FaceAlpha',.2)
    area([.45 .55] , [.8 .8] ,'FaceColor',[1 .5 1],'FaceAlpha',.2)
    area([.55 .7] , [.8 .8] ,'FaceColor',[.7 .7 1],'FaceAlpha',.2)
    area([.7 1.1] , [.8 .8] ,'FaceColor',[.5 .5 1],'FaceAlpha',.2)
    
    Data_to_use = (DATA'./nansum(DATA'))';
    errhigh = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    errlow  = zeros(1,25);
    
    b=bar(x,nanmean(Data_to_use));
    b.FaceColor=[.3 .3 .3];
    
    box off
    
    er = errorbar(x,nanmean(Data_to_use),errlow,errhigh);
    er.Color = [0 0 0];
    er.LineStyle = 'none';
    ylabel(txt)
    xlim([-.05 1.05]), ylim([0 .8])
    if i==4
        xlabel('linear distance (a.u.)')
    end
    
end








