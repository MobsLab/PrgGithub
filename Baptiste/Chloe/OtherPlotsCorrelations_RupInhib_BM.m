

%%
ind2=[1 5 6 7];
ind3=[2 3 4 8];
Cols2 = {[.6350, .0780, .1840],[.85, .85, 0],[.65, .65, 0]};
X2 = [1:3];
Legends2 = {'RipControl','RipInhib good','RipInhib weird'};
NoLegends2 = {'','',''};


figure; sess=5;
subplot(231)
MakeSpreadAndBoxPlot2_SB(Tigmo_score_all.Unblocked.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0);
title('Thigmo score')

subplot(232)
MakeSpreadAndBoxPlot2_SB(ShockEntriesZone.(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0); 
title('Shock zone entries')

subplot(233)
try; MakeSpreadAndBoxPlot2_SB(ExtraStimNumber.(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0); end
title('Eyelid stimulation')

subplot(234)
MakeSpreadAndBoxPlot2_SB(Proportional_TimeFz.(Side{1}).(Session_type{sess})([ind]),Cols,X,Legends,'showpoints',1,'paired',0);
title('Freezing prop')

subplot(235)
MakeSpreadAndBoxPlot2_SB(Proportional_TimeFz.(Side{2}).(Session_type{sess})([ind]),Cols,X,Legends,'showpoints',1,'paired',0);
title('Freezing shock prop')

subplot(236)
MakeSpreadAndBoxPlot2_SB(Proportional_TimeFz.(Side{3}).(Session_type{sess})([ind]),Cols,X,Legends,'showpoints',1,'paired',0);
title('Freezing safe prop')

a=suptitle([Session_type{sess} ' sessions']); a.FontSize=20;


figure; sess=4;
subplot(231), clear data; data=Tigmo_score_all.Unblocked.(Session_type{sess});
MakeSpreadAndBoxPlot2_SB({data{3} data{4}([ind2]) data{4}([ind3])},Cols2,X2,NoLegends2,'showpoints',1,'paired',0);
title('Thigmo score')

subplot(232), clear data; data=ShockEntriesZone.(Session_type{sess});
MakeSpreadAndBoxPlot2_SB({data{3} data{4}([ind2]) data{4}([ind3])},Cols2,X2,NoLegends2,'showpoints',1,'paired',0);
title('Shock zone entries')

subplot(233), try;  clear data; data=ExtraStimNumber.(Session_type{sess});
MakeSpreadAndBoxPlot2_SB({data{3} data{4}([ind2]) data{4}([ind3])},Cols2,X2,NoLegends2,'showpoints',1,'paired',0); end
title('Eyelid stimulation')

subplot(234), clear data; data=Proportional_TimeFz.(Side{1}).(Session_type{sess});
MakeSpreadAndBoxPlot2_SB({data{3} data{4}([ind2]) data{4}([ind3])},Cols2,X2,Legends2,'showpoints',1,'paired',0);
title('Freezing prop')

subplot(235), clear data; data=Proportional_TimeFz.(Side{2}).(Session_type{sess});
MakeSpreadAndBoxPlot2_SB({data{3} data{4}([ind2]) data{4}([ind3])},Cols2,X2,Legends2,'showpoints',1,'paired',0);
title('Freezing shock prop')

subplot(236), clear data; data=Proportional_TimeFz.(Side{3}).(Session_type{sess});
MakeSpreadAndBoxPlot2_SB({data{3} data{4}([ind2]) data{4}([ind3])},Cols2,X2,Legends2,'showpoints',1,'paired',0);
title('Freezing safe prop')

a=suptitle([Session_type{sess} ' sessions']); a.FontSize=20;



figure, sess=5;
subplot(131)
MakeSpreadAndBoxPlot3_SB(Ripples_All.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0); 
ylim([0 1]), ylabel('#/s')
title('All freezing')
subplot(132)
MakeSpreadAndBoxPlot3_SB(Ripples_Shock.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0); 
ylim([0 1]), ylabel('#/s')
title('Shock freezing')
subplot(133)
MakeSpreadAndBoxPlot3_SB(Ripples_Safe.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0); 
ylim([0 1])
title('Safe freezing')

a=suptitle('Ripples density during freezing'); a.FontSize=20;



%% Correlations with VHC stims

figure, sess=5;
subplot(321)
PlotCorrelations_BM(VHC_Stim_Numb_All{2} , Proportional_Time_Unblocked.(Side{2}).(Session_type{sess}){4})
PlotCorrelations_BM(VHC_Stim_Numb_All{2}([ind2]) , Proportional_Time_Unblocked.(Side{2}).(Session_type{sess}){4}([ind2]),'color','r')
axis square, xlabel('VHC stims numb'), ylabel('shock zone prop')

subplot(322)
PlotCorrelations_BM(VHC_Stim_Numb_All{2} , ShockEntriesZone.(Session_type{sess}){4})
PlotCorrelations_BM(VHC_Stim_Numb_All{2}([ind2]) , ShockEntriesZone.(Session_type{sess}){4}([ind2]),'color','r')
axis square, xlabel('VHC stims numb'), ylabel('shock zone entries')

subplot(323)
PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_All{2} , Proportional_Time_Unblocked.(Side{2}).(Session_type{sess}){4})
PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_All{2}([ind2]) , Proportional_Time_Unblocked.(Side{2}).(Session_type{sess}){4}([ind2]),'color','r')
axis square, xlabel('VHC stims numb fz'), ylabel('shock zone prop')

