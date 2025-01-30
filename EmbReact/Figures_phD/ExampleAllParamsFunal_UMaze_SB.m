mm=3
MiceNumber = [507,508,5409];
clear Dir Spikes numNeurons NoiseEpoch FreezeEpoch Vtsd StimEpoch MovEpoch
Dir = GetAllMouseTaskSessions(MiceNumber(mm));
x1 = strfind(Dir,'UMazeCond');
ToKeep = find(~cellfun(@isempty,x1));
Dir = Dir(ToKeep);
MovAcctsd = ConcatenateDataFromFolders_SB(Dir,'accelero');
SpB = ConcatenateDataFromFolders_SB(Dir,'Spectrum','Prefix','B_Low');
SpH = ConcatenateDataFromFolders_SB(Dir,'Spectrum','Prefix','HCorr_Low');
Ripples = ConcatenateDataFromFolders_SB(Dir,'ripples');
EKG = ConcatenateDataFromFolders_SB(Dir,'HeartRate');

ZoneEpoch = ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','zoneepoch');
StimEpoch = ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','stimepoch');
LinPos= ConcatenateDataFromFolders_SB(Dir,'linearposition');
Spikes = ConcatenateDataFromFolders_SB(Dir,'Spikes');
Vtsd = ConcatenateDataFromFolders_SB(Dir,'speed');
FreezeEpoch = ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','freezeepoch');
Postsd= ConcatenateDataFromFolders_SB(Dir,'position');

