

load('/media/nas7/Modelling_Behaviour/Free_Explo_Project/FromBaptiste/Workspace_DrugsOverview_Sal.mat',...
    'ExtraStimNumber','Proportionnal_Time_Freezing_ofZone','Respi_Shock','ImmobilityTime','Speed','ShockEntriesZone')

Var = ImmobilityTime.TestPre;
Var = Speed_All;
Var = Acc_All;
Var = Jerk_All;
Var = Jerk_All2;
Var = Jerk_All3;

m = 'pearson';
m = 'spearman';

figure
subplot(131)
A=ExtraStimNumber.Cond{1};
A(A>12)=NaN;
ind = A<12;
PlotCorrelations_BM(Var , A,'method',m)
axis square
xlabel('immobility (prop)'), ylabel('eyelid shocks, Cond'), %ylim([0 10]), xlim([-1.2 1.2])

subplot(132)
A=Proportionnal_Time_Freezing_ofZone.Safe.Cond{1};
A(~ind)=NaN;
PlotCorrelations_BM(Var , A,'method',m)
axis square
xlabel('immobility (prop)'), ylabel('freezing safe prop, Cond'),% ylim([0 .35]), xlim([-1.2 1.2])

subplot(133)
A=Respi_Shock.Cond{1};
A(~ind)=NaN;% A(A>5.3)=NaN;
PlotCorrelations_BM(Var , A,'method',m)
axis square
xlabel('immobility (prop)'), ylabel('Respi freq, Fz shock, Cond'),% ylim([3 6]), xlim([-1.2 1.2])

a=suptitle('Correlations of immobility in TestPre with behaviour in Cond, Saline'); a.FontSize=20;



for mouse=1:21
    clear D
    D = runmean(Data(Speed.TestPre.(Mouse_names{mouse})),5);
    Speed_All(mouse) = nanmean(D);
    
    clear D2
    for i=1:ceil(length(D)/5)-1
        D2(i) = nanmean(D((i-1)*5+1:(i)*5+1));
    end
    Acc.TestPre.(Mouse_names{mouse}) = diff(D2);
    Acc_All(mouse) = nanmean(abs(Acc.TestPre.(Mouse_names{mouse})));
    
    clear D3
    for i=1:ceil(length(D2)/5)-1
        D3(i) = nanmean(D2((i-1)*5+1:i*5+1));
    end
    Jerk.TestPre.(Mouse_names{mouse}) = diff(D3);
    Jerk_All(mouse) = nanmean(abs(Jerk.TestPre.(Mouse_names{mouse})));
    
%     Jerk2.TestPre.(Mouse_names{mouse}) = diff(diff(D2));
%     Jerk_All2(mouse) = nanmean(abs(Jerk2.TestPre.(Mouse_names{mouse})));
%         
%     bin = 25; clear D4
%     for i=1:ceil(length(D)/bin)-1
%         D4(i) = nanmean(D((i-1)*bin+1:(i)*bin+1));
%     end
%     Jerk3.TestPre.(Mouse_names{mouse}) = diff(diff(D4));
%     Jerk_All3(mouse) = nanmean(abs(Jerk3.TestPre.(Mouse_names{mouse})));
end


ind1 = ImmobilityTime.TestPre<.4;
ind2 = ImmobilityTime.TestPre>.4;

figure
subplot(131)
A = Speed_All;
PlotCorrelations_BM(ImmobilityTime.TestPre(ind1) , A(ind1), 'Color' , 'b' , 'method','spearman')
PlotCorrelations_BM(ImmobilityTime.TestPre(ind2) , A(ind2), 'Color' , 'r' , 'method','spearman')
axis square
xlabel('immobility (prop)'), ylabel('speed (cm.s-1)')

subplot(132)
A = Acc_All;
PlotCorrelations_BM(ImmobilityTime.TestPre(ind1) , A(ind1), 'Color' , 'b' , 'method','spearman')
PlotCorrelations_BM(ImmobilityTime.TestPre(ind2) , A(ind2), 'Color' , 'r' , 'method','spearman')
axis square
xlabel('immobility (prop)'), ylabel('acceleration (cm.s-2)')

