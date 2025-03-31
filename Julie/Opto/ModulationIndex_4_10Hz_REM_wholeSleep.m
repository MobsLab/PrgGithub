% ModulationIndex_4_10Hz_REM_wholeSleep.m
% 13.10.2017
sav=0;
% dataset='7mice_458-467';
dataset='4_3_mice_paper_july17';

if 0
    % previous figure : 4 subplot
cd(['/media/DataMOBsRAIDN/ProjetAversion/RampOver1dayQuantif/Ramp_4_no_selection/' dataset '/allsleep'])
load power_dur-bef_left_right

n=1; p=4;
figure('Position',[1930         706        1000         260]), 
subplot(n,p,1)

plotSpread((Mbulb(:,3)-Mbulb(:,5))./(Mbulb(:,3)+Mbulb(:,5)));

plot([0 2],[0 0 ],'Color',[0.7 0.7 0.7],'LineStyle','-')
MI_bulb_whole=(Mbulb(:,3)-Mbulb(:,5))./(Mbulb(:,3)+Mbulb(:,5));
ylim([-1.5 1.5])
ylabel('modulation index (4-10)/(4+10)')
% xlabel('bulb')
set(gca,'XTickLabel',[])
title('whole sleep')

subplot(n,p,2)
MI_pfc_whole=(Mpfc(:,3)-Mpfc(:,5))./(Mpfc(:,3)+Mpfc(:,5));
plotSpread((Mpfc(:,3)-Mpfc(:,5))./(Mpfc(:,3)+Mpfc(:,5)),'distributionColors','r');
% xlabel('PFC')
ylim([-1.5 1.5])
set(gca,'XTickLabel',[])
plot([0 2],[0 0 ],'Color',[0.7 0.7 0.7],'LineStyle','-')
title('whole sleep')

cd(['/media/DataMOBsRAIDN/ProjetAversion/RampOver1dayQuantif/Ramp_4_no_selection/' dataset '/REM'])
load power_dur-bef_left_right

subplot(n,p,3)
% xlabel('bulb')
ylabel('modulation index (4-10)/(4+10)')
plotSpread((Mbulb(:,3)-Mbulb(:,5))./(Mbulb(:,3)+Mbulb(:,5)));
MI_bulb_rem=(Mbulb(:,3)-Mbulb(:,5))./(Mbulb(:,3)+Mbulb(:,5));
ylim([-1.5 1.5])
set(gca,'XTickLabel',[])
plot([0 2],[0 0 ],'Color',[0.7 0.7 0.7],'LineStyle','-')
title('REM')

subplot(n,p,4)
plotSpread((Mpfc(:,3)-Mpfc(:,5))./(Mpfc(:,3)+Mpfc(:,5)),'distributionColors','r');
MI_pfc_rem=(Mpfc(:,3)-Mpfc(:,5))./(Mpfc(:,3)+Mpfc(:,5));
% xlabel('PFC')
ylim([-1.5 1.5])
set(gca,'XTickLabel',[])
plot([0 2],[0 0 ],'Color',[0.7 0.7 0.7],'LineStyle','-')
title('REM')

[p_bulb, h, stats]=ranksum(MI_bulb_rem(~isnan(MI_bulb_rem)),MI_bulb_whole(~isnan(MI_bulb_whole)));
[p_pfc, h, stats]=ranksum(MI_pfc_rem(~isnan(MI_pfc_rem)),MI_pfc_whole(~isnan(MI_pfc_whole)));
[p_whole, h, stats]=ranksum(MI_bulb_whole(~isnan(MI_bulb_whole)),MI_pfc_whole(~isnan(MI_pfc_whole)));
[p_rem, h, stats]=ranksum(MI_bulb_rem(~isnan(MI_bulb_rem)),MI_pfc_rem(~isnan(MI_pfc_rem)));

