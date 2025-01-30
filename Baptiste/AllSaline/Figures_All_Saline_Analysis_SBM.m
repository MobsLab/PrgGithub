

figure
subplot(131)
MakeSpreadAndBoxPlot2_SB({Sleep_dur_all(ind_sup_hour_PAG,1) Sleep_dur_all(ind_sup_hour_PAG,2)},Cols2,X2,Legends2,'showpoints',0,'paired',1,'optiontest','ttest');
title('Sleep duration')
ylabel('time (min)')
subplot(132)
clear A; A=Ripples_density_all; A(Ripples_density_all(:,1)<.3,:)=NaN;
MakeSpreadAndBoxPlot2_SB({A(ind_sup_hour_PAG,1) A(ind_sup_hour_PAG,2)},Cols2,X2,Legends2,'showpoints',0,'paired',1,'optiontest','ttest');
% MakeSpreadAndBoxPlot2_SB({Ripples_density_all(ind_sup_hour,1) Ripples_density_all(ind_sup_hour,2)},Cols2,X2,Legends2,'showpoints',0,'paired',1,'optiontest','ttest');
title('Ripples density')
ylabel('#/s')
subplot(133)
MakeSpreadAndBoxPlot2_SB({REM_prop_all(ind_sup_hour_PAG,1) REM_prop_all(ind_sup_hour_PAG,2)},Cols2,X2,Legends2,'showpoints',0,'paired',1,'optiontest','ttest');
title('REM proportion')
ylabel('prop.')

a=suptitle('Sleep time = 40 min, PAG'); a.FontSize=20;



figure
subplot(131)
MakeSpreadAndBoxPlot2_SB({Sleep_dur_all(ind_sup_hour_eyelid,1) Sleep_dur_all(ind_sup_hour_eyelid,2)},Cols2,X2,Legends2,'showpoints',0,'paired',1,'optiontest','ttest');
title('Sleep duration')
ylabel('time (min)')
subplot(132)
clear A; A=Ripples_density_all; A(Ripples_density_all(:,1)<.3,:)=NaN;
MakeSpreadAndBoxPlot2_SB({A(ind_sup_hour_eyelid,1) A(ind_sup_hour_eyelid,2)},Cols2,X2,Legends2,'showpoints',0,'paired',1,'optiontest','ttest');
% MakeSpreadAndBoxPlot2_SB({Ripples_density_all(ind_sup_hour,1) Ripples_density_all(ind_sup_hour,2)},Cols2,X2,Legends2,'showpoints',0,'paired',1,'optiontest','ttest');
title('Ripples density')
ylabel('#/s')
subplot(133)
MakeSpreadAndBoxPlot2_SB({REM_prop_all(ind_sup_hour_eyelid,1) REM_prop_all(ind_sup_hour_eyelid,2)},Cols2,X2,Legends2,'showpoints',0,'paired',1,'optiontest','ttest');
title('REM proportion')
ylabel('prop.')

a=suptitle('Sleep time = 40 min, eyelid'); a.FontSize=20;





figure; sess=2;
A=FreezeTime.(Session_type{sess})./ExpeDuration.(Session_type{sess});
subplot(331)
PlotCorrelations_BM(REM_prop_all(ind_sup_hour_eyelid,1) , A(ind_sup_hour_eyelid))
axis square
ylabel('Freezing prop')

subplot(332)
PlotCorrelations_BM(REM_prop_all(ind_sup_hour_eyelid,2) , A(ind_sup_hour_eyelid))
axis square

subplot(333)
PlotCorrelations_BM([REM_prop_all(ind_sup_hour_eyelid,1)-REM_prop_all(ind_sup_hour_eyelid,2)] , A(ind_sup_hour_eyelid))
axis square

clear A; A=FreezeTime_Shock.(Session_type{sess})./ExpeDuration.(Session_type{sess});
subplot(334)
PlotCorrelations_BM(REM_prop_all(ind_sup_hour_eyelid,1) , A(ind_sup_hour_eyelid))
axis square
ylabel('Freezing shock prop')

