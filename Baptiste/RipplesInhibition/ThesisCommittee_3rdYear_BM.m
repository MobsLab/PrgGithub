

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% I. 2 freezing types
Cols={[1 .5 .5],[.5 .5 1]};
X=[1:2];
Legends={'Shock','Safe'};

Cols2={[.3 1 .3],[1 .3 1]};
X2=[1:2];
Legends2={'TestPre','TestPost'};

%% a) Behaviour Pre/post
% occupancy shock/safe
figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({ShockTime_prop.TestPre SafeTime_prop.TestPre./1.3},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 1]), ylabel('proportion')
title('Test Pre')

subplot(122)
MakeSpreadAndBoxPlot3_SB({ShockTime_prop.TestPost SafeTime_prop.TestPost./1.3},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 1])
title('Test Post')

a=suptitle('Time spent in shock and safe zone, n=50'); a.FontSize=15;


% shock zone entries shock/safe & occup maps
figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({ShockZoneEntries.TestPre SafeZoneEntries.TestPre},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 45]), ylabel('#')
title('Test Pre')

subplot(122)
MakeSpreadAndBoxPlot3_SB({ShockZoneEntries.TestPost SafeZoneEntries.TestPost},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 42])
title('Test Post')

a=suptitle('Entries zones in shock and safe zone, n=50'); a.FontSize=15;

figure
subplot(121)
contourf(SmoothDec(OccupMap_squeeze.Unblocked.TestPre{1},1),'linestyle','none'), axis xy
axis off
title('Test Pre')

subplot(122)
contourf(SmoothDec(OccupMap_squeeze.Unblocked.TestPost{1},1),'linestyle','none'), axis xy
axis off
title('Test Post')


% speed & thigmotaxism
figure
MakeSpreadAndBoxPlot3_SB({Speed_all.TestPre Speed_all.TestPost},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylim([0 8]), ylabel('speed (cm/s)')
title('Speed')

figure
MakeSpreadAndBoxPlot3_SB({Tigmo_score_all.Unblocked.TestPre{1} Tigmo_score_all.Unblocked.TestPost{1}},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylim([.4 1]), ylabel('thigmo score (a.u.)')
title('Thigmotaxism')




%% b) Differents behaviours along the Maze
load('/media/nas7/ProjetEmbReact/DataEmbReact/BehaviourAlongMaze.mat') 
% or after JumpsAnalysis_Maze_BM, RA_Drugs_UMaze_BM, Find_Grooming_UMaze_BM

figure
Data_to_use = (Jumps{1}'./nansum(Jumps{1}'))';Jumps{1};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(0,1,25) , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
col= [1 .3 .3]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
% area(linspace(0,1,25) , Mean_All_Sp,'FaceColor',col,'FaceAlpha',.07)

Data_to_use = (RA{1}'./nansum(RA{1}'))';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(0,1,25) , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
col= [1 .3 1]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
% area(linspace(0,1,25) , Mean_All_Sp,'FaceColor',col,'FaceAlpha',.07)

Data_to_use = (Grooming{1}'./nansum(Grooming{1}'))';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(0,1,25) , Mean_All_Sp/2 , Conf_Inter,'-r',1); hold on;
col= [.3 .3 1]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
% area(linspace(0,1,25) , Mean_All_Sp,'FaceColor',col,'FaceAlpha',.07)

xlabel('linear distance (a.u.)'), ylabel('#'), ylim([0 .2])
f=get(gca,'Children'); l=legend([f(4),f(8),f(12)],'Grooming','Risk assessment','Jumps');


%% c) Freezing on the shock and the safe side
GetEmbReactMiceFolderList_BM
Mouse=[688 739 777 779 849 893 1144 1146 1147 1170 1171 9184 1189 9205 1391 1392 1393 1394 1224 1225 1226];
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    FreezeEpoch.Cond.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'epoch','epochname','freezeepoch');
end

    
figure
contourf(SmoothDec(OccupMap_squeeze.Freeze.Cond{1},1),'linestyle','none'), axis xy, caxis([0 .007])
axis off
title('Cond')

% Distribution
load('/media/nas7/ProjetEmbReact/DataEmbReact/LinearDistanceAllSaline.mat')


for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    try
        LinearDist_WhenFreezing.(Mouse_names{mouse}) = Restrict(LinearDist.Cond.(Mouse_names{mouse}) , FreezeEpoch.Cond.(Mouse_names{mouse}));
        h=histogram(Data(LinearDist_WhenFreezing.(Mouse_names{mouse})),'BinLimits',[0 1],'NumBins',25);
        FreezingDistrib{1}(mouse,:) = runmean_BM(h.Values,3);
    end
