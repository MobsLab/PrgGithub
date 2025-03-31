close all

RangeLow = linspace(0.1526,20,261);
for group = 4:5
    if group == 2
        Mouse_names = Mouse_names_Nic;
    elseif group == 1
        Mouse_names = Mouse_names_Sal;
        sizemap1 = [0.01:0.01:1];
        sizemap2 = [0.01:0.01:1];
        
    elseif group == 3
        Mouse_names = Mouse_names_NicLow;
    elseif group == 4
        Mouse_names = Mouse_names_SalHC;
        sizemap1 = [-5:25];
        sizemap2 = [-5:45];
        
    elseif group == 5
        Mouse_names = Mouse_names_NicHC;
    elseif group == 6
        Mouse_names = Mouse_names_DzpHC;
    end
    for mouse = 1:length(Mouse_names)
        %         Fifteen_Bef_Inj = intervalSet(EpochDrugs1.(Name{group})(mouse)-900e4 , EpochDrugs1.(Name{group})(mouse));
        %         Fifteen_Aft_Inj = intervalSet(EpochDrugs2.(Name{group})(mouse) , EpochDrugs2.(Name{group})(mouse)+900e4);
        %
        a=figure; a.Position=[1e3 1e3 2e3 2e3];
        
        subplot(241)
        h = histogram2(Data(YtsdAligned.(Name{group}).Pre.(Mouse_names{mouse})),Data(XtsdAligned.(Name{group}).Pre.(Mouse_names{mouse})),sizemap1,sizemap2);
        makepretty
        
        subplot(242)
        h = histogram2(Data(YtsdAligned.(Name{group}).Post.(Mouse_names{mouse})),Data(XtsdAligned.(Name{group}).Post.(Mouse_names{mouse})),sizemap1,sizemap2);
        makepretty
        
        subplot(248), hold on
        his = histogram(Data(Speed.(Name{group}).Post.(Mouse_names{mouse})), 'BinEdges', linspace(0,30,101));
        his.FaceColor=[0.1 0.1 0.1];
        his.FaceAlpha = 0.5;
        his = histogram(Data(Speed.(Name{group}).Pre.(Mouse_names{mouse})), 'BinEdges', linspace(0,30,101));
        his.FaceColor=[0.9 0.9 0.9];
        his.FaceAlpha = 0.5;
        makepretty
        xlim([0 20])
        
        subplot(247), hold on
        temp = plot(RangeLow, MeanSpectroActive.(Name{group}).Pre(mouse,:));
        temp.Color = [0.7 0.7 0.7];
        hold on
        temp = plot(RangeLow, MeanSpectroActive.(Name{group}).Post(mouse,:));
        temp.Color = [0.3 0.3 0.3];
        temp = plot(RangeLow, MeanSpectroFz.(Name{group}).Post(mouse,:));
        try
            [~,m] = max(MeanSpectroFz.(Name{group}).Post(mouse,:));
            m = RangeLow(m);
            vline(m,'--r')
        end
        temp.Color = [1 0 0];
        xticks(0:1:10)
        xlim([0 10])
        makepretty
        
        subplot(2,4,3:4), hold on
        if group == 4 | group == 5
            plot(Range(Accelero.(Name{group}).Pre.(Mouse_names{mouse}),'s'),Data(Accelero.(Name{group}).Pre.(Mouse_names{mouse})),'k');
            plot(Range(Accelero.(Name{group}).Post.(Mouse_names{mouse}),'s'),Data(Accelero.(Name{group}).Post.(Mouse_names{mouse})),'k');
            plot(Range(Restrict(Accelero.(Name{group}).Post.(Mouse_names{mouse}),FreezeEpochAcc.(Name{group}).Post.(Mouse_names{mouse})),'s'),Data(Restrict(Accelero.(Name{group}).Post.(Mouse_names{mouse}),FreezeEpochAcc.(Name{group}).Post.(Mouse_names{mouse}))),'r');
            plot(Range(Restrict(Accelero.(Name{group}).Pre.(Mouse_names{mouse}),FreezeEpochAcc.(Name{group}).Pre.(Mouse_names{mouse})),'s'),Data(Restrict(Accelero.(Name{group}).Pre.(Mouse_names{mouse}),FreezeEpochAcc.(Name{group}).Pre.(Mouse_names{mouse}))),'r');
        else
            plot(Range(Accelero.(Name{group}).Pre.(Mouse_names{mouse}),'s'),Data(Accelero.(Name{group}).Pre.(Mouse_names{mouse})),'k');
            plot(Range(Accelero.(Name{group}).Post.(Mouse_names{mouse}),'s')+max(Range(Accelero.(Name{group}).Pre.(Mouse_names{mouse}),'s')),Data(Accelero.(Name{group}).Post.(Mouse_names{mouse})),'k');
            plot(Range(Restrict(Accelero.(Name{group}).Post.(Mouse_names{mouse}),FreezeEpochAcc.(Name{group}).Post.(Mouse_names{mouse})),'s')+max(Range(Accelero.(Name{group}).Pre.(Mouse_names{mouse}),'s')),Data(Restrict(Accelero.(Name{group}).Post.(Mouse_names{mouse}),FreezeEpochAcc.(Name{group}).Post.(Mouse_names{mouse}))),'r');
            plot(Range(Restrict(Accelero.(Name{group}).Pre.(Mouse_names{mouse}),FreezeEpochAcc.(Name{group}).Pre.(Mouse_names{mouse})),'s'),Data(Restrict(Accelero.(Name{group}).Pre.(Mouse_names{mouse}),FreezeEpochAcc.(Name{group}).Pre.(Mouse_names{mouse}))),'r');
            vline(max(Range(Accelero.(Name{group}).Pre.(Mouse_names{mouse}),'s')),'r--')
        end
        makepretty_CH
        
        subplot(2,4,5:6)
        try
        imagesc(linspace(0,max(Range(SpectroBulbFz.(Name{group}).Post.(Mouse_names{mouse}),'s')),length(Range(SpectroBulbFz.(Name{group}).Post.(Mouse_names{mouse})))),RangeLow, Data(SpectroBulbFz.(Name{group}).Post.(Mouse_names{mouse}))'), axis xy
        end
        ylim([0 12])
        makepretty
        mtitle([Name{group},', ',Mouse_names{mouse}]);
        saveFigure(1,[Name{group},Mouse_names{mouse}],'/home/greta/Dropbox/Mobs_member/ChloeHayhurst/Data/Nicotine/IDCards')
        close all
    end
end





