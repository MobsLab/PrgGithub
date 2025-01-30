clear all

% To align all the data
figure
Drug_Group={'RipControl','RipInhib'};
Folder = FolderNames_UmazeSleepPrePost_RibInhib_SB;
Session_type={'sleep_pre','sleep_post'};


% Get the occupatioN maps
figure
load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_for_SB/DZP_Sess.mat', 'SleepSession')

%% GET DATA - ctrl group (mCherry saline injection 10h without stress)
clear SFI LatencyToState
time_start = 0*3600*1e4; % first hour
time_end = 1*3600*1e4; % first hour

SpeedLim = 2; % To define movepoch
RectangleCorners = [0,0;20,0;20,40;0,40];
for group=1
    disp(Drug_Group{group})
    for sess=1
        for mouse=[1:8,10:length(SleepSession(2,:,2))]
            
    cd(SleepSession{2,mouse,2}{1});
            
            % Sleep states
            try
            load('SleepScoring_Accelero.mat','Wake','SWSEpoch','REMEpoch','TotalNoiseEpoch','tsdMovement')
            catch
               load('StateEpochSB.mat','Wake','SWSEpoch','REMEpoch','TotalNoiseEpoch') 
            end
            Wake = or(Wake,TotalNoiseEpoch);
            REMEpoch = REMEpoch - TotalNoiseEpoch;
            SWSEpoch = SWSEpoch - TotalNoiseEpoch;
            Tot = or(Wake,or(SWSEpoch,REMEpoch));
            FirstSleep{sess}{group}(mouse) = min(Start(dropShortIntervals(SWSEpoch,1*1e4)));
            PreSleep = intervalSet(0,FirstSleep{sess}{group}(mouse));
            
            load('behavResources_SB.mat')
            MovEpoch = thresholdIntervals(Behav.Vtsd,SpeedLim,'Direction','Above');
            MovEpoch = dropShortIntervals(MovEpoch,0.1*1e4);
            MovEpoch = mergeCloseIntervals(MovEpoch,3*1e4);
            load('AlignedCagePos.mat', 'AlignedYtsd','AlignedXtsd')
            
            h = histogram2(Data(Restrict(AlignedYtsd,and(intervalSet(0,3600*1e4),MovEpoch))),Data(Restrict(AlignedXtsd,and(intervalSet(0,3600*1e4),MovEpoch))),[-5:25],[-5:45]);
            Vals{sess}{group}(:,:,mouse) = (h.Values)./nansum(h.Values(:));
            h.delete
            
            % Distance to wall during mouvement
            X = Data(Restrict(AlignedYtsd,and(intervalSet(0,3600*1e4),MovEpoch)));
            Y = Data(Restrict(AlignedXtsd,and(intervalSet(0,3600*1e4),MovEpoch)));
            for ii = 1:length(X)
                DistNear{sess}{group}{mouse}(ii) = DistancePointNearestSideRectangle([X(ii),Y(ii)],RectangleCorners);
            end
            
            % Distance to wall during sleep
             X = Data(Restrict(AlignedYtsd,SWSEpoch));
            Y = Data(Restrict(AlignedXtsd,SWSEpoch));
            clear posnest
            for ii = 1:length(X)
                posnest(ii) = DistancePointNearestSideRectangle([X(ii),Y(ii)],RectangleCorners);
            end
            DistNear_Sleep{sess}{group}(mouse) = nanmean(posnest);
            NestPosition{sess}{group}{mouse} = [nanmean(X),nanmean(Y)];
            
%                         clf
%                         scatter(X,Y,10,DistNear{sess}{group}{mouse},'filled')
%                         pause
            %
            %             hold on
            %             xlim([0 20])
            %             ylim([0 40])
            
            %             subplot(2,2,group+2)
            %
            %             hold on
            %             plot(Data(Restrict(AlignedYtsd,SWSEpoch)),Data(Restrict(AlignedXtsd,SWSEpoch)),'.')
            %             xlim([0 20])
            %             ylim([0 40])
            
            
        end
        
    end
end