subplot(335)
PlotCorrelations_BM(REM_prop_all(ind_sup_hour_eyelid,2) , A(ind_sup_hour_eyelid))
axis square

subplot(336)
PlotCorrelations_BM([REM_prop_all(ind_sup_hour_eyelid,1)-REM_prop_all(ind_sup_hour_eyelid,2)] , A(ind_sup_hour_eyelid))
axis square


clear A; A=FreezeTime_Safe.(Session_type{sess})./ExpeDuration.(Session_type{sess});
subplot(337)
PlotCorrelations_BM(REM_prop_all(ind_sup_hour_eyelid,1) , A(ind_sup_hour_eyelid))
axis square
xlabel('REM pre prop.'), ylabel('Freezing safe prop')

subplot(338)
PlotCorrelations_BM(REM_prop_all(ind_sup_hour_eyelid,2) , A(ind_sup_hour_eyelid))
axis square
xlabel('REM post prop.')

subplot(339)
PlotCorrelations_BM([REM_prop_all(ind_sup_hour_eyelid,1)-REM_prop_all(ind_sup_hour_eyelid,2)] , A(ind_sup_hour_eyelid))
axis square
xlabel('REM pre - REM post')

a=suptitle('Freezig proportion = f(REM proportion) , Cond sessions, eyelid mice'); a.FontSize=20;




%%
figure; sess=5;
A=ActiveTime_Shock.(Session_type{sess}); A(A==0)=1; A=log10(A);
subplot(131)
PlotCorrelations_BM(REM_prop_all(ind_sup_hour_eyelid,1) , A(ind_sup_hour_eyelid))
axis square
ylabel('Time active shock (log scale)')

subplot(132)
PlotCorrelations_BM(REM_prop_all(ind_sup_hour_eyelid,2) , A(ind_sup_hour_eyelid))
axis square

subplot(133)
PlotCorrelations_BM([REM_prop_all(ind_sup_hour_eyelid,1)-REM_prop_all(ind_sup_hour_eyelid,2)] , A(ind_sup_hour_eyelid))
axis square

a=suptitle('Learning (time active shock in Test Post) = f(REM proportion), eyelid mice'); a.FontSize=20;




figure; sess=2;
clear A; A=Respi_Shock_Fz.(Session_type{sess});
subplot(331)
PlotCorrelations_BM(REM_prop_all(ind_sup_hour_eyelid,1) , A(ind_sup_hour_eyelid))
axis square
ylabel('Respi shock')

subplot(332)
PlotCorrelations_BM(REM_prop_all(ind_sup_hour_eyelid,2) , A(ind_sup_hour_eyelid))
axis square

subplot(333)
PlotCorrelations_BM([REM_prop_all(ind_sup_hour_eyelid,1)-REM_prop_all(ind_sup_hour_eyelid,2)] , A(ind_sup_hour_eyelid))
axis square

clear A; A=Respi_Safe_Fz.(Session_type{sess});
subplot(334)
PlotCorrelations_BM(REM_prop_all(ind_sup_hour_eyelid,1) , A(ind_sup_hour_eyelid))
axis square
ylabel('Respi safe')

subplot(335)
PlotCorrelations_BM(REM_prop_all(ind_sup_hour_eyelid,2) , A(ind_sup_hour_eyelid))
axis square

subplot(336)
PlotCorrelations_BM([REM_prop_all(ind_sup_hour_eyelid,1)-REM_prop_all(ind_sup_hour_eyelid,2)] , A(ind_sup_hour_eyelid))
axis square

clear A; A=Respi_Shock_Fz.(Session_type{sess})-Respi_Safe_Fz.(Session_type{sess});
subplot(337)
PlotCorrelations_BM(REM_prop_all(ind_sup_hour_eyelid,1) , A(ind_sup_hour_eyelid))
axis square
ylabel('Respi shock - Respi safe'), xlabel('REM pre prop.')