subplot(324)
PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_All{2} , ShockEntriesZone.(Session_type{sess}){4})
PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_All{2}([ind2]) , ShockEntriesZone.(Session_type{sess}){4}([ind2]),'color','r')
axis square, xlabel('VHC stims numb fz'), ylabel('shock zone entries')

subplot(325)
PlotCorrelations_BM(VHC_Stim_FreezingDensity_All{2} , Proportional_Time_Unblocked.(Side{2}).(Session_type{sess}){4})
PlotCorrelations_BM(VHC_Stim_FreezingDensity_All{2}([ind2]) , Proportional_Time_Unblocked.(Side{2}).(Session_type{sess}){4}([ind2]),'color','r')
axis square, xlabel('VHC stims density'), ylabel('shock zone prop')

subplot(326)
PlotCorrelations_BM(VHC_Stim_FreezingDensity_All{2} , ShockEntriesZone.(Session_type{sess}){4})
PlotCorrelations_BM(VHC_Stim_FreezingDensity_All{2}([ind2]) , ShockEntriesZone.(Session_type{sess}){4}([ind2]),'color','r')
axis square, xlabel('VHC stims density'), ylabel('shock zone entries')


figure, sess=5;
subplot(321)
PlotCorrelations_BM(VHC_Stim_Numb_All{2} , Proportional_TimeFz.(Side{2}).(Session_type{sess}){4})
PlotCorrelations_BM(VHC_Stim_Numb_All{2}([ind2]) , Proportional_TimeFz.(Side{2}).(Session_type{sess}){4}([ind2]),'color','r')
axis square, xlabel('VHC stims numb'), ylabel('shock fz')

subplot(322)
PlotCorrelations_BM(VHC_Stim_Numb_All{2} , Proportional_TimeFz.(Side{3}).(Session_type{sess}){4})
PlotCorrelations_BM(VHC_Stim_Numb_All{2}([ind2]) , Proportional_TimeFz.(Side{3}).(Session_type{sess}){4}([ind2]),'color','r')
axis square, xlabel('VHC stims numb'), ylabel('safe fz')

subplot(323)
PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_All{2} , Proportional_TimeFz.(Side{2}).(Session_type{sess}){4})
PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_All{2}([ind2]) , Proportional_TimeFz.(Side{2}).(Session_type{sess}){4}([ind2]),'color','r')
axis square, xlabel('VHC stims numb fz'), ylabel('shock fz')

