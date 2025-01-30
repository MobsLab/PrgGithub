
GetEmbReactMiceFolderList_BM
GetAllSalineSessions_BM

noise_thr=12;
Clr = {[],[],[],[],[0.8500, 0.3250, 0.0980],[0.4940, 0.1840, 0.5560],[],[0.75, 0.75, 0],[0.6350, 0.0780, 0.1840]};

cd('/media/nas6/ProjetEmbReact/Mouse1227/20210811/ProjectEmbReact_M1227_20210811_TestPre_PreDrug/TestPre2')
load('B_Low_Spectrum.mat')
%%

SessNames={'TestPre'};
Dir1=PathForExperimentsEmbReact(SessNames{1});

SessNames={'TestPreNight'};
Dir2=PathForExperimentsEmbReact(SessNames{1});

SessNames={'TestPre_EyeShockTempProt'};
Dir3=PathForExperimentsEmbReact(SessNames{1});

SessNames={'TestPre_EyeShock'};
Dir4=PathForExperimentsEmbReact(SessNames{1});

SessNames={'TestPre_PreDrug_TempProt'};
Dir5=PathForExperimentsEmbReact(SessNames{1});

SessNames={'TestPre_PreDrug'};
Dir6=PathForExperimentsEmbReact(SessNames{1});

Dir7=MergePathForExperiment(Dir1,Dir2);
Dir8=MergePathForExperiment(Dir3,Dir4);
Dir9=MergePathForExperiment(Dir5,Dir6);

Dir10=MergePathForExperiment(Dir7,Dir8);
Dir=MergePathForExperiment(Dir10,Dir9);


for d=1:length(Dir.path)
    Mouse_names{d}= ['M' num2str(Dir.ExpeInfo{1, d}{1, 1}.nmouse)];
    Mouse(d)=Dir.ExpeInfo{1, d}{1, 1}.nmouse;
end

Mouse=Mouse([2:21 26:113 115:119 121:123 125 128 131:162 164:end]);


%%
for mouse=1:158%length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    
    % Frezing analysis
    Speed.Fear.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FearSess.(Mouse_names{mouse}),'speed');
    
    Freeze_Epoch.Fear.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FearSess.(Mouse_names{mouse}),'Epoch','epochname','freezeepoch_withnoise');
    ZoneEpoch.Fear.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FearSess.(Mouse_names{mouse}),'Epoch','epochname','zoneepoch_behav');
    
    ShockEpoch.Fear.(Mouse_names{mouse}) = ZoneEpoch.Fear.(Mouse_names{mouse}){1};
    SafeEpoch.Fear.(Mouse_names{mouse}) = or(ZoneEpoch.Fear.(Mouse_names{mouse}){2},ZoneEpoch.Fear.(Mouse_names{mouse}){5});
    
    % Stim analysis
    StimEpoch.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'Epoch','epochname','stimepoch');
    BlockedEpoch.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'epoch','epochname','blockedepoch');
    StimEpochBlocked.(Mouse_names{mouse}) = and(StimEpoch.(Mouse_names{mouse}) , BlockedEpoch.(Mouse_names{mouse}));
    ExtraStim.(Mouse_names{mouse}) = length(Start(StimEpoch.(Mouse_names{mouse})))-length(Start(StimEpochBlocked.(Mouse_names{mouse})));
    ExtraStim_All(mouse) = ExtraStim.(Mouse_names{mouse});
    
    % Test Post analysis
    ZoneEpoch.TestPost.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(TestPostSess.(Mouse_names{mouse}),'Epoch','epochname','zoneepoch_behav');
    ShockZoneEpoch.TestPost.(Mouse_names{mouse})=ZoneEpoch.TestPost.(Mouse_names{mouse}){1};
    SafeZoneEpoch.TestPost.(Mouse_names{mouse})=ZoneEpoch.TestPost.(Mouse_names{mouse}){2};
    
    ShockZonePostTime.(Mouse_names{mouse})=sum(Stop(ShockZoneEpoch.TestPost.(Mouse_names{mouse}))-Start(ShockZoneEpoch.TestPost.(Mouse_names{mouse})));
    SafeZonePostTime.(Mouse_names{mouse})=sum(Stop(SafeZoneEpoch.TestPost.(Mouse_names{mouse}))-Start(SafeZoneEpoch.TestPost.(Mouse_names{mouse})));
    ShockVersusSafeZonesPost.(Mouse_names{mouse})=ShockZonePostTime.(Mouse_names{mouse})/SafeZonePostTime.(Mouse_names{mouse});
    
    % Test Pre analysis
        ZoneEpoch.TestPre.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(TestPreSess.(Mouse_names{mouse}),'epoch','epochname','zoneepoch_behav');
    for zones=1:5
        Zone_c.TestPre.(Mouse_names{mouse}){zones} = ZoneEpoch.TestPre.(Mouse_names{mouse}){zones};
    end
    
    ShockZoneEpoch.TestPre.(Mouse_names{mouse})=Zone_c.TestPre.(Mouse_names{mouse}){1};
    SafeZoneEpoch.TestPre.(Mouse_names{mouse})=or(Zone_c.TestPre.(Mouse_names{mouse}){2},Zone_c.TestPre.(Mouse_names{mouse}){5});
    
    [ShockZoneEpoch_Corrected.TestPre.(Mouse_names{mouse}) , SafeZoneEpoch_Corrected.TestPre.(Mouse_names{mouse})] =...
        Correct_ZoneEntries_Maze_BM(ShockZoneEpoch.TestPre.(Mouse_names{mouse}) , SafeZoneEpoch.TestPre.(Mouse_names{mouse}));
    
    ShockEntriesZone.TestPre(mouse) = length(Start(ShockZoneEpoch_Corrected.TestPre.(Mouse_names{mouse})));
    SafeEntriesZone.TestPre(mouse) = length(Start(SafeZoneEpoch_Corrected.TestPre.(Mouse_names{mouse})));
    
        
    
