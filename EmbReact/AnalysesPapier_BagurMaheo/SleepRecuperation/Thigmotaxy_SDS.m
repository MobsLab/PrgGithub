

% Get the occupatioN maps
clear all
close all
% Get data
clear DirSocialDefeat_classic1
Dir.SDS.path{1}{1} = '/media/nas5/Thierry_DATA/M1112/20201228/SocialDefeat/SleepPostSD/SD_1112_SD1_201228_094818/';
Dir.SDS.path{2}{1} ='/media/nas5/Thierry_DATA/M1075_processed/20201228/SocialDefeat/SleepPostSD/SD_1075_SD1_201228_094818/';
Dir.SDS.path{3}{1} ='/media/nas5/Thierry_DATA/M1107/20201228/SocialDefeat/SleepPostSD/SD_1107_SD1_201228_094818/';

Dir.Control=PathForExperiments_DREADD_MC('mCherry_retroCre_PFC_VLPO_SalineInjection_10am');
Dir.Control=RestrictPathForExperiment(Dir.Control,'nMice',[1423 1424 1425 1426 1433 1434 1449 1450 1451 1414 1439 1440 1437]);

Drug_Group={'Control','SDS'};
SpeedLim = 2; % To define movepoch
RectangleCorners = [0,0;20,0;20,40;0,40];
ExtRectangleCorners = [-2,-2;22,-2;22,42;-2,42];
ExtendedCagePoly = polyshape(ExtRectangleCorners);

for group=1:length(Drug_Group)
    disp(Drug_Group{group})
    for mouse=1:length(Dir.(Drug_Group{group}).path)
        cd(Dir.(Drug_Group{group}).path{mouse}{1})
        
        % Sleep states
        load('SleepScoring_Accelero.mat','Wake','SWSEpoch','REMEpoch','TotalNoiseEpoch','tsdMovement')
        Wake = or(Wake,TotalNoiseEpoch);
        REMEpoch = REMEpoch - TotalNoiseEpoch;
        SWSEpoch = SWSEpoch - TotalNoiseEpoch;
        Tot = or(Wake,or(SWSEpoch,REMEpoch));
        FirstSleep{group}(mouse) = min(Start(dropShortIntervals(SWSEpoch,1*1e4)));
        PreSleep = intervalSet(0,FirstSleep{group}(mouse));
        
        load('behavResources.mat')
        MovEpoch = thresholdIntervals(Vtsd,SpeedLim,'Direction','Above');
        MovEpoch = dropShortIntervals(MovEpoch,0.1*1e4);
        MovEpoch = mergeCloseIntervals(MovEpoch,3*1e4);
        load('AlignedCagePos.mat', 'AlignedYtsd','AlignedXtsd')
        
        h = histogram2(Data(Restrict(AlignedYtsd,and(intervalSet(0,3600*1e4),MovEpoch))),Data(Restrict(AlignedXtsd,and(intervalSet(0,3600*1e4),MovEpoch))),[-5:25],[-5:45]);
        Vals{group}(:,:,mouse) = (h.Values)./nansum(h.Values(:));
        h.delete
        
        % Distance to wall during mouvement
        X = Data(Restrict(AlignedYtsd,and(intervalSet(0,3600*1e4),MovEpoch)));
        Y = Data(Restrict(AlignedXtsd,and(intervalSet(0,3600*1e4),MovEpoch)));
        % Get rid of times when mouse is on top of the cage
        TFin = isinterior(ExtendedCagePoly,X,Y);
        plot(X,Y,'.r')
        hold on
        X = X(TFin);
        Y = Y(TFin);
        
        for ii = 1:length(X)
            DistNear{group}{mouse}(ii) = DistancePointNearestSideRectangle([X(ii),Y(ii)],RectangleCorners);
        end
        
          subplot(121)
        scatter(Y,X,10,DistNear{group}{mouse},'filled')
        hold on
        rectangle('Position',[0 0 40 20])
        xlim([-10 50])
        ylim([-10 30])
        axis square
         subplot(122)
        plot(Y,X,'b')
        hold on
        % Distance to wall during sleep
        X = Data(Restrict(AlignedYtsd,SWSEpoch));
        Y = Data(Restrict(AlignedXtsd,SWSEpoch));
        clear posnest
        for ii = 1:length(X)
            posnest(ii) = DistancePointNearestSideRectangle([X(ii),Y(ii)],RectangleCorners);
        end
        DistNear_Sleep{group}(mouse) = nanmean(posnest);
        NestPosition{group}{mouse} = [nanmean(X),nanmean(Y)];
        
      
                subplot(122)
        plot(Y,X,'r.')
        rectangle('Position',[0 0 40 20])
        xlim([-10 50])
        ylim([-10 30])
        axis square
%         pause
        clf
        
        
    end
    
end


for group = 1:2
    for mouse = 1:length(DistNear{group})
        [Y,X] = hist(DistNear{group}{mouse},[0:0.2:10]);
        
        AllH{group}(mouse,:) = runmean(Y/sum(Y),3);
    end
end


figure
X = [0:0.2:10];
for group = 1:2
    errorbar(X,nanmean(AllH{group}),stdError(AllH{group}))
    hold on
end
makepretty
xlabel('Wall distance')


figure
clear h p
LimInOut = 12;
MakeSpreadAndBoxPlot_SB({nanmean(AllH{1}(:,1:LimInOut)')./nanmean(AllH{1}(:,LimInOut+1:end)'),nanmean(AllH{2}(:,1:LimInOut)')./nanmean(AllH{2}(:,LimInOut+1:end)')},[],[1,2],Drug_Group,1,0)
ylim([-1 7])
[p,h] = ranksum(nanmean(AllH{1}(:,1:LimInOut)')./nanmean(AllH{1}(:,LimInOut+1:end)'),nanmean(AllH{2}(:,1:LimInOut)')./nanmean(AllH{2}(:,LimInOut+1:end)'));
sigstar({[1,2]},p)
xtickangle(45)
ylabel('Prop time near wall')


