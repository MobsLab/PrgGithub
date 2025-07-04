Mouse_names_Nic = {'M1500','M1531','M1532','M1686','M1687','M1685','M1713','M1714','M1747','M1742','M1743','M1745','M1746'};
Mouse_names_Sal = {'M1685','M1686','M1612','M1641','M1644','M1687','M1688','M1742','M1747'};
Name = {'SalineOF','NicotineOF','NicotineLowOF','SalineHC','NicotineHC'};

for group = 1:2
    if group == 2
        Mouse_names = Mouse_names_Nic;
    elseif group == 1
        Mouse_names = Mouse_names_Sal;
    end
    for i=1:length(Mouse_names)
        
        MouseName = Mouse_names{i};
        MouseNumber = i;
        
        
        figure('Color',[1 1 1])
        subplot(331)
        plot(Data(XtsdAligned.(Name{group}).Pre.(MouseName)),Data(YtsdAligned.(Name{group}).Pre.(MouseName)), 'Color', [1.0 0.6 0.8])
        hold on
        diameter = 1;
        radius = diameter / 2;
        center = [0.5, 0.5];
        theta = linspace(0, 2*pi, 100);
        plot(center(1) + radius * cos(theta), center(2) + radius * sin(theta), 'k-', 'LineWidth', 2);
        
        subplot(334)
        plot(Data(XtsdAligned.(Name{group}).Post.(MouseName)),Data(YtsdAligned.(Name{group}).Post.(MouseName)),'Color', [1.0 0.7 0.3])
        hold on
        diameter = 1;
        radius = diameter / 2;
        center = [0.5, 0.5];
        theta = linspace(0, 2*pi, 100);
        plot(center(1) + radius * cos(theta), center(2) + radius * sin(theta), 'k-', 'LineWidth', 2);
        
        
        subplot(337)
        
        x = categorical({'OFPre','OFPost'});
        x = reordercats(x,{'OFPre','OFPost'});
        vals = [FreezeTimeAcc.(Name{group}).Pre(MouseNumber) ; FreezeTimeAcc.(Name{group}).Post(MouseNumber)];
        b = bar(x,vals);
        
        b.FaceColor = 'flat';
        b.CData(1,:) = [1.0 0.6 0.8];
        b.CData(2,:) = [1.0 0.7 0.3];
        
        ylabel('Time spent freezing')
        
        subplot(3,3,2:3)
        try
            plot(Range(RespiFz.(Name{group}).Post.(MouseName),'s'),Data(RespiFz.(Name{group}).Post.(MouseName)), 'r')
            hold on
        end
        try
            plot(Range(RipDensity_Fz.(Name{group}).Post.(MouseName)),Data(RipDensity_Fz.(Name{group}).Post.(MouseName)), 'g-')
            hold on
        end
        try
            plot(Range(HRFz.(Name{group}).Post.(MouseName), FreezeEpochAcc.(Name{group}).Post.(MouseName),'s'),Data(HRFz.(Name{group}).Post.(MouseName)));
            hold on
        end
        try
            starts = Start(FreezeEpochAcc.(Name{group}).Post.(MouseName),'s');
            
            for i = 1:length(starts)
                xline(starts(i), 'k-', 'LineWidth', 0.2);  % noir pointillé
            end
            xlim([0 1800])
        end
        
        subplot(339)
        
        x = categorical({'OFPre','OFPost'});
        x = reordercats(x,{'OFPre','OFPost'});
        vals = [DistanceToCenterBeginning_mean.(Name{group}).Pre(MouseNumber) ; DistanceToCenterBeginning_mean.(Name{group}).Post(MouseNumber)];
        b = bar(x,vals);
        
        b.FaceColor = 'flat';
        b.CData(1,:) = [1.0 0.6 0.8];
        b.CData(2,:) = [1.0 0.7 0.3];
        
        ylabel('Mean thigmotaxis score')
        
        subplot(338)
        
                
        x = categorical({'OFPre','OFPost'});
        x = reordercats(x,{'OFPre','OFPost'});
        vals = [GroomTime.(Name{group}).Pre(MouseNumber) ; GroomTime.(Name{group}).Post(MouseNumber)];
        b = bar(x,vals);
        
        b.FaceColor = 'flat';
        b.CData(1,:) = [1.0 0.6 0.8];
        b.CData(2,:) = [1.0 0.7 0.3];
        
        ylabel('Time spent grooming')
        
        
%         subplot(338)
%         
%         x = categorical({'OFPre','OFPost'});
%         x = reordercats(x,{'OFPre','OFPost'});
%         vals = [length(Start(FreezeEpochAcc.(Name{group}).Pre.(MouseName))) ; length(Start(FreezeEpochAcc.(Name{group}).Post.(MouseName)))];
%         b = bar(x,vals);
%         
%         b.FaceColor = 'flat';
%         b.CData(1,:) = [1.0 0.6 0.8];
%         b.CData(2,:) = [1.0 0.7 0.3];
%         
%         ylabel('Number of freezing')
%         
%         %     subplot(339)
        %
        %     x = categorical({'OFPre','OFPost'});
        %     x = reordercats(x,{'OFPre','OFPost'});
        %     vals = [FreezeTimeAcc.(Name{group}).Pre(MouseNumber)/length(Start(FreezeEpochAcc.(Name{group}).Pre.(MouseName))) ; FreezeTimeAcc.(Name{group}).Post(MouseNumber)/length(Start(FreezeEpochAcc.(Name{group}).Post.(MouseName)))];
        %     b = bar(x,vals);
        %
        %     b.FaceColor = 'flat';
        %     b.CData(1,:) = [1.0 0.6 0.8];
        %     b.CData(2,:) = [1.0 0.7 0.3];
        %
        %     ylabel('Average freezing duration');
        
        subplot(3,3,5:6)
        imagesc(Range(SpectroBulbFz.(Name{group}).Post.(MouseName),'s'),RangeLow,10*log10(Data(SpectroBulbFz.(Name{group}).Post.(MouseName)))');axis xy
        ylim([0 10])
        mtitle(strcat(Name{group},' ',MouseName));
        
    end
end