subplot(324)
PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_All{2} , Proportional_TimeFz.(Side{3}).(Session_type{sess}){4})
PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_All{2}([ind2]) , Proportional_TimeFz.(Side{3}).(Session_type{sess}){4}([ind2]),'color','r')
axis square, xlabel('VHC stims numb fz'), ylabel('safe fz')

subplot(325)
PlotCorrelations_BM(VHC_Stim_FreezingDensity_All{2} , Proportional_TimeFz.(Side{2}).(Session_type{sess}){4})
PlotCorrelations_BM(VHC_Stim_FreezingDensity_All{2}([ind2]) , Proportional_TimeFz.(Side{2}).(Session_type{sess}){4}([ind2]),'color','r')
axis square, xlabel('VHC stims density'), ylabel('shock fz')

subplot(326)
PlotCorrelations_BM(VHC_Stim_FreezingDensity_All{2} , Proportional_TimeFz.(Side{3}).(Session_type{sess}){4})
PlotCorrelations_BM(VHC_Stim_FreezingDensity_All{2}([ind2]) , Proportional_TimeFz.(Side{3}).(Session_type{sess}){4}([ind2]),'color','r')
axis square, xlabel('VHC stims density'), ylabel('safe fz')


figure, sess=5;
subplot(321)
PlotCorrelations_BM(VHC_Stim_Numb_All{2} , FzEMeanDuration.Shock.(Session_type{sess}){4})
PlotCorrelations_BM(VHC_Stim_Numb_All{2}([ind2]) , FzEMeanDuration.Shock.(Session_type{sess}){4}([ind2]),'color','r')
axis square, xlabel('VHC stims numb'), ylabel('shock fz')

subplot(322)
PlotCorrelations_BM(VHC_Stim_Numb_All{2} , FzEMeanDuration.Safe.(Session_type{sess}){4})
PlotCorrelations_BM(VHC_Stim_Numb_All{2}([ind2]) , FzEMeanDuration.Safe.(Session_type{sess}){4}([ind2]),'color','r')
axis square, xlabel('VHC stims numb'), ylabel('safe fz')

subplot(323)
PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_All{2} , FzEMeanDuration.Shock.(Session_type{sess}){4})
PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_All{2}([ind2]) , FzEMeanDuration.Shock.(Session_type{sess}){4}([ind2]),'color','r')
axis square, xlabel('VHC stims numb fz'), ylabel('shock fz')

subplot(324)
PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_All{2} , FzEMeanDuration.Safe.(Session_type{sess}){4})
PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_All{2}([ind2]) , FzEMeanDuration.Safe.(Session_type{sess}){4}([ind2]),'color','r')
axis square, xlabel('VHC stims numb fz'), ylabel('safe fz')

subplot(325)
PlotCorrelations_BM(VHC_Stim_FreezingDensity_All{2} , FzEMeanDuration.Shock.(Session_type{sess}){4})
PlotCorrelations_BM(VHC_Stim_FreezingDensity_All{2}([ind2]) , FzEMeanDuration.Shock.(Session_type{sess}){4}([ind2]),'color','r')
axis square, xlabel('VHC stims density'), ylabel('shock fz')

subplot(326)
PlotCorrelations_BM(VHC_Stim_FreezingDensity_All{2} , FzEMeanDuration.Safe.(Session_type{sess}){4})
PlotCorrelations_BM(VHC_Stim_FreezingDensity_All{2}([ind2]) , FzEMeanDuration.Safe.(Session_type{sess}){4}([ind2]),'color','r')
axis square, xlabel('VHC stims density'), ylabel('safe fz')




