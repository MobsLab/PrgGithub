




%%


Session_type={'Ext','TestPre','Cond','Fear'};
Mouse=Drugs_Groups_UMaze_BM(11);


for sess=1:length(Session_type)
    [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),...
        'instfreq','respi_freq_bm');
end



Side={'All','Shock','Safe'}; Side_ind=[3 5 6];

for sess=1:length(Session_type) % generate all data required for analyses
    for mouse = 1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for side=1:length(Side)
            try
                h=histogram(Data(OutPutData.(Session_type{sess}).respi_freq_bm.tsd{mouse,Side_ind(side)}),'BinLimits',[1 8],'NumBins',91);
                HistData.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) = h.Values;
                HistData.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})(1)=NaN;

                h2=histogram(Data(OutPutData.(Session_type{sess}).instfreq.tsd{mouse,Side_ind(side)}),'BinLimits',[1 8],'NumBins',91);
                HistData2.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) = h2.Values;
                HistData2.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})(1)=NaN;
            end
        end
    end
end


for sess=1:length(Session_type) % generate all data required for analyses
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for side=1:length(Side)
            % spectrum
            try
                if isnan(runmean_BM(HistData.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})/nansum(HistData.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})),3))
                    HistData_All.(Side{side}).(Session_type{sess})(mouse,:) = NaN(1,91);
                else
                    HistData_All.(Side{side}).(Session_type{sess})(mouse,:) = runmean_BM(HistData.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})/nansum(HistData.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})),3);
                end
            catch
                HistData_All.(Side{side}).(Session_type{sess})(mouse,:) = NaN(1,91);
            end

            % inst freq
            try
                if isnan(runmean_BM(HistData2.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})/nansum(HistData2.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})),3))
                    HistData_All2.(Side{side}).(Session_type{sess})(mouse,:) = NaN(1,91);
                else
                    HistData_All2.(Side{side}).(Session_type{sess})(mouse,:) = runmean_BM(HistData2.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})/nansum(HistData2.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})),3);
                end
            catch
                HistData_All2.(Side{side}).(Session_type{sess})(mouse,:) = NaN(1,91);
            end
        end
    end
end

figure, mouse=14;
plot(HistData_All.Shock.Fear(mouse,:),'r'), hold on, plot(HistData_All.Safe.Fear(mouse,:),'b')





