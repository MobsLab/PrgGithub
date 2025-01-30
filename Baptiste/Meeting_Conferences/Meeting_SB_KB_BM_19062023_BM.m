
ind1=[1:6];
ind2=[1 5 6 7];

%% after edit Ripples_Inhibition_Features_ForReal_BM.m


figure

subplot(341)
MakeSpreadAndBoxPlot3_SB(VHC_Stim_Numb_All ,Cols,X,NoLegends , 'showpoints',1,'paired',0);
title('VHC stims'); ylabel('#');
subplot(342)
MakeSpreadAndBoxPlot3_SB(VHC_Stim_Numb_DuringFreezing_All , Cols,X,NoLegends , 'showpoints',1,'paired',0);
title('VHC stims during freezing'); ylabel('#');
subplot(343)
MakeSpreadAndBoxPlot3_SB(VHC_Stim_Prop_DuringFreezing_All , Cols,X,NoLegends , 'showpoints',1,'paired',0);
title('VHC stims freezing proportion'); ylabel('proportion')
subplot(344)
MakeSpreadAndBoxPlot3_SB(VHC_Stim_FreezingDensity_All , Cols,X,NoLegends , 'showpoints',1,'paired',0);
title('VHC density freezing'); ylabel('Hz');
subplot(345)
MakeSpreadAndBoxPlot3_SB(VHC_Stim_Numb_DuringFreezing_Shock , Cols,X,NoLegends , 'showpoints',1,'paired',0);
title('VHC stims during shock freezing'); ylabel('#'); ylim([0 650]);
subplot(346)
MakeSpreadAndBoxPlot3_SB(VHC_Stim_Numb_DuringFreezing_Safe , Cols,X,NoLegends , 'showpoints',1,'paired',0);
title('VHC stims during safe freezing'); ylabel('#'); ylim([0 650]);
subplot(347)
MakeSpreadAndBoxPlot3_SB(VHC_Stim_Numb_DuringActive_Shock , Cols,X,NoLegends , 'showpoints',1,'paired',0);
title('VHC stims during shock active'); ylabel('#'); ylim([0 650]);
subplot(348)
MakeSpreadAndBoxPlot3_SB(VHC_Stim_Numb_DuringActive_Safe , Cols,X,NoLegends , 'showpoints',1,'paired',0);
title('VHC stims during safe active'); ylabel('#'); ylim([0 650]);
subplot(349)
MakeSpreadAndBoxPlot3_SB(VHC_Stim_FreezingDensity_Shock , Cols,X,Legends , 'showpoints',1,'paired',0);
title('VHC density shock freezing'); ylabel('Hz'); ylim([0 1])
subplot(3,4,10)
MakeSpreadAndBoxPlot3_SB(VHC_Stim_FreezingDensity_Safe , Cols,X,Legends , 'showpoints',1,'paired',0);
title('VHC density safe freezing'); ylabel('Hz'); ylim([0 1])
subplot(3,4,11)
MakeSpreadAndBoxPlot3_SB(VHC_Stim_ActiveDensity_Shock , Cols,X,Legends , 'showpoints',1,'paired',0);
title('VHC density shock active'); ylabel('Hz'); ylim([0 1])
subplot(3,4,12)
MakeSpreadAndBoxPlot3_SB(VHC_Stim_ActiveDensity_Safe , Cols,X,Legends , 'showpoints',1,'paired',0);
title('VHC density safe active'); ylabel('Hz'); ylim([0 1])

a=suptitle('Ripples inhibition features, experimental overview'); a.FontSize=20;


% correcting for good mice
figure
subplot(341)
MakeSpreadAndBoxPlot3_SB({VHC_Stim_Numb_All{1}(ind1) VHC_Stim_Numb_All{2}(ind2)} ,Cols,X,NoLegends , 'showpoints',1,'paired',0);
title('VHC stims'); ylabel('#')
subplot(342)
MakeSpreadAndBoxPlot3_SB({VHC_Stim_Numb_DuringFreezing_All{1}(ind1) VHC_Stim_Numb_DuringFreezing_All{2}(ind2)} ,Cols,X,NoLegends , 'showpoints',1,'paired',0);
title('VHC stims during freezing'); ylabel('#');
subplot(343)
MakeSpreadAndBoxPlot3_SB({VHC_Stim_Prop_DuringFreezing_All{1}(ind1) VHC_Stim_Prop_DuringFreezing_All{2}(ind2)} ,Cols,X,NoLegends , 'showpoints',1,'paired',0);
title('VHC stims freezing proportion'); ylabel('proportion')
subplot(344)
MakeSpreadAndBoxPlot3_SB({VHC_Stim_FreezingDensity_All{1}(ind1) VHC_Stim_FreezingDensity_All{2}(ind2)} ,Cols,X,NoLegends , 'showpoints',1,'paired',0);
title('VHC density freezing'); ylabel('Hz');
subplot(345)
MakeSpreadAndBoxPlot3_SB({VHC_Stim_Numb_DuringFreezing_Shock{1}(ind1) VHC_Stim_Numb_DuringFreezing_Shock{2}(ind2)} ,Cols,X,NoLegends , 'showpoints',1,'paired',0);
title('VHC stims during shock freezing'); ylabel('#'); ylim([0 650]);
subplot(346)
MakeSpreadAndBoxPlot3_SB({VHC_Stim_Numb_DuringFreezing_Safe{1}(ind1) VHC_Stim_Numb_DuringFreezing_Safe{2}(ind2)} ,Cols,X,NoLegends , 'showpoints',1,'paired',0);
title('VHC stims during safe freezing'); ylabel('#'); ylim([0 650]);
subplot(347)
MakeSpreadAndBoxPlot3_SB({VHC_Stim_Numb_DuringActive_Shock{1}(ind1) VHC_Stim_Numb_DuringActive_Shock{2}(ind2)} ,Cols,X,NoLegends , 'showpoints',1,'paired',0);
title('VHC stims during shock active'); ylabel('#'); ylim([0 650]);
subplot(348)
MakeSpreadAndBoxPlot3_SB({VHC_Stim_Numb_DuringActive_Safe{1}(ind1) VHC_Stim_Numb_DuringActive_Safe{2}(ind2)} ,Cols,X,NoLegends , 'showpoints',1,'paired',0);
title('VHC stims during safe active'); ylabel('#'); ylim([0 650]);
subplot(349)
MakeSpreadAndBoxPlot3_SB({VHC_Stim_FreezingDensity_Shock{1}(ind1) VHC_Stim_FreezingDensity_Shock{2}(ind2)} ,Cols,X,Legends , 'showpoints',1,'paired',0);
title('VHC density shock freezing'); ylabel('Hz'); ylim([0 1])
subplot(3,4,10)
MakeSpreadAndBoxPlot3_SB({VHC_Stim_FreezingDensity_Safe{1}(ind1) VHC_Stim_FreezingDensity_Safe{2}(ind2)} ,Cols,X,Legends , 'showpoints',1,'paired',0);
title('VHC density safe freezing'); ylabel('Hz'); ylim([0 1])
subplot(3,4,11)
MakeSpreadAndBoxPlot3_SB({VHC_Stim_ActiveDensity_Shock{1}(ind1) VHC_Stim_ActiveDensity_Shock{2}(ind2)} ,Cols,X,Legends , 'showpoints',1,'paired',0);
title('VHC density shock active'); ylabel('Hz'); ylim([0 1])
subplot(3,4,12)
MakeSpreadAndBoxPlot3_SB({VHC_Stim_ActiveDensity_Safe{1}(ind1) VHC_Stim_ActiveDensity_Safe{2}(ind2)} ,Cols,X,Legends , 'showpoints',1,'paired',0);
title('VHC density safe active'); ylabel('Hz'); ylim([0 1])

a=suptitle('Ripples inhibition features, experimental overview'); a.FontSize=20;


figure
subplot(221)
MakeSpreadAndBoxPlot3_SB({VHC_Stim_FreezingDensity_Shock{1} VHC_Stim_FreezingDensity_Safe{1}} , {[1 .5 .5],[.5 .5 1]} , [1:2] , {'Shock','Safe'} , 'showpoints',0,'paired',1);
ylabel('VHC stim density (#/s)')
title('Ripples control')
subplot(222)
MakeSpreadAndBoxPlot3_SB({VHC_Stim_FreezingDensity_Shock{2} VHC_Stim_FreezingDensity_Safe{2}} , {[1 .5 .5],[.5 .5 1]} , [1:2] , {'Shock','Safe'} , 'showpoints',0,'paired',1);
title('Ripples inhib')
subplot(223)
MakeSpreadAndBoxPlot3_SB({VHC_Stim_FreezingDensity_Shock{1}(ind1) VHC_Stim_FreezingDensity_Safe{1}(ind1)} , {[1 .5 .5],[.5 .5 1]} , [1:2] , {'Shock','Safe'} , 'showpoints',0,'paired',1);
ylabel('VHC stim density (#/s)'), ylim([0 1])
subplot(224)
MakeSpreadAndBoxPlot3_SB({VHC_Stim_FreezingDensity_Shock{2}(ind2) VHC_Stim_FreezingDensity_Safe{2}(ind2)} , {[1 .5 .5],[.5 .5 1]} , [1:2] , {'Shock','Safe'} , 'showpoints',0,'paired',1);