subplot(133)
A = Jerk_All;
PlotCorrelations_BM(ImmobilityTime.TestPre(ind1) , A(ind1), 'Color' , 'b' , 'method','spearman')
PlotCorrelations_BM(ImmobilityTime.TestPre(ind2) , A(ind2), 'Color' , 'r' , 'method','spearman')
axis square
xlabel('immobility (prop)'), ylabel('jerk (cm.s-2)')

a=suptitle('Correlations of position derivate with immobility in TestPre, Saline'); a.FontSize=20;




figure
subplot(131)
A = Jerk_All;
PlotCorrelations_BM(ImmobilityTime.TestPre(ind1) , A(ind1), 'Color' , 'b' , 'method','spearman')
PlotCorrelations_BM(ImmobilityTime.TestPre(ind2) , A(ind2), 'Color' , 'r' , 'method','spearman')
axis square

subplot(132)
A = Jerk_All2;
PlotCorrelations_BM(ImmobilityTime.TestPre(ind1) , A(ind1), 'Color' , 'b' , 'method','spearman')
PlotCorrelations_BM(ImmobilityTime.TestPre(ind2) , A(ind2), 'Color' , 'r' , 'method','spearman')
axis square

subplot(133)
A = Jerk_All3;
PlotCorrelations_BM(ImmobilityTime.TestPre(ind1) , A(ind1), 'Color' , 'b' , 'method','spearman')
PlotCorrelations_BM(ImmobilityTime.TestPre(ind2) , A(ind2), 'Color' , 'r' , 'method','spearman')
axis square


%%
for mouse=1:21
    Speed_smooth = tsd(Range(Speed.TestPre.(Mouse_names{mouse})) , runmean(Data(Speed.TestPre.(Mouse_names{mouse})) ,9));
    ImmobileEpoch = thresholdIntervals(Speed_smooth , 2 ,'Direction','Below');
    ImmobileEpoch = mergeCloseIntervals(ImmobileEpoch,0.3*1e4);
    ImmEpoch.(Mouse_names{mouse}) = dropShortIntervals(ImmobileEpoch,.3*1e4);
    ImmEp(mouse) = length(Start(ImmEpoch.(Mouse_names{mouse})));
    ImmMeanDur(mouse) = nanmean(DurationEpoch(ImmEpoch.(Mouse_names{mouse})))/1e4;
end

Var = ImmMeanDur;

m = 'pearson';
m = 'spearman';


figure
Var = ImmEp;
subplot(231)
A=ExtraStimNumber.Cond{1};
A(A>12)=NaN;
ind = A<12;
PlotCorrelations_BM(Var , A,'method',m)
axis square
xlabel('immobility episodes (#)'), ylabel('eyelid shocks, Cond'), %ylim([0 10]), xlim([-1.2 1.2])

subplot(232)
A=Proportionnal_Time_Freezing_ofZone.Safe.Cond{1};
A(~ind)=NaN;
PlotCorrelations_BM(Var , A,'method',m)
axis square
xlabel('immobility episodes (#)'), ylabel('freezing safe prop, Cond'),% ylim([0 .35]), xlim([-1.2 1.2])

subplot(233)
A=Respi_Shock.Cond{1};
A(~ind)=NaN; A(A>5.3)=NaN;
PlotCorrelations_BM(Var , A,'method',m)
axis square
xlabel('immobility episodes (#)'), ylabel('Respi freq, Fz shock, Cond'),% ylim([3 6]), xlim([-1.2 1.2])

Var = ImmMeanDur;
subplot(234)
A=ExtraStimNumber.Cond{1};
A(A>12)=NaN;
ind = A<12;
PlotCorrelations_BM(Var , A,'method',m)
axis square
xlabel('immobility mean dur (s)'), ylabel('eyelid shocks, Cond'), %ylim([0 10]), xlim([-1.2 1.2])

subplot(235)
A=Proportionnal_Time_Freezing_ofZone.Safe.Cond{1};
A(~ind)=NaN;
PlotCorrelations_BM(Var , A,'method',m)
axis square
xlabel('immobility mean dur (s)'), ylabel('freezing safe prop, Cond'),% ylim([0 .35]), xlim([-1.2 1.2])

