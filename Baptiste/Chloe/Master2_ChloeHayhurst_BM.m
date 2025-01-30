
%% Chloé Master 2 report

%% I. Methods confirmation

% After Ripples_Inhibition_Features_ForReal_BM
figure
Data_to_use = BandPassed_Envelope_LFP_rip_corr_all{1};
Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-450,140,568) , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
cols=[.65, .75, 0]; h.mainLine.Color=cols; h.patch.FaceColor=cols; h.edge(1).Color=cols; h.edge(2).Color=cols;
Data_to_use = BandPassed_Envelope_LFP_rip_all{2}(:,1:360);
Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-500,-200,360) , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
cols=[.63, .08, .18]; h.mainLine.Color=cols; h.patch.FaceColor=cols; h.edge(1).Color=cols; h.edge(2).Color=cols;
Data_to_use = BandPassed_Envelope_AroundRip_all{1};
Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-375,0,499) , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
cols=[.3, .745, .93]; h.mainLine.Color=cols; h.patch.FaceColor=cols; h.edge(1).Color=cols; h.edge(2).Color=cols;

xlim([-250 -50]), vline(0,'--r'), vline(-200,'--r')
ylabel('Enveloppe filtered signal 120-250Hz (a.u.)'), xlabel('time (ms)')
t=text(0,350,'VHC stims','Color','r');
f=get(gca,'Children'); l=legend([f(13),f(9),f(5)],'Enveloppe before VHC stim, rip sham','Enveloppe before VHC stim, rip inhib','Enveloppe around ripples, rip sham'); 

a=suptitle('Signal enveloppe after band pass filter 120-250Hz'); a.FontSize=12;


figure
subplot(121)
a= pie([nanmean(Prop_Rip_Before_Stim_all{1}) 1-nanmean(Prop_Rip_Before_Stim_all{1})]);
set(a(1), 'FaceColor', [1 0 0]); set(a(3), 'FaceColor', [0 0 0]);
title('Proba ripples before VHC stim')

subplot(122)
a= pie([nanmean(Prop_Stim_After_Rip_all{1}) 1-nanmean(Prop_Stim_After_Rip_all{1})]);
set(a(1), 'FaceColor', [1 0 0]); set(a(3), 'FaceColor', [0 0 0]);
title('Proba VHC stim after ripples')



% after DrugsGroups_Comparison_Overview_Maze_BM, check ripples density and VHC stims density
figure, sess=5;
subplot(121)
MakeSpreadAndBoxPlot3_SB(Ripples_Shock.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0); 
ylim([0 1]), ylabel('#/s')
title('Shock freezing')
subplot(122)
MakeSpreadAndBoxPlot3_SB(Ripples_Safe.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0); 
ylim([0 1])
title('Safe freezing')

a=suptitle('Ripples density during freezing'); a.FontSize=20;



Cols = {[.65, .75, 0],[.63, .08, .18]};
X = [1:2];
Legends = {'Rip sham','Rip inhib'};
NoLegends = {'',''};


figure, sess=5;
subplot(121)
clear A B; A = Ripples_Shock.(Session_type{sess}){3}+VHC_Stim_FreezingDensity_Shock{1}; B = Ripples_Shock.(Session_type{sess}){4}+VHC_Stim_FreezingDensity_Shock{2}([1 5 6 7]);
MakeSpreadAndBoxPlot3_SB({A B},Cols,X,Legends,'showpoints',1,'paired',0); 
ylim([0 1]), ylabel('#/s')
title('Shock freezing')
subplot(122)
clear A B; A = Ripples_Safe.(Session_type{sess}){3}; B = Ripples_Safe.(Session_type{sess}){4}+VHC_Stim_FreezingDensity_Safe{2}([1 5 6 7]);
MakeSpreadAndBoxPlot3_SB({A B},Cols,X,Legends,'showpoints',1,'paired',0); 
ylim([0 1])
title('Safe freezing')

a=suptitle('Ripples density during freezing'); a.FontSize=20;




% Ripples mean waveform
for group=5:8
    Mouse=Drugs_Groups_UMaze_BM(group);
    for sess=1:length(Session_type) % generate all data required for analyses
        [OutPutData2.(Drug_Group{group}).(Session_type{sess}) , Epoch1.(Drug_Group{group}).(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type{sess}),'ripples_meanwaveform');
    end
