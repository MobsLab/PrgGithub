
clear all
close all

%% path
% Sal DZP
load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_for_SB/DZP_Sess.mat', 'SleepSession')
Dir.SalinePost = SleepSession(1,1:11,2);
Dir.DzpPost = SleepSession(2,:,2);
Drug_Group={'SalinePost','DzpPost'};

% All eyelid
GetAllSalineSessions_BM
Mouse = Drugs_Groups_UMaze_BM(22);
Drug_Group={'Saline'};
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    try
        UMazeSleepSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Sleep')))));
        SleepPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(1);
        if length(UMazeSleepSess.(Mouse_names{mouse}))==3
            SleepPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(1);
            SleepPostPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(2);
            SleepPostSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(3);
        else
            try
                SleepPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(1);
                SleepPostSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(2);
            end
        end
        Dir.Saline{mouse}{1} = SleepPostSess.(Mouse_names{mouse}){1};
    end
end


% RipControl/RipInhib
GetAllSalineSessions_BM
Drug_Group={'RipControl','RipInhib'};
Group = [7 8];
for group=1:length(Drug_Group)
    Mouse = Drugs_Groups_UMaze_BM(Group(group));
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        try
            UMazeSleepSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Sleep')))));
            SleepPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(1);
            if length(UMazeSleepSess.(Mouse_names{mouse}))==3
                SleepPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(1);
                SleepPostPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(2);
                SleepPostSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(3);
            else
                try
                    SleepPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(1);
                    SleepPostSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(2);
                end
            end
            Dir.(Drug_Group{group}){mouse}{1} = SleepPostSess.(Mouse_names{mouse}){1};
        end
    end
end


%% basic parameters
SpeedLim = 2; % To define movepoch
RectangleCorners = [0,0;20,0;20,40;0,40];
ExtRectangleCorners = [-2,-2;22,-2;22,42;-2,42];
ExtendedCagePoly = polyshape(ExtRectangleCorners);
LimInOut = 6;
window_time = 30; % in minutes

%% collect data
clear DistNear Y2 AllH Thigmo_score
figure
for group=1:length(Drug_Group)
    disp(Drug_Group{group})
    for mouse=1:length(Dir.(Drug_Group{group}))
        try
            
            % Sleep states
            clear Wake SWSEpoch REMEpoch TotalNoiseEpoch
            try
                load([Dir.(Drug_Group{group}){mouse}{1} 'StateEpochSB.mat'],'Wake','SWSEpoch','REMEpoch','TotalNoiseEpoch')
                Wake;
            catch
                load([Dir.(Drug_Group{group}){mouse}{1} 'SleepScoring_Accelero.mat'],'Wake','SWSEpoch','REMEpoch','TotalNoiseEpoch')
            end
            Wake = or(Wake,TotalNoiseEpoch);
            REMEpoch = REMEpoch - TotalNoiseEpoch;
            SWSEpoch = SWSEpoch - TotalNoiseEpoch;
            Tot = or(Wake,or(SWSEpoch,REMEpoch));
            
            load([Dir.(Drug_Group{group}){mouse}{1} 'behavResources.mat'],'Vtsd')
            MovEpoch = thresholdIntervals(Vtsd,SpeedLim,'Direction','Above');
            MovEpoch = dropShortIntervals(MovEpoch,0.1*1e4);
            MovEpoch = mergeCloseIntervals(MovEpoch,3*1e4);
            
            try
                load([Dir.(Drug_Group{group}){mouse}{1} 'AlignedCagePos_BM_Video.mat'], 'AlignedYtsd','AlignedXtsd')
            catch
                load([Dir.(Drug_Group{group}){mouse}{1} 'AlignedCagePos.mat'], 'AlignedYtsd','AlignedXtsd')
            end
            
            % Distance to wall during mouvement
            X = Data(Restrict(AlignedYtsd,and(intervalSet(0,window_time*60e4),Wake)));
            Y = Data(Restrict(AlignedXtsd,and(intervalSet(0,window_time*60e4),Wake)));
            V = Data(Restrict(Vtsd,and(intervalSet(0,window_time*60e4),Wake)));
            DistTraveled{group}(mouse) = sum(V);
            DistTraveled2{group}(mouse) = log10(sum(Data(Restrict(Vtsd , intervalSet(0,window_time*60e4)))));
            DistTraveled2{group}(mouse) = nanmean(Data(Restrict(Vtsd , intervalSet(0,window_time*60e4))));
            DistTraveled_TimeNorm{group}(mouse) = sum(V)./(sum(DurationEpoch(and(intervalSet(0,window_time*60e4),Wake)))/3600e4);
            AlignedPosition = tsd(Range(Restrict(AlignedYtsd,and(intervalSet(0,window_time*60e4),Wake))) , [X Y]);
            [Thigmo_score6{group}(mouse), OccupMap] = Thigmo_From_Position_HomeCage_BM(AlignedPosition);
            % Get rid of times when mouse is on top of the cage
            TFin = isinterior(ExtendedCagePoly,X,Y);
            hold on
            X = X(TFin);
            Y = Y(TFin);
            
            X_all{group}{mouse} = X;
            Y_all{group}{mouse} = Y;
            
            for ii = 1:length(X)
                DistNear{group}{mouse}(ii) = DistancePointNearestSideRectangle([X(ii),Y(ii)],RectangleCorners);
            end
            DistToWall{group}{mouse} = DistancePointNearestSideRectangle_BM(X,Y);
            
            % Distance to wall during sleep
            try
                X = Data(Restrict(AlignedYtsd,SWSEpoch));
                Y = Data(Restrict(AlignedXtsd,SWSEpoch));
                clear posnest
                for ii = 1:length(X)
                    posnest(ii) = DistancePointNearestSideRectangle([X(ii),Y(ii)],RectangleCorners);
                end
                DistNear_Sleep{group}(mouse) = nanmean(posnest);
                NestPosition{group}{mouse} = [nanmean(X),nanmean(Y)];
                
            end
        end
        disp(mouse)
    end
    DistTraveled{group}(DistTraveled{group}==0) = NaN;
