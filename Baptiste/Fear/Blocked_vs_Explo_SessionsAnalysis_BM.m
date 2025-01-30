

load('/media/nas7/ProjetEmbReact/DataEmbReact/Blocked_Unblocked_Freezing_Analysis.mat')


%% freezing features

clear all
Group=[9 10];

GetAllSalineSessions_BM
GetEmbReactMiceFolderList_BM
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','RipSham','RipInhib','PAG','All_eyelid','All_saline','Elisa','RipSham2','RipInhib2','RipInhib','ChronicBUS','AcuteBUS','RipControl','RipInhib1','RipControl1','RipInhibPaired','RipControlPaired','Sal_Maze1_1stMaze','Sal_Maze4_1stMaze','DZP_Maze1_1stMaze','DZP_Maze4_1stMaze'};
Session_type={'Fear'};

Cols = {[.3, .745, .93],[.85, .325, .098],[.65, .75, 0],[.63, .08, .18]};
X = 1:4;
Legends = {'Saline','Diazepam','Rip sham','Rip inhib'};
NoLegends = {'','','',''};

ind=1:4;

Side={'All','Shock','Safe'};
Zones_Lab={'Shock','Shock middle','Middle','Safe middle','Safe'};




% Freeze duration
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for sess=1:length(Session_type)
            
            Sessions_List_ForLoop_BM
            
            Speed.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'speed');
            BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','blockedepoch');
            TotEpoch.(Session_type{sess}).(Mouse_names{mouse}) = intervalSet(0,max(Range(Speed.(Session_type{sess}).(Mouse_names{mouse}))));
            TotalTime.(Session_type{sess}).(Mouse_names{mouse}) = sum(DurationEpoch(TotEpoch.(Session_type{sess}).(Mouse_names{mouse})))/1e4;
            UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) = TotEpoch.(Session_type{sess}).(Mouse_names{mouse}) - BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse});
            FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','freezeepoch_withnoise');
            ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}) = TotEpoch.(Session_type{sess}).(Mouse_names{mouse}) - FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse});
            
            ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'Epoch','epochname','zoneepoch_behav');
            ShockZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){1};
            SafeZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = or(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){2},ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){5});
            
            Freeze_BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}));
            Freeze_UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}));

            Distance_UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) = nanmean(Data(Restrict(Speed.(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}))));
            
            ActiveEpoch_Unblocked.(Session_type{sess}).(Mouse_names{mouse}) = and(ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}));

            % side analysis
            for side=1:3
                if side==1
                    ZoneEp = TotEpoch;
                elseif side==2
                    ZoneEp = ShockZoneEpoch;
                elseif side==3
                    ZoneEp = SafeZoneEpoch;
                end
                BlockedEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) = and(ZoneEp.(Session_type{sess}).(Mouse_names{mouse}) , BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}));
                UnblockedEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) = and(ZoneEp.(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}));
                FreezeEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , ZoneEp.(Session_type{sess}).(Mouse_names{mouse}));
                Freeze_BlockedEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) = and(Freeze_BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) , ZoneEp.(Session_type{sess}).(Mouse_names{mouse}));
                Freeze_UnblockedEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) = and(Freeze_UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) , ZoneEp.(Session_type{sess}).(Mouse_names{mouse}));
                ActiveEpoch_Unblocked.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) = and(ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}) , and(ZoneEp.(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse})));
            end
        end
        disp(Mouse_names{mouse})
    end
end


thtps_immob=2;
n=1;
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for side=1:3
            
            FreezeEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})=mergeCloseIntervals(FreezeEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}),0.3*1e4);
            FreezeEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})=dropShortIntervals(FreezeEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}),thtps_immob*1e4);
            Freeze_BlockedEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})=mergeCloseIntervals(Freeze_BlockedEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}),0.3*1e4);
            Freeze_BlockedEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})=dropShortIntervals(Freeze_BlockedEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}),thtps_immob*1e4);
            Freeze_UnblockedEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})=mergeCloseIntervals(Freeze_UnblockedEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}),0.3*1e4);
            Freeze_UnblockedEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})=dropShortIntervals(Freeze_UnblockedEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}),thtps_immob*1e4);
            
            
            FreezeDur{side}{n}(mouse) = sum(DurationEpoch(FreezeEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})))/60e4;
            FreezeDur_Blocked{side}{n}(mouse) = sum(DurationEpoch(Freeze_BlockedEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})))/60e4;
            FreezeDur_Unblocked{side}{n}(mouse) = sum(DurationEpoch(Freeze_UnblockedEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})))/60e4;
            
            FreezeMeanDur{side}{n}(mouse) = nanmedian(DurationEpoch(FreezeEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})))/1e4;
            FreezeMeanDur_Blocked{side}{n}(mouse) = nanmedian(DurationEpoch(Freeze_BlockedEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})))/1e4;
            FreezeMeanDur_Unblocked{side}{n}(mouse) = nanmedian(DurationEpoch(Freeze_UnblockedEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})))/1e4;
            
            FreezeDistribDur{side}{n}{mouse} = (DurationEpoch(FreezeEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})))/1e4;
            FreezeDistribDur_Blocked{side}{n}{mouse} = (DurationEpoch(Freeze_BlockedEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})))/1e4;
            FreezeDistribDur_Unblocked{side}{n}{mouse} = (DurationEpoch(Freeze_UnblockedEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})))/1e4;
            
        end
    end
    n=n+1;
end

