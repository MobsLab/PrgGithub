
%% check by sessions


load('behavResources.mat', 'MovAcctsd', 'Imdifftsd')
load('behavResources_SB.mat', 'Behav')
load('behavResources.mat', 'Vtsd')

Acc2 = MovAcctsd;

Acc_Smooth2 = tsd(Range(Acc2) , runmean(Data(Acc2),30));
Speed_Smooth2 = tsd(Range(Vtsd) , runmean(Data(Vtsd),ceil(1/median(diff(Range(Vtsd,'s'))))));
LinearDist2 = tsd(Range(Behav.LinearDist) , runmean(Data(Behav.LinearDist),ceil(1/median(diff(Range(Behav.LinearDist,'s'))))));
LinearDistDiff = tsd(Range(Behav.LinearDist) , [0 ; abs(diff(Data(LinearDist2)))]);

NotMoving_LinDist = thresholdIntervals(LinearDistDiff , .0012 , 'Direction' , 'Below');
NotMoving_LinDist = mergeCloseIntervals(NotMoving_LinDist,0.3*1E4);
NotMoving_LinDist = dropShortIntervals(NotMoving_LinDist,4*1E4);

NotMoving_Speed = thresholdIntervals(Speed_Smooth2 , 5 , 'Direction' , 'Below');
NotMoving_Speed = mergeCloseIntervals(NotMoving_Speed,0.3*1E4);
NotMoving_Speed = dropShortIntervals(NotMoving_Speed,4*1E4);

NotMoving = and(NotMoving_LinDist , NotMoving_Speed);
Acc_NotMoving = Restrict(Acc_Smooth2 , NotMoving);


HighAcc = thresholdIntervals(Acc_Smooth2 , 4e7);
HighAcc = mergeCloseIntervals(HighAcc,0.3*1E4);
HighAcc = dropShortIntervals(HighAcc,3*1E4);

NotMoving_HighAcc = and(NotMoving , HighAcc);
NotMoving_HighAcc = mergeCloseIntervals(NotMoving_HighAcc,0.3*1E4);
NotMoving_HighAcc = dropShortIntervals(NotMoving_HighAcc,3*1E4);
Acc_NotMoving_HighAcc = Restrict(Acc_Smooth2 , NotMoving_HighAcc);




figure
plot(Range(Acc_Smooth2,'s') , Data(Acc_Smooth2))
hold on
plot(Range(Acc_NotMoving,'s') , Data(Acc_NotMoving))
plot(Range(Acc_NotMoving_HighAcc,'s') , Data(Acc_NotMoving_HighAcc))
vline([15 21])
vline([126 144])

150*(480/156)
446*(156/480)


figure
plot(Range(LinearDistDiff,'s') , Data(LinearDistDiff))

figure
subplot(411)
plot(Range(ImDiff_smooth2,'s') , Data(ImDiff_smooth2))
vline([15 21])
vline([126 144])

subplot(412)
plot(Range(Acc_Smooth2,'s') , Data(Acc_Smooth2))
vline([15 21])
vline([126 144])

subplot(413)
plot(Range(Speed_Smooth2,'s') , Data(Speed_Smooth2))
vline([15 21])
vline([126 144])

subplot(414)
plot(Range(LinearDist2,'s') , Data(LinearDist2))
vline([15 21])
vline([126 144])



%% old version
clear all
GetAllSalineSessions_BM
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM','Diazepam','RipControl','RipInhib','SalineShortAll','Saline2','DZPShortAll','DZP2','RipControlOld','RipInhibOld','AcuteBUS','ChronicBUS','SalineLongBM','DZPLongBM'};
Group=1;
Session_type={'Cond','Ext','Fear'};

