% Get the occupatioN maps
clear all
Folder.Cond = PathForExperimentsERC('UMazePAG');
Folder.Known = PathForExperimentsERC('Known');
Folder.Novel = PathForExperimentsERC('Novel');
MouseGroup = fieldnames(Folder);
NumGroups = length(MouseGroup);
Session_type={'sleep_pre','sleep_post'};
Cols = {'k','r','m'};
SpeedLim = 2; % To define movepoch
RectangleCorners = [0,0;20,0;20,40;0,40];
ExtRectangleCorners = [-2,-2;22,-2;22,42;-2,42];
poly = polyshape(ExtRectangleCorners);
PlotOrNot = 0;
for group=1:length(MouseGroup)
    
    disp(MouseGroup{group})
    for mouse=1:length(Folder.(MouseGroup{group}).path)
        cd(Folder.(MouseGroup{group}).path{mouse}{1})
        if exist('AlignedCagePos.mat')
            
            load('AlignedCagePos.mat', 'AlignedYtsd','AlignedXtsd')
            
            clear Wake REMEpoch SWSEpoch Tot
            load('SleepScoring_Accelero.mat','Wake','SWSEpoch','REMEpoch','TotalNoiseEpoch','tsdMovement')
            Wake_All = Wake - TotalNoiseEpoch;
            REMEpoch_All = REMEpoch - TotalNoiseEpoch;
            SWSEpoch_All = SWSEpoch - TotalNoiseEpoch;
            Tot_All = or(Wake,or(SWSEpoch,REMEpoch));
            % Get pre and post periods
            clear ExpeInfo TTLInfo
            load('ExpeInfo.mat')
            load('behavResources.mat','TTLInfo','Xtsd','Ytsd')
            load('behavResources.mat','TTLInfo','SessionEpoch','Vtsd')
            
            Epoch.sleep_pre  = SessionEpoch.PreSleep;
            Epoch.sleep_post= SessionEpoch.PostSleep;
            
            
            for sess=1:2
                % Realign MovAcctsd with the sessino onset
                stacc = min(Range(AlignedXtsd.(Session_type{sess})));
                stsess = min(Start(Epoch.(Session_type{sess})));
                
                AlignedXtsd.(Session_type{sess}) = tsd(Range(AlignedXtsd.(Session_type{sess})) - stacc + stsess,Data(AlignedXtsd.(Session_type{sess})));
                AlignedYtsd.(Session_type{sess}) = tsd(Range(AlignedYtsd.(Session_type{sess})) - stacc + stsess,Data(AlignedYtsd.(Session_type{sess})));

                %% Restrict to session
                Wake = and(Wake_All,Epoch.(Session_type{sess}));
                REMEpoch = and(REMEpoch_All,Epoch.(Session_type{sess}));
                SWSEpoch = and(SWSEpoch_All,Epoch.(Session_type{sess}));
                
                % Recalculate speed
                V = [0;sqrt(diff(Data(AlignedXtsd.(Session_type{sess}))).^2 + diff(Data(AlignedYtsd.(Session_type{sess}))).^2)/median(diff(Range(AlignedYtsd.(Session_type{sess}),'s')))];
                Vtsd = tsd(Range(AlignedXtsd.(Session_type{sess})),V);
                
                MovEpoch = thresholdIntervals(Vtsd,SpeedLim,'Direction','Above');
                MovEpoch = dropShortIntervals(MovEpoch,0.1*1e4);
                MovEpoch = mergeCloseIntervals(MovEpoch,3*1e4);
                
                % Fix first hour
                FirstHour = intervalSet(min(Start(Epoch.(Session_type{sess}))),min(Start(Epoch.(Session_type{sess})))+3600*1e4);
                stsess = min(Start(Epoch.(Session_type{sess})));
                if min(Range(AlignedYtsd.(Session_type{sess}),'s'))<10
                    AlignedYtsd.(Session_type{sess}) = tsd(Range(AlignedYtsd.(Session_type{sess}))+stsess,Data(AlignedYtsd.(Session_type{sess})));
                    AlignedXtsd.(Session_type{sess}) = tsd(Range(AlignedXtsd.(Session_type{sess}))+stsess,Data(AlignedXtsd.(Session_type{sess})));
                end
                
                h = histogram2(Data(Restrict(AlignedYtsd.(Session_type{sess}),and(FirstHour,MovEpoch))),Data(Restrict(AlignedXtsd.(Session_type{sess}),and(FirstHour,MovEpoch))),[-5:25],[-5:45]);
                Vals{sess}{group}(:,:,mouse) = (h.Values)./nansum(h.Values(:));
                h.delete
                
                % Distance to wall during mouvement
                X = Data(Restrict(AlignedYtsd.(Session_type{sess}),and(FirstHour,MovEpoch)));
                Y = Data(Restrict(AlignedXtsd.(Session_type{sess}),and(FirstHour,MovEpoch)));
                TFin = isinterior(poly,X,Y);
                X = X(TFin);
                Y = Y(TFin);
                if not(isempty(X))
                    
                for ii = 1:length(X)
                    DistNear{sess}{group}{mouse}(ii) = DistancePointNearestSideRectangle([X(ii),Y(ii)],RectangleCorners);
                end
                else
                    X = NaN;
                    Y= NaN;
                    DistNear{sess}{group}{mouse}(1) = NaN;
                end
                if PlotOrNot
                subplot(121)
                scatter(Y,X,10,DistNear{sess}{group}{mouse},'filled')
                hold on
                rectangle('Position',[0 0 40 20])
                xlim([-10 50])
                ylim([-10 30])
                axis square
                subplot(122)
                plot(Y,X,'b')
                hold on
                end
                
                % Distance to wall during sleep
                if isempty(Start(SWSEpoch))
                    DistNear_Sleep{sess}{group}(mouse) = NaN;
                    NestPosition{sess}{group}{mouse} = [NaN;NaN];
                    X=[];
                    Y=[];
                else
                    X = Data(Restrict(AlignedYtsd.(Session_type{sess}),SWSEpoch));
                    Y = Data(Restrict(AlignedXtsd.(Session_type{sess}),SWSEpoch));
                    clear posnest
                    for ii = 1:length(X)
                        posnest(ii) = DistancePointNearestSideRectangle([X(ii),Y(ii)],RectangleCorners);
                    end
                    DistNear_Sleep{sess}{group}(mouse) = nanmean(posnest);
                    NestPosition{sess}{group}{mouse} = [nanmean(X),nanmean(Y)];
                end
                if PlotOrNot
                subplot(122)
                plot(Y,X,'r.')
                rectangle('Position',[0 0 40 20])
                xlim([-10 50])
                ylim([-10 30])
                axis square
                pause
                clf
                end
            end
            
        end
        
    end