Cols={[1 .5 .5],[.5 .5 1],[1 .5 .5],[.5 .5 1]};
X=[1:4];
Legends={'Shock','Safe','Shock','Safe'};


figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({FreezeDur_Blocked{2}{2} FreezeDur_Blocked{3}{2} FreezeDur_Unblocked{2}{2} FreezeDur_Unblocked{3}{2}},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('freezing duration (min)')
makepretty_BM2

subplot(122)
MakeSpreadAndBoxPlot3_SB({FreezeDur{2}{1} FreezeDur{3}{1} FreezeDur{2}{2} FreezeDur{3}{2}},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('freezing duration (min)')
makepretty_BM2


figure
subplot(121)
MakeSpreadAndBoxPlot4_SB({FreezeDur_Unblocked{2}{2}*60},{[.3 .3 .3]},[1],{'Unblocked shock eyelid'},'showpoints',1,'paired',0);
ylabel('time (s)')

subplot(122)
A = FreezeDur_Unblocked{2}{2}; A(A==0)=NaN;
MakeSpreadAndBoxPlot4_SB({A*60},{[.3 .3 .3]},[1],{'Unblocked shock eyelid'},'showpoints',1,'paired',0);
ylabel('time (s)')
set(gca , 'Yscale','log')


figure
MakeSpreadAndBoxPlot3_SB({FreezeMeanDur{2}{1} FreezeMeanDur{3}{1} FreezeMeanDur_Blocked{2}{2} FreezeMeanDur_Blocked{3}{2} FreezeMeanDur_Unblocked{2}{2} FreezeMeanDur_Unblocked{3}{2}},Cols,X,Legends,'showpoints',1,'paired',0);
y=ylabel('freezing episodes median duration (sec)'); y.FontSize=10; ylim([0 17])
makepretty_BM2





%% Breathing
load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/OB_Spec.mat', 'OB_MeanSpecFz_Shock', 'OB_MeanSpecFz_Safe','OB_MeanSpecFz_Shock_Blocked','OB_MeanSpecFz_Safe_Blocked',...
   'OB_MeanSpecFz_Shock_Unblocked','OB_MeanSpecFz_Safe_Unblocked')

figure
subplot(131)
[~,~, Shock_PAG] = Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Shock.Fear(1:20,:), 'color' , [1 .5 .5], 'smoothing' , 3 , 'dashed_line' , 0);
[~,~, Safe_PAG] = Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Safe.Fear(1:20,:) , 'color' , [.5 .5 1], 'smoothing' , 3 , 'dashed_line' , 0);

f=get(gca,'Children'); l=legend([f(5),f(1)],'Shock','Safe'); l.Box='off';
xlabel('Frequency (Hz)'); ylabel('Power (a.u.)'); xlim([0 10]); ylim([0 1])
makepretty
v1=vline(nanmean(5.191)); set(v1,'LineStyle','--','Color',[1 .5 .5]); v2=vline(nanmean(2.977)); set(v2,'LineStyle','--','Color',[.5 .5 1])
xticks([0:2:14])
axis square


subplot(132)
[~,~, Shock_Eyelid_Blo] = Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Shock_Blocked.Fear(21:end,:), 'color' , [1 .5 .5], 'smoothing' , 3 , 'dashed_line' , 0);
[~,~, Safe_Eyelid_Blo] = Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Safe_Blocked.Fear(21:end,:) , 'color' , [.5 .5 1], 'smoothing' , 3 , 'dashed_line' , 0);

f=get(gca,'Children'); l=legend([f(5),f(1)],'Shock','Safe'); l.Box='off';
xlabel('Frequency (Hz)'); ylabel('Power (a.u.)'); xlim([0 10]); ylim([0 1])
makepretty
v1=vline(nanmean(4.58)); set(v1,'LineStyle','--','Color',[1 .5 .5]); v2=vline(nanmean(2.977)); set(v2,'LineStyle','--','Color',[.5 .5 1])
xticks([0:2:14])
axis square


subplot(133)
[~,~, Shock_Eyelid_Unb] = Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Shock_Unblocked.Fear(21:end,:), 'color' , [1 .5 .5], 'smoothing' , 3 , 'dashed_line' , 0);
[~,~, Safe_Eyelid_Unb] = Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Safe_Unblocked.Fear(21:end,:) , 'color' , [.5 .5 1], 'smoothing' , 3 , 'dashed_line' , 0);

f=get(gca,'Children'); l=legend([f(5),f(1)],'Shock','Safe'); l.Box='off';
xlabel('Frequency (Hz)'); ylabel('Power (a.u.)'); xlim([0 10]); ylim([0 1])
makepretty
v1=vline(nanmean(5.038)); set(v1,'LineStyle','--','Color',[1 .5 .5]); v2=vline(nanmean(3.435)); set(v2,'LineStyle','--','Color',[.5 .5 1])
xticks([0:2:14])
axis square






Cols={[1 .5 .5],[.5 .5 1],[1 .5 .5],[.5 .5 1],[1 .5 .5],[.5 .5 1]};
X=[1:6];
Legends={'Shock','Safe','Shock','Safe','Shock','Safe'};

Shock_PAG(7)=NaN;
Shock_Eyelid_Unb([3 5]) = NaN;

figure
MakeSpreadAndBoxPlot3_SB({Shock_PAG Safe_PAG Shock_Eyelid_Blo Safe_Eyelid_Blo Shock_Eyelid_Unb Safe_Eyelid_Unb},...
    Cols,X,Legends,'showpoints',1,'paired',0);
makepretty_BM2
ylabel('Breathing (Hz)')