subplot(338)
PlotCorrelations_BM(REM_prop_all(ind_sup_hour_eyelid,2) , A(ind_sup_hour_eyelid))
axis square
xlabel('REM post prop.')

subplot(339)
PlotCorrelations_BM([REM_prop_all(ind_sup_hour_eyelid,1)-REM_prop_all(ind_sup_hour_eyelid,2)] , A(ind_sup_hour_eyelid))
axis square
xlabel('REM post - REM pre')

a=suptitle('Respi freezing = f(REM proportion) , Cond sessions, eyelid mice'); a.FontSize=20;



%%
figure; sess=2;
subplot(121)
clear A; A=FreezeTime.(Session_type{sess})./ExpeDuration.(Session_type{sess}); 
clear B; B=Sleep_dur_all(:,1)'; ind=or(A==0,B==0); B(ind)=NaN; A(ind)=NaN;
PlotCorrelations_BM(B , A)
axis square
xlabel('Sleep duration pre (min)'), ylabel('Freezing prop.')


subplot(122)
clear A; A=FreezeTime.(Session_type{sess})./ExpeDuration.(Session_type{sess}); 
clear B; B=Sleep_dur_all(:,2)'; ind=or(A==0,B==0); B(ind)=NaN; A(ind)=NaN;
PlotCorrelations_BM(B , A)
axis square
xlabel('Sleep duration post (min)')

a=suptitle('Freezing proportion = f(Sleep duration)'); a.FontSize=20;


figure; sess=2;
subplot(121)
clear A; A=FreezeTime.(Session_type{sess})./ExpeDuration.(Session_type{sess}); 
clear B; B=Sleep_prop_all(:,1)'; ind=or(A==0,B==0); B(ind)=NaN; A(ind)=NaN;
PlotCorrelations_BM(B , A)
axis square
xlabel('Sleep prop pre (min)'), ylabel('Freezing prop.')


subplot(122)
clear A; A=FreezeTime.(Session_type{sess})./ExpeDuration.(Session_type{sess}); 
clear B; B=Sleep_prop_all(:,2)'; ind=or(A==0,B==0); B(ind)=NaN; A(ind)=NaN;
PlotCorrelations_BM(B , A)
axis square
xlabel('Sleep prop post (min)')

a=suptitle('Freezing proportion = f(Sleep proprotion)'); a.FontSize=20;



figure; sess=2;
subplot(331)
clear A; A=FreezeTime.(Session_type{sess})./ExpeDuration.(Session_type{sess}); 
clear B; B=REM_prop_all(:,1)'; ind=or(A==0,or(B==0,B>.2)); B(ind)=NaN; A(ind)=NaN;
PlotCorrelations_BM(B , A)
axis square
xlabel('REM pre (prop)'), ylabel('Freezing prop.')

subplot(332)
clear B; B=REM_prop_all(:,2)'; ind=or(A==0,B==0); B(ind)=NaN; A(ind)=NaN;
PlotCorrelations_BM(B , A)
axis square
xlabel('REM post (prop)')

subplot(333)
clear B; B=[REM_prop_all(:,2)-REM_prop_all(:,1)]'; ind=or(A==0,or(B==0,B<-.5)); B(ind)=NaN; A(ind)=NaN;
PlotCorrelations_BM(B , A)
axis square
xlabel('REM post-pre')


subplot(334)
clear A; A=FreezeTime_Shock.(Session_type{sess})./ExpeDuration.(Session_type{sess}); 
clear B; B=REM_prop_all(:,1)'; ind=or(A==0,or(B==0,B>.2)); B(ind)=NaN; A(ind)=NaN;
PlotCorrelations_BM(B , A)
axis square
xlabel('REM pre (prop)'), ylabel('Freezing shock prop.')

subplot(335)
clear B; B=REM_prop_all(:,2)'; ind=or(A==0,B==0); B(ind)=NaN; A(ind)=NaN;
PlotCorrelations_BM(B , A)
axis square
xlabel('REM post (prop)')

