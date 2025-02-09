
Session_type={'Cond'};
Mouse=Drugs_Groups_UMaze_BM(22);
[OutPutData2 , Epoch2 , NameEpoch] = ...
    MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),'ripples');


for mouse=1:length(Mouse)
    
%     Epoch_Respi_Sup4 = thresholdIntervals(OutPutData.Cond.respi_freq_bm.tsd{mouse,3} , 4.5 , 'Direction' , 'Above');
%     Epoch_Respi_Inf4 = thresholdIntervals(OutPutData.Cond.respi_freq_bm.tsd{mouse,3} , 4.5 , 'Direction' , 'Below');
%     RipDensity_Sup4(mouse) = nanmean(Data(Restrict(OutPutData.Cond.ripples_density.tsd{mouse,3} , Epoch_Respi_Sup4)));
%     RipDensity_Inf4(mouse) = nanmean(Data(Restrict(OutPutData.Cond.ripples_density.tsd{mouse,3} , Epoch_Respi_Inf4)));
%     
    try, RipTot_Sup4(mouse) = length(Restrict(OutPutData2.ripples.ts{mouse,3} , Epoch_Respi_Sup4)); end
    try, RipTot_Inf4(mouse) = length(Restrict(OutPutData2.ripples.ts{mouse,3} , Epoch_Respi_Inf4)); end
    
end
RipDensity_Inf4(5) = NaN;

Cols = {[1 .5 .5],[.5 .5 1]};
X = [1:2];
Legends = {'Fz>4.5Hz','Fz<4.5Hz'};


figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({RipDensity_Sup4 RipDensity_Inf4},...
    Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('SWR, Fz (#)')
makepretty_BM2

subplot(122)
a= pie([nanmean(RipTot_Sup4) nanmean(RipTot_Inf4)]);
set(a(1), 'FaceColor', [1 .5 .5]); set(a(3), 'FaceColor', [.5 .5 1]);












