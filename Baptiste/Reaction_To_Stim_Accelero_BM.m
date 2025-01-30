

%% Movement quantity after VHC stim
clear all

Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM','Diazepam','RipControl','RipInhib','PAG'};
GetEmbReactMiceFolderList_BM
time_aft_stim = 2;
Group=5:8;
Session_type={'Cond','Calib'};

SessNames={'Calibration_Eyeshock'};
Dir=PathForExperimentsEmbReact(SessNames{1});

for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        for i=1:length(Dir.ExpeInfo)
            clear l; l=length(Dir.ExpeInfo{i});
            if Dir.ExpeInfo{i}{l}.nmouse==Mouse(mouse)
                CalibSess.(Mouse_names{mouse})={Dir.path{i}{l}};
            end
        end
    end
end

for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for sess=1:length(Session_type)
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            Sessions_List_ForLoop_BM
            
            Eyelid_Epoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','stimepoch');
            Around_Eyelid_Epoch_Noise.(Session_type{sess}).(Mouse_names{mouse}) = intervalSet(Start(Eyelid_Epoch.(Session_type{sess}).(Mouse_names{mouse}))-.05e4 , Start(Eyelid_Epoch.(Session_type{sess}).(Mouse_names{mouse}))+.3e4);
            Accelero.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'accelero');
            
            %         Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','fz_epoch_nosleep');
            %         Zone_Epoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','zoneepoch_nosleep');
            %         ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}) = Zone_Epoch.(Session_type{sess}).(Mouse_names{mouse}){1};
            %         SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = or(Zone_Epoch.(Session_type{sess}).(Mouse_names{mouse}){2} , Zone_Epoch.(Session_type{sess}).(Mouse_names{mouse}){5});
            %         Freeze_Shock.(Session_type{sess}).(Mouse_names{mouse}) = and(Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}) , ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}));
            %         Freeze_Safe.(Session_type{sess}).(Mouse_names{mouse}) = and(Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}) , SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}));
            
            Start_Eyelid.(Session_type{sess}).(Mouse_names{mouse}) = Start(Eyelid_Epoch.(Session_type{sess}).(Mouse_names{mouse}));
%             try
%                 %   BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Session_type{sess}).(Mouse_names{mouse}),'epoch','epochname','blockedepoch');
%                 TotEpoch.(Session_type{sess}).(Mouse_names{mouse}) = intervalSet(0,max(Range(Accelero.(Session_type{sess}).(Mouse_names{mouse}))));
%                 UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) = TotEpoch.(Session_type{sess}).(Mouse_names{mouse})-BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse});
%                 Eyelid_Unblocked_Epoch.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Eyelid_Epoch.(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}));
%                 Start_Eyelid_Unblocked.(Session_type{sess}).(Mouse_names{mouse}) = Start(Eyelid_Unblocked_Epoch.(Session_type{sess}).(Mouse_names{mouse}));
%             catch
%                 Start_Eyelid_Unblocked.(Session_type{sess}).(Mouse_names{mouse}) = Start_Eyelid.(Session_type{sess}).(Mouse_names{mouse});
%             end
            
            clear i; i=1;
            for stim = 1:length(Start_Eyelid.(Session_type{sess}).(Mouse_names{mouse}))
                Around_Eyelid_Epoch = intervalSet(Start_Eyelid.(Session_type{sess}).(Mouse_names{mouse})(stim)-1e4 , Start_Eyelid.(Session_type{sess}).(Mouse_names{mouse})(stim)+time_aft_stim*1e4);
                Accelero_Around_Eyelid.(Session_type{sess}).(Mouse_names{mouse})(stim,:) = Data(Restrict(Accelero.(Session_type{sess}).(Mouse_names{mouse}) , Around_Eyelid_Epoch));
                %             Before_Stim = intervalSet(Start_Eyelid.(Session_type{sess}).(Mouse_names{mouse})(stim)-2e4 , Start_Eyelid.(Session_type{sess}).(Mouse_names{mouse})(stim));
                %             if sum(DurationEpoch(and(Before_Stim,Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}))))==2e4
                %                 Start_Eyelid_Fz.(Session_type{sess}).(Mouse_names{mouse})(i) = Start_Eyelid.(Session_type{sess}).(Mouse_names{mouse})(stim);
                %                 i=i+1;
                %                 Accelero_Around_Eyelid_Fz.(Session_type{sess}).(Mouse_names{mouse})(i,:) = Data(Restrict(Accelero.(Session_type{sess}).(Mouse_names{mouse}) , Around_Eyelid_Epoch));
                %                 disp('bou')
                %             end
            end
            
            Accelero_Around_Eyelid_All.(Session_type{sess})(mouse,1:length(nanmean(Accelero_Around_Eyelid.(Session_type{sess}).(Mouse_names{mouse})))) = nanmean(Accelero_Around_Eyelid.(Session_type{sess}).(Mouse_names{mouse}));
            %         try; Accelero_Around_Eyelid_Fz_All(mouse,1:length(nanmean(Accelero_Around_Eyelid_Fz.(Session_type{sess}).(Mouse_names{mouse})))) = nanmean(Accelero_Around_Eyelid_Fz.(Session_type{sess}).(Mouse_names{mouse})); end
            Stim_Numb.(Session_type{sess})(mouse) = length(Start_Eyelid.(Session_type{sess}).(Mouse_names{mouse}));
            
            disp(Mouse_names{mouse})
        end
    end