figure
subplot(221)
MakeSpreadAndBoxPlot3_SB(VHC_density_shock , Cols,X,Legends , 'showpoints',1,'paired',0);
ylim([0 .4]), ylabel('VHC stims density (#/s)')
title('VHC stim density shock')
subplot(222)
MakeSpreadAndBoxPlot3_SB(VHC_density_safe , Cols,X,Legends , 'showpoints',1,'paired',0);
ylim([0 .4])
title('VHC stim density safe')
subplot(223)
MakeSpreadAndBoxPlot3_SB({VHC_density_shock{1}(ind1) VHC_density_shock{2}(ind2)} , Cols,X,Legends , 'showpoints',1,'paired',0);
ylim([0 .4]), ylabel('VHC stims density (#/s)')
subplot(224)
MakeSpreadAndBoxPlot3_SB({VHC_density_safe{1}(ind1) VHC_density_safe{2}(ind2)} , Cols,X,Legends , 'showpoints',1,'paired',0);
ylim([0 .4])
title('VHC stim density safe')


figure
subplot(231)
[r1,p1] = PlotCorrelations_BM(VHC_Stim_Numb_All{1} ,FreezeTime_All{1} ,'Color', 'g');
[r2,p2] = PlotCorrelations_BM(VHC_Stim_Numb_All{2} ,FreezeTime_All{2} ,'Color', 'r');
axis square
ylabel('Freezing time (s)'), xlabel('VHC stims')
legend(['R = ' num2str(r1) ', p = ' num2str(p1)],['R = ' num2str(r2) ', p = ' num2str(p2)])
title('Freezing total')

subplot(332)
[r1,p1] = PlotCorrelations_BM(VHC_Stim_Numb_All{1} ,FreezeTime_Shock{1} ,'Color', 'g');
[r2,p2] = PlotCorrelations_BM(VHC_Stim_Numb_All{2} ,FreezeTime_Shock{2} ,'Color', 'r');
axis square
ylabel('Freezing time (s)'), xlabel('VHC stims')
legend(['R = ' num2str(r1) ', p = ' num2str(p1)],['R = ' num2str(r2) ', p = ' num2str(p2)])
title('Freezing shock')

subplot(333)
[r1,p1] = PlotCorrelations_BM(VHC_Stim_Numb_All{1} ,FreezeTime_Safe{1} ,'Color', 'g');
[r2,p2] = PlotCorrelations_BM(VHC_Stim_Numb_All{2} ,FreezeTime_Safe{2} ,'Color', 'r');
axis square
ylabel('Freezing time (s)'), xlabel('VHC stims')
legend(['R = ' num2str(r1) ', p = ' num2str(p1)],['R = ' num2str(r2) ', p = ' num2str(p2)])
title('Freezing safe')

[r1,p1] = PlotCorrelations_BM(VHC_Stim_Freezing{1} ,FreezeTime_Safe{1} ,'Color', 'g');
[r2,p2] = PlotCorrelations_BM(VHC_Stim_Numb_All{2} ,FreezeTime_Safe{2} ,'Color', 'r');
axis square
ylabel('Freezing time (s)'), xlabel('VHC stims')
legend(['R = ' num2str(r1) ', p = ' num2str(p1)],['R = ' num2str(r2) ', p = ' num2str(p2)])
title('Freezing safe')


subplot(334)
[r1,p1] = PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_All{1} ,FreezeTime_All{1} ,'Color', 'g');
[r2,p2] = PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_All{2} ,FreezeTime_All{2} ,'Color', 'r');
axis square
ylabel('Freezing time (s)'), xlabel('VHC stims during freezing')
legend(['R = ' num2str(r1) ', p = ' num2str(p1)],['R = ' num2str(r2) ', p = ' num2str(p2)])

subplot(335)
[r1,p1] = PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_Shock{1} , FreezeTime_Shock{1} ,'Color', 'g');
[r2,p2] = PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_Shock{2} , FreezeTime_Shock{2} ,'Color', 'r');
axis square
ylabel('Freezing time (s)'), xlabel('VHC stims during shock freezing')
legend(['R = ' num2str(r1) ', p = ' num2str(p1)],['R = ' num2str(r2) ', p = ' num2str(p2)])

subplot(336)
[r1,p1] = PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_Safe{1} ,FreezeTime_Safe{1} ,'Color', 'g');
[r2,p2] = PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_Safe{2} ,FreezeTime_Safe{2} ,'Color', 'r');
axis square
ylabel('Freezing time (s)'), xlabel('VHC stims during safe freezing')
legend(['R = ' num2str(r1) ', p = ' num2str(p1)],['R = ' num2str(r2) ', p = ' num2str(p2)])


subplot(337)
[r1,p1] = PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_All{1}(ind1) ,FreezeTime_All{1}(ind1) ,'Color', 'g');
[r2,p2] = PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_All{2}(ind2) ,FreezeTime_All{2}(ind2) ,'Color', 'r');
axis square
ylabel('Freezing time (s)'), xlabel('VHC stims during freezing')
legend(['R = ' num2str(r1) ', p = ' num2str(p1)],['R = ' num2str(r2) ', p = ' num2str(p2)])

subplot(338)
[r1,p1] = PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_Shock{1}(ind1) , FreezeTime_Shock{1}(ind1) ,'Color', 'g');
[r2,p2] = PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_Shock{2}(ind2) , FreezeTime_Shock{2}(ind2) ,'Color', 'r');
axis square
ylabel('Freezing time (s)'), xlabel('VHC stims during shock freezing')
legend(['R = ' num2str(r1) ', p = ' num2str(p1)],['R = ' num2str(r2) ', p = ' num2str(p2)])

subplot(339)
[r1,p1] = PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_Safe{1}(ind1) ,FreezeTime_Safe{1}(ind1) ,'Color', 'g');
[r2,p2] = PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_Safe{2}(ind2) ,FreezeTime_Safe{2}(ind2) ,'Color', 'r');
axis square
ylabel('Freezing time (s)'), xlabel('VHC stims during safe freezing')
legend(['R = ' num2str(r1) ', p = ' num2str(p1)],['R = ' num2str(r2) ', p = ' num2str(p2)])



% other correlations
figure
subplot(341)
[r1,p1] = PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_All{1} ,FreezeTime_All{1} ,'Color', 'g');
[r2,p2] = PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_All{2} ,FreezeTime_All{2} ,'Color', 'r');
axis square
ylabel('Freezing time (s)'), xlabel('VHC stims during freezing')
legend(['R = ' num2str(r1) ', p = ' num2str(p1)],['R = ' num2str(r2) ', p = ' num2str(p2)])

subplot(342)
[r1,p1] = PlotCorrelations_BM(VHC_Stim_Numb_DuringActive_All{1} ,FreezeTime_All{1} ,'Color', 'g');
[r2,p2] = PlotCorrelations_BM(VHC_Stim_Numb_DuringActive_All{2} ,FreezeTime_All{2} ,'Color', 'r');
axis square
ylabel('Freezing time (s)'), xlabel('VHC stims during active')
legend(['R = ' num2str(r1) ', p = ' num2str(p1)],['R = ' num2str(r2) ', p = ' num2str(p2)])

subplot(343)
[r1,p1] = PlotCorrelations_BM(VHC_Stim_FreezingDensity_All{1} ,FreezeTime_All{1} ,'Color', 'g');
[r2,p2] = PlotCorrelations_BM(VHC_Stim_FreezingDensity_All{2} ,FreezeTime_All{2} ,'Color', 'r');
axis square
ylabel('Freezing time (s)'), xlabel('VHC density during freezing')
legend(['R = ' num2str(r1) ', p = ' num2str(p1)],['R = ' num2str(r2) ', p = ' num2str(p2)])

subplot(344)
[r1,p1] = PlotCorrelations_BM(VHC_Stim_ActiveDensity_All{1} ,FreezeTime_All{1} ,'Color', 'g');
[r2,p2] = PlotCorrelations_BM(VHC_Stim_ActiveDensity_All{2} ,FreezeTime_All{2} ,'Color', 'r');
axis square
ylabel('Freezing time (s)'), xlabel('VHC density during active')
legend(['R = ' num2str(r1) ', p = ' num2str(p1)],['R = ' num2str(r2) ', p = ' num2str(p2)])


