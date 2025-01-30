
Mice.FlxChr = [829,851];

SessNames={'UMazeCond' };
cols = summer(10);
cols2 = spring(10);
ReloadData = 1;
XLinPos = [0:0.05:1];


% If you've done the umaze alignement (using
% MorphMaze_RunOnAlLData_EmbReact_SB)
% replace zoneepoch with zoneepochaligned

for ss = 1 : length(SessNames)
    
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    for d = 5: length(Dir.path)
        for dd = 1:length(Dir.path{d})
            cd(Dir.path{d}{dd})
            uiopen('BehaviourOverview.fig',1)
            pause
        end
    end
end

cd /media/DataMOBsRAIDN/ProjectEmbReact/Mouse507/20170201/ProjectEmbReact_M507_20170201_UMazeCond/Cond3
load('B_Low_Spectrum.mat')
imagesc(Spectro{2},Spectro{3},log(Spectro{1}')),axis xy, hold on
load('behavResources_SB.mat')
plot(Start(TTLInfo.StimEpoch,'s'),15,'w*')
line([Start(Behav.FreezeAccEpoch,'s') Stop(Behav.FreezeAccEpoch,'s')]',[Start(Behav.FreezeAccEpoch,'s') Stop(Behav.FreezeAccEpoch,'s')]'*0+12,'color','c','linewidth',2)
Zones = {'shock','safe','center','safe','centersafe'};
for z = 1:5
    line([Start(Behav.ZoneEpoch{z},'s') Stop(Behav.ZoneEpoch{z},'s')]',[Start(Behav.ZoneEpoch{z},'s') Stop(Behav.ZoneEpoch{z},'s')]'*0+13,'color',UMazeColors(Zones{z}),'linewidth',5)
end


cd /media/DataMOBsRAID/ProjectEmbReact/Mouse117/20140221/ProjectFearAnxiety_M117_20140221_Cond/Cond4
load('B_Low_Spectrum.mat')
imagesc(Spectro{2},Spectro{3},log(Spectro{1}')),axis xy, hold on
load('behavResources.mat')
StimEpoch = mergeCloseIntervals(StimEpoch,3*1E4)
plot(Start(StimEpoch,'s'),15,'w*')
line([Start(FreezeEpoch,'s') Stop(FreezeEpoch,'s')]',[Start(FreezeEpoch,'s') Stop(FreezeEpoch,'s')]'*0+12,'color','c','linewidth',2)
Zones = {'shock','safe','center','safe','centersafe'};
for z = 1:5
    line([Start(ZoneEpoch{z},'s') Stop(ZoneEpoch{z},'s')]',[Start(ZoneEpoch{z},'s') Stop(ZoneEpoch{z},'s')]'*0+13,'color',UMazeColors(Zones{z}),'linewidth',5)
end
xlim([0 180])

figure
subplot(211)
plot(Range(LFP,'s'),Data(LFP),'color',UMazeColors('shock'))
xlim([100 105]-5)

subplot(212)
plot(Range(LFP,'s'),Data(LFP),'color',UMazeColors('safe'))
xlim([160 165])