SpeedLim = 3;
MovEpoch = thresholdIntervals(Vtsd,SpeedLim,'Direction','Above');
cd(Dir{1})
[numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx','remove_MUA',1);
Spikes = Spikes(numNeurons);
TotalEpoch = intervalSet(0,max(Range(LinPos)));

LittleFreeEpochs = intervalSet([0,410,2195]*1e4,[380,445,2400]*1e4);
FreezeEpoch = or(FreezeEpoch,LittleFreeEpochs);
Q = MakeQfromS(Spikes,2*1E4);
Q = tsd(Range(Q),nanzscore(Data(Q)')');
VectShock = nanmean(Data(Restrict(Q,and(FreezeEpoch,or(ZoneEpoch{1},ZoneEpoch{4})))));
VectSafe = nanmean(Data(Restrict(Q,and(FreezeEpoch,or(ZoneEpoch{2},ZoneEpoch{5})))));
W = VectShock - VectSafe;
Proj = tsd(Range(Q),Data(Q)*W');



TotalEpoch = intervalSet(0,max(Range(SpB)));
for z = 1 :5
    TotalEpoch = TotalEpoch-ZoneEpoch{z};
end

for g = 1 : length(Start(TotalEpoch))
    for z = 1 :5
        
        dist = (Start(subset(TotalEpoch,2))-Stop(ZoneEpoch{z}));
        dist(dist<0) = [];
        if not(isempty(dist))
            DistEpo(z) = (min(abs(dist)));
        else
            DistEpo(z) = NaN;
        end
    end
    [val,ind] = min(DistEpo);
    
    ZoneEpoch{ind} = or(ZoneEpoch{ind},subset(TotalEpoch,g));
end



figure
subplot(6,2,[1,3,5])
imagesc(Range(SpB,'s'),fLow,log(Data(SpB))'), axis xy
hold on
colormap jet
ylim([0 15])
ZoneNames = {'shock','safe','center','centershock','centersafe'};
for z = 1 :5
    ZoneEpoch{z} = mergeCloseIntervals(ZoneEpoch{z},10*1e4);
    for k = 1:length(Start(ZoneEpoch{z}))
        line([Start(subset(ZoneEpoch{z},k),'s') Stop(subset(ZoneEpoch{z},k),'s')],[12 12],'color',UMazeColors(ZoneNames{z}),'linewidth',20)
    end
end
box off
set(gca,'FontSize',15,'linewidth',2,'XTick',[])
xlim([0 600])
ylabel('Frequency (Hz)')

subplot(9,2,[1,3]+10)
plot(Range(MovAcctsd,'s'),runmean(Data(MovAcctsd),20),'k','linewidth',2), hold on
xlim([0 600])
set(gca,'FontSize',15,'linewidth',1)
box off
plot(Start(StimEpoch,'s'),Start(StimEpoch,'s')*0+5*1e8,'.y','MarkerSize',30)
plot(Start(StimEpoch,'s'),Start(StimEpoch,'s')*0+5*1e8,'k*')
ylim([0 7*1e8])
ylabel('Movement (AU)')

subplot(6,2,[1,3,5]+1)
imagesc(Range(SpB,'s'),fLow,log(Data(SpB))'), axis xy
hold on
colormap jet
ylim([0 15])
ZoneNames = {'shock','safe','center','centershock','centersafe'};
for z = 1 :5
    ZoneEpoch{z} = mergeCloseIntervals(ZoneEpoch{z},10*1e4);
    for k = 1:length(Start(ZoneEpoch{z}))
        line([Start(subset(ZoneEpoch{z},k),'s') Stop(subset(ZoneEpoch{z},k),'s')],[12 12],'color',UMazeColors(ZoneNames{z}),'linewidth',20)
    end
end
box off
set(gca,'FontSize',15,'linewidth',2,'XTick',[])
xlim([1940 2420])
ylabel('Frequency (Hz)')

subplot(9,2,[1,3]+11)
plot(Range(MovAcctsd,'s'),runmean(Data(MovAcctsd),20),'k','linewidth',2), hold on
xlim([1940 2420])
set(gca,'FontSize',15,'linewidth',1)
box off
plot(Start(StimEpoch,'s'),Start(StimEpoch,'s')*0+5*1e8,'.y','MarkerSize',30)
plot(Start(StimEpoch,'s'),Start(StimEpoch,'s')*0+5*1e8,'k*')
ylim([0 7*1e8])
ylabel('Movement (AU)')


% Hippocampus
figure
subplot(6,2,[1,3,5])
    imagesc(Range(SpH,'s'),fLow,log(Data(SpH))'), axis xy
hold on
colormap jet
ylim([0 20])
ZoneNames = {'shock','safe','center','centershock','centersafe'};
for z = 1 :5
    ZoneEpoch{z} = mergeCloseIntervals(ZoneEpoch{z},10*1e4);
    for k = 1:length(Start(ZoneEpoch{z}))
        line([Start(subset(ZoneEpoch{z},k),'s') Stop(subset(ZoneEpoch{z},k),'s')],[17 17],'color',UMazeColors(ZoneNames{z}),'linewidth',20)
    end
end
box off
set(gca,'FontSize',15,'linewidth',2,'XTick',[])
xlim([0 600])
ylabel('Frequency (Hz)')
clim([3 14])

subplot(9,2,[1,3]+10)
plot(Range(MovAcctsd,'s'),runmean(Data(MovAcctsd),20),'k','linewidth',2), hold on
xlim([0 600])
set(gca,'FontSize',15,'linewidth',1)
box off
plot(Start(StimEpoch,'s'),Start(StimEpoch,'s')*0+5*1e8,'.y','MarkerSize',30)
plot(Start(StimEpoch,'s'),Start(StimEpoch,'s')*0+5*1e8,'k*')
ylim([0 7*1e8])
ylabel('Movement (AU)')

subplot(6,2,[1,3,5]+1)
    imagesc(Range(SpH,'s'),fLow,log(Data(SpH))'), axis xy
hold on
colormap jet
ylim([0 20])
ZoneNames = {'shock','safe','center','centershock','centersafe'};
for z = 1 :5
    ZoneEpoch{z} = mergeCloseIntervals(ZoneEpoch{z},10*1e4);
    for k = 1:length(Start(ZoneEpoch{z}))
        line([Start(subset(ZoneEpoch{z},k),'s') Stop(subset(ZoneEpoch{z},k),'s')],[17 17],'color',UMazeColors(ZoneNames{z}),'linewidth',20)
    end
end
box off
set(gca,'FontSize',15,'linewidth',2,'XTick',[])
xlim([1940 2420])
ylabel('Frequency (Hz)')
clim([3 14])

subplot(9,2,[1,3]+11)
plot(Range(MovAcctsd,'s'),runmean(Data(MovAcctsd),20),'k','linewidth',2), hold on
xlim([1940 2420])
set(gca,'FontSize',15,'linewidth',1)
box off
plot(Start(StimEpoch,'s'),Start(StimEpoch,'s')*0+5*1e8,'.y','MarkerSize',30)
plot(Start(StimEpoch,'s'),Start(StimEpoch,'s')*0+5*1e8,'k*')
ylim([0 7*1e8])
ylabel('Movement (AU)')

%% ripples
figure
subplot(6,2,[1,3,5])
[Y,X] =  hist(Range(Restrict(Ripples,LittleFreeEpochs),'s'),200);
bar(X,Y/median(diff(X)),'FaceColor',[0.4 0.4 0.4])
hold on
colormap jet
ylim([0 1])
hold on
ZoneNames = {'shock','safe','center','centershock','centersafe'};
for z = 1 :5
    ZoneEpoch{z} = mergeCloseIntervals(ZoneEpoch{z},10*1e4);
    for k = 1:length(Start(ZoneEpoch{z}))
        line([Start(subset(ZoneEpoch{z},k),'s') Stop(subset(ZoneEpoch{z},k),'s')],[0.8 0.8],'color',UMazeColors(ZoneNames{z}),'linewidth',20)
    end
end
box off
set(gca,'FontSize',15,'linewidth',2,'XTick',[])
xlim([0 600])
ylabel('Frequency (Hz)')
clim([3 14])

subplot(9,2,[1,3]+10)
plot(Range(MovAcctsd,'s'),runmean(Data(MovAcctsd),20),'k','linewidth',2), hold on
xlim([0 600])
set(gca,'FontSize',15,'linewidth',1)
box off
plot(Start(StimEpoch,'s'),Start(StimEpoch,'s')*0+5*1e8,'.y','MarkerSize',30)
plot(Start(StimEpoch,'s'),Start(StimEpoch,'s')*0+5*1e8,'k*')
ylim([0 7*1e8])
ylabel('Movement (AU)')

subplot(6,2,[1,3,5]+1)
[Y,X] =  hist(Range(Restrict(Ripples,LittleFreeEpochs),'s'),200);
bar(X,Y/median(diff(X)),'FaceColor',[0.4 0.4 0.4])
hold on
colormap jet
ylim([0 1])
hold on
ZoneNames = {'shock','safe','center','centershock','centersafe'};
for z = 1 :5
    ZoneEpoch{z} = mergeCloseIntervals(ZoneEpoch{z},10*1e4);
    for k = 1:length(Start(ZoneEpoch{z}))
        line([Start(subset(ZoneEpoch{z},k),'s') Stop(subset(ZoneEpoch{z},k),'s')],[8 8]/10,'color',UMazeColors(ZoneNames{z}),'linewidth',20)
    end
end
box off
set(gca,'FontSize',15,'linewidth',2,'XTick',[])
xlim([1940 2420])
ylabel('Frequency (Hz)')
clim([3 14])

subplot(9,2,[1,3]+11)
plot(Range(MovAcctsd,'s'),runmean(Data(MovAcctsd),20),'k','linewidth',2), hold on
xlim([1940 2420])
set(gca,'FontSize',15,'linewidth',1)
box off
plot(Start(StimEpoch,'s'),Start(StimEpoch,'s')*0+5*1e8,'.y','MarkerSize',30)
plot(Start(StimEpoch,'s'),Start(StimEpoch,'s')*0+5*1e8,'k*')
ylim([0 7*1e8])
ylabel('Movement (AU)')

%% HB
figure
subplot(6,2,[1,3,5])
Resample = interp1(Range(EKG,'s'),runmean(Data(EKG),10),[0:0.1:max(Range(EKG,'s'))]);
Resample = naninterp(Resample);
EKG = tsd([0:0.1:max(Range(EKG,'s'))]*1e4,Resample');
bar(Range(EKG,'s'),runmean(Data(EKG),10),'FaceColor',[0.6 0.6 0.6])
hold on
colormap jet
ylim([0 20])
hold on
ZoneNames = {'shock','safe','center','centershock','centersafe'};
for z = 1 :5
    ZoneEpoch{z} = mergeCloseIntervals(ZoneEpoch{z},10*1e4);
    for k = 1:length(Start(ZoneEpoch{z}))
        line([Start(subset(ZoneEpoch{z},k),'s') Stop(subset(ZoneEpoch{z},k),'s')],[17 17],'color',UMazeColors(ZoneNames{z}),'linewidth',20)
    end
end
box off
set(gca,'FontSize',15,'linewidth',2,'XTick',[])
xlim([0 600])
ylabel('Frequency (Hz)')
clim([3 14])

subplot(9,2,[1,3]+10)
plot(Range(MovAcctsd,'s'),runmean(Data(MovAcctsd),20),'k','linewidth',2), hold on
xlim([0 600])
set(gca,'FontSize',15,'linewidth',1)
box off
plot(Start(StimEpoch,'s'),Start(StimEpoch,'s')*0+5*1e8,'.y','MarkerSize',30)
plot(Start(StimEpoch,'s'),Start(StimEpoch,'s')*0+5*1e8,'k*')
ylim([0 7*1e8])
ylabel('Movement (AU)')

subplot(6,2,[1,3,5]+1)
bar(Range(EKG,'s'),runmean(Data(EKG),10),'FaceColor',[0.6 0.6 0.6])
hold on
colormap jet
ylim([0 20])
hold on
ZoneNames = {'shock','safe','center','centershock','centersafe'};
for z = 1 :5
    ZoneEpoch{z} = mergeCloseIntervals(ZoneEpoch{z},10*1e4);
    for k = 1:length(Start(ZoneEpoch{z}))
        line([Start(subset(ZoneEpoch{z},k),'s') Stop(subset(ZoneEpoch{z},k),'s')],[17 17],'color',UMazeColors(ZoneNames{z}),'linewidth',20)
    end
end
box off
set(gca,'FontSize',15,'linewidth',2,'XTick',[])
xlim([1940 2420])
ylabel('Frequency (Hz)')
clim([3 14])

subplot(9,2,[1,3]+11)
plot(Range(MovAcctsd,'s'),runmean(Data(MovAcctsd),20),'k','linewidth',2), hold on
xlim([1940 2420])
set(gca,'FontSize',15,'linewidth',1)
box off
plot(Start(StimEpoch,'s'),Start(StimEpoch,'s')*0+5*1e8,'.y','MarkerSize',30)
plot(Start(StimEpoch,'s'),Start(StimEpoch,'s')*0+5*1e8,'k*')
ylim([0 7*1e8])
ylabel('Movement (AU)')


%% HBvar
figure
subplot(6,2,[1,3,5])
bar(Range(EKG,'s'),runmean(movstd(Data(EKG),3),10),'FaceColor',[0.6 0.6 0.6])
hold on
colormap jet
ylim([0 1])
hold on
ZoneNames = {'shock','safe','center','centershock','centersafe'};
for z = 1 :5
    ZoneEpoch{z} = mergeCloseIntervals(ZoneEpoch{z},10*1e4);
    for k = 1:length(Start(ZoneEpoch{z}))
        line([Start(subset(ZoneEpoch{z},k),'s') Stop(subset(ZoneEpoch{z},k),'s')],[0.8 0.8],'color',UMazeColors(ZoneNames{z}),'linewidth',20)
    end
end
box off
set(gca,'FontSize',15,'linewidth',2,'XTick',[])
xlim([0 600])
ylabel('Frequency (Hz)')
clim([3 14])

subplot(9,2,[1,3]+10)
plot(Range(MovAcctsd,'s'),runmean(Data(MovAcctsd),20),'k','linewidth',2), hold on
xlim([0 600])
set(gca,'FontSize',15,'linewidth',1)
box off
plot(Start(StimEpoch,'s'),Start(StimEpoch,'s')*0+5*1e8,'.y','MarkerSize',30)
plot(Start(StimEpoch,'s'),Start(StimEpoch,'s')*0+5*1e8,'k*')
ylim([0 7*1e8])
ylabel('Movement (AU)')

subplot(6,2,[1,3,5]+1)
bar(Range(EKG,'s'),runmean(movstd(Data(EKG),3),10),'FaceColor',[0.6 0.6 0.6])
hold on
ylim([0 1])
hold on
ZoneNames = {'shock','safe','center','centershock','centersafe'};
for z = 1 :5
    ZoneEpoch{z} = mergeCloseIntervals(ZoneEpoch{z},10*1e4);
    for k = 1:length(Start(ZoneEpoch{z}))
        line([Start(subset(ZoneEpoch{z},k),'s') Stop(subset(ZoneEpoch{z},k),'s')],[0.8 0.8],'color',UMazeColors(ZoneNames{z}),'linewidth',20)
    end
end
box off
set(gca,'FontSize',15,'linewidth',2,'XTick',[])
xlim([1940 2420])
ylabel('Frequency (Hz)')
clim([3 14])

subplot(9,2,[1,3]+11)
plot(Range(MovAcctsd,'s'),runmean(Data(MovAcctsd),20),'k','linewidth',2), hold on
xlim([1940 2420])
set(gca,'FontSize',15,'linewidth',1)
box off
plot(Start(StimEpoch,'s'),Start(StimEpoch,'s')*0+5*1e8,'.y','MarkerSize',30)
plot(Start(StimEpoch,'s'),Start(StimEpoch,'s')*0+5*1e8,'k*')
ylim([0 7*1e8])
ylabel('Movement (AU)')


%% POsition
PosData = Data(Postsd);
Xtsd = tsd(Range(Postsd),PosData(:,1));
Ytsd = tsd(Range(Postsd),PosData(:,2));
InterVal1 = intervalSet(00*1e4, 400*1e4);
InterVal2 = intervalSet(1940*1e4, 2420*1e4);

X = [Data(Restrict(Xtsd,InterVal1));Data(Restrict(Xtsd,InterVal2))];
Y = [Data(Restrict(Ytsd,InterVal1));Data(Restrict(Ytsd,InterVal2))];

plot(Data(Restrict(Xtsd,InterVal1)),Data(Restrict(Ytsd,InterVal1)),'k')
hold on
plot(Data(Restrict(Xtsd,InterVal2)),Data(Restrict(Ytsd,InterVal2)),'k')
plot(X(1),Y(1),'.','MarkerSize',50)