subplot(345)
[r1,p1] = PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_Shock{1} ,FreezeTime_Shock{1} ,'Color', 'g');
[r2,p2] = PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_Shock{2} ,FreezeTime_Shock{2} ,'Color', 'r');
axis square
ylabel('Freezing shock time (s)'), xlabel('VHC stims during freezing')
legend(['R = ' num2str(r1) ', p = ' num2str(p1)],['R = ' num2str(r2) ', p = ' num2str(p2)])

subplot(346)
[r1,p1] = PlotCorrelations_BM(VHC_Stim_Numb_DuringActive_Shock{1} ,FreezeTime_Shock{1} ,'Color', 'g');
[r2,p2] = PlotCorrelations_BM(VHC_Stim_Numb_DuringActive_Shock{2} ,FreezeTime_Shock{2} ,'Color', 'r');
axis square
ylabel('Freezing shock time (s)'), xlabel('VHC stims during active')
legend(['R = ' num2str(r1) ', p = ' num2str(p1)],['R = ' num2str(r2) ', p = ' num2str(p2)])

subplot(347)
[r1,p1] = PlotCorrelations_BM(VHC_Stim_FreezingDensity_Shock{1} ,FreezeTime_Shock{1} ,'Color', 'g');
[r2,p2] = PlotCorrelations_BM(VHC_Stim_FreezingDensity_Shock{2} ,FreezeTime_Shock{2} ,'Color', 'r');
axis square
ylabel('Freezing shock time (s)'), xlabel('VHC density during freezing')
legend(['R = ' num2str(r1) ', p = ' num2str(p1)],['R = ' num2str(r2) ', p = ' num2str(p2)])

subplot(348)
[r1,p1] = PlotCorrelations_BM(VHC_Stim_ActiveDensity_Shock{1} ,FreezeTime_Shock{1} ,'Color', 'g');
[r2,p2] = PlotCorrelations_BM(VHC_Stim_ActiveDensity_Shock{2} ,FreezeTime_Shock{2} ,'Color', 'r');
axis square
ylabel('Freezing shock time (s)'), xlabel('VHC density during active')
legend(['R = ' num2str(r1) ', p = ' num2str(p1)],['R = ' num2str(r2) ', p = ' num2str(p2)])


subplot(349)
[r1,p1] = PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_Safe{1} ,FreezeTime_Safe{1} ,'Color', 'g');
[r2,p2] = PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_Safe{2} ,FreezeTime_Safe{2} ,'Color', 'r');
axis square
ylabel('Freezing Safe time (s)'), xlabel('VHC stims during freezing')
legend(['R = ' num2str(r1) ', p = ' num2str(p1)],['R = ' num2str(r2) ', p = ' num2str(p2)])

subplot(3,4,10)
[r1,p1] = PlotCorrelations_BM(VHC_Stim_Numb_DuringActive_Safe{1} ,FreezeTime_Safe{1} ,'Color', 'g');
[r2,p2] = PlotCorrelations_BM(VHC_Stim_Numb_DuringActive_Safe{2} ,FreezeTime_Safe{2} ,'Color', 'r');
axis square
ylabel('Freezing Safe time (s)'), xlabel('VHC stims during active')
legend(['R = ' num2str(r1) ', p = ' num2str(p1)],['R = ' num2str(r2) ', p = ' num2str(p2)])

subplot(3,4,11)
[r1,p1] = PlotCorrelations_BM(VHC_Stim_FreezingDensity_Safe{1} ,FreezeTime_Safe{1} ,'Color', 'g');
[r2,p2] = PlotCorrelations_BM(VHC_Stim_FreezingDensity_Safe{2} ,FreezeTime_Safe{2} ,'Color', 'r');
axis square
ylabel('Freezing Safe time (s)'), xlabel('VHC density during freezing')
legend(['R = ' num2str(r1) ', p = ' num2str(p1)],['R = ' num2str(r2) ', p = ' num2str(p2)])

subplot(3,4,12)
[r1,p1] = PlotCorrelations_BM(VHC_Stim_ActiveDensity_Safe{1} ,FreezeTime_Safe{1} ,'Color', 'g');
[r2,p2] = PlotCorrelations_BM(VHC_Stim_ActiveDensity_Safe{2} ,FreezeTime_Safe{2} ,'Color', 'r');
axis square
ylabel('Freezing Safe time (s)'), xlabel('VHC density during active')
legend(['R = ' num2str(r1) ', p = ' num2str(p1)],['R = ' num2str(r2) ', p = ' num2str(p2)])



figure
subplot(341)
[r1,p1] = PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_All{1}(ind1) ,FreezeTime_All{1}(ind1) ,'Color', 'g');
[r2,p2] = PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_All{2}(ind2) ,FreezeTime_All{2}(ind2) ,'Color', 'r');
axis square
ylabel('Freezing time (s)'), xlabel('VHC stims during freezing')
legend(['R = ' num2str(r1) ', p = ' num2str(p1)],['R = ' num2str(r2) ', p = ' num2str(p2)])

subplot(342)
[r1,p1] = PlotCorrelations_BM(VHC_Stim_Numb_DuringActive_All{1}(ind1) ,FreezeTime_All{1}(ind1) ,'Color', 'g');
[r2,p2] = PlotCorrelations_BM(VHC_Stim_Numb_DuringActive_All{2}(ind2) ,FreezeTime_All{2}(ind2) ,'Color', 'r');
axis square
ylabel('Freezing time (s)'), xlabel('VHC stims during active')
legend(['R = ' num2str(r1) ', p = ' num2str(p1)],['R = ' num2str(r2) ', p = ' num2str(p2)])

subplot(343)
[r1,p1] = PlotCorrelations_BM(VHC_Stim_FreezingDensity_All{1}(ind1) ,FreezeTime_All{1}(ind1) ,'Color', 'g');
[r2,p2] = PlotCorrelations_BM(VHC_Stim_FreezingDensity_All{2}(ind2) ,FreezeTime_All{2}(ind2) ,'Color', 'r');
axis square
ylabel('Freezing time (s)'), xlabel('VHC density during freezing')
legend(['R = ' num2str(r1) ', p = ' num2str(p1)],['R = ' num2str(r2) ', p = ' num2str(p2)])

subplot(344)
[r1,p1] = PlotCorrelations_BM(VHC_Stim_ActiveDensity_All{1}(ind1) ,FreezeTime_All{1}(ind1) ,'Color', 'g');
[r2,p2] = PlotCorrelations_BM(VHC_Stim_ActiveDensity_All{2}(ind2) ,FreezeTime_All{2}(ind2) ,'Color', 'r');
axis square
ylabel('Freezing time (s)'), xlabel('VHC density during active')
legend(['R = ' num2str(r1) ', p = ' num2str(p1)],['R = ' num2str(r2) ', p = ' num2str(p2)])


subplot(345)
[r1,p1] = PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_Shock{1}(ind1) ,FreezeTime_Shock{1}(ind1) ,'Color', 'g');
[r2,p2] = PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_Shock{2}(ind2) ,FreezeTime_Shock{2}(ind2) ,'Color', 'r');
axis square
ylabel('Freezing shock time (s)'), xlabel('VHC stims during freezing')
legend(['R = ' num2str(r1) ', p = ' num2str(p1)],['R = ' num2str(r2) ', p = ' num2str(p2)])

subplot(346)
[r1,p1] = PlotCorrelations_BM(VHC_Stim_Numb_DuringActive_Shock{1}(ind1) ,FreezeTime_Shock{1}(ind1) ,'Color', 'g');
[r2,p2] = PlotCorrelations_BM(VHC_Stim_Numb_DuringActive_Shock{2}(ind2) ,FreezeTime_Shock{2}(ind2) ,'Color', 'r');
axis square
ylabel('Freezing shock time (s)'), xlabel('VHC stims during active')
legend(['R = ' num2str(r1) ', p = ' num2str(p1)],['R = ' num2str(r2) ', p = ' num2str(p2)])

subplot(347)
[r1,p1] = PlotCorrelations_BM(VHC_Stim_FreezingDensity_Shock{1}(ind1) ,FreezeTime_Shock{1}(ind1) ,'Color', 'g');
[r2,p2] = PlotCorrelations_BM(VHC_Stim_FreezingDensity_Shock{2}(ind2) ,FreezeTime_Shock{2}(ind2) ,'Color', 'r');
axis square
ylabel('Freezing shock time (s)'), xlabel('VHC density during freezing')
legend(['R = ' num2str(r1) ', p = ' num2str(p1)],['R = ' num2str(r2) ', p = ' num2str(p2)])