subplot(336)
clear B; B=[REM_prop_all(:,2)-REM_prop_all(:,1)]'; ind=or(A==0,or(B==0,B<-.5)); B(ind)=NaN; A(ind)=NaN;
PlotCorrelations_BM(B , A)
axis square
xlabel('REM post-pre')


subplot(337)
clear A; A=FreezeTime_Safe.(Session_type{sess})./ExpeDuration.(Session_type{sess}); 
clear B; B=REM_prop_all(:,1)'; ind=or(A==0,or(B==0,B>.2)); B(ind)=NaN; A(ind)=NaN;
PlotCorrelations_BM(B , A)
axis square
xlabel('REM pre (prop)'), ylabel('Freezing shock prop.')

subplot(338)
clear B; B=REM_prop_all(:,2)'; ind=or(A==0,B==0); B(ind)=NaN; A(ind)=NaN;
PlotCorrelations_BM(B , A)
axis square
xlabel('REM post (prop)')

subplot(339)
clear B; B=[REM_prop_all(:,2)-REM_prop_all(:,1)]'; ind=or(A==0,or(B==0,B<-.5)); B(ind)=NaN; A(ind)=NaN;
PlotCorrelations_BM(B , A)
axis square
xlabel('REM post-pre')

a=suptitle('Freezing proportion = f(REM proprotion)'); a.FontSize=20;


%%
figure; sess=2;
subplot(131)
clear A; A=FreezeTime.(Session_type{sess})./ExpeDuration.(Session_type{sess});
clear B; B=Ripples_density_all(:,1)'; ind=or(A==0,B==0); B(ind)=NaN; A(ind)=NaN;
PlotCorrelations_BM(B , A)
axis square
xlabel('REM pre (prop)'), ylabel('Freezing prop.')

subplot(132)
clear A; A=FreezeTime.(Session_type{sess})./ExpeDuration.(Session_type{sess});
clear B; B=Ripples_density_all(:,2)'; ind=or(A==0,or(B==0,B<.3)); B(ind)=NaN; A(ind)=NaN;
PlotCorrelations_BM(B , A)
axis square
xlabel('REM post (prop)')

subplot(133)
clear A; A=FreezeTime.(Session_type{sess})./ExpeDuration.(Session_type{sess});
clear B; B=[Ripples_density_all(:,2)-Ripples_density_all(:,1)]'; ind=or(A==0,or(B==0,B>.2)); B(ind)=NaN; A(ind)=NaN;
PlotCorrelations_BM(B , A)
axis square
xlabel('REM post-pre')

saveFigure(14,'Sleep_AllSaline_12','/home/ratatouille/Desktop/Figures_Baptiste/')



%%
figure; sess=5;
subplot(131)
clear A; A=ActiveTime_Shock.(Session_type{sess}); A(A==0)=1; A=log10(A); 
clear B; B=REM_prop_all(:,1)'; ind=or(A==0,or(B==0,B>.2)); B(ind)=NaN; A(ind)=NaN;
PlotCorrelations_BM(B , A)
axis square
xlabel('REM pre (prop)'), ylabel('time in shock, Test Post (log scale)')

subplot(132)
clear B; B=REM_prop_all(:,2)'; ind=or(or(A==0,A>200),B==0); B(ind)=NaN; A(ind)=NaN;
PlotCorrelations_BM(B , A)
axis square
xlabel('REM post (prop)')

subplot(133)
clear B; B=[REM_prop_all(:,2)-REM_prop_all(:,1)]'; ind=or(A==0,or(B==0,B<-.5)); B(ind)=NaN; A(ind)=NaN;
PlotCorrelations_BM(B , A)
axis square
xlabel('REM post-pre')


a=suptitle('Learning = f(REM proprotion)'); a.FontSize=20;



ActiveTime_Shock.(Session_type{5});


figure; 
subplot(131); sess=5;
A=ActiveTime_Shock.(Session_type{sess}); A(A==0)=1; A=log10(A);
sess=2;
PlotCorrelations_BM(A , FreezeTime.(Session_type{sess})./ExpeDuration.(Session_type{sess}))
axis square