end


cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/RippleEffect
load('SessionInfo_KnownNovel.mat')
for ss = 1:3
    GoodMice{ss} = find(CondDur{ss}>4000 & CondDur{ss}<8000);% & SleepStart{ss}>13 & SleepStart{ss}<16)
end

for sess = 1:2
    for group = 1:3
        for mouse = 1:length(DistNear{sess}{group})
            [Y,X] = hist(DistNear{sess}{group}{mouse},[0:0.2:10]);
            
            AllH_temp{group}(mouse,:) = runmean(Y/sum(Y),3);
        end
    end
    
    AllH{sess}{1} = AllH_temp{1}(GoodMice{1},:);
    AllH{sess}{2} = [AllH_temp{3}(GoodMice{3},:);AllH_temp{2}(GoodMice{2},:)];
end


figure
X = [0:0.2:10];
for sess = 1:2
    subplot(2,1,sess)
    for group = 1:2
        errorbar(X,nanmean(AllH{sess}{group}),stdError(AllH{sess}{group}))
        hold on
    end
    title(Session_type{sess})
    makepretty
    xlabel('Wall distance')
end

figure
clear h p
LimInOut = 12;
for sess = 1:2
    subplot(1,2,sess)
    MakeSpreadAndBoxPlot_SB({nanmean(AllH{sess}{1}(:,1:LimInOut)')./nanmean(AllH{sess}{1}(:,LimInOut+1:end)'),nanmean(AllH{sess}{2}(:,1:LimInOut)')./nanmean(AllH{sess}{2}(:,LimInOut+1:end)')},[],[1,2],MouseGroup,1,0)
    ylim([-1 7])
    [p,h] = ranksum(nanmean(AllH{sess}{1}(:,1:LimInOut)')./nanmean(AllH{sess}{1}(:,LimInOut+1:end)'),nanmean(AllH{sess}{2}(:,1:LimInOut)')./nanmean(AllH{sess}{2}(:,LimInOut+1:end)'));
    sigstar({[1,2]},p)
    xtickangle(45)
    ylabel('Prop time near wall')
    title(Session_type{sess})