end
close

for group = 1:length(Drug_Group)
    for mouse = 1:length(DistNear{group})
        [Y2,~] = hist(DistNear{group}{mouse},[0:0.2:10]);
        AllH{group}(mouse,:) = runmean(Y2/sum(Y2),3);
        Thigmo_score2{group}(mouse) = nanmean(DistNear{group}{mouse});
        Thigmo_score3{group}(mouse) = nanmean(DistToWall{group}{mouse});
        Thigmo_score4{group}(mouse) = nansum(DistToWall{group}{mouse}<5)/nansum(~isnan(DistToWall{group}{mouse}));
        Thigmo_score5{group}(mouse) = nansum(DistToWall{group}{mouse}>4);
    end
    Thigmo_score{group} = nansum(AllH{group}(:,1:LimInOut)')./nansum(AllH{group}');
    Thigmo_score4{group}(Thigmo_score4{group}==0)=1e-2;
    A{group} = nanmedian((AllH{group}.*[0:0.2:10])');
end

Thigmo_score{1}(5)=NaN; % outlier, bad tracking for all eyelid


%% figures
figure
X = [0:0.2:10];
for group = 1:length(Drug_Group)
    errorbar(X,nanmean(AllH{group}),stdError(AllH{group}))
    hold on
end
makepretty
xlabel('Wall distance'), legend(Drug_Group)


figure
subplot(161)
MakeSpreadAndBoxPlot3_SB(Thigmo_score,{[.3, .745, .93],[.85, .325, .098]},[1,2],Drug_Group,'showpoints',1,'paired',0)
ylabel('prop close wall, SB')

subplot(162)
MakeSpreadAndBoxPlot3_SB(Thigmo_score2,{[.3, .745, .93],[.85, .325, .098]},[1,2],Drug_Group,'showpoints',1,'paired',0)
ylabel('Mean wall dist, SB')

subplot(163)
MakeSpreadAndBoxPlot3_SB(Thigmo_score3,{[.3, .745, .93],[.85, .325, .098]},[1,2],Drug_Group,'showpoints',1,'paired',0)
ylabel('Mean wall dist, BM')

subplot(164)
MakeSpreadAndBoxPlot3_SB(Thigmo_score4,{[.3, .745, .93],[.85, .325, .098]},[1,2],Drug_Group,'showpoints',1,'paired',0)
ylabel('prop close wall, BM')

subplot(165)
MakeSpreadAndBoxPlot3_SB(Thigmo_score5,{[.3, .745, .93],[.85, .325, .098]},[1,2],Drug_Group,'showpoints',1,'paired',0)
ylabel('prop far wall, BM')

subplot(166)
MakeSpreadAndBoxPlot3_SB(Thigmo_score6,{[.3, .745, .93],[.85, .325, .098]},[1,2],Drug_Group,'showpoints',1,'paired',0)
ylabel('prop close wall, BM')


figure
subplot(131)
MakeSpreadAndBoxPlot3_SB(DistTraveled,{[.3, .745, .93],[.85, .325, .098]},[1,2],Drug_Group,'showpoints',1,'paired',0)
ylabel('prop close wall, BM')

subplot(132)
MakeSpreadAndBoxPlot3_SB(DistTraveled2,{[.3, .745, .93],[.85, .325, .098]},[1,2],Drug_Group,'showpoints',1,'paired',0)
ylabel('prop close wall, BM')

subplot(133)
MakeSpreadAndBoxPlot3_SB(DistTraveled_TimeNorm,{[.3, .745, .93],[.85, .325, .098]},[1,2],Drug_Group,'showpoints',1,'paired',0)
ylabel('prop close wall, BM')


figure
MakeSpreadAndBoxPlot3_SB({log10(Thigmo_score{1}) log10(Thigmo_score{2})},{[.3, .745, .93],[.85, .325, .098]},[1,2],Drug_Group,'showpoints',1,'paired',0)

figure
MakeSpreadAndBoxPlot3_SB({nansum(AllH{1}(:,1:LimInOut)')./nansum(AllH{1}') , nansum(AllH{2}(:,1:LimInOut)')./nansum(AllH{2}')},...
    {[.3, .745, .93],[.85, .325, .098]},[1,2],Drug_Group,'showpoints',1,'paired',0)
ylabel('Prop time near wall')


figure
subplot(121)
MakeSpreadAndBoxPlot3_SB(DistTraveled([1 3]),...
    {[.3, .745, .93],[.85, .325, .098]},[1,2],Drug_Group([1 3]),'showpoints',1,'paired',0)

subplot(122)
MakeSpreadAndBoxPlot3_SB(DistTraveled([2 4]),...
    {[.3, .745, .93],[.85, .325, .098]},[1,2],Drug_Group([2 4]),'showpoints',1,'paired',0)


figure
subplot(121)
MakeSpreadAndBoxPlot3_SB(DistTraveled_TimeNorm([1 3]),...
    {[.3, .745, .93],[.85, .325, .098]},[1,2],Drug_Group([1 3]),'showpoints',1,'paired',0)

subplot(122)
MakeSpreadAndBoxPlot3_SB(DistTraveled_TimeNorm([2 4]),...
    {[.3, .745, .93],[.85, .325, .098]},[1,2],Drug_Group([2 4]),'showpoints',1,'paired',0)



%% Position of nests
figure
Cols = {'k','r','k','r'};
Marker = '.';
for group = 1:length(Drug_Group)
    subplot(2,2,group)
    for mouse=1:length(NestPosition{group})
        try
            x(sess) = NestPosition{group}{mouse}(1);
            y(sess) = NestPosition{group}{mouse}(2);
            plot(NestPosition{group}{mouse}(1),NestPosition{group}{mouse}(2),Marker,'MarkerSize',30,'color',Cols{group})
            hold on
        end
    end
    title(Drug_Group{group})
    xlim([0 20]), ylim([0 40])
end



%% tools
figure
group=1;
for mouse=1:11
    subplot(2,12,mouse)
    plot(X_all{group}{mouse} , Y_all{group}{mouse}), xlim([0 20]), ylim([0 40])
    title(num2str(A{1}(mouse)))
end
group=2;
for mouse=1:12
    subplot(2,12,mouse+12)
    plot(X_all{group}{mouse} , Y_all{group}{mouse}), xlim([0 20]), ylim([0 40])
    title(num2str(A{2}(mouse)))
end





for group=2
    for mouse=[1 4 6 7 8]
        
        load([Dir.(Drug_Group{group}){mouse}{1} 'AlignedCagePos_BM_Video.mat'])
        A = AlignedXtsd;
        AlignedXtsd = tsd(Range(AlignedXtsd) , Data(AlignedYtsd)*2);
        AlignedYtsd = tsd(Range(A) , Data(A)/2);
        save([Dir.(Drug_Group{group}){mouse}{1} 'AlignedCagePos_BM_Video.mat'],'AlignedXtsd','AlignedYtsd')
        
    end
end




