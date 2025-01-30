[Group,Mice] = GetMiceDrugGroupsUMaze;
Mice = [666,667,668,669, 739,777,849,567, 569];

for mm = 1:length(Mice)
    FileNames=GetAllMouseTaskSessions(Mice(mm));
    GoodSess = find(not(cellfun(@isempty,strfind(FileNames,'Cond'))));
    FileNames = FileNames(GoodSess);
    
    EKG = ConcatenateDataFromFolders_SB(FileNames,'HeartRate');
    Fz = ConcatenateDataFromFolders_SB(FileNames,'Epoch','epochname','freezeepoch');
    Stim = ConcatenateDataFromFolders_SB(FileNames,'Epoch','epochname','stimepoch');
    StimNum(mm) = length(Start(Stim));
    
    EKGInt = tsd([0:0.05:max(Range(EKG,'s'))]*1E4,interp1(Range(EKG),Data(EKG),[0:0.05:max(Range(EKG,'s'))]*1E4)');
    
    [M,T] = PlotRipRaw(EKGInt,Start(Stim,'s'),20000,0,0);
    T(T==0)=NaN;
    AllResp{mm} = T;
    BefStim = intervalSet(Start(Stim)-5*1E4,Start(Stim));
    AftStim = intervalSet(Start(Stim),Start(Stim)+5*1E4);
    for k = 1:length(Start(Stim))
         [~,FzTimeBef{mm}(k)] = DurationEpoch(and(Fz,subset(BefStim,k)));
         [~,FzTimeAft{mm}(k)] = DurationEpoch(and(Fz,subset(AftStim,k)));
    end
    
    FzAllMice(mm,:) = nanmean(T(FzTimeBef{mm}>2E4,:),1);
    NoFzAllMice(mm,:) = nanmean(T(FzTimeBef{mm}<=2E4,:),1);
    
    
end

figure
subplot(121)
plot(M(:,1),NoFzAllMice','color',[0.9 0.7 0.7])
hold on
plot(M(:,1),nanmean(NoFzAllMice),'color','r')
makepretty
ylim([11 14])
xlim([-5 15])
line([0 0],ylim,'color','k')
title('Stim during activity')

subplot(122)
plot(M(:,1),FzAllMice','color',[0.7 0.7 0.9])
hold on
plot(M(:,1),nanmean(FzAllMice),'color','b')
makepretty
ylim([11 14])
xlim([-5 15])
line([0 0],ylim,'color','k')
title('Stim during freezing')


figure
g=shadedErrorBar(M(:,1),nanmean(NoFzAllMice),stdError(NoFzAllMice));
g.patch.FaceColor = [0.9 0.7 0.7];
g.edge(1).Color = [0.9 0.7 0.7];
g.edge(2).Color = [0.9 0.7 0.7];

g.mainLine.Color = 'r';
g.patch.FaceAlpha = 0.5;

hold on
g=shadedErrorBar(M(:,1),nanmean(FzAllMice),stdError(FzAllMice));
g.patch.FaceColor = [0.7 0.7 0.9];
g.edge(1).Color = [0.7 0.7 0.9];
g.edge(2).Color = [0.7 0.7 0.9];
g.patch.FaceAlpha = 0.5;
g.mainLine.Color = 'b';
xlim([-5 15])
ylim([11 14])
line([0 0],ylim,'color','k')
xlabel('Time to stim (s)')
ylabel('HR (Hz)')
makepretty