end




%% Position of nests
figure
Cols = {'k','r'};
Marker = {'.','.'};
for sess = 1:2
    subplot(1,2,sess)
    for group = 1:2
        for mouse=1:length(Folder.(MouseGroup{group}).(Session_type{sess}))
            x(sess) = NestPosition{sess}{group}{mouse}(1);
            y(sess) = NestPosition{sess}{group}{mouse}(2);
            plot(NestPosition{sess}{group}{mouse}(1),NestPosition{sess}{group}{mouse}(2),Marker{sess},'color',Cols{group})
            hold on
        end
        
    end
    makepretty
    xlim([0 20])
    ylim([0 40])
    title(Session_type{sess})
    
end


%% nest distance
figure
for sess = 1:2
    subplot(1,2,sess)
    MakeSpreadAndBoxPlot_SB(DistNear_Sleep{sess},[],[1,2],MouseGroup,1,0)
    %     ylim([-1 7])
    [p,h] = ranksum(DistNear_Sleep{sess}{1},DistNear_Sleep{sess}{2});
    sigstar({[1,2]},p)
    xtickangle(45)
    ylim([0 12])
    ylabel('Nest dist to wall position')
end

figure
for group = 1:2
    subplot(1,2,group)
    MakeSpreadAndBoxPlot_SB({DistNear_Sleep{1}{group},DistNear_Sleep{2}{group}},[],[1,2],Session_type,1,1)
    %     ylim([-1 7])
    [p,h] = ranksum(DistNear_Sleep{1}{group},DistNear_Sleep{2}{group});
    sigstar({[1,2]},p)
    xtickangle(45)
    ylim([0 12])
    ylabel('Nest dist to wall position')
    title(MouseGroup{group})
end


Centre = [floor(size(Vals{sess}{group},1)/2),floor(size(Vals{sess}{group},2)/2)];
ImSize = [(size(Vals{sess}{group},1)),(size(Vals{sess}{group},2))];
CageSize =  [22,42];

clear Outside_Occup Inside_Occup
InOutRatio = [0.2:0.1:0.9];
for rat = 1:length(InOutRatio)
    % Inside
    Inside = logical(CreateBinaryRectangle(ImSize(1),ImSize(2),floor(CageSize(1)*InOutRatio(rat)),floor(CageSize(2)*InOutRatio(rat)),...
        Centre(1),Centre(2)));
    % OutSide
    All = CreateBinaryRectangle(ImSize(1),ImSize(2),CageSize(1),CageSize(2),Centre(1),Centre(2));
    Outside = logical(All - Inside);
    for sess = 1:2
        for group = 1:2
            for mouse=1:length(Folder.(MouseGroup{group}).(Session_type{sess}))
                
                
                Map = Vals{sess}{group}(:,:,mouse);
                % Set the inside to NaN so we just keep the outside values
                Map(Inside) = NaN;
                Outside_Occup{sess}{group}(rat,mouse) = nansum(Map(:))./nansum(Outside(:));
                
                Map = Vals{sess}{group}(:,:,mouse);
                % Set the Outside to NaN so we just keep the inside values
                Map(Outside) = NaN;
                Inside_Occup{sess}{group}(rat,mouse) = nansum(Map(:))./nansum(Inside(:));
                
                
            end
        end
    end
end


%% Look at time spent near or far from wall
figure
for sess = 1:2
    subplot(2,1,sess)
    for group = 1:2
        Wallpref{group} = (Outside_Occup{sess}{group}-Inside_Occup{sess}{group})./(Outside_Occup{sess}{group}+Inside_Occup{sess}{group});
        errorbar(InOutRatio,nanmean(Wallpref{group}'),stdError(Wallpref{group}'))
        hold on
    end
    YMax = max(ylim);
    ylim([min(ylim) max(ylim)*1.1])
    clear p
    for rat = 1:length(InOutRatio)
        [p,h]= ranksum(Wallpref{1}(rat,:),Wallpref{2}(rat,:));
        text(InOutRatio(rat),YMax,num2str(floor(p*1000)/1000))
    end
    legend(MouseGroup,'Location','SouthWest')
    ylabel('Wall preference')
    xlim([0 1])
    xlabel('Closeness to wall')
    makepretty
    title(Session_type{sess})