end
Accelero_Around_Eyelid_All(Accelero_Around_Eyelid_All==0)=NaN;
Accelero_Around_Eyelid_Fz_All(Accelero_Around_Eyelid_Fz_All==0)=NaN;

MeanReac_All=log10(nanmean(Accelero_Around_Eyelid_All(:,55:150)'));

for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    
    MeanReac.(Session_type{sess}).(Mouse_names{mouse}) = log10(nanmean(Accelero_Around_Eyelid.(Session_type{sess}).(Mouse_names{mouse})(:,55:150)'));
    MeanReac_Evol.(Session_type{sess}).(Mouse_names{mouse}) = interp1(linspace(0,1,length(MeanReac.(Session_type{sess}).(Mouse_names{mouse}))) , MeanReac.(Session_type{sess}).(Mouse_names{mouse}) , linspace(0,1,25));
    MeanReac_Evol_All(mouse,:) = interp1(linspace(0,1,length(MeanReac.(Session_type{sess}).(Mouse_names{mouse}))) , MeanReac.(Session_type{sess}).(Mouse_names{mouse}) , linspace(0,1,25));
    
end

for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        Accelero_Around_Eyelid.(Drug_Group{group})(mouse,:) = nanmean(Accelero_Around_Eyelid.(Session_type{sess}).(Mouse_names{mouse}));
        MeanReac.(Drug_Group{group})(mouse,:) = nanmean(MeanReac.(Session_type{sess}).(Mouse_names{mouse}));
        MeanReac_Evol.(Drug_Group{group})(mouse,:) = MeanReac_Evol.(Session_type{sess}).(Mouse_names{mouse});
        
    end
    MeanReac_All_Drugs{group} = MeanReac.(Drug_Group{group});
end


%% Figures
figure
plot(Accelero_Around_Eyelid_All')
xticks([0:50:150]), xticklabels({'-1','0','1','2'})
vline(50,'--r')
xlabel('time (s)'), ylabel('Movement quantity (log scale)')
title('Mean accelero reaction to eyelid shock')

figure
subplot(121)
PlotCorrelations_BM(MeanReac_All(1:30) , Stim_Numb(1:30))
axis square
subplot(122)
PlotCorrelations_BM(log10(Stim_Numb(31:end)) , MeanReac_All(31:end) , 'binned'  , 0)
axis square
xlabel('Stim (log scale'), ylabel('Movement quantity (log scale)')
ylim([7.5 8.7])
line([1.1 1.8],[8.5 7.6],'Color','r','LineWidth',2)
title('Accelero reaction = f(# eyelid shocks)')

figure
plot(MeanReac_All)
xticks([1:length(Mouse)]), xticklabels(Mouse_names), xtickangle(45)

figure
plot(mean(MeanReac_Evol_All))

Cols={'b','r','m','g'};
figure
subplot(121)
for group=1:4
   
    Conf_Inter=nanstd(Accelero_Around_Eyelid.(Drug_Group{group}))/sqrt(size(Accelero_Around_Eyelid.(Drug_Group{group}),1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(Accelero_Around_Eyelid.(Drug_Group{group}));
    shadedErrorBar(linspace(-1,2,150) , Mean_All_Sp , Conf_Inter, Cols{group},1); hold on;

end
vline(0,'--r')
xlabel('time (s)'), ylabel('Movement quantity (a.u.)')
ylim([0 6e8])
makepretty
f=get(gca,'Children'); legend([f(13),f(9),f(5),f(1)],'Saline','Chronic Flx','Acute Flx','Midazolam')

subplot(122)
for group=5:8
   
    Conf_Inter=nanstd(Accelero_Around_Eyelid.(Drug_Group{group}))/sqrt(size(Accelero_Around_Eyelid.(Drug_Group{group}),1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(Accelero_Around_Eyelid.(Drug_Group{group}));
    shadedErrorBar(linspace(-1,2,150) , Mean_All_Sp , Conf_Inter, Cols{group-4},1); hold on;

end
vline(0,'--r')
xlabel('time (s)')
ylim([0 8e8])
makepretty
f=get(gca,'Children'); legend([f(13),f(9),f(5),f(1)],'Saline','Diazepam','RipControl','RipInhib')

a=suptitle('Mean accelero reaction to eyelid shock, drug shock analysis'); a.FontSize=20;


Cols1 = {[0, 0, 1],[1, 0, 0],[1, 0.5, 0.5],[0, 0.5, 0],[0.3, 0.745, 0.93],};
Cols2 = {[0.3, 0.745, 0.93],[0.85, 0.325, 0.098],[0.6350, 0.0780, 0.1840],[0.75, 0.75, 0]};
X = [1:4];
Legends1 = {'Saline','Chronic Flx','Acute Flx','Midazolam'};
Legends2 = {'Saline','DZP','RipControl','RipInhib'};

figure
subplot(121)
MakeSpreadAndBoxPlot2_SB(MeanReac_All_Drugs(1:4),Cols1,X,Legends1,'showpoints',1,'paired',0);
ylabel('Movement quantity (log sclae)')
% ylim([7.9 8.8])
subplot(122)
MakeSpreadAndBoxPlot2_SB(MeanReac_All_Drugs(5:8),Cols2,X,Legends2,'showpoints',1,'paired',0);

a=suptitle('Mean accelero reaction to eyelid shock, drug shock analysis'); a.FontSize=20;

figure
subplot(121)
for group=1:4
    Conf_Inter=nanstd(MeanReac_Evol.(Drug_Group{group}))/sqrt(size(MeanReac_Evol.(Drug_Group{group}),1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(MeanReac_Evol.(Drug_Group{group}));
    shadedErrorBar(linspace(0,1,25) , Mean_All_Sp , Conf_Inter, Cols{group},1); hold on;
end

subplot(122)
for group=5:8
    Conf_Inter=nanstd(MeanReac_Evol.(Drug_Group{group}))/sqrt(size(MeanReac_Evol.(Drug_Group{group}),1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(MeanReac_Evol.(Drug_Group{group}));
    shadedErrorBar(linspace(0,1,25) , Mean_All_Sp , Conf_Inter, Cols{group-4},1); hold on;
end



%% PAG
SessNames={'TestPre'};

Dir1=PathForExperimentsEmbReact(SessNames{1});
Dir_corr.ExpeInfo=Dir1.ExpeInfo(9:15);
Dir_corr.path=Dir1.path(9:15);

SessNames={'TestPost_PostDrug'};
Dir1=PathForExperimentsEmbReact(SessNames{1});


Dir=MergePathForExperiment(Dir_corr,Dir1);

for d=1:length(Dir.path)
    Mouse_names{d}= ['M' num2str(Dir.ExpeInfo{1, d}{1, 1}.nmouse)];
    Mouse(d)=Dir.ExpeInfo{1, d}{1, 1}.nmouse;
end


cd('/media/nas6/ProjetEmbReact/transfer')
load('Sess.mat')

for mouse =1:length(Mouse_names)
    TestPostSess.(Session_type{sess}).(Mouse_names{mouse}) = Sess.(Session_type{sess}).(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Session_type{sess}).(Mouse_names{mouse}) ,'TestPost')))));
    TestSess.(Session_type{sess}).(Mouse_names{mouse}) = Sess.(Session_type{sess}).(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Session_type{sess}).(Mouse_names{mouse}) ,'Test')))));
    CondSess.(Session_type{sess}).(Mouse_names{mouse}) = Sess.(Session_type{sess}).(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Session_type{sess}).(Mouse_names{mouse}) ,'Cond')))));
    ExtSess.(Session_type{sess}).(Mouse_names{mouse}) = Sess.(Session_type{sess}).(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Session_type{sess}).(Mouse_names{mouse}) ,'Ext')))));
    FearSess.(Session_type{sess}).(Mouse_names{mouse}) =  [CondSess.(Session_type{sess}).(Mouse_names{mouse}) ExtSess.(Session_type{sess}).(Mouse_names{mouse})];
    TestPreSess.(Session_type{sess}).(Mouse_names{mouse}) = Sess.(Session_type{sess}).(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Session_type{sess}).(Mouse_names{mouse}) ,'TestPre')))));