else 1
    % paper figure : 1 subplot
    cd(['/media/DataMOBsRAIDN/ProjetAversion/RampOver1dayQuantif/Ramp_4_no_selection/' dataset])
    load power_dur-bef_left_right_all_vs_REM MI_pfc_whole MI_bulb_whole MI_pfc_rem MI_bulb_rem
    n=1; p=1;
    h=figure;
    plotSpread({MI_bulb_whole; MI_pfc_whole; MI_bulb_rem; MI_pfc_rem},'distributionColors',{'b','r','b','r'})
    ylim([-1.5 1.5])
    set(gca,'XTickLabel',{'OB','PFC','OB','PFC'})
    plot([0 5],[0 0 ],'Color',[0.7 0.7 0.7],'LineStyle','-')
    
    ylabel('modulation index 4-10 Hz')
    text(0.2,1.4, '4 Hz')
    text(0.2,-1.4, '10 Hz')

    text(1.5,-1.7, 'all sleep','HorizontalAlignment','center')
    text(3.5,-1.7, 'REM','HorizontalAlignment','center')
    plot([1 2],[1.1 1.1],'Color','k','LineStyle','-'), text(1.5,1.15,'*')

    plot([3 4],[1.1 1.1],'Color','k','LineStyle','-'),text(3.5,1.15,'*')
%     plot([1 3],[1.3 1.3],'Color','k','LineStyle','-'),text(3.5,1.15,'*')
%     plot([2 4],[1.4 1.4],'Color','k','LineStyle','-'),text(3.5,1.15,'*')


[p_bulb, h, stats_bulb]=ranksum(MI_bulb_rem(~isnan(MI_bulb_rem)),MI_bulb_whole(~isnan(MI_bulb_whole)));
[p_pfc, h, stats_bulb]=ranksum(MI_pfc_rem(~isnan(MI_pfc_rem)),MI_pfc_whole(~isnan(MI_pfc_whole)));
[p_whole, h, stats_whole]=ranksum(MI_bulb_whole(~isnan(MI_bulb_whole)),MI_pfc_whole(~isnan(MI_pfc_whole)))
[p_rem, h, stats_rem]=ranksum(MI_bulb_rem(~isnan(MI_bulb_rem)),MI_pfc_rem(~isnan(MI_pfc_rem)))
    if sav

    cd(['/media/DataMOBsRAIDN/ProjetAversion/RampOver1dayQuantif/Ramp_4_no_selection/' dataset])
    saveas(gcf,'MI_4-10_1plot.fig')
    res=pwd;
    saveFigure(h,'aa',res)
    end

end


subplot(n,p,1)
text(-0.1,-0.1,['bulb ' sprintf('%0.2f',p_bulb) '   pfc ' sprintf('%0.2f',p_pfc) '   whole ' sprintf('%0.2f',p_whole) '   rem ' sprintf('%0.2f',p_rem)],'units','normalized')

if sav
cd(['/media/DataMOBsRAIDN/ProjetAversion/RampOver1dayQuantif/Ramp_4_no_selection/' dataset])
saveas(gcf,'MI_4-10.fig')
res=pwd;saveFigure(gcf,'MI_4-10',res)
save power_dur-bef_left_right_all_vs_REM MI_pfc_whole MI_bulb_whole MI_pfc_rem MI_bulb_rem
end


%% Make bokplot versions
figure
clf
Vals = {MI_bulb_whole; MI_pfc_whole; MI_bulb_rem; MI_pfc_rem};
XPos = [1.1,1.9,3.5,4.4];
ColFact = [1,0.8,1,0.8];
for k = 1:4
X = Vals{k};
a=iosr.statistics.boxPlot(XPos(k),X,'boxColor',[0.9 0.9 0.9]*ColFact(k),'lineColor',[0.9 0.9 0.9]*ColFact(k),'medianColor','k','boxWidth',0.5,'showOutliers',false);
a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
a.handles.medianLines.LineWidth = 5;

handlesplot=plotSpread(X,'distributionColors',[0.6,0.6,0.6]*0.2,'xValues',XPos(k),'spreadWidth',0.7), hold on;
set(handlesplot{1},'MarkerSize',22)
handlesplot=plotSpread(X,'distributionColors',[0.6,0.6,0.6]*ColFact(k),'xValues',XPos(k),'spreadWidth',0.7), hold on;
set(handlesplot{1},'MarkerSize',12)

end

xlim([0 5])
line(xlim,[0 0],'linestyle','--','linewidth',1,'color',[0.6 0.6 0.6])
ylim([-2 2])
set(gca,'FontSize',18,'XTick',XPos,'XTickLabel',{'OB','PFC','OB','PFC'},'linewidth',1.5,'YTick',[-2:1:2])
ylabel('MI - LFP Hz powe')
box off

