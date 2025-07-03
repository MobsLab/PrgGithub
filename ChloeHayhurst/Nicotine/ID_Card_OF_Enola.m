Mouse_names_Nic = {'M1500','M1531','M1532','M1686','M1687','M1685','M1713','M1714','M1747','M1742','M1743','M1745','M1746'};

for i = 1:length(Mouse_names_Nic)
    MouseName = Mouse_names_Nic{i};
    MouseNumber = i;
    
    
    figure('Color',[1 1 1])
    subplot(331)
    plot(Data(XtsdAligned.NicotineOF.Pre.(MouseName)),Data(YtsdAligned.NicotineOF.Pre.(MouseName)), 'Color', [1.0 0.6 0.8])
    hold on
    diameter = 1;
    radius = diameter / 2;
    center = [0.5, 0.5];
    theta = linspace(0, 2*pi, 100);
    plot(center(1) + radius * cos(theta), center(2) + radius * sin(theta), 'k-', 'LineWidth', 2);
    
    subplot(334)
    plot(Data(XtsdAligned.NicotineOF.Post.(MouseName)),Data(YtsdAligned.NicotineOF.Post.(MouseName)),'Color', [1.0 0.7 0.3])
    hold on
    diameter = 1;
    radius = diameter / 2;
    center = [0.5, 0.5];
    theta = linspace(0, 2*pi, 100);
    plot(center(1) + radius * cos(theta), center(2) + radius * sin(theta), 'k-', 'LineWidth', 2);
    
    
    subplot(337)
    
    x = categorical({'OFPre','OFPost'});
    x = reordercats(x,{'OFPre','OFPost'});
    vals = [FreezeTimeAcc.NicotineOF.Pre(MouseNumber) ; FreezeTimeAcc.NicotineOF.Post(MouseNumber)];
    b = bar(x,vals);
    cd
    
    b.FaceColor = 'flat';
    b.CData(1,:) = [1.0 0.6 0.8];
    b.CData(2,:) = [1.0 0.7 0.3];
    
    ylabel('Time spent freezing')
    
    subplot(3,3,2:3)
    try
        plot(Range(RespiFz.NicotineOF.Post.(MouseName),'s'),Data(RespiFz.NicotineOF.Post.(MouseName)), 'r')
        hold on
    end
    try
        plot(Range(RipDensity_Fz.NicotineOF.Post.(MouseName)),Data(RipDensity_Fz.NicotineOF.Post.(MouseName)), 'g-')
        hold on
    end
    try
        plot(Range(HRFz.NicotineOF.Post.(MouseName), FreezeEpochAcc.NicotineOF.Post.(MouseName),'s'),Data(HRFz.NicotineOF.Post.(MouseName)));
        hold on
    end
    try
        starts = Start(FreezeEpochAcc.NicotineOF.Post.(MouseName),'s');
        
        for i = 1:length(starts)
            xline(starts(i), 'k-', 'LineWidth', 0.2);  % noir pointillé
        end
        xlim([0 1800])
    end
    subplot(335)
    
    x = categorical({'OFPre','OFPost'});
    x = reordercats(x,{'OFPre','OFPost'});
    vals = [DistanceToCenter_mean.NicotineOF.Pre(MouseNumber) ; DistanceToCenter_mean.NicotineOF.Post(MouseNumber)];
    b = bar(x,vals);
    
    b.FaceColor = 'flat';
    b.CData(1,:) = [1.0 0.6 0.8];
    b.CData(2,:) = [1.0 0.7 0.3];
    
    ylabel('Time spent in thigmotaxis')
    
    subplot(338)
    
    x = categorical({'OFPre','OFPost'});
    x = reordercats(x,{'OFPre','OFPost'});
    vals = [length(Start(FreezeEpochAcc.NicotineOF.Pre.(MouseName))) ; length(Start(FreezeEpochAcc.NicotineOF.Post.(MouseName)))];
    b = bar(x,vals);
    
    b.FaceColor = 'flat';
    b.CData(1,:) = [1.0 0.6 0.8];
    b.CData(2,:) = [1.0 0.7 0.3];
    
    ylabel('Number of freezing')
    
    subplot(339)
    
    x = categorical({'OFPre','OFPost'});
    x = reordercats(x,{'OFPre','OFPost'});
    vals = [FreezeTimeAcc.NicotineOF.Pre(MouseNumber)/length(Start(FreezeEpochAcc.NicotineOF.Pre.(MouseName))) ; FreezeTimeAcc.NicotineOF.Post(MouseNumber)/length(Start(FreezeEpochAcc.NicotineOF.Post.(MouseName)))];
    b = bar(x,vals);
    
    b.FaceColor = 'flat';
    b.CData(1,:) = [1.0 0.6 0.8];
    b.CData(2,:) = [1.0 0.7 0.3];
    
    ylabel('Average freezing duration');
    
    mtitle(MouseName);
    
end