end

figure
Data_to_use = (FreezingDistrib{1}'./nansum(FreezingDistrib{1}'))';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(0,1,25) , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
col= [.3 .3 .3]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
area(linspace(0,1,25) , Mean_All_Sp,'FaceColor',col,'FaceAlpha',.3)

xlabel('linear distance (a.u.)'), ylabel('#')


%% d) Differents somatic states
figure
subplot(131)
MakeSpreadAndBoxPlot3_SB({HR_Shock_Fz.Cond HR_Safe_Fz.Cond},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([9 13]), ylabel('Frequency (Hz)')
title('Heart rate')
subplot(132)
MakeSpreadAndBoxPlot3_SB({HR_Var_Shock_Fz.Cond HR_Var_Safe_Fz.Cond},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 .4]), ylabel('variability (a.u.)')
title('Heart rate variability')
subplot(133)
MakeSpreadAndBoxPlot3_SB({Respi_Shock_Fz.Cond Respi_Safe_Fz.Cond},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([2.5 9]), ylabel('Frequency (Hz)')
title('Respiratory rate')

a=suptitle('Differents somatic states'); a.FontSize=15;

%% e) DIfferents brain states

figure, sess=2;
[~ , MaxPowerValues1] = Plot_MeanSpectrumForMice_BM(DATA.OB_Low_Spectrum.Shock.(Session_type{sess}), 'color' , 'b' , 'threshold' , 13);
[~ , MaxPowerValues2] = Plot_MeanSpectrumForMice_BM(DATA.OB_Low_Spectrum.Safe.(Session_type{sess}), 'color' , 'b' , 'threshold' , 13);
[~ , MaxPowerValues3] = Plot_MeanSpectrumForMice_BM(DATA.HPC_Low_Spectrum.Shock.(Session_type{sess}), 'color' , 'b' , 'threshold' , 65);
[~ , MaxPowerValues4] = Plot_MeanSpectrumForMice_BM(DATA.HPC_Low_Spectrum.Safe.(Session_type{sess}), 'color' , 'b' , 'threshold' , 65);
[~ , MaxPowerValues5] = Plot_MeanSpectrumForMice_BM(DATA.PFC_Low_Spectrum.Shock.(Session_type{sess}), 'color' , 'b' , 'threshold' , 26);
[~ , MaxPowerValues6] = Plot_MeanSpectrumForMice_BM(DATA.PFC_Low_Spectrum.Safe.(Session_type{sess}), 'color' , 'b' , 'threshold' , 26);
clf