%     ZoneEpoch.TestPre.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(TestPreSess.(Mouse_names{mouse}),'Epoch','epochname','zoneepoch_behav');
%     
%     ShockZoneEpoch.TestPre.(Mouse_names{mouse})=ZoneEpoch.TestPre.(Mouse_names{mouse}){1};
%     SafeZoneEpoch.TestPre.(Mouse_names{mouse})=ZoneEpoch.TestPre.(Mouse_names{mouse}){2};
%     
%     ShockZonePreTime.(Mouse_names{mouse})=sum(Stop(ShockZoneEpoch.TestPre.(Mouse_names{mouse}))-Start(ShockZoneEpoch.TestPre.(Mouse_names{mouse})));
%     SafeZonePreTime.(Mouse_names{mouse})=sum(Stop(SafeZoneEpoch.TestPre.(Mouse_names{mouse}))-Start(SafeZoneEpoch.TestPre.(Mouse_names{mouse})));
%     
%     ShockVersusSafeZonesPre.(Mouse_names{mouse})=ShockZonePreTime.(Mouse_names{mouse})/SafeZonePreTime.(Mouse_names{mouse});
%     ShockVersusSafePostTime(mouse)=ShockVersusSafeZonesPost.(Mouse_names{mouse});
%     ShockVersusSafePreTime(mouse)=ShockVersusSafeZonesPre.(Mouse_names{mouse});
    
    %     % stress features
    %     meanEKG.TestPre(mouse)=nanmean(Data(ConcatenateDataFromFolders_SB(TestPreSess.(Mouse_names{mouse}),'heartrate')));
    %     meanAcc.TestPre(mouse)=nanmean(Data(ConcatenateDataFromFolders_SB(TestPreSess.(Mouse_names{mouse}),'accelero')));
    %     meanTemp.TestPre(mouse)=nanmean(Data(ConcatenateDataFromFolders_SB(TestPreSess.(Mouse_names{mouse}),'masktemperature')));
    %     meanSpeed.TestPre(mouse)=nanmean(Data(ConcatenateDataFromFolders_SB(TestPreSess.(Mouse_names{mouse}),'speed')));
    
    %Occupancy
    OccupancyShockPre.(Mouse_names{mouse})=sum(Stop(ZoneEpoch.TestPre.(Mouse_names{mouse}){1})-Start(ZoneEpoch.TestPre.(Mouse_names{mouse}){1}))/(max(Range(Speed.Fear.(Mouse_names{mouse}))));
    OccupancyShockPost.(Mouse_names{mouse})=sum(Stop(ZoneEpoch.TestPost.(Mouse_names{mouse}){1})-Start(ZoneEpoch.TestPost.(Mouse_names{mouse}){1}))/(max(Range(Speed.Fear.(Mouse_names{mouse}))));
    OccupancySafePre.(Mouse_names{mouse})=sum(Stop(ZoneEpoch.TestPre.(Mouse_names{mouse}){2})-Start(ZoneEpoch.TestPre.(Mouse_names{mouse}){2}))/(max(Range(Speed.Fear.(Mouse_names{mouse}))));
    OccupancySafePost.(Mouse_names{mouse})=sum(Stop(ZoneEpoch.TestPost.(Mouse_names{mouse}){2})-Start(ZoneEpoch.TestPost.(Mouse_names{mouse}){2}))/(max(Range(Speed.Fear.(Mouse_names{mouse}))));
    
    OccupancyShockPost_All(mouse)=OccupancyShockPost.(Mouse_names{mouse});
    
    %     % OB mean spectrum maxima
    %     OBSpec.Fear.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FearSess.(Mouse_names{mouse}),'spectrum','prefix','B_Low');
    %     OBSpec.Fear.Fz.(Mouse_names{mouse})=Restrict(OBSpec.Fear.(Mouse_names{mouse}),Freeze_Epoch.Fear.(Mouse_names{mouse}));
    %     OBSpec.Fear.Fz_Shock.(Mouse_names{mouse})=Restrict(OBSpec.Fear.Fz.(Mouse_names{mouse}),ShockEpoch.Fear.(Mouse_names{mouse}) );
    %     OBSpec.Fear.Fz_Safe.(Mouse_names{mouse})=Restrict(OBSpec.Fear.Fz.(Mouse_names{mouse}),SafeEpoch.Fear.(Mouse_names{mouse}));
    %     AllSpectrum.Shock(mouse,:) = nanmean(zscore_nan_BM(Data(OBSpec.Fear.Fz_Shock.(Mouse_names{mouse}))')') ;
    %     AllSpectrum.Safe(mouse,:) = nanmean(zscore_nan_BM(Data(OBSpec.Fear.Fz_Safe.(Mouse_names{mouse}))')') ;
    %     [PowerMax.Shock.(Mouse_names{mouse}),FreqMax.Shock.(Mouse_names{mouse})]=max(AllSpectrum.Shock(mouse,noise_thr:end));
    %     [PowerMax.Safe.(Mouse_names{mouse}),FreqMax.Safe.(Mouse_names{mouse})]=max(AllSpectrum.Safe(mouse,noise_thr:end));
    %     FreqMaxAll.Shock(mouse) = Spectro{3}(FreqMax.Shock.(Mouse_names{mouse})+noise_thr);
    %     FreqMaxAll.Safe(mouse) = Spectro{3}(FreqMax.Safe.(Mouse_names{mouse})+noise_thr);
    
    % thigmotaxis
    Position.TestPre.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(TestPreSess.(Mouse_names{mouse}),'alignedposition');
    Thigmo.TestPre.(Mouse_names{mouse})=Thigmo_From_Position_BM(Position.TestPre.(Mouse_names{mouse}));
    
    disp(Mouse_names{mouse})
end

Mouse=Mouse(1:158);


% ShockVersusSafePostTime(20)=NaN; OccupancyShockPost_All(20)=NaN;

for mouse = 1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    
    FreezeTime(1,mouse)=sum(Stop(Freeze_Epoch.Fear.(Mouse_names{mouse}))-Start(Freeze_Epoch.Fear.(Mouse_names{mouse})));
    FreezeTime(2,mouse)=max(Range(Speed.Fear.(Mouse_names{mouse})));
    FreezeTime(3,mouse)=(FreezeTime(1,mouse)/FreezeTime(2,mouse))*100;
end
ShockVersusSafe=[ShockVersusSafePreTime' ShockVersusSafePostTime'];
FreqMaxAll.Shock(27)=2.8; FreqMaxAll.Safe(6)=4.12; FreqMaxAll.Safe(8)=2.52; FreqMaxAll.Safe(9)=2.75; FreqMaxAll.Safe(12)=1.68;


SessNames={'TestPost_PostDrug'};
Dir=PathForExperimentsEmbReact(SessNames{1});
for d=130:length(Dir.path)
    Mouse_names{d}= ['M' num2str(Dir.ExpeInfo{1, d}{1, 1}.nmouse)];
    Mouse(d)=Dir.ExpeInfo{1, d}{1, 1}.nmouse;
    DrugType{d} = Dir.ExpeInfo{1,d}{1,1}.DrugInjected;
    MazeType{d} = Dir.ExpeInfo{1,d}{1,1}.RecordingBox;
    Experimenter{d} = Dir.ExpeInfo{1,d}{1,1}.Experimenter;
    try
        MazeOrder{d} = Dir.ExpeInfo{1,d}{1,1}.MazeOrder;
    end
end
Mouse(d)

for mouse=1:length(Mouse)
    
    if convertCharsToStrings(DrugType{mouse}) == 'SALINE'
        Sum_Up_Array(1,mouse) = 1;
    elseif convertCharsToStrings(DrugType{mouse}) == 'FLXCHRONIC'
        Sum_Up_Array(1,mouse) = 2;
    elseif convertCharsToStrings(DrugType{mouse}) == 'ACUTE_FLX'
        Sum_Up_Array(1,mouse) = 3;
    elseif convertCharsToStrings(DrugType{mouse}) == 'MDZ'
        Sum_Up_Array(1,mouse) = 4;
    elseif convertCharsToStrings(DrugType{mouse}) == 'DIAZEPAM'
        Sum_Up_Array(1,mouse) = 5;
    elseif convertCharsToStrings(DrugType{mouse}) == 'CHRONIC_BUS'
        Sum_Up_Array(1,mouse) = 6;
    elseif convertCharsToStrings(DrugType{mouse}) == 'BUSPIRONE'
        Sum_Up_Array(1,mouse) = 7;
    elseif convertCharsToStrings(DrugType{mouse}) == 'RIP_INHIB'
        Sum_Up_Array(1,mouse) = 8;
    elseif convertCharsToStrings(DrugType{mouse}) == 'RIP_CTRL'
        Sum_Up_Array(1,mouse) = 9;
    end
    
    if convertCharsToStrings(MazeType{mouse}) == 'UMaze1'
        Sum_Up_Array(2,mouse) = 1;
    elseif convertCharsToStrings(MazeType{mouse}) == 'UMaze2'
        Sum_Up_Array(2,mouse) = 2;
    elseif convertCharsToStrings(MazeType{mouse}) == 'UMaze3'
        Sum_Up_Array(2,mouse) = 3;
    elseif convertCharsToStrings(MazeType{mouse}) == 'UMaze4'
        Sum_Up_Array(2,mouse) = 4;
    end
    
    if convertCharsToStrings(Experimenter{mouse}) == 'SB'
        Sum_Up_Array(3,mouse) = 1;
    elseif convertCharsToStrings(Experimenter{mouse}) == 'BM'
        Sum_Up_Array(3,mouse) = 2;
    end
    
    try
        Sum_Up_Array(4,mouse) = MazeOrder{mouse};
    catch
        Sum_Up_Array(4,mouse) = 1;
    end
end


I=[1:length(Mouse)];
Saline_ind= I(Sum_Up_Array(1,:)==1);
ChronicFlx_ind= I(Sum_Up_Array(1,:)==2);
AcuteFlx_ind= I(Sum_Up_Array(1,:)==3);
Mdz_ind= I(Sum_Up_Array(1,:)==4);
Dzp_ind= I(Sum_Up_Array(1,:)==5);
ChronicBus_ind= I(Sum_Up_Array(1,:)==6);
AcuteBus_ind= I(Sum_Up_Array(1,:)==7);
RipInhib_ind= I(Sum_Up_Array(1,:)==8);
RipControl_ind= I(Sum_Up_Array(1,:)==9);


%% Global overview
figure
subplot(411)
plot(FreezeTime(3,:)); hold on
plot(Saline_ind,FreezeTime(3,Saline_ind),'.b','MarkerSize',30)
plot(ChronicFlx_ind,FreezeTime(3,ChronicFlx_ind),'.r','MarkerSize',30)
plot(AcuteFlx_ind,FreezeTime(3,AcuteFlx_ind),'.g','MarkerSize',30)
plot(Mdz_ind,FreezeTime(3,Mdz_ind),'.m','MarkerSize',30)
plot(Dzp_ind,FreezeTime(3,Dzp_ind),'.','MarkerSize',30,'Color',[0.8500, 0.3250, 0.0980])
plot(ChronicBus_ind,FreezeTime(3,ChronicBus_ind),'.','MarkerSize',30,'Color',[0.4940, 0.1840, 0.5560])
plot(AcuteBus_ind,FreezeTime(3,AcuteBus_ind),'.c','MarkerSize',30)
plot(RipInhib_ind,FreezeTime(3,RipInhib_ind),'.','MarkerSize',30,'Color',[0.75, 0.75, 0])
plot(RipControl_ind,FreezeTime(3,RipControl_ind),'.','MarkerSize',30,'Color',[0.6350, 0.0780, 0.1840])
ylabel('Freezing percentage (%)'); xlim([0 92])
xticks([1:length(Mouse)]); xticklabels({'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',})
makepretty
legend('Freezing','Saline','Chronic fluoxetine','Acute Flx','Midazolam','Diazepam','Buspirone','Rip Inhibition','Rip control')
title('Freezing proportion, cond sess')
vline(26.5,'--r','Sophie doing the UMaze')
vline(27.5,'--r','Baptiste doing the UMaze')
vline(28.5,'--k','Summer break')
hline(20,'--r')

subplot(412)
plot(ExtraStim_All); hold on
plot(Saline_ind,ExtraStim_All(Saline_ind),'.b','MarkerSize',30)
plot(ChronicFlx_ind,ExtraStim_All(ChronicFlx_ind),'.r','MarkerSize',30)
plot(AcuteFlx_ind,ExtraStim_All(AcuteFlx_ind),'.g','MarkerSize',30)
plot(Mdz_ind,ExtraStim_All(Mdz_ind),'.m','MarkerSize',30)
plot(Dzp_ind,ExtraStim_All(Dzp_ind),'.','MarkerSize',30,'Color',[0.8500, 0.3250, 0.0980])
plot(ChronicBus_ind,ExtraStim_All(ChronicBus_ind),'.','MarkerSize',30,'Color',[0.4940, 0.1840, 0.5560])
plot(AcuteBus_ind,ExtraStim_All(AcuteBus_ind),'.c','MarkerSize',30)
plot(RipInhib_ind,ExtraStim_All(RipInhib_ind),'.','MarkerSize',30,'Color',[0.75, 0.75, 0])
plot(RipControl_ind,ExtraStim_All(RipControl_ind),'.','MarkerSize',30,'Color',[0.6350, 0.0780, 0.1840])
ylabel('extra shocks number'); xlim([0 92]); ylim([0 80])
xticks([1:length(Mouse)]); xticklabels({'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',})
makepretty
title('Extra shocks')
vline(26.5,'--r')
vline(27.5,'--r')
vline(28.5,'--k')
hline(15,'--r')

subplot(413)
plot(OccupancyShockPost_All); hold on
plot(Saline_ind,OccupancyShockPost_All(Saline_ind),'.b','MarkerSize',30)
plot(ChronicFlx_ind,OccupancyShockPost_All(ChronicFlx_ind),'.r','MarkerSize',30)
plot(AcuteFlx_ind,OccupancyShockPost_All(AcuteFlx_ind),'.g','MarkerSize',30)
plot(Mdz_ind,OccupancyShockPost_All(Mdz_ind),'.m','MarkerSize',30)
plot(Dzp_ind,OccupancyShockPost_All(Dzp_ind),'.','MarkerSize',30,'Color',[0.8500, 0.3250, 0.0980])
plot(ChronicBus_ind,OccupancyShockPost_All(ChronicBus_ind),'.','MarkerSize',30,'Color',[0.4940, 0.1840, 0.5560])
plot(AcuteBus_ind,OccupancyShockPost_All(AcuteBus_ind),'.c','MarkerSize',30)
plot(RipInhib_ind,OccupancyShockPost_All(RipInhib_ind),'.','MarkerSize',30,'Color',[0.75, 0.75, 0])
plot(RipControl_ind,OccupancyShockPost_All(RipControl_ind),'.','MarkerSize',30,'Color',[0.6350, 0.0780, 0.1840])
ylabel('Shock/Safe time in TestPost'); xlim([0 92]); ylim([0 .6])
xticks([1:length(Mouse)]); xticklabels({'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',})
makepretty
title('Test Post : Shock / Safe time')
vline(26.5,'--r')
vline(27.5,'--r')
vline(28.5,'--k')
hline(0.35,'--r')

subplot(414)
plot(FreqMaxAll.Shock,'.','Color',[1 0.5 0.5],'MarkerSize',30); hold on
plot(FreqMaxAll.Shock,'Color',[1 0.5 0.5]); hold on
plot(FreqMaxAll.Safe,'.','Color',[0.5 0.5 1],'MarkerSize',30); hold on
plot(FreqMaxAll.Safe,'Color',[0.5 0.5 1]); hold on
ylabel('OB max frequency'); xlim([0 92]); ylim([0 6])
xticks([1:length(Mouse)]); xticklabels(Mouse_names); xtickangle(45);
makepretty
title('OB Analysis')
% vline([1:35],{'--b','--','--b','--g','--g','--g','--b','--g','--b','--g','--','--m','--b','--m','--m','--m','--m','--m','--r','--r','--r','--b','--r','--r','--m','--m','--b','--r','--b','--b','--r','--r','--b','--b','--k'})
f=get(gca,'Children');
legend([f(3),f(1)],'Shock side freezing','Safe side freezing')

a=suptitle(['Drugs experiments, overview, n=' num2str(length(Mouse))]); a.FontSize=20;


%% By drug group
figure
subplot(221)
plot(FreqMaxAll.Shock(Saline_ind),'.','Color',[1 0.5 0.5],'MarkerSize',30); hold on
plot(FreqMaxAll.Shock(Saline_ind),'Color',[1 0.5 0.5]); hold on
plot(FreqMaxAll.Safe(Saline_ind),'.','Color',[0.5 0.5 1],'MarkerSize',30); hold on
plot(FreqMaxAll.Safe(Saline_ind),'Color',[0.5 0.5 1]); hold on
ylabel('OB max frequency')
xticks([1:12]); xticklabels({'M688','M739','M777','M779','M849','M893','M1096','M1134','M1135','M1144','M1146'}); xtickangle(45);
makepretty; ylim([1 6])
title('Saline mice')
vline(6.5,'--r'); hline(2,'--k'); hline(4,'--k'); 

subplot(222)
plot(FreqMaxAll.Shock(AcuteFlx_ind),'.','Color',[1 0.5 0.5],'MarkerSize',30); hold on
plot(FreqMaxAll.Shock(AcuteFlx_ind),'Color',[1 0.5 0.5]); hold on
plot(FreqMaxAll.Safe(AcuteFlx_ind),'.','Color',[0.5 0.5 1],'MarkerSize',30); hold on
plot(FreqMaxAll.Safe(AcuteFlx_ind),'Color',[0.5 0.5 1]); hold on
xticks([1:5]); xticklabels({'M740','M750','M775','M778','M794'}); xtickangle(45);
makepretty; xlim([0 5]); ylim([1 6])
title('Acute flx mice')
hline(2,'--k'); hline(4,'--k'); 

subplot(223)
plot(FreqMaxAll.Shock(ChronicFlx_ind),'.','Color',[1 0.5 0.5],'MarkerSize',30); hold on
plot(FreqMaxAll.Shock(ChronicFlx_ind),'Color',[1 0.5 0.5]); hold on
plot(FreqMaxAll.Safe(ChronicFlx_ind),'.','Color',[0.5 0.5 1],'MarkerSize',30); hold on
plot(FreqMaxAll.Safe(ChronicFlx_ind),'Color',[0.5 0.5 1]); hold on
xticks([1:8]); xticklabels({'M875','M876','M877','M1001','M1002','M1095','M1130','M1131'}); xtickangle(45);
makepretty; xlim([0 8]); ylim([1 6])
title('Chronic flx mice')
vline(5.5,'--r'); hline(2,'--k'); hline(4,'--k'); 

subplot(224)
plot(FreqMaxAll.Shock(Mdz_ind),'.','Color',[1 0.5 0.5],'MarkerSize',30); hold on
plot(FreqMaxAll.Shock(Mdz_ind),'Color',[1 0.5 0.5]); hold on
plot(FreqMaxAll.Safe(Mdz_ind),'.','Color',[0.5 0.5 1],'MarkerSize',30); hold on
plot(FreqMaxAll.Safe(Mdz_ind),'Color',[0.5 0.5 1]); hold on
xticks([1:9]); xticklabels({'M829','M851','M857','M858','M859','M1005','M1006'}); xtickangle(45);
makepretty; xlim([0 7]); ylim([1 6])
title('Midazolam mice')
 hline(2,'--k'); hline(4,'--k'); 

a=suptitle('OB maximum frequency, overview by drug group'); a.FontSize=20;

% BM groups
figure
subplot(221)
plot(FreqMaxAll.Shock(Dzp_ind),'.','Color',[1 0.5 0.5],'MarkerSize',30); hold on
plot(FreqMaxAll.Shock(Dzp_ind),'Color',[1 0.5 0.5]); hold on
plot(FreqMaxAll.Safe(Dzp_ind),'.','Color',[0.5 0.5 1],'MarkerSize',30); hold on
plot(FreqMaxAll.Safe(Dzp_ind),'Color',[0.5 0.5 1]); hold on
ylabel('OB max frequency')
xticks([1:12]); xticklabels({'M688','M739','M777','M779','M849','M893','M1096','M1134','M1135','M1144','M1146'}); xtickangle(45);
makepretty; ylim([1 6])
title('Saline mice')
vline(6.5,'--r'); hline(2,'--k'); hline(4,'--k'); 

subplot(222)
plot(FreqMaxAll.Shock(ChronicBus_ind),'.','Color',[1 0.5 0.5],'MarkerSize',30); hold on
plot(FreqMaxAll.Shock(ChronicBus_ind),'Color',[1 0.5 0.5]); hold on
plot(FreqMaxAll.Safe(ChronicBus_ind),'.','Color',[0.5 0.5 1],'MarkerSize',30); hold on
plot(FreqMaxAll.Safe(ChronicBus_ind),'Color',[0.5 0.5 1]); hold on
xticks([1:5]); xticklabels({'M740','M750','M775','M778','M794'}); xtickangle(45);
makepretty; xlim([0 5]); ylim([1 6])
title('Chronic BUS mice')
hline(2,'--k'); hline(4,'--k'); 

subplot(223)
plot(FreqMaxAll.Shock(AcuteBus_ind),'.','Color',[1 0.5 0.5],'MarkerSize',30); hold on
plot(FreqMaxAll.Shock(AcuteBus_ind),'Color',[1 0.5 0.5]); hold on
plot(FreqMaxAll.Safe(AcuteBus_ind),'.','Color',[0.5 0.5 1],'MarkerSize',30); hold on
plot(FreqMaxAll.Safe(AcuteBus_ind),'Color',[0.5 0.5 1]); hold on
xticks([1:8]); xticklabels({'M875','M876','M877','M1001','M1002','M1095','M1130','M1131'}); xtickangle(45);
makepretty; xlim([0 8]); ylim([1 6])
title('Acute flx mice')
vline(5.5,'--r'); hline(2,'--k'); hline(4,'--k'); 

subplot(224)
plot(FreqMaxAll.Shock(Mdz_ind),'.','Color',[1 0.5 0.5],'MarkerSize',30); hold on
plot(FreqMaxAll.Shock(Mdz_ind),'Color',[1 0.5 0.5]); hold on
plot(FreqMaxAll.Safe(Mdz_ind),'.','Color',[0.5 0.5 1],'MarkerSize',30); hold on
plot(FreqMaxAll.Safe(Mdz_ind),'Color',[0.5 0.5 1]); hold on
xticks([1:9]); xticklabels({'M829','M851','M857','M858','M859','M1005','M1006'}); xtickangle(45);
makepretty; xlim([0 7]); ylim([1 6])
title('Midazolam mice')
 hline(2,'--k'); hline(4,'--k'); 

a=suptitle('OB maximum frequency, overview by drug group'); a.FontSize=20;

%% Real time analysis

ValueOfDate=DateValue_BM(Dir);

ValueOfDate(1)=69; ValueOfDate(2)=73; ValueOfDate(3)=172; ValueOfDate(4)=175; ValueOfDate(14)=419; 
x=ValueOfDate(27); ValueOfDate(27)=ValueOfDate(28); ValueOfDate(28)=x;

figure
plot(ValueOfDate(Saline_ind),0.1*(1+rand(1,length(Saline_ind))/10),'.b','MarkerSize',30); hold on
plot(ValueOfDate(ChronicFlx_ind),0.2*(1+rand(1,length(ChronicFlx_ind))/6),'.r','MarkerSize',30); hold on
plot(ValueOfDate(AcuteFlx_ind),0.3*(1+rand(1,length(AcuteFlx_ind))/10),'.g','MarkerSize',30); hold on
plot(ValueOfDate(Mdz_ind),0.4*(1+rand(1,length(Mdz_ind))/8),'.m','MarkerSize',30); hold on
plot(ValueOfDate(Dzp_ind),0.5*(1+rand(1,length(Dzp_ind))/6),'.','MarkerSize',30,'Color',[0.8500, 0.3250, 0.0980]); hold on
plot(ValueOfDate(ChronicBus_ind),0.6*(1+rand(1,length(ChronicBus_ind))/6),'.','MarkerSize',30,'Color',[0.4940, 0.1840, 0.5560]); hold on
plot(ValueOfDate(AcuteBus_ind),0.7*(1+rand(1,length(AcuteBus_ind))/6),'.c','MarkerSize',30); hold on
plot(ValueOfDate(RipInhib_ind),0.8*(1+rand(1,length(RipInhib_ind))/6),'.','MarkerSize',30,'Color',[0.75, 0.75, 0]); hold on
plot(ValueOfDate(RipControl_ind),0.9*(1+rand(1,length(RipControl_ind))/6),'.','MarkerSize',30,'Color',[0.6350, 0.0780, 0.1840]); hold on
vline(960,'--r')
makepretty
xticks([0 365 730 1095 1460]); xticklabels({'2018','2019','2020','2021','2022'}); ylim([0.05 1])
legend('Saline','Chronic fluoxetine','Acute Flx','Midazolam','Diazepam','Chronic BUS','Acute BUS','Rip Inhib','Rip control')
yticklabels({''})
title('Real time analysis of UMaze drugs experiments mice')


%% Exploration during CondExplo

for mouse = 1:length(Mouse_names)
    ZoneEpoch.CondExploSess.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondExploSess.(Mouse_names{mouse}),'Epoch','epochname','zoneepoch');
    ShockZoneEpoch.CondExploSess.(Mouse_names{mouse})=ZoneEpoch.CondExploSess.(Mouse_names{mouse}){1};
    SafeZoneEpoch.CondExploSess.(Mouse_names{mouse})=ZoneEpoch.CondExploSess.(Mouse_names{mouse}){2};
    
    ShockZoneCondExploTime.(Mouse_names{mouse})=sum(Stop(ShockZoneEpoch.CondExploSess.(Mouse_names{mouse}))-Start(ShockZoneEpoch.CondExploSess.(Mouse_names{mouse})));
    SafeZoneCondExploTime.(Mouse_names{mouse})=sum(Stop(SafeZoneEpoch.CondExploSess.(Mouse_names{mouse}))-Start(SafeZoneEpoch.CondExploSess.(Mouse_names{mouse})));
    ShockVersusSafeZonesCondExplo.(Mouse_names{mouse})=ShockZoneCondExploTime.(Mouse_names{mouse})/SafeZoneCondExploTime.(Mouse_names{mouse});
    
    ShockVersusSafeCondExploTime(mouse)=ShockVersusSafeZonesCondExplo.(Mouse_names{mouse});
end

figure
subplot(211)
plot(ShockVersusSafeCondExploTime); hold on
plot(Saline_ind,ShockVersusSafeCondExploTime(Saline_ind),'.b','MarkerSize',30)
plot(AcuteFlx_ind,ShockVersusSafeCondExploTime(AcuteFlx_ind),'.g','MarkerSize',30)
plot(Mdz_ind,ShockVersusSafeCondExploTime(Mdz_ind),'.m','MarkerSize',30)
plot(ChronicFlx_ind,ShockVersusSafeCondExploTime(ChronicFlx_ind),'.r','MarkerSize',30)
plot([35],ShockVersusSafeCondExploTime([35]),'.k','MarkerSize',30)
ylabel('Shock/Safe time in CondExplo')
xticks([1:length(Mouse)]); xticklabels({'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',})
makepretty
title('CondExplo : Shock / Safe time')
vline(26.5,'--r')
vline(27.5,'--r')
vline(28.5,'--k')
hline(1,'-r')

subplot(212)
plot(ShockVersusSafePostTime); hold on
plot(Saline_ind,ShockVersusSafePostTime(Saline_ind),'.b','MarkerSize',30)
plot(AcuteFlx_ind,ShockVersusSafePostTime(AcuteFlx_ind),'.g','MarkerSize',30)
plot(Mdz_ind,ShockVersusSafePostTime(Mdz_ind),'.m','MarkerSize',30)
plot(ChronicFlx_ind,ShockVersusSafePostTime(ChronicFlx_ind),'.r','MarkerSize',30)
plot([35],ShockVersusSafePostTime([35]),'.k','MarkerSize',30)
ylabel('Shock/Safe time in TestPost')
xticks([1:length(Mouse)]); xticklabels({'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',})
makepretty
title('Test Post : Shock / Safe time')
vline(26.5,'--r')
vline(27.5,'--r')
vline(28.5,'--k')
hline(1,'-r')
xticks([1:length(Mouse)]); xticklabels(Mouse_names); xtickangle(45);


%% Stress features
figure
subplot(411)
plot(meanAcc.TestPre); hold on
plot(Saline_ind,meanAcc.TestPre(Saline_ind),'.b','MarkerSize',30)
plot(ChronicFlx_ind,meanAcc.TestPre(ChronicFlx_ind),'.r','MarkerSize',30)
plot(AcuteFlx_ind,meanAcc.TestPre(AcuteFlx_ind),'.g','MarkerSize',30)
plot(Mdz_ind,meanAcc.TestPre(Mdz_ind),'.m','MarkerSize',30)
plot(Dzp_ind,meanAcc.TestPre(Dzp_ind),'.','MarkerSize',30,'Color',Clr{5})
plot(ChronicBus_ind,meanAcc.TestPre(ChronicBus_ind),'.','MarkerSize',30,'Color',Clr{6})
plot(AcuteBus_ind,meanAcc.TestPre(AcuteBus_ind),'.c','MarkerSize',30)
plot(RipInhib_ind,meanAcc.TestPre(RipInhib_ind),'.','MarkerSize',30,'Color',Clr{8})
plot(RipControl_ind,meanAcc.TestPre(RipControl_ind),'.','MarkerSize',30,'Color',Clr{9})
ylabel('Movement quantity')
xticks([1:length(Mouse)]); xticklabels({'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',})
makepretty
ylim([5e7 2e8])
title('Mean accelero')
vline(26.5,'--r','Sophie')
vline(27.5,'--r','Baptiste')
vline(28.5,'--k','Summer break')
vline(18.5,'--r','Carole')
vline(22.5,'--r','Sophie')
hline(8e7,'--r')

subplot(412)
plot(meanSpeed.TestPre); hold on
plot(Saline_ind,meanSpeed.TestPre(Saline_ind),'.b','MarkerSize',30)
plot(ChronicFlx_ind,meanSpeed.TestPre(ChronicFlx_ind),'.r','MarkerSize',30)
plot(AcuteFlx_ind,meanSpeed.TestPre(AcuteFlx_ind),'.g','MarkerSize',30)
plot(Mdz_ind,meanSpeed.TestPre(Mdz_ind),'.m','MarkerSize',30)
plot(Dzp_ind,meanSpeed.TestPre(Dzp_ind),'.','MarkerSize',30,'Color',Clr{5})
plot(ChronicBus_ind,meanSpeed.TestPre(ChronicBus_ind),'.','MarkerSize',30,'Color',Clr{6})
plot(AcuteBus_ind,meanSpeed.TestPre(AcuteBus_ind),'.c','MarkerSize',30)
plot(RipInhib_ind,meanSpeed.TestPre(RipInhib_ind),'.','MarkerSize',30,'Color',Clr{8})
plot(RipControl_ind,meanSpeed.TestPre(RipControl_ind),'.','MarkerSize',30,'Color',Clr{9})
ylabel('speed (cm/s)')
xticks([1:length(Mouse)]); xticklabels({'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',})
makepretty
title('Mean speed')
vline(26.5,'--r')
vline(27.5,'--r')
vline(28.5,'--k')
vline(18.5,'--r')
vline(22.5,'--r')
hline(6,'--r')

subplot(413)
plot(meanEKG.TestPre); hold on
plot(Saline_ind,meanEKG.TestPre(Saline_ind),'.b','MarkerSize',30)
plot(ChronicFlx_ind,meanEKG.TestPre(ChronicFlx_ind),'.r','MarkerSize',30)
plot(AcuteFlx_ind,meanEKG.TestPre(AcuteFlx_ind),'.g','MarkerSize',30)
plot(Mdz_ind,meanEKG.TestPre(Mdz_ind),'.m','MarkerSize',30)
plot(Dzp_ind,meanEKG.TestPre(Dzp_ind),'.','MarkerSize',30,'Color',Clr{5})
plot(ChronicBus_ind,meanEKG.TestPre(ChronicBus_ind),'.','MarkerSize',30,'Color',Clr{6})
plot(AcuteBus_ind,meanEKG.TestPre(AcuteBus_ind),'.m','MarkerSize',30)
plot(RipInhib_ind,meanEKG.TestPre(RipInhib_ind),'.','MarkerSize',30,'Color',Clr{8})
plot(RipControl_ind,meanEKG.TestPre(RipControl_ind),'.','MarkerSize',30,'Color',Clr{9})
ylabel('movement quantity')
xticks([1:length(Mouse)]); xticklabels({'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',})
makepretty
title('Mean heart rate')
vline(26.5,'--r')
vline(27.5,'--r')
vline(28.5,'--k')
vline(18.5,'--r')
vline(22.5,'--r')
hline(6,'--r')

subplot(414)
plot(meanTemp.TestPre); hold on
plot(Saline_ind,meanTemp.TestPre(Saline_ind),'.b','MarkerSize',30)
plot(AcuteFlx_ind,meanTemp.TestPre(AcuteFlx_ind),'.g','MarkerSize',30)
plot(Mdz_ind,meanTemp.TestPre(Mdz_ind),'.m','MarkerSize',30)
plot(ChronicFlx_ind,meanTemp.TestPre(ChronicFlx_ind),'.r','MarkerSize',30)
ylabel('Temperature')
xticks([1:length(Mouse)]); xticklabels({'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',})
makepretty
title('Mean full body temperature')
xlim([0 39])
vline(26.5,'--r')
vline(27.5,'--r')
vline(28.5,'--k')
vline(18.5,'--r')
vline(22.5,'--r')
xticks([1:length(Mouse)]); xticklabels(Mouse_names); xtickangle(45);

a=suptitle('Test Pre features, drugs experiments'); a.FontSize=20;


plot
plot(meanAcc2.TestPre); hold on





%% Real time overview


figure
subplot(411)
plot(ValueOfDate,FreezeTime(3,:)); hold on
plot(ValueOfDate(Saline_ind),FreezeTime(3,Saline_ind),'.b','MarkerSize',30)
plot(ValueOfDate(AcuteFlx_ind),FreezeTime(3,AcuteFlx_ind),'.g','MarkerSize',30)
plot(ValueOfDate(Mdz_ind),FreezeTime(3,Mdz_ind),'.m','MarkerSize',30)
plot(ValueOfDate(ChronicFlx_ind),FreezeTime(3,ChronicFlx_ind),'.r','MarkerSize',30)
plot(ValueOfDate(35),FreezeTime(3,[35]),'.k','MarkerSize',30)
ylabel('Freezing percentage (%)')
axis_x=sort(unique(ValueOfDate(1:35))); xticks(axis_x); xticklabels({'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',})
makepretty
legend('Freezing','Saline','Acute Flx','Midazolam','Chronic fluoxetine','Diazepam')
title('Freezing proportion')
vline(940,'--r','Sophie doing the UMaze')
vline(960,'--r','Baptiste doing the UMaze')
vline(980,'--k','Summer break')

subplot(412)
plot(ValueOfDate,StimNumb_AllMice2); hold on
plot(ValueOfDate(Saline_ind),StimNumb_AllMice2(Saline_ind),'.b','MarkerSize',30)
plot(ValueOfDate(AcuteFlx_ind),StimNumb_AllMice2(AcuteFlx_ind),'.g','MarkerSize',30)
plot(ValueOfDate(Mdz_ind),StimNumb_AllMice2(Mdz_ind),'.m','MarkerSize',30)
plot(ValueOfDate(ChronicFlx_ind),StimNumb_AllMice2(ChronicFlx_ind),'.r','MarkerSize',30)
plot(ValueOfDate(35),StimNumb_AllMice2([35]),'.k','MarkerSize',30)
ylabel('extra shocks number')
axis_x=sort(unique(ValueOfDate(1:35))); xticks(axis_x); xticklabels({'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',})
makepretty
title('Extra shocks')
vline(940,'--r')
vline(960,'--r')
vline(980,'--k')

subplot(413)
plot(ValueOfDate,ShockVersusSafePostTime); hold on
plot(ValueOfDate(Saline_ind),ShockVersusSafePostTime(Saline_ind),'.b','MarkerSize',30)
plot(ValueOfDate(AcuteFlx_ind),ShockVersusSafePostTime(AcuteFlx_ind),'.g','MarkerSize',30)
plot(ValueOfDate(Mdz_ind),ShockVersusSafePostTime(Mdz_ind),'.m','MarkerSize',30)
plot(ValueOfDate(ChronicFlx_ind),ShockVersusSafePostTime(ChronicFlx_ind),'.r','MarkerSize',30)
plot(ValueOfDate(35),ShockVersusSafePostTime([35]),'.k','MarkerSize',30)
ylabel('%')
axis_x=sort(unique(ValueOfDate(1:35))); xticks(axis_x); xticklabels({'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',})
makepretty
title('Shock zone occupancy in TestPost')
vline(940,'--r')
vline(960,'--r')
vline(980,'--k')
hline(1,'-r')

subplot(414)
plot(ValueOfDate,FreqMaxAll.Shock,'.','Color',[1 0.5 0.5],'MarkerSize',30); hold on
plot(ValueOfDate,FreqMaxAll.Shock,'Color',[1 0.5 0.5]); hold on
plot(ValueOfDate,FreqMaxAll.Safe,'.','Color',[0.5 0.5 1],'MarkerSize',30); hold on
plot(ValueOfDate,FreqMaxAll.Safe,'Color',[0.5 0.5 1]); hold on
ylabel('OB max frequency')
[axis_x,ind_to_use]=sort(unique(ValueOfDate(1:35))); xticks(axis_x); xticklabels(Mouse_names(ind_to_use)); xtickangle(90)
makepretty
title('OB Analysis')
vline(ValueOfDate,{'--b','--','--b','--g','--g','--g','--b','--g','--b','--g','--','--m','--b','--m','--m','--m','--m','--m','--r','--r','--r','--b','--r','--r','--m','--m','--b','--r','--b','--b','--r','--r','--b','--b','--k'})
f=get(gca,'Children');
legend([f(3),f(1)],'Shock side freezing','Safe side freezing')








%%
for i=1:4
    Thigmo_MazeType{i} = Thigmo.TestPre(Sum_Up_Array(2,:)==i);
end

Cols = {[0, 0, 1],[1, 0, 0],[0 1 0],[.3 .3 .3]};
Legends = {'Maze1','Maze2','Maze3','Maze4'};
X = 1:4;


subplot(222)
MakeSpreadAndBoxPlot3_SB(Thigmo_MazeType,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('thigmo score (a.u.)')
title('Maze type')


%
for i=1:3
    Thigmo_MazeExp{i} = Thigmo.TestPre(Sum_Up_Array(3,:)==i);
end

Cols = {[0, 0, 1],[1, 0, 0],[0 1 0]};
Legends = {'SB','BM','CS'};
X = 1:3;


subplot(223)
MakeSpreadAndBoxPlot3_SB(Thigmo_MazeExp,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('thigmo score (a.u.)')
title('Maze experimenter')


%
for i=1:4
    Thigmo_MazeOrder{i} = Thigmo.TestPre(Sum_Up_Array(4,:)==i);
end

Cols = {[0, 0, 1],[1, 0, 0],[0 1 0],[.3 .3 .3]};
Legends = {'1st','2nd','3rd','4th'};
X = 1:4;


subplot(224)
MakeSpreadAndBoxPlot3_SB(Thigmo_MazeOrder,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('thigmo score (a.u.)')
title('Maze order')



%%
Mouse1=[1144 1146 1147 1170 1171 9184 1189 9205 1251 1253 1254 1391 1392 1393 1394 1500 1502 1529 1530 1532];
Mouse2=[11147 11184 11189 11200 11204 11205 11206 11207 11251 11252 11253 11254 11500 11501 11529];


Saline_Maze1 = Mouse(find(and(Sum_Up_Array(1,1:end)==1 , Sum_Up_Array(2,1:end)==1)));
n=1;
for i=1:length(Mouse1)
    if ~isempty(find(Saline_Maze1==Mouse1(i)))
        ind1(n)=find(Saline_Maze1==Mouse1(i));
        n=n+1;
    end
end
Saline_Maze1(ind1)

Saline_Maze4 = Mouse(find(and(Sum_Up_Array(1,1:end)==1 , Sum_Up_Array(2,1:end)==4)));
n=1;
for i=1:length(Mouse1)
    if ~isempty(find(Saline_Maze4==Mouse1(i)))
        ind2(n)=find(Saline_Maze4==Mouse1(i));
        n=n+1;
    end
end
Saline_Maze4(ind2)



Saline1_Maze1_short=Mouse([30 31 32 35 36 39 41 69 70 71]);
Saline1_Maze4_short=Mouse([48 102 103 104 105]);

DZP1_Maze1_short=Mouse([52 53]);
DZP1_Maze4_short=Mouse([42 43 44 45 65 66 67 68]);

n=1;
for group=1:4
    clear Mouse1
    if group==1
        Mouse1=Saline1_Maze1_short;
    elseif group==2
        Mouse1=Saline1_Maze4_short;
    elseif group==3
        Mouse1=DZP1_Maze1_short;
    elseif group==4
        Mouse1=DZP1_Maze4_short;
    end
    for mouse=1:length(Mouse1)
        Mouse_names{mouse}=['M' num2str(Mouse1(mouse))];
        Thigmo_new{n}(mouse) = Thigmo.TestPre.(Mouse_names{mouse});
    end
    n=n+1;
end

Cols = {[.3, .745, .93],[.85, .325, .098],[.3, .545, .93],[.85, .125, .098]};
X = 1:4;
Legends = {'Saline Maze1','Saline Maze4','Diazepam Maze1','Diazepam Maze4'};
NoLegends = {'','','',''};

figure
MakeSpreadAndBoxPlot3_SB(Thigmo_new,Cols,X,Legends,'showpoints',1,'paired',0);


%%
n=1;
for group=1:2
    if group==1
        Mouse=[1144 1146 1147 1170 1171 9184 1189 9205 1251 1253 1254 1391 1392 1393 1394 1500 1502 1529 1530 1532];
    elseif group==2
        Mouse=[11147 11184 11189 11200 11204 11205 11206 11207 11251 11252 11253 11254 11500 11501 11529];
    end
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        Thigmo_new2{n}(mouse) = Thigmo.TestPre.(Mouse_names{mouse});
    end
    n=n+1;
end

Cols = {[.3, .745, .93],[.85, .325, .098]};
X = 1:2;
Legends = {'Saline','DZP'};
NoLegends = {'','','',''};

figure
MakeSpreadAndBoxPlot3_SB(Thigmo_new2,Cols,X,Legends,'showpoints',1,'paired',0);




sum(and(Sum_Up_Array(1,28:end)==1 , Sum_Up_Array(2,28:end)==1)) % Saline Maze1
sum(and(Sum_Up_Array(1,28:end)==1 , Sum_Up_Array(2,28:end)==4)) % Saline Maze4
sum(and(Sum_Up_Array(1,28:end)==5 , Sum_Up_Array(2,28:end)==1)) % DZP Maze1
sum(and(Sum_Up_Array(1,28:end)==5 , Sum_Up_Array(2,28:end)==4)) % DZP Maze4


sum(and(Sum_Up_Array2(1,:)==1 , Sum_Up_Array2(2,:)==1)) % Saline Maze1
sum(and(Sum_Up_Array2(1,:)==1 , Sum_Up_Array2(2,:)==4)) % Saline Maze4
sum(and(Sum_Up_Array2(1,:)==5 , Sum_Up_Array2(2,:)==1)) % DZP Maze1
sum(and(Sum_Up_Array2(1,:)==5 , Sum_Up_Array2(2,:)==4)) % DZP Maze4