end


for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    
    TotalTime.(Session_type{sess}).(Mouse_names{mouse}) = max(Range(Accelero.(Session_type{sess}).(Mouse_names{mouse}),'s'));
    FreezingTime.(Session_type{sess}).(Mouse_names{mouse}) = sum(DurationEpoch(Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse})))/1e4;
    FreezingProp.(Session_type{sess}).(Mouse_names{mouse}) = FreezingTime.(Session_type{sess}).(Mouse_names{mouse})/TotalTime.(Session_type{sess}).(Mouse_names{mouse});
    Fz_Ep_Mean_Dur.(Session_type{sess}).(Mouse_names{mouse}) = nanmean(DurationEpoch(Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}))/1e4);
    Fz_Ep_Density.(Session_type{sess}).(Mouse_names{mouse}) = length(Start(Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse})))/(TotalTime.(Session_type{sess}).(Mouse_names{mouse})/600);
    ShockZoneEntries.(Session_type{sess}).(Mouse_names{mouse}) = length(Start(ShockEpoch.(Session_type{sess}).(Mouse_names{mouse})))/(TotalTime.(Session_type{sess}).(Mouse_names{mouse})/600);
        
    ShockFz_Prop.(Session_type{sess}).(Mouse_names{mouse}) = sum(DurationEpoch(Freeze_Shock.(Session_type{sess}).(Mouse_names{mouse}),'s'))/TotalTime.(Session_type{sess}).(Mouse_names{mouse});
    ShockFz_Prop_InZone.(Session_type{sess}).(Mouse_names{mouse}) = sum(DurationEpoch(Freeze_Shock.(Session_type{sess}).(Mouse_names{mouse})))/sum(DurationEpoch(ShockEpoch.(Session_type{sess}).(Mouse_names{mouse})));
    ShockFz_MeanDur.(Session_type{sess}).(Mouse_names{mouse}) = nanmean(DurationEpoch(Freeze_Shock.(Session_type{sess}).(Mouse_names{mouse}))/1e4);
    ShockFz_Density.(Session_type{sess}).(Mouse_names{mouse}) = length(Start(Freeze_Shock.(Session_type{sess}).(Mouse_names{mouse})))/(TotalTime.(Session_type{sess}).(Mouse_names{mouse})/600);
    
    SafeFz_Prop.(Session_type{sess}).(Mouse_names{mouse}) = sum(DurationEpoch(Freeze_Safe.(Session_type{sess}).(Mouse_names{mouse}),'s'))/TotalTime.(Session_type{sess}).(Mouse_names{mouse});
    SafeFz_Prop_InZone.(Session_type{sess}).(Mouse_names{mouse}) = sum(DurationEpoch(Freeze_Safe.(Session_type{sess}).(Mouse_names{mouse})))/sum(DurationEpoch(SafeEpoch.(Session_type{sess}).(Mouse_names{mouse})));
    SafeFz_MeanDur.(Session_type{sess}).(Mouse_names{mouse}) = nanmean(DurationEpoch(Freeze_Safe.(Session_type{sess}).(Mouse_names{mouse}))/1e4);
    SafeFz_Density.(Session_type{sess}).(Mouse_names{mouse}) = length(Start(Freeze_Safe.(Session_type{sess}).(Mouse_names{mouse})))/(TotalTime.(Session_type{sess}).(Mouse_names{mouse})/600);
    
    Prop_of_Fz.(Session_type{sess}).(Mouse_names{mouse}) = sum(DurationEpoch(Freeze_Shock.(Session_type{sess}).(Mouse_names{mouse})))/sum(DurationEpoch(Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse})));
    Proba_NotMove.(Session_type{sess}).(Mouse_names{mouse}) = sum((ceil(diff(Start_Eyelid_Unblocked.(Session_type{sess}).(Mouse_names{mouse}))/1e4)-1)==12)/length(Start_Eyelid_Unblocked.(Session_type{sess}).(Mouse_names{mouse}));
    Proba_NotMove_Evol.(Session_type{sess}).(Mouse_names{mouse}) = (ceil(diff(Start_Eyelid_Unblocked.(Session_type{sess}).(Mouse_names{mouse}))/1e4)-1)==12;
    Proba_NotMove_Evol_interp.(Session_type{sess}).(Mouse_names{mouse}) = interp1(linspace(0,1,length(Proba_NotMove_Evol.(Session_type{sess}).(Mouse_names{mouse}))) , double(Proba_NotMove_Evol.(Session_type{sess}).(Mouse_names{mouse})) , linspace(0,1,30));