subplot(348)
[r1,p1] = PlotCorrelations_BM(VHC_Stim_ActiveDensity_Shock{1}(ind1) ,FreezeTime_Shock{1}(ind1) ,'Color', 'g');
[r2,p2] = PlotCorrelations_BM(VHC_Stim_ActiveDensity_Shock{2}(ind2) ,FreezeTime_Shock{2}(ind2) ,'Color', 'r');
axis square
ylabel('Freezing shock time (s)'), xlabel('VHC density during active')
legend(['R = ' num2str(r1) ', p = ' num2str(p1)],['R = ' num2str(r2) ', p = ' num2str(p2)])


subplot(349)
[r1,p1] = PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_Safe{1}(ind1) ,FreezeTime_Safe{1}(ind1) ,'Color', 'g');
[r2,p2] = PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_Safe{2}(ind2) ,FreezeTime_Safe{2}(ind2) ,'Color', 'r');
axis square
ylabel('Freezing Safe time (s)'), xlabel('VHC stims during freezing')
legend(['R = ' num2str(r1) ', p = ' num2str(p1)],['R = ' num2str(r2) ', p = ' num2str(p2)])

subplot(3,4,10)
[r1,p1] = PlotCorrelations_BM(VHC_Stim_Numb_DuringActive_Safe{1}(ind1) ,FreezeTime_Safe{1}(ind1) ,'Color', 'g');
[r2,p2] = PlotCorrelations_BM(VHC_Stim_Numb_DuringActive_Safe{2}(ind2) ,FreezeTime_Safe{2}(ind2) ,'Color', 'r');
axis square
ylabel('Freezing Safe time (s)'), xlabel('VHC stims during active')
legend(['R = ' num2str(r1) ', p = ' num2str(p1)],['R = ' num2str(r2) ', p = ' num2str(p2)])

subplot(3,4,11)
[r1,p1] = PlotCorrelations_BM(VHC_Stim_FreezingDensity_Safe{1}(ind1) ,FreezeTime_Safe{1}(ind1) ,'Color', 'g');
[r2,p2] = PlotCorrelations_BM(VHC_Stim_FreezingDensity_Safe{2}(ind2) ,FreezeTime_Safe{2}(ind2) ,'Color', 'r');
axis square
ylabel('Freezing Safe time (s)'), xlabel('VHC density during freezing')
legend(['R = ' num2str(r1) ', p = ' num2str(p1)],['R = ' num2str(r2) ', p = ' num2str(p2)])

subplot(3,4,12)
[r1,p1] = PlotCorrelations_BM(VHC_Stim_ActiveDensity_Safe{1}(ind1) ,FreezeTime_Safe{1}(ind1) ,'Color', 'g');
[r2,p2] = PlotCorrelations_BM(VHC_Stim_ActiveDensity_Safe{2}(ind2) ,FreezeTime_Safe{2}(ind2) ,'Color', 'r');
axis square
ylabel('Freezing Safe time (s)'), xlabel('VHC density during active')
legend(['R = ' num2str(r1) ', p = ' num2str(p1)],['R = ' num2str(r2) ', p = ' num2str(p2)])