subplot(131)
clear D; D=DATA.OB_Low_Spectrum.Shock.(Session_type{sess}); D(D==0)=NaN;
h = Plot_MeanSpectrumForMice_BM(D, 'color' , 'r' , 'threshold' , 13 , 'power_norm_value' , max([MaxPowerValues1' MaxPowerValues2']'));
clear D; D=DATA.OB_Low_Spectrum.Safe.(Session_type{sess}); D(D==0)=NaN;
h = Plot_MeanSpectrumForMice_BM(D, 'color' , 'b' , 'threshold' , 13 , 'power_norm_value' , max([MaxPowerValues1' MaxPowerValues2']'));

f=get(gca,'Children'); legend([f(8),f(4)],'Shock','Safe');
xlabel('Frequency (Hz)'); ylabel('Power (a.u.)'); xlim([0 10]); ylim([0 1]); box off
title('Olfactory bulb')

subplot(132)
clear D; D=DATA.HPC_Low_Spectrum.Shock.(Session_type{sess}); D(D==0)=NaN;
h = Plot_MeanSpectrumForMice_BM(D, 'color' , 'r' , 'threshold' , 65 , 'power_norm_value' , max([MaxPowerValues3' MaxPowerValues4']'));
clear D; D=DATA.HPC_Low_Spectrum.Safe.(Session_type{sess}); D(D==0)=NaN;
h = Plot_MeanSpectrumForMice_BM(D, 'color' , 'b' , 'threshold' , 65 , 'power_norm_value' , max([MaxPowerValues3' MaxPowerValues4']'));

xlabel('Frequency (Hz)'); xlim([0 10]); ylim([0 1.7]); box off
title('Hippocampus')

subplot(133)
clear D; D=DATA.PFC_Low_Spectrum.Shock.(Session_type{sess}); D(D==0)=NaN;
h = Plot_MeanSpectrumForMice_BM(D, 'color' , 'r' , 'threshold' , 26 , 'power_norm_value' , max([MaxPowerValues5' MaxPowerValues6']'));
clear D; D=DATA.PFC_Low_Spectrum.Safe.(Session_type{sess}); D(D==0)=NaN;
h = Plot_MeanSpectrumForMice_BM(D, 'color' , 'b' , 'threshold' , 26 , 'power_norm_value' , max([MaxPowerValues5' MaxPowerValues6']'));

xlabel('Frequency (Hz)'); xlim([0 10]); ylim([0 1]); box off
title('Prefrontal cortex')

a=suptitle('Mean spectrum during freezing'); a.FontSize=15;




figure
MakeSpreadAndBoxPlot3_SB({Ripples_Shock_Fz.Cond Ripples_Safe_Fz.Cond},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 1.1]), ylabel('#/s')
title('Ripples density')

figure
MakeSpreadAndBoxPlot3_SB({log10(ThetaPower_Shock_Fz.Cond) log10(ThetaPower_Safe_Fz.Cond)},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 1.1]), ylabel('#/s')
title('Ripples density')


%% e) pharmaco
% Chronic fluoxetine
figure
subplot(141)
MakeSpreadAndBoxPlot3_SB({Proportionnal_Time_Freezing_ofZone.(Side{2}).Cond{1} Proportionnal_Time_Freezing_ofZone.(Side{2}).Cond{2} Proportionnal_Time_Freezing_ofZone.(Side{3}).Cond{1} Proportionnal_Time_Freezing_ofZone.(Side{3}).Cond{2}}...
    ,{[1 .5 .5],[1 .7 .7],[.5 .5 1],[.7 .7 1],},[1:4],{'Saline','Chronic flx','Saline','Chronic flx'},'showpoints',1,'paired',0);
ylabel('proportion')
title('Freezing duration')

subplot(142)
MakeSpreadAndBoxPlot3_SB({ShockZoneEntries_Density.Cond{1} ShockZoneEntries_Density.Cond{2}}...
    ,{[.7 .3 .7],[1 .7 1]},[1:2],{'Saline','Chronic flx'},'showpoints',1,'paired',0);
ylabel('#/min active')
title('Zone entries, Conditioning')

subplot(143)
MakeSpreadAndBoxPlot3_SB({ShockZoneEntries_Density.TestPost{1} ShockZoneEntries_Density.TestPost{2}}...
    ,{[.7 .3 .7],[1 .7 1]},[1:2],{'Saline','Chronic flx'},'showpoints',1,'paired',0);
ylabel('#/min active')
title('Zone entries, TestPost')

subplot(144)
MakeSpreadAndBoxPlot3_SB({Tigmo_score_all.Active_Unblocked.Cond{4} Tigmo_score_all.Active_Unblocked.Cond{1}}...
    ,{[.7 .3 .7],[1 .7 1]},[1:2],{'Saline','Chronic flx'},'showpoints',1,'paired',0);
ylabel('thigmo score (a.u.)')
title('Thigmotaxism, Cond')



figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({Respi_Shock.Ext{1}  Respi_Shock.Ext{2}...
    Respi_Safe.Ext{1}  Respi_Safe.Ext{2}},{[1 .5 .5],[1 .7 .7],[.5 .5 1],[.7 .7 1],},[1:4],{'Saline','Diazepam','Saline','Diazepam'},'showpoints',1,'paired',0);
ylabel('Frequency (Hz)')


subplot(122)
MakeSpreadAndBoxPlot3_SB({Ripples_Shock.Ext{1} Ripples_Shock.Ext{2}   Ripples_Safe.Ext{1} Ripples_Safe.Ext{2}}...
    ,{[1 .5 .5],[1 .7 .7],[.5 .5 1],[.7 .7 1],},[1:4],{'Saline','Diazepam','Saline','Diazepam'},'showpoints',1,'paired',0);
ylabel('#/s')



% Diazepam
figure
subplot(141)
MakeSpreadAndBoxPlot3_SB({Proportionnal_Time_Freezing_ofZone.(Side{2}).Cond{5} Proportionnal_Time_Freezing_ofZone.(Side{2}).Cond{6}...
    Proportionnal_Time_Freezing_ofZone.(Side{3}).Cond{5} Proportionnal_Time_Freezing_ofZone.(Side{3}).Cond{6}}...
    ,{[1 .5 .5],[1 .7 .7],[.5 .5 1],[.7 .7 1],},[1:4],{'Saline','Diazepam','Saline','Diazepam'},'showpoints',1,'paired',0);
ylabel('proportion')
title('Freezing duration')

subplot(142)
MakeSpreadAndBoxPlot3_SB({ShockZoneEntries_Density.Cond{5} ShockZoneEntries_Density.Cond{6}}...
    ,{[.7 .3 .7],[1 .7 1]},[1:2],{'Saline','Diazepam'},'showpoints',1,'paired',0);
ylabel('#/min active')
title('Zone entries, Conditioning')

subplot(143)
MakeSpreadAndBoxPlot3_SB({ShockZoneEntries_Density.TestPost{5} ShockZoneEntries_Density.TestPost{6}}...
    ,{[.7 .3 .7],[1 .7 1]},[1:2],{'Saline','Diazepam'},'showpoints',1,'paired',0);
ylabel('#/min active')
title('Zone entries, TestPost')

subplot(144)
MakeSpreadAndBoxPlot3_SB({Tigmo_score_all.Active_Unblocked.Cond{4} Tigmo_score_all.Active_Unblocked.Cond{5}}...
    ,{[.7 .3 .7],[1 .7 1]},[1:2],{'Saline','Diazepam'},'showpoints',1,'paired',0);
ylabel('thigmo score (a.u.)')
title('Thigmotaxism, Cond')



figure

sess=5; 
subplot(121); thr=13;
[m1,Freq_Shock_Sal] = max(squeeze(OutPutData.Saline.(Session_type{sess}).ob_low.mean(:,5,thr:end))');
Data_to_use = squeeze(OutPutData.Saline.(Session_type{sess}).ob_low.mean(:,5,:))./m1';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-r',1); hold on;
[c,d]=max(Mean_All_Sp(thr+1:end));

[m1,Freq_Shock_DZP] = max(squeeze(OutPutData.Diazepam.(Session_type{sess}).ob_low.mean(:,5,thr:end))');
Data_to_use = squeeze(OutPutData.Diazepam.(Session_type{sess}).ob_low.mean(:,5,:))./m1';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'--r',1); hold on;
col= [1 .3 .3]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
[c,d]=max(Mean_All_Sp(thr+1:end));

u=vline(3.9,'-b'); set(u,'LineWidth',2);
u=vline(4.807,'-r'); set(u,'LineWidth',2);
u=vline(4.75,'--r'); set(u,'LineWidth',2);


f=get(gca,'Children');
a=legend([f(5),f(1)],'Saline','Diazepam');
makepretty; xlabel('Frequency (Hz)'); ylabel('Power (a.u.)'); xticks([0:2:10]); xlim([0 10]); ylim([0 1])



subplot(122)
[m1,Freq_Safe_Sal] = max(squeeze(OutPutData.Saline.(Session_type{sess}).ob_low.mean(:,6,thr:end))');
Data_to_use = squeeze(OutPutData.Saline.(Session_type{sess}).ob_low.mean(:,6,:))./m1';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-b',1); hold on;
[c,d]=max(Mean_All_Sp(thr+1:end));

[m1,Freq_Safe_DZP] = max(squeeze(OutPutData.Diazepam.(Session_type{sess}).ob_low.mean(:,6,thr:end))');
Data_to_use = squeeze(OutPutData.Diazepam.(Session_type{sess}).ob_low.mean(:,6,:))./m1';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'--b',1); hold on;
col= [.3 .3 1]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
[c,d]=max(Mean_All_Sp(thr+1:end));

u=vline(3.9,'-b'); set(u,'LineWidth',2);
u=vline(4.807,'-r'); set(u,'LineWidth',2);
u=vline(4.654,'--b'); set(u,'LineWidth',2);

f=get(gca,'Children');
a=legend([f(5),f(1)],'Saline','Diazepam');
makepretty; xlabel('Frequency (Hz)'); ylabel('Power (a.u.)'); xticks([0:2:10]); xlim([0 10]); ylim([0 1])



Freq_Shock_Sal = RangeLow(Freq_Shock_Sal+thr-1);
Freq_Safe_Sal = RangeLow(Freq_Safe_Sal+thr-1);
Freq_Shock_DZP = RangeLow(Freq_Shock_DZP+thr-1);
Freq_Safe_DZP = RangeLow(Freq_Safe_DZP+thr-1);



figure
MakeSpreadAndBoxPlot3_SB({Ripples_Shock.(Session_type{sess}){1} Ripples_Shock.(Session_type{sess}){2} ...
    Ripples_Safe.(Session_type{sess}){1} Ripples_Safe.(Session_type{sess}){2}}...
    ,{[1 .5 .5],[1 .7 .7],[.5 .5 1],[.7 .7 1],},[1:4],{'Saline','Chronic flx','Saline','Chronic flx'},'showpoints',1,'paired',0);




figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({OB_Max_Freq.SalineBM.(Session_type{sess}).Shock OB_Max_Freq.Diazepam.(Session_type{sess}).Shock...
    OB_Max_Freq.SalineBM.(Session_type{sess}).Safe OB_Max_Freq.Diazepam.(Session_type{sess}).Safe},{[1 .5 .5],[1 .7 .7],[.5 .5 1],[.7 .7 1],},[1:4],{'Saline','Diazepam','Saline','Diazepam'},'showpoints',1,'paired',0);
ylabel('Frequency (Hz)')

subplot(122)
MakeSpreadAndBoxPlot3_SB({Ripples_Shock.Ext{1} Ripples_Shock.Ext{2}   Ripples_Safe.Ext{1} Ripples_Safe.Ext{2}}...
    ,{[1 .5 .5],[1 .7 .7],[.5 .5 1],[.7 .7 1],},[1:4],{'Saline','Diazepam','Saline','Diazepam'},'showpoints',1,'paired',0);
ylabel('#/s')

figure
MakeSpreadAndBoxPlot3_SB({Freq_Shock_Sal Freq_Shock_DZP    Freq_Safe_Sal Freq_Safe_DZP},...
    {[1 .5 .5],[1 .7 .7],[.5 .5 1],[.7 .7 1],},[1:4],{'Saline','Diazepam','Saline','Diazepam'},'showpoints',1,'paired',0);
ylabel('Frequency (Hz)')




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% II. Ripples inhibition during freezing 

%% a) methods confirmation
Cols = {[.3, .745, .93],[.85, .325, .098]};

PlotErrorBarN_SL({[.813 ,.746 ,.690, .84] [.811 ,.712, .817, .56]},'barcolors',Cols,'showpoints',0,'newfig',1,'paired',0)
xticks([1 2]); xticklabels({'Ripple before stim','Stim after ripples'}), xtickangle(45), ylim([0 1])
ylabel('proportion')
title()

%% b) Spatial informations
% no change in Test Post
figure
for i=1:4
    subplot(2,2,i)
    imagesc(OccupMap_squeeze.Active_Unblocked.TestPost{i}), axis xy, caxis([0 8e-4])
    axis off
    title(Legends{i})
end
a=suptitle('Occupancy maps, Test Post sessions'); a.FontSize=12;

for i=1:4
    Diff{i} = ShockEntriesZone.TestPost{i}-ShockEntriesZone.TestPre{i};
end

figure
MakeSpreadAndBoxPlot3_SB(Diff,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('entries #, TestPost - TestPre')


% avoidance of shock zone in Cond
figure
subplot(131)
MakeSpreadAndBoxPlot3_SB(Proportional_Time_Unblocked.Shock.Cond,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('proportion')
title('Time spent shock zone')

subplot(132)
MakeSpreadAndBoxPlot3_SB(ShockEntriesZone.Cond,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('#')
title('Shock zone entries')

subplot(133)
MakeSpreadAndBoxPlot3_SB(ExtraStimNumber.Cond,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('#')
title('Eyelid shocks')

a=suptitle('Shock zone features, Cond sessions'); a.FontSize=12;



%% b) Emotional valence
% All freezing
figure
subplot(141)
MakeSpreadAndBoxPlot3_SB(Proportional_TimeFz.All.Cond,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('proportion'), ylim([0 .45])
title('Freezing')

subplot(142)
MakeSpreadAndBoxPlot3_SB(Proportional_TimeFz.Shock.Cond,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('proportion'), ylim([0 .45])
title('Freezing shock')

subplot(143)
MakeSpreadAndBoxPlot3_SB(Proportional_TimeFz.Safe.Cond,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('proportion'), ylim([0 .45])
title('Freezing safe')

subplot(144)
MakeSpreadAndBoxPlot3_SB(Tigmo_score_all.Active_Unblocked.Cond,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('thigmo score (a.u.)')
title('Thigmotaxism')

a=suptitle('Freezing features, Cond sessions'); a.FontSize=12;


% Focus on shock freezing
side=2; sess=5;
% Focus on shock freezing during CondPre
side=2; sess=1;
% if you want safe for DZP differences
side=3; sess=5;

figure
subplot(131)
MakeSpreadAndBoxPlot3_SB(Proportional_TimeFz.(Side{side}).(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0)
ylabel('prop')
title('Proportion')

subplot(132)
MakeSpreadAndBoxPlot3_SB(FzEMeanDuration.(Side{side}).(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('sec.')
title('Episodes mean duration')

subplot(133)
MakeSpreadAndBoxPlot3_SB(FzEpNumber.(Side{side}).(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('#')
title('Episodes number')

a=suptitle('Freezing shock features, Cond sessions'); a.FontSize=12;


% Respi
figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({OB_Max_Freq.RipControl.Cond.Shock OB_Max_Freq.RipControl.Cond.Safe},{[1 .5 .5],[.5 .5 1]},1:2,{'Shock','Safe'},'showpoints',0,'paired',1)
ylim([3 6]), ylabel('Frequency (Hz)')
title('Rip control')
subplot(122)
MakeSpreadAndBoxPlot3_SB({OB_Max_Freq.RipInhib.Cond.Shock OB_Max_Freq.RipInhib.Cond.Safe},{[1 .5 .5],[.5 .5 1]},1:2,{'Shock','Safe'},'showpoints',0,'paired',1);
ylim([3 6])
title('Rip inhib')

a=suptitle('Respi during freezing, cond sessions'); a.FontSize=20;


figure
MakeSpreadAndBoxPlot3_SB({OB_Max_Freq.RipControl.Cond.Safe OB_Max_Freq.RipInhib.Cond.Safe},{[.65, .75, 0],[.63, .08, .18]},1:2,{'Rip sham','Rip inhib'},'showpoints',1,'paired',0)
ylim([3 5.5]), ylabel('Frequency (Hz)')
title('Rip control')


% mean spectrum
load('B_Low_Spectrum.mat'); RangeLow=Spectro{3};
figure, sess=5; % or choose sess=2;
subplot(231); thr=25;
[m1,m2] = max(squeeze(OutPutData.RipControl.(Session_type{sess}).ob_low.mean(:,5,thr:end))');
Data_to_use = squeeze(OutPutData.RipControl.(Session_type{sess}).ob_low.mean(:,5,:))./m1';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-r',1); hold on;
[c,d]=max(Mean_All_Sp(thr+1:end));
vline(RangeLow(d+thr),'--r')

[m1,m2] = max(squeeze(OutPutData.RipControl.(Session_type{sess}).ob_low.mean(:,6,thr:end))');
Data_to_use = squeeze(OutPutData.RipControl.(Session_type{sess}).ob_low.mean(:,6,:))./m1';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-b',1); hold on;
[c,d]=max(Mean_All_Sp(:,thr+1:end));
vline(RangeLow(d+thr),'--b')

f=get(gca,'Children');
a=legend([f(8),f(4)],'Shock side freezing','Safe side freezing');
makepretty; xlabel('Frequency (Hz)'); ylabel('Power (a.u.)'); xticks([0:2:10]); xlim([0 10]); ylim([0 1])
u=text(-3,.3,'Rip control','FontWeight','bold','FontSize',20); set(u,'Rotation',90);

subplot(234); thr=25;
[m1,m2] = max(squeeze(OutPutData.RipInhib.(Session_type{sess}).ob_low.mean(:,5,thr:end))');
Data_to_use = squeeze(OutPutData.RipInhib.(Session_type{sess}).ob_low.mean(:,5,:))./m1';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-r',1); hold on;
[c,d]=max(Mean_All_Sp(thr+1:end));
vline(RangeLow(d+thr),'--r')

[m1,m2] = max(squeeze(OutPutData.RipInhib.(Session_type{sess}).ob_low.mean(:,6,thr:end))');
Data_to_use = squeeze(OutPutData.RipInhib.(Session_type{sess}).ob_low.mean(:,6,:))./m1';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-b',1); hold on;
[c,d]=max(Mean_All_Sp(:,thr+1:end));
vline(RangeLow(d+thr),'--b')

makepretty; xlabel('Frequency (Hz)'); ylabel('Power (a.u.)'); xticks([0:2:10]); xlim([0 10]); ylim([0 1])
u=text(-2.5,.3,'Rip inhib','FontWeight','bold','FontSize',20); set(u,'Rotation',90);

subplot(232)
[m1,m2] = max(squeeze(OutPutData.RipControl.(Session_type{sess}).ob_low.mean(:,5,thr:end))');
Data_to_use = squeeze(OutPutData.RipControl.(Session_type{sess}).ob_low.mean(:,5,:))./m1';
plot(Spectro{3} , Data_to_use , 'r')
makepretty; xlim([0 10]); ylim([0 1]), u=vline(4.5); set(u,'LineWidth',2);

subplot(233)
[m1,m2] = max(squeeze(OutPutData.RipControl.(Session_type{sess}).ob_low.mean(:,6,thr:end))');
Data_to_use = squeeze(OutPutData.RipControl.(Session_type{sess}).ob_low.mean(:,6,:))./m1';
plot(Spectro{3} , Data_to_use , 'b')
makepretty; xlim([0 10]); ylim([0 1]), u=vline(4.5); set(u,'LineWidth',2);

subplot(235)
[m1,m2] = max(squeeze(OutPutData.RipInhib.(Session_type{sess}).ob_low.mean(:,5,thr:end))');
Data_to_use = squeeze(OutPutData.RipInhib.(Session_type{sess}).ob_low.mean(:,5,:))./m1';
plot(Spectro{3} , Data_to_use , 'r')
makepretty; xlim([0 10]); ylim([0 1]), u=vline(4.5); set(u,'LineWidth',2);

subplot(236)
[m1,m2] = max(squeeze(OutPutData.RipInhib.(Session_type{sess}).ob_low.mean(:,6,thr:end))');
Data_to_use = squeeze(OutPutData.RipInhib.(Session_type{sess}).ob_low.mean(:,6,:))./m1';
plot(Spectro{3} , Data_to_use , 'b')
makepretty; xlim([0 10]); ylim([0 1]), u=vline(4.5); set(u,'LineWidth',2);

a=suptitle(['OB Low during freezing, ' (Session_type{sess}) ' sessions']); a.FontSize=20;





figure, sess=5; % or choose sess=2;
subplot(121); thr=25;
[m1,m2] = max(squeeze(OutPutData.RipControl.(Session_type{sess}).ob_low.mean(:,5,thr:end))');
Data_to_use = squeeze(OutPutData.RipControl.(Session_type{sess}).ob_low.mean(:,5,:))./m1';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-r',1); hold on;
[c,d]=max(Mean_All_Sp(thr+1:end));
vline(RangeLow(d+thr),'--r')

[m1,m2] = max(squeeze(OutPutData.RipInhib.(Session_type{sess}).ob_low.mean(:,5,thr:end))');
Data_to_use = squeeze(OutPutData.RipInhib.(Session_type{sess}).ob_low.mean(:,5,:))./m1';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'--r',1); hold on;
col= [1 .3 .3]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
[c,d]=max(Mean_All_Sp(thr+1:end));
vline(RangeLow(d+thr),'--r')

f=get(gca,'Children');
a=legend([f(5),f(1)],'Rip sham','Rip inhib');
makepretty; xlabel('Frequency (Hz)'); ylabel('Power (a.u.)'); xticks([0:2:10]); xlim([0 10]); ylim([0 1])


subplot(122); thr=25;
[m1,m2] = max(squeeze(OutPutData.RipControl.(Session_type{sess}).ob_low.mean(:,6,thr:end))');
Data_to_use = squeeze(OutPutData.RipControl.(Session_type{sess}).ob_low.mean(:,6,:))./m1';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-b',1); hold on;
[c,d]=max(Mean_All_Sp(thr+1:end));
vline(RangeLow(d+thr),'--r')

[m1,m2] = max(squeeze(OutPutData.RipInhib.(Session_type{sess}).ob_low.mean(:,6,thr:end))');
Data_to_use = squeeze(OutPutData.RipInhib.(Session_type{sess}).ob_low.mean(:,6,:))./m1';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'--b',1); hold on;
col= [.3 .3 1]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
[c,d]=max(Mean_All_Sp(thr+1:end));
vline(RangeLow(d+thr),'--b')

f=get(gca,'Children');
a=legend([f(5),f(1)],'Rip sham','Rip inhib');
makepretty; xlabel('Frequency (Hz)'); ylabel('Power (a.u.)'); xticks([0:2:10]); xlim([0 10]); ylim([0 1])




%% things quite significative
% Thigmotaxism
figure
MakeSpreadAndBoxPlot3_SB(Tigmo_score_all.Freeze.Cond,Cols,X,Legends,'showpoints',1,'paired',0)
MakeSpreadAndBoxPlot3_SB(Tigmo_score_all.Active_Unblocked.Cond,Cols,X,Legends,'showpoints',1,'paired',0)
ylabel('thigmo score (a.u.)')
title('Thigmotaxism score of freezing')

figure
for i=1:4
    subplot(2,2,i)
    imagesc(OccupMap_squeeze.Freeze_Unblocked.Cond{i}), axis xy, caxis([0 8e-4])
    axis off
    title(Legends{i})
end
a=suptitle('Occupancy maps, Cond sessions'); a.FontSize=12;


edit LinearDistance_WhenFreezing_BM.m

figure; sess=1;
subplot(131)
MakeSpreadAndBoxPlot3_SB(LinearDist_BlockedShock.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('linear dist (a.u.)')
title('Shock zone')
subplot(132)
MakeSpreadAndBoxPlot3_SB(1-LinearDist_BlockedSafe.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0);
title('Safe zone')
subplot(133)
MakeSpreadAndBoxPlot3_SB(Ratio.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0);
title('Ratio shock/safe')
a=suptitle('Linear distance when blocked, Cond sessions'); a.FontSize=20;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% others

%% Trajectories
figure; sess=3;

for group=7
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        subplot(2,7,mouse)
        plot(Position.Active_Unblocked.(Mouse_names{mouse}).(Session_type{sess})(:,1) , Position.Active_Unblocked.(Mouse_names{mouse}).(Session_type{sess})(:,2),'.')
        axis off
        title(['Mouse #' num2str(mouse) ', ' num2str(Tigmo_score_all.Active_Unblocked.(Session_type{sess}){3}(mouse))])
        if mouse==1; u=text(-.1,.2,'Rip control'); set(u,'FontSize',15,'FontWeight','bold','Rotation',90); end
        
    end
end
for group=8
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        subplot(2,7,mouse+7)
        plot(Position.Active_Unblocked.(Mouse_names{mouse}).(Session_type{sess})(:,1) , Position.Active_Unblocked.(Mouse_names{mouse}).(Session_type{sess})(:,2),'.')
        axis off
        title(['Mouse #' num2str(mouse) ', ' num2str(Tigmo_score_all.Active_Unblocked.(Session_type{sess}){4}(mouse))])
        if mouse==1; u=text(-.1,.2,'Rip inhib'); set(u,'FontSize',15,'FontWeight','bold','Rotation',90); end
        
    end
end
a=suptitle(['Trajectories, ' Session_type{sess} ' sessions']); a.FontSize=20;


figure
subplot(121)
MakeSpreadAndBoxPlot3_SB(Tigmo_score_all.Active_Unblocked.Cond,Cols,X,Legends,'showpoints',1,'paired',0);
ylim([.3 1.1]), ylabel('thigmo score (a.u.)')
title('Cond')
subplot(122)
MakeSpreadAndBoxPlot3_SB(Tigmo_score_all.Active_Unblocked.TestPost,Cols,X,Legends,'showpoints',1,'paired',0);
ylim([.3 1.1])
title('Test Post')

a=suptitle('Thigmotaxism'); a.FontSize=20;

% occup maps
figure
for i=1:4
    subplot(2,2,i)
    imagesc(OccupMap_squeeze.Active_Unblocked.Cond{i}), axis xy, caxis([0 8e-4])
    axis off
    title(Legends{i})
end
a=suptitle('Occupancy maps, Cond sessions'); a.FontSize=12;

figure
for i=1:4
    subplot(2,2,i)
    imagesc(OccupMap_squeeze.Freeze.Cond{i}), axis xy, caxis([0 8e-4])
    axis off
    title(Legends{i})
end
a=suptitle('Occupancy maps, Cond sessions'); a.FontSize=12;

figure
for i=1:4
    subplot(2,2,i)
    imagesc(OccupMap_squeeze.Blocked.Cond{i}), axis xy, caxis([0 8e-4])
    axis off
    title(Legends{i})
end
a=suptitle('Freezing occupancy maps, Cond sessions'); a.FontSize=12;

figure
for i=1:4
    subplot(2,2,i)
    imagesc(OccupMap_squeeze.Freeze_Blocked.Cond{i}), axis xy, caxis([0 8e-3])
    axis off
    title(Legends{i})
end
a=suptitle('Freezing occupancy maps, Cond sessions'); a.FontSize=12;


figure
MakeSpreadAndBoxPlot3_SB(Tigmo_score_all.Freeze.Cond,Cols,X,Legends,'showpoints',1,'paired',0)
ylabel('thigmo score (a.u.)')
title('Thigmotaxism score of freezing')

figure
MakeSpreadAndBoxPlot3_SB(Tigmo_score_all.Freeze_Unblocked.Cond,Cols,X,Legends,'showpoints',1,'paired',0)
ylabel('thigmo score (a.u.)')
title('Thigmotaxism score of freezing')



figure
for group=7
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        subplot(2,7,mouse)
        imagesc(squeeze(OccupMap.Freeze.Cond{3}(mouse,:,:))), axis xy, caxis([0 8e-5])
        axis off
        title(['Mouse #' num2str(mouse) ', ' num2str(Tigmo_score_all.Active_Unblocked.(Session_type{sess}){3}(mouse))])
        if mouse==1; u=text(-.1,.2,'Rip control'); set(u,'FontSize',15,'FontWeight','bold','Rotation',90); end
        
    end
end
for group=8
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        subplot(2,7,mouse+7)
        imagesc(squeeze(OccupMap.Freeze.Cond{4}(mouse,:,:))), axis xy, caxis([0 8e-5])
        axis off
        title(['Mouse #' num2str(mouse) ', ' num2str(Tigmo_score_all.Active_Unblocked.(Session_type{sess}){3}(mouse))])
        if mouse==1; u=text(-.1,.2,'Rip inhib'); set(u,'FontSize',15,'FontWeight','bold','Rotation',90); end
        
    end
end