end


n=1;
for group=[1 5 9]
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        FreezingProp_All{n}(mouse) = FreezingProp.(Session_type{sess}).(Mouse_names{mouse});
        Fz_Ep_Mean_Dur_All{n}(mouse) = Fz_Ep_Mean_Dur.(Session_type{sess}).(Mouse_names{mouse});
        Fz_Ep_Density_All{n}(mouse) = Fz_Ep_Density.(Session_type{sess}).(Mouse_names{mouse});
        ShockZoneEntries_All{n}(mouse) = ShockZoneEntries.(Session_type{sess}).(Mouse_names{mouse});
        
        ShockFz_Prop_All{n}(mouse) = ShockFz_Prop.(Session_type{sess}).(Mouse_names{mouse});
        ShockFz_Prop_InZone_All{n}(mouse) = ShockFz_Prop_InZone.(Session_type{sess}).(Mouse_names{mouse});
        ShockFz_MeanDur_All{n}(mouse) = ShockFz_MeanDur.(Session_type{sess}).(Mouse_names{mouse});
        ShockFz_Density_All{n}(mouse) = ShockFz_Density.(Session_type{sess}).(Mouse_names{mouse});
        
        SafeFz_Prop_All{n}(mouse) = SafeFz_Prop.(Session_type{sess}).(Mouse_names{mouse});
        SafeFz_Prop_InZone_All{n}(mouse) = SafeFz_Prop_InZone.(Session_type{sess}).(Mouse_names{mouse});
        SafeFz_MeanDur_All{n}(mouse) = SafeFz_MeanDur.(Session_type{sess}).(Mouse_names{mouse});
        SafeFz_Density_All{n}(mouse) = SafeFz_Density.(Session_type{sess}).(Mouse_names{mouse});
        
        Prop_of_Fz_All{n}(mouse) = Prop_of_Fz.(Session_type{sess}).(Mouse_names{mouse});
        Proba_NotMove_All{n}(mouse) = Proba_NotMove.(Session_type{sess}).(Mouse_names{mouse});
        Proba_NotMove_Evol_All{n}(mouse,:) = Proba_NotMove_Evol_interp.(Session_type{sess}).(Mouse_names{mouse});
    end
    n=n+1;