for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for sess=1:length(Session_type)
            
            Sessions_List_ForLoop_BM
            try
                Acc.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'accelero');
                ImDiff.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'imdiff');
                LinearPos.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'linearposition');
                BlockedEpoch.Cond.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','blockedepoch');
                
                clear D, D = Data(ImDiff.(Session_type{sess}).(Mouse_names{mouse})); D(D>800)=NaN;
                ImDiff_smooth.(Session_type{sess}).(Mouse_names{mouse}) = tsd(Range(ImDiff.(Session_type{sess}).(Mouse_names{mouse})),runmean_BM(log10(D),ceil(1/median(diff(Range(ImDiff.(Session_type{sess}).(Mouse_names{mouse}),'s'))))));
                Low_ImDiff.(Session_type{sess}).(Mouse_names{mouse}) = thresholdIntervals(ImDiff_smooth.(Session_type{sess}).(Mouse_names{mouse}) , 1 , 'Direction' , 'Below');
                Low_ImDiff.(Session_type{sess}).(Mouse_names{mouse}) = mergeCloseIntervals(Low_ImDiff.(Session_type{sess}).(Mouse_names{mouse}),0.3*1E4);
                Low_ImDiff.(Session_type{sess}).(Mouse_names{mouse}) = dropShortIntervals(Low_ImDiff.(Session_type{sess}).(Mouse_names{mouse}),2*1E4);
                
                Acc_Low_ImDiff.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Acc.(Session_type{sess}).(Mouse_names{mouse}) , Low_ImDiff.(Session_type{sess}).(Mouse_names{mouse}));
                Acc_smooth.(Session_type{sess}).(Mouse_names{mouse}) = tsd(Range(Acc_Low_ImDiff.(Session_type{sess}).(Mouse_names{mouse})) , log10(Data(Acc_Low_ImDiff.(Session_type{sess}).(Mouse_names{mouse}))));
                Low_ImDiff_High_Acc.(Session_type{sess}).(Mouse_names{mouse}) = thresholdIntervals(Acc_smooth.(Session_type{sess}).(Mouse_names{mouse}) , 8);
                Low_ImDiff_High_Acc.(Session_type{sess}).(Mouse_names{mouse}) = mergeCloseIntervals(Low_ImDiff_High_Acc.(Session_type{sess}).(Mouse_names{mouse}),0.3*1E4);
                Low_ImDiff_High_Acc.(Session_type{sess}).(Mouse_names{mouse}) = dropShortIntervals(Low_ImDiff_High_Acc.(Session_type{sess}).(Mouse_names{mouse}),2*1E4);
                
                TotEpoch.(Session_type{sess}).(Mouse_names{mouse}) = intervalSet(0,max(Range(Acc.(Session_type{sess}).(Mouse_names{mouse}))));
                Epoch_unblocked.(Session_type{sess}).(Mouse_names{mouse}) = TotEpoch.(Session_type{sess}).(Mouse_names{mouse})-BlockedEpoch.Cond.(Session_type{sess}).(Mouse_names{mouse});
                Low_ImDiff_High_Acc_Unblocked.(Session_type{sess}).(Mouse_names{mouse}) = and(Epoch_unblocked.(Session_type{sess}).(Mouse_names{mouse}) , Low_ImDiff_High_Acc.(Session_type{sess}).(Mouse_names{mouse}));
                
                LinearPos_Low_ImDiff_High_Acc.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(LinearPos.(Session_type{sess}).(Mouse_names{mouse}) , Low_ImDiff_High_Acc.(Session_type{sess}).(Mouse_names{mouse}));
                LinearPos_Low_ImDiff_High_Acc_Unblocked.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(LinearPos.(Session_type{sess}).(Mouse_names{mouse}) , Low_ImDiff_High_Acc_Unblocked.(Session_type{sess}).(Mouse_names{mouse}));
                
                GroomingNumb.(Session_type{sess}).(Mouse_names{mouse}) = length(Start(Low_ImDiff_High_Acc.(Session_type{sess}).(Mouse_names{mouse})));
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
        try
            h=histogram(Data(LinearPos_Low_ImDiff_High_Acc.(Session_type{sess}).(Mouse_names{mouse})),'BinLimits',[0 1],'NumBins',25);
            HistData{n}(mouse,:) = runmean_BM(h.Values,3);
            
            h=histogram(Data(LinearPos_Low_ImDiff_High_Acc_Unblocked.(Session_type{sess}).(Mouse_names{mouse})),'BinLimits',[0 1],'NumBins',25);
            HistData_Ublocked{n}(mouse,:) = runmean_BM(h.Values,3);
        end
    end
    n=n+1;
end
HistData{1}(HistData{1}(:,24)==0,:)=NaN;

figure, group=1;
Data_to_use = HistData{group}./(nansum(HistData{group}')');
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(0,1,25) , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;

figure, group=1;
Data_to_use = HistData_Ublocked{group}./(nansum(HistData_Ublocked{group}')');
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(0,1,25) , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;

Grooming=HistData; save('/media/nas7/ProjetEmbReact/DataEmbReact/BehaviourAlongMaze.mat','Grooming','-append')



for mouse=1:length(Mouse)
    Grooming_Time(1,mouse) = sum(DurationEpoch(Low_ImDiff_High_Acc.(Session_type{sess}).(Mouse_names{mouse})))/.1e4;
    Grooming_Time(2,mouse) = sum(DurationEpoch(Low_ImDiff_High_Acc_Unblocked.(Session_type{sess}).(Mouse_names{mouse})))/.1e4;
end


figure
for mouse=1:length(Mouse)
    subplot(2,4,mouse)
    
    histogram(Data(LinearPos_Low_ImDiff_High_Acc.(Session_type{sess}).(Mouse_names{mouse})),'BinLimits',[0 1],'NumBins',10)
    title(Mouse_names{mouse})
end


figure
for mouse=1:length(Mouse)
    subplot(2,4,mouse)
    
    histogram(Data(LinearPos_Low_ImDiff_High_Acc_Unblocked.(Session_type{sess}).(Mouse_names{mouse})),'BinLimits',[0 1],'NumBins',10)
    title(Mouse_names{mouse})
end

D=Data(Acc); D(D==0)=NaN;

figure
plot(Range(Acc) , runmean_BM(log10(D),1e3))
hold on
plot(Range(ImDiff) , runmean_BM(log10(Data(ImDiff)),100))





figure
hist(log10(Data(Acc_Low_ImDiff)),100)

Start(Low_ImDiff_High_Acc)



ImDiff_corr = Restrict(ImDiff,Acc);
ind = D1<800;
D1 = log10(Data(ImDiff_corr)); D1=D1(ind);
D2 = log10(Data(Acc)); D2=D2(ind);
D1 = zscore(Data(ImDiff_corr)); D1=D1(ind);
D2 = zscore(Data(Acc)); D2=D2(ind);
bin=50;

figure
plot(D1(1:bin:end) , D2(1:bin:end),'.k' , 'MarkerSize',15)