subplot(132)
PlotCorrelations_BM(A , FreezeTime_Shock.(Session_type{sess})./ExpeDuration.(Session_type{sess}))
axis square


subplot(133)
sess=2;
PlotCorrelations_BM(A , FreezeTime_Safe.(Session_type{sess})./ExpeDuration.(Session_type{sess}))
axis square



figure; 
subplot(131)
sess=2;
PlotCorrelations_BM(Sleep_EpMeanDur_all(:,2) , FreezeTime.(Session_type{sess})./ExpeDuration.(Session_type{sess}))
axis square


subplot(132)
PlotCorrelations_BM(Sleep_EpMeanDur_all(:,2) , FreezeTime_Shock.(Session_type{sess})./ExpeDuration.(Session_type{sess}))
axis square


subplot(133)
sess=2;
PlotCorrelations_BM(Sleep_EpMeanDur_all(:,2)  , FreezeTime_Safe.(Session_type{sess})./ExpeDuration.(Session_type{sess}))
axis square



figure; 
subplot(131)
sess=2;
PlotCorrelations_BM(REM_EpMeanDur_all(:,2) , FreezeTime.(Session_type{sess})./ExpeDuration.(Session_type{sess}))
axis square
title('All freezing')
ylabel('Freezing proportion'), xlabel('mean REM dur (min)')

subplot(132)
PlotCorrelations_BM(REM_EpMeanDur_all(:,2) , FreezeTime_Shock.(Session_type{sess})./ExpeDuration.(Session_type{sess}))
axis square
title('Freezing shock')
xlabel('mean REM dur (min)')

subplot(133)
sess=2;
PlotCorrelations_BM(REM_EpMeanDur_all(:,2)  , FreezeTime_Safe.(Session_type{sess})./ExpeDuration.(Session_type{sess}))
axis square
title('Freezing safe')
xlabel('mean REM dur (min)')




figure; 
subplot(131)
sess=2;
PlotCorrelations_BM(REM_EpMeanDur_all(:,1) , FreezeTime.(Session_type{sess})./ExpeDuration.(Session_type{sess}))
axis square
title('All freezing')
ylabel('Freezing proportion'), xlabel('mean REM dur (min)')

subplot(132)
PlotCorrelations_BM(REM_EpMeanDur_all(:,1) , FreezeTime_Shock.(Session_type{sess})./ExpeDuration.(Session_type{sess}))
axis square
title('Freezing shock')
xlabel('mean REM dur (min)')

subplot(133)
sess=2;
PlotCorrelations_BM(REM_EpMeanDur_all(:,1)  , FreezeTime_Safe.(Session_type{sess})./ExpeDuration.(Session_type{sess}))
axis square
title('Freezing safe')
xlabel('mean REM dur (min)')



figure; 
subplot(131)
sess=2; 
PlotCorrelations_BM(REM_EpMeanDur_all(1:21,2) , FreezeTime.(Session_type{sess})(1:21)./ExpeDuration.(Session_type{sess})(1:21))
axis square
title('All freezing')
ylabel('Freezing proportion'), xlabel('mean REM dur (min)')

subplot(132)
PlotCorrelations_BM(REM_EpMeanDur_all(1:21,2) , FreezeTime_Shock.(Session_type{sess})(1:21)./ExpeDuration.(Session_type{sess})(1:21))
axis square
title('Freezing shock')
xlabel('mean REM dur (min)')

subplot(133)
sess=2;
PlotCorrelations_BM(REM_EpMeanDur_all(1:21,2) , FreezeTime_Safe.(Session_type{sess})(1:21)./ExpeDuration.(Session_type{sess})(1:21))
axis square
title('Freezing safe')
xlabel('mean REM dur (min)')



figure; 
subplot(131)
sess=2; 
PlotCorrelations_BM(REM_EpMeanDur_all(22:end,2) , FreezeTime.(Session_type{sess})(22:end)./ExpeDuration.(Session_type{sess})(22:end))
axis square
title('All freezing')
ylabel('Freezing proportion'), xlabel('mean REM dur (min)')

