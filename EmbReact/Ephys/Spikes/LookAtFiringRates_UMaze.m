clear all
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/FiguresAllMice
MiceNumber=[490,507,508,509,510,512,514];

% Everything Together
SessionType{1} =  GetRightSessionsUMaze_SB('AllFreezingSessions');
Name{1} = 'AllCondSessions';

WndwSz = 0.5*1e4;
Recalc = 0;
NumShuffles = 1000;
cd('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/UnitAnalysisphD')
load(['OverallSpikesFzandMov',num2str(WndwSz/1e4),'.mat'])
numspk = 1;
for mm=1:length(MiceNumber)
    
    for spk = 1:size(MouseByMouse.FRFz{mm},1)
        
        AllUnitsFz(numspk,1) = nanmean(MouseByMouse.FRFz{mm}(spk,find(MouseByMouse.LinPosFz{mm}<0.4))');
        AllUnitsFz(numspk,2) = nanmean(MouseByMouse.FRFz{mm}(spk,find(MouseByMouse.LinPosFz{mm}>0.6))');
        
        AllUnitsMov(numspk,1) = nanmean(MouseByMouse.FRMov{mm}(spk,find(MouseByMouse.LinPosMov{mm}<0.4))');
        AllUnitsMov(numspk,2) = nanmean(MouseByMouse.FRMov{mm}(spk,find(MouseByMouse.LinPosMov{mm}>0.6))');
        numspk = numspk+1;
    end
end

Cols = {[0.9 0.9 0.9]};
figure
clf
xlim([0 2])
line(xlim,[0 0],'color',[0.6 0.6 0.6],'linewidth',2,'linestyle','--')
A = {((nanmean(AllUnitsFz')-nanmean(AllUnitsMov'))./(nanmean(AllUnitsMov')+nanmean(AllUnitsFz')))};
hold on
MakeSpreadAndBoxPlot_SB(A,Cols,1)
ylim([-1.2 1.2])
[p,h,stats] = signrank(A{1});
sigstar_DB({[0.8 1.2]},p)
set(gca,'FontSize',15,'linewidth',2)
set(gca,'FontSize',15,'linewidth',2,'XTick',[])
ylabel('MI Fz vs Mov')

figure
clf
xlim([0 2])
line(xlim,[0 0],'color',[0.6 0.6 0.6],'linewidth',2,'linestyle','--')
A = {((AllUnitsFz(:,1)-AllUnitsFz(:,2))./(AllUnitsFz(:,2)+AllUnitsFz(:,1)))};
hold on
MakeSpreadAndBoxPlot_SB(A,Cols,1)
ylim([-1.2 1.2])
[p,h,stats] = signrank(A{1});
sigstar_DB({[0.8 1.2]},p)
set(gca,'FontSize',15,'linewidth',2,'XTick',[])
ylabel('MI shock vs safe')



figure
subplot(121)
nhist({log(AllUnitsFz(:,1)),log(AllUnitsFz(:,2))},'samebins','noerror','binfactor',4)
subplot(122)
A = {((AllUnitsFz(:,1)-AllUnitsFz(:,2))./(AllUnitsFz(:,2)+AllUnitsFz(:,1)))};
hold on
MakeSpreadAndBoxPlot_SB(A,Cols,1)
[p,h] = signrank(A{1});
sigstar_DB({[0.8 1.2]},p)

figure
subplot(121)
nhist({log(nanmean(AllUnitsMov')),log(nanmean(AllUnitsFz'))},'samebins','noerror','binfactor',4)
subplot(122)
A = {((nanmean(AllUnitsFz')-nanmean(AllUnitsMov'))./(nanmean(AllUnitsMov')+nanmean(AllUnitsFz')))};
hold on
MakeSpreadAndBoxPlot_SB(A,Cols,1)
[p,h] = signrank(A{1});
sigstar_DB({[0.8 1.2]},p)