end

figure
subplot(221)
Data_to_use = squeeze(OutPutData2.Saline.Cond.ripples_meanwaveform(:,6,:));
Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-400,400,1001) , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
cols=[.3, .745, .93]; h.mainLine.Color=cols; h.patch.FaceColor=cols; h.edge(1).Color=cols; h.edge(2).Color=cols;
xlim([-50 50]), ylim([-4e3 2e3]), ylabel('amplitude (a.u)')
title('Saline')

subplot(222)
Data_to_use = squeeze(OutPutData2.Diazepam.Cond.ripples_meanwaveform(:,6,:));
Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-400,400,1001) , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
cols=[.85, .325, .098]; h.mainLine.Color=cols; h.patch.FaceColor=cols; h.edge(1).Color=cols; h.edge(2).Color=cols;
xlim([-50 50]), ylim([-4e3 2e3])
title('Diazepam')

subplot(223)
Data_to_use = squeeze(OutPutData2.RipControl.Cond.ripples_meanwaveform(:,6,:));
Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-400,400,1001) , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
cols=[.65, .75, 0]; h.mainLine.Color=cols; h.patch.FaceColor=cols; h.edge(1).Color=cols; h.edge(2).Color=cols;
xlim([-50 50]), ylim([-4e3 2e3]), xlabel('time (ms)'), ylabel('amplitude (a.u)')
title('Rip sham')

subplot(224)
Data_to_use = squeeze(OutPutData2.RipInhib.Cond.ripples_meanwaveform(:,6,:));
Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-400,400,1001) , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
cols=[.63, .08, .18]; h.mainLine.Color=cols; h.patch.FaceColor=cols; h.edge(1).Color=cols; h.edge(2).Color=cols;
xlim([-50 50]), ylim([-4e3 2e3]), xlabel('time (ms)')
title('Rip inhib')



%% II. Thigmotaxism & reaction to stim
% after Trajectories_Function_Maze_BM
figure
subplot(221)
plot(Position.Active_Unblocked.M1391.Cond(:,1) , Position.Active_Unblocked.M1391.Cond(:,2),'.')
axis off
title('Saline mouse, thigmo=0.83')
subplot(222)
plot(Position.Active_Unblocked.M11253.Cond(:,1) , Position.Active_Unblocked.M11253.Cond(:,2),'.')
axis off
title('Diazepam mouse, thigmo=0.50')
subplot(223)
imagesc(OccupMap.Active_Unblocked.M1391.Cond), axis xy, caxis([0 8e-4])
axis off
subplot(224)
imagesc(OccupMap.Active_Unblocked.M11253.Cond), axis xy, caxis([0 8e-4])
axis off


Cols = {[1 .5 .5],[1 .3 .3],[1 0 0]};
X = [1:3];
Legends = {'TestPre','Cond','Test Post'};
NoLegends = {'','','',''};


figure
MakeSpreadAndBoxPlot3_SB({Tigmo_score_all.Active_Unblocked.TestPre{1} Tigmo_score_all.Active_Unblocked.Cond{1} Tigmo_score_all.Active_Unblocked.TestPost{1}},Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 1]), ylabel('thigmo score (a.u.)')


Cols = {[.3, .745, .93],[.85, .325, .098]};
X = [1:2];
Legends = {'Saline','Diazepam'};
NoLegends = {'',''};

figure
MakeSpreadAndBoxPlot3_SB({Tigmo_score_all.Active_Unblocked.Cond{1} Tigmo_score_all.Active_Unblocked.Cond{2}},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 1]), ylabel('thigmo score (a.u.)')