subplot(132)
PlotCorrelations_BM(REM_EpMeanDur_all(22:end,2) , FreezeTime_Shock.(Session_type{sess})(22:end)./ExpeDuration.(Session_type{sess})(22:end))
axis square
title('Freezing shock')
xlabel('mean REM dur (min)')

subplot(133)
sess=2;
PlotCorrelations_BM(REM_EpMeanDur_all(22:end,2) , FreezeTime_Safe.(Session_type{sess})(22:end)./ExpeDuration.(Session_type{sess})(22:end))
axis square
title('Freezing safe')
xlabel('mean REM dur (min)')







figure;
subplot(131)
clear A; A=ActiveTime_Shock.(Session_type{4})-ActiveTime_Shock.(Session_type{5}); 
sess=2;
PlotCorrelations_BM(A(22:end) , FreezeTime.(Session_type{sess})(22:end)./ExpeDuration.(Session_type{sess})(22:end))
axis square
title('All freezing')
ylabel('Freezing proportion'), xlabel('time in shock zone, Test Post')

subplot(132)
PlotCorrelations_BM(A(22:end) , FreezeTime_Shock.(Session_type{sess})(22:end)./ExpeDuration.(Session_type{sess})(22:end))
axis square
title('Freezing shock')
xlabel('time in shock zone, Test Post')

subplot(133)
sess=2;
PlotCorrelations_BM(A(22:end) , FreezeTime_Safe.(Session_type{sess})(22:end)./ExpeDuration.(Session_type{sess})(22:end))
axis square
title('Freezing safe')
xlabel('time in shock zone, Test Post')




%%


load('StateEpochSB.mat')
load('B_Low_Spectrum.mat')
OB_Sp_tsd = tsd(Spectro{2}*1E4 , Spectro{1});
OB_Wake = Restrict(OB_Sp_tsd,Wake);

figure
imagesc(linspace(0,sum(DurationEpoch(Wake))/60e4,length(Data(OB_Wake))) , Spectro{3} , SmoothDec(10*log10(Data(OB_Wake)'),.7)), axis xy
ylim([0 12])

load('behavResources.mat', 'MovAcctsd')
MovAcctsd = Restrict(MovAcctsd,Wake);

NewMovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),30));
FreezeAccEpoch=thresholdIntervals(NewMovAcctsd,1.7e7,'Direction','Below');
FreezeAccEpoch=mergeCloseIntervals(FreezeAccEpoch,0.3*1e4);
FreezeAccEpoch=dropShortIntervals(FreezeAccEpoch,2*1e4);

sum(DurationEpoch(FreezeAccEpoch))/1e4




OB_Freezing = Restrict(OB_Sp_tsd,FreezeAccEpoch);

figure
imagesc(linspace(0,sum(DurationEpoch(FreezeAccEpoch))/60e4,length(Data(OB_Freezing))) , Spectro{3} , SmoothDec(10*log10(Data(OB_Freezing)'),.7)), axis xy
ylim([0 12])

figure
plot(Spectro{3} , nanmean(Data(OB_Freezing)))


%%
figure; sess=5;
subplot(131)
PlotCorrelations_BM(log10(ThetaPower_All_Fz.Cond)./log10(ThetaPower_All.TestPre) , FreezeTime.(Session_type{sess})./ExpeDuration.(Session_type{sess}))
axis square
% xlabel('REM pre (prop)'), ylabel('time in shock, Test Post (log scale)')

subplot(132)
PlotCorrelations_BM(ThetaPower_All_Fz.Cond./ThetaPower_All.TestPre , FreezeTime_Shock.(Session_type{sess})./ExpeDuration.(Session_type{sess}))
axis square
% xlabel('REM post (prop)')

subplot(133)
PlotCorrelations_BM(ThetaPower_All_Fz.Cond./ThetaPower_All.TestPre , FreezeTime_Safe.(Session_type{sess})./ExpeDuration.(Session_type{sess}))
axis square
% xlabel('REM post-pre')




