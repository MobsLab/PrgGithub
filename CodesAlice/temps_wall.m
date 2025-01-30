clear all
SessionNames={'WallRetestShockMAPEyeshock','WallRetestSafeMAPEyeshock','WallHabShockMAPEyeshock','WallHabSafeMAPEyeshock','WallCondShockMAPEyeshock','WallCondSafeMAPEyeshock'};

for ss=1:length(SessionNames)
    
    SessionNames{ss}
    Dir=PathForExperimentsEmbReact(SessionNames{ss})
    
    for mouse=1:length(Dir.path)
        for session=1:length(Dir.path{mouse})
            cd(Dir.path{mouse}{session})
            load('behavResources.mat')
            
            for k=1:2
                 Dur{ss,mouse}(k)=(sum(Stop(and(ZoneEpoch{k},FreezeEpoch),'s')-Start(and(ZoneEpoch{k},FreezeEpoch),'s')));
                 (sum(Stop(and(ZoneEpoch{k},FreezeEpoch),'s')-Start(and(ZoneEpoch{k},FreezeEpoch),'s')))
                 keyboard
            end
        end
        Tot1(ss,mouse,:)=Dur{ss,mouse};
    end
  
    
end   

Tot1(2,:,1)=Tot1(2,:,2);
Tot1(4,:,1)=Tot1(4,:,2);
Tot1(6,:,1)=Tot1(6,:,2);
Tot2(:,:)=Tot1(:,:,1);

figure, errorbar(mean(Tot2,2),stdError(Tot2'),'.')
hold on, bar(mean(Tot2,2))
plot(Tot2,'linewidth',3)
set(gca,'XTick',[1:6],'XTickLabel',{'WallRetestShock','WallRetestSafe','WallHabShock','WallHabSafe','WallCondShock','WallCondSafe'})
title('Freezing Wall')