%% after DrugsGroups_Comparison_Overview_Maze_BM
% time spent in zones
figure; n=1;
for sess=1:3
    subplot(2,3,n)
    MakeSpreadAndBoxPlot3_SB(Proportional_Time_Unblocked.(Side{2}).(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if n==1; ylabel('prop time'); end
    title(Session_type{sess})
    if n==1; u=text(-1,.2,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    ylim([0 .6])
    
    subplot(2,3,n+3)
    MakeSpreadAndBoxPlot3_SB(Proportional_Time_Unblocked.(Side{3}).(Session_type{sess})([ind]),Cols,X,Legends,'showpoints',1,'paired',0);
    if n==1; ylabel('prop time'); end
    if n==1; u=text(-1,.4,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    ylim([0 1.1])

    n=n+1;
end
a=suptitle('Time in zone / Total time, when free'); a.FontSize=20;


figure; n=1;
for sess=1:3
    subplot(2,3,n)
    MakeSpreadAndBoxPlot3_SB({Proportional_Time_Unblocked.(Side{2}).(Session_type{sess}){1} Proportional_Time_Unblocked.(Side{2}).(Session_type{sess}){2} Proportional_Time_Unblocked.(Side{2}).(Session_type{sess}){3}(ind1) Proportional_Time_Unblocked.(Side{2}).(Session_type{sess}){4}(ind2)},Cols,X,NoLegends,'showpoints',1,'paired',0);
    if n==1; ylabel('prop time'); end
    title(Session_type{sess})
    if n==1; u=text(-1,.2,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    ylim([0 .6])
    
    subplot(2,3,n+3)
    MakeSpreadAndBoxPlot3_SB({Proportional_Time_Unblocked.(Side{3}).(Session_type{sess}){1} Proportional_Time_Unblocked.(Side{3}).(Session_type{sess}){2} Proportional_Time_Unblocked.(Side{3}).(Session_type{sess}){3}(ind1) Proportional_Time_Unblocked.(Side{3}).(Session_type{sess}){4}(ind2)},Cols,X,Legends,'showpoints',1,'paired',0);
    if n==1; ylabel('prop time'); end
    if n==1; u=text(-1,.4,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    ylim([0 1.1])

    n=n+1;
end
a=suptitle('Time in zone / Total time, when free'); a.FontSize=20;



% freezing
figure; n=1;
for sess=[1 2 4]
    subplot(3,3,n)
    MakeSpreadAndBoxPlot3_SB(Proportional_TimeFz.(Side{1}).(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if n==1; ylabel('prop time'); end
    title(Session_type{sess})
    if n==1; u=text(-1,.25,'Total'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    ylim([0 .7])
    
    subplot(3,3,n+3)
    MakeSpreadAndBoxPlot3_SB(Proportional_TimeFz.(Side{2}).(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if n==1; ylabel('prop time'); end
    if n==1; u=text(-1,.07,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    ylim([0 .3])
    
    subplot(3,3,n+6)
    MakeSpreadAndBoxPlot3_SB(Proportional_TimeFz.(Side{3}).(Session_type{sess})([ind]),Cols,X,Legends,'showpoints',1,'paired',0);
    if n==1; ylabel('prop time'); end
    if n==1; u=text(-1,.25,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    ylim([0 .6])
    
    n=n+1;
end
a=suptitle('Time freezing in zone / Total time'); a.FontSize=20;


figure; n=1;
for sess=[1 2 4]
    subplot(3,3,n)
    MakeSpreadAndBoxPlot3_SB({Proportional_TimeFz.(Side{1}).(Session_type{sess}){1} Proportional_TimeFz.(Side{1}).(Session_type{sess}){2} Proportional_TimeFz.(Side{1}).(Session_type{sess}){3}(ind1) Proportional_TimeFz.(Side{1}).(Session_type{sess}){4}(ind2)},Cols,X,NoLegends,'showpoints',1,'paired',0);
    if n==1; ylabel('prop time'); end
    title(Session_type{sess})
    if n==1; u=text(-1,.25,'Total'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    ylim([0 .7])
    
    subplot(3,3,n+3)
    MakeSpreadAndBoxPlot3_SB({Proportional_TimeFz.(Side{2}).(Session_type{sess}){1} Proportional_TimeFz.(Side{2}).(Session_type{sess}){2} Proportional_TimeFz.(Side{2}).(Session_type{sess}){3}(ind1) Proportional_TimeFz.(Side{2}).(Session_type{sess}){4}(ind2)},Cols,X,NoLegends,'showpoints',1,'paired',0);
    if n==1; ylabel('prop time'); end
    if n==1; u=text(-1,.07,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    ylim([0 .3])
    
    subplot(3,3,n+6)
    MakeSpreadAndBoxPlot3_SB({Proportional_TimeFz.(Side{3}).(Session_type{sess}){1} Proportional_TimeFz.(Side{3}).(Session_type{sess}){2} Proportional_TimeFz.(Side{3}).(Session_type{sess}){3}(ind1) Proportional_TimeFz.(Side{3}).(Session_type{sess}){4}(ind2)},Cols,X,Legends,'showpoints',1,'paired',0);
    if n==1; ylabel('prop time'); end
    if n==1; u=text(-1,.25,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    ylim([0 .6])
    
    n=n+1;
end
a=suptitle('Time freezing in zone / Total time'); a.FontSize=20;


% zone entries
figure; n=1;
for sess=[1:3]
    subplot(3,3,n)
    MakeSpreadAndBoxPlot3_SB(ShockEntriesZone.(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0); 
    if sess==1; ylabel('entries/min'); end
    title(Session_type{sess})
    if n==1; u=text(-1,2,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
%     ylim([0 5.1])
    
    subplot(3,3,n+3)
    MakeSpreadAndBoxPlot3_SB(SafeEntriesZone.(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0); 
    if sess==1; ylabel('entries/min'); end
%     ylim([0 4])
    if n==1; u=text(-1,1.5,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    
    subplot(3,3,n+6)
    MakeSpreadAndBoxPlot3_SB(Ratio_ZoneEntries.(Session_type{sess})([ind]),Cols,X,Legends,'showpoints',1,'paired',0);
    if sess==1; ylabel('entries/min'); end
    ylim([0 1.5])
    hline(1,'--r')
    if n==1; u=text(-1,.5,'Ratio Shock/Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    
    n=n+1;
end
a=suptitle('Zone entries'); a.FontSize=20;


figure; n=1;
for sess=[1:3]
    subplot(3,3,n)
    MakeSpreadAndBoxPlot3_SB({ShockEntriesZone.(Session_type{sess}){1} ShockEntriesZone.(Session_type{sess}){2} ShockEntriesZone.(Session_type{sess}){3}(ind1) ShockEntriesZone.(Session_type{sess}){4}(ind2)},Cols,X,NoLegends,'showpoints',1,'paired',0);
    if sess==1; ylabel('entries/min'); end
    title(Session_type{sess})
    if n==1; u=text(-1,2,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
%     ylim([0 5.1])
    
    subplot(3,3,n+3)
    MakeSpreadAndBoxPlot3_SB({SafeEntriesZone.(Session_type{sess}){1} SafeEntriesZone.(Session_type{sess}){2} SafeEntriesZone.(Session_type{sess}){3}(ind1) SafeEntriesZone.(Session_type{sess}){4}(ind2)},Cols,X,NoLegends,'showpoints',1,'paired',0);
    if sess==1; ylabel('entries/min'); end
%     ylim([0 4])
    if n==1; u=text(-1,1.5,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    
    subplot(3,3,n+6)
    MakeSpreadAndBoxPlot3_SB({Ratio_ZoneEntries.(Session_type{sess}){1} Ratio_ZoneEntries.(Session_type{sess}){2} Ratio_ZoneEntries.(Session_type{sess}){3}(ind1) Ratio_ZoneEntries.(Session_type{sess}){4}(ind2)},Cols,X,Legends,'showpoints',1,'paired',0);
    if sess==1; ylabel('entries/min'); end
    ylim([0 1.5])
    hline(1,'--r')
    if n==1; u=text(-1,.5,'Ratio Shock/Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    
    n=n+1;
end
a=suptitle('Zone entries'); a.FontSize=20;


% fz ep mean dur
figure; n=1;
for sess=[1 2 4]
    subplot(3,3,n)
    MakeSpreadAndBoxPlot3_SB(FzEMeanDuration.All.(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0); 
    if sess==1; ylabel('time (s)'); end
    title(Session_type{sess})
    if n==1; u=text(-1,2,'All'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    ylim([0 17])
    
    subplot(3,3,n+3)
    MakeSpreadAndBoxPlot3_SB(FzEMeanDuration.Shock.(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0); 
    if sess==1; ylabel('time (s)'); end
    ylim([0 20])
    if n==1; u=text(-1,1.5,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    
    subplot(3,3,n+6)
    MakeSpreadAndBoxPlot3_SB(FzEMeanDuration.Safe.(Session_type{sess})([ind]),Cols,X,Legends,'showpoints',1,'paired',0);
    if sess==1; ylabel('time (s)'); end
    ylim([0 20])
    if n==1; u=text(-1,1.5,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    
    n=n+1;
end
a=suptitle('Freezing episodes mean duration'); a.FontSize=20;

figure; n=1;
for sess=[1 2 4]
    subplot(3,3,n)
    MakeSpreadAndBoxPlot3_SB({FzEMeanDuration.(Side{1}).(Session_type{sess}){1} FzEMeanDuration.(Side{1}).(Session_type{sess}){2} FzEMeanDuration.(Side{1}).(Session_type{sess}){3}(ind1) FzEMeanDuration.(Side{1}).(Session_type{sess}){4}(ind2)},Cols,X,NoLegends,'showpoints',1,'paired',0);
    if sess==1; ylabel('time (s)'); end
    title(Session_type{sess})
    if n==1; u=text(-1,2,'All'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    ylim([0 17])
    
    subplot(3,3,n+3)
    MakeSpreadAndBoxPlot3_SB({FzEMeanDuration.(Side{2}).(Session_type{sess}){1} FzEMeanDuration.(Side{2}).(Session_type{sess}){2} FzEMeanDuration.(Side{2}).(Session_type{sess}){3}(ind1) FzEMeanDuration.(Side{2}).(Session_type{sess}){4}(ind2)},Cols,X,NoLegends,'showpoints',1,'paired',0);
    if sess==1; ylabel('time (s)'); end
    ylim([0 20])
    if n==1; u=text(-1,1.5,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    
    subplot(3,3,n+6)
    MakeSpreadAndBoxPlot3_SB({FzEMeanDuration.(Side{3}).(Session_type{sess}){1} FzEMeanDuration.(Side{3}).(Session_type{sess}){2} FzEMeanDuration.(Side{3}).(Session_type{sess}){3}(ind1) FzEMeanDuration.(Side{3}).(Session_type{sess}){4}(ind2)},Cols,X,Legends,'showpoints',1,'paired',0);
    if sess==1; ylabel('time (s)'); end
    ylim([0 20])
    if n==1; u=text(-1,1.5,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    
    n=n+1;
end
a=suptitle('Freezing episodes mean duration'); a.FontSize=20;



% Freezing episodes number
figure; n=1;
for sess=[1 2 4]
    subplot(3,3,n)
    MakeSpreadAndBoxPlot3_SB(FzEpNumber.All.(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0); 
    if sess==1; ylabel('#'); end
    title(Session_type{sess})
    if n==1; u=text(-1,2,'All'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
%     ylim([0 5.1])
    
    subplot(3,3,n+3)
    MakeSpreadAndBoxPlot3_SB(FzEpNumber.Shock.(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0); 
    if sess==1; ylabel('#'); end
%     ylim([0 4])
    if n==1; u=text(-1,1.5,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    
    subplot(3,3,n+6)
    MakeSpreadAndBoxPlot3_SB(FzEpNumber.Safe.(Session_type{sess})([ind]),Cols,X,Legends,'showpoints',1,'paired',0);
    if sess==1; ylabel('#'); end
    %     ylim([0 4])
    if n==1; u=text(-1,1.5,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    
    n=n+1;
end
a=suptitle('Freezing episodes number'); a.FontSize=20;


figure; n=1;
for sess=[1 2 4]
    subplot(3,3,n)
    MakeSpreadAndBoxPlot3_SB({FzEpNumber.(Side{1}).(Session_type{sess}){1} FzEpNumber.(Side{1}).(Session_type{sess}){2} FzEpNumber.(Side{1}).(Session_type{sess}){3}(ind1) FzEpNumber.(Side{1}).(Session_type{sess}){4}(ind2)},Cols,X,NoLegends,'showpoints',1,'paired',0);
    if sess==1; ylabel('#'); end
    title(Session_type{sess})
    if n==1; u=text(-1,2,'All'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
%     ylim([0 17])
    
    subplot(3,3,n+3)
    MakeSpreadAndBoxPlot3_SB({FzEpNumber.(Side{2}).(Session_type{sess}){1} FzEpNumber.(Side{2}).(Session_type{sess}){2} FzEpNumber.(Side{2}).(Session_type{sess}){3}(ind1) FzEpNumber.(Side{2}).(Session_type{sess}){4}(ind2)},Cols,X,NoLegends,'showpoints',1,'paired',0);
    if sess==1; ylabel('#'); end
%     ylim([0 20])
    if n==1; u=text(-1,1.5,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    
    subplot(3,3,n+6)
    MakeSpreadAndBoxPlot3_SB({FzEpNumber.(Side{3}).(Session_type{sess}){1} FzEpNumber.(Side{3}).(Session_type{sess}){2} FzEpNumber.(Side{3}).(Session_type{sess}){3}(ind1) FzEpNumber.(Side{3}).(Session_type{sess}){4}(ind2)},Cols,X,Legends,'showpoints',1,'paired',0);
    if sess==1; ylabel('#'); end
%     ylim([0 20])
    if n==1; u=text(-1,1.5,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    
    n=n+1;
end
a=suptitle('Freezing episodes number'); a.FontSize=20;


% thigmotaxism
figure
subplot(131)
MakeSpreadAndBoxPlot3_SB({Tigmo_score_all.Active_Unblocked.TestPre{1} Tigmo_score_all.Active_Unblocked.CondPre{1} Tigmo_score_all.Active_Unblocked.CondPost{1} Tigmo_score_all.Active_Unblocked.TestPost{1}},{[1 .8 1],[1 .6 1],[1 .4 1],[1 .2 1]},[1:4],{'TestPre','CondPre','CondPost','TestPost'},'showpoints',0,'paired',1);
title('All')
ylim([.3 1]), ylabel('tigmo score (a.u.)')

subplot(132)
MakeSpreadAndBoxPlot3_SB({Tigmo_score_all_shock.Active_Unblocked.TestPre{1} Tigmo_score_all_shock.Active_Unblocked.CondPre{1} Tigmo_score_all_shock.Active_Unblocked.CondPost{1} Tigmo_score_all_shock.Active_Unblocked.TestPost{1}},{[1 .8 .8],[1 .6 .6],[1 .4 .4],[1 .2 .2]},[1:4],{'TestPre','CondPre','CondPost','TestPost'},'showpoints',0,'paired',1);
title('Shock')
ylim([.3 1]), ylabel('tigmo score (a.u.)')

subplot(133)
MakeSpreadAndBoxPlot3_SB({Tigmo_score_all_safe.Active_Unblocked.TestPre{1} Tigmo_score_all_safe.Active_Unblocked.CondPre{1} Tigmo_score_all_safe.Active_Unblocked.CondPost{1} Tigmo_score_all_safe.Active_Unblocked.TestPost{1}},{[.8 .8 1],[.6 .6 1],[.4 .4 1],[.2 .2 1]},[1:4],{'TestPre','CondPre','CondPost','TestPost'},'showpoints',0,'paired',1);
title('Safe')
ylim([.3 1]), ylabel('tigmo score (a.u.)')

a=suptitle('Thigmotaxis, Saline n=9'); a.FontSize=20;



figure; n=1;
for sess=1:3
    subplot(3,3,n)
    MakeSpreadAndBoxPlot3_SB(Tigmo_score_all.Active_Unblocked.(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0); 
    if sess==1; ylabel('thigmo score (a.u.'); end
    title(Session_type{sess})
    if n==1; u=text(-1,.5,'All'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    ylim([0.3 1.1])
    
    subplot(3,3,n+3)
    MakeSpreadAndBoxPlot3_SB(Tigmo_score_all_shock.Active_Unblocked.(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0); 
    if sess==1; ylabel('thigmo score (a.u.'); end
    ylim([0.3 1.1])
    if n==1; u=text(-1,.5,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    
    subplot(3,3,n+6)
    MakeSpreadAndBoxPlot3_SB(Tigmo_score_all_safe.Active_Unblocked.(Session_type{sess})([ind]),Cols,X,Legends,'showpoints',1,'paired',0);
    if sess==1; ylabel('thigmo score (a.u.'); end
    ylim([0.3 1.1])
    if n==1; u=text(-1,.5,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    
    n=n+1;
end
a=suptitle('Thigmotaxism'); a.FontSize=20;


figure; n=1;
for sess=1:3
    subplot(3,3,n)
    MakeSpreadAndBoxPlot3_SB({Tigmo_score_all.Active_Unblocked.(Session_type{sess}){1} Tigmo_score_all.Active_Unblocked.(Session_type{sess}){2} Tigmo_score_all.Active_Unblocked.(Session_type{sess}){3}(ind1) Tigmo_score_all.Active_Unblocked.(Session_type{sess}){4}(ind2)},Cols,X,NoLegends,'showpoints',1,'paired',0);
    if sess==1; ylabel('thigmo score (a.u.'); end
    title(Session_type{sess})
    if n==1; u=text(-1,.5,'All'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    ylim([0.3 1.1])
    
    subplot(3,3,n+3)
    MakeSpreadAndBoxPlot3_SB({Tigmo_score_all_shock.Active_Unblocked.(Session_type{sess}){1} Tigmo_score_all_shock.Active_Unblocked.(Session_type{sess}){2} Tigmo_score_all_shock.Active_Unblocked.(Session_type{sess}){3}(ind1) Tigmo_score_all_shock.Active_Unblocked.(Session_type{sess}){4}(ind2)},Cols,X,NoLegends,'showpoints',1,'paired',0);
    if sess==1; ylabel('thigmo score (a.u.'); end
    ylim([0.3 1.1])
    if n==1; u=text(-1,.5,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    
    subplot(3,3,n+6)
    MakeSpreadAndBoxPlot3_SB({Tigmo_score_all_safe.Active_Unblocked.(Session_type{sess}){1} Tigmo_score_all_safe.Active_Unblocked.(Session_type{sess}){2} Tigmo_score_all_safe.Active_Unblocked.(Session_type{sess}){3}(ind1) Tigmo_score_all_safe.Active_Unblocked.(Session_type{sess}){4}(ind2)},Cols,X,Legends,'showpoints',1,'paired',0);
    if sess==1; ylabel('thigmo score (a.u.'); end
    ylim([0.3 1.1])
    if n==1; u=text(-1,.5,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    
    n=n+1;
end
a=suptitle('Thigmotaxism'); a.FontSize=20;



%% correlations thigmo and 
figure
subplot(121)
[r1,p1] = PlotCorrelations_BM(Tigmo_score_all.Active_Unblocked.Cond{1} , Proportional_TimeFz.(Side{1}).Cond{1} ,'Color', [.3, .745, .93]);
[r2,p2] = PlotCorrelations_BM(Tigmo_score_all.Active_Unblocked.Cond{2} , Proportional_TimeFz.(Side{1}).Cond{2} ,'Color', [.85, .325, .098]);
[r3,p3] = PlotCorrelations_BM(Tigmo_score_all.Active_Unblocked.Cond{3} , Proportional_TimeFz.(Side{1}).Cond{3} ,'Color', [.65, .75, 0]);
[r4,p4] = PlotCorrelations_BM(Tigmo_score_all.Active_Unblocked.Cond{4} , Proportional_TimeFz.(Side{1}).Cond{4} ,'Color', [.63, .08, .18]);
axis square
ylabel('Freezing proportion, cond'), xlabel('thigmo score (a.u.)')
legend(['R = ' num2str(r1) ', p = ' num2str(p1)],['R = ' num2str(r2) ', p = ' num2str(p2)],['R = ' num2str(r3) ', p = ' num2str(p3)],['R = ' num2str(r4) ', p = ' num2str(p4)])

subplot(122)
[r1,p1] = PlotCorrelations_BM(Tigmo_score_all.Active_Unblocked.Cond{1} , ShockEntriesZone.Cond{1} ,'Color', [.3, .745, .93]);
[r2,p2] = PlotCorrelations_BM(Tigmo_score_all.Active_Unblocked.Cond{2} , ShockEntriesZone.Cond{2} ,'Color', [.85, .325, .098]);
[r3,p3] = PlotCorrelations_BM(Tigmo_score_all.Active_Unblocked.Cond{3} , ShockEntriesZone.Cond{3} ,'Color', [.65, .75, 0]);
[r4,p4] = PlotCorrelations_BM(Tigmo_score_all.Active_Unblocked.Cond{4} , ShockEntriesZone.Cond{4} ,'Color', [.63, .08, .18]);
axis square
ylabel('shock zone entries, cond'), xlabel('thigmo score (a.u.)')
legend(['R = ' num2str(r1) ', p = ' num2str(p1)],['R = ' num2str(r2) ', p = ' num2str(p2)],['R = ' num2str(r3) ', p = ' num2str(p3)],['R = ' num2str(r4) ', p = ' num2str(p4)])


figure
subplot(121)
[r1,p1] = PlotCorrelations_BM(Tigmo_score_all.Active_Unblocked.Cond{1} , Proportional_TimeFz.(Side{1}).Cond{1} ,'Color', [.3, .745, .93]);
[r2,p2] = PlotCorrelations_BM(Tigmo_score_all.Active_Unblocked.Cond{2} , Proportional_TimeFz.(Side{1}).Cond{2} ,'Color', [.85, .325, .098]);
[r3,p3] = PlotCorrelations_BM(Tigmo_score_all.Active_Unblocked.Cond{3}(ind1) , Proportional_TimeFz.(Side{1}).Cond{3}(ind1) ,'Color', [.65, .75, 0]);
[r4,p4] = PlotCorrelations_BM(Tigmo_score_all.Active_Unblocked.Cond{4}(ind2) , Proportional_TimeFz.(Side{1}).Cond{4}(ind2) ,'Color', [.63, .08, .18]);
axis square
xlim([.4 1]), ylim([0 .45])
ylabel('Freezing proportion, cond'), xlabel('thigmo score (a.u.)')
legend(['R = ' num2str(r1) ', p = ' num2str(p1)],['R = ' num2str(r2) ', p = ' num2str(p2)],['R = ' num2str(r3) ', p = ' num2str(p3)],['R = ' num2str(r4) ', p = ' num2str(p4)])

subplot(122)
[r1,p1] = PlotCorrelations_BM(Tigmo_score_all.Active_Unblocked.Cond{1} , ShockEntriesZone.Cond{1} ,'Color', [.3, .745, .93]);
[r2,p2] = PlotCorrelations_BM(Tigmo_score_all.Active_Unblocked.Cond{2} , ShockEntriesZone.Cond{2} ,'Color', [.85, .325, .098]);
[r3,p3] = PlotCorrelations_BM(Tigmo_score_all.Active_Unblocked.Cond{3}(ind1) , ShockEntriesZone.Cond{3}(ind1) ,'Color', [.65, .75, 0]);
[r4,p4] = PlotCorrelations_BM(Tigmo_score_all.Active_Unblocked.Cond{4}(ind2) , ShockEntriesZone.Cond{4}(ind2) ,'Color', [.63, .08, .18]);
xlim([.4 1]), ylim([0 90])
axis square
ylabel('shock zone entries, cond'), xlabel('thigmo score (a.u.)')
legend(['R = ' num2str(r1) ', p = ' num2str(p1)],['R = ' num2str(r2) ', p = ' num2str(p2)],['R = ' num2str(r3) ', p = ' num2str(p3)],['R = ' num2str(r4) ', p = ' num2str(p4)])


figure
subplot(121)
[r1,p1] = PlotCorrelations_BM([Tigmo_score_all.Active_Unblocked.Cond{1} Tigmo_score_all.Active_Unblocked.Cond{3}] , [Proportional_TimeFz.(Side{1}).Cond{1} Proportional_TimeFz.(Side{1}).Cond{3}] ,'Color', [.3, .745, .93]);
[r2,p2] = PlotCorrelations_BM([Tigmo_score_all.Active_Unblocked.Cond{2} Tigmo_score_all.Active_Unblocked.Cond{4}] , [Proportional_TimeFz.(Side{1}).Cond{2} Proportional_TimeFz.(Side{1}).Cond{4}] ,'Color', [.85, .325, .098]);
axis square
ylabel('Freezing proportion, cond'), xlabel('thigmo score (a.u.)')
legend(['R = ' num2str(r1) ', p = ' num2str(p1)],['R = ' num2str(r2) ', p = ' num2str(p2)])
title('Freezing = f(thigmotaxism)')

subplot(122)
[r1,p1] = PlotCorrelations_BM([Tigmo_score_all.Active_Unblocked.Cond{1} Tigmo_score_all.Active_Unblocked.Cond{3}] , [ShockEntriesZone.Cond{1} ShockEntriesZone.Cond{3}] ,'Color', [.3, .745, .93]);
[r2,p2] = PlotCorrelations_BM([Tigmo_score_all.Active_Unblocked.Cond{2} Tigmo_score_all.Active_Unblocked.Cond{4}] , [ShockEntriesZone.Cond{2} ShockEntriesZone.Cond{4}] ,'Color', [.85, .325, .098]);
axis square
ylabel('Freezing proportion, cond'), xlabel('thigmo score (a.u.)')
legend(['R = ' num2str(r1) ', p = ' num2str(p1)],['R = ' num2str(r2) ', p = ' num2str(p2)])
title('Zone entries = f(thigmotaxism)')


%% occup maps
for type=[2 4 6]
    figure; m=1;
    for group=Group
        
        subplot(4,4,1+(m-1)*4);
        imagesc(OccupMap_squeeze.(Type{type}).TestPre{m})
        axis xy;caxis([0 8e-4]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
        ylabel(Drug_Group{group});
        if m==1; title('Test Pre'); end
        Maze_Frame_BM
        
        subplot(4,4,2+(m-1)*4);
        imagesc(OccupMap_squeeze.(Type{type}).CondPre{m})
        axis xy;caxis([0 8e-4]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
        if m==1; title('Cond Pre'); end
        Maze_Frame_BM
        
        subplot(4,4,3+(m-1)*4);
        imagesc(OccupMap_squeeze.(Type{type}).CondPost{m})
        axis xy;caxis([0 8e-4]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
        if m==1; title('Cond Post'); end
        Maze_Frame_BM
        
        subplot(4,4,4+(m-1)*4);
        imagesc(OccupMap_squeeze.(Type{type}).TestPost{m})
        axis xy; caxis([0 8e-4]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
        if m==1; title('Test Post'); end
        Maze_Frame_BM
        
        colormap jet
        m=m+1;
    end
    a=suptitle(['Occupancy maps ' Type{type}]); a.FontSize=20;
end

for type=1:6
    for sess=1:length(Session_type)
        for i=1:4
            if i==1
                ind=1:9;
            elseif i==2
                ind=1:7;
            elseif i==3
                ind=ind1;
            else
                ind=ind2;
            end
            
            OccupMap_squeeze_corr.(Type{type}).(Session_type{sess}){i} = squeeze(nanmean(OccupMap.(Type{type}).(Session_type{sess}){i}(ind,:,:)));
            
        end
    end
end

for type=[2 4 6]
    figure; m=1;
    for group=Group
        
        subplot(4,4,1+(m-1)*4);
        imagesc(OccupMap_squeeze_corr.(Type{type}).TestPre{m})
        axis xy;caxis([0 8e-4]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
        ylabel(Drug_Group{group});
        if m==1; title('Test Pre'); end
        Maze_Frame_BM
        
        subplot(4,4,2+(m-1)*4);
        imagesc(OccupMap_squeeze_corr.(Type{type}).CondPre{m})
        axis xy;caxis([0 8e-4]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
        if m==1; title('Cond Pre'); end
        Maze_Frame_BM
        
        subplot(4,4,3+(m-1)*4);
        imagesc(OccupMap_squeeze_corr.(Type{type}).CondPost{m})
        axis xy;caxis([0 8e-4]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
        if m==1; title('Cond Post'); end
        Maze_Frame_BM
        
        subplot(4,4,4+(m-1)*4);
        imagesc(OccupMap_squeeze_corr.(Type{type}).TestPost{m})
        axis xy; caxis([0 8e-4]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
        if m==1; title('Test Post'); end
        Maze_Frame_BM
        
        colormap jet
        m=m+1;
    end
    a=suptitle(['Occupancy maps ' Type{type}]); a.FontSize=20;
end


%% physio
figure; n=1;
for sess=[1 2 4]
    subplot(2,3,n)
    MakeSpreadAndBoxPlot3_SB(Ripples_Shock.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0); 
    if sess==1; ylabel('Frequency (Hz)'); u=text(-1,.7,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    title(Session_type{sess})
    ylim([0 2])
    
    subplot(2,3,n+3)
    MakeSpreadAndBoxPlot3_SB(Ripples_Safe.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0); 
    if sess==1; ylabel('Frequency (Hz)'); u=text(-1,.7,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    ylim([0 2])
    
    n=n+1;
end
a=suptitle('Ripples analysis'); a.FontSize=20;


figure; n=1;
for sess=[1 2 4]
    subplot(2,3,n)
    MakeSpreadAndBoxPlot3_SB({Ripples_Shock.(Session_type{sess}){1} Ripples_Shock.(Session_type{sess}){2} Ripples_Shock.(Session_type{sess}){3}(ind1) Ripples_Shock.(Session_type{sess}){4}(ind2)},Cols,X,NoLegends,'showpoints',1,'paired',0);
    if sess==1; ylabel('Frequency (Hz)'); u=text(-1,.7,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    title(Session_type{sess})
    ylim([0 2])
    
    subplot(2,3,n+3)
    MakeSpreadAndBoxPlot3_SB({Ripples_Safe.(Session_type{sess}){1} Ripples_Safe.(Session_type{sess}){2} Ripples_Safe.(Session_type{sess}){3}(ind1) Ripples_Safe.(Session_type{sess}){4}(ind2)},Cols,X,NoLegends,'showpoints',1,'paired',0);
    if sess==1; ylabel('Frequency (Hz)'); u=text(-1,.7,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    ylim([0 2])
    
    n=n+1;
end
a=suptitle('Ripples analysis'); a.FontSize=20;



figure; n=1;
for sess=[1 2 4]
    subplot(3,3,n)
    MakeSpreadAndBoxPlot3_SB(HR_Shock.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0); 
    if sess==1; ylabel('Frequency (Hz)'); u=text(-1,9.5,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    title(Session_type{sess})
    ylim([7 14])
    
    subplot(3,3,n+3)
    MakeSpreadAndBoxPlot3_SB(HR_Safe.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0); 
    if sess==1; ylabel('Frequency (Hz)'); u=text(-1,9.5,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    ylim([7 14])
    
    subplot(3,3,n+6)
    MakeSpreadAndBoxPlot3_SB(HR_Diff.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0); 
    if sess==1; ylabel('Frequency (Hz)'); u=text(-1,-1,'Diff Shock-Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    ylim([-2 4]); hline(0,'--r')
    
    n=n+1;
end
a=suptitle('Heart rate analysis'); a.FontSize=20;


figure; n=1;
for sess=[1 2 4]
    subplot(3,3,n)
    MakeSpreadAndBoxPlot3_SB(HRVar_Shock.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if sess==1; ylabel('Frequency (Hz)'); u=text(-1,.1,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    title(Session_type{sess})
    ylim([0 .25])
    
    subplot(3,3,n+3)
    MakeSpreadAndBoxPlot3_SB(HRVar_Safe.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if sess==1; ylabel('Frequency (Hz)'); u=text(-1,.15,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    ylim([0 .35])
    
    subplot(3,3,n+6)
    MakeSpreadAndBoxPlot3_SB(HRVar_Diff.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0);
    if sess==1; ylabel('Frequency (Hz)'); u=text(-1,-.1,'Diff Shock-Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    ylim([-.2 .1]);
    hline(0,'--r')
    
    n=n+1;
end
a=suptitle('Heart rate variability analysis'); a.FontSize=20;


figure; n=1;
for sess=[1 2 4]
    subplot(3,3,n)
    MakeSpreadAndBoxPlot3_SB({HRVar_Shock.(Session_type{sess}){1} HRVar_Shock.(Session_type{sess}){2} HRVar_Shock.(Session_type{sess}){3}(ind1) HRVar_Shock.(Session_type{sess}){4}(ind2)},Cols,X,NoLegends,'showpoints',1,'paired',0);
    if sess==1; ylabel('Frequency (Hz)'); u=text(-1,.1,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    title(Session_type{sess})
    ylim([0 .25])
    
    subplot(3,3,n+3)
     MakeSpreadAndBoxPlot3_SB({HRVar_Safe.(Session_type{sess}){1} HRVar_Safe.(Session_type{sess}){2} HRVar_Safe.(Session_type{sess}){3}(ind1) HRVar_Safe.(Session_type{sess}){4}(ind2)},Cols,X,NoLegends,'showpoints',1,'paired',0);
    if sess==1; ylabel('Frequency (Hz)'); u=text(-1,.15,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    ylim([0 .35])
    
    subplot(3,3,n+6)
     MakeSpreadAndBoxPlot3_SB({HRVar_Diff.(Session_type{sess}){1} HRVar_Diff.(Session_type{sess}){2} HRVar_Diff.(Session_type{sess}){3}(ind1) HRVar_Diff.(Session_type{sess}){4}(ind2)},Cols,X,NoLegends,'showpoints',1,'paired',0);
    if sess==1; ylabel('Frequency (Hz)'); u=text(-1,-.1,'Diff Shock-Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    ylim([-.2 .1]); 
hline(0,'--r')
    
    n=n+1;
end
a=suptitle('Heart rate variability analysis'); a.FontSize=20;




figure; n=1;
for sess=[1 2 4]
    subplot(3,3,n)
    MakeSpreadAndBoxPlot3_SB(Respi_Shock.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0); 
    if sess==1; ylabel('Frequency (Hz)'); u=text(-1,9.5,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    title(Session_type{sess})
%     ylim([7 14])
    
    subplot(3,3,n+3)
    MakeSpreadAndBoxPlot3_SB(Respi_Safe.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if sess==1; ylabel('Frequency (Hz)'); u=text(-1,9.5,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    %     ylim([7 14])
    
    subplot(3,3,n+6)
    MakeSpreadAndBoxPlot3_SB(Respi_Diff.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0);
    if sess==1; ylabel('Frequency (Hz)'); u=text(-1,-1,'Diff Shock-Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    %     ylim([-2 4]);
    hline(0,'--r')
    
    n=n+1;
end


%% Sleep & inhib
figure
for sess=1:2
    subplot(2,3,1+(sess-1)*3)
    MakeSpreadAndBoxPlot3_SB(Sleep_prop_all.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0);
    if sess==1; title('Sleep proportion'); u=text(-1,.3,'Sleep Pre'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90); end
    if sess==2; u=text(-1,.3,'Sleep Post'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90); end
    ylim([0 .9])
    ylabel('proportion')
    
    subplot(2,3,2+(sess-1)*3)
    MakeSpreadAndBoxPlot3_SB(REM_prop_all.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0);
    ylim([0 .17])
    if sess==1; title('REM proportion'); end
    ylabel('proportion')
    
    subplot(2,3,3+(sess-1)*3)
    MakeSpreadAndBoxPlot3_SB(Ripples_density_all.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0);
    ylim([0 1.5])
    if sess==1; title('Ripples density'); end
    ylabel('Frequency (Hz)')
end


figure
for sess=1:2
    subplot(2,3,1+(sess-1)*3)
    MakeSpreadAndBoxPlot3_SB({Sleep_prop_all.(Session_type{sess}){1} Sleep_prop_all.(Session_type{sess}){2} Sleep_prop_all.(Session_type{sess}){3}(ind1) Sleep_prop_all.(Session_type{sess}){4}(ind2)},Cols,X,NoLegends,'showpoints',1,'paired',0);
    if sess==1; title('Sleep proportion'); u=text(-1,.3,'Sleep Pre'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90); end
    if sess==2; u=text(-1,.3,'Sleep Post'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90); end
    ylim([0 .9])
    ylabel('proportion')
    
    subplot(2,3,2+(sess-1)*3)
    MakeSpreadAndBoxPlot3_SB({REM_prop_all.(Session_type{sess}){1} REM_prop_all.(Session_type{sess}){2} REM_prop_all.(Session_type{sess}){3}(ind1) REM_prop_all.(Session_type{sess}){4}(ind2)},Cols,X,NoLegends,'showpoints',1,'paired',0);
    ylim([0 .17])
    if sess==1; title('REM proportion'); end
    ylabel('proportion')
    
    subplot(2,3,3+(sess-1)*3)
    MakeSpreadAndBoxPlot3_SB({Ripples_density_all.(Session_type{sess}){1} Ripples_density_all.(Session_type{sess}){2} Ripples_density_all.(Session_type{sess}){3}(ind1) Ripples_density_all.(Session_type{sess}){4}(ind2)},Cols,X,NoLegends,'showpoints',1,'paired',0);
    ylim([0 1.5])
    if sess==1; title('Ripples density'); end
    ylabel('Frequency (Hz)')
end


Cols = {[.65, .75, 0],[.63, .08, .18]};
X = [1:2];
Legends = {'Rip sham','Rip inhib'};
NoLegends = {'',''};

figure
subplot(121), sess=1;
MakeSpreadAndBoxPlot3_SB({Ripples_density_all.(Session_type{sess}){3}(ind1) Ripples_density_all.(Session_type{sess}){4}(ind2)},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([.4 1]), ylabel('#/s'); title('Sleep Pre')
subplot(122), sess=2;
MakeSpreadAndBoxPlot3_SB({Ripples_density_all.(Session_type{sess}){3}(ind1) Ripples_density_all.(Session_type{sess}){4}(ind2)},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([.4 1]), title('Sleep Post')

a=suptitle('Ripples density, sleep sessions'); a.FontSize=20;



figure
for sess=2%1:4
%     subplot(2,2,sess)
    MakeSpreadAndBoxPlot3_SB({Stim_Dens_All{sess}{1}(ind1) Stim_Dens_All{sess}{2}(ind2)} ,Cols,X,Legends , 'showpoints',1,'paired',0);
    title('VHC stims dnesity, calibration'); ylabel('#/s');
end

     
A{1}=[Stim_Dens_All2{1}(1,2) Stim_Dens_All2{1}(2,2) Stim_Dens_All2{1}(3,1)*2 Stim_Dens_All2{1}(4,2) Stim_Dens_All2{1}(5,2) Stim_Dens_All2{1}(6,2)];
A{2}=[Stim_Dens_All2{2}(1,7) .7 Stim_Dens_All2{2}(6,5) Stim_Dens_All2{2}(7,8)];
     
figure
MakeSpreadAndBoxPlot3_SB(A ,Cols,X,Legends , 'showpoints',1,'paired',0);
title('VHC stims density, calibration'); ylabel('#/s'); ylim([.4 1])





     