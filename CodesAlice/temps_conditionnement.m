Filename564={
    '/media/DataMOBS65/EmbReact_Eyeshock/Mouse564/20170706/ProjectEmbReact_M564_20170706_UMazeCond/Cond1'
    '/media/DataMOBS65/EmbReact_Eyeshock/Mouse564/20170706/ProjectEmbReact_M564_20170706_UMazeCond/Cond2'
    '/media/DataMOBS65/EmbReact_Eyeshock/Mouse564/20170706/ProjectEmbReact_M564_20170706_UMazeCond/Cond3'
    '/media/DataMOBS65/EmbReact_Eyeshock/Mouse564/20170706/ProjectEmbReact_M564_20170706_UMazeCond/Cond4'
    '/media/DataMOBS65/EmbReact_Eyeshock/Mouse564/20170706/ProjectEmbReact_M564_20170706_UMazeCond/Cond5'
    }

Filename565={
    '/media/DataMOBS65/EmbReact_Eyeshock/Mouse565/20170726/ProjectEmbReact_M565_20170726_UMazeCond/Cond1'
    '/media/DataMOBS65/EmbReact_Eyeshock/Mouse565/20170726/ProjectEmbReact_M565_20170726_UMazeCond/Cond2'
    '/media/DataMOBS65/EmbReact_Eyeshock/Mouse565/20170726/ProjectEmbReact_M565_20170726_UMazeCond/Cond3'
    '/media/DataMOBS65/EmbReact_Eyeshock/Mouse565/20170726/ProjectEmbReact_M565_20170726_UMazeCond/Cond4'
    '/media/DataMOBS65/EmbReact_Eyeshock/Mouse565/20170726/ProjectEmbReact_M565_20170726_UMazeCond/Cond5'
    
    }

Filename560={
    '/media/DataMOBS65/EmbReact_Eyeshock/Mouse560/20170706/ProjectEmbReact_M560_20170706_UMazeCond/Cond1'
    '/media/DataMOBS65/EmbReact_Eyeshock/Mouse560/20170706/ProjectEmbReact_M560_20170706_UMazeCond/Cond2'
    '/media/DataMOBS65/EmbReact_Eyeshock/Mouse560/20170706/ProjectEmbReact_M560_20170706_UMazeCond/Cond3'
    '/media/DataMOBS65/EmbReact_Eyeshock/Mouse560/20170706/ProjectEmbReact_M560_20170706_UMazeCond/Cond4'
    '/media/DataMOBS65/EmbReact_Eyeshock/Mouse560/20170706/ProjectEmbReact_M560_20170706_UMazeCond/Cond5'
    }

listefichiers={Filename564,Filename565,Filename560};
i=0;
MouseNumber=[564,565,560];
for souris=1:length(listefichiers)
    fig=figure;
    for ff=1:length(listefichiers{souris})
        cd(listefichiers{souris}{ff})
        load('behavResources.mat')
        
        Xtsd=tsd(PosMat(:,1)*1e4,PosMat(:,2));
        Ytsd=tsd(PosMat(:,1)*1e4,PosMat(:,3));
        
        
        cols=lines(5);
        for k=1:5
            plot(Data(Restrict(Xtsd,ZoneEpoch{k})),Data(Restrict(Ytsd,ZoneEpoch{k})),'color',cols(k,:)), hold on
        end
        
        hold on
        
        for k=1:5
            Dur{souris,ff}(k)=(sum(Stop(ZoneEpoch{k},'s')-Start(ZoneEpoch{k},'s')));%./sum(sum((Zone{k})));
        end
        
        for k=1:5
            DurFz{souris,ff}(k)=(sum(Stop(and(ZoneEpoch{k},FreezeEpoch),'s')-Start(and(ZoneEpoch{k},FreezeEpoch),'s')));%./sum(sum((Zone{k})));
        end
    end
    title(['Conditionnemnent : Mouse ',num2str(MouseNumber(souris))])
    saveas(fig.Number,['/home/vador/Dropbox/Mobs_member/AliceLallemand/Figures-Behaviour/TrajectoriesConditionnementM',num2str(MouseNumber(souris)),'.png'])
    
end


for souris=1:length(listefichiers)
    for ff=1:length(listefichiers{souris})
        if souris==1
            souris564(ff,:)=Dur{souris,ff}./sum(Dur{souris,ff});
        elseif souris==2
            souris565(ff,:)=Dur{souris,ff}./sum(Dur{souris,ff});
        elseif souris==3
            souris560(ff,:)=Dur{souris,ff}./sum(Dur{souris,ff});
        end
    end
end

figure, errorbar(mean(souris564),stdError(souris564),'.')
hold on, bar(mean(souris564))
set(gca,'XTick',[1:5],'XTickLabel',{'Shock','NoShock','Centre','CentreShock','CentreNoShock'})
title('souris 564')

figure, errorbar(mean(souris565),stdError(souris565),'.')
hold on, bar(mean(souris565))
set(gca,'XTick',[1:5],'XTickLabel',{'Shock','NoShock','Centre','CentreShock','CentreNoShock'})
title('souris 565')

figure, errorbar(mean(souris560),stdError(souris560),'.')
hold on, bar(mean(souris560))
set(gca,'XTick',[1:5],'XTickLabel',{'Shock','NoShock','Centre','CentreShock','CentreNoShock'})
title('souris 560')



tot=vertcat(mean(souris564),mean(souris565),mean(souris560));
fig=figure, errorbar(mean(tot),stdError(tot),'.')
hold on, bar(mean(tot))
plot(tot','.-','linewidth',3)
set(gca,'XTick',[1:5],'XTickLabel',{'Shock','NoShock','Centre','CentreShock','CentreNoShock'})
title('Moyenne Conditionnement')
saveas(fig.Number,['/home/vador/Dropbox/Mobs_member/AliceLallemand/Figures-Behaviour/AverageOccupationConditionnement.png'])

%% Freezing

for souris=1:length(listefichiers)
    for ff=1:length(listefichiers{souris})
        if souris==1
            souris564FZ(ff,:)=DurFz{souris,ff};
        elseif souris==2
            souris565FZ(ff,:)=DurFz{souris,ff};
        elseif souris==3
            souris560FZ(ff,:)=DurFz{souris,ff};
        end
    end
end
tot=vertcat(mean(souris564FZ),mean(souris565FZ),mean(souris560FZ));
fig=figure, errorbar(mean(tot),stdError(tot),'.')
hold on, bar(mean(tot))
plot(tot','.-','linewidth',3)
set(gca,'XTick',[1:5],'XTickLabel',{'Shock','NoShock','Centre','CentreShock','CentreNoShock'})
title('Moyenne Conditionnement Fz')
saveas(fig.Number,['/home/vador/Dropbox/Mobs_member/AliceLallemand/Figures-Behaviour/AverageOccupationFzConditionnement.png'])