end

        
Cols = {[0 0 1],[.2 .2 .8],[.2 .8 .2]};
X = [1:3];
Legends = {'Saline SB','Saline BM','PAG'};

figure
subplot(141)
MakeSpreadAndBoxPlot2_SB(FreezingProp_All,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('proportion'), title('Freezing proportion')
subplot(142)
MakeSpreadAndBoxPlot2_SB(Fz_Ep_Mean_Dur_All,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('time (s)'), title('Freezing episodes mean duration')
subplot(143)
MakeSpreadAndBoxPlot2_SB(Fz_Ep_Density_All,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('#/10 min'), title('Freezing episodes density')
subplot(144)
MakeSpreadAndBoxPlot2_SB(ShockZoneEntries_All,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('#/10 min'), title('Freezing episodes density')

a=suptitle('Comparing freezing features, PAG / eyelid'); a.FontSize=20;


figure
subplot(345)
MakeSpreadAndBoxPlot2_SB(Prop_of_Fz_All,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('proportion'), title('Shock fz prop of freezing')

subplot(242)
MakeSpreadAndBoxPlot2_SB(ShockFz_Prop_All,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('proportion'), title('Prop of exp')
u=text(-1,.1,'Shock'), set(u,'Rotation',90,'FontSize',20,'FontWeight','bold');
subplot(243)
MakeSpreadAndBoxPlot2_SB(ShockFz_Prop_InZone_All,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('proportion'), title('Prop of time in zone')
subplot(244)
MakeSpreadAndBoxPlot2_SB(ShockFz_Density_All,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('#/10 min'), title('Freezing episodes density')

subplot(246)
MakeSpreadAndBoxPlot2_SB(SafeFz_Prop_All,Cols,X,Legends,'showpoints',1,'paired',0);
u=text(-1,.1,'Safe'), set(u,'Rotation',90,'FontSize',20,'FontWeight','bold');
ylabel('proportion')
subplot(247)
MakeSpreadAndBoxPlot2_SB(SafeFz_Prop_InZone_All,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('proportion')
subplot(248)
MakeSpreadAndBoxPlot2_SB(SafeFz_Density_All,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('#/10 min')

a=suptitle('Comparing freezing features, PAG / eyelid'); a.FontSize=20;



figure
MakeSpreadAndBoxPlot2_SB(Proba_NotMove_All,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('probability')
title('Proba to stay in shock zone >12s after an aversive stim')

Cols1={'b','c','g'};
figure
for n=1:3
    Data_to_use = runmean(Proba_NotMove_Evol_All{n}',3)';
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
    shadedErrorBar(linspace(0,1,30) , Mean_All_Sp , Conf_Inter, Cols1{n},1); hold on;
end
xlabel('time of experiment (a.u.)'), ylabel('probability')
makepretty
f=get(gca,'Children'); legend([f(9),f(5),f(1)],'Saline SB','Saline BM','PAG');
title('Evolution of probability to stay in shock zone >12s after an aversive stim')