figure, sess=5;
subplot(321)
PlotCorrelations_BM(VHC_Stim_Numb_All{2} , FzEpNumber.Shock.(Session_type{sess}){4})
PlotCorrelations_BM(VHC_Stim_Numb_All{2}([ind2]) , FzEpNumber.Shock.(Session_type{sess}){4}([ind2]),'color','r')
axis square, xlabel('VHC stims numb'), ylabel('shock fz')

subplot(322)
PlotCorrelations_BM(VHC_Stim_Numb_All{2} , FzEpNumber.Safe.(Session_type{sess}){4})
PlotCorrelations_BM(VHC_Stim_Numb_All{2}([ind2]) , FzEpNumber.Safe.(Session_type{sess}){4}([ind2]),'color','r')
axis square, xlabel('VHC stims numb'), ylabel('safe fz')

subplot(323)
PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_All{2} , FzEpNumber.Shock.(Session_type{sess}){4})
PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_All{2}([ind2]) , FzEpNumber.Shock.(Session_type{sess}){4}([ind2]),'color','r')
axis square, xlabel('VHC stims numb fz'), ylabel('shock fz')

subplot(324)
PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_All{2} , FzEpNumber.Safe.(Session_type{sess}){4})
PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_All{2}([ind2]) , FzEpNumber.Safe.(Session_type{sess}){4}([ind2]),'color','r')
axis square, xlabel('VHC stims numb fz'), ylabel('safe fz')

subplot(325)
PlotCorrelations_BM(VHC_Stim_FreezingDensity_All{2} , FzEpNumber.Shock.(Session_type{sess}){4})
PlotCorrelations_BM(VHC_Stim_FreezingDensity_All{2}([ind2]) , FzEpNumber.Shock.(Session_type{sess}){4}([ind2]),'color','r')
axis square, xlabel('VHC stims density'), ylabel('shock fz')

subplot(326)
PlotCorrelations_BM(VHC_Stim_FreezingDensity_All{2} , FzEpNumber.Safe.(Session_type{sess}){4})
PlotCorrelations_BM(VHC_Stim_FreezingDensity_All{2}([ind2]) , FzEpNumber.Safe.(Session_type{sess}){4}([ind2]),'color','r')
axis square, xlabel('VHC stims density'), ylabel('safe fz')



%% other correlations
figure, sess=5; 
PlotCorrelations_BM(ShockEntriesZone.(Session_type{sess}){1} , ExtraStimNumber.(Session_type{sess}){1},'Color',[0.3, 0.745, 0.93]);
PlotCorrelations_BM(ShockEntriesZone.(Session_type{sess}){2} , ExtraStimNumber.(Session_type{sess}){2},'Color',[0.85, 0.325, 0.098]);
PlotCorrelations_BM(ShockEntriesZone.(Session_type{sess}){3} , ExtraStimNumber.(Session_type{sess}){3},'Color',[.6350, .0780, .1840]);
PlotCorrelations_BM(ShockEntriesZone.(Session_type{sess}){4} , ExtraStimNumber.(Session_type{sess}){4},'Color',[.75, .75, 0]);

figure, sess=5; 
PlotCorrelations_BM(ShockEntriesZone.(Session_type{sess}){1} , Proportional_TimeFz.(Side{1}).(Session_type{sess}){1},'Color',[0.3, 0.745, 0.93]);
PlotCorrelations_BM(ShockEntriesZone.(Session_type{sess}){2} , Proportional_TimeFz.(Side{1}).(Session_type{sess}){2},'Color',[0.85, 0.325, 0.098]);
PlotCorrelations_BM(ShockEntriesZone.(Session_type{sess}){3} , Proportional_TimeFz.(Side{1}).(Session_type{sess}){3},'Color',[.6350, .0780, .1840]);
PlotCorrelations_BM(ShockEntriesZone.(Session_type{sess}){4} , Proportional_TimeFz.(Side{1}).(Session_type{sess}){4},'Color',[.75, .75, 0]);
axis square
xlabel('shock zone entries, Cond'), ylabel('Freezing prop')

