function [dist2Walltsd,dist2Wall] = distanceToTheWall(X,Y)
    
%[dist2Walltsd,dist2Wall] = distanceToTheWall(X,Y);

    Xpred = Data(X);
    Ypred = Data(Y);
    dist2Wall = zeros(length(Xpred),1);
    for i = 1:length(Xpred)
        try
            x = Xpred(i);
            y = Ypred(i);
            if x >= 0.3 && x <= 0.7
                distX0 = x;
                distX1 = 1 - x;
                distY0 = y;
                distY1 = 1 - y;
                distY2 = abs(y - 0.8);
                allDists = [distX0,distX1,distY0,distY1,distY2];
                new = min(allDists, [], 2);
                dist2Wall(i) = new;
            end
            if y <= 0.81
                distX0 = x;
                distX1 = 1 - x;
                distY0 = y;
                distY1 = 1 - y;
                distX2 = abs(x - 0.375);
                distX3 = abs(x - 0.625);
                allDists = [distX0,distX1,distX2,distX3,distY0,distY1];
                new = min(allDists, [], 2);
                dist2Wall(i) = new;
            end
            if (x <= 0.3 || x >= 0.7) && y >= 0.81
                distX0 = x;
                distX1 = 1 - x;
                distY0 = y;
                distY1 = 1 - y;
                allDists = [distX0,distX1,distY0,distY1];
                new = min(allDists, [], 2);
                dist2Wall(i) = new;
            end
        catch
            dist2Wall(i) = 0
        end
    end
    dist2Walltsd=tsd(Range(X),dist2Wall);
end
    
% 
% 
% function dist2Wall = distanceToTheWall(dirAnalysis)
%     cd(dirAnalysis)
%     load('DataDoAnalysisFor1mouse.mat')
%     load('DataPred200.mat')
%     Xpred = Data(XpredTsd200);
%     Ypred = Data(YpredTsd200);
%     distX0 = Xpred;
%     distX1 = 1 - Xpred;
%     distX2 = abs(Xpred - 0.375);
%     distX3 = abs(Xpred - 0.625);
%     distY0 = Ypred;
%     distY1 = 1 - Ypred;
%     distY2 = abs(Ypred - 0.666);
%     allDists = [distX0,distX1,distX2,distX3,distY0,distY1,distY2];
%     dist2Wall = min(allDists, [], 2);
% end
%     
    
% function [dist2Walltsd,dist2Wall] = distanceToTheWall(X,Y)
%     
% %[dist2Walltsd,dist2Wall] = distanceToTheWall(X,Y);
%     dist2Wall = [];
%     Xpred = Data(X);
%     Ypred = Data(Y);
%     distX0 = Xpred;
%     distX1 = 1 - Xpred;
%     distY0 = Ypred;
%     distY1 = 1 - Ypred;
%     if Xpred > 0.375 & Xpred < 0.625 & Ypred > 0.665
%         distY2 = abs(Ypred - 0.666);
%         allDists = [distX0,distX1,distY0,distY1,distY2];
%         dist2Wall = [dist2Wall, min(allDists, [], 2)];
%     elseif Xpred > 0.375 & Xpred < 0.625 & Ypred > 0.666
%         dist2Wall = [dist2Wall, 0];
%     elseif Ypred < 0.666 & Xpred < 0.376 & Xpred > 0.624
%         distX2 = abs(Xpred - 0.375);
%         distX3 = abs(Xpred - 0.625);
%         allDists = [distX0,distX1,distX2,distX3,distY0,distY1];
%         dist2Wall = [dist2Wall, min(allDists, [], 2)];
%     elseif Ypred < 0.666 & Xpred > 0.375 & Xpred < 0.625
%         dist2Wall = [dist2Wall, 0];
%     else
%         allDists = [distX0,distX1,distY0,distY1];
%         dist2Wall = [dist2Wall, min(allDists, [], 2)];
%     end
%     dist2Walltsd = tsd(Range(X), dist2Wall);
% end
% 
%     