% after Reaction_To_Stim_Accelero_BM
figure
Data_to_use1 = squeeze(Accelero_Around_Eyelid.SalineBM);
Conf_Inter = nanstd(Data_to_use1)/sqrt(size(Data_to_use1,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use1);
h=shadedErrorBar(linspace(-1,2,150) , runmean(Mean_All_Sp,5) , runmean(Conf_Inter,5), 'r',1); hold on;
cols=[.3, .745, .93]; h.mainLine.Color=cols; h.patch.FaceColor=cols; h.edge(1).Color=cols; h.edge(2).Color=cols;

Data_to_use2 = squeeze(Accelero_Around_Eyelid.Diazepam);
Conf_Inter = nanstd(Data_to_use2)/sqrt(size(Data_to_use2,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use2);
h=shadedErrorBar(linspace(-1,2,150) , runmean(Mean_All_Sp,5) , runmean(Conf_Inter,5), 'r',1); hold on;
cols=[.85, .325, .098]; h.mainLine.Color=cols; h.patch.FaceColor=cols; h.edge(1).Color=cols; h.edge(2).Color=cols;

f=get(gca,'Children'); legend([f(8),f(4)],'Saline','Diazepam')
vline(0,'--r')
xlabel('time (s)'), ylabel('Movement quantity (a.u.)')

for i=1:length(squeeze(Accelero_Around_Eyelid.SalineBM))
    [g(i),p(i)] = ttest2(Data_to_use1(:,i),Data_to_use2(:,i));
end
A=linspace(-1,2,150); plot(A(p<.05),6.5e8,'*k');

a=suptitle('Mean accelero reaction to eyelid shock'); a.FontSize=12;



figure
Data_to_use3 = squeeze(Accelero_Around_Eyelid.RipControl);
Conf_Inter = nanstd(Data_to_use3)/sqrt(size(Data_to_use3,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use3);
h=shadedErrorBar(linspace(-1,2,150) , runmean(Mean_All_Sp,5) , runmean(Conf_Inter,5), 'r',1); hold on;
cols=[.65, .75, 0]; h.mainLine.Color=cols; h.patch.FaceColor=cols; h.edge(1).Color=cols; h.edge(2).Color=cols;

Data_to_use4 = squeeze(Accelero_Around_Eyelid.RipInhib);
Conf_Inter = nanstd(Data_to_use4)/sqrt(size(Data_to_use4,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use4);
h=shadedErrorBar(linspace(-1,2,150) , runmean(Mean_All_Sp,5) , runmean(Conf_Inter,5), 'r',1); hold on;
cols=[.63, .08, .18]; h.mainLine.Color=cols; h.patch.FaceColor=cols; h.edge(1).Color=cols; h.edge(2).Color=cols;

f=get(gca,'Children'); legend([f(8),f(4)],'Rip sham','Rip inhib')
vline(0,'--r')
xlabel('time (s)'), ylabel('Movement quantity (a.u.)')

for i=1:length(squeeze(Accelero_Around_Eyelid.SalineBM))
    [g(i),p(i)] = ttest2(Data_to_use3(:,i),Data_to_use4(:,i));
end
A=linspace(-1,2,150); plot(A(p<.05),6.5e8,'*k');

a=suptitle('Mean accelero reaction to eyelid shock'); a.FontSize=12;


figure
for i=1:4
    subplot(2,2,i)
    imagesc(OccupMap_squeeze.Active_Unblocked.Cond{i}), axis xy, caxis([0 8e-4])
    axis off
    title(Legends{i})
end


figure
for i=1:4
    subplot(2,2,i)
    imagesc(OccupMap_squeeze.Active_Unblocked.TestPost{i}), axis xy, caxis([0 8e-4])
    axis off
end


for i=1:4
    Diff{i} = ShockEntriesZone.TestPost{i}-ShockEntriesZone.TestPre{i};
end

figure
MakeSpreadAndBoxPlot3_SB(Diff,Cols,X,Legends,'showpoints',1,'paired',0);



%% III. Comparing ripples inhib & DZP, behaviour
% shock zone features
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


figure
subplot(131)
PlotErrorBarN_SL(Proportional_Time_Unblocked.Shock.Cond,'barcolors',Cols,'showpoints',1,'newfig',0,'paired',0);
xticks([1:4]), xticklabels(Legends), xtickangle(45)
ylabel('proportion')
title('Time spent shock zone')

subplot(132)
PlotErrorBarN_SL(ShockEntriesZone.Cond,'barcolors',Cols,'showpoints',1,'newfig',0,'paired',0);
xticks([1:4]), xticklabels(Legends), xtickangle(45)
ylabel('#')
title('Shock zone entries')

subplot(133)
PlotErrorBarN_SL(ExtraStimNumber.Cond,'barcolors',Cols,'showpoints',1,'newfig',0,'paired',0);
xticks([1:4]), xticklabels(Legends), xtickangle(45)
ylabel('#')
title('Eyelid shocks')

a=suptitle('Shock zone features, Cond sessions'); a.FontSize=12;


% Freezing
figure
subplot(131)
MakeSpreadAndBoxPlot3_SB(Proportional_TimeFz.All.Cond,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('proportion'), ylim([0 .45])
title('Freezing')

subplot(132)
MakeSpreadAndBoxPlot3_SB(Proportional_TimeFz.Shock.Cond,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('proportion'), ylim([0 .45])
title('Freezing shock')

subplot(133)
MakeSpreadAndBoxPlot3_SB(Proportional_TimeFz.Safe.Cond,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('proportion'), ylim([0 .45])
title('Freezing safe')

a=suptitle('Freezing features, Cond sessions'); a.FontSize=12;



% Thigmotaxism
figure
MakeSpreadAndBoxPlot3_SB(Tigmo_score_all.Active_Unblocked.Cond,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('thigmo score (a.u.)')

a=suptitle('Thigmotaxism, Cond sessions'); a.FontSize=12;


% Aversive memory
figure
subplot(231)
MakeSpreadAndBoxPlot3_SB(ShockEntriesZone.TestPre,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('shock zone entries (#)'), ylim([0 35])
title('Test Pre')

subplot(232)
MakeSpreadAndBoxPlot3_SB(ShockEntriesZone.TestPost,Cols,X,Legends,'showpoints',1,'paired',0);
title('Test Post'), ylim([0 35])

for i=1:4
    A{i} = ShockEntriesZone.TestPost{i}-ShockEntriesZone.TestPre{i};
end
subplot(233)
MakeSpreadAndBoxPlot3_SB(A,Cols,X,Legends,'showpoints',1,'paired',0);
title('Test Psot - Test Pre'), ylim([0 35])

subplot(234)
MakeSpreadAndBoxPlot3_SB(Proportional_Time_Unblocked.Shock.TestPre,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('shock zone occupancy (prop)'), ylim([0 .6])

subplot(235)
MakeSpreadAndBoxPlot3_SB(Proportional_Time_Unblocked.Shock.TestPost,Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 .6])

for i=1:4
    A{i} = Proportional_Time_Unblocked.Shock.TestPost{i}-Proportional_Time_Unblocked.Shock.TestPre{i};
end
subplot(236)
MakeSpreadAndBoxPlot3_SB(A,Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 .6])

a=suptitle('Behaviour, Test Post'); a.FontSize=12;


figure
for i=1:4
    A{i} = ShockEntriesZone.TestPost{i}-ShockEntriesZone.TestPre{i};
end
MakeSpreadAndBoxPlot3_SB(A,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('shock zone entries, Test Post - Test Pre')


figure
subplot(131)
MakeSpreadAndBoxPlot3_SB(Proportional_TimeFz.All.Ext,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('proportion'), ylim([0 .45])
title('Freezing')

subplot(132)
MakeSpreadAndBoxPlot3_SB(Proportional_TimeFz.Shock.Ext,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('proportion'), ylim([0 .45])
title('Freezing shock')

subplot(133)
MakeSpreadAndBoxPlot3_SB(Proportional_TimeFz.Safe.Ext,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('proportion'), ylim([0 .45])
title('Freezing safe')

a=suptitle('Freezing features, Ext sessions'); a.FontSize=12;




figure
for i=1:4
    subplot(2,4,i)
    imagesc(OccupMap_squeeze.Active_Unblocked.Cond{i}), axis xy, caxis([0 8e-4])
    axis off
    if i==1; t=text(-10,15,'Cond'); set(t,'Rotation',90); end
    title(Drug_Group{i})
    
    subplot(2,4,i+4)
    imagesc(OccupMap_squeeze.Active_Unblocked.TestPost{i}), axis xy, caxis([0 8e-4])
    axis off
    if i==1; t=text(-10,15,'TestPost'); set(t,'Rotation',90); end
end

Drug_Group={'Saline','Diazepam','Rip sham','Rip inhib'};