figure, sess=5; 
PlotCorrelations_BM(ShockEntriesZone.(Session_type{sess}){1} , Tigmo_score_all.Unblocked.(Session_type{sess}){1},'Color',[0.3, 0.745, 0.93]);
PlotCorrelations_BM(ShockEntriesZone.(Session_type{sess}){2} , Tigmo_score_all.Unblocked.(Session_type{sess}){2},'Color',[0.85, 0.325, 0.098]);
PlotCorrelations_BM(ShockEntriesZone.(Session_type{sess}){3} , Tigmo_score_all.Unblocked.(Session_type{sess}){3},'Color',[.6350, .0780, .1840]);
PlotCorrelations_BM(ShockEntriesZone.(Session_type{sess}){4} , Tigmo_score_all.Unblocked.(Session_type{sess}){4},'Color',[.75, .75, 0]);
axis square
xlabel('shock zone entries, Cond'), ylabel('thigmo score, Cond')


figure, sess=3; 
PlotCorrelations_BM(Proportional_TimeFz.(Side{1}).(Session_type{sess}){1} , TimeSpent.Shock.TestPost{1},'Color',[0.3, 0.745, 0.93]);
PlotCorrelations_BM(Proportional_TimeFz.(Side{1}).(Session_type{sess}){2} , TimeSpent.Shock.TestPost{2},'Color',[0.85, 0.325, 0.098]);
PlotCorrelations_BM(Proportional_TimeFz.(Side{1}).(Session_type{sess}){3} , TimeSpent.Shock.TestPost{3},'Color',[.6350, .0780, .1840]);
PlotCorrelations_BM(Proportional_TimeFz.(Side{1}).(Session_type{sess}){4} , TimeSpent.Shock.TestPost{4},'Color',[.75, .75, 0]);
axis square
xlabel('fz prop time, TestPost'), ylabel('Time spent shock, Test Post')



%% thigmo correlations



figure
subplot(121)
PlotCorrelations_BM(Tigmo_score_all.Active_Unblocked.Cond{1} , ShockEntriesZone.Cond{1},'Color',[0.3, 0.745, 0.93]);
PlotCorrelations_BM(Tigmo_score_all.Active_Unblocked.Cond{2} , ShockEntriesZone.Cond{2},'Color',[0.85, 0.325, 0.098]);
PlotCorrelations_BM(Tigmo_score_all.Active_Unblocked.Cond{3} , ShockEntriesZone.Cond{3},'Color',[.65, .75, 0]);
PlotCorrelations_BM(Tigmo_score_all.Active_Unblocked.Cond{4} , ShockEntriesZone.Cond{4},'Color',[.63, .08, .18]);
axis square
xlabel('thigmo Cond'), ylabel('shock zone entries, Cond')
legend('Saline','Diazepam','Rip sham','Rip inhib')

subplot(122)
PlotCorrelations_BM(Tigmo_score_all.Active_Unblocked.Cond{1} , ShockEntriesZone.TestPost{1},'Color',[0.3, 0.745, 0.93]);
PlotCorrelations_BM(Tigmo_score_all.Active_Unblocked.Cond{2} , ShockEntriesZone.TestPost{2},'Color',[0.85, 0.325, 0.098]);
PlotCorrelations_BM(Tigmo_score_all.Active_Unblocked.Cond{3} , ShockEntriesZone.TestPost{3},'Color',[.65, .75, 0]);
PlotCorrelations_BM(Tigmo_score_all.Active_Unblocked.Cond{4} , ShockEntriesZone.TestPost{4},'Color',[.63, .08, .18]);
axis square
xlabel('thigmo Cond'), ylabel('shock zone entries, TestPost')

