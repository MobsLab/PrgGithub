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
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/UnitAnalysisphD
load('SkVsSfandMovFzROCValueAllUnits_Maze.mat')

GoodNeurMov = [];
ROCVal = [];
GoodNeur = [];
for mm=1:length(MiceNumber)
    
    GoodNeur = [GoodNeur,IsSigSfvsSk{mm}];
    GoodNeurMov = [GoodNeurMov,IsSigFzvsMov{mm}];
    ROCVal = [ROCVal,RocValSfvsSk{mm}];

    
end
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



subplot(121)
PlotErrorBarN_KJ({AllUnitsFz(GoodNeur==1,1),AllUnitsFz(GoodNeur==1,2),(AllUnitsMov(GoodNeur==1,1)),(AllUnitsMov(GoodNeur==1,2))},'paired',0,'showpoints',0,'newfig',0)
title('Shock preferring')
set(gca,'XTick',1:4,'XTickLabel',{'Sk-Fz','Sf-Fz','Sk-Move','Sk-Fz'})
ylim([0 6])
subplot(122)
PlotErrorBarN_KJ({AllUnitsFz(GoodNeur==-1,1),AllUnitsFz(GoodNeur==-1,2),(AllUnitsMov(GoodNeur==-1,1)),(AllUnitsMov(GoodNeur==-1,2))},'paired',0,'showpoints',0,'newfig',0)
title('Safe preferring')
set(gca,'XTick',1:4,'XTickLabel',{'Sk-Fz','Sf-Fz','Sk-Move','Sk-Fz'})
ylim([0 6])