%% Position of nests
figure
Cols = {'k','r'};
Marker = {'.','.'};
for sess = 1
    subplot(1,2,sess)
    for group = 1
        for mouse=[1:8,10:length(SleepSession(2,:,2))]
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
    for sess = 1
        for group = 1
        for mouse=[1:8,10:length(SleepSession(2,:,2))]
                
                
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
for sess = 1
    subplot(2,1,sess)
    for group = 1
        Wallpref{group} = (Outside_Occup{sess}{group}-Inside_Occup{sess}{group})./(Outside_Occup{sess}{group}+Inside_Occup{sess}{group});
        errorbar(InOutRatio,nanmean(Wallpref{group}'),stdError(Wallpref{group}'))
        hold on
    end
    YMax = max(ylim);
    ylim([min(ylim) max(ylim)*1.1])
    clear p
    legend(Drug_Group,'Location','SouthWest')
    ylabel('Wall preference')
    xlim([0 1])
    xlabel('Closeness to wall')
    makepretty
    title(Session_type{sess})
end

% Look at raw data
for sess = 1
    figure
    for group = 1
        for mouse=1:length(Folder.(Drug_Group{group}).(Session_type{sess}))
            subplot(2,10,mouse+10*(group-1))
            imagesc(squeeze((Vals{sess}{group}(:,:,mouse)))')
            xlim([5 25])
            ylim([5 45])
            
        end
    end
end

% Average maps
for sess = 1
    figure
    for group = 1 
        subplot(1,3,group)
        imagesc(smooth2a(squeeze(nanmean(Vals{sess}{group},3))',1,1))
        xlim([5 25])
        ylim([5 45])
        caxis([0 0.01])
        title(Drug_Group{group})
        colormap parula
        freezeColors
    end
    
end

%% Distrib time spent near wall
clear AllH MeanDist
X = [0:0.2:10];
figure
for sess = 1
    subplot(2,1,sess)
    for group = 1
        for mouse=[1:8,10:length(SleepSession(2,:,2))]
            [Y,X] = hist(DistNear{sess}{group}{mouse},[0:0.2:10]);
            AllH{sess}{group}(mouse,:) = runmean(Y/sum(Y),3);
            MeanDist{sess}{group}(mouse) = nanmean(DistNear{sess}{group}{mouse}(:));
        end
        errorbar(X,nanmean(AllH{sess}{group}),stdError(AllH{sess}{group}))
        hold on
    end
    makepretty
    legend(Drug_Group,'Location','SouthWest')
    xlabel('Dist to wall')
    ylabel('Prop time')
    title(Session_type{sess})
end


figure
clear h p
LimInOut = 8;
for sess = 1
    subplot(1,2,sess)
    MakeSpreadAndBoxPlot_SB({nanmean(AllH{sess}{1}(:,1:LimInOut)')./nanmean(AllH{sess}{1}(:,LimInOut+1:end)'),nanmean(AllH{sess}{1}(:,1:LimInOut)')./nanmean(AllH{sess}{1}(:,LimInOut+1:end)')},[],[1,2],Drug_Group,1,0)
    ylim([-1 7])
    [p,h] = ranksum(nanmean(AllH{sess}{1}(:,1:LimInOut)')./nanmean(AllH{sess}{1}(:,LimInOut+1:end)'),nanmean(AllH{sess}{1}(:,1:LimInOut)')./nanmean(AllH{sess}{1}(:,LimInOut+1:end)'));
    sigstar({[1,2]},p)
    xtickangle(45)
    ylabel('Prop time near wall')
    title(Session_type{sess})
end



%% Have a look
figure
cd /home/pinky/folder/Downloads
load('BMValThigmoCage.mat')
load('BMValThigmoCage2.mat')
load('SBValThigmoCage.mat')
load('SBValThigmoCage2.mat')


subplot(221)
plot(SBVal,SBVal2,'.')
xlabel('SB1')
ylabel('SB2')
axis square
makepretty

subplot(222)
plot(BMVal,BMVal2,'.')
xlabel('BM1')
ylabel('BM2')
axis square
makepretty

subplot(223)
plot(SBVal,BMVal,'.')
xlabel('SB1')
ylabel('BM1')
axis square
makepretty

subplot(224)
plot(SBVal2,BMVal2,'.')
xlabel('SB2')
ylabel('BM2')
axis square
makepretty
linkaxes
xlim([-0.5 6])
ylim([-0.5 6])