subplot(222)
PlotCorrelations_BM(Tigmo_score_all.Active_Unblocked.TestPost{1} , ShockEntriesZone.Cond{1},'Color',[0.3, 0.745, 0.93]);
PlotCorrelations_BM(Tigmo_score_all.Active_Unblocked.TestPost{2} , ShockEntriesZone.Cond{2},'Color',[0.85, 0.325, 0.098]);
PlotCorrelations_BM(Tigmo_score_all.Active_Unblocked.TestPost{3} , ShockEntriesZone.Cond{3},'Color',[.65, .75, 0]);
PlotCorrelations_BM(Tigmo_score_all.Active_Unblocked.TestPost{4} , ShockEntriesZone.Cond{4},'Color',[.63, .08, .18]);
axis square
xlabel('thigmo TestPost'), ylabel('shock zone entries, Cond')

subplot(224)
PlotCorrelations_BM(Tigmo_score_all.Active_Unblocked.TestPost{1} , ShockEntriesZone.TestPost{1},'Color',[0.3, 0.745, 0.93]);
PlotCorrelations_BM(Tigmo_score_all.Active_Unblocked.TestPost{2} , ShockEntriesZone.TestPost{2},'Color',[0.85, 0.325, 0.098]);
PlotCorrelations_BM(Tigmo_score_all.Active_Unblocked.TestPost{3} , ShockEntriesZone.TestPost{3},'Color',[.65, .75, 0]);
PlotCorrelations_BM(Tigmo_score_all.Active_Unblocked.TestPost{4} , ShockEntriesZone.TestPost{4},'Color',[.63, .08, .18]);
axis square
xlabel('thigmo TestPost'), ylabel('shock zone entries, TestPost')

a=suptitle('Thigmo correlations with shock zone entries'); a.FontSize=20;




figure
subplot(131)
[R1,P1]=PlotCorrelations_BM(Tigmo_score_all.Active_Unblocked.Cond{1} , Proportional_TimeFz.All.Cond{1},'Color',[0.3, 0.745, 0.93]);
[R2,P2]=PlotCorrelations_BM(Tigmo_score_all.Active_Unblocked.Cond{2} , Proportional_TimeFz.All.Cond{2},'Color',[0.85, 0.325, 0.098]);
[R3,P3]=PlotCorrelations_BM(Tigmo_score_all.Active_Unblocked.Cond{3} , Proportional_TimeFz.All.Cond{3},'Color',[.65, .75, 0]);
[R4,P4]=PlotCorrelations_BM(Tigmo_score_all.Active_Unblocked.Cond{4} , Proportional_TimeFz.All.Cond{4},'Color',[.63, .08, .18]);
axis square
xlabel('thigmo Cond'), ylabel('Freezing prop, Cond')
legend(['Saline R = ' num2str(R1) , ', P = ' num2str(P1)],['Diazepam R = ' num2str(R2) , ', P = ' num2str(P2)],['Rip sham R = ' num2str(R3) , ', P = ' num2str(P3)],['Rip inhib R = ' num2str(R4) , ', P = ' num2str(P4)])

subplot(132)
[R1,P1]=PlotCorrelations_BM(Tigmo_score_all.Active_Unblocked.Cond{1} , Proportional_TimeFz.Shock.Cond{1},'Color',[0.3, 0.745, 0.93]);
[R2,P2]=PlotCorrelations_BM(Tigmo_score_all.Active_Unblocked.Cond{2} , Proportional_TimeFz.Shock.Cond{2},'Color',[0.85, 0.325, 0.098]);
[R3,P3]=PlotCorrelations_BM(Tigmo_score_all.Active_Unblocked.Cond{3} , Proportional_TimeFz.Shock.Cond{3},'Color',[.65, .75, 0]);
[R4,P4]=PlotCorrelations_BM(Tigmo_score_all.Active_Unblocked.Cond{4} , Proportional_TimeFz.Shock.Cond{4},'Color',[.63, .08, .18]);
axis square
xlabel('thigmo Cond'), ylabel('Freezing shock prop, Cond')
legend(['Saline R = ' num2str(R1) , ', P = ' num2str(P1)],['Diazepam R = ' num2str(R2) , ', P = ' num2str(P2)],['Rip sham R = ' num2str(R3) , ', P = ' num2str(P3)],['Rip inhib R = ' num2str(R4) , ', P = ' num2str(P4)])

