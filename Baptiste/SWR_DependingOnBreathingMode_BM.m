
Session_type={'Cond'}; sess=1;
Mouse=Drugs_Groups_UMaze_BM(22);
[OutPutData , Epoch , NameEpoch] = ...
    MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),'ripples','ripples_density','respi_freq_bm');


for mouse=1:length(Mouse)
    
    Epoch_Respi_Sup4 = thresholdIntervals(OutPutData.respi_freq_bm.tsd{mouse,3} , 4.5 , 'Direction' , 'Above');
    Epoch_Respi_Inf4 = thresholdIntervals(OutPutData.respi_freq_bm.tsd{mouse,3} , 4.5 , 'Direction' , 'Below');
    RipDensity_Sup4(mouse) = nanmean(Data(Restrict(OutPutData.ripples_density.tsd{mouse,3} , Epoch_Respi_Sup4)));
    RipDensity_Inf4(mouse) = nanmean(Data(Restrict(OutPutData.ripples_density.tsd{mouse,3} , Epoch_Respi_Inf4)));
    
    try, RipTot_Sup4(mouse) = length(Restrict(OutPutData.ripples.ts{mouse,3} , Epoch_Respi_Sup4)); end
    try, RipTot_Inf4(mouse) = length(Restrict(OutPutData.ripples.ts{mouse,3} , Epoch_Respi_Inf4)); end
    
    try
        clear R, R = Range(OutPutData.respi_freq_bm.tsd{mouse,5});
        End_Epoch_shock = intervalSet(R(round(size(R,1)*.9)) , R(end));
    end
    clear R, R = Range(OutPutData.respi_freq_bm.tsd{mouse,6});
    End_Epoch_safe = intervalSet(R(round(size(R,1)*.9)) , R(end));
    try, RipTot_Sup4_end(mouse) = length(Restrict(OutPutData.ripples.ts{mouse,3} , and(Epoch_Respi_Sup4 , End_Epoch_shock))); end
    try, RipTot_Inf4_end(mouse) = length(Restrict(OutPutData.ripples.ts{mouse,3} , and(Epoch_Respi_Inf4 , End_Epoch_safe))); end
    
end
RipTot_Inf4_end(RipTot_Inf4_end==0) = NaN;
RipTot_Sup4_end(RipTot_Inf4_end==0) = NaN;

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



figure
a= pie([nanmean(RipTot_Sup4_end) nanmean(RipTot_Inf4_end)]);
set(a(1), 'FaceColor', [1 .5 .5]); set(a(3), 'FaceColor', [.5 .5 1]);








