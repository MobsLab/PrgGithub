

%%

Session_type = {'TestPre'};
Mouse=Drugs_Groups_UMaze_BM(11);

for sess=1:length(Session_type)
    [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),...
'speed','accelero','respi_freq_bm','heartrate','heartratevar','ob_gamma_power','ob_gamma_freq','ob_high','alignedposition');
end
for sess=1:length(Session_type)
    [OutPutData2.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),...
        'alignedposition');
end

for mouse=1:length(Mouse)
    Thigmo.TestPre(mouse) = Thigmo_From_Position_BM(OutPutData2.TestPre.alignedposition.tsd{mouse,4});
end
Thigmo.TestPre(Thigmo.TestPre==0)=NaN;


for mouse=1:length(Mouse)
    
    Immobile=thresholdIntervals(OutPutData.TestPre.speed.tsd{mouse,1},2,'Direction','Below');
    Immobile=mergeCloseIntervals(Immobile,.2*1e4);
    Immobile=dropShortIntervals(Immobile,.5*1e4);
    Moving = intervalSet(0,max(Range(OutPutData.TestPre.respi_freq_bm.tsd{mouse,1})))-Immobile;
    
    Respi_Moving(mouse) = nanmean(Data(Restrict(OutPutData.TestPre.respi_freq_bm.tsd{mouse,1} , Moving)));
    Respi_Immobile(mouse) = nanmean(Data(Restrict(OutPutData.TestPre.respi_freq_bm.tsd{mouse,1} , Immobile)));
    Speed_Moving(mouse) = nanmean(Data(Restrict(OutPutData.TestPre.speed.tsd{mouse,1} , Moving)));
    Speed_Immobile(mouse) = nanmean(Data(Restrict(OutPutData.TestPre.speed.tsd{mouse,1} , Immobile)));
    try
    HR_Moving(mouse) = nanmean(Data(Restrict(OutPutData.TestPre.heartrate.tsd{mouse,1} , Moving)));
    HR_Immobile(mouse) = nanmean(Data(Restrict(OutPutData.TestPre.heartrate.tsd{mouse,1} , Immobile)));
    end
end


figure
subplot(241)
clear A B
A = OutPutData.TestPre.speed.mean(:,4);
B = OutPutData.TestPre.accelero.mean(:,4);
A(A==0)=NaN; B(B==0)=NaN; 
PlotCorrelations_BM(A , B' , 'color' , 'k','method','spearman')
xlabel('speed'), ylabel('accelero')

subplot(242)
clear A B
A = OutPutData.TestPre.speed.mean(:,4);
B = OutPutData.TestPre.respi_freq_bm.mean(:,4);
A(A==0)=NaN; B(B==0)=NaN; 
PlotCorrelations_BM(A , B' , 'color' , 'k','method','spearman')
xlabel('speed'), ylabel('respi')

subplot(243)
clear A B
A = OutPutData.TestPre.speed.mean(:,4);
B = OutPutData.TestPre.heartrate.mean(:,4);
A(A==0)=NaN; B(B==0)=NaN; 
PlotCorrelations_BM(A , B' , 'color' , 'k','method','spearman')
xlabel('speed'), ylabel('heart rate')

subplot(244)
clear A B
A = OutPutData.TestPre.speed.mean(:,4);
B = OutPutData.TestPre.heartratevar.mean(:,4);
A(B==0)=NaN; B(B==0)=NaN; 
PlotCorrelations_BM(A , B' , 'color' , 'k','method','spearman')
xlabel('speed'), ylabel('heart rate var')



subplot(245)
A = Thigmo.TestPre;
B = OutPutData.TestPre.accelero.mean(:,4);
A(A==0)=NaN; B(B==0)=NaN; 
PlotCorrelations_BM(A , B' , 'color' , 'k','method','spearman')
xlabel('thigmo'), ylabel('accelero')

subplot(246)
A = Thigmo.TestPre;
B = OutPutData.TestPre.respi_freq_bm.mean(:,4);
A(A==0)=NaN; B(B==0)=NaN; 
PlotCorrelations_BM(A , B' , 'color' , 'k','method','spearman')
xlabel('thigmo'), ylabel('respi')

subplot(247)
A = Thigmo.TestPre;
B = OutPutData.TestPre.heartrate.mean(:,4);
A(A==0)=NaN; B(B==0)=NaN; %B(B<11.2)=NaN;
PlotCorrelations_BM(A , B' , 'color' , 'k','method','spearman')
xlabel('thigmo'), ylabel('heart rate')

subplot(248)
A = Thigmo.TestPre;
B = OutPutData.TestPre.heartratevar.mean(:,4);
A(A==0)=NaN; B(B==0)=NaN; 
PlotCorrelations_BM(A , B' , 'color' , 'k','method','spearman')
xlabel('thigmo'), ylabel('heart rate var')



%%

for mouse=1:length(Mouse)
    try
        Learning(mouse) = (sum(DurationEpoch(Epoch1.TestPost{mouse,5}))+sum(DurationEpoch(Epoch1.TestPost{mouse,7})))/720e4;
    end
end

figure
subplot(221)
A = OutPutData.TestPre.speed.mean(:,4);
B = OutPutData.TestPre.respi_freq_bm.mean(:,4);
A(A==0)=NaN; B(B==0)=NaN; 

PlotCorrelations_BM(A , B' , 'color' , 'g')


subplot(222)
A = OutPutData.TestPost.speed.mean(:,4);
B = OutPutData.TestPost.respi_freq_bm.mean(:,4);
A(A==0)=NaN; B(B==0)=NaN; 

PlotCorrelations_BM(A , B' , 'color' , 'r')


subplot(223)
A = OutPutData.TestPre.speed.mean(:,4);
B = OutPutData.TestPost.speed.mean(:,4);
A(A==0)=NaN; B(B==0)=NaN; 

PlotCorrelations_BM(A , B' , 'color' , 'g')


subplot(224)
A = OutPutData.TestPre.respi_freq_bm.mean(:,4);
B = OutPutData.TestPost.respi_freq_bm.mean(:,4);
A(A==0)=NaN; B(B==0)=NaN; 

PlotCorrelations_BM(A , B' , 'color' , 'r')




figure
A = Learning;
B = OutPutData.TestPre.respi_freq_bm.mean(:,4);
A(1)=NaN; B(B==0)=NaN; 

PlotCorrelations_BM(A , B' , 'color' , 'r')



figure
A = OutPutData.TestPre.respi_freq_bm.mean(:,4);
B = OutPutData.Cond.respi_freq_bm.mean(:,5)-OutPutData.Cond.respi_freq_bm.mean(:,6);
A(1)=NaN; B(B==0)=NaN; 

PlotCorrelations_BM(A , B' , 'color' , 'r')

figure
A = OutPutData.TestPre.respi_freq_bm.mean(:,4);
B = OutPutData.Cond.respi_freq_bm.mean(:,6);
A(1)=NaN; B(B==0)=NaN; 

PlotCorrelations_BM(A , B' , 'color' , 'r')

figure
A = OutPutData.TestPre.respi_freq_bm.mean(:,4);
B = OutPutData.Cond.respi_freq_bm.mean(:,5);
A(1)=NaN; B(B==0)=NaN; 

PlotCorrelations_BM(A , B' , 'color' , 'r')