subplot(236)
A=Respi_Shock.Cond{1};
A(~ind)=NaN; A(A>5.3)=NaN;
PlotCorrelations_BM(Var , A,'method',m)
axis square
xlabel('immobility mean dur (s)'), ylabel('Respi freq, Fz shock, Cond'),% ylim([3 6]), xlim([-1.2 1.2])


a=suptitle('Correlations of immobility in TestPre with behaviour in Cond, Saline'); a.FontSize=20;


%%
Mouse_names = {'M688', 'M777', 'M849', 'M1144', 'M1146', 'M1147', 'M1170', 'M1171', 'M9184', 'M9205',...
    'M1391', 'M1392', 'M1394', 'M1224', 'M1225', 'M1226', 'M739', 'M779', 'M893', 'M1189', 'M1393'}; 

Session_type={'Habituation','TestPre','Cond','TestPost'};
for sess=1:4
    for mouse=1:21
        Speed_all.(Session_type{sess})(mouse) = nanmean(Data(Speed.(Session_type{sess}).(Mouse_names{mouse})));
        clear D
        D = Data(Speed.(Session_type{sess}).(Mouse_names{mouse})); D=D(D<2);
        ImmobilityTime.(Session_type{sess})(mouse) = length(D)/length(Data(Speed.(Session_type{sess}).(Mouse_names{mouse})));
    end
end
Imm_score = 2*(ImmobilityTime.TestPre-min(ImmobilityTime.TestPre))/(max(ImmobilityTime.TestPre)-min(ImmobilityTime.TestPre))-1; % normalisation [-1 1]
Imm_score_hab = 2*(ImmobilityTime.Habituation-min(ImmobilityTime.TestPre))/(max(ImmobilityTime.TestPre)-min(ImmobilityTime.TestPre))-1; % normalisation [-1 1]
Imm_score_post = 2*(ImmobilityTime.TestPost-min(ImmobilityTime.TestPre))/(max(ImmobilityTime.TestPre)-min(ImmobilityTime.TestPre))-1; % normalisation [-1 1]


Cols={[1 .5 1],[1 .5 .5],[.5 .5 1]};
Legends={'all mice','1st group','2nd group'};
X=1:3;

ind_grp1 = Imm_score<-.2;
ind_grp2 = Imm_score>-.2;