subplot(133)
[R1,P1]=PlotCorrelations_BM(Tigmo_score_all.Active_Unblocked.Cond{1} , Proportional_TimeFz.Safe.Cond{1},'Color',[0.3, 0.745, 0.93]);
[R2,P2]=PlotCorrelations_BM(Tigmo_score_all.Active_Unblocked.Cond{2} , Proportional_TimeFz.Safe.Cond{2},'Color',[0.85, 0.325, 0.098]);
[R3,P3]=PlotCorrelations_BM(Tigmo_score_all.Active_Unblocked.Cond{3} , Proportional_TimeFz.Safe.Cond{3},'Color',[.65, .75, 0]);
[R4,P4]=PlotCorrelations_BM(Tigmo_score_all.Active_Unblocked.Cond{4} , Proportional_TimeFz.Safe.Cond{4},'Color',[.63, .08, .18]);
axis square
xlabel('thigmo Cond'), ylabel('Freezing safe prop, Cond')
legend(['Saline R = ' num2str(R1) , ', P = ' num2str(P1)],['Diazepam R = ' num2str(R2) , ', P = ' num2str(P2)],['Rip sham R = ' num2str(R3) , ', P = ' num2str(P3)],['Rip inhib R = ' num2str(R4) , ', P = ' num2str(P4)])

a=suptitle('Thigmo correlations with freezing'); a.FontSize=20;



figure
subplot(231)
PlotCorrelations_BM([Tigmo_score_all.Active_Unblocked.Cond{1} Tigmo_score_all.Active_Unblocked.Cond{3}] , [Proportional_TimeFz.All.Cond{1} Proportional_TimeFz.All.Cond{3}],'Color',[0.3, 0.745, 0.93]);
title('All freezing'), ylabel('freezing prop, Cond'), xlim([.45 .9])
subplot(232)
PlotCorrelations_BM([Tigmo_score_all.Active_Unblocked.Cond{1} Tigmo_score_all.Active_Unblocked.Cond{3}] , [Proportional_TimeFz.Shock.Cond{1} Proportional_TimeFz.Shock.Cond{3}],'Color',[0.3, 0.745, 0.93]);
title('Shock freezing'), xlim([.45 .9])
subplot(233)
PlotCorrelations_BM([Tigmo_score_all.Active_Unblocked.Cond{1} Tigmo_score_all.Active_Unblocked.Cond{3}] , [Proportional_TimeFz.Safe.Cond{1} Proportional_TimeFz.Safe.Cond{3}],'Color',[0.3, 0.745, 0.93]);
title('Safe freezing'), xlim([.45 .9])

subplot(234)
PlotCorrelations_BM([Tigmo_score_all.Active_Unblocked.Cond{2} Tigmo_score_all.Active_Unblocked.Cond{4}] , [Proportional_TimeFz.All.Cond{2} Proportional_TimeFz.All.Cond{4}],'Color',[0.85, 0.325, 0.098]);
xlabel('thigmo score, Cond'), ylabel('freezing prop, Cond'), xlim([.45 .9])
subplot(235)
PlotCorrelations_BM([Tigmo_score_all.Active_Unblocked.Cond{2} Tigmo_score_all.Active_Unblocked.Cond{4}] , [Proportional_TimeFz.Shock.Cond{2} Proportional_TimeFz.Shock.Cond{4}],'Color',[0.85, 0.325, 0.098]);
xlabel('thigmo score, Cond'), ylabel('freezing prop, Cond'), xlim([.45 .9])
subplot(236)
PlotCorrelations_BM([Tigmo_score_all.Active_Unblocked.Cond{2} Tigmo_score_all.Active_Unblocked.Cond{4}] , [Proportional_TimeFz.Safe.Cond{2} Proportional_TimeFz.Safe.Cond{4}],'Color',[0.85, 0.325, 0.098]);
xlabel('thigmo score, Cond'), ylabel('freezing prop, Cond'), xlim([.45 .9])


