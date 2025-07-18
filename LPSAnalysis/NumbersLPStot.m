%NumbersLPStot

cols=[0 0 0; 0.4 0.6 1; 0 0 0; 0.4 0.1 0.5;0.6 0.1 0.5; 0.8 0.1 0.5];

for num=1:6
    
    for s=1:4
        subplot(6,2,2*s-1)
        hold on
        line([num num], [0 nanmean(totinfo{s}([1,2,4],num))],'color',cols(num,:),'linewidth',10)
        plot(num,totinfo{s}([1,2,4],num),'g.','Markersize',10)

    end
    
    subplot(6,2,9)
    hold on
    line([num num], [0 nanmean(totinfo{9}([1,2,4],num))],'color',cols(num,:),'linewidth',10)
    plot(num,totinfo{9}([1,2,4],num),'g.','Markersize',10)

    
    subplot(6,4,[22:23])
    hold on
    line([num num], [0 nanmean(totinfo{11}([1,2,4],num))],'color',cols(num,:),'linewidth',10)
    plot(num,totinfo{11}([1,2,4],num),'g.','Markersize',10)

    
    for s=1:4
        subplot(6,2,2*s)
        hold on
        line([num num], [0 nanmean(totinfo{s+4}([1,2,4],num))],'color',cols(num,:),'linewidth',10)
        plot(num,totinfo{s+4}([1,2,4],num),'g.','Markersize',10)

        
    end
    
    
    subplot(6,2,10)
    hold on
    line([num num], [0 nanmean(totinfo{10}([1,2,4],num))],'color',cols(num,:),'linewidth',10)
    plot(num,totinfo{10}([1,2,4],num),'g.','Markersize',10)

    
    
end

for s=1:4
    subplot(6,2,2*s-1)
    xlim([0 7])
    set(gca,'XTick',[1:6],'XTickLabel',{'PreVEH','VEH','PreLPS','LPS','+24','+48'})
    title(strcat('Spindles PaCx_',num2str(Spf(s))))
end
subplot(6,2,9)
xlim([0 7])
set(gca,'XTick',[1:6],'XTickLabel',{'PreVEH','VEH','PreLPS','LPS','+24','+48'})
title('Delta Wave PaCx')
for s=1:4
    subplot(6,2,2*s)
    xlim([0 7])
    set(gca,'XTick',[1:6],'XTickLabel',{'PreVEH','VEH','PreLPS','LPS','+24','+48'})
    title(strcat('Spindles PFCx_',num2str(Spf(s))))
end

subplot(6,4,[22:23])
xlim([0 7])
set(gca,'XTick',[1:6],'XTickLabel',{'PreVEH','VEH','PreLPS','LPS','+24','+48'})
title('Ripples')
subplot(6,2,10)
xlim([0 7])
set(gca,'XTick',[1:6],'XTickLabel',{'PreVEH','VEH','PreLPS','LPS','+24','+48'})
title('Delta Wave PFCx')

cd('/media/DataMOBs14/LPSAnalysis')
    a=cd;
    saveas(f,'TotNumbers.fig')
    try
        saveFigure(f,'TotNumbers',a)
    end
    saveas(f,'TotNumbers.png')
    
