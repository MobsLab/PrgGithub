


% bin_size=1
Session_type={'Cond'};
Mouse=Drugs_Groups_UMaze_BM(1);
for sess=1:length(Session_type)
    [OutPutData1.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),...
        'respi_freq_bm');
end

% bin_size=5
Session_type={'Cond'};
Mouse=Drugs_Groups_UMaze_BM(1);
for sess=1:length(Session_type)
    [OutPutData2.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),...
        'respi_freq_bm');
end


%%
figure
plot(Range(OutPutData1.Cond.respi_freq_bm.tsd{mouse,3}) , Data(OutPutData1.Cond.respi_freq_bm.tsd{mouse,3}))
hold on
plot(Range(OutPutData2.Cond.respi_freq_bm.tsd{mouse,3}) , Data(OutPutData2.Cond.respi_freq_bm.tsd{mouse,3}))


plot([1:10:length(OutPutData2.Cond.respi_freq_bm.tsd{mouse,5})*10],Data(OutPutData2.Cond.respi_freq_bm.tsd{mouse,5}))
hold on
plot([1:length(OutPutData.Cond.respi_freq_bm.tsd{mouse,5})],Data(OutPutData.Cond.respi_freq_bm.tsd{mouse,5}))


figure
for mouse=1:length(Mouse)
    clear A B
    A=interp1(linspace(0,1,length(OutPutData2.Cond.respi_freq_bm.tsd{mouse,5})) , Data(OutPutData2.Cond.respi_freq_bm.tsd{mouse,5}) , linspace(0,1,length(OutPutData1.Cond.respi_freq_bm.tsd{mouse,5})));
    B=Data(OutPutData1.Cond.respi_freq_bm.tsd{mouse,5})';
    
    subplot(2,3,mouse)
    PlotCorrelations_BM(A',B)
    line([0 6],[0 6])
    C(mouse,1) = nanstd(A);
    C(mouse,2) = nanstd(B);
end

sum(A<B)./length(B); 
nanmedian(A)
nanmedian(B)