end

% Look at raw data
for sess = 1:2
    figure
    for group = 1:2
        for mouse = 1:length(DistNear{sess}{group})
            subplot(2,10,mouse+10*(group-1))
            imagesc(squeeze((Vals{sess}{group}(:,:,mouse)))')
            xlim([5 25])
            ylim([5 45])
            
        end
    end
end

% Average maps
for sess = 1:2
    figure
    for group = 1 :2
        subplot(1,3,group)
        imagesc(smooth2a(squeeze(nanmean(Vals{sess}{group},3))',1,1))
        xlim([5 25])
        ylim([5 45])
        caxis([0 0.01])
        title(MouseGroup{group})
        colormap parula
        freezeColors
    end
    subplot(1,3,3)
    imagesc(squeeze(nanmean(Vals{sess}{1},3))'-squeeze(nanmean(Vals{sess}{2},3))')
    colormap redblue
    caxis([-0.01 0.01])
    xlim([5 25])
    ylim([5 45])
    title('Control - Inhib')
end

%% Distrib time spent near wall
clear AllH MeanDist
X = [0:0.2:10];
figure
for sess = 1:2
    subplot(2,1,sess)
    for group = 1:2
        for mouse=1:length(Folder.(MouseGroup{group}).(Session_type{sess}))
            [Y,X] = hist(DistNear{sess}{group}{mouse},[0:0.2:10]);
            AllH{sess}{group}(mouse,:) = runmean(Y/sum(Y),3);
            MeanDist{sess}{group}(mouse) = nanmean(DistNear{sess}{group}{mouse}(:));
        end
        errorbar(X,nanmean(AllH{sess}{group}),stdError(AllH{sess}{group}))
        hold on
    end
    makepretty
    legend(MouseGroup,'Location','SouthWest')
    xlabel('Dist to wall')
    ylabel('Prop time')
    title(Session_type{sess})
end


figure
clear h p
LimInOut = 8;
for sess = 1:2
    subplot(1,2,sess)
    MakeSpreadAndBoxPlot_SB({nanmean(AllH{sess}{1}(:,1:LimInOut)')./nanmean(AllH{sess}{1}(:,LimInOut+1:end)'),nanmean(AllH{sess}{2}(:,1:LimInOut)')./nanmean(AllH{sess}{2}(:,LimInOut+1:end)')},[],[1,2],MouseGroup,1,0)
    ylim([-1 7])
    [p,h] = ranksum(nanmean(AllH{sess}{1}(:,1:LimInOut)')./nanmean(AllH{sess}{1}(:,LimInOut+1:end)'),nanmean(AllH{sess}{2}(:,1:LimInOut)')./nanmean(AllH{sess}{2}(:,LimInOut+1:end)'));
    sigstar({[1,2]},p)
    xtickangle(45)
    ylabel('Prop time near wall')
    title(Session_type{sess})
end

% Without two outlies*
AllH{sess}{1}(3,:) = [];
AllH{sess}{2}(8,:) = [];

figure
clear h p
LimInOut = 8;
for sess = 1:2
    subplot(1,2,sess)
    MakeSpreadAndBoxPlot_SB({nanmean(AllH{sess}{1}(:,1:LimInOut)')./nanmean(AllH{sess}{1}(:,LimInOut+1:end)'),nanmean(AllH{sess}{2}(:,1:LimInOut)')./nanmean(AllH{sess}{2}(:,LimInOut+1:end)')},[],[1,2],MouseGroup,1,0)
    ylim([-1 7])
    [p,h] = ranksum(nanmean(AllH{sess}{1}(:,1:LimInOut)')./nanmean(AllH{sess}{1}(:,LimInOut+1:end)'),nanmean(AllH{sess}{2}(:,1:LimInOut)')./nanmean(AllH{sess}{2}(:,LimInOut+1:end)'));
    sigstar({[1,2]},p)
    xtickangle(45)
    ylabel('Prop time near wall')
    title(Session_type{sess})
end