figure
MakeSpreadAndBoxPlot3_SB({Imm_score Imm_score(ind_grp1) Imm_score(ind_grp2)},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('immobility score (a.u.)')


figure
PlotCorrelations_BM(Imm_score , Imm_score_hab,'method','spearman')
axis square
xlabel('model score, pre'), ylabel('model score, hab')
xlim([-1.2 1.2]), ylim([-1.2 1.2])
line([-1.2 1.2],[-1.2 1.2],'Color','r','LineStyle','--')
xticks([-1.2:.2:1.2]), yticks([-1.2:.2:1.2]), xtickangle(90)
grid on
f=legend; f.String=f.String{1};


% correlation with thigmotaxis 
figure
A=Tigmo_score_all.Active_Unblocked.TestPre{1};
PlotCorrelations_BM(Imm_score,A,'method','spearman')
axis square
xlabel('model score pre'), ylabel('thigmo score, pre')


%%
Cols2={[1 .5 1],[1 .5 .5],[.5 .5 1],[.5 1 .5]};
Legends2={'all mice, TestPre','1st group, TestPre','2nd group, TestPre','all mice, TestPost'};
X2=1:4;

figure
MakeSpreadAndBoxPlot3_SB({Imm_score Imm_score(ind_grp1)...
    Imm_score(ind_grp2) Imm_score_post},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('immobility score (a.u.)')

% discuss about freezing inclusion

% after SD
for mouse=1:8
    clear D
    D = Data(Speed.SD.Hab{mouse}); D=D(D<2);
    ImmobilityTime_sd_hab(mouse) = length(D)/length(Data(Speed.SD.Hab{mouse}));
    clear D
    D = Data(Speed.SD.TestPre{mouse}); D=D(D<2);
    ImmobilityTime_sd_pre(mouse) = length(D)/length(Data(Speed.SD.TestPre{mouse}));
end
Imm_score_sd_hab = 2*(ImmobilityTime_sd_hab-min(ImmobilityTime.TestPre))/(max(ImmobilityTime.TestPre)-min(ImmobilityTime.TestPre))-1; % normalisation [-1 1]
Imm_score_sd_pre = 2*(ImmobilityTime_sd_pre-min(ImmobilityTime.TestPre))/(max(ImmobilityTime.TestPre)-min(ImmobilityTime.TestPre))-1; % normalisation [-1 1]


Cols={[1 .5 1],[1 .5 .5],[.5 .5 1],[.5 .7 .5]};
X=1:4;
Legends={'all mice, TestPre','1st group, TestPre','2nd group, TestPre','After SD'};

figure
MakeSpreadAndBoxPlot3_SB({Imm_score Imm_score(ind_grp1)...
    Imm_score(ind_grp2) Imm_score_sd_pre},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('immobility score (a.u.)')


% after DZP
for mouse=4:7
    clear D
    D = Data(Speed.DZP.Hab{mouse}); D=D(D<2);
    ImmobilityTime_dzp_hab(mouse) = length(D)/length(Data(Speed.DZP.Hab{mouse}));
    clear D
    D = Data(Speed.DZP.TestPre{mouse}); D=D(D<2);
    ImmobilityTime_dzp_pre(mouse) = length(D)/length(Data(Speed.DZP.TestPre{mouse}));
end
ImmobilityTime_dzp_hab(ImmobilityTime_dzp_hab==0) = NaN;
ImmobilityTime_dzp_pre(ImmobilityTime_dzp_pre==0) = NaN;
Imm_score_dzp_hab = 2*(ImmobilityTime_dzp_hab-min(ImmobilityTime.TestPre))/(max(ImmobilityTime.TestPre)-min(ImmobilityTime.TestPre))-1; % normalisation [-1 1]
Imm_score_dzp_pre = 2*(ImmobilityTime_dzp_pre-min(ImmobilityTime.TestPre))/(max(ImmobilityTime.TestPre)-min(ImmobilityTime.TestPre))-1; % normalisation [-1 1]


Cols={[1 .5 1],[1 .5 .5],[.5 .5 1],[0.95 0.52 0.3]};
X=1:4;
Legends={'all mice, TestPre','1st group, TestPre','2nd group, TestPre','After DZP'};

figure
MakeSpreadAndBoxPlot3_SB({Imm_score Imm_score(ind_grp1)...
    Imm_score(ind_grp2) Imm_score_dzp_hab},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('immobility score (a.u.)')


figure
MakeSpreadAndBoxPlot3_SB({Imm_score Imm_score(ind_grp1)...
    Imm_score(ind_grp2) Imm_score_dzp_pre},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('immobility score (a.u.)')



%% with EPM values
Cols={[1 .5 1],[1 .5 .5],[.5 .5 1],[0.95 0.52 0.3]};
X=1:4;
Legends2={'all mice, TestPre','1st group, TestPre','2nd group, TestPre','EPM mice, TestPre'};

figure
MakeSpreadAndBoxPlot3_SB({Imm_score Imm_score(ind_grp1)...
    Imm_score(ind_grp2) Imm_score_epm_pre},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('immobility score (a.u.)')

% EPM
clear OpenArm_Prop OpenArm_Entries ClosedArm_Entries Ratio_Entries
Dir=PathForExperimentsEmbReact('EPM');
j=1;
for mouse=[1 2 4 5 6 7 8 11 12 13 14 15 16]
    cd(Dir.path{mouse}{1})
    
    clear Behav
    load('behavResources_SB.mat', 'Behav')
    Epoch = intervalSet(0,300e4);
    for i=1:3
        Behav.ZoneEpoch{i} = and(Behav.ZoneEpoch{i} , Epoch);
        Behav.ZoneEpoch{i} = dropShortIntervals(Behav.ZoneEpoch{i} , 1e4);
        Behav.ZoneEpoch{i} = mergeCloseIntervals(Behav.ZoneEpoch{i},1e4);
    end
    
    OpenArm_Prop(j) = sum(DurationEpoch(Behav.ZoneEpoch{1}))/(sum(DurationEpoch(Behav.ZoneEpoch{1})) + ...
        sum(DurationEpoch(Behav.ZoneEpoch{2})) + sum(DurationEpoch(Behav.ZoneEpoch{3})));
    OpenArm_Entries(j) = length(Start(Behav.ZoneEpoch{1}));
    ClosedArm_Entries(j) = length(Start(Behav.ZoneEpoch{2}));
    Ratio_Entries(j) = OpenArm_Entries(j)/(OpenArm_Entries(j) + ClosedArm_Entries(j));
    
    Speed_EPM{j} = ConcatenateDataFromFolders_SB(Dir.path{mouse},'speed');
    DistanceTraveled_EPM(j) = nanmean(Data(Speed_EPM{j}))*300;
    clear D
    D = Data(Speed_EPM{j}); D=D(D<2);
    ImmobilityTime_EPM(j) = length(D)/length(Data(Speed_EPM{j}));
    
    j=j+1;
    disp(Dir.ExpeInfo{mouse}{1}.nmouse)
end
OpenArm_Entries(OpenArm_Entries>30) = NaN;
Imm_score_epm_epm = 2*(ImmobilityTime_EPM-min(ImmobilityTime.TestPre))/(max(ImmobilityTime.TestPre)-min(ImmobilityTime.TestPre))-1; % normalisation [-1 1]

% TestPre
Dir=PathForExperimentsEmbReact('TestPre');
i=1;
for mouse=2:14
    AlignedPosition.TestPre{i} = ConcatenateDataFromFolders_SB(Dir.path{mouse},'AlignedPosition');
    Thigmo_score_epm.TestPre(i) = Thigmo_From_Position_BM(AlignedPosition.TestPre{i});
    Speed_Pre{i} = ConcatenateDataFromFolders_SB(Dir.path{mouse},'speed');
    DistanceTraveled_Pre(i) = nanmean(Data(Speed_Pre{i}))*300;
    clear D
    D = Data(Speed_Pre{i}); D=D(D<2);
    ImmobilityTime_Pre(i) = length(D)/length(Data(Speed_Pre{i}));
    
    i=i+1;
        disp(Dir.ExpeInfo{mouse}{1}.nmouse)
end
Thigmo_score_epm.TestPre(Thigmo_score_epm.TestPre==0) = NaN;
Imm_score_epm_pre = 2*(ImmobilityTime_EPM.TestPre-min(ImmobilityTime.TestPre))/(max(ImmobilityTime.TestPre)-min(ImmobilityTime.TestPre))-1; % normalisation [-1 1]


figure
subplot(221)
PlotCorrelations_BM(Imm_score_epm_pre,OpenArm_Prop,'method','pearson')
xlabel('Immobility score, Test Pre'), ylabel('Open arm time (prop)')
axis square

subplot(222)
PlotCorrelations_BM(Imm_score_epm_pre,OpenArm_Entries,'method','pearson')
xlabel('Immobility score, Test Pre'), ylabel('Open arm entries (#)')
axis square


subplot(223)
PlotCorrelations_BM(Thigmo_score_epm.TestPre,OpenArm_Prop,'method','spearman')
xlabel('Thigmo score, Test Pre (a.u.)'), ylabel('Open arm entries (#)')
axis square

subplot(224)
PlotCorrelations_BM(Thigmo_score_epm.TestPre,OpenArm_Entries,'method','spearman')
xlabel('Thigmo score, Test Pre (a.u.)'), ylabel('Open arm entries (#)')
axis square


% Cond & TestPost
Dir=PathForExperimentsEmbReact('UMazeCond');
i=1;
for mouse=2:14
    FreezeEpoch{i} = ConcatenateDataFromFolders_SB(Dir.path{mouse},'epoch','epochname','freezeepoch');
    ZoneEpoch{i} = ConcatenateDataFromFolders_SB(Dir.path{mouse},'epoch','epochname','zoneepoch');
    Freeze_Shock{i} = and(FreezeEpoch{i} , ZoneEpoch{i}{1});
    Freeze_Safe{i} = and(FreezeEpoch{i} , or(ZoneEpoch{i}{2} , ZoneEpoch{i}{5}));
    Freeze_All_Dur(i) = sum(DurationEpoch(FreezeEpoch{i}))/60e4;
    Freeze_Shock_Dur(i) = sum(DurationEpoch(Freeze_Shock{i}))/60e4;
    Freeze_Safe_Dur(i) = sum(DurationEpoch(Freeze_Safe{i}))/60e4;
    ShockZoneEntries_Cond(i) = sum(ConcatenateDataFromFolders_SB(Dir.path{mouse},'sz_entries'));
    AlignedPosition.Cond{i} = ConcatenateDataFromFolders_SB(Dir.path{mouse},'AlignedPosition');
    Thigmo_score_epm.Cond(i) = Thigmo_From_Position_BM(AlignedPosition.Cond{i});
    
    Speed_Cond{i} = ConcatenateDataFromFolders_SB(Dir.path{mouse},'speed');
    DistanceTraveled_Cond(i) = nanmean(Data(Speed_Maze{i}))*(max(Range(Speed_Cond{i}))/1e4);
    
    i=i+1;
    disp(Dir.ExpeInfo{mouse}{1}.nmouse)
end


Dir=PathForExperimentsEmbReact('TestPost');
i=1;
for mouse=2:14
    ShockZoneEntries_Post(i) = sum(ConcatenateDataFromFolders_SB(Dir.path{mouse},'sz_entries'));
    AlignedPosition.Post{i} = ConcatenateDataFromFolders_SB(Dir.path{mouse},'AlignedPosition');
    Thigmo_score_epm.Post(i) = Thigmo_From_Position_BM(AlignedPosition.Post{i});
    
    i=i+1;
end

A = OpenArm_Prop;
A = OpenArm_Entries;
A = Ratio_Entries;


figure
subplot(231)
PlotCorrelations_BM(ShockZoneEntries_Cond , A,'method','pearson')
xlabel('shock zone entries, Cond'), ylabel('Open arm time (prop)')
axis square

subplot(232)
PlotCorrelations_BM(ShockZoneEntries_Post , A,'method','pearson')
xlabel('shock zone entries, Test Post'), ylabel('Open arm time (prop)')
axis square

subplot(233)
PlotCorrelations_BM(Thigmo_score_epm.Cond , A,'method','pearson')
xlabel('Thigmo score, Cond'), ylabel('Open arm time (prop)')
axis square


subplot(234)
PlotCorrelations_BM(Freeze_All_Dur , A,'method','pearson')
xlabel('fz duration'), ylabel('Open arm time (prop)')
axis square

subplot(235)
PlotCorrelations_BM(Freeze_Shock_Dur , A,'method','pearson')
xlabel('fz shock duration'), ylabel('Open arm time (prop)')
axis square

subplot(236)
PlotCorrelations_BM(Freeze_Safe_Dur , A,'method','pearson')
xlabel('fz safe duration'), ylabel('Open arm time (prop)')
axis square




figure
PlotCorrelations_BM(Imm_score_epm_epm,Imm_score_epm_pre,'method','pearson')
axis square



%%
% with shock zone entries
figure
subplot(131)
A=ShockEntriesZone.TestPre{1};
PlotCorrelations_BM(Imm_score,A,'method','pearson')
axis square
xlabel('model score pre'), ylabel('shock zone entries, TestPre'), ylim([0 30]), xlim([-1.2 1.2])

subplot(132)
A=ShockEntriesZone.Cond{1};
A(~ind)=NaN; A(A>30)=NaN;
PlotCorrelations_BM(Imm_score,A,'method','spearman')
axis square
xlabel('model score pre'), ylabel('shock zone entries, Cond'), ylim([0 30]), xlim([-1.2 1.2])

subplot(133)
A=ShockEntriesZone.TestPost{1};
PlotCorrelations_BM(Imm_score,A,'method','spearman')
axis square
xlabel('model score pre'), ylabel('shock zone entries, TestPost'), ylim([0 16]), xlim([-1.2 1.2])



%% Others
% DZP in TestPost
load('/media/nas7/ProjetEmbReact/DataEmbReact/Workspace_DrugsOverview.mat', 'Speed')
Mouse=[11200 11206 11207 11251 11252 11253 11254];
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    clear D
    D = Data(Speed.TestPost.(Mouse_names{mouse})); D=D(D<2);
    ImmobilityTime_DZP.TestPost(mouse) = length(D)/length(Data(Speed.TestPost.(Mouse_names{mouse})));
end
Imm_score_dzp_post = 2*(ImmobilityTime_DZP.TestPost-min(ImmobilityTime.TestPre))/(max(ImmobilityTime.TestPre)-min(ImmobilityTime.TestPre))-1; % normalisation [-1 1]


Cols={[1 .5 1],[1 .5 .5],[.5 .5 1],[.5 1 .5],[0.95 0.32 0.2]};
X=1:5;
Legends={'all mice, TestPre','1st group, TestPre','2nd group, TestPre','all mice, TestPost','DZP mice, TestPost'};

figure
MakeSpreadAndBoxPlot3_SB({Imm_score Imm_score(ind_grp1)...
    Imm_score(ind_grp2) Imm_score_post Imm_score_dzp_post},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('immobility score (a.u.)')


% FLX pre and post
load('model_results_FLX_pre_post.mat')
model_results_FLX2 = model_results_FLX(1:12,:);
FLX_pre = (model_results_FLX2'-mu)./sigma;
for mouse=1:7
    proj_flx_pre(mouse) = dot(FLX_pre(mouse,:) , W_norm);
end
proj_flx_pre2=2*(proj_flx_pre-min(proj_mice_pre))/(max(proj_mice_pre)-min(proj_mice_pre))-1;

model_results_FLX3 = model_results_FLX(13:24,:);
FLX_post = (model_results_FLX3'-mu)./sigma;
for mouse=1:7
    proj_flx_post(mouse) = dot(FLX_post(mouse,:) , W_norm);
end
proj_flx_post2=2*(proj_flx_post-min(proj_mice_pre))/(max(proj_mice_pre)-min(proj_mice_pre))-1;


Cols2={[1 .5 1],[1 .5 .5],[.5 .5 1],[.5 1 .5],[0.95 0.32 0.2],[0.7 0.7 0.5]};
X2=1:6;
Legends2={'all mice, TestPre','1st group, TestPre','2nd group, TestPre','all mice, TestPost','FLX mice, TestPre','FLX mice, TestPost'};

figure
MakeSpreadAndBoxPlot3_SB({proj_mice_pre2 proj_mice_pre2([6 18 15 9 4 5 11 21])...
    proj_mice_pre2([17 10 20 16 2 13 3 7 8 12 14 1 19]) proj_mice_post2 proj_flx_pre2 proj_flx_post2},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('model score (a.u.)')


% Experimenter
Cols2={[1 .5 1],[1 .5 .5],[.5 .5 1],[1 0 0],[0 0 1],[0 1 0]};
Legends2={'all mice','1st group','2nd group','SB','CS','BM'};
X2=1:6;

figure
MakeSpreadAndBoxPlot3_SB({proj_mice_pre2 proj_mice_pre2([6 18 15 9 4 5 11 21]) proj_mice_pre2([17 10 20 16 2 13 3 7 8 12 14 1 19])...
    proj_mice_pre2([1:3 17 18]) proj_mice_pre2([19 19]) proj_mice_pre2([4:16 20 21])},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('model score (a.u.)')
hline(0,'--r')


% Correlation with RA
figure
A=RA_number.Saline;
A(~ind)=NaN; 
PlotCorrelations_BM(proj_mice_pre2,A,'method','pearson')
axis square
xlabel('model score pre'), ylabel('RA, Cond'), ylim([0 30]), xlim([-1.2 1.2])


% Correlation with respi diff
Diff.Cond = Respi_Shock.Cond{1}-Respi_Safe.Cond{1};
Diff.Ext = Respi_Shock.Ext{1}-Respi_Safe.Ext{1};

figure
subplot(121)
A=Diff.Cond;
PlotCorrelations_BM(proj_mice_pre2,A,'method','pearson')
axis square
xlabel('model score pre'), ylabel('Respi diff, Cond'), ylim([-.5 3.5]), xlim([-1.2 1.2])
subplot(122)
A=Diff.Ext;
PlotCorrelations_BM(proj_mice_pre2,A,'method','pearson')
axis square
xlabel('model score pre'), ylabel('Respi diff, Ext'), ylim([-.5 3.5]), xlim([-1.2 1.2])


% Correlation with speed in Cond
for mouse=1:length(Mouse_names)
    Speed_All.Cond(mouse) = nanmean(Data(Speed.Cond.(Mouse_names{mouse})));
end
Speed_All.Cond(17)=NaN;


figure
A=Speed_All.Cond;
A(~ind)=NaN; 
PlotCorrelations_BM(proj_mice_pre2,A,'method','pearson')
axis square
xlabel('model score pre'), ylabel('mean speed, Cond'), ylim([1 5]), xlim([-1.2 1.2])


% Correlation with thigmotaxis score
figure
A=saline(44,:);
% A(~ind)=NaN; 
PlotCorrelations_BM(proj_mice_pre2,A,'method','spearman')
axis square
xlabel('model score pre'), ylabel('thigmo, TestPre'), %ylim([1 5]), xlim([-1.2 1.2])



% Intravariability
model_results_hab_688 = model_results_sameHabM688;
M688_hab = (model_results_hab_688'-mu)./sigma;
for it=1:13
    proj_M688_hab(it) = dot(M688_hab(it,:) , W_norm);
end
proj_M688_hab2=2*(proj_M688_hab-min(proj_mice_pre))/(max(proj_mice_pre)-min(proj_mice_pre))-1;


Cols2={[1 .5 1],[1 .5 .5],[.5 .5 1],[.5 1 .5]};
Legends2={'all mice, TestPre','1st group, TestPre','2nd group, TestPre','M688 Hab'};
X2=1:4;

figure
MakeSpreadAndBoxPlot3_SB({proj_mice_pre2 proj_mice_pre2([6 18 15 9 4 5 11 21])...
    proj_mice_pre2([17 10 20 16 2 13 3 7 8 12 14 1 19]) proj_M688_hab2},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('model score (a.u.)')




model_results_hab_739 = model_results_samePostM739;
M739_post = (model_results_hab_739'-mu)./sigma;
for it=1:20
    proj_M739_post(it) = dot(M739_post(it,:) , W_norm);
end
proj_M739_post2=2*(proj_M739_post-min(proj_mice_pre))/(max(proj_mice_pre)-min(proj_mice_pre))-1;


Legends2={'all mice, TestPre','1st group, TestPre','2nd group, TestPre','M739 Post'};

figure
MakeSpreadAndBoxPlot3_SB({proj_mice_pre2 proj_mice_pre2([6 18 15 9 4 5 11 21])...
    proj_mice_pre2([17 10 20 16 2 13 3 7 8 12 14 1 19]) proj_M739_post2},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('model score (a.u.)')


% Params model for 2 groups
for param=1:12
    Param{param}{1} = saline_pre(ind_grp1,param);
    Param{param}{2} = saline_pre(ind_grp2,param);
end

Cols2={[1 .5 .5],[.5 .5 1]};
Legends2={'1st group, TestPre','2nd group, TestPre'};
NoLegends={'',''};
X2=1:2;

figure
for param=1:12
    subplot(2,6,param)
    if param<7
        MakeSpreadAndBoxPlot3_SB(Param{param},Cols2,X2,NoLegends,'showpoints',1,'paired',0);
    else
        MakeSpreadAndBoxPlot3_SB(Param{param},Cols2,X2,Legends2,'showpoints',1,'paired',0);
    end
    title(Var_Names(param))
end

figure
for param=1:12
    subplot(2,6,param)
    PlotCorrelations_BM(proj_mice_pre2 , saline_pre(:,param)')
    axis square
    if param>6; xlabel('model score (a.u.)'); end
    if or(param==1 , param==7); ylabel('model score (a.u.)'); end
    title(Var_Names(param))
end

figure
for param=1:12
    subplot(2,6,param)
    [R0,P0]=PlotCorrelations_BM(proj_mice_pre2 , saline_pre(:,param)')
    [R1,P1]=PlotCorrelations_BM(proj_mice_pre2(ind_grp1) , saline_pre(ind_grp1,param)','Color','r')
    [R2,P2]=PlotCorrelations_BM(proj_mice_pre2(ind_grp2) , saline_pre(ind_grp2,param)','Color','b')
    f=get(gca,'Children'); legend([f(3),f(2),f(1)],['R = ' num2str(R0) '     P = ' num2str(P0)] ,...
        ['R = ' num2str(R1) '     P = ' num2str(P1)],['R = ' num2str(R2) '     P = ' num2str(P2)]);
    axis square
    if param>6; xlabel('model score (a.u.)'); end
    if or(param==1 , param==7); ylabel('model score (a.u.)'); end
    title(Var_Names(param))
end