figure
subplot(231)
PlotCorrelations_BM([Tigmo_score_all.Active_Unblocked.Cond{1} Tigmo_score_all.Active_Unblocked.Cond{3}] , [Proportional_TimeFz.All.Cond{1} Proportional_TimeFz.All.Cond{3}],'Color',[0.3, 0.745, 0.93],'method','Spearman');
title('All freezing'), ylabel('freezing prop, Cond'), xlim([.45 .9])
subplot(232)
PlotCorrelations_BM([Tigmo_score_all.Active_Unblocked.Cond{1} Tigmo_score_all.Active_Unblocked.Cond{3}] , [Proportional_TimeFz.Shock.Cond{1} Proportional_TimeFz.Shock.Cond{3}],'Color',[0.3, 0.745, 0.93],'method','Spearman');
title('Shock freezing'), xlim([.45 .9])
subplot(233)
PlotCorrelations_BM([Tigmo_score_all.Active_Unblocked.Cond{1} Tigmo_score_all.Active_Unblocked.Cond{3}] , [Proportional_TimeFz.Safe.Cond{1} Proportional_TimeFz.Safe.Cond{3}],'Color',[0.3, 0.745, 0.93],'method','Spearman');
title('Safe freezing'), xlim([.45 .9])

subplot(234)
PlotCorrelations_BM([Tigmo_score_all.Active_Unblocked.Cond{2} Tigmo_score_all.Active_Unblocked.Cond{4}] , [Proportional_TimeFz.All.Cond{2} Proportional_TimeFz.All.Cond{4}],'Color',[0.85, 0.325, 0.098],'method','Spearman');
xlabel('thigmo score, Cond'), ylabel('freezing prop, Cond'), xlim([.45 .9])
subplot(235)
PlotCorrelations_BM([Tigmo_score_all.Active_Unblocked.Cond{2} Tigmo_score_all.Active_Unblocked.Cond{4}] , [Proportional_TimeFz.Shock.Cond{2} Proportional_TimeFz.Shock.Cond{4}],'Color',[0.85, 0.325, 0.098],'method','Spearman');
xlabel('thigmo score, Cond'), ylabel('freezing prop, Cond'), xlim([.45 .9])
subplot(236)
PlotCorrelations_BM([Tigmo_score_all.Active_Unblocked.Cond{2} Tigmo_score_all.Active_Unblocked.Cond{4}] , [Proportional_TimeFz.Safe.Cond{2} Proportional_TimeFz.Safe.Cond{4}],'Color',[0.85, 0.325, 0.098],'method','Spearman');
xlabel('thigmo score, Cond'), ylabel('freezing prop, Cond'), xlim([.45 .9])



figure
subplot(121)
PlotCorrelations_BM([Tigmo_score_all.Active_Unblocked.Cond{1} Tigmo_score_all.Active_Unblocked.Cond{3}] , [ShockEntriesZone.Cond{1} ShockEntriesZone.Cond{3}],'Color',[0.3, 0.745, 0.93]);
subplot(122)
PlotCorrelations_BM([Tigmo_score_all.Active_Unblocked.Cond{2} Tigmo_score_all.Active_Unblocked.Cond{4}] , [ShockEntriesZone.Cond{2} ShockEntriesZone.Cond{4}],'Color',[0.85, 0.325, 0.098]);



figure
subplot(121)
MakeSpreadAndBoxPlot3_SB(ShockEntriesZone.CondPre,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('#')
title('CondPre')

subplot(122)
MakeSpreadAndBoxPlot3_SB(ShockEntriesZone.CondPost,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('#')
title('CondPost')





