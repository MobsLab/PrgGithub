
%% Pour figures
% /home/vador/Dropbox/Mobs_member/AliceLallemand

Filename={
  %  '/media/DataMOBS65/EmbReact_Eyeshock/Mouse564/20170706/ProjectEmbReact_M564_20170706_Habituation'
   '/media/DataMOBS65/EmbReact_Eyeshock/Mouse564/20170706/ProjectEmbReact_M564_20170706_TestPre/TestPre1'}
 %   '/media/DataMOBS65/EmbReact_Eyeshock/Mouse564/20170706/ProjectEmbReact_M564_20170706_TestPre/TestPre2'
%    '/media/DataMOBS65/EmbReact_Eyeshock/Mouse564/20170706/ProjectEmbReact_M564_20170706_TestPre/TestPre3'
 %   '/media/DataMOBS65/EmbReact_Eyeshock/Mouse564/20170706/ProjectEmbReact_M564_20170706_TestPre/TestPre4'
    
for ff=1:length(Filename)
    cd(Filename{ff})
    load('behavResources.mat')
    Xtsd=tsd(PosMat(:,1)*1e4,PosMat(:,2));
    Ytsd=tsd(PosMat(:,1)*1e4,PosMat(:,3));

    figure
    plot(Data(Ytsd),Data(Xtsd)) % toute la trajectoire
    hold on
    %plot(Data(Restrict(Ytsd,ZoneEpoch{1})),Data(Restrict(Xtsd,ZoneEpoch{1}))) % seulement une zone
    %   plot(Data(Restrict(Ytsd,FreezeEpoch)),Data(Restrict(Xtsd,FreezeEpoch)),'.') % seulement une zone

    
end
clf
histogram(Stop(FreezeEpoch,'s')-Start(FreezeEpoch,'s'),'Normalization','probability')


Epoch1=thresholdIntervals(Xtsd,50,'Direction','Below');
Epoch2=thresholdIntervals(Xtsd,40,'Direction','Above');
Ep=and(Epoch1,Epoch2);
for k=1:length(Start(Ep))
    tempDat=Data(Restrict(Xtsd,subset(Ep,k)));
    if tempDat(1)>45
       WhichWay(k)=1; 
    else
        WhichWay(k)=-1;
    end
end

clf
plot(Range(Xtsd),Data(Xtsd))
hold on
plot(Range(Restrict(Xtsd,subset(Ep,find(WhichWay==1)))),Data(Restrict(Xtsd,subset(Ep,find(WhichWay==1)))),'.')
plot(Range(Restrict(Xtsd,subset(Ep,find(WhichWay==-1)))),Data(Restrict(Xtsd,subset(Ep,find(WhichWay==-1)))),'.')

figure
histogram(Data(Restrict(Movtsd,subset(Ep,find(WhichWay==1)))))
hold on
histogram(Data(Restrict(Movtsd,subset(Ep,find(WhichWay==-1)))))

SafeToShock=find(WhichWay==1);
MeanSpeedSafeToShock=[];
for k=1:length(SafeToShock)
    MeanSpeedSafeToShock(k)=nanmean(Data(Restrict(Movtsd,subset(Ep,SafeToShock(k)))));
end
ShockToSafe=find(WhichWay==-1);
MeanSpeedShockToSafe=[];
for k=1:length(ShockToSafe)
    MeanSpeedShockToSafe(k)=nanmean(Data(Restrict(Movtsd,subset(Ep,ShockToSafe(k)))));
end

clf
histogram(MeanSpeedSafeToShock,20)
hold on
histogram(MeanSpeedShockToSafe,20)
legend('MeanSpeedSafeToShock','MeanSpeedShockToSafe')
legend('MeanSpeedSafeToShock','MeanSpeedShockToSafe')
title('blabla')
xlabel('blabla')
ylabel('blabla')


for k=1:5
    Dur(k)=(sum(Stop(ZoneEpoch{k},'s')-Start(ZoneEpoch{k},'s')))./sum(sum((Zone{k})));
end
% Dur=Dur./sum(Dur);
clf
bar(Dur)
set(gca,'XTick',[1:5],'XTickLabel',{'Shock','NoShock','Centre','CentreShock','CentreNoShock'})



%% Variable Zone
clf
imagesc(Zone{1})
